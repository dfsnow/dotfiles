#!/bin/bash
QUERY=$(jq -r '.query // ""')
cd "${CLAUDE_PROJECT_DIR:-.}" || exit 1

# Search without a path argument, so rg prints paths without a "./" prefix
eval rg --files --follow --hidden --no-ignore "$FZF_RG_IGNORES" 2>/dev/null \
    | fzf --filter "$QUERY" --scheme=path \
    | head -15
