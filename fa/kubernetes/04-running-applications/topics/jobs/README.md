<div dir="rtl" align="right">
نسخهٔ انگلیسی: [English](../../../../../en/kubernetes/04-running-applications/topics/jobs/README.md) · [کتابخانهٔ منابع](../../../references/README.md#04-running-applications)

# Job و کارهای پایان‌پذیر

**فصل:** [اجرای برنامه‌ها و Workloadها](../../README.md)

## مدل Job

Job اجرای Podها را تا تکمیل موفق تعدادی کار دنبال می‌کند. completions تعداد موفقیت موردنیاز است؛ parallelism تعداد تلاش هم‌زمان را محدود می‌کند؛ backoffLimit تعداد retry و activeDeadlineSeconds سقف زمان را مشخص می‌کند. ttlSecondsAfterFinished می‌تواند شیء تمام‌شده را پس از مدت تعیین‌شده پاک کند.

Kubernetes ممکن است کار را دوباره اجرا کند؛ exactly-once بودن side effect تضمین نیست. اگر process بعد از نوشتن خروجی و پیش از ثبت موفقیت بمیرد، retry می‌تواند خروجی دوگانه بسازد. پردازش را idempotent کنید یا در سامانهٔ مقصد کلید idempotency/transaction داشته باشید.

## نمونهٔ آزمایشی

~~~yaml
apiVersion: batch/v1
kind: Job
metadata:
  name: report
spec:
  completions: 1
  parallelism: 1
  backoffLimit: 2
  activeDeadlineSeconds: 300
  ttlSecondsAfterFinished: 600
  template:
    spec:
      restartPolicy: Never
      containers:
      - name: task
        image: busybox:stable
        command: ["sh", "-c", "echo report-ready"]
~~~

برای برنامهٔ زمان‌بندی‌شده از CronJob استفاده کنید؛ schedule، concurrencyPolicy و تاریخچه را تنظیم کنید. پردازش واقعی باید ورودی، خروجی پایدار، timeout و گزارش خطا داشته باشد.

## عیب‌یابی و ظرفیت

~~~sh
kubectl get jobs
kubectl describe job report
kubectl get pods -l job-name=report
kubectl logs job/report
~~~

به شمار attempt، exit code، image، credential، timeout و retry نگاه کنید. parallelism زیاد می‌تواند storage، دیتابیس یا API مقصد را overload کند. کار batch را با limit و queue مدیریت کنید.

## تجربهٔ واقعی

Netflix در [مقالهٔ Kueue](https://netflixtechblog.com/how-netflix-simplified-batch-compute-with-kueue-87860682629c) تجربهٔ مدیریت batch compute، صف‌بندی و ظرفیت در Kubernetes را بیان می‌کند. درس عمومی این است که workloadهای tenantهای متعدد به سیاست queue و عدالت ظرفیت نیاز دارند؛ ابزار انتخابی را با مقیاس خود بسنجید.

## کوییز

1. چرا retry اثر کار را دوباره اجرا می‌کند؟ — process ممکن است بعد از اثر بیرونی و پیش از اعلام موفقیت متوقف شود.
2. چطور side effect تکراری را کم می‌کنید؟ — کار idempotent، transaction یا idempotency key.
3. تفاوت Job و CronJob؟ — Job اجرای پایان‌پذیر است؛ CronJob در زمان‌بندی Job می‌سازد.
4. parallelism را چگونه تعیین می‌کنید؟ — براساس ظرفیت cluster و سامانهٔ مقصد، deadline و محدودیت queue.
5. TTL تمام‌شده چه trade-off دارد؟ — منابع را پاک می‌کند اما log/event را برای بررسی از دست می‌دهید.

## منابع

- [Jobs رسمی](https://kubernetes.io/docs/concepts/workloads/controllers/job/)
- [CronJobs رسمی](https://kubernetes.io/docs/concepts/workloads/controllers/cron-jobs/)
- [Netflix TechBlog: Kueue](https://netflixtechblog.com/how-netflix-simplified-batch-compute-with-kueue-87860682629c)
- [منبع فارسی EasyEnv](https://easyenv.io/engineering/courses/catalog/kubernetes/fa)

</div>