<div dir="rtl" align="right">

# شبکه، bind، firewall و TLS در Redis

> English edition: [Redis Networking, Bind, Firewall, and TLS](README.en.md)

> مسیر: فصل ۷ · سطح: میانی · زمان درس: ۶۰ تا ۹۰ دقیقه
>
> Redis را مستقیماً به اینترنت باز نکن. تغییر شبکه/TLS در سرویس زنده می‌تواند همهٔ clientها را قطع کند؛ برای rollout برنامه داشته باش.

## هدف یادگیری

- Redis listener را فقط روی interface/network لازم باز کنی.
- تفاوت bind، firewall، protected mode، authentication و TLS را بفهمی.
- مسیرهای client, replica, Sentinel و Cluster bus را در threat model ببینی.
- اتصال TLS را از client تست و certificate expiry/rotation را اداره کنی.
- با مشاهدهٔ خطای TLS یا connection timeout، layer مناسب را بررسی کنی.

## مدل لایه‌ها

```text
Application identity/ACL  = چه کسی، کدام command/key را می‌تواند بزند؟
TLS                       = آیا traffic در مسیر رمز و peer احراز می‌شود؟
Private network/firewall  = چه hostهایی اصلاً می‌توانند socket را باز کنند؟
Host hardening/patching   = اگر Redis reachable شد، چه سطح حمله‌ای باقی است؟
```

هیچ لایه‌ای جای بقیه را نمی‌گیرد. یک Redis password روی اینترنت public هم exposure است؛ TLS روی هر host عمومی بدون ACL هم کافی نیست. Protected mode محافظ startup برای پیکربندی‌های ناایمن است، نه firewall دائمی.

## ۱. Listener و دسترسی شبکه

برای developer lab، bind پورت به loopback host یعنی تنها host محلی می‌تواند وصل شود:

```powershell
docker run -d --name redis-local -p 127.0.0.1:6379:6379 redis:8
```

برای server، Redis را در private subnet قرار بده، port 6379 را از اینترنت routable نکن، security group/firewall را allowlist کن و access را فقط از application network بده. در config، `bind` interface لازم را مشخص و `protected-mode` را مطابق مستندات حفظ کن. `0.0.0.0` روی host عمومی یعنی listen روی تمام interfaceها؛ آن را به عنوان shortcut نگذار.

Cluster علاوه بر client port، cluster bus جدا هم دارد (پیش‌فرض معمولاً port اصلی + 10000). Sentinel port معمولاً 26379 است. firewall باید مسیرهای control/data لازم را فقط بین nodeهای مشخص allow کند، نه به اینترنت.

## ۲. TLS در Redis Open Source

Redis می‌تواند TLS را برای client connections، replication و Cluster bus پشتیبانی کند؛ build/package باید TLS support داشته باشد و config certificateهای درست را ارائه دهد. نمونهٔ مفهومی:

```text
port 0
tls-port 6379
tls-cert-file /run/redis/tls/server.crt
tls-key-file /run/redis/tls/server.key
tls-ca-cert-file /run/redis/tls/ca.crt
tls-auth-clients yes
```

`port 0` listener غیر-TLS معمول را می‌بندد؛ این config را قبل از اطمینان از support تمام clientها اعمال نکن. در service managed گزینه‌ها و endpoint TLS ممکن است provider-controlled باشد.

نمونهٔ client CLI:

```text
redis-cli --tls --cacert ca.crt -h redis.internal -p 6379 --user app-reader
```

در mTLS ممکن است client certificate و private key نیز لازم باشد. CA chain، SAN/hostname، expiration, trust store و certificate rotation را در لَب verify کن. `--insecure` یا خاموش‌کردن certificate check برای workaround، identity سرور را از بین می‌برد.

## ۳. کدام ارتباط‌ها را پوشش می‌دهی؟

فقط HTTPS-like client socket را فعال‌کردن کافی نیست اگر nodeها plaintext با هم ارتباط دارند. matrix بساز:

| ارتباط | پرسش امنیتی |
| --- | --- |
| Application → Redis | TLS؟ ACL user اختصاصی؟ private subnet؟ |
| Primary → replica | TLS replication link؟ credential اختصاصی؟ |
| Client → Sentinel | port 26379 فقط از app/admin network؟ ACL/TLS؟ |
| Redis Cluster node → node | bus port محدود و TLS cluster bus؟ |
| Backup storage | encryption-at-rest، private access، credential rotation؟ |

هر مسیر user/ACL و firewall rule جداگانهٔ حداقلی می‌خواهد.

## ۴. اتصال و عیب‌یابی

از application network:

1. DNS resolve و route درست است؟
2. TCP port از host مجاز reachable است؟
3. TLS handshake، CA chain و hostname verify می‌شوند؟
4. `AUTH`/ACL user و command/key permission درست‌اند؟
5. Client protocol/cluster/Sentinel mode endpoint را درست استفاده می‌کند؟

| نشانه | ناحیهٔ بررسی |
| --- | --- |
| connection refused | process/listener/port یا firewall reject |
| timeout | route, security group, packet drop, congestion |
| TLS unknown CA / hostname | trust chain/SAN/config certificate |
| `NOAUTH` یا `WRONGPASS` | username/password/secret rotation |
| `NOPERM` | ACL command/key/channel pattern |
| پس از TLS فعال شدن همه قطع شدند | clientها، replication/Sentinel/Cluster paths و rollout |

## تجربهٔ واقعی و به‌روز

