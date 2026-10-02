#!/data/data/com.termux/files/usr/bin/bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

printf '\n=== Termux ManimGL Mobile GPU Installer ===\n\n'
printf 'This installs 3Blue1Brown ManimGL, not Manim Community Edition.\n'
printf 'Target GPU path: normal mesa 26.x + Zink + Turnip/Freedreno.\n\n'

if [ ! -d /data/data/com.termux/files/usr ]; then
    echo "ERROR: This installer is intended for Android Termux."
    exit 1
fi

bash "$ROOT_DIR/scripts/00-system-info.sh"
bash "$ROOT_DIR/scripts/01-install-packages.sh"
bash "$ROOT_DIR/scripts/02-install-python-deps.sh"
bash "$ROOT_DIR/scripts/03-patch-manimgl-mobile.sh"
bash "$ROOT_DIR/scripts/04-create-wrappers.sh"
bash "$ROOT_DIR/scripts/05-create-workspace.sh"
bash "$ROOT_DIR/scripts/06-run-tests.sh"

printf '\n=== Install complete ===\n\n'
printf 'Next commands:\n\n'
printf '  cd ~/manimgl-workspace\n'
printf '  check-manimgl-gpu\n'
printf '  rendergpu test_scene.py MobileRenderTest --hd\n\n'
printf 'CPU fallback:\n\n'
printf '  rendercpu test_scene.py MobileRenderTest --hd\n\n'
