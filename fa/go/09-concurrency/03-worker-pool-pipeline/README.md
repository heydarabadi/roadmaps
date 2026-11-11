# ۹.۳ — worker pool و pipeline

<div dir="rtl">

**زمان پیشنهادی:** ۱۸۰ دقیقه · **پیش‌نیاز:** goroutine، channel، context، WaitGroup و error  
**هدف:** throughput را محدود و قابل‌کنترل کنی، مسئولیت close را روشن نگه داری و نتیجهٔ کارهای هم‌زمان را بدون goroutine leak جمع کنی.

## نقشهٔ این درس

- چرا worker pool
- queue محدود و backpressure
- pipeline و مالکیت stageها
- fan-out و fan-in
- cancellation و error
- جمع‌آوری نتیجهٔ بدون ترتیب
- ظرفیت و اندازه‌گیری
- shutdown و partial result

## ۱) چرا تعداد goroutine را محدود کنیم؟

ساخت یک goroutine برای هر ورودی آسان است، اما وقتی ورودی خیلی زیاد شود، مصرف حافظه، connection، file descriptor و فشار downstream هم زیاد می‌شود. Worker pool تعداد goroutineهای فعال را محدود می‌کند؛ صف محدود هم مشخص می‌کند چه زمانی producer باید منتظر بماند یا ورودی را رد کند.

محدودیت worker تعداد اجرای هم‌زمان را کنترل می‌کند، نه الزاماً نرخ درخواست در ثانیه را. اگر downstream rate limit دارد، ممکن است limiter جدا لازم شود. اندازهٔ pool را با latency، CPU، محدودیت سرویس وابسته و بار واقعی انتخاب کن، نه با عدد جادویی.

## ۲) معماری pool

- Producer ورودی‌ها را روی <code>jobs</code> می‌فرستد.
- Workerها از همان channel دریافت می‌کنند؛ هر job توسط یکی از workerها پردازش می‌شود.
- Worker نتیجه را روی <code>results</code> می‌فرستد.
- هماهنگ‌کننده پس از پایان producer و workerها channelهای خروجی را درست می‌بندد.
- Caller خروجی را تا پایان stream تخلیه می‌کند.
- Context مسیر لغو را به producer و worker می‌رساند.

قانون کلیدی: هر channel یک owner برای close داشته باشد. Producer مالک close کردن jobs است؛ هماهنگ‌کننده که همهٔ workerها را join کرده مالک بستن results است.

## ۳) مثال کامل: pool محدود، cancellation و نتیجه

این نمونهٔ مستقل خروجی‌ها را به ترتیب اتمام برمی‌گرداند، نه ترتیب ورودی. اگر context لغو شود، نتیجه‌های انجام‌شده ممکن است برگردند و خطای context جداگانه گزارش شود.

</div>

~~~go
package main

import (
	"context"
	"errors"
	"fmt"
	"sync"
)

type Job struct {
	ID    int
	Value int
}

type Result struct {
	JobID int
	Value int
	Err   error
}

func process(ctx context.Context, job Job) Result {
	select {
	case <-ctx.Done():
		return Result{JobID: job.ID, Err: ctx.Err()}
	default:
	}

	// در این نمونه پردازش CPU کوتاه و قطعی است.
	return Result{JobID: job.ID, Value: job.Value * 2}
}

func Run(ctx context.Context, input []Job, workerCount int) ([]Result, error) {
	if workerCount <= 0 {
		return nil, errors.New("workerCount باید مثبت باشد")
	}
	if len(input) == 0 {
		return nil, nil
	}

	jobs := make(chan Job)
	results := make(chan Result)
	var workers sync.WaitGroup

	for i := 0; i < workerCount; i++ {
		workers.Add(1)
		go func() {
			defer workers.Done()
			for {
				select {
				case <-ctx.Done():
					return
				case job, ok := <-jobs:
					if !ok {
						return
					}
					result := process(ctx, job)
					select {
					case results <- result:
					case <-ctx.Done():
						return
					}
				}
			}
		}()
	}

	go func() {
		defer close(jobs)
		for _, job := range input {
			select {
			case jobs <- job:
			case <-ctx.Done():
				return
			}
		}
	}()

	go func() {
		workers.Wait()
		close(results)
	}()

	var completed []Result
	for result := range results {
		completed = append(completed, result)
	}

	if err := ctx.Err(); err != nil {
		return completed, err
	}
	return completed, nil
}

