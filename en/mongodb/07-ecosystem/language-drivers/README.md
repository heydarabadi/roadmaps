# Language Drivers and Connection Pools

> **Persian edition:** [Read this lesson in Persian](../../../../fa/mongodb/07-ecosystem/language-drivers/README.md).

> **Learning goal:** Use an official driver, reuse its client, and manage connections and timeouts through the application lifecycle.

## What a driver does

A MongoDB driver maps application-language values to BSON, discovers servers, manages connections, sends commands, and converts results. Use the official driver for the chosen language and server version. Keep shell syntax separate from driver APIs: a `mongosh` example is not automatically valid application code.

## Create a long-lived client

In a typical service, create one `MongoClient` for the service process and reuse it. The client maintains connection pools and handles topology discovery. Constructing a new client on every request creates connection churn, repeated handshakes, extra server load, and slower requests.

~~~javascript
import { MongoClient } from "mongodb"

const client = new MongoClient(process.env.MONGODB_URI, {
  maxPoolSize: 50,
  serverSelectionTimeoutMS: 5000
})

await client.connect()
const db = client.db("shop")
~~~

The values are examples, not universal production settings. Tune pool limits, selection timeouts, socket timeouts, and application concurrency using measured traffic and driver guidance. Close the client during orderly process shutdown.

## Pool sizing and operations

A pool bounds concurrent connections from one client to a server. More connections do not automatically mean higher throughput; too many can increase memory and context-switching costs. Estimate request concurrency, number of application instances, and per-node limits. Monitor pool wait time and checked-out connections before raising `maxPoolSize`.

Use explicit timeouts and cancellation behavior. A database timeout is not proof that a write did not occur; operations with business side effects still need idempotency and status reconciliation. Avoid logging the full URI because it may contain credentials.

## Error handling and observability

Separate connection startup failures from operation failures. Log safe metadata such as operation type and duration, not secrets or unrestricted document contents. Track pool wait, server-selection errors, command latency, retry count, and topology changes. Driver versions can change supported API and retry behavior, so pin and upgrade intentionally.

## Exercise

Draw the lifecycle of one application process from startup to shutdown. Mark where the client is created, how a request selects a collection, where timeouts apply, and which metrics reveal pool saturation.

## Common mistakes

- Creating a new client for each request.
- Increasing pool size without measuring the bottleneck.
- Treating every timeout as a failed write.
- Mixing shell and driver APIs.
- Exposing credentials in logs or error reports.

## Quiz and answer key

1. **What does a MongoDB driver do?** Handles connection/topology behavior, BSON conversion, commands, and returned values.
2. **How many clients should a typical service create?** Usually one long-lived client per service process, reused across requests.
3. **What does a connection pool manage?** Reusable connections and their concurrent use to database servers.
4. **Why avoid a new client per request?** It creates pools and handshakes repeatedly, causing connection churn and resource use.
5. **Applied task: design startup and health checks.** Create the client at startup, connect and verify a safe readiness condition, reuse it, track pool/selection errors, and close it on shutdown.
6. **Does a larger pool always improve performance?** No. It can add resource overhead and may not fix slow queries or CPU saturation.
7. **What can a timeout mean for a write?** The outcome may be unknown; check durable application state before repeating it.
8. **Why pin driver versions?** To control API and behavior changes and schedule validated upgrades.
9. **Which pool signal can reveal saturation?** Wait time or checked-out connections relative to pool capacity.
10. **What should not be included in logs?** Credentials, keys, and uncontrolled sensitive document contents.

## Further reading

- [MongoDB Drivers](https://www.mongodb.com/docs/drivers/)
- [Node.js Driver](https://www.mongodb.com/docs/drivers/node/current/)
- [Node.js Connection Pools](https://www.mongodb.com/docs/drivers/node/current/connect/connection-options/connection-pools/)
- [Java Driver](https://www.mongodb.com/docs/drivers/java/sync/current/)
- [Python Driver](https://www.mongodb.com/docs/languages/python/pymongo-driver/current/)
- [Go Driver](https://www.mongodb.com/docs/drivers/go/current/)
- [Curated reference library: drivers and pools](../../reference-library.md#ecosystem-drivers)

---
Sources reviewed: 2026-11-11. Consult the current driver docs for the language and version in use.
