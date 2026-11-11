# Security Patterns

[فارسی](../../../10-reliability-security/31-security-patterns/README.md)

## Learning goals

- Identify assets, actors, trust boundaries, and likely abuse paths.
- Distinguish authentication from authorization.
- Apply federated identity, gatekeeper controls, and restricted object access.
- Use least privilege, audit, and privacy-aware telemetry.

## Central idea

Secure architecture uses verifiable identity, least privilege, and explicit boundaries. A gateway does not replace authorization inside the service that owns the resource.

## Concept map

Asset and threat → identity → authorization and validation → boundary controls → audit and response.

## Detailed lesson

### Build a threat model from boundaries

List assets such as money, personal information, files, user accounts, API keys, and service availability. Consider valid users, anonymous attackers, compromised accounts, internal services, and operators.

Mark data and trust flows on the architecture. For each endpoint, ask who can call it, which resource they can act on, what input is accepted, what rate and size are allowed, which credential is used, what is returned and logged, and what happens when identity services fail.

### Federated identity

Federation delegates authentication to a trusted identity provider. It can simplify single sign-on and identity lifecycle. OpenID Connect adds an authentication layer on OAuth 2.0; SAML is common in enterprise systems.

Validate token issuer, audience, expiry, signature, and required claims. Access tokens should have a defined audience and short lifetime. Refresh tokens need secure storage and rotation policies.

A valid token proves identity or delegated claims; it does not grant every operation on every resource. The service must still authorize the request.

### Gatekeeper and boundary controls

A gatekeeper or API gateway can terminate TLS, perform initial authentication, validate schemas, limit request size, rate-limit, and emit audit events.

The owning service should still enforce domain authorization. A gateway can be bypassed, misroute traffic, or pass the wrong service identity. Normalize and allowlist inputs. Keep administrative and internal routes out of public gateway rules.

### Valet key and direct file access

A signed URL or short-lived token lets a client read or write a specific object directly in storage without proxying large bytes through the application.

Limit the URL to one object and one operation. Set expiration and size/content constraints; verify owner and content after upload. Keep private objects under a private cache policy.

A signed URL is a credential. Do not expose it in logs, analytics, referrers, or chat.

### Least privilege and workload identity

Each user and service should have only the permissions required and only for the necessary period. Avoid one static shared secret for every service. Short-lived workload identity, rotation, and environment/service-specific scope reduce the impact of compromise.

Do not assume an internal network is trusted. Authenticate and authorize service-to-service traffic. Define identity-provider failure behavior; fail-open can grant unintended access.

### Audit, data, and incident response

Record role changes, access to sensitive data, signed URL creation, and financial actions with actor, time, target, correlation ID, and outcome.

Do not log secrets or sensitive payloads. Keep audit data tamper-resistant, clocks synchronized, and retention defined. Security alerts need an owner and runbook. Incident responders should be able to revoke tokens or credentials and rotate keys.

### Threat-review checklist

For each endpoint, document caller identity, target resource, request size/rate, credential source, returned data, logged fields, and behavior during timeout or identity-provider failure.

Include allowed and denied cases: owner, another user, expired token, wrong scope, duplicate request, and oversized payload.

## Worked example

A client uploads an image using a signed URL limited to PUT for five minutes. The application verifies ownership, content type, and size after upload. It issues a separate short-lived read URL only to an authorized order owner.

## Design choices

| Choice | A good fit when | Risk to watch |
| --- | --- | --- |
| Federated identity | SSO and centralized identity lifecycle are needed | Token validation and downstream authorization remain |
| Gateway controls | Shared ingress policy and rate limits help | Service-level checks can be missed if the gateway is treated as the only boundary |
| Signed URL | Large objects can move directly to storage | URL leakage or broad scope exposes data |
| Short-lived workload credentials | Automated services need access without static shared secrets | Rotation and identity-provider availability need design |

## Common pitfalls

- Authentication at the gateway without resource-level authorization.
- Signed URLs with broad permissions or long expiry.
- Shared static secrets across services.
- Treating the internal network as trusted by default.
- Missing audit events for administrative or financial actions.
- Failing open when identity validation is unavailable.

## Short quiz

1. How do authentication and authorization differ?
2. What scope and expiry should a signed URL have?
3. Why should an internal service also authorize access?
4. What fields make an audit record useful?

### Answer key

1. Authentication establishes who/what is making the request; authorization decides which action on which resource is permitted.
2. One resource and operation, the narrowest scope, and a short expiration.
3. Internal networks can be compromised or misrouted; each owner must protect its own resources.
4. Actor, time, target, action/result, and correlation context without logging secrets.

## Exercise

Threat-model the store’s order and file-upload APIs. List assets and trust boundaries; define identity, authorization, size/rate limits, signed-URL scope and expiry, audit events, secret rotation, and behavior if the identity provider fails.

## Summary

Security patterns establish identity and constrain actions at every boundary. Federate authentication where useful, authorize at the resource owner, restrict credentials, and make security events auditable.

## Further reading

- [OWASP API Security Top 10](https://api-security.owasp.org/) — API-specific security risks.
- [OWASP Application Security Verification Standard](https://owasp.org/www-project-application-security-verification-standard/) — verification requirements for application security.
- [OpenID Foundation: Specifications](https://openid.net/developers/specs/) — OpenID Connect Core and related standards.
- [NIST SP 800-207: Zero Trust Architecture](https://csrc.nist.gov/pubs/sp/800/207/final) — trust boundaries and continuous authorization.
- [AWS Well-Architected: Grant least privilege](https://docs.aws.amazon.com/wellarchitected/latest/framework/sec_permissions_least_privileges.html) — least-privilege access.
- [OWASP Secrets Management Cheat Sheet](https://cheatsheetseries.owasp.org/cheatsheets/Secrets_Management_Cheat_Sheet.html) — secret storage and rotation.
