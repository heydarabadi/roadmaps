# تمرین DSA با C#

> والد: [انتخاب زبان](../README.md) · [فصل ۱](../../README.md) · [English](../../../../../en/data-structures-and-algorithms/01-foundations/choose-language/c-sharp/README.md)

## پیش‌نیازها و نقشهٔ ذهنی

نوع‌ها، generic، class و interface. ابتدا مفهوم را به‌عنوان یک قرارداد ببین، سپس نمایش حافظه و عملیات را دنبال کن. هدف حفظ‌کردن نام نیست؛ باید بتوانی برای یک ورودی کوچک، state را بعد از هر گام بنویسی.

## ایده از پایه

C# و .NET مجموعهٔ generic، LINQ و runtime مدیریت حافظه دارند. برای DSA، تفاوت List و LinkedList، رفتار Dictionary، comparerها و هزینهٔ allocation را بفهم؛ LINQ کوتاه‌نویسی است اما ممکن است enumeration/copy پنهان کند.

## مدل، قرارداد و ناوردا

`T[]` آرایهٔ ثابت؛ `List<T>` آرایهٔ پویا؛ `LinkedList<T>` doubly linked؛ `Queue<T>`, `Stack<T>`, `PriorityQueue<TElement,TPriority>`؛ `Dictionary<TKey,TValue>` و `HashSet<T>`. `SortedDictionary` درختی با O(log n)، Dictionary hash-based است.

ناوردا (invariant) جمله‌ای است که در تمام مراحل الگوریتم باید درست بماند. نوشتن آن پیش از کدنویسی، هم به اثبات درستی کمک می‌کند و هم خطاهای مرزی را آشکار می‌سازد.

## الگوریتم یا عملیات گام‌به‌گام

BFS: `var q=new Queue<int>(); q.Enqueue(s); var u=q.Dequeue();`. Dijkstra از PriorityQueue استفاده می‌کند و اولویت کمتر را بیرون می‌دهد؛ stale priority را با dist جاری مقایسه کن. برای key سفارشی equality comparer را سازگار بساز.

در پیاده‌سازی واقعی، قرارداد ورودی/خروجی را دقیق تعریف کن: رفتار ورودی تهی، مقدار تکراری، عنصر پیدا‌نشده و ظرفیت تمام‌شده باید روشن باشد.

## اجرای حل‌شده با ردگیری

در .NET priority به‌صورت min اولویت کمینه است. اگر .NET نسخهٔ هدف API متفاوتی دارد، امضای `Enqueue(element,priority)` و `TryDequeue` را از مستندات همان نسخه بررسی کن. HashSet برای visited، List برای adjacency vector رایج است.

برای تمرین، جدولی با ستون‌های «گام»، «اندیس/اشاره‌گر»، «بخش فعال»، «تغییر state» و «دلیل» بساز. این روش به‌خصوص برای الگوریتم‌های درجا و تقسیم‌و‌غلبه جلوی پرش ذهنی را می‌گیرد.

## چرا درست است؟

`Equals` و `GetHashCode` برای keyهای Dictionary باید هماهنگ باشند. تغییر فیلدهای hashشونده پس از درج، lookup را خراب می‌کند. Enumerating collection هنگام تغییر ساختاری معمولاً invalid operation می‌دهد.

اثبات معمولاً سه بخش دارد: (۱) آغاز—ناوردا پیش از نخستین گام درست است؛ (۲) نگهداری—هر گام آن را حفظ می‌کند؛ (۳) پایان—شرط توقف همراه invariant جواب موردنیاز را نتیجه می‌دهد. اگر یکی از این سه بخش نامشخص است، هنوز درک الگوریتم کامل نشده است.

## تحلیل زمان و حافظه

List index O(1)، append amortized O(1)، درج میانه O(n). Queue enqueue/dequeue O(1) amortized؛ Dictionary/HashSet average O(1)، SortedDictionary O(log n). Allocation از value/reference type و boxing اثر دارد.

