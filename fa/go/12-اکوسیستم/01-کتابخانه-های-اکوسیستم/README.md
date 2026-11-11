# ۱۲.۱ — اکوسیستم Go: CLI، HTTP، RPC، database و realtime

<div dir="rtl">

**زمان پیشنهادی:** ۱۸۰ دقیقه · **پیش‌نیاز:** package/module، interface، HTTP و error  
**هدف:** کتابخانه را بر اساس مرز پروژه انتخاب کنی، API بیرونی را امن بسازی و هزینهٔ نگه‌داری dependency را در طراحی ببینی.

## نقشهٔ این درس

- انتخاب dependency و استاندارد library
- CLI و command tree
- سرور و client HTTP
- framework وب و middleware
- database/sql، driver و ORM
- gRPC و Protocol Buffers
- logging و observability
- WebSocket و realtime
- dependency governance
- تجربهٔ مهاجرت و ساخت کتابخانه در Dropbox

## ۱) از نیاز شروع کن، نه از فهرست محبوبیت

Go standard library مجموعهٔ بزرگی از نیازهای backend را پوشش می‌دهد: <code>net/http</code>، <code>flag</code>، <code>database/sql</code>، <code>encoding/json</code>، <code>log/slog</code> و بیشتر. کتابخانهٔ بیرونی زمانی ارزش دارد که قابلیت مهمی را با هزینهٔ کمتر یا کیفیت بهتر بدهد. dependency جدید یعنی نسخه‌بندی، security review، update، license و compatibility هم به پروژه اضافه می‌شود.

برای هر انتخاب این پرسش‌ها را جواب بده:

- کدام requirement واقعی را حل می‌کند؟
- آیا standard library کافی است؟
- API و رفتار failure آن چیست؟
- نگه‌داری و سازگاری نسخه چگونه است؟
- آیا به cgo یا native dependency نیاز دارد؟
- چه هزینه‌ای در build، test، deploy و incident response می‌آورد؟

## ۲) CLI: flag یا command framework؟

برای برنامهٔ کوچک با چند flag، package استاندارد <code>flag</code> معمولاً کافی است. وقتی command tree عمیق، help/usage، completion، subcommand یا config sourceهای متعدد لازم است، libraryهایی مثل Cobra یا urfave/cli می‌توانند کار را ساده کنند. برای رابط تعاملی ترمینال (TUI)، مدل برنامه و event loop اهمیت دارد و ابزارهایی مانند Bubble Tea در این دسته‌اند.

CLI خوب ورودی را validate می‌کند، پیام خطای قابل‌فهم به stderr می‌دهد، exit code معنادار دارد، secret را در خروجی echo نمی‌کند و عملیات طولانی را با signal/context متوقف می‌کند. command logic را در package قابل‌تست بگذار؛ <code>main</code> را فقط composition root نگه دار.

## ۳) HTTP server و client

برای APIهای متداول، <code>net/http</code> هم server و هم client می‌دهد. قبل از framework، routing، middleware، validation و logging نیاز پروژه را فهرست کن. در نسخه‌های جدید Go، ServeMux قابلیت‌های routing بیشتری دارد؛ اگر module قدیمی یا target قدیمی داری، APIهای قابل‌استفاده را بررسی کن.

### اصول سرور

- برای request body سقف اندازه بگذار.
- deadline و timeout برای header/read/write/idle را متناسب تنظیم کن.
- request context را تا database/RPC منتقل کن.
- ورودی را parse و validate کن و authentication/authorization را جدا نگه دار.
- status code و error response را با قرارداد API هماهنگ کن.
- secret یا error داخلی را در body نمایش نده.
- با SIGTERM shutdown graceful انجام بده و مهلت پایان مشخص کن.

### اصول client

- به‌طور پیش‌فرض clientی با timeout مشخص بساز؛ درخواست بدون deadline ممکن است تا مدت طولانی منتظر بماند.
- از request context برای timeout هر عملیات استفاده کن.
- response body را ببند و در صورت نیاز drain کن تا connection reuse ممکن باشد.
- status code را بررسی کن؛ پاسخ 500 از نگاه transport الزاماً error در <code>Client.Do</code> نیست.
- TLS verification را خاموش نکن.
- retry را فقط با idempotency، deadline، سقف و backoff طراحی کن.

یک framework routing نیازهای روزمره را کم می‌کند، اما timeout، امنیت، error handling و lifecycle را به‌جای تو تصمیم نمی‌گیرد.

## ۴) database/sql، driver، pgx و ORM

