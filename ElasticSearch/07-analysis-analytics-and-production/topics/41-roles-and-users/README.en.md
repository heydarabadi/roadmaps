# Roles and Users

> Chapter 07: Analysis, Analytics, and Production · Lesson 41

[Read the Persian version](README.md)

## Learning goals

- Separate a user identity from the privileges assigned through roles.
- Grant only the cluster and index actions required by each workload.
- Test both allowed and denied operations.

## Least-privilege identities

A user represents a human or service identity. A role defines privileges and can be assigned to users. Index privileges can target specific index patterns; cluster privileges should be granted only when the application needs them. Field- and document-level restrictions can further narrow visibility where supported. Avoid giving an application the `superuser` role: a compromised service would then gain broad control over data and cluster operations.

~~~http
PUT /_security/role/catalog_reader
{"indices":[{"names":["products-*"],
  "privileges":["read","view_index_metadata"]}]}
~~~

Use separate identities for readers, indexers, administrators, and interactive operators. Store passwords and credentials in a secret manager, rotate them, and audit role changes. Test denied operations as carefully as allowed ones. The role name and privilege set above are examples; confirm required privileges for your APIs and deployment.

## Exercise

Create one read-only catalog role and one writer role limited to a lab index. Test search, index, delete, and cluster-management requests using each identity. Verify the least-privilege role rejects every unneeded operation.

## Quiz with answers

1. **What does a role define?** A set of privileges for cluster, index, or other supported access scopes.
2. **Why separate user and role?** Identities can receive reviewed privilege sets and have access changed without sharing credentials.
3. **Why is a superuser service account risky?** A compromised application could alter or delete far more data than necessary.
4. **How should a role be validated?** Test intended allowed operations and denied operations using the actual service identity.

## References and further reading

- [User roles](https://www.elastic.co/docs/deploy-manage/users-roles/cluster-or-deployment-auth/user-roles) — define and assign privileges.
- [Role management APIs](https://www.elastic.co/docs/api/doc/elasticsearch/group/endpoint-security) — create users and roles.
- [Built-in roles](https://www.elastic.co/docs/deploy-manage/users-roles/cluster-or-deployment-auth/built-in-roles) — available role patterns.
- [Field and document security](https://www.elastic.co/docs/deploy-manage/users-roles/cluster-or-deployment-auth/field-and-document-access-control) — constrain accessible data.
- [API keys](https://www.elastic.co/docs/deploy-manage/api-keys/elasticsearch-api-keys) — separate application credentials.
- Persian discovery search (not a verified article): [Persian Elasticsearch roles and users tutorials](https://www.google.com/search?q=Elasticsearch+roles+users+%D9%86%D9%82%D8%B4+%DA%A9%D8%A7%D8%B1%D8%A8%D8%B1+%D9%81%D8%A7%D8%B1%D8%B3%DB%8C).


## Curated bilingual reading map

- [Persian sources, courses, and examples](../../../references/README.md) · [English technical documentation and case studies](../../../references/README.en.md)

Google search links above are discovery shortcuts; they are not verified article citations.

