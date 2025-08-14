## Comments
  - This is my AGENTS.md file from my MeshForge C# project. (Adapted from my Claude Code config.)
  - If you don't have one, you can copy this to your project root. 
  - If you're using a language other than C#, you can remove a lot of this. 
  - Or, to use for Python, for example, copy it and then tell Codex to:

    `update your agent instructions to remove the C# specific stuff and configure for Python.`

# Repository Guidelines
## Project Structure & Module Organization
- Source: root C# WPF app targeting `net8.0-windows` (`MeshForge.csproj`).
- UI: XAML in `MainWindow.xaml` (+ partial `MainWindow.*.cs`), assets in `Resources/` and `Images/`.
- Logic: helpers in `Utilities/`, domain features in `Services/`, mesh tooling in `MeshTools/`.
- Python integration: per-model wrappers under `PythonModels/`, helper scripts in `Scripts/`.
- Data & models: `Models/`, `Weights/`, and CSVs (e.g., `depth_models.csv`).
- Installer: `Installer/`; logs in `logs/`.
## Build, Test, and Development Commands
- Build (PowerShell): `./build.ps1 -Configuration Release`
  - Restores NuGet, builds, and writes logs to `logs/`.
- Build (CLI): `dotnet build MeshForge.sln -c Debug`
- Run (Windows): `dotnet run --project MeshForge.csproj -c Debug`
  - Produces `bin/<Config>/net8.0-windows/MeshForge.exe`.
 - Python setup (optional models/UI):
   - Windows PowerShell: `python -m venv .venv && .\\.venv\\Scripts\\pip install -r requirements.txt`
   - WSL/Linux (this shell): `python3 -m venv .venv && ./.venv/bin/pip install -r requirements.txt`

### Quick Build Error Filters (Windows/WSL)
Only run these when explicitly asked to build. These capture compiler/link errors without the full log noise.

PowerShell (recommended on Windows):
```
cd D:\Documents\Code\GitHub\.Net\MeshForge
dotnet build MeshForge.csproj 2>&1 | Select-String -Pattern 'error CS[0-9]+','error MSB[0-9]+'
```

Command Prompt (CMD):
```
cd /d D:\Documents\Code\GitHub\.Net\MeshForge
dotnet build MeshForge.csproj 2>&1 | findstr /r /c:"error CS[0-9][0-9]*" /c:"error MSB[0-9][0-9]*"
```

WSL (grep):
```
cd /mnt/d/Documents/Code/GitHub/.Net/MeshForge
dotnet build MeshForge.csproj 2>&1 | grep -E "error CS[0-9]+|error MSB[0-9]+"
```

Helper scripts (in `Scripts/`):
- `Scripts/Build-Errors.ps1`: `pwsh -File .\Scripts\Build-Errors.ps1 [-Configuration Release]`
- `Scripts/build-errors.cmd`: `Scripts\build-errors.cmd -c Release`
  - Both scripts `cd` to repo root and target `MeshForge.csproj` by default.

### Rider Build & Output (Agents)
- Open solution: `MeshForge.sln` in JetBrains Rider (Windows).
- Build: Build → Build Solution (Ctrl+F6) or Rebuild Solution.
- Build output: View → Tool Windows → Build → toggle "Console View" for full MSBuild logs.
- Verbosity: Settings → Build, Execution, Deployment → Toolset and Build → enable "Write MSBuild log to output" and adjust verbosity if needed.
- WPF note: `Console.WriteLine` does not appear under Rider Debug output; prefer `System.Diagnostics.Debug.WriteLine` or the app `LoggingService` for runtime messages. Inspect via Run/Debug tool window Output/Debug tabs and DiagnosticsWindow in-app.
- Reference: see `Notes/Rider_WPF_Build_Methods.md` for details and alternatives.
- Artifacts: built executable at `bin/<Config>/net8.0-windows/MeshForge.exe`; `dotnet publish` outputs under `bin/<Config>/net8.0-windows/publish/`.

