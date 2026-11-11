<div dir="rtl" align="right">

# Time Series و ساختارهای احتمالی

> English edition: [Redis Time Series and Probabilistic Data Structures](README.en.md)

> مسیر: فصل ۱۰، ساختارهای دادهٔ جدید · سطح: میانی · زمان مطالعه و تمرین: ۹۰ تا ۱۴۰ دقیقه
>
> این درس دربارهٔ دو خانوادهٔ متفاوت است: سری زمانی دادهٔ دقیقِ زمان‌دار را نگه می‌دارد؛ ساختارهای احتمالی خلاصه‌هایی کوچک و تقریبی از مجموعه/جریان می‌سازند. آن‌ها را با هم اشتباه نگیر.

## پیش‌نیاز و هدف یادگیری

پیش از این درس باید کلید/TTL، نوع‌های Redis، دستورهای `SCAN` و مفهوم حافظه را بشناسی. در پایان می‌توانی:

- نمونهٔ اندازه‌گیری را با timestamp ثبت و بازهٔ زمانی را پرس‌وجو کنی.
- retention، برچسب‌گذاری، duplicate policy و downsampling را برای یک workload طراحی کنی.
- Bloom/Cuckoo، Count-Min Sketch، Top-K و t-digest را از نظر نوع سؤال و خطای احتمالی از هم جدا کنی.
- بگویی کدام تصمیم را نباید بر یک دادهٔ تقریبی بنا کرد.
- اندازه‌گیری‌های تمرینی را اجرا کنی، خروجی را تفسیر کنی و خطاهای رایج را پیدا کنی.

## ۱. سری زمانی چیست؟

سری زمانی دنباله‌ای از زوج‌های **(زمان، مقدار)** است؛ مثلاً `(2026-11-11 10:00:00, 23.4°C)`. Redis Time Series این داده را به‌صورت نوع تخصصی نگه می‌دارد و دستورهایی برای نوشتن، بازه‌خوانی، فیلتر با label و تجمیع دوره‌ای دارد.

timestamp در دستورها عدد صحیح میلی‌ثانیه از Unix epoch است؛ `*` یعنی ساعت سرور. یک key سری زمانی معمولاً یک اندازه‌گیری/سری مشخص است. labelهایی مثل `site=tehran`, `sensor=temp`, `unit=celsius` کمک می‌کنند از میان چند سری، مجموعهٔ مورد نظر را انتخاب کنی.

**نکتهٔ نسخه:** قابلیت Time Series از ابتدا یک قابلیت ماژولی بوده و در Redis Open Source 8 در بستهٔ یکپارچهٔ Redis آمده است. در نصب‌های قدیمی‌تر ممکن است RedisTimeSeries module یا بستهٔ Stack لازم باشد. وجود فرمان را روی همان endpoint با `COMMAND INFO TS.CREATE` یا `TS.CREATE` کنترل کن؛ «در مستندات هست» تضمین نمی‌کند که binary نصب‌شده آن را دارد.

## ۲. ایجاد، درج و خواندن

برای مثال‌های قابل تکرار timestamp ثابت به‌کار می‌بریم؛ در سیستم واقعی timestamp را از منبع اندازه‌گیری/رویداد بگیر و تفاوت ساعت دستگاه و سرور را در نظر بگیر.

```text
DEL lab:ts:temp:1 lab:ts:temp:2 lab:ts:temp:1m
TS.CREATE lab:ts:temp:1 RETENTION 86400000 DUPLICATE_POLICY LAST LABELS site tehran sensor temperature unit celsius
TS.ADD lab:ts:temp:1 1794384000000 23.4
TS.ADD lab:ts:temp:1 1794384060000 23.8
TS.ADD lab:ts:temp:1 1794384120000 24.1
TS.RANGE lab:ts:temp:1 1794384000000 1794384120000
TS.INFO lab:ts:temp:1
```

`RETENTION 86400000` یعنی نگه‌داشتن حداکثر یک روز از دادهٔ قدیمی‌تر نسبت به آخرین timestamp ثبت‌شده؛ صفر یا حذف تنظیم در بسیاری از تنظیم‌ها به معنی بدون retention است. retention را با نیاز تحلیل و ظرفیت انتخاب کن، نه حدس. در ورود دیرهنگام داده، retention نسبت به آخرین زمان سری اهمیت دارد.

