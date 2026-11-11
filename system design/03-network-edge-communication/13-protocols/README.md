<div dir="rtl" align="right">
[English version](../../en/03-network-edge-communication/13-protocols/README.md)


# HTTP، TCP، UDP، RPC، gRPC، REST و GraphQL

## هدف یادگیری

- مسئله‌ای را که این مفهوم حل می‌کند تعریف کنی.
- برای یک سامانهٔ نمونه انتخاب را با trade-off توضیح بدهی.
- رفتار سیستم را هنگام اختلال پیش‌بینی کنی.

## ایدهٔ مرکزی

پروتکل باید با کشف‌پذیری، نسخه‌پذیری، streaming، latency، browser و استقلال سرویس هماهنگ باشد.

## نقشهٔ مفهومی

نیاز کسب‌وکار ← قرارداد بار/کیفیت ← انتخاب الگو ← نقطهٔ شکست ← مشاهده و بازیابی

## توضیح کامل

TCP جریان بایت مرتب و قابل‌اعتماد می‌دهد؛ UDP تحویل/ترتیب را تضمین نمی‌کند. HTTP قرارداد وب است. REST از semantics منابع و HTTP استفاده می‌کند؛ GraphQL شکل دادهٔ درخواستی می‌دهد و کنترل هزینه query لازم دارد. RPC فراخوانی دوردست را صورت‌بندی می‌کند؛ gRPC عموماً Protobuf و HTTP/2 را برای قرارداد تایپ‌شده/stream به کار می‌برد. Timeout، deadline، auth و retry بخشی از قراردادند.

## درس گام‌به‌گام

### لایه‌های ارتباط را از هم جدا کن

IP packet را به میزبان می‌رساند؛ TCP/UDP انتقال بین processها را شکل می‌دهد؛ TLS محرمانگی، تمامیت و احراز هویت سرور را اضافه می‌کند؛ HTTP روش و header و status را تعریف می‌کند؛ API قرارداد حوزهٔ کسب‌وکار را ارائه می‌دهد. وقتی «اتصال کار نمی‌کند» باید معلوم باشد مشکل DNS، TCP handshake، TLS، HTTP یا منطق endpoint است. log یک لایه به تنهایی برای تشخیص همه کافی نیست.

### TCP و UDP

TCP یک byte stream مرتب و قابل‌اعتماد می‌دهد: گم‌شدن packet با retransmit مدیریت می‌شود و برنامه لازم نیست ترتیب packetها را خودش بسازد. اما اتصال، handshake، congestion control و head-of-line delay هزینه دارد. TCP مرز پیام application را نمی‌شناسد؛ برنامه باید length prefix، delimiter یا framing داشته باشد. UDP datagram می‌فرستد و delivery/order را تضمین نمی‌کند؛ برای voice/game/DNS یا پروتکل‌هایی که خودشان رفتار مورد نیاز را می‌سازند مناسب است. UDP را صرفاً «سریع‌تر» فرض نکن.

### HTTP و روش‌های آن

HTTP قرارداد client-server است؛ method، URL، header و body را به status و response header/body پیوند می‌دهد. `GET` برای خواندن و معمولاً safe/idempotent است؛ `PUT` معمولاً جایگزینی idempotent یک resource و `DELETE` درخواست حذف همان resource است؛ `POST` معمولاً ایجاد/عملیات دارد و idempotent نیست مگر API چنین قراردادی بسازد. `429` می‌تواند throttle را نشان دهد؛ `5xx` عموماً خطای server/dependency است. TLS از HTTP محافظت می‌کند ولی authorization و validation را حذف نمی‌کند.

### REST، RPC/gRPC و GraphQL

REST resource-oriented است و از semantics HTTP، cache و status code بهره می‌برد. نام REST به تنهایی API را درست نمی‌کند؛ resource، pagination، version، error schema و idempotency مهم‌اند. RPC عملیاتی شبیه فراخوانی تابع را بین processها می‌برد و باید failure شبکه را در API آشکار کند. gRPC با schema تایپ‌شده و Protobuf، unary و streaming را پشتیبانی می‌کند؛ browser، gateway، debugging و evolution schema را نیز در نظر بگیر. GraphQL یک endpoint و query shape انتخابی می‌دهد؛ N+1، query گران، authorization روی هر field و caching نیاز به سیاست دارند.

### Timeout، deadline و retry

timeout سقف انتظار یک اتصال/عملیات است؛ deadline بودجهٔ کل مسیر است. اگر gateway یک ثانیه بودجه دارد، backend نباید 3 ثانیه ادامه دهد. timeout به معنای cancel شدن اثر server نیست: سرور ممکن است کار را انجام داده و پاسخ در شبکه گم شده باشد. retry فقط برای failureهای گذرا و عملیات امن انجام شود؛ backoff، jitter، سقف تلاش و idempotency لازم است.

