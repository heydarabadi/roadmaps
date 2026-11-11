<div dir="rtl" align="right">

# MVC، MVP، MVVM و الگوهای طراحی

## ایدهٔ مرکزی

الگو طرحی نام‌دار برای تکرارپذیرکردن یک تصمیم طراحی است. الگو جزئیات اجرایی قطعی نیست؛ باید با framework، جریان داده، تیم و نیاز محصول تطبیق داده شود. MVC/MVP/MVVM الگوهای جداسازی نمایش از منطق و state هستند. GoF عمدتاً الگوهای شیءگرا و PoSA الگوهای معماری نرم‌افزار را گردآوری می‌کنند.

## خانواده‌های UI

- **MVC:** Model مسئول داده/رفتار، View نمایش، Controller دریافت ورودی و هماهنگی. شکل دقیق MVC میان server-rendered و UIهای reactive فرق می‌کند.
- **MVP:** Presenter منطق نمایش را کنترل می‌کند؛ View معمولاً ساده و از طریق قرارداد قابل‌آزمون است. در UIهای قدیمی یا وقتی جداسازی view لازم است مفید است.
- **MVVM:** ViewModel state و فرمان‌های مناسب نمایش را فراهم می‌کند؛ data binding می‌تواند سیم‌کشی را کم کند ولی تغییر state را پنهان سازد.

الگوهای GoF به خانواده‌های creational، structural و behavioral تقسیم می‌شوند: Factory، Adapter، Decorator، Composite، Strategy، Observer و Command نمونه‌هایی‌اند. الگوهای معماری مانند Layered، Hexagonal، Event-Driven و Microkernel در سطح سیستم و boundary اثر دارند. قبل از استفاده، مسئله را بدون نام الگو توصیف کن.

## مثال: چند درگاه پرداخت

اگر درگاه‌ها قراردادی مشترک دارند، Adapter هر ارائه‌دهنده را به قرارداد داخلی PaymentGateway نگاشت می‌کند. Strategy می‌تواند انتخاب درگاه بر اساس کشور یا نوع کارت را محصور کند. Factory ساخت adapter را از مصرف‌کننده جدا می‌سازد. اگر فقط یک درگاه و یک use case باشد، لایهٔ factory و registry ممکن است هزینهٔ بی‌دلیل باشد.

~~~text
PaymentUseCase -> PaymentGateway
                     |-> GatewayAAdapter -> Provider A
                     |-> GatewayBAdapter -> Provider B
~~~

## مدل‌های UI را دقیق‌تر مقایسه کن

MVC یک مسئولیت را برای دریافت رخداد کاربر و انتخاب پاسخ به Controller، نمایش را به View و state/domain را به Model می‌سپارد. در server MVC ممکن است controller درخواست HTTP را بگیرد و HTML بسازد؛ در UI client، data flow اغلب event-driven است. پس سه نام MVC در دو framework الزاماً ساختار داخلی یکسانی ندارند.

در MVP، Presenter تصمیم می‌گیرد چه چیزی نمایش داده شود و از راه interface با View حرف می‌زند. این مدل در UIهایی که view باید بسیار ساده و قابل mock باشد کمک می‌کند، اما اگر Presenter همهٔ قوانین دامنه را بگیرد، به کلاس عظیم تبدیل می‌شود. در MVVM، ViewModel state و commandهای مناسب نمایش را آماده می‌کند؛ data binding می‌تواند boilerplate را کم کند، ولی اگر binding پنهان باشد عیب‌یابی جریان تغییر state دشوار می‌شود.

| نیاز | گزینهٔ احتمالی | بررسی |
| --- | --- | --- |
| درخواست HTTP و تولید پاسخ | MVC سمت server | controller نازک و use case جدا |
| آزمون مستقل منطق نمایش | MVP | interface و مالک state روشن |
| binding دوطرفه و state UI | MVVM | رفتار خودکار و lifecycle را بفهم |
| چند UI مستقل از domain | hexagonal/ports & adapters | domain نباید به framework UI وابسته شود |

## خانواده‌های GoF و PoSA

