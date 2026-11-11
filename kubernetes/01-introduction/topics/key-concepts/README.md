<div dir="rtl" align="right">
نسخهٔ انگلیسی: [English](README.en.md) · [کتابخانهٔ منابع](../../../references/README.md#01-introduction-and-mental-model)

# مفاهیم و واژگان Kubernetes

**فصل:** [مقدمه و مدل ذهنی](../../README.md)

## هدف یادگیری

ساختار یک شیء API را بخوانید، تفاوت resource، controller و فرایند اجرا را بفهمید و label و selector را عیب‌یابی کنید.

## اشیای API چه شکلی‌اند؟

بیشتر manifestها چهار بخش اصلی دارند:

~~~yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: api
  namespace: shop
  labels:
    team: checkout
spec:
  replicas: 3
  selector:
    matchLabels:
      app: api
  template:
    metadata:
      labels:
        app: api
    spec:
      containers:
      - name: server
        image: example.invalid/shop/api:v1
~~~

- **apiVersion** گروه و نسخهٔ schema را مشخص می‌کند.
- **kind** نوع منبع است.
- **metadata** نام، namespace، label و annotation را نگه می‌دارد.
- **spec** خواستهٔ شما را بیان می‌کند.
- **status** را کلاستر گزارش می‌کند؛ آن را به‌عنوان ورودی دستی جایگزین نکنید.

این دو بخش مهم را قاطی نکنید: spec می‌گوید چه می‌خواهیم؛ status می‌گوید چه مشاهده شده است.

## Label و Selector

Label جفت کلید/مقدار برای دسته‌بندی شیء است. Selector شرط انتخاب را تعریف می‌کند؛ مثلاً Service با app=api فقط Podهای مطابق را endpoint می‌کند. اگر Pod label اشتباه داشته باشد، Deployment ممکن است آن را نسازد یا Service هیچ endpointی نداشته باشد.

~~~sh
kubectl get pods --show-labels -n shop
kubectl get endpointslices -n shop
~~~

در تغییر selector دقت کنید؛ selector Deployment معمولاً immutable است و ناسازگاری می‌تواند باعث مدیریت اشتباه Pod شود.

## مفاهیم مرتبط را به هم وصل کنید

- Deployment یک controller سطح‌بالاست.
- ReplicaSet تعداد Pod را مدیریت می‌کند.
- Pod درخواست اجراست، نه خود ماشین.
- Service انتخابگر و آدرس منطقی backend است.
- Namespace مرز نام‌گذاری و بخشی از جداسازی مدیریتی است، نه مرز امنیتی کامل.
- ConfigMap و Secret دادهٔ پیکربندی را از image جدا می‌کنند.
- Event سرنخ زمانی برای مشکل است، اما جای log و metric برنامه را نمی‌گیرد.

## تمرین خواندن manifest

در نمونهٔ بالا selector برابر app=api است. در قالب Pod نیز app=api آمده؛ این تطبیق ضروری است. نام image نمونهٔ آموزشی و غیرقابل‌دسترسی است؛ برای آزمایش آن را با image معتبر جایگزین کنید. از kubectl explain deployment.spec برای مرور schema همان API استفاده کنید.

## دام‌ها

- هر metadata را کاربردی فرض نکنید؛ label برای انتخاب، annotation برای دادهٔ غیرانتخابی است.
- namespace را به‌تنهایی مرز امنیتی ندانید.
- هر شیءی که get نشان می‌دهد را آمادهٔ مصرف ندانید؛ status، condition و endpoint را بررسی کنید.
- نسخهٔ API را از روی نمونهٔ قدیمی کپی نکنید؛ مستند نسخهٔ cluster خود را ببینید.

## کوییز تشریحی

1. manifest وضعیت مطلوب را در کدام بخش می‌نویسد؟ — spec؛ وضعیت واقعی در status گزارش می‌شود.
2. Service هیچ backendی ندارد؛ اولین تطبیق چیست؟ — selector سرویس با label Podها و سپس readiness را مقایسه کنید.
3. چرا annotation معمولاً در selector استفاده نمی‌شود؟ — برای metadata توصیفی/ابزاری است؛ labelها برای انتخاب و گروه‌بندی طراحی شده‌اند.
4. آیا namespace جداسازی کامل امنیتی است؟ — نه؛ RBAC، NetworkPolicy، policyهای Pod و مرزهای زیرساخت هم لازم‌اند.

## منابع

- [Kubernetes Objects](https://kubernetes.io/docs/concepts/overview/working-with-objects/)
- [Labels and Selectors](https://kubernetes.io/docs/concepts/overview/working-with-objects/labels/)
- [مرجع API رسمی](https://kubernetes.io/docs/reference/kubernetes-api/)
- [راهنمای فارسی Fadak دربارهٔ API و YAML](https://fadak.ir/fa/Article/1001106)

</div>