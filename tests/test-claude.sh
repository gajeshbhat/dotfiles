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

# hooks: block generated files, pass others; gofmt formats .go
h=dot_claude/hooks
echo '{"tool_input":{"file_path":"/r/doc/rest-api.yaml"}}' | bash $h/executable_block-generated.sh 2>/dev/null && fail "generated file not blocked"
echo '{"tool_input":{"file_path":"/r/lxd/main.go"}}' | bash $h/executable_block-generated.sh || fail "normal file blocked"
printf 'package x\nfunc  f( ){}\n' >"$home/a.go"
echo "{\"tool_input\":{\"file_path\":\"$home/a.go\"}}" | bash $h/executable_gofmt.sh
! command -v gofmt >/dev/null || [ -z "$(gofmt -l "$home/a.go")" ] || fail "gofmt hook did not format"
jq -e '.hooks.PreToolUse and .hooks.PostToolUse' dot_claude/settings.json >/dev/null || fail "hooks missing in settings"

jq -e '.enabledPlugins["caveman@caveman"] and .extraKnownMarketplaces.caveman' dot_claude/settings.json >/dev/null || fail "caveman missing"
grep -q '^name: jevgrep' dot_claude/skills/jevgrep/SKILL.md || fail "jevgrep skill missing"
grep -q '## Tool routing' dot_claude/CLAUDE.md || fail "routing missing"

echo "ok"
