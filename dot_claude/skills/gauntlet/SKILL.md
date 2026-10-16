---
name: gauntlet
description: Run the gauntlet (CRAP, architecture, mutation, exclusion and spec gates) on code written by an agent, in a Workshop sandbox, and read the evidence instead of the code. Use when the user says "gauntlet", asks to prove agent-written Python or Go works, or wants an agent loop with a human-approved spec.
argument-hint: [run|check|loop] [path]
---
`gauntlet` is installed (`~/git/gauntlet`, `uv tool install --editable`). Rules live in `~/.config/gauntlet/policy.toml`
(the user's; never copy it into a repo, never edit it, never edit a repo's `gauntlet.toml` to make a gate pass).

- Prove a change: `gauntlet run .` (tests + mutation in a sandbox, then every gate; writes `.gauntlet/`). Add `--report EVIDENCE.md`.
- Re-check existing results: `gauntlet check .` (uses `.gauntlet/`; "stale" means the source changed: rerun `run`).
- Exit codes: 0 pass, 1 a gate failed (fix the code or tests), 2 refused or error (read the message), 3 spec awaiting approval.
- Fix failures at the cause: split complex functions, write the missing test, strengthen a test for a surviving mutant.
  Never add `# pragma: no cover|no mutate`, `nolint`, `nosec`, coverage `omit`, or relax limits; the exclusion gate will fail.
- Agent loop: `gauntlet loop . --requirement "..."` writes a spec for the user to approve (exit 3). Only after they approve:
  `CLAUDE_CODE_OAUTH_TOKEN="$(cat ~/.config/claude-ws-token)" gauntlet loop . --spec <approved.feature>`.
  The result is `.gauntlet-loop/loop.patch` and `EVIDENCE.md`; the user reviews the patch (control files first) and applies it.
- Go repos need artifacts from their own toolchain unless a stock Go sandbox can build them; see `gauntlet --help` and the README.

Never print the token. Report gate output verbatim; do not summarise a failure as a pass.
