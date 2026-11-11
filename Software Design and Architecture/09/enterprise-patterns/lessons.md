<div dir="rtl" align="right">

# درس کامل: الگوهای سازمانی


> **زبان:** [نسخهٔ انگلیسی](../../en/09/enterprise-patterns/lessons.md)

## جایگاه الگوهای سازمانی

الگوهای سازمانی ساختارهای پرتکراری برای منطق application، انتقال داده و persistence هستند. بسیاری از آن‌ها در کاتالوگ Martin Fowler مستند شده‌اند. انتخابشان تابع پیچیدگی دامنه و شکل query/transaction است؛ به‌کاربردن همهٔ آن‌ها در هر feature معماری را بهتر نمی‌کند.

ابتدا این سه مدل را از هم جدا کن:

- **Domain model:** معنا، رفتار و invariantهای کسب‌وکار.
- **Persistence model:** شکل و محدودیت ذخیره‌سازی.
- **Transport/view model:** داده‌ای که API، UI یا message می‌گیرد.

گاهی یک type ساده می‌تواند چند نقش را بی‌خطر انجام دهد؛ در سامانهٔ حساس یا پرتغییر، یکی‌کردن مدل‌ها leakage و coupling می‌سازد.

## ۱. DTO

Data Transfer Object داده را از یک boundary عبور می‌دهد. هدفش API سطحی، serialization یا انتقال داده است؛ لازم نیست entity دامنه باشد. DTO را بر اساس مصرف‌کننده و security طراحی کن: فقط field لازم را بده، دادهٔ داخلی را پنهان کن، versioning را در نظر بگیر و validation مرز را انجام بده.

~~~python
@dataclass(frozen=True)
class OrderSummaryDto:
    order_id: str
    total_cents: int
    currency: str
~~~

بازگرداندن entity یا ORM graph از API می‌تواند data حساس، lazy-loading و رابطه‌های داخلی را افشا کند. DTO زیاد هم mapping و version drift می‌آورد؛ اگر مدل ساده و فقط‌خواندنی است، جداسازی را بر اساس ریسک واقعی بسنج.

## ۲. Identity Map

Identity Map در یک unit of work تضمین می‌کند یک هویت/شناسه به یک instance در حافظه نگاشت شود. اگر Customer با شناسهٔ یکسان دوبار query شود، دو نسخهٔ مستقل mutable نگیریم که تغییرشان با هم ناسازگار باشد. ORMها معمولاً در scope یک context/session چنین رفتاری دارند.

این الگو global cache نیست. عمر آن را به transaction/request یا unit of work محدود کن؛ cache سراسری مسئلهٔ invalidation، race و stale state دارد. دیتابیس concurrency و identity مستقل از object reference دارند.

## ۳. Use Case

Use case یک هدف قابل مشاهدهٔ کاربر/سامانه را هماهنگ می‌کند: ثبت سفارش، لغو رزرو، بازپرداخت. ورودی و خروجی application را تعریف می‌کند و transaction boundary، authorization check یا workflow را مدیریت می‌کند. قواعد domain باید به object/policy دامنه‌ای واگذار شوند تا use case به script نامنسجم تبدیل نشود.

یک use case می‌تواند مراحل اعتبارسنجی، بارگذاری aggregate، فراخوانی behavior، ذخیره و انتشار پیام را هماهنگ کند. وابستگی شبکه و دیتابیس را مستقیم در آن پنهان نکن؛ failure و retry اثر دارند.

## ۴. Repository

Repository مجموعه‌ای از aggregateها یا objectهای دامنه را از دید مصرف‌کننده بازیابی و ذخیره می‌کند. هدف جداسازی query/persistence detail از use case است، نه ساخت یک CRUD class برای هر جدول.

~~~text
OrderRepository:
  get(order_id)
  save(order)
~~~

اگر interface همهٔ SQL و queryهای ad-hoc را مجبور به abstraction عمومی کند، مصرف‌کننده‌ها به امکانات واقعی storage نیاز دارند. Repository هم transaction manager یا ORM را جایگزین نمی‌کند؛ عمر unit of work و transaction باید روشن باشد.

## ۵. Data Mapper

Data Mapper بین objectها و دیتابیس ترجمه می‌کند، بدون اینکه دو مدل به هم وابسته شوند. Mapper تبدیل mapping و identity/relationships را انجام می‌دهد؛ دامنه نباید مجبور باشد schema table را تکرار کند. ORM اغلب Data Mapper را پیاده می‌کند، هرچند جزئیات framework فرق دارد.