الگوهای GoF را بهتر است با مسئله یاد بگیری: Factory ساخت وابسته به شرایط را محصور می‌کند؛ Adapter شکل قرارداد را عوض می‌کند؛ Decorator رفتار را پیرامون یک قرارداد اضافه می‌کند؛ Composite ساختار درختی جزء و کل را یکسان می‌سازد؛ Strategy الگوریتم قابل‌تعویض است؛ Observer تغییر را به subscriberها می‌رساند؛ Command درخواست را به داده/عمل مستقل تبدیل می‌کند.

PoSA/architectural patternها در سطح وسیع‌ترند: Layered dependency را لایه‌بندی می‌کند، Microkernel افزونه را کنار core می‌گذارد، Event-Driven producer را از consumer جدا می‌کند، Client-Server درخواست را میان مصرف‌کننده و ارائه‌دهنده می‌برد. این‌ها اغلب با هم ترکیب می‌شوند؛ مثلاً layered modular monolith می‌تواند در یک boundary از event استفاده کند.

## انتخاب الگو

| پرسش | نشانه |
| --- | --- |
| چه چیزی تغییر می‌کند؟ | الگو باید همین تغییر را محصور کند |
| مالک state کیست؟ | جریان داده و mutation را شفاف کن |
| کدام قرارداد پایدار است؟ | وابستگی مصرف‌کننده را به آن ببند |
| چه هزینه‌ای افزوده می‌شود؟ | abstraction، indirection و دیباگ را بشمار |

## دام‌ها

- انتخاب pattern بر اساس نمودار UML پیش از بیان مسئله.
- مخلوط‌کردن MVCهای frameworkهای مختلف.
- Factory و Manager و Providerهای تودرتو برای یک implementation.
- برداشت اینکه GoF patternها معادل معماری کل سامانه‌اند.
- abstraction برای «آیندهٔ شاید» و ایجاد API پیچیدهٔ عمومی.

## آزمون

۱. Adapter چه مشکلی را حل می‌کند؟  
**پاسخ:** قرارداد بیرونی یا ناسازگار را پشت interface مورد انتظار سیستم پنهان می‌کند.

۲. فرق Strategy و Adapter چیست؟  
**پاسخ:** Strategy انتخاب الگوریتم هم‌قرارداد را آسان می‌کند؛ Adapter قرارداد یا شکل یک طرف را به طرف دیگر نگاشت می‌کند.

۳. چرا MVVM می‌تواند هم سودمند و هم خطرناک باشد؟  
**پاسخ:** state نمایش و آزمون‌پذیری را سامان می‌دهد، اما data binding و تغییرهای پنهان می‌توانند جریان داده را دشوار کنند.

۴. پیش از معرفی pattern چه کاری انجام می‌دهی؟  
**پاسخ:** مسئله، تغییر مورد انتظار، هزینهٔ کنونی و نتیجهٔ مطلوب را توصیف می‌کنم؛ سپس ساده‌ترین طراحی کافی را می‌سنجم.

## تمرین

دو درگاه پرداخت را پشت قرارداد واحد مدل کن. نشان بده Adapter کجاست، انتخاب provider کجا می‌شود و کدام خطاهای درگاه باید به مدل داخلی تبدیل شوند.

## پاسخ نمونهٔ تمرین

PaymentGateway یک قرارداد داخلی مانند authorize/refund دارد؛ ProviderAAdapter و ProviderBAdapter مدل خارجی را به انواع داخلی تبدیل می‌کنند. انتخاب provider در configuration/application policy انجام می‌شود، نه داخل domain. timeout، insufficient funds، declined و provider unavailable به خطاهای داخلی مجزا نگاشت می‌شوند؛ raw exception و credential بیرونی نباید نشت کند. contract test روی هر adapter از یکسان‌بودن معنا مراقبت می‌کند.

## منابع

- فارسی: [نقشهٔ طراحی و معماری](https://roadmap.sh/pdfs/roadmaps/software-design-architecture.pdf)، [مبانی معماری نرم‌افزار به فارسی](https://www.alirostami.com/software-architecture/)
- انگلیسی: [Microsoft: Common web application architectures](https://learn.microsoft.com/en-us/dotnet/architecture/modern-web-apps-azure/common-web-application-architectures)، [Refactoring.Guru: Design Patterns](https://refactoring.guru/design-patterns)

</div>
