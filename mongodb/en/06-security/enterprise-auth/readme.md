# Enterprise Authentication: X.509, Kerberos, and LDAP

> **Persian edition:** [Read this lesson in Persian](../../../06-security/enterprise-auth/readme.md).

> **Learning goal:** Compare enterprise identity mechanisms and plan around MongoDB's current LDAP deprecation.

## Start with identity operations

Choose an authentication mechanism that fits the organization's identity provider, certificate lifecycle, network trust, deployment edition, and operational expertise. Authentication does not itself define database permissions; map the authenticated identity to narrow MongoDB roles.

## SCRAM

SCRAM is a password-based challenge-response mechanism commonly used for application and database users. Protect passwords, rotate them safely, and avoid embedding them in code. It is often the simplest mechanism where directory or certificate integration is not required.

## X.509 certificates

X.509 authenticates a client using a certificate signed by a trusted certificate authority. Define certificate issuance, expiration, renewal, revocation, and subject-to-user mapping. A certificate that expires unexpectedly can disrupt every dependent service, so monitor lifecycle well before the expiration date.

## Kerberos

Kerberos can provide centralized enterprise authentication using tickets and service principals. MongoDB support and configuration depend on the deployment and Enterprise features. Plan DNS/service-principal naming, ticket refresh, clock synchronization, and role mapping with the identity team.

## LDAP deprecation

MongoDB documents LDAP authentication and authorization as deprecated starting with MongoDB 8.0 and states it will be removed in a future major release. Existing LDAP configurations may continue within the supported version lifetime, but a new long-lived dependency should account for migration. Evaluate supported alternatives, validate identity and group-to-role mapping, and test the exact Atlas or self-managed deployment before upgrading.

## Migration checklist

1. Inventory LDAP users, groups, role mappings, and applications.
2. Identify a supported replacement mechanism for the deployment.
3. Map groups to least-privilege MongoDB roles.
4. Run parallel authentication tests in a non-production environment.
5. Rotate credentials/certificates and update connection configuration safely.
6. Monitor authentication failures and remove the old mechanism after validation.

## Exercise

For a service with 30 engineers, a batch job, and two production applications, compare SCRAM, X.509, and Kerberos. State who issues credentials, how rotation occurs, and which roles each identity receives.

## Common mistakes

- Assuming an authentication mechanism grants appropriate database roles automatically.
- Letting a certificate expire without alerting or a renewal test.
- Copying an Enterprise-only configuration to another edition without checking availability.
- Starting a new LDAP dependency without a removal/upgrade plan.
- Treating identity-provider groups as a substitute for least-privilege role design.

## Quiz and answer key

1. **What does SCRAM use?** Username/password challenge-response authentication.
2. **What does X.509 use?** A trusted client certificate.
3. **What does Kerberos integrate with?** A ticket-based centralized authentication service.
4. **Why plan LDAP migration?** LDAP authentication and authorization are deprecated beginning in MongoDB 8.0 and are scheduled for removal in a future major release.
5. **Applied task: design enterprise authentication.** Choose a mechanism supported by the deployment, map identities to roles, and document credential issuance, rotation, and recovery.
6. **Does authentication automatically grant a database role?** Not necessarily; authorization mapping is a separate design.
7. **What certificate lifecycle events should be monitored?** Issuance, expiration, renewal, revocation, and mapping changes.
8. **Why test identity-group mapping?** Incorrect mapping can overgrant or lock out users.
9. **What should be inventoried before an LDAP migration?** Users, groups, role mappings, clients, and connection configuration.
10. **Why verify feature availability first?** Mechanisms vary by server version, deployment, and product edition.

## Further reading

- [Authentication mechanisms](https://www.mongodb.com/docs/manual/core/authentication-mechanisms/)
- [X.509 Client Certificate Authentication](https://www.mongodb.com/docs/manual/core/security-x.509/)
- [Kerberos Authentication](https://www.mongodb.com/docs/manual/core/kerberos/)
- [LDAP Authentication](https://www.mongodb.com/docs/manual/core/security-ldap/)
- [LDAP Deprecation](https://www.mongodb.com/docs/manual/core/security-ldap-external/)
- [Atlas LDAP setup and deprecation notice](https://www.mongodb.com/docs/atlas/security-ldaps/)
- [Authentication in Persian — Urhoba](https://www.urhoba.net/fa/post/mongodb-2)
- [Curated reference library: enterprise auth](../../reference-library.md#security-auth)

---
Sources reviewed: 2026-11-11. Validate supported mechanisms for the exact deployment before migration.
