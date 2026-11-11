<div dir="rtl" align="right">

# پروژهٔ جامع: معماری فروشگاه آنلاین

## مسئله

فروشگاه باید کاتالوگ، سبد، سفارش، پرداخت، موجودی، ارسال، فاکتور و گزارش را پشتیبانی کند. تیم کوچک است و دامنه هنوز رشد می‌کند. تجربهٔ خرید باید قابل‌اعتماد باشد؛ burst کمپین، خطای provider پرداخت، درخواست تکراری، data privacy، observability و امکان تغییر ruleها مطرح‌اند.

## پیشنهاد آغازین

با modular monolith شروع کن و ماژول‌های catalog، checkout/order، inventory، billing و reporting را با API داخلی و dependency rule جدا کن. PostgreSQL برای transactional order/payment ledger؛ object storage برای تصویر؛ queue پایدار برای فاکتور و اعلان؛ read model جدا برای reporting. API عمومی versioned باشد؛ payment provider از adapter boundary عبور کند.

این طرح یک فرض آموزشی است و باید با حجم، پلتفرم تیم، الزامات مالی و مقررات اصلاح شود. مرزهای سرویس را بعد از مشاهدهٔ تغییر و نیاز انتشار/scale مستقل بازبینی کن. برای event publish، transaction outbox و consumer idempotent طراحی کن.

## خروجی‌هایی که بساز

۱. stakeholder و سه سناریوی کیفیت با معیار.  
۲. C4 context و container؛ sequence پرداخت موفق، timeout و refund.  
۳. context map و مالکیت Customer/Order/Inventory/Payment.  
۴. ADR برای modular monolith، relational store، queue و provider adapter.  
۵. threat model برای IDOR، token، callback و نشت داده.  
۶. API contract، migration expand/contract و پیام event versioned.  
۷. deployment view، CI/CD، backup/restore و incident runbook.  
۸. SLI/SLO برای checkout، سنجهٔ freshness گزارش و error budget.

## نمونهٔ تصمیم

### ADR: ثبت نتیجهٔ پرداخت

**زمینه:** callback بیرونی ممکن است دیر یا تکراری برسد.  
**گزینه‌ها:** update ساده؛ idempotency key و ledger؛ event sourcing کامل.  
**تصمیم آغازین:** payment attempt با provider reference یکتا و وضعیت‌های محدود؛ callback با idempotency و audit ثبت شود.  
**پیامد:** retry امن‌تر و عیب‌یابی بهتر؛ نیاز به reconciliation روزانه و مدیریت وضعیت نامشخص.  
**بازنگری:** هنگام نیاز به چند provider، dispute گسترده یا تاریخچهٔ قابل‌بازسازی.

## معیار ارزیابی خودت

آیا نیازها سنجش‌پذیرند؟ آیا هر داده owner دارد؟ آیا failure mode در هر boundary دیده شده؟ آیا هر فناوری یک مسئلهٔ مشخص حل می‌کند؟ آیا راه مهاجرت برگشت‌پذیر است؟ اگر بخشی از پاسخ «نه» است، نقشه را اصلاح کن.

## راه‌حل مرجع مرحله‌به‌مرحله

راه‌حل یگانه نیست؛ این نمونه شروعی برای بحث است.

۱. **سناریوها:** checkout عادی، peak کمپین، callback تکراری، provider کند، restore بعد از حذف اشتباه، گزارش با تأخیر. برای هرکدام actor، load، response، احتمال و recovery را مشخص کن.
۲. **ساختار آغازین:** modular monolith برای تیم کوچک؛ مرزهای داخلی order، inventory، payment و catalog با مالک داده و قرارداد. جداسازی deployment فقط وقتی شواهد scale/ownership/failure isolation می‌آید.
۳. **پرداخت:** ثبت intent و idempotency key، stateهای Pending/Authorized/Failed/Refunded، callback امضاشده و replay-protected، reconciliation برای نتیجهٔ مبهم؛ هرگز timeout را معادل failure قطعی ندان.
۴. **موجودی:** invariant عدم فروش بیش از موجودی در مالک inventory enforce می‌شود؛ reservation زمان‌دار و آزادسازی پس از timeout برای فرایند چندمرحله‌ای.
۵. **گزارش:** outbox/event یا CDC کنترل‌شده به warehouse؛ metric دارای grain، timezone، currency و freshness؛ checkout به query تحلیلی سنگین وابسته نمی‌شود.
۶. **امنیت:** threat model برای IDOR، session/token، webhook، PII، staff access و backup؛ authorization در هر resource؛ secret و key rotation.
۷. **عملیات:** artifact immutable، rollout تدریجی، schema expand/contract، health/telemetry، RPO/RTO و restore drill؛ error budget و runbook.

