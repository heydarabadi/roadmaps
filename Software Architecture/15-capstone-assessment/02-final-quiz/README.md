<div dir="rtl" align="right">

# آزمون جامع Software Architect

ابتدا سؤال‌ها را بدون دیدن پاسخ‌ها جواب بده. نمرهٔ پیشنهادی: هر سؤال یک امتیاز؛ ۲۴ به بالا یعنی مفاهیم پایه جا افتاده‌اند، اما برای تسلط باید پروژهٔ فصل قبل را نیز با دلیل تصمیم کامل کنی.

## آزمون: پرسش‌ها

۱. معمار باید در قدم اول چه چیزی را روشن کند؟  
۲. چرا «سامانه مقیاس‌پذیر باشد» نیاز کافی نیست؟  
۳. C4 context diagram برای چه مخاطبی مفید است؟  
۴. تفاوت Entity و Value Object چیست؟  
۵. آیا DDD به معنی microservices است؟  
۶. CQRS چه چیزی را جدا می‌کند؟  
۷. Event Sourcing چه هزینه‌هایی دارد؟  
۸. ACID Atomicity چه می‌گوید؟  
۹. CAP دربارهٔ کدام وضعیت شبکه است؟  
۱۰. چه چیزی modular monolith را ماژولار می‌کند؟  
۱۱. استقلال microservice چه مسئولیت‌هایی اضافه می‌کند؟  
۱۲. چه چیزی timeout را مبهم می‌کند؟  
۱۳. چرا consumer پیام idempotent می‌شود؟  
۱۴. OAuth و OIDC چه تفاوتی دارند؟  
۱۵. چرا authorization در UI کافی نیست؟  
۱۶. password را با SHA-256 ساده ذخیره می‌کنی؟  
۱۷. NoSQL را بر اساس چه انتخاب می‌کنی؟  
۱۸. چرا ETL باید lineage داشته باشد؟  
۱۹. gRPC چه مزیتی برای service-to-service دارد؟  
۲۰. چه وقت SSG مناسب است؟  
۲۱. container و VM چه تفاوتی دارند؟  
۲۲. SLI و SLO چه تفاوتی دارند؟  
۲۳. ADR چه چیزی را ثبت می‌کند؟  
۲۴. UML و C4 چه رابطه‌ای دارند؟  
۲۵. Scrum و Kanban چه تمرکزی دارند؟  
۲۶. چرا toolset مشترک بدون governance کافی نیست؟

## پاسخ‌نامهٔ کوتاه

۱. هدف، ذی‌نفع و محدودیت مسئله.  
۲. بار، مخاطب، زمان پاسخ و شرایط باید سنجش‌پذیر شوند.  
۳. مخاطبی که باید محیط و مرز سامانه را ببیند.  
۴. Entity هویت پایدار دارد؛ Value Object با مقدارش تعریف می‌شود.  
۵. خیر؛ DDD روش مدل‌کردن پیچیدگی دامنه است و context می‌تواند module باشد.  
۶. مدل یا مسیر خواندن و تغییر را.  
۷. schema evolution، replay، projection، حریم خصوصی و tooling.  
۸. تراکنش کامل اعمال می‌شود یا نمی‌شود.  
۹. partition میان گره‌ها.  
۱۰. قرارداد و قواعد وابستگی قابل‌اجرا، نه فقط پوشه.  
۱۱. شبکه، discovery، telemetry، release، امنیت، آن‌کال و consistency.  
۱۲. ممکن است درخواست commit شده باشد ولی پاسخ از دست رفته باشد.  
۱۳. تحویل یا retry می‌تواند پیام را تکرار کند.  
۱۴. OAuth delegated authorization؛ OIDC identity.  
۱۵. کلاینت قابل‌دورزدن است؛ server باید هر object/action را مجوزدهی کند.  
۱۶. خیر؛ password hashing کند و saltدار لازم است.  
۱۷. access pattern، workload، consistency، query و توان اداره.  
۱۸. منشأ داده و اثر تغییر را برای اعتماد و عیب‌یابی دنبال می‌کند.  
۱۹. قرارداد typed، code generation و streaming.  
۲۰. داده هنگام build شناخته و کم‌تغییر باشد.  
۲۱. container kernel host را شریک است؛ VM سیستم‌عامل مهمان دارد.  
۲۲. SLI اندازه‌گیری است؛ SLO هدف آن.  
۲۳. زمینه، گزینه، تصمیم و پیامد آن.  
۲۴. روش‌های مکمل: C4 ساختار سطح‌به‌سطح؛ UML مدل‌های رسمی برای ساختار/رفتار.  
۲۵. Scrum iteration و ساختار تیمی؛ Kanban جریان و WIP.  
۲۶. قرارداد تصمیم، مالک، استثنا و بازبینی لازم است.

