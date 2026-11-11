# TLS, Encryption at Rest, and Field-Level Encryption

> **Persian edition:** [Read this lesson in Persian](../../../06-security/encryption-detail/readme.md).

> **Learning goal:** Match network, storage, and field-level protections to a threat model and manage encryption keys safely.

## Three protection layers

1. **In transit:** TLS protects traffic between clients and servers. Validate certificates and hostnames; turning verification off removes an important protection.
2. **At rest:** encryption protects database files, storage volumes, and often backups. Available controls differ between Atlas and self-managed editions.
3. **In use / field level:** Client-Side Field Level Encryption (CSFLE) encrypts selected fields in the driver before they reach the database. Queryable Encryption supports certain searches on encrypted fields with its own requirements and trade-offs.

These controls do not replace RBAC, network restrictions, or key management. At-rest encryption alone does not stop an authorized database user from reading data. Client-side encryption can reduce what a database operator sees, but the application holding keys can decrypt data.

## CSFLE and Queryable Encryption

CSFLE can use deterministic or randomized encryption modes with different query capabilities and information leakage. Queryable Encryption supports defined query types, but not every MongoDB operator or aggregation. Review supported query shapes, driver versions, metadata leakage, and deployment requirements before choosing it. MongoDB documents that CSFLE and Queryable Encryption cannot be used together in the same collection.

Encrypt only fields justified by the threat model. First determine whether the application needs equality search, range search, sorting, or aggregation on the field. If it does not need the original value, tokenization or storing a reduced representation may be simpler.

## Key management

Keep key-encryption keys and data-encryption keys separate from application data and source code. Use a managed KMS or key vault, restrict key permissions, plan rotation and backup, and rehearse disaster recovery. Losing a required key may make the data unrecoverable; leaking it can defeat confidentiality.

## Exercise: sensitive identifier

For a sensitive identifier, list risks from network interception, stolen disk, an administrator with database access, and a leaked key. For each, choose a control and state what risk remains. Then list the query operations the application must perform on the encrypted value.

## Common mistakes

- Treating TLS and encryption at rest as the same control.
- Storing encryption keys beside ciphertext or in source code.
- Disabling certificate verification to work around TLS errors.
- Assuming every query works on an encrypted field.
- Combining CSFLE and Queryable Encryption in one collection.

## Quiz and answer key

1. **What does TLS protect?** Network traffic in transit.
2. **What does encryption at rest protect?** Stored database and backup media.
3. **Where does CSFLE encrypt selected values?** In the client/driver before data is sent to MongoDB.
4. **Why keep TLS separate from at-rest encryption?** They protect different threat boundaries; neither protects against every threat or replaces key controls.
5. **Applied task: protect a payment identifier.** State required searches, use field encryption only if compatible, manage keys externally, and retain least-privilege access.
6. **Does at-rest encryption replace RBAC?** No. RBAC controls authenticated access; storage encryption protects the underlying media.
7. **Why is key management critical?** Confidentiality depends on preventing key leakage, and recovery depends on retaining necessary keys.
8. **Can every operator be used on an encrypted field?** No. Supported operations depend on encryption mode and product/version.
9. **Can CSFLE and Queryable Encryption share a collection?** MongoDB's current documentation says they cannot be combined in the same collection.
10. **What should be decided before selecting field encryption?** The threat model and required query operations.

## Further reading

- [Data Encryption](https://www.mongodb.com/docs/manual/core/security-data-encryption/)
- [Encryption at Rest](https://www.mongodb.com/docs/manual/core/security-encryption-at-rest/)
- [TLS/SSL Transport Encryption](https://www.mongodb.com/docs/manual/core/security-transport-encryption/)
- [Client-Side Field Level Encryption](https://www.mongodb.com/docs/manual/core/csfle/)
- [Queryable Encryption](https://www.mongodb.com/docs/manual/core/queryable-encryption/)
- [Queryable Encryption Features and Limitations](https://www.mongodb.com/docs/manual/core/queryable-encryption/features/)
- [Atlas encryption guidance](https://www.mongodb.com/docs/atlas/architecture/current/data-encryption/)
- [Persian MongoDB security guide — Urhoba](https://www.urhoba.net/fa/post/mongodb-2)
- [Curated reference library: encryption](../../reference-library.md#security-encryption)

---
Sources reviewed: 2026-11-11. Encryption requirements and supported query types are version and edition dependent.
