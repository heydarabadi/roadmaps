# MongoDB Auditing and Security Logs

> **Persian edition:** [Read this lesson in Persian](../../../../fa/mongodb/06-security/audit-detail/README.md).

> **Learning goal:** Record the security events needed for investigation while protecting logs from becoming another data leak.

## What an audit trail is for

An audit trail helps answer who authenticated, which sensitive administrative action occurred, and when it happened. It supports investigations and compliance evidence, but it is not a substitute for application telemetry, access reviews, or intrusion prevention. Audit functionality and configuration are product/edition dependent.

## Define events and retention

Choose the event categories that matter: authentication and authorization outcomes, user/role changes, configuration changes, access to sensitive data, and administrative actions. Define retention, access control, integrity protection, alerting, and who can investigate. Collect only what is necessary and avoid storing passwords, tokens, raw secret fields, or unnecessary personal data.

## Logs need operational protection

Restrict who can read or change audit logs. Forward them to a protected centralized system where appropriate. Monitor ingestion gaps, clock synchronization, storage capacity, and changes to audit configuration. A disabled or full audit destination may leave an investigation incomplete.

## Incident-response exercise

Imagine a service account suddenly receives a broader role. Write a timeline query and list which events would help reconstruct the change: authentication, user/role modification, source address, actor identity, and approval record. Then state what the log cannot prove by itself.

## Common mistakes

- Enabling broad logging without a retention or review plan.
- Logging sensitive data or credentials in event payloads.
- Letting the same administrator alter both database roles and the only audit copy.
- Ignoring missing events or clock drift.
- Assuming audit logs identify every action performed inside an application.

## Quiz and answer key

1. **What question does an audit log help answer?** Who performed a security-relevant action and when.
2. **Does auditing prevent unauthorized access?** No. It records selected events; prevention needs access and network controls.
3. **Why define retention?** To keep required evidence available while controlling privacy, storage, and exposure.
4. **Why avoid unlimited unfiltered logging?** Logs can expose sensitive data, create high storage cost, and make useful events difficult to find.
5. **Applied task: investigate a suspicious role change.** Correlate authentication, role/user change events, source, timestamp, actor, and a separate approval record.
6. **What should never be casually logged?** Passwords, tokens, encryption keys, and unnecessary sensitive payloads.
7. **Why centralize protected logs?** It can make investigation easier and reduce the risk that the same compromised host deletes all evidence.
8. **What operational signals matter for an audit pipeline?** Ingestion gaps, retention, capacity, time synchronization, and configuration changes.
9. **Can an audit log prove intent?** No. It records events and context, not the person's intent.
10. **Why review edition requirements?** Audit capabilities and setup vary by product and deployment.

## Further reading

- [MongoDB Auditing](https://www.mongodb.com/docs/manual/core/auditing/)
- [Configure Auditing](https://www.mongodb.com/docs/manual/tutorial/configure-auditing/)
- [Audit Events](https://www.mongodb.com/docs/manual/reference/audit-events/)
- [Atlas Auditing](https://www.mongodb.com/docs/atlas/database-auditing/)
- [MongoDB Security](https://www.mongodb.com/docs/manual/security/)
- [Persian MongoDB security series — Urhoba](https://www.urhoba.net/fa/series/mongodb-rehberi)
- [Curated reference library: audit and encryption](../../reference-library.md#security-encryption)

---
Sources reviewed: 2026-11-11. Confirm whether auditing is supported for the deployment and edition.
