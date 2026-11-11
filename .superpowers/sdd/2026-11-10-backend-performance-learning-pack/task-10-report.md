# Task 10 report — Chapter 09: Performance Testing

Status: complete within assigned scope; ready for independent review. Research and manual review date: 2026-11-10.

No Git initialization, commits, test execution, benchmark execution, services, deployment, production traffic or exercise execution. The example dataset is constructed for teaching. Used built-in web tools; no Firecrawl calls.

## Files created

Only the two assigned chapter files and this authorized report were created in this follow-up task:

- `Backend Performace/09-performance-testing/README.md` — Persian chapter index, goals, prerequisites, topic link, learning sequence from user goal to representative workload and repeatable baseline before final thresholds, linked scenario and chapter checklist.
- `Backend Performace/09-performance-testing/01-load-testing-and-regression-benchmarks/README.md` — self-contained Persian topic with definitions, learning outcomes, test-type table, representative workload design, open/closed arrival models, baseline/noise, regression protocol, example test plan, hypothetical counts and repeated runs, bounded first-party evidence, exercise and expected observations, failure modes, operational checklist, eight explained quiz answers, annotated Persian/English resources and relative navigation.

Current document sizes after author review: index 6,990 bytes; topic 34,828 bytes. No root index, other chapter or shared progress ledger was edited by this follow-up task.

## Requirement coverage

| Requirement | Coverage |
| --- | --- |
| Persian-first, stack/tool neutral | RTL Persian prose; one LTR arithmetic code fence outside the prose container; no required implementation language or test vendor. k6 is an official example source, not a mandated stack. |
| Load/Stress/Spike/Soak | Table differentiates goal, traffic shape and limits; Smoke is included for scenario validity. Stress includes bounded degradation/recovery; spike means rate of change, not just peak size; soak duration is risk-dependent. |
| Workload and baseline before thresholds | Goal and measurement population first; representative request mix, arrival pattern, data and environment next; repeated reference measurements establish noise; final absolute/relative criteria are frozen before candidate results. Baseline is descriptive, not permission to weaken product objectives. |
| Realistic data/environment | Key skew, dataset/response size, read/write mix, state reset, user permissions, cache cold/warm state, external dependencies/stub limits, CPU quota, runtime/DB/driver versions, network/TLS/reuse and telemetry costs. |
| Valid arrival and generator model | Closed-model rate changes with response duration; open arrival schedule is independent of completion. Coordinated-omission risk is bounded to the model mismatch. Generator CPU/network/capacity and scheduled-versus-started work are explicitly checked. |
| Repeatability/noise | Versioned protocol/raw results, repeated runs, warmup, A/B/A/B option, environment interference, autoscaling case distinction, documented exclusions, tail sample limits and no cherry-picking. |
| Regression comparison | Per-route absolute outcome/latency goals plus a predefined relative comparison; distinction between median of run-level p95 values and pooled p95. Invalid or inconclusive measurements are not passed. |
| Correctness and completion boundaries | Status alone is insufficient; semantic assertions, failures, timeouts, cancellation and outstanding work are visible. Sample counts use a started-work cohort and bounded drain, rather than mismatched completion windows. |
| Worked example | Hypothetical request mix, 200 requests/s, five-minute measured cohort of 60,000, absolute criteria, error/timely-success table, three-run p95 median comparison and about 12% regression. |
| Exercise | Paper model for 20 closed workers, soak selection for connection leakage and recomputation of the example; expected observations included. No runnable test is required. |
| Public evidence | Three dated first-party Meta cases, with direct links and explicit limits. No company result is invented and no case is used to predict the user's capacity. |
| Failure modes/checklist | Generator bottlenecks, misleading success-only latency, unrealistic keys/cache/data, environment changes, short observation, mixed routes, cherry-picked runs, maximum-RPS-only claims and controlled recovery. |
| Quiz | Eight mixed definition/scenario/calculation questions, each with a taught, explained answer. |
| Resources/navigation | Verified Persian introductory reference with a precise limitation; official English docs and first-party engineering cases; all current local relative targets resolve. |

## Sources checked and bounded use

Opened and read relevant content using built-in web search/open/find:

