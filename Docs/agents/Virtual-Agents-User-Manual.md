# Virtual Agents User Manual

## Quick Help: Triggers and Playbooks
- Use agents: say "use virtual agents", "use agent", or mention an agent/playbook by name (e.g., "run review-docs-tests"). I will enable agents and show this summary.
- Core playbooks:
  - review-docs-tests: Review → Docs → Tests. Inputs: `changed_files`, `diff_summary`, `task_id`.
  - performance-sweep: Perf analysis → perf tests. Inputs: `changed_files`, `task_id`.
  - security-gate: Security audit → notes. Inputs: `changed_files`, `task_id`.
  - code-map-update: Backup, then draft CodeMap to `Docs/codemap/{task_id}-codemap.md`. Inputs: `changed_files`, `since`, `task_id`.
  - code-map-update-inplace: Backup, then write `Docs/CodeMap.md` in-place. Inputs: `changed_files`, `since`.
  - research: Technical research write-up. Inputs: `topic`, `constraints`, `task_id`.
  - implement-task: Implementation notes for code changes. Inputs: `task_description`, `targets`, `task_id`.
- Typical flows:
  - “use virtual agents → review-docs-tests with git changes”
  - “run code-map-update-inplace since 2025-08-01”
  - “research: Compare MonoGame vs WPF 3D”

---

## Overview
This repository provides a local virtual-agents framework via `agents/registry.yaml` and `agents/playbooks/`. Each playbook sequences agents to generate artifacts in `Docs/` (reviews, docs, tests, security, performance, code map updates, etc.).

When you ask to use agents, I route work through a playbook and keep you updated. Artifacts are saved under `Docs/` in purpose-specific folders.

## Playbooks

### review-docs-tests
- Steps: `code-reviewer` → `documentation-specialist` → `test-generator`
- Inputs: `changed_files`, `diff_summary`, optional `task_id`
- Outputs: `Docs/reviews/{task_id}-review.md`, `Docs/docs/{task_id}-docs.md`, `Docs/tests/{task_id}-tests.md`
- Use when: You’ve changed code and want a holistic review, updated docs, and test ideas.

### performance-sweep
- Steps: `performance-optimizer` → `test-generator`
- Inputs: `changed_files`, optional `task_id`
- Outputs: `Docs/performance/{task_id}-perf.md`, `Docs/tests/{task_id}-perf-tests.md`
- Use when: You suspect bottlenecks and want a perf plan + tests.

### security-gate
- Steps: `security-auditor` → `documentation-specialist`
- Inputs: `changed_files`, optional `task_id`
- Outputs: `Docs/security/{task_id}-security.md`, `Docs/docs/{task_id}-security-notes.md`
- Use when: You need a quick OWASP-aligned security pass and notes.

### code-map-update
- Steps: `codemap-backup` → `code-map-updater`
- Inputs: `changed_files`, optional `since`, optional `task_id`
- Outputs: backup at `Docs/codemap/backups/{task_id}-CodeMap.md`; draft at `Docs/codemap/{task_id}-codemap.md`
- Use when: You want a draft CodeMap update without touching the main file.

### code-map-update-inplace
- Steps: `codemap-backup` → `code-map-updater`
- Inputs: `changed_files`, optional `since`
- Outputs: backup at `Docs/codemap/backups/{timestamp}-CodeMap.md`; updates `Docs/CodeMap.md` directly
- Use when: You’re ready to update the authoritative CodeMap.

### research
- Steps: `research-assistant`
- Inputs: `topic`, optional `constraints`, optional `task_id`
- Outputs: `Docs/research/{task_id}-research.md`
- Use when: You need a comparative analysis, best practices, or solution designs.

### implement-task
- Steps: `software-engineer`
- Inputs: `task_description`, optional `targets`, optional `task_id`
- Outputs: `Docs/changes/{task_id}-impl-notes.md`
- Use when: Implementing or refactoring code with rationale captured.

## Agents

### code-reviewer
- Purpose: Identify bugs, quality and performance issues, best-practice gaps.
- Tools: Read, Grep, Glob
- Inputs: `changed_files`, `diff_summary`
- Output: `Docs/reviews/{task_id}-review.md`
- Triggers: “review this code”, “code review”, “PR”.

### documentation-specialist
- Purpose: Create/update developer and user docs.
- Tools: Read, Write
- Inputs: `targets`, `review_findings`
- Output: `Docs/docs/{task_id}-docs.md`

### test-generator
- Purpose: Generate tests and a coverage plan.
- Tools: Read, Write
- Inputs: `changed_files`, `public_interfaces`
- Output: `Docs/tests/{task_id}-tests.md`

### security-auditor
- Purpose: Identify vulnerabilities and compliance issues (OWASP).
- Tools: Read, Grep
- Inputs: `targets`
- Output: `Docs/security/{task_id}-security.md`

### performance-optimizer
- Purpose: Analyze performance, detect bottlenecks, propose optimizations.
- Tools: Read, Grep
- Inputs: `targets`
- Output: `Docs/performance/{task_id}-perf.md`

### code-map-updater
- Purpose: Maintain and update CodeMap.md per CLAUDE_CodeMap.md standards.
- Tools: Read, Grep, Glob, Write
- Inputs: `targets`, `since`
- Output: Draft or in-place CodeMap update depending on playbook.
- Notes: Always back up first via `codemap-backup` in our playbooks.

### research-assistant
- Purpose: Research technologies/approaches; produce actionable recommendations.
- Tools: Read, Grep, WebSearch, WebFetch
- Inputs: `topic`, `constraints`
- Output: `Docs/research/{task_id}-research.md`

### software-engineer
- Purpose: Implement features, fix bugs, refactor code.
- Tools: Read, Grep, Glob, Write
- Inputs: `task_description`, `targets`
- Output: `Docs/changes/{task_id}-impl-notes.md`

### codemap-backup (internal)
- Purpose: Create `Docs/codemap/backups/{timestamp}-CodeMap.md` ensuring directories exist.
- Tools: Read, Write

## Conventions and Outputs
- All artifacts live under `Docs/` in category subfolders (`reviews/`, `docs/`, `tests/`, `security/`, `performance/`, `codemap/`, `research/`, `changes/`).
- `task_id` defaults to a timestamp if not provided.
- Playbooks maintain step outputs and pass them to subsequent steps automatically.

## Bootstrapping and Setup
- Bootstrap script paths:
  - In this repo: `virtual-agents/bootstrap-virtual-agents.sh <dest> [--force]`
  - After bootstrapping into a repo: `./bootstrap-virtual-agents.sh <dest> [--force]`
- What it does:
  - Ensures target Docs output directories exist (reviews, docs, tests, security, performance).
  - Copies the starter agents registry and playbooks into the destination.
  - Copies the user manual into `<dest>/Docs/agents/Virtual-Agents-User-Manual.md` when available.
  - Copies itself into the destination for reuse.
- Notes:
  - In this repository, the starter agents live under `virtual-agents/agents/`. In consuming repos, the standard layout is `./agents/`.
  - Optional flags and details are documented in the script header.

## Examples
- “use virtual agents” → I’ll list playbooks and ask for inputs.
- “use agent review-docs-tests with git changes” → I’ll detect changed files from Git and run the playbook.
- “run code-map-update-inplace since last Tuesday” → I’ll take `since` as provided and proceed.
- “research: GPU scheduling strategies for WPF image processing” → Generates a research doc in `Docs/research/`.

*** End of User Manual ***
