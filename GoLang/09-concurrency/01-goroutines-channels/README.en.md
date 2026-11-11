# 9.1 — Goroutines, channels, and select

<div dir="ltr">

**Time:** 150 minutes · **Prerequisite:** functions and error handling  
**Goal:** Start concurrent work, communicate through channels, and design cancellation and channel closure deliberately.

## Goroutines are concurrent tasks

A goroutine is a lightweight execution unit scheduled by the Go runtime. Creating one is easy; owning its lifetime is the design responsibility.

~~~go
go func() {
    doWork()
}()
~~~

The program may exit while a goroutine is still running. A goroutine that blocks forever can retain memory and request data. Every goroutine should have a clear owner, completion condition, and cancellation path.

## Channels communicate values

~~~go
jobs := make(chan int)
go func() {
    jobs <- 42
    close(jobs)
}()

job := <-jobs
fmt.Println(job)
~~~

An unbuffered channel synchronizes send and receive. A buffered channel can queue a bounded number of values before send blocks. Buffer capacity should represent a deliberate queue budget, not hide a slow consumer.

Sending to a closed channel panics. Receiving from a closed channel returns the element type’s zero value immediately; the two-result receive distinguishes a closed channel from a real zero value. A receiver normally should not close a channel it did not produce.

## select

select waits for one of several channel operations:

~~~go
select {
case value := <-results:
    use(value)
case <-ctx.Done():
    return ctx.Err()
}
~~~

If several cases are ready, Go chooses one pseudo-randomly. Do not assume a priority order. A default case makes select non-blocking and can create a busy loop if used without care.

## Ownership and cancellation

A safe design answers:

- Who sends to this channel?
- Who closes it, and after all senders finish?
- Who receives and drains remaining values?
- What happens when the caller cancels?
- Can a send block forever if no receiver remains?

Use context cancellation or an explicit done channel to stop work. Sending or receiving from a channel is not itself a cancellation policy.

## Common mistakes

- Launching a goroutine and never waiting for it or canceling it.
- Closing a channel while a sender may still send.
- Multiple goroutines closing the same channel.
- Using an unbounded number of goroutines for untrusted input.
- Assuming a buffered channel prevents deadlocks.
- Adding default to select and accidentally spinning.
- Forgetting that a closed channel continuously returns zero values.

## Guided practice with answers

**1. What is the difference between an unbuffered and buffered channel?**  
An unbuffered send pairs with a receiver; a buffered channel allows a bounded queue before send blocks.

**2. Who should close a jobs channel?**  
The producer or coordinator that knows no more jobs will be sent.

**3. How can a worker stop waiting when its request is canceled?**  
Select between the work channel and ctx.Done, and pass the context into blocking operations.

## Quiz

### Questions

1. What schedules goroutines?
2. Does starting a goroutine guarantee the program waits for it?
3. What synchronization does an unbuffered send provide?
4. What is a buffered channel’s capacity?
5. What happens when sending to a closed channel?
6. What does receiving from a closed channel return?
7. How do you distinguish a closed channel from a sent zero value?
8. What does select do?
9. Is select case order a priority rule?
10. Who should normally close a producer channel?
11. What must a goroutine’s lifecycle have?
12. Why can an unbounded goroutine count be dangerous?

### Answer key

1. The Go runtime scheduler.
2. No.
3. It waits for a matching receiver.
4. The number of queued values before send blocks.
5. It panics.
6. The element type’s zero value immediately.
7. Use the two-result receive form.
8. Waits for one ready channel operation.
9. No; selection among ready cases is pseudo-random.
10. The sender or coordinator that knows sending is finished.
11. An owner, completion condition, and cancellation path.
12. It can exhaust memory, sockets, and downstream capacity.

## References and further reading

- [Effective Go: concurrency](https://go.dev/doc/effective_go#concurrency)
- [Go specification: go statements](https://go.dev/ref/spec#Go_statements)
- [Go specification: channel types](https://go.dev/ref/spec#Channel_types)
- [Go specification: select statements](https://go.dev/ref/spec#Select_statements)
- [Go blog: Go concurrency patterns](https://go.dev/blog/pipelines)
- [Go blog: timing out, moving on](https://go.dev/blog/concurrency-timeouts)
- [Go memory model](https://go.dev/ref/mem)
- [Go blog: share memory by communicating](https://go.dev/blog/codelab-share)

[Persian version](README.md) · [Next: sync and context](../02-sync-context/README.en.md)

</div>