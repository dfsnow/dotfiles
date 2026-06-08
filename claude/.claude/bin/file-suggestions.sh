#!/bin/bash

QUERY=$(jq -r '.query')
PROJECT_DIR="${CLAUDE_PROJECT_DIR:-.}"
cd "$PROJECT_DIR" || exit 1

eval rg --files --follow --hidden --no-ignore $FZF_RG_IGNORES . 2>/dev/null | sort -u | fzf --filter "$QUERY" | head -15
