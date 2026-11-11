# 11.1 — Standard library, I/O, JSON, time, and embedding

<div dir="ltr">

**Time:** 150 minutes · **Prerequisite:** types, errors, files, and packages  
**Goal:** Use standard packages at clear boundaries, bound resource use, and handle common data formats deliberately.

## Reader and Writer

io.Reader and io.Writer are small interfaces for streaming bytes. They let code work with files, network connections, buffers, and test doubles without depending on one storage type.

~~~go
func copyLimited(dst io.Writer, src io.Reader) error {
    _, err := io.Copy(dst, src)
    return err
}
~~~

For untrusted input, do not read an unbounded body into memory. Use io.LimitReader or a request-body limit and handle the case where the limit is exceeded.

## Files, os, bufio, and flag

os provides filesystem and process operations. Close files explicitly and handle close errors when writes or flushes matter. bufio reduces small read/write overhead and offers line-oriented scanning; Scanner has a token size limit that must be adjusted or replaced for large records.

flag is suitable for simple command-line options. For complex command trees, a CLI framework may be more appropriate. Environment variables are useful for deployment configuration but require validation and safe secret handling.

## JSON

encoding/json marshals and unmarshals Go values. Prefer explicit request/response types over map[string]any for stable contracts. Decode untrusted input with size bounds, validation, and a deliberate unknown-field policy. JSON syntax success does not prove business validity.

When decoding numbers into any, JSON numbers may become float64 and lose integer precision. Use typed structs or Decoder.UseNumber for exact number handling.

## JSON v2 in Go 1.27

Go 1.27 provides encoding/json/v2 for higher-level operations and encoding/json/jsontext for lower-level token/value processing. V2 offers configurable options and stricter defaults, including rejection of invalid UTF-8 and duplicate object names. The existing encoding/json API remains supported and uses the newer implementation while preserving intended behavior, though exact error text may differ.

~~~go
import jsonv2 "encoding/json/v2"

data, err := jsonv2.Marshal(value)
if err != nil {
    return err
}
_ = data
~~~

Before migrating, check whether existing inputs rely on duplicate keys or invalid UTF-8. Choose v2 for contract and interoperability reasons, not simply because it is new.

## Time and duration

time.Time represents an instant; time.Duration represents an elapsed interval. Use duration constants for timeouts. Parse and format using Go’s reference-time layout. Store and transmit a timezone-aware instant; use a named location for local calendar rules.

~~~go
timeout := 3 * time.Second
deadline := time.Now().Add(timeout)
_ = deadline
~~~

Wall clocks can jump. For measuring elapsed time, time.Time values returned by time.Now carry a monotonic component used by operations such as time.Since.

## flag, regexp, slog, and go:embed

- flag parses simple command-line flags.
- regexp uses RE2 syntax with predictable matching behavior; compile untrusted patterns carefully and bound input size.
- log/slog provides structured logging with levels and attributes. Redact secrets and avoid logging full request bodies.
- go:embed includes files at build time. Do not embed credentials or environment-specific secrets in a binary.

~~~go
//go:embed templates/*
var templates embed.FS
~~~

The directive belongs in Go source comments and the embedded files must satisfy the compiler’s path rules.

## Common mistakes

- Reading an unbounded body into memory.
- Forgetting to close files or network response bodies.
- Using Scanner without considering its token limit.
- Assuming JSON decoding validates business rules.
- Losing numeric precision through float64.
- Using a local timezone implicitly for cross-region timestamps.
- Logging secrets or embedding them into an executable.

## Guided practice with answers

**1. A request body can be very large. What should you do?**  
Set an explicit maximum size and reject input beyond it before full decoding.

**2. Which package is appropriate for CSV rather than splitting on commas?**  
encoding/csv, because quoted fields can contain commas.

**3. When should you use time.Since rather than comparing wall-clock strings?**  
For elapsed-time measurement.

## Quiz

### Questions

1. What do io.Reader and io.Writer abstract?
2. Why limit an untrusted input stream?
3. What is a Scanner token limit?
4. When is bufio useful?
5. Why use typed JSON structs for stable contracts?
6. What can happen to large numbers decoded into any?
7. Name the two JSON packages introduced in Go 1.27.
8. Name two stricter JSON v2 defaults.
9. What does time.Time represent?
10. What does time.Duration represent?
11. Which reference layout does Go use for time formatting?
12. What kind of logging does slog provide?
13. What does go:embed do?
14. What should never be embedded in a binary?

### Answer key

1. Byte-stream reading and writing behavior.
2. To bound memory and CPU use.
3. Scanner has a maximum token size unless configured differently or replaced.
4. For buffering and convenient line or token processing.
5. They give the contract explicit names and types.
6. float64 may lose integer precision.
7. encoding/json/v2 and encoding/json/jsontext.
8. It rejects invalid UTF-8 and duplicate JSON object names by default.
9. An instant.
10. An elapsed interval.
11. The Go reference-time layout.
12. Structured logging with levels and attributes.
13. Embeds files into the compiled program.
14. Credentials or environment-specific secrets.

## References and further reading

- [io package](https://pkg.go.dev/io)
- [os package](https://pkg.go.dev/os)
- [bufio package](https://pkg.go.dev/bufio)
- [flag package](https://pkg.go.dev/flag)
- [encoding/json package](https://pkg.go.dev/encoding/json)
- [Go 1.27 release notes: JSON v2](https://go.dev/doc/go1.27#encoding_json_v2)
- [time package](https://pkg.go.dev/time)
- [regexp package](https://pkg.go.dev/regexp)
- [log/slog package](https://pkg.go.dev/log/slog)
- [embed package](https://pkg.go.dev/embed)
- [Go blog: JSON and Go](https://go.dev/blog/json)

[Persian version](README.md) · [Next: ecosystem](../../12-اکوسیستم/01-کتابخانه-های-اکوسیستم/README.en.md)

</div>