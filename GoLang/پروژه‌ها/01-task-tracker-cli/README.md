# پروژهٔ ۱ — مدیریت کارها در CLI

<div dir="rtl">

## مسئله و قرارداد

برنامهٔ خط فرمانی بساز که کارها را در فایل JSON محلی نگه دارد و add، list، done، remove و search را پشتیبانی کند. خروجی موفق برای انسان خوانا باشد؛ خطا به stderr برود و status code غیرصفر بدهد.

نمونهٔ رابط:

~~~text
tasks add --title "خرید کتاب"
tasks list [--all]
tasks done --id 12
tasks remove --id 12
tasks search --query "کتاب"
~~~

فرض نسخهٔ اول: در هر لحظه فقط یک process می‌نویسد. این محدودیت را در README نگه دار؛ JSON file جایگزین database چندکاربره نیست.

## مدل و invariant

~~~go
type Task struct {
    ID        int64         `json:"id"`
    Title     string        `json:"title"`
    CreatedAt time.Time     `json:"created_at"`
    DoneAt    *time.Time    `json:"done_at,omitempty"`
}
~~~

Invariantها: ID مثبت و یکتا؛ عنوان پس از trim خالی نباشد؛ زمان ایجاد ثابت؛ DoneAt=nil یعنی تکمیل نشده؛ list ترتیب پایدار بر اساس ID یا زمان داشته باشد.

## ساختار پیشنهادی

~~~text
task-tracker/
  go.mod
  cmd/tasks/main.go
  internal/task/task.go
  internal/store/jsonfile.go
  internal/cli/cli.go
~~~

برای نمونهٔ کوچک لازم نیست از ابتدا همه‌چیز را به package تقسیم کنی. هر package باید مسئولیت واقعی و مرز import روشن داشته باشد. package main کارها را به هم وصل کند، نه اینکه business logic را نگه دارد.

## گام ۱: مدل و قواعد

تابع خالص برای ساخت Task/اعتبارسنجی عنوان بساز. تولید ID و زمان را قابل‌تست نگه دار. abstraction زمان فقط وقتی بساز که test واقعاً ساعت ثابت لازم داشته باشد.

**پذیرش:** عنوان فاصله‌ای رد، عنوان معتبر حفظ، invariantهای مدل test شده باشند.

## گام ۲: repository در حافظه

عملیات Create، List، Complete و Delete را پیاده کن. map برای نگاشت ID به Task مناسب است اما ترتیب آن تضمین ندارد؛ List باید کپی مرتب‌شده برگرداند تا caller بتواند بدون تغییر storage کار کند.

interface را فقط اگر چند implementation واقعی یا fake تستی مفید است اضافه کن. اگر هیچ seam لازم نیست، concrete type ساده‌تر است.

## گام ۳: فایل JSON

در load، نبودن فایل اولین اجرای خالی باشد؛ JSON خراب را خالی تفسیر نکن چون می‌تواند از دست‌رفتن داده را پنهان کند. مسیر را از flag، environment یا user data directory بگیر، نه از مسیر ثابت repository.

نوشتن مقاوم‌تر: directory با permission مناسب، فایل موقت کنار مقصد، encode و بررسی خطا، close/sync طبق نیاز، rename و پاک‌سازی فایل موقت در شکست. rename احتمال مشاهدهٔ فایل نیمه‌نوشته را کم می‌کند؛ durability در قطع برق و transaction چند process را تضمین نمی‌کند.

## گام ۴: CLI و error

argument parsing را از منطق application جدا کن. ابتدا argument را parse، سپس use case را صدا بزن. error داخلی را با operation و مسیر wrap کن و در مرز CLI به متن امن تبدیل کن. متن SQL یا stack trace در CLI لازم نیست. قرارداد exit code را مستند کن چون shell و automation آن را می‌خوانند.

**پذیرش:** add/list/done/remove/search کار کنند؛ ID ناموجود خطای قابل‌فهم دهد؛ search دربارهٔ حساسیت به حروف قرارداد روشن داشته باشد.

