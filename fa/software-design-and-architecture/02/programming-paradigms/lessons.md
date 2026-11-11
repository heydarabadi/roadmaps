<div dir="rtl" align="right">

# درس کامل: پارادایم‌های برنامه‌نویسی


> **زبان:** [نسخهٔ انگلیسی](../../../../en/software-design-and-architecture/02/programming-paradigms/lessons.md)

## هدف

پارادایم را سبک نحوی یا نام یک زبان تصور نکن. پارادایم می‌گوید برنامه را چگونه به اجزا تقسیم کنیم، state را کجا نگه داریم، رفتار را چگونه ترکیب کنیم و چه نوع تغییر را آسان‌تر کنیم. زبان‌هایی مانند Python، Kotlin، C# و JavaScript چندپارادایمی‌اند؛ یک سامانه می‌تواند در مرزهای مختلف از سبک‌های متفاوت استفاده کند.

در پایان این درس باید بتوانی سبک رویه‌ای، شیءگرا، تابعی و اعلانی را مقایسه کنی؛ یک مسئله را با بیش از یک سبک حل کنی؛ اثر جانبی را از محاسبه جدا کنی؛ و دلیل انتخابت را با trade-off توضیح بدهی.

## ۱. برنامه‌نویسی امری و رویه‌ای

در برنامه‌نویسی imperative، دستورها تغییرهایی را که باید انجام شوند به‌ترتیب بیان می‌کنند. در سبک procedural، این دستورها به procedure/functionها گروه‌بندی می‌شوند. برای taskهای خطی و workflowهای روشن، این سبک ساده و مستقیم است.

~~~python
def place_order(request, inventory, payments, repository):
    validate(request)
    inventory.reserve(request.items)
    payment = payments.charge(request.customer, request.total)
    order = build_order(request, payment.id)
    repository.save(order)
    return order.id
~~~

مزیت، ترتیب آشکار و سادگی دنبال‌کردن workflow است. خطر، پخش‌شدن قاعده در procedureهای زیاد و وابستگی به state تغییرپذیر است. تابع رویه‌ای بد نیست؛ وقتی قواعد در چند procedure تکرار می‌شوند یا callerها state را بی‌قید تغییر می‌دهند، باید مرزهای قوی‌تر ساخت.

## ۲. برنامه‌نویسی شیءگرا

OOP رفتار و state مرتبط را در objectها سازمان می‌دهد و همکاری را از راه پیام یا contract انجام می‌دهد. برای مفاهیمی خوب است که lifecycle و invariant دارند: حساب بانکی، سفارش، اشتراک، رزرو.

در همان سناریوی سفارش، object سفارش باید transitionهای معتبر خود را حفاظت کند؛ application use case همچنان ترتیب ارتباط با انبار، پرداخت و مخزن را هماهنگ می‌کند. OOP نباید همهٔ orchestration یا I/O را داخل entity ببرد.

استفادهٔ مناسب:
- state چند operation دارد و باید معتبر بماند؛
- رفتار و داده در طول زمان باهم تغییر می‌کنند؛
- مصرف‌کننده باید به capability متکی باشد نه جزئیات storage.

خطر:
- objectهای بزرگ و وابستگی‌های دوردست؛
- inheritance برای reuse ساده؛
- هر record به کلاس پرمتد تبدیل شود؛
- setterهای عمومی invariant را دور بزنند.

جزئیات فصل در [درس شیءگرایی](../../03/object-oriented-programming/lessons.md) آمده است.

## ۳. برنامه‌نویسی تابعی

سبک تابعی روی توابع، تبدیل داده، عدم تغییرپذیری و محدودکردن اثر جانبی تأکید می‌کند. pure function برای ورودی یکسان نتیجهٔ یکسان می‌دهد و state بیرونی را تغییر نمی‌دهد. با composition می‌توان تبدیل‌های کوچک را زنجیر کرد.

~~~python
eligible = [item for item in cart if item.is_available]
subtotal = sum(item.price_cents * item.quantity for item in eligible)
total = apply_discount(subtotal, discount_policy)
~~~