گزارش‌های Shadowserver و Censys سال‌ها hostهای Redis قابل‌دسترسی عمومی را ردیابی کرده‌اند؛ پژوهش Censys تلاش‌های سوءاستفاده از Redis exposed را هم مستند می‌کند. شمارش این منابع scan-based است و «exposed» را با «هر host compromise شده» یکی نمی‌گیرد. [Shadowserver](https://www.shadowserver.org/what-we-do/network-reporting/open-redis-report/) · [Censys research](https://censys.com/blog/databases-exposed-redis/)

همچنین خود Redis advisoryهای امنیتی منتشر می‌کند؛ برای نمونه advisory مربوط به پردازش TLS، آسیب‌پذیری را در شرایط مشخص authenticated گزارش کرده است. این نمونه یادآوری می‌کند TLS پچ‌کردن و دنبال‌کردن advisoryها را حذف نمی‌کند؛ نسخهٔ تحت‌تأثیر و نسخهٔ اصلاح‌شده را مستقیم از صفحهٔ رسمی همان advisory بررسی کن. [Redis security advisory](https://redis.io/blog/security-advisory-cve-2026-81934/)

## rollout بدون lockout

1. certificate و chain را در staging صادر/تست کن.
2. تمام client libraryها و replication/monitoring paths را فهرست کن.
3. port TLS و credential را موازی معرفی کن؛ clientها را مرحله‌ای منتقل کن.
4. handshake/ACL metrics را پایش کن.
5. پس از انتقال کامل، plaintext listener را در maintenance window ببند.
6. rollback certificate/endpoint و expiry alert را آماده نگه دار.

## دام‌ها

- **بازکردن 6379 روی `0.0.0.0`:** اسکنرها port عمومی را پیدا می‌کنند؛ private network و firewall تنظیم کن.
- **`requirepass` را کافی می‌دانی:** هویت، شبکه، ACL و TLS هنوز مسئله‌اند.
- **protected mode را firewall فرض می‌کنی:** برای دسترسی شبکه رویش حساب نکن.
- **TLS فقط app connection:** replication/cluster/sentinel management را فراموش می‌کنی.
- **TLS verification خاموش:** client ممکن است به endpoint جعلی وصل شود.
- **certificate expires:** alert و rotation دوره‌ای بگذار.
- **تغییر همزمان host/network/config:** root cause عیب‌یابی سخت می‌شود؛ rollout مرحله‌ای کن.
- **password در URL/log:** credentials را secret نگه دار و redaction فعال کن.

## تمرین

1. رسم کن کدام سرویس‌ها به Redis port دسترسی network دارند؛ همهٔ ورودی‌های عمومی را حذف کن.
2. برای کلاینت، replica و Sentinel یک TLS/ACL matrix بنویس.
3. پس از قطع ارتباط فرضی به علت CA اشتباه، ترتیب عیب‌یابی را ثبت کن.
4. threat model کن اگر staging Redis با دادهٔ واقعی روی public IP اشتباه bind شود، چه کنترل‌هایی جلوی دسترسی/خسارت را می‌گیرند؟

**معیار پاسخ:** network access محدود، TLS verification روشن در مسیرهای ناامن، ACL حداقلی، secret خارج repo، patch alert، و rollout/rollback آزموده.

## کوییز

### ۱. TLS چه چیزی را حل می‌کند؟

<details><summary>پاسخ</summary>

رمز و در صورت تنظیم، احراز هویت peer در مسیر ارتباط.

</details>

### ۲. ACL چه چیزی را حل می‌کند؟

<details><summary>پاسخ</summary>

محدودیت هویت به command/key/channelهای مجاز.

</details>

### ۳. protected mode جای firewall است؟

<details><summary>پاسخ</summary>

خیر؛ امنیت شبکه را با firewall/private subnet تأمین کن.

</details>

### ۴. چرا 6379 را مستقیم به اینترنت نمی‌دهیم؟

<details><summary>پاسخ</summary>

هر service reachable سطح حمله دارد و default/خطای پیکربندی می‌تواند دسترسی جدی بدهد؛ Redis باید فقط از شبکهٔ trusted قابل‌دسترسی باشد.

</details>

### ۵. در Cluster فقط TLS app socket کافی است؟

<details><summary>پاسخ</summary>

خیر؛ replication و cluster bus/Sentinel pathها را هم ارزیابی کن.

</details>

### ۶. پس از خطای certificate چه چیزی را خاموش نمی‌کنی؟

<details><summary>پاسخ</summary>

Certificate/hostname verification؛ به‌جایش CA chain و SAN را اصلاح می‌کنی.

</details>

## منابع

### انگلیسی و رسمی

- [Redis Security](https://redis.io/docs/latest/operate/oss_and_stack/management/security/)
- [TLS support in Redis OSS](https://redis.io/docs/latest/operate/oss_and_stack/management/security/encryption/)
- [Redis ACL](https://redis.io/docs/latest/operate/oss_and_stack/management/security/acl/)
- [Redis security advisory: CVE-2026-81934](https://redis.io/blog/security-advisory-cve-2026-81934/)
- [Shadowserver Open Redis Report](https://www.shadowserver.org/what-we-do/network-reporting/open-redis-report/)
- [Censys: Redis exposure and abuse attempts](https://censys.com/blog/databases-exposed-redis/)

### فارسی

- [آموزش فارسی Redis در زبان سلام](https://www.salamlang.ir/std/db/redis/)
- [جست‌وجوی راهنمای فارسی Redis TLS و امنیت شبکه](https://www.google.com/search?q=آموزش+فارسی+Redis+TLS+امنیت+شبکه)
- [مرور فارسی ساختارهای Redis در DNTips](https://www.dntips.ir/exports/posts/www.dntips.ir-posts-3088.pdf)

منابع فارسی برای TLS Redis محدودند. موارد امنیتی نسخه‌حساس‌اند؛ advisoryهای رسمی و پیکربندی provider را در زمان اجرا بررسی کن.

</div>