در Big-O ورودی را تعریف کن (مثلاً n تعداد عناصر)، نوع حالت را نام ببر (بهترین/میانگین/بدترین)، و فضای کمکی را از حافظهٔ خود ورودی جدا کن. مرتبهٔ رشد زمان واقعی بر حسب ثانیه نیست؛ cache، تخصیص حافظه و ثابت‌های پیاده‌سازی هم اثر دارند.

## کاربرد واقعی و انتخاب مناسب

برنامه‌های .NET، backend، ابزار و بازی. struct کوچک گاهی allocation را کم می‌کند اما copy هزینه دارد؛ در الگوریتم‌ها ابتدا semantics/درستی را بسنج و سپس profile کن.

پیش از انتخاب بپرس: چه عملیاتی پرتکرارند؟ آیا ترتیب مهم است؟ دادهٔ ورودی چه اندازه است؟ آیا محدودیت حافظه، latency بدترین‌حالت یا thread-safety داریم؟ ساختار خوب برای workload نامناسب می‌تواند انتخاب بدی باشد.

## خطاهای رایج و edge caseها

LINQ ممکن است deferred execution داشته باشد؛ چندبار enumerate کنی کار تکرار می‌شود. overflow arithmetic وابسته به checked context است. recursion و stack عمق دارد؛ `List.RemoveAt(0)` صف کارآمدی نیست.

حالت‌های مرزی را جداگانه بررسی کن: ورودی خالی، یک عضو، همهٔ اعضا برابر، هدف غایب، حداقل/حداکثر مقدار و اندازهٔ بزرگ. سرریز عدد صحیح در محاسبهٔ اندیس/ظرفیت نیز بسته به زبان مهم است.

## تمرین‌های مرحله‌ای

۱) برای BFS از Queue و HashSet استفاده کن. ۲) Dictionary و SortedDictionary را برای عملیات مرتب‌شده مقایسه کن. ۳) رفتار priority queue را در نسخهٔ target framework بررسی و Dijkstra بساز.

برای هر تمرین، اول پاسخ ساده و درست بنویس، بعد پیچیدگی را حساب کن، سپس edge case اضافه کن. تمرین را با دست‌کم یک ورودی کوچک ردگیری کن و خروجی را با انتظار مستقل مقایسه کن.

## آزمون جامع با پاسخ تشریحی

ابتدا پاسخ‌ها را نخوان؛ جواب را با استدلال بنویس، سپس توضیح را مقایسه کن.

1. **پرسش:** List<T> چیست؟
   **پاسخ تشریحی:** آرایهٔ پویا.
2. **پرسش:** صف استاندارد؟
   **پاسخ تشریحی:** Queue<T> با Enqueue/Dequeue.
3. **پرسش:** Dictionary lookup؟
   **پاسخ تشریحی:** میانگین O(1).
4. **پرسش:** چرا key mutable خطر دارد؟
   **پاسخ تشریحی:** hash/equality تغییر می‌کند و bucket قبلی دیگر قابل‌پیداکردن نیست.
5. **پرسش:** چه هزینه‌ای ممکن است LINQ پنهان کند؟
   **پاسخ تشریحی:** enumeration، allocation یا محاسبهٔ deferred تکراری.

## راهنمای بازگویی از حافظه

بدون نگاه به متن، ایده، پیش‌شرط، invariant، یک ردگیری واقعی، پیچیدگی، edge case و یک کاربرد را در چند دقیقه روی کاغذ توضیح بده. اگر فقط pseudocode را حفظی می‌نویسی اما دلیل درستی یا محدودیت‌ها را نمی‌دانی، یک بار دیگر بخش‌های invariant و خطاها را مرور کن.

## منابع

- **منبع اصلی:** [مستند رسمی C#](https://learn.microsoft.com/dotnet/csharp/)
- **فارسی:** [درس جامع ساختمان داده و الگوریتم](https://valinejad.ir/courses/data-structures-algorithms/index.html)
- **انگلیسی:** [MIT 6.006 — Algorithms](https://ocw.mit.edu/courses/6-006-introduction-to-algorithms-fall-2011/)