دوباره ثبت کردن timestamp یکسان، مسئلهٔ **duplicate** است. policy می‌تواند بلوکه کند یا مقدار قبلی/بعدی را انتخاب کند یا تجمیع‌هایی مثل min/max/sum را به‌کار ببرد؛ نام دقیق policy و رفتار محصول را برای نسخهٔ خود بخوان. `ON_DUPLICATE` برای یک درج می‌تواند policy همان فرمان را عوض کند. اگر دادهٔ تکراری در واقع retry است، `LAST` ممکن است خوب باشد؛ اگر دو دستگاه برای یک زمان گزارش می‌دهند، overwrite شاید دادهٔ واقعی را پنهان کند.

برای خواندن عقب‌رو یا بازهٔ کوچک از `TS.RANGE` و `TS.REVRANGE` استفاده می‌شود. `TS.MRANGE` چند سری را با فیلتر label می‌خواند:

```text
TS.CREATE lab:ts:temp:2 RETENTION 86400000 LABELS site tehran sensor temperature unit celsius
TS.ADD lab:ts:temp:2 1794384000000 21.2
TS.ADD lab:ts:temp:2 1794384060000 21.6
TS.MRANGE 1794384000000 1794384060000 WITHLABELS FILTER site=tehran sensor=temperature
```

`WITHLABELS` metadata سری‌ها را نیز در پاسخ می‌آورد. برای بارهای بزرگ تعداد سری، اندازهٔ بازه و خروجی را محدود کن. label باید برای دسته‌بندی مفید باشد؛ برچسبی با مقدار یکتا برای هر sample (مثلاً شناسهٔ UUID هر درخواست) cardinality را بی‌جهت زیاد می‌کند.

## ۳. Aggregation و downsampling

برای dashboard معمولاً لازم نیست هر sample خام را برای همیشه نگه داری. **Aggregation در query** همان لحظهٔ خواندن bucketها را محاسبه می‌کند. **Compaction rule** هنگام ورود داده، سری خلاصه‌شدهٔ دیگری می‌سازد؛ بنابراین در برابر هزینهٔ نوشتن و حافظه، query تاریخی کم‌حجم‌تری می‌گیری.

```text
TS.RANGE lab:ts:temp:1 - + AGGREGATION avg 60000
TS.CREATE lab:ts:temp:1m RETENTION 2592000000 LABELS site tehran sensor temperature resolution 1m
TS.CREATERULE lab:ts:temp:1 lab:ts:temp:1m AGGREGATION avg 60000
```

نمونهٔ دوم یک سری یک‌دقیقه‌ای برای نگهداری ۳۰روزه می‌سازد؛ rule منبع را به مقصد وصل می‌کند و bucketهای کامل را خلاصه می‌کند. معمولاً آخرین bucket ناتمام هنوز نهایی نشده است. قاعده را پیش از بارگیری داده تعیین کن و فقط raw را حذف/کوتاه نکن تا مطمئن شوی مقصد compaction برای نیاز بازسازی و تحلیل کافی است.

تجمیع `avg` برای نمودار دما ممکن است مفید باشد، ولی برای peak latency ممکن است پیک کوتاه را محو کند؛ `max` یا percentile تقریباً مناسب‌تر است. برای metricهای شمارشی، `sum` می‌تواند درست باشد؛ برای counter تجمعی، قبل از جمع‌زدن باید افزایش/ریست counter را مدل کنی. bucket alignment، timezone گزارش، مرزهای بازه و sampleهای دیررس را مشخص کن.

نمونهٔ چندسری با تجمیع یک‌دقیقه‌ای:

```text
TS.MRANGE 1794384000000 1794384120000 WITHLABELS AGGREGATION avg 60000 FILTER site=tehran sensor=temperature
```

## ۴. الگوی مهندسی سری زمانی

فرض کن ۵۰هزار دستگاه هر ۱۰ ثانیه دما می‌فرستند:

