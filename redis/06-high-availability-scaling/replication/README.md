<div dir="rtl" align="right">

# Replication: primary و replica

> English edition: [Replication: Primary and Replica](README.en.md)

> مسیر: فصل ۶، دسترس‌پذیری و مقیاس · سطح: میانی · زمان: ۷۰ تا ۱۰۰ دقیقه
>
> فرمان‌های تغییر role/replication را فقط در لَب اجرا کن؛ اشتباه‌گرفتن primary می‌تواند writeها را به مقصد ناخواسته ببرد.

## هدف یادگیری

- نقش primary و replica و مسیر کپی داده را توضیح دهی.
- full synchronization را از partial resynchronization تشخیص دهی.
- lag، read staleness، async write loss و هزینهٔ initial sync را تحلیل کنی.
- replication را از backup و automatic failover جدا بدانی.
- `INFO replication`, `ROLE`, `WAIT` و وضعیت اتصال را بخوانی.

## مدل ذهنی

در Redis replication معمولی، یک primary writeهای dataset را انجام می‌دهد و replicaها جریان تغییرها را دریافت می‌کنند. مدل پیش‌فرض asynchronous است تا write latency و throughput مطلوب باشد؛ primary لازم نیست پیش از پاسخ به client منتظر fsync دیسک یا تأیید همهٔ replicaها بماند.

```text
client write -> primary -> replication stream -> replica(s)
                         (may lag / disconnect)
```

Replica می‌تواند از بعضی readها پشتیبانی کند، اما پاسخ آن ممکن است stale باشد. Primary failover نیز فقط «کپی تازه را حتماً پیدا می‌کند» تضمین نمی‌کند؛ selection بهترین replica با دادهٔ در دسترس انجام می‌شود.

## ۱. Full sync و partial sync

وقتی replica برای نخستین بار متصل می‌شود یا gap تغییرها از replication backlog بزرگ‌تر است، ممکن است full sync لازم شود: primary یک snapshot می‌سازد، داده را می‌فرستد و سپس جریان تغییرهای جدید را ادامه می‌دهد. این کار پهنای‌باند، disk/CPU و RAM/child process مصرف می‌کند و روی dataset بزرگ زمان‌بر است.

اگر ارتباط کوتاه قطع شود و offset لازم هنوز در backlog باشد، PSYNC می‌تواند فقط تغییرهای ازدست‌رفته را بدهد. backlog یک buffer محدود است؛ اندازه‌اش را با نرخ write و مدت قطع شبکه بسنج. backlog کوچک‌تر از gap باعث full resync پرهزینه می‌شود.

## ۲. مشاهدهٔ وضعیت

روی هر node در لَب:

```text
INFO replication
ROLE
```

در `INFO replication` نقش، آدرس primary، link status، replication offsets و lag/replica state را دنبال کن. نام fieldها در نسخه‌ها فرق می‌کند؛ معنی را با مستند همان نسخه تطبیق بده. `ROLE` برای پاسخ مستقیم نقش node مفید است.

شاخص‌های عملیاتی:

- `master_link_status` و مدت disconnect.
- فاصلهٔ replication offset بین primary و replica.
- زمان آخرین full sync و مدت آن.
- throughput ارسال و replication backlog.
- تغییر latency و write response هنگام sync.

## ۳. read scaling و کهنگی

خواندن از replica ممکن است بار primary را کم کند، اما تضمین linearizable/latest read نمی‌دهد. اگر application فوراً بعد از write، read-after-write سازگار می‌خواهد، از primary بخوان یا طراحی/version check بساز. برای leaderboard یا dashboard که چند ثانیه کهنگی قابل‌قبول است، replica ممکن است مناسب باشد.

`replica-read-only` معمولاً از write ناخواسته محافظت می‌کند. در managed service ممکن است endpoint read/write routing را provider مدیریت کند؛ client configuration را مطابق آن بساز.

## ۴. `WAIT` و مرز تضمین

`WAIT numreplicas timeout` روی همان connection منتظر می‌ماند تا writeهای قبلی آن اتصال به حدی replica برسند یا timeout شود:

```text
SET lab:replication:value v1
WAIT 1 100
```

خروجی تعداد replicaهایی است که تأیید داده‌اند. اگر عدد درخواستی حاصل نشد، برنامه باید تصمیم timeout/retry را بگیرد؛ `WAIT` write را به تراکنش دیسکی تبدیل نمی‌کند. مستند Redis تأکید می‌کند این دستور احتمال از‌دست‌رفتن در failover را پایین می‌آورد، اما failover همچنان best-effort است و یک replica قدیمی ممکن است promote شود. `WAIT` را هم روی همان connectionی اجرا کن که write مربوطه را فرستاده است.

اگر سیاست فقط اجازهٔ write وقتی حداقل replica حاضر است می‌دهد، تنظیم‌هایی مثل `min-replicas-to-write` و `min-replicas-max-lag` را بررسی کن؛ این‌ها هنگام partition availability را کاهش می‌دهند و جای durability/backup را نمی‌گیرند.

## ۵. Replication چه چیزی نیست؟

- **Backup نیست:** `DEL`, خرابکاری یا data corruption می‌تواند replicate شود.
- **Persistence نیست:** اگر هر دو node memory-only باشند و هم‌زمان restart/از دست بروند، RDB/AOF خارجی ندارند.
- **Failover coordinator نیست:** خود replication تغییر نقش را به شکل HA policy مدیریت نمی‌کند؛ Sentinel یا Cluster این لایه را اضافه می‌کند.
- **تضمین zero data loss نیست:** replication asynchronous است.

