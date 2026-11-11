# Hashing, Cryptography, PKI, and TLS

## Learning goals

- Select hashing, encryption, signatures, and key exchange for distinct purposes.
- Explain certificates, trust chains, and TLS at an architectural level.
- Design key custody, rotation, and failure handling.

A general hash is a one-way fingerprint. Password hashing should be slow and salted. Encryption protects recoverable data with a key. A digital signature checks integrity and origin. Certificates and PKI connect a public key to an identity and trust chain. These mechanisms are not interchangeable.

For password storage, use Argon2id or a platform-appropriate password-hashing algorithm; a fast SHA-256 hash makes offline guessing cheap. Use established cryptographic libraries for sensitive data, keep keys in key management, and practice rotation, backup, and recovery.

TLS protects a communication channel and validates certificates. HTTPS alone does not guarantee API authorization, safe business logic, or protected logs. Certificate expiry, hostname validation, and key rotation are operational responsibilities.

~~~text
Client -- TLS + server certificate validation --> API
Password -- slow hash + unique salt --> verifier
Never log passwords, tokens, or raw payment credentials
~~~

## Choose the correct cryptographic tool

- **General hash:** fingerprint and integrity comparison; irreversible, but fast hashes are unsuitable for passwords.
- **Password hashing:** purpose-built and slow, with a unique salt per password. Choose and review cost parameters against current guidance and hardware. A salt is not secret; a pepper, if used, requires separate protection and rotation.
- **Symmetric encryption:** the same key encrypts and decrypts; efficient for bulk data but key protection and rotation are critical.
- **Asymmetric cryptography:** public/private key operations for uses such as key exchange or signatures; it does not replace a well-designed protocol or TLS library.
- **Digital signature:** private key signs; public key verifies authenticity and integrity. It does not provide confidentiality.
- **MAC/HMAC:** parties with a shared secret verify message authenticity and integrity; every key holder can create a valid message.

Do not invent ciphers, padding, nonces, or protocols. Use standard, maintained framework APIs and review configuration against the threat model.

## Key lifecycle

1. Record the key’s purpose, owner, data classification, and environment.
2. Generate it with a cryptographically secure source or managed key service. Do not put it in source code, images, or logs.
3. Grant least privilege and audit access. Separate development, test, and production keys.
4. Design rotation with overlap: receivers accept the new key, producers begin using it, old data is re-encrypted if needed, and the prior key is revoked when the transition ends.
5. Practice backup and recovery. Losing the only key can make ciphertext unrecoverable; key exposure requires revocation and an impact assessment.

## TLS from connection to request

The client validates the server certificate chain, expiration, and hostname. Negotiation establishes the session’s cryptographic protection; data in transit is encrypted and protected from modification. Use a modern TLS version and official platform configuration; disable obsolete versions.

TLS does not automatically protect data in memory, databases, backups, logs, or screenshots, and it does not authorize users. For a webhook, use a signature with a timestamp, unique event ID, and acceptance window to constrain replay. A timestamp alone does not prevent replay.

## Worked selection example

Password storage needs slow password hashing, not reversible encryption. A recoverable backup needs encryption with managed keys. API communication needs TLS. Webhook authenticity needs a signature or MAC plus replay protection. Calling all four “encryption” hides the actual security requirement.

## Self-check quiz

1. **Why is plain SHA-256 inappropriate for password storage?** It is fast, making offline brute-force attempts inexpensive.
2. **How does encryption differ from hashing?** Encryption can be reversed with a key; a hash is ordinarily one-way.
3. **What does TLS not guarantee?** User authorization or safe application logic.
4. **What relationship does PKI establish?** Trust in a public key’s identity through certificates and a chain of trust.
5. **What happens if the only decryption key is lost?** Encrypted data may be permanently unrecoverable; recovery must be planned and tested.

## Exercise

For password storage, backup, API TLS, and webhook signatures, decide where keys live and how they rotate.

### Sample answer

Passwords use purpose-built salted password hashing and have no decryption key. Backups use a data-encryption key protected by a key-encryption key in KMS/HSM; rotation and restore are tested. TLS private keys live in a certificate manager with renewal. Webhooks use a separate signing/MAC secret and include timestamp and event ID; rotation accepts old and new keys during a short overlap, then revokes the old key.

## Further reading

- Persian: [Software architecture fundamentals](https://www.alirostami.com/software-architecture/), [OWASP guidance](https://cheatsheetseries.owasp.org/)
- English: [OWASP Password Storage Cheat Sheet](https://cheatsheetseries.owasp.org/cheatsheets/Password_Storage_Cheat_Sheet.html), [OWASP TLS Cheat Sheet](https://cheatsheetseries.owasp.org/cheatsheets/Transport_Layer_Security_Cheat_Sheet.html), [NIST Cryptographic Standards](https://csrc.nist.gov/projects/cryptographic-standards-and-guidelines), [NIST Key Management Guidelines](https://csrc.nist.gov/projects/key-management/key-management-guidelines), [RFC Editor](https://www.rfc-editor.org/)
