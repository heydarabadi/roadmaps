# 10.2 — Benchmarks, coverage, and fuzzing

<div dir="ltr">

**Time:** 120 minutes · **Prerequisite:** unit testing  
**Goal:** Measure performance, interpret coverage carefully, and use fuzzing to explore malformed inputs.

## Benchmarks measure a workload

Go benchmark functions start with Benchmark and accept *testing.B. The benchmark loop repeats the operation.

~~~go
func BenchmarkParse(b *testing.B) {
    input := []byte("id=42")
    b.ReportAllocs()
    for i := 0; i < b.N; i++ {
        if _, err := Parse(input); err != nil {
            b.Fatal(err)
        }
    }
}
~~~

Run go test -bench=. -benchmem. A benchmark measures the code and setup you wrote under the current machine, Go version, and workload. Record these conditions when comparing results.

Do not include unrelated setup in the timed loop. Do not discard errors in order to make the benchmark look faster. Repeat measurements and use statistical comparison tools when small differences matter.

## Benchmark allocations and profiles

-benchmem reports allocations and bytes per operation. It does not identify which allocation matters to production. CPU, heap, and allocation profiles can reveal where cost occurs. Profile a representative workload and keep sensitive profile artifacts protected.

Optimization should answer a specific question. Compare a baseline and a change using the same workload. A microbenchmark win may not improve end-to-end latency.

## Coverage

go test -cover reports statement coverage. Coverage shows which statements executed, not whether assertions verified the right behavior. Add tests for invariants, boundaries, and failures rather than chasing a percentage alone.

~~~powershell
go test -cover ./...
go test -coverprofile=coverage.out ./...
go tool cover -func=coverage.out
~~~

## Fuzzing

A fuzz test defines a target function and seed inputs. The fuzzer mutates inputs to discover cases that cause a panic or violate assertions.

~~~go
func FuzzParseID(f *testing.F) {
    f.Add("id=42")
    f.Fuzz(func(t *testing.T, input string) {
        _, _ = ParseID(input)
    })
}
~~~

A useful fuzz target asserts safety and invariants, not merely that the function returns. Save and review minimized failures; they become regression tests. Fuzzing does not prove correctness for all possible inputs.

## Common mistakes

- Benchmarking one run and treating it as truth.
- Comparing results across different Go versions or machines without noting it.
- Measuring test setup rather than the operation.
- Ignoring benchmark errors.
- Treating coverage as a quality score.
- Fuzzing without meaningful invariants.
- Publishing profile data that contains sensitive information.

## Guided practice with answers

**1. A benchmark reports fewer allocations but end-to-end latency is unchanged. What does that tell you?**  
The allocation reduction may not be on the critical path or may be too small to affect the workload.

**2. Why keep a failing fuzz input as a regression test?**  
It preserves a discovered boundary and prevents the same bug from returning.

**3. What does 100% statement coverage prove?**  
Only that the statements were executed under the measured tests; it does not prove assertions or behavior are correct.

## Quiz

### Questions

1. What prefix does a Go benchmark function use?
2. What does b.N represent?
3. What does -benchmem report?
4. Why record Go version and machine?
5. What does a CPU profile help find?
6. Does a microbenchmark win guarantee end-to-end improvement?
7. What does statement coverage measure?
8. Does coverage measure assertion quality?
9. What does a fuzzer mutate?
10. What should a fuzz target assert?
11. What should happen to a minimized failing input?
12. Can fuzzing prove all possible inputs are safe?
13. Why should profile files be protected?
14. Why repeat benchmarks?

### Answer key

1. Benchmark.
2. The number of iterations chosen for measurement.
3. Allocation counts and bytes per operation.
4. Results depend on environment, toolchain, and workload.
5. CPU-consuming code paths.
6. No.
7. Which statements executed.
8. No.
9. Inputs supplied to the fuzz target.
10. Safety and semantic invariants.
11. Review it and keep it as a regression case.
12. No.
13. They may reveal sensitive runtime data or program structure.
14. To account for noise and measurement variation.

## References and further reading

- [testing package: benchmarks and fuzzing](https://pkg.go.dev/testing)
- [Go blog: profiling Go programs](https://go.dev/blog/pprof)
- [Go diagnostics](https://go.dev/doc/diagnostics)
- [Go fuzzing tutorial](https://go.dev/doc/tutorial/fuzz)
- [Go fuzzing documentation](https://go.dev/doc/security/fuzz/)
- [Go Code Review Comments: tests](https://go.dev/wiki/CodeReviewComments#tests)
- [cmd/cover documentation](https://pkg.go.dev/cmd/cover)
- [Go benchmark comparison tool benchstat](https://pkg.go.dev/golang.org/x/perf/cmd/benchstat)

[Persian version](README.md) · [Next chapter: standard library](../../11-standard-library/01-stdlib-io-json-time/README.en.md)

</div>