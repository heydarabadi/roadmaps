<div dir="rtl" align="right">

# Profiling دیتابیس — از هزینه کل تا گره پرهزینه پلن

**زبان:** فارسی · [English version](../../../../en/backend-performance/04-databases/12-database-profiling/README.md)


**هدف یادگیری:** query پرهزینه را بر اساس بازه و هزینه مجموع پیدا کنید، EXPLAIN را تفسیر کنید و بهینه‌سازی را با مشاهده قابل مقایسه تأیید کنید. **بررسی منابع: ۲۰۲۶-۱۱-۱۰**؛ دستورهای نمونه PostgreSQL ۱۸ هستند و اجرا نشده‌اند.

## مدل ذهنی و ترتیب کار

Profiling یعنی اندازه‌گیری برای نسبت‌دادن هزینه به مسیر مشخص. ابتدا latency درخواست را به Pool، اجرای SQL، شبکه و پردازش برنامه تقسیم کنید. سپس خانواده query را بر اساس تعداد، زمان مجموع و مصرف I/O رتبه‌بندی کنید. بعد یک اجرای نماینده را با plan، انتظار قفل و داده/پارامتر واقعی تحلیل کنید. اصلاح بدون خط پایه قابل انتساب نیست.

| ابزار PostgreSQL | کاربرد | محدودیت |
| --- | --- | --- |
| pg_stat_activity و wait events | اجرای جاری و انتظار | عکس لحظه‌ای، نه سابقه کامل |
| pg_stat_statements | آمار خانواده statement | تجمیع، reset و بازه؛ بدون p99 واقعی |
| EXPLAIN | پلن تخمینی | اجرای واقعی را اندازه نمی‌گیرد |
| EXPLAIN ANALYZE + BUFFERS | ردیف/زمان واقعی و buffer | query را اجرا و سربار اضافه می‌کند |
| ابزار سیستم/trace | CPU، دیسک، شبکه و هم‌بستگی | نسبت‌دادن نیازمند context است |

