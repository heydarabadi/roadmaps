# Hybrid Search

[English version](README.en.md)


> فصل 07: تحلیل، تجمیع و عملیات تولید · درس 37

## هدف این درس
در این مبحث، Hybrid Search را با سازوکار، مثال عملی، محدودیت و تمرین همان موضوع یاد می‌گیری. پاسخ‌های آزمونک پس از درس آمده‌اند.

## تدریس کامل
Hybrid search در یک تجربه نتایج دقیق واژه‌ای و نتایج معنایی را ادغام می‌کند. lexical برای کد/نام دقیق خوب است؛ vector برای هم‌معنی و intent. scoreها در مقیاس‌های متفاوت‌اند؛ RRF بر اساس رتبه‌های هر لیست ادغام می‌کند و نیاز به calibration مستقیم score را کم می‌کند.

~~~text
Lexical top-10 + Vector top-10 → rank fusion → فهرست نهایی
~~~

نمونهٔ Query DSL با retriever در نسخه‌های پشتیبان RRF:

~~~http
POST /products-v1/_search
{"retriever":{"rrf":{"retrievers":[{"standard":{"query":{"match":{"title":"کفش پیاده‌روی"}}}},{"knn":{"field":"embedding","query_vector":[0.1,0.2,0.3],"k":20,"num_candidates":100}}],"rank_window_size":50,"rank_constant":20}},"size":10}
~~~
این بردار صرفاً شماتیک است؛ باید از embedding model واقعی و mapping هم‌ابعاد بیاید. syntax و پشتیبانی retriever را برای نسخهٔ نصب‌شده بررسی کن.
تمرین: سه run lexical، vector و hybrid را روی query set یکسان مقایسه و NDCG/Recall@k را گزارش کن. اگر filter دسترسی داری باید در هر مسیر یکسان enforce شود. هزینه، latency و empty-result fallback را هم در نظر بگیر.

## خودآزمایی
1. hybrid چه دو مسیری را ترکیب می‌کند؟ پاسخ: lexical/full-text و vector/semantic retrieval.
2. چرا scoreها را کورکورانه جمع نمی‌زنیم؟ پاسخ: scale آن‌ها متفاوت است؛ rank fusion مثل RRF می‌تواند ترکیب متوازن‌تری بدهد.

## منابع
- انگلیسی: [مرجع رسمی Elasticsearch](https://www.elastic.co/docs/solutions/search/hybrid-search)
- فارسی: [جست‌وجوی موضوعی مقاله‌های فارسی](https://www.google.com/search?q=%D8%A2%D9%85%D9%88%D8%B2%D8%B4%20%D9%81%D8%A7%D8%B1%D8%B3%DB%8C%20Elasticsearch%20Hybrid%20Search)
- [مقاله‌ی مقدماتی نصب Elasticsearch](https://nadinsoft.com/راهکار-نصب-الستیک-سرچ-elasticsearch-و-4-مزیت-آن/)
- [کتابخانهٔ منابع فارسی](../../../references/README.md)
- [ParsiAnalyzer؛ تحلیل فارسی](https://github.com/NarimanN2/ParsiAnalyzer)

## معیار تسلط
مفهوم را با یک مثال از همین درس توضیح بده، یک کاربرد یا محدودیت را نام ببر و آزمونک را بدون نگاه به پاسخ حل کن.


