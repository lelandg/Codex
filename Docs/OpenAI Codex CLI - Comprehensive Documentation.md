

# OpenAI Codex CLI – Comprehensive Guide



- [Overview](#overview)
- [CLI Commands & Help](#cli-commands)
- [Approval Modes](#approval-modes)
- [AGENTS.md vs AGENTS.local.md](#agents-md)
- [Configuration & Env Vars](#configuration)
- [Examples & Workflows](#examples)
- [Further Resources](#resources)
- [^ Top](#top)



[]()

## Overview


OpenAI Codex CLIis an open-source command-line tool that acts as a local AI coding assistant. It brings the power of OpenAI’s latest code-capable models directly to your terminal:contentReference[oaicite:135]{index=135}. Codex CLI can read, modify, and even execute code on your machine to help you build features faster, fix bugs, and understand unfamiliar code – all through natural language commands. Because it runs locally, your source code never leaves your environment (unless you explicitly share it), addressing privacy concerns for proprietary code:contentReference[oaicite:136]{index=136}.


This CLI integrates into your workflow as a chat-like interface in the terminal. You prompt it in English, and it can perform tasks such as creating files, editing functions, running tests, and more, guided by your instructions. It essentially enables “pair programming” with an AI agent, without switching to a browser or editor plugin.


Key features include:


- Zero setup: Install with `npm install -g @openai/codex` (or `brew install codex`) and you’re ready to go:contentReference[oaicite:137]{index=137}. Authenticate once (via API key or ChatGPT login) and the CLI requires no complex config to start working.
- Terminal-native UI: The tool runs entirely in your terminal. It provides a text-based chat interface for conversation with the AI, so you don’t have to leave your command-line environment:contentReference[oaicite:138]{index=138}.
- Multi-modal input: You can feed not only text but also images (like screenshots or sketched diagrams) to Codex CLI, and it will interpret them to inform its code generation:contentReference[oaicite:139]{index=139}. For instance, you could paste a screenshot of an interface and ask Codex to generate HTML/CSS for it.
- Flexible autonomy (Approval Modes): You control how much freedom the AI has to make changes. In Suggest mode it only suggests actions, in Auto-Edit it makes changes to files automatically, and in Full-Auto it can even run commands by itself in a safe sandbox:contentReference[oaicite:140]{index=140}:contentReference[oaicite:141]{index=141}. This allows usage ranging from cautious (review every suggestion) to hands-off (let it complete tasks on its own).
- Local execution & sandboxing: The AI can execute shell commands and code locally to verify its changes. In Full Auto mode, these commands run in a sandboxed environment (no network access, limited to your project directory):contentReference[oaicite:142]{index=142}:contentReference[oaicite:143]{index=143}, ensuring that autonomous actions don’t harm your system or leak data.
- OpenAI-powered, multi-model support: Codex CLI uses OpenAI models (by default `o4-mini`, a Codex-optimized model). You can specify any available model like GPT-4.1:contentReference[oaicite:144]{index=144}, and as of mid-2025, ChatGPT Plus users can even use the GPT-5 model through the CLI at no extra cost by logging in:contentReference[oaicite:145]{index=145}. Moreover, you can configure it to use other model providers (OpenRouter, Azure, local LLMs via API) by editing the config.
- Privacy and security: By default, none of your code files are sent to the cloud. Only prompts and high-level context (and optional diffs or summaries) are sent to the OpenAI API:contentReference[oaicite:146]{index=146}. Full Auto commands are run in isolation, and Codex CLI will warn you if you attempt to use autonomous modes without version control in place:contentReference[oaicite:147]{index=147}, emphasizing safe usage.
- Open source: The CLI is open-sourced on GitHub ([openai/codex](https://github.com/openai/codex):contentReference[oaicite:148]{index=148}). Developers can inspect the code, contribute improvements, or file issues. OpenAI has also introduced a fund to encourage community-built tooling around Codex CLI:contentReference[oaicite:149]{index=149}.


In short, Codex CLI is like having a ChatGPT-powered junior developer operating directly in your terminal. It can speed up routine coding tasks, help with on-demand code explanations, and even handle whole refactoring or bug-fixing sessions – under your supervision.


[]()

## CLI Commands and Help Reference


Once installed, the primary way to use Codex CLI is by invoking thecodexcommand. The CLI supports a few subcommands and a variety of flags to tailor its behavior. Here’s a breakdown of the available commands and options (as of the latest version):


- `codex` – Launches the interactive terminal UI (Text User Interface). This enters a chat session where you and the AI can exchange messages. If you run `codex` with no arguments, it will start in the default Suggest mode and await your prompt:contentReference[oaicite:150]{index=150}. Use this when you want a conversational session to discuss or modify code.
- `codex "Your prompt"` – You can provide an initial prompt in quotes when launching the CLI:contentReference[oaicite:151]{index=151}. For example: `codex "Explain the purpose of utils.py"`. Codex will start, read your project, and directly answer that prompt, then remain open for follow-ups. This saves a step, effectively combining launch+question in one command.
- `codex exec "task"` – Runs Codex in non-interactive mode to execute a single task and then exit:contentReference[oaicite:152]{index=152}. This is useful for automation or CI/CD pipelines. Codex will carry out the instruction (applying edits or running commands as needed) and print the results/diff. For instance: `codex exec --auto-edit "format all Python files according to PEP8"` would attempt to auto-format your codebase. The `exec` subcommand is essentially a one-shot run. An example in CI might be updating a changelog as shown below:
`codex exec --full-auto "update CHANGELOG for next release"` :contentReference[oaicite:153]{index=153}
In that example, Codex would try to autonomously edit theCHANGELOG.mdbased on commit history or context and then exit, which you could then commit as part of your CI routine.



- `codex login` – Initiates the authentication flow to link your ChatGPT account to Codex CLI:contentReference[oaicite:154]{index=154}. This opens a browser window for OpenAI login and, upon success, stores your credentials in `~/.codex/auth.json`. After logging in, Codex CLI can use the models available to your ChatGPT plan (like GPT-4 or GPT-5) without requiring API key usage. This is recommended for Plus/Pro users, as OpenAI provides complimentary Codex usage credits for subscribers (e.g., Plus users got $5 credit as of mid-2025):contentReference[oaicite:155]{index=155}. If you prefer not to use the web login, you can still use an API key (see below). Note: You only need to login once; subsequent uses will refresh tokens automatically. Use `codex logout` if you need to disconnect.
- `codex --help` – Shows the detailed help text, including usage syntax and all available options. It’s a good idea to run this at least once. For example, due to a packaging quirk, it might show the usage with a binary name (like `codex-x86_64-unknown-linux-musl`), but effectively that refers to the `codex` command:contentReference[oaicite:156]{index=156}. The help will list subcommands like `exec`, `login`, etc., and global flags.
- `codex --version` – Prints the version of the Codex CLI. Useful for checking if you have the latest version or including when reporting issues (e.g., `0.21.0`).
- `codex --upgrade` – Self-upgrades the CLI by fetching the latest version from npm:contentReference[oaicite:157]{index=157}. This is equivalent to running the npm install command again. Run this periodically to get new features and fixes.
- `codex mcp` – (Advanced) Runs the CLI in Model Context Protocol server mode:contentReference[oaicite:158]{index=158}. This is not commonly used unless you are integrating Codex with other tools via the MCP standard. It basically exposes Codex’s functionality as a service that an MCP client can interact with. Unless you know you need this, you can ignore this command.


Beyond these commands, a number offlagscan modify behavior:


- `--suggest`, `--auto-edit`, `--full-auto` – Sets the approval mode for the session:contentReference[oaicite:159]{index=159}. By default, Suggest mode is used, so specifying `--suggest` is usually not necessary. Use `--auto-edit` to start in Auto-Edit mode (Codex will apply file changes automatically) or `--full-auto` for Full-Auto mode (Codex will also execute commands autonomously in sandbox). See the next section for details on modes.
- `-m <model>` or `--model <model>` – Choose a specific model for this run:contentReference[oaicite:160]{index=160}. E.g. `-m gpt-4` to use GPT-4, if available to you. Otherwise, the default model (o4-mini or what’s configured in your settings) will be used. This flag overrides the config file’s model just for the current session.
- `-a` or `--ask-for-approval` – Force asking approval for every action:contentReference[oaicite:161]{index=161}. Even in Auto-Edit or Full-Auto, this will make Codex pause for confirmation before applying a change or running a command. Essentially it’s a safety toggle to ensure nothing happens without your “yes”. If you start in Suggest mode, this flag has no additional effect (since it already asks by default).
- `-q` or `--quiet` – Quiet mode, which reduces the verbosity of output. In quiet mode, Codex might suppress intermediate reasoning or streaming text and just output final results. This can be helpful for scripting scenarios where you only want the final answer or diff. *Note:* There was an issue where quiet mode still expected an OpenAI API key even when using a different provider, so ensure you have `OPENAI_API_KEY` set if you use `-q` with third-party providers:contentReference[oaicite:162]{index=162}.
- `--config key=value` – Override a config option for this run:contentReference[oaicite:163]{index=163}. For example, `codex --config maxTokens=5000` (hypothetically) to set a parameter not normally exposed. Most users won’t need this, but it’s there for advanced tuning. The `key` names correspond to those in the config file (without spaces, case-sensitive).


Interactive session “slash” commands:When you’re inside the Codex TUI (after runningcodex), you can type special commands starting with/to control the session or get info. These include:


- `/init` – Create an `AGENTS.md` file in the current directory, pre-populated with headings and tips:contentReference[oaicite:164]{index=164}. Use this when you start a project with Codex to quickly set up the context file for better results.
- `/status` – Show current status, like which model is in use, what mode you’re in, how many tokens used so far, etc:contentReference[oaicite:165]{index=165}. This can help track usage and settings in the middle of a session.
- `/diff` – Display the git diff of changes Codex has made or proposed:contentReference[oaicite:166]{index=166}. Even uncommitted/untracked changes are shown. This is extremely useful to review changes incrementally. After a series of AI edits, `/diff` lets you scroll through the patch.
- `/prompts` – Show some example prompts and usage hints:contentReference[oaicite:167]{index=167}. If you’re not sure what to ask, this can provide inspiration or format examples (the CLI might list things like “/init - to initialize an agent file” etc. as we see in the welcome message).
- `/mode` – Change the approval mode on the fly:contentReference[oaicite:168]{index=168}. For instance, typing `/mode full-auto` in the middle of a session will elevate Codex to Full Auto (it will usually confirm the switch in the output). Similarly, `/mode suggest` can downgrade to manual suggestions.
- `/help` – (If available) Lists the slash commands and maybe a short description of each. Not all versions have this, but it’s common for such tools to include a help command in-session.
- `Ctrl+C` – Keyboard interrupt. This will cancel the current generation or command. Use this if Codex seems stuck or if it’s taking too long on a step and you want to regain control:contentReference[oaicite:169]{index=169}. After pressing Ctrl+C, you can usually type a new prompt to continue.


These interactive commands are your control panel during a chat session with Codex. They are especially important in longer sessions to monitor and manage what the AI is doing.


Now that we have covered how to invoke and control Codex CLI, let’s explore the differentApproval Modesin detail, as they determine how those commands above actually behave in practice.


[]()

## Approval Modes


Codex CLI supports three distinct approval modes that govern the agent’s permissions. Understanding these modes is critical for safe and effective use. Here’s a closer look at each:





Mode
What the Agent Can Do
When to Use




Suggest (default)
Read files; propose code changes and terminal commands, but always asks you for approval before actually editing a file or running a command:contentReference[oaicite:170]{index=170}.
Safe exploration, code reviews, initial understanding of a codebase. Use this when you want to vet every action, or when trying out Codex for the first time in a new project:contentReference[oaicite:171]{index=171}.


Auto Edit
Read and write to files automatically (applies edits without confirmation). However, still prompts before executing any shell commands:contentReference[oaicite:172]{index=172}.
Refactoring or repetitive edits where confirming each small change is tedious, but you still want to manually approve any command executions (which could have broader effects):contentReference[oaicite:173]{index=173}. It’s a middle ground – file changes are streamlined, but potentially dangerous operations are gated.


Full Auto
Read, write, and execute commands autonomously, within a sandboxed, network-disabled environment:contentReference[oaicite:174]{index=174}. No approvals are required once this mode is active; the agent decides on its own.
Long or complex tasks like debugging a failing test suite, fixing a broken build, or implementing a multi-step feature, especially when you trust the agent to iterate. It’s useful when you want to delegate a task entirely and possibly do something else (grab a coffee):contentReference[oaicite:175]{index=175}. Always review the outcome later.



In **Suggest** mode, you are effectively in charge; Codex won’t change anything unless you explicitly okay it. This mode is very safe. For example, if you ask Codex to “optimize this function,” it will show a diff of the proposed optimization. You can then accept it (y) or reject (n). If it suggests running tests, you have to type “yes” before it actually runs them. This is great for learning and for cautious usage, ensuring you have full control.


In **Auto Edit** mode, Codex will directly apply changes to files as it suggests them. You’ll see the changes in the terminal output (usually prefaced by something like “✏️ Applying patch to X file...”), but it won’t wait for you to confirm each one. However, if Codex wants to run a shell command (like building your project or executing tests), it will still ask you first. This mode significantly speeds up workflows like “make these 10 small changes across the codebase,” because you don’t have to hit “y” 10 times. But it still errs on the side of safety for commands, since running commands can have side effects beyond just modifying text in a file.


In **Full Auto** mode, Codex doesn’t ask for permission for anything – it will edit files, create new files, delete files, run compilation, run tests, etc. on its own, as needed to accomplish the goal. To prevent chaos, Full Auto always runs in a restricted environment:On **macOS**, it uses Apple’s sandbox (Seatbelt) viasandbox-exec, which restricts file system access to basically your project directory and a temp dir:contentReference[oaicite:176]{index=176}. It also blocks all network access by default:contentReference[oaicite:177]{index=177} (even if the code tries to call out).On **Linux**, Codex CLI (when Full Auto is enabled) can run inside a lightweight Docker container. The container has your current directory mounted (so it can read/write your project) and uses aniptablesfirewall to block egress (except the connection to OpenAI API):contentReference[oaicite:178]{index=178}. This container approach is optional (for now you have to run the providedrun_in_container.shto set it up).So, the sandbox means even in Full Auto, the AI can’t accidentally modify files outside your project or exfiltrate data via network. It’s an important safety feature.


When launching Full Auto, Codex CLI will prompt a confirmation, especially if you’re not in a git repo: “Directory not under version control – are you sure?”:contentReference[oaicite:179]{index=179}. This is because without version control, you have no easy way to see what it changed or roll back. It’s highly recommended to only use Full Auto on projects tracked by Git (or similar). Commit your work, then let Codex Full Auto run, then you can usegit diffor/diffto inspect changes.


Tip:If you want Codex to behave mostly autonomously but you worry about a specific operation, you can start in Full Auto and then, if you see it heading in a risky direction, pressCtrl+Cto stop and then switch to Suggest mode for the next steps. Alternatively, you can start in Suggest mode and after seeing it make good suggestions, type/mode auto-editor/mode full-autoto speed things up.


In practice, many users start in Suggest for initial prompts (“What does this code do?”) then move to Auto Edit for mechanical changes (“Apply these fixes”). Full Auto is often used for letting the agent run tests and fix things—something that may involve multiple iterations. For example, in Full Auto you might say “Upgrade this project to Python 3.11 and ensure all tests pass.” Codex will:Edit some files (like update syntax, or dependencies).Runpytest(without asking).See failures, modify more files to fix, maybe runpytestagain.Repeat until tests all succeed or it’s stuck.All that would happen without your intervention. At the end, you get control back with a message like “All tasks completed.” Then you can review the changes.


No matter the mode, **you** have the final say. Even in Full Auto, you can always review the git diff or revert commits. The modes just determine how often the AI pauses to ask permission. Using them appropriately can make Codex CLI both safe and highly efficient.


Back to top


[]()

## Using AGENTS.md and AGENTS.local.md


Codex CLI can be guided by special markdown files namedAGENTS.md(and optionallyAGENTS.local.md). These files are not code; they are notes/instructions for the AI agent. They persist across sessions and help Codex understand your project’s context and conventions without you having to repeat information in every prompt.



### AGENTS.md – The Project Guidebook


What is AGENTS.md?It’s a plain text Markdown file (akin to a README) where you write down important information about your project for the AI to consider:contentReference[oaicite:180]{index=180}. This can include:


- Project overview: e.g. “This is a web app for X, using framework Y, etc.”
- Technical stack: languages, frameworks, versions (e.g. “Node.js 18 with Express, MongoDB backend”).
- Architecture and conventions: how the project is structured (“uses MVC pattern, services in `src/services`, UI in `src/components`”) and coding guidelines (“follow PEP8 style”, “use 2 spaces indent”).
- Key commands: how to run, test, build the project (“to run: `npm start`”, “to run tests: `npm test`”). Codex can use these when appropriate, especially in Auto or Full modes.
- Requirements or TODOs: high-level goals or pending tasks. You could list user stories or bug IDs you intend to work on, so Codex knows the context.


Codex CLI automatically searches for AGENTS.md in three places and merges them:contentReference[oaicite:181]{index=181}:


- Global: `~/.codex/AGENTS.md` – your personal global instructions. This might include your general preferences or common directives you want for all projects (for example, “always write clear comments” or “favor functional programming style”).
- Repo root: `AGENTS.md` in the root of your project repository. This is the shared project-specific guidance – anyone using Codex on this repo should ideally have the same file (committed to version control). It’s like documentation specifically for AI assistance.
- Current folder: `AGENTS.md` in the current working directory (if different from repo root). This allows more granular or feature-specific notes. For instance, if you have a submodule or a specific directory for a microservice, you could put an AGENTS.md there with details just for that part. Codex will read that in addition to the repo root and global files:contentReference[oaicite:182]{index=182}.


The content from all applicable files is merged, with the more local files taking precedence (i.e., deeper folder = higher priority):contentReference[oaicite:183]{index=183}. In practice, it likely concatenates them in that order (global, then repo, then local dir), so if there are conflicting statements, the later one wins. You can use this layering to your advantage: global could say “use American English in comments” and a repo-level could override “in this project, use British English” as a trivial example.


How Codex uses AGENTS.md:When Codex starts on a project, it will open and read these files internally. The information influences how it responds to your prompts. For example, ifAGENTS.mdsays “All database changes must go through the repository layer, not directly in controllers,” Codex will try to adhere to that rule when generating code. Or if it lists how to run tests, Codex will know the exact command to use (saving it from guessing, which might be wrong). Essentially, it gives Codex additional context beyond just the code it sees.


Creating and editing AGENTS.md:If your project doesn’t have one yet, you can create it manually or use the/initcommand in Codex which will interactively help you start one:contentReference[oaicite:184]{index=184}. That typically opens a text editor (nano or vim) with a template:# AGENTS.md

## Project
_(<Describe the project>)_

## Design
_(<Architecture guidelines>)_

## Commands
_(<Important commands: build, test, run>)_

## Conventions
_(<Code style, naming conventions, etc.>)_

## Env
_(<Key environment variables>)_

## TODO
_(<Planned tasks or known issues>)_You fill this out as needed. It’s a good idea to store this in git, so others on your team can also benefit (and so the AI instructions are transparent and versioned).


Notably, the OpenAI blog mentions: *“Codex can be guided by AGENTS.md files... akin to README.md... to inform Codex how to navigate your codebase, which commands to run for testing, and how best to adhere to your project's standard practices.”*:contentReference[oaicite:185]{index=185} This captures the essence – it’s guidance for the agent, which ultimately helps you by making its output more relevant and accurate.


Whenever the project changes (new commands, new sections), update AGENTS.md. It doesn’t require a restart of Codex if you’re in the middle of a session – you can use/initto reload it, or restart Codex to pick up changes. If you have critical new info (like you just added a new dependency that requires a special build step), definitely put it in there so Codex knows.



### AGENTS.local.md – Personal/Local Instructions


AGENTS.local.mdis not an official required file, but rather an emerging convention. The idea is to have a separate file for instructions that arenot meant to be shared or committed– for your eyes (or AI) only. For example, if you have some experimental notes, or preferences that your team hasn’t agreed on, you might use AGENTS.local.md to keep them.


In some workflows, developers create anAGENTS.local.mdand add it to.gitignore. In fact, the DotAgent project (a tool to manage AI instruction files) explicitly suggests ignoringAGENTS.local.mdand treats any*.local.mdfile as private:contentReference[oaicite:186]{index=186}:contentReference[oaicite:187]{index=187}. DotAgent even updates .gitignore with a pattern to excludeAGENTS.local.mdautomatically:contentReference[oaicite:188]{index=188}:contentReference[oaicite:189]{index=189}.


How to use AGENTS.local.md:Currently, Codex CLI does not automatically read an AGENTS.local.md file. It only looks for AGENTS.md as described. However, you have a couple of options to use it:Manual inclusion:You could copy its contents into AGENTS.md when running Codex, or temporarily rename it. This is clunky but straightforward.Merge via script:Write a small shell script or command alias that, before launching Codex, merges AGENTS.md + AGENTS.local.md into a temp file, and maybe points Codex to use that (for example by using--config agentFile=...tempif such an option existed, or simply by concatenating them into one AGENTS.md and removing after).Rely on global AGENTS.md:If the content in AGENTS.local.md is truly personal and you want it always, consider putting it in your~/.codex/AGENTS.mdinstead. That global file is by definition your personal instruction set. You could delineate sections in it per project if needed (like “If project = X, do this…” though Codex may not parse that logic clearly).The key is that AGENTS.local.md is forprivate rules– things like:Your own preferences (e.g., “I like code comments in a certain style”).Client-specific information or credentials that shouldn’t be in the repo. Perhaps the project is open source, but you have local API keys or experimental APIs you use – you might note those in the local file.Temporary notes – say you’re in the middle of a big refactor, you might list “Here’s the plan for refactoring module X” in local, since that plan might change or isn’t needed in official docs.In short, AGENTS.local.md is a supplement for your own use. If you share the project with others, they won’t see those instructions (unless they also create their own local file).


Because it’s not automatically loaded, many users actually skip using a separate file and just incorporate everything into AGENTS.md and use comments or separators to mark private stuff. For instance, you could put an HTML comment in AGENTS.md like<!-- DevNote: ... -->that your teammates know to ignore. But the separate file approach has the benefit of clearly not committing it.


Convention in other tools:This idea of “.local.md” files isn’t unique to Codex. For example, GitHub Copilot hascopilot.jsonand they’ve discussed havingcopilot.local.jsonfor personal settings, etc. DotAgent (as mentioned) formalizes this across multiple AI assistant tools:contentReference[oaicite:190]{index=190}. So using AGENTS.local.md is future-proofing in a way. If Codex CLI later adds native support for it, it may automatically merge it or something.


Bottom line:Use AGENTS.md as the main way to give Codex context. Only use AGENTS.local.md if you have a specific need to keep some AI instructions private. And remember, if you do use it, you’ll need to handle its loading/merging yourself (at least until official support potentially arrives). Always keep any truly sensitive info (like actual passwords or keys) out of any AI context if possible, as a good security practice, even if running locally.


Back to top


[]()

## Configuration, Environment Variables, and Usage Patterns


Codex CLI is highly configurable to fit your development environment and preferences. We’ll break this section into:


- Setting up the configuration file and what options you can tweak.
- Important environment variables that influence Codex CLI.
- Typical usage patterns and best practices for integrating Codex into your workflow.



### Configuration File (~/.codex/config.toml)


After installing Codex CLI, it will create a directory~/.codex/in your home folder. Inside, you may findconfig.toml(or it might be generated on first run). This file contains default settings. You can edit it to change how Codex operates by default. The config format is TOML (key = value), but as noted earlier, JSON or YAML formats are also accepted in newer versions (you can useconfig.yamlif you prefer YAML syntax, for example):contentReference[oaicite:191]{index=191}.


Key settings you can configure:


- model: Which model to use for completions. Example: `model = "gpt-4.1"` or `"o4-mini"`:contentReference[oaicite:192]{index=192}. If you have access to GPT-4 (or beyond) and want it always, set it here. Otherwise, you might leave it as default and occasionally override via `-m` flag when needed.
- model_provider: By default this is `"openai"`. But you can define others in the `[model_providers]` section and set this to use them. For example, to use OpenRouter, you would add:
        
```
[model_providers.openrouter]
name = "OpenRouter"
base_url = "https://openrouter.ai/api/v1"
env_key = "OPENROUTER_API_KEY"
```


        and then set `model_provider = "openrouter"` in the main config:contentReference[oaicite:193]{index=193}. Now Codex will send API calls to OpenRouter’s endpoint instead of OpenAI’s, allowing you to use models hosted there (like Anthropic’s Claude, etc.), given you have an API key for it.
- providers: *(If using JSON config as in older docs)* – It might be under a `"providers"` object if JSON. For TOML, it’s `[model_providers]` as above. The key point is you can configure multiple and switch.
- reasoningEffort: Could be `"low"`, `"medium"`, `"high"` – this setting (used by OpenAI’s Codex-1 model) indicates how much reasoning the model should apply. Higher usually means more thorough but possibly slower or costlier. If you find Codex’s answers too superficial, consider setting a higher effort. This might not affect non-Codex models like GPT-4.
- history.maxSize: How many tokens of conversation history to retain. If you set a high number, Codex will keep more of the past dialogue in context (useful for long sessions, but uses more token budget). history.saveHistory: if true, Codex may save your session transcripts somewhere (likely in ~/.codex/history). This could be handy to review later or if you want continuity between sessions, but note that saved history with sensitive info is something to manage carefully.
- disable_response_storage: If you’re under a Zero Data Retention policy and get errors about it:contentReference[oaicite:194]{index=194}, set this to true. This tells Codex not to rely on cached response IDs when calling the API, which is required under ZDR (where the API won’t allow linking to past conversation turns):contentReference[oaicite:195]{index=195}.
- fullAutoErrorMode: This determines what Codex does if a command it ran in Full Auto fails (exits with error). The value could be `"ask-user"` (pause and ask you how to proceed) or `"ignore-and-continue"` (it will note the error and attempt to proceed anyway). Setting it to ask-user can prevent Codex from getting stuck in a loop on something like “server failed to start” – you get to intervene:contentReference[oaicite:196]{index=196}.
- notify: If set to true, Codex might send desktop notifications for certain events (like when it’s waiting for your approval, or after finishing a long task). This is a minor UX thing but can be useful if you switch windows while it’s working:contentReference[oaicite:197]{index=197}.
- profiles: The config supports grouping sets of configs under profiles. For example:
        
```
[profiles.o3]
model = "o3"
model_provider = "azure"
azure_version = "2023-05-15"
```


        You might have multiple profiles for different scenarios (fast model vs accurate model, or different cloud providers):contentReference[oaicite:198]{index=198}. Then launch with `codex --profile o3` to use that profile:contentReference[oaicite:199]{index=199}. Each profile inherits base settings but can override some. This feature is for power users who frequently swap contexts or models.
- mcp_servers: If you plan to integrate external tools via the Model Context Protocol, you’ll configure them here. As shown earlier, Snyk’s security scanner can be added:contentReference[oaicite:200]{index=200}, or any other MCP-compatible service (perhaps you create one for custom analysis). Each entry names the server and the command to start it (plus args and env). Codex will then know it can call that tool. For example, after configuring Snyk’s MCP, Codex can respond to a prompt “scan for vulnerabilities” by invoking that tool automatically:contentReference[oaicite:201]{index=201}.


The official configuration documentation (in the repo’s docs) lists all available options. Many of them you may never need to change. But it’s good to know you have this level of control.


One tip: If you want to quickly see what config options exist, runcodex --helpand look at the section that might list environment variables or config keys (some CLI help do list them). Alternatively, open the config file – the default one often includes comments or examples.


Remember that after editing the config file, you should restart the Codex CLI for changes to take effect (since it reads config at startup). If something seems off, double-check syntax. TOML is strict with things like quoting strings and not using tabs (should use spaces) etc.



### Environment Variables


Various environment variables interplay with Codex CLI. Here are the key ones:


- OPENAI_API_KEY: Your OpenAI API key (if using API mode). If you didn’t do `codex login` (which is the ChatGPT method), then Codex will expect an API key to be present:contentReference[oaicite:202]{index=202}. Without it, it cannot call the OpenAI API and will refuse to work. Set this in your shell (e.g., in `~/.bashrc` or `~/.zshrc`) or in a local `.env` file.:contentReference[oaicite:203]{index=203}:contentReference[oaicite:204]{index=204} Codex CLI loads `.env` automatically thanks to `dotenv`:contentReference[oaicite:205]{index=205}, meaning you can just have a file with `OPENAI_API_KEY=sk-...` in your project and it will pick it up.
- OPENROUTER_API_KEY, GEMINI_API_KEY, etc.: Similarly, if you configure an alternate provider that needs a key, it likely has an env var. From our earlier example, OpenRouter requires `OPENROUTER_API_KEY`:contentReference[oaicite:206]{index=206}. If using Azure OpenAI, you might need `AZURE_API_KEY` and some additional config for endpoint and deployment names (Azure uses a different authentication scheme and endpoints). Google’s Gemini (via PaLM API) might use an API key or service account – if it’s OpenAI-compatible via OpenRouter or similar, you’d still set an env key specified in config.
- GITHUB_TOKEN (optional): If you plan to use Codex CLI’s PR helper functionality (it has some integration to open a GitHub PR with your changes, which might exist given it mentions a “built-in PR helper” requiring Git:contentReference[oaicite:207]{index=207}), having a GitHub token could allow it to create gists or PRs via command. This isn’t clearly documented, but just in case: certain OpenAI tools allow linking a GitHub account for PR creation.
- RUST_LOG: As mentioned, for debug logging. E.g. `export RUST_LOG=codex_core=debug` to see detailed logs in the console. By default, interactive mode logs to `~/.codex/log/codex-tui.log` with info level:contentReference[oaicite:208]{index=208}. You can watch that file in a separate terminal with `tail -F` to monitor what the agent is doing behind the scenes (like reading a file, or the full conversation it’s sending to the API, etc.). This is advanced usage for debugging or curiosity.
- NO_COLOR: If set (to any value), many CLI apps disable colored output. Codex might respect this too. If you find ANSI codes in your output and you don’t want them, either use `--no-ansi` (if provided) or set NO_COLOR=1.
- http_proxy / https_proxy: If you are behind a corporate proxy, setting these environment variables ensures the CLI can reach the OpenAI API. Codex CLI uses Node/Rust HTTP libraries which typically respect these standard env vars for proxies.
- CODEX_something: There may be some undocumented env variables for experimental features. For instance, some CLIs use flags via env for things like “enable beta features”. If you browse the code or release notes and see something like that, you’d set it similarly (e.g., CODEX_SUPER_MODE=true as a hypothetical example). This is not from docs, just a note that env vars sometimes hide toggles.


One more environment consideration: **Operating System Path/Dependencies**. Codex will run shell commands as needed. Ensure that any command it might call is available. For example, if you prompt “format code with clang-format,” but you don’t have clang-format installed, Codex can’t magically do it. So, having common build tools, linters, etc. installed is beneficial. If a needed tool is missing, Codex might even try to install it (it could propose runningapt-getornpm install), which you’d have to approve. That’s fine, just be aware of what’s on your system.


**.env files**: It’s worth reiterating that Codex CLI loads a .env file if present in the working directory:contentReference[oaicite:209]{index=209}. So you can keep API keys or other env vars there instead of cluttering your global shell. This .env will also apply to commands Codex runs (so if your app needs certain env vars set to run, putting them in .env means when Codex runsnpm startor tests, those env vars are in place). This is hugely helpful for things like database URLs for testing, etc. Make sure not to commit your .env if it contains secrets (add to .gitignore).



### Usage Patterns and Tips


Now that your Codex CLI is configured and you know how to control it, how do you best incorporate it into daily development? Here are some patterns:


- Start simple, then automate: When you begin using Codex on a project, you might stick to Suggest mode until you trust the agent. For example, ask it to describe the project or do a small change. As you see its behavior is reasonable, you can get bolder – maybe let it auto-apply trivial changes, or eventually try Full Auto on a contained task like running and fixing tests. This phased approach builds trust and understanding.
- One task at a time: Codex works best when given a clear, single objective. Instead of asking: “Build me a new feature with A, refactor module B, and fix bug C,” split those into separate sessions or prompts. Tackle them one by one. You can do multiple in one continuous session, but sequentially. E.g., “Now that feature A is done (and committed), let's refactor module B.” This avoids confusing the AI or stretching context too thin.
- Keep conversations focused: If you stray off-topic in a session (asking about an unrelated part of the code mid-session), Codex might carry a lot of context from earlier discussion that is no longer relevant. It can handle context well, but if you switch to a very different task, consider resetting (closing and reopening Codex) or using the `/clear` command if one exists (not sure if Codex CLI has a /clear context). This ensures it doesn’t get biased by previous prompts irrelevant to the new task.
- Version control is your safety net: Always have git (or another VCS) initialized. Commit before starting a major Codex session. This way, you can compare “before vs after” easily. If Codex makes a mess, you can revert to before the session. If it does well, you can commit the changes with a clear message (perhaps “AI-assisted changes: did X and Y”). Each Codex session or task could be one commit. This makes auditing later easier.
- Review diffs and test results: Don’t blindly accept everything. Codex is good but not perfect. Always read through the diffs it proposes (it might occasionally introduce a subtle bug even as it fixes another). Run your test suite after it makes changes, even if Codex itself ran them (double-check in a fresh environment if possible). Essentially, treat Codex’s output like you would a human junior developer’s code – useful, but needing code review.
- Leverage approvals strategically: In Suggest mode, you might get a large diff and only want to accept part of it. Currently, Codex CLI’s approval is usually all-or-nothing for a given suggestion. But you can say “No” and then guide it: e.g., “That change to X looks good, but don’t change Y.” Codex will likely redo the diff focusing only on X. This interactive refinement is powerful. Use natural language to tell Codex how to tweak its suggestion, rather than manually editing the file yourself – let the AI do the mechanical part while you specify the intent.
- Use Full Auto for grunt work: Some tasks are just painful to do manually but straightforward, e.g., renaming a function across dozens of files and updating references, or reformatting all code. Full Auto shines here – you can literally ask Codex CLI in full auto to “Enforce our coding style on the entire repository” and it might run your linter/formatter or make changes accordingly (provided it knows the style or you have a linter config). Another example: “Upgrade dependency X to latest version and fix any compatibility issues.” It can try to bump a version, run `npm install`, see if build/tests fail, modify code, etc. This could save hours. Just be sure to watch it (or review after) since automated upgrades can have side effects.
- Combining with other tools: Codex CLI can act as an orchestrator of other CLI tools. If you have a Makefile or npm scripts, Codex will often use them (because it can read those files). That means you can simply instruct “Generate the API documentation” and if your project has a script for it, Codex might call it. Or with an MCP integration like Snyk, you say “ensure the code has no security issues,” it will run Snyk. The benefit is you interacting with one interface (Codex) and it delegates to many. This centralizes your workflow remarkably.
- Stay aware of costs and rate limits: Each API call costs tokens, and there may be rate limits. Codex CLI streams output which is great for responsiveness. But if you have a very large codebase, the initial context it sends can be large. Monitor your usage on OpenAI’s dashboard if using API keys. If you hit limits, you may need to reduce how much context it sends (e.g., perhaps remove very large files or binary files from the directory to avoid Codex reading them – currently it doesn’t respect .gitignore unless you apply a patch/setting:contentReference[oaicite:210]{index=210}, though PRs exist to add that). One quick hack: temporarily rename node_modules or other huge folders while running Codex if it seems to waste time reading those. The community is actively improving this aspect (like adding an `.agentignore` file to exclude certain paths):contentReference[oaicite:211]{index=211}.


Finally, **remember the human override**: You as the developer have the final responsibility for the code. Codex CLI can handle a lot, but if something is critical (security-sensitive logic, complex algorithm), it’s often best to double-check or even do it manually if the AI isn’t instilling confidence. Use Codex to handle the boilerplate and mundane, and free your time to focus on the high-level design and tricky parts that require careful thought.


With practice, you’ll learn which tasks Codex excels at and which to avoid. Over time, you might find you trust it with more (especially as the models improve). It’s like mentoring an intern that quickly becomes a competent assistant – but still needs oversight for the hard stuff. Embrace its help, but stay in control.


Back to top


[]()

## Practical Examples & Workflows


Let’s walk through a few concrete scenarios showing how you might use Codex CLI in real situations:



### 1. Initial Codebase Exploration


Scenario:You just cloned a repository and want to understand it.


Actions:Navigate into the repo and runcodex. When prompted, ask something like “Summarize what this repository does.” Codex will read through the files and likely generate an overview: e.g., “This is a Flask web application for a task tracker. It has modules A, B, C... etc.”:contentReference[oaicite:212]{index=212} You can follow up with questions like “What are the key classes or functions I should know about?” Codex might describe important classes and their relationships.


Use/promptsto see examples; one might be “Explain the code in file X”, which you can do for specific files. Or/diff(though initially, no diff since nothing changed). Essentially, Codex acts like a documentation generator and tutor here.


Outcome:In a few minutes, you have a decent mental model of the project, without reading all files manually. This helps you onboard faster. (Of course, verify its summary with actual code to ensure accuracy.)



### 2. Bug Fix with Full Auto


Scenario:There’s a failing unit test in your project. The test output says that for input X the function Y returns the wrong value, causing an assertion failure.


Actions:You open Codex CLI. You might literally copy-paste the failing assertion or error message into Codex and say “Fix this bug.” Codex will search where that error could come from. It finds function Y, sees what it’s doing, and proposes a code change to fix the logic. It presents the diff to you in Suggest mode. If it looks reasonable, you accept it. You then type “Run tests” or Codex itself suggests running them. It runsnpm testorpytest(depending on your project setup), sees the results. If all tests pass, it prints success. If not, it will show failures and possibly start addressing the next failure.


You could alternatively do this in one go with Full Auto:codex exec --full-auto "run the tests and fix any failures". Codex will loop running tests and fixing code until tests are green (or it gets stuck). It provides a log of what it’s doing:contentReference[oaicite:213]{index=213}.


Outcome:The bug is fixed quickly. Codex not only applied a fix but also verified it via tests. You save time in diagnosing and iterating on the fix.



### 3. Implementing a New Feature


Scenario:You need to add a new feature (say, a new API endpoint in a web app) with certain requirements. You have a spec or general idea of what to do.


Actions:Write a summary of the feature in the prompt: e.g., “Add a new endpoint GET /users/{id}/settings that returns the settings for a user. Include authentication and a new unit test for this endpoint.” Hit enter in Codex CLI. In Suggest mode, Codex will likely:Create or modify the route configuration to add the new endpoint.Implement the handler function (maybe in a controller or route module).Add a new test case in the test suite for this endpoint.It will show you diffs for each file it changes or creates. You approve them if they meet the spec. It might then suggest, “Shall I run tests?” – you approve. It runs them. If something fails (maybe you forgot to update a URL in documentation), it may fix that too. If it passes, great.


During this, you can have a dialogue: “Actually, ensure that this endpoint is only accessible to admin users.” Codex will adjust the code to add an auth check (because your AGENTS.md might have how auth is handled, it knows how to do that). You are effectively pair-programming: you state requirements, Codex writes code, you refine, etc.


Outcome:The new feature is implemented along with tests in, say, 10 minutes, whereas manually it might have taken 30. The code still might need some polishing (maybe style fixes), but you can either let Codex format it or do a quick pass yourself.



### 4. Large Scale Refactoring


Scenario:You want to rename a core class or function across the codebase, or change an API usage (e.g., migrate from one library to another equivalent).


Actions:Example prompt: “Rename the classOldManagertoNewManagerand update all references. Ensure everything compiles.” Codex will findOldManagerin your code, rename the class and constructor, update all places it’s referenced. It might be dozens of changes. It shows the diffs possibly file by file. In Auto Edit mode, it would just apply them all. You double-check with/diff(which will be big). Then you tell Codex “run the build” or “run tests” to be sure. If it missed something, the compiler/test will catch it, and Codex will fix it.


This is similar to what a good IDE refactor tool can do, but here you didn’t have to click through anything – just one command. Another example: “We’re replacing usage ofLibraryXwithLibraryY. Update the import statements and equivalent function calls.” Codex might need some guidance if APIs differ, but you can do it iteratively. Perhaps first ask it to change the import, then handle errors as they arise.


Outcome:A potentially error-prone, multi-file refactor is done quickly and with less mental load. And you had the safety net of tests/compilation to verify the refactor didn’t break things.



### 5. Documentation and Cleanup


Scenario:You want to improve documentation or code comments across your project.


Actions:Using Codex, you could do:“Generate docstrings for all public functions inutils.py.” – Codex will parse that file and add docstrings in a consistent style to each function that lacks one. It shows the diff; you approve.“Create a Markdown API documentation file listing all endpoints and their purpose.” – If it’s a web API, Codex can gather info (from route definitions, perhaps reading your controllers) and produce anAPI.mdfile. You review and tweak if necessary. It might not be perfect, but it’s a great start.“Find and remove any commented-out code.” – Codex can scan files for blocks of code that are commented and remove them (or better, present a diff removing them for you to confirm). This is a nice cleanup task near release time.In doing these, use Suggest mode first to ensure it’s doing what you intend (documentation quality can vary, you might need to instruct it on format). Once confident, you could let it auto-apply for many files.


Outcome:Improved documentation and cleaner code, done in a fraction of the time it would take manually combing through files. And because Codex can understand the code, the docstrings it writes are often accurate (though always give them a read to ensure no hallucinations).


These examples show the versatility of Codex CLI – from understanding code to modifying it in non-trivial ways. The common theme is that you, the developer, provide guidance and validation, while Codex handles the brute-force editing and some of the thinking. You save time and reduce manual mistakes (like missing one of ten references to a function during rename, which Codex would not miss unless it lacked context).


One thing to note: the effectiveness of Codex CLI can depend on how well your project is structured and how good your instructions are. Clear, concise prompts yield better results. Also, if your codebase has a lot of context (like relevant info in README or comments), Codex picks up on that. It’s worth investing in your AGENTS.md and keeping the project’s structure clean – not just for Codex, but it helps any contributor (AI or human).


Back to top


[]()

## Further Reading & Resources


For more information, help, or involvement with OpenAI Codex CLI, check out these resources:


- [OpenAI Codex CLI GitHub Repository](https://github.com/openai/codex) – The official repo contains the source code, README documentation, a `docs/` folder with more detailed docs (like `config.md`), and a CHANGELOG. It’s the best place to see the latest updates and known issues. If you encounter a bug or have a feature request, you can open an issue there:contentReference[oaicite:214]{index=214}. Also, browsing the `Discussions` tab can provide insight into how others are using the tool or clever tricks.
- [OpenAI Help Center – Codex CLI Getting Started](https://help.openai.com/en/articles/11096431-openai-codex-cli-getting-started) – An official quickstart article:contentReference[oaicite:215]{index=215} with some FAQ. It covers the basic installation and a short FAQ (which models are used, does it upload code, how to update, etc.). It’s brief but useful for common questions when first installing.
- [OpenAI Developer Community (Codex section)](https://community.openai.com/c/codex) – A forum where you can ask questions and share experiences. If you run into a problem, it’s likely someone else has too. For example, issues with Windows login or .gitignore not being respected have been discussed there:contentReference[oaicite:216]{index=216}:contentReference[oaicite:217]{index=217}. The OpenAI staff and community members often provide solutions or workarounds.
- [OpenAI Blog: Introducing Codex](https://openai.com/index/introducing-codex) – This blog post:contentReference[oaicite:218]{index=218} announces Codex (the broader initiative) and specifically mentions the CLI and how it works in tandem with the ChatGPT sidebar version. It gives a perspective on why Codex was built and some design philosophy (like the importance of citations and sandboxing to build trust in AI agents). It’s a good read for understanding the vision behind the tool and its future direction.
- Tutorials & Blog Posts:
- "Describe It, Codex Builds It — Quick Start with Codex CLI" by Rob Śliwa (Medium) – A detailed walkthrough of using Codex CLI to build a feature from scratch:contentReference[oaicite:219]{index=219}. Rob shares his experience and even an example AGENTS.md content for a project. Great for seeing an end-to-end usage in practice, with commentary.
- "Working with OpenAI’s Codex CLI" by Kevin Leary – Focuses on setup, configuration, and some quirks (like using .env, global context, ignoring files):contentReference[oaicite:220]{index=220}:contentReference[oaicite:221]{index=221}. It’s useful especially for the config and environment preparation aspects.
- "OpenAI Codex CLI: Build Faster Code Right From Your Terminal" (Blott.studio) – An introductory article summarizing features and installation with some imagery:contentReference[oaicite:222]{index=222}:contentReference[oaicite:223]{index=223}. Good for sharing with colleagues who need a high-level overview before diving in.
- "Understanding OpenAI Codex CLI Commands" (machinelearningmastery.com) – As the name suggests, a tutorial focusing on usage of commands and perhaps some internal logic. This could help reinforce your knowledge of the CLI capabilities.



- Related Tools: Codex CLI is one of several AI coding assistants:
        - [OpenAI Codex (API)](https://platform.openai.com/docs/codex) – Not to be confused, but the earlier Codex model (2021) and its API documentation might still be floating around. Note that the old Codex model is deprecated:contentReference[oaicite:224]{index=224}; the CLI uses newer models. The concept is similar but the CLI adds the agentic behavior.
- GitHub Copilot CLI – A small tool from GitHub for shell autocompletion and small tasks. Not nearly as comprehensive as Codex CLI, but interesting to compare if you’ve used it.
- [DotAgent](https://github.com/johnlindquist/dotagent) – The tool we mentioned for managing AI agent instructions. If you find yourself using not just Codex but other AI tools, DotAgent helps keep your AGENTS.md, etc., in sync or convert between formats:contentReference[oaicite:225]{index=225}. For example, if you wanted to also support Cursor or Copilot, you could maintain one set of rules and export to each format.
- Cursor (by OpenAI) – An IDE (VSCode-like) that also uses the Codex model and supports MCP. If you prefer a GUI editor with similar AI capabilities, give Cursor a try. Codex CLI and Cursor can actually work together via MCP, theoretically.
- Local LLM dev helpers: There are emerging open-source projects to replicate Codex CLI with local models (for those who want completely offline solutions). One example is “aider” or “GPT-Engineer”. They’re not as polished as Codex CLI yet, but you might watch that space if interested in offline usage.





By exploring these resources, you can deepen your understanding, troubleshoot issues, and even contribute to the improvement of Codex CLI. Since the tool is evolving, staying updated via the GitHub repo (watching releases or discussions) is useful. Who knows – you might discover new features as they come out (like when the ChatGPT login was introduced, which was a major change). The community around these AI coding tools is growing, and sharing experiences helps everyone learn how to best use them.


Happy coding with Codex CLI!


 Citations (for reference in rendered view, though in a static HTML page these might just appear as text) 

Sources cited in this guide are indicated in the text with the format 【source†lines】. For example, :contentReference[oaicite:226]{index=226} refers to lines 15-23 of source [1]. Below is a list of sources:


- [OpenAI Help Center: "OpenAI Codex CLI – Getting Started"](https://help.openai.com/en/articles/11096431-openai-codex-cli-getting-started)
- [OpenAI Codex CLI GitHub README – CLI reference section](https://github.com/openai/codex#cli-reference)
- [OpenAI Blog: "Introducing Codex"](https://openai.com/index/introducing-codex), May 16, 2025
- [OpenAI Codex CLI GitHub README – various sections (Memory, MCP, etc.)](https://github.com/openai/codex/blob/main/README.md)
- [OpenAI Codex CLI GitHub README – Other Providers and Profiles section](https://github.com/openai/codex/blob/main/README.md#codex-also-allows-you-to-use-other-providers)
- [Rob Śliwa on Medium: "Describe It, Codex Builds It — Quick Start with Codex CLI"](https://medium.com/@robjsliwa_71070/describe-it-codex-builds-it-quick-start-with-codex-cli-8493956b9480), Aug 2025
- [KevinLeary.net Blog: "Working with OpenAI’s Codex CLI"](https://www.kevinleary.net/blog/openai-codex-cli/), May 7, 2025
- [Blott Studio: "OpenAI Codex CLI: Build Faster Code Right From Your Terminal"](https://www.blott.studio/blog/post/openai-codex-cli-build-faster-code-right-from-your-terminal), Apr 17, 2025
- [Analytics Vidhya: "How to Install and Use OpenAI Codex CLI Locally?"](https://www.analyticsvidhya.com/blog/2025/05/codex-cli/), May 2025
- [Snyk User Docs: "Codex CLI guide"](https://docs.snyk.io/integrations/developer-guardrails-for-agentic-workflows/quickstart-guides-for-mcp/codex-cli-guide), 2023
- [OpenAI Codex CLI GitHub Issues – (search results for OPENROUTER_API_KEY and quiet mode)](https://github.com/openai/codex/issues)
- [GitHub Issue #2231: "Help output shows incorrect binary name in Usage section"](https://github.com/openai/codex/issues/2231), Aug 12, 2025