### قرارداد نمونهٔ API

برای endpoint ساخت سفارش، API باید شکل خطا، auth، validation، pagination (برای list)، version و رفتار replay را روشن کند. نمونهٔ زیر فقط بخشی از قرارداد است:

~~~http
POST /v1/orders
Authorization: Bearer <token>
Idempotency-Key: 41ab...
Content-Type: application/json

{"sku":"A7","quantity":1}
~~~

پاسخ موفق باید شناسهٔ سفارش و وضعیت اولیه را بدهد؛ اگر پرداخت ادامه دارد، status endpoint یا event مشخص کند کاربر چطور نتیجه را دنبال می‌کند.

## مثال عملی

API موبایل عمومی ممکن است REST/JSON بخواهد؛ ارتباط داخلی پرترافیک شاید gRPC باشد. gateway و observability را هم بسنج.

## نمونهٔ قرارداد / شبه‌کد

~~~text
POST /v1/orders با Idempotency-Key و JSON versioned؛ retry فقط با قرارداد ایمن.
~~~

## تجربهٔ عملی و تصمیم‌های معماری

نمونهٔ مهندسی برای مطالعه: [Uber Engineering](https://www.uber.com/blog/engineering/)

REST برای سازگاری عمومی؛ gRPC برای RPC داخلی/streaming؛ GraphQL برای نیازهای داده‌ای متنوع با سقف پیچیدگی.

| تصمیم | چه زمانی مناسب است | کجا پرریسک می‌شود |
| --- | --- | --- |
| راه‌حل ساده | بار و دامنه محدود، رفتار قابل‌اندازه‌گیری | نیاز اثبات‌شدهٔ چندمنطقه‌ای یا حد ظرفیت |
| الگوی توزیع‌شده | نیاز روشن به جداسازی، ظرفیت یا دوام | پیچیدگی عملیاتی از سود بیشتر شود |

## دام‌ها و سوءبرداشت‌ها

- retry همهٔ POSTها؛ نبود deadline؛ GraphQL گران؛ تصور اینکه TCP مرز پیام برنامه را می‌شناسد.
- عددهای مثال آموزشی‌اند؛ SLO و ظرفیت نهایی را از دادهٔ واقعی تعیین کن.

## آزمون کوتاه

1. TCP و UDP چه تفاوتی دارند؟
2. gRPC چه زمانی مفید است؟
3. GraphQL چه ریسک عملیاتی دارد؟

### پاسخ‌نامهٔ فشرده

1. TCP جریان مرتب و قابل‌اعتماد می‌دهد؛ UDP پیام‌های datagram با تحویل/ترتیب تضمین‌نشده می‌دهد.
2. برای قرارداد تایپ‌شدهٔ سرویس داخلی، latency مناسب یا streaming با اکوسیستم سازگار.
3. query عمیق/پرجنب‌وجوش می‌تواند fan-out و هزینهٔ دیتابیس را بالا ببرد؛ سقف depth/complexity لازم است.

## تمرین

برای یک فروشگاه اینترنتی، مسیر درخواست این مفهوم را رسم کن. منبع حقیقت، مرز شبکه، رفتار شکست، دادهٔ حساس، معیار پایش و راه بازگشت را مشخص کن. سپس یک آزمون خرابی بنویس که بتواند فرض اصلی را رد کند.

## خلاصه

پروتکل باید با کشف‌پذیری، نسخه‌پذیری، streaming، latency، browser و استقلال سرویس هماهنگ باشد. پیش از پیاده‌سازی رفتار عادی، حالت اختلال و معیار موفقیت را ثبت کن.

## مبنای roadmap

- [System Design Roadmap — نسخهٔ تعاملی](https://roadmap.sh/system-design)
- [PDF رسمی roadmap.sh با شاخه‌ها و ریزموضوع‌ها](https://roadmap.sh/pdfs/roadmaps/system-design.pdf)

### مقالهٔ فارسی

- [معماری وب و اجزای یک سامانه](https://virgool.io/Quera-Mag/%D9%85%D8%B9%D9%85%D8%A7%D8%B1%DB%8C-%D9%88%D8%A8-%D8%A2%D8%B4%D9%86%D8%A7%DB%8C%DB%8C-%D9%85%D9%81%D8%A7%D9%87%DB%8C%D9%85-%D9%BE%D8%A7%DB%8C%D9%87-ofbcud4oao0c)

### منابع انگلیسی و تجربه‌های مهندسی

- [MDN: HTTP overview](https://developer.mozilla.org/en-US/docs/Web/HTTP/Overview)
- [gRPC: Core concepts](https://grpc.io/docs/what-is-grpc/core-concepts/)
- [Uber Engineering](https://www.uber.com/blog/engineering/)

</div>