[مرور رسمی پایش دیتابیس](https://www.postgresql.org/docs/current/monitoring.html) ابزارهای داخلی و سیستم را مکمل هم می‌داند. buffer hit به معنی رایگان‌بودن query نیست؛ CPU، lock و mapping همچنان هزینه دارند.

## کاربرد و مصالحه

پیش از index یا تغییر schema، query پرتکرار را بر هزینه مجموع بسنجید. نمونه کند استثنایی نیز با SLO و تجربه کاربر اهمیت دارد؛ فقط یک ranking کافی نیست. Pg_stat_statements باید در `shared_preload_libraries` آماده شود و راه‌اندازی اولیه آن restart می‌خواهد؛ فعال‌سازی extension و مجوزها نیز لازم است. تنظیم موجود preload را با یک رشته جدید جایگزین نکنید. [مرجع ماژول](https://www.postgresql.org/docs/current/pgstatstatements.html) جزئیات normalization، محدودیت‌ها و سربار planning را شرح می‌دهد.

## مثال حل‌شده

در محیطی که extension از قبل نصب و آماده است، query زیر رتبه‌بندی تجمعی از آخرین reset را نشان می‌دهد. برای پنجره آزمایش، دو snapshot از counters و calls بگیرید و اختلاف را حساب کنید؛ هویت ردیف برای تطبیق دو snapshot ترکیب `(dbid, userid, toplevel, queryid)` است، چون `queryid` یکسان می‌تواند در ردیف‌های جدا برای دیتابیس، کاربر یا وضعیت toplevel متفاوت ظاهر شود. آمار مشترک production را برای آزمایش شخصی reset نکنید. تغییر reset یا حذف entry میان دو snapshot مقایسه را نامعتبر می‌کند.

<div dir="ltr" align="left">

```sql
SELECT dbid, userid, toplevel, queryid, calls, total_exec_time, mean_exec_time,
       rows, shared_blks_hit, shared_blks_read
FROM pg_stat_statements
ORDER BY total_exec_time DESC
LIMIT 10;

EXPLAIN (ANALYZE, BUFFERS, FORMAT TEXT)
SELECT id, total
FROM orders
WHERE customer_id = 42
ORDER BY created_at DESC, id DESC
LIMIT 20;
```

</div>

جدول فرضی orders ستون‌های id، total، customer_id و created_at دارد. پارامتر ۴۲ باید نماینده توزیع واقعی باشد. در پلن، estimate/actual rows، loops، sort و bufferها را ببینید؛ cost واحد مدل planner است، میلی‌ثانیه نیست. در گره دارای loops، actual time/rows معمولاً به‌ازای هر اجرا گزارش می‌شوند. زمان والد شامل کار زیرشاخه است؛ زمان گره‌ها را ساده با هم جمع نزنید. [Using EXPLAIN](https://www.postgresql.org/docs/current/using-explain.html) مرجع خواندن این اعداد است.

## تمرین و مشاهده مورد انتظار

دو خانواده فرضی بسازید: A با ۱۰ هزار بار اجرای ۲ms و B با ۱۰ بار اجرای ۲۰۰ms. هزینه مجموع را حساب کنید، سپس یک index یا Projection را فقط روی A در محیط آزمایشی مقایسه کنید. انتظار: A با ۲۰s بالاتر از B با ۲s است؛ mean بالاتر B به‌تنهایی اولویت ظرفیت را تعیین نمی‌کند. پیش/پس را در پنجره مشابه، با تعداد فراخوانی، داده و حالت cache ثبت کنید. اجرای سرد و گرم را برچسب بزنید و برای کسب «آزمایش سرد» cache تولید را پاک نکنید.

## شاهد عمومی و حد شواهد

[نمونه رسمی pg_stat_statements](https://www.postgresql.org/docs/current/pgstatstatements.html) رتبه‌بندی زمان مجموع و buffer را روی workload آزمایشی نشان می‌دهد؛ گزارش production شرکت نیست. [نوشته فارسی PostGIS](https://asnegar.ir/blog/postgis-optimization/) نیز نمونه عمومی استفاده از EXPLAIN برای تشخیص و تغییر query است؛ اندازه‌گیری آن مستقل بازتولید نشده و مثال orders از آن استخراج نشده است.

## شکست‌ها، سیگنال‌ها و چک‌لیست

پارامتر نامعمول، statistics reset، تغییر ترافیک یا اجرای benchmark فقط با cache گرم می‌تواند مقایسه را منحرف کند. آمار تجمیعی percentile نیست؛ mean را p95 ننامید. EXPLAIN ANALYZE روی write واقعاً write را اجرا می‌کند؛ ROLLBACK همه اثرهای خارجی trigger/sequence را خنثی نمی‌کند. این درس صرفاً SELECT آزمایشی دارد. query text و plan را نیز با سیاست داده حساس نگهداری کنید.

- [ ] بازه، reset، تعداد calls و ترافیک مقایسه مشخص‌اند.
- [ ] زمان Pool، SQL، شبکه و mapping از هم تفکیک شده‌اند.
- [ ] ranking هم هزینه مجموع و هم اثر روی SLO را در نظر می‌گیرد.
- [ ] estimate/actual، loops، buffers و spill بررسی شده‌اند.
- [ ] فقط یک تغییر با خروجی و داده نماینده سنجیده می‌شود.
- [ ] سربار instrumentation، مجوز و دسترسی به SQL/plan کنترل شده‌اند.
- [ ] نتیجه با latency انتهابه‌انتها و هزینه write تأیید می‌شود.

## پیش‌نیازها و محاسبه هزینه query

Profiling هزینه را به مسیر یا خانواده query نسبت می‌دهد. calls تعداد اجرا، mean متوسط زمان، و total زمان جمع‌شده همان بازه است. EXPLAIN cost واحد planner است و میلی‌ثانیه نیست؛ EXPLAIN ANALYZE query را واقعاً اجرا می‌کند. counters را در دو زمان با کلید هویت query تطبیق دهید و بازه reset را ثابت نگه دارید.

### حل عددی مثال و تمرین

برای A، ۱۰٬۰۰۰ اجرا × ۲ms = ۲۰٬۰۰۰ms = ۲۰s است. برای B، ۱۰ اجرا × ۲۰۰ms = ۲٬۰۰۰ms = ۲s است. پس A ده برابر زمان جمع‌شده مصرف کرده و نخستین گزینه بررسی ظرفیت است؛ B ممکن است به‌خاطر SLO یا tail همچنان مهم باشد. بعد از تغییر فقط A، calls، total، نرخ درخواست، ترکیب داده و latency انتهابه‌انتها را در پنجره مشابه مقایسه کنید. اگر calls نصف شده، کاهش total به‌تنهایی بهبود را ثابت نمی‌کند.

### مسیر عیب‌یابی

کندی درخواست را به acquire wait، SQL، شبکه و mapping تفکیک کنید. query پرتکرار را از counters و query نادر مهم را از trace/SLO بیابید. در plan rows estimate/actual و loops را بخوانید؛ زمان والد کار فرزند را دارد، پس زمان گره‌ها را جمع نکنید. buffers و temp I/O را برای حافظه/دیسک ببینید و پارامتر نماینده استفاده کنید. یک تغییر بدهید و مقایسه را با بار و وضعیت cache مشخص تکرار کنید. EXPLAIN ANALYZE روی query نوشتنی واقعاً می‌نویسد؛ تراکنش همه اثرهای جانبی را خنثی نمی‌کند.

## جمع‌بندی

آمار تجمعی محل کار بزرگ را می‌یابد؛ plan اجرای مشخص را توضیح می‌دهد؛ trace اثر بر درخواست را می‌سنجد. ابزارها مکمل‌اند و هرکدام محدودیت دارند.

## خودآزمایی

۱. cost در EXPLAIN میلی‌ثانیه است؟

۲. آیا mean_exec_time همان p99 است؟

۳. چرا queryهای سریع پرتکرار در رتبه‌بندی مهم‌اند؟

۴. EXPLAIN با EXPLAIN ANALYZE چه تفاوتی دارد؟

۵. چرا جمع زمان همه گره‌های plan درست نیست؟

۶. اگر total_exec_time پیش/پس کم شد ولی calls نیز نصف شد، چه نتیجه‌ای می‌گیرید؟

### پاسخ‌نامه با دلیل

۱. خیر؛ واحد تخمینی مدل هزینه planner است و نباید با ساعت مقایسه مستقیم شود.

۲. خیر؛ میانگین است. percentile به توزیع اجراها یا histogram/trace مناسب نیاز دارد.

۳. تعداد زیاد می‌تواند هزینه مجموع، ظرفیت CPU و رفت‌وبرگشت را غالب کند.

۴. اولی تخمین پلن است؛ دومی واقعاً اجرا و اندازه‌گیری می‌کند و سربار/اثر دارد.

۵. زمان والد شامل کار فرزند است؛ جمع ساده دوباره‌شماری می‌کند و loops نیز باید تفسیر شود.

۶. بهبود ثابت نشده؛ حجم و ترکیب بار تغییر کرده‌اند. نرخ/هزینه هر call و پنجره قابل مقایسه لازم است.

## منابع اختیاری برای مطالعه بیشتر

پیوندهای این بخش برای مطالعه تکمیلی و بررسی جزئیات نسخه/محصول‌اند؛ برای فهم سازوکار و انجام تمرین لازم نیستند.

- انگلیسی: [Using EXPLAIN](https://www.postgresql.org/docs/current/using-explain.html)؛ خواندن plan و caveatهای اندازه‌گیری.
- انگلیسی: [pg_stat_statements](https://www.postgresql.org/docs/current/pgstatstatements.html) و [Monitoring](https://www.postgresql.org/docs/current/monitoring.html)؛ تجمیع و مشاهده فعالیت.
- فارسی: [تشخیص و بهینه‌سازی PostGIS با EXPLAIN](https://asnegar.ir/blog/postgis-optimization/)؛ مثال مرتبط با حدود شواهد بیان‌شده، نه مرجع تمام جزئیات PostgreSQL.

- English, official: [PostgreSQL auto_explain](https://www.postgresql.org/docs/current/auto-explain.html) describes logging plans for slow statements and instrumentation overhead.
- English, official: [PostgreSQL monitoring](https://www.postgresql.org/docs/current/monitoring.html) locates activity views and system-level signals for diagnosis.
- English, official: [pg_stat_statements](https://www.postgresql.org/docs/current/pgstatstatements.html) explains normalized query aggregates and counter lifecycle.

[فهرست فصل](../README.md) · [فهرست مجموعه](../../README.md) · [قبلی: Sharding](../11-sharding/README.md) · [شروع دوباره از Pooling](../01-connection-pooling/README.md) · [Slow logs](../09-slow-query-logging/README.md) · [Application profiling](../../06-code-optimization/02-application-profiling/README.md) · [آزمون عملکرد](../../09-performance-testing/README.md)

</div>


