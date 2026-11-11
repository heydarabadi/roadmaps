<div dir="rtl" align="right">

# Microsoft Dynamics

Microsoft Dynamics 365 مجموعه‌ای از برنامه‌های business شامل CRM و ERP است؛ مدل deployment و یکپارچه‌سازی آن به محصول و قابلیت مورد استفاده وابسته است. معماری راه‌حل باید system of record هر داده، identity، integration contract، boundary سفارشی‌سازی و مسیر ارتقا را روشن کند.

قابلیت آمادهٔ پلتفرم را با کدنویسی اختصاصی جایگزین نکن مگر نیاز، هزینه و محدودیت آن را ثبت کرده باشی. سفارشی‌سازی خارج از extension point می‌تواند upgrade را دشوار کند. برای ارتباط با سرویس‌های دیگر، API، event، connector یا integration platform را بر اساس latency، consistency و retry بسنج.

## درس گام‌به‌گام: مرز Dynamics و فروشگاه

فرض کن Dynamics مشتری و pipeline فروش را مالک است ولی فروشگاه منبع حقیقت سفارش‌های آنلاین است:

۱. هر object/field را به یک system of record نسبت بده؛ نام محصول به‌تنهایی مالکیت را مشخص نمی‌کند.
۲. با data dictionary، شناسهٔ مشترک، کیفیت و قواعد تطبیق customer را تعریف کن.
۳. برای تغییر customer، API sync وقتی پاسخ فوری لازم است؛ event وقتی مصرف‌کنندهٔ مستقل و تأخیر قابل‌قبول است؛ batch وقتی حجم زیاد و تازگی پایین‌تر پذیرفتنی است.
۴. قرارداد شامل auth، quota، paging، schema، idempotency، error mapping و retry باشد.
۵. برای conflict، source-of-truth هر فیلد و قواعد merge را بنویس؛ «آخرین timestamp برنده است» همیشه امن نیست.
۶. reconciliation دوره‌ای اختلاف و backlog را پیدا کند؛ خطای connector باید قابل‌پیگیری و replay محدود داشته باشد.

## سفارشی‌سازی و مسیر ارتقا

قابلیت استاندارد را نخست ارزیابی کن. customization ممکن است licensing، governance، sandbox، performance و upgrade را تحت تأثیر قرار دهد. Extension point پشتیبانی‌شده، solution package و محیط جدا از production به کاهش coupling کمک می‌کند. پیش از upgrade نسخه، API deprecated، integration و data model را inventory و در sandbox آزمون کن.

## امنیت و عملیات

App registration و identity integration کم‌دسترسی بساز؛ secret rotation و audit را در طرح بگنجان. connector را با timeout، rate limit و circuit behavior تنظیم کن؛ dead-letter و reconciliation مالک داشته باشند. دسترس‌پذیری Dynamics به tenant، region، configuration و سرویس مصرفی وابسته است؛ فرض availability یکسان نکن.

## آزمون

۱. چرا مالکیت داده باید مشخص شود؟ **پاسخ:** از چند منبع حقیقت و update متناقض جلوگیری می‌کند.
۲. سفارشی‌سازی عمیق چه هزینه‌ای دارد؟ **پاسخ:** upgrade، پشتیبانی و وابستگی به پیاده‌سازی داخلی.
۳. event integration چه زمانی مناسب است؟ **پاسخ:** مصرف‌کننده مستقل و تأخیر کوتاه اما غیرهم‌زمان قابل‌قبول باشد.
۴. قبل از انتخاب connector چه می‌سنجی؟ **پاسخ:** قرارداد، هویت، volume، failure، محدودیت provider و عملیات.

## تمرین

جریان customer و order را میان Dynamics و فروشگاه رسم کن و system of record، sync direction، retry و reconciliation را تعیین کن.

## پاسخ نمونهٔ تمرین

Dynamics می‌تواند customer/profile و فروش سازمانی را مالک شود؛ فروشگاه order و fulfillment را. Field mapping و ID مشترک تعیین می‌شود. تغییر customer از event/API بر اساس نیاز تازگی می‌رود؛ consumer idempotent و cursor/replay دارد؛ conflict با مالک هر field حل می‌شود. reconciliation روزانه اختلاف را ثبت و صف خطا owner دارد.

## منابع

- فارسی: [مبانی معماری نرم‌افزار](https://www.alirostami.com/software-architecture/)، [معماری سازمانی فارسی](https://codingcogs.org/road-maps/software-architecture)
- انگلیسی: [Dynamics 365 documentation](https://learn.microsoft.com/en-us/dynamics365/)، [Power Platform Well-Architected](https://learn.microsoft.com/en-us/power-platform/well-architected/)

</div>

