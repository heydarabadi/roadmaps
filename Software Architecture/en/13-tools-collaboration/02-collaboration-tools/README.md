# Collaboration and Architecture Tools

## Learning goals

- Select tools for shared knowledge, planning, diagrams, code, and operational response.
- Define ownership, access, retention, and source of truth for each artifact.
- Prevent tool sprawl and undocumented decisions.

## A tool serves a workflow

Teams may use issue trackers, source control, chat, wikis, whiteboards, diagramming tools, architecture repositories, CI/CD, and incident platforms. Choose tools by workflow needs: discoverability, permissions, integrations, audit, exportability, and accessibility. A tool should reduce coordination cost or improve evidence; adding another system creates administration and knowledge fragmentation.

Define where decisions live. Chat can coordinate rapidly, but decisions with long-term impact belong in a durable ADR or project record with context, alternatives, consequences, owner, and review trigger. Link the decision from code, ticket, and diagram. Keep diagrams and docs near the system when possible so change review can update them.

Use access controls, retention, classification, and export/backup plans. Treat AI-generated summaries as drafts that need verification, especially for decisions, security, or incidents. Do not paste secrets or personal data into tools without an approved data-handling basis.

## Meeting and asynchronous practice

Write a short agenda and decision needed before a meeting. Record outcomes, owners, and due dates. Use asynchronous proposals for review when participants need time to inspect evidence. Architecture reviews should surface trade-offs and unresolved risks, not simply approve slides.

## Worked example: cross-team API decision

The API owner writes a proposal with consumer needs, sample contract, compatibility plan, security boundary, and alternatives. Teams comment asynchronously; a short meeting resolves the two open trade-offs. The final ADR is stored with the service, while a ticket assigns rollout work and the collaboration tool links both.

## Self-check quiz

1. Why should consequential decisions outlive chat history? Future maintainers need context, rationale, and consequences.
2. What makes a tool decision useful? It supports a real workflow and has clear ownership and source-of-truth boundaries.
3. What should meeting notes capture? Decision, rationale, open questions, owners, and due dates.
4. Why plan for exportability? Teams may need migration, audit, or recovery independent of a vendor.
5. Is an AI summary authoritative evidence? No; verify it against original sources.

## Exercise

Design a lightweight tool and artifact workflow for a new architecture decision involving four teams.

### Sample answer

Draft a proposal and ADR in a versioned repository, collect async comments in the shared review tool, track implementation in the issue system, and link the diagram and API schema. The service owner maintains the canonical decision; each comment closes with disposition, owner, and due date. Apply access/retention policy and avoid copying sensitive production data.

## Further reading

- English: [GOV.UK Architectural Decision Record Framework](https://www.gov.uk/government/publications/architectural-decision-record-framework), [ADR GitHub community](https://adr.github.io/), [GitHub Docs: collaboration](https://docs.github.com/en/get-started/using-github/collaborating-with-issues-and-pull-requests), [Atlassian Team Playbook](https://www.atlassian.com/team-playbook), [Google SRE: Postmortem culture](https://sre.google/sre-book/postmortem-culture/), [C4 model](https://c4model.com/)
- Persian: [DNTips](https://www.dntips.ir/), [Ali Rostami architecture resources](https://www.alirostami.com/software-architecture/)
