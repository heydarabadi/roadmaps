# Pods
[Persian edition](README.md) · [Chapter references](../../../references/README.en.md#04-running-applications)

[فارسی](README.md) | [Chapter 04](../../README.en.md)

## The basic model

A Pod is Kubernetes' smallest schedulable unit. It contains one or more containers, a shared network namespace, and optional shared volumes. Containers in the same Pod always run on the same node and share localhost and the Pod IP. Do not combine unrelated processes just to reduce the number of manifests: their scaling, release, and failure lifecycles would become coupled.

Pods are replaceable, not permanent identities. A replacement gets a new UID and usually a new IP. That is why ordinary applications use a Deployment and communicate through a Service.

### Multi-container patterns
- **Init container:** runs before application containers for bounded setup work.
- **Sidecar:** provides a helper function, such as a proxy; account for shared resources and lifecycle.
- **Ephemeral container:** provides temporary debugging access to an existing Pod, not a permanent workload.

## Simple Pod

~~~yaml
apiVersion: v1
kind: Pod
metadata:
  name: debug-web
  labels:
    app: web
spec:
  restartPolicy: Never
  containers:
    - name: web
      image: nginx:stable
      ports:
        - containerPort: 80
~~~

This is useful for a lab. If it fails or is deleted, no controller replaces it. Put production workloads under a controller and add probes, resources, and a securityContext.

## Lifecycle and troubleshooting

- **Pending:** no suitable node or storage has been found yet.
- **Running:** containers have been created; this does not guarantee the app is ready.
- **Succeeded/Failed:** the work finished or failed.
- **CrashLoopBackOff:** a container repeatedly exits and is restarted with backoff; this status is not the root cause.

~~~sh
kubectl get pod debug-web -o wide
kubectl describe pod debug-web
kubectl logs debug-web
kubectl logs debug-web --previous
kubectl exec -it debug-web -- sh
~~~

Read events, logs, and exit codes. Use exec only when authorized and for diagnosis; edits inside a running container are not reproducible from its manifest.

## Security and resources

Give containers appropriate requests and limits, identity, and security settings. Prefer non-root and minimal capabilities. A slow or incorrect probe can cause repeated restarts; keep readiness separate from liveness.

## Quiz with explanations

1. **Why not hard-code a Pod IP in a client?** Pods are replaced; a Service and DNS provide a more stable name.
2. **When are multiple containers in a Pod justified?** When tightly coupled processes need shared networking/volumes and lifecycle.
3. **Does Running mean Ready?** No. Inspect Pod conditions and readiness probes.
4. **What happens when a standalone Pod is deleted?** It disappears; no workload controller recreates it.

## Further reading
- [Pods](https://kubernetes.io/docs/concepts/workloads/pods/)
- [Pod lifecycle](https://kubernetes.io/docs/concepts/workloads/pods/pod-lifecycle/)
- [Init containers](https://kubernetes.io/docs/concepts/workloads/pods/init-containers/)
- [Sidecar containers](https://kubernetes.io/docs/concepts/workloads/pods/sidecar-containers/)
- [Ephemeral containers](https://kubernetes.io/docs/concepts/workloads/pods/ephemeral-containers/)
- [EasyEnv Persian course](https://easyenv.io/engineering/courses/catalog/kubernetes/fa)
