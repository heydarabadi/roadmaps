# 9.1 — Load Testing, Baselines, and Performance Regressions

**Language:** English · [فارسی](README.md)

A **performance test** examines a system under defined conditions. A **benchmark** is a comparison protocol that holds inputs, environment, execution method, and metrics steady. A **baseline** is the reference version’s result and variation under that protocol. A **regression** is a decline relative to the reference that must be distinguished from noise and changed conditions. Correct results are part of performance: a fast error is not a successful completion.

**Sources reviewed: 2026-11-10.** The plan, data, and calculations in this lesson are educational. No load test, executable test, or real measurement was performed to prepare this page.

## Learning outcomes

- Distinguish Load, Stress, Spike, and Soak by their goals and load patterns.
- Design a representative workload and repeatable baseline before finalizing thresholds.
- Interpret planned load, achieved load, correct work, and errors separately.
- Recognize environmental noise, unrealistic data, and load-generator limits.
- Compare reference and new versions against both an absolute product target and a relative regression limit.

Prerequisite: basic familiarity with web requests and responses. Percentiles, goodput, errors, baselines, and measurement boundaries are explained here. [Metrics, Logs, and Traces](../../07-monitoring-and-logging/01-metrics-logs-and-traces/README.en.md) is optional further study. A real run requires a load-generation tool and system observability; the exercises here are paper exercises.

## Basic terms for reading a result

A **request** is incoming work and a **response** is its reply. For a background job, however, an API response may only acknowledge that work was accepted; the job itself can finish later. Define **response time** for a specific boundary and population: which event starts the clock and which event stops it? For queued work, keep queue wait before execution separate from the work duration.

A **percentile** is a point in an ordered distribution. If p95 is 300 ms, then under the common definition for a population, at least about 95% of measurements completed within 300 ms and the slower tail lies above it. It is neither the mean nor the maximum. Tools may estimate percentiles differently, so keep their versions and settings fixed for comparison. With few samples, the tail is unstable.

**Rate/throughput** is the number of observed work items per unit of time, but state whether you count scheduled, started, or completed work. **Goodput** is correctly completed work in that same interval. A fast failure, timeout, unfinished job, or semantically wrong response can make successful-request latency look good while goodput falls. A **baseline** says how the reference version actually behaved; a **product target** says what behavior is acceptable to the user. They need not be equal.

Read every number with its request/job boundary, population definition, errors, and counting method. If these terms do not match between runs, the version comparison is invalid.

## Choose the test type from the question

| Type | Load pattern | Main question | What it does not prove |
| --- | --- | --- | --- |
| Smoke | Low and brief | Do the scenario, data, and correctness checks work? | Production capacity |
| Load | Representative normal or expected peak load, with a steady phase | Does the service meet its target at this load? | Behavior at every load level |
| Stress | Beyond the expected range, usually in bounded stages | What are the limits, controlled failure modes, and recovery behavior? | That a crash is a desirable target |
| Spike | A rapid rise or fall in rate or concurrency | How do queues, pools, caches, and scaling react to a sudden change? | Long-term behavior |
| Soak / Endurance | Representative load over a duration appropriate to the risk | Do memory, queues, connections, or disk grow over time? | Absence of every leak for every duration |

