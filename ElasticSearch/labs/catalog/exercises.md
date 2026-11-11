# تمرین‌های آزمایشگاه کاتالوگ

[English version](exercises.en.md)


پاسخ‌ها را پس از اجرای `catalog-console.http` بررسی کن. هر تمرین یک مفهوم از نقشهٔ راه را به دادهٔ مشترک وصل می‌کند.

## تمرین‌ها

1. فقط کالاهای موجود در دستهٔ computer را جست‌وجو کن؛ قیمت تا ۶ میلیون باشد و title شامل «بی‌سیم» باشد.
2. کالایی را پیدا کن که title آن دقیقاً یک keyword کامل است؛ توضیح بده چرا روی `title.raw` از `term` استفاده می‌کنی و روی `title` از `match`.
3. محصولات را بر اساس category گروه‌بندی کن و برای هر دسته count و متوسط price را بخوان.
4. فقط محصولی را برگردان که یک offer واحد با seller برابر direct و stock حداقل ۱۰ داشته باشد. چرا nested لازم است؟
5. از دو فیلد `title` و `description` snippet بساز و قبل از نمایش در HTML خروجی را escape کن.
6. سه کالای ارزان‌تر را بگیر و صفحهٔ دوم را با `search_after` ادامه بده. sort values آخرین hit را عیناً منتقل کن.
7. قیمت `sku-001` را با Update API عوض کن؛ سپس Get by ID و Search را مقایسه کن.
8. یک mapping تازه برای `brand` بساز که lowercase normalization داشته باشد. چرا index موجود به‌سادگی analyzer قبلی را عوض نمی‌کند؟

## پاسخ تشریحی

### ۱) متن + filter
~~~http
POST /products-lab-v1/_search
{"query":{"bool":{"must":[{"match":{"title":"بی‌سیم"}}],"filter":[{"term":{"category":"computer"}},{"term":{"available":true}},{"range":{"price":{"lte":6000000}}}]}}}
~~~
must تطبیق متن را رتبه می‌دهد؛ category، available و price فقط شرط ورود به مجموعه هستند.

### ۲) exact در برابر full text
برای عبارت طبیعی از `match` روی `title` استفاده کن؛ برای رشتهٔ کامل/مرتب‌شونده از `term` روی `title.raw`. `term` ورودی را مانند match تحلیل نمی‌کند. اگر query بر اساس product_id است، فیلد keyword آن انتخاب روشن‌تری است.

### ۳) bucket و metric
~~~http
POST /products-lab-v1/_search
{"size":0,"aggs":{"categories":{"terms":{"field":"category","size":10},"aggs":{"mean_price":{"avg":{"field":"price"}}}}}}
~~~
هر bucket یک category و `doc_count` تعداد سندهای آن دسته است. `mean_price.value` میانگین قیمت‌های indexشدهٔ همان bucket است؛ missingها و آرایه‌ای‌بودن field را در دادهٔ واقعی لحاظ کن.

### ۴) nested semantics
~~~http
POST /products-lab-v1/_search
{"query":{"nested":{"path":"offers","query":{"bool":{"must":[{"term":{"offers.seller":"direct"}},{"range":{"offers.stock":{"gte":10}}}]}}}}}
~~~
nested تضمین می‌کند هر دو شرط در یک offer برقرار باشند. اگر offers به‌صورت object آرایه‌ای عادی بود، ممکن بود seller از یک عضو و stock از عضو دیگر با هم ترکیب شوند.

### ۵) Highlighting
~~~http
POST /products-lab-v1/_search
{"query":{"match":{"description":"سفر طولانی"}},"highlight":{"fields":{"description":{"fragment_size":100,"number_of_fragments":2}}}}
~~~
highlight fragment پیشنهادی است، نه متن HTML امن. هنگام render آن را escape کن و کیفیت snippet را با فارسی/نیم‌فاصله بررسی کن.

### ۶) search_after
در query اول sort را روی `price asc, product_id asc` بگذار. آخرین hit سه sort values دارد: مقدار price و product_id. درخواست بعدی باید همان query و sort را نگه دارد و آرایهٔ sort آخرین hit را در `search_after` بفرستد. برای دادهٔ متغیر، PIT اضافه کن و پس از پیمایش ببند.

### ۷) Update و visibility
~~~http
POST /products-lab-v1/_update/sku-001
{"doc":{"price":3990000}}
GET /products-lab-v1/_doc/sku-001
~~~
Get مستقیم سند را می‌خواند؛ Search ممکن است تا refresh آن تغییر را نبیند. برای مشاهدهٔ تغییری که فقط search می‌خواند، نیاز freshness و هزینهٔ refresh را با هم بسنج.

### ۸) تغییر analyzer
Analyzer در زمان index شکل termهای ساخته‌شده را تعیین می‌کند؛ تغییر تنظیم index موجود نمی‌تواند همهٔ termهای قبلی را دوباره بسازد. نسخهٔ تازه با mapping جدید بساز، reindex کن، کیفیت queryها را مقایسه و alias را پس از تأیید جابه‌جا کن.


