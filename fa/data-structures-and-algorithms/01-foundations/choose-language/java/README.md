# تمرین DSA با Java

> والد: [انتخاب زبان](../README.md) · [فصل ۱](../../README.md) · [English](../../../../../en/data-structures-and-algorithms/01-foundations/choose-language/java/README.md)

## پیش‌نیازها و نقشهٔ ذهنی

class، generic، array و interface. ابتدا مفهوم را به‌عنوان یک قرارداد ببین، سپس نمایش حافظه و عملیات را دنبال کن. هدف حفظ‌کردن نام نیست؛ باید بتوانی برای یک ورودی کوچک، state را بعد از هر گام بنویسی.

## ایده از پایه

Java مجموعه‌های generic و رفتار runtime نسبتاً قابل‌حمل می‌دهد؛ شناخت primitive و boxed types، equality/hashCode و memory overhead برای DSA لازم است.

## مدل، قرارداد و ناوردا

`ArrayList` آرایهٔ پویا؛ `LinkedList` دوطرفه و پیاده‌سازی Queue/Deque؛ `ArrayDeque` stack/queue مناسب؛ `HashMap/HashSet` میانگین نزدیک O(1)؛ `TreeMap/TreeSet` O(log n)؛ `PriorityQueue` min-heap پیش‌فرض.

ناوردا (invariant) جمله‌ای است که در تمام مراحل الگوریتم باید درست بماند. نوشتن آن پیش از کدنویسی، هم به اثبات درستی کمک می‌کند و هم خطاهای مرزی را آشکار می‌سازد.

## الگوریتم یا عملیات گام‌به‌گام

BFS: `Deque<Integer> q=new ArrayDeque<>(); q.addLast(s); int u=q.removeFirst();`. Dijkstra: `PriorityQueue<State>` با comparator فاصله؛ فاصلهٔ قدیمی را هنگام poll رد. برای primitiveهای بزرگ `long`، نه int.

در پیاده‌سازی واقعی، قرارداد ورودی/خروجی را دقیق تعریف کن: رفتار ورودی تهی، مقدار تکراری، عنصر پیدا‌نشده و ظرفیت تمام‌شده باید روشن باشد.

## اجرای حل‌شده با ردگیری

`PriorityQueue<Integer>` کمینه را اول می‌دهد. برای max-heap از `Comparator.reverseOrder()` استفاده کن. اگر State شامل distance و node است، comparator با `Long.compare(a.dist,b.dist)` بنویس؛ تفریق مستقیم ممکن است overflow کند.

برای تمرین، جدولی با ستون‌های «گام»، «اندیس/اشاره‌گر»، «بخش فعال»، «تغییر state» و «دلیل» بساز. این روش به‌خصوص برای الگوریتم‌های درجا و تقسیم‌و‌غلبه جلوی پرش ذهنی را می‌گیرد.

## چرا درست است؟

اگر کلاس به‌عنوان کلید HashMap استفاده می‌شود، `equals` و `hashCode` باید قرارداد هماهنگ داشته باشند و key هنگام حضور در map mutable نشود. `ArrayDeque` null را نمی‌پذیرد.

اثبات معمولاً سه بخش دارد: (۱) آغاز—ناوردا پیش از نخستین گام درست است؛ (۲) نگهداری—هر گام آن را حفظ می‌کند؛ (۳) پایان—شرط توقف همراه invariant جواب موردنیاز را نتیجه می‌دهد. اگر یکی از این سه بخش نامشخص است، هنوز درک الگوریتم کامل نشده است.

## تحلیل زمان و حافظه

ArrayList get O(1)، add انتهایی amortized O(1)، درج میانه O(n). HashMap average O(1)، TreeMap O(log n)، PriorityQueue offer/poll O(log n)، peek O(1). Boxing هزینهٔ allocation/محدودهٔ حافظه دارد.

