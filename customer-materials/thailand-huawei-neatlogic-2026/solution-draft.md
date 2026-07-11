# NeatLogic Customer Solution Draft for Huawei Thailand

## Page 1: Business Pain Point -> Solution Logic -> Business Effect

**Title:** NeatLogic for Financial IT Operations  
**Subtitle:** From fragmented operations to AI-assisted service resilience

Financial institutions are under pressure to keep customer-facing services stable while reducing operating cost, audit risk, and manual dependency. The common challenge is not a single missing tool. It is fragmented execution across service requests, CMDB data, monitoring alerts, release activities, knowledge, and reporting.

### Customer Business Pain Points

- **Slow service response:** incidents and service requests depend on manual dispatch, repeated communication, and unclear ownership.
- **High operating cost:** routine checks, deployment tasks, environment preparation, and recovery actions rely on engineers doing repetitive work.
- **Fragmented system data:** assets, applications, topology, work orders, alerts, changes, and knowledge are stored in separate systems, making impact analysis slow.
- **Late risk identification:** alerts are noisy, duplicate, and disconnected from business context; risk often becomes visible only after users are affected.
- **Compliance pressure:** change records, approval evidence, execution logs, SLA status, and configuration changes are hard to trace end to end.

### Solution Logic

| Business Pain Point | NeatLogic Capability | Huawei ICT / AI Foundation | Business Effect |
| --- | --- | --- | --- |
| Service response is slow and inconsistent | ITSM service catalog, workflow engine, SLA, forms, assignment rules, mobile work order handling | Stable cloud, network, compute, storage, and AI service foundation | Faster request routing, visible SLA control, improved user experience |
| Asset and application data are incomplete | CMDB with "Everything is CI", resource center, auto discovery, topology, transaction and audit records | Huawei infrastructure and integration capabilities provide trusted resource data | Faster impact analysis, better change risk control, audit-ready configuration history |
| Alerts are noisy and risk is found late | Alert center, multi-source ingestion, event plugins, suppression, subscription, topology, AI-assisted classification and RCA | Huawei AI platform/model services plus monitoring and operations data | Lower alert noise, earlier risk recognition, more consistent remediation suggestions |
| Operations and releases are manual | Automation orchestration, runner-based remote execution, batch/parallel/gray execution, one-click release, super pipeline | Huawei compute, network, storage, security, and cloud resource foundation | Shorter operation cycle, fewer manual errors, repeatable release execution |
| Knowledge and decision data are scattered | Knowledge base, reports, dashboards, large screen, data APIs, message subscription | Unified data access and AI-assisted knowledge retrieval | Better management visibility, reusable resolution knowledge, continuous improvement |

### Customer Value to Validate

Use the following as PoC validation targets rather than unverified promises:

- **30-50% reduction** in manual incident triage effort through alert classification, CMDB context, and automatic assignment.
- **20-40% shorter** incident handling or change lead time when workflow, SLA, and automation are connected.
- **40-60% automation coverage** for repetitive inspection, deployment, recovery, or data collection tasks selected in the PoC scope.
- **60-80% faster** asset and application impact analysis when CMDB topology and work orders are linked.
- **100% traceable evidence** for selected change/release flows: approval, execution log, result, rollback record, and audit trail.

## Page 2: NeatLogic Capability Map and PoC Proof Path

**Title:** One Platform for Service, Operations, Change, Knowledge, and AI-assisted Decisioning

### NeatLogic Capability Coverage

- **Customer and employee service:** service catalog, work order center, workflow, SLA, satisfaction, notification, mobile access.
- **Configuration and resource management:** dynamic CMDB model, CI transaction, topology, resource center, data collection, auto discovery, authorization, APIs and message subscription.
- **Monitoring, inspection, and risk detection:** scheduled/manual inspection, application and asset inspection, latest problem list, configuration file version comparison, alert center, event-driven alert lifecycle.
- **Automation and release:** custom tools, composite orchestration, runner-based execution, batch/parallel/gray execution, job management, one-click release, super pipeline, scheduled jobs.
- **Change, R&D, and delivery governance:** requirements, tasks, defects, iterations, test plans/cases, code/release association, configurable state transitions.
- **Knowledge, reporting, and management visibility:** knowledge authoring, versioning, approval, ITSM-to-knowledge conversion, configurable reports, scheduled report sending, dashboard and large-screen views.
- **AI-assisted operations:** AI agent runner, tool/workflow invocation, RAG knowledge retrieval, alert analysis, structured AI outputs for downstream automation and routing.

### Financial Customer PoC 1: Incident-to-Resolution Intelligence

**Scenario:** Connect monitoring alerts, CMDB context, ITSM workflow, knowledge base, and automation runbooks for one high-value banking application.

**Implementation path:**

1. Ingest alerts from the selected monitoring source into NeatLogic Alert Center.
2. Correlate alert object, application, owner, and topology through CMDB.
3. Use AI-assisted analysis to classify alert type, severity, probable cause, and recommended action.
4. Auto-create or update ITSM tickets, assign the right team, attach knowledge/runbook guidance, and trigger approved automation where safe.
5. Report SLA status, MTTA/MTTR, repeated alert rate, and closure evidence.

**Suggested validation metrics:**

- Alert deduplication or noise reduction ratio.
- Correct assignment ratio after AI/CMDB routing.
- Mean time to acknowledge and mean time to restore.
- Percentage of incidents with complete evidence: alert, CI impact, action log, ticket, and resolution knowledge.

### Financial Customer PoC 2: Controlled Change and Release

**Scenario:** Standardize a core banking or channel-system change flow from request, approval, risk assessment, release execution, verification, and rollback evidence.

**Implementation path:**

1. Submit change request through ITSM service catalog with required business and risk fields.
2. Use CMDB topology to show impacted applications, middleware, databases, servers, and dependent services.
3. Execute automated pre-checks, release tasks, post-checks, and rollback steps through Automation and Super Pipeline.
4. Use dashboards and reports to show change status, failure reason, execution log, and compliance evidence.

**Suggested validation metrics:**

- Change lead time from submission to verified completion.
- Number of manual execution steps replaced by automation.
- Release success rate and rollback readiness.
- Completeness of audit evidence for approval, execution, verification, and exception handling.

