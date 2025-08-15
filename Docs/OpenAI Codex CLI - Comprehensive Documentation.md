# OpenAI Codex CLI – Comprehensive Guide

## Overview
OpenAI **Codex CLI** is an open-source command-line tool that serves as a local AI coding assistant. It leverages OpenAI’s latest reasoning models to help developers write, modify, and understand code directly from the terminal. Unlike cloud-based coding agents, Codex CLI runs entirely on your machine – reading and editing files locally – so your code stays private unless you choose to share it.

**Key Features:**
- **Zero-Setup Installation:** Install via `npm install -g @openai/codex` or Homebrew. Minimal config.
- **Terminal-Native Interface:** Work fully from the terminal without switching context.
- **Multimodal Inputs:** Accepts text and images for coding tasks.
- **Approval Modes:** Suggest, Auto Edit, Full Auto – varying degrees of autonomy.
- **Local Execution & Sandbox:** Runs commands locally in safe isolation.
- **No Cloud Code Uploads:** Your source stays local.
- **Open-Source and Extensible:** Available on GitHub.
- **Cross-Platform:** macOS, Linux, and Windows via WSL2.
- **Model Flexibility:** Use default o4-mini or specify another model.

---
## CLI Commands and Help Reference
- `codex` – Launch interactive TUI chat session.
- `codex "prompt"` – Start with an initial prompt.
- `codex exec "task"` – Run a single instruction and exit.
- `codex login` – Authenticate with ChatGPT account.
- `codex logout` – Remove stored credentials.
- `codex --upgrade` – Update to latest version.
- `codex --version` – Show CLI version.
- `codex mcp` – Launch as Model Context Protocol server.

**Common Flags:**
- `--suggest`, `--auto-edit`, `--full-auto` – Set approval mode.
- `-m`, `--model` – Choose model.
- `-a`, `--ask-for-approval` – Confirm each action.
- `-q`, `--quiet` – Reduce verbosity.
- `--config key=value` – Override config for this run.

**Interactive Session Commands:**
- `/init` – Generate starter AGENTS.md
- `/status` – Show session details
- `/diff` – Show current git diff
- `/prompts` – Example prompts
- `/mode` – Switch approval mode
- `/help` – List commands
- `Ctrl+C` – Cancel current task

---
## Approval Modes
- **Suggest:** Read-only; always asks for approval.
- **Auto Edit:** Can modify files; asks before running commands.
- **Full Auto:** Can modify files and run commands in sandbox autonomously.

---
## AGENTS.md vs AGENTS.local.md
**AGENTS.md:** Shared project or personal global file giving Codex context and guidelines. Loaded automatically from global, repo root, and local dir (merged).

**AGENTS.local.md:** Private/local-only file for personal preferences or sensitive info. Typically git-ignored. Not loaded automatically; must be merged manually or used via global AGENTS.md.

---
## Configuration & Environment
Config file: `~/.codex/config.toml` (also supports YAML/JSON). Key settings:
- `model`, `model_provider`, `reasoningEffort`
- `history.maxSize`, `disable_response_storage`
- `fullAutoErrorMode`, `notify`
- Profiles for quick switching
- MCP servers for external tool integration

Environment variables:
- `OPENAI_API_KEY`, `OPENROUTER_API_KEY`, `GEMINI_API_KEY`
- `.env` file support
- `RUST_LOG` for debugging
- `NO_COLOR` to disable ANSI

---
## Usage Patterns
- Start in Suggest mode to verify changes.
- Use Auto Edit for safe batch edits.
- Use Full Auto for complex, iterative tasks.
- Always keep projects under version control.
- Commit before and after AI-assisted changes.
- Use `/diff` to review.

---
## Practical Examples
- **Explore codebase:** "Summarize this repo."
- **Bug fix:** Paste failing test and say "Fix this bug."
- **Add feature:** "Add GET /users/{id}/settings endpoint with test."
- **Refactor:** "Rename OldManager to NewManager across repo."
- **Docs:** "Generate docstrings for utils.py."

---
## Resources
- [OpenAI Codex CLI GitHub](https://github.com/openai/codex)
- [OpenAI Help Center – Getting Started](https://help.openai.com/en/articles/11096431-openai-codex-cli-getting-started)
- [OpenAI Blog – Introducing Codex](https://openai.com/index/introducing-codex)
- [Kevin Leary Blog](https://www.kevinleary.net/blog/openai-codex-cli/)
