# JSON

[English version](../../../../../en/elasticsearch/01-foundations/topics/02-json/README.md)


> فصل 01: مبانی و شناخت · درس 02

## هدف این درس
ساختار JSON، object، array، scalar و شکل request/response را بخوان؛ در mapping هر کدام به دادهٔ مناسب تبدیل می‌شوند.
## تدریس کامل: ساختار JSON و قرارداد داده

JSON قالب نمایش داده است؛ schema و معنای تجاری را خودش تعیین نمی‌کند. Object مجموعه‌ی fieldهاست، array فهرستی از مقدارها، و مقدارها می‌توانند string، number، boolean، null، object یا array باشند. Elasticsearch سندها و بیشتر API bodyها را با JSON می‌گیرد، سپس mapping نوع هر field و نحوه‌ی ایندکس آن را کنترل می‌کند.

~~~json
{
  "sku": "A-100",
  "title": "کیبورد مکانیکی",
  "price": 4200000,
  "available": true,
  "tags": ["مکانیکی", "USB"],
  "seller": {"name": "فروشگاه نمونه", "city": "تهران"}
}
~~~

در نمونه، SKU و title رشته، price عدد، available مقدار منطقی، tags آرایه و seller شیء تو‌در‌تو است. برای query بازه‌ای روی price باید مقدار در همه‌ی سندها عدد باشد؛ مقدار رشته‌ای با مقدار عددی یکی نیست.

### آرایه‌ها و شیءهای تو‌در‌تو

آرایه‌ی مقدارهای ساده، مثل چند tag، معمولاً مستقیم قابل استفاده است. آرایه‌ی objectها ظریف‌تر است. اگر سند چند variant کالا داشته باشد، query ممکن است شرط رنگ را از variant اول و شرط سایز را از variant دوم بگیرد. اگر شرط‌ها باید روی یک عضو واحد برقرار باشند، mapping نوع nested لازم می‌شود. این انتخاب هزینه‌ی فضای ذخیره و پیچیدگی query دارد.

### نبودن، null و مقدار خالی

Field حذف‌شده، field دارای null و رشته‌ی خالی معنای یکسان ندارند. این تفاوت روی exists query و منطق برنامه اثر می‌گذارد. برای مثال، نبودن price می‌تواند یعنی قیمت هنوز نرسیده، null یعنی مقدار نامعلوم و صفر یک قیمت واقعی یا خطای داده. قرارداد ورودی باید معنای هر حالت را مشخص کند.

### تمرین

یک سند سفارش با order_id، customer_id، created_at، status، total و items بساز. برای هر field مشخص کن آیا exact search، full-text search، range، sort یا aggregation لازم است. همین نیازها بعداً type mapping را تعیین می‌کنند.

### آزمون تشریحی با پاسخ

1. **چرا JSON به‌تنهایی schema نیست؟** JSON شکل سند را نمایش می‌دهد؛ mapping نوع و قابلیت‌های search هر field را مشخص می‌کند.
2. **چرا price نباید گاهی رشته و گاهی عدد باشد؟** چون mapping و عملیات عددی به نوع پایدار نیاز دارند و range یا sum روی رشته رفتار عددی ندارد.
3. **چه وقت nested لازم می‌شود؟** وقتی چند شرط باید روی همان object از یک آرایه برقرار باشند.


## خودآزمایی
1. چرا price را در JSON به‌شکل عدد می‌فرستیم؟ پاسخ: تا به‌صورت numeric map و range/aggregation اجرا شود؛ رشته رفتار متنی دارد.
2. آیا آرایه باید همهٔ itemها هم‌نوع باشند؟ پاسخ: برای mapping سازگار بله؛ نوع ناهماهنگ parse error یا معنای بد می‌سازد.
## منابع
- انگلیسی: [مستندات رسمی فصل](https://www.elastic.co/docs/solutions/search/get-started)
- فارسی: [جست‌وجوی موضوعی مقاله‌های فارسی](https://www.google.com/search?q=%D8%A2%D9%85%D9%88%D8%B2%D8%B4%20%D9%81%D8%A7%D8%B1%D8%B3%DB%8C%20Elasticsearch%20JSON)
- [مقاله‌ی مقدماتی نصب Elasticsearch](https://nadinsoft.com/راهکار-نصب-الستیک-سرچ-elasticsearch-و-4-مزیت-آن/)
- [کتابخانهٔ منابع فارسی](../../../references/README.md)
- [ParsiAnalyzer؛ تحلیل فارسی](https://github.com/NarimanN2/ParsiAnalyzer)



