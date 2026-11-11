# فصل ۳ — آماده‌سازی بازبین

**زبان:** فارسی · [English](../en/03-reviewer/README.md)

**هدف:** پیش از قضاوت، زمینه، اثر، مالکیت و سطح بررسی را مشخص کن.

## درس پیونددهندهٔ فصل

بازبین ابتدا فهم ایجاد می‌کند، سپس نظر می‌دهد. شرح و نیازمندی را بخوان؛ تغییرها را دسته‌بندی کن؛ ورودی، خروجی و مصرف‌کننده‌ها را دنبال کن؛ احتمال، شدت، دامنهٔ اثر و برگشت‌پذیری را بسنج. این روند کمک می‌کند commentها به هدف وصل باشند، نه به خطی که از بافت جدا شده است.

Reviewer باید تخصص و محدودیت خود را بداند. مالک کد ممکن است بهترین بازبین باشد، اما تغییر چندحوزه‌ای می‌تواند به تخصص‌های مکمل نیاز داشته باشد. CODEOWNERS برای مسیریابی مفید است و تضمین صحت نیست. اگر review در زمان معقول کامل نمی‌شود، زود خبر بده؛ برای پیچیدگی، feedback زودهنگام یا pairing را به‌کار بگیر.

**تمرین فصل:** برای یک PR دیتابیس، نمودار ساده‌ای از caller، query، دادهٔ ذخیره‌شده، consumer، failure mode و rollback رسم کن. دو reviewer را بر اساس خطر انتخاب و سهم بررسی هرکدام را بنویس.

## تاپیک‌ها

- [فهم زمینه و تحلیل ریسک](./01-context-risk/README.md)
- [انتخاب بازبین و برنامهٔ بررسی](./02-reviewer-selection/README.md)

## مرور فصل

1. چرا خواندن diff بدون فهم caller و نیازمندی خطرناک است؟
2. reviewer را بر چه اساسی انتخاب می‌کنی؟
3. اگر زمان یا تخصص کافی نداری، چه کار حرفه‌ای انجام می‌دهی؟

**پاسخ راهنما:** یک خط ممکن است اثرش را در مصرف‌کننده، داده یا قرارداد نشان دهد؛ زمینه جلوی کامنت بی‌ربط را می‌گیرد. تخصص، مالکیت و دامنهٔ ریسک را ملاک قرار بده و برای تغییر چندحوزه‌ای reviewerهای مکمل بخواه. زود اطلاع بده، بخش بررسی‌شده و محدودیت را روشن کن و موضوع امنیت/داده را به owner مرتبط ارجاع بده.

## منابع فصل

- [Google: How to do a code review](https://google.github.io/eng-practices/review/reviewer/)
- [GitLab: Code Review Guidelines](https://docs.gitlab.com/development/code_review/)
- [GitHub: Reviewing a pull request](https://docs.github.com/en/pull-requests/collaborating-with-pull-requests/reviewing-changes-in-pull-requests/reviewing-a-pull-request)
- [OWASP Secure Code Review Cheat Sheet](https://cheatsheetseries.owasp.org/cheatsheets/Secure_Code_Review_Cheat_Sheet.html)
- [بازبینی کد؛ فرایند و اهمیت](https://hheydarian.github.io/Gitab/books/book2/Book/02/Code-Review-Process-and-Importance/)
