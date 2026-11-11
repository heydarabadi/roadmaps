<div dir="rtl" align="right">

# GraphQL و gRPC

GraphQL به client امکان می‌دهد ساختار دادهٔ درخواستی را انتخاب کند؛ schema type-safe، introspection و resolver دارد. برای clientهای با نیاز نمایشی متفاوت مفید است، اما query complexity، N+1، authorization در سطح field، cache و versioning نیازمند طراحی‌اند. یک endpoint واحد، مسئولیت policy را حذف نمی‌کند.

gRPC بر RPC و قرارداد Protocol Buffers تکیه می‌کند؛ code generation، streaming و کارایی در ارتباط سرویس‌به‌سرویس از مزیت‌های رایج‌اند. browser/client و tooling ممکن است bridge نیاز داشته باشند. تغییر field number در protobuf خطرناک است و قرارداد باید سازگار evolve شود.

## تصمیم

| معیار | GraphQL | gRPC |
| --- | --- | --- |
| مخاطب رایج | UI و چند client با نیاز دادهٔ متفاوت | ارتباط backend و streaming |
| قرارداد | schema قابل‌پرس‌وجو | proto service/message |
| ریسک اصلی | query پرهزینه و دسترسی ریزدانه | سازگاری proto و ابزار client |

## GraphQL: مسیر یک query

Client یک operation را روی schema می‌فرستد. parser و validator نام fieldها و typeها را بررسی می‌کنند؛ resolverها داده را می‌خوانند و پاسخ shape شده بازمی‌گردد. این انعطاف محدودیت می‌خواهد:

- **N+1:** resolver برای هر محصول seller را جدا می‌خواند؛ batching درخواست‌های هم‌زمان را گروه می‌کند.
- **هزینهٔ query:** محدودیت عمق کافی نیست؛ query عریض یا field پرهزینه منابع می‌گیرد. complexity budget، سقف node، timeout و rate limit لازم است.
- **authorization:** فیلد حساس باید در resolver یا policy مجوز بگیرد؛ مخفی‌کردن field در UI کنترل دسترسی نیست.
- **cache:** پاسخ به query و variable وابسته است؛ persisted query یا cache در سطح field ممکن است مناسب باشد.
- **versioning:** فیلد را اضافه کن، قدیمی را deprecated کن، مصرف را اندازه بگیر و سپس حذف کن.

## gRPC و قرارداد Protocol Buffers

تعریف proto، service و message به تولید stub در زبان‌های مختلف می‌انجامد. field number شناسهٔ wire format است: شماره را دوباره استفاده نکن؛ field حذف‌شده را reserve کن. فیلد جدید را سازگار اضافه کن تا client قدیمی ادامه دهد. deadline را در تماس منتقل و status code را قراردادی انتخاب کن.

Streaming می‌تواند client، server یا دوطرفه باشد؛ backpressure، cancellation، طول عمر stream و retry پس از قطع را طراحی کن. gRPC روی browser خام ممکن است gateway یا bridge بخواهد.

## تصمیم کاربردی

برای صفحهٔ وب با نیاز دادهٔ متنوع، GraphQL می‌تواند round trip را کم کند؛ برای قرارداد ساده، REST ممکن است cacheپذیرتر و قابل‌کشف‌تر باشد. برای تماس داخلی typed و stream، gRPC را بسنج؛ برای workflowی که مستقل از caller ادامه می‌یابد، پیام async را هم مقایسه کن. معیارها latency، tooling، امنیت و عملیات‌اند.

## آزمون

۱. GraphQL چگونه over-fetching را کاهش می‌دهد؟ **پاسخ:** client فقط fieldهای لازم را درخواست می‌کند.
۲. چرا این ویژگی می‌تواند سوءاستفاده شود؟ **پاسخ:** query عمیق یا سنگین منابع سرور را مصرف می‌کند؛ limit و cost control لازم است.
۳. gRPC چرا code generation دارد؟ **پاسخ:** قرارداد مشترک را به stub و type برای زبان‌های پشتیبانی‌شده تبدیل می‌کند.
۴. انتخاب را بر چه اساس انجام می‌دهی؟ **پاسخ:** مخاطب، قرارداد، latency، tooling، امنیت و نیاز streaming.

## تمرین

برای یک صفحهٔ product detail، GraphQL در برابر REST؛ برای ارسال رویداد داخلی order-to-inventory، gRPC در برابر پیام async مقایسه کن.

## پاسخ نمونهٔ تمرین

برای جزئیات محصولی که UI فیلدهای ترکیبی متغیر دارد GraphQL می‌تواند query یک‌مرحله‌ای، cost limit و field authorization داشته باشد؛ اگر cache استاندارد/سادگی اولویت است REST گزینهٔ روشن‌تری است. برای stock reservation که نتیجهٔ لازم فوری است gRPC sync ممکن است مناسب باشد؛ اگر consumer مستقل و نتیجهٔ با تأخیر پذیرفتنی است queue/event جداسازی failure می‌دهد. latency و semantics از syntax مهم‌ترند.

## منابع

- فارسی: [مبانی معماری فارسی](https://www.alirostami.com/software-architecture/)، [مقالات REST و GraphQL در DNTips](https://www.dntips.ir/)
- انگلیسی: [GraphQL Learn](https://graphql.org/learn/)، [gRPC Introduction](https://grpc.io/docs/what-is-grpc/introduction/)

</div>