1. https://grafana.com/docs/k6/latest/testing-guides/automated-performance-testing/ — consistent scenario/workload, baseline/regression comparison, realistic environment, result retention and observability correlation. Tool examples are not prescribed globally.
2. https://grafana.com/docs/k6/latest/ — official tool overview and documentation entry point; not used to claim that any tool produces valid capacity numbers automatically.
3. https://grafana.com/docs/k6/latest/testing-guides/test-types/ — smoke, average/load, stress, spike and soak distinctions.
4. https://grafana.com/docs/k6/latest/using-k6/scenarios/concepts/open-vs-closed/ — iteration/arrival scheduling difference, load reduction in a closed model as iteration time increases, and why workload model must match the question.
5. https://grafana.com/docs/k6/latest/using-k6/thresholds/ — metrics-based pass/fail criteria; no copied universal numeric threshold.
6. https://engineering.fb.com/2009/04/07/video-engineering/scaling-facebook-live-feed-for-the-inauguration/ — historical pre-event dark launch, adjustable request rates/types, whole-stack exercise and client visibility for CDN responses. Presented as a historical first-party case with explicit transfer limits, not an instruction to apply production traffic testing.
7. https://engineering.fb.com/2022/09/07/core-infra/taobench/ — production-derived social-graph request properties, validation against production counterparts, transaction size, key/shard mapping and operation frequency. No database ranking or Meta-scale capacity number is generalized.
8. https://engineering.fb.com/2020/09/14/networking-traffic/throughput-autoscaling/ — controlled concentration of real traffic onto selected hosts, backing off at degradation, repeated measurement by region/hardware. Presented as a method with specialized operating controls, not a ready-made recipe or staging-to-production multiplier.
9. https://ferdowsi.cloud/blog/website-load-testing/ — Persian supplemental article directly covering test types and preparation, with JMeter/k6 examples. Opened and verified. The article includes hosting recommendations and strong guarantee wording; the README explicitly does not treat those statements as evidence of user capacity or guaranteed absence of timeouts. Primary English sources support the lesson's operational definitions and measurement method.

All company summaries are short original paraphrases. No screenshots, transcripts, copied article blocks or invented measurements were included.

## Manual inspection

Read both final files end to end, splitting the long topic read to avoid output truncation. Compared the chapter and topic sections against the brief and approved design. Inspected the single LTR code fence and RTL container transitions. Corrected one Persian typo and changed the relative-threshold wording from ambiguous decline to explicit **increase in run-level p95 median**.

Reviewed eight question/answer pairs. The answers are taught in the lesson, distinguish observed reference behavior from desired outcomes, and avoid inferring capacity from vendor/case-study numbers.

Manually recalculated:

- Closed model, no think time or overhead: 20 / 0.1 = 200 operations/s; 20 / 1 = 20 operations/s.
- Representative request mix at 200 requests/s: 60%/30%/10% gives approximately 120/60/20 requests/s.
- Stable five-minute cohort: 200 × 300 = 60,000 operations.
- Baseline count partition: 59,700 timely + 180 late + 120 failed = 60,000; error 0.2%; timely success 99.5%.
- Candidate count partition: 59,280 timely + 480 late + 240 failed = 60,000; error 0.4%; timely success 98.8%.
- Run-level p95 medians: A [238, 245, 242] → 242 ms; B [268, 271, 274] → 271 ms.
- Relative increase: (271 − 242) / 242 × 100 ≈ 11.98%, about 12%, exceeding the illustrative 10% relative gate despite remaining under the illustrative 300 ms absolute p95 threshold.

The topic explicitly labels those as constructed teaching data. Three repeated values are not claimed as a general statistical-confidence guarantee. Tail sample counts, noise and potential dependence are discussed.

Read-only local link inventory: **two requested README files present; zero missing relative Markdown targets** at the time of review. Links resolve to root, the chapter, Chapter 04 pooling, Chapter 05 scaling, Chapter 06 profiling/critical paths/timeouts, Chapter 07 signals and Chapter 08 index. There are no pending Chapter 10 links in these two files.

No software tests or benchmark tooling were run. No rendered browser verification was performed; Markdown/RTL/LTR was manually inspected as source text.

## Remaining concerns

- No blocking issue found within the assigned scope.
- Public performance stories are historical and environment-specific. Retain their explicit limits during final editing; they do not establish a current numeric target for the user's software.
- The Persian resource is introductory and commercial; the lesson explicitly separates its terminology/preparation value from its capacity/guarantee wording.
- Examples are teaching plans and calculations, not measured baseline data. Actual thresholds require the product objective and representative environment measurements.
