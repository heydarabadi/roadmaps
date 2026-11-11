# 10.1 — Testing, table-driven cases, doubles, and httptest

<div dir="ltr">

**Time:** 150 minutes · **Prerequisite:** functions, interfaces, and HTTP handlers  
**Goal:** Test behavior at useful boundaries with deterministic cases and controlled dependencies.

## Basic Go tests

Test files end in _test.go. A test function has the form func TestName(t *testing.T). The testing package runs it and reports failures.

~~~go
func TestNormalize(t *testing.T) {
    got := Normalize("  Go ")
    if got != "Go" {
        t.Fatalf("Normalize() = %q, want %q", got, "Go")
    }
}
~~~

Use t.Helper in test helpers so failure locations point to the calling test. Use Errorf when the test can continue, and Fatalf when continuing would produce invalid follow-up assertions.

## Table-driven tests

A table makes related inputs and expected outcomes visible:

~~~go
tests := []struct {
    name string
    in   string
    want string
}{
    {name: "trim spaces", in: " Go ", want: "Go"},
    {name: "empty", in: "", want: ""},
}
for _, tt := range tests {
    t.Run(tt.name, func(t *testing.T) {
        if got := Normalize(tt.in); got != tt.want {
            t.Fatalf("got %q, want %q", got, tt.want)
        }
    })
}
~~~

Use clear names and include boundary and failure cases. A huge table can become harder to understand than separate tests.

## Unit and integration boundaries

A unit test should isolate one behavior. An integration test checks interaction among components or a real boundary. Do not make every unit test depend on a live database or internet service; tests become slow and flaky.

Use the lightest useful double:

- A stub returns a controlled response.
- A fake is a small working implementation, such as an in-memory store.
- A mock records and asserts interactions.

Avoid building an elaborate mock framework when a small fake expresses the needed behavior.

## Test HTTP handlers and clients

httptest.ResponseRecorder runs a handler directly without opening a network listener. httptest.Server is useful when testing an HTTP client, transport, redirects, headers, or connection behavior.

~~~go
request := httptest.NewRequest(http.MethodGet, "/healthz", nil)
recorder := httptest.NewRecorder()
handler.ServeHTTP(recorder, request)
if recorder.Code != http.StatusOK {
    t.Fatalf("status = %d", recorder.Code)
}
~~~

Close test servers and response bodies to release resources. Decode JSON and assert contract fields rather than comparing raw formatting.

Go 1.27 adds httptest.NewTestServer, an in-memory fake network suitable for some tests with testing/synctest. For older module language versions, use ResponseRecorder or Server.

## Deterministic concurrent tests

Prefer channels, WaitGroup, and explicit signals over time.Sleep. A timeout can guard against hanging tests, but synchronization should express the event being awaited. Parallel tests need isolated state and concurrency-safe fixtures.

## Common mistakes

- Testing only the happy path.
- Depending on internet or shared mutable fixtures.
- Comparing full error strings when only cause or category matters.
- Calling t.Fatal from a goroutine other than the test goroutine.
- Using sleep to synchronize.
- Forgetting to close response bodies or servers.
- Equating coverage with meaningful assertions.

## Guided practice with answers

**1. When should you use ResponseRecorder instead of a test server?**  
When testing a handler directly and no client transport behavior is part of the contract.

**2. How should a test check a JSON response?**  
Decode it and assert status, headers, and contract fields.

**3. What does a fake store provide?**  
A deterministic substitute with enough behavior for the unit under test without a live external database.

## Quiz

### Questions

1. What is the test-file suffix?
2. What is the standard test function signature?
3. What does table-driven testing help with?
4. What does t.Run provide?
5. What is the difference between Errorf and Fatalf?
6. Why avoid asserting every byte of an error string?
7. What does ResponseRecorder test?
8. When is httptest.Server useful?
9. Why close test servers and response bodies?
10. What does t.Helper do?
11. When is t.Parallel safe?
12. Why is sleep a poor synchronization tool?
13. What does a unit test target?
14. What does an integration test target?
15. Does high coverage prove good tests?
16. Why not call a live dependency in every unit test?
17. What resource control can an HTTP test need?
18. How can JSON assertions be more stable?
19. What is the difference between a stub, fake, and mock?
20. When is a small fake preferable to a mock framework?
21. When should ResponseRecorder be preferred to NewTestServer?
22. In which Go version was NewTestServer introduced?

### Answer key

1. _test.go.
2. func TestName(t *testing.T).
3. Reusing one test structure for multiple named cases.
4. Independent, named subtests.
5. Errorf records and continues; Fatalf records and stops that test.
6. Exact wording may be implementation detail; assert error identity or stable contract instead.
7. Direct handler behavior without a real listener.
8. Client, transport, redirect, and realistic HTTP exchange behavior.
9. To release resources and avoid test leaks.
10. Makes test failures report the calling helper’s location.
11. When fixtures and dependencies are isolated and concurrency-safe.
12. It guesses timing and establishes no synchronization.
13. One focused behavior.
14. Collaboration across components or an external boundary.
15. No; executed lines may have no meaningful assertions.
16. To avoid external time, cost, flakiness, and availability.
17. A deadline or timeout.
18. Decode the JSON and check fields rather than raw whitespace.
19. Stub returns controlled data; fake behaves simply; mock records expected interactions.
20. When a small deterministic substitute suffices without extra framework complexity.
21. When only direct handler behavior matters.
22. Go 1.27.

## References and further reading

- [testing package](https://pkg.go.dev/testing)
- [net/http/httptest package](https://pkg.go.dev/net/http/httptest)
- [Go blog: testing time with synctest](https://go.dev/blog/testing-time)
- [Go 1.27 release notes: httptest](https://go.dev/doc/go1.27#net_http_httptest)
- [Go Code Review Comments: test names](https://go.dev/wiki/CodeReviewComments#tests)
- [Go blog: testing techniques](https://go.dev/blog/subtests)
- [A Tour of Go: testing](https://go.dev/doc/tutorial/add-a-test)

[Persian version](README.md) · [Next: benchmarks and coverage](../02-benchmarks-coverage/README.en.md)

</div>