#### Rider Build Troubleshooting
- Clean/restore: Build → Clean Solution, then right-click solution → Restore NuGet Packages.
- Verify SDK: Settings → Build, Execution, Deployment → Toolset and Build → .NET CLI path; ensure `dotnet --info` shows .NET 8; restart Rider after installing SDKs.
- MSBuild/Toolset: In the same Toolset page, confirm MSBuild is detected; set a custom path only if needed.
- ReSharper Build: If unexpected rebuilds or stalls, toggle "Use ReSharper Build" in Toolset and Build to compare behavior.
- NuGet sources: Settings → NuGet → Package Sources → ensure `nuget.org` enabled and authenticated if required; retry restore.
- Config/platform: Ensure `MeshForge.csproj` targets `net8.0-windows`; use Any CPU and correct Debug/Release config.
- Windows-only: WPF builds and runs on Windows; avoid Linux/macOS runtime for execution.
- Last resort: File → Invalidate Caches / Restart; re-open solution and rebuild with Console View + increased verbosity.
## Coding Style & Naming Conventions
- C#: 4 spaces, `nullable` enabled, implicit usings on.
- Naming: PascalCase for types/methods; camelCase for locals/parameters; `_camelCase` for private fields.
- XAML: keep view logic in code-behind partials; prefer MVVM-friendly patterns in `MainViewModel.cs`.
- Formatting: follow existing file layout; avoid one-letter identifiers; keep methods focused.
## Testing Guidelines
- Current state: no formal unit test project is present.
- Preferred: add `MeshForge.Tests` (xUnit), name files `<TypeName>Tests.cs`, method names `Method_Condition_Expected`.
- Manual checks: launch app, import an image, run shape completion, verify viewport, export PLY.
## Commit & Pull Request Guidelines
- Commits: short imperative subject, optional scope.
  - Examples: `Improve Python model integration`, `Fix mesh winding on export`, `UI: refine camera restore`.
- PRs: clear description, rationale, steps to test, screenshots/GIFs for UI, and link issues (e.g., `Closes #123`).
- Keep diffs focused; explain model/weight changes and large asset additions.
## Security & Configuration Tips
- Platform: Windows x64 with .NET 8 SDK; WPF requires Windows to run.
- GPU/ONNX: ensure CUDA/CuDNN compatible drivers; DLLs live under `runtimes/`.
- Secrets: do not commit API keys or licenses; check `.gitignore` before adding new files.

## Edits & Tooling (Agents)
- Preferred: use `apply_patch` for multi-file or structured edits (clear history and reviewability).
- Patching tools: `makepatch` is available; you may use `applypatch` (CLI) when your environment supports it. In this repo’s agent harness, `apply_patch` is the primary tool, but `applypatch`/makepatch workflows are acceptable when preferred and supported.
- Allowed: use `sed` or focused shell edits for pinpoint fixes (e.g., complex regex/string literal changes) when `apply_patch` context is fragile due to escaping.
- C# regex strings: prefer verbatim strings `@"..."` and double the quotes inside (`""`) to avoid backslash explosions. Consider assigning long patterns to a variable before calling `Regex.Match` for clarity.
- XAML theming: merge `Themes/SharedResources.xaml` and `Themes/Styles/CommonStyles.xaml` at the window scope for design-time defaults; runtime themes override via `ThemeManager`.

### Build/Run Constraints (Agents)
- Do not run `dotnet build`, `dotnet restore`, or app execution commands by default.
- Avoid any networked build steps (NuGet restore) or long-running builds in this environment.
- Only attempt a build/run when the user explicitly asks for it.
- Prefer static code edits and targeted scans; report verification steps for the user to run locally.

## Search & Scanning Guidance
- Prefer the project code map (`Docs/CodeMap.md`) to target locations before running broad searches.
- Limit searches to source paths; avoid build/output folders to keep runs fast and noise-free.
- Default include paths (typical repos like this): root C# files (`*.cs`, `*.xaml`), `Utilities/`, `Services/`, `MeshTools/`, `Models/`, `Views/`, `Themes/`, `UiSettings/`, `PythonModels/`, `Scripts/`.
- Default exclude paths: `bin/`, `obj/`, `.venv/`, `node_modules/`, `logs/`, `Weights/`, `runtimes/`, `Images/`, `Resources/`, `Installer/`, `temp/`, `__pycache__/`.
- Example ripgrep command:
  - `rg -n "Pattern" --glob '!{bin,obj,node_modules,logs,Weights,runtimes,Images,Resources,Installer,temp,__pycache__,.venv}/**' --type-add 'wpf:*.xaml' -tcs -twpf`

## Screenshots and Analysis Guidelines
- Screenshot locations: primary on host (Windows) `C:\Users\aboog\Pictures\Screenshots\2025`; WSL path: `/mnt/e/Pictures/Screenshots/2025`.
- To list the newest N screenshots from that folder (example 3): `ls -lt | grep "\.png" | head -3 | awk '{print $9}'`.
- When referred to “screenshot” (singular), inspect the newest by timestamp.
- When referred to “# screenshots”, consider only the # newest; analyze newest first.
- Read the next older screenshot only if needed to complete the task.
- You can correlate screenshot timestamps with log entries for context.
