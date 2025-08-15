# Virtual Agents in This Repository

- Registry: `agents/registry.yaml`
- Playbooks: `agents/playbooks/*.yaml`
- Outputs: `Docs/`
- Plan: `Notes/Virtual-Agents-Implementation-Plan.md`

## Codex CLI
- Paste `Notes/Codex-Virtual-Agents-Prompt.md` at session start, or say:
  "Use the local virtual agents. Run playbook <name> with task_id: <id>, changed_files: [...], diff_summary: '...'."

## Claude Code
- Note in `CLAUDE.md`: "Virtual agents present. Registry: `agents/`; Playbooks: `agents/playbooks/`."
- Ask Claude to run the desired flow and write to `Docs/`.