## گام ۵: تست

- table-driven برای عنوان، create، complete، delete و ID ناموجود.
- store fake برای تست CLI بدون دیسک.
- فایل store در t.TempDir.
- فایل خراب، missing و write failure را پوشش بده.
- JSON را decode کن و fieldهای قرارداد را بررسی کن؛ whitespace خروجی را بی‌دلیل assert نکن.
- پیام خطا را کامل و شکننده مقایسه نکن، مگر متن دقیق خودش قرارداد محصول باشد.

## گام ۶: سخت‌سازی

help و exit code، حداکثر تعداد کار یا اندازهٔ فایل، permission مناسب، عدم افشای اطلاعات حساس، و limitation هم‌زمانی را مشخص کن. تست کن write ناموفق نسخهٔ قبلی فایل را حفظ کند. اگر چند process هم‌زمان مجاز است، atomic rename کافی نیست: lost update ممکن است رخ دهد و lock یا storage تراکنشی لازم است.

## تجربهٔ کاربردی

CLIها معمولاً داخل script و automation اجرا می‌شوند؛ خروجی پایدار، status code، مسیر config، cleanup و رفتار در failure اهمیت دارند. ابزار کوچک JSON-based را با database production اشتباه نگیر: query، migration، backup، concurrency و recovery نیازهای جدا دارند.

## تمرین پاسخ‌دار

**چرا فایل خراب را خالی فرض نکنیم؟** چون خطای داده را پنهان می‌کند و ممکن است کاربر دادهٔ موجود را overwrite کند.  
**چرا list را از map مستقیم چاپ نکنیم؟** ترتیب map تضمین نیست؛ خروجی پایدار نیاز به sort دارد.  
**آیا atomic rename مشکل چند process را حل می‌کند؟** خیر؛ write اتمیک می‌تواند آخرین نویسنده را برنده کند و update دیگری را از دست بدهد.  
**چرا main مسئول exit status است؟** چون process boundary قرارداد CLI است؛ domain نباید process را terminate کند.

## کوییز

### پرسش‌ها

1. چرا فرض تک‌process را صریح می‌کنیم؟
2. invariant عنوان چیست؟
3. چرا JSON خراب را خالی فرض نمی‌کنیم؟
4. خروجی error به کجا می‌رود؟
5. چرا map order را برای ID و output به کار نمی‌بریم؟
6. فایل موقت بهتر است کجا ساخته شود؟
7. rename چه چیزی را کاهش می‌دهد و چه چیزی را تضمین نمی‌کند؟
8. چه زمانی interface برای store ارزشمند است؟
9. برای فایل تست از چه helperی استفاده می‌کنی؟
10. exit code برای چه کسی مهم است؟
11. چند process هم‌زمان چه خطری دارد؟
12. JSON file برای چند کاربر هم‌زمان مناسب است؟

### کلید پاسخ

1. تا محدودیت دامنه و نیاز به synchronization روشن بماند.
2. پس از trim خالی نباشد.
3. چون دادهٔ خراب یا ناسازگار را پنهان می‌کند.
4. stderr.
5. ترتیب map نامعین است و ID نیاز به تولید یکتا دارد.
6. همان directory مقصد برای امکان rename در همان filesystem.
7. احتمال فایل نیمه‌نوشته را کم می‌کند؛ durability و transaction را تضمین نمی‌کند.
8. وقتی چند implementation واقعی یا seam تستی نیاز است.
9. t.TempDir.
10. shell و automation.
11. lost update؛ هر دو snapshot قبلی را می‌خوانند و یکی تغییر دیگری را overwrite می‌کند.
12. خیر؛ قفل، transaction، backup و recovery جدا لازم‌اند.

## معیار پایان

قرارداد، invariant، تست شکست و موفقیت، recovery فایل خراب و محدودیت concurrency در README روشن باشند. سپس [پروژهٔ API](../02-catalog-http-api/README.md) را شروع کن.



**نسخهٔ انگلیسی:** [مطالعهٔ این صفحه به انگلیسی](README.en.md)
</div>
