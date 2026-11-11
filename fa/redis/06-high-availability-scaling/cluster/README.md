<div dir="rtl" align="right">

# Redis Cluster: shard کردن keyspace و دسترس‌پذیری

> English edition: [Redis Cluster: Keyspace Sharding and Availability](../../../../en/redis/06-high-availability-scaling/cluster/README.md)

> مسیر: فصل ۶ · سطح: میانی تا پیشرفته · زمان درس: ۹۰ تا ۱۴۰ دقیقه
>
> Cluster یک distributed database deployment است؛ روی production بدون client سازگار، topology plan و migration rehearsal تغییر نده.

## هدف یادگیری

- دلیل استفاده از Cluster را از Sentinel و یک replica group جدا کنی.
- ۱۶٬۳۸۴ hash slot، توزیع key، `MOVED` و `ASK` را توضیح دهی.
- key naming و hash tag را برای multi-key commandها طراحی کنی.
- محدودیت‌های availability، replication async، hot key و client routing را درک کنی.
- بفهمی چه زمانی vertical scaling یا managed Redis از Cluster ساده‌تر است.

## مدل ذهنی

Redis Cluster keyspace را بین چند primary تقسیم می‌کند. هر key در یکی از ۱۶٬۳۸۴ hash slot است؛ هر primary subsetی از slotها را می‌گیرد و replicaها برای failover هر primary پشتیبان آن shard هستند. Client با topology cluster key را به node مالک slot می‌فرستد؛ nodeها عموماً پاسخ را proxy نمی‌کنند، بلکه redirect می‌دهند.

```text
key -> CRC16(key) % 16384 -> hash slot -> primary for that slot
                                               |
                                          replica(s)
```

Cluster سه فایدهٔ اصلی می‌دهد: توزیع حافظه/write در چند primary، reshard slotها و replica failover. پیچیدگی client، شبکه، کار چندکلیدی، capacity balancing و operations نیز افزایش می‌یابد.

## ۱. Hash slot و redirect

برای مشاهدهٔ slot در لَب:

```text
CLUSTER KEYSLOT customer:42
CLUSTER KEYSLOT cart:{customer-42}
```

فرمول slot از CRC16 و modulo 16,384 است. اگر client key را به node اشتباه بفرستد، Redis `MOVED <slot> <host:port>` می‌دهد؛ client slot map را به‌روز و درخواست را به node درست می‌فرستد. `ASK` معمولاً هنگام slot migration است: این درخواست موقت به node مقصد می‌رود و client باید `ASKING` را پیش از فرمان ارسال کند. Library سازگار این redirectها و map refresh را مدیریت می‌کند.

## ۲. Hash tag و commandهای چندکلیدی

اگر key شامل `{...}` باشد، فقط قسمت داخل اولین brace معتبر مبنای hash است. بنابراین:

```text
cart:{customer-42}
cart-items:{customer-42}
cart-lock:{customer-42}
```

در یک slot می‌افتند و می‌توانند برای برخی multi-key operations/transaction/scriptها با هم کار کنند. بدون hash tag، `MGET key1 key2` یا transaction چندکلیدی ممکن است `CROSSSLOT` بگیرد.

Hash tag را با دامنهٔ invariant انتخاب کن: کلیدهایی که atomicity لازم دارند باید باهم باشند. اما tag همگانی مثل `{all-users}` تمام keyها را روی یک slot می‌اندازد و یک primary را hotspot می‌کند؛ در آن صورت Cluster مزیت افقی‌اش را از دست می‌دهد.

Cluster فقط دیتابیس شمارهٔ ۰ را پشتیبانی می‌کند؛ چند DB شماره‌دار standalone را جای namespace و Cluster routing تصور نکن. Prefix keyها را برای environment/tenant/domain طراحی کن.

## ۳. Resharding و failover

با جابه‌جایی slotها می‌توان keyspace را میان primaryها balance کرد. هنگام migration، بخشی از keyها ممکن است در حال انتقال باشند و client باید `MOVED`/`ASK` را درست مدیریت کند. قبل از resize ظرفیت هر node، free disk/RAM، replica capacity، network و migration throughput را محاسبه کن.

