<div dir="rtl" align="right">

# Salesforce و معماری CRM

Salesforce یک CRM ابری با object model، automation، role/sharing، API و قابلیت توسعه از راه platform است. معمار باید data ownership، tenant/security model، governor limits، integration throughput، package lifecycle، sandbox و deployment را در طراحی بگنجاند. کد سفارشی باید تنها جایی افزوده شود که declarative capability یا product fit کافی نیست.

Integration می‌تواند API هم‌زمان، platform event یا batch باشد. برای هر جریان قرارداد، idempotency، retry، replay، ordering و reconciliation را تعریف کن. CRM غالباً داده‌های حساس مشتری دارد؛ least privilege، field-level access و audit نیاز به بررسی در APIهای بیرونی دارند.

## مدل object، sharing و حد platform

Object و field را با فرایند واقعی و مالکیت داده تطبیق بده؛ schema سفارشی بی‌نیاز ممکن است هزینهٔ migration و گزارش بسازد. Role hierarchy، sharing rule، permission set و field-level access روی visibility اثر دارند، ولی هر API integration و user context را جدا بررسی کن. Governor limits معماری را محدود می‌کنند: query/selectivity، batch، transaction size، callout و concurrency باید در design دیده شوند.

## integration: sync، event یا batch

Sync API وقتی caller به نتیجهٔ فوری نیاز دارد؛ platform event وقتی subscriberهای جدا باید به تغییر واکنش دهند؛ batch وقتی حجم بالا و freshness پایین‌تر پذیرفتنی است. برای هر روش قرارداد، rate limit، identity، replay، idempotency و reconciliation تعریف کن. Event replay و retention را با معنای exactly-once اشتباه نگیر.

## ALM و lifecycle بسته

Sandboxها محیط آزمایش‌اند ولی production را کاملاً بازنمایی نمی‌کنند. package/source control، metadata dependency، permission و data migration را version کن. Deploy plan شامل validation، regression، smoke check، rollback یا forward-fix و owner باشد. Org sprawl و customization با مالک نامعلوم هزینهٔ upgrade را زیاد می‌کنند.

## امنیت مشتری

Least privilege، MFA، session policy، audit، retention و data minimization را پوشش بده. Token یا PII را log نکن. External service باید user/connected app identity محدود داشته باشد؛ sharing داخل CRM جای مجوزدهی endpoint فروشگاه را نمی‌گیرد.

## آزمون

۱. governor limit چه چیزی را نشان می‌دهد؟ **پاسخ:** محدودیت مصرف منابع پلتفرم که بر طراحی query و عملیات اثر می‌گذارد.
۲. چرا event integration مفید است؟ **پاسخ:** decoupling و پردازش async فراهم می‌کند؛ در عوض consistency فوری نمی‌دهد.
۳. کد سفارشی زیاد چه خطری دارد؟ **پاسخ:** نگهداری، upgrade و وابستگی به platform را بالا می‌برد.
۴. sharing rule جای authorization سرویس بیرونی است؟ **پاسخ:** باید مجوز در مرز API هم درست اعمال و آزمون شود.

## تمرین

برای همگام‌سازی customer بین CRM و فروشگاه، مالک فیلدها، conflict policy، event failure و replay را مشخص کن.

## پاسخ نمونهٔ تمرین

برای هر field (email, segment, consent) owner مشخص؛ conflict با source-of-truth/precedence rule نه آخرین timestamp کور حل می‌شود. Event دارای event ID/schema version و replay window است. consumer deduplicate و checkpoint می‌کند؛ خطای transient retry، poison event DLQ با alert؛ reconciliation دوره‌ای customer IDs و consent را تطبیق می‌دهد. security sharing به endpoint دوم منتقل می‌شود.

## منابع

- فارسی: [مبانی معماری فارسی](https://www.alirostami.com/software-architecture/)، [نقشهٔ معماری سازمانی](https://codingcogs.org/road-maps/software-architecture)
- انگلیسی: [Salesforce Architecture Center](https://architect.salesforce.com/)، [Salesforce Developers](https://developer.salesforce.com/docs/)

</div>

