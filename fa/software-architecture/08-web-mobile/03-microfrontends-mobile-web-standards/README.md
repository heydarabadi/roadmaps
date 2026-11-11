<div dir="rtl" align="right">

# Microfrontend، موبایل و استانداردهای وب

Microfrontend رابط کاربری را بر اساس قابلیت یا مالکیت تیمی به بخش‌های قابل‌استقرار/توسعهٔ مستقل تقسیم می‌کند. این کار هماهنگی تیم‌های متعدد را کم می‌کند، اما حجم bundle، consistency طراحی، routing، احراز هویت مشترک، telemetry و compatibility را پیچیده می‌سازد. تیم کوچک اغلب با component boundary در یک برنامهٔ واحد بهتر پیش می‌رود.

در موبایل، شبکهٔ ناپایدار، مصرف باتری، offline، push، ذخیرهٔ محلی، حفاظت credential و چرخهٔ انتشار فروشگاه اهمیت دارند. API باید نسخه‌های قدیمی app را تحمل کند و طرح migration آن با انتشار کندتر mobile سازگار باشد. W3C و WHATWG استانداردهای پلتفرم وب و مرورگر را تعریف می‌کنند؛ پیروی از استانداردها interoperability و دسترس‌پذیری را تقویت می‌کند.

## آیا Microfrontend ارزش هزینه را دارد؟

آن را زمانی بررسی کن که چند تیم واقعاً مرز محصولی و cadence مستقل دارند و یک shell مشترک را می‌توان اداره کرد. اگر فقط قصد داری frontend را «مدرن» کنی، هزینهٔ قرارداد runtime، bundleهای تکراری، styling، routing، observability و debugging توجیهی ندارد.

پیش از انتخاب این موارد را بنویس: مالک route، نسخهٔ قرارداد shared component، سیاست design system، روش deploy و rollback، احراز هویت مشترک، انتقال telemetry و راه fallback هنگام شکست remote module. استقلال deploy اگر با release هماهنگ همهٔ تیم‌ها همراه باشد بیشتر اسمی است.

## موبایل: آفلاین و API سازگار

شبکه ممکن است قطع یا کند شود. operation قابل‌صف‌شدن را محلی نگه دار، به هر command شناسهٔ تکرار بده، conflict sync را حل و دادهٔ cacheشده را با زمان آخرین به‌روزرسانی نشان بده. دسترسی محلی به دادهٔ حساس، storage امن سیستم‌عامل و logout/revoke را در نظر بگیر. push notification تضمین تحویل یا حقیقت دامنه نیست.

کاربر ممکن است نسخهٔ قدیمی را مدت‌ها اجرا کند؛ API را additive تغییر بده، rollout و minimum supported version را تعریف کن و deprecation را با دادهٔ مصرف پشتیبانی کن. store release فوری و همگانی نیست.

## استانداردهای وب و دسترس‌پذیری

HTML معنایی، فرم native، keyboard navigation و ARIA درست رفتار را میان browser و assistive technology قابل‌پیش‌بینی می‌کند. تا جای ممکن native element را به component سفارشی ترجیح بده. W3C و WHATWG مرجع استانداردهای وب‌اند؛ پشتیبانی واقعی browser و نیازهای مخاطب را هم اندازه بگیر.

## تمرین تصمیم

برای سامانه‌ای با سه تیم frontend، ابتدا برنامهٔ واحد با component boundary را در برابر microfrontend مقایسه کن. هزینهٔ integration، UX، performance، deploy و incident را محاسبه کن؛ فقط تعداد تیم ملاک نیست.

## آزمون

۱. چه زمانی microfrontend توجیه دارد؟ **پاسخ:** چند تیم مستقل و مرز محصولی واقعی، همراه با توان ادارهٔ قرارداد و تجربهٔ یکپارچه.
۲. چرا mobile API versioning مهم است؟ **پاسخ:** کاربر ممکن است نسخهٔ قدیمی را هفته‌ها یا ماه‌ها اجرا کند.
۳. استاندارد W3C/WHATWG چه سودی دارد؟ **پاسخ:** رفتار وب را میان مرورگرها و ابزارها قابل‌تعامل‌تر می‌کند.
۴. microfrontend چه مشکلی را خودکار حل نمی‌کند؟ **پاسخ:** مالکیت مبهم دامنه، یکپارچگی UX یا هزینهٔ عملیات را.

## تمرین

یک پنل متشکل از تیم پرداخت و تیم catalog را به‌صورت SPA مشترک و microfrontend مقایسه کن. deploy استقلال و پیامدهای UX و performance را ثبت کن.

## پاسخ نمونهٔ تمرین

با سه تیم ابتدا component boundary و ownership در SPA واحد را بسنج؛ یکپارچگی design, routing, auth و deploy ساده‌تر است. Microfrontend فقط اگر release cadence مستقل و مرز محصول واقعی زمان تحویل را بهتر می‌کند. هزینهٔ runtime/version contract، bundle تکراری، failure remote module، UX و incident را اندازه بگیر. توافق deploy مشترک نشان می‌دهد استقلال واقعی هنوز شکل نگرفته.

## منابع

- فارسی: [نقشهٔ معماری نرم‌افزار](https://codingcogs.org/road-maps/software-architecture)، [مبانی معماری فارسی](https://www.alirostami.com/software-architecture/)
- انگلیسی: [W3C Standards](https://www.w3.org/standards/)، [WHATWG](https://whatwg.org/)، [Micro Frontends](https://micro-frontends.org/)

</div>
