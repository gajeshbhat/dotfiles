#!/usr/bin/env bash
# Checks for the tracked Claude Code config. Run: ./tests/test-claude.sh
set -euo pipefail
cd "$(dirname "$0")/.."
fail() { echo "FAIL: $*"; exit 1; }

jq -e . dot_claude/settings.json >/dev/null || fail "settings.json is not valid JSON"

# statusline: dir, branch, model and context % from Claude Code's JSON on stdin
home=$(mktemp -d); trap 'rm -rf "$home"' EXIT
git init -q -b demo "$home/proj"
out=$(echo "{\"model\":{\"display_name\":\"Opus\"},\"workspace\":{\"current_dir\":\"$home/proj\"},\"context_window\":{\"used_percentage\":42.4}}" \
  | CLAUDE_CONFIG_DIR="$home" bash dot_claude/executable_statusline.sh | sed 's/\x1b\[[0-9;]*m//g')
[ "$out" = "proj (demo) · Opus · 42% ctx" ] || fail "statusline: got '$out'"

# missing optional fields must not break it
out=$(echo '{"model":{"display_name":"Opus"},"workspace":{"current_dir":"/"}}' \
  | CLAUDE_CONFIG_DIR="$home/none" bash dot_claude/executable_statusline.sh)
[ "$out" = "/ · Opus" ] || fail "statusline minimal: got '$out'"

echo "ok"
