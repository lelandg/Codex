## Purpose
- Provide concise, repo-specific guidance for using Codex CLI (this assistant) effectively in this repository.
- Remove language/IDE-specific instructions; keep tooling-agnostic tips that fit a docs/tips repo.

# Repository Guidelines
## Project Structure
- Root docs: `README.md` (how to use these tips/utilities).
- Virtual agents: `virtual-agents/` (starter registry, playbooks, and notes).
- Documentation: `Docs/` (general docs), `Notes/` (plans and how-tos), `logs/` (agent outputs).
- Local overrides: `AGENTS.local.md` (optional, personal notes; do not put secrets here either).

## Development Notes
- This repo is documentation-first; there is no app to build or run.
- Prefer small, reviewable edits to Markdown, YAML, and shell scripts.
- Keep examples up to date with current Codex CLI behavior where possible.

## Edits & Tooling (Agents)
- Preferred: use `apply_patch` for multi-file or structured edits (clear history and reviewability).
- Allowed: use `sed` for pinpoint text fixes when patch escaping is brittle.
- Avoid destructive commands (deletes/moves) unless explicitly requested by the user.
- Keep changes scoped; don’t reformat unrelated files.

## Task Constraints (This Environment)
- Filesystem: workspace-write; keep edits within the repo.
- Network: restricted; do not perform networked installs or fetches.
- Approvals: on-request; seek approval for privileged or potentially destructive actions.
- Builds/runs: not applicable here; do not invoke external build systems by default.

## Search & Scanning Guidance
- Focus on these paths: root `*.md`/`*.yaml`/`*.sh`, `virtual-agents/`, `Docs/`, `Notes/`, `logs/` (metadata only).
- Exclude heavy/non-source folders: `.git/`, `.venv/`, `node_modules/`, `logs/` contents unless requested.
- Example ripgrep:
  - `rg -n "Pattern" --glob '!{.git,.venv,node_modules,logs}/**' -tmd -tyaml -tshell` 

## Commit & PR Guidelines
- Commits: short imperative subject, optional scope.
  - Examples: `Docs: clarify setup`, `Agents: add review playbook`, `Notes: update usage tips`.
- PRs: explain rationale, list changed areas, add before/after snippets when helpful.
- Keep diffs focused; prefer incremental updates over large rewrites.

## Security & Configuration
- Do not commit secrets or API keys.
- If adding scripts, prefer safe defaults and clear prompts for any irreversible actions.
- Keep example commands generic and non-destructive.

## Using This Repo With Codex CLI
- Open the repo in Codex CLI and browse `README.md` for the entry points.
- In this repository, the agents live under `virtual-agents/agents/` (this repo publishes a starter agents package rather than using a root `./agents/` folder).
- For virtual agents here, see `virtual-agents/README.md` and `virtual-agents/agents/registry.yaml`.
- When working in other projects, assume the standard root layout `./agents/registry.yaml` and `./agents/playbooks/` unless specified otherwise.
- Ask Codex to "use the virtual agents in this repo" when you want orchestrated reviews or docs/testing outputs in `Docs/`.

## Local Overrides (Optional)
- Put personal workflow notes in `AGENTS.local.md` if desired.
- Keep it machine-agnostic and free of secrets; it is committed to git in this repo.

## Agent Assistance
You are Codex CLI assisting in a repo that uses local virtual agents.
Path resolution rules for this repository vs. others:
- In this repository: treat `virtual-agents/agents/` as the agents root (registry + playbooks).
- In other repositories: default to the standard root `./agents/` path.

If an agents root (per above) contains `registry.yaml` and `playbooks/`, adopt these rules for the session:
- When I say "use the virtual agents", confirm and route work via the playbooks in the resolved `playbooks/` directory.
- Execute playbooks step-by-step, passing inputs between steps as defined.
- Write artifacts to `Docs/` as specified by the playbook (e.g., reviews/docs/tests/security/performance).
- Append brief run summaries suitable for logging.
  If no agents root is found but `Notes/Virtual-Agents-Implementation-Plan.md` exists, ask if you should bootstrap the files.
  Acknowledge with: "Using virtual agents (virtual-agents/agents/)." in this repo, or "Using virtual agents (agents/)." in repos with the standard layout, then ask for a playbook name and inputs.

### Help and Manual
- On hearing any of: "use virtual agents", "use agents", "use agent", or a direct agent/playbook name, first enable agents and display the quick help summary from `Docs/agents/Virtual-Agents-User-Manual.md` (top section), then proceed to collect inputs and run the chosen playbook.
- User manual: `Docs/agents/Virtual-Agents-User-Manual.md`
    - For this repo, the bootstrap script lives at `virtual-agents/bootstrap-virtual-agents.sh` (not `Scripts/`). Use it if you want to copy the manual or the starter set elsewhere.
    - The manual lists all playbooks, their inputs/outputs, and trigger phrases.
