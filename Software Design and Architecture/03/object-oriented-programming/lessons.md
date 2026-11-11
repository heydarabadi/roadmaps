<div dir="rtl" align="right">

# درس عمیق: برنامه‌نویسی شیءگرا و مدل‌سازی


> **زبان:** [نسخهٔ انگلیسی](../../en/03/object-oriented-programming/lessons.md)

این راهنما همهٔ گره‌های فصل شیءگرایی را به هم وصل می‌کند: پارادایم OOP، اصول پایه، ویژگی‌های زبان، مدل‌محورکردن دامنه، گونه‌های کلاس و لایه‌بندی. درس‌های کوتاه هر موضوع در پوشهٔ topics هم باقی‌اند؛ این متن مسیر یکپارچه و خودبسندهٔ مطالعه است.

## پیش‌نیاز و هدف

پیش‌نیاز: متغیر، تابع، شرط، ساختار داده و مفهوم فراخوانی تابع. هدف این نیست که هر چیز را کلاس کنیم؛ هدف این است که بدانیم state و قواعد را کجا نگه داریم، قراردادها را چگونه طراحی کنیم و کدام نوع تنوع را با چه سازوکاری بیان کنیم.

پس از مطالعه باید بتوانی:

- فرق class، object، value و entity را با مثال توضیح بدهی.
- چهار اصل OOP را به مسئلهٔ واقعی ربط بدهی و بی‌دلیل از آن‌ها استفاده نکنی.
- interface، abstract class و concrete class را در جای درست به کار ببری.
- مدل دامنه و زبان مشترک را از schema دیتابیس جدا کنی.
- domain model غنی را با مدل بی‌رفتار بر حسب پیچیدگی مسئله انتخاب کنی.
- dependency میان domain، application، presentation و infrastructure را مشخص کنی.

## ۱. پارادایم چیست و OOP چه مسئله‌ای را حل می‌کند؟

پارادایم روش سازمان‌دهی برنامه و فکرکردن دربارهٔ محاسبه، state و جریان کنترل است. در سبک رویه‌ای، برنامه از دستورهای پی‌درپی و توابع ساخته می‌شود؛ در سبک تابعی، تبدیل مقدارها و کنترل اثر جانبی برجسته است؛ در سبک شیءگرا، state و رفتار مرتبط در objectها قرار می‌گیرد؛ در سبک اعلانی، بیشتر می‌گوییم چه نتیجه‌ای می‌خواهیم تا چطور گام‌به‌گام بسازیم.

این مرزها دیوار قطعی نیستند. سامانهٔ خوب می‌تواند برای محاسبهٔ قیمت تابع خالص، برای lifecycle سفارش object، و برای هماهنگی use case رویهٔ روشن داشته باشد. زبان چندپارادایمی را مطابق مسئله به کار ببر.

در OOP، class طرح نوعی از object است و object نمونهٔ در حال اجراست. هر object ممکن است:

- **state** داشته باشد؛ مقادیری که در طول عمر آن تغییر می‌کنند.
- **behavior** داشته باشد؛ عملیات‌هایی که روی state یا ورودی انجام می‌دهد.
- **identity** داشته باشد؛ تشخیص اینکه این همان شیء کسب‌وکاری است حتی اگر بعضی ویژگی‌هایش تغییر کرده باشد.
- **contract** داشته باشد؛ رفتارهایی که مصرف‌کننده حق دارد انتظار داشته باشد.

Object صرفاً کیف داده نیست. اگر هر caller بتواند هر فیلدی را تغییر دهد، قواعد در همه‌جا پخش می‌شوند. اما object هم همیشه لازم نیست؛ رکورد فقط‌خواندنی یا یک محاسبهٔ ساده می‌تواند data value یا تابع باشد.

## ۲. چهار اصل پایهٔ OOP

### کپسوله‌سازی (Encapsulation)

کپسوله‌سازی دسترسی مستقیم به state را کنترل می‌کند تا invariant حفظ شود. invariant شرطی است که باید پیش و پس از همهٔ operationهای معتبر برقرار بماند؛ برای مثال موجودی حساب پس از برداشت نباید از حد اعتباری مجاز عبور کند.

گام‌ها: invariant را بنویس؛ setter آزاد را محدود کن؛ operation دامنه‌ای بساز؛ تغییر state را فقط از همان مسیر انجام بده؛ تلاش کن حالت نامعتبر حتی قابل ساخت نباشد.

