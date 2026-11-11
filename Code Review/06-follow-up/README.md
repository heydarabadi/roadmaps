# فصل ۶ — پاسخ، تایید و ادغام

**زبان:** فارسی · [English](../en/06-follow-up/README.md)

**هدف:** feedback را پاسخ بده، revision جدید را دوباره بررسی کن و merge را به revision تاییدشده متصل کن.

## درس پیونددهندهٔ فصل

یک review وقتی کامل می‌شود که نویسنده فهمیده باشد چه چیزی مطرح است و بازبین نتیجهٔ اصلاح را در revision تازه دیده باشد. پاسخ «done» بدون شاهد مبهم است؛ بهتر است تغییر، تست و commit مربوط را نام ببری. حل thread وضعیت گفتگو را روشن می‌کند، اما correctness را ثابت نمی‌کند.

Approval به diffی تعلق دارد که بازبین دیده است. پس از push جدید، آخرین CI، approval policy، CODEOWNERS و محتوا را دوباره بررسی کن. Merge هم انتشار نیست؛ تغییر پراثر rollout، پایش و recovery می‌خواهد. سطح اطمینان و محدودهٔ review را در خلاصهٔ نهایی بنویس.

**تمرین فصل:** برای PRی که پس از approve یک commit جدید می‌گیرد، گام‌هایی را که نویسنده، reviewer و pipeline باید دوباره انجام دهند فهرست کن؛ بگو چه چیزی می‌تواند approval را stale کند.

## تاپیک‌ها

- [پاسخ نویسنده و اصلاح](./01-address-feedback/README.md)
- [بازبینی مجدد، approval و merge](./02-rereview-merge/README.md)

## مرور فصل

1. نویسنده چطور نشان دهد که یک feedback را واقعاً رسیدگی کرده است؟
2. چه تفاوتی بین بستن thread و اثبات اصلاح وجود دارد؟
3. چه زمانی approval قبلی باید دوباره بررسی شود؟

**پاسخ راهنما:** commit یا تغییر مشخص، نتیجهٔ تست و در صورت نیاز توضیح trade-off را ارجاع بده؛ «انجام شد» مبهم است. بستن thread فقط وضعیت گفتگو را ثبت می‌کند، reviewer باید diff جدید را ببیند. پس از تغییر revision/base، تغییر رفتار، رفع conflict یا طبق policy سازمان، approval و CI را برای آخرین diff دوباره بسنج.

## منابع فصل

- [چک‌لیست رسمی Code Review در roadmap.sh](https://roadmap.sh/pdfs/best-practices/code-review.pdf)
- [GitHub: Resolving reviews](https://docs.github.com/en/pull-requests/concepts/resolving-reviews)
- [GitLab: Code Review Guidelines](https://docs.gitlab.com/development/code_review/)
- [Google: The CL Author’s Guide](https://google.github.io/eng-practices/review/developer/)
- [بازبینی کد؛ فرایند و اهمیت](https://hheydarian.github.io/Gitab/books/book2/Book/02/Code-Review-Process-and-Importance/)