There is no universal duration or intensity. A Load test can have a ramp; a Spike is characterized by how quickly load changes, not only by a high peak. For Stress, define the failure point using service and recovery criteria, not just the maximum RPS before outage. The [official k6 test-types guide](https://grafana.com/docs/k6/latest/testing-guides/test-types/) describes these patterns using one sample tool; the concepts are not specific to k6 or JavaScript.

A microbenchmark may isolate the cost of a function or serialization and can be useful for that decision. An end-to-end benchmark also observes queues, network, and dependencies within the chosen boundary. A faster function in a microbenchmark does not prove a lower end-to-end request p99; inspect its share of the [critical path](../../06-code-optimization/04-critical-paths/README.en.md).

## 1. Unit of work, target, and representative load

First write down the need: which operation, for which population, with what result and timing boundary? For a job, acceptance time, queue wait, and final completion are separate. For an API, HTTP 200 alone does not prove inventory, amount, or authorization correctness; add semantic assertions. Timeouts, canceled requests, and work not completed by the end of the observation window must appear in the report.

Then use monitoring data or an explicit product assumption to define:

- **Operation mix:** read/write ratios and important paths; do not hide an expensive, infrequent operation in the overall average. A request ratio is not the same as a user-session ratio.
- **Arrival behavior:** arrival rate, changes over time, concurrent users, think time, and gaps between operations. “100 virtual users” alone does not specify a rate.
- **Data and distribution:** dataset size, response size, old/new records, hot keys, users with different permissions, and concurrent access to one product. Sending every request to one ID may test only the cache; fully random IDs may remove a real hotspot.
- **Dependencies and environment:** instance count, CPU/RAM and quotas, runtime/DB/driver versions, indexes, network, TLS and connection reuse, logging, and instrumentation. State the limits of any stub; an instant fake response does not prove behavior with a real dependency.
- **Initial state:** cold and warm caches are different valid scenarios. Label warm-up and separate it from the steady measurement window; do not remove startup cost when startup itself is the subject.

Test data must be valid, reproducible, and representative in size and distribution. For mutating operations, restore the starting state for each run or model inventory consumption/growth in the scenario. Automatic retries are part of the load; record business-operation rate separately from HTTP attempt rate. Record randomization and seed. A fixed seed helps comparison, but several representative distributions are better than trusting one lucky sequence.

## 2. Arrival model: fixed users or independent rate?

In a **closed model**, each user/worker starts its next operation after the current one finishes and any think time elapses. If the system slows, the same user count produces fewer requests. This models some genuinely bounded populations. In an **open model**, the schedule for starting work is independent of the previous work finishing; it is suited to independent arrivals. Neither model is always correct; match it to the test question. The [official k6 guide to open and closed models](https://grafana.com/docs/k6/latest/using-k6/scenarios/concepts/open-vs-closed/) explains the difference.

Ignoring overhead and think time, 20 serial workers with a 0.1-second response time produce about 200 requests/s; with a one-second response time, they produce about 20 requests/s. If the intent was to model 200 independently arriving requests/s, this automatic drop hides pressure. This undercounting of work that should have arrived during a delay is one form of **Coordinated Omission**. A closed model is not wrong for a closed population; the problem is applying its result to independent arrivals.

An open-model generator also has finite resources. Record its CPU, network, connection count, and ready tasks. If 200 work items/s are scheduled but only 150/s start, do not hide the missing 50/s. The run is not adequate or valid evidence for capacity at 200. Understand the tool’s timing boundary too: does it include scheduling delay before sending? A socket timing value may omit the wait before transmission.

## 3. Baselines, repeatability, and noise

Run the reference version several times with the same scenario and retain the **protocol and raw data**: version and test-plan IDs, settings, time, environment, data, load phases, sample counts, errors, and achieved rates. At this stage, learn normal behavior, variation, and scenario validity; do not yet use the new version’s result to choose the threshold.

For a fair comparison:

1. Keep inputs, authentication method, result correctness, load, resources, and cache state equal. A hardware upgrade at the same time as a code change mixes causes.
2. Record interference such as backups, noisy neighbors, CPU throttling, GC, autoscaling, and network changes. If autoscaling is the subject, do not disable it; hold its policy and starting state steady and report transient behavior.
3. Run several reference and new-version executions close in time, alternating the order such as A/B/A/B where possible. Use the same warm-up and data reset contract.
4. Do not discard an unusual run without a reason. Record environmental causes or scenario failures. Do not call a difference within observed variation a definite improvement or keep moving thresholds to get a green result.
5. p99 depends on sample count and sample dependence. With 100 observations, there is only about one observation in the slowest 1%, so the tail is unstable. More repetitions, a longer window, or suitable statistical analysis may be needed. There is no single minimum sample count for every system; report uncertain results as inconclusive.

Do not average the p95s from different runs and call that the “overall p95.” A combined distribution needs raw data or compatible histograms with the correct boundary and population. To compare runs, you can report each run’s p95 distribution or their median, clearly labeled; that summary is not the percentile of all merged requests. Assuming every request in one run is independent also usually needs scrutiny.

## 4. Acceptance thresholds and regression comparison

After understanding the workload and baseline, finalize criteria from product needs and noise, and record them before viewing the candidate result. **The baseline is descriptive; the product target is normative.** Do not establish poor current behavior as a good limit. Define a combination of:

| Metric family | Question | Common trap |
| --- | --- | --- |
| Load validity | Were target rate/mix achieved, and was the generator healthy? | Passing under less load than required |
| Correctness and outcome | What share of all eligible work received the correct result? | Checking only status codes or only successful requests |
| User time | What share finished correctly by the deadline? What are p95/p99 per path? | Excluding timeouts/unfinished work or hiding a slow route |
| Stability | Did queues, memory, and connections remain bounded and recover after load? | Observing a few minutes instead of the full lifecycle |
| Regression/cost | Under equal load, how did CPU or latency change from the reference? | Comparing different hardware or error rates |

[k6 thresholds](https://grafana.com/docs/k6/latest/using-k6/thresholds/) define Pass/Fail criteria on metrics; this is one tool-specific example. Correctness checks, error counting, and stop/acceptance thresholds must be designed explicitly in any tool. Both absolute and relative criteria may be needed: a version can still meet the product target while regressing significantly, or improve on the baseline while still missing the product target.

## Worked example: reservation test plan

**All numbers in this section are illustrative.** The hypothetical product requirement is that, at a defined load, at least 99% of eligible work completes with the correct result within 400 ms. Here the unit of work is one API request, not a full purchase session. Time starts when the generator begins the request and ends when it receives the response; generator scheduling delay is recorded separately.

| Plan element | Example contract |
| --- | --- |
| Operations and mix | List 60%, detail 30%, reservation 10%; valid state and semantic checks for each path |
| Load rate | 200 independently arriving requests/s; about 120/60/20 for the three paths |
| Environment | Dedicated staging with recorded version/settings; specified DB, network, and quotas |
| Data | Synthetic dataset with documented size and skew, hot products, valid users and permissions; restore reservation state for each run |
| Phases | Low-load Smoke; separate 2-minute warm-up; 3-minute ramp; 5-minute steady comparison window; stop arrivals and drain for a bounded period |
| Output | Scheduled/started/completed rates, correctness, timeouts and unfinished work, per-route timing, queue/pool, CPU/RSS, and generator health |
| Validity | Achieved input count and mix within a pre-written tolerance; generator not saturated; data/assertions correct |
| Example acceptance | Correct result by deadline ≥99%; errors ≤0.5%; p95 for each route <300 ms; median run p95 increase ≤10% versus reference |
| Example stop | Target outage, sustained severe errors, or uncontrolled queue growth; write exact limits before running and fit them to the environment |

Also check the user target on each important route so that the 60% fast list path cannot hide the reservation path. The 2/3/5-minute durations and 10% limit are not universal recommendations; p99, periodic behavior, and Soak may need far more observations. This example defines the relative criterion specifically on the median per-route p95 across runs.

During the five-minute steady window, scheduled arrivals are `200 × 300 = 60,000` work items. Suppose all 60,000 started and all outcomes are known by the final reporting deadline; if some were unfinished, they would remain in the denominator. Hypothetical paired-run data:

| Outcome | Reference A | New version B |
| --- | ---: | ---: |
| Correct within 400 ms | 59,700 | 59,280 |
| Correct but late | 180 | 480 |
| Failed or incorrect | 120 | 240 |
| Total | 60,000 | 60,000 |
| Error/incorrect share | 0.2% | 0.4% |
| Correct within deadline, out of all work | 99.5% | 98.8% |

B meets the example’s error ceiling but **fails** the combined correct-by-deadline target. Looking only at 0.4% errors would hide the 480 correct-but-late items. To correlate with phases, assign work to a window cohort by start time and collect outcomes after arrivals stop using a bounded drain. Work still unfinished at the end of the deadline is reported as unfinished. These percentages use the same cohort, not counters from different windows.

For the Reservation route, the hypothetical p95 values from three independent, matching runs are 238, 245, and 242 ms for A, and 268, 271, and 274 ms for B. The medians are 242 and 271 ms:

```text
relative_change = (271 - 242) / 242 * 100 ≈ 11.98%
```

Both are below 300 ms, but the roughly 12% change exceeds the example’s 10% regression limit. This table is fabricated for teaching; three runs alone do not guarantee statistical significance for every test. For a real decision, consider persistent change, observed noise, errors, resources, and repeatability together. Reducing the start rate, dropping expensive work, or accepting incorrect responses is not an improvement.

## Public evidence and limits of interpretation

> **Historical production experience, April 7, 2009 — Facebook Live Feed:** The report [Scaling Facebook Live Feed for the Inauguration](https://engineering.fb.com/2009/04/07/video-engineering/scaling-facebook-live-feed-for-the-inauguration/) says the team ran the client as a dark launch before the event, varied request rate and type, and collected client-side statistics as well; some CDN responses were not visible at the origin server. This supports observing the real request path. That team’s specific production method is not an instruction to test our users or a guarantee of today’s capacity.

> **Representative workload, September 7, 2022 — TAOBench:** [Meta](https://engineering.fb.com/2022/09/07/core-infra/taobench/) built a model from TAO request characteristics and compared it with a production counterpart. Transaction size, key-to-shard mapping, and operation distribution were among its parameters. The transferable lesson is to model actual behavior; a social-network workload is not automatically suitable for our store or API, and DB rankings do not generalize to a different load.

> **Controlled production measurement, September 14, 2020 — Throughput Autoscaling:** [Meta’s report](https://engineering.fb.com/2020/09/14/networking-traffic/throughput-autoscaling/) describes gradually shifting production traffic to a small number of target hosts and backing off when service metrics decline to estimate throughput for each environment. Region and hardware differences were also examined. This approach requires dedicated infrastructure controls and observability; dividing a small staging result or copying another company’s number does not prove our production capacity.

## When it is useful and when the result is weak

Repeatable tests are useful for important paths, query/cache/runtime changes, preparing for increased load, and finding a decline after release. Start with a small representative scenario, then cover different risks with separate tests. An expensive daily Stress run without a new question, or a short benchmark on unrealistic input, does not produce a dependable decision.

Automation can provide a short, stable comparison in CI, while Soak or a large-event test needs separate scheduling and observation. Treat a major environment or data change as a new protocol version and establish a new baseline; do not silently join an old trend to the new one. Pass means only that the specified criteria held under the tested conditions. Do not turn an invalid or inconclusive result into Pass.

## Short exercise and expected observations

This is a calculation exercise; do not run a tool or service.

1. Twenty serial workers with zero think time first have a 0.1-second response and then a one-second response. Calculate the approximate rate in each case. If the target was 200 independent work items/s, which result is misleading?
2. Extend the example plan to detect a connection leak using only the test type and signals. Explain why a short peak is insufficient.
3. Recalculate the number of correct-but-late items for B and its correct-by-deadline ratio from the table. Find the median of each version’s three p95 values and the relative change.

**Expected:** The rates are about 200 and 20 requests/s; the second case does not create the target independent arrival load. For a leak, use a Soak test appropriate to the resource lifecycle and track busy/open connections, pool wait, and recovery trend; stability over a few minutes does not prove there is no leak. B has 480 correct-but-late work items and 98.8% correct by the deadline. The medians are 242 and 271, and the roughly 12% change must be reported as the median of run-level p95s, not the “overall p95.” None of these are results from a real run.

## Failures, signals, and controls

| Failure | Operational signal | Review |
| --- | --- | --- |
| Only status or successful-request latency | Fast response but wrong/missing user result | Semantic assertion; include errors and unfinished work in the population |
| Load falls because of the model/generator | Started RPS below target while the chart looks better | Arrival model, dropped/scheduled work, and generator resources |
| Unrealistic small data or keys | Cache hit/query plan differs from production | Volume, skew, response size, and initial state |
| Comparison uses changing environments | Results move with host or run time | Quota, neighbor activity, network, version, and interfering load |
| Short test for a long-running issue | Queue/RSS grows later | Soak and maintenance/refresh lifecycle |
| Aggregate average hides an important route | Expensive route disappears in the mix | Per-route/operation slices and that population’s percentile/deadline |
| Bad run discarded without reason | Report shows only the best run | Repeat, document the cause, and retain raw data |
| Only maximum RPS considered | Errors/queue/recovery time are severe | Goodput, latency target, and recovery after load is reduced |

### Operational checklist

- [ ] Question, test type, work unit, timing/correctness boundary are defined.
- [ ] Load model, data, skew, and cache state come from observations or documented assumptions.
- [ ] Reference version, environment, quota, and protocol are retained for reproduction.
- [ ] Baseline and noise are understood before finalizing thresholds and comparing the candidate.
- [ ] Target/achieved rates, correct work, errors, timeouts, and unfinished work are recorded separately.
- [ ] Generator health, sample count, and measurement-window adequacy are checked.
- [ ] Absolute product target and relative regression limit are fixed before viewing the candidate.
- [ ] Stop, drain, queue/pool, and post-load recovery behavior are defined for Load/Stress/Spike.
- [ ] Results, metrics/traces/profiles, and likely cause are correlated by time and version.
- [ ] Conclusions are limited to tested conditions; a changed protocol gets a newly versioned baseline.

## Review quiz

1. Which test types suit a sudden campaign surge and a gradual connection leak, respectively, and why?
2. How does a baseline differ from an acceptable product target? What if the baseline is already poor?
3. Why do “20 fixed virtual users” not necessarily model 200 independently arriving requests/s?
4. Why are HTTP 200 and good p95 for successful requests alone insufficient for acceptance?
5. If the generator schedules 200 work items/s but starts 150/s, does success among started work prove capacity at 200?
6. In the example, what is the approximate increase in median p95 from 242 to 271 ms, and why is being under 300 ms insufficient to pass?
7. Is the median p95 of three runs the p95 of all requests in those runs? What must be held constant and recorded for a valid comparison?
8. What do Meta’s experiences teach about representativeness, and what claim about our system’s capacity do they not allow?

### Explained answer key

1. **Spike and Soak.** The first measures reaction to a rapid change; the second measures long-term resource use and release. Duration and load must fit the actual risk.
2. **A baseline describes the reference; a product target comes from product needs.** The baseline shows current state and variation. If it misses the target, report the gap and improve it; a poor reference does not justify lowering the target.
3. **In a closed model, new work waits for previous work to finish.** As response time grows, the rate falls; in the example it drops from about 200 to 20. Independent arrivals need a separate schedule and sufficient generator capacity.
4. **Neither correctness nor all outcomes are represented.** The response may be semantically wrong, and timeouts/errors/unfinished work may be excluded from successful-request latency. Define the population and goodput.
5. **No.** The target was not achieved; 50 work items/s never started. The run is invalid or insufficient evidence for a capacity claim at 200. First identify the generator/model bottleneck.
6. **About a 12% increase.** The example’s relative limit was at most 10%, so both absolute and relative criteria matter. Correct-by-deadline performance for B is also 98.8%, below 99%.
7. **No; it summarizes run-level percentiles.** A merged percentile requires raw data or compatible histograms. Keep load, data, correctness, environment, and initial state equal; record versions, warm-up, noise, sample counts, and errors.
8. **Access patterns, operation mix, and observation boundaries matter.** Those reports describe particular environments; they do not establish capacity, a universally best DB, or a sufficient duration for our system.

## Further reading

- **Persian, introductory supplement:** [Website load testing — Ferdowsi Cloud](https://ferdowsi.cloud/blog/website-load-testing/): explains test types and preparation steps with a tool example. It is a hosting-service article; its guarantees are not evidence of capacity or absence of timeouts in your project. Apply this lesson’s arrival model, correctness, and evidence limits.
- **English, official:** [k6 Load Test Types](https://grafana.com/docs/k6/latest/testing-guides/test-types/): compares Smoke, Load, Stress, Spike, and Soak; tool-specific examples.
- **English, official:** [Automated Performance Testing](https://grafana.com/docs/k6/latest/testing-guides/automated-performance-testing/): baselines, comparable runs, retaining results, and observability.
- **English, official:** [Open and Closed Models](https://grafana.com/docs/k6/latest/using-k6/scenarios/concepts/open-vs-closed/) and [Thresholds](https://grafana.com/docs/k6/latest/using-k6/thresholds/): load scheduling and Pass/Fail criteria in k6; using k6 is optional.
- **English, production experience:** [Facebook Live Feed, 2009](https://engineering.fb.com/2009/04/07/video-engineering/scaling-facebook-live-feed-for-the-inauguration/): pre-event testing and visibility into client/CDN behavior.
- **English, representative workload experience:** [Meta TAOBench, 2022](https://engineering.fb.com/2022/09/07/core-infra/taobench/): modeling production request characteristics and limits on benchmark generalization.
- **English, production capacity measurement:** [Meta Throughput Autoscaling, 2020](https://engineering.fb.com/2020/09/14/networking-traffic/throughput-autoscaling/): controlled measurement and hardware/region differences; not a ready-to-copy method for another environment.

**Navigation:** [Chapter index](../README.en.md) · [Package index](../../README.en.md) · [Profiling](../../06-code-optimization/02-application-profiling/README.en.md) · [Critical paths](../../06-code-optimization/04-critical-paths/README.en.md)

**Related:** [Metrics, Logs, and Traces](../../07-monitoring-and-logging/01-metrics-logs-and-traces/README.en.md) · [Scaling](../../05-load-balancing-and-scaling/README.en.md) · [Timeouts and Retries](../../06-code-optimization/07-timeouts-and-retries/README.en.md) · [Connection Pooling](../../04-databases/01-connection-pooling/README.en.md)
