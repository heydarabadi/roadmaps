<div dir="rtl" align="right">

# Redis Pub/Sub: اعلان زنده و گذرا

> English edition: [Redis Pub/Sub: Live, Ephemeral Notifications](README.en.md)

> مسیر: فصل ۴، قابلیت‌های پیشرفته · سطح: مقدماتی تا میانی · زمان: ۵۰ تا ۸۰ دقیقه
>
> مثال‌ها را روی Redis آزمایشی اجرا کن. Pub/Sub برای پیام‌های قابل‌از‌دست‌رفتن طراحی شده است.

## هدف یادگیری

- `PUBLISH`, `SUBSCRIBE`, `UNSUBSCRIBE`, `PSUBSCRIBE` و پیام‌های channel را بشناسی.
- توضیح دهی چرا Pub/Sub صف durable نیست و پیامِ subscriber آفلاین قابل replay نیست.
- Pub/Sub را با Streams، List و brokerهای durable متناسب با نیاز مقایسه کنی.
- permission کانال‌ها و بازیابی state پس از reconnect را در طرح خودت ببینی.

## ایدهٔ مرکزی

Pub/Sub یک سازوکار broadcast آنلاین است. publisher پیام را روی channel می‌فرستد؛ subscriberهای متصل همان لحظه آن را می‌گیرند. Redis پیام را برای consumer نگه نمی‌دارد، acknowledgment نمی‌گیرد و consumer group ندارد. بنابراین Pub/Sub برای «اکنون خبر بده» مناسب است، نه «تا وقتی هر کارگر انجام نداده نگه‌دار».

```text
Publisher --PUBLISH(channel, payload)--> Redis
                                      /     \\
                              subscriber A  subscriber B
                              (connected)    (offline = no replay)
```

## ۱. اولین آزمایش در دو ترمینال

در ترمینال A یک subscription باز کن:

```text
SUBSCRIBE lab:notifications
```

پاسخی شبیه `subscribe`, channel و تعداد subscriptionها می‌بینی. در ترمینال B بفرست:

```text
PUBLISH lab:notifications "deployment-ready"
(integer) 1
```

عدد پاسخ تعداد subscriberهایی است که پیام را دریافت کرده‌اند، نه تعداد پیام‌های durable ذخیره‌شده یا تعداد business operationهای کامل‌شده. اگر هیچ subscriber متصل نباشد ممکن است صفر برگردد و payload برای بعد ذخیره نمی‌شود.

## ۲. channel دقیق و الگو

`SUBSCRIBE` نام دقیق را می‌گیرد. `PSUBSCRIBE` با pattern می‌تواند چند channel را گوش کند:

```text
PSUBSCRIBE orders:*
PUBLISH orders:created "order=501"
PUBLISH orders:cancelled "order=501"
```

pattern می‌تواند پیام‌های بیش از انتظار دریافت کند. schema پیام را با `channel`, `event_type`, `event_id`, `schema_version` و payload روشن طراحی کن. اگر از `PUBLISH`های چند نوع استفاده می‌کنی، پیام دریافتی و pattern matching را در client درست parse کن. نام channel مکانیزم کنترل دسترسی نیست؛ ACL channel permission را جدا تنظیم کن.

## ۳. تضمین تحویل و بازیابی

Pub/Sub در Redis **at-most-once** است: پیام یا هنگام اتصال می‌رسد یا گم می‌شود؛ server دوباره‌فرستی برای subscriber قطع‌شده انجام نمی‌دهد. اگر consumer پس از دریافت crash کند، producer نمی‌فهمد کار کامل شد یا نه؛ Pub/Sub ack application-level ندارد.

برای کانال اعلان UI این اغلب قابل قبول است: هنگام اتصال مجدد، UI از API یا پایگاه اصلی snapshot تازه می‌گیرد و سپس live update را دنبال می‌کند. برای تغییر موجودی یا پرداخت معمولاً کافی نیست؛ پیام‌ها ممکن است گم یا در منطق application دوباره تولید شوند. `PUBLISH` را در کنار source of truth استفاده کن و از payload کوچک شناسهٔ entity/event بده تا subscriber state معتبر را دوباره بخواند.

### تصمیم انتخاب ابزار

| نیاز | گزینهٔ معمول |
| --- | --- |
| خبر لحظه‌ای به clientهای آنلاین؛ از دست‌رفتن قابل‌قبول | Pub/Sub |
| نگه‌داری پیام، replay، PEL و ack per group | Redis Streams |
| صف ساده با یک/چند worker و طراحی visibility اختصاصی | List یا Sorted Set به همراه پروتکل ack خودت |
| نگهداری طولانی/بسیار حجیم، replay مستقل گروه‌ها، اکوسیستم streaming | Kafka یا سامانهٔ مشابه را بسنج |

