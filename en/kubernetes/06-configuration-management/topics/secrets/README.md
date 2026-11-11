# Secrets and Credential Management
[Persian edition](../../../../../fa/kubernetes/06-configuration-management/topics/secrets/README.md) · [Chapter references](../../../references/README.md#06-configuration-management)

[فارسی](../../../../../fa/kubernetes/06-configuration-management/topics/secrets/README.md) | [Chapter 06](../../README.md)

## What is a Secret, and what is it not?

A Secret is an API resource for sensitive values so credentials are not mixed with ordinary ConfigMap settings. Values in a manifest may use Base64, which is not encryption. Protection depends on encryption at rest, API access controls, etcd security, node access, and how the value is mounted.

~~~sh
kubectl create secret generic api-auth --from-file=TOKEN=./token.txt -n shop
kubectl get secret api-auth -n shop
~~~

Do not decode Secret values unless you have an authorized, specific need; terminal history and logs can expose them.

## Security controls

- Give each workload a separate service account and only the namespace/key access it needs.
- Keep Secrets out of images, Git, build logs, and issue/chat threads.
- Configure encryption at rest for etcd.
- Prefer an external secret manager and short-lived credentials when appropriate.
- Mount the credential only into containers that need it.
- Document rotation, revocation, audit, and incident response.
- Treat etcd backups as sensitive and encrypt them; they may contain cluster Secrets.

## Injection and rotation

Secrets can be injected as environment variables or volumes. An environment value does not change inside a running process. A projected file may update, but the program must reread it. Rotation may require a rollout. Validate the new value before revoking the old one to avoid authentication downtime.

## Troubleshooting

If a container cannot read a Secret, check namespace, object name, key, volumeMount, and file permissions. If a stale value is used, find out whether the app reads env at startup or reloads a file. Do not put credentials in YAML or command-line history as a quick fix.

## Quiz with explanations

1. **What does Base64 do to a Secret value?** It encodes it; it does not encrypt it.
2. **Why should every workload not read every Secret?** Broad permission increases the blast radius of a credential leak.
3. **What is a safe rotation order?** Create the new value, deliver it, test it, then revoke the old one.
4. **Why is an etcd backup sensitive?** It may contain copies of cluster Secrets.

## Further reading
- [Kubernetes Secrets](https://kubernetes.io/docs/concepts/configuration/secret/)
- [Encrypt data at rest](https://kubernetes.io/docs/tasks/administer-cluster/encrypt-data/)
- [RBAC](https://kubernetes.io/docs/reference/access-authn-authz/rbac/)
- [Service accounts](https://kubernetes.io/docs/concepts/security/service-accounts/)
- [External Secrets Operator documentation](https://external-secrets.io/latest/)
- [DevNA Persian guide](https://devna.ir/articles/kubernetes-basics-for-beginners)
