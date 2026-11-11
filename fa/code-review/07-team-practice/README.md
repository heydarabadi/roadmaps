# فصل ۷ — تیم، تجربه و تمرین

**زبان:** فارسی · [English](../../../en/code-review/07-team-practice/README.md)

**هدف:** فرایند پایدار بساز، از تجربهٔ مستند بیاموز و آموخته‌ها را در تمرین به کار ببر.

## درس پیونددهندهٔ فصل

کیفیت review فقط مهارت reviewer نیست؛ طراحی فرایند تیم هم تعیین‌کننده است. Definition of Done، style guide، زمان پاسخ، مالکیت فایل، CI قابل‌اعتماد و مسیر حل اختلاف باید روشن باشند. قواعد مکانیکی را خودکار کن و کنترل‌ها را نگه‌داری کن؛ دروازهٔ flaky یا هشدار بی‌صاحب تیم را به دورزدن عادت می‌دهد.

شاخص‌ها را برای تشخیص bottleneck بخوان، نه برای پاداش‌دادن به تعداد comment یا سرعت approve. بازنگری منظم باید روندهای تکراری را به تست، آموزش، ابزار یا policy تبدیل کند. گزارش صنعتی نیز باید جدا کند منبع چه واقعیتی گفته و نویسنده چه lessonی استخراج می‌کند.

**تمرین فصل:** برای تیم فرضی خود سه قانون merge، دو شاخص جریان، یک شاخص کیفیت، مسیر escalation و جلسهٔ ماهانهٔ بهبود تعریف کن؛ توضیح بده چطور مطمئن می‌شوی این معیارها review سطحی را تشویق نمی‌کنند.

## تاپیک‌ها

- [Definition of Done، اتوماسیون و سلامت جریان](01-process-automation/README.md)
- [تجربه‌های واقعی و کارگاه پایانی](02-real-world-capstone/README.md)

## مرور فصل

1. چه شاخصی می‌تواند bottleneck را نشان دهد بدون آن‌که رفتار بد ایجاد کند؟
2. چگونه از postmortem درس می‌گیریم بی‌آنکه علت را بیش از شواهد ادعا کنیم؟
3. Definition of Done برای review تیم باید چه مواردی را روشن کند؟

**پاسخ راهنما:** زمان انتظار و زمان چرخه را کنار کیفیت/بازگشت defect بخوان و آن را برای تشخیص فرایند، نه رتبه‌بندی فرد، به‌کار ببر. واقعیت‌های گزارش را از تفسیر جدا کن و فقط کنترل‌هایی را نتیجه بگیر که به شواهد incident وصل‌اند. DoD باید تست‌ها، reviewهای الزامی، مجوزها، migration، مستندات و در تغییر پراثر rollout/monitoring/recovery را پوشش دهد.

## منابع فصل

- [چک‌لیست رسمی Code Review در roadmap.sh](https://roadmap.sh/pdfs/best-practices/code-review.pdf)
- [GitLab: Code Review Guidelines](https://docs.gitlab.com/development/code_review/)
- [Microsoft Engineering Playbook: Code Review FAQ](https://microsoft.github.io/code-with-engineering-playbook/code-reviews/faq/)
- [GitHub: Protected branches and required reviews](https://docs.github.com/en/repositories/configuring-branches-and-merges-in-your-repository/managing-protected-branches/about-protected-branches)
- [GitHub: About code owners](https://docs.github.com/en/repositories/managing-your-repositorys-settings-and-features/customizing-your-repository/about-code-owners)
