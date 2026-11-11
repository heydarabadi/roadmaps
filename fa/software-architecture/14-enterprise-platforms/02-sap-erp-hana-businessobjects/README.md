<div dir="rtl" align="right">

# SAP ERP، HANA و BusinessObjects

SAP ERP فرایندهای یکپارچهٔ مالی، خرید، فروش و زنجیرهٔ تأمین را مدل می‌کند. HANA پلتفرم داده و پایگاه درون‌حافظه‌ای SAP است؛ BusinessObjects ابزار گزارش و BI در سبد SAP بوده است. ترکیب دقیق محصول، نسخه، deployment و licensing در هر سازمان فرق می‌کند و باید از inventory واقعی محیط استخراج شود.

معمار به جای شناخت نام محصول، باید business process، data object، extension point، interface، master data، authorization و replication را بداند. اتصال مستقیم و شکننده به schema داخلی می‌تواند upgrade را مختل کند؛ API یا integration interface پشتیبانی‌شده را ترجیح بده. برای گزارش، workload تحلیلی را از تراکنش ERP جدا و freshness و lineage را تعریف کن.

## درس گام‌به‌گام: فاکتور SAP تا گزارش BI

۱. **فرایند و سند:** مشخص کن فاکتور کدام مرحلهٔ کسب‌وکار و کدام سند رسمی است.
۲. **منبع حقیقت:** SAP ممکن است مالک posting مالی باشد؛ storefront سفارش اولیه را مالک باشد. مقدارها را برای هر entity مشخص کن.
۳. **integration:** API/event برای latency پایین‌تر یا batch/file برای حجم و قرارداد موجود را با semantics واقعی محصول بسنج.
۴. **مدل BI:** report metric، grain، currency، fiscal calendar و reversal/refund را تعریف کن.
۵. **reconciliation:** count و total مبلغ را بین source و target تطبیق بده؛ gap را قابل‌مشاهده کن.
۶. **دسترسی:** role و field-level permission، export، audit و retention را پوشش بده.

## مرز customization و migration

پیش از تغییر، نسخه و deployment واقعی، extensionهای موجود، business process، interface، volume و custom code را inventory کن. اتصال مستقیم به schema داخلی می‌تواند release ارتقا را بشکند؛ interface پشتیبانی‌شده و data replication رسمی را بررسی کن. مهاجرت شامل mapping، پاک‌سازی، reconcile، cutover، coexistence و rollback است؛ ابزار extract به‌تنهایی معادل مهاجرت کامل نیست.

## workload تحلیلی در برابر تراکنشی

HANA و ابزار SAP می‌توانند نقش‌های متنوع داشته باشند؛ دربارهٔ نام محصول فرض نکن. query تحلیلی سنگین ممکن است latency تراکنشی را بالا ببرد؛ replication یا warehouse جدا را با freshness، lineage، هزینه و governance مقایسه کن.

## آزمون

۱. چرا direct database integration پرریسک است؟ **پاسخ:** به schema داخلی وابسته می‌شود و upgrade/transaction را شکننده می‌کند.
۲. system of record چیست؟ **پاسخ:** منبع authoritative داده و مرجع تغییر معتبر.
۳. BI report چه نیاز معماری دارد؟ **پاسخ:** تعریف metric، lineage، کنترل دسترسی و تازگی داده.
۴. چه چیزی را پیش از برآورد migration باید پیدا کرد؟ **پاسخ:** نسخه، customization، interface، data volume و dependency واقعی.

## تمرین

سناریوی «ثبت فاکتور در SAP، گزارش فروش در BI» را با source data، integration mode، reconciliation، access control و recovery plan توضیح بده.

## پاسخ نمونهٔ تمرین

SAP مالک invoice posting و BI مصرف‌کنندهٔ دادهٔ تحلیلی است. انتقال از interface رسمی API/event/batch بر اساس latency/volume انجام می‌شود؛ metric با currency, fiscal period و reversal تعریف دارد. reconciliation row count و sum مبلغ را می‌سنجد؛ access مطابق role و audit است. recovery شامل replay از watermark، restore source و نشان‌دادن freshness dashboard است.

## منابع

- فارسی: [مقالهٔ معماری نرم‌افزار فارسی](https://www.alirostami.com/software-architecture/)، [مبانی داده و انبار داده](https://codingcogs.org/road-maps/software-architecture)
- انگلیسی: [SAP Help Portal](https://help.sap.com/)، [SAP Architecture Center](https://architecture.learning.sap.com/)

</div>

