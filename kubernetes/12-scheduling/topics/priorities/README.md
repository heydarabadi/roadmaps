<div dir="rtl" align="right">
نسخهٔ انگلیسی: [English](README.en.md) · [کتابخانهٔ منابع](../../../references/README.md#12-scheduling)

# Pod Priority و Preemption

**فصل:** [Scheduling](../../README.md)

## اهمیت و اثر

PriorityClass عدد اولویت را به Pod می‌دهد. اگر هیچ node مناسبی برای Pod با اولویت بالا نباشد، scheduler ممکن است Podهای کم‌اولویت را از node بیرون کند تا جا باز شود. مقدار بالاتر capacity جدید تولید نمی‌کند؛ فقط ترتیب و preemption را تغییر می‌دهد.

برای jobهای آزمایشی اولویت پایین و سرویس حیاتی اولویت بالاتر ممکن است معقول باشد، اما هر تیم می‌تواند ادعای critical بودن کند. نام‌گذاری، owner و policy تخصیص PriorityClass را مدیریت کنید. preemption ممکن است کار دیگران را قطع کند؛ PDB روی نتیجه و امکان eviction اثر دارد.

## کوییز

1. PriorityClass برای چیست؟ — تعیین اهمیت نسبی Pod و امکان preemption.
2. آیا priority بالا node اضافه می‌کند؟ — خیر.
3. چرا اولویت باید حاکمیت شود؟ — سوءاستفاده می‌تواند workloadهای دیگر را بیرون کند.
4. preemption همیشه موفق است؟ — نه؛ قیدها، PDB و نبود candidate مناسب مانع می‌شوند.

## منابع

- [Pod Priority and Preemption](https://kubernetes.io/docs/concepts/scheduling-eviction/pod-priority-preemption/)
- [Pod Disruptions](https://kubernetes.io/docs/concepts/workloads/pods/disruptions/)

</div>