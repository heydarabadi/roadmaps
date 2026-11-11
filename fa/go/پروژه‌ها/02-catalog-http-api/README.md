# پروژهٔ ۲ — API کاتالوگ HTTP

<div dir="rtl">

## مسئله و قرارداد

سرویس کاتالوگ کوچک بساز. نسخهٔ اول در حافظه است تا HTTP، validation، error contract و test را یاد بگیری؛ persistence را پس از تثبیت رفتار اضافه کن.

| Method | Path | رفتار |
|---|---|---|
| GET | /healthz | سلامت اولیهٔ process |
| GET | /v1/items | فهرست و pagination محدود |
| GET | /v1/items/{id} | خواندن یک مورد |
| POST | /v1/items | ساخت مورد |
| PATCH | /v1/items/{id} | تغییر فیلدهای مجاز |
| DELETE | /v1/items/{id} | حذف |

body، status، header، error JSON و ورودی نامعتبر را برای هر route پیش از پیاده‌سازی تعریف کن. endpoint ناتمام را موفق جلوه نده.

## مدل دامنه و DTO

مدل دامنه invariant برنامه را نگه می‌دارد؛ DTO قرارداد بیرونی است. جداکردن آن‌ها از نشت field داخلی یا شکستن مدل دامنه هنگام تغییر API جلوگیری می‌کند.

~~~go
type Item struct {
    ID         int64
    Name       string
    PriceCents int64
    CreatedAt  time.Time
}

type createItemRequest struct {
    Name       string `json:"name"`
    PriceCents int64  `json:"price_cents"`
}
~~~

struct tagها قرارداد JSON را روشن می‌کنند و خودشان validation نمی‌کنند. شناسه، timestamp و fieldهای پاسخ را مطابق قرارداد بیرونی بنویس.

## ساختار پیشنهادی

~~~text
catalog-api/
  cmd/catalog/main.go
  internal/catalog/item.go
  internal/catalog/service.go
  internal/catalog/repository.go
  internal/httpapi/handler.go
  internal/httpapi/handler_test.go
  go.mod
~~~

repository interface فقط methodهایی داشته باشد که use case واقعاً لازم دارد: Get, List, Create, Update, Delete. interface کوچک را سمت مصرف‌کننده تعریف کن. اگر یک implementation کافی است، concrete type مستقیم از interface بی‌دلیل ساده‌تر است.

## milestone ۱: route و status

از http.NewServeMux استفاده کن. method اشتباه پاسخ کنترل‌شده و Allow header بگیرد. statusهای نمونه: 201 ساخت، 200 پاسخ JSON، 204 حذف، 400 ورودی نامعتبر، 404 مورد ناموجود، 405 method اشتباه، 409 تعارض یکتا، 500 شکست غیرمنتظره.

helper واحد JSON پاسخ را بنویس تا content type و encode error یک‌جا مدیریت شوند. header را قبل از body بفرست.

## milestone ۲: decode و validation

body را size limit کن؛ JSON نحوی را decode کن؛ در قرارداد strict unknown field را رد کن؛ decode دوم انجام بده و trailing document را رد کن؛ سپس validation دامنه و authorization را اجرا کن. parse موفق به معنی اعتبار کسب‌وکار نیست.

خطای request را به کد public پایدار مثل invalid_item تبدیل کن. detail داخلی و SQL را به caller نده و payload یا credential حساس را log نکن. اگر Go 1.27+ و baseline module مناسب است، json/v2 را ارزیابی کن؛ migration باید براساس compatibility و قرارداد client باشد.

## milestone ۳: use case و خطا

handler نازک: parse → فراخوانی application → تبدیل error به HTTP. service قواعد کسب‌وکار را نگه دارد. repository خطا را با context wrap کند. errors.Is/As را برای دسته‌بندی به‌کار ببر، نه جست‌وجوی متن.

خطای مورد ناموجود را از خطای storage جدا نگه دار. اگر database down است، 404 گفتن واقعیت را مخفی می‌کند و caller را به تصمیم اشتباه می‌رساند.

## milestone ۴: lifecycle و context

ReadHeaderTimeout, ReadTimeout, WriteTimeout و IdleTimeout را متناسب با API تنظیم کن. r.Context را تا service، database و outbound HTTP منتقل کن. timeout زیرسیستم‌ها را در بودجهٔ deadline کل request نگه دار.

با SIGTERM پذیرش کار جدید را متوقف و Server.Shutdown را با مهلت محدود اجرا کن. worker پس‌زمینه، transaction و connection pool هم lifecycle می‌خواهند؛ بستن listener به‌تنهایی کافی نیست.

