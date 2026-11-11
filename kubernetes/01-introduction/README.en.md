# Chapter 01: Introduction and the Kubernetes Mental Model
[Persian edition](README.md) · [Chapter references](../references/README.en.md#01-introduction-and-mental-model)

[فارسی](README.md) | [Course index](../README.en.md)

## Learning objectives

After this chapter, you should be able to:

- Explain what Kubernetes is designed to manage and what remains outside its scope.
- Describe desired state, observed state, and reconciliation.
- Trace a deployment request from kubectl to a running container.
- Decide whether Kubernetes is appropriate for a workload and team.

## Core idea

Kubernetes is a distributed system for managing containerized workloads. You submit desired state through an API. Controllers and other cluster components continuously try to make observed state converge toward that request.

This control-loop model is more useful than memorizing commands. A successful API request means that the object was accepted. It does not mean the application is already ready to serve users.

## From a Deployment request to a running application

Suppose a Deployment specifies two copies of a web application:

1. kubectl sends the manifest to the API server.
2. The API server authenticates and authorizes the request, validates the object, and runs admission controls.
3. The accepted object is persisted in the cluster data store, usually etcd.
4. The Deployment controller notices the desired replica count and creates a ReplicaSet.
5. The ReplicaSet creates Pods. The scheduler assigns each unscheduled Pod to a node based on resources and constraints.
6. The node's kubelet asks the container runtime to prepare the image and start the container.
7. Networking, volumes, and probes are configured; node status is reported back through the API.
8. Controllers keep reconciling while actual state differs from desired state.

This is asynchronous. The request does not directly log into each server and launch a process. Controllers also do not understand business correctness unless you describe health and policy through probes, metrics, and configuration.

## Desired state and observed state

A Deployment's desired state may specify three replicas and a Pod template. Observed state might contain one healthy Pod, one starting Pod, and one failing Pod. The controller detects the difference and tries to correct it.

Declarative management has practical consequences:

- Reapplying a reviewed manifest should converge on the declared state.
- Version-controlled configuration helps teams audit and reproduce changes.
- Manual node edits can conflict with the declared state.
- A controller faithfully repeats a bad configuration too; reconciliation does not repair application bugs.

## A small working example

~~~yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: web
  labels:
    app: web
spec:
  replicas: 2
  selector:
    matchLabels:
      app: web
  template:
    metadata:
      labels:
        app: web
    spec:
      containers:
        - name: nginx
          image: nginx:stable
          ports:
            - name: http
              containerPort: 80
          resources:
            requests:
              cpu: 100m
              memory: 64Mi
~~~

Save this as web.yaml in a learning cluster:

~~~sh
kubectl apply -f web.yaml
kubectl get deployment,pods
kubectl describe deployment web
kubectl get events --sort-by=.metadata.creationTimestamp
~~~

The Deployment selector must match the Pod-template labels. If you change replicas from two to three and apply again, the controller works toward the new desired state.

## When is Kubernetes a reasonable choice?

| Kubernetes may be useful when | Consider a simpler option when |
| --- | --- |
| You operate multiple services and environments with frequent releases | One application runs on one host with stable traffic |
| You need repeatable rollouts, scheduling, or team isolation | The team cannot staff cluster and add-on operations |
| A shared API and ecosystem help standardize automation | A managed container service already meets the need |
| Platform engineering is justified by the workload | Networking, storage, and operational cost exceed the product value |

A busy store with several APIs and daily releases may benefit from a standard orchestration platform. A small informational site may be cheaper to operate on simpler hosting. Compare total cost of ownership, not technology popularity.

## Published case experience

CNCF's Michelin case describes a platform supporting hundreds of business applications across multiple clusters. The broader lesson is that a platform must support onboarding, upgrades, security, observability, and failure handling, not only container packaging. Compare the organization’s scale with your own before reusing its architecture.

## Common traps

- Treating Kubernetes as Docker or as the container runtime.
- Assuming a Pod keeps the same IP address forever.
- Treating a successful apply as proof that the application is healthy.
- Expecting Kubernetes to fix application bugs, database outages, or missing backups.
- Running production without owners, runbooks, upgrades, and incident response.

## Quiz with explanations

1. **Why define replicas in a Deployment instead of creating one Pod once?**  
   A Deployment maintains the desired count through controllers. A standalone Pod has no workload controller to replace it if it disappears.

2. **Why inspect rollout status and readiness after the manifest is accepted?**  
   The API accepted the request, but image pulls, scheduling, startup, and health checks can still fail.

3. **Does recreating a failed Pod guarantee availability?**  
   No. A bad image or configuration will produce another bad Pod. Probes, capacity, rollback, and observability are still needed.

4. **What might a managed provider operate, and what remains with the application team?**  
   A provider may manage part of the control plane. The team still owns its workload, data, permissions, configuration, cost, and recovery design.

## Further reading

- [Kubernetes roadmap](https://roadmap.sh/kubernetes) and its [official PDF](https://roadmap.sh/pdfs/roadmaps/kubernetes.pdf)
- [Kubernetes concepts](https://kubernetes.io/docs/concepts/)
- [Cluster components](https://kubernetes.io/docs/concepts/overview/components/)
- [Michelin CNCF case study](https://www.cncf.io/case-studies/michelin/)
- [VSCO: how Kubernetes changed its deployment process](https://www.cncf.io/blog/2019/02/20/how-vsco-saved-with-kubernetes/)
- [Production Kubernetes: architecture and lessons](https://mpurayil.com/blog/kubernetes-production-case-study)
- [DevNA: Kubernetes basics for beginners](https://devna.ir/articles/kubernetes-basics-for-beginners)
