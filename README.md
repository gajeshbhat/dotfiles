# dotfiles

Personal dotfiles managed with [chezmoi](https://www.chezmoi.io).

```sh
chezmoi init --apply gajeshbhat/dotfiles
```

Prompts for your Git name/email and templates `~/.gitconfig`, which includes
an untracked `~/.gitconfig.local` for machine-specific settings. Also applies
`~/.local/bin/dotfiles-backup`, which re-adds local edits (including
`~/.claude/settings.json`) and pushes them back here.

Tracked: `.bashrc`/`.zshrc` (OS-specific), `.vimrc`, `.vimrc.plug`,
`.screenrc`, `.gitconfig`, a portable subset of `~/.claude/settings.json`,
and scripts to install vim-plug and enabled Claude plugins on apply.

Never tracked: credentials, shell history, sessions, projects, caches, or
`~/.claude/skills/synced/`.