func main() {
	input := []Job{
		{ID: 1, Value: 12},
		{ID: 2, Value: 20},
		{ID: 3, Value: 7},
	}
	results, err := Run(context.Background(), input, 2)
	if err != nil {
		fmt.Println("pool stopped:", err)
		return
	}
	for _, result := range results {
		fmt.Printf("job=%d value=%d\n", result.JobID, result.Value)
	}
}
~~~

<div dir="rtl">

### کالبدشکافی کد

1. ورودی workerCount پیش از ایجاد goroutine اعتبارسنجی می‌شود.
2. producer تنها sender jobs است؛ پس خودش پس از اتمام یا cancellation channel را close می‌کند.
3. هر worker پس از خروج <code>Done</code> را فراخوانی می‌کند.
4. فقط goroutine هماهنگ‌کننده پس از <code>workers.Wait()</code> results را می‌بندد؛ در نتیجه send پس از close اتفاق نمی‌افتد.
5. مصرف‌کننده تا بسته‌شدن results آن را می‌خواند؛ بنابراین worker روی send نتیجه گیر نمی‌کند.
6. producer و worker هر دو cancellation را می‌بینند.
7. <code>process</code> نمونه عمداً کار طولانی ندارد. پردازش واقعی باید context را به I/O بدهد یا در loopهای CPU-bound مرتب بررسی کند؛ در غیر این صورت cancellation فوری نیست.
8. اگر لغو پیش بیاید، همهٔ ورودی‌ها پردازش نشده‌اند. تابع نتیجه‌های تکمیل‌شده را همراه با error برمی‌گرداند؛ caller باید با partial result چه کند را تعیین کند.
9. این pool ترتیب results را حفظ نمی‌کند. اگر ترتیب مهم است، index ورودی را همراه Job بفرست و در caller نتیجه را در جایگاه همان index قرار بده.

## ۴) ظرفیت queue و backpressure

در مثال jobs channel بدون buffer است؛ producer وقتی همهٔ workerها مشغول‌اند منتظر می‌ماند. این backpressure طبیعی است. اگر queue با ظرفیت محدود بسازی، producer تا پرشدن آن جلو می‌رود. اندازهٔ ظرفیت باید از latency و حافظهٔ قابل‌قبول پیروی کند. buffer بی‌نهایت واقعی نیست؛ صف بزرگ فقط شکست را دیرتر نشان می‌دهد و latency را بالا می‌برد.

در سامانهٔ آنلاین گاهی producer نباید block شود؛ ممکن است لازم باشد کار را reject کند، محدود کند یا به صف پایدار بیرونی بسپارد. این تصمیم دامنه و قرارداد سرویس است.

## ۵) Pipeline

Pipeline چند stage را با channel به هم وصل می‌کند: stage اول تولید، stage میانی transform و stage پایانی consume می‌کند. هر stage ورودی را می‌خواند و خروجی خودش را می‌بندد. وقتی downstream زودتر تمام می‌شود، upstream باید از context یا signal خروج استفاده کند؛ وگرنه روی ارسال block و نشت می‌کند.

یک channel میان هر دو stage ساده است، اما خطا و cancellation را فراموش نکن. اگر stage میانی خطا داد، آیا بقیهٔ ورودی‌ها را drain می‌کند؟ آیا cancel می‌کند؟ آیا partial output قابل‌قبول است؟ این‌ها باید طراحی شوند، نه به امید close خودکار بمانند.

### Fan-out و fan-in

Fan-out یک ورودی job را میان چند worker تقسیم می‌کند؛ Fan-in خروجی چند channel را در یک channel جمع می‌کند. هر مرحله باید راه cancellation داشته باشد و channel خروجی خودش را ببندد:

~~~go
func squareStage(ctx context.Context, input <-chan int) <-chan int {
	output := make(chan int)
	go func() {
		defer close(output)
		for {
			select {
			case <-ctx.Done():
				return
			case value, ok := <-input:
				if !ok {
					return
				}
				select {
				case output <- value * value:
				case <-ctx.Done():
					return
				}
			}
		}
	}()
	return output
}

