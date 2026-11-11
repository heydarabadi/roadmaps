# Container Storage Interface (CSI)
[Persian edition](../../../../../fa/kubernetes/11-storage-volumes/topics/csi/README.md) · [Chapter references](../../../references/README.md#11-storage-and-volumes)

[فارسی](../../../../../fa/kubernetes/11-storage-volumes/topics/csi/README.md) | [Chapter 11](../../README.md)

## What does CSI do?

Container Storage Interface standardizes the boundary between Kubernetes and a storage driver. A driver may create, attach, mount, detach, and snapshot volumes. The control plane commonly runs external provisioner/controller components and the node runs a plugin. Both must be healthy for provisioning and mounting.

## Volume path

1. An application creates a PVC.
2. A StorageClass selects the provisioner and parameters.
3. The driver creates storage in its backend.
4. The scheduler considers topology and node placement.
5. A controller performs attach operations.
6. The node plugin mounts the volume.
7. kubelet makes it available inside the Pod.

## Troubleshooting

For a Pending PVC, inspect claim events and StorageClass. If attach/mount fails, inspect the node, CSI controller, node plugin, cloud permissions, zone, and attachment limits. Test driver upgrades with real workloads and snapshots.

## Operational decisions

Choose a driver based on latency, IOPS, access modes, zones, encryption, snapshots, and consistency. Provisioning speed is not the only factor; support, cost, backup, and restore matter. A local test driver may not provide production features.

## Quiz
1. **What boundary does CSI standardize?** The interface between Kubernetes and storage implementations.
2. **PVC Pending before any Pod exists: what first?** PVC events and provisioner/StorageClass.
3. **Pod stuck mounting: which layers?** CSI node plugin, node, and attach state.
4. **What does snapshotting require?** Driver support, compatible configuration, retention, and a tested restore.

## Further reading
- [CSI volumes in Kubernetes](https://kubernetes.io/docs/concepts/storage/volumes/#csi)
- [Container Storage Interface specification](https://github.com/container-storage-interface/spec)
- [Volume snapshots](https://kubernetes.io/docs/concepts/storage/volume-snapshots/)
- [CSI drivers in Kubernetes](https://kubernetes-csi.github.io/docs/)
