<div dir="rtl" align="right">

# Linux و Unix برای معماران

Linux و Unix مدل process، user، file permission، network، filesystem و signal را فراهم می‌کنند؛ این مفاهیم روی container و سرویس تولیدی هم اثر دارند. معمار لازم نیست مدیر سیستم تمام‌وقت باشد، اما باید resource limit، permission، process lifecycle، file descriptor، DNS و logging را بفهمد.

هنگام سرویس‌دهی graceful shutdown، process باید درخواست‌های در حال انجام را تخلیه و connectionها را ببندد. log به stdout/stderr یا سامانهٔ مرکزی هدایت شود؛ secret نباید در environment یا فایل با دسترسی باز پخش شود. محدودیت CPU و memory می‌تواند throttling یا OOM ایجاد کند. تفاوت signalهای termination و kill، readiness و liveness در rollout مهم است.

## چرخهٔ عمر process و shutdown

Process با user و محیط مشخص اجرا می‌شود. هنگام deploy یا توقف، سیستم به process signal می‌دهد؛ برنامه باید پذیرش کار تازه را متوقف کند، connection و consumer را drain کند، کار جاری را تا مهلت مشخص کامل کند و سپس خارج شود. اگر deadline گذشت، termination اجباری ممکن است رخ دهد؛ پیام نیمه‌کاره باید با طراحی صف و idempotency قابل‌بازیابی باشد.

## permission و secret

برنامه را با user غیر-root و دسترسی حداقلی اجرا کن. permission فایل config و socketها را بررسی کن؛ world-readable secret می‌تواند همهٔ processهای ماشین را در معرض بگذارد. environment variable ساده‌تر است اما همیشه راه امن secret نیست: ممکن است در dump، diagnostics یا ابزار مدیریت دیده شود. secret manager، rotation و کمینه‌سازی دسترسی را بسنج.

## resource و عیب‌یابی

CPU throttling tail latency را زیاد می‌کند؛ memory limit می‌تواند OOM kill بسازد؛ file descriptor و connection pool محدودند. میانگین CPU پایین به معنای نبود throttling در burst نیست. زمان restart، OOM event، open file، queue، disk pressure و latency را کنار هم ببین. restart علت leak یا dependency failure را رفع نمی‌کند.

## فایل‌سیستم و log

container filesystem اغلب ephemeral است؛ دادهٔ پایدار باید در volume یا managed storage باشد. log را ساختاریافته به stdout/stderr بفرست تا collector جمع کند؛ token و دادهٔ حساس را log نکن. rotation و حجم log را محدود کن تا دیسک پر نشود.

## آزمون

۱. چرا process نباید با root اجرا شود؟ **پاسخ:** سطح آسیب در compromise را کمینه می‌کنیم.
۲. OOM چه پیامدی دارد؟ **پاسخ:** kernel می‌تواند process را terminate کند؛ restart به‌تنهایی علت را رفع نمی‌کند.
۳. graceful shutdown چه می‌کند؟ **پاسخ:** پذیرش کار تازه را متوقف و کارهای جاری را با timeout تخلیه می‌کند.
۴. CPU limit پایین چه علامتی می‌دهد؟ **پاسخ:** throttling و افزایش tail latency، حتی اگر میانگین مصرف کم دیده شود.

## تمرین

برای یک worker، کاربر سیستم، permission فایل config، log، signal shutdown و resource limit تعریف کن.

## پاسخ نمونهٔ تمرین

Worker با user اختصاصی non-root، config غیرحساس با read-only mode و secret از secret manager اجرا می‌شود. log ساختاریافته stdout و بدون token است. SIGTERM پذیرش پیام را متوقف، کار جاری را تا deadline کامل و سپس خروج می‌کند؛ visibility/ack صف مانع گم‌شدن پیام می‌شود. CPU/memory/file descriptor limit و OOM/throttle alert پایش می‌شود.

## منابع

- فارسی: [یادداشت‌های Linux و عملیات در DevDocs](https://devdocs.ir/)، [مبانی معماری فارسی](https://www.alirostami.com/software-architecture/)
- انگلیسی: [Linux man-pages](https://man7.org/linux/man-pages/)، [The Linux Documentation Project](https://tldp.org/)

</div>

