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

@../.tessl/RULES.md
