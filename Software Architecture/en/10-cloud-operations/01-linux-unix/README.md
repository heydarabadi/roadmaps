# Linux and Unix for Software Architects

## Learning goals

- Understand processes, filesystems, permissions, networking, and service management.
- Use logs and resource signals to trace production failures.
- Design least-privilege runtime environments and repeatable operations.

## Operating-system concepts

Unix-like systems expose processes, files, devices, and many operating interfaces through consistent abstractions. A process has an identity, environment, open file descriptors, resource limits, and lifecycle. A signal can request graceful shutdown, but the application must handle it. Containers also rely on host-kernel primitives, so understanding the host remains useful even when the application is packaged.

The filesystem hierarchy separates system areas, configuration, variable state, temporary data, and user content according to distribution conventions. Permissions combine owner, group, and mode bits; access-control lists add finer rules. Run services as dedicated non-root users, restrict writable paths, and keep secrets out of world-readable files, shell history, and process arguments.

Systemd commonly manages services on modern Linux distributions. A unit can define startup dependencies, restart policy, environment, and resource controls. Service ordering does not prove a dependency is ready; applications still need bounded retries and health behavior. Use journald or the platform's log pipeline while keeping credentials and personal data out of logs.

## Operations and diagnosis

Investigate CPU saturation, memory pressure, file descriptor exhaustion, disk latency/capacity, and network errors separately. A healthy process can still be unable to serve requests because its dependency pool is exhausted. Record resource limits and capacity assumptions. Prefer structured logs, metrics, and traces over ad-hoc shell output as the main production evidence; shell tools are still valuable for targeted diagnosis.

Use package updates, signed images/packages, minimal base images, secure boot or host protections where appropriate, and a patch process with rollback. Avoid treating root access as the default troubleshooting tool.

## Worked example: a service that stops responding

Check whether the process is running and restarting, inspect recent logs and service events, then examine CPU, memory, disk, file descriptors, and network sockets. Compare against the deployment change and dependency health. A restart may restore service but erase evidence or conceal a leak, so capture the relevant telemetry and root cause before treating restart as resolution.

## Self-check quiz

1. Why run a service as a dedicated user? It limits the damage from a compromised or misconfigured process.
2. Does service startup order prove a database is ready? No; readiness and retry behavior must handle actual dependency state.
3. What does a graceful shutdown allow? The process can stop accepting new work and complete or safely abandon in-flight work.
4. Name four host resource signals to check under saturation. CPU, memory, disk, file descriptors, and network are examples.
5. Why is an unexplained restart insufficient as a fix? It can erase symptoms while the cause and recurrence risk remain.

## Exercise

Write an incident triage sequence for an API process that is alive but timing out. Include host, process, dependency, and application evidence.

### Sample answer

Check service status and restart count; inspect logs and recent releases; measure CPU/memory/disk/fd usage; examine connection pools and socket errors; inspect dependency latency and traces; compare request volume and queue depth; then mitigate according to evidence. Preserve timestamps, trace IDs, and relevant metrics before recycling the instance.

## Further reading

- English: [Linux man-pages project](https://man7.org/linux/man-pages/), [systemd documentation](https://systemd.io/), [The Linux kernel documentation](https://docs.kernel.org/), [Red Hat performance tuning guide](https://docs.redhat.com/en/documentation/red_hat_enterprise_linux/), [Google SRE: Monitoring Distributed Systems](https://sre.google/sre-book/monitoring-distributed-systems/), [CIS Linux benchmarks](https://www.cisecurity.org/cis-benchmarks)
- Persian: [Linux documentation translated by LinuxReview](https://linuxreview.ir/), [DNTips](https://www.dntips.ir/)
