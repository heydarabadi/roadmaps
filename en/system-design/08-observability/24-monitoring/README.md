# Monitoring, Instrumentation, and SLOs

[فارسی](../../../../fa/system-design/08-observability/24-monitoring/README.md)

## Learning goals

- Distinguish metrics, logs, and traces and know what each helps answer.
- Define health signals and service-level indicators.
- Build dashboards and alerts around user impact.
- Instrument distributed requests without collecting unsafe or unbounded data.

## Central idea

Monitoring should show whether users can complete important work. Metrics, logs, and traces answer different but complementary questions.

## Concept map

User journey and SLO → instrumentation → metrics/logs/traces → visualization and alert → incident action and learning.

## Detailed lesson

### Monitoring and observability

Monitoring provides predefined dashboards and alerts for known questions. Observability uses telemetry to investigate new questions about internal behavior.

Metrics are numeric time series such as counts, duration distributions, and resource levels. Logs are detailed event records. Traces connect spans and timing across service boundaries. None is enough alone: a metric may reveal falling success, a trace may locate a slow dependency, and a log may explain one specific failure.

### The four golden signals and USE

For request-driven services, Google SRE’s four golden signals are latency, traffic, errors, and saturation.

- **Latency:** measure successful and failed requests separately; do not hide slow timeouts.
- **Traffic:** measure demand in an appropriate unit, such as requests or jobs per second.
- **Errors:** include explicit failures and failures detected from the outcome.
- **Saturation:** show how full a constrained resource is, such as CPU, queue, disk, or connection pool.

The USE method asks about utilization, saturation, and errors for each resource.

### SLI, SLO, and alerting

An SLI must be precisely defined. For example, eligible checkout requests that finish successfully within a deadline divided by all eligible checkout requests.

An SLO adds a target and time window. An alert should indicate user impact or error-budget consumption at a rate that needs action. A CPU alert alone may be noisy; CPU saturation combined with rising latency and failures is more actionable.

Every alert needs an owner, runbook, and urgency. If an alert does not result in an action, adjust or remove it.

### Seven monitoring areas

- **Health:** liveness, readiness, and required dependencies; probes must not create a shared failure.
- **Availability:** successful user operations across time and regions.
- **Performance:** latency percentiles, throughput, queue, and saturation.
- **Security:** failed authentication, privilege changes, policy violations, and auditable events.
- **Usage:** feature use and traffic patterns for capacity or product decisions; minimize personal data.
- **Instrumentation:** metrics, logs, traces, context propagation, and correlation IDs.
- **Visualization and alerts:** readable charts and alerts with an owner and action.

### Instrumentation that stays useful

Use trace and span IDs to follow a request. Propagate context only across trusted boundaries. Metric labels such as raw user IDs or arbitrary URLs can create unbounded cardinality and cost; prefer limited labels such as route template, status class, and region.

Logs should include timestamp, severity, service/version, and relevant context, but must mask or omit tokens, passwords, and sensitive customer data. Define clock synchronization and retention.

Sampling can control trace cost, but do not inadvertently drop rare failures. Tail-based sampling can retain slow or failed traces after their outcome is known.

### Dashboards that answer questions

A dashboard should help answer practical questions: Are users succeeding? Which path is slow? Which dependency is failing? Give charts units, time ranges, percentiles, and deployment annotations.

Separate service overview, dependencies, capacity, and incident detail instead of placing hundreds of unrelated metrics on one page. Alerts should link to a dashboard with the same SLI definition.

### Security and privacy in telemetry

Telemetry may contain customer details, session IDs, or request payloads. Collect the minimum necessary, redact at the boundary, restrict access, encrypt, set retention, and audit access.

Security alerts should connect to an incident process that is protected and auditable.

### From observation to action

Every actionable alert should state what happened, who may be affected, when it started, who owns the response, and the safe next step. During an incident, retain a timeline and representative traces. Separate immediate mitigation from root-cause fixes, then review SLOs and alerts using what the incident taught.

## Worked example

For a failed checkout, a trace should separate time spent in the API, inventory, payment, and broker. The metric shows how widespread the failure is; logs provide a specific error; the trace identifies the dependency path.

## Example SLO

~~~text
Illustrative only:
99.9% of eligible checkout requests succeed within 800 ms over 30 days.
The real target must reflect product needs, dependency boundaries, and measurement rules.
~~~

## Public engineering case study

[Uber: Technology stack foundations](https://www.uber.com/us/en/blog/tech-stack-part-one-foundation/) discusses telemetry and infrastructure concerns in a large service platform. Its instrumentation needs reflect its own scale and architecture.

## Design choices

| Choice | A good fit when | Risk to watch |
| --- | --- | --- |
| Metrics | Trends, rates, and alerting are needed | High-cardinality labels can become costly |
| Logs | Detailed event context is needed | Sensitive data and unbounded volume |
| Traces | A request crosses dependencies and needs path attribution | Sampling can miss rare failures |
| SLO-based alerts | User outcomes and reliability are the concern | Poor SLI definition creates misleading pages |

## Common pitfalls

- Alerting on every resource threshold rather than user impact.
- Defining an SLO without an eligible-request population.
- Logging tokens or personal data.
- Using user ID as a metric label.
- Showing averages but hiding latency tails.
- Creating dashboards without owners or operational decisions.

## Short quiz

1. Which three telemetry signals complement one another?
2. What are the four golden signals?
3. Why can an unbounded metric label be harmful?
4. What should every actionable alert include?

### Answer key

1. Metrics show aggregate trends, logs record detailed events, and traces show cross-service causality and timing.
2. Latency, traffic, errors, and saturation.
3. It can create an enormous number of distinct time series, raising storage and query cost.
4. Impact, start/context, owner, urgency, and a safe next step or runbook.

## Exercise

Define one SLI and SLO for checkout. Sketch a dashboard with success ratio, p95/p99, traffic, saturation, dependency errors, and oldest job age. Decide what to sample and redact, and write the alert’s owner and runbook action.

## Summary

Useful observability connects a user outcome to telemetry that helps someone act. Define SLIs precisely, instrument the request path, protect telemetry data, and alert on actionable symptoms.

## Further reading

- [Google SRE: Monitoring Distributed Systems](https://sre.google/sre-book/monitoring-distributed-systems/) — golden signals, tails, and monitoring practices.
- [Google SRE: Service Level Objectives](https://sre.google/sre-book/service-level-objectives/) — SLI definitions and objective setting.
- [OpenTelemetry documentation](https://opentelemetry.io/docs/) — vendor-neutral tracing, metrics, and logs.
- [Prometheus overview](https://prometheus.io/docs/introduction/overview/) — time-series metrics.
- [Grafana documentation](https://grafana.com/docs/grafana/latest/) — dashboards and alerting.
- [Google SRE Workbook: Alerting on SLOs](https://sre.google/workbook/alerting-on-slos/) — alerting through error budgets.
