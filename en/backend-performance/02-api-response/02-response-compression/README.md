<div dir="ltr" align="left">

[فارسی](../../../../fa/backend-performance/02-api-response/02-response-compression/README.md) | **English**

# Response Compression

Compression encodes the same content into fewer bytes for transfer; it does not semantically summarize JSON. The server and client must agree on the encoding. Fewer network bytes reduce transfer cost, but compression and decompression consume CPU; choose by comparing those costs.

**After this lesson, you can:** explain three key headers; avoid confusing transfer size with decompressed size; identify the responsible compression layer; and assess network savings along with CPU, latency, and sensitive-content risk. Prerequisites: HTTP headers and [payload size](../01-payload-size/README.md). **Sources reviewed: 2026-11-10.**

## Basic headers and terms

Request headers tell a server what the client accepts; response headers describe the representation actually sent. A **representation** is the content the consumer gets after decoding; Content-Encoding changes its transfer representation.

## How does encoding negotiation work?

| Element | Role | Example |
| --- | --- | --- |
| Request `Accept-Encoding` | Encodings acceptable to the client | `gzip, br` |
| Response `Content-Encoding` | Encoding actually applied to the body | `gzip` |
| Response `Vary: Accept-Encoding` | Tells caches that representation depends on a request header | Do not mix compressed and uncompressed variants |
| `Content-Type` | Type of the decompressed content | Still `application/json` |

