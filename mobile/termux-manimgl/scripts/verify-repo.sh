#!/usr/bin/env bash
set -euo pipefail
ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT_DIR"

echo "[verify] shell syntax"
for f in install.sh scripts/*.sh scripts/bin/*; do
    bash -n "$f"
    echo "OK $f"
done

echo "[verify] python syntax"
python3 -m py_compile scripts/patch_manimgl_mobile.py

echo "[verify] required files"
for f in README.md examples/test_scene.py scripts/bin/rendergpu scripts/bin/rendercpu scripts/bin/background docs/00-copy-paste-install.md; do
    test -f "$f"
    echo "OK $f"
done

echo "[verify] done"
