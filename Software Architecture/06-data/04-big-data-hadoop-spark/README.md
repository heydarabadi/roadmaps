<div dir="rtl" align="right">

# Hadoop، MapReduce و Spark

Big data مسئلهٔ حجم، سرعت، تنوع یا هزینهٔ پردازش داده است؛ انتخاب Hadoop یا Spark باید از workload و نگهداری بیاید. MapReduce داده را به ورودی‌های partitionشدهٔ map و نتایج reduce تقسیم می‌کند و برای پردازش‌های دسته‌ای بزرگ مناسب است. Hadoop مجموعه‌ای از اجزاست، از جمله HDFS و YARN؛ Spark engine پردازش توزیع‌شده است و می‌تواند روی cluster managerهای مختلف اجرا شود.

Spark DataFrame/SQL API، batch و structured streaming را پشتیبانی می‌کند؛ حافظه‌محوربودن ویژگی عمومی تضمین‌شده برای هر query نیست. shuffle، skew، partition، serialization و اندازهٔ executor عملکرد را تغییر می‌دهند. Pipeline باید schema، late data، checkpoint، retry و idempotent sink داشته باشد.

## MapReduce را مرحله‌به‌مرحله بفهمیم

برای شمارش بازدید کالا از clickstream:

۱. فایل به partitionهای مستقل تقسیم می‌شود.
۲. mapper ردیف‌ها را parse می‌کند و زوج کلید/مقدار مثل (productId, 1) تولید می‌کند.
۳. shuffle مقدارهای یک کلید را میان workerها جمع می‌کند؛ شبکه و دیسک مصرف می‌شود و کلید بسیار محبوب می‌تواند skew بسازد.
۴. reducer مقدارها را جمع و نتیجه را به sink می‌نویسد.

task ممکن است پس از شکست دوباره اجرا شود؛ خروجی نباید دوبرابر شود. خروجی partitionشده، checkpoint و sink idempotent برای درستی pipeline اهمیت دارند.

## Hadoop و Spark

Hadoop اکوسیستمی شامل HDFS برای فایل توزیع‌شده، YARN برای تخصیص منابع cluster و MapReduce برای batch کلاسیک است. Spark engine پردازش توزیع‌شده با APIهای DataFrame/SQL و streaming است. داده گاهی در حافظه می‌ماند و گاهی spill می‌شود؛ این به plan، حجم و منابع بستگی دارد. ادعای «همیشه in-memory و سریع» معیار انتخاب نیست.

## Spark: از کد تا اجرا

کد DataFrame یک DAG منطقی می‌سازد؛ optimizer آن را ساده می‌کند؛ stage و task بر اساس مرز shuffle اجرا می‌شوند. فیلتر زودهنگام و انتخاب ستون کمتر، دادهٔ جابه‌جا‌شده را کم می‌کند. join دو جدول بزرگ معمولاً shuffle دارد؛ broadcast فقط وقتی سمت کوچک در حافظه جا شود مناسب است. skew یک کلید یک task را کند می‌کند.

در Spark UI زمان task، shuffle read/write، spill، executor memory، skew و تعداد partition را ببین. partition خیلی کم concurrency را کم می‌کند؛ تعداد خیلی زیاد سربار scheduling و فایل ریز می‌سازد.

## Structured Streaming و تحویل

Streaming معمولاً batchهای کوچک را با checkpoint هماهنگ می‌کند. watermark حد زمانی پذیرش دادهٔ دیررس را کنترل می‌کند؛ کوتاه باشد داده می‌افتد و بلند باشد state بیشتری می‌ماند. checkpoint نقطهٔ پیشرفت است، اما exactly-once انتها‌به‌انتها به source و sink وابسته است؛ sink غیرقابل‌تکرار ممکن است اثر را دوباره اعمال کند.

## انتخاب معماری big data

پیش از cluster، حجم، رشد، SLA، latency، schema، replay، sink، هزینهٔ شبکه و storage، مهارت تیم و بار on-call را اندازه بگیر. برای حجم کم، DB یا job مدیریت‌شده شاید کافی باشد. Spark یا Hadoop وقتی سود دارند که موازی‌سازی و حجم، پیچیدگی و هزینه را توجیه کند.

## تجربهٔ صنعتی

سیستم‌های ETA، کشف تقلب و تحلیل clickstream به جریان داده و پردازش چندمرحله‌ای نیاز دارند. تجربه‌های منتشرشدهٔ Uber در زیرساخت real-time data نشان می‌دهند معماری pipeline، routing و نگهداری جریان داده خود مسئلهٔ مقیاس است؛ راه‌حل از workload آن‌ها جداشدنی نیست.

## آزمون

۱. MapReduce دو مرحلهٔ اصلی چه هستند؟ **پاسخ:** map روی بخش‌های ورودی و reduce برای تجمیع نتایج.
۲. Spark چه چیزی را جادویی سریع نمی‌کند؟ **پاسخ:** query بد، skew شدید، shuffle پرهزینه یا sink گلوگاهی را.
۳. checkpoint چه هدفی دارد؟ **پاسخ:** ادامه یا بازیابی محاسبهٔ جریان از نقطهٔ ثبت‌شده.
۴. قبل از انتخاب framework چه باید دانست؟ **پاسخ:** حجم، latency، schema، SLA، مهارت تیم، sink و هزینهٔ اجرا.

## تمرین

جریان رویداد مشاهدهٔ کالا را به شمارش دقیقه‌ای تبدیل کن. کلید partition، late event، checkpoint و sink را مشخص کن.

## پاسخ نمونهٔ تمرین

برای شمارش دقیقه‌ای، کلید partition مثلاً productId یا hash آن است؛ event time از client به تنهایی قابل‌اعتماد نیست. watermark پنجرهٔ دیررسی و هزینهٔ state را تنظیم می‌کند. checkpoint پیشرفت source و state را نگه می‌دارد. sink با upsert کلید (product, minute) یا batch اتمی تکرار را بی‌اثر می‌کند. metricها lag، late-drop، skew و sink errors را دنبال می‌کنند.

## منابع

- فارسی: [مبانی معماری فارسی: داده و تحلیل](https://www.alirostami.com/software-architecture/)، [دوره‌ها و منابع داده](https://codingcogs.org/road-maps/software-architecture)
- انگلیسی: [Apache Spark Documentation](https://spark.apache.org/docs/latest/)، [Structured Streaming](https://spark.apache.org/docs/latest/streaming/index.html)، [Real-time Data Infrastructure at Uber](https://arxiv.org/abs/2104.00087)

</div>
