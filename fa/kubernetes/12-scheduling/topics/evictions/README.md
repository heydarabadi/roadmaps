<div dir="rtl" align="right">
نسخهٔ انگلیسی: [English](../../../../../en/kubernetes/12-scheduling/topics/evictions/README.md) · [کتابخانهٔ منابع](../../../references/README.md#12-scheduling)

# Eviction و Pod Disruption

**فصل:** [Scheduling](../../README.md)

## داوطلبانه و اجباری را جدا کنید

وقتی node تحت فشار حافظه یا disk است، kubelet ممکن است Pod را evict کند. هنگام drain یا بعضی عملیات نگهداری، eviction داوطلبانه رخ می‌دهد. PodDisruptionBudget حداقل تعداد در دسترس یا سقف disruption داوطلبانه را مشخص می‌کند تا تعمیر کلاستر بی‌محابا همهٔ replicaها را خارج نکند.

PDB خرابی اجباری، process crash یا قطع ناگهانی node را منع نمی‌کند. اگر سرویس یک replica داشته باشد، PDB نمی‌تواند ظرفیت جایگزین بسازد. replica، spread، resource request و graceful shutdown همچنان لازم‌اند.

~~~yaml
apiVersion: policy/v1
kind: PodDisruptionBudget
metadata:
  name: api-budget
spec:
  minAvailable: 2
  selector:
    matchLabels:
      app: api
~~~

اگر فقط دو replica دارید، minAvailable دو ممکن است drain را متوقف کند. تعداد replica و maintenance policy را هماهنگ کنید.

## کوییز

1. PDB عمدتاً چه disruptionی را محدود می‌کند؟ — disruption داوطلبانه.
2. آیا PDB node crash را متوقف می‌کند؟ — خیر.
3. drain با PDB متوقف شده؛ چه می‌سنجید؟ — replica، minAvailable/maxUnavailable، سلامت Pod و ظرفیت.
4. چرا eviction اجباری رخ می‌دهد؟ — فشار منابع node یا شرایط اضطراری.

## منابع

- [Pod Disruptions](https://kubernetes.io/docs/concepts/workloads/pods/disruptions/)
- [Node pressure eviction](https://kubernetes.io/docs/concepts/scheduling-eviction/node-pressure-eviction/)
- [kubectl drain](https://kubernetes.io/docs/reference/kubectl/generated/kubectl_drain/)

</div>