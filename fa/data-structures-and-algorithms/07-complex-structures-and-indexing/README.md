# فصل ۷ — ساختارهای پیچیده و نمایه‌سازی

> نسخهٔ انگلیسی: [English version](../../../en/data-structures-and-algorithms/07-complex-structures-and-indexing/README.md)

تفاوت ساختارهای متوازن در حافظه و روی دیسک، و نقش ایندکس در دسترسی را مقایسه کن.

## ترتیب پیشنهادی

1. پیش‌نیازها و تعریف‌ها را بخوان.
2. مثال هر تاپیک را دستی اجرا کن.
3. تمرین‌ها را انجام بده و بعد پاسخ آزمون را ببین.
4. هنگام پیاده‌سازی، complexity را با operation واقعی کتابخانهٔ زبانت تطبیق بده.

## از حافظه تا دیسک

درخت متوازن در RAM تعداد مقایسه را کم می‌کند؛ index دیسکی تعداد page read/random I/O را هدف می‌گیرد. fanout B-tree و B+ tree زیاد است، زیرا یک page چندین separator را جا می‌دهد. ISAM index ثابت‌تری است و overflow chain دارد؛ workload پر‌درج می‌تواند آن را کند کند. Skip list گزینهٔ ordered در حافظه با عملکرد موردانتظار لگاریتمی است.

## تاپیک‌های فصل

- [درخت ۲–۳](two-three-tree/README.md)
- [درخت B در نمایه‌سازی](b-tree-complex/README.md)
- [درخت B+](b-plus-tree/README.md)
- [لیست پرشی](skip-list/README.md)
- [ISAM](isam/README.md)
- [نمایه‌سازی خطی](linear-indexing/README.md)
- [نمایه‌سازی درختی](tree-indexing/README.md)

## منبع فارسی فصل

[منبع فارسی پیشنهادی](https://safarnejad.github.io/)

## منبع انگلیسی فصل

[منبع انگلیسی پیشنهادی](https://www.postgresql.org/docs/current/btree.html)


---

## آموزش گره‌های والد در نقشهٔ رسمی

این بخش عنوان‌های گروهی نقشه را نیز پوشش می‌دهد؛ برای درس مستقل هر برگ، README تاپیک را باز کن.

## تاپیک والد نقشه: Complex Data Structures

### آموزش

ساختارهای پیچیده مانند 2–3 Tree، B/B+ Tree، Skip List و ISAM میان سادگی، توازن، ترتیب، disk I/O و به‌روزرسانی مبادله می‌کنند.

**روش انتخاب/اجرا:** اندازهٔ داده، read/write ratio، range scan، page size و نیاز concurrency را تعیین کن؛ بعد تضمین worst-case/expected و نگهداری ساختار را مقایسه کن.

**پیچیدگی و مبادله:** درخت‌های چندراهه سطوح page access را کم می‌کنند؛ Skip List expected logarithmic است؛ ISAM ایستا با درج‌های سنگین overflow می‌سازد.

**تجربهٔ عملی:** PostgreSQL مستندات B-tree خود را به‌عنوان ساختار چندراههٔ مرتب‌شونده برای ایندکس‌سازی توضیح می‌دهد.

**دام رایج:** نام مشابه تضمین یکسان ندارد؛ worst-case و رفتار تحت workload واقعی را از مستندات implementation بخوان.

### آزمون کوتاه با پاسخ

1. **پرسش:** چرا B-tree از BST صفحه‌محورتر است؟
   **پاسخ:** fan-out بالاتر، ارتفاع کمتر و کاهش page I/O.
2. **پرسش:** Skip List چه تضمینی دارد؟
   **پاسخ:** هزینهٔ لگاریتمی مورد انتظار، نه الزاماً worst-case.
3. **پرسش:** چرا ایندکس برای همهٔ ستون‌ها نمی‌سازیم؟
   **پاسخ:** فضا و هزینهٔ write/maintenance اضافه می‌کند.

## تاپیک والد نقشه: Indexing

### آموزش

ایندکس ساختار کمکی برای یافتن رکوردها بدون اسکن کامل است. ایندکس خطی ساده است؛ ایندکس درختی lookup و range را با نگهداری و هزینهٔ نوشتن عوض می‌کند.

**روش انتخاب/اجرا:** query pattern و selectivity را بخوان؛ کلید/ترتیب ستون‌ها را انتخاب کن؛ EXPLAIN/query plan را بسنج؛ هزینهٔ insert/update را هم مانیتور کن.

**پیچیدگی و مبادله:** اسکن خطی O(n)؛ index متوازن معمولاً O(log n) lookup و page I/O؛ range result k هم خروجی‌خوانی می‌خواهد.

**تجربهٔ عملی:** PostgreSQL B-tree مستندشده نمونهٔ تولیدی index مرتب است؛ Bloom index با false positive امکان رد سریع رکوردهای ناموجود را می‌دهد.

**دام رایج:** ایندکس می‌تواند query خاص را سریع کند ولی storage و write amplification افزایش دهد؛ plan واقعی مهم است.

### آزمون کوتاه با پاسخ

1. **پرسش:** چه تفاوتی بین data و index هست؟
   **پاسخ:** index ساختار کمکی‌ای است که به رکوردها اشاره می‌کند.
2. **پرسش:** Bloom filter index چه نوع خطایی ممکن دارد؟
   **پاسخ:** مثبت کاذب؛ منفی کاذب در قرارداد معمول ندارد.
3. **پرسش:** چه چیزی را بعد از ساخت index بررسی می‌کنی؟
   **پاسخ:** plan و هزینهٔ خواندن، نوشتن، فضا و maintenance.


- [RocksDB MemTable design notes](https://github.com/meta/rocksdb/wiki/MemTable) — مرجع implementation برای مطالعهٔ بافرهای مرتب در LSM.


## آزمون جمع‌بندی فصل

۱. چرا همهٔ برگ‌های B-tree هم‌عمق‌اند؟ تضمین height و lookup. ۲. B+ leaf link برای چیست؟ range scan. ۳. ISAM در درج روی صفحهٔ پر چه می‌کند؟ overflow page. ۴. dense/sparse index چه فرق دارد؟ هر رکورد در برابر هر block/گروه. ۵. skip list complexity چه نوع تضمینی دارد؟ expected تحت تصادفی‌سازی، worst-case خطی. ۶. آیا index scan همیشه ارزان‌تر از table scan است؟ خیر؛ selectivity و I/O تعیین‌کننده‌اند.

## معیار عبور

یک بازه‌پرس‌وجوی پایگاه‌داده را با درخت داخلی، برگ و page I/O رسم کن و فرق latency lookup، scan و maintenance در insert/delete را بگو.