هیچ گزینه‌ای را تنها به‌خاطر نام «queue» انتخاب نکن. retention، throughput، ترتیب لازم، consumer مستقل، durability، failure recovery و مهارت عملیاتی تیم را با هم مقایسه کن.

## ۴. شارد، keyspace notification و اتصال

در Redis Cluster، Pub/Sub عادی و sharded Pub/Sub شکل‌های پخش متفاوتی دارند؛ از Redis 7 به بعد `SSUBSCRIBE`, `SPUBLISH`, `SUNSUBSCRIBE` برای sharded Pub/Sub معرفی شده‌اند تا پیام‌های shard-scoped منتقل شوند. رفتار، سازگاری client و پیکربندی را برای نسخهٔ خود بررسی کن.

Keyspace notifications قابلیتی دیگر است: Redis رخدادهایی مثل تغییر/انقضای key را روی channelهای مخصوص منتشر می‌کند، اما خاموش‌بودن/پیکربندی، هزینه و گذرا بودن پیام‌ها را در نظر بگیر. این notificationها لاگ durable تغییرات نیستند؛ برای workflow حساس، آن‌ها را منبع قطعی event حساب نکن.

Client معمولاً connection اختصاصی برای subscription می‌خواهد، چون اتصال در حالت subscribed پیام‌های asynchronous دریافت می‌کند. Pool اتصال معمولی را بدون بررسی رفتار library دوباره مصرف نکن. timeout، reconnect و shutdown را در client پیاده کن.

## ۵. تجربهٔ واقعی منتشرشده: feedback loop در لایهٔ cache

