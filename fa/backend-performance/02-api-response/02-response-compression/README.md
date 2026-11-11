<div dir="rtl" align="right">

# فشرده‌سازی پاسخ — Response Compression

**زبان:** فارسی · [English version](../../../../en/backend-performance/02-api-response/02-response-compression/README.md)


Compression نمایش بایتی همان محتوا را برای انتقال کوچک‌تر می‌کند؛ JSON را از نظر معنایی خلاصه نمی‌کند. سرور و کلاینت باید دربارهٔ Encoding توافق کنند. کاهش بایت هزینهٔ شبکه را کم می‌کند، اما فشرده‌سازی و بازکردن آن CPU می‌خواهد؛ تصمیم خوب نتیجهٔ مقایسهٔ این هزینه‌هاست.

**پس از این درس می‌توانید:** نقش سه Header اصلی را توضیح دهید؛ اندازهٔ انتقال را با بدنهٔ بازشده اشتباه نگیرید؛ لایهٔ مسئول فشرده‌سازی را تعیین کنید؛ و سود شبکه را همراه با CPU، تأخیر و ریسک محتوای حساس بسنجید. پیش‌نیاز: HTTP Header و [اندازهٔ Payload](../01-payload-size/README.md). تاریخ بررسی منابع: **۲۰۲۶-۱۱-۱۰**.

## Headerها و اصطلاح‌های لازم

Headerهای درخواست از کلاینت به سرور می‌گویند چه چیزی را می‌پذیرد؛ Headerهای پاسخ رفتار و نمایش بدنه را توصیف می‌کنند. **Representation** بدنه‌ای است که پس از بازشدن مصرف می‌شود؛ Content-Encoding فقط نمایش بایتی انتقال را عوض می‌کند.

## مذاکرهٔ Encoding چگونه کار می‌کند؟

| جزء | نقش | نمونه |
| --- | --- | --- |
| `Accept-Encoding` در درخواست | الگوریتم‌های قابل‌قبول برای کلاینت | `gzip, br` |
| `Content-Encoding` در پاسخ | Encoding واقعاً اعمال‌شده به بدنه | `gzip` |
| `Vary: Accept-Encoding` در پاسخ | اطلاع به Cache دربارهٔ وابستگی نمایش به Header درخواست | نسخهٔ فشرده و خام اشتباه به هم تحویل نشوند |
| `Content-Type` | نوع محتوای بازشده | همچنان `application/json` |

