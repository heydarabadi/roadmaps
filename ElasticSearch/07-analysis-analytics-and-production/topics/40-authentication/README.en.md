# Authentication

> Chapter 07: Analysis, Analytics, and Production · Lesson 40

[Read the Persian version](README.md)

## Learning goals

- Distinguish authentication from authorization.
- Verify the effective identity of a request.
- Protect credentials and network communication.

## Prove identity and protect the channel

Authentication answers “who is making this request?” Authorization answers “what may that identity do?” Elasticsearch can use supported realms and identity providers such as the native realm, LDAP, SAML, or OpenID Connect, depending on deployment. TLS protects communication and helps verify endpoints. The exact configuration depends on version and deployment type.

~~~http
GET /_security/_authenticate
~~~

Use this endpoint to confirm the effective authenticated identity during a controlled check. Do not disable security for production or expose an unauthenticated cluster to public networks. Store credentials in a secret manager, rotate them, restrict logs, and configure TLS for application and node communication. Authentication alone does not provide least privilege; roles and privileges are covered in the next lesson.

## Exercise

Make a request with no credentials and with a limited service identity. Record the response and effective user. Sketch how the application retrieves the credential from a secret manager and how it rotates without sharing a human account.

## Quiz with answers

1. **What is authentication?** Verifying the identity of the requester.
2. **What is authorization?** Determining which operations and data the identity can access.
3. **Why configure TLS?** To protect communication and verify the endpoint identity.
4. **Does successful authentication guarantee safe access?** No; the identity still needs appropriate limited privileges.

## References and further reading

- [User authentication](https://www.elastic.co/docs/deploy-manage/users-roles/cluster-or-deployment-auth/user-authentication) — supported identity methods.
- [Secure the Elastic Stack](https://www.elastic.co/docs/deploy-manage/security) — security configuration overview.
- [TLS configuration](https://www.elastic.co/docs/deploy-manage/security/secure-cluster-communications) — encrypted node and client communication.
- [Authenticate API](https://www.elastic.co/docs/api/doc/elasticsearch/operation/operation-security-authenticate) — inspect the current identity.
- [API keys](https://www.elastic.co/docs/deploy-manage/api-keys/elasticsearch-api-keys) — application credentials.
- Persian discovery search (not a verified article): [Persian Elasticsearch authentication tutorials](https://www.google.com/search?q=Elasticsearch+authentication+security+%D8%A2%D9%85%D9%88%D8%B2%D8%B4+%D9%81%D8%A7%D8%B1%D8%B3%DB%8C).


## Curated bilingual reading map

- [Persian sources, courses, and examples](../../../references/README.md) · [English technical documentation and case studies](../../../references/README.en.md)

Google search links above are discovery shortcuts; they are not verified article citations.