## تجربهٔ واقعی: چرا GitLab Redis را cross-region replicate نکرد

در مقالهٔ معماری GitLab Geo، تیم بررسی کرد Redis را هم برای cache/session بین siteها replicate کند، اما latency بین مناطق می‌توانست باعث شود session بلافاصله روی replicaٔ دوردست حاضر نباشد و وابستگی به primary ایجاد کند. آن‌ها Redis replication را برای این use case کنار گذاشتند و راه دیگری برای authentication/synchronization انتخاب کردند. این تجربه نشان می‌دهد replica برای locality/DR رایگان نیست؛ latency و consistency requirement اپلیکیشن باید آزموده شود. [مقالهٔ GitLab Geo](https://about.gitlab.com/blog/how-we-built-gitlab-geo/)

## لَب مفهومی

برای دیدن full/partial sync به دو node lab و پیکربندی network نیاز داری؛ اینجا server واقعی start نمی‌کنیم. تمرین طراحی:

1. primary و replica را با dataset نمونه تعریف کن.
2. اگر replica ۲ ثانیه عقب است، کدام endpoint برای read-after-write استفاده می‌شود؟
3. اگر backlog قبل از reconnect پر شد، چه syncی لازم است و peak RAM/CPU چقدر headroom می‌خواهد؟
4. چه metric و alertی با lag از آستانه عبور می‌کند؟
5. `WAIT` timeout شد، API موفقیت می‌دهد یا retryable error؟

## عیب‌یابی

- **replica لینک ندارد:** DNS/network/firewall, auth/ACL/TLS و log connection را بررسی کن.
- **lag رو به افزایش:** write rate، network bandwidth، slow disk، full sync، CPU و command load را اندازه بگیر.
- **full sync مکرر:** backlog/timeout, deployment restarts, network churn و concurrent BGSAVE را بررسی کن.
- **read قدیمی:** query replica را با primary value/offset مقایسه کن؛ consistency need را بازنگری کن.
- **replica write error:** نقش و `replica-read-only` را ببین؛ primary discovery را درست کن.
- **failover پس از ack داده کم دارد:** async replication و replication safety assumptions را بررسی کن؛ برای loss کم‌تر persistence/`WAIT` کمک می‌کنند ولی مطلق نیستند.

## تمرین با پاسخ

1. cache read-only روی replica می‌خواند و user بعد از update مقدار قبلی می‌بیند؛ دو راه حل و trade-off بنویس.
2. replica ۳۰ ثانیه offline بوده و backlog فقط ۵ ثانیه را نگه می‌دارد؛ چه اتفاقی می‌افتد؟
3. چرا `WAIT` را از یک اتصال دیگر اجراکردن write قبلی را تأیید نمی‌کند؟
4. برای DR چرا فقط replication به region دوم کافی نیست؟

**راهنمای پاسخ:** primary read یا consistency window/versioning برای سؤال ۱؛ full resync برای سؤال ۲؛ WAIT state همان اتصال و writeهای قبلی آن را می‌سنجد؛ backup point-in-time, data validation, DNS/cutover, replication lag و dependencyهای region هم برای DR مهم‌اند.

## کوییز

### ۱. پیش‌فرض replication sync است یا async؟

<details><summary>پاسخ</summary>

Asynchronous.

</details>

### ۲. Full sync در چه حالتی رخ می‌دهد؟

<details><summary>پاسخ</summary>

Replica نتواند gap را از backlog بگیرد، یا sync اولیه لازم باشد؛ snapshot و جریان جدید منتقل می‌شوند.

</details>

### ۳. آیا read از replica همیشه آخرین write را می‌بیند؟

<details><summary>پاسخ</summary>

خیر؛ امکان lag/stale data وجود دارد.

</details>

### ۴. `WAIT` چه می‌کند؟

<details><summary>پاسخ</summary>

روی همان connection منتظر تأیید replication برای writeهای قبلی می‌ماند.

</details>

### ۵. آیا `WAIT` loss را صفر می‌کند؟

<details><summary>پاسخ</summary>

خیر؛ احتمال را کم می‌کند ولی failover best-effort می‌ماند.

</details>

### ۶. آیا replica جای backup است؟

<details><summary>پاسخ</summary>

نه؛ تغییرات بد هم replicate می‌شوند.

</details>

## منابع

### انگلیسی و رسمی

- [Redis replication](https://redis.io/docs/latest/operate/oss_and_stack/management/replication/)
- [PSYNC](https://redis.io/docs/latest/commands/psync/)
- [WAIT](https://redis.io/docs/latest/commands/wait/)
- [SENTINEL versus replication](https://redis.io/docs/latest/operate/oss_and_stack/management/sentinel/)
- [GitLab Geo: latency and decision not to replicate Redis across sites](https://about.gitlab.com/blog/how-we-built-gitlab-geo/)

### فارسی

- [آموزش فارسی Redis در زبان سلام](https://www.salamlang.ir/std/db/redis/)
- [مرور فارسی کاربردها و داده‌ساختارها در DNTips](https://www.dntips.ir/exports/posts/www.dntips.ir-posts-3088.pdf)
- [جست‌وجوی فارسی Redis replication](https://www.google.com/search?q=آموزش+فارسی+Redis+replication+replica)

جزئیات replication در منابع فارسی موجود محدود است؛ درس فوق مدل و تصمیم‌های اصلی را پوشش می‌دهد. پارامترها را در محیط managed/OSS و نسخهٔ خودت بررسی کن.

</div>
