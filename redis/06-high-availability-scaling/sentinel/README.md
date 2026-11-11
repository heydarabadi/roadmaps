<div dir="rtl" align="right">

# Redis Sentinel: مانیتورینگ و failover برای یک shard

> English edition: [Redis Sentinel: Monitoring and Failover for One Shard](README.en.md)

> مسیر: فصل ۶ · سطح: میانی · زمان: ۷۵ تا ۱۱۰ دقیقه
>
> Sentinel failover را ممکن می‌کند، اما durability یا zero data loss تضمین نمی‌کند. config عملی را با نسخه و managed service خود بررسی کن.

## هدف یادگیری

- نقش سه node Redis و چند Sentinel را جدا کنی.
- quorum را از majority و مجوز failover تشخیص دهی.
- client را برای کشف primary جدید تنظیم کنی.
- `down-after-milliseconds`, `failover-timeout`, `parallel-syncs` و `CKQUORUM` را بفهمی.
- اثر async replication، network partition و failure test را در برنامهٔ production ببینی.

## Sentinel چه مسئله‌ای را حل می‌کند؟

Replication فقط داده را از primary به replica می‌فرستد. Sentinel یک سرویس جداگانه است که instanceها را monitor می‌کند، event/notification می‌دهد، در صورت down شدن primary replica را promote می‌کند و clientها را از primary جدید باخبر می‌سازد. Sentinel داده را partition/shard نمی‌کند؛ برای یک logical Redis primary/replica group است.

```text
Sentinel S1 --\\          /--> Redis primary
Sentinel S2 ---- quorum -+----> replica A
Sentinel S3 --/          \\--> replica B
                  |
            client asks: current primary address?
```

برای topology مقاوم، حداقل سه Sentinel روی failure domainهای مستقل بگذار؛ سه process روی یک VM یا یک zone با هم fail می‌شوند و استقلالی نمی‌دهند.

## ۱. تشخیص down و failover

Sentinel ابتدا خودش instance را unreachable می‌بیند (**SDOWN**). اگر quorum لازم نظر مشابه داشته باشد primary به **ODOWN** می‌رسد. سپس یک Sentinel باید با majority از Sentinelهای شناخته‌شده برای failover انتخاب/مجاز شود. بنابراین quorum برای agreement تشخیص است؛ authorization majority مرحلهٔ جداگانه‌ای است.

فرض پنج Sentinel با quorum `2`: دو Sentinel می‌توانند primary را down اعلام کنند، اما برای انجام failover leader همچنان نیاز به majority (حداقل سه از پنج) دارد. minority partition نباید به‌تنهایی failover انجام دهد. این طرح availability را در برابر partitionهای نامتقارن محدود می‌کند.

### نمونهٔ پیکربندی آموزشی

```text
port 26379
sentinel monitor mymaster 10.0.0.10 6379 2
sentinel down-after-milliseconds mymaster 5000
sentinel failover-timeout mymaster 60000
sentinel parallel-syncs mymaster 1
```

مقادیر عددی فقط مثال‌اند. فایل Sentinel باید writable باشد؛ Sentinel state/config تغییر یافته را نگه می‌دارد. تنظیم شبکه/ACL/TLS و address announcement در container/NAT هم باید با توپولوژی واقعی سازگار باشد.

## ۲. پارامترها

- **quorum:** چند Sentinel باید unreachable بودن primary را تشخیص دهند.
- **majority:** برای authorize شدن failover، اکثریت Sentinelها باید قابل دسترس باشند.
- **down-after-milliseconds:** چه مدت پاسخ قابل‌قبول نباشد تا یک Sentinel instance را down فرض کند. کوچک‌کردن زیاد، failover کاذب هنگام GC/شبکهٔ کند می‌آورد؛ بزرگ‌کردن زیاد outage را طولانی می‌کند.
- **failover-timeout:** پارامتر coordination/retry/failover state؛ زمان دقیق کل outage نیست.
- **parallel-syncs:** چند replica هم‌زمان به master جدید sync شوند؛ بالا یعنی recovery سریع‌تر ولی منابع sync بیشتری مصرف می‌شود.

