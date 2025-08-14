## Comments
- This is my AGENTS.md file from my MeshForge C# project. (Adapted from my Claude Code config.)
- If you don't have one, you can copy this to your project root.
- If you're using a language other than C#, you can remove a lot of this.
- Or, to use for Python, for example, copy it and then tell Codex to:

  `update your agent instructions to remove the C# specific stuff and configure for Python.`

# Local Working Notes (No Secrets)

## Quick Links
- Code map: `Docs/CodeMap.md`
- Build: `./build.ps1 -Configuration Release` (or Debug)
- Run: `dotnet run --project MeshForge.csproj -c Debug`
- Key CSVs: `depth_models.csv`, `PythonShapeCompletionModels.csv`, `symmetry_models.csv`
- Models: `Models/`, `PythonModels/`, `Weights/`
- Scripts: `Scripts/model_installer.py`, `Scripts/model_downloader.py`, `Scripts/shape_completion.py`
- Logs: `logs/`, Python UI logs: `shape_completion_ui_*.log`

## Procedures & Agents
- CodeMap updates: Check last modified date; use `git log`/`git diff` to find changes and update relevant sections.
- CodeMap authoring: Follow specs in `~/.claude/CLAUDE_CodeMap.md` when editing any `CodeMap.md`.
- Startup check: If `./CLAUDE.md` exists and `./Docs/CodeMap.md` is missing, offer to create it.
- Startup check: Read `ActiveTasks.md` for current tasks; prompt to proceed with item 1.

### Local Agent Constraints
- Do not try to build or run the app automatically.
- Skip `dotnet build`/`restore` unless I explicitly request it.
- Prefer code edits + guidance; I will run builds locally as needed.

### Editing Guidelines (Local override)
- Use `apply_patch` for most edits; it’s review-friendly and safe. `makepatch` is available here, so `applypatch` (CLI) can also be used when convenient.
- It is OK to use `sed` for precise, delicate string edits (e.g., regex literals with heavy escaping) when patch hunks get brittle.
- Regex tip: convert complex patterns to verbatim strings and store in a variable. Example from `Services/DownloadManager.cs` fix:
  - Before: inline normal string with many `\\` and `\"` escapes.
  - After: `var hrefPattern = @"href=""(?<href>(?:https?://[^"]+)?/uc\?[^""]*export=download[^""]*)""");`
    - Verbatim string `@"..."`
    - Double double-quotes to represent `"` in the pattern
    - Minimal backslashes: only those required by regex semantics
    - Assigned to a variable, then `Regex.Match(html, hrefPattern)`
  - Same approach applied to the `<a id="uc-download-link" ... href="...">` pattern and `confirm`/`id` tokens.

## Active Tasks
- Primary tracker: `ActiveTasks.md` (root). On startup, prompt: “Proceed with Active Tasks item 1?”
- Details/background: `Notes/Feature-Plan-Model-Weights-Downloads.md` → “Next Steps (Actionable)”.

### Code Scanning Defaults (MeshForge)
- Prefer targeted navigation via `Docs/CodeMap.md` over recursive greps.
- When searching, include only code directories/files:
  - Root `*.cs`, `*.xaml`, and partials `MainWindow.*.cs`
  - `Utilities/`, `Services/`, `MeshTools/`, `Models/`, `Views/`, `Themes/`, `UiSettings/`
  - Python: `PythonModels/`, `Scripts/`
- Exclude heavy/non-code paths from scans by default:
  - `bin/`, `obj/`, `.venv/`, `node_modules/`, `logs/`, `Weights/`, `runtimes/`, `Images/`, `Resources/`, `Installer/`, `temp/`, `__pycache__/`
- If a broad search is unavoidable, use ripgrep with globs, e.g.:
  - `rg -n "YourPattern" --glob '!{bin,obj,node_modules,logs,Weights,runtimes,Images,Resources,Installer,temp,__pycache__,.venv}/**' --type-add 'wpf:*.xaml' -tcs -twpf`

Shortcuts
- Bash/WSL: `Scripts/search.sh "Pattern" [Path]` (adds fast excludes; uses ripgrep if available, falls back to grep)
- PowerShell: `./Scripts/Search.ps1 "Pattern" [Path] [-IgnoreCase] [-Context N] [-Literal]`
- PowerShell alias: run once `./Scripts/Add-SearchAlias.ps1`, then use `s "Pattern"` anywhere in the repo


Use this file to record your personal preferences and repo-specific context. Keep it concise; avoid credentials, API keys, or license files.

## Contributor Profile
- Name/Handle: Leland
- Contact/Time zone: aboogieman@gmail.com/CST
- Typical focus areas (UI, mesh, Python models, installer): Everything

## Environment
- OS/Version:
- .NET SDK: `dotnet --info` 
- GPU/Driver/CUDA/CuDNN: 
- Editor/IDE & formatting settings: JetBrains Rider, default C# settings
- Python version & venv: Python 3.12.3

