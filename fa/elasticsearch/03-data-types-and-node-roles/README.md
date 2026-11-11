# فصل 03: نوع داده و نقش نودها / Data Types

[English version](../../../en/elasticsearch/03-data-types-and-node-roles/README.md)


## درس فصل
نوع field تعیین می‌کند چه query، sort و aggregation ممکن است. قیمت را عددی، زمان را date، پرچم را boolean و مکان را geo_point تعریف کنید. متن تحلیل‌شده text و مقدار دقیق keyword است. master-eligible node برای انتخاب master و مدیریت cluster state است؛ data node shardها و indexing/search را اداره می‌کند؛ coordinating node درخواست را پخش و پاسخ را جمع می‌کند. جداسازی roleها تابع اندازه و بار واقعی است.

## تمرین فصل
سند فروشگاه با قیمت، وضعیت، زمان و مختصات تعریف کن و query مناسب هر نوع را مشخص کن.

## تدریس کامل فصل: نوع فیلد، مسئولیت node و اثر روی سرویس

### Typeها را از query نیازمندش انتخاب کن
برای هر field از خود بپرس: آیا متن طبیعی را باید تحلیل و رتبه‌بندی کرد؟ از text استفاده کن؛ آیا مقدار کامل exact/filter/sort/facet است؟ keyword. آیا range/sum/avg لازم است؟ نوع numeric با دامنه و precision مناسب. زمان را date با format/timezone روشن بده؛ پرچم را Boolean. مختصات نقطه را geo_point بساز و چندضلعی را geo_shape بررسی کن. arrays نوع اختصاصی ندارند، اما مقدارهایشان باید با همان mapping سازگار باشند.

~~~http
PUT /shops-v1
{"mappings":{"properties":{"name":{"type":"text","fields":{"keyword":{"type":"keyword"}}},"price":{"type":"long"},"open":{"type":"boolean"},"location":{"type":"geo_point"},"updated_at":{"type":"date"}}}}
POST /shops-v1/_search
{"query":{"geo_distance":{"distance":"5km","location":{"lat":35.70,"lon":51.40}}}}
~~~
برای آرایهٔ geo_point به ترتیب `[lon,lat]` توجه کن؛ object با نام lat/lon ابهام را کم می‌کند. پول را با scale و واحد صریح ذخیره کن. تغییر type/analyzer را غالباً migration/reindex بدان.

### Roleهای node و جریان request
Master-eligible node می‌تواند در election شرکت کند؛ master منتخب cluster state و metadata را هماهنگ می‌کند. Data node shardها را میزبانی می‌کند و indexing/search را اجرا می‌کند. Coordinating node درخواست را به shardها پخش و نتیجه را merge می‌کند؛ هر node می‌تواند این کار را انجام دهد و dedicated coordinator فقط در صورت اثبات نیاز ارزش دارد. Node می‌تواند چند role داشته باشد؛ roleها را بر اساس workload، ظرفیت و failure domain طراحی کن.

### ظرفیت و خرابی را با role قاطی نکن
Node process است؛ shard unit داده/اجرای Lucene است. از دست‌رفتن data node با replica مناسب قابل‌تحمل‌تر است؛ از دست‌رفتن master منتخب cluster state را تحت تأثیر می‌گذارد؛ overloaded coordinator ممکن است merge را bottleneck کند. green/yellow/red عمدتاً وضعیت allocation را نشان می‌دهد، نه کیفیت latency. heap، disk، CPU، queue، network، shard size و recovery را مانیتور کن.

### کوییز فصل با پاسخ
1. چه زمان multi-field می‌سازیم؟ پاسخ: وقتی یک مقدار را هم full-text جست‌وجو و هم exact/sort/aggregation می‌خواهیم.
2. geo_point array چه ترتیبی دارد؟ پاسخ: longitude سپس latitude؛ object با نام‌های lat/lon خواناتر است.
3. کدام role cluster state را مدیریت می‌کند؟ پاسخ: master منتخب از میان master-eligibleها.
4. آیا هر node فقط یک نقش دارد؟ پاسخ: نه؛ چند role ممکن است، و جداسازی dedicated به اندازه/بار وابسته است.
5. اضافه‌کردن data node به‌تنهایی مشکل query کند را حل می‌کند؟ پاسخ: نه؛ bottleneck، allocation، mapping و query را باید اندازه‌گیری کرد.
6. چرا Boolean false و missing را جدا در نظر می‌گیریم؟ پاسخ: missing value indexشده ندارد و ممکن است مفهوم «نامعلوم/ارسال‌نشده» باشد.

## موضوع‌های این فصل
- [Data Types](topics/01-data-types/README.md) · [English](topics/01-data-types/README.en.md)
- [Master-Eligible Nodes](topics/02-master-eligible-nodes/README.md) · [English](topics/02-master-eligible-nodes/README.en.md)
- [Data Nodes](topics/03-data-nodes/README.md) · [English](topics/03-data-nodes/README.en.md)
- [Coordinating Nodes](topics/04-coordinating-nodes/README.md) · [English](topics/04-coordinating-nodes/README.en.md)
- [Numeric](topics/05-numeric/README.md) · [English](topics/05-numeric/README.en.md)
- [Boolean](topics/06-boolean/README.md) · [English](topics/06-boolean/README.en.md)
- [Dates](topics/07-dates/README.md) · [English](topics/07-dates/README.en.md)
- [Geo Points](topics/08-geo-points/README.md) · [English](topics/08-geo-points/README.en.md)

## منابع
- [مستند رسمی فصل](https://www.elastic.co/docs/reference/elasticsearch/mapping-reference/field-data-types)
- [Reference کامل Elasticsearch](https://www.elastic.co/guide/en/elasticsearch/reference/current/)
- [Roadmap](https://roadmap.sh/elasticsearch)


