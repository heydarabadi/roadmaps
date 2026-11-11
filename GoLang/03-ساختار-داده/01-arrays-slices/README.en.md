# 3.1 — Arrays and slices

<div dir="ltr">

**Time:** 120 minutes · **Prerequisite:** types and functions  
**Goal:** Distinguish fixed-size arrays from slices, understand slice headers and shared storage, and modify sequences without accidental aliasing.

## Arrays are values with a fixed length

The length is part of an array’s type. Assigning or passing an array copies its elements.

~~~go
var a [3]int
a[0] = 7
b := a
b[0] = 99
fmt.Println(a[0], b[0]) // 7 99
~~~

Arrays are useful when fixed size and value semantics matter. Most application collections use slices because the length varies.

## A slice is a descriptor over an array

A slice describes a segment of an underlying array. Conceptually it holds a pointer to the first element, a length, and a capacity. Copying a slice copies this descriptor, not the elements.

~~~go
base := []int{10, 20, 30, 40}
left := base[:2]
right := base[1:3]
right[0] = 99
fmt.Println(base) // [10 99 30 40]
~~~

The slices alias the same backing array. Mutating one can affect another. When ownership must be independent, copy the elements into fresh storage.

## Length, capacity, and bounds

For a slice s:

- len(s) is the number of elements currently accessible.
- cap(s) is the number of elements available from the first element to the end of its backing array.
- A two-index expression selects [low:high], with length high-low.
- A three-index expression also limits capacity.

~~~go
values := make([]int, 2, 5)
fmt.Println(len(values), cap(values)) // 2 5
limited := values[:2:2]
fmt.Println(len(limited), cap(limited)) // 2 2
~~~

The full slice expression can prevent append through this slice from overwriting later elements in the original array. It does not make the underlying data private; existing elements may still alias.

## make, append, and growth

Use make when you know a length or capacity. Use append to add elements; always keep the returned slice because append may allocate a new backing array.

~~~go
items := make([]string, 0, 4)
items = append(items, "go", "tooling")
~~~

The growth strategy is an implementation detail. Do not rely on an exact capacity multiplier. If capacity is likely to grow substantially, use a reasonable estimate to reduce reallocations, then measure.

## Copying and cloning

~~~go
source := []int{1, 2, 3}
clone := make([]int, len(source))
copy(clone, source)
clone[0] = 9
fmt.Println(source[0], clone[0]) // 1 9
~~~

This is a shallow copy: nested slices, maps, pointers, or reference-like values inside the elements may still be shared. Deep-copy only when the data model needs independent ownership.

## Slice conversions in modern Go

Go 1.17 added conversion from a slice to a pointer to an array, for example (*[3]int)(slice); the slice must have at least that many elements. Go 1.20 added direct slice-to-array conversion, for example [3]int(slice); it panics if the slice is too short. Array-to-slice conversion is a slice view over the array’s storage.

~~~go
values := []int{1, 2, 3}
array := [3]int(values)
view := array[:]
view[0] = 8
fmt.Println(array[0]) // 8
~~~

The array-to-slice view aliases the array. Check the module language version before using version-specific syntax.

## Common mistakes

- Assuming a slice is the backing array itself.
- Ignoring the result of append.
- Keeping a tiny subslice of a very large array and unintentionally retaining the whole array.
- Mutating through a second aliased slice.
- Assuming copy performs a deep clone.
- Depending on a specific append growth factor.
- Converting a short slice to an array without handling panic or checking length.

## Guided practice with answers

**1. Why did changing right[0] change base[1]?**  
The slices share the same backing array.

**2. Make a shallow independent copy of a []string.**  
Allocate a new slice with the same length and call copy. The string values are immutable, so copying their descriptors is sufficient for this example.

**3. How can a subslice keep a large backing array alive?**  
The subslice still references that array. Copy the needed elements into a smaller allocation when retaining the large array is wasteful.

## Quiz

### Questions

1. Is an array’s length part of its type?
2. Does assigning an array copy its elements?
3. What information does a slice conceptually contain?
4. What does len report?
5. What does cap report?
6. Can two slices share storage?
7. Why must the result of append be assigned?
8. Does copy make nested maps and slices independent?
9. What does a three-index slice expression control?
10. Since which version can a slice convert directly to an array?
11. What happens if direct slice-to-array conversion is too short?
12. Does array-to-slice conversion copy elements?
13. Why can a small subslice retain a large allocation?
14. Should code depend on the exact growth factor of append?

### Answer key

1. Yes.
2. Yes; arrays have value semantics.
3. A reference to storage plus length and capacity.
4. Accessible element count.
5. Available capacity from the first element to the backing array’s end.
6. Yes; slices can alias the same backing array.
7. Append may return a slice over a newly allocated array.
8. No. copy is shallow.
9. The resulting capacity as well as the selected range.
10. Go 1.20.
11. It panics.
12. No; it creates a view over the array storage.
13. The subslice still references the original backing array.
14. No. Growth is an implementation detail.

## References and further reading

- [Go specification: array types](https://go.dev/ref/spec#Array_types)
- [Go specification: slice types](https://go.dev/ref/spec#Slice_types)
- [Go specification: slice expressions](https://go.dev/ref/spec#Slice_expressions)
- [Go blog: Go slices: usage and internals](https://go.dev/blog/slices-intro)
- [Go blog: arrays, slices, and strings](https://go.dev/blog/slices)
- [Package slices](https://pkg.go.dev/slices)
- [Go 1.17 release notes](https://go.dev/doc/go1.17#language)
- [Go 1.20 release notes](https://go.dev/doc/go1.20#language)

[Persian version](README.md) · [Next: strings](../02-strings/README.en.md)

</div>