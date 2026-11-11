# Threat Modeling, OWASP, and Secure Design

## Learning goals

- Identify assets, trust boundaries, actors, and abuse cases.
- Use threat modeling to connect risk with controls, owners, and tests.
- Place OWASP materials in the context of a system-specific security program.

Start security work with assets, trust boundaries, and likely abuse. A vulnerability checklist is not a substitute for understanding the product. STRIDE or another threat-modeling method helps teams record threats, controls, owners, and test evidence. OWASP Top 10 raises awareness of common web risks; OWASP API Security focuses on API risks. Neither certifies that a product is secure.

For an online store, assets include customer accounts, addresses, payments, cart credit, and API keys. Important trust boundaries run from browser to gateway, order service, payment provider, and staff access. Threats can include session theft, IDOR, injection, callback replay, log leakage, and abuse of administrator access.

Controls include least privilege, validation, TLS, secret management, network segmentation, audit logs, patching, tested backups, and incident response. Connect each control to a test or telemetry and record accepted exceptions.

| Goal | Example control | Evidence |
| --- | --- | --- |
| Prevent unauthorized access | Authorization for every resource/action | Negative test |
| Reduce credential damage | Secret manager and rotation | Configuration review |
| Detect attacks | Structured logs and meaningful alerts | Incident exercise |
| Recover | Backups and restore drills | Measured recovery result |

## Step-by-step threat modeling

1. **Scope the system and goal.** Draw data flows for clients, APIs, services, databases, payment providers, queues, and administrators. Mark trust boundaries.
2. **List assets and harm.** Separate personal data, credentials, credit/inventory, order availability, and the ability to change price. State the harm from each abuse.
3. **Imagine actors and misuse.** Consider normal users, employees, partner services, anonymous attackers, and compromised accounts. Ask what they might read, alter, forge, or disable.
4. **Use STRIDE as a prompt:** Spoofing identity; Tampering with data or requests; Repudiation due to missing trustworthy evidence; Information Disclosure; Denial of Service; Elevation of Privilege. Not every category applies to every flow.
5. **Prioritize risk.** Record likelihood, impact, exposure, and existing controls. Risk scores help compare transparently; they are not objective truth.
6. **Link controls and tests to threats.** For IDOR, test two tenants; for replay, submit the same callback twice; for log leakage, scan for tokens; for DoS, test rate limits under controlled load.
7. **Assign owner and review date.** Record residual risk, action, and review trigger. Risk acceptance should be explicit and reviewable.

## Worked example: viewing an order

**Capability:** a customer sees only their own orders. **Abuse:** a user changes orderId and reads another customer’s order. **Weak boundary:** hiding the ID or button in the UI. **Control:** scope the server query by authenticated user or tenant and authorize every resource. **Test:** user A requests order B; no sensitive data appears in body, headers, or logs. **Evidence:** automated negative test, safe audit event, and alert for enumeration patterns.

## Security throughout the development lifecycle

- During design, review data flows, trust boundaries, and abuse cases.
- During implementation, use secure defaults, validation, per-action authorization, secret management, and dependency hygiene.
- During review, inspect code, deployment configuration, IAM, storage, and network rules.
- Before release, run risk-appropriate tests and patch dependencies; a clean scan does not prove the whole product secure.
- In operations, use limited structured logs, alerts, incident response, credential revocation, and practiced restore.

OWASP Top 10 summarizes common web categories for awareness. A product threat model derives misuse from the actual system and changes as the system changes. No public list covers every attack, misconfiguration, or business abuse.

## Self-check quiz

1. **What is OWASP Top 10 not?** It is not a complete threat model or proof of application security.
2. **Why is server-side authorization required?** Client controls can be bypassed; policy must be checked for each resource and action.
3. **What is defense in depth?** Multiple independent controls reduce the likelihood and impact of one control failing.
4. **What should a threat model produce?** Prioritized threats, controls, owners, tests, and explicit residual risks.
5. **Why include asset owners and evidence?** A mitigation without an owner or verification method may never be implemented or may silently fail.

## Exercise

For an endpoint that displays an order, write three abuse cases and define a control and test for each.

### Sample answer

Three cases are changing order ID to exploit IDOR, enumerating sequential IDs, and leaking PII in responses or logs. Scope server queries by owner/tenant, apply rate limiting and monitoring, and return only necessary data. Negative tests with two users/tenants and a log review should prove another user’s data is not exposed.

## Further reading

- Persian: [Software architecture fundamentals](https://www.alirostami.com/software-architecture/), [OWASP Top 10](https://owasp.org/www-project-top-ten/)
- English: [OWASP Top 10](https://owasp.org/www-project-top-ten/), [OWASP API Security Top 10](https://owasp.org/www-project-api-security/), [OWASP Cheat Sheet Series](https://cheatsheetseries.owasp.org/), [OWASP ASVS](https://owasp.org/www-project-application-security-verification-standard/), [OWASP Threat Modeling](https://owasp.org/www-community/Threat_Modeling), [NIST Cybersecurity Framework](https://www.nist.gov/cyberframework), [OWASP Web Service Security](https://cheatsheetseries.owasp.org/cheatsheets/Web_Service_Security_Cheat_Sheet.html)
