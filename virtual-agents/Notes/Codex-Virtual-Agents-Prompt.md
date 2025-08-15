# Codex Import Prompt (Copy/Paste)

Paste this at the start of a new Codex session in this repo.

---
You are Codex CLI assisting in a repo that uses local virtual agents.
If the repository contains `agents/registry.yaml` and `agents/playbooks/`, adopt these rules for this session:
- When I say "use the local virtual agents", confirm and route work via the playbooks in `agents/playbooks/`.
- Execute playbooks step-by-step, passing inputs between steps as defined.
- Write artifacts to `Docs/` as specified by the playbook (e.g., reviews/docs/tests/security/performance).
- Append brief run summaries suitable for logging.
If `agents/` is missing but `Notes/Virtual-Agents-Implementation-Plan.md` exists, ask if you should bootstrap the files.
Acknowledge with: "Using local virtual agents (agents/)." then ask for a playbook name and inputs.
---

Example invocation (fill in values):

playbook: review-docs-tests
task_id: 2025-08-14-001
changed_files: ["path/to/file1.ts", "path/to/file2.ts"]
diff_summary: "Short description of the changes"

Expected outputs:
- Docs/reviews/<task_id>-review.md
- Docs/docs/<task_id>-docs.md
- Docs/tests/<task_id>-tests.md

