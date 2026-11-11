<div dir="rtl" align="right">

# HTTP و HTTPS

HTTP پروتکل کاربردی client-server و stateless است؛ درخواست شامل method، URI، header و گاهی body است و پاسخ status، header و body دارد. cookie و session می‌توانند state را روی تعامل‌های جدا برقرار کنند. HTTP/2 و HTTP/3 روی انتقال و multiplexing اثر می‌گذارند، اما semantics روش‌ها را عوض نمی‌کنند.

HTTPS یعنی HTTP روی TLS. TLS ارتباط را رمزگذاری می‌کند و سرور را از طریق certificate اعتبارسنجی می‌کند. باید redirect به HTTPS، HSTS در زمینهٔ مناسب، certificate renewal، secure cookie، content type و cache policy را طراحی کرد. API نیاز به احراز هویت و مجوزدهی جدا دارد.

برای عملیات معماری، semantics مهم‌اند: GET معمولاً safe است؛ PUT و DELETE idempotent تعریف می‌شوند؛ POST عموماً idempotent نیست مگر کلید یکتایی طراحی شده باشد. status code و timeout در retry client اثر می‌گذارند.

## درخواست HTTP را باز کنیم

درخواست معمولاً method، target، version، header و گاهی body دارد. پاسخ status، header و body می‌دهد. HTTP/2 چند stream را روی اتصال multiplex می‌کند؛ HTTP/3 از QUIC روی UDP استفاده می‌کند. انتقال عوض می‌شود، اما قرارداد application همچنان method و status دارد.

## تصمیم دربارهٔ رفتار امن و تکرارپذیر

- GET داده می‌خواند و باید safe باشد؛ crawler یا cache ممکن است آن را اجرا کند.
- PUT معمولاً resource را جایگزین می‌کند و تکرار همان درخواست باید همان حالت نهایی را بدهد.
- POST اغلب command/create است و تکرارش ممکن است اثر را دوباره اعمال کند؛ پرداخت به idempotency key نیاز دارد.
- PATCH معنای تغییر را از media type/قرارداد می‌گیرد؛ عملیات تکراری همیشه idempotent نیست.

Timeout پس از ارسال POST نتیجه را مبهم می‌کند. client با کلید تکرار همان درخواست را امتحان می‌کند؛ server همان نتیجه را برمی‌گرداند یا status قبلی را استعلام می‌کند، نه اینکه دوباره charge کند.

## HTTPS و حفاظت اطراف آن

TLS انتقال را رمز و تمامیت‌سنجی می‌کند و client گواهی server را بررسی می‌کند. گواهی منقضی، hostname ناهماهنگ، chain ناقص یا ساعت نادرست اتصال را می‌شکند. Renewal، redirect به HTTPS و HSTS را اداره کن. Cookie نشست از Secure و HttpOnly و SameSite مناسب استفاده کند. CORS کنترل authorization نیست و HTTPS هم مجوز API را جایگزین نمی‌کند.

## انتخاب status و cache

201 ایجاد، 202 پذیرفته‌شدن async، 204 پاسخ بی‌بدنه، 400 ورودی نامعتبر، 401 نبود هویت معتبر، 403 نداشتن مجوز، 404 نبود/پنهان‌بودن منبع، 409 تعارض و 429 محدودیت نرخ را می‌توانند نمایش دهند؛ قرارداد باید دقیق باشد. Cache-Control برای پاسخ خصوصی یا عمومی مهم است؛ ETag و If-None-Match درخواست مجدد بی‌دلیل را کم می‌کند.

## آزمون

۱. stateless بودن HTTP یعنی چه؟ **پاسخ:** پروتکل به‌تنهایی وضعیت درخواست قبلی را حفظ نمی‌کند؛ app می‌تواند session بسازد.
۲. HTTPS چه محافظتی می‌دهد؟ **پاسخ:** محرمانگی و تمامیت کانال و اعتبارسنجی گواهی endpoint.
۳. idempotent بودن چه اهمیتی دارد؟ **پاسخ:** retry را با اثر منطقی تکراری اشتباه نمی‌گیریم.
۴. آیا 200 برای همهٔ پاسخ‌ها مناسب است؟ **پاسخ:** نه؛ semantics خطا و موفقیت باید در status code منعکس شوند.

## تمرین

برای پرداخت، رفتار کلاینت در timeout پس از POST را طراحی کن تا دوبار شارژ نشود.

## پاسخ نمونهٔ تمرین

Client key یکتا برای checkout POST می‌فرستد؛ server آن را با user و payload hash ثبت می‌کند. timeout باعث ارسال مجدد همان key می‌شود؛ server همان order/payment status را برمی‌گرداند. کلید با payload متفاوت رد می‌شود. response اولیه Pending است؛ status endpoint یا callback/reconciliation نتیجه را می‌رساند. UI پرداخت دوم نمی‌سازد.

## منابع

- فارسی: [نقشهٔ API و معماری](https://roadmap.sh/pdfs/roadmaps/software-architect.pdf)، [مبانی معماری فارسی](https://www.alirostami.com/software-architecture/)
- انگلیسی: [MDN HTTP Overview](https://developer.mozilla.org/en-US/docs/Web/HTTP/Guides/Overview)، [OWASP TLS Cheat Sheet](https://cheatsheetseries.owasp.org/cheatsheets/Transport_Layer_Security_Cheat_Sheet.html)

</div>

