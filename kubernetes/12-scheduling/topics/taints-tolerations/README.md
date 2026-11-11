<div dir="rtl" align="right">
نسخهٔ انگلیسی: [English](README.en.md) · [کتابخانهٔ منابع](../../../references/README.md#12-scheduling)

# Taints و Tolerations

**فصل:** [Scheduling](../../README.md)

## رابطهٔ دوطرفه

Taint روی node می‌گوید Podهای فاقد تحمل مناسب نباید آنجا قرار بگیرند. Toleration در Pod اجازه می‌دهد آن taint مانع زمان‌بندی نشود؛ اما انتخاب node را تضمین نمی‌کند. برای ترجیح یا اجبار node باید affinity/selector هم طراحی شود.

Effectها:
- NoSchedule: Pod تازهٔ بدون toleration زمان‌بندی نمی‌شود.
- PreferNoSchedule: تا حد امکان از node پرهیز می‌شود.
- NoExecute: Pod نامتحمل ممکن است از node خارج شود.

~~~sh
kubectl taint nodes NODE_NAME workload=gpu:NoSchedule
kubectl taint nodes NODE_NAME workload=gpu:NoSchedule-
~~~

فرمان اول نمونهٔ آموزشی است؛ node و اثر را قبل از اجرا بررسی کنید. در cluster مشترک taint اشتباه می‌تواند scheduling workloadها را متوقف کند.

## کاربرد و دام

برای nodeهای GPU، عملیات یا workload حساس مفید است. Toleration را بی‌دلیل به همهٔ Podها ندهید، وگرنه جداسازی بی‌اثر می‌شود. برای placement اختصاصی، taint و toleration را با label و affinity جفت کنید.

## کوییز

1. Taint کجا تعریف می‌شود؟ — روی node.
2. Toleration کجا تعریف می‌شود؟ — در Pod spec.
3. آیا toleration Pod را به node می‌فرستد؟ — خیر، فقط مانع taint را حذف می‌کند.
4. کدام effect می‌تواند Pod جاری را بیرون کند؟ — NoExecute.

## منابع

- [Taints and Tolerations](https://kubernetes.io/docs/concepts/scheduling-eviction/taint-and-toleration/)
- [Node assignment](https://kubernetes.io/docs/concepts/scheduling-eviction/assign-pod-node/)

</div>