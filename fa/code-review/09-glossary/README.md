# واژه‌نامهٔ دوزبانهٔ بازبینی کد

**زبان:** فارسی · [English](../../../en/code-review/09-glossary/README.md)

این ضمیمه اصطلاح‌های اصلی دوره را با تعریف عملی توضیح می‌دهد. ترجمه‌ها معادل کمکی‌اند؛ در تیم‌های مختلف ممکن است اصطلاح متفاوت به‌کار رود.

## نقش‌ها و شیءهای کار

| اصطلاح | معادل/تعریف فارسی | مثال |
|---|---|---|
| Code Review | بازبینی کد؛ بررسی تغییر توسط همکار | نگاه به diff سفارش پیش از ادغام |
| Author | نویسندهٔ تغییر | کسی که branch و PR را می‌سازد |
| Reviewer | بازبین | هم‌تیمی که رفتار و ریسک را می‌سنجد |
| Maintainer | نگه‌دارندهٔ پروژه | مسئول تصمیم نهایی یا نگه‌داری مخزن |
| Pull Request (PR) | درخواست ادغام؛ اصطلاح GitHub | درخواست انتقال تغییر branch به مقصد |
| Merge Request (MR) | درخواست ادغام؛ اصطلاح GitLab | معادل عملی PR در GitLab |
| Change List (CL) | مجموعهٔ تغییر برای بررسی | واژه‌ای که در راهنمای Google استفاده می‌شود |
| Diff | تفاوت دو نسخه | خط‌های اضافه‌شده و حذف‌شده |
| Base branch | شاخهٔ مقصد مقایسه/ادغام | معمولاً main |
| Head branch | شاخهٔ منبع PR | شاخهٔ feature |
| Commit | snapshot تغییر در تاریخچهٔ Git | یک گام ثبت‌شده در branch |
| Draft PR | درخواست پیش‌نویس | برای feedback زودهنگام، نه ادعای آمادگی merge |
| Stacked PR | PR وابسته به PR قبلی | migration اول، feature دوم |

## گفت‌وگو و تصمیم

| اصطلاح | معادل/تعریف فارسی | تفاوت کلیدی |
|---|---|---|
| Comment | نظر روی خط یا PR | ممکن است سؤال، توضیح یا درخواست باشد |
| Suggestion | پیشنهاد تغییر | در بعضی ابزارها متن اصلاح پیشنهادی دارد |
| Approval / Approve | تایید revision بررسی‌شده | تضمین بی‌خطایی یا سلامت production نیست |
| Request Changes | درخواست تغییر | در بعضی policyها تا رفع مورد merge را متوقف می‌کند |
| Blocker | مانع ادغام | ریسک معتبر یا الزام روشن باید رفع/تصمیم‌گیری شود |
| Suggestion | بهبود اختیاری | می‌تواند در PR یا issue بعدی بیاید |
| Question | سؤال برای فهم | لزوماً درخواست تغییر نیست |
| Nit | نکتهٔ جزئی و غیرمسدودکننده | نباید برای پنهان‌کردن ایراد مهم به‌کار رود |
| LGTM | Looks Good To Me؛ به‌نظر خوب است | بهتر است با وضعیت و دامنهٔ review همراه شود |
| Thread | رشتهٔ گفتگو روی یک موضوع | resolveشدن thread correctness را ثابت نمی‌کند |
| Re-review | بازبینی دوباره | پس از revision معنادار |
| Push | ارسال commit به remote | می‌تواند diff و اعتبار approval را تغییر دهد |
| Stale approval | تایید قدیمی‌شده | policy ممکن است پس از تغییر diff آن را نامعتبر کند |

## کیفیت، طراحی و آزمون

| اصطلاح | معادل/تعریف فارسی | نمونه |
|---|---|---|
| Requirement | نیازمندی | کاربر باید فقط سفارش خود را ببیند |
| Acceptance criteria | معیار پذیرش | شرایطی که feature را قابل‌قبول می‌کنند |
| Invariant | خاصیت همواره برقرار | یک idempotency key فقط یک پرداخت بسازد |
| Edge case | حالت مرزی | لیست خالی، دادهٔ بیشینه یا درخواست تکراری |
| Regression | بازگشت خطای رفع‌شده | تغییر جدید دوباره pagination را می‌شکند |
| Unit test | تست واحد | تابع با dependencyهای محدود |
| Integration test | تست یکپارچه‌سازی | سرویس با DB واقعی/آزمایشی |
| Contract test | تست قرارداد | توافق producer و consumer API |
| End-to-end test | تست سرتاسری | جریان کامل کاربر در سیستم |
| Assertion | شرط موردانتظار تست | مبلغ نهایی برابر انتظار باشد |
| Mock | بدل کنترل‌شدهٔ dependency | شبیه‌سازی پاسخ درگاه |
| Flaky test | تست ناپایدار | گاهی بی‌دلیل پاس و گاهی fail می‌شود |
| Coverage | درصد پوشش اجرای کد | صحت assertion یا کامل‌بودن تست را ثابت نمی‌کند |
| Refactoring | بازساخت بدون تغییر قصد رفتاری | ساده‌کردن ساختار با تست محافظ |
| Coupling | وابستگی اجزا به هم | تغییر یک ماژول، چند سرویس را می‌شکند |
| API contract | قرارداد API | نوع، معنا، خطا و دسترسی |
| Backward compatibility | سازگاری رو به عقب | client قدیمی با نسخهٔ جدید کار کند |

