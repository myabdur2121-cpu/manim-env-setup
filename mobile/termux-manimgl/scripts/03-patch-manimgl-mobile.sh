#!/data/data/com.termux/files/usr/bin/bash
set -euo pipefail

python "$(dirname "${BASH_SOURCE[0]}")/patch_manimgl_mobile.py"
