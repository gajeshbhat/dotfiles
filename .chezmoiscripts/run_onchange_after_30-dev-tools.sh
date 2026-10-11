#!/usr/bin/env bash
# Dev tools outside brew, pinned to the versions in use. Re-runs when this file changes.
set -uo pipefail

if command -v go >/dev/null 2>&1; then
  for pkg in honnef.co/go/tools/cmd/staticcheck@v0.6.1 \
             golang.org/x/tools/cmd/godoc@v0.1.0-deprecated \
             github.com/go-swagger/go-swagger/cmd/swagger@v0.33.1 \
             google.golang.org/protobuf/cmd/protoc-gen-go@v1.36.9 \
             google.golang.org/grpc/cmd/protoc-gen-go-grpc@v1.5.1; do
    [ -x "$HOME/go/bin/$(basename "${pkg%@*}")" ] || { go install "$pkg" && echo "[+] $pkg"; }
  done
fi

if command -v npm >/dev/null 2>&1; then
  for pkg in @openrig/cli@0.6.8 skillkit@1.24.0; do
    npm ls -g --depth=0 "${pkg%@*}" >/dev/null 2>&1 || { npm install -g "$pkg" >/dev/null && echo "[+] $pkg"; }
  done
fi

# Tessl MCP server for Claude Code (the tessl CLI itself is installed separately)
if command -v claude >/dev/null 2>&1 && command -v tessl >/dev/null 2>&1; then
  claude mcp get tessl >/dev/null 2>&1 || { claude mcp add --scope user tessl -- tessl mcp start >/dev/null && echo "[+] tessl MCP"; }
fi
