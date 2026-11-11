# ۴.۱ — حلقه‌ها و range

<div dir="rtl">

**زمان:** ۹۰ دقیقه · **پیش‌نیاز:** slice، map، شرط · **هدف:** collectionها را درست پیمایش کنی و پایان/ادامهٔ حلقه را کنترل کنی.

## ۱) همهٔ حلقه‌ها با for ساخته می‌شوند

Go حلقهٔ سه‌بخشی، شرطی شبیه while و حلقهٔ بی‌نهایت را با یک keyword می‌سازد.

</div>

~~~go
for i := 0; i < 3; i++ {
	fmt.Println(i)
}

n := 3
for n > 0 {
	n--
}

for {
	select {
	case job := <-jobs:
		process(job)
	case <-ctx.Done():
		return
	}
}
~~~

<div dir="rtl">

در حلقهٔ سه‌بخشی initializer یک بار اجرا می‌شود؛ شرط پیش از هر دور بررسی می‌شود؛ سپس body و post statement اجرا می‌شوند. شرطی مثل <code>for n &gt; 0</code> رفتاری شبیه while دارد. حلقهٔ بی‌نهایت باید با break، return یا cancellation پایان یابد.

## ۲) range روی collectionها

<code>range</code> بسته به نوع collection جفت مقدار می‌دهد:

- array/slice: index و value کپی‌شده.
- map: key و value کپی‌شده؛ ترتیب نامشخص.
- string: byte index و rune.
- channel: مقدار دریافتی تا بسته‌شدن channel.
- integer: تعداد دور؛ این فرم از Go 1.22 است و module باید همان language version را فعال کند.

اگر یک خروجی لازم نیست، از blank identifier استفاده کن. برای پیمایش elementهای slice بدون index، <code>for _, item := range items</code> بنویس. مقدار range کپی است؛ برای تغییر element با index در slice بنویس.

</div>

~~~go
for i := range names {
	fmt.Println(i, names[i])
}
for _, name := range names {
	fmt.Println(name)
}
~~~

<div dir="rtl">

Map order تضمین ندارد. برای گزارش مرتب، keyها را در slice کپی کن، sort کن و بعد بخوان. برای string، index بر حسب byte است و rune ممکن است چند byte مصرف کند.

## ۳) break و continue

<code>continue</code> بدنهٔ دور فعلی را متوقف و دور بعد را شروع می‌کند. <code>break</code> از نزدیک‌ترین loop یا switch خارج می‌شود. برای loop تو در تو label ممکن است:

</div>

~~~go
outer:
for row := 0; row < 3; row++ {
	for col := 0; col < 3; col++ {
		if row == col {
			continue
		}
		if row+col == 3 {
			break outer
		}
	}
}
~~~

<div dir="rtl">

Label برای خروج از loop بیرونی مفید است، ولی در منطق طولانی تابع کمکی معمولاً واضح‌تر است. <code>goto</code> وجود دارد اما الگوی عادی نیست و پرش میان scopeها محدودیت دارد.

## ۴) loop variable، goroutine و نسخه

از Go 1.22، متغیر loop که با <code>:=</code> اعلان می‌شود برای هر iteration تازه است، مشروط به اینکه go directive module برابر 1.22 یا بالاتر باشد. متغیری که قبلاً اعلان شده و در loop با <code>=</code> مقدار می‌گیرد همچنان reuse می‌شود. هنگام خواندن کد قدیمی go.mod را بررسی کن.

</div>

~~~go
for _, item := range items {
	go func(value string) {
		fmt.Println(value)
	}(item)
}
~~~

<div dir="rtl">

پارامتر تابع anonymous مقدار را در زمان راه‌اندازی کپی می‌کند و capture را صریح می‌سازد. goroutineها تضمین ترتیب اجرا ندارند؛ برای جمع‌آوری نتیجه و shutdown باید WaitGroup/channel/context مناسب داشته باشی.

## مثال کامل: فیلتر

