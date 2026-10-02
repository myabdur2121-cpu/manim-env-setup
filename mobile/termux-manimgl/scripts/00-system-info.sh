#!/data/data/com.termux/files/usr/bin/bash
set -euo pipefail

echo
printf '--- System info ---\n'
printf 'PREFIX: %s\n' "$PREFIX"
printf 'HOME  : %s\n' "$HOME"
printf 'ARCH  : %s\n' "$(uname -m)"
if command -v python >/dev/null 2>&1; then
    python --version || true
else
    echo 'python: not installed yet'
fi
printf '%s\n' '-------------------'
