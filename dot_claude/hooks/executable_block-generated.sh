#!/usr/bin/env bash
# PreToolUse: refuse hand edits to generated files (regenerate them with their make target).
f=$(jq -r '.tool_input.file_path // empty')
case "$f" in
  */doc/rest-api.yaml|*/doc/metadata.txt|*/lxd/metadata/configuration.json|\
  */lxd/auth/entitlements_generated.go|*/lxd/auth/drivers/openfga_model.openfga|*.mapper.go)
    echo "Generated file, do not edit by hand: $f (regenerate with its make update-* target)" >&2
    exit 2 ;;
esac
