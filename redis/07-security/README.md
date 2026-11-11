<div dir="rtl" align="right">

# فصل ۷ — امنیت Redis

> English edition: [Chapter 7 — Redis security](./README.en.md)

> امنیت با رمز عبور شروع می‌شود ولی تمام نمی‌شود: شبکه، ACL، TLS، secret، patch، log و backup همه بخشی از مرز اعتماد هستند. زمان پیشنهادی: ۲ تا ۳ ساعت.

## درس‌های فصل

1. [Authentication و ACL](./acl-auth/README.md): کاربرهای مجزا، command permission، key/channel pattern و کمترین دسترسی.
2. [شبکه و TLS](./network-tls/README.md): bind، firewall، private network، encryption و گواهی.

## مدل تهدید ساده

دارایی‌ها را مشخص کن: دادهٔ cache، token/session، credential، backup و commandهای admin. مهاجم ممکن است به شبکهٔ داخلی دست پیدا کند، secret افشا شود، worker مجاز بیش از حد دسترسی بگیرد یا endpoint اشتباهاً عمومی شود. کنترل‌ها را چندلایه کن: port عمومی بسته، شبکهٔ private، TLS در مسیرهای لازم، ACL per-service و secret rotation.

ACL باید علاوه بر user/password، نام commandهای مجاز، کلیدهایی که کاربر می‌تواند ببیند و channelهای Pub/Sub را محدود کند. `default` را برای application عمومی فعال و admin را برای workload عادی استفاده نکن. `ACL DRYRUN` برای پیش‌آزمایش مجوز کاربرد دارد؛ secret واقعی را در README، ticket یا history نگذار.

## چک‌لیست کاربردی

- Redis از اینترنت عمومی قابل دسترسی نیست؛ firewall و bind را از شبکهٔ واقعی بررسی کن.
- هر سرویس user جدا و دسترسی حداقلی دارد؛ key prefixها enforce می‌شوند.
- replication, Sentinel, Cluster bus, backup و exporter هم مسیر شبکه/دسترسی دارند.
- در transit لازم TLS پیکربندی و certificate lifecycle تعریف شده است.
- secret در secret manager نگهداری و rotate می‌شود؛ در config git نیست.
- version/security advisory پایش، patch و rollback برنامه‌ریزی شده است.
- log و monitoring دادهٔ حساس را افشا نمی‌کند؛ backup encryption و access کنترل دارد.

## سناریوی بازبینی

یک برنامهٔ سفارش فقط روی `orders:*` باید `GET`, `HGET`, `HSET`, `XADD` انجام دهد. user جدا بساز و فرمان `FLUSHALL` یا `CONFIG SET` را برای آن رد کن. سپس بررسی کن آیا pattern واقعاً کلیدهای لازم را پوشش می‌دهد و transaction/scriptهایش به commandهای بیشتری نیاز دارند یا نه. ACL را در محیط محلی آزمایش کن و از قفل‌شدن admin پیشگیری کن.

## آزمون عبور

1. چرا password تنها دفاع Redis کافی نیست؟
2. برای چه‌کار ACL key pattern را محدود می‌کند؟
3. TLS چه چیزی را محافظت می‌کند و چه چیزی را به‌تنهایی حل نمی‌کند؟
4. چه مسیرهایی غیر از اتصال app به Redis نیاز به security review دارند؟

<details><summary>پاسخ راهنما</summary>

endpoint عمومی/credential leak/دسترسی بیش از حد همچنان خطرند. ACL command و key دسترس‌پذیر را محدود می‌کند. TLS محرمانگی/یکپارچگی مسیر ارتباطی را فراهم می‌کند ولی authorization، host security یا secret management را جایگزین نمی‌کند. replica, Sentinel, Cluster bus, backup/restore و monitoring نیز مسیرهای دسترسی‌اند.

</details>

## منابع

- [Redis Security](https://redis.io/docs/latest/operate/oss_and_stack/management/security/)
- [ACL](https://redis.io/docs/latest/operate/oss_and_stack/management/security/acl/)
- [TLS](https://redis.io/docs/latest/operate/oss_and_stack/management/security/encryption/)
- [راهنمای فارسی امن‌سازی Redis](https://www.ariaservice.net/blog/%D8%B1%D8%A7%D9%87-%D8%A7%D9%86%D8%AF%D8%A7%D8%B2%DB%8C-%D9%88-%D8%A7%D9%85%D9%86-%D8%B3%D8%A7%D8%B2%DB%8C-redis-%D8%B1%D9%88%DB%8C-%D8%B3%D8%B1%D9%88%D8%B1-%D9%85%D8%AC%D8%A7%D8%B2%DB%8C-%D9%88-%D8%A7%D8%AE%D8%AA%D8%B5%D8%A7%D8%B5%DB%8C)

</div>
