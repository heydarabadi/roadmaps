<div dir="ltr" align="left">

# Redis Pub/Sub: Live, Ephemeral Notifications

> Persian edition: [Read this lesson in Persian](README.md)

> Path: Chapter 4, advanced features · Level: beginner to intermediate · Time: 50–80 minutes
>
> Run the examples on a disposable Redis instance. Pub/Sub is designed for messages that may be lost.

## Learning objectives

- Understand `PUBLISH`, `SUBSCRIBE`, `UNSUBSCRIBE`, `PSUBSCRIBE`, and channel messages.
- Explain why Pub/Sub is not a durable queue and why messages missed while offline cannot be replayed.
- Compare Pub/Sub with Streams, Lists, and durable brokers for a specific delivery need.
- Include channel permissions and state recovery after reconnect in a design.

## The central idea

Pub/Sub is an online broadcast mechanism. A publisher sends a message to a channel, and currently connected subscribers receive it. Redis does not retain the message for consumers, collect an acknowledgment, or provide a consumer group. Pub/Sub fits “notify whoever is online now,” not “keep this until every worker has processed it.”

```text
Publisher --PUBLISH(channel, payload)--> Redis
                                      /     \
                              subscriber A  subscriber B
                              (connected)    (offline = no replay)
```

## 1. First experiment in two terminals

In Terminal A, open a subscription:

```text
SUBSCRIBE lab:notifications
```

You should see a response containing `subscribe`, the channel name, and the number of subscriptions. In Terminal B, publish a message:

```text
PUBLISH lab:notifications "deployment-ready"
(integer) 1
```

The reply is the number of subscribers that received this message, not the number of durable copies or completed business operations. If nobody is subscribed, it may return zero and the payload is not saved for later.

## 2. Exact channels and patterns

`SUBSCRIBE` takes an exact channel name. `PSUBSCRIBE` can listen to several channels with a pattern:

```text
PSUBSCRIBE orders:*
PUBLISH orders:created "order=501"
PUBLISH orders:cancelled "order=501"
```

A pattern may receive more messages than intended. Define a message schema with fields such as `channel`, `event_type`, `event_id`, `schema_version`, and payload. If you publish several event types, parse the message and pattern-match response correctly in the client. A channel name is not an authorization boundary; configure ACL channel permissions separately.

## 3. Delivery and recovery guarantees

Redis Pub/Sub is **at-most-once**: a message is delivered to a connected subscriber or lost; the server does not resend it to a disconnected subscriber. If a consumer crashes after receipt, the publisher cannot tell whether the work completed. Pub/Sub has no application-level acknowledgment.

For a UI notification channel, this may be acceptable: after reconnecting, the UI fetches a fresh snapshot from an API or primary database and then listens for live updates. For inventory changes or payments, it is usually insufficient; messages may be lost, and application logic may also publish duplicates. Keep the source of truth elsewhere and send a small entity or event ID so subscribers can reload authoritative state.

### Choose a suitable tool

| Need | Usual option |
| --- | --- |
| Live updates for online clients; loss is acceptable | Pub/Sub |
| Retained messages, replay, PEL, and acknowledgment by group | Redis Streams |
| Simple work list with visibility/ack designed by your application | List or Sorted Set with your own protocol |
| Long retention, large-scale replay, and an established streaming ecosystem | Evaluate Kafka or a similar system |

Do not choose a system just because it is called a “queue.” Compare retention, throughput, ordering needs, independent consumers, durability, failure recovery, and your team's operational experience.

## 4. Sharding, keyspace notifications, and connections

In Redis Cluster, regular Pub/Sub and sharded Pub/Sub have different fan-out behavior. Redis 7 introduced `SSUBSCRIBE`, `SPUBLISH`, and `SUNSUBSCRIBE` for sharded Pub/Sub, with shard-scoped message delivery. Check behavior, client support, and configuration for the version you run.

Keyspace notifications are a separate feature: Redis can publish events such as key changes, expirations, and evictions to special channels. Account for configuration, overhead, and the transient delivery model. These notifications are not a durable log of changes; do not treat them as the authoritative event source for a critical workflow.

A client usually needs a dedicated connection for subscriptions because that connection receives asynchronous messages while in subscribed mode. Do not reuse an ordinary pooled connection without checking your client library's behavior. Implement timeout, reconnect, and shutdown handling.

## 5. Published incident: a cache/database feedback loop

