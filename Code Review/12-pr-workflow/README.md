# گردش‌کار عملی Pull Request و Merge Request

**زبان:** فارسی · [English](../en/12-pr-workflow/README.md)

این فصل روند مفهومی GitHub/GitLab را آموزش می‌دهد؛ عنوان دکمه‌ها و قابلیت رابط ممکن است تغییر کند یا به تنظیم repository بستگی داشته باشد. مفهوم‌ها ثابت‌ترند: پیشنهاد diff، بحث، اصلاح، تایید، کنترل خودکار و ادغام.

## بخش اول: آماده‌کردن branch

پیش از شروع مطمئن شو در مخزن درست هستی و branch مقصد را می‌شناسی. نمونهٔ فرمان‌های رایج Git:

<pre dir="ltr"><code>git status --short
git switch -c feature/search-pagination
# edit files and run relevant tests
git diff --check
git diff --stat
git diff
git add src/search tests/search
git diff --cached
git commit -m "Add stable search pagination"
git push -u origin feature/search-pagination</code></pre>

فرمان‌ها نمونه‌اند؛ مسیرها و نام branch را با پروژه هماهنگ کن. پیش از commit به diff نگاه کن تا secret، فایل محیطی، build output یا تغییر نامربوط stage نشده باشد. عنوان commit باید معنای تغییر را بگوید. اگر چند علت مستقل داری، commit یا PR جدا می‌تواند تاریخچه و بازگشت را ساده کند.

## بخش دوم: ساخت PR/MR

1. **مقصد را دوباره بررسی کن:** source branch و target branch درست‌اند؟
2. **شرح را پر کن:** مسئله، راه‌حل، تست، risk، rollout و سؤال‌های review.
3. **Draft یا Ready:** اگر هنوز کار می‌کنی، draft را به‌کار ببر؛ می‌توانی برای طراحی بازخورد زودهنگام بخواهی.
4. **اشخاص مناسب:** ownerها، reviewer حوزه و متخصصان لازم را انتخاب کن.
5. **خودت diff را بخوان:** view تغییرات و context خطوط قبل/بعد را باز کن.
6. **pipeline را ببین:** تست، lint، build و scan چه revisionی را سنجیده‌اند؟

در GitHub معمولاً Pull Request و در GitLab Merge Request گفته می‌شود؛ هر دو برای گفت‌وگوی روی تغییر و تصمیم ادغام استفاده می‌شوند. رفتارهای دقیق review thread، required approval، suggestion و auto-merge با نسخه و policy فرق می‌کند.

## بخش سوم: بازبین در ابزار چه می‌کند؟

1. شرح و issue را می‌خواند.
2. نمای کلی فایل‌ها و diff را می‌بیند.
3. روی خط مشخص comment یا suggestion می‌گذارد.
4. اگر هنوز بررسی کامل نشده، review را نهایی اعلام نمی‌کند.
5. در پایان جمع‌بندی و وضعیت review را می‌فرستد.

در GitHub امکان ثبت comment و suggestion در جریان review وجود دارد؛ GitLab نیز review و discussion را در MR نگه می‌دارد. اما هر دو ابزار می‌توانند پیکربندی متفاوت داشته باشند. از رفتار UI فعلی مخزن مطمئن شو و policy آن را بخوان.

## بخش چهارم: پاسخ نویسنده و دور دوم

نویسنده هر comment را می‌فهمد، پاسخ می‌دهد، اصلاح را push می‌کند و تست را دوباره اجرا می‌کند. اگر بخشی بیرون scope است، issue مرتبط بسازد و در همان گفتگو لینک بدهد. پس از تغییر مهم، reviewer را re-request کند. در دور دوم بازبین delta را با revision قبل مقایسه می‌کند و می‌سنجد آیا آخرین CI و approval هنوز معتبرند.

## بخش پنجم: ادغام

پیش از merge از وضعیت آخر مطمئن شو:

