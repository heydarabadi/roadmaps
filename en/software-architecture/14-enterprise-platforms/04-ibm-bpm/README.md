# IBM BPM and Business Automation Workflow

## Learning goals

- Understand how workflow platforms coordinate human tasks, services, and business rules.
- Distinguish process definition, runtime state, integrations, and analytics.
- Plan migration and governance around long-running enterprise processes.

## Product context

IBM BPM is a legacy product name often encountered in existing estates. Current IBM documentation uses IBM Business Automation Workflow (BAW) for workflow applications that coordinate people, systems, and information. Deployment models, supported migration paths, and version features differ, so begin with the exact installed product and IBM's lifecycle documentation.

A workflow platform can manage process models, human task assignment, timers, service calls, permissions, audit, dashboards, and versioned process deployments. It is useful when a process crosses systems and needs visible long-running state or human decisions. It should not become a substitute for the authoritative data in ERP, CRM, or domain services.

A process instance may last days or months. Model durable state, correlation IDs, timeout, escalation, retries, compensation, and manual repair. Keep external side effects idempotent or track their result to prevent duplicate work. Versioning must define how running instances continue when a process definition changes.

## Architecture and operations

Separate authoring, testing, staging, and production runtime. Control deployment artifacts, configuration, identities, and integration credentials. Monitor instance age, task queues, failed service calls, throughput, and user backlog. Provide operations teams with safe retry, suspend, resume, and correction procedures, and audit who performed them.

## Worked example: invoice exception

Invoices that fail automated matching enter a human queue with reason, supplier, purchase order, and amount. A finance user corrects metadata or requests approval. The workflow calls ERP through a bounded integration and records the response. Duplicate submissions use a stable invoice ID; unresolved cases escalate after a defined age.

## Self-check quiz

1. What value does a workflow engine add? Durable coordination, human tasks, timers, visibility, and controlled process execution.
2. Should BAW replace ERP as the financial system of record? No; the ERP owns accounting facts while workflow coordinates steps.
3. Why are long-running process versions important? Instances may continue after a new process definition is deployed.
4. Why track external call IDs and outcomes? To make retries and manual repair safe.
5. Name useful workflow operational signals. Instance age, queue depth, failure rate, throughput, and task backlog.

## Exercise

Design a workflow for a supplier invoice that may need approval and an ERP posting. Include state, idempotency, timeout, escalation, and audit.

### Sample answer

Create an instance keyed by supplier invoice identity, validate and deduplicate, then route by amount and policy. Approval tasks have an owner and due time; ERP posting uses a stable idempotency/reference key. A timeout moves to an uncertain state and triggers reconciliation before retry. Escalations and corrections are audited with actor, reason, and timestamp.

## Further reading

- English: [IBM Business Automation Workflow overview](https://www.ibm.com/docs/en/baw/26.0.x?topic=overview), [IBM Business Automation Workflow product docs](https://www.ibm.com/docs/en/cloud-paks/cp-biz-automation/25.0.1?topic=automation-business-workflow), [IBM Business Automation Workflow lifecycle](https://www.ibm.com/support/pages/lifecycle/search?q=Business%20Automation%20Workflow), [BPMN 2.0 specification](https://www.omg.org/spec/BPMN/2.0/), [Camunda process orchestration concepts](https://docs.camunda.io/docs/components/concepts/processes/), [IBM case studies](https://www.ibm.com/case-studies)
- Persian: [DNTips BPM and workflow articles](https://www.dntips.ir/), [Persian Event-Driven Architecture notes](https://github.com/gloonch/eventdrivenfarsi)
