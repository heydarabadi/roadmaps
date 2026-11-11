# بازبینی مجدد، approval و merge

**زبان:** فارسی · [English](../../en/06-follow-up/02-rereview-merge/README.md)

> مسیر: [فصل ۶ — پاسخ، تایید و ادغام](../README.md) · [فهرست دوره](../../README.md)

## آموزش

دور دوم review باید delta و اثر آن را بسنجد: آیا comment حل شد؟ آیا تغییر تازه مسئلهٔ دیگری ساخت؟ CI باید مربوط به آخرین revision باشد. approval به نسخهٔ بررسی‌شده وصل است؛ branch protection ممکن است آن را پس از تغییر diff stale کند و CODEOWNERS/required checks را enforce نماید.

Approve یعنی نسخهٔ حاضر بر اساس شواهد و policy آمادهٔ ادغام است، نه تضمین بی‌خطایی یا رفتار production. پیش از merge، blockers، conflicts، approvals، checks و dependencies را ببین. نویسنده نباید ruleها را برای سرعت دور بزند مگر policy اجازه دهد.

پس از ادغام تغییر پراثر، rollout و پایش لازم است. merge و انتشار یا فعال‌شدن feature یک مرحله نیستند. خلاصهٔ review بگوید چه بررسی شد و محدودیت باقی‌مانده کجاست.

## روند پیشنهادی

1. revision جدید و feedback باقی‌مانده را مرور کن.
2. اصلاح blocker و اثرهای جانبی را تایید کن.
3. CI و approval را برای HEAD بسنج.
4. conflict، dependency و ruleهای merge را بررسی کن.
5. merge را از rollout و پایش جدا برنامه‌ریزی کن.

## مثال کاربردی

پس از approve تغییر مجوز یک commit تازه می‌آید. چون diff عوض شده، reviewer آن را دوباره می‌سنجد و branch policy ممکن است تایید تازه بخواهد.

## خطاهای رایج

approval قدیمی را به کد تازه تعمیم نده؛ CI پیشین را معتبر ندان؛ approve را تضمین کامل نخوان؛ merge را پایان عملیات فرض نکن.

## چک‌لیست

- [ ] هدف و انتظار کاربر را می‌فهمم.
- [ ] یافته را با اثر یا شاهد مشخص می‌کنم.
- [ ] ریسک مرتبط را بررسی می‌کنم.
- [ ] الزام، پیشنهاد، سؤال و ترجیح را جدا می‌کنم.
- [ ] محدودیت شواهد را پنهان نمی‌کنم.

## آزمون

### پرسش 1

**سؤال:** دور دوم review بر چه تمرکز دارد؟

   1. تعداد commit
   2. delta، حل blocker و اثر جانبی
   3. فقط style
   4. تاریخچهٔ کامل بی‌هدف

**پاسخ:** 2 — اصلاح باید در revision جدید تایید شود.

### پرسش 2

**سؤال:** CI لازم برای merge باید مربوط به چه باشد؟

   1. اولین commit
   2. آخرین revision/HEAD
   3. branch دیگری
   4. PR مشابه

**پاسخ:** 2 — کد تازه می‌تواند نتیجهٔ تست را عوض کند.

### پرسش 3

**سؤال:** Approve دقیقاً چه می‌گوید؟

   1. بی‌نقصی قطعی
   2. نسخهٔ بررسی‌شده مطابق policy و شواهد آمادهٔ merge است
   3. تضمین سلامت production
   4. تایید همهٔ نسخه‌های آینده

**پاسخ:** 2 — تایید به revision و دامنهٔ review محدود است.

### پرسش 4

**سؤال:** CODEOWNERS و branch protection چه می‌کنند؟

   1. جلوگیری از هر باگ
   2. اجرای برخی قواعد review/approval
   3. جایگزین امنیت
   4. rollback

**پاسخ:** 2 — گیت‌ها policy را اعمال می‌کنند اما منطق را نمی‌فهمند.

## آموزش عمیق: تایید باید به همان revision وصل باشد

### بازبین در دور دوم چه می‌کند؟