~~~python
class Account:
    def __init__(self, balance_cents, credit_limit_cents=0):
        self._balance = balance_cents
        self._credit_limit = credit_limit_cents

    def withdraw(self, amount_cents):
        if amount_cents <= 0:
            raise ValueError("Amount must be positive")
        if self._balance - amount_cents < -self._credit_limit:
            raise InsufficientFunds()
        self._balance -= amount_cents
~~~

فیلد private بدون کنترل mutation کافی نیست؛ اگر متد دیگری مقدار را بدون invariant تغییر دهد، کپسوله‌سازی شکسته است. برای مجموعه‌های mutable باید مراقب باش reference داخلی از property بیرون نشت نکند.

### انتزاع (Abstraction)

انتزاع قرارداد لازم برای مصرف‌کننده را نگه می‌دارد و جزئیات نامربوط را پنهان می‌کند. use case سفارش باید بداند کالا را رزرو کند، نه اینکه هر اتصال دیتابیس و query SQL چگونه کار می‌کند.

انتزاع را از نیاز مصرف‌کننده استخراج کن: چه کاری لازم است؟ چه نتیجه و شکست‌هایی ممکن‌اند؟ چه جزئیاتی نباید به caller برسند؟ اگر API همچنان ORM entity یا خطای خام vendor را می‌دهد، انتزاع کامل نیست.

هر interface ارزشمند نیست. اگر تنها یک پیاده‌سازی، هیچ seam تست و هیچ دلیل تغییر وجود ندارد، قرارداد می‌تواند فقط یک لایهٔ اضافه باشد. انتزاع زودرس آینده را حدس می‌زند؛ انتزاع مناسب تغییر واقعی را محدود می‌کند.

### وراثت (Inheritance)

وراثت می‌تواند type relation، reuse behavior و polymorphism بدهد؛ ولی «برای reuse» دلیل کافی نیست. رابطهٔ زیرنوع باید از دید مصرف‌کننده درست باشد: هرجا نوع پایه استفاده می‌شود، subtype هم باید قرارداد رفتاری را حفظ کند.

اگر subtype یک operation پایه را غیرفعال می‌کند، پیش‌شرط قوی‌تری می‌خواهد یا معنی نتیجه را عوض می‌کند، آن subtype احتمالاً جایگزین معتبر نیست. subclass به implementation پایه، ترتیب hookها و protected API وابسته می‌شود؛ تغییر base class می‌تواند وارثانی را بشکند که مالکیتشان دست تیم دیگری است.

نمونهٔ مستند تحلیلی: مربع از نظر ریاضی نوعی مستطیل است، اما object مستطیلی که عرض و ارتفاعش مستقل تغییر می‌کنند با مربع قابل‌جایگزینی نیست. اشتراک مفهومی همیشه قرارداد زیرنوعی درست نمی‌سازد.

برای رفتارهایی که به چند محور مستقل تغییر می‌کنند، composition مناسب‌تر است: سفارش یک DiscountPolicy می‌گیرد، نه اینکه برای هر ترکیب نوع مشتری و کمپین subclass تازه بسازیم.

### چندریختی (Polymorphism)

چندریختی یعنی consumer با قرارداد مشترک کار کند و رفتار بر اساس implementation واقعی انتخاب شود. subtype polymorphism از interface/base type استفاده می‌کند؛ parametric polymorphism از generic؛ برخی زبان‌ها dispatch بر حسب overload یا pattern matching دارند.

~~~python
class DiscountPolicy(Protocol):
    def apply(self, subtotal_cents: int) -> int: ...

def checkout(subtotal_cents, policy: DiscountPolicy):
    return policy.apply(subtotal_cents)
~~~

این کار branchهای پراکنده را کم می‌کند، اگر الگوریتم‌های تخفیف واقعاً متفاوت و قابل تعویض باشند. اگر فقط یک policy داریم و change driver مشخصی نیست، تابع مستقیم ساده‌تر است. برای قرارداد مشترک، test contract داشته باش تا implementationها یک رفتار حداقلی را رعایت کنند.

## ۳. ویژگی‌های زبان: interface، abstract class، concrete class، scope

### Interface

