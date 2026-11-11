# Jobs and Finite Workloads
[Persian edition](README.md) · [Chapter references](../../../references/README.en.md#04-running-applications)

[فارسی](README.md) | [Chapter 04](../../README.en.md)

## The Job model

A Job tracks Pods until a required number of tasks complete successfully. completions sets the number of successful tasks; parallelism caps simultaneous work; backoffLimit controls retries; activeDeadlineSeconds caps elapsed time. ttlSecondsAfterFinished can clean up a completed Job after a delay.

Kubernetes may run work again; exactly-once side effects are not guaranteed. A process might write output and then die before reporting success. A retry can duplicate that output. Make work idempotent or use an idempotency key or transaction at the destination.

## Example

~~~yaml
apiVersion: batch/v1
kind: Job
metadata:
  name: report
spec:
  completions: 1
  parallelism: 1
  backoffLimit: 2
  activeDeadlineSeconds: 300
  ttlSecondsAfterFinished: 600
  template:
    spec:
      restartPolicy: Never
      containers:
        - name: task
          image: busybox:stable
          command: ["sh", "-c", "echo report-ready"]
~~~

Use a CronJob for scheduled work; configure its schedule, concurrencyPolicy, and history. Real batch tasks need durable input/output, timeouts, and error reporting.

## Troubleshoot and protect capacity

~~~sh
kubectl get jobs
kubectl describe job report
kubectl get pods -l job-name=report
kubectl logs job/report
~~~

Inspect attempts, exit codes, image, credentials, timeout, and retries. High parallelism can overload storage, databases, or external APIs. Use limits and queueing for batch workloads.

## Production experience

Netflix describes its batch-compute capacity and queuing experience in its [Kueue article](https://netflixtechblog.com/how-netflix-simplified-batch-compute-with-kueue-87860682629c). Multi-tenant batch systems need queue policy and fair access to capacity; evaluate tools against your scale.

## Quiz
1. **Why can a retry repeat work?** A process can fail after an external side effect but before reporting success.
2. **How do you reduce duplicate effects?** Make processing idempotent or use transactions/idempotency keys.
3. **Job vs CronJob?** A Job runs finite work; a CronJob creates Jobs on a schedule.
4. **How do you choose parallelism?** Consider cluster capacity, destination limits, deadlines, and queue policy.
5. **What is the TTL trade-off?** It cleans old resources but can remove evidence useful for debugging.

## Further reading
- [Jobs](https://kubernetes.io/docs/concepts/workloads/controllers/job/)
- [CronJobs](https://kubernetes.io/docs/concepts/workloads/controllers/cron-jobs/)
- [Kueue overview](https://kueue.sigs.k8s.io/docs/overview/)
- [Netflix: Simplifying batch compute with Kueue](https://netflixtechblog.com/how-netflix-simplified-batch-compute-with-kueue-87860682629c)
- [EasyEnv Persian course](https://easyenv.io/engineering/courses/catalog/kubernetes/fa)
