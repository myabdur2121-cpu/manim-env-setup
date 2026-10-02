# 05 — Dev notes

## ManimGL identity

```text
package: manimgl
import : manimlib
CLI    : manimgl
```

Do not replace with Manim Community Edition package `manim`.

## Mobile patches

`patch_manimgl_mobile.py` does three things:

1. Sets pyglet headless mode before ManimGL imports window modules.
2. Changes standalone ModernGL context creation to prefer EGL on Android.
3. Installs a `pathops.py` compatibility stub if real skia-pathops is unavailable.

Backups are written next to patched files with `.mobile_backup` suffix.

## Wrapper files

Installed into `$PREFIX/bin`:

```text
manimgl-gpu
manimgl-cpu
rendercore
rendergpu
rendercpu
rendergl
rendergl-safe
check-manimgl-gpu
check-manimgl-cpu
test-manimgl-mobile
```

## Final confirmed fix

Old broken state:

```text
mesa-zink 22.0.5 + Zink/Turnip → fast but broken strokes
```

Good state:

```text
normal mesa 26.2.4 + Zink/Turnip → clean ManimGL GPU render
```
