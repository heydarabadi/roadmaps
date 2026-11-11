<div dir="rtl" align="right">

# فصل ۶ — دسترس‌پذیری و مقیاس‌پذیری

> English edition: [Chapter 6 — Availability and scaling](../../../en/redis/06-high-availability-scaling/README.md)

> سه مسئلهٔ جدا را حل می‌کنیم: replica برای کپی خواندنی/آمادگی، Sentinel برای پایش و failover خودکار یک primary، Cluster برای sharding و scale افقی. زمان پیشنهادی: ۴ تا ۶ ساعت.

## ترتیب درس

1. [Replication](replication/README.md): full/partial sync، replication ID/offset، lag و کپی ناهمگام.
2. [Sentinel](sentinel/README.md): quorum، subjective/objective down، انتخاب primary و کشف endpoint از client.
3. [Cluster](cluster/README.md): 16384 hash slots، shard، MOVED/ASK، hash tag و multi-key constraint.

## مدل معماری

Replication جریان تغییرات را از primary به replica می‌فرستد و ذاتاً همگام نیست. Sentinel مجموعه‌ای از processهای monitor، تصمیم failover و endpoint جدید را به client معرفی می‌کند؛ آن را با sharding اشتباه نگیر. Cluster داده را slotهای متعدد پخش می‌کند و هر slot را node مشخصی میزبانی می‌کند؛ replicaهای shard برای failover به‌کار می‌روند.

```text
Replication:  client -> primary ---- async change stream ----> replica
Sentinel:     sentinels monitor primary/replicas -> elect/failover -> client discovers new primary
Cluster:      client -> node owning hash-slot(key) ; slot range split among shards
```

## موضوع‌هایی که باید تصمیم بگیری

- آیا read stale از replica قابل‌قبول است؟ replication lag را چطور پایش می‌کنی؟
- هنگام primary failure، چه writeهایی از دست می‌روند؟ failover را چگونه client-side reconnect/refresh می‌کند؟
- Sentinel مستقل، در failure domain جدا و با quorum درست اجرا می‌شود؟
- در Cluster کدام keyها باید multi-key atomic باشند و آیا hash tag آن‌ها را هم‌slot می‌کند؟
- reshard/rebalance چه اثری روی latency، connection pool و deploy دارد؟
- backup و cross-region DR کجا هستند؟ HA جای backup نیست.

## تمرین طراحی

سرویسی با یک primary و دو replica تصور کن. سپس node primary را از شبکه جدا کن: چه کسی تشخیص می‌دهد؟ چه کسی رهبر جدید را انتخاب می‌کند؟ برنامه از کجا endpoint جدید را پیدا می‌کند؟ آیا write تأییدشدهٔ آخر حتماً روی replica هست؟ بعد به Cluster سه shard فکر کن: چرا `MGET keyA keyB` ممکن است نیازمند slot مشترک باشد؟ پاسخ را از روی [درس cluster](./cluster/README.md) توضیح بده.

## پرسش مرور

1. آیا replica هم‌زمان با primary write می‌کند؟
2. Sentinel داده را shard می‌کند؟
3. Sentinel quorum با تعداد nodeهای monitor چه رابطه‌ای دارد؟
4. Cluster hash tag چه وقت لازم است؟

<details><summary>پاسخ راهنما</summary>

Replication معمولاً async است و replica می‌تواند lag داشته باشد. Sentinel failover/monitoring/discovery است نه sharding. Quorum تعداد موافقت‌های لازم برای تشخیص/اقدام را تعیین می‌کند و majority/availability را نیز باید مطابق طراحی بشناسی. Hash tag یک بخش کلید را برای keyهای مرتبط به slot یکسان می‌برد؛ این کار multi-key را ممکن می‌کند اما skew/hot slot ایجاد نکند.

</details>

## منابع

- [Replication](https://redis.io/docs/latest/operate/oss_and_stack/management/replication/)
- [Sentinel](https://redis.io/docs/latest/operate/oss_and_stack/management/sentinel/)
- [Cluster specification](https://redis.io/docs/latest/operate/oss_and_stack/reference/cluster-spec/)
- [مقالهٔ فارسی Replication و Cluster](https://azarsys.com/blog/setup-redis-replication-cluster/)

</div>