<code>database/sql</code> API استاندارد connection pool و query است؛ برای صحبت با موتور واقعی به driver نیاز دارد. <code>pgx</code> یک driver/client رایج PostgreSQL و GORM یک ORM عمومی است. این‌ها جایگزین‌های همسان نیستند: یکی driver/client تخصصی، دیگری abstraction مدل object-relational است.

### قواعد دسترسی به DB

- query را با placeholder و parameter بفرست؛ SQL را با concat ورودی user نساز.
- query/exec را با context اجرا کن تا لغو و deadline منتقل شود.
- <code>Rows.Close</code> را ببند و <code>Rows.Err</code> را پس از iteration بررسی کن.
- connection pool را با ترافیک و محدودیت DB تنظیم کن؛ تعداد زیاد connection می‌تواند خود DB را overload کند.
- transaction را کوتاه نگه دار و <code>Commit</code>/<code>Rollback</code> را بررسی کن.
- schema migration را نسخه‌بندی کن و data backfill را جدا از deploy فکر کن.
- plan/query count را اندازه بگیر؛ ORM تضمین‌کنندهٔ query کارا نیست.

ORM می‌تواند CRUD ساده و mapping را سرعت دهد، اما N+1 query، lock، transaction و SQL plan همچنان نیاز به فهم دارند. abstractionی انتخاب کن که تیم بتواند مشکل performance را از پشت آن پیدا کند.

## ۵) gRPC و Protocol Buffers

gRPC برای ارتباط سرویس به سرویس type-safe و قراردادمحور مناسب است. Protocol Buffers schema را تعریف می‌کند و code generation client/server را می‌سازد. مزیت‌ها: قرارداد واضح، پیام compact، tooling و streaming. هزینه‌ها: versioning schema، code generation، debugging، proxy/browser compatibility و coupling به gRPC stack.

سازگاری schema را رعایت کن: field numberهای منتشرشده را دوباره استفاده نکن، field حذف‌شده را reserve کن، و تغییر ناسازگار را rollout مرحله‌ای کن. deadline و cancellation را از caller انتقال بده. یک درخواست RPC ممکن است retry شود؛ idempotency و retry policy را explicit تعیین کن.

برای API عمومی browser/clientهای متنوع، REST/JSON ممکن است تعامل ساده‌تری بدهد. انتخاب protocol با مصرف‌کننده‌ها و عملیاتی‌کردن آن سنجیده می‌شود.

## ۶) logging و observability

از Go 1.21 به بعد <code>log/slog</code> در standard library structured logging فراهم می‌کند. اگر پروژه به قابلیت‌هایی مانند handler، sampling یا عملکرد خاص نیاز دارد، Zap و Zerolog نمونه‌های کتابخانهٔ بیرونی‌اند. این‌ها را به‌عنوان گزینهٔ اکوسیستم بشناس، نه اینکه بدون بررسی latest API و معیار پروژه یکی را مطلقاً بهترین بنامی.

Log ساخت‌یافته key/value و سطح شدت دارد. در هر رویداد request/trace ID، operation و error context را ثبت کن؛ ولی credential، token، secret و دادهٔ حساس را log نکن. Log جای metric و trace را نمی‌گیرد: شمارش خطا، latency distribution و dependency trace پاسخ پرسش‌های متفاوتی می‌دهند.

## ۷) WebSocket و realtime

WebSocket کانال دوطرفهٔ persistent میان client و server می‌دهد؛ خودش broker، durable queue، fanout cluster یا user presence database نیست. کتابخانه‌هایی مثل Melody API راحت‌تر برای WebSocket می‌دهند؛ Centrifugo نمونهٔ یک سرور realtime/pub-sub جدا است. این دو سطح و deployment متفاوت دارند.

برای realtime این رفتارها را طراحی کن:

- authentication در handshake و authorization هر channel/topic
- محدودیت تعداد connection و اندازهٔ frame/message
- queue محدود برای هر client کند
- backpressure: drop، coalesce، disconnect یا persistence
- heartbeat، reconnect و deduplication
- fanout و scale-out با broker مشترک
- shutdown graceful و بسته‌شدن connectionها
- مراقبت از دادهٔ حساس در eventها

اگر client پیام را کند مصرف کند، buffer نامحدود حافظه را می‌خورد. سیاست کندبودن باید بخشی از قرارداد محصول باشد.

## ۸) تجربهٔ واقعی: Dropbox و ساخت کتابخانه

