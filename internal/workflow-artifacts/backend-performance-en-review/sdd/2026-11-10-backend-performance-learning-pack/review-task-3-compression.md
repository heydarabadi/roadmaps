# Task 3 omitted snapshot

## Snapshot: Backend Performance/02-api-response/02-response-compression/README.md

   1: <div dir="ltr" align="left">
   2: 
   3: # response compression — Response Compression
   4: 
   5: Compression makes the byte representation of the same content smaller for transmission; It does not semantically abstract JSON. Server and client must agree on Encoding. Byte reduction reduces network overhead, but compressing and decompressing it requires CPU; A good decision is the result of comparing these costs.
   6: 
   7: **After this lesson, you can:** Explain the role of the three main headers; Don't confuse the transfer size with the opened body; Determine the layer responsible for compression; And measure network gain along with CPU, latency and sensitive content risk. Prerequisite: HTTP Header and [Payload Size](../01-payload-size/README.md). Source review date: **11-10-2026**.
   8: 
   9: ## How does Encoding negotiation work?
  10: 
  11: Component | role Example
  12: --- | --- | --- |
  13: `Accept-Encoding` in request | Acceptable algorithms for the client `gzip, br` |
  14: `Content-Encoding` in reply | Encoding actually applied to the body `gzip` |
  15: `Vary: Accept-Encoding` in reply | Inform the Cache about the dependence of the display on the Request Header The compressed and raw versions should not be delivered to each other by mistake
  16: `Content-Type` | Opened content type Still `application/json` |
  17: 
  18: The client declares its support; The server selects an acceptable and supported Encoding and sends the body with it. When the display selection depends on `Accept-Encoding`, `Vary` must express this dependency. gzip is usually useful for text/JSON; Compressing a JPEG or ZIP again is usually of little benefit. [MDN: Compression in HTTP] (https://developer.mozilla.org/en-US/docs/Web/HTTP/Guides/Compression)
  19: 
  20: You should not send raw JSON body by adding only `Content-Encoding: gzip`; The header must describe the actual bytes. On the contrary, gzip body without proper Header cannot be interpreted by the consumer. `Content-Length`, if present, specifies the length of the encoded message; Do not copy it after changing the Encoding from the previous value. [MDN: Content-Encoding](https://developer.mozilla.org/en-US/docs/Web/HTTP/Reference/Headers/Content-Encoding)
  21: 
  22: ### Choosing the location and level of compression
  23: 
  24: 1. Write the delivery path: Application → Reverse Proxy → CDN → Client. See the response behavior at each hop, not just the program setting.
  25: 2. Set a clear owner for the Policy. If they convert multiple layers, the responsibility of Header, Validator and Decompression/Recompression should be known.
  26: 3. Specify the MIME Type, minimum size, and allowed algorithms. The appropriate threshold depends on your data, CPU, and network conditions.
  27: 4. Select compression level with p95/p99 and CPU for high traffic dynamic response. The lowest byte is not necessarily the lowest latency.
  28: 5. Precompress and distribute fixed assets if possible; For streaming response, consider Buffer and Flush cost as well.
  29:30: Compression is suitable for medium/large text response on limited link. For a very small response, a pre-compressed file, or a CPU-bound service, the benefit may be negligible or negative. If you are sending unnecessary data, first modify [Payload](../01-payload-size/README.md); The client will continue to parse additional data after opening.
  31: 
  32: ## Solved example of HTTP and thumb account
  33: 
  34: <div dir="ltr" align="left">
  35: 
  36:```http
  37: GET /v1/orders?page_size=50 HTTP/1.1
  38: Host: api.example.test
  39: Accept: application/json
  40: Accept-Encoding: gzip
  41: ```42: 
  43:```http
  44: HTTP/1.1 200 OK
  45: Content-Type: application/json
  46: Content-Encoding: gzip
  47: Vary: Accept-Encoding
  48: 
  49: [gzip-encoded bytes of the JSON representation]
  50: ```51: 
  52: </div>
  53: 
  54: The last line is the educational representation of the binary body; You should not implement that text as the actual body of the server. In the example above, we deliberately did not write a number `Content-Length`, because the length must be calculated from the actual output byte.
  55: 
  56: **hypothetical scenario:** JSON equals 200 KiB; The result of local gzip measurement is 40 KiB. Output to input ratio is 0.2 and byte saving is 80%. On a hypothetical 1 MiB/s link, the net transfer portion goes from about 195 to 39 ms; RTT, queue, TLS and processing are not included in this account. If compression costs 5 milliseconds, there is a possibility of profit; This choice may be worse if it adds 200ms of CPU queue under load. These numbers are not production reports.
  57: 
  58: ## Short exercise: see the actual response from the client side
  59: 
  60: On your local Endpoint or test environment that has a big enough JSON response, send two requests to the same URL with the same permission. `localhost:8080` is hypothetical in this exercise and should be replaced with your test service. On Windows use `curl.exe`:
  61: 
  62: <div dir="ltr" align="left">
  63: 
  64:```powershell
  65: curl.exe -sS -H "Accept-Encoding: identity" -D identity-headers.txt -o identity-body.bin -w "bytes=%{size_download} total=%{time_total}\n" "http://localhost:8080/v1/orders?page_size=50"
  66: curl.exe -sS -H "Accept-Encoding: gzip" -D gzip-headers.txt -o gzip-body.bin -w "bytes=%{size_download} total=%{time_total}\n" "http://localhost:8080/v1/orders?page_size=50"
  67: Get-Item -LiteralPath .\identity-body.bin, .\gzip-body.bin |
  68:     Select-Object Name, Length
  69: ```70: 
  71: </div>
  72: 
  73: `--compressed` is not used in these two commands so that the body tool does not open automatically; The second file has compressed bytes if gzip is accepted. **Expect:** In the qualified path, the second Header is `Content-Encoding: gzip` and the transmitted size is smaller; The first answer should not claim gzip. If no difference, check MIME Type, Threshold, Supported Encoding and Proxy behavior. Compare several times with fixed data and specified Cache mode; A time measurement does not prove improvement. You can send a separate request with `--compressed` to check the validity of the unpacked JSON.
  74: 
  75: ## True witness and its limits
  76: 
  77: **Cloudflare operational documentation:** Compressing the origin path to the Cloudflare network and its path to the visitor is separate. This Reverse Proxy can convert between raw and compressed rendering, and some content changes require decompression and recompression. Practical consequence for troubleshooting: Header and size observed in Origin are not necessarily the same as the final output of the client. [Cloudflare: Content compression] (https://developers.cloudflare.com/speed/optimization/content/compression/)
  78: 
  79: This evidence comes from the behavior of a real service; Our program is not a comparative test or a percentage savings guarantee. Double-check your CDN settings and limitations when running; Do not make an "HTTP standard number" out of a product-specific threshold.
  80: 
  81: ## failures, risks and symptoms
  82: 
  83: Failure Sign | Action |
  84: --- | --- | --- |
  85: Very heavy level on dynamic response Fewer bytes, more CPU and p99 | Compare lighter layers and layer owner
  86: Incorrect header or incompatible conversion Decode/JSON error in client | Check the real byte and header of each hop together
  87: `Vary` Incomplete | The problem is only for part of the clients behind Cache Modify display policy and cache key
  88: Relying on DevTools' unpacked size instead of transferring | Wrong savings report Record transfer size and decoded size separately
  89: Buffering the entire streaming response Increasing the memory and time of the first byte Check Buffer size and Flush behavior
  90: 
  91: **Sensitive Content:** Combining secret data and attacker-controllable input in a dynamically compressed response can leak information from changing the response length; HTTPS does not solve this problem alone. The ASP.NET Core documentation warns about the risk of compression on dynamic and secure responses. This does not mean that all compressed JSON is unsafe; Check the sensitive endpoint and threat model. [Microsoft: Response compression] (https://learn.microsoft.com/en-us/aspnet/core/performance/response-compression?view=aspnetcore-10.0)
  92: 
  93: ### Operational checklist
  94: 
  95:- [ ] MIME Type, Threshold, Encoding and Owner Policy are on.
  96: - [ ] request without compression and with any supported encoding gets correct response.
  97: - [ ] `Content-Encoding`, `Vary` and body length are compatible with actual bytes.
  98:- [ ] Decompressed size, compression ratio, CPU, TTFB and p95/p99 are recorded.
  99: - [ ] Checked final behavior after Proxy/CDN and Cache effect.
 100: - [ ] Sensitive responses and pre-compressed data are checked separately.101:- [ ] For Streaming, Buffer memory and Flush latency are under observation.
 102: 
 103: ## test
 104: 
 105: 1. What is the difference between `Accept-Encoding` and `Content-Encoding`?
 106: 2. Why is `Vary: Accept-Encoding` necessary in selecting Encoding based on request?
 107: 3. Should `Content-Type` change compressed JSON response to `application/gzip`?
 108: 4. The output has gone from 200 to 40 KiB, but p99 has gotten worse; What are the next two reviews?
 109: 5. Is just seeing `Content-Encoding` in Origin enough to prove the final output?
 110: 6. Why is "compress all HTTPS responses with the heaviest level" not a defensible decision?
 111: 
 112: ### descriptive answer
 113: 
 114: 1. The first expresses the client's ability/preference; The latter declares the Encoding actually applied to the response body.
 115: 2. Cache must recognize representations dependent on client capability; Otherwise it may deliver inappropriate display.
 116: 3. No; The unwrapped content type is still JSON. `Content-Encoding` describes its transitive transformation.
 117: 4. Measure CPU and queuing/compression time and see Buffer/TTFB; Fewer bytes are not enough for total latency.
 118: 5. No; Proxy/CDN may perform conversion or recompression. From the consumer's point of view, check both Header and Byte.
 119: 6. CPU cost, size and type of content, buffering and risk of sensitive content are different; Level and range should be selected by measurement.
 120: 
 121: ## Further study
 122: 
 123: - [Persian: EnginX; Fixed file compression and cache] (https://mehdimj.ir/blog/2026/10/08/nginx-night-16-static-cache-compression/): MIME short practice, `gzip_vary` and Header viewing; The example domain is a fixed file.
 124: - [English: MDN Compression in HTTP] (https://developer.mozilla.org/en-US/docs/Web/HTTP/Guides/Compression): content negotiation model and algorithm differences.
 125: - [English: MDN Content-Encoding](https://developer.mozilla.org/en-US/docs/Web/HTTP/Reference/Headers/Content-Encoding): body interpretation reference and content type.
 126: - [English: Microsoft response compression](https://learn.microsoft.com/en-us/aspnet/core/performance/response-compression?view=aspnetcore-10.0): Trade-off, HTTPS considerations and an example implementation; .NET dependency is not required to understand this lesson.
 127: - [English: Cloudflare Content compression](https://developers.cloudflare.com/speed/optimization/content/compression/): Multi-stage delivery and Proxy transformations.
 128: 
 129: **Navigation:** [API Response Chapter](../README.md) · [Main Index](../../README.md) · [Previous: Payload](../01-payload-size/README.md) · [Next: Pagination](../03-efficient-pagination/README.md)
 130: 
 131: **Related:** [Streaming](../../06-code-optimization/01-streaming-large-bodies/README.md) · [CDN](../../10-network/03-cdn-for-static-and-frequent-content/README.md) · [Network Latency](../../10-network/01-region-and-network-latency/README.md)
 132: 
 133: </div>