Interface قرارداد capability است؛ مثلاً PaymentAuthorizer می‌گوید چه کاری در اختیار مصرف‌کننده است. interface را از نیاز consumer طراحی کن، نه از کل SDK فروشنده. اگر یک interface بزرگ همهٔ عملیات پرداخت، refund، گزارش و تنظیمات را ارائه می‌دهد، مصرف‌کننده‌ها به عملیات نامربوط وابسته می‌شوند؛ قرارداد کوچک‌تر بر اساس نقش‌ها می‌تواند مناسب باشد.

### Abstract class

کلاس انتزاعی مستقیماً نمونه‌سازی نمی‌شود و ممکن است پیاده‌سازی مشترک یا الگوریتم قالب داشته باشد. Template Method وقتی مناسب است که ترتیب مراحل ثابت و یک گام قابل تغییر باشد. اگر زیرکلاس‌ها ترتیب را تغییر می‌دهند یا چند محور مستقل variation هست، composition معمولاً coupling کمتری دارد.

### Concrete class

کلاس عینی قرارداد را کامل پیاده می‌کند و قابل ساخت است. StripeGateway نمونهٔ adapter concrete است. composition root یا factory باید وابستگی‌های حساس را پیکربندی کند؛ callerهای متعدد نباید خودشان درگاه واقعی را new کنند. interface را فقط به خاطر «شاید روزی» نساز.

### Scope و visibility

Scope محدودهٔ اعتبار نام در زبان است: block، function، module یا global. Visibility سطح دسترسی بیرونی است: private، protected، internal/package یا public. این دو مرتبط‌اند اما یکی نیستند.

از کمترین visibility لازم شروع کن. public member قرارداد پشتیبانی‌شدهٔ بیرونی می‌سازد و تغییر آن سازگاری می‌خواهد. protected هم نوعی API برای وارثان است. global mutable state ردیابی تغییر را سخت می‌کند؛ constant تغییرناپذیر خطر کمتری دارد.

## ۴. طراحی مدل‌محور و زبان مشترک

Domain model، schema ذخیره‌سازی نیست. آن، مفهوم‌ها، رفتارها، روابط و قواعد دنیای مسئله را به زبان نرم‌افزار بیان می‌کند. برای کشف آن، به جای شروع از کلاس‌ها با متخصص دامنه دربارهٔ جریان واقعی کار، استثناها، تصمیم‌های انسانی و پیامدها گفتگو کن.

### زبان مشترک (Ubiquitous Language)

واژهٔ مشترک باید در مکالمه، کد، API، آزمون و مستندات معنای سازگار داشته باشد. «لغو سفارش»، «بازپرداخت پول» و «مرجوعی کالا» سه عمل مختلف‌اند. اگر همه را cancel بنامیم، سیستم نمی‌تواند به‌خوبی وضعیت ارسال، پول و موجودی را مدیریت کند.

یک واژه‌نامهٔ کوتاه بساز اما آن را به سند مرده تبدیل نکن. مثال و counterexample اضافه کن؛ اگر دو بخش کسب‌وکار یک واژه را با معناهای متفاوت به کار می‌برند، bounded context جدا را بررسی کن و ترجمهٔ میان contextها را صریح بساز.

### Domain model غنی و مدل بی‌رفتار

مدل غنی state و قواعد را نزدیک هم نگه می‌دارد؛ مفید است وقتی invariantهای مهم یا پرتغییر داریم. مدل بی‌رفتار عمدتاً داده است و عملیات در serviceها قرار می‌گیرد؛ برای CRUD ساده، گزارش یا انتقال داده ممکن است کم‌هزینه و درست باشد.

مدل بی‌رفتار وقتی آسیب می‌زند که:
- یک قاعده در چند handler تکرار شود؛
- caller state را بخواند، تصمیم بگیرد و setter بزند؛
- transition نامعتبر از چند مسیر ممکن باشد؛
- سرویس‌های متعدد برای یک مفهوم نتایج متفاوت تولید کنند.

در چنین شرایطی مالک invariant را پیدا کن و رفتار را به آن منتقل کن. برچسب anti-pattern را کورکورانه به هر data record نزن؛ پیچیدگی واقعی را بسنج.

### Entity، value و class variant

Entity با identity پایدار و lifecycle خود شناخته می‌شود؛ ایمیل مشتری عوض شود، CustomerId همان است. Value object بر اساس مقدار معنا دارد؛ Money(100, USD) با Money(100, USD) برابر است، اما 100 USD با 100 EUR برابر نیست. value object معمولاً تغییرناپذیر است و invariant را هنگام ساخت می‌گیرد.

