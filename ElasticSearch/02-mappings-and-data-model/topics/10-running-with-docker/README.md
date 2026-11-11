# Running with Docker

[English version](README.en.md)


> فصل 02: Mapping و مدل‌سازی داده · درس 10

## هدف این درس
اجرای Docker محیط local را بالا می‌آورد؛ volume، حافظه، security و نسخهٔ image را برای تمرین کنترل کن.
## اجرای محلی با Docker

### اجرای محلی با Docker
Docker برای یادگیری، بازتولید محیط و اجرای نسخه‌ی pin شده مفید است. نسخه‌ی Elasticsearch و Kibana را هم‌تراز انتخاب کن؛ برای persistence volume داشته باش و memory limit را متناسب تنظیم کن. در نسخه‌های جدید راه‌اندازی ممکن است security را خودکار فعال کند، پس راهنمای همان نسخه را دنبال کن.
کلاستر تک‌نودی با security خاموش فقط برای sandbox محلی و داده‌ی آزمایشی است. پورت را روی شبکه‌ی عمومی باز نکن. برای مثال REST این دوره، از Kibana Console یا REST client به localhost وصل شو. برای داده‌ی مهم، volume تنها backup نیست؛ snapshot خارج از node را هم در طراحی production بسنج.
~~~text
docker run --name es-lab -p 127.0.0.1:9200:9200 -e discovery.type=single-node docker.elastic.co/elasticsearch/elasticsearch:<نسخه>
~~~
جای <نسخه> نسخه‌ی سازگار و pin شده را بنویس؛ tag شناور را برای محیط تکرارپذیر به‌کار نبر. خطای رایج آن است که setting آموزشی را در production کپی کنند.


## خودآزمایی
1. چرا باید volume را mount کرد؟ پاسخ: برای حفظ داده پس از حذف/recreate container.
2. نسخهٔ Kibana و Elasticsearch چه رابطه‌ای دارند؟ پاسخ: باید نسخه‌های سازگار و ترجیحاً هم‌تراز باشند.
## منابع
- انگلیسی: [مستندات رسمی فصل](https://www.elastic.co/docs/manage-data/data-store/mapping)
- فارسی: [جست‌وجوی موضوعی مقاله‌های فارسی](https://www.google.com/search?q=%D8%A2%D9%85%D9%88%D8%B2%D8%B4%20%D9%81%D8%A7%D8%B1%D8%B3%DB%8C%20Elasticsearch%20Running%20with%20Docker)
- [مقاله‌ی مقدماتی نصب Elasticsearch](https://nadinsoft.com/راهکار-نصب-الستیک-سرچ-elasticsearch-و-4-مزیت-آن/)
- [کتابخانهٔ منابع فارسی](../../../references/README.md)
- [ParsiAnalyzer؛ تحلیل فارسی](https://github.com/NarimanN2/ParsiAnalyzer)



