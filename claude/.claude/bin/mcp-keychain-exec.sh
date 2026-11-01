#!/bin/bash
# Run a command with secrets loaded from the macOS keychain.

set -euo pipefail

service="claude-mcp"
names=()

while [[ $# -gt 0 && "$1" != "--" ]]; do
  names+=("$1")
  shift
done

if [[ $# -eq 0 ]]; then
  echo "mcp-keychain-exec.sh: missing '--' before the command" >&2
  exit 64
fi
shift

if [[ $# -eq 0 ]]; then
  echo "mcp-keychain-exec.sh: missing command after '--'" >&2
  exit 64
fi

for name in ${names[@]+"${names[@]}"}; do
  if ! value="$(/usr/bin/security find-generic-password -s "$service" -a "$name" -w 2>/dev/null)"; then
    echo "mcp-keychain-exec.sh: no keychain item for service '$service', account '$name'" >&2
    exit 1
  fi
  export "$name=$value"
done

args=()
for arg in "$@"; do
  for name in ${names[@]+"${names[@]}"}; do
    placeholder="{{$name}}"
    arg="${arg//"$placeholder"/${!name}}"
  done
  args+=("$arg")
done

exec "${args[@]}"
