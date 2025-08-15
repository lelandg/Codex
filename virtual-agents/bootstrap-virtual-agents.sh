#!/usr/bin/env bash
set -euo pipefail

DEST=""
SRC_DIR=$(cd "$(dirname "$0")/.." && pwd)
TPL_DIR="$SRC_DIR/templates/virtual-agents"

usage() {
  echo "Usage: $0 DEST_DIR [--force]" >&2
  echo "\nBootstraps the local Virtual Agents scaffold into DEST_DIR." >&2
  echo "\nOptions:" >&2
  echo "  --force   Overwrite existing files" >&2
  exit 1
}

FORCE=false
for arg in "$@"; do
  if [[ "$arg" == "--force" ]]; then
    FORCE=true
  elif [[ -z "${DEST}" ]]; then
    DEST="$arg"
  fi
done

if [[ -z "${DEST}" ]]; then
  usage
fi

mkdir -p "$DEST"

copy_file() {
  local rel="$1"
  local src="$TPL_DIR/$rel"
  local dst="$DEST/$rel"
  mkdir -p "$(dirname "$dst")"
  if [[ -e "$dst" && "$FORCE" != true ]]; then
    echo "Skip existing: $rel (use --force to overwrite)"
  else
    cp -f "$src" "$dst"
    echo "Copied: $rel"
  fi
}

# Agents registry and playbooks
copy_file agents/registry.yaml
copy_file agents/playbooks/review-docs-tests.yaml
copy_file agents/playbooks/security-gate.yaml || true
copy_file agents/playbooks/performance-sweep.yaml || true

# Docs structure (.gitkeep files)
for f in Docs/reviews/.gitkeep Docs/docs/.gitkeep Docs/tests/.gitkeep Docs/security/.gitkeep Docs/performance/.gitkeep; do
  mkdir -p "$DEST/$(dirname "$f")"
  : > "$DEST/$f"
  echo "Ensured: $f"
done

# Logs structure
mkdir -p "$DEST/logs/agents"
: > "$DEST/logs/agents/.gitkeep"
echo "Ensured: logs/agents/.gitkeep"

# Plan document
copy_file Notes/Virtual-Agents-Implementation-Plan.md
copy_file AGENTS.md
copy_file Notes/Codex-Virtual-Agents-Prompt.md

# Copy this bootstrap script into the target directory
SELF_NAME="$(basename "$0")"
cp -f "$0" "$DEST/$SELF_NAME"
chmod +x "$DEST/$SELF_NAME" || true
echo "Copied: $SELF_NAME (into $DEST)"

echo "\nBootstrap complete. Review files under: $DEST"
echo "\nCopy/paste this to initialize Codex in a new session:"
echo "-----------------------------------------------------------------"
if [[ -f "$DEST/Notes/Codex-Virtual-Agents-Prompt.md" ]]; then
  sed -n '1,200p' "$DEST/Notes/Codex-Virtual-Agents-Prompt.md"
else
  echo "Use the local virtual agents. Run playbook review-docs-tests with task_id: YYYYMMDD-001, changed_files: [...], diff_summary: '...'."
fi
echo "-----------------------------------------------------------------"