در Big-O ورودی را تعریف کن (مثلاً n تعداد عناصر)، نوع حالت را نام ببر (بهترین/میانگین/بدترین)، و فضای کمکی را از حافظهٔ خود ورودی جدا کن. مرتبهٔ رشد زمان واقعی بر حسب ثانیه نیست؛ cache، تخصیص حافظه و ثابت‌های پیاده‌سازی هم اثر دارند.

## کاربرد واقعی و انتخاب مناسب

backend و سرویس سازمانی، graph algorithms، cache و collectionها. برای primitive-heavy computation ممکن است آرایه‌های primitive نسبت به `List<Integer>` memory/cpu بهتری داشته باشند.

پیش از انتخاب بپرس: چه عملیاتی پرتکرارند؟ آیا ترتیب مهم است؟ دادهٔ ورودی چه اندازه است؟ آیا محدودیت حافظه، latency بدترین‌حالت یا thread-safety داریم؟ ساختار خوب برای workload نامناسب می‌تواند انتخاب بدی باشد.

## خطاهای رایج و edge caseها

استفاده از `==` برای مقایسهٔ object به‌جای equals؛ overflow int؛ `PriorityQueue` برای arbitrary remove کارآمد نیست؛ recursion limit کمتر صریح از Python اما stack هم محدود است؛ comparator subtraction unsafe.

حالت‌های مرزی را جداگانه بررسی کن: ورودی خالی، یک عضو، همهٔ اعضا برابر، هدف غایب، حداقل/حداکثر مقدار و اندازهٔ بزرگ. سرریز عدد صحیح در محاسبهٔ اندیس/ظرفیت نیز بسته به زبان مهم است.

## تمرین‌های مرحله‌ای

۱) Map/TreeMap و HashSet/TreeSet را بر اساس order/complexity مقایسه کن. ۲) یک priority queue برای State بساز. ۳) نشان بده چرا equals/hashCode ناسازگار کلید را گم می‌کند.

برای هر تمرین، اول پاسخ ساده و درست بنویس، بعد پیچیدگی را حساب کن، سپس edge case اضافه کن. تمرین را با دست‌کم یک ورودی کوچک ردگیری کن و خروجی را با انتظار مستقل مقایسه کن.

## آزمون جامع با پاسخ تشریحی

ابتدا پاسخ‌ها را نخوان؛ جواب را با استدلال بنویس، سپس توضیح را مقایسه کن.

1. **پرسش:** صف FIFO پیشنهادی؟
   **پاسخ تشریحی:** ArrayDeque.
2. **پرسش:** PriorityQueue پیش‌فرض؟
   **پاسخ تشریحی:** min-heap.
3. **پرسش:** جست‌وجوی HashMap؟
   **پاسخ تشریحی:** میانگین O(1).
4. **پرسش:** چرا long برای فاصله؟
   **پاسخ تشریحی:** مجموع وزن‌ها ممکن است از محدودهٔ int بگذرد.
5. **پرسش:** قانون equals/hashCode؟
   **پاسخ تشریحی:** اشیای برابر باید hashCode یکسان داشته باشند.

## راهنمای بازگویی از حافظه

بدون نگاه به متن، ایده، پیش‌شرط، invariant، یک ردگیری واقعی، پیچیدگی، edge case و یک کاربرد را در چند دقیقه روی کاغذ توضیح بده. اگر فقط pseudocode را حفظی می‌نویسی اما دلیل درستی یا محدودیت‌ها را نمی‌دانی، یک بار دیگر بخش‌های invariant و خطاها را مرور کن.

## منابع

- **منبع اصلی:** [Dev.java — Learn Java](https://dev.java/learn/)
- **فارسی:** [درس جامع ساختمان داده و الگوریتم](https://valinejad.ir/courses/data-structures-algorithms/index.html)
- **انگلیسی:** [MIT 6.006 — Algorithms](https://ocw.mit.edu/courses/6-006-introduction-to-algorithms-fall-2011/)
