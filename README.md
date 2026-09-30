# dotfiles

Personal dotfiles managed with [chezmoi](https://www.chezmoi.io).

```sh
chezmoi init --apply gajeshbhat/dotfiles   # new machine
dotfiles-backup                            # push local edits back here
```

`init` prompts for Git name/email and templates `~/.gitconfig`, which includes an
untracked `~/.gitconfig.local` for machine-specific settings (signing key etc.).

## Tracked

- Shell: `.bashrc` (Linux; PATH for uv, Go, Rust, fvm/Flutter), `.zshrc` (macOS only)
- `.vimrc` + `.vimrc.plug` (vim-plug installed and plugins synced on apply), `.screenrc`, `.gitconfig`
- Claude Code: `~/.claude/settings.json`, `~/.claude/CLAUDE.md` (my working preferences)
- `~/.local/bin/dotfiles-backup`

Never tracked: credentials, shell history, sessions, projects, caches, `~/.claude/skills/synced/`.

## Claude Code

Settings: `auto` permission mode, Concise output style, small multi-agent workflows,
worktrees from fresh `origin`, auto-continue at usage limits; computer-use, browser,
`morning` and `import-memory` skills off. On apply, marketplaces are added and every
enabled plugin installed:

| Plugin | Marketplace | What for |
|---|---|---|
| superpowers | claude-plugins-official | SDLC skills: brainstorm, plan, TDD, debug, subagent execution, review |
| feature-dev | claude-plugins-official | Guided feature work; code-explorer/architect/reviewer agents |
| security-guidance | claude-plugins-official | Security warnings on edits (e.g. GitHub Actions injection) |
| claude-code-setup | claude-plugins-official | Recommends hooks, skills, MCP servers for a repo |
| receipts | claude-plugins-official | Personal Claude Code usage/impact report |
| mcp-server-dev | claude-plugins-official | Building MCP servers and apps |
| ponytail | [DietrichGebert/ponytail](https://github.com/DietrichGebert/ponytail) | Simplest-solution mode and over-engineering reviews |

Installed but disabled: `code-review`, `desktop-commander`.

## Machine setup

Apps and toolchains are installed by [auto-workspace](https://github.com/gajeshbhat/auto-workspace)
(Ubuntu 24.04/26.04), which also applies these dotfiles: Docker, KVM/LXD, VirtualBox, Multipass,
Wine, Chrome, VS Code, gh, Rust, Go, uv, Flutter (fvm), dotrun and Claude Code.
