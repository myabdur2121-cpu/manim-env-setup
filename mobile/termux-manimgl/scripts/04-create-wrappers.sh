#!/data/data/com.termux/files/usr/bin/bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

install_bin() {
    local src="$1"
    local dst="$PREFIX/bin/$(basename "$src")"
    cp "$src" "$dst"
    chmod +x "$dst"
    echo "installed: $dst"
}

install_bin "$ROOT_DIR/scripts/bin/manimgl-gpu"
install_bin "$ROOT_DIR/scripts/bin/manimgl-cpu"
install_bin "$ROOT_DIR/scripts/bin/rendercore"
install_bin "$ROOT_DIR/scripts/bin/rendergpu"
install_bin "$ROOT_DIR/scripts/bin/rendercpu"
install_bin "$ROOT_DIR/scripts/bin/rendergl"
install_bin "$ROOT_DIR/scripts/bin/rendergl-safe"
install_bin "$ROOT_DIR/scripts/bin/check-manimgl-gpu"
install_bin "$ROOT_DIR/scripts/bin/check-manimgl-cpu"
install_bin "$ROOT_DIR/scripts/bin/test-manimgl-mobile"
install_bin "$ROOT_DIR/scripts/bin/stop-background"
install_bin "$ROOT_DIR/scripts/bin/check-background"
install_bin "$ROOT_DIR/scripts/bin/background"

printf '\nWrapper commands installed.\n'
