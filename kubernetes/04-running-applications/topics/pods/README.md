<div dir="rtl" align="right">
نسخهٔ انگلیسی: [English](README.en.md) · [کتابخانهٔ منابع](../../../references/README.md#04-running-applications)

# Pod

**فصل:** [اجرای برنامه‌ها و Workloadها](../../README.md)

## آموزش از پایه

Pod کوچک‌ترین واحد زمان‌بندی Kubernetes است. یک Pod یک یا چند container، فضای شبکه و volumeهای مشترک دارد. containerهای داخل آن همیشه روی یک node اجرا می‌شوند و localhost و IP Pod را به اشتراک می‌گذارند. چند process مستقل را فقط برای کم‌کردن تعداد manifest در یک Pod قرار ندهید؛ با این کار مقیاس، rollout و failure آن‌ها به هم گره می‌خورد.

Pod هویت دائمی ندارد. اگر node خراب شود یا controller آن را جایگزین کند، Pod جدید UID و معمولاً IP جدید می‌گیرد. به همین دلیل برای سرویس‌های عادی Deployment می‌سازیم و ارتباط را با Service انجام می‌دهیم.

### الگوهای چندکانتینری

- **Init container** پیش از containerهای اصلی اجرا می‌شود و برای آماده‌سازی محدود مناسب است.
- **Sidecar** کنار برنامه کار کمکی مثل proxy انجام می‌دهد؛ هم‌زمانی و منابع مشترک آن را در نظر بگیرید.
- **Ephemeral container** برای بررسی موقت Pod موجود در زمان عیب‌یابی است، نه بارکاری دائمی.

## نمونهٔ ساده

~~~yaml
apiVersion: v1
kind: Pod
metadata:
  name: debug-web
  labels:
    app: web
spec:
  restartPolicy: Never
  containers:
  - name: web
    image: nginx:stable
    ports:
    - containerPort: 80
~~~

این Pod برای آزمایش خوب است؛ اگر حذف یا شکست بخورد، controller جایگزینش نمی‌کند. برای برنامهٔ واقعی آن را زیر Deployment ببرید و probe، منابع و security context بیفزایید.

## چرخهٔ عمر و عیب‌یابی

- **Pending:** هنوز node یا منابع/storage مناسب پیدا نشده است.
- **Running:** دست‌کم containerها ساخته شده‌اند؛ الزاماً برنامه آماده نیست.
- **Succeeded/Failed:** کار پایان یافته یا ناموفق شده است.
- **CrashLoopBackOff:** container بارها خارج و با فاصله دوباره شروع می‌شود؛ این status علت نیست.

~~~sh
kubectl get pod debug-web -o wide
kubectl describe pod debug-web
kubectl logs debug-web
kubectl logs debug-web --previous
kubectl exec -it debug-web -- sh
~~~

ابتدا event، بعد log و exit code را ببینید. استفاده از exec فقط در دسترسی مجاز و برای تشخیص است؛ اصلاح دستی داخل container با manifest همگام نمی‌ماند.

## امنیت و منابع

هر container را با requests و limits مناسب، هویت و securityContext محدود اجرا کنید. process غیرریشه و capability حداقلی را ترجیح دهید. probe کند یا اشتباه می‌تواند restart تکراری بسازد؛ endpoint آمادگی را جدا از liveness طراحی کنید.

## کوییز تشریحی

1. چرا IP Pod را در تنظیمات مصرف‌کننده hard-code نمی‌کنیم؟ — Pod جایگزین می‌شود؛ Service/DNS نام پایدارتر می‌دهد.
2. چه زمانی چند container در یک Pod موجه‌اند؟ — وقتی ارتباط شبکه/volume و چرخهٔ عمر مشترک، همکاری tightly-coupled را توجیه کند.
3. آیا Running یعنی Ready؟ — نه؛ بررسی condition و readiness probe ضروری است.
4. حذف Pod مستقیم چه اثری دارد؟ — Pod حذف می‌شود و ownerای برای ساخت جایگزین وجود ندارد.

## منابع

- [Pods رسمی](https://kubernetes.io/docs/concepts/workloads/pods/)
- [چرخهٔ عمر Pod](https://kubernetes.io/docs/concepts/workloads/pods/pod-lifecycle/)
- [Init Containers](https://kubernetes.io/docs/concepts/workloads/pods/init-containers/)
- [Ephemeral Containers](https://kubernetes.io/docs/concepts/workloads/pods/ephemeral-containers/)
- [منبع فارسی EasyEnv](https://easyenv.io/engineering/courses/catalog/kubernetes/fa)

</div>