#!/usr/bin/env python3
"""Patch ManimGL for Android Termux headless EGL rendering."""
from __future__ import annotations

import pathlib
import sys
import sysconfig

PURELIB = pathlib.Path(sysconfig.get_paths()["purelib"])
MANIMLIB = PURELIB / "manimlib"

if not MANIMLIB.exists():
    raise SystemExit(f"manimlib not found at {MANIMLIB}. Install manimgl first.")


def backup(path: pathlib.Path) -> pathlib.Path:
    b = path.with_suffix(path.suffix + ".mobile_backup")
    if not b.exists():
        b.write_text(path.read_text())
    return b


def patch_init() -> None:
    path = MANIMLIB / "__init__.py"
    text = path.read_text()
    marker = "MANIMGL_MOBILE_HEADLESS_PATCH"
    if marker in text:
        print("already patched:", path)
        return
    backup(path)
    patch = '''# MANIMGL_MOBILE_HEADLESS_PATCH_BEGIN
# Android Termux has no normal desktop display.  Set pyglet headless mode
# before ManimGL imports manimlib.window / pyglet.window.
import os as _manimgl_mobile_os
if _manimgl_mobile_os.environ.get("MANIMGL_MOBILE_HEADLESS", "0") == "1":
    _manimgl_mobile_os.environ.setdefault("PYGLET_HEADLESS", "true")
    try:
        import pyglet as _manimgl_mobile_pyglet
        _manimgl_mobile_pyglet.options["headless"] = True
        _manimgl_mobile_pyglet.options["shadow_window"] = False
    except Exception:
        pass
# MANIMGL_MOBILE_HEADLESS_PATCH_END

'''
    path.write_text(patch + text)
    print("patched:", path)


def patch_camera() -> None:
    path = MANIMLIB / "camera" / "camera.py"
    text = path.read_text()
    marker = "MANIMGL_MOBILE_EGL_CONTEXT_PATCH"
    if marker in text:
        print("already patched:", path)
        return
    backup(path)
    if "import os" not in text.split("\n")[:20]:
        text = text.replace("import moderngl\n", "import os\nimport moderngl\n", 1)
    old = """        if self.window is None:\n            self.ctx: moderngl.Context = moderngl.create_standalone_context()\n        else:\n            self.ctx: moderngl.Context = self.window.ctx\n"""
    new = """        if self.window is None:\n            # MANIMGL_MOBILE_EGL_CONTEXT_PATCH\n            # Prefer EGL on Android/Termux. Fallback to the upstream path if needed.\n            backend = os.environ.get(\"MANIMGL_MOBILE_MODERNGL_BACKEND\", \"egl\")\n            try:\n                if backend:\n                    self.ctx: moderngl.Context = moderngl.create_context(standalone=True, backend=backend)\n                else:\n                    self.ctx: moderngl.Context = moderngl.create_standalone_context()\n            except Exception:\n                self.ctx: moderngl.Context = moderngl.create_standalone_context()\n        else:\n            self.ctx: moderngl.Context = self.window.ctx\n"""
    if old not in text:
        raise SystemExit("camera.py patch target not found; file may have changed")
    path.write_text(text.replace(old, new, 1))
    print("patched:", path)


def install_pathops_stub() -> None:
    path = PURELIB / "pathops.py"
    marker = "MANIMGL_MOBILE_PATHOPS_STUB"
    if path.exists() and marker not in path.read_text(errors="ignore"):
        b = path.with_suffix(".py.mobile_backup")
        if not b.exists():
            b.write_text(path.read_text())
    if path.exists() and marker in path.read_text(errors="ignore"):
        print("pathops stub already installed:", path)
        return
    path.write_text('''# MANIMGL_MOBILE_PATHOPS_STUB
"""Small compatibility stub for skia-pathops on Android Termux.

ManimGL imports pathops at startup for boolean VMobject operations.
skia-pathops can fail to build on Android.  This stub lets normal ManimGL scenes
run.  Advanced boolean operations Union/Difference/Intersection/Exclusion will
raise NotImplementedError until a real skia-pathops build is available.
"""
from __future__ import annotations

from enum import Enum

class PathVerb(Enum):
    MOVE = 0
    LINE = 1
    QUAD = 2
    CUBIC = 3
    CLOSE = 4

class Path:
    def __init__(self):
        self._ops = []

    def getPen(self):
        return self

    def moveTo(self, x, y):
        self._ops.append((PathVerb.MOVE, [(x, y)]))

    def lineTo(self, x, y):
        self._ops.append((PathVerb.LINE, [(x, y)]))

    def quadTo(self, x1, y1, x2, y2):
        self._ops.append((PathVerb.QUAD, [(x1, y1), (x2, y2)]))

    def cubicTo(self, x1, y1, x2, y2, x3, y3):
        self._ops.append((PathVerb.CUBIC, [(x1, y1), (x2, y2), (x3, y3)]))

    def close(self):
        self._ops.append((PathVerb.CLOSE, []))

    def closePath(self):
        self.close()

    def __iter__(self):
        return iter(self._ops)

def _not_available(*args, **kwargs):
    raise NotImplementedError(
        "skia-pathops is not available on this Termux install. "
        "Normal ManimGL scenes work, but boolean path operations need a real skia-pathops build."
    )

union = _not_available
difference = _not_available
intersection = _not_available
xor = _not_available
''')
    print("installed pathops stub:", path)


def main() -> None:
    patch_init()
    patch_camera()
    install_pathops_stub()
    print("ManimGL mobile patch complete")


if __name__ == "__main__":
    main()
