# How I work (all projects)

## Git
- Work on a feature branch or worktree; never commit to or push `master`/`main`. Push feature branches and open **draft** PRs freely; I review and merge.
- Commits and tags are GPG-signed. If signing fails (`Inappropriate ioctl for device`), stop and ask me to run `! echo unlock | gpg --clearsign > /dev/null`. Never disable signing.
- Conventional commit messages (`feat|fix|refactor|docs|build|style|test|ci: ...`).
- Releases: annotated, signed tags with short release notes (`vX.Y.Z`); on 0.x a breaking change bumps the minor.

## Verification
- Prove changes with automated checks (tests, linters, CI via `gh pr checks`), not by asking me to test by hand. If something can only be verified manually, say so and keep it to one final run.
- Root-cause failures with evidence (logs, bisecting) before proposing fixes; say plainly when a hypothesis was wrong.

## Scripts and docs
- Expose setup as simple one-line shell entry points (`./scripts/setup-dev.sh`, `curl ... | bash`).
- Scripts never read, validate or store my password; let `sudo` / `-K` prompt for themselves.
- Keep READMEs and guides short.

## Process
- For new features, agree the design with me first, briefly; then implement with TDD.
- Keep multi-agent workflows lean (few agents, one review pass), and prefer pinned, well-maintained official sources for tools and packages.
- When skills or plugins disagree: project instructions first, then this file, then ponytail, then everything else.
- Only plugins, skills and tools that work offline with Claude Code itself; no hosted services or third-party API keys (e.g. no context7, no jevgrep).

## Tool routing
- "Where/how does X work?" in an unfamiliar repo: the built-in `Explore` agent (or feature-dev `code-explorer` to trace a flow); exact symbols, strings and filenames: Grep/Glob or gopls.
- A plan or diff about to be committed to: `hyperplan-critic` once.
- Prove agent-written Python/Go works (CRAP, mutation, architecture, spec): `/gauntlet`; its policy is `~/.config/gauntlet/policy.toml`, never inside a repo.
- Long unattended or risky work: `/workshop-agent`; LXD builds and tests: `/vm-test`, never on the host.
- Multi-step feature with a written spec requested: `specify` (Spec Kit); otherwise superpowers brainstorming, then TDD.
- Prose stays terse (Concise style, caveman); code, commits and PR text are written normally.
