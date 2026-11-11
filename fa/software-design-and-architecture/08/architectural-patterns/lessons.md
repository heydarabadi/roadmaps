<div dir="rtl" align="right">

# درس کامل: الگوهای معماری


> **زبان:** [نسخهٔ انگلیسی](../../../../en/software-design-and-architecture/08/architectural-patterns/lessons.md)

## تفاوت سبک و الگو

واژه‌ها در منابع همیشه یکسان طبقه‌بندی نمی‌شوند. برای این دوره، **سبک** شکل کلی اجزا و قیدهای ارتباطی سیستم را توصیف می‌کند؛ **الگوی معماری** ساختار تکرارشونده‌ای برای حل مسئله در یک context است و ممکن است در یک سرویس، یک component یا کل سامانه به کار رود. CQRS و domain model معمولاً الگوهای داخلی‌اند؛ microservices و event-driven بیشتر سبک سیستم‌های چندجزئی توصیف می‌شوند.

هیچ الگوی واحدی برای کل برنامه اجباری نیست. یک bounded context ساده ممکن است CRUD داشته باشد؛ context حساس مالی ممکن است مدل دامنه غنی و transitionهای سخت‌گیرانه بخواهد.

## ۱. Domain-Driven Design

DDD راهی برای فهم دامنهٔ پیچیده و تبدیل فهم آن به مرز و مدل است. بخش راهبردی، bounded context و رابطهٔ contextها را می‌کاود؛ بخش تاکتیکی entity، value object، aggregate، repository و domain service را به کار می‌برد.

### مرزهای راهبردی

Bounded Context مرزی است که داخلش زبان و مدل معنای سازگار دارند. «Customer» در کاتالوگ، billing و shipping می‌تواند مدل‌های مختلفی داشته باشد. Context Map رابطه و جهت همکاری contextها را مشخص می‌کند؛ این کمک می‌کند مدل مشترک جهانی نسازیم.

### Tactical model

- **Entity:** هویت و lifecycle دارد.
- **Value object:** بر اساس مقدار تعریف می‌شود و بهتر است immutable باشد.
- **Aggregate:** محدودهٔ consistency و transaction دامنه‌ای را مشخص می‌کند؛ بیرون به root دسترسی می‌گیرد.
- **Domain event:** واقعیتی دربارهٔ دامنه که رخ داده است.
- **Repository:** collection-like contract برای بازیابی/ذخیرهٔ aggregate.
- **Domain service:** منطق دامنه‌ای که طبیعی نیست داخل یک entity تنها قرار بگیرد.

DDD کلاس‌نویسی بیشتر نیست. از گفتگو، eventها، invariantها، واژگان و دشواری تغییر شروع کن. برای CRUD ساده هزینهٔ همهٔ این مفاهیم ممکن است توجیه نشود.

## ۲. MVC

Model-View-Controller ورودی کاربر و نمایش را از مدل رفتار/داده جدا می‌کند. Controller request را می‌گیرد و به behavior مناسب می‌سپارد؛ View نتیجه را نمایش می‌دهد؛ Model بخش داده/رفتار است. چارچوب‌ها واژهٔ Model را متفاوت به کار می‌برند؛ اسم MVC تضمین نمی‌کند domain ruleها داخل Model یا خارج Controller باشند.

خطای رایج: controllerهای چاق که validation، قواعد دامنه، transaction و SQL را باهم اجرا می‌کنند. Controller را adapter مرزی نگه دار و منطق مهم را در application/domain model بگذار. برای UI، MVC می‌تواند ساختار سطح presentation باشد و هم‌زمان domain داخلی معماری دیگری داشته باشد.

## ۳. Microservices

Microservices سامانه را به سرویس‌های کوچک، مستقل و پیرامون business capability می‌شکند که معمولاً جداگانه deploy می‌شوند و دادهٔ خود را مالک‌اند. استقلال تیمی و release مزیت است؛ network, consistency, observability, deployment و security پیچیدگی می‌آورند.

مرز را از bounded context و تغییر/مالکیت پیدا کن، نه از جدول یا کلاس. اگر دو سرویس برای هر request پشت‌سرهم call می‌کنند، transaction مشترک دارند و باهم deploy می‌شوند، مرز ممکن است بد باشد. استخراج را مرحله‌ای کن؛ service boundary از library boundary سخت‌تر refactor می‌شود.

## ۴. Blackboard

Blackboard pattern برای مسئله‌ای مناسب است که راه‌حل از چند منبع دانش و گام‌های تدریجی ساخته می‌شود. فضای دادهٔ مشترک وضعیت/سرنخ را نگه می‌دارد؛ knowledge sourceها وقتی بتوانند آن را پیش ببرند فعال می‌شوند؛ control component پیشرفت را هماهنگ می‌کند.

مثال آموزشی: سامانهٔ تشخیص عیب، دادهٔ حسگر را روی تخته می‌گذارد و تحلیل‌گرهای مستقل سرنخ‌های مکانیکی/حرارتی را اضافه می‌کنند. کاربردهای احتمالی در recognition یا تشخیص پیچیده‌اند؛ برای یک pipeline خطی، صف معمولی یا توابع ترکیبی ساده‌ترند.