## امنیت و وابستگی

| اصطلاح | معادل/تعریف فارسی | یادآوری |
|---|---|---|
| Authentication | احراز هویت؛ هویت کیست؟ | پاسخ به پرسش «چه کسی؟» |
| Authorization | مجوزدهی؛ اجازهٔ چه کاری روی چه منبعی؟ | هویت معتبر لزوماً مجاز نیست |
| Trust boundary | مرز اعتماد | ورودی HTTP، queue، فایل یا سرویس خارجی |
| Source | منبع داده | request، فایل، پیام یا DB |
| Sink | مقصد حساس | query، shell، log، HTML یا filesystem |
| Taint/data flow | جریان دادهٔ کنترل‌نشده | ورودی تا مقصد دنبال می‌شود |
| SAST | تحلیل ایستای امنیتی | کد را بدون اجرای کامل تحلیل می‌کند |
| DAST | آزمون پویا | برنامهٔ در حال اجرا را از بیرون می‌سنجد |
| Secret | راز دسترسی | password، token، private key |
| Dependency | وابستگی نرم‌افزاری | کتابخانه‌ای که پروژه وارد می‌کند |
| Lockfile | فایل تثبیت نسخهٔ dependencyها | نسخهٔ دقیق نصب را بازتولید می‌کند |
| Supply-chain risk | ریسک زنجیرهٔ تأمین | منبع، maintainer، نسخه و install script |
| Least privilege | حداقل دسترسی لازم | سرویس فقط مجوز موردنیاز را داشته باشد |
| Threat model | مدل تهدید | دارایی، مهاجم، مرزها و مسیر حمله |

## عملیات و سنجش

| اصطلاح | معادل/تعریف فارسی | نمونه |
|---|---|---|
| Migration | تغییر ساختار/داده | افزودن ستون به جدول |
| Rollout | فعال‌سازی/انتشار مرحله‌ای | شروع روی درصد کمی ترافیک |
| Rollback | بازگرداندن نسخه/رفتار | خاموش‌کردن flag یا بازگشت کد |
| Feature flag | کلید فعال‌سازی قابلیت | تغییر کد merge شود اما خاموش بماند |
| Canary | انتشار آزمایشی محدود | ابتدا چند instance یا درصد کم |
| Observability | قابلیت فهم وضعیت از telemetry | metrics، logs، traces |
| Metric | سنجه | نرخ خطای پرداخت |
| Alert | هشدار نیازمند اقدام | خطای بالاتر از آستانه |
| Blast radius | گسترهٔ اثر شکست | یک کاربر تا همهٔ سرویس |
| Tail latency | کندی صدک‌های انتهایی | p95 یا p99 زمان پاسخ |
| N+1 query | یک query به‌علاوهٔ query برای هر رکورد | صفحهٔ ۱۰۰ ردیفی ممکن است ۱۰۱ query بزند |
| Idempotency | تکرار امن یک عملیات | retry پرداخت دومین charge نسازد |
| Race condition | نتیجه وابسته به زمان‌بندی هم‌زمانی | دو درخواست هر دو موجودی را بخوانند |
| Backoff | فاصلهٔ افزایشی retry | فشار را هنگام اختلال کمتر کند |
| SLO | هدف سطح خدمت | هدف قابل‌اندازه‌گیری قابلیت اطمینان |

## جفت‌هایی که نباید قاطی شوند

- **Authentication ≠ Authorization:** شناخت هویت به معنی اجازهٔ دسترسی به هر شیء نیست.
- **Coverage ≠ Test quality:** ممکن است خط اجرا شده باشد اما انتظار اشتباه assert شود.
- **Resolved ≠ Fixed:** thread بسته شده، ولی نتیجهٔ کد باید بررسی شود.
- **Approve ≠ Guarantee:** approval به revision و دامنهٔ بررسی محدود است.
- **Merge ≠ Deploy:** ادغام کد مرحلهٔ انتشار یا فعال‌سازی نیست.
- **Input validation ≠ Access control:** معتبر بودن شناسه، مالکیت را ثابت نمی‌کند.
- **Average latency ≠ Tail latency:** میانگین خوب می‌تواند کاربران کند را پنهان کند.
- **Correlation ≠ Causation:** هم‌زمانی دو شاخص علت را ثابت نمی‌کند.

## منابع

- [Google Engineering Practices: Code Review](https://google.github.io/eng-practices/review/)
- [OWASP Secure Code Review Cheat Sheet](https://cheatsheetseries.owasp.org/cheatsheets/Secure_Code_Review_Cheat_Sheet.html)
- [راهنمای فارسی بازبینی کد](https://www.sauleh.ir/ap97/static_files/AP97982-CodeReviewGuide.V.1.3.pdf)
- [بازبینی کد؛ راهنمای فارسی](https://emrozino.ir/article/code-review-beginners-guide)
