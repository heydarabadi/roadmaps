# 9.3 — Worker pools, fan-in, fan-out, and pipelines

<div dir="ltr">

**Time:** 150 minutes · **Prerequisite:** channels, WaitGroup, and context  
**Goal:** Bound concurrent work, connect processing stages, and close each channel only after its senders are done.

## Worker pool

A worker pool uses a fixed number of goroutines to process a larger stream of jobs. It limits concurrent resource use and gives a place to apply backpressure.

~~~go
jobs := make(chan Job)
results := make(chan Result)

for i := 0; i < workerCount; i++ {
    go worker(ctx, jobs, results)
}
~~~

The sketch leaves out coordination on purpose: someone must produce jobs, wait for every worker, close results, and stop workers when context is canceled. Do not start one goroutine per untrusted input by default.

## Fan-out and fan-in

Fan-out distributes jobs to multiple workers. Fan-in combines their outputs into a single stream. These patterns are useful when tasks are independent and the downstream stage can handle the resulting concurrency.

The output order may differ from input order. Attach an index or request ID if stable ordering is required. Protect shared state or, preferably, let one collector own the result slice.

## Pipelines and backpressure

A pipeline connects stages through channels:

~~~text
source -> parse -> validate -> process -> sink
~~~

Each stage must define how it exits when downstream stops. If the sink returns early while an upstream stage is blocked sending, cancellation must unblock that send. Buffered channels absorb a bounded burst; they do not make a pipeline infinitely fast.

Backpressure is the signal that a consumer cannot keep up. Propagate the slowdown or reject work according to product policy rather than accumulating unbounded memory.

## Channel closure and completion

Only close a channel after all senders are finished. A coordinator can wait for workers, then close a shared results channel. Closing a channel is a broadcast that no further values will be sent; it is not a way to cancel workers by itself.

~~~go
go func() {
    workerGroup.Wait()
    close(results)
}()
~~~

The producer typically closes jobs when it has submitted all work. The coordinator closes results after every result sender has finished.

## Integer range in newer Go

Go 1.22 introduced integer range syntax, which is available when the module language version enables it:

~~~go
for index := range 5 {
    fmt.Println(index)
}
~~~

This iterates 0 through 4. It is not a broadcast mechanism; each job still needs an explicit send or shared job source.

## Common mistakes

- Creating an unbounded number of workers.
- Closing results before workers finish sending.
- Having several goroutines close the same channel.
- Returning early without canceling upstream stages.
- Sharing a result slice among workers without synchronization.
- Assuming output order matches input order.
- Using a large buffer to hide permanent overload.

## Guided practice with answers

**1. The consumer stops after the first result. What should upstream stages do?**  
Receive cancellation or a done signal, stop accepting jobs, and exit so blocked sends can complete.

**2. How do you preserve input order when workers finish out of order?**  
Carry each job’s index in its result and let one collector place the result in the matching slot.

**3. Who closes the results channel?**  
A coordinator after all worker senders have completed.

## Quiz

### Questions

1. What resource does a fixed worker pool bound?
2. What is fan-out?
3. What is fan-in?
4. Does a worker pool preserve result order automatically?
5. What is a pipeline?
6. What does backpressure communicate?
7. Does a buffer eliminate overload?
8. Who should close a channel with multiple senders?
9. Why should results close after workers finish?
10. Does closing a channel cancel a worker?
11. What can happen if a sink returns early?
12. How can early return be propagated upstream?
13. How can the collector preserve input order?
14. What does integer range over 5 iterate in Go 1.22+?
15. Is integer range a broadcast?
16. Why is a very large buffer risky?
17. Why should one collector own a shared result slice?
18. What can happen if each input starts its own goroutine?

### Answer key

1. Concurrent jobs and associated resources.
2. Distributing work among consumers.
3. Combining several outputs into one stream.
4. No; completion timing may differ.
5. A sequence of processing stages connected by data flow.
6. That a downstream consumer cannot keep up.
7. No; it only absorbs a finite amount of work.
8. A coordinator that knows all senders are finished.
9. No sender should remain that can write to the channel.
10. No.
11. Upstream goroutines may block forever trying to send.
12. Cancellation or an explicit done channel.
13. Carry input indexes and store results by index.
14. Integer values 0 through 4.
15. No.
16. It can retain large amounts of memory and delay overload signals.
17. It avoids concurrent writes to shared state.
18. Resource exhaustion or unbounded downstream pressure.

## References and further reading

- [Go blog: pipelines and cancellation](https://go.dev/blog/pipelines)
- [Effective Go: concurrency](https://go.dev/doc/effective_go#concurrency)
- [Go specification: channel types](https://go.dev/ref/spec#Channel_types)
- [Go specification: range clauses](https://go.dev/ref/spec#For_range)
- [Go memory model](https://go.dev/ref/mem)
- [errgroup package](https://pkg.go.dev/golang.org/x/sync/errgroup)
- [context package](https://pkg.go.dev/context)
- [Go 1.22 release notes](https://go.dev/doc/go1.22#language)

[Persian version](README.md) · [Next: race detection](../04-race-detector/README.en.md)

</div>