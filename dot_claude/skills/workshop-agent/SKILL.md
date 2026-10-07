---
name: workshop-agent
description: Delegate a task to a Claude Code agent running unattended (no permission prompts) inside a Canonical Workshop (LXD) sandbox of the current project. Use when the user says "in the sandbox", "in a workshop", "yolo this", or wants risky, messy or long unattended work kept off the host.
argument-hint: [task]
---
The project directory is mounted read-write at `/project` in the sandbox; nothing else on the host is.
Workshop name: `agent`. Run everything from the project root (the directory that holds, or will hold,
`.workshop/`); from anywhere else, add `-p <project-root>` to every `workshop` command.

1. Bring it up (each step may fail harmlessly if already done):

       [ -f .workshop/agent.yaml ] || workshop init agent --sdks claude-code
       workshop launch agent 2>/dev/null || workshop start agent 2>/dev/null || true

   The task needs a toolchain? Add SDKs to `.workshop/agent.yaml` (`workshop.sdk find <term>`: go, rust,
   node, uv, flutter, docker-ce) and `workshop refresh agent`; anything else, the agent can `sudo apt install`.

2. Delegate. Write a self-contained prompt: the sandbox agent sees the repo but none of this conversation.
   Use run_in_background for anything likely to exceed 10 minutes.

       CLAUDE_CODE_OAUTH_TOKEN="$(cat ~/.config/claude-ws-token)" \
       workshop exec --env CLAUDE_CODE_OAUTH_TOKEN agent -- \
         claude -p "<task>" --dangerously-skip-permissions --output-format json \
         | jq -r '.session_id, .is_error, .result'

3. Follow up in the same session: the same command plus `--resume <session_id>`.

4. Check `.is_error`, not the exit code. No three-line output at all means the command never reached
   claude: read stderr and redo step 1. "Not logged in" (token file missing) or "Failed to authenticate
   ... 401" (token invalid or expired): ask the user to run `claude setup-token` and save the printed
   token to `~/.config/claude-ws-token` (mode 600).

5. Afterwards review `git diff` on the host and commit here: the sandbox has no git identity, SSH or GPG
   keys, so tell the agent not to commit. Files it created with sudo are owned by a mapped uid; delete
   and recreate them if they need editing. `.workshop/agent.yaml` and `.workshop.lock` are Workshop's, not
   the agent's: commit the first, gitignore the second. Tear down with `workshop remove agent`.

Never print the token. The sandbox has open network access (internet, LAN, host services), so do not
delegate tasks that involve untrusted input together with secrets placed in the project directory.

Task: $ARGUMENTS
