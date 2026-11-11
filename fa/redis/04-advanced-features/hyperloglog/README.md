<div dir="rtl" align="right">

# HyperLogLog: شمارش تقریبی اعضای یکتا

> English edition: [HyperLogLog: Approximate Distinct Counting](../../../../en/redis/04-advanced-features/hyperloglog/README.md)

> مسیر: فصل ۴ · سطح: مقدماتی تا میانی · زمان: ۴۵ تا ۷۰ دقیقه
>
> این ساختار برای آمار تقریبی است؛ برای پول، صورتحساب، مجوز یا شمارش موردنیاز قانونی استفاده نکن.

## هدف یادگیری

- cardinality را تعریف کنی و تفاوت شمارش دقیق و تخمینی را بفهمی.
- `PFADD`, `PFCOUNT`, `PFMERGE` را اجرا کنی.
- بدانی HLL فهرست memberها را نگه نمی‌دارد و یک عضو خاص را حذف نمی‌کند.
- بودجهٔ خطا، bucket روزانه، timezone و retention را در تصمیم ثبت کنی.

## ایدهٔ مرکزی

وقتی فقط می‌خواهی «حدوداً چند کاربر/مقدار یکتا دیده شده‌اند؟» را بدانی، ذخیرهٔ تمام شناسه‌ها در Set می‌تواند پرهزینه باشد. HyperLogLog یک خلاصهٔ probabilistic از داده می‌سازد و تعداد distinct را با خطای کوچک تخمین می‌زند. چون خلاصه است، نمی‌توانی از آن memberها را enumerate یا یک member را دقیق حذف کنی.

```text
ورودی: user-1, user-2, user-1, user-3
Set دقیق: 3 عضو واقعی را نگه می‌دارد
HLL: خلاصهٔ فشرده نگه می‌دارد و cardinality را تقریب می‌زند
```

## فرمان‌ها و خروجی

```text
DEL lab:visitors:today
PFADD lab:visitors:today user:1 user:2 user:1
(integer) 1
PFADD lab:visitors:today user:2 user:3
(integer) 1
PFCOUNT lab:visitors:today
(integer) 3
```

مقدار بازگشتی `PFADD` «چند عضو جدید اضافه شد» نیست؛ یک نشانگر است که آیا وضعیت داخلی HLL در نتیجهٔ این فرمان تغییر کرد. پس از تکرار داده، ممکن است `0` برگردد؛ به این معنی نیست که کاربر قطعاً قبلاً در فهرستی ذخیره شده، چون اصلاً فهرست member در دسترس نیست.

`PFCOUNT` تعداد یکتای تخمینی را برمی‌گرداند. Redis برای HLL خطای استاندارد حدود ۰٫۸۱٪ را مستند می‌کند؛ این عدد تضمین «هر پاسخ حداکثر این درصد خطا دارد» نیست و پاسخ یک تخمین آماری است. در سیستم تصمیم‌گیری باید تحمل خطای واقعی workload و ریسک تصمیم را ارزیابی کنی.

## شمارش چند bucket و ادغام

برای هر روز key جدا بساز تا هم retention و هم تحلیل روزانه روشن باشد. timezone و مرز روز را در کل محصول یکسان تعریف کن:

```text
PFADD lab:visitors:2026-11-09 user:1 user:2
PFADD lab:visitors:2026-11-10 user:2 user:3
PFCOUNT lab:visitors:2026-11-09
PFCOUNT lab:visitors:2026-11-10
PFCOUNT lab:visitors:2026-11-09 lab:visitors:2026-11-10
```

شمارش چند HLL با `PFCOUNT key1 key2 ...` union تقریبی آن‌ها را می‌دهد، بدون نوشتن کلید جدید. `PFMERGE destination source...` union را در کلید مقصد ذخیره می‌کند:

```text
PFMERGE lab:visitors:week lab:visitors:2026-11-09 lab:visitors:2026-11-10
PFCOUNT lab:visitors:week
```

اگر کاربر در دو روز حاضر بوده، union روزها او را یک بار در شمارش بازه می‌گیرد؛ جمع‌کردن عدد روزانه به‌جای ادغام HLL چنین کاری نمی‌کند و دو بار می‌شمارد.

## انتخاب HLL یا ساختار دقیق

| نیاز | انتخاب مناسب‌تر |
| --- | --- |
| تخمین بازدید یکتا برای dashboard و خطای کوچک پذیرفتنی | HyperLogLog |
| فهرست افراد برای ارسال پاداش یا پیگیری | Set/دیتابیس دقیق |
| حذف یک کاربر یا اصلاح دادهٔ خاص | Set یا ذخیرهٔ دقیق در منبع اصلی |
| شمارش مالی یا سهمیه‌ای که روی آن تصمیم حقوقی/مالی است | شمارش دقیق پایدار |
| intersection دقیق اعضای دو گروه | دادهٔ exact (HLL فهرست عضو ندارد) |

HLL در حالت متراکم حدود ۱۲ کیلوبایت برای هر sketch مصرف می‌کند و در dataset کم‌حجم ممکن است encoding کم‌حافظه‌تری داشته باشد. این را با key overhead، replication و تعداد bucketها بسنج؛ «فشرده» به معنای هزینهٔ صفر نیست.

## طراحی متریک بازدیدکنندهٔ یکتا

