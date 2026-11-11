<div dir="rtl" align="right">
[English version](../../en/02-fault-tolerance-and-replication/09-replication/README.md)


# Replication

## هدف یادگیری

- مسئله‌ای را که این مفهوم حل می‌کند تعریف کنی.
- برای یک سامانهٔ نمونه انتخاب را با trade-off توضیح بدهی.
- رفتار سیستم را هنگام اختلال پیش‌بینی کنی.

## ایدهٔ مرکزی

Replication نسخه‌های داده را برای دوام، خواندن بیشتر یا جداسازی بار نگه می‌دارد؛ هزینهٔ آن lag، هماهنگی و انتخاب رهبر است.

## نقشهٔ مفهومی

نیاز کسب‌وکار ← قرارداد بار/کیفیت ← انتخاب الگو ← نقطهٔ شکست ← مشاهده و بازیابی

## توضیح کامل

primary-replica (در واژهٔ قدیمی roadmap: master-slave) نوشتن را در رهبر می‌پذیرد. تکثیر همگام latency بالاتر و تضمین commit قوی‌تر دارد؛ ناهمگام سریع‌تر اما tail write ممکن است در failover گم شود. Multi-primary نوشتن چندگانه و conflict resolution می‌خواهد. Replica جای backup نیست؛ حذف اشتباهی هم تکثیر می‌شود.

## درس گام‌به‌گام

### Replication چه مسئله‌ای را حل می‌کند؟

Replication تغییر داده را به یک یا چند نسخهٔ دیگر منتقل می‌کند تا خواندن نزدیک‌تر/بیشتر شود یا پس از خرابی منبع دیگری برای ادامه وجود داشته باشد. این با backup فرق دارد: replication معمولاً تازه و آنلاین است، اما همان حذف اشتباه، رمزگذاری مخرب یا فساد منطقی را هم تکثیر می‌کند. backup باید retention مستقل داشته باشد و امکان restore آن جداگانه آزموده شود.

### Primary-replica و replication log

پایگاه داده تغییرها را در log پایدار (مانند WAL) ثبت می‌کند و replica آن را دریافت و اعمال می‌کند. در مدل primary-replica همهٔ نوشتن‌ها از رهبر می‌گذرد؛ این ترتیب را ساده‌تر می‌کند اما رهبر گلوگاه و failure point است. replica خواندنی می‌تواند query را بردارد، ولی latency تکثیر (replication lag) دارد. اگر کاربر بلافاصله پس از نوشتن از replica بخواند ممکن است نسخهٔ قبل را ببیند.

برای read-after-write می‌توان پس از نوشتن، session را موقتاً به primary فرستاد؛ یا token نسخه/LSN به client داد تا replica تا رسیدن آن نسخه صبر کند. مسیر fallback به primary باید محدود باشد تا همهٔ بار روی رهبر نیفتد.

### همگام یا ناهمگام؟

در synchronous replication commit معمولاً منتظر تأیید replica یا quorum می‌ماند. این کار احتمال از دست‌رفتن نوشتن تأییدشده را کاهش می‌دهد، اما latency و حساسیت به شبکه را بالا می‌برد. در asynchronous، primary سریع‌تر پاسخ می‌دهد ولی اگر قبل از رسیدن آخرین log به replica خراب شود، failover می‌تواند آن tail write را از دست بدهد. دقیقاً معلوم کن تأیید API چه چیزی را تضمین می‌کند: پایدارشدن روی دیسک primary؟ روی یک replica؟ روی quorum؟

### Multi-primary و حل تعارض

نوشتن در چند primary برای توزیع جغرافیایی جذاب است، اما دو ویرایش هم‌زمان یک رکورد می‌توانند هر دو معتبر به نظر برسند. Last-write-wins به ساعت وابسته است و ممکن است تغییر مفید را حذف کند. Conflict-free merge فقط برای داده‌هایی جواب می‌دهد که عملیاتشان قابل ادغام باشد؛ موجودی منفی یا پول برداشت‌شده را نمی‌توان با جمع ساده امن کرد. اغلب انتخاب یک مالک برای هر key یا region ساده‌تر است.

### Lag و سلامت replica

lag را فقط با تعداد log bytes نسنج؛ مدت تأخیر برای freshness کاربر مهم‌تر است. replica ممکن است زنده باشد ولی عقب‌مانده، read-only یا در حال apply یک transaction بزرگ باشد. health check مصرف‌پذیری، lag، ظرفیت دیسک و وضعیت replication را نشان دهد. در failover replica عقب‌مانده ممکن است data loss بیشتری از RPO مجاز داشته باشد و نباید خودکار انتخاب شود.

