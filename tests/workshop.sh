#!/usr/bin/env bash
# Fresh-machine restore test in Workshop containers: ./tests/workshop.sh [noble|resolute]...
set -euo pipefail

if [ "${1:-}" = --inside ]; then
  # the checkout is mounted at /project; --source tests it as-is, uncommitted edits included
  sudo apt-get update -qq && sudo apt-get install -y -qq curl git jq vim >/dev/null
  cd ~
  sh -c "$(curl -fsLS get.chezmoi.io)" -- -b ~/.local/bin init --apply --source /project \
    --promptString "Git name=Test User" --promptString "Git email=test@example.com"
  cz() { ~/.local/bin/chezmoi --source /project "$@"; }
  cz verify
  [ -z "$(cz status)" ]
  [ "$(git config --global user.email)" = test@example.com ]
  [ -x ~/.claude/statusline.sh ]
  [ -f ~/.claude/skills/workshop-agent/SKILL.md ]
  [ -f ~/.vim/autoload/plug.vim ]
  [ ! -e ~/.zshrc ]
  [ ! -e ~/README.md ]
  [ ! -e ~/tests ]
  [ ! -e ~/.workshop ]
  /project/tests/test-claude.sh
  exit
fi

cd "$(dirname "$0")/.."
[ $# -gt 0 ] || set -- noble resolute
for w; do
  echo "== $w"
  workshop remove "$w" 2>/dev/null || true # left over from a failed run
  workshop launch "$w"
  workshop exec "$w" -- bash -x /project/tests/workshop.sh --inside
  workshop remove "$w"
done
echo "ok"
