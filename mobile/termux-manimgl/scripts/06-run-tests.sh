#!/data/data/com.termux/files/usr/bin/bash
set -euo pipefail

echo
echo "--- Running ManimGL mobile smoke tests ---"
if command -v test-manimgl-mobile >/dev/null 2>&1; then
    test-manimgl-mobile
else
    echo "test-manimgl-mobile command not found"
    exit 1
fi
