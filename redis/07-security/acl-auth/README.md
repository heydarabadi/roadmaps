<div dir="rtl" align="right">

# امنیت Redis: ACL، احراز هویت و حداقل دسترسی

> English edition: [Redis Security: ACLs, Authentication, and Least Privilege](README.en.md)

> مسیر: فصل ۷، امنیت · سطح: میانی · زمان درس: ۷۰ تا ۱۰۰ دقیقه
>
> secret نمونهٔ واقعی نیست. گذرواژه را در command history، chat، README یا log ذخیره نکن.

## هدف یادگیری

- فرق احراز هویت با مجوزدهی و encryption را بدانی.
- ACL user بسازی که فقط keyspace و command لازم را ببیند.
- نقش‌های read-only و read/write را از هم جدا کنی.
- `ACL WHOAMI`, `LIST`, `GETUSER`, `DRYRUN`, `LOG` را برای audit/عیب‌یابی بشناسی.
- دسترسی Pub/Sub، script و commandهای حساس را با کمترین privilege تنظیم کنی.

## مدل امنیتی

برای اتصال امن چند لایه می‌خواهی: شبکه trusted و firewall، TLS در مسیرهای ناامن، authentication برای هویت، ACL برای مجوز، secret rotation، encryption-at-rest در backup، پایش و patch. `AUTH` فقط ثابت می‌کند client چه credentialی ارائه کرده؛ داده را در شبکه رمز نمی‌کند و key/command را محدود نمی‌سازد.

```text
Client -> network/firewall -> TLS (privacy) -> AUTH (identity) -> ACL (allowed commands/keys/channels)
```

از Redis 6 به بعد ACL کاربران متعدد و command/key/channel permission را فراهم می‌کند. `requirepass` با ACL کاربر default کار می‌کند، اما برای application role separation کاربر جدا بهتر است.

## ۱. دیدن identity و ruleها

```text
ACL WHOAMI
ACL LIST
ACL USERS
ACL CAT
```

`ACL WHOAMI` user اتصال فعلی را نشان می‌دهد. `ACL LIST` ruleهای فعلی را برمی‌گرداند؛ خروجی شامل secret hash/credential data است و نباید بی‌محافظت log یا share شود. `ACL CAT` commandها را بر اساس category نشان می‌دهد؛ category را کورکورانه نده چون شامل فرمان‌های بیشتری از نیاز application است.

## ۲. ساخت user محدود

نمونهٔ مفهومی برای دو نقش در یک key pattern:

```text
ACL SETUSER cache-reader reset on >REPLACE_WITH_RANDOM_SECRET ~cache:* +get +mget +ping
ACL SETUSER cache-writer reset on >REPLACE_WITH_RANDOM_SECRET ~cache:* +get +set +del +expire +ttl +ping
```

جایگزین `REPLACE_WITH_RANDOM_SECRET` را با credential تصادفی از secret manager کن؛ placeholder را اجرا نکن. اگر terminal history ثبت می‌شود، secret را به CLI command argument نده؛ policy سازمانی برای ACL file/secret injection را رعایت کن.

- `reset` ruleهای موجود را پاک می‌کند؛ روی user shared به‌صورت تصادفی اجرا نکن.
- `on` کاربر را فعال می‌کند.
- `>...` رمز را تعریف می‌کند.
- `~cache:*` key pattern مجاز می‌کند.
- `+get`, `+set`, ... command مجاز می‌کنند.

با اتصال آزمایشی به user:

```text
AUTH cache-reader <secret>
GET cache:product:501
SET cache:product:501 value
GET private:salary:42
```

reader باید GET مجاز روی cache را ببیند، write command را رد کند و key خارج از pattern را رد کند. پاسخ ردشده را با `NOPERM` تشخیص بده. آزمایش را روی instance disposable انجام بده.

## ۳. key pattern و channel pattern

ACL دسترسی key را با pattern محدود می‌کند. چند tenant که key prefix مشترک دارند را می‌توان با namespace جدا کرد؛ اما اگر application بتواند prefix دلخواه بسازد، authorization logic را در سرویس هم اعتبارسنجی کن. ACL جایگزین tenant isolation در تمام لایه‌های برنامه نیست.

Pub/Sub channel permission با `&pattern` کنترل می‌شود. برای publisher یا subscriber فقط channelهایی را که لازم دارد باز کن. دسترسی `PSUBSCRIBE` به الگوهای وسیع می‌تواند پیام‌های بیشتری از انتظار در اختیار user بگذارد.

## ۴. مجوزهای ویژه و کمینه‌کردن سطح حمله

بعضی دستورها قدرت زیادی دارند: `CONFIG`, `MODULE`, `FLUSHALL`, `ACL`, `REPLICAOF`/replication controls, `DEBUG`, `SCRIPT`/Functions, `MONITOR`, client management. به user application آن‌ها را از روی convenience نده. برای هر service user جدا، expire/rotate credential، و audit مجوزها داشته باش.

برای query کردن مجوز بدون اجرای side effect از `ACL DRYRUN` استفاده کن (نسخه‌های پشتیبان‌کننده):

```text
ACL DRYRUN cache-reader GET cache:product:501
ACL DRYRUN cache-reader SET cache:product:501 x
```

برای خطاهای مجوز و failed commandها `ACL LOG` را ببین و log را با حساسیت امنیتی نگه‌دار. پس از تغییر ACL در لَب با همان roleهای واقعی application smoke test کن.

## ۵. تغییرات امن و rollout