func fanOut(ctx context.Context, input <-chan int, count int) []<-chan int {
	outputs := make([]<-chan int, count)
	for i := range count {
		outputs[i] = squareStage(ctx, input)
	}
	return outputs
}

func fanIn(ctx context.Context, inputs ...<-chan int) <-chan int {
	output := make(chan int)
	var wg sync.WaitGroup

	for _, input := range inputs {
		wg.Add(1)
		go func(source <-chan int) {
			defer wg.Done()
			for {
				select {
				case <-ctx.Done():
					return
				case value, ok := <-source:
					if !ok {
						return
					}
					select {
					case output <- value:
					case <-ctx.Done():
						return
					}
				}
			}
		}(input)
	}

	go func() {
		wg.Wait()
		close(output)
	}()
	return output
}
~~~

این مثال از integer range استفاده می‌کند که از Go 1.22 است؛ برای module قدیمی loop سه‌بخشی <code>for i := 0; i &lt; count; i++</code> بنویس. ورودی fanOut میان workerها تقسیم می‌شود، broadcast نمی‌شود؛ هر مقدار را یکی از workerها می‌گیرد. fanIn فقط پس از تمام‌شدن همهٔ readerها خروجی را می‌بندد. اگر consumer زودتر تمام شد، cancel را صدا بزن؛ در غیر این صورت stageها ممکن است روی send بمانند. برای count صفر، هیچ outputی ساخته نمی‌شود و fanIn خروجی خالی می‌بندد.
## ۶) ظرفیت pool را چگونه انتخاب کنیم؟

- CPU-bound: تعداد workerها را با ظرفیت CPU و profiling شروع کن.
- I/O-bound: محدودیت connection/downstream و timeoutها مهم‌تر از تعداد core است.
- external API: rate limit و retry budget رعایت شود.
- کارهای ناهمگن: یک job خیلی کند می‌تواند tail latency ایجاد کند.
- memory-bound: queue، input buffering و result accumulation را اندازه بگیر.
- نیاز throughput ثابت: علاوه بر worker limit، rate limiter و SLO latency لازم می‌شود.

این‌ها نقطهٔ شروع‌اند؛ مقدار نهایی را با benchmark و دادهٔ production تنظیم کن. برای fairness و cancellation، به مدت نگهداری lock یا صف نیز نگاه کن.

## خطاهای رایج

- یک goroutine برای هر ورودی بدون concurrency limit.
- فراموش‌کردن WaitGroup یا بستن result channel پیش از پایان workerها.
- بستن jobs از worker/consumer.
- تولید نتیجه بدون مصرف‌کننده و گیرکردن worker.
- cancellation فقط در caller، بدون انتقال به producer و worker.
- نادیده‌گرفتن اینکه processor روی I/O ممکن است cancellation را رعایت نکند.
- فرض اینکه نتیجه‌ها به ترتیب ورودی می‌رسند.
- انتخاب queue بزرگ برای پوشاندن downstream کند.
- دورریختن partial result بدون قرارداد.
- افزایش worker count بدون توجه به rate limit وابستگی.

## تمرین‌های مرحله‌ای با پاسخ

### تمرین ۱: ترتیب ورودی

نتیجه‌ها باید در همان ترتیب jobs برگردند. چه تغییری می‌دهی؟

**پاسخ:** index را در Job بگذار. یک slice نتیجه با اندازهٔ ورودی بساز و هر worker نتیجهٔ همان index را در جایگاه جدا بنویسد؛ پس از join slice را برگردان. هر index فقط یک writer داشته باشد و slice پس از Wait خوانده شود. یا نتیجه‌ها را جمع کن و پس از پایان بر اساس ID مرتب کن.

### تمرین ۲: worker خطاپذیر

process ممکن است خطا بدهد. آیا pool باید فوراً لغو کند یا خطای همان job را ثبت و ادامه دهد؟

**پاسخ:** به semantics batch بستگی دارد. برای job مستقل، error را داخل Result بگذار و بقیه را ادامه بده. اگر هر شکست کار باقی‌مانده را بی‌معنی می‌کند، child context را cancel کن و اولین خطا را به‌صورت هماهنگ گزارش کن.

### تمرین ۳: queue محدود

