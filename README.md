# dotfiles

Personal dotfiles managed with [chezmoi](https://www.chezmoi.io).

```sh
sh -c "$(curl -fsLS get.chezmoi.io)" -b ~/.local/bin -- init --apply gajeshbhat/dotfiles   # new machine
dotfiles-backup                                                                          # push local edits back here
./tests/test-claude.sh                                                                   # check Claude config
```

`init` prompts for Git name/email and templates `~/.gitconfig`, which includes an
untracked `~/.gitconfig.local` for machine-specific settings (signing key etc.).

## Tracked

- Shell: `.bashrc` (Linux; PATH for uv, Go, Rust, fvm/Flutter), `.zshrc` (macOS only)
- `.vimrc` + `.vimrc.plug` (vim-plug installed and plugins synced on apply), `.screenrc`, `.gitconfig`
- Claude Code: `~/.claude/settings.json`, `~/.claude/CLAUDE.md` (my working preferences), `~/.claude/statusline.sh`
- `~/.local/bin/dotfiles-backup`

Never tracked: credentials, shell history, sessions, projects, caches, `~/.claude/skills/synced/`.

## Claude Code

Settings: `auto` permission mode, Concise output style, small multi-agent workflows,
worktrees from fresh `origin`, auto-continue at usage limits; computer-use, browser,
`morning` and `import-memory` skills off. Statusline: `dir (branch) · model · context % [PONYTAIL]`.
On apply, marketplaces are added, every enabled plugin installed, and the language servers for
the LSP plugins (rust-analyzer via rustup, gopls via go, pyright via uv) installed if missing:

| Plugin | Marketplace | What for |
|---|---|---|
| superpowers | claude-plugins-official | SDLC skills: brainstorm, plan, TDD, debug, subagent execution, review |
| feature-dev | claude-plugins-official | Guided feature work; code-explorer/architect/reviewer agents |
| security-guidance | claude-plugins-official | Security warnings on edits (e.g. GitHub Actions injection) |
| claude-code-setup | claude-plugins-official | Recommends hooks, skills, MCP servers for a repo |
| receipts | claude-plugins-official | Personal Claude Code usage/impact report |
| mcp-server-dev | claude-plugins-official | Building MCP servers and apps |
| rust-analyzer-lsp, gopls-lsp, pyright-lsp | claude-plugins-official | Code intelligence (diagnostics, go-to-definition) for Rust, Go, Python |
| context7 | claude-plugins-official | Up-to-date library docs via Context7's hosted MCP server |
| ponytail | [DietrichGebert/ponytail](https://github.com/DietrichGebert/ponytail) | Simplest-solution mode and over-engineering reviews |

Installed but disabled: `code-review`, `desktop-commander`.

## Machine setup

Apps and toolchains are installed by [auto-workspace](https://github.com/gajeshbhat/auto-workspace)
(Ubuntu 24.04/26.04), which also applies these dotfiles: Docker, KVM/LXD, VirtualBox, Multipass,
Wine, Chrome, VS Code, gh, Rust, Go, uv, Flutter (fvm), dotrun and Claude Code.
