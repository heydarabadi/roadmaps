# فصل ۲ — آماده‌سازی نویسنده

**زبان:** فارسی · [English](../../../en/code-review/02-author/README.md)

**هدف:** تغییر متمرکز، قابل‌فهم و قابل‌آزمون بساز و زمینهٔ لازم را برای reviewer فراهم کن.

## درس پیونددهندهٔ فصل

نویسنده مالک آماده‌سازی تغییر است: باید هدف واحد را مشخص کند، کد را با معماری و قواعد پروژه هماهنگ نگه دارد، تست و docs متأثر را آماده کند و ریسک را برای reviewer آشکار سازد. اندازه با خطوط تنها سنجیده نمی‌شود؛ PR باید یک مفهوم قابل‌فهم داشته باشد و به‌نحوی شکسته شود که هر مرحله امن و معنادار بماند.

بعد از پیاده‌سازی، diff نهایی را از اول بخوان. فایل تصادفی، log دیباگ، تغییر بدون تست، docs نادرست و config جاافتاده را پیدا کن. شرح باید بگوید چه تغییر کرد، چرا، چطور آزموده شد و چه چیزی هنوز نامطمئن است. صداقت دربارهٔ تست اجرا نشده نشانهٔ کیفیت است؛ ادعای سبز بدون شواهد اعتماد review را از بین می‌برد.

**تمرین فصل:** یک feature از مخزن خود انتخاب کن؛ آن را به PRهای متمرکز طراحی کن، قالب شرح را پر کن و برای هر مرحله test، risk، docs و rollback را بنویس.

## تاپیک‌ها

- [دامنه و اندازهٔ PR](01-pr-scope/README.md)
- [شرح PR، شواهد و خودبازبینی](02-pr-description/README.md)
- [تست، مستندات و ریسک‌های تغییر](03-tests-docs-risk/README.md)

## مرور فصل

1. چه چیزی یک PR را «کوچک و قابل فهم» می‌کند؟
2. شرح PR باید چه اطلاعاتی بدهد تا reviewer بتواند تصمیم بگیرد؟
3. self-review چه دسته از خطاهایی را معمولاً پیش از ارسال پیدا می‌کند؟

**پاسخ راهنما:** معیار اصلی، یکپارچگی مفهوم و امکان فهم جریان تغییر است؛ تعداد خط به‌تنهایی کافی نیست. شرح باید مسئله، دلیل، رفتار جدید، روش تست، ریسک، rollout و موارد انجام‌نشده را شفاف کند. self-review تغییر ناخواسته، تست جاافتاده، خطای نام‌گذاری یا مستندات/config ناسازگار را پیدا می‌کند؛ رفتار و شواهد را هم دوباره بررسی کن.

## منابع فصل

- [Google: Small CLs](https://google.github.io/eng-practices/review/developer/small-cls.html)
- [GitHub: Helping others review changes](https://docs.github.com/en/pull-requests/concepts/helping-others-review-your-changes)
- [Microsoft Engineering Playbook: Pull Requests](https://github.com/microsoft/code-with-engineering-playbook/blob/main/docs/code-reviews/pull-requests.md)
- [چک‌لیست رسمی Code Review در roadmap.sh](https://roadmap.sh/pdfs/best-practices/code-review.pdf)
- [بازبینی کد؛ چطور کد دیگران را بخوانیم — نت پارادیس](https://netparadis.com/code-review-practices-pull-request/?rm=pro-skills)
