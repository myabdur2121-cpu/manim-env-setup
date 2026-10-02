# Termux ManimGL Mobile GPU Setup

Fresh Termux থেকে **3Blue1Brown ManimGL** (`manimgl` / `manimlib`) চালানোর reusable installer.

এই repo **Manim Community Edition নয়**। এটি 3Blue1Brown-এর ManimGL package:

```text
package: manimgl
import : manimlib
CLI    : manimgl
```

## What this repo gives you

- Fresh Termux থেকে full install flow
- Android/headless EGL patch for ManimGL
- Clean GPU render path using **normal Termux `mesa` 26.x + Zink + Turnip/Freedreno**
- CPU/llvmpipe fallback wrapper
- Organized render/background commands:
  - `rendergpu`
  - `rendercpu`
  - `rendergl` alias to GPU
  - `rendergl-safe` alias to CPU
- Test scene and GPU verification commands
- Rollback notes if bad packages return

## Important diagnosis

Do **not** use old TUR `mesa-zink 22.0.5` for ManimGL on Pixel 3a / Adreno 630. It rendered fast but caused broken/dotted/displaced vector strokes.

Working clean GPU path:

```text
ManimGL original shader
→ normal Termux mesa 26.x Zink
→ Turnip/Freedreno Vulkan
→ Adreno GPU
```

Avoid:

```text
mesa-zink/tur-packages 22.0.5
virglrenderer-mesa-zink
```

If broken output comes back, run:

```bash
pkg install mesa
```

## Fresh Termux install

Run these step-by-step:

```bash
pkg update
```

```bash
pkg install git
```

Clone this repo:

```bash
git clone <YOUR_REPO_URL> termux-manimgl-mobile
```

```bash
cd termux-manimgl-mobile
```

Start installer:

```bash
bash install.sh
```

The installer is modular. It calls scripts from `scripts/` and writes wrappers into `$PREFIX/bin`.

## After install

Go to workspace:

```bash
cd ~/manimgl-workspace
```

Check GPU context:

```bash
check-manimgl-gpu
```

Render test scene with GPU:

```bash
rendergpu test_scene.py MobileRenderTest --hd
```

CPU clean fallback:

```bash
rendercpu test_scene.py MobileRenderTest --hd
```

## Output paths

GPU:

```text
~/manimgl-workspace/videos/test_scene/1080p/gpu/MobileRenderTest.mp4
```

CPU:

```text
~/manimgl-workspace/videos/test_scene/1080p/cpu/MobileRenderTest.mp4
```

## Quality flags

ManimGL flags:

```text
-l      480p
-m      720p
--hd    1080p
--uhd   4K
```

Important: in ManimGL, `-h` means help, not high quality.

## Documentation

See `docs/`:

- `docs/01-fresh-termux.md`
- `docs/02-gpu-backend.md`
- `docs/03-commands.md`
- `docs/04-troubleshooting.md`
- `docs/05-dev-notes.md`
- `docs/06-background-mode.md`

## License

MIT
