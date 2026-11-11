# Task 3 omitted snapshot

## Snapshot: Backend Performace/02-api-response/02-response-compression/README.md

   1: <div dir="rtl" align="right">
   2: 
   3: # فشرده‌سازی پاسخ — Response Compression
   4: 
   5: Compression نمایش بایتی همان محتوا را برای انتقال کوچک‌تر می‌کند؛ JSON را از نظر معنایی خلاصه نمی‌کند. سرور و کلاینت باید دربارهٔ Encoding توافق کنند. کاهش بایت هزینهٔ شبکه را کم می‌کند، اما فشرده‌سازی و بازکردن آن CPU می‌خواهد؛ تصمیم خوب نتیجهٔ مقایسهٔ این هزینه‌هاست.
   6: 
   7: **پس از این درس می‌توانید:** نقش سه Header اصلی را توضیح دهید؛ اندازهٔ انتقال را با بدنهٔ بازشده اشتباه نگیرید؛ لایهٔ مسئول فشرده‌سازی را تعیین کنید؛ و سود شبکه را همراه با CPU، تأخیر و ریسک محتوای حساس بسنجید. پیش‌نیاز: HTTP Header و [اندازهٔ Payload](../01-payload-size/README.md). تاریخ بررسی منابع: **۲۰۲۶-۱۱-۱۰**.
   8: 
   9: ## مذاکرهٔ Encoding چگونه کار می‌کند؟
  10: 
  11: | جزء | نقش | نمونه |
  12: | --- | --- | --- |
  13: | `Accept-Encoding` در درخواست | الگوریتم‌های قابل‌قبول برای کلاینت | `gzip, br` |
  14: | `Content-Encoding` در پاسخ | Encoding واقعاً اعمال‌شده به بدنه | `gzip` |
  15: | `Vary: Accept-Encoding` در پاسخ | اطلاع به Cache دربارهٔ وابستگی نمایش به Header درخواست | نسخهٔ فشرده و خام اشتباه به هم تحویل نشوند |
  16: | `Content-Type` | نوع محتوای بازشده | همچنان `application/json` |
  17: 
  18: کلاینت پشتیبانی‌اش را اعلام می‌کند؛ سرور Encoding قابل‌قبول و پشتیبانی‌شده را انتخاب می‌کند و بدنه را با آن می‌فرستد. وقتی انتخاب نمایش به `Accept-Encoding` وابسته است، `Vary` باید این وابستگی را بیان کند. gzip معمولاً برای متن/JSON مفید است؛ فشرده کردن دوبارهٔ JPEG یا ZIP معمولاً سود کمی دارد. [MDN: Compression in HTTP](https://developer.mozilla.org/en-US/docs/Web/HTTP/Guides/Compression)
  19: 
  20: نباید تنها با افزودن `Content-Encoding: gzip` بدنهٔ JSON خام ارسال کنید؛ Header باید بایت‌های واقعی را توصیف کند. برعکس، بدنهٔ gzip بدون Header درست برای مصرف‌کننده قابل تفسیر نیست. `Content-Length`، اگر موجود است، طول پیامِ کدگذاری‌شده را بیان می‌کند؛ آن را پس از تغییر Encoding از مقدار قبلی کپی نکنید. [MDN: Content-Encoding](https://developer.mozilla.org/en-US/docs/Web/HTTP/Reference/Headers/Content-Encoding)
  21: 
  22: ### انتخاب محل و سطح فشرده‌سازی
  23: 
  24: 1. مسیر تحویل را بنویسید: Application ← Reverse Proxy ← CDN ← Client. رفتار پاسخ را در هر Hop ببینید، نه فقط تنظیم برنامه را.
  25: 2. یک مالک روشن برای Policy تعیین کنید. اگر چند لایه تبدیل می‌کنند، مسئولیت Header، Validator و Decompression/Recompression باید معلوم باشد.
  26: 3. MIME Type، حداقل اندازه و الگوریتم‌های مجاز را مشخص کنید. آستانهٔ مناسب به داده، CPU و شرایط شبکهٔ شما وابسته است.
  27: 4. برای پاسخ پویای پرترافیک، سطح فشرده‌سازی را با p95/p99 و CPU انتخاب کنید. کمترین بایت الزاماً کمترین latency نیست.
  28: 5. دارایی ثابت را در صورت امکان از پیش فشرده و توزیع کنید؛ برای پاسخ جریانی، هزینهٔ Buffer و Flush را نیز بسنجید.
  29: 
  30: Compression برای پاسخ متنی متوسط/بزرگ روی لینک محدود مناسب است. برای پاسخ بسیار کوچک، فایل از پیش فشرده، یا سرویس CPU-bound ممکن است سود ناچیز یا منفی باشد. اگر دادهٔ غیرضروری می‌فرستید، ابتدا [Payload](../01-payload-size/README.md) را اصلاح کنید؛ کلاینت دادهٔ اضافی را پس از بازکردن همچنان Parse می‌کند.
  31: 
  32: ## مثال حل‌شدهٔ HTTP و حساب سرانگشتی
  33: 
  34: <div dir="ltr" align="left">
  35: 
  36: ```http
  37: GET /v1/orders?page_size=50 HTTP/1.1
  38: Host: api.example.test
  39: Accept: application/json
  40: Accept-Encoding: gzip
  41: ```
  42: 
  43: ```http
  44: HTTP/1.1 200 OK
  45: Content-Type: application/json
  46: Content-Encoding: gzip
  47: Vary: Accept-Encoding
  48: 
  49: [gzip-encoded bytes of the JSON representation]
  50: ```
  51: 
  52: </div>
  53: 
  54: سطر آخر نمایش آموزشیِ جای بدنهٔ باینری است؛ نباید آن متن را به‌عنوان بدنهٔ واقعی سرور پیاده کنید. در نمونهٔ فوق عمداً `Content-Length` عددی ننوشته‌ایم، چون طول باید از بایت واقعی خروجی محاسبه شود.
  55: 
  56: **سناریوی فرضی:** JSON برابر ۲۰۰ KiB است؛ نتیجهٔ اندازه‌گیری محلی gzip برابر ۴۰ KiB شده است. نسبت خروجی به ورودی ۰٫۲ و صرفه‌جویی بایت ۸۰٪ است. روی لینک فرضی ۱ MiB/s، بخش خالص انتقال از حدود ۱۹۵ به ۳۹ میلی‌ثانیه می‌رسد؛ RTT، صف، TLS و پردازش در این حساب نیستند. اگر فشرده‌سازی ۵ میلی‌ثانیه هزینه داشته باشد احتمال سود هست؛ اگر زیر بار ۲۰۰ میلی‌ثانیه صف CPU اضافه کند، این انتخاب ممکن است بدتر باشد. این اعداد گزارش تولید نیستند.
  57: 
  58: ## تمرین کوتاه: پاسخ واقعی را از سمت کلاینت ببینید
  59: 
  60: روی Endpoint محلی یا محیط آزمایشیِ خودتان که پاسخ JSON به‌اندازهٔ کافی بزرگ دارد، دو درخواست به یک URL و با مجوز یکسان بفرستید. `localhost:8080` در این تمرین فرضی است و باید با سرویس آزمایشی خود جایگزین شود. در Windows از `curl.exe` استفاده کنید:
  61: 
  62: <div dir="ltr" align="left">
  63: 
  64: ```powershell
  65: curl.exe -sS -H "Accept-Encoding: identity" -D identity-headers.txt -o identity-body.bin -w "bytes=%{size_download} total=%{time_total}\n" "http://localhost:8080/v1/orders?page_size=50"
  66: curl.exe -sS -H "Accept-Encoding: gzip" -D gzip-headers.txt -o gzip-body.bin -w "bytes=%{size_download} total=%{time_total}\n" "http://localhost:8080/v1/orders?page_size=50"
  67: Get-Item -LiteralPath .\identity-body.bin, .\gzip-body.bin |
  68:     Select-Object Name, Length
  69: ```
  70: 
  71: </div>
  72: 
  73: در این دو فرمان `--compressed` استفاده نشده تا ابزار بدنه را خودکار باز نکند؛ فایل دوم در صورت پذیرفته‌شدن gzip، بایت فشرده دارد. **انتظار:** در مسیر واجد شرایط، Header دوم `Content-Encoding: gzip` و اندازهٔ منتقل‌شده کوچک‌تر است؛ پاسخ اول نباید ادعای gzip کند. اگر تفاوت نیست، MIME Type، آستانه، Encoding پشتیبانی‌شده و رفتار Proxy را بررسی کنید. چند بار با دادهٔ ثابت و حالت Cache مشخص مقایسه کنید؛ یک اندازه‌گیری زمان اثبات بهبود نیست. برای بررسی صحت JSON بازشده می‌توانید درخواست جداگانه با `--compressed` بفرستید.
  74: 
  75: ## شاهد واقعی و حدود آن
  76: 
  77: **مستند عملیاتی Cloudflare:** فشرده‌سازی مسیر Origin تا شبکهٔ Cloudflare و مسیر آن تا بازدیدکننده جداست. این Reverse Proxy می‌تواند بین نمایش خام و فشرده تبدیل کند، و برخی تغییرهای محتوا نیازمند بازکردن و فشرده‌سازی دوباره هستند. نتیجهٔ عملی برای عیب‌یابی: Header و اندازهٔ مشاهده‌شده در Origin الزاماً همان خروجی نهایی کلاینت نیست. [Cloudflare: Content compression](https://developers.cloudflare.com/speed/optimization/content/compression/)
  78: 
  79: این شاهد از رفتار یک سرویس واقعی می‌آید؛ آزمایش مقایسه‌ایِ برنامهٔ ما یا تضمین درصد صرفه‌جویی نیست. تنظیمات و محدودیت‌های CDN را هنگام اجرا دوباره بررسی کنید؛ از یک آستانهٔ اختصاصی محصول، «عدد استاندارد HTTP» نسازید.
  80: 
  81: ## شکست‌ها، ریسک‌ها و علائم
  82: 
  83: | شکست | نشانه | اقدام |
  84: | --- | --- | --- |
  85: | سطح بسیار سنگین روی پاسخ پویا | بایت کمتر، CPU و p99 بیشتر | سطوح سبک‌تر و مالک لایه را مقایسه کن |
  86: | Header نادرست یا تبدیل دوبارهٔ ناسازگار | خطای Decode/JSON در کلاینت | بایت واقعی و Header هر Hop را کنار هم بررسی کن |
  87: | `Vary` ناقص | مشکل فقط برای بخشی از کلاینت‌های پشت Cache | سیاست نمایش و کلید Cache را اصلاح کن |
  88: | اعتماد به اندازهٔ بازشدهٔ DevTools به‌جای انتقال | گزارش صرفه‌جویی اشتباه | Transfer size و decoded size را جدا ثبت کن |
  89: | Buffer کردن کل پاسخ جریانی | افزایش حافظه و زمان اولین بایت | اندازهٔ Buffer و رفتار Flush را بررسی کن |
  90: 
  91: **محتوای حساس:** ترکیب دادهٔ راز و ورودی قابل‌کنترل مهاجم در یک پاسخ فشردهٔ پویا می‌تواند از تغییر طول پاسخ اطلاعات نشت دهد؛ HTTPS این مسئله را به‌تنهایی برطرف نمی‌کند. مستندات ASP.NET Core دربارهٔ ریسک Compression روی پاسخ‌های پویا و امن هشدار می‌دهد. این به معنای ناامن بودن همهٔ JSONهای فشرده نیست؛ Endpoint حساس و مدل تهدید را بررسی کنید. [Microsoft: Response compression](https://learn.microsoft.com/en-us/aspnet/core/performance/response-compression?view=aspnetcore-10.0)
  92: 
  93: ### چک‌لیست عملیاتی
  94: 
  95: - [ ] MIME Type، آستانه، Encoding و مالک Policy روشن‌اند.
  96: - [ ] درخواست بدون Compression و با هر Encoding پشتیبانی‌شده درست پاسخ می‌گیرد.
  97: - [ ] `Content-Encoding`، `Vary` و طول بدنه با بایت واقعی سازگارند.
  98: - [ ] اندازهٔ بازشده، نسبت فشرده‌سازی، CPU، TTFB و p95/p99 ثبت شده‌اند.
  99: - [ ] رفتار نهایی پس از Proxy/CDN و اثر Cache بررسی شده است.
 100: - [ ] پاسخ‌های حساس و دادهٔ از پیش فشرده جدا بررسی شده‌اند.
 101: - [ ] برای Streaming، حافظهٔ Buffer و تأخیر Flush تحت مشاهده‌اند.
 102: 
 103: ## آزمون
 104: 
 105: 1. تفاوت `Accept-Encoding` و `Content-Encoding` چیست؟
 106: 2. چرا در انتخاب Encoding بر اساس درخواست، `Vary: Accept-Encoding` لازم است؟
 107: 3. آیا باید `Content-Type` پاسخ JSON فشرده را به `application/gzip` تغییر داد؟
 108: 4. خروجی از ۲۰۰ به ۴۰ KiB رسیده ولی p99 بدتر شده است؛ دو بررسی بعدی چیست؟
 109: 5. آیا فقط دیدن `Content-Encoding` در Origin برای اثبات خروجی نهایی کافی است؟
 110: 6. چرا «همهٔ پاسخ‌های HTTPS را با سنگین‌ترین سطح فشرده کن» تصمیم قابل دفاعی نیست؟
 111: 
 112: ### پاسخ تشریحی
 113: 
 114: 1. اولی قابلیت/ترجیح کلاینت را بیان می‌کند؛ دومی Encoding واقعاً اعمال‌شده به بدنهٔ پاسخ را اعلام می‌کند.
 115: 2. Cache باید نمایش‌های وابسته به قابلیت کلاینت را تشخیص دهد؛ وگرنه ممکن است نمایش نامناسب تحویل دهد.
 116: 3. خیر؛ نوع محتوای بازشده همچنان JSON است. `Content-Encoding` تبدیل انتقالی آن را توصیف می‌کند.
 117: 4. CPU و زمان صف/فشرده‌سازی را اندازه بگیرید و Buffer/TTFB را ببینید؛ بایت کمتر برای latency کل کافی نیست.
 118: 5. خیر؛ Proxy/CDN ممکن است تبدیل یا Recompression کند. از دید مصرف‌کننده هم Header و بایت را بررسی کنید.
 119: 6. هزینهٔ CPU، اندازه و نوع محتوا، Buffering و ریسک محتوای حساس متفاوت است؛ سطح و دامنه باید با اندازه‌گیری انتخاب شوند.
 120: 
 121: ## مطالعهٔ بیشتر
 122: 
 123: - [فارسی: انجین‌اکس؛ فشرده‌سازی و Cache فایل ثابت](https://mehdimj.ir/blog/2026/10/08/nginx-night-16-static-cache-compression/): تمرین کوتاه MIME، `gzip_vary` و مشاهدهٔ Header؛ دامنهٔ مثال فایل ثابت است.
 124: - [English: MDN Compression in HTTP](https://developer.mozilla.org/en-US/docs/Web/HTTP/Guides/Compression): مدل مذاکرهٔ محتوا و تفاوت الگوریتم‌ها.
 125: - [English: MDN Content-Encoding](https://developer.mozilla.org/en-US/docs/Web/HTTP/Reference/Headers/Content-Encoding): مرجع تفسیر بدنه و نوع محتوا.
 126: - [English: Microsoft response compression](https://learn.microsoft.com/en-us/aspnet/core/performance/response-compression?view=aspnetcore-10.0): Trade-off، ملاحظات HTTPS و یک نمونهٔ پیاده‌سازی؛ وابستگی به .NET برای فهم این درس لازم نیست.
 127: - [English: Cloudflare Content compression](https://developers.cloudflare.com/speed/optimization/content/compression/): تحویل چندمرحله‌ای و تبدیل‌های Proxy.
 128: 
 129: **ناوبری:** [فصل API Response](../README.md) · [فهرست اصلی](../../README.md) · [قبلی: Payload](../01-payload-size/README.md) · [بعدی: Pagination](../03-efficient-pagination/README.md)
 130: 
 131: **مرتبط:** [Streaming](../../06-code-optimization/01-streaming-large-bodies/README.md) · [CDN](../../10-network/03-cdn-for-static-and-frequent-content/README.md) · [تأخیر شبکه](../../10-network/01-region-and-network-latency/README.md)
 132: 
 133: </div>
