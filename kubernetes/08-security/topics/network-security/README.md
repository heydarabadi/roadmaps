<div dir="rtl" align="right">
نسخهٔ انگلیسی: [English](README.en.md) · [کتابخانهٔ منابع](../../../references/README.md#08-security)

# NetworkPolicy و امنیت شبکه

**فصل:** [امنیت Kubernetes](../../README.md)

## از flow map تا policy

NetworkPolicy ورود و خروج Podهای انتخاب‌شده را محدود می‌کند. چند policy می‌توانند مجموعهٔ دسترسی‌های مجاز را ترکیب کنند. CNI باید enforcement را پیاده کند. policy object موجود بودن به معنی فیلترشدن ترافیک نیست؛ implementation کلاستر را بررسی کنید.

پیش از default-deny، مسیرهای واقعی را ثبت کنید: DNS، frontend→API، API→database، telemetry و dependency بیرونی. بعد اجازه‌ها را محدود و در staging اتصال مجاز و غیرمجاز را آزمایش کنید.

~~~yaml
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: allow-api-from-front
  namespace: shop
spec:
  podSelector:
    matchLabels:
      app: api
  policyTypes:
  - Ingress
  ingress:
  - from:
    - podSelector:
        matchLabels:
          app: frontend
    ports:
    - protocol: TCP
      port: 8080
~~~

این تنها ingress است؛ egress و DNS را نیز در طراحی لحاظ کنید. selectorها باید به label واقعی Podها بخورند.

## عیب‌یابی

اگر policy ارتباط را قطع کرد، namespace، podSelector، namespaceSelector، port، protocol و policyTypes را بخوانید. از داخل Pod یا محیط تشخیصی مجاز ارتباط را آزمایش و CNI logs/metrics را بررسی کنید. NetworkPolicy جای TLS، auth برنامه یا firewall مرزی نیست.

## کوییز

1. NetworkPolicy چه جهتی را کنترل می‌کند؟ — ingress و egress.
2. default-deny چه چیزی را سهواً می‌بندد؟ — DNS، telemetry و dependencyهایی که اجازهٔ صریح نگرفته‌اند.
3. چرا policy بدون CNI قابل اتکا نیست؟ — API شیء را ثبت می‌کند، ولی CNI باید packetها را enforce کند.
4. آیا policy شبکه هویت کاربر API را بررسی می‌کند؟ — خیر؛ برای آن authentication/authorization برنامه و API لازم است.

## منابع

- [NetworkPolicy رسمی](https://kubernetes.io/docs/concepts/services-networking/network-policies/)
- [مدل شبکه Kubernetes](https://kubernetes.io/docs/concepts/services-networking/)
- [ویدئوی فارسی Service و شبکه](https://www.youtube.com/watch?v=FEpWJAqx79w)

</div>