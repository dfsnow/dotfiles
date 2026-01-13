#!/bin/bash

QUERY=$(cat | jq -r '.query')
PROJECT_DIR="${CLAUDE_PROJECT_DIR:-.}"
cd "$PROJECT_DIR" || exit 1

rg --files --follow --hidden --no-ignore -g '!{.npm,.rustup,.tldrc,.tldr,.cargo,.git,.Rproj.user,.mypy_cache}/' -g '!{node_modules,renv,venv,.venv}/' . 2>/dev/null | sort -u | fzf --filter "$QUERY" | head -15