حالت‌ها و variantها را طوری مدل کن که ترکیب نامعتبر کم شود. دو Boolean می‌توانند چهار ترکیب بسازند که شاید فقط یکی مجاز باشد. enum، tagged union، subclass یا composition را بر اساس تعداد حالت‌ها، رفتار مستقل و جهت تغییر انتخاب کن؛ کلاس بیشتر همیشه مدل بهتر نیست.

## ۵. لایه‌بندی و جهت وابستگی

لایه‌های منطقی متداول:

1. **Presentation:** ورودی/خروجی HTTP، UI یا پیام را تبدیل می‌کند.
2. **Application:** use case را هماهنگ و transaction را مدیریت می‌کند.
3. **Domain:** مفهوم‌ها و invariantهای کسب‌وکار را نگه می‌دارد.
4. **Infrastructure:** دیتابیس، broker و providerهای خارجی را وصل می‌کند.

این لایه‌ها لزوماً process یا deploy جدا نیستند. قاعدهٔ اصلی، کنترل dependency است: domain به web framework یا ORM وابسته نشود؛ adapter بیرونی قرارداد لازم برای use case را پیاده کند. جریان فراخوانی زمان اجرا ممکن است به سمت بیرون باشد، ولی dependency source در لایهٔ domain نباید به جزئیات بیرونی جهت بگیرد.

~~~text
HTTP controller -> application use case -> domain model
infrastructure adapter implements a domain/application port
~~~

برای CRUD کوچک شاید تمام لایه‌ها نیاز نباشند. mapping و boilerplate را در برابر آزمون‌پذیری، استقلال قواعد و هزینهٔ تغییر بسنج. مرز خوب از یک تغییر واقعی محافظت می‌کند؛ پوشه‌بندی صرف به‌تنهایی معماری نمی‌سازد.

## ۶. مثال یکپارچه: ثبت سفارش

1. Controller JSON را می‌خواند و ورودی نامعتبر transport را رد می‌کند.
2. PlaceOrder یک use case است؛ موجودی، پرداخت و ذخیره‌سازی را با ترتیب روشن هماهنگ می‌کند.
3. Order خطوط و وضعیت معتبر را نگه می‌دارد؛ عملیات mark_paid و cancel transition مجاز را کنترل می‌کنند.
4. Money مقدار مبلغ و ارز را مدل می‌کند و جمع ارزهای متفاوت را رد می‌کند.
5. PaymentAuthorizer interface نیاز use case را بیان می‌کند؛ VendorPaymentAdapter خطاهای provider را به outcome دامنه‌ای تبدیل می‌کند.
6. OrderRepository قرارداد ذخیره را فراهم می‌کند؛ adapter آن در دیتابیس واقعی پیاده می‌شود.
7. آزمون unit قوانین Order و Money را بدون دیتابیس می‌سنجد؛ integration test قرارداد transaction و persistence را بررسی می‌کند.

## ۷. تصمیم‌های رایج و خطاها

| انتخاب | وقتی مناسب است | خطر/محدودیت |
| --- | --- | --- |
| Inheritance | زیرنوع قرارداد پایه را حفظ می‌کند و hierarchy پایدار است | coupling به base و override شکننده |
| Composition | behaviorها محورهای مستقل و قابل تعویض‌اند | wiring و تعداد collaborator بالا می‌رود |
| Domain model غنی | قواعد و invariantها پیچیده یا پرتغییرند | برای CRUD ساده ممکن است over-engineering باشد |
| مدل بی‌رفتار | داده ساده و عملیات محدود است | قواعد پیچیده میان serviceها پراکنده می‌شوند |
| Interface | مرز تغییر، تست یا چند implementation واقعی وجود دارد | interfaceهای ساختگی و چاق |
| لایه‌بندی | جهت وابستگی و مسئولیت‌ها مبهم/پرریسک‌اند | mapping و لایهٔ بی‌مصرف |

خطاهای رایج:

- هر noun را class کردن و هر رفتار را service کردن.
- استفاده از inheritance فقط برای reuse خطوط کد.
- ساختن interface برای هر concrete class.
- public setterهایی که invariant را دور می‌زنند.
- یک Customer یا Order جهانی برای contextهایی با معناهای متفاوت.
- جداسازی همه‌چیز به پروژه‌های متعدد بدون سنجش هزینه.

