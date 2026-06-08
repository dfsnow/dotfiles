#!/usr/bin/env bash
key=$(security find-generic-password -s "claude-code" -a "$USER" -w 2>/dev/null)
# Trim leading/trailing whitespace, emit without trailing newline
key="${key#"${key%%[![:space:]]*}"}"
key="${key%"${key##*[![:space:]]}"}"
printf '%s' "$key"
