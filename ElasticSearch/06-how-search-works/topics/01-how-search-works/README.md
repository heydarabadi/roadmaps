# How Search Works

[English version](README.en.md)


> فصل 06: چگونه جست‌وجو کار می‌کند · درس 01

## هدف این درس
در این مبحث، How Search Works را با سازوکار، مثال عملی، محدودیت و تمرین همان موضوع یاد می‌گیری. پاسخ‌های آزمونک پس از درس آمده‌اند.

## تدریس کامل
درخواست به node پذیرنده می‌رسد؛ coordinator آن را به shardهای هدف می‌فرستد؛ shardها محلی query را اجرا و candidateها، scoreها و aggregationهای جزئی می‌سازند؛ coordinator نتیجه‌ها را reduce و مرتب می‌کند. fan-out، صف، CPU/heap، شبکه، sort و تعداد hitها در latency اثر دارند. Get by ID با Search یکی نیست و Search پس از refresh نزدیک‌به‌زمان‌واقعی می‌شود.

~~~http
POST /products-v1/_search
{"query":{"match":{"title":"هدفون بی‌سیم"}},"size":10}
~~~
تمرین: query مشابه را با index دارای shardهای بیشتر بسنج و latency/fan-out را تفسیر کن. took زمان client-to-client نیست؛ شبکه و برنامه را جدا اندازه بگیر.

## خودآزمایی
1. shardها چه می‌کنند؟ پاسخ: هر shard بخش query را روی دادهٔ خودش اجرا و candidateها/aggregationهای محلی را می‌سازد.
2. چرا Search با write بلافاصله ممکن است فرق کند؟ پاسخ: Search پس از refresh segment تازه را می‌بیند و near-real-time است.

## منابع
- انگلیسی: [مستندات رسمی فصل](https://www.elastic.co/docs/reference/query-languages/query-dsl)
- فارسی: [جست‌وجوی موضوعی مقاله‌های فارسی](https://www.google.com/search?q=%D8%A2%D9%85%D9%88%D8%B2%D8%B4%20%D9%81%D8%A7%D8%B1%D8%B3%DB%8C%20Elasticsearch%20How%20Search%20Works)
- [مقاله‌ی مقدماتی نصب Elasticsearch](https://nadinsoft.com/راهکار-نصب-الستیک-سرچ-elasticsearch-و-4-مزیت-آن/)
- [کتابخانهٔ منابع فارسی](../../../references/README.md)
- [ParsiAnalyzer؛ تحلیل فارسی](https://github.com/NarimanN2/ParsiAnalyzer)

## معیار تسلط
مفهوم را با یک مثال از همین درس توضیح بده، یک کاربرد یا محدودیت را نام ببر و آزمونک را بدون نگاه به پاسخ حل کن.


