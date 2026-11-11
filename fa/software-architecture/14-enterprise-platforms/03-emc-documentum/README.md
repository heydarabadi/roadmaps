<div dir="rtl" align="right">

# EMC Documentum و مدیریت محتوا

Documentum (امروزه در سبد OpenText) سامانهٔ مدیریت محتوای سازمانی است. چنین ECMهایی فقط file store نیستند: metadata، taxonomy، version، retention، permission، workflow، search و audit را مدیریت می‌کنند. انتخاب معماری باید طبقه‌بندی و lifecycle سند را با مقررات و فرایند کسب‌وکار هماهنگ کند.

فایل‌های بزرگ را ممکن است در object store نگه داشت و metadata را در repository؛ mapping، version و link پایدار باید روشن باشد. migration سند باید hash/تعداد/metadata را reconcile کند، permissionها را حفظ و retention/legal hold را رعایت کند. export یا replica بدون metadata ممکن است سند را از نظر حقوقی بی‌معنا کند.

## درس گام‌به‌گام: lifecycle سند

سند قرارداد را از ورود تا حذف دنبال کن:

۱. هنگام ingest، نوع محتوا، صاحب، tenant و metadata اجباری را اعتبارسنجی کن.
۲. taxonomy و شناسهٔ پایدار بده؛ content hash و حجم/فرمت را برای تشخیص خرابی ثبت کن.
۳. نسخه‌ها را immutable یا با history روشن نگه دار؛ metadata قابل‌تغییر با محتوا و نسخه‌ها هماهنگ باشد.
۴. permission، classification و legal hold را در هر API و workflow اعمال کن.
۵. search index را projection مشتق‌شده بدان؛ حذف یا تغییر permission باید index را هم به‌روز کند.
۶. retention و حذف را با audit، نسخه‌های backup و hold قانونی هماهنگ کن.

## معماری مخزن و فایل

Repository metadata، version و policy را نگه می‌دارد؛ object store ممکن است محتوای حجیم را جدا ذخیره کند. link سند باید پایدار و authorization-aware باشد، نه path فیزیکی. cache/download URL، مدت اعتبار و امکان لغو دسترسی را طراحی کن. backup باید metadata و blob را با consistency لازم بازیابی کند؛ بازیابی یک بدون دیگری orphan می‌سازد.

## مهاجرت در مقیاس بالا

۱. inventory تعداد، حجم، mime، metadata، ACL و legal hold را استخراج کن.
۲. mapping taxonomy و principalها را با نمونه و گزارش exception تأیید کن.
۳. batch قابل‌تکرار انتقال بده؛ checkpoint و retry با idempotency داشته باش.
۴. پس از انتقال hash، count، metadata و ACL را تطبیق بده.
۵. cutover را مرحله‌ای کن، write freeze یا dual-path policy را روشن کن و rollback بسنج.

## آزمون

۱. ECM چه چیزی فراتر از file storage دارد؟ **پاسخ:** metadata، version، policy، workflow، search و audit.
۲. چرا hash در migration مفید است؟ **پاسخ:** تمامیت محتوای منتقل‌شده را قابل‌مقایسه می‌کند.
۳. retention policy چه چیزی را تعیین می‌کند؟ **پاسخ:** زمان نگهداری و حذف مجاز/الزامی محتوا.
۴. چرا permission باید با محتوا مهاجرت کند؟ **پاسخ:** حذف کنترل دسترسی می‌تواند دادهٔ محرمانه را افشا کند.

## تمرین

مهاجرت ده میلیون سند را طراحی کن: inventory، انتقال batch، retry، hash، permission، legal hold و cutover را تعیین کن.

## پاسخ نمونهٔ تمرین

ابتدا inventory metadata/ACL/legal hold؛ batch قابل‌تکرار با checkpoint و hash انتقال می‌دهد؛ failureها به retry محدود و quarantine؛ مقصد count/hash/metadata/permission را reconcile می‌کند. cutover pilot و read-only window یا dual-write کنترل‌شده دارد. legal hold حذف را ممنوع می‌کند. retention و backup/restore با metadata/blob با هم آزمون می‌شوند.

## منابع

- فارسی: [مبانی معماری فارسی](https://www.alirostami.com/software-architecture/)، [سرفصل مدیریت داده](https://roadmap.sh/pdfs/roadmaps/software-architect.pdf)
- انگلیسی: [OpenText Content Management](https://www.opentext.com/products/content-management)، [OpenText documentation](https://www.opentext.com/support/documentation)

</div>

