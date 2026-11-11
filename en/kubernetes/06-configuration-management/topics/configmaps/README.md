# ConfigMaps
[Persian edition](../../../../../fa/kubernetes/06-configuration-management/topics/configmaps/README.md) · [Chapter references](../../../references/README.md#06-configuration-management)

[فارسی](../../../../../fa/kubernetes/06-configuration-management/topics/configmaps/README.md) | [Chapter 06](../../README.md)

## Structure and use

A ConfigMap stores non-sensitive key/value configuration. You can expose it as environment variables, with envFrom, or as mounted files. Choose according to the configuration format and how the application reloads it.

~~~yaml
apiVersion: v1
kind: ConfigMap
metadata:
  name: app-config
data:
  LOG_LEVEL: info
  app.yaml: |
    retries: 3
    timeout: 2s
~~~

~~~yaml
envFrom:
  - configMapRef:
      name: app-config
volumeMounts:
  - name: config-files
    mountPath: /etc/app
volumes:
  - name: config-files
    configMap:
      name: app-config
~~~

In the second example, the app.yaml key becomes a file. The application must read it; file configuration and environment variables have different semantics.

## Changes and rollouts

An environment variable in an existing process does not change when the ConfigMap changes. A mounted file may update after a delay, but the application may need to reread it. For deterministic releases, version the configuration or add a checksum to the Pod template so a change triggers a rollout. Do not put sensitive data in a ConfigMap.

## Troubleshooting
- **Pod fails to start:** the ConfigMap or required key may be missing.
- **Old value is still used:** env was read at startup or the file was not reloaded.
- **Wrong file path:** inspect mountPath and subPath.
- **The app cannot read it:** check file mode and application user.

## Quiz
1. **What belongs in a ConfigMap?** Non-sensitive configuration.
2. **When is an environment value read?** When the process starts.
3. **Does changing a ConfigMap always create a rollout?** No. A Pod-template change, such as a checksum, can make that behavior explicit.
4. **Where should a very large configuration archive go?** In an appropriate artifact or storage system, not an oversized ConfigMap.

## Further reading
- [ConfigMap concepts](https://kubernetes.io/docs/concepts/configuration/configmap/)
- [Configure a Pod using a ConfigMap](https://kubernetes.io/docs/tasks/configure-pod-container/configure-pod-configmap/)
- [Projecting ConfigMaps into volumes](https://kubernetes.io/docs/concepts/storage/projected-volumes/)
- [DevNA Persian guide](https://devna.ir/articles/kubernetes-basics-for-beginners)