### Failover و split-brain

وقتی primary از شبکه جدا می‌شود، standby نباید صرفاً با timeout فعال شود؛ شاید primary هنوز به client دیگری پاسخ دهد. quorum، lease و fencing token کمک می‌کنند فقط رهبر جدید حق نوشتن داشته باشد. پس از promotion، endpointهای قدیمی باید بسته یا رد شوند. هر failover باید مقدار واقعی replication lag و رکوردهای احتمالی ازدست‌رفته را ثبت کند.

## مثال عملی

کاتالوگ می‌تواند از replica نزدیک خوانده شود؛ ledger معمولاً نوشتن مرجع واحد یا پروتکل هماهنگی نیاز دارد.

## نمونهٔ قرارداد / شبه‌کد

~~~text
پس از نوشتن سفارش، کاربر را تا همگرایی کوتاه به primary یا session-consistent مسیر بده.
~~~

## تجربهٔ موردی واقعی منتشرشده

[Uber Herb: replication میان دیتاسنترها](https://www.uber.com/us/en/blog/herb-datacenter-replication/) — مطالعهٔ موردی عمومی است؛ آن را با نسخه و محدودیت‌های زمان انتشار بخوان.

## تجربهٔ عملی و تصمیم‌های معماری

نمونهٔ مهندسی برای مطالعه: [Amazon Builders Library](https://aws.amazon.com/builders-library/)

read replica برای بار خواندن؛ backup آفلاین و restore drill برای بازیابی؛ multi-primary تنها با conflict policy روشن.

| تصمیم | چه زمانی مناسب است | کجا پرریسک می‌شود |
| --- | --- | --- |
| راه‌حل ساده | بار و دامنه محدود، رفتار قابل‌اندازه‌گیری | نیاز اثبات‌شدهٔ چندمنطقه‌ای یا حد ظرفیت |
| الگوی توزیع‌شده | نیاز روشن به جداسازی، ظرفیت یا دوام | پیچیدگی عملیاتی از سود بیشتر شود |

## دام‌ها و سوءبرداشت‌ها

- replica lag؛ promotion بدون fencing؛ نبود backup؛ خواندن تازه از replica عقب‌مانده.
- عددهای مثال آموزشی‌اند؛ SLO و ظرفیت نهایی را از دادهٔ واقعی تعیین کن.

## آزمون کوتاه

1. Replication و backup چه تفاوتی دارند؟
2. در async failover چه چیزی ممکن است از دست برود؟
3. چطور read-your-writes حفظ می‌شود؟

### پاسخ‌نامهٔ فشرده

1. Replication نسخهٔ آنلاین را تکثیر می‌کند؛ backup نسخهٔ قابل‌بازیابیِ جدا/زمان‌مند است و خطای منطقی را خنثی می‌کند.
2. نوشتن‌هایی که هنوز از primary به replica نرسیده‌اند.
3. مسیر خواندن تازه را موقتاً به primary ببَر یا نسخهٔ آخرین نوشتن را با replica مقایسه کن.

## تمرین

برای یک فروشگاه اینترنتی، مسیر درخواست این مفهوم را رسم کن. منبع حقیقت، مرز شبکه، رفتار شکست، دادهٔ حساس، معیار پایش و راه بازگشت را مشخص کن. سپس یک آزمون خرابی بنویس که بتواند فرض اصلی را رد کند.

## خلاصه

Replication نسخه‌های داده را برای دوام، خواندن بیشتر یا جداسازی بار نگه می‌دارد؛ هزینهٔ آن lag، هماهنگی و انتخاب رهبر است. پیش از پیاده‌سازی رفتار عادی، حالت اختلال و معیار موفقیت را ثبت کن.

## مبنای roadmap

- [System Design Roadmap — نسخهٔ تعاملی](https://roadmap.sh/system-design)
- [PDF رسمی roadmap.sh با شاخه‌ها و ریزموضوع‌ها](https://roadmap.sh/pdfs/roadmaps/system-design.pdf)

### مقالهٔ فارسی

- [Kafka و سیستم‌های توزیع‌شده](https://www.dntips.ir/post/2822)

### منابع انگلیسی و تجربه‌های مهندسی

- [PostgreSQL: Streaming Replication](https://www.postgresql.org/docs/current/warm-standby.html)
- [Amazon Dynamo paper](https://www.allthingsdistributed.com/files/amazon-dynamo-sosp2007.pdf)
- [Amazon Builders Library](https://aws.amazon.com/builders-library/)

</div>