1. **کلید:** `telemetry:{device-42}:temperature` یا قالب دیگری که با cluster placement و query pattern سازگار باشد.
2. **timestamp:** زمان اندازه‌گیری UTC، نه زمان رسیدن پیام؛ در کنار آن اختلاف ساعت و timestampهای آینده را پایش کن.
3. **retention:** مثلاً raw یک هفته و aggregate ساعتی شش ماه؛ اعداد واقعی را با نیاز حقوقی/تحلیلی تعیین کن.
4. **label:** `region`, `kind`, `firmware`؛ label با هزاران/میلیون‌ها مقدار یکتا می‌تواند index و memory را سنگین کند.
5. **دادهٔ دیررس/تکراری:** رویداد را با timestamp خودش درج کن؛ policy تکراری را بر اساس semantics تعیین کن؛ برای داده‌های خارج از ترتیب، روی نسخهٔ خود آزمایش کن.
6. **از دست‌رفتن داده:** سری زمانی در Redis لزوماً جایگزین data lake یا پایگاه تحلیلی ماندگار نیست. اگر گزارش قانونی یا بازسازی دقیق لازم است، منبع ماندگار دیگری و مسیر replay داشته باش.
7. **ظرفیت:** نرخ sample × تعداد device × retention خام، تعداد keyها، labelها و ruleها را اندازه بگیر؛ با دادهٔ نماینده benchmark کن.

برای موارد بسیار حجیم، retention طولانی و scanهای تحلیلی، Redis را با سامانه‌هایی مثل VictoriaMetrics/Prometheus, TimescaleDB, ClickHouse یا سرویس ابری مقایسه کن. معیار انتخاب شامل ingest rate، query shape، compression, durability, cost, operational burden و data export است؛ صرف سرعت یک دستور، برتری end-to-end را ثابت نمی‌کند.

## ۵. ساختار احتمالی: پاسخ سریع با عدم‌قطعیت شناخته‌شده

ساختار احتمالی خلاصه‌ای با حافظهٔ کمتر از نگهداری تک‌تک آیتم‌هاست. نتیجه دقیقاً معادل مجموعه/جدول اصلی نیست. پیش از استفاده این قرارداد را بنویس:

- سؤال دقیق چیست؟ «ممکن است دیده باشم؟»، «چند بار دیده‌ام؟»، «پرتکرارترین‌ها کدام‌اند؟»، «p99 تقریباً چند است؟»
- ظرفیت، بازهٔ زمانی و نرخ داده چقدر است؟
- خطای قابل‌قبول چیست و اگر خطا رخ داد چه زیانی می‌دهد؟
- آیا حذف/فهرست‌کردن عضوها/حساب دقیق لازم است؟
- آیا خلاصه باید reset شود یا بین shardها merge شود؟

| نوع | چه چیزی را تقریبی می‌کند؟ | محدودیت ذهنی مهم |
| --- | --- | --- |
| Bloom Filter | احتمال حضور/عدم حضور | «نه» قطعی است؛ «بله» ممکن است false positive باشد؛ عضوها را فهرست نمی‌کند و حذف مستقیم عضو ندارد. |
| Cuckoo Filter | احتمال حضور | معمولاً حذف عضو را پشتیبانی می‌کند؛ خطا و ظرفیت دارد؛ جایگزین set دقیق نیست. |
| Count-Min Sketch | فراوانی itemها | شمارش معمولاً overestimate می‌شود؛ نمی‌توان از مقدار تخمینی نتیجهٔ دقیق گرفت. |
| Top-K | آیتم‌های پرتکرار | نگهداری/رتبه‌بندی تقریبی و محدود به k مورد؛ مناسب leaderboard تحلیلی، نه رتبه‌بندی مالی قطعی. |
| t-digest | quantile/percentile توزیع عددی | تخمین percentile است؛ رفتار خطا به داده/تنظیم/merge وابسته است. |
| HyperLogLog | تعداد عضوهای متمایز | فقط cardinality تقریبی؛ جزئیات عضوها یا مجموعهٔ exact را برنمی‌گرداند. درس [HyperLogLog](../../04-advanced-features/hyperloglog/README.md) را هم ببین. |

