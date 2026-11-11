# Authentication and Authorization

## Learning goals

- Distinguish authentication, authorization, sessions, and federation.
- Apply least privilege and server-side authorization to resources and actions.
- Select OAuth/OIDC flows with appropriate token and session protections.

Authentication asks, “Who are you?” Authorization asks, “May you perform this action on this resource?” Successful login does not grant access to every object. Enforce policy on the server for each resource and action, considering ownership, tenant, and business state.

A session uses a random identifier and retains state on the server. A bearer token grants use to whoever holds it, so theft is dangerous. OAuth 2.0 is delegated authorization; OpenID Connect adds identity on top. For browser and native clients, use Authorization Code with PKCE and a reputable library. Keep tokens short-lived and limit audience and scope.

## Example: a multi-tenant account

Derive tenant identity from authenticated claims and check the requested order against tenant and role policy. A UI filter is not a security control. Choose consistent 403/404 behavior and audit events; do not log sensitive information.

## Design login step by step

1. **Choose a method for users and threats.** Passwords, SSO, passkeys, and additional factors have different experience and recovery needs. Never store raw passwords; use suitable password hashing and controls against credential stuffing.
2. **Secure the session.** Use a random, revocable server-side session ID and rotate it after login or privilege changes. Set cookies with Secure, HttpOnly, and appropriate SameSite behavior; CSRF protection still depends on the architecture.
3. **Use a standard flow for third-party clients.** OAuth 2.0 defines delegated authorization; OIDC defines identity. Public clients should use Authorization Code with PKCE and exact redirect URIs. Do not default to obsolete flows. Integrate a trusted identity provider with a maintained library.
4. **Constrain tokens.** Validate expiry, audience, scope, and issuer. Keep access tokens short-lived; protect, rotate, and revoke refresh tokens where supported. A signed JWT is not necessarily encrypted; do not assume its claims are confidential.
5. **Design logout and compromise response.** Logout, password changes, device removal, and suspicious activity should revoke relevant sessions/tokens. Fully stateless tokens may remain usable until expiry; understand that revocation trade-off.

## Authorization: a role is not enough

RBAC is simple for stable roles such as customer, support, and admin. But “a user may edit only their own document in their own tenant while its status is open” depends on the resource and context; attribute-based policy may be needed. Decide access from subject, action, resource, context, ownership, tenant, domain state, and explicit allow/deny rules.

### Worked example: support staff and refunds

- **Identity:** support employee with MFA and an organization session.
- **View order:** only for an active ticket and an allowed tenant.
- **Refund:** separate permission, amount limit, valid payment state, and perhaps a second approval.
- **Audit:** actor, resource, action, outcome, and reason; never log tokens, passwords, or sensitive payment data.
- **Tests:** another customer, another tenant, a cancelled order, over-limit amount, and expired session are checked independently.

## Errors and privacy

401 means valid identity is not established; 403 means the identity exists but lacks permission. A consistent 404 can conceal whether a resource exists. Choose the behavior through the API contract and threat model. Error messages must not reveal which user owns an identifier.

## Design review checklist

- Is authorization checked for every endpoint and object?
- Is changing an ID, tenant, or role in the client ineffective?
- Is the cache partitioned by identity/tenant so private data cannot cross users?
- Is staff access minimal, time-bounded, and auditable?
- Can tokens, signed URLs, or sessions leak into logs or analytics?
- Is account recovery as secure as login? A weak recovery flow undermines the whole system.

## Self-check quiz

1. **How do OAuth and OIDC differ?** OAuth provides delegated access; OIDC adds an identity layer.
2. **Why is a JWT not always safer than a session?** A signature provides neither confidentiality nor easy revocation; storage, audience, and expiry matter.
3. **How do you mitigate IDOR?** Check authorization based on ownership or tenant for each object on the server.
4. **What is the risk of broad token scopes?** A stolen token has a larger impact.
5. **Why is a UI role check insufficient?** Attackers can call the server directly; the server must enforce the same policy.

## Exercise

Design support access that lets an employee view an authorized customer order but not issue a refund. Separate identity, policy, and audit.

### Sample answer

The employee signs in with organization identity and MFA. Viewing requires an active ticket, allowed tenant, and view scope; refund is a separate prohibited permission. The API evaluates policy server-side on every request. Audit records actor, resource, action, result, and reason without unnecessary PII, card data, or tokens.

## Further reading

- Persian: [OWASP project resources](https://owasp.org/www-project-top-ten/), [Software architecture fundamentals](https://www.alirostami.com/software-architecture/)
- English: [OWASP Authentication Cheat Sheet](https://cheatsheetseries.owasp.org/cheatsheets/Authentication_Cheat_Sheet.html), [OWASP OAuth 2.0 Cheat Sheet](https://cheatsheetseries.owasp.org/cheatsheets/OAuth2_Cheat_Sheet.html), [OAuth 2.0 Security BCP, RFC 9700](https://www.rfc-editor.org/rfc/rfc9700.html), [OWASP Authentication Patterns](https://cheatsheetseries.owasp.org/cheatsheets/Authentication_Patterns_Cheat_Sheet.html), [OWASP Session Management Cheat Sheet](https://cheatsheetseries.owasp.org/cheatsheets/Session_Management_Cheat_Sheet.html), [OpenID Connect specifications](https://openid.net/developers/specs/)
