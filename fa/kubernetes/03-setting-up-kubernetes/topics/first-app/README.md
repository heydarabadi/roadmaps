<div dir="rtl" align="right">
نسخهٔ انگلیسی: [English](../../../../../en/kubernetes/03-setting-up-kubernetes/topics/first-app/README.md) · [کتابخانهٔ منابع](../../../references/README.md#03-setting-up-kubernetes)

# استقرار اولین برنامه

**فصل:** [راه‌اندازی Kubernetes](../../README.md)

## هدف

یک workload را به شکل declarative اجرا کنید، دسترسی داخلی بدهید و تفاوت وضعیت ثبت‌شده و آماده‌بودن برنامه را ببینید.

## manifest نمونه

~~~yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: hello
  labels:
    app: hello
spec:
  replicas: 2
  selector:
    matchLabels:
      app: hello
  template:
    metadata:
      labels:
        app: hello
    spec:
      containers:
      - name: web
        image: nginx:stable
        ports:
        - name: http
          containerPort: 80
        readinessProbe:
          httpGet:
            path: /
            port: http
          periodSeconds: 5
        resources:
          requests:
            cpu: 100m
            memory: 64Mi
---
apiVersion: v1
kind: Service
metadata:
  name: hello
spec:
  selector:
    app: hello
  ports:
  - name: http
    port: 80
    targetPort: http
  type: ClusterIP
~~~

Deployment تعداد Pod را می‌سازد. selector آن باید با labelهای Pod برابر باشد. Service نیز با selector خودش Podهای backend را می‌یابد؛ دو selector متفاوت‌اند ولی هر دو باید با labelهای درست مطابقت کنند.

~~~sh
kubectl apply -f hello.yaml
kubectl rollout status deployment/hello
kubectl get deploy,rs,pods,svc,endpointslices
kubectl describe pod -l app=hello
kubectl port-forward service/hello 8080:80
~~~

در مرورگر localhost:8080 را باز کنید. سپس مقدار replica را به سه تغییر دهید و دوباره apply کنید. تفاوت desired و ready replica را مشاهده کنید.

## چرخهٔ عیب‌یابی

1. get برای وضعیت کلی.
2. describe برای conditionها و رویداد.
3. logs برای خطای برنامه.
4. endpoint slice برای بررسی اتصال Service به Pod.
5. اصلاح علت و مشاهدهٔ rollout status.

Image نامعتبر، نرسیدن Pod به Ready یا selector ناسازگار هرکدام لایهٔ متفاوتی از مسیر را می‌شکنند.

## کوییز تشریحی

1. چرا Service ممکن است وجود داشته باشد اما endpoint نداشته باشد؟ — selector ناهماهنگ، نبود Pod یا non-ready بودن آن.
2. apply موفق چه چیزی را ثابت می‌کند؟ — API درخواست را پذیرفته؛ نه اینکه image کشیده یا برنامه آماده شده باشد.
3. چه چیزی را در این نمونه برای production کم داریم؟ — image pin، limit/resource sizing مبتنی بر بار، securityContext، logging/monitoring، TLS/ورودی و policy.
4. چطور آزمایش را پاک می‌کنید؟ — بعد از تأیید context، منابع را با همان فایل یا namespace تمرینی حذف کنید.

## منابع

- [آموزش رسمی اجرای برنامه](https://kubernetes.io/docs/tutorials/kubernetes-basics/deploy-app/deploy-intro/)
- [Deployment](https://kubernetes.io/docs/concepts/workloads/controllers/deployment/)
- [Service](https://kubernetes.io/docs/concepts/services-networking/service/)
- [آموزش مقدماتی فارسی DevNA](https://devna.ir/articles/kubernetes-basics-for-beginners)

</div>