# 02 — GPU backend

Working backend:

```text
normal Termux mesa 26.x
+ Zink OpenGL-on-Vulkan
+ mesa-vulkan-icd-freedreno Turnip
+ Adreno GPU
```

Expected GPU check:

```text
CTX_OK
GL_VENDOR: Mesa
GL_RENDERER: zink Vulkan 1.3(Turnip Adreno ...)
GL_VERSION: 3.3 (Core Profile) Mesa 26.x
VERSION_CODE: 330
```

Bad backend to avoid:

```text
mesa-zink/tur-packages 22.0.5
```

That old package rendered quickly but caused broken/dotted/displaced ManimGL vector strokes.

Fix if it returns:

```bash
pkg install mesa
```
