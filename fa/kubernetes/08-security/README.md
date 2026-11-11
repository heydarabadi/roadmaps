<div dir="rtl" align="right">
نسخهٔ انگلیسی: [English](../../../en/kubernetes/08-security/README.md) · [کتابخانهٔ منابع](../references/README.md#08-security)

# فصل 08: امنیت Kubernetes

## مدل تهدید

امنیت فقط RBAC نیست. دارایی‌ها و مسیر دسترسی را از API و هویت تا control plane و etcd، node و runtime، image و build pipeline، شبکه، Secret، volume و backup دنبال کنید. برای هر actor بپرسید چه credential دارد، به چه resource دسترسی دارد و نفوذ او چه اثری می‌گذارد.

## هویت و مجوز

Authentication می‌گوید درخواست از چه هویتی است؛ authorization تعیین می‌کند آن هویت چه کاری می‌تواند بکند. RBAC با Role، ClusterRole و bindingها مجوز را می‌دهد. workload باید ServiceAccount اختصاصی و حداقل privilege داشته باشد. دادن cluster-admin راه حل Forbidden نیست.

## شبکه

NetworkPolicy ingress و egress را محدود می‌کند، به شرطی که CNI enforcement آن را پشتیبانی کند. ارتباط‌های واقعی را فهرست کنید، سپس اجازه‌های لازم را در محیط آزمایشی بررسی کنید. policy شبکه TLS، احراز هویت برنامه یا firewall cloud را جایگزین نمی‌کند.

## Container و admission

Pod Security Standards و securityContext اجرای non-root، capability کمینه، seccomp و filesystem محدود را هدایت می‌کنند. image provenance، اسکن، امضا و policy admission زنجیرهٔ supply chain را می‌بندند. یک scan پاک، امنیت کامل را ثابت نمی‌کند.

## نمونهٔ طراحی

برای سرویس checkout:
- ServiceAccount جدا برای API و worker.
- API فقط Secret و ConfigMap موردنیاز namespace خودش را بخواند.
- ingress فقط از gateway؛ backend فقط از API مجاز.
- image نسخه‌دار و ساخته‌شده در pipeline کنترل‌شده.
- container غیرریشه با resources و filesystem محدود.
- audit، alert، rotation و پاسخ به افشای credential مستند.

Namespace به‌تنهایی مرز امنیتی کامل نیست؛ RBAC، NetworkPolicy، admission و زیرساخت را با هم به‌کار ببرید.

## تمرین

1. ServiceAccount بسازید و فقط get یک ConfigMap را با Role بدهید.
2. بررسی کنید مجوز خواندن Secret را ندارد.
3. default-deny شبکه را در namespace آموزشی اعمال و DNS/API لازم را جدا مجاز کنید.
4. Pod پرامتیاز را با Pod Security policy آزمایش کنید.

## کوییز و کلید پاسخ

1. Role با RoleBinding چه تفاوتی دارد؟ — Role مجوز را تعریف؛ binding آن را به هویت وصل می‌کند.
2. NetworkPolicy بدون سازگاری CNI چه می‌شود؟ — ممکن است enforcement نشود.
3. چرا Secret base64 امن نیست؟ — encoding است، نه encryption.
4. چرا namespace به‌تنهایی کافی نیست؟ — همهٔ مرزهای مجوز، شبکه، kernel و زیرساخت را ایجاد نمی‌کند.
5. چرا image provenance اهمیت دارد؟ — باید بدانیم artifact از کجا و با چه pipelineای ساخته شده است.

## منابع

- [Security مفاهیم رسمی](https://kubernetes.io/docs/concepts/security/)
- [RBAC](https://kubernetes.io/docs/reference/access-authn-authz/rbac/)
- [NetworkPolicy](https://kubernetes.io/docs/concepts/services-networking/network-policies/)
- [Pod Security Standards](https://kubernetes.io/docs/concepts/security/pod-security-standards/)
- [منبع فارسی Fadak دربارهٔ API](https://fadak.ir/fa/Article/1001106)

</div>