یک صف با ظرفیت ۵ بساز و توضیح بده اگر producer از consumer سریع‌تر باشد چه می‌شود.

**پاسخ:** تا پنج job buffer می‌شوند؛ سپس producer در send متوقف می‌شود تا worker دریافت کند. این backpressure حافظه را محدود می‌کند.

### تمرین ۴: shutdown

چه تضمینی لازم است تا بعد از Run goroutine باقی نماند؟

**پاسخ:** producer باید تمام شود/بسته شود؛ workerها باید cancellation یا پایان jobs را ببینند؛ results consumer تا close تخلیه کند؛ هماهنگ‌کننده Wait کند و channel را بعد از پایان senderها ببندد. عملیات blocking باید خودش context-aware باشد.

## کوییز

### پرسش‌ها

1. worker pool چه منبعی را محدود می‌کند؟
2. آیا محدودیت worker به معنی محدودیت نرخ درخواست است؟
3. چه کسی jobs را می‌بندد؟
4. چه کسی results را می‌بندد؟
5. چرا results تا پایان workerها باز می‌ماند؟
6. channel بدون buffer در این نمونه چه نقشی دارد؟
7. backpressure چیست؟
8. چرا queue خیلی بزرگ می‌تواند مشکل را پنهان کند؟
9. ترتیب نتیجهٔ این نمونه چگونه است؟
10. برای حفظ ترتیب چه اطلاعاتی لازم است؟
11. آیا cancellation تابع processor را به زور متوقف می‌کند؟
12. partial result یعنی چه؟
13. چه وقت fail-fast مناسب است؟
14. برای API محدود نرخ چه سازوکاری جز worker limit ممکن است لازم باشد؟
15. چرا caller تا بسته‌شدن results آن را می‌خواند؟
16. چه چیزی جلوی goroutine leak هنگام توقف downstream را می‌گیرد؟
17. Fan-out این مثال broadcast می‌کند یا ورودی را میان workerها تقسیم می‌کند؟
18. چه کسی channel خروجی fan-in را می‌بندد و چرا؟

### کلید پاسخ

1. تعداد پردازش‌های هم‌زمان.
2. خیر؛ rate limiter جدا ممکن است لازم باشد.
3. producer که تنها مالک ارسال است.
4. هماهنگ‌کننده پس از Wait برای همهٔ workerها.
5. تا هیچ workerی پس از close send نکند.
6. در نبود worker آماده، producer را block می‌کند و فشار را به عقب منتقل می‌کند.
7. کندشدن/توقف producer متناسب با ظرفیت consumer به‌جای انباشتن نامحدود کار.
8. حافظه و latency را بالا می‌برد و overload را دیرتر آشکار می‌کند.
9. ترتیب اتمام workerها، غیرقطعی.
10. index ورودی یا ID و مرحلهٔ مرتب‌سازی.
11. خیر؛ processor باید cancellation را بررسی یا به I/O منتقل کند.
12. نتیجهٔ بخشی از کارها تا زمان لغو/خطا.
13. وقتی با یک failure، بقیهٔ کار دیگر معتبر یا مفید نیست.
14. rate limiter، token bucket یا صف پایدار با policy.
15. تا sendها block نشوند و نتایج تکمیل‌شده drain شوند.
16. cancellation، selectهای cancellable، انتظار و close با مالکیت روشن.
17. هر مقدار را یکی از workerها می‌گیرد؛ broadcast نیست.
18. هماهنگ‌کننده بعد از WaitGroup؛ تا هیچ senderی پس از close نفرستد.

## منابع

- انگلیسی: [Go blog — Pipelines and cancellation](https://go.dev/blog/pipelines)
- انگلیسی: [Go package sync](https://pkg.go.dev/sync)
- انگلیسی: [Go package context](https://pkg.go.dev/context)
- انگلیسی: [Go Blog — Context](https://go.dev/blog/context)
- فارسی: [GoFarsi — Goroutine و channel](https://book.gofarsi.ir/chapter-3/goroutine/)
- فارسی: [GoFarsi — concurrency](https://cloud-book.gofarsi.ir/chapter-3/)



**نسخهٔ انگلیسی:** [مطالعهٔ این صفحه به انگلیسی](README.en.md)
</div>
