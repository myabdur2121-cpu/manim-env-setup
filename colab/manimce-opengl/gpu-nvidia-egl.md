# Manim OpenGL on Google Colab (Quick Start)

This guide installs **Manim Community Edition** with **OpenGL (NVIDIA GPU)** support on **Google Colab**.

> **Important**
> - Runtime → **Change runtime type** → **GPU**
> - Run **every cell in order**.
> - Do **not** skip the restart cells.

---

# Step 1 — Check GPU

```python
!nvidia-smi
```

If you see your NVIDIA GPU information, continue.

---

# Step 2 — Install Dependencies

```python
!sudo apt update
!sudo apt install libcairo2-dev \
    texlive texlive-latex-extra texlive-fonts-extra \
    texlive-latex-recommended texlive-science \
    tipa libpango1.0-dev

!pip install manim
!pip install IPython==8.21.0
print("✅ Installation complete — Run the next cell.")
```

---

# Step 3 — Restart Runtime

```python
import os
os.kill(os.getpid(), 9)
```

Wait for Colab to reconnect.

---

# Step 4 — Configure NVIDIA EGL

```python
import os

lib = "/usr/lib/x86_64-linux-gnu/libEGL_nvidia.so.0"
print("NVIDIA EGL lib:", "✅ Found" if os.path.exists(lib) else "❌ Not Found")

!mkdir -p /usr/share/glvnd/egl_vendor.d

!echo '{"file_format_version":"1.0.0","ICD":{"library_path":"/usr/lib/x86_64-linux-gnu/libEGL_nvidia.so.0"}}' > /usr/share/glvnd/egl_vendor.d/10_nvidia.json

!cat /usr/share/glvnd/egl_vendor.d/10_nvidia.json

print("✅ NVIDIA EGL configured.")
```

---

# Step 5 — Restart Runtime Again

```python
import os
os.kill(os.getpid(), 9)
```

Wait for Colab to reconnect.

---

# Step 6 — Install NVIDIA OpenGL Userspace Libraries

```python
!apt-get update -qq

!apt-cache policy libnvidia-gl-580 2>/dev/null | head -4

!apt-get install -y -qq libnvidia-gl-580 2>&1 | tail -3

print("== Verification ==")

!ls -la /usr/lib/x86_64-linux-gnu/ | grep -iE "libEGL_nvidia|libnvidia-(eglcore|glsi|tls)" | head -6
```

---

# Step 7 — Verify OpenGL Uses NVIDIA GPU

```python
import os

os.environ["__EGL_VENDOR_LIBRARY_FILENAMES"] = "/usr/share/glvnd/egl_vendor.d/10_nvidia.json"

import moderngl

_orig = moderngl.create_context

def _egl_first(*a, **kw):
    if kw.get("standalone", False):
        try:
            return _orig(*a, **{**kw, "backend": "egl"})
        except Exception as e:
            print("⚠️ EGL failed:", e)
    return _orig(*a, **kw)

moderngl.create_context = _egl_first

ctx = moderngl.create_context(standalone=True)

info = ctx.info

print("GL_VENDOR  :", info["GL_VENDOR"])
print("GL_RENDERER:", info["GL_RENDERER"])
print("GL_VERSION :", info["GL_VERSION"])

ctx.release()

if "llvmpipe" in info["GL_RENDERER"].lower():
    print("❌ Still using llvmpipe.")
else:
    print("🎉 NVIDIA GPU is active!")
```

---

# Step 8 — Import Manim

```python
from manim import *
```

---

# Step 9 — Test OpenGL Rendering

```python
%%manim -v WARNING -qh --renderer=opengl --write_to_movie --disable_caching Simple3DScene

from manim import *
from manim.opengl import *

config.media_embed = True

class Simple3DScene(ThreeDScene):
    def construct(self):
        self.set_camera_orientation(
            phi=70 * DEGREES,
            theta=-45 * DEGREES,
        )

        axes = ThreeDAxes()

        sphere = Sphere(
            radius=1,
            resolution=(24, 24),
            fill_opacity=0.8,
            checkerboard_colors=[BLUE_D, BLUE_E],
        )

        cube = Cube(
            side_length=1.5,
            fill_opacity=0.7,
        ).set_color(RED)

        cube.shift(RIGHT * 3)

        self.play(Create(axes))
        self.play(FadeIn(sphere), FadeIn(cube))

        self.begin_ambient_camera_rotation(rate=0.2)
        self.wait(5)
        self.stop_ambient_camera_rotation()
```

If the animation renders successfully, your **Manim OpenGL + NVIDIA GPU** setup is ready.

---

# Done!

You can now create OpenGL scenes using:

```python
%%manim --renderer=opengl YourScene
```

Enjoy creating 3D animations with Manim! 🚀
