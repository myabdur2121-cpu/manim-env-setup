# 07 — CPU mode / llvmpipe fallback

This setup includes a full CPU rendering mode.

CPU mode is useful when:

- GPU driver output is broken after a package update
- You want a clean baseline render for comparison
- You need maximum compatibility and do not care about speed

## CPU command

```bash
rendercpu test_scene.py MobileRenderTest --hd
```

Legacy alias:

```bash
rendergl-safe test_scene.py MobileRenderTest --hd
```

## CPU context check

```bash
check-manimgl-cpu
```

Expected renderer contains something like:

```text
llvmpipe
```

## CPU test

Smoke test:

```bash
test-manimgl-cpu
```

Actual quick 480p CPU render:

```bash
test-manimgl-cpu --render
```

## Background CPU render

```bash
background rendercpu test_scene.py MobileRenderTest --hd
```

Check log:

```bash
check-background
```

## Output path

CPU output is separated from GPU output:

```text
~/manimgl-workspace/videos/test_scene/1080p/cpu/MobileRenderTest.mp4
```

GPU output stays here:

```text
~/manimgl-workspace/videos/test_scene/1080p/gpu/MobileRenderTest.mp4
```

## How CPU mode works

CPU mode still uses ManimGL's OpenGL shader pipeline, but Mesa runs it in software:

```text
Scene.py
→ manimgl / manimlib
→ ModernGL EGL standalone context
→ Mesa llvmpipe software OpenGL
→ CPU rendering
→ ffmpeg MP4 output
```

Environment used by `manimgl-cpu`:

```text
GALLIUM_DRIVER=llvmpipe
LIBGL_ALWAYS_SOFTWARE=1
MESA_GL_VERSION_OVERRIDE=3.3
MESA_GLSL_VERSION_OVERRIDE=330
PYOPENGL_PLATFORM=egl
```

CPU mode is cleaner and more stable, but slower than GPU mode.
