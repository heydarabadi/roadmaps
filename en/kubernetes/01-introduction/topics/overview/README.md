# Kubernetes Overview
[Persian edition](../../../../../fa/kubernetes/01-introduction/topics/overview/README.md) · [Chapter references](../../../references/README.md#01-introduction-and-mental-model)

[فارسی](../../../../../fa/kubernetes/01-introduction/topics/overview/README.md) | [Chapter 01](../../README.md)

## Learning objective

Explain the control plane, worker nodes, API, and controllers, and trace how a Pod is created and started.

## The main idea

Kubernetes is not merely a command that starts a container. It offers an API for describing workloads and control loops that manage their lifecycle. A cluster has a control plane and worker nodes. Requests pass through several asynchronous components.

### Control plane

- **API server:** the front door for Kubernetes resources; handles authentication, authorization, validation, and admission.
- **etcd:** stores persistent API state. It requires careful backup and protection.
- **Scheduler:** places Pods that have no node, considering requests, constraints, and node status.
- **Controller manager:** runs controllers that watch specific kinds of desired state.

### Worker node

- **kubelet:** manages Pods assigned to its node.
- **Container runtime:** such as containerd, prepares images and starts containers.
- **Network and storage plugins:** provide Pod connectivity and volume mounts.

## Request path

~~~text
kubectl → API server → persist object → Deployment controller
→ ReplicaSet → Pod → scheduler → kubelet/runtime → container
~~~

This is not a single synchronous transaction. The Deployment can exist before a Pod exists; a Pod can exist but remain Pending; a container can run while readiness fails.

## Explore a cluster

~~~sh
kubectl get nodes
kubectl get pods -A
kubectl get events -A --sort-by=.metadata.creationTimestamp
~~~

Some legacy health commands have been deprecated or are unreliable on current releases. Use the supported monitoring and health procedures for your distribution or provider.

In a local cluster, delete one Pod managed by a Deployment. Compare the Deployment, Pod, and event state before and after deletion.

## Distinguish related terms

| Term | Question it answers |
| --- | --- |
| Cluster | Which resources share this API and control plane? |
| Node | Which machine will run a workload? |
| Pod | Which containers are scheduled and networked together? |
| Controller | Which component keeps a desired count or condition? |
| Service | How do clients find a changing set of Pods? |

## Troubleshooting by layer

Start with get to see current status, describe to inspect events, and logs to inspect the application. For an unscheduled Pod, look at scheduler events and capacity. For an image error, inspect the registry name, credentials, TLS, DNS, and network. For a crash, inspect the process command, configuration, and logs.

## Quiz with answer key

1. **Which component selects a node?** The scheduler, after a controller has created the Pod and the API has recorded it.
2. **Does the API server start the container?** No. It stores and serves the object; kubelet and the runtime on a node start the process.
3. **Why can a Pod appear in the API but serve no traffic?** It may not be scheduled, may still be starting, may fail readiness, or the app/network may be broken.
4. **What happens when no node has enough capacity?** The Pod remains Pending; scheduling events explain the constraints. Increasing replicas does not create capacity.

## Further reading

- [Cluster architecture](https://kubernetes.io/docs/concepts/architecture/)
- [Kubernetes components](https://kubernetes.io/docs/concepts/overview/components/)
- [Kubernetes troubleshooting guides](https://kubernetes.io/docs/tasks/debug/)
- [Learning environment in the official Persian docs](https://kubernetes.io/fa/docs/setup/learning-environment/)
