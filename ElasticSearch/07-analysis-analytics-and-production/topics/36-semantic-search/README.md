# Semantic Search

[English version](README.en.md)


> فصل 07: تحلیل، تجمیع و عملیات تولید · درس 36

## هدف این درس
در این مبحث، Semantic Search را با سازوکار، مثال عملی، محدودیت و تمرین همان موضوع یاد می‌گیری. پاسخ‌های آزمونک پس از درس آمده‌اند.

## تدریس کامل
Semantic search متن query و سند را به بازنمایی‌هایی می‌برد که معنا/شباهت را مدل می‌کنند؛ عبارت «وسیله برای روز بارانی» ممکن است به «چتر» نزدیک شود بی‌آنکه واژه مشترک باشد. این کار به model/inference pipeline، هزینه و نسخه‌گذاری وابسته است. برای فارسی، کیفیت را با query و سند فارسی واقعی اندازه بگیر.

~~~text
پرسش: «وسیله برای روز بارانی» → بازیابی معناییِ کالاهایی با مفهوم چتر/بارانی
~~~
تمرین: برای 20 query مورد انتظار و غیرمرتبط، top-k را دستی قضاوت و precision/Recall ثبت کن. Semantic را بدون baseline lexical وارد production نکن؛ مدل version و latency inference را مانیتور کن.

## خودآزمایی
1. semantic search چه تفاوتی دارد؟ پاسخ: intent/معنای متن را از طریق مدل یادگرفته‌شده می‌سنجد، نه فقط واژه‌های دقیق.
2. چرا ممکن است جواب نامربوط بدهد؟ پاسخ: embedding، زبان، domain و query-context ممکن است با داده سازگار نباشد؛ قضاوت انسانی لازم است.

## منابع
- انگلیسی: [مرجع رسمی Elasticsearch](https://www.elastic.co/docs/solutions/search/get-started/semantic-search)
- فارسی: [جست‌وجوی موضوعی مقاله‌های فارسی](https://www.google.com/search?q=%D8%A2%D9%85%D9%88%D8%B2%D8%B4%20%D9%81%D8%A7%D8%B1%D8%B3%DB%8C%20Elasticsearch%20Semantic%20Search)
- [مقاله‌ی مقدماتی نصب Elasticsearch](https://nadinsoft.com/راهکار-نصب-الستیک-سرچ-elasticsearch-و-4-مزیت-آن/)
- [کتابخانهٔ منابع فارسی](../../../references/README.md)
- [ParsiAnalyzer؛ تحلیل فارسی](https://github.com/NarimanN2/ParsiAnalyzer)

## معیار تسلط
مفهوم را با یک مثال از همین درس توضیح بده، یک کاربرد یا محدودیت را نام ببر و آزمونک را بدون نگاه به پاسخ حل کن.


