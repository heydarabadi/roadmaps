<div dir="rtl" align="right">
نسخهٔ انگلیسی: [English](../../../../../en/kubernetes/14-advanced-topics/topics/crds/README.md) · [کتابخانهٔ منابع](../../../references/README.md#14-advanced-topics-and-extensibility)

# CustomResourceDefinition (CRD)

**فصل:** [موضوعات پیشرفته](../../README.md)

## تعریف نوع جدید

CRD یک resource kind تازه با group، version، scope و OpenAPI schema معرفی می‌کند. API Server داده را ذخیره و validate می‌کند. Custom Resource نمونه‌ای از آن نوع است. CRD باید برای کاربر API روشن و پایدار باشد؛ حذف یا تغییر ناسازگار آن می‌تواند objectهای کاربردی را از API خارج کند.

~~~yaml
apiVersion: apiextensions.k8s.io/v1
kind: CustomResourceDefinition
metadata:
  name: backups.ops.example.com
spec:
  group: ops.example.com
  scope: Namespaced
  names:
    plural: backups
    singular: backup
    kind: Backup
    shortNames: ["bkp"]
  versions:
  - name: v1
    served: true
    storage: true
    schema:
      openAPIV3Schema:
        type: object
        properties:
          spec:
            type: object
            properties:
              destination:
                type: string
~~~

نمونه فقط ساختار حداقلی schema را نشان می‌دهد. resource واقعی validation، required fields، defaults، status subresource و RBAC می‌خواهد.

## Versioning و lifecycle

- served version نسخه‌ای است که API می‌پذیرد/برمی‌گرداند.
- storage version نسخهٔ ذخیره‌شده در etcd است؛ migration را برنامه‌ریزی کنید.
- conversion webhook برای تبدیل نسخه‌های ناسازگار می‌تواند لازم شود.
- scope namespaced یا cluster-scoped را پیش از انتشار انتخاب کنید.
- unknown fields و pruning را بفهمید تا دادهٔ اضافه ناخواسته حذف نشود.
- backup و upgrade controller را همراه CRD هماهنگ کنید.

CRD بدون controller فقط ذخیرهٔ declarative data است؛ رفتار باید جداگانه پیاده شود.

## کوییز

1. چه کسی Custom Resource را validate و ذخیره می‌کند؟ — API server بر مبنای CRD/schema.
2. آیا CRD به‌تنهایی cluster را اداره می‌کند؟ — خیر؛ controller منطق reconcile را لازم دارد.
3. چرا storage version مهم است؟ — objectها در etcd با آن نسخه ذخیره می‌شوند.
4. حذف CRD چه اثری می‌تواند داشته باشد؟ — API type و custom objectها را از دسترس خارج/پاک کند؛ migration و backup لازم است.

## منابع

- [CRD concepts](https://kubernetes.io/docs/concepts/extend-kubernetes/api-extension/custom-resources/)
- [راهنمای ساخت CRD](https://kubernetes.io/docs/tasks/extend-kubernetes/custom-resources/custom-resource-definitions/)
- [Kubernetes API versioning](https://kubernetes.io/docs/reference/using-api/api-concepts/)

</div>