«احتمالی» به معنی تصادفیِ بی‌قاعده نیست. خطا یک ویژگی طراحی‌شده/محدودشده است، اما باید پارامترهای ظرفیت و احتمال را متناسب با workload انتخاب کنی و خروجی را با منبع exact نمونه‌برداری کنی.

## ۶. Bloom و Cuckoo: آیا قبلاً دیده‌ایم؟

Bloom Filter چند hash position را علامت می‌زند. درج‌ها تنها بیت‌های بیشتری روشن می‌کنند. اگر query به بیت خاموش برسد، عضو قطعاً درج نشده؛ اگر همه روشن باشند، عضو درج شده یا collision باعث **false positive** شده است. false negative در استفادهٔ عادی Bloom رخ نمی‌دهد، ولی حذف/خرابی داده/مدل‌سازی اشتباه می‌تواند مفروضات را بشکند. Bloom به‌تنهایی پاسخ نمی‌دهد کدام آیتم‌ها داخل آن هستند.

```text
BF.RESERVE lab:emails 0.01 100000
BF.ADD lab:emails user@example.com
BF.EXISTS lab:emails user@example.com
BF.EXISTS lab:emails other@example.com
```

در اینجا `0.01` نرخ false positive هدف و `100000` ظرفیت مورد انتظار است؛ این اعداد مشخصهٔ کیفیت‌اند. اگر ظرفیت را شدیداً رد کنی، خطا/هزینه افزایش می‌یابد؛ رفتار scaling را تنظیم و پایش کن. برای منطق «اگر احتمال دیده‌شدن هست، از پایگاه دقیق بپرس؛ اگر نیست، سریع رد کن» Bloom می‌تواند مرحلهٔ فیلتر باشد.

Cuckoo Filter از fingerprintها و bucketها استفاده می‌کند و امکان حذف را هم می‌دهد. حذف فقط وقتی درست است که مدل افزودن/حذف، شمارش تکراری و احتمال false positive را درست مدیریت کند. در user registration، هیچ‌گاه فقط به Bloom «این ایمیل استفاده شده» تکیه نکن: پاسخ مثبت را با دیتابیس authoritative بررسی کن، سپس قید unique واقعی را در منبع اصلی اعمال کن.

## ۷. شمارش، Top-K و percentile

**Count-Min Sketch** برای سؤال «این path/event تقریباً چند بار آمده؟» است. هر رخداد شمارنده‌های چند ردیف hash را زیاد می‌کند؛ collision باعث این می‌شود تخمین از مقدار واقعی بالاتر باشد. ابتدا sketch را با خطا/احتمال یا ابعاد مناسب بساز:

```text
CMS.INITBYPROB lab:paths 0.001 0.01
CMS.INCRBY lab:paths /search 1 /home 1 /search 1 /checkout 1
CMS.QUERY lab:paths /search /checkout /unknown
```

**Top-K** از جریان، k نامزد پرتکرار را دنبال می‌کند:

```text
TOPK.RESERVE lab:top-paths 3 2000 7 0.9
TOPK.ADD lab:top-paths /home /search /home /checkout /home /search
TOPK.LIST lab:top-paths WITHCOUNT
```

خروجی را نمایندهٔ تقریبی بدان، نه audit log. برای گزارش‌های مالی/صورتحساب، جمع دقیق را در store مناسب نگه دار و از sketch برای کشف داغ‌ترین‌ها استفاده کن.

**t-digest** از توزیع عددی خلاصه می‌سازد تا median و tail percentile را تخمین بزند:

```text
TDIGEST.CREATE lab:latency COMPRESSION 100
TDIGEST.ADD lab:latency 8 9 10 11 12 13 20 45 110 900
TDIGEST.QUANTILE lab:latency 0.5 0.95 0.99
TDIGEST.INFO lab:latency
```

تفسیر کن: quantile با `0.99` تخمین صدک ۹۹ است، نه «حداکثر» و نه تضمین سقف تأخیر. دُم توزیع را با histogram/percentile واقعی سرویس مقایسه کن، نمونه‌ها را در windowهای زمانی جدا نگه دار و compression/merge و sampling را برای workload واقعی ارزیابی کن.

## ۸. همه‌چیز را در یک سناریو وصل کنیم