The client announces supported encodings; the server selects an acceptable encoding it supports and sends the body using it. When selection depends on `Accept-Encoding`, `Vary` must express that dependency. Gzip is often useful for text/JSON; recompressing JPEG or ZIP usually saves little. [MDN: Compression in HTTP](https://developer.mozilla.org/en-US/docs/Web/HTTP/Guides/Compression).

Do not send raw JSON while adding only `Content-Encoding: gzip`; the header must describe the actual bytes. Conversely, a gzip body without the correct header cannot be interpreted by the consumer. `Content-Length`, if present, describes the encoded message content length; do not copy an old value after changing encoding. [MDN: Content-Encoding](https://developer.mozilla.org/en-US/docs/Web/HTTP/Reference/Headers/Content-Encoding).

### Choosing the compression layer and level

1. Draw the delivery path: Application ← Reverse Proxy ← CDN ← Client. Inspect behavior at each hop, not only the application setting.
2. Name one owner for the policy. If multiple layers transform data, define responsibility for headers, validators, decompression, and recompression.
3. Set MIME types, minimum size, and allowed algorithms. Suitable thresholds depend on your data, CPU, and network conditions.
4. For high-traffic dynamic responses, choose a compression level using p95/p99 and CPU. Fewest bytes do not necessarily mean lowest latency.
5. When possible, precompress static assets and distribute them. For streaming responses, also measure buffer cost and flush behavior.

Compression may suit medium or large text responses over constrained links. It may produce little or negative benefit for very small responses, already-compressed files, or a CPU-bound service. If unnecessary data is being sent, fix the [payload](../01-payload-size/README.md) first; after decompression, the client still parses extra data.

## Worked HTTP example and back-of-the-envelope calculation

<div dir="ltr" align="left">

```http
GET /v1/orders?page_size=50 HTTP/1.1
Host: api.example.test
Accept: application/json
Accept-Encoding: gzip
```

```http
HTTP/1.1 200 OK
Content-Type: application/json
Content-Encoding: gzip
Vary: Accept-Encoding

[gzip-encoded bytes of the JSON representation]
```

</div>

The final line is a teaching placeholder for binary body bytes; do not send that literal text from a server. We intentionally omit a numeric `Content-Length` because its value must be computed from the actual output bytes.

**Hypothetical scenario:** The JSON is 200 KiB; a local gzip measurement produces 40 KiB. The output/input ratio is 0.2 and byte savings are 80%. On a hypothetical 1 MiB/s link, pure transfer time falls from about 195 to 39 ms; this excludes RTT, queueing, TLS, and processing. Compression taking 5 ms may be worthwhile; adding 200 ms of CPU queueing under load may make it worse. These are not production results.

## Exercise and worked measurement

On your own local or test endpoint with a sufficiently large JSON response, send two requests to the same URL with the same authorization. `localhost:8080` is hypothetical; replace it with your test service. Use `curl.exe` on Windows:

<div dir="ltr" align="left">

```powershell
curl.exe -sS -H "Accept-Encoding: identity" -D identity-headers.txt -o identity-body.bin -w "bytes=%{size_download} total=%{time_total}\n" "http://localhost:8080/v1/orders?page_size=50"
curl.exe -sS -H "Accept-Encoding: gzip" -D gzip-headers.txt -o gzip-body.bin -w "bytes=%{size_download} total=%{time_total}\n" "http://localhost:8080/v1/orders?page_size=50"
Get-Item -LiteralPath .\identity-body.bin, .\gzip-body.bin |
    Select-Object Name, Length
```

</div>

We omit `--compressed` so the tool does not automatically decompress the body; if accepted as gzip, the second file contains compressed bytes. **Expected:** on an eligible path, the second header says `Content-Encoding: gzip` and the downloaded size is smaller; the first response must not claim gzip. If there is no difference, inspect MIME type, minimum-size threshold, supported encoding, and proxy behavior. Compare multiple times with fixed data and known cache state; one timing result does not prove improvement. To verify the decoded JSON, make a separate request with `--compressed`.

### Worked calculation and diagnosis

If a sample reports `identity=204800` and `gzip=51200` downloaded bytes, the compressed output is one quarter of the original and byte savings are `(204800−51200)/204800=75%`. Alongside the number, verify that the compressed response has `Content-Encoding: gzip` and the raw response does not claim gzip. If sizes match, start with headers and MIME type, then inspect the minimum-size threshold and proxy/CDN settings. One timing sample is insufficient to conclude anything about CPU or latency.

## Real evidence and limits

**Cloudflare operational documentation:** compression from the origin to Cloudflare and from Cloudflare to a visitor are separate paths. This reverse proxy can convert between uncompressed and compressed representations, and some content changes require decompression and recompression. Therefore, headers and size observed at the origin need not match the final client response. [Cloudflare: Content compression](https://developers.cloudflare.com/speed/optimization/content/compression/).

This is evidence of a real service’s behavior; it is not a comparative test of our application or a guaranteed savings percentage. Recheck CDN settings and limits at deployment; do not treat a product-specific threshold as a universal HTTP constant.

## Failures, risks, and signals

| Failure | Signal | Action |
| --- | --- | --- |
| Very heavy level on a dynamic response | Fewer bytes, higher CPU and p99 | Compare lighter levels and identify the owning layer |
| Incorrect header or incompatible repeat conversion | Client decode/JSON failure | Compare actual bytes and headers at every hop |
| Incomplete `Vary` | Issue only for some clients behind a cache | Correct representation policy and cache key |
| Trusting decoded DevTools size as transfer size | Incorrect savings report | Record transfer and decoded sizes separately |
| Buffering a whole streaming response | More memory and later first byte | Inspect buffer size and flush behavior |

**Sensitive content:** Combining secrets and attacker-controlled input in one dynamic compressed response can leak information through changes in response length; HTTPS alone does not fix this. ASP.NET Core documentation warns about compression on dynamic secure responses. This does not mean all compressed JSON is unsafe; assess the endpoint and threat model. [Microsoft: Response compression](https://learn.microsoft.com/en-us/aspnet/core/performance/response-compression?view=aspnetcore-10.0).

### Operational checklist

- [ ] MIME types, threshold, encodings, and policy owner are clear.
- [ ] Requests without compression and with each supported encoding return correctly.
- [ ] `Content-Encoding`, `Vary`, and body length match actual bytes.
- [ ] Decompressed size, compression ratio, CPU, TTFB, and p95/p99 are recorded.
- [ ] Final behavior after proxy/CDN and cache effects is checked.
- [ ] Sensitive and already-compressed responses are reviewed separately.
- [ ] Buffer memory and flush delay are observed for streaming.

## Quiz

1. What is the difference between `Accept-Encoding` and `Content-Encoding`?
2. Why is `Vary: Accept-Encoding` needed when encoding selection depends on the request?
3. Should `Content-Type` for compressed JSON change to `application/gzip`?
4. Output fell from 200 KiB to 40 KiB but p99 worsened. What two checks come next?
5. Is `Content-Encoding` at the origin alone enough to prove what the client received?
6. Why is “compress every HTTPS response at the heaviest level” indefensible?

### Explained answers

1. The first states client capabilities/preferences; the second reports the encoding actually applied to the response body.
2. A cache must distinguish representations that depend on client capability, or it may deliver the wrong one.
3. No. The decompressed media type remains JSON; `Content-Encoding` describes its transfer transformation.
4. Measure CPU and compression/queue time, and inspect buffering/TTFB; fewer bytes alone do not establish lower end-to-end latency.
5. No. A proxy/CDN may transform or recompress it. Inspect the bytes and headers from the consumer side too.
6. CPU cost, size and content type, buffering, and sensitive-content risk vary; choose level and scope based on measurement.

## Summary

Compression reduces transfer bytes only; CPU, decoding, and decompressed content remain. Coordinate encoding with client capability, `Vary`, the responsible layer, and what the consumer receives. Read transfer size together with server cost.

## Optional references and further reading

The header model and worked calculation are complete on this page. These links are optional further reading and specific implementation references.

- Persian, supplementary Nginx example: [Compression and caching static files](https://mehdimj.ir/blog/2026/10/08/nginx-night-16-static-cache-compression/); its scope is static-file MIME, `gzip_vary`, and header inspection.
- English, primary standard: [RFC 9110 — HTTP Semantics](https://www.rfc-editor.org/rfc/rfc9110.html), for `Accept-Encoding` and `Content-Encoding` semantics.
- English, primary standard: [RFC 9111 — HTTP Caching](https://www.rfc-editor.org/rfc/rfc9111.html), for cache variants and `Vary`.
- English, educational: [MDN Compression in HTTP](https://developer.mozilla.org/en-US/docs/Web/HTTP/Guides/Compression), for negotiation and algorithm differences.
- English, reference: [MDN Content-Encoding](https://developer.mozilla.org/en-US/docs/Web/HTTP/Reference/Headers/Content-Encoding), for body and media-type interpretation.
- English, first-party implementation: [Microsoft response compression](https://learn.microsoft.com/en-us/aspnet/core/performance/response-compression?view=aspnetcore-10.0), for trade-offs, HTTPS considerations, and a .NET example; .NET is not required to understand this lesson.
- English, first-party product docs: [Cloudflare content compression](https://developers.cloudflare.com/speed/optimization/content/compression/), for multi-stage delivery and proxy transformations.

[API Response chapter](../README.en.md) · [Course contents](../../README.en.md) · [Previous: Payload](../01-payload-size/README.en.md) · [Next: Pagination](../03-efficient-pagination/README.en.md)

**Related:** [Streaming](../../06-code-optimization/01-streaming-large-bodies/README.en.md) · [CDNs](../../10-network/03-cdn-for-static-and-frequent-content/README.en.md) · [Network latency](../../10-network/01-region-and-network-latency/README.en.md)

</div>
