<div dir="rtl" align="right">

# Git و GitHub

Git تاریخچهٔ تغییر را به‌صورت توزیع‌شده نگه می‌دارد؛ branch، commit، merge، tag و revert ابزارهای مدیریت تکامل‌اند. GitHub میزبانی مخزن و فرایند همکاری مانند pull request، issue و workflow را فراهم می‌کند. مخزن می‌تواند کد، ADR، schema، نمودار و IaC را کنار هم نگه دارد.

Commit باید کوچک، قابل‌بازبینی و دارای دلیل روشن باشد. pull request محل بازبینی رفتار، امنیت و سازگاری قرارداد است؛ approval تعداد بالا جای مالکیت مشخص را نمی‌گیرد. Branch protection، secret scanning و CI کمک می‌کنند، اما دسترسی least privilege و branch policy باید متناسب سازمان باشد.

## مسیر تغییر از branch تا release

۱. branch کوتاه‌عمر بساز و تغییر محدود انجام بده.
۲. commit معنایی و کوچک ثبت کن؛ commitهای merge شده باید قابل‌ردیابی باشند.
۳. pull request هدف، approach، risk و روش آزمون را توضیح دهد و issue/ADR را پیوند بزند.
۴. CI build، static check، test و dependency/security policy را اجرا کند.
۵. reviewer قرارداد، migration، امنیت، observability، rollback و اثر بر مصرف‌کننده را بررسی کند.
۶. merge با branch protection انجام و artifact نسخه‌دار منتشر شود؛ tag و release note قابلیت پیدا کردن نسخه را می‌دهند.

## merge، rebase و rollback

Merge شاخه‌ها را با commit ادغام ثبت می‌کند؛ rebase commitها را روی پایهٔ تازه بازنویسی می‌کند. history مشترک را بی‌هماهنگی rewrite نکن. Revert یک commit تازه برای خنثی‌کردن تغییر می‌سازد و برای branch مشترک معمولاً امن‌تر از reset است. rollback نسخهٔ برنامه بدون سازگاری schema ممکن نیست؛ API و DB را با هم در طرح انتشار ببین.

## حفاظت مخزن

دسترسی least privilege، MFA، branch protection، signed commit/artifact در صورت نیاز، secret scanning و review ownership را فعال کن. Secretی که push شده باید revoke شود؛ حذف فایل از commit بعدی افشا را پاک نمی‌کند. Workflow CI هم code execution دارد و tokenهایش باید محدود باشند.

## مستندات کنار کد

ADR و diagram version-controlled باشند؛ schema API، migration و IaC با همان PR دیده شوند. README باید راه build، run، dependency و owner را مشخص کند. مستند stale را بازبینی یا حذف کن.

## آزمون

۱. Git و GitHub چه تفاوتی دارند؟ **پاسخ:** Git سیستم کنترل نسخه است؛ GitHub پلتفرم همکاری و میزبانی.
۲. ADR را کجا نگه می‌داری؟ **پاسخ:** غالباً مخزن نزدیک کد تا تغییر و تصمیم با هم دیده شوند.
۳. چرا commitهای کوچک سود دارند؟ **پاسخ:** review، bisect و rollback را ساده می‌کنند.
۴. merge conflict را چگونه کم می‌کنی؟ **پاسخ:** integration زودهنگام، branch عمر کوتاه و مرزهای ownership روشن.

## تمرین

یک PR فرضی برای افزودن فیلد وضعیت سفارش بساز؛ migration، API contract، ADR و تست سازگاری را در review checklist بگنجان.

## پاسخ نمونهٔ تمرین

Checklist PR: API contract فیلد جدید additive؟ DB migration expand/backfill/contract؟ consumer قدیمی سازگار؟ ADR دلیل و trade-off دارد؟ permission و PII کنترل شده؟ test/monitor/rollback هست؟ review مالک API و DB؟ secret در diff نیست؟ release note/deprecation policy درج شده است.

## منابع

- فارسی: [Git و همکاری در کدینگ‌کاگز](https://codingcogs.org/road-maps/software-architecture)، [مبانی معماری فارسی](https://www.alirostami.com/software-architecture/)
- انگلیسی: [Pro Git Book](https://git-scm.com/book/en/v2)، [GitHub Docs](https://docs.github.com/)

</div>