کلاینت پشتیبانی‌اش را اعلام می‌کند؛ سرور Encoding قابل‌قبول و پشتیبانی‌شده را انتخاب می‌کند و بدنه را با آن می‌فرستد. وقتی انتخاب نمایش به `Accept-Encoding` وابسته است، `Vary` باید این وابستگی را بیان کند. gzip معمولاً برای متن/JSON مفید است؛ فشرده کردن دوبارهٔ JPEG یا ZIP معمولاً سود کمی دارد. [MDN: Compression in HTTP](https://developer.mozilla.org/en-US/docs/Web/HTTP/Guides/Compression)

نباید تنها با افزودن `Content-Encoding: gzip` بدنهٔ JSON خام ارسال کنید؛ Header باید بایت‌های واقعی را توصیف کند. برعکس، بدنهٔ gzip بدون Header درست برای مصرف‌کننده قابل تفسیر نیست. `Content-Length`، اگر موجود است، طول پیامِ کدگذاری‌شده را بیان می‌کند؛ آن را پس از تغییر Encoding از مقدار قبلی کپی نکنید. [MDN: Content-Encoding](https://developer.mozilla.org/en-US/docs/Web/HTTP/Reference/Headers/Content-Encoding)

### انتخاب محل و سطح فشرده‌سازی

1. مسیر تحویل را بنویسید: Application ← Reverse Proxy ← CDN ← Client. رفتار پاسخ را در هر Hop ببینید، نه فقط تنظیم برنامه را.
2. یک مالک روشن برای Policy تعیین کنید. اگر چند لایه تبدیل می‌کنند، مسئولیت Header، Validator و Decompression/Recompression باید معلوم باشد.
3. MIME Type، حداقل اندازه و الگوریتم‌های مجاز را مشخص کنید. آستانهٔ مناسب به داده، CPU و شرایط شبکهٔ شما وابسته است.
4. برای پاسخ پویای پرترافیک، سطح فشرده‌سازی را با p95/p99 و CPU انتخاب کنید. کمترین بایت الزاماً کمترین latency نیست.
5. دارایی ثابت را در صورت امکان از پیش فشرده و توزیع کنید؛ برای پاسخ جریانی، هزینهٔ Buffer و Flush را نیز بسنجید.

Compression برای پاسخ متنی متوسط/بزرگ روی لینک محدود مناسب است. برای پاسخ بسیار کوچک، فایل از پیش فشرده، یا سرویس CPU-bound ممکن است سود ناچیز یا منفی باشد. اگر دادهٔ غیرضروری می‌فرستید، ابتدا [Payload](../01-payload-size/README.md) را اصلاح کنید؛ کلاینت دادهٔ اضافی را پس از بازکردن همچنان Parse می‌کند.

## مثال حل‌شدهٔ HTTP و حساب سرانگشتی

<div dir="ltr" align="left">

```http
GET /v1/orders?page_size=50 HTTP/1.1
Host: api.example.test
Accept: application/json
Accept-Encoding: gzip
```

```http
HTTP/1.1 200 OK
Content-Type: application/json
Content-Encoding: gzip
Vary: Accept-Encoding

[gzip-encoded bytes of the JSON representation]
```

</div>

سطر آخر نمایش آموزشیِ جای بدنهٔ باینری است؛ نباید آن متن را به‌عنوان بدنهٔ واقعی سرور پیاده کنید. در نمونهٔ فوق عمداً `Content-Length` عددی ننوشته‌ایم، چون طول باید از بایت واقعی خروجی محاسبه شود.

**سناریوی فرضی:** JSON برابر ۲۰۰ KiB است؛ نتیجهٔ اندازه‌گیری محلی gzip برابر ۴۰ KiB شده است. نسبت خروجی به ورودی ۰٫۲ و صرفه‌جویی بایت ۸۰٪ است. روی لینک فرضی ۱ MiB/s، بخش خالص انتقال از حدود ۱۹۵ به ۳۹ میلی‌ثانیه می‌رسد؛ RTT، صف، TLS و پردازش در این حساب نیستند. اگر فشرده‌سازی ۵ میلی‌ثانیه هزینه داشته باشد احتمال سود هست؛ اگر زیر بار ۲۰۰ میلی‌ثانیه صف CPU اضافه کند، این انتخاب ممکن است بدتر باشد. این اعداد گزارش تولید نیستند.

## تمرین کوتاه و راه‌حل نمونه: پاسخ واقعی را ببینید

روی Endpoint محلی یا محیط آزمایشیِ خودتان که پاسخ JSON به‌اندازهٔ کافی بزرگ دارد، دو درخواست به یک URL و با مجوز یکسان بفرستید. `localhost:8080` در این تمرین فرضی است و باید با سرویس آزمایشی خود جایگزین شود. در Windows از `curl.exe` استفاده کنید:

<div dir="ltr" align="left">

```powershell
curl.exe -sS -H "Accept-Encoding: identity" -D identity-headers.txt -o identity-body.bin -w "bytes=%{size_download} total=%{time_total}\n" "http://localhost:8080/v1/orders?page_size=50"
curl.exe -sS -H "Accept-Encoding: gzip" -D gzip-headers.txt -o gzip-body.bin -w "bytes=%{size_download} total=%{time_total}\n" "http://localhost:8080/v1/orders?page_size=50"
Get-Item -LiteralPath .\identity-body.bin, .\gzip-body.bin |
    Select-Object Name, Length
```

</div>

در این دو فرمان `--compressed` استفاده نشده تا ابزار بدنه را خودکار باز نکند؛ فایل دوم در صورت پذیرفته‌شدن gzip، بایت فشرده دارد. **انتظار:** در مسیر واجد شرایط، Header دوم `Content-Encoding: gzip` و اندازهٔ منتقل‌شده کوچک‌تر است؛ پاسخ اول نباید ادعای gzip کند. اگر تفاوت نیست، MIME Type، آستانه، Encoding پشتیبانی‌شده و رفتار Proxy را بررسی کنید. چند بار با دادهٔ ثابت و حالت Cache مشخص مقایسه کنید؛ یک اندازه‌گیری زمان اثبات بهبود نیست. برای بررسی صحت JSON بازشده می‌توانید درخواست جداگانه با `--compressed` بفرستید.

## راه‌حل نمونهٔ اندازه‌گیری

اگر نمونه‌ای `identity=204800` و `gzip=51200` بایت دانلود کند، خروجی فشرده یک‌چهارم ورودی و صرفه‌جویی بایت `(204800−51200)/204800=75%` است. نتیجهٔ درست باید علاوه بر عدد، `Content-Encoding: gzip` را در پاسخ فشرده نشان دهد و پاسخ خام ادعای gzip نکند. اگر اندازه‌ها برابرند، از Headerها و نوع MIME شروع کنید، سپس آستانهٔ حداقل اندازه و تنظیم Proxy/CDN را بررسی کنید؛ از یک اندازه‌گیری زمان برای نتیجه‌گیری CPU یا latency کافی نیست.

## شاهد واقعی و حدود آن

**مستند عملیاتی Cloudflare:** فشرده‌سازی مسیر Origin تا شبکهٔ Cloudflare و مسیر آن تا بازدیدکننده جداست. این Reverse Proxy می‌تواند بین نمایش خام و فشرده تبدیل کند، و برخی تغییرهای محتوا نیازمند بازکردن و فشرده‌سازی دوباره هستند. نتیجهٔ عملی برای عیب‌یابی: Header و اندازهٔ مشاهده‌شده در Origin الزاماً همان خروجی نهایی کلاینت نیست. [Cloudflare: Content compression](https://developers.cloudflare.com/speed/optimization/content/compression/)

این شاهد از رفتار یک سرویس واقعی می‌آید؛ آزمایش مقایسه‌ایِ برنامهٔ ما یا تضمین درصد صرفه‌جویی نیست. تنظیمات و محدودیت‌های CDN را هنگام اجرا دوباره بررسی کنید؛ از یک آستانهٔ اختصاصی محصول، «عدد استاندارد HTTP» نسازید.

## شکست‌ها، ریسک‌ها و علائم

| شکست | نشانه | اقدام |
| --- | --- | --- |
| سطح بسیار سنگین روی پاسخ پویا | بایت کمتر، CPU و p99 بیشتر | سطوح سبک‌تر و مالک لایه را مقایسه کن |
| Header نادرست یا تبدیل دوبارهٔ ناسازگار | خطای Decode/JSON در کلاینت | بایت واقعی و Header هر Hop را کنار هم بررسی کن |
| `Vary` ناقص | مشکل فقط برای بخشی از کلاینت‌های پشت Cache | سیاست نمایش و کلید Cache را اصلاح کن |
| اعتماد به اندازهٔ بازشدهٔ DevTools به‌جای انتقال | گزارش صرفه‌جویی اشتباه | Transfer size و decoded size را جدا ثبت کن |
| Buffer کردن کل پاسخ جریانی | افزایش حافظه و زمان اولین بایت | اندازهٔ Buffer و رفتار Flush را بررسی کن |

**محتوای حساس:** ترکیب دادهٔ راز و ورودی قابل‌کنترل مهاجم در یک پاسخ فشردهٔ پویا می‌تواند از تغییر طول پاسخ اطلاعات نشت دهد؛ HTTPS این مسئله را به‌تنهایی برطرف نمی‌کند. مستندات ASP.NET Core دربارهٔ ریسک Compression روی پاسخ‌های پویا و امن هشدار می‌دهد. این به معنای ناامن بودن همهٔ JSONهای فشرده نیست؛ Endpoint حساس و مدل تهدید را بررسی کنید. [Microsoft: Response compression](https://learn.microsoft.com/en-us/aspnet/core/performance/response-compression?view=aspnetcore-10.0)

### چک‌لیست عملیاتی

- [ ] MIME Type، آستانه، Encoding و مالک Policy روشن‌اند.
- [ ] درخواست بدون Compression و با هر Encoding پشتیبانی‌شده درست پاسخ می‌گیرد.
- [ ] `Content-Encoding`، `Vary` و طول بدنه با بایت واقعی سازگارند.
- [ ] اندازهٔ بازشده، نسبت فشرده‌سازی، CPU، TTFB و p95/p99 ثبت شده‌اند.
- [ ] رفتار نهایی پس از Proxy/CDN و اثر Cache بررسی شده است.
- [ ] پاسخ‌های حساس و دادهٔ از پیش فشرده جدا بررسی شده‌اند.
- [ ] برای Streaming، حافظهٔ Buffer و تأخیر Flush تحت مشاهده‌اند.

## آزمون

1. تفاوت `Accept-Encoding` و `Content-Encoding` چیست؟
2. چرا در انتخاب Encoding بر اساس درخواست، `Vary: Accept-Encoding` لازم است؟
3. آیا باید `Content-Type` پاسخ JSON فشرده را به `application/gzip` تغییر داد؟
4. خروجی از ۲۰۰ به ۴۰ KiB رسیده ولی p99 بدتر شده است؛ دو بررسی بعدی چیست؟
5. آیا فقط دیدن `Content-Encoding` در Origin برای اثبات خروجی نهایی کافی است؟
6. چرا «همهٔ پاسخ‌های HTTPS را با سنگین‌ترین سطح فشرده کن» تصمیم قابل دفاعی نیست؟

### پاسخ تشریحی

1. اولی قابلیت/ترجیح کلاینت را بیان می‌کند؛ دومی Encoding واقعاً اعمال‌شده به بدنهٔ پاسخ را اعلام می‌کند.
2. Cache باید نمایش‌های وابسته به قابلیت کلاینت را تشخیص دهد؛ وگرنه ممکن است نمایش نامناسب تحویل دهد.
3. خیر؛ نوع محتوای بازشده همچنان JSON است. `Content-Encoding` تبدیل انتقالی آن را توصیف می‌کند.
4. CPU و زمان صف/فشرده‌سازی را اندازه بگیرید و Buffer/TTFB را ببینید؛ بایت کمتر برای latency کل کافی نیست.
5. خیر؛ Proxy/CDN ممکن است تبدیل یا Recompression کند. از دید مصرف‌کننده هم Header و بایت را بررسی کنید.
6. هزینهٔ CPU، اندازه و نوع محتوا، Buffering و ریسک محتوای حساس متفاوت است؛ سطح و دامنه باید با اندازه‌گیری انتخاب شوند.

## جمع‌بندی

Compression فقط بایت انتقال را کم می‌کند و هزینهٔ CPU، Decode و محتوای بازشده باقی می‌ماند. Encoding باید با قابلیت کلاینت، `Vary`، لایهٔ مسئول و دید مصرف‌کننده هماهنگ باشد؛ نتیجه را با Transfer size و هزینهٔ سرور کنار هم بخوانید.

## منابع اختیاری و مرجع

مدل Headerها و مثال محاسبه در همین صفحه کامل است؛ این پیوندها برای مطالعهٔ اضافه و پیاده‌سازی‌های مشخص‌اند.

- [فارسی: انجین‌اکس؛ فشرده‌سازی و Cache فایل ثابت](https://mehdimj.ir/blog/2026/10/08/nginx-night-16-static-cache-compression/): تمرین کوتاه MIME، `gzip_vary` و مشاهدهٔ Header؛ دامنهٔ مثال فایل ثابت است.
- [English: MDN Compression in HTTP](https://developer.mozilla.org/en-US/docs/Web/HTTP/Guides/Compression): مدل مذاکرهٔ محتوا و تفاوت الگوریتم‌ها.
- [English: MDN Content-Encoding](https://developer.mozilla.org/en-US/docs/Web/HTTP/Reference/Headers/Content-Encoding): مرجع تفسیر بدنه و نوع محتوا.
- [English: Microsoft response compression](https://learn.microsoft.com/en-us/aspnet/core/performance/response-compression?view=aspnetcore-10.0): Trade-off، ملاحظات HTTPS و یک نمونهٔ پیاده‌سازی؛ وابستگی به .NET برای فهم این درس لازم نیست.
- [English: Cloudflare Content compression](https://developers.cloudflare.com/speed/optimization/content/compression/): تحویل چندمرحله‌ای و تبدیل‌های Proxy.

**ناوبری:** [فصل API Response](../README.md) · [فهرست اصلی](../../README.md) · [قبلی: Payload](../01-payload-size/README.md) · [بعدی: Pagination](../03-efficient-pagination/README.md)

**مرتبط:** [Streaming](../../06-code-optimization/01-streaming-large-bodies/README.md) · [CDN](../../10-network/03-cdn-for-static-and-frequent-content/README.md) · [تأخیر شبکه](../../10-network/01-region-and-network-latency/README.md)

</div>