## Preferred Workflow
- Build (Rider): Build → Build Solution (Ctrl+F6); open Build tool window and enable Console View for full logs. If needed, increase verbosity via Settings → Build, Execution, Deployment → Toolset and Build → "Write MSBuild log to output".
- Run (Rider): Use default Run/Debug configuration for `MeshForge` (WPF); view Output/Debug tabs for app logs.
- Build (script): `./build.ps1 -Configuration Debug` (writes to `logs/`).
- Run (CLI): `dotnet run --project MeshForge.csproj -c Debug`
- Debugging: (e.g., Rider launch profile, attach to `MeshForge.exe`)
- Python venv: In this shell Python is `python3`: `python3 -m venv .venv && .\\.venv\\Scripts\\pip install -r requirements.txt`

## Project References
- Navigation: See `Docs/CodeMap.md` for file/class locations and line refs.
- Dev commands (Claude): `~/.claude/MeshForge_Development_Commands.md` if present.

## Model & Execution Notes
- Recommended depth model: Depth Anything V2 Large (ViT-L).
- Execution providers: CPU, CUDA, DirectML; verify via `DiagnosticsWindow`.
- Depth models config: `depth_models.csv` → downloads into `Models/`.
- Python shape completion: models listed in `PythonShapeCompletionModels.csv`, stored under `PythonModels/`.

## Tools & Diagnostics
- DiagnosticsWindow: ONNX providers, runtime info, and model status.
- LoggingService: multi-level logging to file and UI.
- Dual mesh architecture (v1.0.27+): keeps double- and single-sided meshes.
 - WPF debug output in Rider: prefer `System.Diagnostics.Debug.WriteLine` (shows in Debug Output); `Console.WriteLine` will not appear under WPF.

## Testing Focus
- Manual checks I run before PR:
  - Import image → run shape completion → verify viewport → export PLY
  - Models I verify (e.g., `PythonModels/PoinTr`, `AdaPoinTr`):
- Datasets/inputs I commonly use (paths or notes): 
- Note: No formal unit tests are present yet.

## Conventions & Notes
- Style nudges I follow (beyond AGENTS.md):
- File naming patterns I prefer:
- Areas of the code I’m cautious about (threading, file IO, GPU):

## Current Work & Parking Lot
- Active tasks: Working on Python shape completion + model weights downloads.
  - See `Notes/Feature-Plan-Model-Weights-Downloads.md` for progress and next steps.
  - On restart, continue with:
    - Implement Google Drive confirm-token handling in `DownloadManager` (follow confirm pages to real file).
    - Add/edit mirrors UI in weights panel; allow pasting alternate URLs; persist for session.
    - Standardize Python wrappers to load checkpoints from `parameters['weights_path']`.
    - Add “View Downloads…” link in `PythonModelsWindow`; consider “Import Weights…” using `LocalWeightsImporter`.
    - Replace dialogs with non-blocking toasts/snackbars for completion/failure (Reveal/Set Active).
- Known issues: Shape completion can produce artifacts; see `Notes/AI_Shape_Completion_Review.md`.
- Blockers:
- Future ideas: Documented in various notes files in `./Notes/`

> Reminder: This file is committed by request. Do not include secrets or private data.

## Post-Change Validation Steps (WSL-friendly)
- WSL syntax validation for MeshForge (full build not possible):
  - Quick syntax-only build (matches ~/.claude guide):
    - `dotnet build --no-restore --no-dependencies MeshForge.csproj 2>&1 | head -50`
    - Expected: C# compile errors (if any) appear first, then MSB4019 about missing WindowsDesktop SDK.
  - Alternative grep for errors:
    - `dotnet build --no-restore --no-dependencies 2>&1 | grep -E "error CS|warning CS"`

- Windows quick error-only build (PowerShell):
  - `cd D:\\Documents\\Code\\GitHub\\.Net\\MeshForge; dotnet build MeshForge.csproj 2>&1 | Select-String -Pattern 'error CS[0-9]+','error MSB[0-9]+'`

- Windows quick error-only build (CMD):
  - `cd /d D:\\Documents\\Code\\GitHub\\.Net\\MeshForge && dotnet build MeshForge.csproj 2>&1 | findstr /r /c:"error CS[0-9][0-9]*" /c:"error MSB[0-9][0-9]*"`

- Shortcuts (scripts):
  - PowerShell: `pwsh -File .\\Scripts\\Build-Errors.ps1 [-Configuration Release]`
  - CMD: `Scripts\\build-errors.cmd -c Release`

- Python import dry-run (imports only; do not run UI):
  - Activate venv if present: `source .venv/bin/activate` (WSL) or `.\\.venv\\Scripts\\activate` (Windows).
  - Import check:
    - `python - << 'PY'\nimport sys; sys.path.insert(0, '.');\nimport shape_completion_ui\nprint('shape_completion_ui import: OK')\nPY`
  - If this fails due to missing GUI deps (e.g., PyQt6), install `requirements.txt` in venv or limit to non-GUI modules.

- Reference: See `~/.claude/MeshForge_Development_Commands.md` for full guidance and limitations.

## Screenshots and Analysis Guidelines
- Screenshots folder: `/mnt/e/Pictures/Screenshots/2025` (Windows: `C:\Users\aboog\Pictures\Screenshots\2025`).
- Find newest N (example 3): `ls -lt | grep \.png | head -3 | awk '{print $9}'`.
- If you say “screenshot” (singular), inspect the newest by timestamp.
- If you say “# screenshots”, consider only the # newest; analyze newest first.
- Read older screenshots only if needed to complete the task.
- Use timestamps in logs to correlate with screenshots when helpful.
