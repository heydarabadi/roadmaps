<div dir="rtl" align="right">

# LeSS و SAFe برای کار چندتیمی

LeSS و SAFe هر دو برای هماهنگی کار چابک در مقیاس بزرگ‌تر شناخته می‌شوند، اما شکل سازمان‌دهی، نقش‌ها و رویدادهایشان فرق دارد. LeSS می‌کوشد چند تیم را حول یک محصول و Product Backlog مشترک، با کمینه‌کردن ساختار افزوده هماهنگ کند. SAFe portfolio، program increment و لایه‌های هماهنگی بیشتری ارائه می‌دهد.

هر چارچوب هزینهٔ هماهنگی، تخصص تسهیل‌گری و خطر bureaucracy دارد. انتخاب باید از تعداد تیم‌ها، وابستگی، الزام برنامه‌ریزی/بودجه، استقلال محصول و میزان تغییر مورد انتظار بیاید. چارچوب مقیاس‌گذاری جای معماری ماژولار، API contract یا تیم‌های دارای مالکیت را نمی‌گیرد.

## از یک تیم به چند تیم: تشخیص مسئله

Scaling framework زمانی وارد بحث می‌شود که dependency، اولویت‌گذاری و یکپارچه‌سازی میان چند تیم سرعت ارزش را پایین آورده باشد. نخست جریان ارزش، تعداد handoff، صف تصمیم، ownership، release cadence و علت انتظار را اندازه بگیر. چارچوب تازه اگر handoff را بیشتر کند ولی dependency را کم نکند، مسئله را حل نکرده است.

## LeSS و SAFe: چطور مقایسه کنیم؟

LeSS چند تیم را حول محصول و backlog مشترک با ساختار افزودهٔ کم هماهنگ می‌کند؛ SAFe نقش‌ها و سطح‌های هماهنگی portfolio/program بیشتری دارد. در هر دو، outcome مشترک، تیم‌های cross-functional، مرز محصول و integration پیوسته مهم‌اند. انتخاب به استقلال تیم، مقررات، بودجه‌بندی، تعداد وابستگی و نیاز governance وابسته است؛ نام چارچوب کیفیت را تضمین نمی‌کند.

## معماری در سازمان چندتیمی

API owner، data ownership و compatibility را به تیم‌ها واگذار کن. guild یا architecture community می‌تواند استاندارد و تجربه را پخش کند؛ اگر همهٔ تصمیم‌ها نیاز به board مرکزی دارند، تیم‌ها صف می‌شوند. تصمیم سراسری را محدود به cross-cutting risk، platform و guardrail کن و exception path داشته باش.

## آزمایش کوچک و بازنگری

به‌جای rollout سراسری framework، در یک value stream چند هفته آزمایش کن: آیا زمان handoff کم شد؟ lead time و defect rate چه تغییری کرد؟ تیم‌ها اختیار روشن‌تری دارند؟ پس از تجربه، ceremony بی‌فایده را حذف و نتیجه را مستند کن.

## آزمون

۱. چرا Scrum یک تیم را به چند ده تیم scale نمی‌کند؟ **پاسخ:** dependency و تصمیم‌گیری بین تیم‌ها شکل تازه‌ای پیدا می‌کند.
۲. LeSS چه تأکیدی دارد؟ **پاسخ:** چندتیمی‌کردن Scrum حول یک محصول با ساختار افزودهٔ محدود.
۳. SAFe چه زمانی می‌تواند مفید باشد؟ **پاسخ:** نیاز به هماهنگی برنامه و portfolio رسمی در سازمان بزرگ.
۴. خطر چارچوب سنگین چیست؟ **پاسخ:** مراسم و گزارش‌دهی زیاد بدون کاهش dependency یا افزایش ارزش.

## تمرین

برای محصولی با شش تیم و دو release train فرضی، جریان value، backlog، dependency و تصمیم معماری را یک‌بار در LeSS و یک‌بار در SAFe تصور و trade-off را بنویس.

## پاسخ نمونهٔ تمرین

LeSS یک product backlog و integration cadence مشترک می‌خواهد؛ dependencyها در برنامه‌ریزی بین تیم‌ها آشکار می‌شود. SAFe می‌تواند برنامه/portfolio و release train هماهنگ را formal کند، اما ceremony/وابستگی مرکزی بیشتر. پیش از گزینش dependency graph، lead time، handoff و الزام بودجه را اندازه بگیر؛ pilot باید نشان دهد یکی از معیارها بهتر شده است.

## منابع

- فارسی: [مهندسی نرم‌افزار چابک](https://mehrdadghobadi.com/lessons/agile-software-engineering)، [کتابچهٔ فارسی Scrum و Kanban](https://res.infoq.com/news/2010/01/kanban-scrum-minibook/en/resources/KanbanAndScrum-Persian%202.pdf)
- انگلیسی: [LeSS Framework](https://less.works/less/framework)، [SAFe Framework](https://scaledagileframework.com/)، [Agile at Scale: LeSS](https://www.atlassian.com/agile/agile-at-scale/less)

</div>