mapping ممکن است اطلاعات گم کند، null را غلط تعبیر کند یا N+1 query بسازد. تست mapping برای invariantها، precision پول/زمان و relationها لازم است. AutoMapper جای فهم قرارداد را نمی‌گیرد.

## ۶. Transaction Script

Transaction Script منطق یک use case را به رویه‌ای می‌سپارد که یک transaction را کنترل می‌کند. برای CRUD و قواعد محدود، ساده و مؤثر است: ثبت پرداخت، update status و نوشتن audit داخل یک unit.

وقتی قواعد در چند script کپی می‌شوند یا هر اسکریپت invariant را متفاوت اجرا می‌کند، domain model غنی یا domain service را بررسی کن. برعکس، برای فرم تنظیمات ساده aggregate پیچیده نساز. معیار، تغییر و پیچیدگی قواعد است.

## ۷. Command و Query

Command درخواست تغییر state است و معمولاً outcome یا شناسه برمی‌گرداند؛ query اطلاعات می‌دهد و state دامنه را عوض نمی‌کند. این تفکیک CQS را در API نیز روشن می‌کند.

Command باید مجوز، validation، idempotency و failure واضح داشته باشد. Query می‌تواند projection مختصر و cacheable بدهد. Query نباید زیر نام read، command پنهان اجرا کند؛ side effect فنی مانند logging را هم از mutation دامنه تفکیک کن.

اگر مدل خواندن و نوشتن به شکل جدی متفاوت شد، CQRS را بررسی کن؛ صرف جداکردن handlerها CQRS کامل یا نیازمند دو database نیست.

## ۸. Value Object

Value Object هویت مستقل ندارد و با مقدار/معنایش برابر است. Money شامل amount و currency است؛ EmailAddress می‌تواند نرمال‌سازی و اعتبار پایه را هنگام ساخت انجام دهد. Value object عموماً immutable است تا تغییر پنهان و hash/equality ناپایدار نشود.

~~~python
@dataclass(frozen=True)
class Money:
    amount_cents: int
    currency: str

    def add(self, other):
        if self.currency != other.currency:
            raise ValueError("Currencies must match")
        return Money(self.amount_cents + other.amount_cents, self.currency)
~~~

نوع‌های دامنه‌ای زیاد mapping و serialization می‌آورند؛ برای هر رشتهٔ ساده type نساز مگر معنا، validation یا عملیات مشخص داشته باشد.

## ۹. Domain Model و Entity

Domain model رفتار و قوانین را کنار هم نگه می‌دارد. Entity هویت پایدار و lifecycle دارد؛ برابری آن با مقدار همهٔ propertyهای mutable تعریف نمی‌شود. Customer emailش را عوض می‌کند اما همچنان همان CustomerId است.

Aggregate root مرز consistency و دسترسی تغییرات داخل aggregate را کنترل می‌کند. Query model و entity یکسان بودن لازم ندارند. Domain event حقیقتی مانند OrderPaid ثبت می‌کند، نه صرفاً log اینکه تابع اجرا شده است.

مدل بی‌رفتار برای CRUD ساده کافی است؛ برای قواعد متغیر مثل سقف برداشت یا eligibility لغو، behavior را در owner نگه دار. تشخیص باید بر مبنای invariant و پراکندگی تغییر باشد.

## ۱۰. ORM

Object-Relational Mapper objectها را به rowها و رابطه‌های relational نگاشت می‌کند و query, unit of work, identity tracking و transaction را فراهم می‌کند. ORM سرعت توسعه می‌دهد، اما تفاوت object graph و relation را حذف نمی‌کند.

### خطرهای رایج

- N+1: یک query برای فهرست و query جدا برای هر سطر.
- lazy load ناخواسته پس از بسته‌شدن transaction.
- tracking و state قدیمی.
- transaction طولانی یا lock نامنتظر.
- مدل domain وابسته به attribute/base class ORM.
- query سنگین که خروجی مطلوبش با entity graph مناسب نیست.

رفتار SQL generated، query plan و transaction را ببین. برای read/report بزرگ، projection یا SQL مستقیم ممکن است روشن‌تر باشد؛ ORM را ابزار بگیر نه قرارداد معماری کل سامانه.

## ۱۱. سناریوی سفارش end-to-end

