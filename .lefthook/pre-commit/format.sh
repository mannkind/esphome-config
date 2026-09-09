#!/usr/bin/env bash
# Format staged YAML with prettier.
#
# mise.toml pins prettier and is tracked, so `mise exec` is the normal path.
# The fallbacks keep the hook working for anyone without mise installed.
set -euo pipefail

[ $# -eq 0 ] && exit 0

if command -v prettier >/dev/null 2>&1; then
  prettier --write "$@"
elif command -v mise >/dev/null 2>&1 && mise exec -- prettier --version >/dev/null 2>&1; then
  mise exec -- prettier --write "$@"
elif command -v npx >/dev/null 2>&1; then
  npx --yes prettier@3 --write "$@"
else
  echo "pre-commit: no prettier found." >&2
  echo "            install it with: mise use prettier@3" >&2
  exit 1
fi
