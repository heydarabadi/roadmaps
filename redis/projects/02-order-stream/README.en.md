<div dir="ltr" align="left">

# Project 2 — Order Event Processing with Redis Streams

> Level: intermediate · Time: 120–180 minutes · All keys use lab: and should be used only in local Redis.

> Persian edition: [پروژهٔ ۲ — پردازش رویداد سفارش با Redis Streams](README.md)

## Problem

After an order is placed, a service emits an order-created event. Different workers may handle reservation, email, and analytics. A consumer can crash, so the group must track delivered-but-unacknowledged work and recover it. A message may be processed more than once, so its side effect must be idempotent.

Streams provide an event log and consumer groups. They do not by themselves guarantee exactly-once execution of an external database or payment side effect. For critical business events, compare a transactional outbox in the database or a suitable broker with the real architecture.

## Vocabulary and flow

- **Stream entry:** an ordered ID plus fields and values.
- **Consumer group:** workers that divide entries for one logical role.
- **PEL:** Pending Entries List of delivered but unacknowledged messages.
- **XACK:** marks an entry processed for a group; it does not automatically delete the entry from the Stream.
- **Claim/recovery:** transfers old pending work from a dead consumer to a live one.
- **Idempotency:** repeating an event does not create an unintended second business effect.

~~~text
producer --XADD--> stream --> consumer group --> worker
                                       |            |
                                       |        idempotent side effect
                                       +--pending--XACK after success
~~~

## Step 1 — Create a Stream and group

Use 0 to read existing entries. If a new group should receive only future entries, use the current end marker when creating it. Choose deliberately for this lab.

~~~text
DEL lab:orders:events lab:orders:dead
XGROUP CREATE lab:orders:events order-workers 0 MKSTREAM
XINFO GROUPS lab:orders:events
~~~

If the group already exists, Redis returns BUSYGROUP. Do not blindly delete and recreate a group in production; doing so can lose its cursor and pending state.

## Step 2 — Produce events

~~~text
XADD lab:orders:events * event_id evt-1001 order_id 1001 type order.created schema 1 customer_id 7
XADD lab:orders:events * event_id evt-1002 order_id 1002 type order.created schema 1 customer_id 8
XRANGE lab:orders:events - +
XLEN lab:orders:events
~~~

The asterisk creates the Stream entry ID. event_id is an application-level stable identifier useful for deduplication. Version the payload, avoid unnecessary secrets or personal data, and start with small, clear fields.

## Step 3 — Read through the group

~~~text
XREADGROUP GROUP order-workers worker-1 COUNT 10 STREAMS lab:orders:events >
XPENDING lab:orders:events order-workers
XINFO CONSUMERS lab:orders:events order-workers
~~~

The greater-than marker returns entries not yet delivered to this group. After delivery, an entry is pending for that consumer until acknowledged. Reading again with the same marker does not automatically replay the consumer’s old pending entries; design pending inspection and reclaim separately.

## Step 4 — Acknowledge after successful processing

Copy the actual Stream ID from XREADGROUP (for example, 1794384000000-0) and substitute it below:

~~~text
XACK lab:orders:events order-workers STREAM-ID-FROM-OUTPUT
XPENDING lab:orders:events order-workers
~~~

After acknowledgement, the entry leaves that group’s pending list, but it remains in the Stream. Acknowledge only after the side effect succeeds. If you acknowledge first and the worker crashes before saving its result, the group no longer sees pending work even though the effect never happened.

## Step 5 — Simulate a crash and reclaim pending work

Add another event, let worker-1 read it, and do not acknowledge it:

~~~text
XADD lab:orders:events * event_id evt-1003 order_id 1003 type order.created schema 1 customer_id 9
XREADGROUP GROUP order-workers worker-1 COUNT 10 STREAMS lab:orders:events >
XPENDING lab:orders:events order-workers
~~~

In the application, a healthy consumer can claim work that has been idle long enough. On supported versions, XAUTOCLAIM can do this:

~~~text
XAUTOCLAIM lab:orders:events order-workers worker-2 60000 0-0 COUNT 10
~~~

The 60,000 value is the minimum idle time in milliseconds. If worker-1 is still alive and merely slow, claiming too early can cause concurrent duplicate work. Choose the idle threshold using processing p99, pauses, timeouts, and heartbeat behavior.

## Step 6 — Make processing idempotent

Give every event a stable ID. A handler checks whether processed:<event_id> exists before applying an effect. This small Redis-only simulation updates state and a marker atomically. In Cluster, keys used by one script must be compatible with hash-slot rules.

~~~lua
-- KEYS[1] = lab:order:1001
-- KEYS[2] = lab:processed:evt-1001
-- ARGV[1] = new status; ARGV[2] = stream event ID
if redis.call('EXISTS', KEYS[2]) == 1 then
  return 0
end
redis.call('HSET', KEYS[1], 'status', ARGV[1], 'last_event_id', ARGV[2])
redis.call('SET', KEYS[2], '1', 'EX', 604800)
return 1
~~~

The CLI simulation:

~~~text
HSET lab:order:1001 status accepted
EVAL "if redis.call('EXISTS',KEYS[2]) == 1 then return 0 end; redis.call('HSET',KEYS[1],'status',ARGV[1],'last_event_id',ARGV[2]); redis.call('SET',KEYS[2],'1','EX',604800); return 1" 2 lab:order:1001 lab:processed:evt-1001 accepted 1794384000000-0
HGETALL lab:order:1001
GET lab:processed:evt-1001
~~~

