# Chapter 08: Kubernetes Security
[Persian edition](../../../fa/kubernetes/08-security/README.md) · [Chapter references](../references/README.md#08-security)

[فارسی](../../../fa/kubernetes/08-security/README.md) | [Course index](../README.md)

## Threat model

Security is more than RBAC. Trace assets and access paths from API identity through the control plane and etcd, nodes and runtime, images and build pipeline, network, Secrets, volumes, and backups. For each actor, ask which credentials it holds, which resources it can access, and what a compromise could affect.

## Identity and authorization

Authentication identifies a requester; authorization decides what it may do. RBAC grants permissions with Roles, ClusterRoles, and bindings. Give each workload a dedicated ServiceAccount and least privilege. Do not grant cluster-admin to “fix” a Forbidden response.

## Network security

NetworkPolicy restricts Pod ingress/egress if the CNI implements enforcement. Map real traffic, then test the required connections. NetworkPolicy does not replace application TLS/authentication or cloud firewalls.

## Containers and admission

Pod Security Standards and securityContext guide non-root execution, minimal capabilities, seccomp, and filesystem restrictions. Image provenance, scanning, signing, and admission policy protect the supply chain. A clean scan does not prove complete security.

## Example design

For a checkout service:
- Give the API and worker separate ServiceAccounts.
- Allow the API to read only its required ConfigMaps and Secrets.
- Accept ingress only from the gateway; allow backend traffic only from approved services.
- Use versioned images built through a controlled pipeline.
- Run containers non-root with resource and filesystem controls.
- Document audit, alerting, rotation, and credential-exposure response.

A Namespace alone is not a complete security boundary. Combine RBAC, NetworkPolicy, admission, and infrastructure controls.

## Practice

1. Create a ServiceAccount and a Role that allows get on one ConfigMap.
2. Verify it cannot read Secrets.
3. Apply default-deny in a learning namespace and add only required DNS/API paths.
4. Test Pod Security enforcement with a deliberately over-privileged Pod.

## Quiz with answer key

1. **Role vs RoleBinding?** A Role defines permissions; a binding assigns them to an identity.
2. **What if CNI does not support NetworkPolicy?** Enforcement may not happen.
3. **Is a Base64 Secret secure?** No. Base64 is encoding, not encryption.
4. **Why isn't a Namespace enough?** It does not provide every identity, network, kernel, and infrastructure boundary.
5. **Why record image provenance?** Teams need to know where and how an artifact was built.

## Further reading
- [Kubernetes security concepts](https://kubernetes.io/docs/concepts/security/)
- [RBAC](https://kubernetes.io/docs/reference/access-authn-authz/rbac/)
- [NetworkPolicy](https://kubernetes.io/docs/concepts/services-networking/network-policies/)
- [Pod Security Standards](https://kubernetes.io/docs/concepts/security/pod-security-standards/)
- [Admission control](https://kubernetes.io/docs/reference/access-authn-authz/admission-controllers/)
- [Kubernetes supply-chain security](https://kubernetes.io/docs/concepts/security/software-supply-chain-security/)
- [Fadak Persian Kubernetes API article](https://fadak.ir/fa/Article/1001106)
