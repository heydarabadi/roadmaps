<div dir="rtl" align="right">
نسخهٔ انگلیسی: [English](README.en.md) · [کتابخانهٔ منابع](../../references/README.md)

# آزمایشگاه پایانی: استقرار وب قابل‌عیب‌یابی

این تمرین را فقط در kind، minikube یا کلاستر آموزشی اجرا کنید. پیش‌نیاز: kubectl و کلاستر محلی.

## ۱. بررسی context و جداسازی تمرین

~~~sh
kubectl config current-context
kubectl cluster-info
kubectl create namespace k8s-lab
~~~

پیش از تغییر context را تأیید کنید. فایل Secret را در Git قرار ندهید؛ Base64 رمزنگاری نیست.

## ۲. پیکربندی

~~~yaml
apiVersion: v1
kind: ConfigMap
metadata:
  name: web-settings
  namespace: k8s-lab
data:
  APP_MODE: training
~~~

برای Secret آزمایشی، فایل محلی بسازید:

~~~sh
kubectl create secret generic web-credentials --from-file=TOKEN=./token.txt -n k8s-lab
~~~

## ۳. Deployment و Service

~~~yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: web
  namespace: k8s-lab
spec:
  replicas: 2
  selector:
    matchLabels:
      app: web
  strategy:
    type: RollingUpdate
    rollingUpdate:
      maxUnavailable: 0
      maxSurge: 1
  template:
    metadata:
      labels:
        app: web
    spec:
      containers:
      - name: nginx
        image: nginx:stable
        ports:
        - name: http
          containerPort: 80
        envFrom:
        - configMapRef:
            name: web-settings
        env:
        - name: API_TOKEN
          valueFrom:
            secretKeyRef:
              name: web-credentials
              key: TOKEN
        resources:
          requests:
            cpu: 100m
            memory: 64Mi
          limits:
            memory: 128Mi
        readinessProbe:
          httpGet:
            path: /
            port: http
          periodSeconds: 5
        livenessProbe:
          httpGet:
            path: /
            port: http
          initialDelaySeconds: 10
          periodSeconds: 10
---
apiVersion: v1
kind: Service
metadata:
  name: web
  namespace: k8s-lab
spec:
  selector:
    app: web
  ports:
  - name: http
    port: 80
    targetPort: http
  type: ClusterIP
~~~

فایل را lab.yaml نام‌گذاری کنید. پیش از استفادهٔ واقعی، image را pin، امنیت اجرا را محدود و منابع را با بار واقعی تنظیم کنید.

## ۴. استقرار و بررسی

~~~sh
kubectl apply -f lab.yaml
kubectl -n k8s-lab rollout status deployment/web
kubectl -n k8s-lab get deploy,pods,svc,endpointslices
kubectl -n k8s-lab describe deployment/web
kubectl -n k8s-lab logs deployment/web
kubectl -n k8s-lab port-forward service/web 8080:80
~~~

در مرورگر localhost:8080 را باز کنید. سپس آمادگی Podها را با endpointهای Service تطبیق دهید.

## ۵. شکست و بازیابی

- یک Pod را حذف کنید؛ ببینید Deployment چگونه replica را جایگزین می‌کند.
- نام image را در نسخه‌ای آزمایشی غلط کنید؛ eventهای ImagePullBackOff را پیدا و اصلاح کنید.
- readiness را به مسیر ناموجود تغییر دهید؛ اثرش بر EndpointSlice را ببینید.
- rollout را متوقف و نسخهٔ سالم را برگردانید؛ تفاوت rollback کد و schema دیتابیس را توضیح دهید.

| نشانه | بررسی اول | علت‌های محتمل |
| --- | --- | --- |
| ImagePullBackOff | describe Pod و Events | نام/tag، registry، credential یا TLS |
| Pending | describe Pod | منابع، quota، taint، selector یا PVC |
| CrashLoopBackOff | log قبلی و Events | فرمان، config، startup یا OOM |
| Service بی‌پاسخ | selector و EndpointSlice | label، readiness یا پورت |

## کوییز و پاسخ

1. چرا Deployment به‌جای Pod تنها؟ — replica و rollout را مدیریت می‌کند.
2. Service چگونه Podها را پیدا می‌کند؟ — selector، label و EndpointSlice.
3. آیا Base64 روی Secret رمزنگاری است؟ — خیر؛ encoding است.
4. PV همان backup است؟ — خیر؛ backup مستقل و قابل‌بازیابی لازم است.
5. readiness و liveness چه تفاوتی دارند؟ — اولی ورود به ترافیک، دومی زنده‌بودن/restart را کنترل می‌کند.
6. HPA برای CPU چه نیاز دارد؟ — متریک و requests معتبر.
7. PDB چه چیزی را منع نمی‌کند؟ — خرابی ناگهانی node یا همهٔ disruptionهای اجباری.
8. پس از تمرین چه می‌کنید؟ — context را تأیید و namespace آزمایش را حذف می‌کنید.

~~~sh
kubectl config current-context
kubectl delete namespace k8s-lab
~~~

## منابع

- [Tutorials رسمی Kubernetes](https://kubernetes.io/docs/tutorials/)
- [Pods](https://kubernetes.io/docs/concepts/workloads/pods/)
- [Deployments](https://kubernetes.io/docs/concepts/workloads/controllers/deployment/)
- [Services](https://kubernetes.io/docs/concepts/services-networking/service/)
- [ConfigMaps](https://kubernetes.io/docs/concepts/configuration/configmap/)
- [Secrets](https://kubernetes.io/docs/concepts/configuration/secret/)

</div>