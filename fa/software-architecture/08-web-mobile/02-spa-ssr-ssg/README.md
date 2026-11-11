<div dir="rtl" align="right">

# SPA، SSR و SSG

این اصطلاح‌ها زمان و محل تولید HTML را توصیف می‌کنند. در SPA اغلب مرورگر پس از دریافت JavaScript صفحه را می‌سازد؛ در SSR سرور برای درخواست HTML تولید می‌کند؛ در SSG صفحه در زمان build ساخته و به‌صورت فایل استاتیک منتشر می‌شود. محصول می‌تواند راهبرد ترکیبی برای مسیرهای مختلف داشته باشد.

SPA برای UI تعاملی پس از بارگذاری مناسب است، اما JavaScript و hydration می‌توانند زمان نمایش را عقب بیندازند. SSR محتوای اولیه را زودتر می‌رساند ولی هزینهٔ سرور، caching و خطر ناسازگاری کد server/browser دارد. SSG برای محتوای کم‌تغییر ساده و سریع است؛ دادهٔ شخصی یا لحظه‌ای را به‌تنهایی حل نمی‌کند.

## انتخاب

| مسیر | گزینهٔ محتمل | ملاحظه |
| --- | --- | --- |
| صفحهٔ محصول عمومی | SSR یا SSG | freshness، SEO و cache |
| پنل کاربری | SPA یا rendering ترکیبی | احراز هویت و زمان شروع |
| مستندات | SSG | build و انتشار محتوا |

## انتخاب rendering به تفکیک مسیر

| مسیر | گزینهٔ آغازین | پرسش تعیین‌کننده |
| --- | --- | --- |
| صفحهٔ marketing کم‌تغییر | SSG | داده با build تازه می‌شود یا باید on-demand باشد؟ |
| جزئیات کالای عمومی | SSR یا SSG با revalidation | تازگی موجودی، SEO و cache چه می‌خواهد؟ |
| سبد و پنل مشتری | client rendering یا ترکیبی | چه داده‌ای شخصی است و چطور cache می‌شود؟ |
| ابزار داخلی | SPA اغلب کافی | آیا کاربران واقعاً به نمایش اولیهٔ عمومی نیاز دارند؟ |

گزینه‌ها را می‌توان ترکیب کرد. تصمیم را بر اساس معیار تجربه مثل LCP، TTFB، حجم JavaScript، هزینهٔ server و تازگی داده ارزیابی کن.

## جریان درخواست SSR

مرورگر URL می‌خواهد؛ سرور route را پیدا می‌کند، دادهٔ لازم را با هویت و مجوز مناسب می‌خواند، HTML می‌سازد و پاسخ می‌دهد. مراقب باش دادهٔ شخصی در HTML یا cache مشترک نماند. سپس browser JavaScript را بارگذاری و HTML را hydrate می‌کند. محتوایی که در server و client متفاوت render شود hydration mismatch می‌سازد؛ ساعت، locale، random value و دسترسی browser-only از علت‌های رایج‌اند.

## cache و freshness

صفحهٔ استاتیک می‌تواند بسیار سریع باشد، ولی زمان revalidation و invalidation باید روشن باشد. cache کردن response شخصی بر اساس URL تنها ممکن است دادهٔ کاربر دیگر را افشا کند؛ کلید cache باید هویت/سیاست درست را منعکس کند یا پاسخ private باشد. ISR و revalidation نیز تضمین freshness لحظه‌ای نیستند.

## SEO، دسترس‌پذیری و امنیت

SSR/SSG می‌تواند محتوای HTML اولیه بدهد، اما crawler، metadata، canonical URL و structured data را مستقل بررسی کن. صفحهٔ قابل‌استفاده بدون JavaScript کجا لازم است؟ آیا navigation و form با keyboard کار می‌کند؟ هیچ rendering mode به‌خودی‌خود authorization یا حفاظت XSS را حل نمی‌کند.

## آزمون

۱. SSG چه زمانی مناسب است؟ **پاسخ:** داده هنگام build شناخته‌شده و به‌روزرسانی کم‌تکرار باشد.
۲. SSR چه هزینه‌ای می‌آورد؟ **پاسخ:** runtime سرور، CPU، caching و کد سازگار با محیط server.
۳. hydration چیست؟ **پاسخ:** وصل‌کردن رفتار JavaScript به HTML اولیهٔ تولیدشده.
۴. آیا SSR امنیت را تضمین می‌کند؟ **پاسخ:** خیر؛ authorization و حفاظت داده جداگانه لازم‌اند.

## تمرین

برای صفحهٔ فهرست کالا، جزئیات محصول، سبد و پنل کاربر، rendering و سیاست cache را جدا تعیین کن.

## پاسخ نمونهٔ تمرین

فهرست کالا SSG با revalidation یا SSR بسته به freshness/SEO؛ جزئیات محصول SSR یا SSG برای محتوای ثابت و cache عمومی با invalidation؛ سبد و پنل client-rendered با private cache و هویت کاربر. هیچ response شخصی در shared cache بدون partition امن ذخیره نمی‌شود. معیار تصمیم: تازگی، LCP، TTFB، هزینه و دادهٔ خصوصی.

## منابع

- فارسی: [نقشهٔ Web و معماری](https://roadmap.sh/software-architect)، [مبانی معماری فارسی](https://www.alirostami.com/software-architecture/)
- انگلیسی: [Vue SSR guide](https://vuejs.org/guide/scaling-up/ssr)، [Angular rendering strategies](https://angular.dev/guide/routing/rendering-strategies)، [React server APIs](https://react.dev/reference/react-dom/server)

</div>