Replica failover دسترس‌پذیری را بالا می‌برد؛ اما replication پیش‌فرض async است. اگر primary قبل از ارسال write به replica از دست برود، آخرین write پذیرفته‌شده ممکن است در replica موجود نباشد. Cluster هم strongly consistent نیست؛ آخرین failover برنده می‌شود و divergent state قابل reconciliation نیاز دارد.

اگر node/slot لازم در دسترس نیست، cluster ممکن است بخشی یا همهٔ درخواست‌ها را رد کند بسته به پوشش slot و پیکربندی. `CLUSTER INFO`, `CLUSTER NODES` و logهای cluster bus را در runbook داشته باش. یک primary تنها برای هر slot یک failure domain است؛ primaryها/replicaها را در zoneهای مناسب توزیع کن.

## ۴. دسترسی و latency در client

Client باید cluster mode را پشتیبانی کند، topology map را cache/refresh کند، به چند node وصل شود و redirectها را parse کند. یک اتصال ثابت به node اول کافی نیست. Client باید reconnect/backoff، timeout، command retry semantics، TLS/auth و metrics per node را مدیریت کند.

Pipelining در Cluster وقتی keyها روی nodeهای متفاوت‌اند ممکن است library batch را به nodeها fan-out کند؛ latency/partial failure semantics با standalone یکی نیست. Hot key همچنان روی یک slot/node است و Cluster آن key را خودکار split نمی‌کند.

## ۵. Cluster یا Sentinel یا scale-up؟

| گزینه | مناسب برای | هزینهٔ تصمیم |
| --- | --- | --- |
| بزرگ‌ترکردن یک node | ظرفیت فعلی کم است و downtime/scale plan قابل‌قبول | سقف node و هزینهٔ عمودی |
| Primary + replica + Sentinel | یک keyspace روی یک shard، automatic failover مهم است | داده روی یک primary می‌ماند و شارد نمی‌شود |
| Redis Cluster | RAM/throughput keyspace باید بین چند primary تقسیم شود | client routing، multi-key constraints، resharding و عملیات پیچیده‌تر |
| Managed Redis | تیم نمی‌خواهد topology پایه را خودش operate کند | ویژگی‌ها/هزینه/limits را با قرارداد provider بررسی کن |

## تجربهٔ واقعی: cross-region session و latency

