# MongoDB Security in Layers

> **Persian edition:** [Read this lesson in Persian](../../../../fa/mongodb/06-security/security/README.md).

> **Learning goal:** Combine identity, permissions, network controls, encryption, auditing, and recovery rather than relying on one safeguard.

## Start with a threat model

List the assets (customer data, credentials, backups, encryption keys), likely threats, and trust boundaries. Examples include a leaked application URI, a compromised host, an over-privileged employee, network interception, accidental deletion, or an exposed backup. Select controls that address those threats and record their limits.

## Layer 1: identity and permissions

Enable authentication and use unique identities for services, people, and automation. Give each identity only the roles and database actions it needs. An application user should not be an administrator. Review and rotate credentials, and remove access when it is no longer needed.

## Layer 2: network and transport

Restrict which clients can reach the deployment. Use private connectivity or narrow network rules when available. Keep TLS certificate validation enabled; transport encryption protects data in transit but does not stop an authorized user from querying data.

## Layer 3: stored data and secrets

Protect storage and backups with at-rest encryption. Store database credentials and encryption keys in a managed secret/key service, separately from source code and the encrypted data. If field-level encryption is needed, identify which operators and search patterns the application requires before selecting a scheme.

## Layer 4: observe and recover

Audit or log security-relevant events with a retention policy. Exclude passwords, tokens, and unnecessary personal data. Alert on suspicious authentication, role changes, configuration changes, and backup failures. Maintain and test an independent restore path.

## Practical access matrix

| Identity | Typical permission boundary |
|---|---|
| Web application | Read/write only its required application collections. |
| Analytics job | Read-only access to approved datasets. |
| Backup process | Backup-specific permissions and isolated credentials. |
| Operator | Named human account, scoped administrative role, and monitored access. |

Exact roles depend on deployment and product edition. Build least privilege from required actions rather than granting a broad built-in role for convenience.

## Exercise

Create an access matrix for the application, analyst, backup job, and operator. For each identity, name its allowed databases, actions, credential storage, network path, and review date.

## Common mistakes

- Leaving authentication disabled on a reachable deployment.
- Sharing an administrator account across services.
- Treating a firewall or TLS as a replacement for RBAC.
- Keeping secrets in Git, logs, or an unencrypted backup.
- Logging sensitive payloads without retention and access controls.

## Quiz and answer key

1. **Why use a threat model?** It ties each security control to assets, threats, and trust boundaries.
2. **What does least privilege mean?** Grant each identity only the actions and data it requires.
3. **What does TLS protect?** Data in transit between client and server.
4. **Why not connect an application with an admin account?** A leaked credential can affect the entire deployment; scope the app role to its collections and actions.
5. **Applied task: build an identity matrix.** Define separate application, analytics, backup, and operator identities with scoped permissions and protected credentials.
6. **Does encryption at rest replace authorization?** No. It protects storage media; it does not decide which authenticated users may query data.
7. **Where should secrets be kept?** In a protected secret manager or equivalent, outside source code and logs.
8. **What security events may need alerts?** Unusual authentication, role changes, configuration changes, and backup failures.
9. **Why are backup controls part of security?** Backups contain sensitive data and may provide broad access if exposed.
10. **How do you prove recovery controls work?** Restore into an isolated environment and verify data, access, and recovery objectives.

## Further reading

- [MongoDB Security](https://www.mongodb.com/docs/manual/security/)
- [Authentication](https://www.mongodb.com/docs/manual/core/authentication/)
- [Role-Based Access Control](https://www.mongodb.com/docs/manual/core/authorization/)
- [TLS/SSL Transport Encryption](https://www.mongodb.com/docs/manual/core/security-transport-encryption/)
- [MongoDB auditing](https://www.mongodb.com/docs/manual/core/auditing/)
- [Persian MongoDB security series — Urhoba](https://www.urhoba.net/fa/series/mongodb-rehberi)
- [Curated reference library: security](../../reference-library.md#security-auth)

---
Sources reviewed: 2026-11-11. Available security controls differ by product and edition.
