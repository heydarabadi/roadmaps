# NetworkPolicy and Network Security
[Persian edition](../../../../../fa/kubernetes/08-security/topics/network-security/README.md) · [Chapter references](../../../references/README.md#08-security)

[فارسی](../../../../../fa/kubernetes/08-security/topics/network-security/README.md) | [Chapter 08](../../README.md)

## From a traffic map to policy

A NetworkPolicy restricts ingress or egress for selected Pods. Multiple policies can combine allowed paths. The CNI must enforce them; the existence of an API object does not prove traffic is filtered.

Before default-deny, map DNS, frontend-to-API, API-to-database, telemetry, and external dependencies. Add the required allowances and test both permitted and denied paths in staging.

~~~yaml
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: allow-api-from-front
  namespace: shop
spec:
  podSelector:
    matchLabels:
      app: api
  policyTypes:
    - Ingress
  ingress:
    - from:
        - podSelector:
            matchLabels:
              app: frontend
      ports:
        - protocol: TCP
          port: 8080
~~~

This example allows one ingress path only. Plan egress and DNS too, and verify that selectors match actual Pod labels.

## Troubleshoot

If a policy blocks traffic, inspect namespace, podSelector, namespaceSelector, port, protocol, and policyTypes. Test from an authorized diagnostic environment and inspect CNI logs/metrics. NetworkPolicy does not provide TLS, application identity, or perimeter firewalls.

## Quiz
1. **Which directions can NetworkPolicy control?** Ingress and egress.
2. **What can default-deny accidentally block?** DNS, telemetry, and dependencies without explicit allowances.
3. **Why does CNI support matter?** The API stores the policy, but the CNI enforces packets.
4. **Does a policy authenticate an API user?** No. Application and API authentication/authorization are separate.

## Further reading
- [NetworkPolicy](https://kubernetes.io/docs/concepts/services-networking/network-policies/)
- [Kubernetes network model](https://kubernetes.io/docs/concepts/services-networking/)
- [CNI specification](https://github.com/containernetworking/cni)
- [Cilium network policy](https://docs.cilium.io/en/stable/security/policy/)
- [Persian networking video](https://www.youtube.com/watch?v=FEpWJAqx79w)