دور دوم فقط «آیا نویسنده کامنت را resolve کرد؟» نیست. تغییرات را با revision قبلی مقایسه کن، اصلاح blocker را مشاهده کن، اثرهای جانبی همان اصلاح را بسنج و مطمئن شو تست مربوط به آخرین commit است. اگر تغییر کوچک و مستقل است، diff تازه ممکن است کافی باشد؛ اگر تغییر روی معماری، مجوز یا جریان داده اثر گذاشته، مسیر وسیع‌تر را دوباره بخوان.

### سه وضعیت را از هم جدا کن

- **Conversation resolved:** thread بسته یا به پاسخ رسیده است.
- **Review approved:** بازبین revision مشخص را با policy جاری قابل‌ادغام می‌داند.
- **Checks passed:** کنترل‌های خودکار تعریف‌شده برای revision مشخص موفق‌اند.

هیچ‌کدام جای دیگری را نمی‌گیرد. thread حل‌شده تضمین تست نیست؛ CI سبز به معنی approval نیست؛ approval ممکن است پس از push تازه دیگر به همان diff مربوط نباشد.

### قواعد ابزار در برابر اصل عمومی

اصل عمومی: تایید باید به کدی مربوط باشد که واقعاً بررسی شده است. GitHub protected branches می‌تواند تعداد approval، CODEOWNERS، حل conversation و status checks را الزام کند و با تغییر diff، approval را stale کند. جزئیات تنظیمات قابل انتخاب است و در هر repository متفاوت خواهد بود؛ policy همان مخزن را ببین، از رفتار UI یک repo نتیجهٔ جهانی نگیر.

### چک‌لیست پیش از merge

1. آخرین commit و base branch را می‌شناسم.
2. نتیجهٔ pipeline به همان revision تعلق دارد.
3. reviewer لازم و owner حوزه تایید کرده‌اند.
4. blockerها حل یا با مسئول مجاز تصمیم‌گیری شده‌اند.
5. conflict، dependency PR و تغییر بعد از approval روشن است.
6. rollout، migration، feature flag و rollback متناسب با ریسک برنامه دارند.

### مثال

PR پس از approval یک commit تازه می‌گیرد که فقط تست را «اصلاح» می‌کند. اگر تغییر تست assertion را حذف کرده باشد، code diff کوچک است ولی اطمینان را کم می‌کند. reviewer باید آخرین diff تست را هم بخواند و مطمئن شود CI تازه اجرا شده. در تغییر محتوایی جدید، approval قبلی ممکن است طبق branch policy بی‌اعتبار شود.

### تصمیم و خلاصه

کامنت پایانی باید وضعیت را بگوید: «Approved» یا «Changes requested»، blocker باقی‌مانده چیست، چه قسمت‌هایی بررسی شد و چه چیزی بیرون دامنه ماند. برای PR پرریسک، «LGTM» بدون زمینه به تاریخچهٔ بعدی کمکی نمی‌کند. مرز اطمینان را صادقانه بگو.

### تمرین

یک reviewer approve کرده، نویسنده بعداً کد جدیدی برای logging push می‌کند و CI قدیمی هنوز سبز دیده می‌شود. پیش از merge چه می‌کنی؟ پاسخ: diff جدید و اثر دادهٔ log را بررسی، pipeline مربوط به HEAD را اجرا/تایید، policy stale approval و نیاز re-review را بسنج؛ سپس تصمیم ثبت‌شده بگیر.

## منابع تکمیلی

- [راهنمای فارسی عمومی بازبینی کد؛ مطالعهٔ مکمل](https://netparadis.com/code-review-practices-pull-request/?rm=pro-skills)


- [GitHub: Resolving reviews](https://docs.github.com/en/pull-requests/concepts/resolving-reviews)
- [GitHub: Protected branches and required reviews](https://docs.github.com/en/repositories/configuring-branches-and-merges-in-your-repository/managing-protected-branches/about-protected-branches)
- [GitHub: About code owners](https://docs.github.com/en/repositories/managing-your-repositorys-settings-and-features/customizing-your-repository/about-code-owners)
- [GitHub: Reviewing a pull request](https://docs.github.com/en/pull-requests/collaborating-with-pull-requests/reviewing-changes-in-pull-requests/reviewing-a-pull-request)
- [GitLab: Code Review Guidelines](https://docs.gitlab.com/development/code_review/)

مقاله‌های فارسی برای تکمیل مطالعه‌اند؛ در مورد policy یا رفتار ابزار، مستندات رسمی جاری را ملاک بگیر.
