<div dir="rtl" align="right">
نسخهٔ انگلیسی: [English](README.en.md) · [کتابخانهٔ منابع](../../../references/README.md#08-security)

# RBAC: مجوزدهی مبتنی بر نقش

**فصل:** [امنیت Kubernetes](../../README.md)

## چهار جزء

- Role: مجموعهٔ verb و resource در یک namespace.
- ClusterRole: مجوز قابل استفاده در سطح cluster یا ارجاع در namespace.
- RoleBinding: اتصال Role/ClusterRole به user، group یا ServiceAccount در یک namespace.
- ClusterRoleBinding: اتصال ClusterRole به subject در سراسر cluster.

RoleBinding که ClusterRole را ارجاع می‌دهد، همچنان به namespace همان binding محدود است. ClusterRoleBinding گسترهٔ بیشتری دارد. Role دسترسی را تعریف می‌کند؛ تا به subject bind نشود آن subject مجوزی نمی‌گیرد.

~~~yaml
apiVersion: v1
kind: ServiceAccount
metadata:
  name: report-reader
  namespace: reports
---
apiVersion: rbac.authorization.k8s.io/v1
kind: Role
metadata:
  name: read-config
  namespace: reports
rules:
- apiGroups: [""]
  resources: ["configmaps"]
  verbs: ["get", "list"]
---
apiVersion: rbac.authorization.k8s.io/v1
kind: RoleBinding
metadata:
  name: report-reader-binding
  namespace: reports
subjects:
- kind: ServiceAccount
  name: report-reader
  namespace: reports
roleRef:
  apiGroup: rbac.authorization.k8s.io
  kind: Role
  name: read-config
~~~

این نمونه به workload امکان خواندن ConfigMapهای namespace را می‌دهد؛ اگر تنها یک object لازم است، resourceNames را هم ارزیابی کنید. Secret permission ندهید مگر نیاز روشن باشد.

## آزمون دسترسی

~~~sh
kubectl auth can-i list configmaps -n reports --as=system:serviceaccount:reports:report-reader
kubectl auth can-i get secrets -n reports --as=system:serviceaccount:reports:report-reader
kubectl get role,rolebinding -n reports
~~~

دومی باید در طراحی کمینه‌دسترسی no بدهد. خطای Forbidden را با بررسی هویت، verb، API group، resource، namespace و binding حل کنید؛ برای رفع فوری admin ندهید.

## اصل حداقل‌دسترسی

ServiceAccount اختصاصی برای workload، بدون wildcard، کمترین verb ممکن، credential کوتاه‌عمر برای انسان و بازبینی دوره‌ای bindingهای قدیمی. workloadی که API را صدا نمی‌زند نباید بی‌دلیل token خودکار mount کند.

## کوییز

1. کدام جزء permission را به هویت می‌بندد؟ — Binding.
2. get و list یکسان‌اند؟ — خیر؛ خواندن یک object با فهرست‌کردن resourceها تفاوت دارد.
3. wildcard چرا خطرناک است؟ — مجوزهای تازه یا حساس را نیز ممکن است شامل شود.
4. Forbidden را چطور تشخیص می‌دهید؟ — هویت موثر و ruleهای binding را با درخواست دقیق تطبیق می‌دهید.

## منابع

- [RBAC رسمی](https://kubernetes.io/docs/reference/access-authn-authz/rbac/)
- [Service Accounts](https://kubernetes.io/docs/concepts/security/service-accounts/)
- [Authorization](https://kubernetes.io/docs/reference/access-authn-authz/authorization/)
- [منبع فارسی Kubernetes API](https://fadak.ir/fa/Article/1001106)

</div>