مقالهٔ خود Dropbox در سال ۲۰۱۴ می‌گوید تیم برای backendهای performance-critical از Python به Go مهاجرت کرد؛ گزارش آن دوره حدود ۲۰۰ هزار خط کد Go و همکاری تیمی کوچک را ذکر می‌کند. همان مقاله از نیازهای کتابخانه‌ای مانند connection management، memcache، caching و SQL builder می‌گوید و تأکید می‌کند شرکت نسخهٔ عمومی repository را در داخل هم مصرف کند تا کیفیت و اصلاحات عمومی با مصرف داخلی هم‌راستا شوند.

این تجربه مربوط به ۲۰۱۴ و اکوسیستم همان زمان است؛ دلیل کافی برای مهاجرت امروز نیست. درس قابل‌انتقال آن، سنجش bottleneck، سرمایه‌گذاری در libraryهای موردنیاز واقعی و یکسان نگه‌داشتن مسیر استفادهٔ داخلی/عمومی است. پیش از انتخاب framework، latency، throughput، operational complexity و تخصص تیم خودت را اندازه بگیر.

## ۹) تصمیم معماری نمونه برای API کاتالوگ

برای API کاتالوگ، یک طرح آغازین می‌تواند این باشد:

- router استاندارد <code>net/http</code> اگر routing پیچیده نیست.
- handler سبک: decode → validate → authentication/authorization → use case → encode.
- repository با interface کوچک در package مصرف‌کننده.
- PostgreSQL با database/sql و driver انتخابی یا pgx؛ queryهای پرتکرار با profile بازبینی شوند.
- <code>slog</code> با request ID، بدون ثبت token.
- RPC فقط برای نیاز واقعی سرویس داخلی یا streaming.
- WebSocket فقط وقتی push دوطرفه نیاز محصول است؛ برای notification ساده شاید SSE یا polling کافی باشد.
- هر تصمیم با latency target، deployment و operational ownership توجیه شود.

این طرح نمونه است، نه blueprint اجباری؛ محصول باید بر اساس نیاز خودش مرزها را انتخاب کند.

## خطاهای رایج

- افزودن framework پیش از روشن‌شدن نیاز.
- فرض اینکه ORM query efficient تولید می‌کند.
- concatenation SQL با ورودی کاربر.
- HTTP client بدون timeout یا context.
- فراموش‌کردن بررسی status و بستن body.
- retry روی operation غیر-idempotent.
- استفاده از gRPC بدون plan برای schema compatibility و observability.
- تصور WebSocket برابر message broker است.
- نگه‌داشتن buffer نامحدود برای realtime client کند.
- logging token و دادهٔ حساس.
- برگزیدن library فقط به‌خاطر محبوبیت یا تعداد star.

## تمرین‌های مرحله‌ای با پاسخ

### تمرین ۱: CLI

یک ابزار مدیریت task داری: create، list، delete. تصمیم بگیر flag ساده کافی است یا command framework لازم.

**پاسخ نمونه:** اگر تنها یک command و چند flag است، <code>flag</code> کافی؛ اگر subcommand، help و completion لازم است، Cobra/urfave را با هزینهٔ dependency و release review مقایسه کن.

### تمرین ۲: database

Query جست‌وجو یک کلمهٔ ورودی دارد. پاسخ: پارامتر placeholder استفاده کن، context و timeout بفرست، Rows را close و Err را بررسی کن. متن user را به SQL concatenate نکن.

### تمرین ۳: client timeout

یک client داخلی به سرویس upstream درخواست می‌زند. پاسخ: deadline caller را از context منتقل کن، client با timeout مناسب بساز، status و body را بررسی، retry را فقط با idempotency و بودجهٔ تلاش انجام بده.

### تمرین ۴: realtime کند

یک client به‌طور پایدار از event عقب می‌ماند. پاسخ: queue bounded، metric برای lag، و policy مشخص مثل drop/coalesce/disconnect/persist. buffer را بی‌سقف بزرگ نکن.

### تمرین ۵: انتخاب RPC

تیم می‌خواهد gRPC انتخاب کند. چه سؤال‌هایی بپرس؟

**پاسخ:** مصرف‌کننده‌ها چه هستند؟ قرارداد و code generation چطور version می‌شوند؟ browser/proxy چه محدودیتی دارد؟ timeout/auth/observability و rollout backward compatibility چگونه مدیریت می‌شود؟ آیا HTTP/JSON نیاز را ساده‌تر حل می‌کند؟

## کوییز

### پرسش‌ها

