# 9.4 — Data races and the race detector

<div dir="ltr">

**Time:** 120 minutes · **Prerequisite:** goroutines, synchronization, and tests  
**Goal:** Distinguish a data race from a broader race condition and use the detector as evidence during testing.

## Data race and race condition

A data race occurs when goroutines access the same memory location concurrently, at least one access is a write, and the accesses are not synchronized. It can produce undefined or surprising behavior under the Go memory model.

A race condition is broader: correctness depends on timing or ordering. A program may have a race condition without a low-level data race, for example when two individually synchronized operations occur in the wrong business order.

## Protect shared state

Use a mutex, atomic operation, channel ownership, or another synchronization rule consistently.

~~~go
type Cache struct {
    mu   sync.RWMutex
    data map[string]string
}
~~~

The synchronization must cover the entire invariant. Locking only the map lookup but not the related update may still allow inconsistent state.

## Run the race detector

~~~powershell
go test -race ./...
go run -race ./cmd/server
~~~

The detector instruments execution and reports races that occur in the paths and schedules exercised. A clean run is not proof that all races are absent. Add tests for concurrent use and run the detector in CI where cost permits.

The detector can increase runtime and memory substantially. Use it to find correctness problems, not to benchmark production throughput.

## Testing concurrent behavior

Prefer deterministic synchronization using channels, WaitGroup, and controlled test servers over sleeps. A sleep guesses about timing and can be flaky. Tests should assert the invariant: no concurrent map access, one writer at a time, or cancellation completes before a deadline.

## Real-world research

Uber’s paper studied data races in a large production Go codebase and describes engineering trade-offs in making race detection usable at scale. The paper reports more than 2,000 races found and more than 1,000 fixed across the studied system, but those counts belong to that codebase and study period. The transferable lesson is the process: run instrumentation on representative paths, triage findings, and address concurrency design rather than treating a tool as a substitute for ownership rules.

## Common mistakes

- Calling the detector a proof that no races exist.
- Running it only once on a narrow test path.
- Using sleeps instead of synchronization in tests.
- Protecting individual map calls but not a multi-step invariant.
- Using a race build for performance benchmarking.
- Ignoring a report because the observed output “looks correct.”

## Guided practice with answers

**1. Two goroutines write distinct keys to an ordinary map. Is this automatically safe?**  
No. Concurrent map writes require synchronization even when keys differ.

**2. Why might a race detector not report a bug that exists in production?**  
The test may not execute the relevant code path or interleaving.

**3. How can a test wait for a worker without guessing a sleep duration?**  
Use a WaitGroup or a channel signal, with a timeout only as a final guard.

## Quiz

### Questions

1. What conditions define a data race?
2. What is a race condition?
3. Can a race condition exist without a data race?
4. Name three synchronization approaches.
5. Does locking one map call protect a compound invariant?
6. What does the race detector instrument?
7. Does a clean race run prove all races are absent?
8. Why is sleep a weak synchronization mechanism?
9. Why should race builds not be benchmarked for production throughput?
10. What useful lesson does the Uber study provide?
11. Is concurrent writing to distinct keys of a regular map safe?
12. Where should race testing run?

### Answer key

1. Concurrent accesses to the same memory location, at least one a write, with no synchronization.
2. A correctness issue that depends on execution timing or order.
3. Yes.
4. Mutexes, atomics, channels with ownership, or other synchronization primitives.
5. Not necessarily; lock the whole invariant.
6. Program execution to detect unsynchronized conflicting accesses.
7. No; only exercised paths and interleavings are observed.
8. Timing differs across machines and load; a sleep does not establish a happens-before relationship.
9. Instrumentation changes runtime and memory behavior.
10. Detection at scale takes engineering integration, representative execution, triage, and fixes.
11. No.
12. In test and CI paths that exercise concurrent behavior, when practical.

## References and further reading

- [Go memory model](https://go.dev/ref/mem)
- [Data Race Detector](https://go.dev/doc/articles/race_detector)
- [Go race detector implementation](https://go.dev/blog/race-detector)
- [A Study of Real-World Data Races in Golang](https://arxiv.org/abs/2204.00764)
- [sync package](https://pkg.go.dev/sync)
- [sync/atomic package](https://pkg.go.dev/sync/atomic)
- [Go blog: Pipelines and cancellation](https://go.dev/blog/pipelines)
- [Go diagnostics](https://go.dev/doc/diagnostics)

[Persian version](README.md) · [Next chapter: testing](../../10-testing/01-testing-httptest/README.en.md)

</div>