هزینه‌ها: state مشترک، تداخل گام‌ها، زمان‌بندی و تشخیص اینکه کدام تحلیل‌گر نتیجه را تغییر داده.

## ۵. Microkernel

Microkernel یک هستهٔ کوچک و پایدار دارد و قابلیت‌های متغیر را به plugin یا extension منتقل می‌کند. این الگو برای platformهایی خوب است که third-party extensions یا محصول‌های edition-specific واقعی دارند.

مرز plugin باید نسخه‌بندی، permission، lifecycle، خطا و resource limit داشته باشد. Plugin تنها وقتی مفید است که رفتار را خارج از هسته توسعه یا نصب کنیم؛ اگر همهٔ pluginها همیشه با خود برنامه منتشر می‌شوند، ماژول داخلی شاید ساده‌تر باشد.

## ۶. Serverless

Serverless یعنی بخش‌هایی از provisioning، runtime یا scaling را provider مدیریت می‌کند؛ سرور از نظر واقعی حذف نمی‌شود. Function/event-driven execution برای workloadهای bursty، کوتاه‌مدت و مستقل مفید است.

باید این‌ها را بسنجی: cold start، حداکثر زمان اجرا، حافظه، concurrency limit، provider lock-in، دادهٔ بین invocationها، observability و هزینهٔ per invocation. workload دائمی یا پردازش پرحجم ممکن است container/VM ارزان‌تر و قابل‌پیش‌بینی‌تری بخواهد.

## ۷. Queue و Stream

Queue کار را buffer می‌کند و consumer بعداً آن را برمی‌دارد؛ فشار موقت و کار پس‌زمینه از request جدا می‌شود. Stream سابقهٔ مرتب‌شده‌ای با offset/retention می‌دهد و چند consumer مستقل می‌توانند از جای جدا بخوانند. برخی brokerها هر دو رفتار را ترکیب می‌کنند؛ semantics را از ابزار بخوان.

پیام باید schema version، owner، key، retry policy، dead-letter handling و idempotency داشته باشد. consumer را برای duplicate و out-of-order امن کن. Queue کار گم‌شده را پنهان نمی‌کند؛ lag و failure باید alert شوند.

## ۸. Event Sourcing

در event sourcing، تغییر state به صورت دنبالهٔ eventهای دامنه‌ای تغییرناپذیر ذخیره می‌شود و state فعلی از replay به دست می‌آید. این روش audit، بازسازی projection و پرسش از تاریخچه را ممکن می‌کند؛ اما نیاز همیشگی نیست.

ملاحظات:

- event schema در زمان تغییر می‌کند؛ upcasting یا compatibility لازم است.
- replay باید deterministic باشد و به provider بیرونی وابسته نشود.
- snapshot برای کاهش replay طولانی مفید است.
- دادهٔ حساس، حذف قانونی و retention به طراحی ویژه نیاز دارند.
- اصلاح رویداد اشتباه اغلب با رویداد جبرانی انجام می‌شود.
- eventها را با log فنی یکسان نگیر؛ event باید واقعیت دامنه‌ای معنادار باشد.

## ۹. SOA

Service-Oriented Architecture قابلیت‌های سازمان را در سرویس‌های قراردادی برای integration عرضه می‌کند؛ ممکن است governance و enterprise bus مرکزی داشته باشد. SOA خانواده‌ای گسترده‌تر از microservices است و همیشه معادل سبک سرویس‌های کوچک و decentralized نیست.

مرکزیت ESB می‌تواند ترجمه و policy را یک‌جا جمع کند، ولی bottleneck سازمانی و coupling مرکزی هم بسازد. هدف را integration، ownership، reuse و تغییرپذیری روشن کن؛ سپس governance را اندازه بگیر.

## ۱۰. CQRS

CQRS مدل نوشتن و خواندن را جدا می‌کند. نسخهٔ ساده می‌تواند دو handler و دو model logical در یک process و دیتابیس باشد. مدل write invariant و transaction را اجرا می‌کند؛ read projection برای صفحه یا گزارش شکل می‌گیرد.

~~~python
def place_order(command, order_repository):
    order = Order.from_command(command)
    order_repository.save(order)
    return order.id

def get_order_summary(query, read_store):
    return read_store.find_summary(query.order_id)
~~~

CQRS لزوماً دو database یا دو service نیست. جداسازی physical زمانی ارزش دارد که query load، schema یا scalability به‌طور واقعی متفاوت باشد؛ در آن صورت projection delay و سازگاری نهایی نیز بخشی از قراردادند. Fowler هشدار می‌دهد که CQRS برای بسیاری از سیستم‌ها پیچیدگی ناموجه می‌سازد.

## ۱۱. مثال مرجع و تفاوت production

