# Kubernetes Concepts and Vocabulary
[Persian edition](README.md) · [Chapter references](../../../references/README.en.md#01-introduction-and-mental-model)

[فارسی](README.md) | [Chapter 01](../../README.en.md)

## Learning objective

Read an API object, distinguish a resource from its controller and running process, and troubleshoot labels and selectors.

## What does a Kubernetes object look like?

Most manifests have four major sections:

~~~yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: api
  namespace: shop
  labels:
    team: checkout
spec:
  replicas: 3
  selector:
    matchLabels:
      app: api
  template:
    metadata:
      labels:
        app: api
    spec:
      containers:
        - name: server
          image: example.invalid/shop/api:v1
~~~

- **apiVersion** names the API group and schema version.
- **kind** names the resource type.
- **metadata** includes the name, namespace, labels, and annotations.
- **spec** describes the desired state.
- **status** reports observed state; it is not a field to maintain by hand.

Do not confuse spec (“what we want”) with status (“what the cluster currently observes”).

## Labels and selectors

A label is a key/value used to categorize an object. A selector defines which objects match. For example, a Service can select Pods with app=api and create endpoints for ready matches. A typo in Pod labels may leave a Service without endpoints.

~~~sh
kubectl get pods --show-labels -n shop
kubectl get endpointslices -n shop
~~~

Review selectors carefully. A Deployment selector is generally immutable, and mismatches can cause incorrect workload ownership.

## Connect the concepts

- A Deployment is a higher-level controller.
- A ReplicaSet maintains a number of Pods.
- A Pod is a scheduled execution unit, not a machine.
- A Service selects backends and offers a logical address.
- A Namespace scopes names and some administration; it is not a complete security boundary.
- ConfigMaps and Secrets separate configuration from the container image.
- Events provide a timeline and clues, but do not replace application logs or metrics.

## Read the manifest

The Deployment selector in the example is app=api, and the Pod template carries the same label. The image address is intentionally illustrative and cannot be pulled. Replace it with a valid image to run the example. Use kubectl explain deployment.spec to inspect the schema supported by your cluster.

## Common traps

- Labels are for selection; annotations hold descriptive or tool-specific metadata.
- A namespace alone is not a security boundary.
- An object returned by get is not necessarily ready; inspect conditions, status, and endpoints.
- Do not copy an API version from an old example without checking your cluster's documentation.

## Quiz with explanations

1. **Where do you declare desired state?** In spec; observed state is reported in status.
2. **A Service has no backend. What should you compare first?** The Service selector against Pod labels, then Pod readiness.
3. **Why are annotations usually not used as selectors?** Labels are the mechanism for selection and grouping; annotations carry non-selective metadata.
4. **Does a Namespace provide complete isolation?** No. RBAC, NetworkPolicy, Pod security, and infrastructure boundaries may also be required.

## Further reading

- [Kubernetes objects](https://kubernetes.io/docs/concepts/overview/working-with-objects/)
- [Labels and selectors](https://kubernetes.io/docs/concepts/overview/working-with-objects/labels/)
- [Kubernetes API reference](https://kubernetes.io/docs/reference/kubernetes-api/)
- [Namespaces](https://kubernetes.io/docs/concepts/overview/working-with-objects/namespaces/)
- [Fadak's Persian Kubernetes API article](https://fadak.ir/fa/Article/1001106)
