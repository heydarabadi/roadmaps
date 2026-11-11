# 4.1 — Correctness, Design, and API Contracts

**Language:** English · [فارسی](../../../04-technical-review/01-correctness-design-api/README.md)

**Learning outcomes:** Derive invariants from requirements, inspect edge and failure behavior, and assess API and design compatibility.

## Core lesson

Correctness means the code produces the required behavior under the conditions that matter. Turn prose into invariants: a user may read only their own records; an order's total matches its line items; one idempotency key causes at most one payment; a successful response reflects committed state. Then inspect how those rules are enforced across layers.

Use an edge-case taxonomy: empty, null, missing, invalid, maximum, duplicate, stale, unauthorized, concurrent, partial failure, timeout, and retry. Compare the contract with callers and persisted data, not only a new happy-path test. Consider error semantics, default values, pagination, sorting, versioning, and whether older clients still work.

Good design places behavior where ownership and invariants are clear. Watch for duplicated policy, surprising side effects, accidental coupling, needless abstractions, leaky layers, and APIs that are difficult to use safely. A review should distinguish an objective contract defect from a preference. Point to a requirement, observed behavior, or maintainability cost.

## Worked example: idempotent payment endpoint

The API accepts a payment request with an idempotency key. Define what happens when the same key arrives twice, when it arrives with a different amount, and when the provider accepts a charge but the application times out before saving the response. The invariant is not merely “the endpoint returns 200”; it is that retries do not create multiple charges and that stored state can be reconciled.

## Checklist

- [ ] Requirements are expressed as observable invariants.
- [ ] Boundary, invalid, failure, and concurrent cases are considered.
- [ ] API contract and existing consumers remain compatible or are migrated.
- [ ] Side effects, transaction boundaries, and retry semantics are clear.
- [ ] Design comments are tied to a real cost or project convention.

## Quiz

1. How do you begin a correctness review? **Translate the requirement into invariants and scenarios.**
2. A new endpoint returns the correct response in one test; what else matters? **Authorization, failures, old clients, persistence, duplicates, and concurrent requests.**
3. Why is idempotency important for payment retry? **A repeated request must not produce an unintended second charge.**
4. When is an abstraction comment actionable? **When it identifies a concrete cost, contract problem, or agreed project rule rather than personal taste.**

## Further reading

- [Google: What to look for](https://google.github.io/eng-practices/review/reviewer/looking-for.html)
- [Google API Design Guide](https://cloud.google.com/apis/design)
- [Stripe: Idempotent requests](https://docs.stripe.com/api/idempotent_requests)
- [Microsoft REST API Guidelines](https://github.com/microsoft/api-guidelines)
- [Persian: Netparadis review guide](https://netparadis.com/code-review-practices-pull-request/?rm=pro-skills)
- [Persian: Sauleh code review guide (PDF)](https://www.sauleh.ir/ap97/static_files/AP97982-CodeReviewGuide.V.1.3.pdf)