در postmortem رسمی Meta دربارهٔ outage سال 2010، یک cache invalidation/repair process با تفسیر خطا به‌عنوان مقدار نامعتبر، cache key را حذف می‌کرد و با queryهای بیشتر به پایگاه داده فشار می‌آورد؛ خطا باعث درخواست بیشتر و حلقهٔ feedback می‌شد. این رخداد گزارش Redis نیست و به Pub/Sub مربوط نمی‌شود؛ ولی درس طراحی آن به subscriberها و cache invalidation هم قابل‌اعمال است: خطا را با «داده قطعاً خراب است» یکی نگیر، retry را محدود کن، backoff بگذار، state authoritative را بازخوانی کن و از burst بازگشت کاربران محافظت کن. [شرح outage از Engineering at Meta](https://engineering.fb.com/2010/09/23/uncategorized/more-details-on-todays-outage/)

## لَب: invalidate بدون از‌دست‌رفتن state اصلی

ترمینال A:

```text
SUBSCRIBE product:updates
```

ترمینال B:

```text
SET product:501:version 12
PUBLISH product:updates "product=501 version=12"
GET product:501:version
```

هدف پیام این است که client بداند کدام رکورد را دوباره بخواند. حالا ترمینال A را disconnect کن، publish دیگری بفرست و reconnect کن: پیام قبلی برنمی‌گردد. سپس توضیح بده client چگونه با خواندن نسخهٔ authoritative یا snapshot، gap را جبران می‌کند. `product:501:version` در این لَب صرفاً نمونه است، نه طرح کامل cache invalidation.

## امنیت و عملیات

- channel را در payload به عنوان مرز امنیتی فرض نکن؛ ACL با `&channel-pattern` و دسترسی command را تنظیم و با حساب application جدا آزمایش کن.
- اطلاعات شخصی/secret را broadcast نکن؛ چند subscriber ممکن است پیام را ببینند.
- log کردن payload می‌تواند دادهٔ حساس را کپی کند؛ در log شناسه و correlation id کافی است.
- تعداد subscriberهای متصل، reconnect rate، خطاهای parser و نرخ publish را در برنامه پایش کن؛ publish count نشان‌دهندهٔ موفقیت کسب‌وکار نیست.
- برای cache invalidation، راه بازسازی state پس از outage یا پیام جاافتاده را مشخص کن.

## دام‌ها و عیب‌یابی

- **هیچ پیام نمی‌رسد:** نام channel، ACL، اتصال به همان endpoint و حالت subscription را بررسی کن.
- **`PUBLISH` صفر می‌دهد:** subscriber فعالی نداشته‌ای؛ پیام در backlog ذخیره نشده است.
- **بعد از reconnect state کهنه است:** API snapshot یا read-repair طراحی نشده؛ Pub/Sub خودش gap را پر نمی‌کند.
- **همهٔ channelها به همهٔ clientها می‌رسند:** pattern خیلی باز است یا ACL مرز کانال را محدود نکرده.
- **notification را برای workflow critical استفاده کرده‌ای:** آن را به Stream/queue durable منتقل کن یا یک outbox پایدار در منبع داده بساز.
- **reconnect هم‌زمان درخواست‌ها را زیاد می‌کند:** jitter، backoff، coalescing و endpoint snapshot را طراحی کن.

## تمرین با پاسخ

1. چرا عدد `PUBLISH` معیار «پیام پردازش شد» نیست؟
2. بعد از قطع دو دقیقه‌ای subscriber چه تضمینی دربارهٔ پیام‌های قبلی داریم؟
3. برای live dashboard چه stateی را باید پس از reconnect بازخوانی کرد؟
4. کدام بهتر است برای تایید سفارش: Pub/Sub یا Stream؟ دلیل را با ack/retention توضیح بده.
5. Pub/Sub notification را چگونه امن می‌کنی؟

<details><summary>پاسخ‌های تشریحی</summary>

1. فقط تعداد subscriberهای آنلاین تحویل‌گیرندهٔ همان پیام را می‌شمارد؛ acknowledgement یا پایان business operation ندارد.
2. هیچ تضمینی برای replay نیست؛ پیام‌های زمان قطع‌بودن از دست می‌روند.
3. snapshot از منبع authoritative یا API، سپس subscription برای تغییرات بعدی؛ ترتیب گرفتن snapshot و وصل‌شدن باید gap را مدیریت کند.
4. برای تأیید سفارش، Stream یا broker durable مناسب‌تر است چون entry، group و ack/recovery دارد؛ بااین‌حال idempotency و durability policy همچنان لازم است.
5. ACL کانال/command، جداسازی user، payload کم‌حساسیت و محدودکردن patternها.

</details>

## کوییز

### ۱. آیا Redis پیام Pub/Sub را برای subscriber آفلاین نگه می‌دارد؟

<details><summary>پاسخ</summary>

خیر؛ Pub/Sub گذراست.

</details>

### ۲. عدد بازگشتی `PUBLISH` چیست؟

<details><summary>پاسخ</summary>

تعداد subscriberهای آنلاین که پیام را دریافت کرده‌اند.

</details>

### ۳. آیا Pub/Sub acknowledgement دارد؟

<details><summary>پاسخ</summary>

خیر؛ Redis تضمین نمی‌کند اثر subscriber انجام شده باشد.

</details>

### ۴. آیا Keyspace notification لاگ پایدار است؟

<details><summary>پاسخ</summary>

خیر؛ notification را منبع قطعی تاریخچه حساب نکن.

</details>

### ۵. پیام سفارش را کجا می‌بری؟

<details><summary>پاسخ</summary>

Streams یا broker durable را با نیازهای واقعی مقایسه می‌کنی و پیام را idempotent پردازش می‌کنی.

</details>

### ۶. پس از reconnect چه کاری لازم است؟

<details><summary>پاسخ</summary>

state معتبر را از source of truth دوباره می‌خوانی یا gap را با یک سازوکار durable جبران می‌کنی.

</details>

## منابع

### انگلیسی و رسمی

- [Redis Pub/Sub](https://redis.io/docs/latest/develop/pubsub/)
- [PUBLISH](https://redis.io/docs/latest/commands/publish/)
- [Sharded Pub/Sub](https://redis.io/docs/latest/develop/pubsub/#sharded-pubsub)
- [راهنمای Redis برای انتخاب streaming](https://redis.io/docs/latest/develop/use-cases/streaming/)
- [postmortem فنی cache/database از Engineering at Meta](https://engineering.fb.com/2010/09/23/uncategorized/more-details-on-todays-outage/)

### فارسی

- [آموزش فارسی Redis در زبان سلام](https://www.salamlang.ir/std/db/redis/)
- [جست‌وجوی ویدیوهای فارسی Redis Pub/Sub](https://www.youtube.com/results?search_query=آموزش+فارسی+Redis+PubSub)
- [مرور فارسی ساختارهای Redis در DNTips](https://www.dntips.ir/exports/posts/www.dntips.ir-posts-3088.pdf)

منابع فارسی تخصصی Pub/Sub کم‌تعداد است؛ توضیح و آزمایش این فایل برای مفهوم اصلی کافی است. نسخهٔ Redis و client library خود را برای شارد Pub/Sub و ACL با مستند رسمی بررسی کن.

</div>