مزیت‌ها: رفتار determinisitic، آزمون ساده‌تر، parallelization و reasoning محلی. محدودیت‌ها: I/O و state واقعی باقی می‌مانند؛ مدل تغییرناپذیر ممکن است allocation و mapping بیشتر داشته باشد؛ style تابعی هم اگر تیم آن را نفهمد هزینه دارد.

الگوی خوب این است که shell بیرونی داده و effect را فراهم کند، core محاسبهٔ قابل‌تست را انجام دهد و shell نتیجه را ذخیره یا ارسال کند. این ایده به functional core / imperative shell شناخته می‌شود، اما لازم نیست برای هر برنامه معماری جداگانه بسازی.

## ۴. برنامه‌نویسی اعلانی و منطقی

در برنامه‌نویسی declarative بیشتر توصیف می‌کنی چه نتیجه‌ای می‌خواهی؛ موتور یا چارچوب تعیین می‌کند چگونه آن را به دست آورد. SQL می‌گوید کدام ردیف‌ها لازم‌اند، نه اینکه با چه حلقه‌ای تک‌تک‌شان را پیمایش کنی. HTML ساختار صفحه را توصیف می‌کند؛ CSS ظاهر را؛ rule engine یا logic programming نیز روابط و قواعد را می‌گیرد.

مثال:

~~~sql
SELECT order_id, total_cents
FROM orders
WHERE state = 'paid'
ORDER BY created_at DESC;
~~~

مزیت: intent از مکانیزم جدا می‌شود و optimizer/engine می‌تواند اجرا را تغییر دهد. هزینه: رفتار و کارایی ممکن است به query planner، framework و مدل اجرا وابسته شود؛ باید plan، semantics و failure mode را فهمید. Declarative به معنای «بدون پیچیدگی» نیست.

## ۵. مقایسه روی یک مسئله

مسئله: محاسبهٔ مبلغ نهایی سبد و ثبت پرداخت.

- **رویه‌ای:** مراحل validate، price، charge و save در use case دیده می‌شوند. برای workflow مفید است؛ اگر قوانین قیمت‌گذاری پخش شوند سخت می‌شود.
- **شیءگرا:** Order state و transition معتبر را حفظ می‌کند؛ PaymentGateway یک capability بیرونی است. برای invariant و lifecycle مناسب است؛ hierarchy زیاد می‌تواند پرهزینه شود.
- **تابعی:** line itemها به subtotal و سپس discount تبدیل می‌شوند؛ محاسبه خالص است. برای آزمون و ترکیب خوب است؛ rate و زمان باید ورودی باشند.
- **اعلانی:** SQL یا query زبان domain-specific موارد پرداخت‌شده را جست‌وجو می‌کند. برای query و rule مناسب است؛ مدل اجرا را باید شناخت.

هیچ‌کدام به تنهایی لازم نیست تمام مسئله را حل کنند. سبک‌ها را در سطحی به‌کار ببر که در آن وضوح بیشتری می‌دهند.

## ۶. چگونه پارادایم مناسب را انتخاب کنیم؟

این پرسش‌ها را به ترتیب بپرس:

۱. آیا مسئله بیشتر تبدیل داده است، lifecycle state، workflow مرحله‌ای، query یا مجموعه‌ای از rules؟
۲. کدام state mutable است و چه invariantی باید حفظ شود؟
۳. کدام اثر جانبی وجود دارد: شبکه، زمان، DB، فایل، پیام یا randomness؟
۴. کدام بخش‌ها جداگانه تغییر می‌کنند؟
۵. زبان و مهارت تیم کدام سبک را قابل‌خواندن می‌کند؟
۶. آزمون و ابزارهای موجود چگونه رفتار را مشاهده می‌کنند؟

