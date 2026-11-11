# فصل ۴ — بررسی فنی

**زبان:** فارسی · [English](../en/04-technical-review/README.md)

**هدف:** درستی، طراحی، تست، امنیت، کارایی و پیامدهای عملیاتی را ارزیابی کن.

## درس پیونددهندهٔ فصل

بازبینی فنی با رفتار مورد انتظار شروع می‌شود. از requirement invariant بساز، مسیر موفق و خطا را دنبال کن، edge case و قرارداد بیرونی را بخوان. سپس ببین تست‌ها این رفتار را واقعاً محافظت می‌کنند. برای security از مرز اعتماد و جریان داده استفاده کن؛ برای performance مسیر پرترافیک و دادهٔ نماینده را بسنج؛ برای عملیات، سازگاری نسخه‌ها، rollout، metric و recovery را در نظر بگیر.

ترتیب اهمیت را ریسک تعیین می‌کند. نام‌گذاری و style مهم‌اند، اما formatter می‌تواند آن‌ها را بررسی کند؛ زمان انسان را برای مجوز، داده، race، API و failure نگه دار. یافته باید evidence داشته باشد. اگر احتمال را می‌بینی اما هنوز نمی‌توانی آن را اثبات کنی، سؤال یا آزمون پیشنهادی بنویس.

**تمرین فصل:** یک endpoint را انتخاب کن و برگه‌ای شامل رفتار مطلوب، invariant، پنج سناریوی تست، threat boundary، بدترین حالت کارایی و طرح پایش پس از انتشار پر کن.

## تاپیک‌ها

- [درستی رفتار، طراحی و قرارداد API](./01-correctness-design-api/README.md)
- [تست و بررسی امنیتی](./02-tests-security/README.md)
- [کارایی، مقیاس و عملیات](./03-performance-operations/README.md)

## مرور فصل

1. برای سنجش درستی رفتار از چه چیزی شروع می‌کنی؟
2. چرا تست سبز، امنیت یا performance را به‌طور کامل اثبات نمی‌کند؟
3. در تغییر پراثر، چه چیزهایی را فراتر از کد و تست بررسی می‌کنی؟

**پاسخ راهنما:** نیازمندی را به invariant و سناریوهای موفق، مرزی و شکست تبدیل کن. تست فقط ورودی/مسیرهای پوشش‌داده‌شده را نشان می‌دهد و ممکن است authz منطقی، بار واقعی یا رقابت هم‌زمان را نبیند. migration، سازگاری نسخه‌ها، rollout، metric، alert، rollback و مالک عملیات را نیز بررسی کن.

## منابع فصل

- [Google Engineering Practices: Code Review](https://google.github.io/eng-practices/review/)
- [Google: How to do a code review](https://google.github.io/eng-practices/review/reviewer/)
- [GitLab: Code Review Guidelines](https://docs.gitlab.com/development/code_review/)
- [GitHub: Reviewing a pull request](https://docs.github.com/en/pull-requests/collaborating-with-pull-requests/reviewing-changes-in-pull-requests/reviewing-a-pull-request)
- [بازبینی کد؛ چطور کد دیگران را بخوانیم — نت پارادیس](https://netparadis.com/code-review-practices-pull-request/?rm=pro-skills)
