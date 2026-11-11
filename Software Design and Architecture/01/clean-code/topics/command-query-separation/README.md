<div dir="rtl" align="right">

# جداسازی فرمان و پرس‌وجو — Command-Query Separation


> **زبان:** [نسخهٔ انگلیسی](../../../../en/01/clean-code/topics/command-query-separation/README.md)

[فصل کد تمیز](../../README.md) · [فهرست دوره](../../../../00-index.md)

## هدف درس

بتوانی مسئلهٔ این اصل را تشخیص بدهی، آن را در کد به‌کار ببری، trade-off را توضیح بدهی و در آزمون از نتیجه دفاع کنی.

## آموزش دقیق

CQS اصل سطح operation است: command وضعیت را تغییر می‌دهد؛ query نتیجه می‌خواند و state دامنه را تغییر نمی‌دهد. این جداسازی caller را از اثر قابل انتظار آگاه می‌کند. Queryهای pure راحت‌تر cache، retry و load balance می‌شوند؛ commandها نیازمند idempotency و کنترل تکرارند.

۱. نام و قرارداد هر operation را بررسی کن: آیا دارد تغییر می‌دهد یا می‌خواند؟
۲. تغییر دامنه را command صریح کن؛ نتیجهٔ جاری را query جدا بخوان.
۳. side effectهای جانبی مثل logging را از تغییر دامنه تفکیک کن.
۴. اگر مدل‌های خواندن/نوشتن واقعاً متفاوت‌اند، CQRS را ارزیابی کن.

## CQS با CQRS فرق دارد

CQS در سطح متد و گاهی یک شیء اجرا می‌شود. CQRS مسئولیت/مدل خواندن و نوشتن را جدا می‌کند؛ می‌تواند در یک سرویس و یک پایگاه داده آغاز شود و بعدها نیازمند projection، eventual consistency و نگهداری دو مدل شود.

## مثال

get_or_create_user نام query را به عملیات تغییر تبدیل می‌کند و retry آن ممکن است کاربر بسازد. API شفاف‌تر می‌تواند find_user و register_user باشد. اگر registration باید در یک عملیات واحد انجام شود، آن را command مستقل و اتمیک تعریف کن.

## تمرین

API read/write را فهرست کن، operationهایی را بیاب که هم state عوض می‌کنند و هم دادهٔ متناقض می‌دهند، سپس تشخیص بده مشکل CQS است یا واقعاً به مدل CQRS نیاز داری.

## نمونهٔ کد/قرارداد

~~~python
def get_balance(account_id):       # query
    return repository.load(account_id).balance_cents

def withdraw(account_id, amount):  # command
    account = repository.load(account_id)
    account.withdraw(amount)
    repository.save(account)
~~~

## تمرین سنجش

نمونه‌ای از کد خودت یا یک پروژهٔ آموزشی انتخاب کن. مفهوم را در یک تغییر کوچک اعمال کن، آزمونی برای رفتار مرزی اضافه کن و با یک جمله ثبت کن که چه چیزی خواناتر یا امن‌تر شد.

## کوییز با پاسخ تشریحی

پیش از دیدن پاسخ، دلیل خودت را بنویس. پاسخ پیشنهادی باید با زمینه هماهنگ باشد؛ اگر گزینهٔ دیگری داری، trade-off آن را هم بیان کن.

1. **CQS چه چیزی را تفکیک می‌کند؟**
   - پاسخ تشریحی: عملیات تغییر‌دهندهٔ state از عملیات خواندن نتیجه.
2. **آیا CQS دو دیتابیس لازم دارد؟**
   - پاسخ تشریحی: نه؛ این اصل می‌تواند داخل یک کلاس و یک دیتابیس رعایت شود.
3. **CQRS چه هزینه‌ای اضافه می‌کند؟**
   - پاسخ تشریحی: جداسازی مدل‌ها، projection، همگام‌سازی، eventual consistency و عملیات بیشتر.

## منابع اختیاری فارسی و انگلیسی

این درس برای فهم مبانی کامل است؛ پیوندها برای مقایسه و مطالعهٔ بیشترند.

### فارسی

- [DevNA؛ اصول کلین‌کد](https://devna.ir/articles/clean-code-principles)
- [JavaScript.info؛ سبک کدنویسی به فارسی](https://fa.javascript.info/coding-style)

### انگلیسی

- [Google Java Style Guide](https://google.github.io/styleguide/javaguide.html)
- [Clean Code JavaScript](https://github.com/ryanmcdermott/clean-code-javascript)




## منابع تکمیلی

[کتابخانهٔ منابع مرتبط با این فصل](../../../../references.md#chapter-01)
</div>
