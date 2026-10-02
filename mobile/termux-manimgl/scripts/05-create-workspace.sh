#!/data/data/com.termux/files/usr/bin/bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
WORK="$HOME/manimgl-workspace"
mkdir -p "$WORK"

if [ ! -f "$WORK/test_scene.py" ]; then
    cp "$ROOT_DIR/examples/test_scene.py" "$WORK/test_scene.py"
    echo "created: $WORK/test_scene.py"
else
    echo "exists: $WORK/test_scene.py"
fi

mkdir -p "$WORK/docs"
pkg list-installed | grep -Ei 'mesa|virgl|vulkan|angle' > "$WORK/docs/graphics-packages-after-install.txt" || true

echo "workspace ready: $WORK"
