<div dir="rtl" align="right">

# Agile، Scrum، Kanban و XP

Agile بر تحویل تدریجی، همکاری و یادگیری از تغییر تأکید دارد. Scrum چارچوب تیمی برای کار دوره‌ای و بازبینی هدف است؛ Kanban جریان کار، محدودیت WIP و بهبود cycle time را برجسته می‌کند؛ XP مجموعه‌ای از practices مهندسی مانند pair programming، refactoring، TDD و integration پیوسته دارد. این‌ها یکسان یا صرفاً جلسه‌های تقویمی نیستند.

معماری در Agile کنار گذاشته نمی‌شود؛ تصمیم‌های پرریسک باید زود با آزمایش بررسی شوند و طراحی با یادگیری رشد کند. «just enough architecture» یعنی تأخیر در تصمیم برگشت‌پذیر، نه بی‌توجهی به امنیت، داده یا migration پرهزینه. Technical debt باید با هزینه و اولویت محصول دیده شود.

## برنامه‌ریزی Agile به‌صورت حلقهٔ یادگیری

۱. هدف محصول یا outcome را تعریف کن؛ feature صرف به‌تنهایی ارزش نیست.
۲. backlog را به slice کوچک و قابل‌تحویل بشکن.
۳. ریسک فنی/امنیتی را در refinement زود شناسایی کن و برای ناشناختهٔ پرهزینه spike محدود بساز.
۴. در iteration یا جریان پیوسته کار را تحویل بده.
۵. feedback کاربر و metric را ببین، فرض را اصلاح و اولویت را تغییر بده.
۶. کیفیت و بدهی فنی را در برنامهٔ واقعی نگه دار؛ کار نادیده‌گرفته‌شده بعداً هزینهٔ عملیاتی می‌شود.

## Scrum، Kanban و XP در عمل

Scrum برای تیم با هدف iteration و بازبینی منظم چارچوب می‌دهد؛ sprint وعدهٔ تحویل دقیق هر قلم نیست و change policy باید روشن باشد. Kanban کارهای شروع‌شده را با محدودیت WIP کم و flow را با lead/cycle time بهبود می‌دهد. XP مهندسی را با TDD، pair/mob programming، refactoring و continuous integration تقویت می‌کند. تیم می‌تواند practices را با نیازش ترکیب کند بدون ادعای پیروی کامل از چارچوب.

## معماری و تصمیم‌های برگشت‌ناپذیر

تصمیم برگشت‌پذیر را می‌توان پس از feedback به تعویق انداخت؛ انتخاب database که مهاجرت دادهٔ آن پرهزینه است، قرارداد عمومی، کلید رمزنگاری، مدل tenancy و نیاز قانونی زودتر بررسی می‌شوند. برای ریسک بالا prototype یا آزمایش بار و failure بساز. ADR مختصر فرض، گزینه‌ها، پیامدها و trigger بازبینی را ثبت می‌کند.

## بدهی فنی را قابل‌بحث کن

به‌جای «کد کثیف است» اثر را بنویس: چه کندی تیم یا ریسک رخداد می‌سازد، هزینهٔ نگهداری چیست، چه نشانه‌ای اولویت را بالا می‌برد و کمترین اصلاح مفید کدام است. هیچ تیمی همهٔ بدهی را صفر نمی‌کند؛ باید هزینه و ریسک آن آگاهانه بماند.

## آزمون

۱. Scrum و Kanban چه تفاوت کلی دارند؟ **پاسخ:** Scrum iteration و نقش/رویداد مشخص دارد؛ Kanban جریان و محدودیت کار در جریان را مدیریت می‌کند.
۲. XP چه چیزی را برجسته می‌کند؟ **پاسخ:** تمرین‌های مهندسی برای feedback سریع و کیفیت طراحی.
۳. Agile به معنی نداشتن مستندات است؟ **پاسخ:** خیر؛ مستندِ مفید و به‌روز لازم است.
۴. چه تصمیمی را زودتر می‌گیری؟ **پاسخ:** تصمیم پرریسک، برگشت‌ناپذیر یا دارای dependency بیرونی.

## تمرین

برای افزودن درگاه پرداخت، کار را به sliceهای قابل‌تحویل تقسیم و یک technical spike برای ریسک callback تعریف کن.

## پاسخ نمونهٔ تمرین

Sliceها: قرارداد و sandbox provider؛ create payment برای happy path؛ callback امن و idempotent؛ status نامشخص و reconciliation؛ refund؛ rollout با metric. Spike محدود پرسش «callback ممکن است تکرار/نامرتب برسد و چگونه verify شود؟» را در محیط sandbox بررسی می‌کند و با نتیجه، not-to-exceed time و تصمیم ADR پایان می‌یابد.

## منابع

- فارسی: [مهندسی نرم‌افزار چابک](https://mehrdadghobadi.com/lessons/agile-software-engineering)، [کتابچهٔ فارسی Kanban و Scrum](https://res.infoq.com/news/2010/01/kanban-scrum-minibook/en/resources/KanbanAndScrum-Persian%202.pdf)
- انگلیسی: [Scrum Guide](https://scrumguides.org/)، [Kanban Guide](https://kanbanguides.org/)، [Extreme Programming](http://www.extremeprogramming.org/)

</div>

