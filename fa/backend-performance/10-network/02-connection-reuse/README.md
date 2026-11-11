<div dir="rtl" align="right">

# ۱۰.۲ — بازاستفاده اتصال با توجه به نسخه HTTP

**زبان:** فارسی · [نسخهٔ انگلیسی](../../../../en/backend-performance/10-network/02-connection-reuse/README.md)  

**هدف یادگیری:** هزینه ایجاد اتصال را از هر درخواست جدا کنید، Client/Pool محدود و طول‌عمر مناسب طراحی کنید و persistence در HTTP/1.1 را با multiplexing اشتباه نگیرید. پیش‌نیاز: TCP، TLS و HTTP. بررسی منابع: **۲۰۲۶-۱۱-۱۱**؛ شبه‌کد و محاسبه آموزشی‌اند.

## مدل ذهنی و تفاوت نسخه‌ها

Reuse یعنی چند درخواست از اتصال قابل‌استفاده موجود عبور کنند. DNS، اتصال و TLS ممکن است در اتصال سرد هزینه داشته باشند؛ تعداد دقیق RTT به پروتکل، resumption و شبکه بستگی دارد. TCP keepalive، Header با نام Keep-Alive و HTTP persistent connection مفاهیم یکسانی نیستند.

| نسخه | بازاستفاده | محدودیت مهم |
| --- | --- | --- |
| HTTP/1.1 | persistence رفتار پیش‌فرض است، مگر پایان اتصال اعلام/ایجاد شود | بدون pipelining، روی هر اتصال یک exchange فعال داریم؛ Pool می‌تواند چند اتصال داشته باشد |
| HTTP/2 | چند Stream هم‌زمان روی یک اتصال TCP | محدودیت Stream/flow control و اثر loss در TCP باقی است |
| HTTP/3 | Streamهای چندگانه روی اتصال QUIC | ظرفیت، congestion، محدودیت Stream و پشتیبانی مسیر همچنان مهم‌اند |

