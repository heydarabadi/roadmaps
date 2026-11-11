# Transactions چندسندی

> **English edition:** [Read this lesson in English](../../../../en/mongodb/05-reliability/transactions/README.md).

> **هدف یادگیری:** transaction را فقط برای invariantهای چندسندی لازم به کار ببرید.

## تدریس کامل: transaction با invariant شروع می‌شود

### Atomicity تک‌سندی

Write یک سند به طور اتمیک اعمال می‌شود. اگر داده را طوری مدل کنید که invariant داخل همان سند باشد، چند update جدا لازم نیست. مثلاً تغییر status یک سفارش و زمان updatedAt در همان سند انجام می‌شود.

### چه وقت transaction لازم است؟

وقتی یک عملیات کسب‌وکار چند سند را تغییر می‌دهد و حالت نیمه‌کاره غیرقابل‌قبول است، transaction چندسندی را بررسی کنید. مثال: انتقال مبلغ بین دو حساب. transaction همهٔ operationهای دیتابیس را در یک مرز commit/abort قرار می‌دهد. deployment باید topology سازگار داشته باشد و transaction هزینهٔ هماهنگی، زمان و منابع دارد.

برای روشن‌ماندن مثال، مقدار را به واحد خرد پول (مثلاً ریال یا سنت) و integer امن نگه می‌داریم؛ حساب‌های این نمونه همگی یک currency دارند. اگر مقدار از محدودهٔ `Number.MAX_SAFE_INTEGER` بزرگ‌تر است یا چند currency دارید، از نوع دقیق BSON و کتابخانهٔ decimal مناسب driver استفاده کنید؛ مبلغ مالی را به عدد اعشاری معمولی JavaScript تبدیل نکنید.

~~~javascript
if (!Number.isSafeInteger(amountMinor) || amountMinor <= 0) {
  throw new Error("مبلغ باید integer مثبت و در محدودهٔ امن باشد")
}

const session = client.startSession()
try {
  await session.withTransaction(async () => {
    const debit = await accounts.updateOne(
      { _id: fromId, balanceMinor: { $gte: amountMinor } },
      { $inc: { balanceMinor: -amountMinor } },
      { session }
    )
    if (debit.matchedCount !== 1) throw new Error("حساب مبدأ پیدا نشد یا موجودی کافی نیست")

    const credit = await accounts.updateOne(
      { _id: toId },
      { $inc: { balanceMinor: amountMinor } },
      { session }
    )
    if (credit.matchedCount !== 1) throw new Error("حساب مقصد پیدا نشد")
  })
} finally {
  await session.endSession()
}
~~~

کد بالا نمونهٔ Node.js driver و برای آموزش است؛ `client` و collection را پیش‌تر ساخته باشید. اگر هر filter سندی را پیدا نکند exception باعث abort کل transaction می‌شود. callback API خطاهای مشخص transient و نتیجهٔ نامعلوم commit را طبق driver/version مدیریت می‌کند؛ callback ممکن است دوباره اجرا شود. برای انتقال واقعی، شناسهٔ یکتای درخواست/transfer و سیاست idempotency هم طراحی کنید.

### تماس بیرونی transaction نیست

Database transaction نمی‌تواند ایمیل یا بانک خارجی را rollback کند. در transaction side effect شبکه انجام ندهید. از outbox استفاده کنید: event را همراه تغییر دیتابیس ثبت کنید، سپس worker آن را با کلید تکرارناپذیر منتشر کند. برای پرداخت، idempotency key و reconciliation لازم است.

### Retry و idempotency

بعضی خطاها قابل retry هستند و driver ممکن است callback را دوباره اجرا کند. متغیر محلی بیرون دیتابیس، ارسال پیام یا تغییر state خارجی را طوری ننویسید که با اجرای دوباره دو بار اثر بگذارد. transaction کوتاه، filterهای دقیق و callback قابل تکرار بسازید.

### معیار تصمیم

پیش از transaction، invariant را جملهٔ دقیق کنید. اگر «یا همه تغییرها باهم یا هیچ‌کدام» لازم است، transaction کاندید است. اگر consistency نهایی با تأخیر قابل‌قبول است، outbox/saga ممکن است مناسب‌تر باشد. transaction را برای پنهان‌کردن مدل‌سازی بد انتخاب نکنید.

