# Pod and Container Security
[Persian edition](README.md) · [Chapter references](../../../references/README.en.md#08-security)

[فارسی](README.md) | [Chapter 08](../../README.en.md)

## Pod Security Standards

Privileged, Baseline, and Restricted define progressively tighter expectations. Pod Security Admission can enforce a standard at namespace scope. Understand application and kernel/filesystem needs first; untested restrictions can break rollouts.

## Minimize privilege

~~~yaml
securityContext:
  runAsNonRoot: true
  allowPrivilegeEscalation: false
  readOnlyRootFilesystem: true
  capabilities:
    drop:
      - ALL
  seccompProfile:
    type: RuntimeDefault
~~~

The app must support a non-root user and a read-only root filesystem. If it needs temporary writable paths, mount a narrow volume for those paths. Add only the specific capability required rather than disabling all controls.

## Supply chain

Use trusted images, update dependencies, scan vulnerabilities, and record SBOM, provenance, and signatures in the pipeline. Admission can reject untrusted artifacts or policy violations. A clean scan reflects only the database knowledge at that time; it is not a complete security guarantee.

## Common traps
- Using privileged mode, hostNetwork, or hostPath without a documented need.
- Running as root and leaving capabilities enabled for convenience.
- Assuming a Namespace is a sufficient security boundary.
- Installing admission webhooks without HA and timeout planning.
- Embedding credentials in an image.

## Quiz
1. **What does runAsNonRoot do?** Limits the process identity inside the container.
2. **What does readOnlyRootFilesystem require?** Mount writable paths separately when the app needs them.
3. **Do Pod Security Standards secure the entire supply chain?** No. Build, scan, and signing controls are separate.
4. **Why must a webhook be reliable?** Failure can slow or block API requests.

## Further reading
- [Pod Security Standards](https://kubernetes.io/docs/concepts/security/pod-security-standards/)
- [Pod and container securityContext](https://kubernetes.io/docs/tasks/configure-pod-container/security-context/)
- [Admission controllers](https://kubernetes.io/docs/reference/access-authn-authz/admission-controllers/)
- [Software supply-chain security](https://kubernetes.io/docs/concepts/security/software-supply-chain-security/)
- [Fadak Persian reference](https://fadak.ir/fa/Article/1001106)
