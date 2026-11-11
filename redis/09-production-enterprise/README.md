<div dir="rtl" align="right">

# فصل ۹ — آمادگی Production و محصولات Redis

> English edition: [Chapter 9 — Production readiness and Redis products](./README.en.md)

> فصل پایانی طراحی عملیاتی از روی failure و تغییر محصول است. community edition، managed service و Enterprise یکسان نیستند. زمان پیشنهادی: ۳ تا ۵ ساعت و tabletop exercise.

## درس‌های فصل

1. [Upgrade و Disaster Recovery](./upgrade-dr/README.md): برنامهٔ ارتقا، backup، failover، restore، RPO/RTO و drill.
2. [Enterprise و انتخاب سرویس](./enterprise/README.md): قابلیت‌های OSS، managed، پشتیبانی، SLA، هزینه و compatibility.
3. [Active-Active و Flash/Flex](./active-active-flash/README.md): replication چندمنطقه‌ای، conflict و tiering با محدودیت محصول.

## Design review قبل از production

برای هر workload جواب مکتوب داشته باش:

1. **داده:** source of truth، schema/key pattern، اندازه و رشد.
2. **کارایی:** p95/p99 هدف، query mix، peak QPS، payload و test dataset.
3. **خرابی:** behavior هنگام Redis unavailable، region loss، split brain، restart و restore.
4. **دوام:** RPO/RTO، RDB/AOF/backup، off-site copy و restore drill.
5. **دسترسی:** ACL per-service، TLS/network boundary، secret rotation و audit.
6. **عملیات:** metric، alert، incident owner، capacity review، patch/upgrade و rollback.
7. **هزینه و vendor:** RAM/replica/backup/network، egress، support، lock-in و export path.

## HA در برابر DR

HA برای قطعی node/zone در همان deployment زمان در دسترس نبودن را کم می‌کند؛ DR بازگشت بعد از failure domain بزرگ‌تر/از دست‌رفتن region یا داده را می‌سنجد. replication ممکن است خطا/حذف را هم کپی کند، پس backup مستقل لازم است. Active-Active به معنی linearizable consistency سراسری نیست؛ conflict resolution، replication lag، partition behavior و support featureها را بخوان.

## تمرین tabletop

اعلام کن: «region اصلی دسترس‌پذیر نیست و primary آخرین تغییر را روی replica نداشته.» مالک سیستم باید چه کند؟ مسیر failover، client DNS/discovery، تصمیم RPO، تأیید write، ریکاوری region اصلی، جلوگیری از dual writer و validation data را به ترتیب بنویس. سپس سناریو را سخت‌تر کن: فایل backup اشتباه یا ACL نامعتبر است. runbook را طوری بنویس که operator بدون حدس گام بعد را بداند.

## معیار عبور نهایی

بتوانی معماری را روی یک صفحه توضیح دهی؛ failure mode و recovery هر قطعه را نام ببری؛ trade-off هزینه/تاخیر/دوام را روشن کنی؛ بازگردانی را تمرین کرده باشی؛ و روشن بگویی کدام ادعا benchmark vendor یا case منتشرشده است.

## منابع

- [Redis products](https://redis.io/products/)
- [Redis releases](https://redis.io/docs/latest/operate/oss_and_stack/management/upgrade/)
- [مقالهٔ معماری GitLab Geo](https://about.gitlab.com/blog/how-we-built-gitlab-geo/)
- caseهای vendor-linked هر موضوع در فایل درس مربوطه قرار گرفته‌اند.

</div>