## ۳. Client discovery

Client نباید static IP primary را تا ابد نگه دارد. Sentinel-aware client به یک یا چند Sentinel وصل می‌شود، primary logical name مثل `mymaster` را می‌پرسد و پس از failover به آدرس جدید reconnect می‌کند. Client باید retry/backoff، timeout، command idempotency و connection pool refresh را داشته باشد.

با `redis-cli` می‌توان address را بپرسید:

```text
SENTINEL get-master-addr-by-name mymaster
SENTINEL CKQUORUM mymaster
SENTINEL replicas mymaster
SENTINEL sentinels mymaster
```

`CKQUORUM` می‌گوید وضعیت فعلی برای quorum و majority موردنیاز کافی هست یا نه؛ آن را به health signal تبدیل کن. در production یک `redis-cli -p 26379` local example کافی نیست؛ address, auth/TLS و client library باید درست باشند.

## ۴. چه تضمینی نمی‌دهد؟

Sentinel یک distributed system eventually consistent است. چون replication asynchronous است و failover ممکن است replicaٔ عقب‌مانده را انتخاب کند، write پذیرفته‌شده می‌تواند گم شود. Sentinel همچنین replica جداگانه برای cross-region disaster recovery، backup point-in-time یا logical rollback نمی‌سازد.

برای نوشتن حیاتی:

1. replication lag را مانیتور کن.
2. persistence و backup را مطابق RPO تنظیم کن.
3. `WAIT` را فقط به‌عنوان کاهش احتمال loss و برای write همان connection بسنج.
4. failure test انجام بده و lost/duplicate behavior اپلیکیشن را اندازه بگیر.
5. عملیات تکرارپذیر/idempotent و conflict handling داشته باش.

## ۵. تجربهٔ واقعی: Sentinel با محصول و مسیر داده یکی نیست

