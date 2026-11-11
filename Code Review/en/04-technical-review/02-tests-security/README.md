# 4.2 — Test Quality and Security Review

**Language:** English · [فارسی](../../../04-technical-review/02-tests-security/README.md)

**Learning outcomes:** Evaluate whether tests assert the required behavior and perform a structured, risk-based security review.

## Core lesson

A test is useful when it asserts a meaningful property and would fail if the defect returned. Read the setup, input, assertion, and cleanup. Check negative cases and authorization boundaries, not only successful requests. Mocks are helpful for isolation but can encode the same mistaken assumption as production code. Use integration tests where persistence, transactions, or real policy wiring matter.

For security, identify assets, actors, trust boundaries, sources, transformations, and sinks. A source may be HTTP input, a queue message, uploaded file, environment variable, or database row. A sink may be SQL, shell, filesystem, HTML, log, or external API. Verify validation appropriate to the data, contextual output encoding, safe query construction, least privilege, secrets handling, and useful error behavior. Authentication answers who the user is; authorization asks what that identity may do to this specific resource.

Check business workflows too: state transitions, race conditions, quotas, transaction integrity, and ways to bypass a control through a different endpoint. SAST and dependency tools provide signals, not a complete security argument. Triage findings, verify the relevant control manually, and involve a security owner when the impact or design is high.

## Worked example: file upload

Do not trust the extension or browser-supplied content type. Check authorization before upload; enforce size limits; validate content; generate a storage name; store outside executable web paths; restrict access; and consider archive expansion limits. Tests should include a valid small file, unauthorized user, spoofed content type, oversized payload, and malformed content. Verify rejected input does not leak secrets into logs.

## Review checklist

- [ ] Tests assert behavior and include relevant negative/boundary cases.
- [ ] Security-sensitive data is traced from source to sink.
- [ ] Authorization is enforced on every path to the resource.
- [ ] Untrusted input is safely validated and encoded/parameterized for its sink.
- [ ] Secrets, logs, dependencies, and error messages are checked.
- [ ] Tool findings are triaged and high-risk questions have an owner.

## Quiz

1. A test asserts only that a helper was called. What may be missing? **The resulting business behavior, persisted state, permission decision, or failure handling.**
2. A user is authenticated. Can they read any account ID? **No; resource-level authorization must independently verify access.**
3. Why is checking a file extension insufficient? **The filename and content type are untrusted metadata and may not match the actual payload.**
4. Does a clean SAST report prove a workflow is secure? **No; it only means configured patterns were not reported, while business logic and context may require manual analysis.**

## Further reading

- [OWASP Secure Code Review Cheat Sheet](https://cheatsheetseries.owasp.org/cheatsheets/Secure_Code_Review_Cheat_Sheet.html)
- [OWASP Authorization Cheat Sheet](https://cheatsheetseries.owasp.org/cheatsheets/Authorization_Cheat_Sheet.html)
- [OWASP Input Validation Cheat Sheet](https://cheatsheetseries.owasp.org/cheatsheets/Input_Validation_Cheat_Sheet.html)
- [OWASP SQL Injection Prevention](https://cheatsheetseries.owasp.org/cheatsheets/SQL_Injection_Prevention_Cheat_Sheet.html)
- [OWASP File Upload Cheat Sheet](https://cheatsheetseries.owasp.org/cheatsheets/File_Upload_Cheat_Sheet.html)
- [NIST SSDF, SP 800-218](https://csrc.nist.gov/pubs/sp/800/218/final)
- [OWASP Web Security Testing Guide](https://owasp.org/www-project-web-security-testing-guide/)
- [Persian: Pro-nee secure code review](https://pro-nee.net/terms/secure-code-review/)