| فشار مسئله | سبک/ابزار محتمل | هشدار |
| --- | --- | --- |
| مراحل روشن و محدود | procedure/use case | قواعد دامنه را در چند workflow تکرار نکن |
| state و invariantهای مرتبط | object/domain model | setter و inheritance را بی‌دلیل گسترش نده |
| تبدیل محض مقدارها | تابع خالص/pipeline | I/O مخفی وارد تابع نکن |
| query و constraint | زبان اعلانی مثل SQL | query plan، transaction و semantics را بفهم |
| چند نوع behavior متغیر | interface/strategy/composition | abstraction پیش از نیاز واقعی نساز |

## ۷. سوءبرداشت‌های رایج

- OOP یعنی همه‌چیز کلاس است؛ در واقع تابع و مقدار ساده ابزارهای اصلی‌اند.
- functional یعنی هیچ state یا effect وجود ندارد؛ effectها وجود دارند، ولی در مرز مدیریت می‌شوند.
- declarative یعنی ندانستن مکانیزم؛ برای performance و failure باید رفتار موتور را بفهمی.
- زبان تعیین می‌کند چه پارادایمی باید به‌کار ببری؛ بیشتر زبان‌های رایج چندسبکی‌اند.
- مخلوط‌کردن سبک‌ها همیشه بد است؛ ترکیب آگاهانه اغلب نتیجهٔ روشن‌تری دارد.

## ۸. تمرین

سیستم سادهٔ صدور فاکتور را انتخاب کن:

۱. مراحل ثبت را به سبک رویه‌ای فهرست کن.
۲. state فاکتور و transitionهای معتبر را مشخص کن.
۳. محاسبهٔ مبلغ و مالیات را به pure function تبدیل کن.
۴. یک query گزارش را به سبک declarative بنویس.
۵. بررسی کن مرزهای effect کجا قرار دارند.
۶. انتخاب‌ها را با اندازهٔ مسئله و مهارت تیم مقایسه کن؛ هر abstractionی که دلیل ندارد حذف کن.

## ۹. آزمون با پاسخ تشریحی

۱. تفاوت imperative و declarative چیست؟
   - پاسخ: imperative گام‌های اجرا و تغییر را بیان می‌کند؛ declarative نتیجه/قید را توصیف می‌کند و اجرا به engine واگذار می‌شود.
۲. تابعی به دیتابیس query می‌زند و global را افزایش می‌دهد. آیا pure است؟
   - پاسخ: خیر؛ به محیط وابسته است و state بیرونی را تغییر می‌دهد.
۳. چه چیز OOP را برای Account مناسب می‌کند؟
   - پاسخ: lifecycle، state و قواعدی مثل محدودیت برداشت باید در مسیرهای مختلف معتبر بمانند.
۴. کدام سبک برای یک workflow سه‌مرحله‌ای ساده ممکن است کافی باشد؟
   - پاسخ: procedure/use case روشن؛ مگر قواعد متغیر یا stateدار وجود داشته باشند که مرزهای بیشتری توجیه کنند.
۵. آیا functional code اثر جانبی را حذف می‌کند؟
   - پاسخ: نه؛ آن را به مرزهای قابل مشاهده منتقل می‌کند و بخش مرکزی را خالص‌تر نگه می‌دارد.
۶. چرا ترکیب پارادایم‌ها قابل قبول است؟
   - پاسخ: چون نوع مسئله‌ها متفاوت است؛ محاسبه، state، orchestration و query از ابزارهای متفاوت سود می‌برند.

## منابع اختیاری برای مطالعهٔ بیشتر

### فارسی

- [جزوهٔ برنامه‌نویسی شیءگرا](https://programmershouse.ir/Syllabus/Files/OOP.pdf)
- [آزمایشگاه مهندسی نرم‌افزار هوشمند؛ اصول و الگوها](https://www.m-zakeri.ir/lab/courses/software_engineering_patterns/)

### انگلیسی

- [Microsoft Learn؛ Object-oriented programming](https://learn.microsoft.com/en-us/dotnet/csharp/fundamentals/tutorials/oop)
- [Oracle Java Tutorials؛ Classes and Objects](https://docs.oracle.com/javase/tutorial/java/concepts/)



## منابع تکمیلی

[کتابخانهٔ منابع مرتبط با این فصل](../../references.md#chapter-02)
</div>