## پرسش‌های دفاع از تصمیم

- چرا سفارش و پرداخت در یک transaction نیستند؟ چه تضمینی جایگزین اتمی بودن می‌گذاری؟
- اگر callback اصلاً نرسید چه چیزی state را به نتیجه می‌رساند؟
- کدام دادهٔ کاتالوگ stale می‌تواند باشد و تا چه حد؟
- چه اتفاقی می‌افتد اگر صف عقب بماند یا provider طولانی کند شود؟
- چه تصمیمی را امروز نگه می‌داری و با چه شواهدی بعداً بازبینی می‌کنی؟

## تحویل نهایی پروژه

بستهٔ تصمیم باید شامل یک صفحهٔ خلاصه برای مدیر محصول، نمودار context/container، یک sequence برای timeout، threat model اولویت‌دار، سه ADR، قرارداد API/event، جدول مالکیت داده، طرح deployment/recovery و آزمون سناریویی باشد. هر سند تاریخ، owner و فرض‌های نامطمئن را ثبت کند.

## تمرین: دفاع معماری

در یک جلسهٔ ۱۵ دقیقه‌ای از طراحی خود دفاع کن: یک stakeholder نقش مشتری ناراضی، یک نفر اپراتور و یک نفر مسئول مالی را بازی کند. هرکدام یک failure بدهند؛ تو باید مسیر تصمیم، دادهٔ معتبر و پیامد را نشان بدهی. سپس نظر مخالف را در ADR ثبت و بگو چه شواهدی نظرت را عوض می‌کند.

**معیار پاسخ:** پاسخ خوب فقط نمودار سرویس‌ها نیست؛ نیاز سنجش‌پذیر، مالک data، حالت failure، بازیابی، امنیت و هزینهٔ تیمی را به تصمیم وصل می‌کند. اگر یک سرویس را جدا کرده‌ای، release، on-call و data ownership مستقلش را نشان بده.

## آزمون

### پرسش‌های کوتاه پروژه

۱. اگر provider timeout دهد، آیا پرداخت قطعاً شکست خورده؟ **پاسخ:** نه؛ نتیجه نامشخص است و باید idempotency یا استعلام وضعیت/reconciliation داشت.
۲. چرا گزارش را از مسیر checkout جدا می‌کنی؟ **پاسخ:** workload تحلیلی را از latency و resource تراکنش دور می‌کند؛ freshness و lineage باید طراحی شود.
۳. کدام موضوع می‌تواند تصمیم ماژولار را به سرویس مستقل تبدیل کند؟ **پاسخ:** شواهدی مانند انتشار/scale مستقل، owner واقعی و نیاز failure isolation همراه با توان عملیات.

## منابع مطالعهٔ پروژه

- فارسی: [کارگاه Microservices در عمل](https://hadi-ahmadi.com/training/2024/microservices-in-practice-service-design-and-integration/)، [راهنمای فارسی DDD](https://github.com/hheydarian/Understanding-Domain-Driven-Design)، [EventDrivenFarsi](https://github.com/gloonch/eventdrivenfarsi)
- انگلیسی: [Azure Architecture Styles](https://learn.microsoft.com/en-us/azure/architecture/guide/architecture-styles/)، [AWS Cloud Design Patterns](https://docs.aws.amazon.com/prescriptive-guidance/latest/cloud-design-patterns/introduction.html)، [Google SRE SLOs](https://sre.google/sre-book/service-level-objectives/)

</div>

