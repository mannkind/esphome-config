#!/usr/bin/env bash
# Compile firmware for every device, or just the ones named as arguments.
# Slow on a cold .esphome cache; esphome caches builds, so reruns are quick.
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

# esphome lives in the project venv; mise doesn't manage it.
ESPHOME="$REPO_ROOT/.venv/bin/esphome"

cd "$REPO_ROOT"
[ -x "$ESPHOME" ] || {
  echo "error: no esphome at $ESPHOME (run: source .venv/bin/activate)" >&2
  exit 1
}

if [ $# -gt 0 ]; then targets="$*"; else targets=$(ls the_*.yaml); fi

failed=() checked=0
for d in $targets; do
  checked=$((checked + 1))
  echo "unit: compiling $d"
  # Keep going after a failure so one run reports every broken device.
  if ! "$ESPHOME" compile "$d"; then
    failed+=("$d")
  fi
done

echo
if [ "${#failed[@]}" -gt 0 ]; then
  echo "unit: ${#failed[@]} of $checked device(s) failed to compile"
  printf '  %s\n' "${failed[@]}"
  exit 1
fi
echo "unit: $checked device(s) compiled"
