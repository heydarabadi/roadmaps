# API Keys

> Chapter 07: Analysis, Analytics, and Production · Lesson 42

[Read the Persian version](../../../../../fa/elasticsearch/07-analysis-analytics-and-production/topics/42-api-keys/README.md)

## Learning goals

- Create a credential for an application with a limited role descriptor.
- Store, expire, rotate, and revoke API keys safely.
- Understand that API keys are one credential type and deployment capabilities can vary.

## Limited programmatic access

An API key can authenticate an application and carry limited privileges. Create a descriptive name, restrict access to the required indices and operations, and add an expiration where appropriate. The encoded secret is shown when the key is created; store it securely because it cannot be safely recovered from a later listing. Never commit it to source control, expose it in browser code, or include it in logs.

~~~http
POST /_security/api_key
{"name":"catalog-reader","expiration":"30d",
 "role_descriptors":{"reader":{"indices":[
   {"names":["products-*"],"privileges":["read"]}
 ]}}}
~~~

Rotate by creating a new key, moving the consumer, verifying usage, and revoking the old key. Short expirations reduce the window of misuse but require a renewal workflow. API key behavior and supported management differ by deployment and license; verify the current environment. Use a dedicated key per service rather than a shared human credential.

## Exercise

Create a reader key for a lab index, confirm it can search but not write, and store it in an environment-appropriate secret manager. Create a replacement, switch a test client, then revoke the old key and verify it no longer works.

## Quiz with answers

1. **What is an API key used for?** Programmatic authentication with assigned privileges.
2. **Why limit the key to specific indices and operations?** It reduces the impact if the credential is exposed.
3. **Why use expiration and rotation?** They reduce the lifetime of an exposed or stale secret.
4. **What should happen during rotation?** Create a new key, migrate consumers, verify the transition, then revoke the old key.

## References and further reading

- [Elasticsearch API keys](https://www.elastic.co/docs/deploy-manage/api-keys/elasticsearch-api-keys) — create, manage, and invalidate keys.
- [Create API key API](https://www.elastic.co/docs/api/doc/elasticsearch/operation/operation-security-create-api-key) — privileges and expiration.
- [Invalidate API key API](https://www.elastic.co/docs/api/doc/elasticsearch/operation/operation-security-invalidate-api-key) — revoke credentials.
- [User roles](https://www.elastic.co/docs/deploy-manage/users-roles/cluster-or-deployment-auth/user-roles) — privilege model.
- [Elastic security guidance](https://www.elastic.co/docs/deploy-manage/security) — secure credentials and deployments.
- Persian discovery search (not a verified article): [Persian Elasticsearch API-key tutorials](https://www.google.com/search?q=Elasticsearch+API+key+%DA%A9%D9%84%DB%8C%D8%AF+API+%D9%81%D8%A7%D8%B1%D8%B3%DB%8C).


## Curated bilingual reading map

- [Persian sources, courses, and examples](../../../references/README.md) · [English technical documentation and case studies](../../../references/README.en.md)

Google search links above are discovery shortcuts; they are not verified article citations.