یک API رخدادهای `request_duration_ms` می‌فرستد:

- سری زمانی: اندازه‌گیری دقیق هر رخداد یا تجمیع‌شده در هر بازه، برای trend و dashboard.
- t-digest: تقریب p50/p95/p99 پنجره برای پاسخ سریع و کم‌حافظه.
- Top-K/Count-Min: پیدا کردن routeهای پرتکرار یا پرهزینه.
- Bloom: جلوگیری از خواندن منبع اصلی برای شناسه‌هایی که احتمالاً هرگز دیده نشده‌اند.
- منبع authoritative: رخداد/صورتحساب اصلی و محاسبهٔ exact در storage مناسب.

اینها مکمل‌اند و جای یکدیگر را نمی‌گیرند. اگر Redis restart شود یا خلاصه را reset کنی، سیستم باید بداند محاسبه از چه زمانی ناقص است و آیا می‌تواند از log دوباره بسازد.

## تجربهٔ واقعی و آنچه می‌توان با اطمینان گفت

RedisTimeSeries به‌طور رسمی برای telemetry، instrumentation، IoT، smart metering و پایش QoS معرفی شده است؛ اینها workloadهای مستندشده‌اند، نه داستان مشتری مستقل. [راهنمای رسمی Time Series](https://redis.io/docs/latest/develop/data-types/timeseries/) قابلیت retention، label، aggregation و query چندسری را نشان می‌دهد. همچنین Redis مقاله‌ای دربارهٔ [دادهٔ سری زمانی و کاربرد آن](https://redis.io/blog/what-is-time-series-data/) دارد. در این درس ادعای نام‌بردن از شرکت خاص برای RedisTimeSeries نمی‌کنم چون در منابع قابل‌اتکا یک تجربهٔ مشتری با جزییات معماری/نتیجهٔ قابل راستی‌آزمایی پیدا نشد.

یک تمرین طراحی واقعی‌نما: اگر داشبورد هر دقیقه میانگین دما را بخواهد، raw را مثلاً ۷ روز و averageهای ۱ دقیقه‌ای را مدت بیشتری نگه دار؛ اما برای alarm «اگر دما حتی یک بار از ۹۰ بالاتر رفت» فقط average نساز، چون پیک را پنهان می‌کند. این یک مثال آموزشی است، نه توصیهٔ ظرفیت برای محصول خاص.

## کارگاه: طراحی داشبورد telemetry

### مرحلهٔ A: نیاز را مشخص کن

یک device، یک دقیقه، دو sample می‌فرستد. نمودار ۱دقیقه‌ای لازم است؛ دادهٔ خام ۲ روز و aggregate یک‌دقیقه‌ای ۱۴ روز نگهداری می‌شود. مقادیر `min/max/avg` برای بررسی spikeها لازم است.

### مرحلهٔ B: نمونهٔ محلی

این syntax را روی Redisی اجرا کن که Time Series دارد:

```text
DEL lab:device:7:raw lab:device:7:minute
TS.CREATE lab:device:7:raw RETENTION 172800000 DUPLICATE_POLICY LAST LABELS device 7 site tehran metric temperature
TS.ADD lab:device:7:raw 1794384000000 21.0
TS.ADD lab:device:7:raw 1794384030000 22.0
TS.ADD lab:device:7:raw 1794384060000 24.0
TS.CREATE lab:device:7:minute RETENTION 1209600000 LABELS device 7 site tehran metric temperature resolution minute
TS.CREATERULE lab:device:7:raw lab:device:7:minute AGGREGATION max 60000
TS.RANGE lab:device:7:raw 1794384000000 1794384060000
TS.RANGE lab:device:7:minute - +
```

Rule را بهتر است پیش از درج دادهٔ تولیدی بسازی؛ این مثال برای مشاهده است و ممکن است اولین bucket تا ورود دادهٔ timestamp بعدی کامل نشود. برای ساخت خروجی min/avg/max جداگانه، هر aggregation به destination/rule خودش نیاز دارد.

### مرحلهٔ C: فرضیه‌ها و مشاهده

1. کدام timestamp در بازه شامل است؟ مرزهای `from` و `to` را در خروجی بررسی کن.
2. اگر sampleی دیر برسد که زمانش قدیمی‌تر از دادهٔ فعلی است، retention و سیاست duplicate چه اثری دارد؟
3. اگر label هر سری `request_id` یکتا باشد، index و جست‌وجوی چندسری چه ریسکی می‌گیرند؟
4. برای هشدار peak از avg استفاده می‌کنی یا max؟ چرا؟
5. در outage چند دقیقه‌ای، device buffer دارد؟ پیام‌ها replay می‌شوند؟ اگر نه، dashboard gap را چگونه نشان می‌دهد؟

## عیب‌یابی

| نشانه | علت‌های محتمل | قدم تشخیص |
| --- | --- | --- |
| `unknown command TS.*` | نسخه/ماژول/سرویس Time Series ندارد | نسخه، product، `MODULE LIST` و سازگاری client را بررسی کن. |
| `the key is not a TSDB key` | key موجود از نوع String/Hash است یا سری ساخته نشده | `TYPE key`، نام key و ترتیب `TS.CREATE` را ببین. |
| دادهٔ تکراری ثبت نشد | duplicate policy یا timestamp یکسان | `TS.INFO` و policy، منبع timestamp و `ON_DUPLICATE` را بررسی کن. |
| نمودار دادهٔ قدیمی ندارد | retention یا query range اشتباه، timestamp آینده | retention، میلی‌ثانیه بودن epoch و timezone را کنترل کن. |
| `TS.MRANGE` نتیجه نمی‌دهد | label/filter اشتباه یا labelها متفاوت‌اند | `TS.INFO`، عبارت `FILTER` و مقدارهای label را تطبیق بده. |
| خروجی aggregation خالی/عقب است | bucket هنوز کامل نشده، rule دیر ساخته شده یا زمان‌بندی غلط است | destination، rule، timestamp مرزی و sample جدیدتر را بررسی کن. |
| Bloom مثبت اما عضو پایگاه نیست | false positive | lookup دقیق را ادامه بده؛ مثبت Bloom را حکم قطعی ندان. |
| CMS/Top-K با عدد دقیق برابر نیست | collision/تقریب/فشردگی حافظه | با log exact نمونه‌گیری و پارامترهای sketch را بررسی کن. |

## اشتباه‌های رایج

1. زمان را ثانیه می‌فرستی درحالی‌که فرمان انتظار میلی‌ثانیه دارد؛ یک timestamp نمونه را دستی به تاریخ UTC تبدیل کن.
2. average را به‌جای peak یا percentile استفاده می‌کنی؛ هدف metric را قبل از انتخاب reducer بنویس.
3. هر device را یک label با cardinality بالا می‌کنی ولی label index را ظرفیت‌سنجی نمی‌کنی.
4. TTL/retention را با سیاست پشتیبان اشتباه می‌گیری؛ retention پاک‌سازی دادهٔ سری است، backup نسخهٔ قابل‌بازیابی.
5. Bloom/CMS/Top-K را منبع دقیق حساب می‌گیری؛ اینها projection آماری‌اند، source of truth نیستند.
6. Redis را برای retention بی‌نهایت انتخاب می‌کنی بی‌آنکه RAM، persistence، replication و هزینهٔ restore را حساب کنی.
7. برای هر قابلیت ماژولی فرض می‌کنی نصب محلی از نسخهٔ جاری است؛ command availability را روی endpoint هدف کنترل کن.

## تمرین‌های تشریحی

1. برای ۲۰هزار دستگاه با یک sample در هر ۱۵ ثانیه، نرخ ورودی sample در ثانیه را حساب کن. اگر raw هفت روز بماند، چه اطلاعاتی برای برآورد RAM هنوز کم داری؟
2. برای دمای موتور، نیاز به `avg`، `min`، `max` یا quantile را برای سه کاربرد «نمودار»، «هشدار داغی» و «SLA تأخیر» انتخاب کن و دلیل بیاور.
3. نرخ false positive برای Bloom را ۱٪ انتخاب کرده‌ای. توضیح بده چرا در سامانهٔ ثبت‌نام هنوز باید unique constraint پایگاه اصلی وجود داشته باشد.
4. CMS برای شمارش جست‌وجوهای داغ استفاده شده. بگو چرا مقدار تخمینی ممکن است از شمارش واقعی بیشتر باشد و چگونه آن را نمونه‌برداری می‌کنی.
5. Top-K را برای trend یک‌ساعته می‌خواهی؛ چرا یک ساختار دائمی از شروع سرویس کافی نیست؟ چه الگوی window/reset/rollover می‌سازی؟
6. t-digest صدک ۹۹ را می‌دهد. چه تفاوتی با «۹۹٪ درخواست‌ها در کمتر از این مقدار بوده‌اند» از یک histogram دقیق دارد؟ عدم‌قطعیت را چطور گزارش می‌کنی؟
7. دو سری را با labelهای `region` و `sensor_type` طراحی کن. کدام labelها را از سری حذف می‌کنی تا cardinality کنترل شود؟
8. یک معماری replay طراحی کن تا پس از حذف/خرابی aggregate، بتوانی آن را از log دوباره بسازی. چه داده‌ای منبع authoritative است؟

### راهنمای پاسخ

1. `20000 ÷ 15 ≈ 1333.3` sample در ثانیه. برای RAM باید اندازهٔ واقعی هر sample/chunk، تعداد سری، label/index overhead، replication, fragmentation و compaction معلوم شود؛ نرخ×روز به‌تنهایی کافی نیست.
2. نمودار شاید avg همراه min/max؛ هشدار داغی max یا raw threshold؛ SLA معمولاً p95/p99 در window، نه avg. تعریف SLI تعیین‌کننده است.
3. Bloom false positive دارد، race هم ممکن است؛ فقط قید unique در منبع authoritative جلوی ثبت duplicate را قطعی می‌گیرد.
4. hash collision باعث شمارش اضافه در bucketهای مشترک می‌شود. log exact را نمونه‌گیری یا روی window کوچک مقایسه کن.
5. نرخ‌ها با زمان تغییر می‌کنند؛ ساختار بدون window ممکن است محبوبیت قدیمی را با امروز مخلوط کند. sketchهای دوره‌ای، keyهای windowدار یا reset کنترل‌شده در نظر بگیر.
6. تخمین t-digest است؛ به اندازهٔ نمونه و ساختار توزیع/تنظیم وابسته است. در کنار تخمین، بازهٔ زمانی، تعداد نمونه و روش محاسبه را بنویس و با histogram منبع بسنج.
7. region و نوع سنسور معمولاً دسته‌های محدودند؛ شناسهٔ یکتای کاربر/درخواست را label نکن مگر واقعاً query pattern و هزینه را سنجیده باشی.
8. log ماندگار/صف durable یا storage تحلیلی؛ Redis aggregate نمای مشتق‌شده است. checkpoint، offset، idempotency و بازسازی تدریجی لازم‌اند.

## کوییز

### ۱. timestamp سری زمانی Redis بر چه واحدی است؟

<details><summary>پاسخ</summary>

عدد میلی‌ثانیه از Unix epoch؛ `*` زمان سرور را به‌کار می‌برد.

</details>

### ۲. Bloom برای عضو موجود چه جواب‌هایی می‌دهد؟

<details><summary>پاسخ</summary>

اگر منفی باشد، عضو درج نشده است؛ اگر مثبت باشد، احتمال دارد درج شده باشد یا false positive باشد.

</details>

### ۳. آیا Bloom filter فهرست اعضا یا حذف عضو را فراهم می‌کند؟

<details><summary>پاسخ</summary>

خیر؛ Cuckoo filter در سناریوهای خاص حذف را پشتیبانی می‌کند، اما آن هم ساختار احتمالی است.

</details>

### ۴. Count-Min Sketch معمولاً چه نوع خطایی دارد؟

<details><summary>پاسخ</summary>

به دلیل برخورد hash، فراوانی را می‌تواند بیشتر از مقدار واقعی تخمین بزند؛ آن را exact count فرض نکن.

</details>

### ۵. Top-K به چه سؤال پاسخ می‌دهد؟

<details><summary>پاسخ</summary>

کدام تعداد محدودی item در جریان پرتکرارند؛ برای فهرست کامل یا رتبه‌بندی حسابرسی‌شده نیست.

</details>

### ۶. آیا average یک دقیقه‌ای برای شناسایی یک پیک چندثانیه‌ای کافی است؟

<details><summary>پاسخ</summary>

ممکن است پیک را پنهان کند؛ بسته به هدف، raw/min/max یا rule جدا برای threshold لازم است.

</details>

### ۷. retention چه تفاوتی با compaction دارد؟

<details><summary>پاسخ</summary>

Retention عمر دادهٔ قدیمی را محدود می‌کند؛ compaction از sampleها سری خلاصه‌شده می‌سازد. یکی جای دیگری نیست.

</details>

### ۸. t-digest چه چیزی را تقریب می‌زند؟

<details><summary>پاسخ</summary>

quantileهای توزیع عددی مثل median یا p99 را؛ نه یک حد قطعی یا شمارش exact.

</details>

### ۹. چرا `request_id` معمولاً label خوبی نیست؟

<details><summary>پاسخ</summary>

تقریباً برای هر رکورد مقدار تازه‌ای می‌سازد و cardinality/index را زیاد می‌کند، بدون آنکه معمولاً query تجمیعی مفیدی بسازد.

</details>

### ۱۰. آیا قابلیت Time Series روی هر نسخهٔ Redis در دسترس است؟

<details><summary>پاسخ</summary>

خیر؛ نسخه، product/edition، package/module و client را روی endpoint واقعی بررسی کن. Redis 8 قابلیت‌ها را یکپارچه کرده، ولی نصب قدیمی ممکن است module بخواهد.

</details>

## منابع برای مطالعهٔ تکمیلی

### مستندها و مقاله‌های انگلیسی

- [مستند Redis Time Series](https://redis.io/docs/latest/develop/data-types/timeseries/) — درج، retention، aggregation و query.
- [راهنمای توسعهٔ Time Series](https://redis.io/docs/latest/develop/data-types/timeseries/development/) — کار با label، aggregation و چندسری.
- [دستور TS.ADD](https://redis.io/docs/latest/commands/ts.add/) — timestamp، duplicate policy و ورودی نمونه.
- [ساختارهای احتمالی Redis](https://redis.io/docs/latest/develop/data-types/probabilistic/) — نمای کلی خانواده‌ها.
- [Bloom Filter](https://redis.io/docs/latest/develop/data-types/probabilistic/bloom-filter/) و [فهرست فرمان‌های احتمالی](https://redis.io/docs/latest/operate/oss_and_stack/stack-with-enterprise/bloom/commands/).
- [Redis دربارهٔ سری زمانی چیست؟](https://redis.io/blog/what-is-time-series-data/) — مثال‌های کاربردی و مفاهیم پایه.
- [Time Series command reference](https://redis.io/docs/latest/commands/?group=timeseries) — syntax و پیچیدگی فرمان‌ها.

### فارسی

- [آموزش Redis به فارسی در SalamLang](https://www.salamlang.ir/std/db/redis/) — مبانی Redis و نمونهٔ پروژه؛ برای syntax سری زمانی نسخه‌ات مستند رسمی را هم ببین.
- [مرور فارسی ساختارهای Redis در DNTips](https://www.dntips.ir/exports/posts/www.dntips.ir-posts-3088.pdf) — مرور ساختارها؛ پوشش همهٔ قابلیت‌های جدید/احتمالی را تضمین نمی‌کند.
- [جست‌وجوی مقاله‌های فارسی Redis Time Series](https://www.google.com/search?q=آموزش+فارسی+Redis+Time+Series+TS.ADD+TS.RANGE).
- [جست‌وجوی فارسی Bloom Filter و Count-Min Sketch](https://www.google.com/search?q=آموزش+فارسی+Bloom+Filter+Count+Min+Sketch).

منابع بیرونی مکمل‌اند؛ برای یادگیری مفهومی، توضیح و کارگاه همین فصل کافی است. برای سازگاری فرمان‌ها، محدودیت محصول و نسخه، مستند endpoint مورد استفاده را در زمان پیاده‌سازی تطبیق بده.

</div>
