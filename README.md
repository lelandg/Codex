# Codex
Tips and utilities for optimizing your OpenAI Codex CLI installation. 

**_Use at your own risk. This is not an official OpenAI product. It is provided as-is._**

These agents may increase your Codex CLI usage/cost. I have a Pro subscription, so I've never hit a limit. But these agents are new.


## Table of Contents
**Virtual Agents.**

Note that Codex CLI currently doesn't support true agents the way Antrhopic's Codex CLI does. I asked Codex CLI about this, and it offered to create "virtual agents" that would be similar to Antrhopic's agents. This is what I got.
  
- See [Virtual Agents README.md](virtual-agents/README.md)

## Sample run:

PowerShell 7.5.2
PS C:\Users\aboog> pushd D:\Documents\Code\GitHub\.Net\MeshForge\
PS D:\Documents\Code\GitHub\.Net\MeshForge> wsl -d Ubuntu
leland@Alienware:/mnt/d/Documents/Code/GitHub/.Net/MeshForge$ codex

To get started, describe a task or try one of these commands:

/init - create an AGENTS.md file with instructions for Codex
/status - show current session configuration and token usage
First, I need to verify if the agents directory exists in the repository. I’ll l
ist the repo's content as this is read-only. My plan is to check for agents conf
he Docs directory, I’ll print a quick help summary from the top section. Now, le
t’s run the shell to check for 'agents/' and 'Docs/agents/'.**Planning agent exe
cution**

Since using agents involves several steps, I think it’s better to create a plan:
detect agents, show quick help, ask for the playbook and inputs, run the playbo
ok, and summarize what's next. The user is asking for guidance on the next steps

Since using agents involves several steps, I think it’s better to create a plan:
after enabling agents. To do this, I’ll start with a preamble message, check fo
r the existence of directories and the manual, and then display the relevant mes
sages based on the findings. If the manual is missing, I’ll suggest bootstrappin
g with a specific script.
the quick help.

⚙︎ Working
-la Docs/agents '2>/dev/null' '||' echo '(no Docs/agents dir)' '&&' printf "\\n--- Scripts/ ---\\n" '&&' ls -la Scripts '2>/dev/null' '||' echo '(no Scripts dir)'

📋 Updated to do list [███░░░░░░░] 1/4
□ Collect playbook name and inputs

⚙︎ Working
Usage: Scripts/bootstrap-virtual-agents.sh DEST_DIR [--force]
\nBootstraps the local Virtual Agents scaffold into DEST_DIR.
\nOptions:
--force   Overwrite existing files

I noticed that the script needs a DEST_DIR argument. The earlier instructions me
ntioned a default to Docs/agents, but the usage suggests it requires a specific
to ensure the argument is correctly set up to avoid any issues!
⚙︎ Working
⚙︎ Working
L ⌨️ bash Scripts/bootstrap-virtual-agents.sh Docs/agents
ems to be missing, which might cause the script to fail. I could read from Docs/
agents/Virtual-Agents-User-Manual.md, but it’s not there. I could generate a qui
ck help summary from AGENTS.md instead. The guidance suggests enabling agents an
executing.

⚙︎ Working
L 📖 bootstrap-virtual-agents.sh
⌨️ ls -la templates/virtual-agents '2>/dev/null' '||' echo '(no templates/virtual-agents)' '&&' printf "\\nList files under templates recursively (top 40):\\n" '&&' find templates -maxdepth 3 -type f '2>/dev/null' '|' head -40

thinking
**Exploring bootstrap scripts**

I see that the templates directory is missing, which is preventing the root boot
strap script from functioning properly. Hmm, should I check the Scripts/bootstra
p-virtual-agents.sh file? It seems like it might be worth taking a look at that


thinking
**Generating quick help summary**

I need to display the quick help from the manual's top section, but since it's m
issing, I'll create a brief summary instead. I should note that the manual is un
available and mention that we can install it. Also, I’ll make sure to list the a
vailable playbooks under the agents/playbooks directory. Since we’ve already est
ablished that the 'playbooks' directory exists, I’m going to quickly list those
files to show the available choices.

⚙︎ Working
L 📂 playbooks

thinking
**Planning playbook execution**