## ۸. تمرین جامع

سامانهٔ رزرو صندلی یا سفارش کالا را انتخاب کن:

1. واژه‌نامهٔ پنج اصطلاح دامنه‌ای بساز و synonym/ابهام را یادداشت کن.
2. Entity و value objectها را تعیین کن.
3. سه invariant و transition مجاز بنویس.
4. operationهای use case را از queryها جدا کن.
5. dependency diagram چهار لایه را رسم کن.
6. یک interface فقط برای مرز واقعی انتخاب کن.
7. آزمون‌های happy path، حالت نامعتبر، رقابت هم‌زمان و شکست provider را طراحی کن.
8. در یک ADR توضیح بده چه زمانی مدل ساده‌تر یا architecture متفاوت را انتخاب می‌کنی.

## ۹. کوییز جامع با پاسخ تشریحی

۱. چرا Order با setter عمومی برای state ناامن است؟
   - چون caller می‌تواند transition نامعتبر بسازد. مالک state باید operation دامنه‌ای ارائه کند و invariant را در همهٔ مسیرها کنترل کند.
۲. تفاوت abstraction و encapsulation چیست؟
   - Abstraction قرارداد قابل‌استفاده را انتخاب و جزئیات غیرضروری را پنهان می‌کند؛ encapsulation دسترسی به state و invariant را کنترل می‌کند.
۳. کی Square نباید subtype مستطیل باشد؟
   - وقتی قرارداد Rectangle انتظار تغییر مستقل عرض و ارتفاع دارد ولی Square این عملیات را محدود می‌کند؛ مصرف‌کنندهٔ پایه دیگر قابل‌استفادهٔ درست نیست.
۴. آیا هر سامانه باید rich domain model داشته باشد؟
   - نه. CRUD ساده ممکن است با record و transaction script بهتر باشد؛ قواعد stateدار/پرتغییر مدل غنی را توجیه می‌کنند.
۵. چه چیزی یک interface خوب را می‌سازد؟
   - نیاز روشن consumer، عملیات کم و معنا‌دار، ورودی/خروجی و خطای مشخص، و پرهیز از نشت SDK یا ORM.
۶. کدام وقت composition از inheritance بهتر است؟
   - وقتی چند بُعد رفتار مستقل ترکیب می‌شوند یا runtime selection لازم است و زیرنوع قرارداد پایه‌ای ندارد.
۷. آیا لایهٔ infrastructure باید با domain ارتباط بگیرد؟
   - adapter در runtime با نیازهای domain همکاری می‌کند، اما source dependency باید از adapter به قرارداد پایدار اشاره کند؛ جزئیات نباید domain را به framework گره بزند.
۸. چطور می‌فهمی مدل بی‌رفتار به مشکل تبدیل شده؟
   - قواعد تکرار و state mutation بیرونی پیدا می‌شود و invariant از هر مسیر تضمین نمی‌شود.
۹. چرا واژه‌نامه به تنهایی کافی نیست؟
   - چون زبان باید در operationها، API، آزمون و مکالمه زندگی کند و با کشف جدید به‌روز شود.
۱۰. دو Boolean در class variant چه خطری دارند؟
   - چهار ترکیب می‌سازند و ممکن است چند حالت بی‌معنا باشند؛ نوع tagged یا enum با دادهٔ وابسته، ترکیب نامعتبر را حذف می‌کند.

## منابع اختیاری

### فارسی

- [جزوهٔ برنامه‌نویسی شیءگرا](https://programmershouse.ir/Syllabus/Files/OOP.pdf)
- [راهنمای فارسی DDD](https://github.com/hheydarian/Understanding-Domain-Driven-Design)
- [درس فارسی اصول و الگوهای مهندسی نرم‌افزار](https://www.m-zakeri.ir/lab/courses/software_engineering_patterns/)

### انگلیسی

- [Microsoft Learn؛ مفاهیم OOP در C#](https://learn.microsoft.com/en-us/dotnet/csharp/fundamentals/tutorials/oop)
- [Microsoft Learn؛ طراحی microservice مبتنی بر DDD](https://learn.microsoft.com/en-us/dotnet/architecture/microservices/microservice-ddd-cqrs-patterns/ddd-oriented-microservice)



## منابع تکمیلی

[کتابخانهٔ منابع مرتبط با این فصل](../../references.md#chapter-03)
</div>
