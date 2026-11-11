# Volumes, PersistentVolumes, and PVCs
[Persian edition](../../../../../fa/kubernetes/11-storage-volumes/topics/pv-pvc/README.md) · [Chapter references](../../../references/README.md#11-storage-and-volumes)

[فارسی](../../../../../fa/kubernetes/11-storage-volumes/topics/pv-pvc/README.md) | [Chapter 11](../../README.md)

## Storage types

emptyDir is scratch space or a way to share files inside a Pod; it disappears when the Pod is deleted. A PersistentVolumeClaim is an independent storage request. A Pod mounts the claim so its lifecycle is separate from a particular container. ConfigMaps and Secrets can also be projected as volumes, but they are not general-purpose durable storage.

## Provisioning

~~~yaml
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: uploads
spec:
  accessModes:
    - ReadWriteOnce
  resources:
    requests:
      storage: 5Gi
  storageClassName: standard
~~~

With a dynamic StorageClass, a provisioner creates a PV and binds the claim. If the class or suitable capacity is unavailable, the claim stays Pending. Inspect requested size, access mode, zone topology, and reclaim policy in events and resource status.

ReadWriteOnce means read-write mounting from one node. Multiple Pods on that node may be possible depending on the driver. ReadWriteMany and ReadWriteOncePod have different semantics. Do not treat access mode as a data lock or replication feature.

## Data and cleanup

~~~sh
kubectl get pvc,pv
kubectl describe pvc uploads
kubectl get storageclass
~~~

Inspect a PVC before deleting it. Reclaim policy can delete or retain the underlying volume. Test backup/snapshot and restore. A healthy volume does not protect against logical errors, ransomware, or user deletion.

## Quiz
1. **When is emptyDir deleted?** When the Pod is deleted.
2. **How does a Pod use a PVC?** It mounts the claim as a volume.
3. **Why could a claim be Pending?** StorageClass, capacity, permissions, topology, or CSI issues.
4. **Is access mode a backup policy?** No.
5. **What do you check before deleting a claim?** Data owner, snapshot, reclaim policy, and retention needs.

## Further reading
- [PersistentVolumes](https://kubernetes.io/docs/concepts/storage/persistent-volumes/)
- [Volumes](https://kubernetes.io/docs/concepts/storage/volumes/)
- [StorageClasses](https://kubernetes.io/docs/concepts/storage/storage-classes/)
- [Volume snapshots](https://kubernetes.io/docs/concepts/storage/volume-snapshots/)