## milestone ۵: تست

- ResponseRecorder برای تست مستقیم handler.
- Server برای client، transport، redirect و header واقعی.
- Go 1.27+ تابع NewTestServer دارد و برای fake network حافظه‌ای با synctest طراحی شده؛ نسخه‌های قدیمی از Recorder یا Server استفاده کنند.
- مسیر موفق، JSON خراب، body بزرگ، field ناشناخته، trailing document، مقدار منفی، ID گمشده و method اشتباه را پوشش بده.
- repository error باید به پاسخ 500 امن بدل شود.
- لغو context باید به dependency برسد.
- response DTO نباید field داخلی را افشا کند.
- status و header را assert و JSON را decode کن؛ whitespace خام را مبنا نگذار.

## milestone ۶: database واقعی

وقتی persistence لازم شد، database را به‌دلیل نیاز انتخاب کن. query پارامتری، pool و context timeout، migration نسخه‌دار و transaction مطابق invariant لازم است. ORM نیاز به schema، index، transaction یا authorization را حذف نمی‌کند. pgx/GORM را با نیاز SQL control و مهارت تیم مقایسه کن.

## امنیت و عملیات

authentication هویت را می‌سنجد؛ authorization اجازهٔ عمل را. threat model ممکن است TLS termination، rate limit، audit، log redaction، request ID و monitoring را لازم کند. این نمونه identity ندارد؛ endpoint مدیریتی را بدون کنترل دسترسی public نکن.

liveness و readiness دو پرسش متفاوت‌اند. health endpointی که process را می‌سنجد database readiness را تضمین نمی‌کند.

## تمرین با پاسخ

**چرا 404 و 500 را جدا می‌کنیم؟** مورد ناموجود نتیجهٔ موردانتظار است؛ storage failure خطای سرویس.  
**آیا SQL را در پاسخ client می‌نویسیم؟** خیر؛ اطلاعات داخلی است. کد پایدار را بیرون و علت را در log کنترل‌شده نگه دار.  
**چرا فقط outbound timeout کافی نیست؟** ورودی کند نیز connection و goroutine سمت server را نگه می‌دارد.  
**چه چیزی handler را testable می‌کند؟** dependency صریح و جدایی mapping HTTP از منطق دامنه.

## کوییز

### پرسش‌ها

1. چرا قبل از handler قرارداد endpoint را می‌نویسیم؟
2. DTO چه تفاوتی با domain model دارد؟
3. body size limit از چه چیزی محافظت می‌کند؟
4. parse موفق چه چیزی را اثبات نمی‌کند؟
5. چرا storage error نباید 404 شود؟
6. خطای machine-readable چه کمکی می‌کند؟
7. r.Context را تا کدام لایه‌ها می‌بریم؟
8. ReadHeaderTimeout چه خطری را کم می‌کند؟
9. handler مستقیم را با چه ابزاری test می‌کنیم؟
10. client و transport را با چه ابزاری test می‌کنیم؟
11. shutdown فقط با بستن listener کامل است؟
12. ORM query امن و transaction را حذف می‌کند؟
13. authentication و authorization چه تفاوتی دارند؟
14. چه چیزهایی نباید در response خطای داخلی بیاید؟

### کلید پاسخ

1. تا status، schema و failure برای client قابل‌پیش‌بینی باشد.
2. DTO مرز بیرونی است؛ domain model قانون و invariant برنامه.
3. مصرف نامحدود memory و CPU.
4. business validation، authorization یا نبودن دادهٔ trailing را.
5. database unavailable با مورد پیدا نشدن فرق دارد.
6. caller بر اساس کد ثابت تصمیم می‌گیرد؛ متن برای نمایش است.
7. use case، database و outbound callهای cancellation-aware.
8. slow header client که connection را نگه می‌دارد.
9. httptest.ResponseRecorder.
10. httptest.Server؛ در Go 1.27+ NewTestServer برای fake network.
11. خیر؛ worker و request جاری نیز drain/cancel شوند.
12. خیر.
13. احراز هویت در برابر تصمیم دسترسی.
14. SQL، stack، secret، مسیر داخلی و payload حساس.

## معیار پایان

قرارداد endpoint، تست مرزی، خطاهای پایدار، cancellation، timeout و threat model را مستند کن. سپس [URL checker](../03-concurrent-url-checker/README.md) را انجام بده.



**نسخهٔ انگلیسی:** [مطالعهٔ این صفحه به انگلیسی](README.en.md)
</div>
