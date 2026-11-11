<div dir="rtl" align="right">
نسخهٔ انگلیسی: [English](README.en.md) · [کتابخانهٔ منابع](../../../references/README.md#05-services-and-networking)

# Load Balancing و EndpointSlice

**فصل:** [Service و شبکه](../../README.md)

## selector تا backend

Service با selector برچسب‌های Pod را انتخاب می‌کند. EndpointSlice فهرست endpointها و وضعیت آمادگی آن‌ها را نگه می‌دارد. dataplane کلاستر اتصال به ClusterIP را به backend مناسب می‌رساند؛ جزئیات implementation به provider یا CNI وابسته است.

~~~yaml
apiVersion: v1
kind: Service
metadata:
  name: api
spec:
  selector:
    app: api
  ports:
  - name: http
    port: 80
    targetPort: 8080
  type: ClusterIP
~~~

این Service پورت 80 را به پورت 8080 Pod انتخاب‌شده می‌برد. برنامه باید واقعاً روی 8080 گوش دهد؛ containerPort صرفاً metadata است و process را مجبور به گوش‌دادن نمی‌کند.

## آمادگی و توازن

Readiness شکست‌خورده Pod را از دریافت traffic معمول Service خارج می‌کند. Load balancing تضمین نمی‌کند که latency برابر یا session state مشترک باشد. برنامه‌های sessionful باید session store یا راهکار مناسب داشته باشند. sessionAffinity یا رفتار client IP را فقط با نیاز روشن فعال کنید.

## عیب‌یابی

~~~sh
kubectl get svc api -o yaml
kubectl get pods -l app=api --show-labels
kubectl get endpointslices -l kubernetes.io/service-name=api
kubectl describe pod -l app=api
~~~

- EndpointSlice خالی: selector یا label اشتباه، Pod ناموجود یا non-ready.
- Endpoint هست ولی connection refused: targetPort/listener یا process را بررسی کنید.
- timeout: policy، CNI، firewall یا route را بررسی کنید.
- فقط یک replica کار می‌کند: readiness، label و process هر Pod را مقایسه کنید.

## کوییز

1. پورت Service و targetPort چرا جدا هستند؟ — مصرف‌کننده می‌تواند پورت منطقی ثابت داشته باشد درحالی‌که process داخل Pod روی پورت دیگری گوش می‌دهد.
2. چه چیزی backend را از ترافیک خارج می‌کند؟ — endpoint readiness/conditionها که به probe وابسته‌اند.
3. Service با endpoint خالی چه چیزی را ثابت می‌کند؟ — فقط شیء Service وجود دارد، نه backend سالم.
4. آدرس Podها را چگونه هدف‌گیری می‌کنید؟ — از Service به‌جای فهرست ثابت IP Pod استفاده کنید.

## منابع

- [Service API concepts](https://kubernetes.io/docs/concepts/services-networking/service/)
- [EndpointSlices](https://kubernetes.io/docs/concepts/services-networking/endpoint-slices/)
- [Probes و آمادگی Pod](https://kubernetes.io/docs/concepts/configuration/liveness-readiness-startup-probes/)
- [منبع فارسی](https://www.youtube.com/watch?v=FEpWJAqx79w)

</div>