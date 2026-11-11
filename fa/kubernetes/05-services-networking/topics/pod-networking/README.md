<div dir="rtl" align="right">
نسخهٔ انگلیسی: [English](../../../../../en/kubernetes/05-services-networking/topics/pod-networking/README.md) · [کتابخانهٔ منابع](../../../references/README.md#05-services-and-networking)

# ارتباط Pod، DNS و CNI

**فصل:** [Service و شبکه](../../README.md)

## مدل شبکه

Podها طبق مدل Kubernetes IP دارند و انتظار می‌رود طبق network implementation کلاستر با هم ارتباط برقرار کنند. CNI افزونهٔ شبکه است که اتصال و address allocation را فراهم می‌کند. Service یک IP مجازی و endpoint پویا دارد؛ dataplane قوانین آن را پیاده می‌کند. در بعضی کلاسترها kube-proxy این نقش را انجام می‌دهد و بعضی از providerها dataplane متفاوت دارند.

Pod مستقیم برای کشف سرویس مناسب نیست؛ IP آن جابه‌جا می‌شود. CoreDNS نام سرویس را در namespace resolve می‌کند. برای مثال backend در همان namespace معمولاً با نام کوتاه api و از namespace دیگر با نام api.shop قابل‌شناسایی است؛ FQDN دقیق را از DNS policy و namespace بخوانید.

## آزمون مرحله‌ای از داخل Pod

~~~sh
kubectl exec -it deploy/frontend -- sh
nslookup api
wget -qO- http://api:8080/health
~~~

اگر ابزار داخل image نیست، یک Pod تشخیصی مجاز و موقت بسازید؛ ابزار debugging را بی‌دلیل به image production اضافه نکنید.

1. آیا DNS نام را برمی‌گرداند؟
2. آیا Service selector به endpoint می‌رسد؟
3. آیا targetPort با listener برنامه برابر است؟
4. آیا NetworkPolicy اجازه می‌دهد؟
5. آیا CNI و route node سالم‌اند؟

## NetworkPolicy

NetworkPolicy می‌تواند ingress و egress Pod را محدود کند، اما CNI باید اجرای آن را پشتیبانی کند. default-deny را همراه استثنای DNS و dependencyهای واقعی طراحی کنید. سیاست تنها در namespace و برای Podهای انتخاب‌شده اثر می‌گذارد؛ label و policyهای هم‌پوشان را بررسی کنید.

## نشانه‌های رایج

- DNS همهٔ نام‌ها را resolve نمی‌کند: DNS config Pod یا CoreDNS.
- DNS کار می‌کند ولی timeout: policy، route، firewall یا مقصد.
- اتصال درون Pod کار می‌کند اما Service نه: selector، EndpointSlice یا service dataplane.
- فقط node خاص مشکل دارد: CNI agent، مسیر و condition node.

## کوییز

1. CNI چه کاری می‌کند؟ — پیاده‌سازی شبکه و اتصال Podها براساس plugin کلاستر.
2. چرا ping به معنی سلامت HTTP نیست؟ — پورت، TLS، HTTP handler و dependency جدا هستند.
3. NetworkPolicy بدون CNI سازگار چه می‌شود؟ — ممکن است اعمال نشود یا رفتار موردانتظار را نداشته باشد.
4. سرویس backend را با چه نامی صدا می‌زنیم؟ — DNS Service، نه Pod IP ثابت.

## منابع

- [مفاهیم Networking رسمی](https://kubernetes.io/docs/concepts/services-networking/)
- [DNS برای Service و Pod](https://kubernetes.io/docs/concepts/services-networking/dns-pod-service/)
- [NetworkPolicy](https://kubernetes.io/docs/concepts/services-networking/network-policies/)
- [آموزش فارسی Service/DNS](https://www.youtube.com/watch?v=FEpWJAqx79w)

</div>