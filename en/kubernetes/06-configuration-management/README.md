# Chapter 06: Configuration and Sensitive Data
[Persian edition](../../../fa/kubernetes/06-configuration-management/README.md) · [Chapter references](../references/README.md#06-configuration-management)

[فارسی](../../../fa/kubernetes/06-configuration-management/README.md) | [Course index](../README.md)

## Why separate configuration from the image?

The same image should be usable in development, staging, and production; endpoints, feature settings, and credentials differ by environment. If configuration is baked into the image, every environment needs a separate artifact. Kubernetes can provide ConfigMaps and Secrets as environment variables or files.

## ConfigMap versus Secret

A ConfigMap holds non-sensitive settings such as APP_MODE or a service URL. A Secret is intended for sensitive data, but default Base64 encoding is not encryption. RBAC, encryption at rest, access limits, and rotation remain necessary.

~~~yaml
apiVersion: v1
kind: ConfigMap
metadata:
  name: web-config
data:
  LOG_LEVEL: info
---
apiVersion: v1
kind: Secret
metadata:
  name: web-secret
type: Opaque
stringData:
  API_TOKEN: replace-in-local-lab
~~~

Never commit the sample Secret to Git. For production, use an approved secret manager or secure encryption and delivery process.

## Files and environment variables

Environment variables are read when a process starts; changing the object does not change an already-running process environment. A projected volume can update files, but the application must reread them. Some apps only reload on restart. For predictable changes, use an explicit rollout or a checksum annotation in your Helm/GitOps release.

## Secret lifecycle

Design rotation as a sequence: create a new value, deliver it, validate that the app uses it, then revoke the old one. If the process reads it only at startup, coordinate a restart. Do not print secrets in logs or errors.

## Operational checklist

- Put non-sensitive settings in ConfigMaps and sensitive values in a Secret or secret manager.
- Limit Secret access to the service accounts that need it.
- Keep credential files out of Git, image artifacts, and logs.
- Know how environment and mounted-file changes propagate.
- Observe readiness and rollout after configuration changes.
- Keep configuration small; ConfigMaps are not bulk file or database storage.

## Quiz with answers

1. **When does a ConfigMap change reach an existing environment variable?** It does not automatically; the process needs a restart or explicit reload.
2. **Does Base64 protect a Secret?** No. It encodes the value.
3. **Why keep config out of the image?** Build one artifact and configure it separately for each environment.
4. **How do you rotate a Secret safely?** Deliver and validate the new value before revoking the old one.

## Further reading
- [Kubernetes configuration concepts](https://kubernetes.io/docs/concepts/configuration/)
- [ConfigMaps](https://kubernetes.io/docs/concepts/configuration/configmap/)
- [Secrets](https://kubernetes.io/docs/concepts/configuration/secret/)
- [Encrypt data at rest](https://kubernetes.io/docs/tasks/administer-cluster/encrypt-data/)
- [DevNA Persian Kubernetes basics](https://devna.ir/articles/kubernetes-basics-for-beginners)
