# NeatLogic Agent Guide

This file defines the default execution rules for working in the `neatlogic-itom-all` workspace.
Use it as the first-level instruction set when starting a new thread.

## Workspace Role

- `neatlogic-itom-all` is a packaging and aggregation workspace.
- Do not treat `neatlogic-itom-all` as the default place for business code changes.
- Business code changes should be made in the real module directories:
  - `neatlogic-web`
  - `neatlogic-framework`
  - `neatlogic-xxx`
  - `neatlogic-xxx-base`
- `neatlogic-itom-all` can contain documentation, norms, helper scripts, and coordination material.

## Module Placement Rules

- Frontend changes belong in `neatlogic-web`.
- Global reusable framework capability belongs in `neatlogic-framework`.
- Business logic belongs in the owning `neatlogic-xxx` module.
- Cross-module definitions, DTOs, shared mapper interfaces, enums, and reusable abstractions should prefer `neatlogic-xxx-base`.
- Do not move business logic into unrelated common layers just because it is convenient.

## Dependency Rules

- Maven modules must not form direct circular dependencies.
- If two business modules need to share basic definitions, place those definitions into the corresponding `-base` module.
- When deciding mapper or DTO placement, judge by future cross-module reuse potential, not only current call sites.

## Backend Rules

- Entity/data classes are named `xxxVo`.
- `Vo` classes should usually live under the corresponding `-base` module `dto` package.
- Project APIs are implemented through the API component mechanism, not traditional controllers.
- Do not add a normal Spring MVC controller for standard backend APIs unless there is a very specific reason.
- API classes normally live under `neatlogic.module.xxx.api`.
- API naming should use `Action + Domain + Api`, for example `SearchRagDatasetApi`.
- For simple functions, the usual pattern is:
  - add an API component
  - use mapper directly
  - add service only when business complexity justifies it
- SQL should stay in MyBatis XML, not annotation SQL.
- Mapper namespace must match the mapper interface fully qualified class name.
- Common list patterns should provide both list query and count query.
- In `neatlogic_tenant.sql` changelog files, do not create foreign key constraints. Table creation should not add any FK.

## Spring and Bean Scope

- `neatlogic-framework` beans are loaded in `root-context` and visible to all modules.
- Module beans should stay in their module servlet context unless they are genuinely global.
- Before adding a bean, decide whether it is:
  - global shared capability
  - module-private capability

## Frontend Rules

- Frontend code belongs in `neatlogic-web/src`.
- Commercial modules live under `src/commercial-module`.
- Community modules live under `src/community-module`.
- AI frontend code belongs under `src/commercial-module/ai`.

### Frontend Structure

- A frontend module typically contains:
  - `api`
  - `pages`
  - `import.js`
  - `router.js`
- `api` stores request wrappers.
- `pages` stores page-level Vue files.
- `import.js` registers module-specific components.
- `router.js` manages routes and menu entries.

### Frontend Style Rules

- Reuse existing common styles from `neatlogic-web/src/resources/assets/css/common.less` first.
- Only add local page styles if no suitable common style exists.
- Page styles should default to `<style scoped lang="less">`.
- Avoid page-level unscoped styles.
- Keep new local classes minimal.
- For form interaction, use internal components first. If an internal component exists, it must be used; only fall back to raw iView/native components when no equivalent internal component is available.

### Frontend Component Rules

- For type-driven pages, do not expand many `if/else` or `v-if` branches inside the main page.
- Prefer:
  - main page handles data flow
  - component mapping via `index.js`
  - dynamic rendering with `<component :is="...">`
- Different types should have separate component files even when they currently share the same base behavior.
- Shared props, computed logic, and helper methods should be moved into a base component and reused through extension/composition.

### Global Component Rules

- Do not re-import globally registered base components inside pages.
- In particular, do not locally register `Loading` again if it is already globally available.

## AI Module Rules

- AI backend APIs live under `neatlogic.module.ai.api`.
- AI frontend pages live under `neatlogic-web/src/commercial-module/ai`.
- RAG-related backend APIs should continue under focused subpackages such as `neatlogic.module.ai.api.rag`.
- For AI chat with RAG, prefer retrieval augmentation over turning RAG into a normal tool by default.
- `AiAgentRunner` should mount retrievers/augmentors, not embed low-level ES retrieval details directly.

## Default Decision Order

When requirements are not fully specified, use this order:

1. Put frontend work in `neatlogic-web`.
2. Put pure business logic in the owning `neatlogic-xxx` module.
3. Put reusable definitions in `neatlogic-xxx-base`.
4. Put truly global common capability in `neatlogic-framework`.
5. For beans and config, first decide whether the scope is global or module-private.

## Explicit Prohibitions

- Do not use `neatlogic-itom-all` as the direct landing zone for feature code.
- Do not create standard controllers for ordinary APIs when the project already uses API components.
- Do not spread business logic into framework/common layers without a clear cross-module reason.

## Threading and Task Control

The default collaboration model is one control thread plus optional worker threads.

### Main Thread Responsibility

- The main thread owns:
  - requirement decomposition
  - dependency management
  - task dispatch
  - result collection
  - documentation maintenance
- The main thread should avoid writing large amounts of business code directly.
- Small non-business edits are acceptable in the main thread, such as:
  - updating norms
  - maintaining task lists
  - summarizing execution state

### Task Decomposition Rules

- Every task must have clear input and output.
- Each child task should solve one clear problem.
- Prefer decomposition by dependency order:
  1. basic definitions
  2. backend interface
  3. frontend integration
  4. verification and documentation
- Parallel tasks must minimize write overlap.
- Strong dependencies must be stated explicitly.
- Every child task must include explicit out-of-scope content.

### Task Card Minimum Fields

Every dispatched task should include:

- task id
- task name
- task type
- target module
- dependency
- input
- output
- allowed modification scope
- forbidden scope
- done criteria
- required return content

### Child Thread Execution Rules

- Read the listed inputs before changing code.
- Only modify the target module.
- Do not write business code into `neatlogic-itom-all`.
- If module ownership, dependency completeness, or scope is wrong, stop and return the blocker.
- Return at least:
  - changed files
  - core implementation summary
  - verification result
  - risks and blockers

### Acceptance Rules

- A task is not complete unless it includes:
  - changed file list
  - verification result
  - risk summary
- If verification is missing, status should be at most `pending acceptance`, not `completed`.
- The main thread must only continue based on accepted outputs, not assumptions.

## Maintenance Rule

- If new project rules are confirmed during work, update the authoritative guidance document.
- If historical implementation conflicts with current recommendation, clearly distinguish:
  - historical behavior
  - current recommended approach

## User Confirmation Rule

- If the user explicitly asks to "give the design first", "provide a plan first", or otherwise makes it clear that implementation must wait for confirmation, stop at the design/proposal stage first.
- In that case, do not write code, edit files, or execute implementation steps until the user explicitly confirms the plan.
- This is a mandatory rule and overrides the default bias toward direct implementation.