1. HTTP body به PlaceOrder command/DTO تبدیل می‌شود.
2. use case مجوز، transaction و workflow را هماهنگ می‌کند.
3. repository aggregate Order را بار می‌کند یا می‌سازد.
4. domain model invariant کالا/مبلغ/وضعیت را بررسی می‌کند.
5. Money value object قواعد پول را نگه می‌دارد.
6. ORM یا mapper ذخیره‌سازی را اجرا می‌کند؛ transaction commit می‌شود.
7. API یک OrderReceipt DTO برمی‌گرداند.
8. query summary می‌تواند projection جداگانه بسازد.

اگر هر مرحله فقط داده را بدون تغییر معنا پاس می‌دهد، تعداد abstractionها را کم کن. اگر هر مرز مسئولیت و قرارداد روشنی دارد، جداسازی ارزش دارد.

## ۱۲. آزمون با پاسخ

۱. DTO با entity چه تفاوتی دارد؟
   - پاسخ: DTO برای مرز انتقال داده است؛ entity هویت، lifecycle و رفتار دامنه دارد.
۲. Identity Map چه بازه‌ای باید داشته باشد؟
   - پاسخ: معمولاً unit of work/session محدود؛ نه cache سراسری بی‌حد.
۳. Repository چه مشکلی را حل می‌کند و چه چیزی نیست؟
   - پاسخ: contract collection-like برای persistence دامنه؛ نه الزاماً CRUD هر جدول یا transaction manager.
۴. Transaction Script چه زمانی ساده‌تر است؟
   - پاسخ: use case با قواعد محدود و یک transaction روشن، بدون invariantهای پیچیدهٔ چندعملیاتی.
۵. Money چرا Value Object است؟
   - پاسخ: معنا به مقدار و ارز بستگی دارد، نه identity مستقل؛ رفتار جمع/برابری و invariant ارز دارد.
۶. Entity چرا با همهٔ فیلدها برابر نیست؟
   - پاسخ: بعضی فیلدها در lifecycle تغییر می‌کنند؛ هویت پایدار با identifier تعریف می‌شود.
۷. ORM چه چیزی را حذف نمی‌کند؟
   - پاسخ: نیاز به فهم query plan, transaction, relation, N+1 و هزینهٔ mapping.
۸. چه وقت DTO جدا لازم نیست؟
   - پاسخ: وقتی مدل ساده، read-only و بدون security/versioning risk است؛ duplication هزینهٔ بیشتری می‌آورد.

## تمرین جامع: طراحی ثبت سفارش

برای endpoint ثبت سفارش، boundary و مدل‌ها را طراحی کن. درخواست HTTP شامل CustomerId و چند قلم کالا است؛ سفارش باید معتبر ذخیره شود و پاسخ فقط شمارهٔ سفارش و مبلغ نهایی را بدهد.

**کارها**
1. DTO، command، entity و value object را از هم جدا کن.
2. مسئولیت use case، repository و transaction را بنویس.
3. محل validation و mapping را مشخص کن.

**پاسخ تشریحی:** request DTO فقط ورودی مرزی را منتقل می‌کند؛ mapper آن را پس از validation اولیه به PlaceOrder command تبدیل می‌کند. use case مشتری و کالا را بررسی می‌کند، Order entity را می‌سازد و قواعد وضعیت/تعداد را اعمال می‌کند. Money ارز و محاسبه را معتبر نگه می‌دارد. repository aggregate سفارش را ذخیره می‌کند و unit of work transaction را commit می‌کند. پاسخ OrderReceipt DTO است و entity داخلی را serialize نمی‌کند. اگر قواعد فقط چند گام ساده و بدون invariant پیچیده بودند، transaction script کافی بود؛ رشد قواعد دلیل انتقال تدریجی آن‌ها به domain model است.

## منابع اختیاری

- [Martin Fowler؛ کاتالوگ الگوهای Enterprise Application](https://martinfowler.com/eaaCatalog/index.html)
- [Microsoft Learn؛ DDD-oriented microservice](https://learn.microsoft.com/en-us/dotnet/architecture/microservices/microservice-ddd-cqrs-patterns/ddd-oriented-microservice)
- [راهنمای فارسی DDD](https://github.com/hheydarian/Understanding-Domain-Driven-Design)



## منابع تکمیلی

[کتابخانهٔ منابع مرتبط با این فصل](../../references.md#chapter-09)
</div>
