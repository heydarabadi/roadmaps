# TOGAF and IAF Enterprise Architecture

## Learning goals

- Explain enterprise architecture as alignment between strategy, capabilities, information, applications, and technology.
- Understand TOGAF's ADM cycle, architecture repository, governance, and tailoring.
- Compare framework guidance with an organization's actual decision process.

## Enterprise architecture

Enterprise architecture (EA) connects business direction to the capabilities, information, applications, and technology needed to deliver it. The goal is not to draw every system; it is to make dependencies and choices visible at the level needed for investment, change, and risk decisions.

TOGAF is a standard and set of practices maintained by The Open Group. Its Architecture Development Method (ADM) provides an iterative cycle: establish architecture capability and principles, define vision, develop business/data/application/technology views, identify opportunities and solutions, plan migration, govern implementation, and manage change. Tailor the method to the organization's scale and governance; using every artifact mechanically can delay delivery without improving decisions.

An architecture repository stores principles, models, reference architectures, standards, solution designs, and decision records. Governance should set review triggers and authority, not become a gate for every code change. Connect architecture roadmaps to funding, accountable owners, and measurable outcomes.

The Integrated Architecture Framework (IAF), associated with Capgemini, is another structured approach to enterprise and solution architecture. Compare frameworks by the perspectives and concerns they cover, how they handle traceability and governance, and how well they fit organizational skills. Framework names do not substitute for stakeholder engagement or evidence.

## Worked example: replace a fulfillment platform

Start with business capability and target outcomes: faster dispatch, fewer stock mismatches, and regional growth. Map current applications, data owners, integrations, and regulatory constraints. Define transition states and migration waves. Approve an architecture that permits incremental cutover, then review each implementation against principles and recorded exceptions.

## Self-check quiz

1. What is the purpose of EA? Align business goals and change with capabilities, information, applications, and technology.
2. Is TOGAF's ADM necessarily a one-way waterfall? No; it is iterative and should be tailored.
3. What belongs in an architecture repository? Reusable principles, models, standards, reference architectures, and decision records.
4. Why tie a roadmap to owners and funding? A target without accountable execution is only an aspiration.
5. Can a framework choose the right architecture automatically? No; context, constraints, stakeholders, and trade-offs remain decisive.

## Exercise

Outline an EA assessment for replacing an order management system. Name stakeholders, baseline views, target outcomes, migration concerns, and governance evidence.

### Sample answer

Include operations, sales, finance, security, data, and integration owners. Map order capabilities, systems of record, interfaces, data retention, and current failure costs. Define target outcomes and constraints, compare incremental replacement paths, record dependencies and risks, fund transition increments, and review implementation through measurable outcomes and ADRs.

## Further reading

- English: [The Open Group: TOGAF Standard](https://www.opengroup.org/togaf), [TOGAF ADM overview](https://pubs.opengroup.org/togaf-standard/adm/), [TOGAF Standard 10th Edition resources](https://help.opengroup.org/hc/en-us/articles/32726995273362-Understanding-the-TOGAF-Standard), [Capgemini Integrated Architecture Framework](https://www.capgemini.com/insights/expert-perspectives/integrated-architecture-framework/), [Gartner: Enterprise Architecture](https://www.gartner.com/en/information-technology/glossary/enterprise-architecture-ea), [GOV.UK Technology Code of Practice](https://www.gov.uk/guidance/the-technology-code-of-practice)
- Persian: [Ali Rostami software architecture](https://www.alirostami.com/software-architecture/), [DNTips](https://www.dntips.ir/)