در طرح اولیهٔ GitLab Geo، تیم تجربه کرد cross-region Redis replication ممکن است session بلافاصله روی site ثانویه حاضر نباشد و latency redirect/login را تحت تأثیر قرار دهد؛ همچنین وابستگی به primary باقی می‌ماند. این مورد تجربهٔ Cluster نیست، ولی در انتخاب Cluster مهم است: shardها و replicas مسئلهٔ latency جغرافیایی/سازگاری اپلیکیشن را خودکار حل نمی‌کنند. [GitLab Geo architecture](https://about.gitlab.com/blog/how-we-built-gitlab-geo/)

## لَب طراحی و عیب‌یابی

کلیدها را انتخاب کن و `CLUSTER KEYSLOT` را روی Cluster آزمایشی ببین:

```text
CLUSTER KEYSLOT inventory:{sku-7}
CLUSTER KEYSLOT reservation:{sku-7}:order-501
CLUSTER KEYSLOT customer:42
```

کلیدهای اول و دوم باید به یک slot برسند؛ key سوم لزوماً هم‌slot نیست. از اینجا مشخص کن آیا قرار دادن reservation و inventory در slot یک کالا هم‌زمان خطر hotspot می‌سازد یا نه.

عیب‌یابی:

- `MOVED`: slot map قدیمی است؛ client topology را refresh می‌کند.
- `ASK`: slot در حال انتقال است؛ redirect موقت و `ASKING` را از client cluster-aware انتظار داشته باش.
- `CROSSSLOT`: کلیدهای command/transaction هم‌slot نیستند؛ hash tag/invariant را بازبینی کن.
- `CLUSTERDOWN`: slotها کامل map نشده‌اند، primary/majority مشکل دارد یا topology unhealthy است؛ `CLUSTER INFO` را ببین.
- keyها به یک primary چسبیده‌اند: hash distribution، tag بسیار عمومی، key hot، workload واقعی و slot allocation را بررسی کن.
- failover با data discrepancy: async replication, acknowledged write timing و recovery/source of truth را تحلیل کن.

## تمرین با پاسخ

1. چرا Cluster از Sentinel در memory scaling فرق دارد؟
2. سه key برای cart, items و lock بنویس که multi-key transaction پشتیبانی شود.
3. `MOVED` و `ASK` را فرق بگذار.
4. یک `user_id` hot که یک‌چهارم traffic را می‌گیرد داری؛ آیا Cluster به‌تنهایی مشکل را حل می‌کند؟
5. Cluster failover و backup چه چیزی را هرکدام پوشش می‌دهند؟

<details><summary>پاسخ‌های راهنما</summary>

1. Sentinel یک primary shard را monitor/failover می‌کند؛ Cluster keyspace را بین چند primary shard می‌کند.
2. برای مثال `cart:{u-42}`, `items:{u-42}` و `lock:{u-42}`.
3. MOVED مسیر مالک فعلی slot و topology update است؛ ASK redirect موقت حین migration است.
4. خیر؛ یک hot key به یک slot می‌افتد؛ باید مدل read/write را split، shard application-level یا cache/aggregation را redesign کنی.
5. Cluster failover به خرابی node کمک می‌کند؛ backup point-in-time و بازیابی حذف/خرابی منطقی را پشتیبانی می‌کند.

</details>

## کوییز

### ۱. چند hash slot در Redis Cluster هست؟

<details><summary>پاسخ</summary>

۱۶٬۳۸۴.

</details>

### ۲. `MOVED` به چه معناست؟

<details><summary>پاسخ</summary>

کلید روی node دیگری است؛ client slot map را به‌روز و redirect دائمی فعلی را دنبال می‌کند.

</details>

### ۳. Hash tag چه می‌کند؟

<details><summary>پاسخ</summary>

کلیدهای دارای tag مشابه را به یک slot می‌برد تا عملیات چندکلیدی سازگار شود.

</details>

### ۴. چرا `{all}` برای همهٔ keyها خطرناک است؟

<details><summary>پاسخ</summary>

همه را روی یک slot/node متمرکز و hotspot ایجاد می‌کند.

</details>

### ۵. آیا Cluster write acknowledged را بدون loss تضمین می‌کند؟

<details><summary>پاسخ</summary>

خیر؛ async replication هنوز می‌تواند write تازه را در failover از دست بدهد.

</details>

### ۶. آیا Cluster جای backup است؟

<details><summary>پاسخ</summary>

خیر؛ backup/recovery مستقل می‌ماند.

</details>

## منابع

### انگلیسی و رسمی

- [Redis Cluster specification](https://redis.io/docs/latest/operate/oss_and_stack/reference/cluster-spec/)
- [Scale with Redis Cluster](https://redis.io/docs/latest/management/scaling/)
- [MOVED error](https://redis.io/docs/latest/develop/reference/errors/common/moved/)
- [ASK redirection and cluster specification](https://redis.io/docs/latest/operate/oss_and_stack/reference/cluster-spec/)
- [Sentinel for non-clustered HA](https://redis.io/docs/latest/operate/oss_and_stack/management/sentinel/)
- [GitLab Geo replication and latency trade-offs](https://about.gitlab.com/blog/how-we-built-gitlab-geo/)

### فارسی

- [آموزش فارسی Redis در زبان سلام](https://www.salamlang.ir/std/db/redis/)
- [جست‌وجوی فارسی Redis Cluster و hash slot](https://www.google.com/search?q=آموزش+فارسی+Redis+Cluster+hash+slot)
- [مرور فارسی ساختارها در DNTips](https://www.dntips.ir/exports/posts/www.dntips.ir-posts-3088.pdf)

منابع فارسی جزئی Cluster کمتر از مستندات اصلی‌اند؛ درس فوق کلیدها و محدودیت‌های طراحی را خودبسنده پوشش می‌دهد. behavior client/version، redirect و upgrade plan را با نسخهٔ هدف بررسی کن.

</div>
