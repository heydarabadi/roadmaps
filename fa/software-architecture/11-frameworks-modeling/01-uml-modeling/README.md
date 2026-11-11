<div dir="rtl" align="right">

# UML و مدل‌سازی معماری

UML زبان مدل‌سازی استاندارد OMG برای نمایش ساختار و رفتار است؛ ابزار فکر و ارتباط است و جای کد قابل‌اجرا را نمی‌گیرد. در معماری، component diagram، deployment diagram، sequence diagram، state machine و use-case view پرسش‌های متفاوتی پاسخ می‌دهند. از نموداری استفاده کن که تصمیم یا تعامل را واضح کند.

C4 به‌جای نشانه‌گذاری رسمی UML، سطح‌های context، container، component و code را پیشنهاد می‌دهد تا مخاطب را از کل سامانه به جزئیات ببرد. این دو رقیب کامل نیستند: C4 نمای ساختار را روشن می‌کند؛ sequence یا state diagram می‌تواند رفتار موردنیاز را نشان دهد.

## مثال

برای فرآیند پرداخت، C4 container سرویس‌ها و provider را نشان می‌دهد؛ sequence diagram ترتیب authorize، callback، commit و timeout را توضیح می‌دهد؛ deployment view محل اجرا و شبکه را مشخص می‌کند. سه نمودار کوچک معمولاً از یک نمودار عظیم مفیدترند.

## انتخاب نمودار از پرسش شروع می‌شود

- «سامانه و همسایه‌هایش چیستند؟» C4 context یا UML use-case.
- «کدام برنامه‌ها و ذخیره‌سازها deploy می‌شوند؟» C4 container و deployment diagram.
- «ترتیب پیام checkout چگونه است؟» sequence diagram.
- «سفارش چه وضعیت‌هایی دارد و چه انتقالی مجاز است؟» state machine.
- «کدام جزء به کدام interface وابسته است؟» component diagram.

برای هر نمودار بالای صفحه یک جملهٔ هدف و مخاطب بنویس. boundary، مالک، protocol و مسیرهای شکست را با notation ساده و legend مشخص نشان بده. نام کلی مانند «backend» اطلاعات کمی دارد؛ نام مسئولیت و داده را بنویس.

## از مدل به تصمیم معماری

نمودار پرداخت را این‌طور بساز: ابتدا actor مشتری و order service؛ سپس payment provider؛ بعد پیام authorize، پاسخ pending و callback؛ timeout و تکرار callback را اضافه کن؛ در پایان state سفارش و مسئولیت هر عملیات را نشان بده. این sequence diagram پرسش‌های طراحی را آشکار می‌کند: callback معتبر است؟ duplicate چگونه مهار می‌شود؟ reconciliation کجاست؟ نمودار قرار نیست همهٔ خط‌های کد را نمایش دهد.

## نگهداری مدل

نمودار منقضی می‌تواند بدتر از نداشتن نمودار باشد. در کنار source یا repository نگه‌دار، owner تعیین کن و در تغییر مهم update را در review بررسی کن. diagram-as-code و link به ADR بازتولیدپذیری را کمک می‌کند؛ اما خودکار بودن تولید به معنای درست بودن معنا نیست.

## آزمون

۱. UML چه چیزی نیست؟ **پاسخ:** زبان برنامه‌نویسی یا تضمین خودکار سازگاری مدل و کد نیست.
۲. برای نشان‌دادن ترتیب پیام‌ها چه نموداری مناسب است؟ **پاسخ:** sequence diagram.
۳. چرا C4 و UML را می‌توان ترکیب کرد؟ **پاسخ:** برای سطوح ساختار و جزئیات رفتاری پرسش‌های مکمل دارند.
۴. چه زمانی نمودار را حذف می‌کنی؟ **پاسخ:** اگر هیچ تصمیم/مخاطبی را روشن نکند یا نگهداری‌اش از ارزشش بیشتر شود.

## تمرین

برای سامانهٔ رزرو یک context diagram، sequence لغو رزرو و deployment view انتخاب کن؛ هر نمودار را با یک جملهٔ هدف برچسب بزن.

## پاسخ نمونهٔ تمرین

Context diagram مشتری، سیستم رزرو و تقویم بیرونی را نشان می‌دهد؛ sequence لغو رزرو درخواست، بررسی policy، commit، refund و notification را با timeout/خطا رسم می‌کند؛ deployment view مرز اینترنت، app runtime، DB و provider را نشان می‌دهد. هر نمودار عنوان مخاطب و یک پرسش دارد و شامل تمام جزئیات کد نیست.

## منابع

- فارسی: [جزوهٔ فارسی مهندسی نرم‌افزار و UML](https://files.rahatbiamooz.ir/downloads/files/daneshgah/jozve/jozvekardani/mabaninarmafzar.pdf)، [راهنمای C4 فارسی](https://www.cybermedian.com/fa/the-c4-model-a-comprehensive-guide-to-visualizing-software-architecture/)
- انگلیسی: [OMG UML specification](https://www.omg.org/spec/UML/)، [C4 Model diagrams](https://c4model.com/diagrams)

</div>

