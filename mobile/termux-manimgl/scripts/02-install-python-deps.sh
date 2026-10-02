#!/data/data/com.termux/files/usr/bin/bash
set -euo pipefail

say() { printf '\n[pip] %s\n' "$*"; }

say "Upgrading pip and pinning setuptools"
python -m pip install --upgrade pip wheel
python -m pip install --upgrade 'setuptools==81.0.0'

say "Installing ManimGL Python dependencies"
# Notes:
# - ipython is pinned because newer versions may pull psutil>=7, which can fail on Android.
# - mapbox-earcut is pinned because latest builds failed in tested Termux/Python 3.14.
# - skia-pathops is intentionally skipped; a local pathops.py compatibility stub is installed later.
python -m pip install --upgrade \
    addict appdirs colour diskcache fonttools \
    'ipython==8.37.0' \
    'mapbox-earcut==1.0.3' \
    'moderngl==5.12.0' \
    'glcontext==3.0.0' \
    'moderngl-window==3.1.1' \
    'pyglet==2.1.16' \
    'PyOpenGL' \
    'pyglm==2.8.3' \
    'isosurfaces==0.1.2' \
    manimpango pydub pygments pyperclip pyyaml rich screeninfo \
    'svgelements>=1.8.1' sympy tqdm validators

say "Installing ManimGL itself without dependency auto-resolution"
python -m pip install --upgrade --no-deps 'manimgl==1.7.2'

say "Python package check"
python - <<'PY'
import sys
print('python:', sys.version)
mods = [
    'numpy', 'scipy', 'PIL', 'matplotlib', 'moderngl', 'glcontext',
    'manimpango', 'mapbox_earcut', 'pyglet', 'OpenGL'
]
for name in mods:
    try:
        mod = __import__(name)
        print('OK', name, getattr(mod, '__version__', ''))
    except Exception as e:
        print('WARN', name, repr(e))
PY