## آموزش
تغییر تک‌سندی اتمیک است؛ transaction وقتی لازم می‌شود که چند سند/collection باید یک‌جا commit یا rollback شوند. در MongoDB transaction در replica set و sharded cluster پشتیبانی می‌شود. transaction کوتاه نگه دارید و عملیات بیرونی مثل تماس HTTP، ایمیل و درگاه را در callback نگذارید، چون callback می‌تواند برای خطای transient دوباره اجرا شود.

از session و API رسمی driver استفاده کنید، خطای commit را مدیریت کنید و side effect بیرونی را با outbox، idempotency یا reconciliation طراحی کنید. تراکنش هزینهٔ latency و منابع دارد؛ اول مدل داده را بررسی کنید که آیا invariant را می‌توان در یک سند حفظ کرد.

## مثال
برای نسخهٔ کوتاه‌شدهٔ نمونه، همان شرط‌های `matchedCount` را برای برداشت و واریز بررسی کنید؛ transaction به‌تنهایی شرط‌های کسب‌وکاری را حدس نمی‌زند.

## سناریوی عملی
انتقال وجه کسر و افزودن را اتمیک می‌خواهد؛ ولی API بانک بیرونی در transaction دیتابیس قرار نمی‌گیرد. از idempotency key و reconciliation برای دو سامانه استفاده کنید.

## خطاهای رایج
- transaction طولانی.
- تماس شبکه داخل callback.
- فرض rollback شدن سرویس بیرونی.
- transaction برای پنهان‌کردن مدل نامناسب.

## تمرین
1. تغییرهای دیتابیس و side effectهای بیرونی در ثبت سفارش را جدا کنید.
2. یک الگوی idempotency برای پرداخت پیشنهاد دهید.

## آزمون و پاسخ
1. **پرسش:** transaction چه تضمینی می‌دهد؟
   **پاسخ:** چند operation دیتابیس را به صورت all-or-nothing گروه می‌کند.
2. **پرسش:** چرا کوتاه باشد؟
   **پاسخ:** کاهش contention و منابع مصرفی.
3. **پرسش:** callback می‌تواند retry شود؟
   **پاسخ:** بله؛ منطقش باید تکرارپذیر/ایمن باشد.
4. **پرسش:** چرا باید از «transaction طولانی.» پرهیز کرد؟
   **پاسخ:** side effect بیرونی با rollback دیتابیس برنمی‌گردد و retry ممکن است callback را تکرار کند؛ عملیات بیرونی باید idempotent/outbox باشد.
5. **مسئلهٔ کاربردی:** تغییرهای دیتابیس و side effectهای بیرونی در ثبت سفارش را جدا کنید.
   **پاسخ نمونه:** transaction را به writeهای دیتابیس محدود کنید؛ برای تماس درگاه idempotency key نگه دارید و نتیجه را با outbox یا reconciliation هماهنگ کنید.

## آزمون تکمیلی — مفاهیم و تصمیم‌گیری

6. **پرسش:** Write تک‌سندی چه خاصیتی دارد؟
   **پاسخ:** اتمیک است.
7. **پرسش:** transaction چه زمانی کاندید است؟
   **پاسخ:** وقتی invariant چندسندی باید all-or-nothing باشد.
8. **پرسش:** چرا تماس بانک داخل transaction نیست؟
   **پاسخ:** بانک خارج از دیتابیس است و rollback دیتابیس آن را برنمی‌گرداند.
9. **پرسش:** Outbox چه کمکی می‌کند؟
   **پاسخ:** ثبت تغییر و رخداد در یک مرز دیتابیس و انتشار بعدی.
10. **پرسش:** چرا transaction کوتاه می‌ماند؟
   **پاسخ:** برای محدودکردن contention، منابع و timeout.

## منابع فارسی
- [تراکنش MongoDB به فارسی](https://www.urhoba.net/fa/post/mongodb-acid)
- [توضیح تراکنش در فارسی](https://pars.host/blog/what-is-mongodb/)

> منابع فارسی ممکن است از نسخهٔ جاری عقب باشند؛ جزئیات را با مستندات رسمی انگلیسی تطبیق دهید.

## منابع انگلیسی و رسمی
- [Transactions](https://www.mongodb.com/docs/manual/core/transactions/)
- [Transactions in Applications](https://www.mongodb.com/docs/manual/core/transactions-in-applications/)
- [Transaction Operations](https://www.mongodb.com/docs/manual/core/transactions-operations/)

---
## منابع و مقاله‌های بیشتر
[کتابخانهٔ رفرنس‌های موضوعی](../../reference-library.md#reliability-transactions) — مستندات رسمی، راهنماهای عملی، مقاله‌ها و تجربه‌های مرتبط.

بازبینی منابع: 2026-11-10
