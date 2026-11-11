# Load Balancing and EndpointSlices
[Persian edition](README.md) · [Chapter references](../../../references/README.en.md#05-services-and-networking)

[فارسی](README.md) | [Chapter 05](../../README.en.md)

## From selector to backend

A Service selects Pod labels. EndpointSlices hold backend addresses and conditions. The cluster data plane routes traffic for a ClusterIP to suitable backends; implementation details depend on the provider or CNI.

~~~yaml
apiVersion: v1
kind: Service
metadata:
  name: api
spec:
  selector:
    app: api
  ports:
    - name: http
      port: 80
      targetPort: 8080
  type: ClusterIP
~~~

This Service maps port 80 to port 8080 on selected Pods. The application must actually listen on 8080; containerPort is metadata and does not make a process listen.

## Readiness and distribution

A failed readiness check normally removes a Pod from Service traffic. Load balancing does not guarantee equal latency or shared session state. Sessionful apps need a session store or another design. Enable sessionAffinity or client-IP behavior only when required.

## Troubleshooting

~~~sh
kubectl get svc api -o yaml
kubectl get pods -l app=api --show-labels
kubectl get endpointslices -l kubernetes.io/service-name=api
kubectl describe pod -l app=api
~~~

- **No EndpointSlice endpoints:** selector/label mismatch, missing Pod, or unready Pod.
- **Endpoint exists but connection is refused:** inspect targetPort, listener, and process.
- **Timeout:** inspect policy, CNI, firewall, and routes.
- **Only one replica works:** compare readiness, labels, and process state for every Pod.

## Quiz
1. **Why are Service port and targetPort separate?** Clients can use a stable logical port while the app listens on another port.
2. **What can remove a backend from normal traffic?** Endpoint conditions and readiness, which is often informed by a probe.
3. **What does a Service with no endpoints prove?** Only that the Service object exists, not that a healthy backend exists.
4. **How should clients address Pods?** Through a Service rather than a fixed Pod-IP list.

## Further reading
- [Service concepts](https://kubernetes.io/docs/concepts/services-networking/service/)
- [EndpointSlices](https://kubernetes.io/docs/concepts/services-networking/endpoint-slices/)
- [Liveness, readiness, and startup probes](https://kubernetes.io/docs/concepts/configuration/liveness-readiness-startup-probes/)
- [Connecting applications with Services](https://kubernetes.io/docs/tutorials/services/connect-applications-service/)
- [Persian networking video](https://www.youtube.com/watch?v=FEpWJAqx79w)
