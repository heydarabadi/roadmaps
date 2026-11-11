# Chapter 11: Storage and Volumes
[Persian edition](../../../fa/kubernetes/11-storage-volumes/README.md) · [Chapter references](../references/README.md#11-storage-and-volumes)

[فارسی](../../../fa/kubernetes/11-storage-volumes/README.md) | [Course index](../README.md)

## Learning objectives
- Explain ephemeral volumes, PVs, PVCs, and StorageClasses.
- Trace provisioning and mounting through CSI.
- Distinguish persistent storage from backup and recovery.
- Assess topology, access modes, and reclaim policy before deleting resources.

## Why is a container filesystem not enough?

A container's writable layer usually disappears when its Pod is removed or replaced. Volumes decouple data from that container lifecycle. emptyDir exists for the life of the Pod and is deleted with it. A PVC requests storage that may outlive the Pod.

## Request-to-disk model

- **PVC:** the application namespace requests storage.
- **PV:** cluster storage that satisfies a claim.
- **StorageClass:** storage type and dynamic-provisioning policy.
- **CSI driver:** connects Kubernetes to a provider/storage system to provision, attach, mount, and sometimes snapshot.
- **Snapshot/backup:** recovery mechanisms; a volume is not itself a backup.

~~~yaml
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: app-data
spec:
  accessModes:
    - ReadWriteOnce
  resources:
    requests:
      storage: 5Gi
  storageClassName: standard
~~~

The StorageClass must exist. Access modes describe attachment semantics; ReadWriteOnce commonly means read-write from one node, not necessarily one Pod. Actual behavior depends on the driver.

## Lifecycle and data

The reclaim policy controls what can happen to the PV after a claim is deleted. Retain and Delete have different consequences. Before deleting a PVC, inspect its PV, snapshots, replication, and data policy. Deleting a Pod usually does not delete its claim, but that is not a backup guarantee.

## Troubleshooting and practice

If a PVC is Pending, inspect events, StorageClass, provisioner, quota, topology, and CSI controllers. If a Pod remains in ContainerCreating, inspect attach/mount events and node access. Create a PVC, delete and recreate its Pod, then confirm the data. Practice snapshot/restore in a learning cluster.

## Operational experience

A persistent disk protects against some failures only. Region loss, user error, corruption, or accidental deletion can affect the volume too. For a financial system, separately design snapshots, copies outside the cluster, encryption, RPO/RTO, and restore drills.

## Quiz
1. **PVC versus PV?** A PVC is a request; a PV is a backing resource.
2. **What does a StorageClass do?** Selects a storage type and provisioning process.
3. **Does RWO necessarily mean one Pod can mount the volume?** Not exactly; it is node-oriented and actual behavior depends on the driver.
4. **Is a persistent volume a backup?** No. Backups and tested restores are separate.
5. **PVC Pending: first clue?** Claim events and StorageClass/provisioner status.

## Further reading
- [Kubernetes storage concepts](https://kubernetes.io/docs/concepts/storage/)
- [Persistent volumes](https://kubernetes.io/docs/concepts/storage/persistent-volumes/)
- [StorageClasses](https://kubernetes.io/docs/concepts/storage/storage-classes/)
- [Volume snapshots](https://kubernetes.io/docs/concepts/storage/volume-snapshots/)
- [CSI specification](https://github.com/container-storage-interface/spec)
- [EasyEnv Persian course](https://easyenv.io/engineering/courses/catalog/kubernetes/fa)
