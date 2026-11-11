# Chapter 05: Services and Networking
[Persian edition](README.md) · [Chapter references](../references/README.en.md#05-services-and-networking)

[فارسی](README.md) | [Course index](../README.en.md)

## Learning objectives
- Explain the Pod network model and distinguish Pod IPs from Service addresses.
- Trace selectors, endpoints, DNS, and readiness along a connection path.
- Expose internal and external applications using the right abstraction.
- Troubleshoot from symptoms down to CNI, DNS, Service, and ingress layers.

## Networking layers

Kubernetes networking expects Pods to communicate using cluster networking. A CNI implementation provides Pod connectivity. A Service gives clients a logical address for a group of Pods; EndpointSlices describe backends. CoreDNS provides service discovery. External entry points such as LoadBalancer Services, Ingress, and Gateway rely on a controller or provider integration.

~~~text
Client → DNS/hostname → load balancer or Gateway/Ingress
→ Service → EndpointSlice → ready Pod → container port
~~~

These are independent pieces. Being able to ping a Pod does not prove that HTTP, TLS, selectors, or readiness are correct.

## Keep Services and external entry points distinct

- **ClusterIP:** stable internal access to backends.
- **NodePort:** opens a port on nodes; by itself it is not usually a complete public-exposure design.
- **LoadBalancer:** asks an infrastructure integration to provide an address.
- **Ingress:** describes HTTP/S host and path rules; a controller must implement them.
- **Gateway API:** a more extensible model for roles and traffic; it also needs a Gateway controller.

A Service provides cluster-level backend access. Ingress or Gateway defines incoming traffic and routing. Neither replaces the other.

## Diagnostic clues

~~~sh
kubectl get svc
kubectl get endpointslices
kubectl get pods -o wide
kubectl describe service api
kubectl logs deployment/coredns -n kube-system
~~~

If a Service has an IP but no endpoints, compare selector, labels, and readiness. If a name does not resolve, inspect Pod DNS settings and CoreDNS. If the application works inside but not outside, inspect controller status/logs, firewall, public DNS, certificates, and provider integration.

## Practice

Create a backend Deployment and Service. Deliberately mismatch the selector and inspect its EndpointSlice, then fix it. Next make a readiness check fail and observe how the ready endpoints change. Use a local learning cluster.

## Quiz with answers

1. **How does a Service find new Pods?** Its selector matches Pod labels and endpoint controllers update the backend list.
2. **Why not give clients a Pod IP?** Pods can be replaced; a Service provides a logical stable address.
3. **What does an Ingress object need to work?** An Ingress controller and its data-plane infrastructure.
4. **DNS resolves but connection times out. What is next?** Inspect EndpointSlices, readiness, ports, policy, and CNI routes.
5. **Why might a local LoadBalancer not get an IP?** The local cluster may not have a provider integration.

## Further reading

- [Kubernetes Services, Load Balancing, and Networking](https://kubernetes.io/docs/concepts/services-networking/)
- [Services](https://kubernetes.io/docs/concepts/services-networking/service/)
- [EndpointSlices](https://kubernetes.io/docs/concepts/services-networking/endpoint-slices/)
- [DNS for Services and Pods](https://kubernetes.io/docs/concepts/services-networking/dns-pod-service/)
- [Ingress](https://kubernetes.io/docs/concepts/services-networking/ingress/)
- [Gateway API](https://gateway-api.sigs.k8s.io/)
- [NetworkPolicy](https://kubernetes.io/docs/concepts/services-networking/network-policies/)
- [Open source Cilium networking documentation](https://docs.cilium.io/en/stable/network/)
- [Persian Service and networking video](https://www.youtube.com/watch?v=FEpWJAqx79w)