- required status checks مربوط به HEAD سبزند؛
- approvalهای لازم متعلق به همان diff یا مورد تایید policy هستند؛
- commentها طبق فرایند تیم تعیین تکلیف شده‌اند؛
- merge conflict و dependencyها حل شده‌اند؛
- تغییر پراثر rollout، پایش و recovery plan دارد.

Merge به معنی deployment نیست. ممکن است کد ادغام شود ولی feature flag خاموش بماند؛ یا deployment مرحله‌ای انجام شود. پس از انتشار، metric مرتبط با هدف را دنبال کن و در صورت عبور از آستانه، rollout را متوقف یا rollback کن.

## فرق ابزار با اصول

| مورد | اصل پایدار | جزئیات متغیر |
|---|---|---|
| Approval | کسی باید revision موردنظر را دیده باشد | تعداد reviewer، چه کسی می‌تواند approve کند |
| CODEOWNERS | ownership باید مشخص باشد | syntax، محل فایل، رفتار درخواست خودکار |
| Checks | شواهد خودکار باید تازه باشند | نوع pipeline، گیت‌ها و امکان bypass |
| Suggestions | تغییر پیشنهادی باید قابل بازبینی باشد | دکمه و نحوهٔ commitکردن در UI |
| Resolve | گفتگو باید وضعیت روشن داشته باشد | چه کسی thread را می‌بندد |

## عیب‌یابی موقعیت‌های رایج

- **CI سبز نیست:** ببین failure واقعاً مرتبط است یا flaky؛ نتیجه را بی‌بررسی dismiss نکن.
- **Approval ناپدید شد:** diff یا base branch ممکن است عوض شده باشد؛ policy را ببین و reviewer را دوباره خبر کن.
- **کامنت روی خط قدیمی گم شده:** آن را در timeline یا revision قبلی پیدا و نتیجه را به نسخهٔ جدید متصل کن.
- **PR بزرگ و کند است:** هدف، نویز، وابستگی و reviewerهای لازم را بررسی کن؛ فقط فشار زمانی وارد نکن.
- **merge conflict:** ابتدا branch را به‌روز کن؛ حل conflict می‌تواند رفتار را تغییر دهد و review تازه لازم داشته باشد.

## تمرین عملی

یک branch آزمایشی در مخزن شخصی بساز و یک تغییر کوچک همراه تست ایجاد کن. diff را self-review، شرح را پر و PR را draft کن. بعد به‌عنوان reviewer یک سؤال، یک suggestion و یک مورد blocker فرضی بنویس؛ تغییر را اصلاح، pipeline را برای آخرین commit ببین و در پایان PR را merge یا ببند. هیچ‌یک از این تمرین‌ها را به مخزن عمومی بدون خواندن contribution guide نفرست.

## منابع رسمی

- [GitHub: Reviewing a pull request](https://docs.github.com/en/pull-requests/collaborating-with-pull-requests/reviewing-changes-in-pull-requests/reviewing-a-pull-request)
- [GitHub: Resolving reviews](https://docs.github.com/en/pull-requests/concepts/resolving-reviews)
- [GitHub: Protected branches](https://docs.github.com/en/repositories/configuring-branches-and-merges-in-your-repository/managing-protected-branches/about-protected-branches)
- [GitHub: About code owners](https://docs.github.com/en/repositories/managing-your-repositorys-settings-and-features/customizing-your-repository/about-code-owners)
- [GitLab: Code Review Guidelines](https://docs.gitlab.com/development/code_review/)

## مطالعهٔ فارسی

- [بازبینی کد؛ راهنمای برنامه‌نویسان — امروزینو](https://emrozino.ir/article/code-review-beginners-guide)
- [بازبینی کد؛ چطور کد دیگران را بخوانیم — نت پارادیس](https://netparadis.com/code-review-practices-pull-request/?rm=pro-skills)
- [بازبینی کد؛ فرایند و اهمیت](https://hheydarian.github.io/Gitab/books/book2/Book/02/Code-Review-Process-and-Importance/)