مقالهٔ GitLab Geo شرح می‌دهد replication بین regionها برای session و cache در طرح اولیه latency و وابستگی به primary ایجاد می‌کرد؛ تیم تصمیم گرفت Redis را برای آن مسیر cross-site replicate نکند. این رویداد خاص، گزارش نقص Sentinel نیست؛ نکته این است که Sentinelِ یک deployment و replicationِ cross-region، نیازهای DR جغرافیایی و consistency برنامه را خودکار حل نمی‌کنند. [GitLab Geo architecture](https://about.gitlab.com/blog/how-we-built-gitlab-geo/)

## برنامهٔ failure test

یک محیط disposable با primary، replica و ۳ Sentinel بساز. سناریوها را یکی‌یکی اجرا کن:

1. primary را stop کن؛ زمان `ODOWN`, promote, client reconnect و error recovery ثبت کن.
2. network partition ایجاد کن؛ ببین minority Sentinel failover را انجام نمی‌دهد.
3. replica را با lag بالا جدا کن؛ انتخاب promotion و احتمال loss را ثبت کن.
4. primary قدیمی را برگردان؛ بررسی کن به replicaٔ primary جدید تبدیل شود و data divergent نماند.
5. یک write را در مرز failover اجرا کن؛ چند بار و از دید client تکراری/گم‌شده را تحلیل کن.

Chaos test را در production به‌صورت دستی اجرا نکن؛ ownership و rollback در محیط آزمایشی لازم است.

## دام‌ها و عیب‌یابی

- **فقط دو Sentinel:** majority/partition شکننده است؛ حداقل سه failure domain مستقل توصیه می‌شود.
- **quorum را با majority یکی گرفته‌ای:** تشخیص down و authorization failover دو شرط‌اند.
- **client همچنان primary قدیمی را می‌زند:** Sentinel-aware client/discovery و pool refresh وجود ندارد.
- **failover کاذب:** timeout نامتناسب، scheduling pause یا network jitter را بررسی کن.
- **write گم‌شده بعد از failover:** async replication و replica selection را تحلیل کن؛ Sentinel lossless نیست.
- **فایل config writable نیست:** Sentinel نمی‌تواند state را ذخیره کند یا start نمی‌شود؛ path/permission را بررسی کن.
- **Sentinelها همگی یک zone:** failure zone تمام رأی‌دهندگان را از دسترس می‌اندازد.
- **اطلاعیهٔ monitor به معنی application recovery:** client reconnect, retries و end-to-end health را جدا بسنج.

## تمرین با پاسخ

1. ۳ Sentinel داری، quorum=2؛ چه اتفاقی اگر فقط ۲ تا primary را down ببینند اما یکی از آن‌ها دیگر Sentinelها را نبیند؟
2. چرا replica read-only است و چه موقع read replica stale است؟
3. چه چیزی را client پس از failover باید انجام دهد؟
4. آیا Sentinel جای Cluster می‌گیرد وقتی RAM یک primary کافی نیست؟

<details><summary>پاسخ‌های راهنما</summary>

1. Quorum تشخیص ODOWN را ممکن می‌کند، ولی failover authorization به majority و election نیاز دارد؛ network partition ممکن است مانعش شود.
2. writeها معمولاً primary را هدف می‌گیرند؛ replica تاخیر دارد و stale read ممکن است.
3. primary address را از Sentinel دوباره کشف کند، connection pool را تازه کند و درخواست‌های قابل‌تکرار را با idempotency retry کند.
4. خیر؛ Sentinel HA یک primary/replica group می‌دهد و shard نمی‌کند؛ ظرفیت افقی نیازمند Cluster/راهکار دیگر است.

</details>

## کوییز

### ۱. Sentinel داده را shard می‌کند؟

<details><summary>پاسخ</summary>

خیر؛ مانیتور و failover برای non-clustered Redis است.

</details>

### ۲. quorum و majority چه تفاوتی دارند؟

<details><summary>پاسخ</summary>

quorum برای رسیدن به تشخیص down است؛ majority برای مجازشدن leader به انجام failover.

</details>

### ۳. حداقل چند Sentinel مستقل برای deployment مقاوم توصیه می‌شود؟

<details><summary>پاسخ</summary>

سه یا بیشتر، روی failure domainهای مستقل.

</details>

### ۴. آیا failover تمام writeها را حفظ می‌کند؟

<details><summary>پاسخ</summary>

خیر؛ async replication باعث window بالقوهٔ loss می‌شود.

</details>

### ۵. Client آدرس master را از کجا می‌گیرد؟

<details><summary>پاسخ</summary>

از Sentinel-aware discovery با logical master name.

</details>

### ۶. `CKQUORUM` چه بررسی می‌کند؟

<details><summary>پاسخ</summary>

آیا Sentinelهای در دسترس می‌توانند quorum و majority لازم را برای failover فراهم کنند.

</details>

## منابع

### انگلیسی و رسمی

- [Redis Sentinel documentation](https://redis.io/docs/latest/operate/oss_and_stack/management/sentinel/)
- [Sentinel clients and service discovery](https://redis.io/docs/latest/develop/reference/sentinel-clients/)
- [SENTINEL CKQUORUM](https://redis.io/docs/latest/commands/sentinel-ckquorum/)
- [Replication asynchronous safety](https://redis.io/docs/latest/operate/oss_and_stack/management/replication/)
- [GitLab Geo cross-region architecture decision](https://about.gitlab.com/blog/how-we-built-gitlab-geo/)

### فارسی

- [آموزش فارسی Redis در زبان سلام](https://www.salamlang.ir/std/db/redis/)
- [مرور فارسی Redis در DNTips](https://www.dntips.ir/exports/posts/www.dntips.ir-posts-3088.pdf)
- [جست‌وجوی تکمیلی Sentinel به فارسی](https://www.google.com/search?q=آموزش+فارسی+Redis+Sentinel+quorum)

آموزش فارسی عمیق Sentinel محدود است؛ بخش اصلی مفاهیم و failure test در این درس هست. با نسخه و سرویس مورد استفاده، syntax و client discovery را تطبیق بده.

</div>
