# StatefulSets
[Persian edition](../../../../../fa/kubernetes/04-running-applications/topics/statefulsets/README.md) · [Chapter references](../../../references/README.md#04-running-applications)

[فارسی](../../../../../fa/kubernetes/04-running-applications/topics/statefulsets/README.md) | [Chapter 04](../../README.md)

## What remains stable?

A StatefulSet gives replicas stable ordinal identities and network names. With a claim template, each replica gets its own persistent claim. If a Pod named db-0 is replaced, it keeps its ordinal and its associated PVC can be mounted again. A headless Service commonly provides DNS names for individual replicas.

This identity does not automatically replicate a database or make it highly available. The application must implement consistency, elections, quorum, and failover. Backups and restores are also separate. A managed database may carry less operational risk for some teams.

## Basic shape

~~~yaml
apiVersion: apps/v1
kind: StatefulSet
metadata:
  name: db
spec:
  serviceName: db
  replicas: 2
  selector:
    matchLabels:
      app: db
  template:
    metadata:
      labels:
        app: db
    spec:
      containers:
        - name: database
          image: example.invalid/database:v1
          volumeMounts:
            - name: data
              mountPath: /var/lib/data
  volumeClaimTemplates:
    - metadata:
        name: data
      spec:
        accessModes: ["ReadWriteOnce"]
        resources:
          requests:
            storage: 10Gi
~~~

This is only an API skeleton, not a production database. The image, security, credentials, probes, StorageClass, replication, and recovery need separate design.

## Safer operations

- Check healthy members and quorum before upgrades.
- Align volume topology with node and zone placement.
- StatefulSet and PVC lifecycles differ; deleting a workload may leave its data behind.
- Match a PodDisruptionBudget to real quorum; an overly strict budget can block draining.
- Regularly restore from backup in a separate test.

## Quiz with explanations

1. **What survives a Pod replacement?** Ordinal name and associated claim, not necessarily healthy data or quorum.
2. **Does a StatefulSet create HA by itself?** No. The software must implement replication and leader selection.
3. **Will deleting a StatefulSet erase data?** That depends on PVC/PV and reclaim policies; inspect before deletion.
4. **What do you check before a node upgrade?** Quorum, PDB, replacement capacity, volume state, and recovery.

## Further reading
- [StatefulSets](https://kubernetes.io/docs/concepts/workloads/controllers/statefulset/)
- [Run a replicated stateful application](https://kubernetes.io/docs/tasks/run-application/run-replicated-stateful-application/)
- [StorageClasses](https://kubernetes.io/docs/concepts/storage/storage-classes/)
- [Persistent volumes](https://kubernetes.io/docs/concepts/storage/persistent-volumes/)
- [EasyEnv Persian course](https://easyenv.io/engineering/courses/catalog/kubernetes/fa)
