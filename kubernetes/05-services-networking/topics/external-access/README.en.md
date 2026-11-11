# External Access to a Service
[Persian edition](README.md) · [Chapter references](../../../references/README.en.md#05-services-and-networking)

[فارسی](README.md) | [Chapter 05](../../README.en.md)

## Choose an exposure method

ClusterIP is internal-only and is the default choice for many backends. NodePort opens a port on every node; public exposure also requires firewall and port management. LoadBalancer asks a provider or controller to create an IP or hostname. Ingress and Gateway describe HTTP routing, hosts, and TLS, and require a controller.

ExternalName aliases an external DNS name; it is not a proxy or load balancer. A local tunnel creates a practice path only and does not prove a production architecture.

## Incoming HTTP flow

1. Public DNS resolves the hostname to a load balancer.
2. The load balancer sends traffic to a controller or Gateway.
3. A route selects a Service by host and path.
4. The Service selects ready Pod endpoints.
5. Readiness, port name, targetPort, and application listener must agree.
6. TLS may terminate at the edge or in the application; document termination and trust.

## Troubleshooting

~~~sh
kubectl get svc,ingress,gateway -A
kubectl describe ingress shop
kubectl get endpointslices
kubectl get pods -A
~~~

An Ingress without a controller can remain only an API object. A LoadBalancer Service may not receive an address without a cloud-controller or local integration. Inspect DNS, controller logs, firewall, certificates, and backend readiness separately.

## Design choices and traps

ClusterIP suits internal backends. Public websites need DNS, TLS, a controller, certificate rotation, and policy. Do not assume NodePort is a safe production shortcut. Avoid unnecessary duplicate controllers and document provider-specific annotations.

## Quiz
1. **Ingress vs Service?** A Service provides stable backend access; Ingress describes HTTP entry and needs a controller.
2. **Why can a local LoadBalancer stay Pending?** There may be no external-load-balancer integration.
3. **What do you check before the firewall?** Endpoints, selectors, readiness, and the application listener.
4. **Which Service type is internal-only?** ClusterIP.

## Further reading
- [Service types](https://kubernetes.io/docs/concepts/services-networking/service/)
- [Ingress concepts](https://kubernetes.io/docs/concepts/services-networking/ingress/)
- [Gateway API](https://gateway-api.sigs.k8s.io/)
- [Gateway API concepts](https://gateway-api.sigs.k8s.io/guides/)
- [Persian Service and networking tutorial](https://www.youtube.com/watch?v=FEpWJAqx79w)