Meta's engineering postmortem about a 2010 outage describes a cache invalidation/repair process that interpreted an error as an invalid value and removed a cache key. Additional database queries increased load, creating a feedback loop: errors triggered more requests. This was not a Redis incident and did not involve Pub/Sub. The design lesson also applies to subscribers and cache invalidation: do not equate an error with “the data is definitely corrupt,” limit retries, use backoff, reread authoritative state, and protect the system from a returning-client burst. [Engineering at Meta: More details on today's outage](https://engineering.fb.com/2010/09/23/uncategorized/more-details-on-todays-outage/)

## Lab: invalidate without losing authoritative state

Terminal A:

```text
SUBSCRIBE product:updates
```

Terminal B:

```text
SET product:501:version 12
PUBLISH product:updates "product=501 version=12"
GET product:501:version
```

The message tells a client which record to reload. Now disconnect Terminal A, publish another update, and reconnect: the old message does not return. Explain how the client can repair the gap by reading the authoritative version or a fresh snapshot. `product:501:version` is a teaching example, not a complete cache invalidation design.

## Security and operations

- Do not treat a channel name as a security boundary. Configure ACL channel patterns such as `&pattern` and command permissions; test with separate application users.
- Do not broadcast personal information or secrets; many subscribers may receive the payload.
- Logging payloads can copy sensitive data. Often an identifier and correlation ID are enough.
- Monitor connected subscriber count, reconnect rate, parser errors, and publish rate in the application. A publish count does not prove a business operation succeeded.
- For cache invalidation, define how state is rebuilt after an outage or missed message.

## Troubleshooting and common pitfalls

- **No message arrives:** Check the exact channel name, ACL, endpoint, and subscription state.
- **`PUBLISH` returns zero:** There was no active subscriber; no backlog was stored.
- **State is stale after reconnect:** There is no snapshot or read-repair path; Pub/Sub does not fill the gap.
- **Every channel reaches every client:** The pattern may be too broad, or ACLs may not constrain channels.
- **Pub/Sub is used for a critical workflow:** Move the event to Streams or a durable queue, or write a durable outbox in the source database.
- **Reconnect causes a burst of requests:** Design jitter, backoff, coalescing, and a snapshot endpoint.

## Exercises with answers

1. Why is the `PUBLISH` return value not a measure of “message processed”?
2. What guarantee do you have about messages during a two-minute subscriber outage?
3. What state should a live dashboard reload after reconnect?
4. Which is a better starting point for confirming an order: Pub/Sub or Streams? Explain using acknowledgment and retention.
5. How should you secure Pub/Sub notifications?

<details><summary>Explanations</summary>

1. It counts online subscribers that received that message; it is not an acknowledgment or proof that a business operation completed.
2. There is no replay guarantee. Messages published while the subscriber is disconnected are missed.
3. Fetch a snapshot from an authoritative API or source, then subscribe for later changes. The design must close the gap between the snapshot and subscription.
4. Streams or a durable broker is a better fit because entries, groups, and acknowledgments/recovery are available. Idempotency and a durability policy are still necessary.
5. Configure channel and command ACLs, isolate application users, keep payloads low-sensitivity, and restrict patterns.

</details>

## Quiz with answers

### 1. Does Redis retain Pub/Sub messages for offline subscribers?

<details><summary>Answer</summary>

No. Pub/Sub messages are transient.

</details>

### 2. What does the `PUBLISH` return value count?

<details><summary>Answer</summary>

The subscribers that were online and received that message.

</details>

### 3. Does Pub/Sub provide an acknowledgment?

<details><summary>Answer</summary>

No. Redis does not confirm that a subscriber completed its side effect.

</details>

### 4. Is a keyspace notification a durable change log?

<details><summary>Answer</summary>

No. Do not treat it as an authoritative history.

</details>

### 5. Where should order events go?

<details><summary>Answer</summary>

Compare Streams or a durable broker with the actual requirements, and make message processing idempotent.

</details>

### 6. What is required after reconnect?

<details><summary>Answer</summary>

Reload authoritative state or use a durable mechanism to repair the missed interval.

</details>

## References and further reading

### English: official documentation and engineering articles

- [Redis Pub/Sub guide](https://redis.io/docs/latest/develop/pubsub/) — channels, subscribers, and message behavior.
- [Redis Pub/Sub use-case guide](https://redis.io/docs/latest/develop/use-cases/pub-sub/) — patterns and design constraints.
- [PUBLISH command reference](https://redis.io/docs/latest/commands/publish/) and [SUBSCRIBE command reference](https://redis.io/docs/latest/commands/subscribe/).
- [Pattern subscriptions](https://redis.io/docs/latest/commands/psubscribe/) — glob-style channel subscriptions.
- [Sharded Pub/Sub guide](https://redis.io/docs/latest/develop/pubsub/#sharded-pubsub) — Redis Cluster behavior and commands.
- [Keyspace notifications guide](https://redis.io/docs/latest/develop/pubsub/keyspace-notifications/) — event notifications and configuration.
- [Redis streaming use-case guide](https://redis.io/docs/latest/develop/use-cases/streaming/) — compare transient Pub/Sub with retained Streams.
- [Engineering at Meta: More details on today's outage](https://engineering.fb.com/2010/09/23/uncategorized/more-details-on-todays-outage/) — a cache/database feedback-loop incident, not a Redis case.

### فارسی

- [آموزش فارسی Redis در زبان سلام](https://www.salamlang.ir/std/db/redis/)
- [جست‌وجوی ویدیوهای فارسی Redis Pub/Sub](https://www.youtube.com/results?search_query=آموزش+فارسی+Redis+PubSub)
- [مرور فارسی ساختارهای Redis در DNTips](https://www.dntips.ir/exports/posts/www.dntips.ir-posts-3088.pdf)

Specialized Persian Pub/Sub references are limited. This file teaches the core model and experiment directly. Check your Redis and client-library versions for sharded Pub/Sub and ACL details.

</div>

