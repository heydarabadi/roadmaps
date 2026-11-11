<div dir="ltr" align="left">

# Authentication and Authorization

**Language:** [فارسی](README.md) | **English**

**Learning objective:** Distinguish “Who are you?” from “What may you do to which resource?”, then manage the cost of these controls without losing correctness or revocation. **Reference review: 2026-11-11.** Examples are conceptual and were not run.

## Definition and decision path

Authentication validates a claimed identity. Authorization decides whether that identity may perform an operation on a particular resource in a particular context. Quota is separate: a user can be authorized and still have exhausted their usage allowance. A successful login or a valid JWT does not grant permission to read every customer’s order.

| Question | Trusted input needed | Example rejection |
| --- | --- | --- |
| What is the identity? | A valid session or validated token | Expired session or invalid signature |
| Is this operation allowed? | Subject, tenant, action, object, and policy | User A trying to access Order B |
| Is this amount of use allowed? | Verified identity and a quota counter | Export beyond its budget |

For each request, build identity context from a trusted mechanism, identify the object and operation, evaluate policy with a deny-by-default posture, and then read only permitted data. File endpoints, alternate routes, and workers need the same rules. [OWASP Authorization Cheat Sheet](https://cheatsheetseries.owasp.org/cheatsheets/Authorization_Cheat_Sheet.html) recommends checking authorization on every request and applying least privilege. An ID in a URL is not itself a vulnerability; failing to check access is.

Use these terms to follow the flow: a **principal** is the entity making the request; a **credential** is evidence offered to prove identity; a **claim** is a statement about identity or context in a credential; a **resource/object** is the thing to read or change; and a **policy** is a rule that evaluates principal, operation, object, and context. Roles and scopes express parts of a policy; neither proves ownership of a particular object on its own.

### Decision path for one request

1. **Validate the credential.** If a session is expired or a token fails signature, issuer, audience, or time validation, there is no verified principal and the user operation stops.
2. **Build trusted context.** Obtain tenant membership from a source the server has verified. A user-supplied header may request a context; it is not proof of membership.
3. **Identify the operation and object.** `order:read` on Order 81 is not the same authorization decision as that operation on Order 82. Checking only the route may be insufficient.
4. **Evaluate policy with deny-by-default.** If required data is unknown or the policy service is unavailable, do not turn “unknown” into “allow”; stop the operation in a controlled way.
5. **Read data with authorization constraints.** A tenant/ownership condition in the query or domain layer is defense in depth against mistakes; it does not replace explicit policy or checking every path.
6. **Record a low-disclosure outcome.** Authentication and policy duration, decision, and policy version can be useful. Do not log tokens, passwords, or entire orders.

| State | Identity | Authorization | Conceptual behavior |
| --- | --- | --- | --- |
| Invalid or expired credential | Invalid | Not evaluated | Stop the request |
| Valid credential, correct owner and tenant | Valid | Allowed | Return only required fields |
| Valid credential, order belongs to someone else | Valid | Denied | Do not read or disclose the data |
| Role revoked while the token remains valid | May be valid | Deny according to current policy | Revocation and role-version behavior matter |
| Identity or policy is uncertain | Unknown | Unknown | Fail safely; do not allow by default |

Choose an access-denied response that fits the API contract and the need to avoid revealing whether a resource exists. You may return the same outward response for a nonexistent and an inaccessible object; that changes the message visible to the caller, not the need to record a safe internal reason.

## When to use it and the security/latency trade-off

Password authentication should use a suitable library and password-hashing method with a cost that is deliberately configured. Reducing the cost or removing MFA only to make login faster changes the security contract. Login needs bounded capacity, brute-force protections, and responses that do not reveal whether an account exists. The [OWASP Authentication Cheat Sheet](https://cheatsheetseries.owasp.org/cheatsheets/Authentication_Cheat_Sheet.html) covers sessions, error responses, and reauthentication for sensitive actions.

Local validation of a signed token can avoid a network round trip, but a trusted library still needs to validate signature, issuer, audience, expiry, token type, required claims for the consuming profile, and the accepted algorithm policy. Token lifetime and revocation are a contract: local validation does not provide immediate revocation by itself. An untrusted issuer identifier or key URL must not choose an arbitrary network destination. Trusted keys come from trusted configuration; key refresh should be bounded and observable.

An authorization-decision cache is safe only when its key, freshness, and invalidation are understood. Possible key dimensions include subject, tenant, action, object, and policy version. Omitting a dimension can reuse another user’s or object’s allowed decision. Every request still has to pass the authorization control; caching changes how a valid decision is obtained. Ownership or role changes must fit the revocation budget. Failure of the identity or policy dependency must not default to granting access; a controlled failure is different from bypassing authorization.

## Worked example, independent of language

Assumption: a customer may view their own order in the active tenant. The tenant comes from a trusted membership context, not solely from a user-selected header. The SQL below is one part of a simple ownership policy, not a replacement for complex real-world policies.

<div dir="ltr" align="left">

```text
principal = trusted_authenticator.validate(request.credentials)
context = resolve_verified_membership(principal, requested_tenant)
authorize_route(principal, context, action = "order:read")
order = database.query_one(
  "SELECT id, total FROM orders " +
  "WHERE id = ? AND tenant_id = ? AND customer_id = ?",
  [request.order_id, context.tenant_id, principal.customer_id]
)
if order is absent:
    return uniform_resource_unavailable_response()
return order
```

</div>

A support employee who is allowed to view several customers needs an explicit policy for that case; removing the ownership condition for everyone is not a solution. Never log a token or secret. Record the decision, policy version, and an appropriate correlation ID with the minimum required data. A denial message must not fetch and disclose private fields from the object.

## Exercise and expected observation

Draw a decision table for customers A and B, two orders, and two tenants. Walk through six cases: expired token, correct owner, wrong owner, wrong tenant, revoked role, and the endpoint that downloads an order receipt. Expected result: only an authorized combination passes, and both the JSON and file paths enforce the check. Then analyze an authorization cache keyed only by `role`: why is one order’s allowed decision not trustworthy for another order? This is a reasoning exercise, not a test run against a system.

**Worked solution:** Make columns for “valid identity?”, “valid tenant?”, “authorized owner/role?”, “JSON or file path?”, and “decision.” An expired token is denied in the first column; User A accessing User B’s order is denied at ownership; a revoked membership is denied under current policy even if the token remains valid. The file path must check the same object; changing the output format does not make the order public. A cache keyed only by role does not know which tenant or order was checked, so its decision cannot safely be reused.

## Public evidence and its limits

[OWASP API1:2023 — Broken Object Level Authorization](https://api-security.owasp.org/editions/2023/en/0xa1-broken-object-level-authorization/) documents object-access scenarios and the need to check access to the resource. It is a classification and practical guide, not a company incident report or a latency benchmark. This lesson does not provide a public study measuring authentication optimization for the hypothetical example; the store and its numbers are illustrative. UUIDs or obscure identifiers do not replace authorization.

## Failure modes, signals, and checklist

Trusting a role in an unverified payload, omitting a tenant check, caching without invalidation, exposing a private file through a public download route, and using a default-allow policy are dangerous failures. Observe authentication and authorization duration, identity-dependency errors, denial rates by route, and role-change events. A high denial rate is not necessarily an attack; it can also indicate bad configuration. Avoid unbounded-cardinality metric labels containing raw tokens or IDs.

- [ ] Identity is validated with a trusted library and explicit trust configuration.
- [ ] Object/action/tenant authorization is enforced on all paths with deny-by-default.
- [ ] Session lifetime, token expiry, revocation, and key rotation have owners and contracts.
- [ ] Authorization-decision caching has a complete key and invalidation budget; every request remains controlled.
- [ ] Login and sensitive operations have appropriate abuse controls and reauthentication.
- [ ] Identity or policy outages do not grant access without authorization.
- [ ] Logs and errors do not expose secrets or private resource data.

## Self-check

1. Why is a valid token not enough to read every order?
2. Does a UUID remove the need for object authorization?
3. What is wrong with an authorization cache keyed only by `role`?
4. Which problem does local token validation not solve by itself?
5. What happens if a policy-service outage defaults to allow?
6. Why should authentication latency be recorded separately?

### Answer key with reasoning

1. Authentication identifies the caller; authorization must check that identity’s relationship to this object and operation.
2. No. Hard-to-guess IDs do not grant permission, and an ID may become known through another path.
3. It mixes tenant, object, action, and context and may reuse an allowed result for a different request.
4. Immediate revocation and role/ownership changes; token lifetime and freshness need explicit design.
5. It turns an outage into a control bypass. Use a controlled failure and deny uncertain access.
6. To identify the cost of signing, network calls, or policy evaluation and fix the actual contributor; endpoint averages do not explain the cause.

## Optional references

- English: [OWASP Authentication Cheat Sheet](https://cheatsheetseries.owasp.org/cheatsheets/Authentication_Cheat_Sheet.html) and [Authorization Cheat Sheet](https://cheatsheetseries.owasp.org/cheatsheets/Authorization_Cheat_Sheet.html) — separate responsibilities, deny-by-default, and reauthentication.
- English: [OWASP API1:2023](https://api-security.owasp.org/editions/2023/en/0xa1-broken-object-level-authorization/) — object-level authorization.
- English: [OWASP Web Security Testing Guide — BOLA/API object authorization](https://wstg.owasp.org/latest/4-Web_Application_Security_Testing/12-API_Testing/02-API_Broken_Object_Level_Authorization/) — testing object substitution across accounts or tenants; a test guide does not prove complete coverage.
- English: [OWASP Session Management Cheat Sheet](https://cheatsheetseries.owasp.org/cheatsheets/Session_Management_Cheat_Sheet.html) — session creation, lifetime, revocation, and protection.
- English: [RFC 7519 — JSON Web Token](https://www.rfc-editor.org/rfc/rfc7519.html) — JWT format and registered claims; the format does not define authorization logic.
- English, additional: [OWASP JWT Cheat Sheet](https://cheatsheetseries.owasp.org/cheatsheets/JSON_Web_Token_Cheat_Sheet.html) — validation, issuer/audience, lifetime, and revocation considerations; JWT alone does not create authorization or a secure session.
- Persian: [Persian API Security Checklist](https://github.com/shieldfy/API-Security-Checklist/blob/master/README-fa.md) — a reminder of authentication and access-control categories. It is a general checklist with simplifications; do not treat UUIDs or URL changes as authorization, and compare security details with the official references above.

[Chapter index](../README.en.md) · [Course index](../../README.en.md) · [Previous: Dependency hygiene](../01-dependency-hygiene/README.en.md) · [Next: Rate limiting](../03-throttling-and-rate-limiting/README.en.md) · [Caching and invalidation](../../01-caching/04-invalidation-and-freshness/README.en.md)

</div>