## تمرین تشریحی پایانی

برای سامانه‌ای که ۹۹٫۹٪ درخواست checkout را زیر ۴۰۰ میلی‌ثانیه پاسخ دهد، ولی provider پرداخت گاهی ۸ ثانیه کند می‌شود، معماری و تجربهٔ کاربر را پیشنهاد بده. SLI/SLO، timeout، وضعیت «نامشخص»، idempotency، reconciliation، پیام به کاربر و سناریوی بازیابی را باهم توضیح بده.

پاسخ مطلوب باید بین پذیرش سفارش و تأیید پرداخت تفاوت بگذارد، timeout بی‌قیدوشرط را رد کند، وضعیت نامشخص را قابل‌پیگیری کند و تصمیم را بر اساس ریسک تجاری بگیرد.

## پاسخ تشریحی سناریوی پایانی

به محض دریافت درخواست معتبر، checkout می‌تواند سفارش را با وضعیت PendingPayment ثبت کند و سریع شناسهٔ پیگیری بدهد؛ این پاسخ نباید ادعا کند پرداخت نهایی شده. درخواست پرداخت با idempotency key به provider می‌رود. مهلت HTTP از SLO checkout جدا از زمان نهایی‌سازی provider است؛ اگر provider کند شد، کاربر وضعیت «در حال تأیید» و مسیر polling/status می‌بیند، نه دکمه‌ای که پرداخت را بی‌قید تکرار کند.

نتیجهٔ callback با امضای provider، audience/merchant و timestamp/nonce مناسب بررسی می‌شود؛ event ID تکراری deduplicate و transition state فقط از حالت‌های مجاز پذیرفته می‌شود. اگر callback نرسد یا پاسخ timeout مبهم باشد، background reconciliation از provider وضعیت را می‌پرسد. پرداخت موفق سفارش را تأیید و رزرو موجودی را نهایی می‌کند؛ شکست قطعی رزرو را آزاد می‌کند؛ وضعیت غیرقطعی برای پیگیری باقی می‌ماند.

SLI را برای latency پاسخ اولیه و نسبت checkoutهای نهایی‌شده در بازهٔ کسب‌وکار جدا تعریف کن. در غیر این صورت provider کند، SLO پاسخ API را بی‌معنا می‌کند یا برعکس تجربهٔ نهایی پنهان می‌ماند. SLO و درصدک‌های واقعی از دادهٔ محصول تعیین می‌شوند؛ عدد 400ms به‌تنهایی تضمین نمی‌کند که کار کاربر تمام شده.

## معیار نمره‌دهی

- **۲ امتیاز:** تفاوت پذیرش درخواست و تأیید پرداخت را روشن می‌کند.
- **۲ امتیاز:** timeout مبهم، idempotency و جلوگیری از برداشت دوباره را پوشش می‌دهد.
- **۲ امتیاز:** callback امن، تکرار، transition state و reconciliation را دارد.
- **۲ امتیاز:** SLI/SLO تجربهٔ فوری و نتیجهٔ نهایی را جدا می‌کند.
- **۲ امتیاز:** حالت recovery، موجودی، پیام کاربر و مالک عملیات را توضیح می‌دهد.

پاسخ خوب علاوه بر گزینهٔ انتخابی، حداقل یک گزینهٔ ردشده و هزینهٔ آن را توضیح می‌دهد. اگر trade-off و زمینه را نگویی، حفظ اصطلاح‌ها برای معمارشدن کافی نیست.

## منابع مرور نهایی

- فارسی: [مبانی معماری نرم‌افزار](https://www.alirostami.com/software-architecture/)، [نقشهٔ راه Software Architect](https://roadmap.sh/pdfs/roadmaps/software-architect.pdf)، [EventDrivenFarsi](https://github.com/gloonch/eventdrivenfarsi)
- انگلیسی: [C4 Model](https://c4model.com/)، [OWASP Cheat Sheet Series](https://cheatsheetseries.owasp.org/)، [Google SRE Book](https://sre.google/sre-book/table-of-contents/)، [Microsoft Azure Architecture Center](https://learn.microsoft.com/en-us/azure/architecture/)

</div>
