<div dir="rtl" align="right">
نسخهٔ انگلیسی: [English](../../../../../en/kubernetes/05-services-networking/topics/external-access/README.md) · [کتابخانهٔ منابع](../../../references/README.md#05-services-and-networking)

# دسترسی بیرونی به Service

**فصل:** [Service و شبکه](../../README.md)

## انتخاب روش

Service نوع ClusterIP فقط داخل کلاستر قابل‌دسترسی است و انتخاب پیش‌فرض بسیاری از backendهاست. NodePort پورت node را باز می‌کند؛ expose مستقیم به اینترنت به firewall و مدیریت پورت‌ها نیاز دارد. LoadBalancer از provider یا controller می‌خواهد IP/hostname بسازد. Ingress و Gateway routing لایهٔ HTTP، host و TLS را تعریف می‌کنند و برای کار به controller نیاز دارند.

ExternalName نام DNS بیرونی را alias می‌کند؛ خود آن proxy یا load balancer نیست. ابزار local tunnel نیز صرفاً مسیر تمرینی می‌سازد و architecture production را اثبات نمی‌کند.

## جریان HTTP ورودی

1. DNS hostname عمومی را به load balancer می‌برد.
2. load balancer ترافیک را به controller/Gateway می‌دهد.
3. route بر پایهٔ host و path به Service اشاره می‌کند.
4. Service endpointهای Pod آماده را می‌بیند.
5. readiness، port name، targetPort و container listener باید هم‌خوان باشند.
6. TLS ممکن است در لبه یا برنامه خاتمه یابد؛ محل termination و trust chain را مشخص کنید.

## عیب‌یابی

~~~sh
kubectl get svc,ingress,gateway -A
kubectl describe ingress shop
kubectl get endpointslices
kubectl get pods -A
~~~

Ingress بدون controller می‌تواند فقط یک شیء API باقی بماند. همچنین Service نوع LoadBalancer در محیطی بدون cloud-controller ممکن است hostname نگیرد. DNS، controller logs، firewall، certificate و backend readiness را جدا بررسی کنید.

## تصمیم و دام‌ها

برای backend داخلی ClusterIP مناسب است؛ برای وب عمومی به DNS، TLS، controller، certificate rotation و policy نیاز دارید. NodePort را راه میانبر امن production فرض نکنید. چند controller هم‌زمان را بی‌دلیل نصب نکنید و annotationهای provider-specific را ثبت کنید.

## کوییز

1. Ingress و Service چه تفاوتی دارند؟ — Service backend پایدار؛ Ingress HTTP routing ورودی و نیازمند controller.
2. چرا LoadBalancer در local cluster ممکن است Pending بماند؟ — integration ساخت external LB وجود ندارد.
3. قبل از بررسی firewall، backend را چگونه می‌سنجید؟ — endpoint، selector، readiness و listener پورت.
4. کدام نوع Service فقط درون کلاستر است؟ — ClusterIP.

## منابع

- [Service types](https://kubernetes.io/docs/concepts/services-networking/service/)
- [Ingress](https://kubernetes.io/docs/concepts/services-networking/ingress/)
- [Gateway API](https://gateway-api.sigs.k8s.io/)
- [آموزش فارسی Service و شبکه](https://www.youtube.com/watch?v=FEpWJAqx79w)

</div>