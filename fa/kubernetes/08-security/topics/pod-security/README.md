<div dir="rtl" align="right">
نسخهٔ انگلیسی: [English](../../../../../en/kubernetes/08-security/topics/pod-security/README.md) · [کتابخانهٔ منابع](../../../references/README.md#08-security)

# امنیت Pod و Container

**فصل:** [امنیت Kubernetes](../../README.md)

## Pod Security Standards

سطح‌های Privileged، Baseline و Restricted راهنمایی می‌کنند چه قابلیت‌هایی مجاز باشند. Pod Security Admission می‌تواند policy را در namespace enforce کند. ابتدا رفتار برنامه و نیاز kernel/filesystem آن را بفهمید؛ سخت‌گیری بی‌آزمون ممکن است rollout را بشکند.

## حداقل‌سازی privilege

~~~yaml
securityContext:
  runAsNonRoot: true
  allowPrivilegeEscalation: false
  readOnlyRootFilesystem: true
  capabilities:
    drop:
    - ALL
  seccompProfile:
    type: RuntimeDefault
~~~

برنامه باید با کاربر غیرریشه کار کند و root filesystem آن قابل‌نوشتن لازم نباشد. اگر مسیر موقت لازم دارد، volume محدود برای همان مسیر mount کنید. قابلیت لازم را دقیق اضافه کنید، نه اینکه همهٔ controlها را خاموش کنید.

## زنجیرهٔ supply chain

Image مطمئن، dependency update، vulnerability scan، SBOM، provenance و signature را در pipeline ببینید. Admission می‌تواند image یا policy نامعتبر را رد کند. اسکن پاک فقط دانش همان پایگاه در همان زمان است و تضمین امنیت کامل نیست.

## دام‌ها

- privileged یا hostNetwork/hostPath بدون نیاز مشخص.
- اجرای root برای سادگی و بازگذاشتن capability.
- فرض namespace مرز امنیتی کافی است.
- webhook policy بدون HA و timeout.
- گذاشتن credential داخل image.

## کوییز

1. runAsNonRoot چه کمکی می‌کند؟ — دسترسی process را محدود می‌کند.
2. readOnlyRootFilesystem چه شرطی دارد؟ — برنامه مسیرهای writable خود را جدا mount کند.
3. آیا Pod Security Standards تمام supply-chain را امن می‌کنند؟ — خیر؛ image build/scan/signing کنترل جداست.
4. webhook policy چرا باید پایدار باشد؟ — خرابی آن می‌تواند درخواست API را کند یا مسدود کند.

## منابع

- [Pod Security Standards](https://kubernetes.io/docs/concepts/security/pod-security-standards/)
- [Security Context](https://kubernetes.io/docs/tasks/configure-pod-container/security-context/)
- [Admission Controllers](https://kubernetes.io/docs/reference/access-authn-authz/admission-controllers/)
- [منبع فارسی Fadak](https://fadak.ir/fa/Article/1001106)

</div>