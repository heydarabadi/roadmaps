# Practicing DSA with JavaScript

> Parent: [Choose a Language](../readme.en.md) · [Chapter 1](../../readme.en.md)  
> Language: English · [Read this guide in Persian](readme.md)

## Prerequisites and mental model

JavaScript works in browsers and Node.js, making it convenient for algorithm practice. Be aware of coercion, the `Number` type, and built-in collection behavior; short syntax does not guarantee the intended semantics or cost.

## Core collections for DSA

- `Array` is resizable; indexed access is typically `O(1)`, and end `push`/`pop` are usually amortized `O(1)`.
- `shift()` and `unshift()` may move many elements and cost `O(n)`.
- `Map` and `Set` support average fast lookup for keys and membership.
- Typed arrays provide array-like views over binary buffers for numeric data.
- `Array.sort()` uses string-like ordering by default; pass a numeric comparator for numbers.

## Step-by-step patterns

For a BFS queue, avoid repeated `shift()` on a large array. Use a head index:

~~~javascript
const q = [start];
let head = 0;
while (head < q.length) {
  const u = q[head++];
  // visit neighbors and append newly discovered vertices
}
~~~

Use a `Set` for visited vertices and a `Map` for parent links. JavaScript has no general standard-library heap with a familiar `PriorityQueue` API, so implement a binary heap or use a reviewed dependency and understand its contract.

## Worked examples and semantics

`[2, 10, 1].sort()` may sort lexicographically. Use `(a, b) => a - b` for numeric ascending order. With a `Map`, `map.get(key)` returning `undefined` does not distinguish an absent key from a stored `undefined`; use `map.has(key)` when existence matters.

For a manual trace, record the head index, queue contents, visited set, and each state change.

## Correctness and language semantics

Array `length` describes the last index plus one, but sparse arrays can contain holes. A comparator must define a consistent order. `Map` and plain objects have different key and iteration semantics. `===` avoids the coercion of `==`, but the required equality relation still depends on the problem.

For BFS, mark vertices visited when adding them to the queue to prevent duplicate enqueue operations.

## Time and space analysis

Array end append/pop are typically amortized `O(1)`; `shift()` is `O(n)`; `includes()` is `O(n)`; `Map`/`Set` lookup is average near `O(1)`. JavaScript `Number` represents integers exactly only up to `Number.MAX_SAFE_INTEGER`; use `BigInt` for larger integer values, and do not mix it directly with `Number` arithmetic.

## Practical use

JavaScript suits browser algorithms, Node.js tools, and interview practice. `Map` supports keys beyond strings, while typed arrays can represent dense numeric data compactly.

## Common mistakes and edge cases

- Default `sort()` is not numeric sorting; supply a comparator.
- Avoid `shift()` as a frequent queue operation.
- `Array(5)` creates holes, not five ordinary initialized values.
- Check safe-integer limits and do not mix `BigInt` with `Number` without explicit conversion.
- Handle `undefined`, `null`, duplicate values, empty arrays, and recursion depth explicitly.

## Step-by-step exercises

1. Compare default sorting with `(a, b) => a - b`.
2. Write BFS with a head index.
3. Explain why `Number` cannot exactly represent every integer larger than the safe-integer limit.

For each exercise, write a correct baseline, analyze it, and add an edge case. Trace a small input and compare the result with an independently derived expectation.

## Comprehensive quiz with explained answers

1. **How do you sort numbers ascending?** Pass `(a, b) => a - b` to `sort()`.
2. **Why can `shift()` be inefficient for a queue?** Remaining array elements may need to move, costing `O(n)`.
3. **What collection supports key lookup and membership?** `Map` for key/value pairs and `Set` for unique values; typical lookup is average near `O(1)`.
4. **What is the exact-integer limit of `Number`?** Integers are exact only through `Number.MAX_SAFE_INTEGER` (and its negative counterpart).
5. **Why use `map.has(key)`?** It distinguishes an absent key from one whose stored value is `undefined`.

## Further reading and references

- [MDN — Array](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Array) — array methods, sorting, and iteration.
- [MDN — Keyed Collections](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Guide/Keyed_collections) — `Map` and `Set` semantics.
- [MDN — Map](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Map) — key/value collection behavior.
- [MDN — Set](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Set) — uniqueness and membership.
- [MDN — Typed Arrays](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Guide/Typed_arrays) — binary-buffer views for numeric data.
- [Persian supplementary course — Data Structures and Algorithms](https://www.konkurcomputer.ir/dade-videos.html).

## Mastery checklist

- [ ] I can use Array, Map, and Set with their correct semantics.
- [ ] I can implement an efficient queue and numeric sort.
- [ ] I can handle safe-integer and missing-value cases.
- [ ] I have completed the exercises and reviewed their edge cases.
