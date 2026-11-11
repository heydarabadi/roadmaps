<div dir="rtl" align="right">

# پروژه‌های پایانی Redis

> English edition: [Redis Capstone Projects](../../../en/redis/projects/README.md)

این سه پروژه، درس‌های جدا را در یک طراحی end-to-end به هم وصل می‌کنند. برای اجرای commandهای تغییردهنده فقط از container محلی [درس صفر](../00-start-here/README.md) استفاده کن. لازم نیست سرویس production بسازی؛ هدف این است که مدل داده، flow، failure و runbook را بتوانی توضیح دهی.

## ترتیب پیشنهادی

1. [Cache محصول](01-product-cache/README.md): cache-aside، TTL، invalidation، miss، stale data و stampede.
2. [جریان رویداد سفارش](02-order-stream/README.md): Streams، consumer group، pending/ack، retry، dedupe و retention.
3. [آمادگی production](03-production-readiness/README.md): security، durability، HA/DR، memory، telemetry، rollout و incident drill.

## خروجی هر پروژه

برای هر پروژه یک طراحی یک‌صفحه‌ای بساز که شامل workload، key schema، منبع authoritative، sequence عملیات، concurrency، failure mode، metric، بازیابی و trade-off باشد. راه‌حل نمونهٔ READMEها را با نیاز خیالی خودت تغییر بده؛ copy/paste بدون تعریف رفتار خرابی، پایان پروژه نیست.

## وابستگی درس‌ها

| پروژه | درس‌های اصلی |
| --- | --- |
| cache | String، TTL، انتخاب datastore، memory/eviction، monitoring |
| order stream | Streams، transaction/Lua، ACL، backup/retention |
| readiness | persistence، replication/Sentinel/Cluster، امنیت، latency، upgrade/DR |

## معیار پایان مسیر

- می‌توانی در هر پروژه Redis را cache، source of truth، event log یا بخشی از control/data plane تشخیص بدهی.
- loss، duplicate، stale read و unavailable را جداگانه تحلیل می‌کنی.
- عددهای ظرفیت و latency را بدون benchmark نمی‌سازی؛ پارامترهای مفقود را یادداشت می‌کنی.
- تمرین failure را فقط در lab یا tabletop انجام می‌دهی و restore واقعی را روی instance ایزوله بررسی می‌کنی.

</div>
