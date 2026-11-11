# Create a Local Cluster
[Persian edition](README.md) · [Chapter references](../../../references/README.en.md#03-setting-up-kubernetes)

[فارسی](README.md) | [Chapter 03](../../README.en.md)

## Why local?

A local cluster is a cheap, disposable place to learn APIs and manifests. It does not accurately reproduce cloud networking, load balancers, production CSI, high availability, IAM, quotas, or multi-zone failures.

## kind and minikube
- **kind** runs cluster nodes in containers; useful for manifest tests, CI, and local multi-node labs.
- **minikube** offers local drivers and learning add-ons.
- Desktop Kubernetes tools simplify setup but retain resource, network, and storage limitations.

Choose based on OS, container runtime, laptop resources, and lab goals. Follow current project installation docs because options change.

## Create and delete a kind cluster

~~~sh
kind create cluster --name learn
kubectl config current-context
kubectl get nodes
kubectl cluster-info
kind delete cluster --name learn
~~~

Check the context before deletion; deleting the cluster removes its resources. Use clear context names when practicing with multiple clusters.

## Readiness checklist
- Install kubectl and compare client/server versions.
- Decide how nodes will access local images; kind may need the image loaded explicitly.
- Allocate enough CPU, memory, and disk.
- Never commit personal kubeconfig files.
- Delete practice namespaces and clusters after the lab.

## Limitations
A LoadBalancer Service may need a local integration or tunnel. A default StorageClass may use a simple local driver. Passing a local test validates only part of an API and manifest, not production readiness.

## Quiz
1. **Why is local good for learning?** Fast, disposable, and low risk.
2. **Why is it not staging?** Failure domains, provider integration, storage, and networks differ.
3. **A local image cannot be pulled. What do you check?** Whether the node can access it through cache or registry.
4. **What do you check before deletion?** The active context and whether anything must be kept.

## Further reading
- [Kubernetes learning environment](https://kubernetes.io/docs/setup/learning-environment/)
- [Learning environment in Persian](https://kubernetes.io/fa/docs/setup/learning-environment/)
- [kind Quick Start](https://kind.sigs.k8s.io/docs/user/quick-start/)
- [kind configuration](https://kind.sigs.k8s.io/docs/user/configuration/)
- [minikube Start](https://minikube.sigs.k8s.io/docs/start/)
- [minikube drivers](https://minikube.sigs.k8s.io/docs/drivers/)
