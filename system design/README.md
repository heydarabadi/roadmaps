<div dir="rtl" align="right">
[English version](en/README.md)


# مسیر یادگیری System Design

این مجموعهٔ فارسی، مفاهیم roadmap.sh را با بیان آموزشی مستقل، مثال، آزمون و منابع تکمیلی پوشش می‌دهد؛ متن سایت را خط‌به‌خط ترجمه نمی‌کند.

> صفحهٔ roadmap تعاملی است و بخشی از درخت در متن ساده دیده نمی‌شود. مبنای استخراج ریزموضوع‌ها، صفحهٔ تعاملی و PDF رسمی قابل‌خواندن roadmap.sh است. ساختار سایت ممکن است به‌روزرسانی شود؛ این بررسی در 2026-11-10 انجام شد.

## روش استفاده

- از فصل 01 تا 10 پیش برو؛ هر مفهوم در پوشهٔ جدا و فایل README.md خودش است.
- ابتدا آزمون را حل کن و بعد پاسخ‌نامه را بخوان.
- مثال‌ها برای آموزش‌اند؛ معماری داخلی شرکت‌ها را ادعا نمی‌کنند مگر به منبع عمومی ارجاع داده شود.
- نام تاریخی roadmap مانند master-slave در توضیح با اصطلاح رایج primary-replica همراه شده است.
- توضیح‌های فصل‌ها و پروژهٔ پایانی برای یادگیری مفاهیم اصلی در همین مجموعه هستند. پیوندهای بیرونی منابع اختیاری‌اند؛ برای نسخه‌های تازهٔ فناوری یا عمق بیشتر می‌توانی آن‌ها را دنبال کنی.

## شروع و پایان دوره

- [پیش‌نیازها، واژه‌نامه و فرمول‌ها](00-prerequisites-and-glossary.md)
- [پروژهٔ پایانی: checkout فروشگاه در زمان فروش ویژه](11-capstone-project/README.md)

## فصل‌ها

- [مبانی طراحی سیستم](01-foundations/README.md)
- [تحمل خرابی و تکثیر](02-fault-tolerance-and-replication/README.md)
- [شبکه، لبه و ارتباط](03-network-edge-communication/README.md)
- [معماری لایهٔ کاربرد](04-application-architecture/README.md)
- [داده و کش](05-data-and-caching/README.md)
- [پردازش ناهمگام و پیام‌رسانی](06-async-and-messaging/README.md)
- [ضدالگوهای کارایی](07-performance-antipatterns/README.md)
- [مشاهده‌پذیری](08-observability/README.md)
- [الگوهای طراحی ابری](09-cloud-design-patterns/README.md)
- [قابلیت اطمینان و امنیت](10-reliability-security/README.md)

## پوشش نقشه

- مبانی: روش طراحی، performance/scalability، latency/throughput، availability/consistency، consistency patterns، CAP و محاسبهٔ downtime.
- خرابی و داده: failover و replication.
- شبکه: DNS، CDN، load balancer و HTTP/TCP/UDP/RPC/gRPC/REST/GraphQL.
- اپلیکیشن و ذخیره‌سازی: microservices، discovery، SQL/NoSQL، cache، sharding و الگوهای مدیریت داده.
- پردازش: jobهای پس‌زمینه، task/message queue، backpressure، stream، الگوهای پیام و idempotency.
- عملیات: performance antipatterns، health/availability/performance/security/usage monitoring، instrumentation، visualization و alerting.
- الگوهای ابری: Design & Implementation، Data Management، Messaging و Reliability (Availability، High Availability، Resiliency، Security).

## برنامهٔ پیشنهادی ۸ هفته‌ای

| هفته | فصل‌ها | تمرین |
| --- | --- | --- |
| 1 | مبانی | تخمین بار و SLO سرویس سفارش |
| 2 | خرابی و replication | تعیین RTO/RPO و تمرین failover |
| 3 | شبکه | رسم مسیر درخواست و قرارداد API |
| 4 | معماری اپلیکیشن | مقایسهٔ monolith ماژولار و سرویس‌ها |
| 5 | داده و cache | تعیین freshness و منبع حقیقت |
| 6 | ناهمگامی | طراحی queue، retry، DLQ و idempotency |
| 7 | کارایی و پایش | تعریف SLI و یافتن ضدالگو با trace |
| 8 | الگوهای ابری و امنیت | ارائهٔ طرح و بازبینی failure/security |

## منابع مبنا

- [System Design Roadmap — roadmap.sh](https://roadmap.sh/system-design)
- [PDF رسمی roadmap.sh](https://roadmap.sh/pdfs/roadmaps/system-design.pdf)
- منابع رسمی و مقاله‌های فارسی مرتبط در README هر موضوع آمده‌اند.

</div>

