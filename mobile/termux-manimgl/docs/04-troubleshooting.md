# 04 — Troubleshooting

## Broken/dotted/displaced strokes on GPU

Check packages:

```bash
pkg list-installed | grep -Ei 'mesa|virgl|vulkan|angle'
```

If `mesa-zink` appears, replace it:

```bash
pkg install mesa
```

Then verify:

```bash
check-manimgl-gpu
```

## CPU render clean but GPU broken

CPU uses llvmpipe software OpenGL:

```text
ManimGL shader → Mesa llvmpipe → CPU
```

GPU uses:

```text
ManimGL shader → Mesa Zink → Vulkan Turnip → Adreno GPU
```

If CPU is clean but GPU broken, the problem is usually the graphics backend/driver package, not your scene.

## VirGL stack corruption

If you see:

```text
stack corruption detected (-fstack-protector)
```

Do not keep retrying flags. In testing, this was fixed by replacing old `mesa-zink` with normal `mesa`.

## False render complete

This repo's `rendercore` removes the old output before rendering and exits non-zero if ManimGL crashes. So it should not report success for an old video.

## skia-pathops / boolean operations

This setup installs a small `pathops.py` stub because `skia-pathops` can fail to build on Android. Normal scenes work. Advanced boolean operations like `Union`, `Difference`, `Intersection`, `Exclusion` need a real `skia-pathops` build.
