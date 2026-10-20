#!/usr/bin/env bash
if ! key=$(security find-generic-password -s "claude-code" -a "$USER" -w 2>/dev/null); then
    echo "No 'claude-code' API key found in the Keychain for $USER" >&2
    exit 1
fi

# Trim leading/trailing whitespace, emit without trailing newline
key="${key#"${key%%[![:space:]]*}"}"
key="${key%"${key##*[![:space:]]}"}"
printf '%s' "$key"
