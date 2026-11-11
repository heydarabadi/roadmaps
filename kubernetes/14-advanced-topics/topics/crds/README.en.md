<div dir="ltr" align="left">

# CustomResourceDefinitions (CRDs)

**Chapter:** [Advanced topics](../../README.en.md) · **Persian:** [فارسی](README.md) · **More references:** [Advanced topics bibliography](../../../references/README.en.md#14-advanced-topics-and-extensibility)

## Define a new API type

A CRD introduces a new resource kind with an API group, version, scope, names, and OpenAPI schema. The API server validates and stores instances, called custom resources. Design a CRD as a stable user-facing API: removing or incompatibly changing it can make important objects inaccessible or invalid.

~~~yaml
apiVersion: apiextensions.k8s.io/v1
kind: CustomResourceDefinition
metadata:
  name: backups.ops.example.com
spec:
  group: ops.example.com
  scope: Namespaced
  names:
    plural: backups
    singular: backup
    kind: Backup
    shortNames: [bkp]
  versions:
    - name: v1
      served: true
      storage: true
      schema:
        openAPIV3Schema:
          type: object
          properties:
            spec:
              type: object
              properties:
                destination:
                  type: string
~~~

This fragment demonstrates only a minimal schema. A production API should define validation, required fields, defaults, status subresource behavior, and appropriate RBAC. The schema is part of the contract clients rely on.

## Versioning and lifecycle

- A **served version** is accepted and returned by the API.
- The **storage version** is used to persist objects in etcd; plan migrations when changing it.
- A conversion webhook may be needed to translate between incompatible versions.
- Choose namespaced or cluster scope before publishing the type.
- Understand pruning and unknown fields so data is not silently discarded.
- Coordinate CRD upgrades, controller upgrades, and backups.

A CRD without a controller stores declarative data; it does not perform the requested operation by itself.

## Exercise

Design a Backup custom resource with a destination, retention policy, and schedule. List which fields need validation, which information belongs in status, which Secret references are allowed, and what happens when v1 is retired.

## Quiz

1. Who validates and stores a custom resource? — The API server, using the installed CRD schema and API behavior.
2. Does a CRD alone manage the cluster? — No. A controller is needed to implement reconciliation behavior.
3. Why does storage version matter? — It is the version used to store objects in etcd.
4. What can deleting a CRD do? — It removes the API type and can make its custom resources unavailable or delete them; plan migration and backup before removal.
5. What is a conversion webhook for? — Converting objects between API versions when schemas differ.

## References

- [Custom resource concepts](https://kubernetes.io/docs/concepts/extend-kubernetes/api-extension/custom-resources/)
- [Creating a CRD](https://kubernetes.io/docs/tasks/extend-kubernetes/custom-resources/custom-resource-definitions/)
- [Kubernetes API concepts and versioning](https://kubernetes.io/docs/reference/using-api/api-concepts/)
- [Kubebuilder: CRD generation](https://book.kubebuilder.io/reference/generating-crd.html)
- [Chapter bibliography](../../../references/README.en.md#14-advanced-topics-and-extensibility)

</div>
