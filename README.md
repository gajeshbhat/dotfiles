# dotfiles

Personal dotfiles managed with [chezmoi](https://www.chezmoi.io).

```sh
sh -c "$(curl -fsLS get.chezmoi.io)" -- -b ~/.local/bin init --apply gajeshbhat/dotfiles   # new machine
dotfiles-backup          # push local edits back here
./tests/test-claude.sh   # check Claude config
./tests/test-managed.sh  # check what chezmoi manages
./tests/workshop.sh      # fresh-machine restore in Ubuntu 24.04 + 26.04 Workshop containers
```

`init` prompts for Git name/email and templates `~/.gitconfig`, which includes an
untracked `~/.gitconfig.local` for machine-specific settings (signing key etc.).

## Tracked

- Shell: `.bashrc` (Linux; PATH for uv, Go, Rust, fvm/Flutter), `.zshrc` (macOS only)
- `.vimrc` + `.vimrc.plug` (vim-plug installed and plugins synced on apply), `.screenrc`, `.gitconfig`
- Claude Code: `~/.claude/settings.json`, `~/.claude/CLAUDE.md` (my working preferences), `~/.claude/statusline.sh`, `~/.claude/skills/workshop-agent`
- macOS only (ignored on Linux): `Brewfile` (formulae, casks, App Store, VS Code extensions; `brew bundle` runs on apply), `.zprofile`, `~/.ssh/config`, `~/.tmux.conf`, `~/.gnupg/gpg-agent.conf`, `~/.config/gh/config.yml`
- macOS: dev tools outside brew (pinned Go tools, `@openrig/cli`, `skillkit`, the Tessl MCP server) by `.chezmoiscripts/*30-dev-tools.sh`
- `~/.local/bin/dotfiles-backup`

Never tracked: credentials (`~/.ssh` keys, `~/.config/gh/hosts.yml`, `~/.tessl`), shell history, sessions, projects, caches, `~/.claude/skills/synced/`.

## Claude Code

Settings: `auto` permission mode, Concise output style, small multi-agent workflows,
worktrees from fresh `origin`, auto-continue at usage limits. Statusline:
`dir (branch) · model · context % [PONYTAIL]`. Unused skills are off (browser, computer-use,
Office, `morning`, `import-memory`); ponytail's skills are slash-only except `ponytail-review`.

On apply, marketplaces are added, every enabled plugin installed, and the language servers
for the LSP plugins (rust-analyzer via rustup, gopls via go, pyright via uv) installed if missing:

| Plugin | Marketplace | What for |
|---|---|---|
| ponytail | [DietrichGebert/ponytail](https://github.com/DietrichGebert/ponytail) | Simplest-solution mode and over-engineering reviews. Update by hand: `claude plugin update ponytail@ponytail` |
| superpowers | claude-plugins-official | SDLC skills: brainstorm, plan, TDD, debug, review (auto-workspace's workflow uses them) |
| feature-dev | claude-plugins-official | code-explorer/architect/reviewer agents |
| claude-code-setup | claude-plugins-official | Recommends hooks, skills, MCP servers for a repo |
| security-guidance | claude-plugins-official | Security warnings on edits and commits |
| rust-analyzer-lsp, gopls-lsp, pyright-lsp | claude-plugins-official | Code intelligence for Rust, Go, Python |

### Agents in a Workshop sandbox

The `workshop-agent` skill (`/workshop-agent <task>`, or "do this in the sandbox") runs a second
Claude Code with no permission prompts inside a [Workshop](https://ubuntu.com/workshop) container
of the current project and brings the result back. One-time setup per machine:

```sh
sudo snap install workshop --classic
claude setup-token   # browser login; save the printed token:
install -D -m 600 /dev/stdin ~/.config/claude-ws-token   # paste, Enter, Ctrl-D
```

Only the project directory is shared with the sandbox. Its network is not restricted (internet,
LAN and host services are reachable), so it protects the rest of the host's files, not secrets
you put in the project.

## Machine setup

Apps and toolchains are installed by [auto-workspace](https://github.com/gajeshbhat/auto-workspace)
(Ubuntu 24.04/26.04), which also applies these dotfiles: Docker, KVM/LXD, VirtualBox, Multipass,
Wine, Chrome, VS Code, gh, Rust, Go, uv, Flutter (fvm), dotrun and Claude Code.
