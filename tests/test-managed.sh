#!/usr/bin/env bash
# Checks what chezmoi manages: machine files in, repo meta and secrets out. Run: ./tests/test-managed.sh
set -euo pipefail
cd "$(dirname "$0")/.."
fail() { echo "FAIL: $*"; exit 1; }

managed=$(chezmoi --source "$PWD" --destination "$(mktemp -d)" managed --path-style relative)
has() { grep -qxF "$1" <<<"$managed" || fail "not managed: $1"; }
hasnt() { ! grep -qxF "$1" <<<"$managed" || fail "must not be managed: $1"; }

for f in .zshrc .zprofile .tmux.conf .ssh/config .config/gh/config.yml .gnupg/gpg-agent.conf; do has "$f"; done
for f in AGENTS.md CLAUDE.md tessl.json Brewfile .config/gh/hosts.yml; do hasnt "$f"; done
! grep -E '^\.ssh/(id_|.*\.pub|known_hosts)' <<<"$managed" || fail "ssh keys must not be managed"

# Brewfile: parses, and has none of the tools removed from this machine
list=$(brew bundle list --file Brewfile --all)
for gone in opencode codex auggie hugo terraform localgcp virtualbox transmission; do
  ! grep -qx "$gone" <<<"$list" || fail "Brewfile still lists $gone"
done
grep -qx chezmoi <<<"$list" || fail "Brewfile missing chezmoi"

# Scripts are valid bash once rendered
for t in .chezmoiscripts/*.tmpl; do chezmoi execute-template <"$t" | bash -n || fail "$t does not parse"; done
bash -n .chezmoiscripts/run_onchange_after_30-dev-tools.sh || fail "30-dev-tools.sh does not parse"

echo "ok"