I'm thinking about how to present these playbooks effectively. The next step wou
ld be to ask the user which specific playbook they want to run and gather the ne
cessary inputs for that. It would be helpful to refer to the 'agents/registry.ya
ml' file to understand how to execute each playbook and what inputs are required
. So, I'll open that file for more details!

⚙︎ Working
L 📖 registry.yaml

thinking
**Reviewing playbooks**

I think it’s time to list some playbooks. Maybe it would be helpful to open a co
uple of them to check the expected inputs. I’ll open 'agents/playbooks/review-do
cs-tests.yaml' and 'review-and-docs.yaml' to take a look at their flows. This wa
y, I can better understand how they operate and gather any necessary information
. Let's see what I can discover from these files!

⚙︎ Working
L ⌨️ echo '--- review-docs-tests.yaml ---'
⌨️ echo "\\n--- review-and-docs.yaml ---"
📖 review-and-docs.yaml
⌨️ for f in 'agents/playbooks/*.yaml;' do echo '--- $(basename $f) ---;' sed -n '1,200p' '$f;' 'echo;' done

thinking
**Updating plan based on available resources**

I need to provide suggestions based on common tasks, but since the manual isn’t
available, I’ll say something like, “The manual is not present; I can install it
, or here’s a condensed quick help…” and list out the playbooks. I’ll need to as
k the user to choose a playbook with required inputs. Also, I have to mark that
step two is complete but with an explanation about the missing manual. Let’s go
ahead and do that!

📋 Updated to do list [█████░░░░░] 2/4
note
Bootstrap script lacks templates; manual not present. Proceeding with a condensed quick help based on agents/registry.yaml and available playbooks.
⎿ ✔ Check agents registry and playbooks
✔ Install/copy the user manual
□ Show quick help summary
□ Collect playbook name and inputs

codex
Using virtual agents (agents/). Manual file not found; I’ll give a quick help su
mmary and we can proceed.

**Quick Help**
- Purpose: Orchestrate multi-step reviews/docs/tests via `agents/playbooks/`.
- Inputs: Provide a `task_id` (e.g., 20250815-001) and playbook-specific fields
  like `changed_files`, `diff_summary`, `since`, or `topic`.
- Outputs: Artifacts saved under `Docs/` (reviews, docs, tests, security, perfor
  mance, codemap).
- Run Style: I execute the selected playbook step-by-step, pass outputs between
  steps, and summarize results.

**Available Playbooks**
- review-docs-tests: Review → Docs → Tests. Needs `changed_files`, `diff_summary
`.
- review-and-docs: Review → Docs only. Optional `changed_files`, `diff_summary`.
- implement-task: Implement a change. Needs `task_description`, `targets`.
- security-gate: Security audit → security notes. Needs `changed_files`.
- performance-sweep: Perf analysis → perf test plan. Needs `changed_files`.
- research: Research a topic. Needs `topic`, optional `constraints`.
- code-map-update: Backup CodeMap → write new codemap file. Needs `changed_files`, `since`.
- code-map-update-inplace: Backup → update `Docs/CodeMap.md` directly. Needs `changed_files`, `since`.

**What’s Next**
- Pick a playbook and provide inputs:
    - review-docs-tests: `task_id`, `changed_files` (list), `diff_summary` (1–3 li
      nes)
    - review-and-docs: `task_id`, `changed_files` (optional), `diff_summary` (opti
      onal)
    - implement-task: `task_id`, `task_description` (1–3 lines), `targets` (paths)
    - security-gate/performance-sweep: `task_id`, `changed_files` (list)
    - code-map-update(-inplace): `task_id`, `changed_files` (list), `since` (e.g.,
      “2 days” or commit range)
    - research: `task_id`, `topic`, `constraints` (optional)

If you want the full user manual installed under `Docs/agents/Virtual-Agents-Use
r-Manual.md`, I can bootstrap it once templates are available, or proceed without it. Which playbook should I run, and what inputs should I use?

▌ Ask Codex to do anything                                                       
⏎ send   Ctrl+J newline   Ctrl+C quit   31192 tokens used   89% context left

--- 
End of session.
Note that this used 11% of my context, just to get started. But I have some detailed "agents"