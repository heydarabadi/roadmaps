# Query DSL

[English version](../../../../../en/elasticsearch/04-indexing-and-query-languages/topics/query-dsl/README.md)


> فصل 04: عملیات سند و زبان‌های Query · موضوع تکمیلی مسیر

## هدف یادگیری

بتوانی query جست‌وجوی Elasticsearch را به شکل JSON بسازی، تفاوت query context و filter context را توضیح بدهی و شرط‌های leaf و compound را با هم ترکیب کنی.

## آموزش

Query DSL زبان JSON-native برای جست‌وجو در Elasticsearch است. Queryهای leaf مثل match، term و range یک شرط روی یک field را بیان می‌کنند. Queryهای compound مثل bool چند شرط را ترکیب می‌کنند. در query context، Elasticsearch برای نتیجه score می‌سازد؛ در filter context فقط می‌سنجد سند شرط را دارد یا نه. برای متن از match و analyzer مناسب استفاده کن؛ برای مقدار دقیق، وضعیت، SKU و بازه‌ی عددی از query مناسب mapping استفاده کن.

## مثال: جست‌وجوی فروشگاهی

~~~http
POST /products-v1/_search
{
  "query": {
    "bool": {
      "must": [
        { "match": { "title": "کیبورد مکانیکی" } }
      ],
      "filter": [
        { "term": { "available": true } },
        { "range": { "price": { "lte": 8000000 } } }
      ],
      "must_not": [
        { "term": { "status": "hidden" } }
      ],
      "should": [
        { "match": { "brand": "مکانیکی" } }
      ]
    }
  }
}
~~~

عنوان برای relevance در must است؛ موجودی و قیمت در filter قرار دارند تا score نسازند؛ status پنهان حذف می‌شود. در صورت اهمیت الزام should، مقدار minimum_should_match را صریح تعیین کن. Query DSL با KQL، Lucene query string و ES|QL یکی نیست.

## روش عیب‌یابی

اول mapping و analyzer فیلد را ببین. نتیجه‌ی مورد انتظار را با چند سند کوچک بساز. برای سند مشخص از _explain استفاده کن تا score را بفهمی؛ برای تحلیل هزینه از profile به شکل هدفمند استفاده کن، چون profile خودش سربار دارد. query را روی نمونه‌ی واقعی و queryهای پرتکرار بسنج.

## سناریو و خطای رایج

در جست‌وجوی کالا، متن باید relevance داشته باشد، اما موجودی، tenant، زمان و بازه‌ی قیمت معمولاً شرط filter هستند. خطای رایج این است که از term روی فیلد text تحلیل‌شده استفاده شود یا همه‌ی شرط‌ها در must قرار گیرند و score بی‌دلیل محاسبه شود.

## خودآزمایی
1. Query DSL چیست؟ پاسخ: زبان JSON بومی برای تعریف query، filter، score و بخش‌های درخواست Search.
2. چرا query را با mapping می‌خوانیم؟ پاسخ: رفتار term/match و analyzer به نوع فیلد وابسته است؛ JSON معتبر به‌تنهایی query درست نمی‌سازد.
## تدریس کامل
Query DSL بدنهٔ JSON درخواست‌های Elasticsearch را تشکیل می‌دهد. هر query باید در زمینهٔ mapping تفسیر شود: match تحلیل متنی دارد، term exact است، range بازه را می‌سنجد، bool queryهای کوچک را ترکیب می‌کند و aggregation نتیجه را خلاصه می‌کند. ابتدا کوچک‌ترین query را اجرا کن، پاسخ را ببین و سپس clauseها را اضافه کن.

~~~http
POST /products-v1/_search
{"query":{"bool":{"must":[{"match":{"title":"کیبورد مکانیکی"}}],"filter":[{"term":{"available":true}},{"range":{"price":{"lte":8000000}}}]}}}
~~~
عنوان رتبه‌سازی می‌کند؛ موجودی و قیمت شرط قبولی‌اند. تمرین: query را با Explain برای سندی که انتظارش را داشتی ولی برنگشت بررسی کن. syntax درست، mapping نادرست، analyzer و دادهٔ واقعی را جایگزین نمی‌کند.
## منابع

- انگلیسی: [Query DSL رسمی](https://www.elastic.co/docs/reference/query-languages/query-dsl)
- انگلیسی: [Search API](https://www.elastic.co/docs/reference/elasticsearch/rest-apis/search)
- فارسی: [جست‌وجوی مقاله‌های Query DSL](https://www.google.com/search?q=%D8%A2%D9%85%D9%88%D8%B2%D8%B4+%D9%81%D8%A7%D8%B1%D8%B3%DB%8C+Elasticsearch+Query+DSL)
- فارسی: [کتابخانهٔ منابع فارسی](../../../references/README.md)