1. یک user جدید با کمترین مجوز بساز.
2. در staging application را به آن وصل کن و denied operations را پایش کن.
3. اگر config persistent file است، آن را با permission محدود ذخیره و در deployment management وارد کن.
4. secret را در secret manager rotate کن؛ old credential را فقط بعد از مهاجرت clientها حذف کن.
5. default user را فقط وقتی خاموش کن که admin break-glass user و روش recovery تست شده باشد.
6. در runbook، lockout و credential leak را هم پوشش بده.

## تجربهٔ واقعی/تهدید مستند

Shadowserver هر روز گزارش hostهایی را شناسایی می‌کند که Redis را از اینترنت قابل‌دسترسی دارند؛ Censys و پژوهش‌های امنیتی نیز نمونه‌های exposed Redis و تلاش برای سوءاستفاده/نوشتن در filesystem را مستند کرده‌اند. این آمار بسته به بازهٔ جمع‌آوری تغییر می‌کند و تعداد مشاهده‌شده معادل تعداد breach موفق نیست؛ پیام عملی ثابت است: public exposure را حذف کن، default/weak auth را نپذیر و ACL/شبکه را لایه‌ای اعمال کن. [Shadowserver Open Redis Report](https://www.shadowserver.org/what-we-do/network-reporting/open-redis-report/), [Censys Redis exposure research](https://censys.com/blog/databases-exposed-redis/)

## دام‌ها و عیب‌یابی

- **`AUTH` را encryption فرض می‌کنی:** credential/Data در شبکه بدون TLS ممکن است شنود شود.
- **همهٔ برنامه‌ها یک user دارند:** compromise یک app دسترسی تمام workloadها را می‌دهد.
- **فقط password گذاشته‌ای:** user هنوز ممکن است `FLUSHALL`, `CONFIG` یا کل keyspace را داشته باشد.
- **category `+@all` داده‌ای:** کمینهٔ دسترسی را نقض می‌کند.
- **key pattern و command را یکی می‌گیری:** باید هر دو محدود شوند.
- **password را در process args یا URL log می‌کنی:** secret handling و terminal history را بررسی کن.
- **پس از محدودسازی `NOPERM` می‌گیری:** `ACL LOG`, `ACL DRYRUN` و نیاز واقعی command/key/channel را بررسی و فقط rule لازم را اضافه کن.
- **admin خودت را حذف کردی:** break-glass/access recovery لازم است؛ default off را زود اعمال نکن.

## تمرین

1. reader/writer user برای `cache:*` بساز و رفتار key خارج از prefix را مشاهده کن.
2. یک user دیگر بساز که فقط `orders:events` را با XREADGROUP بخواند؛ فهرست command/key permission لازم را مستند کن.
3. مشخص کن کدام role اجازهٔ `PUBLISH` و کدام `SUBSCRIBE` channel را دارد.
4. نقش admin امن و نحوهٔ credential rotation را طراحی کن.

**معیار پاسخ:** هر user فقط key/channel prefix و command لازم، secret بیرون repo/log، آزمون denied operation و recovery admin باید داشته باشد.

## کوییز

### ۱. فرق `AUTH` و ACL چیست؟

<details><summary>پاسخ</summary>

AUTH هویت را احراز می‌کند؛ ACL محدودهٔ command/key/channel مجاز را محدود می‌کند.

</details>

### ۲. ACL جای TLS را می‌گیرد؟

<details><summary>پاسخ</summary>

خیر؛ ACL مجوزدهی می‌کند، TLS ارتباط را رمز می‌کند.

</details>

### ۳. چرا user جدا برای هر سرویس؟

<details><summary>پاسخ</summary>

محدودسازی و لغو credential یک سرویس بدون دسترسی بقیه ممکن می‌شود.

</details>

### ۴. `NOPERM` را چطور ریشه‌یابی می‌کنی؟

<details><summary>پاسخ</summary>

با ACL LOG/DRYRUN و بررسی command/key/channel درخواست‌شده؛ فقط rule لازم را اضافه می‌کنی.

</details>

### ۵. آیا pattern `~cache:*` command مجاز می‌کند؟

<details><summary>پاسخ</summary>

خیر؛ pattern و command permission دو بخش جدا هستند.

</details>

### ۶. آیا تعداد Redisهای exposed برابر تعداد breachها است؟

<details><summary>پاسخ</summary>

خیر؛ detection exposure با اثبات دسترسی موفق/خسارت یکی نیست.

</details>

## منابع

### انگلیسی و رسمی

- [Redis ACL documentation](https://redis.io/docs/latest/operate/oss_and_stack/management/security/acl/)
- [ACL SETUSER](https://redis.io/docs/latest/commands/acl-setuser/)
- [ACL DRYRUN](https://redis.io/docs/latest/commands/acl-dryrun/)
- [Redis security overview](https://redis.io/docs/latest/operate/oss_and_stack/management/security/)
- [Shadowserver Open Redis Report](https://www.shadowserver.org/what-we-do/network-reporting/open-redis-report/)
- [Censys: Redis exposed on the Internet](https://censys.com/blog/databases-exposed-redis/)

### فارسی

- [جست‌وجوی راهنمای فارسی ACL و احراز هویت Redis](https://www.google.com/search?q=آموزش+فارسی+Redis+ACL+احراز+هویت)
- [آموزش فارسی Redis در زبان سلام](https://www.salamlang.ir/std/db/redis/)
- [مرور فارسی Redis در DNTips](https://www.dntips.ir/exports/posts/www.dntips.ir-posts-3088.pdf)

آموزش‌های فارسی دربارهٔ ACL کم‌پوشش‌اند؛ این درس مدل و لَب را خودبسنده پوشش می‌دهد. syntax و categoryهای ACL در نسخهٔ هدف را با مرجع رسمی بررسی کن.

</div>
