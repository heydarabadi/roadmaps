# فصل ۵ — بازخورد، شدت و اختلاف

**زبان:** فارسی · [English](../../../en/code-review/05-feedback/README.md)

**هدف:** کامنت دقیق و محترمانه بنویس، موارد blocker را از ترجیح جدا کن و اختلاف را به تصمیم تبدیل کن.

## درس پیونددهندهٔ فصل

کامنتی خوب است که نویسنده بداند چه رفتاری دیده شده، چه پیامدی دارد و چه پاسخی انتظار می‌رود. فرض را از واقعیت جدا کن؛ شدت را صریح بگو؛ style را به قواعد تیم بسپار. blocker، question، suggestion و nit اگر با قرارداد روشن شوند، احتمال سکوت و سوءبرداشت را کم می‌کنند.

اختلاف فنی با نام سمت شغلی حل نمی‌شود. نیازمندی، داده، آزمایش یا design record را معیار قرار بده. اگر هنوز consensus نیست، owner تصمیم را مشخص و trade-off را ثبت کن. reviewer نیز باید با شاهد تازه نظرش را اصلاح کند. هدف سلامت کد و یادگیری است، نه کمال بی‌پایان یا بیشترین تعداد comment.

**تمرین فصل:** پنج جملهٔ واقعی یا فرضی review را بدون اطلاعات شخصی بازنویسی کن: برای هرکدام behavior، impact، ask، severity و میزان قطعیت را جدا بنویس.

## تاپیک‌ها

- [کامنت مشخص و سازنده](01-constructive-comments/README.md)
- [اولویت، style و حل اختلاف](02-priority-conflict/README.md)

## مرور فصل

1. چه اجزایی یک comment را actionable می‌کنند؟
2. چگونه blocker را از suggestion یا nit جدا می‌کنی؟
3. هنگام اختلاف فنی چه شواهدی باید تصمیم را جلو ببرد؟

**پاسخ راهنما:** رفتار مشاهده‌شده، پیامد، درخواست یا سؤال روشن و شدت/قطعیت لازم است. اگر نقص می‌تواند correctness، امنیت، داده یا قابلیت انتشار را بشکند، blocker موجه است؛ بهبود اختیاری suggestion و ترجیح قالب‌بندی nit است. requirement، آزمایش، دادهٔ نماینده و design record را بررسی کن و در نبود توافق، owner و trade-off تصمیم را ثبت کن.

## منابع فصل

- [Google: Writing review comments](https://google.github.io/eng-practices/review/reviewer/comments.html)
- [Conventional Comments](https://conventionalcomments.org/)
- [What Makes a Code Review Useful to OpenDev Developers?](https://arxiv.org/abs/2302.11686)
- [بازبینی کد؛ راهنمای برنامه‌نویسان — امروزینو](https://emrozino.ir/article/code-review-beginners-guide)
- [بازبینی کد؛ چطور کد دیگران را بخوانیم — نت پارادیس](https://netparadis.com/code-review-practices-pull-request/?rm=pro-skills)
