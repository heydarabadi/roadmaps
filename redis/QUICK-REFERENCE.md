<div dir="rtl" align="right">

# برگهٔ مرور سریع Redis

> English edition: [Redis Quick Reference](QUICK-REFERENCE.en.md)

این برگه برای یادآوری بعد از خواندن درس‌هاست، نه جایگزین توضیح کامل. فرمان‌ها را در لَب محلی اجرا کن.

## اتصال و تشخیص

~~~text
PING
INFO server
INFO memory
INFO replication
~~~

## Key و expiration

~~~text
SET cache:item:42 "value" EX 300
GET cache:item:42
TTL cache:item:42
TYPE cache:item:42
EXISTS cache:item:42
DEL cache:item:42
SCAN 0 MATCH cache:* COUNT 100
~~~

TTL برابر -2 یعنی key وجود ندارد؛ -1 یعنی key هست اما expiry ندارد. برای keyspace بزرگ از KEYS * استفاده نکن.

## ساختارهای اصلی

~~~text
SET counter 0
INCR counter

LPUSH queue "task-1"
RPOP queue

SADD user:42:tags redis database
SISMEMBER user:42:tags redis

HSET user:42 name Sara plan free
HGET user:42 name
HINCRBY user:42 login_count 1

ZADD leaderboard 900 user:42
ZREVRANGE leaderboard 0 9 WITHSCORES
~~~

## Pub/Sub در برابر Stream

~~~text
SUBSCRIBE notifications
PUBLISH notifications "hello"

XADD events * type order-created order_id 42
XRANGE events - +
~~~

Pub/Sub پیام را نگه نمی‌دارد. Stream برای replay و consumer group مناسب‌تر است؛ retention و pending recovery را هم باید طراحی کرد.

## Persistence و عملیات

~~~text
BGSAVE
INFO persistence
SLOWLOG GET 10
LATENCY DOCTOR
~~~

RDB snapshot است؛ AOF فرمان‌های write را ثبت می‌کند. پیش از تغییر config یا recovery، راهنمای persistence و backup/restore را بخوان.

## خطرناک

~~~text
FLUSHDB
FLUSHALL
CONFIG SET
MONITOR
~~~

این فرمان‌ها می‌توانند داده را پاک یا رفتار سرور را تغییر دهند؛ MONITOR هم می‌تواند سربار بسازد. هیچ‌کدام را روی سرویس واقعی از روی برگهٔ مرور اجرا نکن.

## روش سریع انتخاب ساختار

| نیاز اصلی | گزینهٔ معمول |
|---|---|
| مقدار یا counter | String |
| flag فشرده با index معلوم | Bitmap |
| دنباله و عملیات دو سر | List |
| یکتایی و membership | Set |
| فیلدهای یک رکورد | Hash |
| مرتب‌سازی با score | Sorted Set |
| شمارش distinct تقریبی | HyperLogLog |
| پیام ذخیره‌شده، replay یا worker group | Streams |
| broadcast لحظه‌ای برای subscriber آنلاین | Pub/Sub |

هیچ انتخابی را فقط با جدول انجام نده؛ دسترسی، حجم، retention، failure mode و benchmark را هم بسنج.

</div>
