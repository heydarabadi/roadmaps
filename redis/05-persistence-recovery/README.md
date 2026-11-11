<div dir="rtl" align="right">

# فصل ۵ — ماندگاری، backup و بازیابی

> English edition: [Chapter 5 — Persistence and recovery](./README.en.md)

> «Redis restart شد» مسئلهٔ ساده‌ای نیست؛ RPO، RTO، فایل معتبر، سازگاری نسخه و مسیر بازگردانی باید با هم طراحی شوند. زمان پیشنهادی: ۴ تا ۶ ساعت و انجام یک restore drill آزمایشگاهی.

## مفاهیم پیش از درس‌ها

- **Persistence:** ذخیرهٔ وضعیت روی دیسک برای بارگیری پس از restart.
- **Backup:** کپی قابل‌بازیابی و مستقل از خرابی سرور اصلی؛ داشتن فایل روی همان دیسک backup کافی نیست.
- **RPO:** حداکثر بازه/حجم داده‌ای که از دست رفتنش پذیرفته است.
- **RTO:** حداکثر زمان بازگشت سرویس به وضعیت قابل‌استفاده.
- **Restore drill:** تمرین واقعی بازگردانی، بررسی داده و اندازه‌گیری زمان، در محیط ایزوله.

## ترتیب یادگیری

1. [انتخاب persistence](./persistence-modes/README.md): بدون persistence، RDB، AOF و ترکیب آن‌ها را با نوع داده و تحمل ریسک تطبیق بده.
2. [RDB snapshot](./rdb/README.md): snapshot زمان‌مند، BGSAVE، هزینهٔ fork/copy-on-write و انتقال فایل.
3. [AOF](./aof/README.md): append log، سیاست fsync، rewrite و خرابی انتهای log.
4. [Backup و restore](./backup-restore/README.md): نسخهٔ پشتیبان، checksum، انتقال، restore ایزوله و runbook.

## از نیاز تا تنظیم

فرض کن counter سفارش در صورت خرابی حداکثر یک ثانیه داده از دست بدهد و سرویس در کمتر از ۱۵ دقیقه بازیابی شود. این نیاز هنوز کافی نیست. باید اندازهٔ dataset، زمان load، نوع persistence، cadence فایل off-host، latency نوشتن، failure domain و dependency برنامه را بررسی کنی. یک AOF پرپایداری ممکن است نوشتن را گران کند؛ RDB ممکن است آخرین تغییرات بعد از snapshot را نداشته باشد. Backup سالم را از روی restore ثابت می‌کنی، نه از روی نام فایل.

## خروجی فصل

یک جدول برای cache، session و state سفارش بساز: source of truth، data loss مجاز، RPO، RTO، RDB/AOF/منبع بازسازی، محل backup، encryption, checksum, restore steps و مالک runbook. اگر Redis فقط cache قابل‌ساخت مجدد است، persistence شاید لازم نباشد؛ اگر دادهٔ عملیاتی مهم است، پاسخ باید مستند و آزموده شود.

## پرسش مرور

1. تفاوت replication و backup چیست؟
2. چرا RDB روی همان volume backup off-site نیست؟
3. چطور ثابت می‌کنی که فایل پشتیبان قابل restore است؟
4. کدام معیار زمان بازیابی را می‌سنجد و کدام مقدار دادهٔ از دست‌رفته را؟

<details><summary>پاسخ راهنما</summary>

Replica خطا/حذف ناخواسته را هم می‌تواند replicate کند؛ backup نقطهٔ زمانی مستقل و قابل‌نگهداری می‌دهد. یک volume ممکن است با host/دیسک همان failure domain از بین برود. Restore روی instance ایزوله، integrity/data checks و اندازه‌گیری زمان ثابت می‌کند. RTO زمان و RPO مقدار/بازهٔ loss مجاز است.

</details>

## شرط عبور

باید یک نسخهٔ پشتیبان را در محیط آزمایشگاهی restore کرده، دادهٔ مورد انتظار را بخوانی و زمان/گام‌های لازم را ثبت کنی. اجرای یک `BGSAVE` یا دیدن `appendonly.aof` به‌تنهایی اثبات DR نیست.

## منابع

- [Persistence رسمی Redis](https://redis.io/docs/latest/operate/oss_and_stack/management/persistence/)
- [RDB persistence](https://redis.io/docs/latest/operate/oss_and_stack/management/persistence/#rdb)
- [AOF persistence](https://redis.io/docs/latest/operate/oss_and_stack/management/persistence/#aof)
- [مقالهٔ فارسی Snapshot](https://www.urhoba.net/fa/post/redis-persistence-snapshot)

</div>
