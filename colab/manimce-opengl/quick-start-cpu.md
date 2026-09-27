# Quick Start Guide

This guide contains the exact cell-by-cell code required to set up and run Manim with the OpenGL renderer in a fresh Jupyter Notebook or Google Colab environment. 

Simply create a new notebook and copy each code block into its own individual cell sequentially.

### 📝 Cell 1: Base System Updates & TeX Dependencies
Run this in the first cell to update packages and install the core Manim and LaTeX rendering engines.

```bash
!sudo apt update
!sudo apt install libcairo2-dev \
    texlive texlive-latex-extra texlive-fonts-extra \
    texlive-latex-recommended texlive-science \
    tipa libpango1.0-dev

!pip install manim
!pip install IPython==8.21.0
```

### 📝 Cell 2: Virtual Display & OpenGL Setup
Run this in the second cell to install the virtual framebuffer required for headless cloud rendering.

```bash
!apt-get install -qq xvfb freeglut3-dev python3-opengl
!pip install -q manim pyvirtualdisplay
```

### 📝 Cell 3: Initialize the Virtual Screen
Run this in the third cell to launch the virtual display server in the background.

```python
from pyvirtualdisplay import Display

# ব্যাকগ্রাউন্ডে ভার্চুয়াল স্ক্রিন চালু করা
display = Display(visible=0, size=(1920, 1080))
display.start()
```

### 📝 Cell 4: Define and Render the 3D OpenGL Scene
for more safer add this simple code next cell 
```python
from manim import * 
```
Run this in the fourth cell to render the 3D surface and view the video directly inside your notebook.
```python
%%manim -v WARNING -qm --renderer=opengl --write_to_movie ExampleOpenGLScene

from manim import *
from manim.opengl import *

# কোলাবের ভেতর ভিডিও দেখার অনুমতি দেওয়া হলো
config.media_embed = True

class ExampleOpenGLScene(ThreeDScene):
    def construct(self):
        # 3D সারফেস তৈরি
        surface = OpenGLSurface(
            lambda u, v: np.array([u, v, np.sin(u * v)]),
            u_range=[-3, 3],
            v_range=[-3, 3],
            fill_opacity=0.8,
            stroke_color=BLUE
        )

        # ক্যামেরার অ্যাঙ্গেল ও অবজেক্ট যোগ করা
        self.set_camera_orientation(phi=60 * DEGREES, theta=-45 * DEGREES)
        self.add(surface)

        # অ্যানিমেশন প্লে করা
        self.play(Rotate(surface, angle=PI, axis=OUT), run_time=3)
        self.wait()
```
