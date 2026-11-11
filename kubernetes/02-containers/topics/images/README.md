<div dir="rtl" align="right">
نسخهٔ انگلیسی: [English](README.en.md) · [کتابخانهٔ منابع](../../../references/README.md#02-containers-and-images)

# Image، لایه‌ها و Registry

**فصل:** [کانتینرها](../../README.md)

## از کد تا image

Image نتیجهٔ build است و معمولاً از لایه‌های filesystem تشکیل می‌شود. دستورهای Dockerfile می‌توانند لایهٔ cacheشونده بسازند؛ ترتیب وابستگی‌های کم‌تغییر را پیش از کد بگذارید تا build دوباره از صفر انجام نشود. Multi-stage build وابستگی‌های کامپایل را از image نهایی جدا می‌کند.

~~~dockerfile
FROM node:22-alpine AS build
WORKDIR /app
COPY package*.json ./
RUN npm ci
COPY . .
RUN npm run build

FROM node:22-alpine
WORKDIR /app
COPY --from=build /app/dist ./dist
COPY --from=build /app/package*.json ./
RUN npm ci --omit=dev
USER node
CMD ["node", "dist/server.js"]
~~~

این نمونه فرض می‌کند پروژه Node.js فایل‌های یادشده را دارد. در پروژهٔ واقعی، base image را نسخه‌دار کنید، فایل‌های غیرلازم را با .dockerignore حذف کنید و تنها خروجی و runtime dependency لازم را کپی کنید.

## Tag، digest و pull policy

Tag قابل‌خواندن است اما ممکن است قابل‌تغییر باشد. Digest به محتوای مشخص image اشاره می‌کند و برای ثبت دقیق artifact مناسب‌تر است. Kubernetes رفتار pull را با imagePullPolicy تعیین می‌کند؛ cache node و mutable tag می‌تواند نتیجه را مبهم کند. سیاست release را یکدست کنید.

برای registry خصوصی imagePullSecret به namespace مربوط وصل می‌شود. خطای pull ممکن است از نام اشتباه، نبود مجوز، انقضای credential، CA/TLS یا قطعی شبکه باشد؛ eventها معمولاً سرنخ اول را می‌دهند.

## زنجیرهٔ تأمین و امنیت

- secret را وارد Dockerfile، لایهٔ build یا repository نکنید.
- dependency و image را اسکن و منشأ artifact را ثبت کنید.
- از base image قابل‌اعتماد و به‌روزرسانی‌شده استفاده کنید.
- image را با کاربر غیرریشه اجرا کنید، اگر برنامه پشتیبانی می‌کند.
- امضا و admission policy می‌توانند تنها artifact تأییدشده را مجاز کنند.

## تمرین و کوییز

1. چرا tag شناور برای production خطر ایجاد می‌کند؟ — tag ممکن است محتوای دیگری بگیرد و rebuild/rollback دقیق دشوار شود.
2. ImagePullBackOff با CrashLoopBackOff چه فرقی دارد؟ — اولی در دریافت/آماده‌کردن image گیر کرده؛ دومی container شروع شده ولی مکرر خارج می‌شود.
3. چرا multi-stage build؟ — ابزار build و dependencyهای غیرلازم را از runtime image حذف می‌کند.
4. secret را کجا نگه می‌دارید؟ — در secret manager یا سازوکار امن pipeline و secret مرجع؛ نه در لایهٔ image.
5. تمرین: یک image خراب نام‌گذاری کنید، event را بخوانید، خطا را اصلاح و rollout را بررسی کنید.

## منابع

- [Images رسمی Kubernetes](https://kubernetes.io/docs/concepts/containers/images/)
- [Image pull secrets](https://kubernetes.io/docs/tasks/configure-pod-container/pull-image-private-registry/)
- [OCI Image Specification](https://github.com/opencontainers/image-spec)
- [منبع فارسی EasyEnv](https://easyenv.io/engineering/courses/catalog/kubernetes/fa)

</div>