# CodeMap: Codex Repository

- Generated: 2025-08-15
- Purpose: High-level map of repository structure, key docs, and how virtual agents fit in.

## Overview
This repository is documentation-first with tips and utilities for using Codex CLI effectively. There is no application to build or run. It includes a "virtual-agents" starter package under `virtual-agents/` with a registry and playbooks that can be copied into a project.

Notes:
- Root-level `agents/` is not present; the starter lives in `virtual-agents/agents/`.
- The user manual for agents is present at `Docs/agents/Virtual-Agents-User-Manual.md`.
- Outputs from agents (when used) should go under `Docs/` (e.g., `Docs/reviews/`, `Docs/docs/`, `Docs/tests/`, `Docs/security/`, `Docs/performance/`).

## Top-Level Layout
```
./
├─ README.md                 # Repo purpose and usage guidelines
├─ AGENTS.md                 # Repo-specific agent usage and rules
├─ AGENTS.local.md           # Personal/local notes (committed; avoid secrets)
├─ Docs/
│  └─ agents/
│     └─ Virtual-Agents-User-Manual.md  # Triggers and playbook descriptions
├─ virtual-agents/           # Starter kit for virtual agents
│  ├─ README.md              # How to adopt the starter
│  ├─ AGENTS.md              # Notes and invocation guidance for agents
│  ├─ agents/
│  │  ├─ registry.yaml       # Agent definitions (starter)
│  │  └─ playbooks/          # review-docs-tests, security-gate, performance-sweep
│  ├─ Docs/                  # Starter output folders (empty placeholders)
│  ├─ Notes/
│  │  ├─ Virtual-Agents-Implementation-Plan.md
│  │  └─ Codex-Virtual-Agents-Prompt.md
│  ├─ logs/agents/           # Placeholder for run logs
│  └─ bootstrap-virtual-agents.sh
├─ .gitignore, .gitattributes
└─ .idea/                    # Editor settings (exclude from scans)
```

## Key Documents
- `README.md`: Repo purpose, structure, guidelines, and how to use Codex here.
- `AGENTS.md`: Session rules and triggers; how to route work via playbooks; references the user manual.
- `AGENTS.local.md`: Local working notes copied from another project (C#-heavy); keep as personal context only.
- `Docs/agents/Virtual-Agents-User-Manual.md`: Quick help for triggers and available playbooks.
- `virtual-agents/README.md`: How to copy the starter agents into an existing repo and run playbooks.
- `virtual-agents/agents/registry.yaml`: Agent IDs and outputs for the starter set.
- `virtual-agents/agents/playbooks/*.yaml`: Starter playbooks (no codemap playbook included by default).

## Virtual Agents (Starter)
- Starter location: `virtual-agents/agents/` (not auto-discovered by tools that expect `./agents/`).
- Provided playbooks: `review-docs-tests`, `security-gate`, `performance-sweep`.
- Missing from starter: CodeMap playbooks mentioned in the manual (`code-map-update`, `code-map-update-inplace`).
- How to enable in this repo:
  - Option A: Copy `virtual-agents/agents/` to repo root as `agents/`.
  - Option B: Update your tooling to point at `virtual-agents/agents/`.
  - Option C: Keep ad-hoc runs (like this codemap) without installing playbooks.

## Agent Outputs (Conventions)
When running playbooks, write artifacts to `Docs/`:
- `Docs/reviews/{task_id}-review.md`
- `Docs/docs/{task_id}-docs.md`
- `Docs/tests/{task_id}-tests.md`
- `Docs/security/{task_id}-security.md`
- `Docs/performance/{task_id}-perf.md`
- CodeMap drafts (this run): `Docs/codemap/<date>-codemap.md`

## Scanning Defaults for This Repo
- Focus paths: root `*.md`/`*.yaml`/`*.sh`, `virtual-agents/`, `Docs/`.
- Exclude: `.git/`, `.idea/`, `logs/` contents unless requested.

## Observations and Gaps
- There is no `agents/` at the repo root; only the starter under `virtual-agents/`.
- The manual lists CodeMap playbooks, but they are not present in the starter playbooks.
- `AGENTS.local.md` contains MeshForge/C#-specific content; treat it as personal notes and not authoritative for this repo.

## Suggested Next Steps
- Decide whether to adopt the starter agents:
  - Copy `virtual-agents/agents/` → `agents/` to enable playbooks.
  - Add the CodeMap playbooks if desired (`code-map-update`, `code-map-update-inplace`).
- Keep artifacts organized under `Docs/` and add `Docs/codemap/` to track future codemap updates.
- If you want in-place updates: create `Docs/CodeMap.md` and back it up before each change.

---
Generated ad hoc by Codex CLI (no playbook execution).