1. اولین معیار انتخاب کتابخانه چیست؟
2. چه وقت package flag استاندارد کافی است؟
3. چرا command logic را از main جدا می‌کنیم؟
4. آیا HTTP client بدون timeout امن است؟
5. آیا <code>Client.Do</code> برای status code 500 error برمی‌گرداند؟
6. چرا response body را می‌بندیم؟
7. query parameterized چه خطری را کاهش می‌دهد؟
8. database/sql برای اتصال به DB به چه چیز دیگری نیاز دارد؟
9. آیا ORM performance را تضمین می‌کند؟
10. gRPC معمولاً از چه schema/code generation استفاده می‌کند؟
11. چرا field number Protobuf را دوباره استفاده نمی‌کنیم؟
12. slog از کدام نسخه در standard library موجود است؟
13. چه چیزی را نباید در log گذاشت؟
14. WebSocket چه چیزی را به‌تنهایی فراهم نمی‌کند؟
15. client realtime کند را با چه سیاست‌هایی مدیریت می‌کنیم؟
16. Dropbox در مقالهٔ ۲۰۱۴ از چه زمینه‌ای برای مهاجرت Go گفت؟
17. چرا مقالهٔ تاریخی Dropbox دلیل کافی برای انتخاب stack امروز نیست؟
18. چگونه میان REST و gRPC تصمیم می‌گیری؟
19. برای logging چه تفاوتی با metrics و trace وجود دارد؟
20. چه مواردی retry امن RPC را تعیین می‌کنند؟

### کلید پاسخ

1. requirement واقعی و trade-off نگه‌داری.
2. CLI ساده با command و flag محدود.
3. تا domain قابل‌تست باشد و main composition root کوچک بماند.
4. خیر؛ ممکن است انتظار نامحدود/طولانی ایجاد کند، از timeout/context استفاده کن.
5. معمولاً نه؛ پاسخ transport موفق می‌رسد، خودت status را بررسی کن.
6. برای آزادشدن/بازیافت connection و resource.
7. SQL injection.
8. driver سازگار.
9. خیر؛ queryهای ایجادشده و plan را باید بررسی کرد.
10. Protocol Buffers.
11. چون wire compatibility شکسته و دادهٔ قدیمی ممکن است اشتباه decode شود.
12. Go 1.21.
13. token، password، secret، PII و payload حساس.
14. durable queue، broker، persistence یا fanout cluster.
15. محدودکردن buffer و drop/coalesce/disconnect/persist بر اساس محصول.
16. مقیاس‌دادن کارایی backendهای حساس و سرعت execution/concurrency؛ مقاله تاریخی می‌گوید.
17. workload و ecosystem آن دوره با نیاز و نسخهٔ امروز فرق دارد.
18. مصرف‌کننده‌ها، streaming، compatibility، tooling و عملیاتی‌کردن را مقایسه کن.
19. log رخداد متنی ساخت‌یافته؛ metric رفتار تجمیعی؛ trace مسیر درخواست میان سرویس‌ها را نشان می‌دهد.
20. idempotency، deadline، retry budget، backoff/jitter و semantics خطا.

## منابع و تجربه‌های بیشتر

- انگلیسی: [Go net/http](https://pkg.go.dev/net/http)
- انگلیسی: [gRPC for Go](https://grpc.io/docs/languages/go/)
- انگلیسی: [Protocol Buffers](https://protobuf.dev/)
- انگلیسی: [database/sql](https://pkg.go.dev/database/sql)
- انگلیسی: [pgx](https://github.com/jackc/pgx)
- انگلیسی: [GORM](https://gorm.io/)
- انگلیسی: [Go slog](https://pkg.go.dev/log/slog)
- انگلیسی: [Cobra CLI](https://cobra.dev/)
- تجربهٔ مستند: [Dropbox — Open Sourcing Our Go Libraries (2014)](https://dropbox.tech/infrastructure/open-sourcing-our-go-libraries)
- تجربهٔ Go در محصولات شبکه‌ای: [Cloudflare — Do you want to work with Go?](https://blog.cloudflare.com/do-you-want-to-work-with-go/)
- مجموعهٔ مطالعهٔ موردی: [Go case studies](https://go.dev/solutions/case-studies)
- فارسی: [GoFarsi — اکوسیستم و طراحی پروژه](https://cloud-book.gofarsi.ir/chapter-5/)
- فارسی: [GoFarsi — module و پروژه](https://cloud-book.gofarsi.ir/chapter-4/)



**نسخهٔ انگلیسی:** [مطالعهٔ این صفحه به انگلیسی](../../../../en/go/12-%D8%A7%DA%A9%D9%88%D8%B3%DB%8C%D8%B3%D8%AA%D9%85/01-%DA%A9%D8%AA%D8%A7%D8%A8%D8%AE%D8%A7%D9%86%D9%87-%D9%87%D8%A7%DB%8C-%D8%A7%DA%A9%D9%88%D8%B3%DB%8C%D8%B3%D8%AA%D9%85/README.md)
</div>
