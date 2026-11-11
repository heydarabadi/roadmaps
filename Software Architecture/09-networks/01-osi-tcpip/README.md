<div dir="rtl" align="right">

# مدل‌های OSI و TCP/IP

مدل OSI هفت لایه برای فکرکردن و توضیح شبکه دارد؛ مدل TCP/IP به مجموعهٔ پروتکل‌های عملی اینترنت نزدیک‌تر است. این مدل‌ها کمک می‌کنند خطا را لایه‌به‌لایه محدود کنیم؛ شبکهٔ واقعی همیشه مرزهای تمیز کتابی ندارد و بعضی سرویس‌ها چند لایه را با هم درگیر می‌کنند.

OSI از physical، data link، network، transport، session، presentation و application تشکیل می‌شود. TCP/IP معمولاً link، internet، transport و application را جدا می‌کند. DNS و HTTP در application، TCP/UDP در transport و IP در network/internet هستند. TLS در عمل روی transport یا پروتکل کاربردی قرار می‌گیرد و جایگزین authentication برنامه نیست.

## مثال عیب‌یابی

اگر DNS نام API را resolve نمی‌کند، بررسی HTTP status هنوز بی‌معناست. اگر TCP handshake برقرار می‌شود ولی TLS شکست می‌خورد، certificate، SNI یا ساعت سیستم را بررسی کن. اگر TLS موفق است اما API پاسخ 403 می‌دهد، احتمالاً لایهٔ برنامه و مجوزدهی مطرح است.

## مسیر یک درخواست، لایه‌به‌لایه

وقتی client به api.example.com وصل می‌شود:

۱. DNS نام را به IP resolve می‌کند؛ cache، record، resolver و شبکهٔ دسترسی می‌توانند failure ایجاد کنند.
۲. IP packet را بین شبکه‌ها route می‌کند؛ IP به‌تنهایی تحویل برنامه را تضمین نمی‌کند.
۳. TCP اتصال و جریان بایت مرتب/قابل‌اعتماد می‌دهد؛ UDP datagram کم‌هزینه‌تری می‌دهد اما تضمین را به پروتکل بالاتر واگذار می‌کند.
۴. TLS در handshake گواهی و پارامترهای رمز را بررسی می‌کند و سپس کانال امن می‌سازد.
۵. HTTP method، path، header، body و status را تعریف می‌کند؛ برنامه authentication و authorization را اعمال می‌کند.

## کاربرد مدل هنگام عیب‌یابی

از پایین به بالا سؤال بپرس: link فعال است؟ IP و route درست‌اند؟ DNS جواب می‌دهد؟ TCP port باز است؟ TLS و hostname معتبرند؟ HTTP response چیست؟ برنامه چه policy اجرا کرد؟ هر لایه symptom متفاوت دارد؛ ping موفق اثبات سلامت HTTP نیست، چون ممکن است ICMP مجاز باشد ولی port یا app خراب باشد.

## محدودیت مدل‌ها

OSI چارچوب مفهومی هفت‌لایه است؛ TCP/IP به شبکهٔ واقعی اینترنت نزدیک‌تر است. پیاده‌سازی‌ها دقیقاً در لایه‌های کتابی جا نمی‌گیرند: TLS، proxy، VPN و HTTP/3 چند لایه را تحت تأثیر می‌گذارند. مدل را برای نام‌گذاری فرضیه استفاده کن، نه برای نتیجه‌گیری بدون مشاهده.

## آزمون

۱. OSI بیشتر چه کاربردی دارد؟ **پاسخ:** زبان آموزشی و چارچوب عیب‌یابی.
۲. TCP چه قابلیتی می‌دهد؟ **پاسخ:** انتقال جریان قابل‌اعتماد و مرتب‌شده، با هزینهٔ handshake/کنترل.
۳. UDP چه تفاوتی دارد؟ **پاسخ:** datagram با تضمین‌های کمتر؛ پروتکل بالاتر باید رفتار لازم را بسازد.
۴. DNS در کدام لایهٔ مدل ساده قرار می‌گیرد؟ **پاسخ:** application.

## تمرین

مسیر یک درخواست API را از DNS تا HTTP بنویس و برای هر مرحله یک failure symptom ثبت کن.

## پاسخ نمونهٔ تمرین

DNS failure: NXDOMAIN/timeout؛ IP route failure: unreachable؛ TCP: connection refused/timeout؛ TLS: certificate/hostname alert؛ HTTP: 4xx/5xx؛ app policy: 401/403. در هر گام ابزار متناسب مانند resolver query، route/socket, TLS client و request trace به‌کار ببر؛ ping تنها سلامت API را ثابت نمی‌کند.

## منابع

- فارسی: [شبکه در مبانی معماری فارسی](https://www.alirostami.com/software-architecture/)، [آموزش شبکهٔ فارسی](https://www.daneshjooyar.com/blog/osi-model/)
- انگلیسی: [AWS: OSI Model](https://aws.amazon.com/what-is/osi-model/)، [MikroTik Networking Fundamentals](https://manual.mikrotik.com/docs/getting-started/networking-fundamentals/)

</div>

