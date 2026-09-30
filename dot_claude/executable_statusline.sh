#!/usr/bin/env bash
# Claude Code statusline: dir (branch) · model · context % [ponytail badge]
in=$(cat)
dir=$(jq -r '.workspace.current_dir // .cwd' <<<"$in")
line=$(basename "$dir")
branch=$(git -C "$dir" branch --show-current 2>/dev/null) && [ -n "$branch" ] && line+=" ($branch)"
line+=" · $(jq -r '.model.display_name' <<<"$in")"
ctx=$(jq -r '.context_window.used_percentage // empty | floor' <<<"$in")
[ -n "$ctx" ] && line+=" · ${ctx}% ctx"
printf '%s' "$line"

# ponytail's own statusline script lives under a versioned plugin cache path
badge=$(ls -d "${CLAUDE_CONFIG_DIR:-$HOME/.claude}"/plugins/cache/ponytail/ponytail/*/hooks/ponytail-statusline.sh 2>/dev/null | sort -V | tail -1)
[ -n "$badge" ] && b=$(bash "$badge") && [ -n "$b" ] && printf ' %s' "$b"
exit 0
