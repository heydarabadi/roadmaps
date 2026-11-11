# مسیر یادگیری Elasticsearch


[English version](README.en.md)
این دوره‌ی فارسی بر پایه‌ی [نقشه‌ی Elasticsearch در roadmap.sh](https://roadmap.sh/elasticsearch) تنظیم شده است. چون گراف صفحه‌ی اصلی پویاست، نام و ترتیب فصل‌ها با فهرست متنی [Elasticsearch Roadmap](https://learning.bibha.ai/roadmaps/elasticsearch) تطبیق داده شد؛ آن فهرست ۷ مرحله و ۱۱۳ درس را معرفی می‌کند. هر درس اینجا صفحه‌ی مستقل، مثال، سناریو، کوییز و منبع مطالعه دارد.

> متن لینک پیام system-design بود اما مقصد Markdown آن /elasticsearch؛ مقصد Elasticsearch مبنا شد.

## خودبسندگی دوره

درس‌های فارسی و تمرین‌های همین پوشه، متن اصلی یادگیری هستند؛ برای فهم مفاهیم پایه لازم نیست از لینک بیرونی شروع کنی. لینک‌های بیرونی برای بررسی syntax نسخهٔ جاری، مقایسه با مستند رسمی و مطالعهٔ اختیاری بیشترند. چون Elasticsearch و APIهایش نسخه‌به‌نسخه تغییر می‌کنند، پیش از اجرای مثال عملی نسخهٔ کلاستر/Kibana را با لینک رسمی همان درس تطبیق بده.

در هر فصل ابتدا درس فصل را بخوان، سپس topicها را به‌ترتیب مطالعه کن، مثال را روی index آزمایشی اجرا کن، تمرین را بدون نگاه به پاسخ انجام بده و در آخر خودآزمایی فصل را مرور کن. برای جواب هر کوییز، دلیل و trade-off را هم با زبان خودت توضیح بده.

## فصل‌ها
- [فصل 01: مبانی و شناخت](01-foundations/README.md) · [English](01-foundations/README.en.md) — 6 موضوع
- [فصل 02: Mapping و مدل‌سازی داده](02-mappings-and-data-model/README.md) · [English](02-mappings-and-data-model/README.en.md) — 12 موضوع
- [فصل 03: نوع داده و نقش نودها](03-data-types-and-node-roles/README.md) · [English](03-data-types-and-node-roles/README.en.md) — 8 موضوع
- [فصل 04: عملیات سند و زبان‌های Query](04-indexing-and-query-languages/README.md) · [English](04-indexing-and-query-languages/README.en.md) — 25 موضوع
- [فصل 05: کنترل نتایج و نگهداری داده](05-search-results-and-maintenance/README.md) · [English](05-search-results-and-maintenance/README.en.md) — 15 موضوع
- [فصل 06: چگونه جست‌وجو کار می‌کند](06-how-search-works/README.md) · [English](06-how-search-works/README.en.md) — 5 موضوع
- [فصل 07: تحلیل، تجمیع و عملیات تولید](07-analysis-analytics-and-production/README.md) · [English](07-analysis-analytics-and-production/README.en.md) — 42 موضوع

## مسیر پیشنهادی
1. مبانی، JSON و REST.
2. Mapping، نوع داده، index و node.
3. عملیات سند و Query DSL؛ سپس نتایج و pagination.
4. اجرای search و Bool Query.
5. تحلیل متن، aggregation، ranking، vector، عملیات، backup و امنیت.
6. [پروژه‌ی کاتالوگ](projects/ecommerce-catalog/README.md) · [English](projects/ecommerce-catalog/README.en.md) را انجام بده و [مطالعات موردی](case-studies/README.md) · [English](case-studies/README.en.md) را بخوان.

برای اجرای یک دادهٔ ثابت و دیدن queryهای واقعی از [آزمایشگاه عملی کاتالوگ](labs/catalog/README.md) · [English](labs/catalog/README.en.md) شروع کن؛ بعد تمرین پایانی را انجام بده.

## منابع فارسی منتخب
- [مقاله‌ی مقدماتی و نصب Elasticsearch](https://nadinsoft.com/راهکار-نصب-الستیک-سرچ-elasticsearch-و-4-مزیت-آن/) — قدیمی‌تر؛ دستورها را با نسخه‌ی جاری تطبیق بده.
- [مقالهٔ جست‌وجوی پیشرفته در Codity](https://codity.ir/advanced-search-training-with-elasticsearch/) و [راهنمای تحلیل متن فارسی](https://virgool.io/@technotesai/%DA%86%D8%B1%D8%A7-%D8%AC%D8%B3%D8%AA%D8%AC%D9%88%DB%8C-%D9%81%D8%A7%D8%B1%D8%B3%DB%8C-%D8%AF%D8%B1-elasticsearch-%D8%AF%D8%B1%D8%B3%D8%AA-%DA%A9%D8%A7%D8%B1-%D9%86%D9%85%DB%8C-%DA%A9%D9%86%D8%AF-%D9%88-%DA%86%D8%B7%D9%88%D8%B1-%D8%AF%D8%B1%D8%B3%D8%AA%D8%B4-%DA%A9%D9%86%DB%8C%D9%85-dfsaaev7zebh) — منابع مکمل‌اند؛ پیکربندی مقالهٔ analyzer را روی متن و queryهای خودت ارزیابی کن.
- [ParsiAnalyzer](https://github.com/NarimanN2/ParsiAnalyzer) — normalization و tokenization فارسی؛ سازگاری نسخه را بررسی کن.
- [دوره‌ی تاپ‌لرن](https://toplearn.com/c/6112) و [دوره‌ی EngineDevOps](https://enginedevops.com/product/آموزش-جامع-elasticsearch) — منابع ویدیویی فارسی.
- هر درس پیوند جست‌وجوی فارسی موضوعی دارد؛ تاریخ و نسخه‌ی مقاله را بررسی کن.

[کتابخانهٔ منابع و مقاله‌های فارسی/انگلیسی](references/README.md) · [English](references/README.en.md) شامل مستند رسمیِ فصل‌بندی‌شده، مقاله‌های منتخب، منابع فارسی و تجربه‌های واقعی است. بعضی پیوندهای جست‌وجو در درس‌ها فقط برای کشف مقاله‌های تازه‌اند، نه استناد تأییدشده.

## منابع انگلیسی
- [راهنمای رسمی Elasticsearch](https://www.elastic.co/docs/products/elasticsearch) · [Reference](https://www.elastic.co/guide/en/elasticsearch/reference/current/)
- [Index fundamentals](https://www.elastic.co/docs/manage-data/data-store/index-basics)
- [معماری خواندن و نوشتن](https://www.elastic.co/docs/deploy-manage/distributed-architecture/reading-and-writing-documents)
- [Search API](https://www.elastic.co/docs/reference/elasticsearch/rest-apis/search)
- [Snapshot and restore](https://www.elastic.co/docs/deploy-manage/tools/snapshot-and-restore) · [Elastic Training](https://www.elastic.co/training)

## نسخه و ایمنی
نسخه‌ی Elasticsearch، Kibana، client و مستندات را هم‌تراز کن؛ APIها تغییر می‌کنند. مقصد را پیش از فرمان حذف/تغییر بررسی کن. خاموش‌کردن security و single-node فقط برای sandbox محلی جداشده مناسب است.




