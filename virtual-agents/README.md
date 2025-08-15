# Virtual Agents Starter Repo

A minimal, ready-to-publish repository with virtual agents, starter playbooks, output folders, and a setup plan.

## What’s Included
- `agents/registry.yaml`: Core agent definitions
- `agents/playbooks/`: `review-docs-tests`, `security-gate`, `performance-sweep`
- `Docs/`: Output folders for reports
- `logs/agents/`: Placeholder for run logs
- `Notes/Virtual-Agents-Implementation-Plan.md`: How to use and extend

## Getting Started
1) Create a new repo and copy these files (or `git init` here):
   - `git init`
   - `git add . && git commit -m "init virtual agents starter"`
2) Open `agents/registry.yaml` and tweak for your stack (tools, outputs).
3) Run a pilot using the prompts in the Plan doc.

## Use In An Existing Repo
You can use this by just copying the files — no script required.
1) Create a feature branch in your existing repo:
   - `git checkout -b chore/virtual-agents-setup`
2) Copy these folders/files into the repo root (merge if folders exist):
   - `agents/` (registry + playbooks)
   - `Docs/` (ensures subfolders: `reviews`, `docs`, `tests`, `security`, `performance`)
   - `Notes/Virtual-Agents-Implementation-Plan.md`
   - `logs/agents/` (create if missing)
   Example from this starter dir:
   - `rsync -av --exclude .git ./ /path/to/existing-repo/`
3) Commit:
   - `git add agents Docs Notes logs && git commit -m "add virtual agents + playbooks"`
4) Pilot a playbook manually (see below), then iterate on `agents/registry.yaml`.

Optional: Use the bootstrap script to copy the starter into another repo:
- From this repo: `virtual-agents/bootstrap-virtual-agents.sh /path/to/existing-repo [--force]`
- After bootstrapping (inside the target repo): `./bootstrap-virtual-agents.sh /another/target [--force]`
  - The script copies itself into the destination for reuse.
  - It also copies the user manual to `<dest>/Docs/agents/Virtual-Agents-User-Manual.md` when available.

## Running Manually (LLM Orchestration)
- Choose a playbook (e.g., `review-docs-tests`).
- Provide `changed_files` and a short `diff_summary`.
- Ask your LLM to act as orchestrator using the prompt template in `Notes/Virtual-Agents-Implementation-Plan.md` and produce artifacts in `Docs/`.

Example context for a manual run:
```
playbook: review-docs-tests
task_id: 2025-08-14-001
changed_files: ["src/app/services/contact.service.ts", "src/app/pages/product-details/product-details.component.ts"]
diff_summary: "Refactor ContactService logging; fix product details video handling."
```

Expected outputs:
- `Docs/reviews/<task_id>-review.md`
- `Docs/docs/<task_id>-docs.md`
- `Docs/tests/<task_id>-tests.md`

## First-Time Setup: Codex CLI
- Install Node.js 20.19+ (match your project engines).
- Install or open Codex CLI (per your local setup).
- Open the repository in Codex CLI and say:
  - "Use the local virtual agents. Run playbook review-docs-tests with task_id: YYYYMMDD-001, changed_files: [...], diff_summary: '...'."
- Codex looks for `agents/registry.yaml` and `agents/playbooks/*.yaml` by default; it will write outputs under `Docs/`.

Tips
- If `agents/` is missing but `Notes/Virtual-Agents-Implementation-Plan.md` exists, ask Codex to "bootstrap the virtual agents from the Plan".
- Keep `agents/` in the repo so future sessions autodiscover.

## First-Time Setup: Claude Code
If you prefer Claude Code with custom agents:
- Ensure your Claude agents repo is installed/configured (you mentioned you have one).
- Typical Claude agent locations:
  - Global: `~/.claude/agents/` and `~/.claude/CLAUDE.md`
  - Project override: `./CLAUDE.md`
- Add a short note in `CLAUDE.md`:
  - "Virtual agents present in this repo. Registry: `agents/`; Playbooks: `agents/playbooks/`."
- Invoke in Claude:
  - "Use the code-reviewer agent on this repo," or
  - "Run the review-docs-tests flow using the local registry and produce artifacts in Docs/."

## Next Steps
- Add CI hooks to trigger playbooks on PRs.
- Add more playbooks (release-ready, dependency audit, etc.).
- Track metrics in `logs/agents/metrics.jsonl` for continuous improvement.
