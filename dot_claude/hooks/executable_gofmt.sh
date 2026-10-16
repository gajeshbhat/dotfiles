#!/usr/bin/env bash
# PostToolUse: gofmt edited .go files. Formatting only; builds and tests stay in the VM.
f=$(jq -r '.tool_input.file_path // empty')
[[ $f == *.go && -f $f ]] && command -v gofmt >/dev/null && gofmt -w "$f"
exit 0
