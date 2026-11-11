<div dir="rtl" align="right">
نسخهٔ انگلیسی: [English](../../../../../en/kubernetes/12-scheduling/topics/topology-spread/README.md) · [کتابخانهٔ منابع](../../../references/README.md#12-scheduling)

# Topology Spread Constraints

**فصل:** [Scheduling](../../README.md)

## پخش replicaها

اگر همهٔ replicaها روی یک node یا zone باشند، خرابی همان بخش همه را از دسترس خارج می‌کند. topology spread تعداد Podهای مطابق را بین topology domainها پخش می‌کند؛ domain معمولاً با node label مثل zone یا hostname شناخته می‌شود.

~~~yaml
topologySpreadConstraints:
- maxSkew: 1
  topologyKey: topology.kubernetes.io/zone
  whenUnsatisfiable: DoNotSchedule
  labelSelector:
    matchLabels:
      app: api
~~~

maxSkew اختلاف مجاز شمار Podها میان domainهاست. DoNotSchedule قید سخت است؛ اگر zone خالی/ناسازگار باشد Pod Pending می‌ماند. ScheduleAnyway ترجیح است و ممکن است یکنواختی کامل را ندهد.

## طراحی و failure

برچسب topology باید روی nodeها درست باشد و ظرفیت هر zone کافی باشد. topology spread جای چند replica یا PDB نیست؛ مکمل آن‌هاست. خرابی کل region یا dependency مشترک را هم حل نمی‌کند.

## کوییز

1. چرا spread constraint می‌گذاریم؟ — برای پخش بار و کاهش اثر شکست یک domain.
2. DoNotSchedule چه هزینه‌ای دارد؟ — ممکن است با نبود domain مناسب، Pod زمان‌بندی نشود.
3. constraint با چه چیزی Podها را شناسایی می‌کند؟ — label selector.
4. آیا پخش zone خرابی region را حل می‌کند؟ — نه؛ باید failure domain و dependency بزرگ‌تر را هم طراحی کرد.

## منابع

- [Topology Spread Constraints](https://kubernetes.io/docs/concepts/scheduling-eviction/topology-spread-constraints/)
- [Pod Topology Labels](https://kubernetes.io/docs/reference/labels-annotations-taints/)

</div>