# Pod Networking, DNS, and CNI
[Persian edition](../../../../../fa/kubernetes/05-services-networking/topics/pod-networking/README.md) · [Chapter references](../../../references/README.md#05-services-and-networking)

[فارسی](../../../../../fa/kubernetes/05-services-networking/topics/pod-networking/README.md) | [Chapter 05](../../README.md)

## Network model

The Kubernetes network model expects Pods to communicate over cluster networking. A CNI plugin implements Pod connectivity and address allocation. A Service has a virtual IP and dynamic endpoints; the cluster data plane programs its routing. Some clusters use kube-proxy, while providers may supply other data planes.

Do not use Pod IPs for discovery because they change. CoreDNS resolves Service names inside the cluster. A Service in the same namespace is commonly addressed by a short name such as api; from another namespace, use a namespace-qualified name such as api.shop. The exact FQDN also depends on DNS policy and domain configuration.

## Test from inside a Pod

~~~sh
kubectl exec -it deploy/frontend -- sh
nslookup api
wget -qO- http://api:8080/health
~~~

If the application image lacks tools, use an authorized temporary diagnostic Pod rather than bloating a production image.

1. Does DNS return the Service?
2. Does the Service selector produce endpoints?
3. Does targetPort match the listening process?
4. Does NetworkPolicy permit the connection?
5. Are CNI agents and node routes healthy?

## NetworkPolicy

NetworkPolicy can restrict Pod ingress and egress, but the CNI must implement it. Design default-deny alongside the required DNS and dependency exceptions. Policy applies to selected Pods and namespaces; inspect labels and overlapping policies.

## Common symptoms

- DNS names fail broadly: inspect Pod DNS settings and CoreDNS.
- DNS works but requests time out: inspect policy, route, firewall, or destination.
- Direct Pod traffic works but Service traffic fails: inspect selector, EndpointSlice, and Service data plane.
- Only one node fails: inspect its CNI agent, route, and node conditions.

## Quiz
1. **What does CNI do?** It implements Pod networking according to the cluster's plugin.
2. **Does a successful ping prove HTTP health?** No. Port, TLS, handler, and dependencies are separate.
3. **What if CNI does not support NetworkPolicy?** The API may exist without the expected enforcement.
4. **How should a client find a backend Service?** Use Service DNS, not a fixed Pod IP.

## Further reading
- [Kubernetes networking concepts](https://kubernetes.io/docs/concepts/services-networking/)
- [DNS for Services and Pods](https://kubernetes.io/docs/concepts/services-networking/dns-pod-service/)
- [NetworkPolicy](https://kubernetes.io/docs/concepts/services-networking/network-policies/)
- [CNI specification](https://github.com/containernetworking/cni)
- [Cilium networking documentation](https://docs.cilium.io/en/stable/network/)
- [Debug Service connectivity](https://kubernetes.io/docs/tasks/debug/debug-application/debug-service/)
- [Persian Service/DNS video](https://www.youtube.com/watch?v=FEpWJAqx79w)