[RFC 9112 بخش 9.3](https://www.rfc-editor.org/rfc/rfc9112.html#section-9.3) persistence را برای HTTP/1.1 تعریف می‌کند؛ برای فعال‌سازی معمول آن افزودن `Connection: keep-alive` لازم نیست. در **HTTP/2 و HTTP/3 فیلدهای connection-specific مانند `Connection`، `Keep-Alive`، `Proxy-Connection`، `Transfer-Encoding` و `Upgrade` ممنوع‌اند**؛ تنظیم reuse در transport/Client انجام می‌شود. تنها استثنا در هر دو پروتکل، فیلد `TE` در درخواست با مقدار صرفاً `trailers` است (`TE: trailers`)؛ این استثنا در پاسخ یا با مقدار دیگری مجاز نیست. [RFC 9113 بخش 8.2.2](https://www.rfc-editor.org/rfc/rfc9113.html#section-8.2.2) و [RFC 9114 بخش 4.2](https://www.rfc-editor.org/rfc/rfc9114.html#section-4.2) این قاعده و استثنا را مشخص می‌کنند. نسخه سمت کاربر و سمت Origin پشت Proxy ممکن است متفاوت باشد؛ هر hop را جدا بررسی کنید.

### چرخهٔ اتصال سرد و گرم

در اتصال سرد، client باید مقصد را resolve کند، transport را برقرار کند و در صورت نیاز TLS و مذاکرهٔ نسخه را انجام دهد؛ سپس request و response جابه‌جا می‌شوند. جزئیات تعداد رفت‌وبرگشت‌ها به نسخهٔ پروتکل، resumption و شبکه وابسته است، پس یک عدد ثابت برای همهٔ اتصال‌ها وجود ندارد. در اتصال گرم، مرحلهٔ setup دوباره انجام نمی‌شود و exchange جدید از transport موجود استفاده می‌کند. Reuse هزینهٔ setup را بین چند درخواست پخش می‌کند؛ نه اندازهٔ response، نه query برنامه و نه زمان اجرای API را خودبه‌خود حذف نمی‌کند.

HTTP/1.1 معمولاً برای هر exchange فعال در هر اتصال به اتصال جداگانه نیاز دارد، بنابراین client از pool چند اتصال می‌سازد؛ HTTP/2/3 می‌توانند چند stream را روی اتصال حمل کنند، ولی تعداد stream، flow control، ظرفیت server و محدودیت شبکه پابرجاست. «یک اتصال» پس به معنی «ظرفیت نامحدود» نیست.

## روش و مثال حل‌شده

Client و transport را طبق مستند کتابخانه بازاستفاده کنید؛ wrapper تازه الزاماً transport تازه نیست، اما ساخت Pool مستقل برای هر درخواست می‌تواند reuse را از بین ببرد. پاسخ را کامل مصرف و منبع آن را آزاد کنید؛ در HTTP/1.1 بدنه ناتمام می‌تواند reuse را ناممکن کند. هنگام لغو، طبق API امن کتابخانه پاسخ/Stream را ببندید؛ بدنه نامحدود را صرفاً برای reuse تخلیه نکنید.

برای فهم اندازهٔ Pool، یک تقریب ابتدایی از قانون Little کمک می‌کند: اگر نرخ پایدار ورود `λ` درخواست بر ثانیه و زمان اشغال اتصال `W` ثانیه باشد، میانگین درخواست‌های هم‌زمان `L≈λ×W` است. مثلاً `120 request/s × 0.05 s = 6` exchange فعال به‌طور میانگین می‌دهد. این **عدد نهایی Pool نیست**: burst، p95/p99، زمان انتظار acquire، تعداد replica و ظرفیت پایین‌دست مهم‌اند. Pool بسیار بزرگ می‌تواند هم‌زمانی DB یا Origin را بالا ببرد و مشکل را تشدید کند؛ عدد نهایی را با اندازه‌گیری و سقف ظرفیت مقصد انتخاب کنید.

</div>

```text
# Create once per configured destination and policy, not per incoming request:
client = shared_client(bounded_pool, bounded_pending_queue, idle_policy)

on_request(deadline):
    response = client.send(request, deadline, cancellation)
    try:
        return read_bounded_response(response)
    finally:
        response.close_according_to_client_contract()
```

<div dir="rtl" align="right">

مدل **فرضی** ده درخواست سریال دارد: آماده‌سازی اتصال سرد ۶۰ ms و هر exchange روی اتصال آماده ۲۵ ms است. بدون reuse: `10*(60+25)=850 ms`؛ با یک اتصال پایدار: `60+10*25=310 ms`. صرفه‌جویی مدل ۵۴۰ ms است؛ این عدد تعداد RTT یا سود ثابت TLS/HTTP/2 نیست. Multiplexing درخواست‌های مستقل می‌تواند هم‌پوشانی اضافه ایجاد کند، ولی ظرفیت سرور و صف باید دوباره مدل شوند. Reuse تعداد query یا بایت پاسخ را خودکار کم نمی‌کند.

## کاربرد، هزینه و تمرین

برای callهای مکرر به مقصد ثابت مفید است. اتصال idle نیز FD، حافظه و state مصرف می‌کند. سقف اتصال، صف acquire، deadline و برای HTTP/2/3 تعداد Stream را محدود کنید. idle timeout ناسازگار با Load balancer می‌تواند reset ایجاد کند. اتصال بسیار طولانی ممکن است تغییر DNS یا جابه‌جایی مقصد را دیر منعکس کند؛ سیاست refresh/lifetime به Client وابسته است. قطع اتصال لزوماً نشان نمی‌دهد write انجام نشده؛ Retry باید [ایمن و محدود](../../06-code-optimization/07-timeouts-and-retries/README.md) باشد.

**تمرین:** در مدل بالا آماده‌سازی را ۱۲۰ ms کنید؛ پاسخ قبل/بعد و تعداد اتصال تازه را حساب کنید. سپس بعد از درخواست پنجم، بسته‌شدن اتصال توسط Peer را فرض کنید. **انتظار:** بدون reuse برابر ۱۴۵۰ ms، با یک اتصال ۳۷۰ ms و با یک بازاتصال اضافی ۴۹۰ ms است؛ فرض کرده‌ایم شکست درخواست/Retry هزینه دیگری ندارد. در ابزار دلخواه، connection count، acquire wait، TLS و p99 را جدا ببینید؛ آزمایش واقعی در این درس انجام نشده است.

## شاهد عملیاتی و حد آن

[راهنمای رسمی MDN](https://developer.mozilla.org/en-US/docs/Web/HTTP/Guides/Connection_management_in_HTTP_1.x) مدل اتصال کوتاه/پایدار و تفاوت multiplexing را مستند می‌کند. این سند عملیاتی شاهد سازوکار است، نه گزارش benchmark یک شرکت. مطالعه تولیدی مستقلی با همین مدل ده‌درخواستی در منابع این درس ارائه نشده؛ اعداد فرضی‌اند. سازگاری Headerها را از RFCها و [مرجع Keep-Alive](https://developer.mozilla.org/en-US/docs/Web/HTTP/Reference/Headers/Keep-Alive) بخوانید.

## مسیر عیب‌یابی با داده

یک trace از درخواست سرد و یک trace از درخواست‌های گرم هم‌مقصد بگیرید و این ترتیب را دنبال کنید:

| نشانه | احتمال | گام بعدی |
| --- | --- | --- |
| اتصال تازه تقریباً برای هر درخواست ساخته می‌شود | Client/transport per-request ساخته می‌شود یا پاسخ reuse را متوقف می‌کند | lifecycle client و بسته‌شدن/مصرف بدنه را بررسی کنید |
| `connect/TLS` کم است اما latency همچنان بالاست | هزینه در server، DB، payload یا شبکهٔ بعد از اتصال است | trace را تا مرز API و وابستگی‌ها دنبال کنید؛ reuse درمان آن نیست |
| acquire wait و صف Pool بالا می‌رود | pool کوچک، destination کند یا ورود بیش‌ازحد است | نرخ، زمان اشغال و سقف downstream را کنار هم ببینید |
| reset بعد از idle افزایش دارد | idle timeout طرفین ناسازگار یا stale connection استفاده شده | سیاست idle/lifetime و retry امن کتابخانه را بررسی کنید |
| HTTP/2 یک connection دارد و latency بالا می‌رود | stream یا server ظرفیت محدود شده، یا TCP/مسیر گلوگاه است | stream فعال، flow control، server queue و loss را بررسی کنید |

زمان‌های اندازه‌گیری‌شده به hop مشخص تعلق دارند. اگر client به CDN متصل است ولی CDN با Origin اتصال دیگری می‌سازد، reuse client-side رفتار Origin-side را ثابت نمی‌کند.

## شکست‌ها و چک‌لیست

افزایش اتصال جدید و TLS در هر call، نشتی response، Pool اشباع، reset پس از idle و تعداد زیاد reconnect هنگام failover علائم قابل بررسی‌اند. بزرگ کردن Pool بدون دیدن ظرفیت مقصد می‌تواند overload را تشدید کند.

- [ ] نسخه HTTP و reuse در هر hop مشاهده شده است.
- [ ] Client/transport چرخه عمر روشن و Pool/صف محدود دارد.
- [ ] پاسخ در موفقیت، خطا و لغو طبق قرارداد آزاد می‌شود.
- [ ] idle/lifetime، DNS و shutdown هماهنگ‌اند؛ reconnect هجوم نمی‌سازد.
- [ ] connection count، reuse، acquire wait، خطا و Streamهای فعال پایش می‌شوند.
- [ ] در HTTP/2/3 فیلدهای connection-specific ممنوع‌اند؛ تنها استثنا `TE: trailers` در درخواست است، نه پاسخ یا مقدار دیگر TE.

## خودآزمایی

۱. آیا HTTP/1.1 برای persistence معمول نیاز به Header Keep-Alive دارد؟

۲. تفاوت reuse با multiplexing چیست؟

۳. چرا افزودن Connection به پاسخ HTTP/2 اشتباه است؟

۴. چرا پاسخ خوانده‌نشده می‌تواند Pool را مختل کند؟

۵. آیا reuse مشکل N+1 را خودکار حل می‌کند؟

۶. اگر اتصال بعد از write قطع شد، آیا Retry بی‌قید امن است؟

### پاسخ با دلیل

۱. خیر؛ persistence پیش‌فرض است. سیاست Peer و بسته‌شدن اتصال همچنان تعیین‌کننده‌اند.

۲. reuse چند درخواست را از اتصال موجود عبور می‌دهد؛ multiplexing exchangeهای چند Stream را هم‌زمان روی آن حمل می‌کند.

۳. فیلد connection-specific در آن پروتکل ممنوع است؛ اتصال با سازوکار پروتکل مدیریت می‌شود.

۴. منابع/اتصال ممکن است اشغال بمانند؛ در HTTP/1.1 مرز و مصرف بدنه برای reuse اهمیت دارد و کتابخانه قرارداد آزادسازی دارد.

۵. خیر؛ هزینه ساخت اتصال کمتر می‌شود ولی N درخواست هنوز وجود دارد؛ برنامه واکشی/Batch باید اصلاح شود.

۶. خیر؛ نتیجه ممکن است اعمال شده باشد. idempotency یا استعلام نتیجه و بودجه Retry لازم‌اند.

## منابع

- [فارسی: مبانی شبکه برای طراحی سیستم](https://learn.mhkarami97.ir/posts/networking_essentials/): مقدمه handshake، reuse و multiplexing؛ مرور گسترده و ساده‌شده است، مرجع هنجاری Header/نسخه نیست.
- [English: MDN Connection Management](https://developer.mozilla.org/en-US/docs/Web/HTTP/Guides/Connection_management_in_HTTP_1.x): مدل‌های HTTP/1.x و هزینه اتصال.
- [English: RFC 9113 — HTTP/2, §9](https://www.rfc-editor.org/rfc/rfc9113.html#section-9): connection lifecycle و reuse در HTTP/2.
- [English: RFC 9114 — HTTP/3, §4](https://www.rfc-editor.org/rfc/rfc9114.html#section-4): connection setup/management و ممنوعیت فیلدهای اتصال در HTTP/3.
- [English: Overview of HTTP — MDN](https://developer.mozilla.org/en-US/docs/Web/HTTP/Guides/Overview): گام‌های HTTP exchange و تفاوت reuse با بازکردن اتصال جدید.
- [English: RFC 9110 §7.6.1](https://www.rfc-editor.org/rfc/rfc9110.html#section-7.6.1): معنای connection-specific و forwarding؛ قواعد اختصاصی HTTP/2/3 در RFCهای لینک‌شده بالا.

**ناوبری:** [فهرست فصل](../README.md) · [فهرست مجموعه](../../README.md) · [قبلی: منطقه](../01-region-and-network-latency/README.md) · [بعدی: CDN](../03-cdn-for-static-and-frequent-content/README.md)

**مرتبط:** [Pool دیتابیس](../../04-databases/01-connection-pooling/README.md) · [Batching](../../06-code-optimization/08-batching-and-round-trips/README.md)

</div>



