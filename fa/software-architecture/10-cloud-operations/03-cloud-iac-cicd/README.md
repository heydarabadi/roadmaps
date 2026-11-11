<div dir="rtl" align="right">

# ارائه‌دهندگان ابر، IaC و CI/CD

Cloud provider قابلیت‌هایی چون compute، storage، network، database، identity، queue و managed runtime عرضه می‌کند. انتخاب AWS، Azure، Google Cloud یا ابر خصوصی را با region، دسترس‌پذیری سرویس، مهارت، مقررات، هزینه، پشتیبانی و exit strategy بسنج؛ اصطلاح مشابه در providerها ضمانت یکسانی ندارد.

Infrastructure as Code (IaC) وضعیت زیرساخت را version control و قابل‌بازبینی می‌کند. state، secret، drift، plan review، policy و محیط‌ها را مدیریت کن. CI کد را build و test می‌کند؛ CD تغییر معتبر را به محیط مقصد می‌رساند. deployment باید rollback، rollout تدریجی، artifact immutable، provenance و کنترل دسترسی داشته باشد.

## مثال

در هر merge، pipeline تست و image امضاشده می‌سازد؛ IaC plan برای بازبینی ارائه می‌شود؛ تغییر به staging می‌رود؛ smoke check و SLO guardrail اجرا می‌شود؛ سپس release درصدی با امکان rollback انجام می‌شود. migration database باید با نسخهٔ قبلی و جدید app سازگار باشد.

## مسیر IaC و انتشار

۱. تعریف زیرساخت در repository version-control می‌شود و secret داخل کد قرار نمی‌گیرد.
۲. formatter، validator، policy check و plan در CI اجرا می‌شوند.
۳. reviewer اختلاف plan با محیط را می‌بیند؛ state backend قفل، backup و دسترسی کنترل‌شده دارد.
۴. apply با هویت deploy کم‌دسترسی و ردپای audit اجرا می‌شود؛ drift از تغییر دستی کشف می‌شود.
۵. artifact برنامه یک‌بار build و با digest همان artifact به محیط‌های بعدی منتقل می‌شود.
۶. rollout تدریجی، smoke check و SLO guardrail موفقیت را می‌سنجند؛ rollback یا forward-fix از پیش طراحی شده است.

## استراتژی deployment

Rolling به‌تدریج instance جایگزین می‌کند؛ ظرفیت و سازگاری دو نسخه باید هم‌زمان برقرار باشد. Blue/green دو محیط نگه می‌دارد و switch می‌کند، اما هزینهٔ ظرفیت دارد. Canary درصد کمی را در معرض می‌گذارد و با metric/گروه کنترل تصمیم می‌گیرد. Feature flag انتشار کد و فعال‌سازی قابلیت را جدا می‌کند، اما owner و تاریخ حذف می‌خواهد.

Database migration با expand/contract به نسخه‌های app سازگار می‌ماند. Rollback کد همیشه ممکن نیست اگر schema برگشت‌ناپذیر شده؛ گاهی forward-fix امن‌تر است.

## هویت pipeline و زنجیرهٔ تأمین

CI runner، registry، signing key و environment credential زنجیرهٔ اعتمادند. هر job فقط permission لازم داشته باشد؛ approval و protected environment برای production و artifact provenance را تعریف کن. dependency lock و image digest قابلیت بازتولید و بررسی را تقویت می‌کنند.

## سنجهٔ موفقیت

انتشار وقتی موفق است که کاربر مسیر مهم را انجام دهد و error rate، latency، saturation و business metric در محدوده بماند. Build سبز بدون smoke test و monitoring مدرک سلامت production نیست.

## آزمون

۱. IaC چه فایده‌ای دارد؟ **پاسخ:** زیرساخت را تکرارپذیر، reviewپذیر و قابل‌ردیابی می‌کند.
۲. CI با CD چه تفاوت دارد؟ **پاسخ:** CI build/test و ادغام را پیوسته می‌کند؛ CD تحویل یا انتشار را خودکار می‌سازد.
۳. cloud-native یعنی همه‌چیز در یک provider؟ **پاسخ:** خیر؛ بیشتر به طراحی برای قابلیت‌های ابری و اداره‌پذیری اشاره دارد.
۴. drift چیست؟ **پاسخ:** تفاوت وضعیت واقعی با تعریف IaC.

## تمرین

مسیر انتشار تغییر شبکه و نسخهٔ API را از pull request تا rollback بنویس؛ هویت deploy، approval و سنجهٔ موفقیت را مشخص کن.

## پاسخ نمونهٔ تمرین

PR شامل IaC plan و API migration سازگار است؛ CI policy/test؛ approval از مالک شبکه/امنیت؛ deploy identity محدود و audit؛ change مرحله‌ای؛ smoke check و metric latency/error؛ canary/rollback در صورت افت. schema expand/contract باید با هر دو API version سازگار باشد. موفقیت با SLI و business flow سنجیده می‌شود، نه فقط pipeline سبز.

## منابع

- فارسی: [سناریوی فارسی CI/CD](https://virgool.io/@alimaster/سناریو-کامل-cicd-با-گیت-لب-و-داکر-و-traefik-و-reactjs-iebtcpzlz5ue)، [ساخت زیرساخت DevOps](https://codity.ir/devops-infrastructure-docker-kubernetes/)
- انگلیسی: [AWS Well-Architected](https://docs.aws.amazon.com/wellarchitected/latest/framework/)، [Terraform Documentation](https://developer.hashicorp.com/terraform/docs)، [GitHub Actions](https://docs.github.com/en/actions)

</div>