This only simulates state inside Redis. A Redis Lua script cannot create one transaction spanning Redis and an external database, payment provider, or email service. Use the destination’s idempotency key, an outbox/inbox pattern, or a compensating workflow. Lua also does not roll back earlier commands like a SQL transaction after every runtime error; validate inputs and command preconditions.

After the effect and marker succeed, acknowledge the Stream entry. If the worker crashes between the script and XACK, the message may be delivered again, but the marker prevents repeating this simulated state change; the next attempt can acknowledge it.

## Step 7 — Retry and dead letter

Define a bounded retry policy:

1. Retry temporary failures, such as a dependency timeout, with backoff and a maximum attempt policy.
2. Do not reclaim pending entries forever without an attempt counter and an alert.
3. After a threshold, record the event ID and reason in a dead-letter Stream, then acknowledge the original so healthy work can proceed.
4. Replay dead letters under control after checking idempotency and schema.
5. If dead-letter write and original acknowledgement are separate commands, a crash can occur between them. Production needs dedupe/reconciliation or an atomic workflow.

Illustrative dead-letter entry (replace the placeholder with a real ID):

~~~text
XADD lab:orders:dead * original_stream lab:orders:events original_id STREAM-ID reason dependency-timeout event_id evt-1003
~~~

## Step 8 — Retention and trimming

Streams grow. XTRIM with MAXLEN or MINID can bound length or age, but trimming an entry before it has been processed or replayed can remove recovery history. Choose retention based on the longest expected outage, ingest rate, oldest consumer lag, audit requirement, and replay window.

Inspect group lag and pending work before trimming. XDEL removes entries but has separate implications from group pending state. Do not assume that trimming and acknowledgements are the same lifecycle.

## Troubleshooting

| Symptom | Meaning and response |
| --- | --- |
| NOGROUP | The group is missing or named incorrectly; review lifecycle and key name. |
| Duplicate handling | Retry, claim, or crash-before-ack can redeliver; make effects idempotent. |
| PEL keeps growing | Worker is slow, failing, or not acknowledging; inspect XPENDING, consumers, dependency, and processing time. |
| New worker gets nothing | The new-entry marker does not return old pending work; inspect/reclaim pending entries. |
| Message seems missing | Check trim/delete, group cursor, and retention history. |
| Side effect happens twice | Event ID or marker may be unstable, or marker TTL is shorter than replay horizon. |
| One event retries forever | Treat it as a poison message; cap attempts, dead-letter, alert, and define replay. |

## Sample design answer

- Producer uses XADD with immutable event ID, schema version, and idempotent production.
- Separate consumer groups serve independent roles such as fulfillment and analytics; workers of one role share a group.
- Acknowledge only after effect persistence; derive idle timeout from processing latency and retries.
- Deduplicate in each handler by event ID; external APIs also receive their own idempotency token.
- Bound retries and dead-letter poison events; alert on PEL size and oldest pending age.
- Keep retention longer than the recovery/replay window.
- Select persistence, backup, and source of truth based on order criticality; do not confuse a transient Stream with a durable business ledger.

## Deliverable and rubric (12 points)

1. Producer/group/consumer topology and number of groups: 2
2. Pending, acknowledgement, crash, and reclaim: 2
3. Deduplication and real idempotency: 2
4. Retry, dead-letter, and poison-message behavior: 2
5. Retention, trimming, and observability: 2
6. Redis guarantee boundaries and external side effects: 2

## Safe lab cleanup

~~~text
DEL lab:orders:events lab:orders:dead lab:order:1001 lab:processed:evt-1001
~~~

Deleting the Stream removes its consumer groups. Do not use FLUSHDB or FLUSHALL to clean up the project.

## References and further reading

- [Redis Streams guide](https://redis.io/docs/latest/develop/data-types/streams/)
- [XREADGROUP](https://redis.io/docs/latest/commands/xreadgroup/), [XPENDING](https://redis.io/docs/latest/commands/xpending/), [XACK](https://redis.io/docs/latest/commands/xack/), and [XAUTOCLAIM](https://redis.io/docs/latest/commands/xautoclaim/)
- [Transactional outbox pattern — Microsoft](https://learn.microsoft.com/azure/architecture/databases/guide/transactional-out-box-cosmos)
- [Reliable message processing — AWS Prescriptive Guidance](https://docs.aws.amazon.com/prescriptive-guidance/latest/cloud-design-patterns/transactional-outbox.html)
- [You’re Probably Thinking About Redis Streams Wrong — Redis](https://redis.io/blog/youre-probably-thinking-about-redis-streams-wrong)
- [ویدئوی فارسی Redis Streams](https://www.youtube.com/watch?v=_IcgS_NuV-k)
- [مبانی Redis فارسی در SalamLang](https://www.salamlang.ir/std/db/redis/)
- [Netflix write-ahead log article](https://netflixtechblog.com/building-a-resilient-data-platform-with-write-ahead-log-at-netflix-127b6712359a) — this case uses Kafka, not Redis Streams; use it only for broader event-log design context.

</div>

