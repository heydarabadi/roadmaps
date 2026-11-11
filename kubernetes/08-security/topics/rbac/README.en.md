# RBAC: Role-Based Access Control
[Persian edition](README.md) · [Chapter references](../../../references/README.en.md#08-security)

[فارسی](README.md) | [Chapter 08](../../README.en.md)

## Four components

- **Role:** permissions on resources within a namespace.
- **ClusterRole:** permissions usable cluster-wide or referenced by a namespaced binding.
- **RoleBinding:** binds a Role or ClusterRole to a user, group, or ServiceAccount in one namespace.
- **ClusterRoleBinding:** binds a ClusterRole to subjects across the cluster.

A RoleBinding that references a ClusterRole is still scoped to the binding's namespace. A ClusterRoleBinding is broader. A Role defines access; no subject receives it until a binding connects them.

~~~yaml
apiVersion: v1
kind: ServiceAccount
metadata:
  name: report-reader
  namespace: reports
---
apiVersion: rbac.authorization.k8s.io/v1
kind: Role
metadata:
  name: read-config
  namespace: reports
rules:
  - apiGroups: [""]
    resources: ["configmaps"]
    verbs: ["get", "list"]
---
apiVersion: rbac.authorization.k8s.io/v1
kind: RoleBinding
metadata:
  name: report-reader-binding
  namespace: reports
subjects:
  - kind: ServiceAccount
    name: report-reader
    namespace: reports
roleRef:
  apiGroup: rbac.authorization.k8s.io
  kind: Role
  name: read-config
~~~

This lets the workload read ConfigMaps in that namespace. If it needs one specific object, consider resourceNames. Do not grant Secret access without a clear need.

## Test access

~~~sh
kubectl auth can-i list configmaps -n reports --as=system:serviceaccount:reports:report-reader
kubectl auth can-i get secrets -n reports --as=system:serviceaccount:reports:report-reader
kubectl get role,rolebinding -n reports
~~~

Under least privilege, the second check should say no. For Forbidden, inspect the effective identity, verb, API group, resource, namespace, and bindings. Do not grant admin access as a quick fix.

## Least privilege
Use a dedicated ServiceAccount per workload, avoid wildcards, grant the minimum verbs, use short-lived human credentials, and review old bindings. A workload that does not call the API should not mount a token without a reason.

## Quiz
1. **Which component attaches permissions to an identity?** A binding.
2. **Are get and list the same?** No; reading one object differs from listing a resource.
3. **Why are wildcards risky?** They can include new or sensitive permissions.
4. **How do you debug Forbidden?** Compare the effective identity and binding rules to the exact request.

## Further reading
- [RBAC authorization](https://kubernetes.io/docs/reference/access-authn-authz/rbac/)
- [ServiceAccounts](https://kubernetes.io/docs/concepts/security/service-accounts/)
- [Authorization overview](https://kubernetes.io/docs/reference/access-authn-authz/authorization/)
- [Good practices for RBAC](https://kubernetes.io/docs/concepts/security/rbac-good-practices/)
- [Fadak Persian Kubernetes API article](https://fadak.ir/fa/Article/1001106)
