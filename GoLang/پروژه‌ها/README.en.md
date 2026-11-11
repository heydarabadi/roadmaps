# Guided Go Projects

<div dir="ltr">

Complete the projects in order. The first consolidates language basics and files; the second applies those skills to HTTP; the third practices bounded concurrency, cancellation, and profiling. Each guide includes a problem statement, milestones, acceptance criteria, testing guidance, trade-offs, a quiz, and an answer key.

| Order | Project | Main skills |
|---|---|---|
| 1 | [Task tracker CLI](01-task-tracker-cli/README.en.md) | functions, structs, JSON, files, errors, tests |
| 2 | [Catalog HTTP API](02-catalog-http-api/README.en.md) | net/http, interfaces, context, httptest, security |
| 3 | [Concurrent URL checker](03-concurrent-url-checker/README.en.md) | goroutines, channels, worker pools, cancellation, races, benchmarks |

## How to work through a project

1. Write the input/output contract in your own words.
2. Complete one milestone at a time and add tests before extending behavior.
3. Use hints only after trying to design the solution yourself.
4. Record assumptions, limitations, and operational decisions in the project README.
5. Score the result with the rubric below.

For each criterion, award 0 for missing or incorrect, 1 for working but incomplete, and 2 for clear and testable. Criteria: input/output contract, validation and errors, separation of I/O and logic, tests for failure cases, resource lifecycle, and documentation. The rubric is a study aid, not a formal software-quality measure.

## Lesson dependencies

- Before project 1: [functions](../04-کنترل-و-توابع/02-functions-closures/README.en.md), [arrays and slices](../03-ساختار-داده/01-arrays-slices/README.en.md), [maps](../03-ساختار-داده/03-maps-comma-ok/README.en.md), [errors](../08-error-resilience/01-errors/README.en.md), [I/O and JSON](../11-standard-library/01-stdlib-io-json-time/README.en.md).
- Before project 2: [methods and interfaces](../06-متد-interface-generics/01-methods-interfaces/README.en.md), [modules](../07-packages-modules/01-packages-modules/README.en.md), [HTTP ecosystem](../12-اکوسیستم/01-کتابخانه-های-اکوسیستم/README.en.md), [HTTP testing](../10-testing/01-testing-httptest/README.en.md).
- Before project 3: [goroutines and channels](../09-concurrency/01-goroutines-channels/README.en.md), [sync and context](../09-concurrency/02-sync-context/README.en.md), [worker pools](../09-concurrency/03-worker-pool-pipeline/README.en.md), [race detection](../09-concurrency/04-race-detector/README.en.md), [benchmarks](../10-testing/02-benchmarks-coverage/README.en.md).

## Final review

Ask: What breaks if input is ten times larger? What resource remains if a dependency is slow? What data can be corrupted if the process stops during a write? Who can see a token in logs? What measurement would demonstrate that an optimization helped? Keep answers with the project.

[Persian project index](README.md) · [English course index](../README.en.md)

</div>