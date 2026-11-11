<div dir="rtl" align="right">

# نصب، اجرا و اتصال

> English edition: [Install, run, and connect](./README.en.md)

> سطح پیشنهادی: مقدماتی تا میانی · زمان: ۳۰ تا ۶۰ دقیقه

## هدف یادگیری

محیط آزمایشی Redis را امن بالا بیاوری و CLI را از server تشخیص بدهی.

## درس

Redis بیشتر روی Linux و macOS توسعه و آزمایش می‌شود. برای یادگیری Docker نسخه و عمر محیط را روشن می‌کند. redis-server سرویس است؛ redis-cli کلاینت ارسال فرمان. برای لَب، پورت را فقط روی localhost منتشر کن. tag نسخه را برای تمرین قابل‌تکرار pin کن؛ نسخهٔ انتخابی production را جدا تأیید کن.

## Redis را روی کدام محیط نصب کنم؟

این سه جزء را از هم جدا کن:

- **Image/package:** فایل‌های server و ابزارها، مانند image رسمی Docker یا package سیستم‌عامل.
- **Server process:** فرایندی که port را گوش می‌دهد و command اجرا می‌کند.
- **Client:** ابزار اتصال، مانند redis-cli یا کتابخانهٔ برنامه.

در Windows مسیر پیشنهادی این دوره Docker Desktop است؛ Redis را به port عمومی شبکه bind نکن. WSL2 نیز می‌تواند محیط Linux فراهم کند، ولی برای شروع یک container کافی است. در Linux معمولاً Redis از package manager یا دستورالعمل رسمی نصب می‌شود؛ نسخهٔ repo توزیع ممکن است از نسخهٔ جاری عقب‌تر باشد. روی macOS نیز می‌توان از package manager استفاده کرد. در هر روش، version و source package را بررسی کن.

برای Debian/Ubuntu نمونهٔ نصب توزیعی:

~~~bash
sudo apt update
sudo apt install redis-server
sudo systemctl enable --now redis-server
redis-cli PING
~~~

خروجی موفق PONG است. این فرمان‌ها را فقط روی Linux خودت اجرا کن؛ enable سرویس را برای راه‌اندازی خودکار فعال می‌کند. روی machine مشترک، تنظیمات default را بی‌بررسی در معرض شبکه قرار نده.

## لَب Docker قدم‌به‌قدم

در لَب فصل صفر container با نام redis-course ساخته شده است. در تمرین‌های این README از نام redis-lab استفاده می‌کنیم. در فرمان زیر 127.0.0.1 محدودیت دسترسی به همین میزبان را نگه می‌دارد:

~~~powershell
docker run --name redis-lab -p 127.0.0.1:6379:6379 -d redis:8
docker ps --filter name=redis-lab
docker exec redis-lab redis-cli PING
docker exec redis-lab redis-cli INFO server
docker logs redis-lab
~~~

در port mapping، عدد سمت چپ port کامپیوتر و عدد سمت راست port داخل container است. اگر روی کامپیوتر port 6379 اشغال بود، سمت چپ را 6380 بگذار:

~~~powershell
docker run --name redis-lab -p 127.0.0.1:6380:6379 -d redis:8
docker exec redis-lab redis-cli PING
~~~

docker exec مستقیم به port داخل container می‌رود؛ اگر از host client استفاده کنی، باید port سمت چپ یعنی 6380 را target بگیری. اگر container شروع نشد، با docker logs علت را ببین؛ name conflict را با حذف کورکورانهٔ container حل نکن.

برای تکرار دقیق در یک تیم، tag patch یا digest ثابت کن و آن را در README پروژه ثبت کن. tag redis:8 برای آموزش ساده است ولی با انتشار نسخهٔ جدید می‌تواند image دیگری دریافت کند. در production باید image، config و روش rollout بازبینی شوند.

## تفاوت stop، start و rm

- stop فقط فرایند container را متوقف می‌کند؛ container باقی است.
- start همان container را دوباره اجرا می‌کند.
- rm container را حذف می‌کند.
- volume عمر جداگانه دارد؛ حذف container الزاماً volume را حذف نمی‌کند.

این لَب volume ندارد؛ حذف redis-lab دادهٔ همین container را هم حذف می‌کند. دستورهای پاک‌سازی را فقط برای container نام‌برده اجرا کن.

## مثال و آزمایش

```text
docker run --name redis-lab -p 127.0.0.1:6379:6379 -d redis:8
docker exec -it redis-lab redis-cli PING
docker stop redis-lab
docker rm redis-lab
# stop فقط فرایند container را متوقف می‌کند؛ rm container آزمایشی را حذف می‌کند و چون volume نداریم، دادهٔ همان لَب هم حذف می‌شود.
```

## تجربهٔ کاربردی و سناریوی طراحی

محیط‌های ephemeral برای توسعه و Linux یا سرویس مدیریت‌شده برای production الگوهای رایج‌اند؛ این تمرین ادعای کیس شرکتی نیست.

این بخش یک الگوی مهندسی/تمرین است؛ آن را به شرکت مشخصی نسبت نده.

## خطاهای رایج

بازکردن پورت به همهٔ interfaceها، قراردادن رمز در history، یا فرض اینکه حذف کانتینر همان حذف volume است.

## تمرین

1. مثال را در Redis محلی اجرا و خروجی را با زبان خودت توضیح بده.
2. دو حالت شکست یا edge case برای این الگو بنویس.
3. برای workload خودت حجم داده، نرخ خواندن/نوشتن، TTL یا retention و رفتار زمان outage را مشخص کن.
4. یک معیار بگذار: p95 latency، hit rate، RAM، lag، pending count یا زمان restore.

## کوییز

### 1. redis-cli چیست؟

<details><summary>پاسخ</summary>

کلاینتی برای اتصال و اجرای دستور است، نه datastore.

</details>

### 2. چرا bind کردن پورت به 127.0.0.1؟

<details><summary>پاسخ</summary>

Redis لَب از بیرون ماشین قابل دسترسی نشود.

</details>

### 3. چرا نسخه را pin کنیم؟

<details><summary>پاسخ</summary>

برای تکرارپذیری و کنترل ارتقا.

</details>

## منابع انگلیسی

- [نقشهٔ Redis در roadmap.sh](https://roadmap.sh/pdfs/roadmaps/redis.pdf)
- [install](https://redis.io/docs/latest/operate/oss_and_stack/install/)
- [cli](https://redis.io/docs/latest/develop/tools/cli/)

## منابع فارسی

- مرور فارسی: https://www.dntips.ir/exports/posts/www.dntips.ir-posts-3088.pdf
- ویدئوی دستورهای پایه: https://www.youtube.com/watch?v=e5Q_RUwviaE

> برای قابلیت‌های تخصصی، مستند رسمی نسخه‌ای را که اجرا می‌کنی مرجع اصلی بگیر. منابع فارسی تخصصی برای همهٔ موضوع‌ها پوشش یکسان ندارند؛ این محدودیت در لینک‌های مکمل مشخص است.

</div>
