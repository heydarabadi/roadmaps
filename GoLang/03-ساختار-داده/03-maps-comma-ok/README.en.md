# 3.3 — Maps and the comma-ok idiom

<div dir="ltr">

**Time:** 90 minutes · **Prerequisite:** arrays, slices, and comparable types  
**Goal:** Model key-value lookup, detect missing keys, and use maps without relying on iteration order.

## Map model

A map associates keys with values. Keys must be comparable. Strings, integers, pointers, and structs with comparable fields can be keys; slices and maps cannot.

~~~go
scores := map[string]int{"Ada": 95, "Lin": 88}
scores["Sam"] = 91
delete(scores, "Lin")
~~~

The zero value of a map is nil. Reading is safe and returns the value type’s zero value; writing panics. Use make or a map literal before writing.

## Comma-ok lookup

A lookup returns the value and whether the key exists:

~~~go
score, ok := scores["Ada"]
if !ok {
    fmt.Println("not found")
    return
}
fmt.Println(score)
~~~

Do not compare the value with zero to detect absence: zero may be valid. The comma-ok idiom also appears in type assertions and channel receive.

## Iteration order is unspecified

Map iteration is not a stable sorting rule. For deterministic output, collect and sort keys:

~~~go
keys := make([]string, 0, len(scores))
for key := range scores {
    keys = append(keys, key)
}
sort.Strings(keys)
for _, key := range keys {
    fmt.Println(key, scores[key])
}
~~~

A test that passes only because a map happened to iterate in one order is fragile.

## Maps and ownership

Map values are copied on assignment, but refer to shared map data. Passing a map to a function allows that function to mutate the same map. Concurrent reads and writes without synchronization are unsafe. Compound operations such as “check then insert” are not automatically atomic.

If values are slices or pointers, copying the map structure does not deep-copy referenced values. Define ownership and copy rules at the API boundary.

~~~go
counts := make(map[string]int)
for _, word := range words {
    counts[word]++
}
~~~

The counting pattern is concise because a missing integer key reads as zero. It is appropriate only when zero and absence do not need to be distinguished.

## Common mistakes

- Writing to a nil map.
- Treating a missing key as identical to a present zero-valued entry.
- Assuming iteration order is insertion or sorted order.
- Concurrently mutating a map without protection.
- Returning a mutable internal map to callers.
- Using a non-comparable type as a map key.

## Guided practice with answers

**1. A user ID may map to quantity zero. How do you distinguish absent from zero?**  
Use value, ok := m[key] and check ok.

**2. How should map keys be printed deterministically?**  
Collect the keys, sort them, and look up values in that order.

**3. Why can a caller change a map returned from a function?**  
The returned map refers to shared map storage. Return a defensive copy when callers must not mutate internal state.

## Quiz

### Questions

1. Which types may be map keys?
2. What is a map’s zero value?
3. Can you read from a nil map?
4. Can you write to a nil map?
5. What does comma-ok provide?
6. Why is value == zero insufficient to check presence?
7. Is map iteration order stable?
8. How can map output be sorted?
9. Are ordinary map writes safe across goroutines?
10. Does copying a map deep-copy slices stored as values?
11. Why can passing a map to a function allow mutation?
12. What does delete do for a missing key?

### Answer key

1. Comparable types.
2. nil.
3. Yes; it returns the value type’s zero value.
4. No; it panics.
5. The value plus a boolean for existence.
6. Zero can be a valid stored value.
7. No.
8. Collect and sort the keys.
9. No. Synchronize access.
10. No.
11. The map value refers to shared map data.
12. Nothing; delete is safe if the key is absent.

## References and further reading

- [Go specification: map types](https://go.dev/ref/spec#Map_types)
- [Go specification: map indexing](https://go.dev/ref/spec#Index_expressions)
- [Go blog: Go maps in action](https://go.dev/blog/maps)
- [A Tour of Go: maps](https://go.dev/tour/moretypes/19)
- [Package maps](https://pkg.go.dev/maps)
- [Go memory model](https://go.dev/ref/mem)
- [Go Code Review Comments: copying](https://go.dev/wiki/CodeReviewComments#copying)

[Persian version](README.md) · [Next: structs and embedding](../04-struct-tags-embedding/README.en.md)

</div>