# Authentication and Role-Based Access Control

> **Persian edition:** [Read this lesson in Persian](../../../../fa/mongodb/06-security/authentication-rbac/README.md).

> **Learning goal:** Verify identity separately from authorization and assign the minimum permissions required by each actor.

## Authentication versus authorization

**Authentication** answers “Who is connecting?” **Authorization** answers “What may that identity do?” A valid username or certificate does not automatically imply broad permission. Configure both deliberately and review the effective role mappings.

## Database users and roles

Create named users on the appropriate authentication database and assign built-in or custom roles with narrow scope. A service account usually needs access only to the databases and actions required by that service. Human operators should use named accounts and their own administrative path. Keep backup, monitoring, migration, and application identities separate.

~~~javascript
// Run only in a controlled administrative session and adapt role/database names.
use shop
db.createUser({
  user: "shop-app",
  pwd: passwordPrompt(),
  roles: [{ role: "readWrite", db: "shop" }]
})
~~~

Avoid hard-coding credentials in scripts. `passwordPrompt()` is a shell helper; application services should read credentials from a secret manager or protected runtime configuration.

## Principle of least privilege

1. List the application's required collections and commands.
2. Start with the smallest built-in role that fits.
3. Create a custom role only when built-in roles are too broad or insufficient.
4. Test normal flows and expected denied operations.
5. Review role assignments regularly and after service changes.

Do not use the root or cluster-administration role for routine application traffic. Broad shared accounts make audits weaker and increase damage from credential exposure.

## Authentication mechanisms

SCRAM is a common username/password mechanism. X.509 uses client certificates. Kerberos integrates with a Kerberos service in supported Enterprise deployments. LDAP can integrate directory identity and role mapping, but MongoDB 8.0 deprecates LDAP authentication and authorization; MongoDB says it will be removed in a future major release. Verify current deployment support and plan a migration rather than starting a new LDAP dependency.

## Exercise

Create an access matrix for `shop-app`, a read-only analyst, the backup process, and a human operator. Name a role, database scope, credential source, and rotation/review process for each.

## Common mistakes

- Confusing authentication with authorization.
- Reusing the same administrator login in every application.
- Granting `readWriteAnyDatabase` to a service that uses one database.
- Storing passwords in scripts or Git.
- Ignoring LDAP's deprecation when planning future upgrades.

## Quiz and answer key

1. **What does authentication establish?** The identity of the connecting user or service.
2. **What does authorization decide?** Which resources and actions that identity may use.
3. **What is least privilege?** The minimum role scope required for the job.
4. **Why avoid an app connection with root/admin?** A compromised app credential could administer the deployment; use a scoped service account.
5. **Applied task: design application roles.** Separate app, analyst, backup, and operator identities and scope each to only required databases/actions.
6. **What is SCRAM commonly used for?** Username/password authentication.
7. **What does X.509 use?** Certificates for client identity.
8. **What is the LDAP status starting in MongoDB 8.0?** Deprecated and scheduled for removal in a future major release.
9. **Why separate backup credentials?** Limit what a compromised application account or backup job can expose or change.
10. **How do you test least privilege?** Verify required actions succeed and unnecessary actions are denied.

## Further reading

- [Authentication](https://www.mongodb.com/docs/manual/core/authentication/)
- [Role-Based Access Control](https://www.mongodb.com/docs/manual/core/authorization/)
- [Built-in Roles](https://www.mongodb.com/docs/manual/reference/built-in-roles/)
- [Create a User](https://www.mongodb.com/docs/manual/tutorial/create-users/)
- [LDAP Deprecation](https://www.mongodb.com/docs/manual/core/security-ldap-external/)
- [Authentication in Persian — Urhoba](https://www.urhoba.net/fa/post/mongodb-2)
- [Curated reference library: authentication and roles](../../reference-library.md#security-auth)

---
Sources reviewed: 2026-11-11. Mechanism availability depends on server, edition, and deployment.
