# AGENTS.local (Codex repo)
Local, machine-agnostic working notes for this documentation-first repo. No secrets or credentials.

## Quick Links
- CodeMap: `Docs/CodeMap.md`
- Manual: `Docs/agents/Virtual-Agents-User-Manual.md`
- Agents (this repo): `virtual-agents/agents/` (starter package)

## Repo Intent
- This repository publishes a reusable set of Codex virtual agents (starter registry + playbooks) under `virtual-agents/agents/`.
- When applying these agents to other projects, use the standard root `./agents/` layout.

## Day-to-Day
- Codemap updates: edit `Docs/CodeMap.md`; keep drafts under `Docs/codemap/` and back up to `Docs/codemap/backups/` when making major changes.
- Reviews/docs/tests via agents: if orchestrating locally in this repo, point to `virtual-agents/agents/`; write outputs under `Docs/` (reviews, docs, tests, security, performance).
- Keep edits small and focused; prefer `apply_patch` for structured changes. Use `sed` only for precise one-liners.

## Scanning Defaults
- Focus: root `*.md`/`*.yaml`/`*.sh`, `virtual-agents/`, `Docs/`.
- Exclude: `.git/`, `.idea/`, `node_modules/`, `logs/` contents unless requested.
- Ripgrep example:
  - `rg -n "Pattern" --glob '!{.git,.venv,node_modules,logs}/**' -tmd -tyaml -tshell`

## Constraints
- No builds or runtime here; it’s a docs/tips repo.
- Workspace-write only; no network fetches or installs.
- Avoid destructive operations unless explicitly asked.

## Active Notes
- Consider adding `code-map-update` and `code-map-update-inplace` playbooks to the starter set if codemap workflows prove useful.
- If needed, copy `virtual-agents/agents/` to a target project’s root as `./agents/` to enable standard autodiscovery.

## Contributor
- Name/Handle: Leland
- Time zone: CST
- Contact: aboogieman@gmail.com

