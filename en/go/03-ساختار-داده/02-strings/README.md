# 3.2 — Strings, UTF-8, runes, and user-visible text

<div dir="ltr">

**Time:** 90 minutes · **Prerequisite:** integers and slices  
**Goal:** Understand what a Go string stores and choose between byte, rune, and grapheme operations.

## A string is not an array of characters

A Go string is an immutable sequence of bytes. Text is commonly encoded as UTF-8, but the string type does not require valid UTF-8. len(s) counts bytes, and s[i] returns one byte.

~~~go
s := "Go فارسی"
fmt.Println("bytes:", len(s))
fmt.Println("runes:", utf8.RuneCountInString(s))
for index, r := range s {
    fmt.Printf("byte-index=%d rune=%U %q\n", index, r, r)
}
~~~

range decodes UTF-8 and yields the starting byte offset plus a rune. Offsets are not consecutive when a code point uses multiple bytes. For malformed UTF-8, range yields RuneError; use utf8.ValidString when validity must be checked explicitly.

## Three different counts

- Byte length: encoded storage size, available through len.
- Rune count: Unicode code-point count, available through utf8.RuneCountInString or iteration.
- Grapheme count: count of user-perceived text clusters; a cluster may include multiple code points.

Emoji sequences, combining marks, and many scripts demonstrate why these counts differ. Use byte length for protocol or memory bounds, rune iteration for code-point processing, and grapheme segmentation for user-visible character limits.

## Strings are immutable; byte slices are mutable

~~~go
text := "cat"
bytes := []byte(text)
bytes[0] = 'b'
fmt.Println(text, string(bytes)) // cat bat
~~~

Converting to []byte creates mutable data; the original string does not change. Conversions may allocate. Profile before considering unsafe shortcuts.

## Building strings

For a few pieces, + is readable. For repeated construction in a loop, strings.Builder can reduce allocations:

~~~go
var b strings.Builder
for _, name := range names {
    b.WriteString(name)
    b.WriteByte('\n')
}
result := b.String()
_ = result
~~~

Do not copy a Builder after it has been used. For joining an existing slice of strings, strings.Join is often clearer than a manual loop.

## Literal forms and standard helpers

Interpreted string literals process escapes such as newline. Raw string literals preserve backslashes and newlines and are useful for regular expressions or multiline templates. A raw literal cannot contain its own delimiter directly.

Useful helpers include strings.TrimSpace, Fields, Split, Cut, Contains, and Join. Split on a comma is not a complete CSV parser because CSV allows quoting and escaped delimiters; use encoding/csv for CSV data.

~~~go
left, right, found := strings.Cut("id=42", "=")
if found {
    fmt.Println(left, right)
}
~~~

## Persian text and normalization

Unicode can encode visually similar text in different ways. Persian and Arabic text also commonly differ in character variants and zero-width non-joiner usage. Normalization and canonicalization are product decisions; do not rewrite user text blindly. For identifiers, search, or security-sensitive comparisons, define normalization and comparison rules explicitly and test real input.

## Common bug: slicing at an arbitrary byte index

~~~go
s := "سلام"
broken := s[:3] // may end in the middle of a UTF-8 sequence
_ = broken
~~~

A byte slice can contain invalid UTF-8 even when the original string was valid. Iterate over runes or use Unicode-aware boundaries when text integrity matters. For truncation in storage, state whether the limit is bytes, code points, or visible graphemes.

## Common mistakes

- Assuming len(string) counts visible characters.
- Treating each s[i] as a full Unicode character.
- Slicing between bytes of one UTF-8 sequence.
- Treating Split as a full parser for CSV or quoted formats.
- Using unsafe merely to avoid a conversion allocation without measurement.
- Comparing normalized or case-folded text without a defined domain rule.

## Guided practice with answers

**1. Why can len("سلام") be larger than the number of displayed letters?**  
UTF-8 uses multiple bytes for many code points; len counts bytes.

**2. How should a UI limit text to 20 visible characters?**  
Use a Unicode grapheme segmentation algorithm, not len or rune count alone.

**3. What should be used to parse CSV?**  
The encoding/csv package, because commas can appear inside quoted fields.

## Quiz

### Questions

1. What does len return for a string?
2. What does indexing a string return?
3. What does range over a string yield?
4. What does a rune represent?
5. Is one rune always one visible character?
6. What does utf8.ValidString check?
7. Does converting a string to []byte mutate the original?
8. When is strings.Builder useful?
9. Why should a used Builder not be copied?
10. Why is strings.Split not a CSV parser?
11. What kind of bug can s[:n] cause?
12. Which count should be used for byte limits?
13. Which count is often needed for UI character limits?

### Answer key

1. The number of bytes.
2. One byte.
3. The start byte offset and decoded rune.
4. A Unicode code point.
5. No. A grapheme can contain multiple code points.
6. Whether the byte sequence is valid UTF-8.
7. No; the converted slice is mutable and the source string is immutable.
8. Repeated string construction.
9. Builder has copy restrictions after use and copying can violate its intended behavior.
10. CSV quoting and escaped separators require a real parser.
11. A slice may end in the middle of a UTF-8 encoding.
12. Byte length.
13. Grapheme-cluster count.

## References and further reading

- [Go blog: strings, bytes, runes, and characters](https://go.dev/blog/strings)
- [Go specification: string types](https://go.dev/ref/spec#String_types)
- [Package strings](https://pkg.go.dev/strings)
- [Package unicode/utf8](https://pkg.go.dev/unicode/utf8)
- [Package encoding/csv](https://pkg.go.dev/encoding/csv)
- [Unicode Standard Annex #29: text segmentation](https://www.unicode.org/reports/tr29/)
- [Unicode Normalization Forms](https://www.unicode.org/reports/tr15/)
- [Go 1.27 release notes: strings.CutLast](https://go.dev/doc/go1.27#strings)

[Persian version](README.md) · [Next: maps](../03-maps-comma-ok/README.en.md)

</div>