</div>

~~~go
package main

import "fmt"

func positive(values []int) []int {
	result := make([]int, 0, len(values))
	for _, value := range values {
		if value <= 0 {
			continue
		}
		result = append(result, value)
	}
	return result
}

func main() {
	fmt.Println(positive([]int{-2, 0, 3, 5}))
}
~~~

<div dir="rtl">

خروجی <code>[3 5]</code> است. result با capacity ورودی ساخته شده تا احتمال resize کمتر شود؛ برای هر مجموعهٔ کوچک لازم نیست زودهنگام optimize کنی.

## خطاهای رایج

- index باید از صفر تا len منهای یک باشد.
- map را مرتب فرض می‌کنی.
- range value را تغییر می‌دهی و انتظار تغییر عنصر اصلی را داری.
- حلقهٔ worker را بدون cancellation یا limit رها می‌کنی.
- goroutineها را راه می‌اندازی اما نتیجه/خطا را جمع نمی‌کنی.
- دربارهٔ loop variable بدون بررسی نسخهٔ go.mod نتیجه می‌گیری.

## تمرین با پاسخ

**۱.** مجموع عددهای مثبت را بگیر و صفر/منفی را رد کن.

~~~go
sum := 0
for _, n := range values {
	if n <= 0 {
		continue
	}
	sum += n
}
~~~

**۲.** اولین نام غیرخالی را پیدا کن.

~~~go
found := ""
for _, name := range names {
	if strings.TrimSpace(name) == "" {
		continue
	}
	found = name
	break
}
~~~

**۳.** map را deterministic چاپ کن.

پاسخ: keyها را به slice جمع کن، <code>sort.Strings</code> اجرا کن و با ترتیب slice مقدارها را چاپ کن.

## کوییز

### پرسش‌ها

1. ترتیب بخش‌های for سه‌بخشی چیست؟
2. آیا Go حلقهٔ while مستقل دارد؟
3. range روی string چه index و value می‌دهد؟
4. ترتیب range روی map چه تضمینی دارد؟
5. continue چه می‌کند؟
6. break بدون label از کدام loop خارج می‌شود؟
7. چرا range value برای تغییر عنصر slice مناسب نیست؟
8. چه شرطی برای semantics جدید loop variable لازم است؟
9. آیا goroutineهای یک loop خروجی را به همان ترتیب می‌دهند؟
10. چرا worker بی‌نهایت cancellation لازم دارد؟
11. integer range در کدام نسخه افزوده شد؟
12. چه وقت label بدخواناتر از تابع کمکی است؟

### کلید پاسخ

1. initializer، condition، body، post؛ condition پیش از هر دور بررسی می‌شود.
2. خیر؛ for با شرط همان نقش را دارد.
3. index بر حسب byte و مقدار rune.
4. هیچ ترتیب ثابتی.
5. باقی بدنهٔ این دور را رد و دور بعد را آغاز می‌کند.
6. نزدیک‌ترین loop یا switch.
7. چون value کپی است؛ برای mutation از index استفاده کن.
8. go directive حداقل 1.22 و اعلان variable در خود loop با <code>:=</code>.
9. خیر.
10. تا سرویس قابل توقف باشد و goroutine نشت نکند.
11. Go 1.22.
12. وقتی labelهای زیاد مسیر اجرا را نامفهوم می‌کنند.

## منابع

- [Tour: flow control](https://go.dev/tour/flowcontrol/1)
- [Go blog: loop variable semantics](https://go.dev/blog/loopvar-preview)
- فارسی: [GoFarsi — حلقه و شرط](https://cloud-book.gofarsi.ir/chapter-1/)
- فارسی: [Tarhche — حلقه‌ها](https://tarhche.com/fa/articles/018fabef-c30e-7e5a-9e5d-65c3bf0a4c7b)



**نسخهٔ انگلیسی:** [مطالعهٔ این صفحه به انگلیسی](README.en.md)
</div>
