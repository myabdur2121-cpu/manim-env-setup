#!/data/data/com.termux/files/usr/bin/bash
set -euo pipefail

say() { printf '\n[packages] %s\n' "$*"; }

say "Updating package lists"
pkg update

say "Installing repositories needed for graphics and scientific Python packages"
pkg install -y x11-repo tur-repo
pkg update

say "Installing base build/runtime packages"
pkg install -y \
    bash coreutils findutils grep sed gawk which procps \
    git curl wget nano tmux termux-api \
    python clang cmake make pkg-config rust binutils patchelf \
    ffmpeg \
    freetype fontconfig harfbuzz fribidi pango libcairo \
    libjpeg-turbo libpng libtiff libwebp libffi openssl zlib \
    libandroid-execinfo openblas libxml2 libxslt

say "Installing Termux Python binary packages where available"
# These avoid slow/failing pip builds on Android. Some names can vary by repo state,
# so install one-by-one and keep going for optional packages.
for p in python-numpy python-scipy python-pillow matplotlib; do
    if pkg install -y "$p"; then
        echo "installed: $p"
    else
        echo "optional package not installed by pkg: $p"
    fi
done

say "Installing clean GPU stack"
# mesa is the good path. It may remove old TUR mesa-zink if present.
pkg install -y mesa mesa-demos mesa-vulkan-icd-freedreno mesa-vulkan-icd-swrast vulkan-loader-generic vulkan-tools

say "Graphics packages now installed"
pkg list-installed | grep -Ei 'mesa|virgl|vulkan|angle' || true

if pkg list-installed | grep -q '^mesa-zink/'; then
    echo
    echo "WARNING: mesa-zink is still installed. This old TUR package caused broken ManimGL strokes."
    echo "Run manually: pkg install mesa"
fi
