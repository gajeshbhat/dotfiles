#!/usr/bin/env bash
# Checks what chezmoi manages on macOS and Linux: machine files in, repo meta and secrets out.
# Run: ./tests/test-managed.sh   (the Linux case is simulated, so it runs on any OS)
set -euo pipefail
cd "$(dirname "$0")/.."
fail() { echo "FAIL: $*"; exit 1; }

# Managed paths with .chezmoiignore rendered for the given OS
managed_for() {
  local src dst; src=$(mktemp -d); dst=$(mktemp -d)
  cp -R . "$src"; rm -rf "$src/.git"
  sed "s/\.chezmoi\.os/\"$1\"/g" .chezmoiignore >"$src/.chezmoiignore"
  chezmoi --source "$src" --destination "$dst" managed --path-style relative
}
has() { grep -qxF "$2" <<<"$1" || fail "$3: not managed: $2"; }
hasnt() { ! grep -qxF "$2" <<<"$1" || fail "$3: must not be managed: $2"; }

mac=$(managed_for darwin); linux=$(managed_for linux)
macfiles=".zshrc .zprofile .ssh/config .tmux.conf .config/gh/config.yml .gnupg/gpg-agent.conf .chezmoiscripts/30-dev-tools.sh"
for f in $macfiles; do has "$mac" "$f" darwin; hasnt "$linux" "$f" linux; done
has "$linux" .bashrc linux; hasnt "$mac" .bashrc darwin
for f in .claude/settings.json .claude/CLAUDE.md .gitconfig .vimrc; do has "$mac" "$f" darwin; has "$linux" "$f" linux; done
for os in "$mac" "$linux"; do
  for f in AGENTS.md CLAUDE.md tessl.json Brewfile .config/gh/hosts.yml; do hasnt "$os" "$f" any; done
  ! grep -E '^\.ssh/(id_|.*\.pub|known_hosts)' <<<"$os" || fail "ssh keys must not be managed"
done

# Brewfile: parses, and has none of the tools removed from this machine
if command -v brew >/dev/null 2>&1; then
  list=$(brew bundle list --file Brewfile --all)
  for gone in opencode codex auggie hugo terraform localgcp virtualbox transmission; do
    ! grep -qx "$gone" <<<"$list" || fail "Brewfile still lists $gone"
  done
  grep -qx chezmoi <<<"$list" || fail "Brewfile missing chezmoi"
fi

# Scripts are valid bash once rendered
for t in .chezmoiscripts/*.tmpl; do chezmoi execute-template <"$t" | bash -n || fail "$t does not parse"; done
bash -n .chezmoiscripts/run_onchange_after_30-dev-tools.sh || fail "30-dev-tools.sh does not parse"

echo "ok"
