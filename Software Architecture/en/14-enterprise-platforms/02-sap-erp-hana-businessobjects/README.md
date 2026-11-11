# SAP ERP, S/4HANA, HANA, and BusinessObjects

## Learning goals

- Distinguish ERP business processes, the S/4HANA application, the HANA database, and BI/reporting platforms.
- Plan fit-to-standard, extensions, data migration, integration, and analytics.
- Evaluate enterprise change through business process and lifecycle impact.

## Platform layers

An ERP coordinates core business processes such as finance, procurement, inventory, production, and sales. SAP S/4HANA is an ERP product family built on the SAP HANA platform; SAP HANA is an in-memory relational data platform with transactional and analytical capabilities. SAP BusinessObjects BI is a separate reporting and analytics platform that can connect to SAP and non-SAP sources. These names describe related but distinct architecture layers.

An S/4HANA program starts with process and data design, not custom code. Fit-to-standard compares business needs with supported product processes and identifies justified gaps. Uncontrolled customizations complicate upgrades and can block adoption of standard improvements. Document extensions, integration boundaries, authorizations, data ownership, and change impacts.

Migration from SAP ERP to S/4HANA includes business-process changes, data quality and volume, custom-code remediation, interfaces, reporting, security roles, testing, cutover, and operational support. Select deployment model, availability, disaster recovery, and residency requirements early. Rehearse data migration and cutover with measured duration and reconciliation.

SAP HANA's architecture encourages processing close to data to reduce data movement. That can improve analytical workloads but does not make every query or model efficient. Define workload classes, capacity, backups, security, and lifecycle. BusinessObjects semantic models and reports should use governed metric definitions and least-privilege access; avoid duplicating measures with inconsistent formulas.

## Worked example: order-to-cash

Map sales order, availability, delivery, invoicing, payment, and finance posting. Name the owning application and master data for customer, product, price, and inventory. Integrate external commerce through stable APIs or events; reconcile asynchronous confirmations. Build BI measures from defined facts and dimensions, then validate totals with business owners before replacing existing reports.

## Self-check quiz

1. What is the relationship between S/4HANA and HANA? S/4HANA is the ERP application family built on the HANA data platform.
2. Is SAP BusinessObjects identical to the ERP database? No; it is a BI/reporting platform that connects to data sources.
3. What does fit-to-standard aim to do? Use supported standard processes where suitable and justify necessary gaps.
4. Why rehearse cutover? It exposes duration, data quality, dependencies, and recovery issues before production.
5. Why govern BI metric definitions? Conflicting formulas lead different departments to act on different versions of the same business measure.

## Exercise

Plan a staged migration of order-to-cash from a legacy ERP to S/4HANA with one external commerce integration and executive reports.

### Sample answer

Inventory business processes, data owners, custom code, interfaces, reports, and regulatory controls. Agree on standard process adoption and approved extensions. Profile and cleanse master and transactional data, test repeated migration/reconciliation, and build versioned interfaces. Pilot a region or company code where feasible, rehearse cutover and rollback/forward recovery, and certify reports against finance-owned definitions.

## Further reading

- English: [SAP S/4HANA Help Portal](https://help.sap.com/docs/SAP_S4HANA_ON-PREMISE), [SAP S/4HANA 2025 feature scope](https://help.sap.com/doc/e2048712f0ab45e791e6d15ba5e20c68/2025/en-US/FSD_OP2025_latest.pdf), [SAP HANA architecture documentation](https://help.sap.com/docs/SAP_HANA_PLATFORM), [What is SAP HANA?](https://www.sap.com/products/data-cloud/hana/what-is-sap-hana.html), [SAP BusinessObjects BI Platform](https://pages.community.sap.com/topics/bi-platform), [Microsoft: SAP BusinessObjects on Azure architecture](https://learn.microsoft.com/en-us/azure/sap/workloads/businessobjects-deployment-guide)
- Persian: [SAP Help Portal language selector](https://help.sap.com/), [DNTips enterprise software articles](https://www.dntips.ir/)

Product and edition availability changes; use SAP's current maintenance, implementation, and migration documents for project planning.
