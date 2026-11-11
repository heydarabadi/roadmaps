<div dir="rtl" align="right">
نسخهٔ انگلیسی: [English](README.en.md) · [کتابخانهٔ منابع](../references/README.md#05-services-and-networking)

# فصل 05: Service و شبکه

## هدف‌های یادگیری

- مدل شبکهٔ Pod و تفاوت آن با Service IP را توضیح دهید.
- selector، endpoint، DNS و readiness را در زنجیرهٔ اتصال دنبال کنید.
- دسترسی داخل کلاستر و ورودی خارجی را با abstraction مناسب فراهم کنید.
- خرابی شبکه را از نشانه تا لایهٔ CNI، DNS، Service یا ingress عیب‌یابی کنید.

## لایه‌های شبکه

مدل Kubernetes انتظار می‌کشد Podها بتوانند براساس IP با یکدیگر ارتباط داشته باشند. CNI چگونگی ساخت این اتصال را پیاده می‌کند. Service یک نشانی منطقی برای مجموعه‌ای از Podها ارائه می‌دهد؛ EndpointSlice فهرست backendهاست. CoreDNS نام Service را به سرویس‌یابی درون‌کلاستری تبدیل می‌کند. برای ورودی خارجی، LoadBalancer یا Ingress/Gateway به provider و controller وابسته است.

~~~text
Client → DNS/hostname → LoadBalancer یا Gateway/Ingress
→ Service → EndpointSlice → Pod آماده → container port
~~~

این مسیر چند جزء مستقل دارد. موفقیت ping به Pod ثابت نمی‌کند HTTP، TLS، selector یا readiness درست است.

## Service و ورودی بیرونی را جدا ببینید

- **ClusterIP:** دسترسی داخلی پایدار به backendها.
- **NodePort:** یک پورت روی nodeها عرضه می‌کند؛ برای expose عمومی معمولاً به‌تنهایی کافی نیست.
- **LoadBalancer:** از integration زیرساخت IP یا hostname می‌گیرد.
- **Ingress:** قواعد HTTP/S است؛ controller لازم دارد تا مسیر را واقعاً پیاده کند.
- **Gateway API:** مدل توسعه‌پذیرتر نقش‌ها و ترافیک ورودی است؛ implementation نیازمند Gateway controller است.

Service لایهٔ دسترسی درون کلاستر است؛ Ingress یا Gateway مسیر ورودی و routing را تعریف می‌کند. یکی جایگزین دیگری نیست.

## سرنخ‌های تشخیص

~~~sh
kubectl get svc
kubectl get endpointslices
kubectl get pods -o wide
kubectl describe service api
kubectl logs deployment/coredns -n kube-system
~~~

اگر سرویس IP دارد ولی endpoint ندارد، selector، label و readiness را بررسی کنید. اگر hostname resolve نمی‌شود، DNS config Pod و CoreDNS را بسنجید. اگر از داخل کار می‌کند ولی بیرون نه، controller، status، firewall، DNS عمومی، certificate و provider integration را بررسی کنید.

## تمرین

یک backend Deployment و Service بسازید. selector را عمداً ناهماهنگ کنید و EndpointSlice را ببینید؛ سپس درستش کنید. در مرحلهٔ بعد آمادگی Pod را false کنید و ببینید endpoint آماده چه تغییری می‌کند. این آزمایش را در کلاستر محلی انجام دهید.

## کوییز و پاسخ

1. Service چطور Podهای جدید را می‌یابد؟ — selector با label match می‌شود؛ endpoint controller فهرست را به‌روز می‌کند.
2. چرا Pod IP را به مصرف‌کننده نمی‌دهیم؟ — Pod جابه‌جا/جایگزین می‌شود؛ Service نشانی منطقی پایدار است.
3. Ingress object به‌تنهایی چه کم دارد؟ — controller و زیرساخت dataplane.
4. DNS resolve می‌شود ولی اتصال timeout است؛ چه لایه‌هایی بعدی‌اند؟ — EndpointSlice، readiness، port/targetPort، policy و مسیر CNI.
5. چرا LoadBalancer local ممکن است IP نگیرد؟ — cluster محلی ممکن است provider integration نداشته باشد.

## منابع

- [Services, Load Balancing, Networking](https://kubernetes.io/docs/concepts/services-networking/)
- [Service](https://kubernetes.io/docs/concepts/services-networking/service/)
- [DNS for Services and Pods](https://kubernetes.io/docs/concepts/services-networking/dns-pod-service/)
- [Ingress](https://kubernetes.io/docs/concepts/services-networking/ingress/)
- [Gateway API](https://gateway-api.sigs.k8s.io/)
- [ویدئوی فارسی Service و شبکه](https://www.youtube.com/watch?v=FEpWJAqx79w)

</div>