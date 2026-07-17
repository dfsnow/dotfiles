#!/bin/bash
# Stop hook: run prek (or pre-commit) hooks against the files Claude changed.
# No-ops unless prek/pre-commit is installed and we're inside a git repo with changes.
# Exits 2 with the hook output when hooks fail/modify files so Claude wakes to fix them

# Prefer prek; fall back to pre-commit. Both share the `run --files` interface
if command -v prek >/dev/null 2>&1; then
  runner=prek
elif command -v pre-commit >/dev/null 2>&1; then
  runner=pre-commit
else
  exit 0
fi

root=$(git rev-parse --show-toplevel 2>/dev/null) || exit 0
cd "$root" || exit 0

# Only run when hooks are actually configured for this repo.
[ -f .pre-commit-config.yaml ] || [ -f .pre-commit-config.yml ] || [ -f prek.toml ] || exit 0

# Files changed vs HEAD (staged + unstaged) plus new untracked files
tracked=$(git diff --name-only --diff-filter=ACMR HEAD 2>/dev/null)
untracked=$(git ls-files --others --exclude-standard 2>/dev/null)
files=$(printf '%s\n%s\n' "$tracked" "$untracked" | sort -u | grep -v '^$')
[ -z "$files" ] && exit 0

out=$(printf '%s\n' "$files" | xargs "$runner" run --files 2>&1)
code=$?
[ "$code" -eq 0 ] && exit 0

printf '%s hooks reported issues:\n\n%s\n' "$runner" "$out"
exit 2