نمونهٔ Microsoft eShopOnContainers برای آموزش DDD/CQRS ساخته شده و سفارش را با command/query و مدل دامنه نشان می‌دهد؛ آن را شاهد اینکه همهٔ سرویس‌های production باید همین الگو را پیاده کنند تلقی نکن. [راهنمای ساده‌شدهٔ DDD/CQRS](https://learn.microsoft.com/en-us/dotnet/architecture/microservices/microservice-ddd-cqrs-patterns/apply-simplified-microservice-cqrs-ddd-patterns) تأکید می‌کند که این الگوها در سرویس پیچیده مفیدند و برای CRUD ساده ممکن است زیادی باشند.

## ۱۲. جدول تصمیم

| الگو | فشار مناسب | هزینه‌ای که باید بپذیری |
| --- | --- | --- |
| DDD | واژگان و قواعد پیچیده، تغییر زیاد | کشف دامنه و نگهداری مدل |
| MVC | جداسازی ورودی و نمایش در UI | controller fat یا مدل مبهم |
| Microservices | deploy/ownership/scale مستقل | network، consistency و عملیات |
| Blackboard | تحلیل تدریجی از منابع دانشی مستقل | coordination و shared state |
| Microkernel | plugin واقعی و اکوسیستم extension | compatibility، امنیت و lifecycle |
| Serverless | burst و event کوتاه‌مدت | limit، cold start و هزینهٔ provider |
| Queue/Stream | buffering یا replay چندمصرف‌کننده‌ای | ordering، retry، schema و lag |
| Event sourcing | تاریخچهٔ دامنه منبع اصلی لازم است | replay، migration و retention |
| SOA | integration سازمانی و contract مشترک | governance و مرکزیت |
| CQRS | مدل query/write واقعاً متفاوت است | projection و eventual consistency |

## ۱۳. آزمون با پاسخ

۱. آیا CQRS خودش microservices است؟
   - پاسخ: نه؛ می‌تواند درون یک سرویس و حتی یک database باشد.
۲. DDD چه چیزی را قبل از microservice boundary کمک می‌کند پیدا کنیم؟
   - پاسخ: bounded context، زبان و قواعدی که منسجم‌اند.
۳. Queue و stream چه تفاوت نیازمندی دارند؟
   - پاسخ: queue کار را buffer/تحویل می‌دهد؛ stream تاریخچه و offset مستقل چند مصرف‌کننده را فراهم می‌کند.
۴. چرا event sourcing از audit log ساده پیچیده‌تر است؟
   - پاسخ: eventها منبع state می‌شوند؛ replay، schema، determinism، snapshot و اصلاح تاریخچه مهم‌اند.
۵. Serverless چه چیزی را حذف نمی‌کند؟
   - پاسخ: مسئولیت سیستم، observability، امنیت، limit و هزینهٔ اجرا.
۶. چه وقت Microkernel توجیه دارد؟
   - پاسخ: وقتی extension مستقل واقعی، نسخه‌بندی و نصب قابلیت لازم است.
۷. چرا همهٔ سرویس‌ها را DDD نمی‌کنیم؟
   - پاسخ: پیچیدگی دامنه متفاوت است و مدل سنگین برای CRUD ساده هزینهٔ بی‌فایده می‌آورد.

## تمرین جامع: انتخاب الگو برای ثبت سفارش

سفارش قواعد پیچیدهٔ تخفیف و مجوز دارد. دو مصرف‌کنندهٔ مستقل به OrderPlaced نیاز دارند؛ dashboard می‌تواند چند ثانیه تأخیر داشته باشد، اما مالیات و مبلغ نهایی باید هنگام ثبت دقیق باشند.

**کارها**
1. مدل و مرز write را مشخص کن.
2. تحویل event و ساخت dashboard را انتخاب کن.
3. بگو آیا CQRS یا Event Sourcing لازم است.

**پاسخ تشریحی:** مدل دامنهٔ سفارش را با invariantهای تخفیف و مبلغ حفظ می‌کنم و use case مجوز، تغییر مدل و transaction را هماهنگ می‌کند. برای جلوگیری از گم‌شدن event، ثبت سفارش و outbox را در یک transaction ذخیره می‌کنم؛ worker آن را idempotent منتشر می‌کند. dashboard می‌تواند از projection ناهمگام بخواند. این جداسازی read/write شکل ساده‌ای از CQRS است، نه الزاماً دو سرویس. Event Sourcing را انتخاب نمی‌کنم مگر تاریخچهٔ event منبع حقیقت و قابلیت replay الزام دامنه باشد؛ در غیر این صورت هزینهٔ نسخه‌بندی و replay بی‌دلیل است.

## منابع اختیاری

- [راهنمای فارسی DDD](https://github.com/hheydarian/Understanding-Domain-Driven-Design)
- [DNTips؛ معماری و مایکروسرویس به فارسی](https://www.dntips.ir/news/details/18872)
- [Microsoft Learn؛ DDD-oriented microservice](https://learn.microsoft.com/en-us/dotnet/architecture/microservices/microservice-ddd-cqrs-patterns/ddd-oriented-microservice)
- [Martin Fowler؛ CQRS](https://martinfowler.com/bliki/CQRS.html)
- [Martin Fowler؛ Event Sourcing](https://martinfowler.com/eaaDev/EventSourcing.html)



## منابع تکمیلی

[کتابخانهٔ منابع مرتبط با این فصل](../../references.md#chapter-08)
</div>