1. تعریف کن «کاربر» چیست: شناسهٔ حساب، cookie، IP یا ترکیبی؟
2. یک canonical identifier بساز؛ تفاوت حروف، whitespace، anonymous/login و حذف حساب را مشخص کن.
3. بازهٔ زمانی و timezone را تعیین کن؛ نام key را نسخه‌دار کن.
4. `PFADD` را در مسیر ثبت event بزن؛ privacy و retention را رعایت کن.
5. `PFCOUNT` را در dashboard cache کن اگر محاسبه در لحظه پرتکرار است.
6. یک معیار دقیق کوچک یا نمونهٔ مقایسه‌ای نگه دار تا خطای مشاهده‌شده را بسنجی.

اگر identifier را برای privacy hash می‌کنی، hash کردن خودش حذف داده از امکان ردیابی نیست؛ سیاست حفاظت داده، access و retention را تعیین کن. PF merge فقط sketchهای سازگار را ترکیب می‌کند؛ bucketهای مربوط به tenant/version را اشتباه مخلوط نکن.

## تمرین و بررسی

1. در دو key روزانه userهای تکراری ثبت کن و `PFCOUNT key1 key2` را با جمع دو count مقایسه کن.
2. نتیجهٔ `PFADD` برای دادهٔ تکراری را مشاهده کن؛ آن را به شمارش newly-seen تبدیل نکن.
3. یک سناریو بساز که خطای ۱٪ پذیرفتنی است، و یک سناریو که ۱٪ خطا خطرناک است.
4. تعیین کن با پاک‌شدن یا expire شدن bucketهای روزانه آیا گزارش ۳۰ روزه هنوز ممکن است.

**راهنمای پاسخ:** countهای روزانه می‌توانند یک کاربر مشترک را چند بار بشمارند؛ union HLL تخمین distinct کل بازه را می‌دهد. نمایش analytics نمونهٔ مناسب است؛ تسویهٔ مالی یا eligibility برای جایزهٔ قطعی نیست. retention تعیین می‌کند گزارش تاریخی را بتوان ساخت یا نه.

## دام‌ها

- **استفاده از PFADD reply به‌عنوان `new_unique_user`:** پاسخ آن تعداد distinct جدید نیست.
- **جمع counts روزانه برای unique ماهانه:** کاربران مشترک دوباره‌شماری می‌شوند؛ sketchها را union کن.
- **انتظار فهرست عضوها:** HLL فقط cardinality تخمینی را هدف گرفته است.
- **پاک‌کردن یک member:** حذف جزئی در HLL پشتیبانی نمی‌شود؛ sketch را از دادهٔ دقیق بازسازی کن یا بازه را نگه ندار.
- **استفاده در پول/سهمیه:** خطای آماری ممکن است نتیجهٔ کسب‌وکار را غلط کند.
- **نادیده‌گرفتن تعریف هویت:** `user:7` و `7` یا کاربر anonymous/logged-in ممکن است ناخواسته دو عضو شوند.

## کوییز

### ۱. HLL چه چیزی را ذخیره/برمی‌گرداند؟

<details><summary>پاسخ</summary>

خلاصه‌ای probabilistic برای تخمین cardinality؛ فهرست قابل بازیابی memberها نیست.

</details>

### ۲. `PFADD` عدد یکتای جدید را می‌دهد؟

<details><summary>پاسخ</summary>

خیر؛ فقط می‌گوید وضعیت داخلی sketch با اضافه‌کردن ورودی تغییر کرده یا نه.

</details>

### ۳. union چند روز را چطور بگیری؟

<details><summary>پاسخ</summary>

`PFCOUNT` چند key یا `PFMERGE` به یک destination.

</details>

### ۴. آیا می‌توان یک شناسه را از HLL حذف کرد؟

<details><summary>پاسخ</summary>

حذف یک عضو مشخص پشتیبانی نمی‌شود.

</details>

### ۵. چرا جمع تعداد یکتای هر روز برای unique ماه غلط است؟

<details><summary>پاسخ</summary>

کاربری که چند روز آمده در چند count روزانه حضور دارد؛ باید union sketchها تخمین زده شود.

</details>

### ۶. آیا خطای استاندارد ۰٫۸۱٪ تضمین حداکثر خطای هر نتیجه است؟

<details><summary>پاسخ</summary>

خیر؛ مشخصهٔ آماری است، نه سقف قطعی برای تک‌تک پاسخ‌ها.

</details>

## منابع

### انگلیسی و رسمی

- [مستند HyperLogLog در Redis](https://redis.io/docs/latest/develop/data-types/probabilistic/hyperloglogs/)
- [PFADD](https://redis.io/docs/latest/commands/pfadd/)
- [PFCOUNT](https://redis.io/docs/latest/commands/pfcount/)
- [PFMERGE](https://redis.io/docs/latest/commands/pfmerge/)

### فارسی

- [آموزش فارسی Redis در زبان سلام](https://www.salamlang.ir/std/db/redis/)
- [مرور فارسی ساختارهای Redis در DNTips](https://www.dntips.ir/exports/posts/www.dntips.ir-posts-3088.pdf)
- [جست‌وجوی تکمیلی فارسی دربارهٔ HyperLogLog](https://www.google.com/search?q=HyperLogLog+Redis+آموزش+فارسی)

پوشش عمیق فارسی برای HyperLogLog محدود است؛ درس فوق مفهوم، تصمیم و فرمان‌ها را مستقل توضیح می‌دهد. خطای آماری و encoding را با مستند رسمی نسخهٔ خودت کنترل کن.

</div>
