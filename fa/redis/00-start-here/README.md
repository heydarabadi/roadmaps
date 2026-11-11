<div dir="rtl" align="right">

# درس صفر — محیط آزمایش و روش این دوره

> English edition: [Start here — lab setup and study method](../../../en/redis/00-start-here/README.md)

این درس ابزار و زبان مشترکی را می‌سازد که در همهٔ فصل‌های بعد لازم است. Redis را اول فقط روی کامپیوتر خودت اجرا می‌کنیم؛ هرگز دستورهای تمرینی این دوره را روی سرویس واقعی یا دادهٔ مهم اجرا نکن.

## پیش‌نیازها

- توانایی بازکردن PowerShell در Windows
- Docker Desktop روشن و قابل استفاده، یا Docker Engine در Linux/macOS
- اتصال اینترنت فقط برای دریافت image در اولین اجرا
- آشنایی مقدماتی با متن، کلید/مقدار و فایل JSON

لازم نیست Redis را روی Windows به‌صورت native نصب کنی. برای دوره، Docker یک راه مستقل و تکرارپذیر است. پس از اجرا، نسخهٔ دقیق server را از خود Redis می‌خوانیم؛ tag خانوادهٔ 8 با انتشار نسخهٔ جدید ممکن است به‌روز شود.

## ساخت لَب خصوصی

در PowerShell این فرمان را اجرا کن:

~~~powershell
docker run --name redis-course -p 127.0.0.1:6379:6379 -d redis:8
~~~

معنی بخش‌های فرمان:

- docker run یک container جدید می‌سازد و اجرا می‌کند.
- --name redis-course اسم مشخص می‌دهد تا در درس‌ها همین container را پیدا کنیم.
- -p 127.0.0.1:6379:6379 پورت Redis را فقط روی همین کامپیوتر منتشر می‌کند؛ آن را روی 0.0.0.0 منتشر نکن.
- -d اجرا را در پس‌زمینه می‌گذارد.
- redis:8 image رسمی Redis از خانوادهٔ اصلی 8 است.

در پاسخ Docker یک شناسهٔ طولانی می‌بینی. وضعیت را بررسی کن:

~~~powershell
docker ps --filter name=redis-course
docker logs redis-course
~~~

اگر container با همین نام از قبل وجود داشته باشد، Docker خطای conflict می‌دهد. آن را خودکار حذف نکن؛ اول مطمئن شو همان container تمرینی است:

~~~powershell
docker ps -a --filter name=redis-course
~~~

## اتصال و اولین گفت‌وگو

وارد redis-cli شو:

~~~powershell
docker exec -it redis-course redis-cli
~~~

نشانگر prompt معمولاً به شکل 127.0.0.1:6379> است. حالا:

~~~text
PING
PONG
SET greeting "Salam Redis"
OK
GET greeting
"Salam Redis"
~~~

در این مثال سه مرحله داریم: کلاینت PING می‌فرستد، سرور PONG پاسخ می‌دهد؛ سپس SET مقدار را زیر کلید greeting ذخیره می‌کند؛ GET همان مقدار را برمی‌گرداند. Redis متن فارسی UTF-8 را هم نگه‌می‌دارد:

~~~text
SET greeting:fa "سلام ردیس"
GET greeting:fa
"سلام ردیس"
~~~

برای خروج از cli:

~~~text
QUIT
~~~

یا در PowerShell کلیدهای Ctrl+C را بزن. برای اتصال از خود PowerShell نیز:

~~~powershell
docker exec redis-course redis-cli PING
~~~

خروجی مورد انتظار PONG است.

## نسخه و سلامت

این فرمان فقط اطلاعات سرور را می‌خواند:

~~~powershell
docker exec redis-course redis-cli INFO server
~~~

در خروجی، سطرهایی با redis_version و os را پیدا کن. خط نسخه را یادداشت کن؛ بعداً هرجا قابلیتی وابسته به نسخه باشد، آن را با این مقدار مقایسه می‌کنیم. برای دیدن نسخه بدون متن اضافی:

~~~powershell
docker exec redis-course redis-cli INFO server | Select-String redis_version
~~~

اگر PONG نمی‌گیری، این ترتیب را بررسی کن:

1. Docker Desktop یا Docker Engine روشن است؟
2. container در docker ps دیده می‌شود؟
3. لاگ با docker logs redis-course خطای شروع نشان می‌دهد؟
4. آیا برنامهٔ دیگری پورت 6379 را گرفته است؟
5. آیا نام container را در فرمان دقیق نوشته‌ای؟

در صورت اشغال پورت، Redis را با فرمان‌هایی که سرویس‌های دیگر را متوقف می‌کنند پاک نکن. بعداً می‌توانی پورت سمت کامپیوتر را به 6380 نگاشت کنی: -p 127.0.0.1:6380:6379 و کلاینت را به پورت 6380 وصل کنی.

## توقف، شروع دوباره و پاک‌سازی

توقف container داده‌اش را حذف نمی‌کند:

~~~powershell
docker stop redis-course
docker start redis-course
docker exec redis-course redis-cli PING
~~~

وقتی کار دوره تمام شد، فقط همان container لَب را حذف کن:

~~~powershell
docker rm -f redis-course
~~~

این دستور container با نام redis-course را حذف می‌کند. از docker system prune یا حذف volumeهای عمومی برای این دوره استفاده نکن؛ ممکن است دادهٔ پروژه‌های دیگر Docker را پاک کند. این لَب volume جداگانه ندارد؛ حذف container دادهٔ بدون volume همین لَب را هم از بین می‌برد.

## تفاوت چهار واژه

- **Server:** فرایند Redis که port را گوش می‌دهد، دستور اجرا می‌کند و داده را نگه می‌دارد.
- **Client:** برنامه‌ای مانند redis-cli که به server فرمان می‌فرستد.
- **Database داخل Redis:** فضای منطقی انتخاب‌شده در یک server؛ با یک server جدا اشتباه نشود.
- **Key:** نامی که با آن مقدار یا ساختار داده را پیدا می‌کنیم.

## تمرین با پاسخ

1. container را اجرا کن، با PING پاسخ بگیر، یک کلید دلخواه بساز و بخوان.
2. INFO server را ببین و نسخه را یادداشت کن.
3. container را stop/start کن و مقدار را دوباره بخوان.
4. در پایان فقط redis-course را حذف کن.

**پاسخ مورد انتظار:** PING پاسخ PONG می‌دهد؛ SET پاسخ OK؛ GET همان مقدار را برمی‌گرداند. پس از stop/start، مقدار ممکن است با تنظیم پیش‌فرض image همچنان وجود داشته باشد؛ برای درس‌های بعد به این رفتار اتکا نکن، چون فایل persistence و lifecycle کانتینر می‌توانند نتیجه را عوض کنند. حذف container تمرینی بدون volume، دادهٔ همان لَب را پاک می‌کند.

## مسیر بعدی

حالا [مبانی Redis](../01-foundations/README.md) را بخوان، بعد به نصب و redis-cli برگرد. واژه‌ها در [واژه‌نامه](../GLOSSARY.md) و دستورها در [برگهٔ مرور سریع](../QUICK-REFERENCE.md) جمع شده‌اند.

</div>
