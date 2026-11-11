<div dir="ltr" align="left">

# Dependency Hygiene

**Language:** [فارسی](README.md) | **English**

**Learning objective:** Inventory direct and transitive dependencies, interpret scan results in context, and ship updates without losing security or performance. **Reference review: 2026-11-11.** The example and exercise are hypothetical and were not run.

## Definition and mental model

Every library, runtime, base image, and build tool is part of the software supply chain. A flaw in a parser, HTTP client, or compression library can lead to unbounded CPU or memory use, an outage, or unauthorized access. Dependency hygiene means knowing which components are present in an artifact, where they came from, who maintains them, and how they are corrected.

| Evidence | What it tells you | What it does not prove |
| --- | --- | --- |
| Manifest | Requirements declared by the project | Exact versions of every component in the artifact |
| Lockfile | Versions resolved by a particular tool | That those versions are safe |
| SBOM | Components in a particular build or release | Absence of vulnerabilities or authenticity by itself |
| SCA/advisory scan | A match between components and known information | Discovery of every unknown flaw |
| Provenance/valid signature | A relationship between an artifact and a defined origin/process | That the source code has no defects |

Start by recording the release and its direct and indirect components. Check a trustworthy advisory and support status; assess impact and exposure; define a fix or a narrowly scoped temporary control; finally, match the new artifact to deployment evidence. [OWASP Vulnerable Dependency Management](https://cheatsheetseries.owasp.org/cheatsheets/Vulnerable_Dependency_Management_Cheat_Sheet.html) emphasizes decisions that fit the situation: finding a CVE is the beginning of triage, not its conclusion.

## When to use it and the security/performance trade-off

Every service that contains external code needs this lifecycle. Removing an unused dependency can reduce attack surface and build size; hastily rewriting a security-sensitive capability is not a sound substitute. Pinning a version improves reproducibility, but pinning forever can preserve a vulnerability. Automatic upgrades without checking behavior can also break compatibility or resource use.

Updating a parser can change input limits or processing cost. Compare correctness, security, latency, and memory using representative inputs. If a corrected version is slower, investigate supported configuration, unnecessary work, or capacity; an unplanned rollback to the vulnerable version or disabling validation is not an acceptable optimization. A temporary control needs an owner, scope, due date, and patch path.

## Worked example, independent of language

Teaching assumption: a receipt service uses `receipt-renderer`, which depends on `image-parser`. A hypothetical advisory says a particular image input causes high memory use in a vulnerable version. The names and versions below are fictional and are not installation advice.

<div dir="ltr" align="left">

```text
release: receipts-2026-11-10
artifact: sha256:<digest-of-built-artifact>
dependency path:
  receipt-renderer 3.1.0 -> image-parser 4.2.1
proposed fix:
  supported renderer release resolving parser 4.2.2
verification:
  inspect resolved graph and final artifact
  compare output correctness, bounded inputs, memory and latency
deployment:
  staged rollout with error/resource signals and recovery plan
```

</div>

Changing only the project’s top-level file does not guarantee that a transitive version changed. Inspect the lockfile, build output, and deployed artifact. The package registry and package identity matter too: obtaining a same-named package from the wrong source is not fixed by upgrading its version. [OWASP Software Supply Chain Security](https://cheatsheetseries.owasp.org/cheatsheets/Software_Supply_Chain_Security_Cheat_Sheet.html) treats provenance, dependencies, and builds as related but distinct concerns.

## Step by step: from an alert to a corrected release

Keep these terms distinct when reading a scan result:

| Term | Meaning in this lesson | Practical question |
| --- | --- | --- |
| Direct dependency | The application requests it directly | Which capability depends on it? |
| Indirect or transitive dependency | Another dependency brings it in | Which path in the dependency tree introduced it? |
| Advisory/CVE | An identifier or report for a known flaw | Which versions and usage conditions are affected? |
| Lockfile | The resolver’s decisions about specific versions | Did this build use this file? |
| SBOM | Component inventory for a particular artifact | Is the inventory tied to that output’s digest? |
| Artifact | An installable or runnable output, such as an image or package | Was this corrected output actually deployed? |

Follow the lifecycle in order. **1.** Record the exact component name and version from the alert; a library name alone is insufficient because several versions or dependency paths may exist. **2.** Read the resolved dependency graph and confirm the component is present in the produced artifact. **3.** Match the affected conditions to the application: for example, can network-controlled input reach the vulnerable parser? Lack of a direct dependency does not automatically make the risk zero; assess both impact and reachability. **4.** Select a supported corrected version. Any temporary control must narrow the exposed path and have an owner and due date. **5.** Compare boundary inputs before and after the change; measure output correctness, processing errors, memory, and time separately. **6.** Match the graph/SBOM, build identifier, and deployment digest to confirm that the corrected artifact is active.

In the example, upgrading `receipt-renderer` to resolve `image-parser 4.2.2` may still leave `4.2.1` in another branch, such as dependency path B. Do not guess what the resolver selected: inspect the final graph. If two versions coexist, determine which capability calls each version. If the resolver selected one version for both paths, check API compatibility as well.

## Exercise and expected observation

On paper, draw `App → A → Parser` and `App → B → Parser`. Upgrade only A while B still depends on the old Parser. Expected observation: depending on the resolver, the old version may remain in the artifact; “the direct version changed” is not evidence that the finding is closed. For the next release, write down the component inventory, patch owner, review date, and resource-use criterion. No scan or package installation is required.

**Worked solution:** List both paths from `App` to `Parser`, and record the resolved version and using capability for each path. If any path contains the vulnerable version, the finding remains open. Even if the graph is clean, match the artifact to the deployment digest and relevant boundary inputs. “The project’s top-level file changed” is not sufficient closure evidence.

## Public evidence and its limits

[Cisco’s official Log4j advisory from December 2021](https://www.cisco.com/c/en/us/support/docs/csa/cisco-sa-apache-log4j-qRuKNEbd.html) documents product review and several related vulnerabilities, including denial of service. This is first-party historical evidence; its patch versions from that period are not recommendations for current versions. We cannot infer a latency reduction or an incident in your project from that advisory.

## Failure modes, signals, and checklist

Common failures include a forgotten base image, a transitive package, an old artifact returning after restart, an unsupported component, or a suppression with no due date. Finding count alone is not quality: also track the age of important findings, time to correction, inventory coverage, and releases with unknown provenance. Run scanners and dependency installers with least privilege and protect secrets.

- [ ] The inventory/SBOM is tied to the digest of the deployable artifact.
- [ ] Direct, transitive, runtime, and base-image dependencies are visible.
- [ ] Advisories are checked against a trustworthy source, version, and exposure conditions.
- [ ] Pinning/lockfiles are paired with an update process and advisory monitoring.
- [ ] Patches have an owner, due date, correctness check, and performance budget.
- [ ] Temporary controls or exceptions have a reason, scope, and expiration date.
- [ ] Deployment of the corrected artifact and removal of the old version are confirmed.

## Self-check

1. Does a lockfile show that a dependency is safe?
2. Why might upgrading A in the exercise fail to close the finding?
3. Does an SBOM replace scanning and review?
4. What should you do if the patch increases CPU use?
5. Why is a signed artifact not the same as perfectly secure code?
6. What problem does an exception without a due date create?

### Answer key with reasoning

1. No. It fixes the resolved version, even when that version is vulnerable.
2. B may preserve a separate path to the old version; inspect the resolved output and artifact.
3. No. An inventory supports matching and investigation but cannot prove that no flaw exists.
4. Measure the cause while keeping the security fix; investigate supported tuning or capacity. A temporary control still needs an owner and deadline.
5. A signature helps establish origin and integrity; code from a trusted source can still contain defects.
6. A temporary risk acceptance can become permanent by neglect, losing ownership and a path to correction.

## Optional references

- English: [OWASP Vulnerable Dependency Management](https://cheatsheetseries.owasp.org/cheatsheets/Vulnerable_Dependency_Management_Cheat_Sheet.html) — triage and correction options for different situations.
- English: [OWASP Software Supply Chain Security](https://cheatsheetseries.owasp.org/cheatsheets/Software_Supply_Chain_Security_Cheat_Sheet.html) — pinning, provenance, and build risks.
- English: [OpenSSF Concise Guide for Evaluating Open Source Software](https://best.openssf.org/Concise-Guide-for-Evaluating-Open-Source-Software.html) — maintenance, authenticity, development practices, and suitability before adding a library.
- English: [NIST Secure Software Development Framework, SP 800-218](https://csrc.nist.gov/pubs/sp/800/218/final) — a secure development and software-risk management framework, not a dependency scanner.
- English: [OWASP Dependency Graph/SBOM Cheat Sheet](https://cheatsheetseries.owasp.org/cheatsheets/Dependency_Graph_SBOM_Cheat_Sheet.html) — using an inventory for vulnerability response and SBOM limitations.
- Persian: [OWASP Top 10:2025 — Software Supply Chain Failures](https://top10.owasp.org/2025/fa/A03_2025-Software_Supply_Chain_Failures/) — the official Persian translation for understanding the issue; for a product patch, use that product’s advisory.

[Chapter index](../README.en.md) · [Course index](../../README.en.md) · [Next: Authentication and authorization](../02-authentication-and-authorization/README.en.md) · [Security review and updates](../04-security-review-and-updates/README.en.md) · [Performance testing](../../09-performance-testing/README.en.md)

</div>
