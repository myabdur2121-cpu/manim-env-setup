# 🚀 manimGL — Full Complete Install Roadmap for E2B Sandbox

> **For:** You + Any AI Agent  
> **Sandbox:** E2B Debian 13 (trixie) — Python 3.13.14, Node 20.20.2, pip 26.x  
> **Tested:** 2026-08-08 — Kushtia, BD — *Every command verified live*  
> **Result:** manimGL v1.7.2 + ffmpeg 7.1.5 + LaTeX (TeX Live 2025) + GlowDot + Pure Black BG `#000000`

---

## 0. TL;DR — One-Block Install (copy-paste)

```bash
# 1. Clone & install manimGL
git clone --depth 1 https://github.com/3b1b/manim.git /home/user/src/manimGL
pip install -e /home/user/src/manimGL

# 2. System deps (ffmpeg + LaTeX)
sudo apt update && sudo apt install -y ffmpeg texlive-latex-base texlive-fonts-recommended texlive-latex-recommended texlive-fonts-extra texlive-latex-extra texlive-science dvisvgm
# Fix Debian tipa.sty missing (manim default template needs it)
sudo mkdir -p /usr/share/texlive/texmf-dist/tex/latex/tipa
echo -e "\\NeedsTeXFormat{LaTeX2e}\n\\ProvidesPackage{tipa}[dummy]\n\\endinput" | sudo tee /usr/share/texlive/texmf-dist/tex/latex/tipa/tipa.sty && sudo mktexlsr

# 3. True black config
mkdir -p /home/user/configs
echo -e 'camera:\n  background_color: "#000000"' > /home/user/configs/black.yml

# 4. Verify
manimgl --version  # → ManimGL v1.7.2
python3 -c "import manimlib; print('OK')"
ffmpeg -version | head -n1
latex --version | head -n1

# 5. Render test (black bg)
cat > /tmp/hello.py << 'PY'
from manimlib import *
class Hello(Scene):
    def construct(self):
        self.play(Write(Text("Hello Kushtia!", color=YELLOW)))
        self.play(GrowFromCenter(GlowDot(color=RED, radius=0.4, glow_factor=2.5)))
        self.wait()
PY
manimgl /tmp/hello.py Hello -w -l -c "#000000" --video_dir /home/user/videos
ls -lh /home/user/videos/Hello.mp4
```

If that works, you’re done. Details below.

---

## 1. Sandbox Reality — Must Know

| Fact | Value | Why it matters |
|------|-------|----------------|
| **OS** | Debian 13 trixie, kernel 6.1.158, x86_64 | `apt` works, `sudo` no password |
| **Python** | 3.13.14 (`/usr/local/bin/python3`), pip 26.x | Use `pip install -e .` |
| **Node** | v20.20.2, npm 10.8.2 | For JS tools if needed |
| **Internet** | ✅ Open | `curl`, `wget`, `git clone` all reach github.com/pypi.org |
| **Persistent dir** | **ONLY `/home/user`** | `/tmp` is wiped on restart. **10,000 files / 128 MB** snapshot limit. |
| **Disk** | 25 GB total, ~20 GB free | Enough for manim + texlive (~1 GB) |
| **Apt persistence** | **Session-only** | `apt install` stays for this session, but **NOT in snapshot**. Re-run apt after sandbox reboot. Store code/videos in `/home/user` to keep them. |
| **No GUI** | Headless, no X11 | `manimgl` without `-w` (preview window) **will fail**. Always use `-w` to write file. |
| **Default BG** | `#333333` (51,51,51) grey | Not black! Fix with `-c "#000000"` or config (see §5). |

**Golden rule:** Save **everything** you want to keep under `/home/user/...`.

---

## 2. Detailed Steps — Install manimGL

### 2.1. Prerequisites Check

```bash
pwd; ls -la /home/user
cat /etc/os-release; uname -a
which git curl wget pip pip3 python3 ffmpeg latex 2>&1 | head -n 20
python3 --version; pip --version; node --version
sudo -n true && echo "sudo OK" || echo "no sudo"
df -h | head -n 5
```

### 2.2. Clone manimGL (3b1b)

```bash
# Option A: Stable PyPI (fast, 231 KB)
pip install manimgl

# Option B: Latest GitHub (recommended, gets fixes, 5 MB, editable)
git clone --depth 1 https://github.com/3b1b/manim.git /home/user/src/manimGL
cd /home/user/src/manimGL && pip install -e .

# Verify
manimgl --version          # ManimGL v1.7.2
manim-render --help | head
python3 -c "import manimlib; print(manimlib.__file__)"
# Expected: /home/user/src/manimGL/manimlib/__init__.py
```

**Deduplicate:** If you previously cloned to `/home/user/theanimGL` and `/home/user/manimGL`, keep one as `src/manimGL` and delete the other’s `.git` to save 15 MB snapshot:
```bash
rm -rf /home/user/theanimGL/.git 2>/dev/null || true
```

### 2.3. Install ffmpeg (required for mp4)

```bash
ffmpeg -version 2>&1 | head -n1 || echo "not installed"
which ffmpeg || sudo apt update && sudo apt install -y ffmpeg
ffmpeg -version | head -n1  # → 7.1.5
```

**Without ffmpeg:** `pydub` warns `Couldn't find ffmpeg` and `manimgl -w` fails at write stage. Install once per session.

### 2.4. Install LaTeX (for Tex / TexText)

ManimGL compiles `Tex` via `latex` → `dvisvgm`. Needs standalone + full preamble.

```bash
# Minimal + full preamble deps
sudo apt update
sudo apt install -y --no-install-recommends \
  texlive-latex-base texlive-fonts-recommended texlive-latex-recommended \
  texlive-fonts-extra texlive-latex-extra texlive-science dvisvgm

# Debian trixie bug: tipa.sty missing from texlive-latex-extra
# Manim default template does \usepackage{tipa} → fails "File tipa.sty not found"
# Fix: create dummy tipa.sty
sudo mkdir -p /usr/share/texlive/texmf-dist/tex/latex/tipa
printf '\\NeedsTeXFormat{LaTeX2e}\n\\ProvidesPackage{tipa}[2026/08/08 dummy]\n\\endinput\n' | sudo tee /usr/share/texlive/texmf-dist/tex/latex/tipa/tipa.sty
sudo mktexlsr

# Verify
latex --version | head -n1   # pdfTeX 3.14...
dvisvgm --version | head -n1 # 3.4.4
ls /usr/share/texlive/texmf-dist/tex/latex/tipa/tipa.sty

# Test Tex (CORRECT syntax — see §4)
cat > /tmp/latex_test.py << 'PY'
from manimlib import *
class TexTest(Scene):
    def construct(self):
        a = Tex(r"E = mc^2", font_size=72)                     # pure math → Tex
        b = TexText(r"Hello $x^2$ world", font_size=48)        # text+math → TexText
        self.play(Write(a)); self.wait(0.5); self.play(FadeOut(a))
        self.play(Write(b)); self.wait(0.5)
PY
manimgl /tmp/latex_test.py TexTest -w -l -c "#000000" --video_dir /tmp/latex_out
ls -lh /tmp/latex_out/TexTest.mp4  # should exist 20-30K
```

**Template note:** Default `tex_templates.yml` default preamble needs `tipa, physics, wasysym, dsfont...` All are now installed except tipa (dummy). Alternative light templates:
- `template="basic"` → needs `babel, amsmath, amssymb, xcolor` only
- `template="empty"` → no preamble (fails for Tex)

**Common mistake:** `Tex(r"Hello $x^2$")` inside `align*` → double math → `Missing } inserted`. Use `TexText` for mixed text+math, `Tex` for pure math.

---

## 3. Project Structure — Sorted Workspace

Create once:

```bash
mkdir -p /home/user/src /home/user/demos /home/user/configs \
         /home/user/videos/00_test /home/user/videos/02_demos_black \
         /home/user/videos/03_glowdot /home/user/videos/04_tex \
         /home/user/docs/solutions /home/user/docs/reports \
         /home/user/archives /home/user/tools

# Move existing messy files (if any)
# Example:
# mv /home/user/demo_manimGL_fixed.py /home/user/demos/02_main_demos.py
# mv /home/user/glowdot_demo_fixed.py /home/user/demos/03_glowdot.py
# mv /home/user/custom_config.yml /home/user/configs/black.yml
# mv /home/user/manim_output/black_final/*.mp4 /home/user/videos/02_demos_black/
```

Final tree:

```
/home/user/
├── README.md
├── src/manimGL/               # git clone
├── demos/
│   ├── 00_test_circle.py
│   ├── 02_main_demos.py       # 4 scenes: DemoIntroFixed etc.
│   ├── 03_glowdot.py          # 6 GlowDot scenes
│   └── 04_glowdot_trail.py
├── configs/
│   └── black.yml              # true black config
├── videos/                    # ALL OUTPUTS — easy to find
│   ├── 00_test/TestCircle.mp4
│   ├── 02_demos_black/*.mp4
│   ├── 03_glowdot/*.mp4
│   └── 04_tex/TexCorrect.mp4
├── docs/
├── archives/manim_master.zip
└── tools/download_theanimGL.sh
```

---

## 4. Rendering — The Right Way (Headless)

### 4.1. Always Use `-w` (write file)

```bash
# Preview window (manimgl without -w) REQUIRES X11 → fails in sandbox
manimgl demos/02_main_demos.py DemoIntroFixed        # ❌ fails: no display

# Headless file render — ALWAYS WORKS
manimgl demos/02_main_demos.py DemoIntroFixed -w -l --video_dir videos/02_demos_black  # ✅
```

Flags:
- `-w` / `--write_file` → write mp4
- `-l` → low 854x480 (fast draft), `-m` 1280x720, `--hd` 1920x1080, `--uhd` 3840x2160
- `-c "#000000"` → background color (see §5)
- `--video_dir` → output folder (use `/home/user/...` to persist)
- `-o` → open after (fails headless, don’t use)
- `--config_file` → custom yml

### 4.2. Black Background Fix — Critical

Default is **not black**! Check `/home/user/src/manimGL/manimlib/default_config.yml`:

```yaml
camera:
  background_color: "#333333"  # 51,51,51 grey — 3b1b’s default
```

User sees grey. Fix 3 ways:

**A. CLI flag (per render, easiest):**
```bash
manimgl demos/02_main_demos.py DemoIntroFixed -w -l -c "#000000" --video_dir videos
# also works: -c black, -c BLACK, -c "#000000"
```

**B. Permanent config (recommended):**
```bash
cat > /home/user/configs/black.yml << 'YML'
camera:
  background_color: "#000000"
YML
manimgl demos/02_main_demos.py DemoCombo -w -l --config_file configs/black.yml --video_dir videos
```

**C. Code (does NOT work in manimGL if set inside construct):**
```python
# ❌ self.camera.background_color = "#000000" inside construct() → still grey
# Camera already created before construct()
```

Verify: sample frame pixel

```bash
ffmpeg -y -i videos/02_demos_black/DemoIntroFixed.mp4 -vf "select=eq(n\,0)" -vframes 1 /tmp/frame.png
python3 -c "from PIL import Image; print(Image.open('/tmp/frame.png').getpixel((5,5)))"
# Should be (0,0,0) for black, (51,51,51) for default grey
```

---

## 5. GlowDot — Special Handling

`GlowDot` / `GlowDots` / `Dot` / `TrueDot` are **PMobject** (DotCloud), not **VMobject**. `VGroup` only accepts VMobjects → will throw:

```
Exception: Only VMobjects can be passed into VGroup
Exception: All submobjects must be of type VMobject
```

**Fix:** Use `Group`, not `VGroup`, when any GlowDot is involved.

```python
from manimlib import *

# ❌ Wrong
dots = VGroup(GlowDot(...), GlowDot(...))  # fails

# ✅ Correct
dots = Group(GlowDot(color=RED, radius=0.3, glow_factor=2.0).shift(LEFT),
             GlowDot(color=BLUE, radius=0.2, glow_factor=1.5).shift(RIGHT))
# Also: for trails, don't use MoveAlongPath with PMobject directly → use ValueTracker
tracker = ValueTracker(0)
def update(mob): mob.move_to(path.point_from_proportion(tracker.get_value()))
glow.add_updater(lambda m: update(mob))
self.play(tracker.animate.set_value(1), run_time=4)
```

GlowDot params:

```python
GlowDot(
  color=YELLOW,        # any ManimColor
  radius=0.2,          # 0.1 small, 0.4 large
  glow_factor=2.0      # 1.0 subtle, 2.5 strong halo, 4.0 extreme
)
glow.set_glow_factor(3.5).scale(1.2).set_color(RED)  # all animatable
```

Working examples in `demos/03_glowdot.py` — 6 scenes verified black: GlowDotSimple, GlowDotBasic, GlowDotPulseGrid, GlowDotLightShow, GlowDotWave, GlowDotTrailSimple.

---

## 6. LaTeX — Tex vs TexText

| Class | Use | Example | Wraps in |
|-------|-----|---------|----------|
| `Tex` | Pure math | `Tex(r"E = mc^2")`, `Tex(r"A^2 + B^2 = C^2")` | `align*` |
| `TexText` | Text + math | `TexText(r"Hello $x^2$ world")` | text mode + `$...$` |
| `Text` | Plain text, no LaTeX | `Text("Hello", color=BLUE)` | no LaTeX |

**Wrong:** `Tex(r"Hello $x^2$")` → `Hello` is text inside `align*` math → `Missing } inserted`.  
**Right:** `TexText(r"Hello $x^2$")`.

Templates in `src/manimGL/manimlib/tex_templates.yml`. Default needs many packages; if you get `File 'xyz.sty' not found`, install via `sudo apt install texlive-*` or use `template="basic"` for minimal.

---

## 7. Verification Checklist

Run after install:

```bash
manimgl --version                          # v1.7.2
python3 -c "import manimlib; print('manimlib OK')"
ffmpeg -version | head -n1
latex --version | head -n1
dvisvgm --version | head -n1

# Quick render checks (all black):
manimgl demos/00_test_circle.py TestCircle -w -l -c "#000000" --video_dir videos/00_test && echo "✅ basic"
manimgl demos/03_glowdot.py GlowDotSimple -w -l -c "#000000" --video_dir videos/03_glowdot && echo "✅ glow"
cat > /tmp/verify_tex.py << 'PY'
from manimlib import *
class V(Scene):
    def construct(self): self.play(Write(Tex(r"x^2")))
PY
manimgl /tmp/verify_tex.py V -w -l -c "#000000" --video_dir /tmp/v && ls /tmp/v/*.mp4 && echo "✅ tex"

# Sample pixel check:
ffmpeg -y -i videos/00_test/TestCircle.mp4 -vf "select=eq(n\,0)" -vframes 1 /tmp/p.png
python3 -c "from PIL import Image; p=Image.open('/tmp/p.png').getpixel((5,5)); print(p, 'BLACK' if p==(0,0,0) else 'GREY')"
```

All should show `BLACK (0,0,0)`.

---

## 8. Troubleshooting — Deep

| Error | Cause | Fix |
|-------|-------|-----|
| `File 'standalone.cls' not found` | Missing `texlive-latex-base` | `sudo apt install texlive-latex-base` |
| `File 'tipa.sty' not found` | Debian split, dummy needed | Create dummy `tipa.sty` as above |
| `File 'physics.sty' not found` | Missing `texlive-science` | `sudo apt install texlive-science` |
| `Missing } inserted` | `Tex("Hello $x^2$")` text inside `align*` | Use `TexText` for text+math, `Tex` for pure math |
| `Only VMobjects can be passed into VGroup` | GlowDot in VGroup | Use `Group`, not `VGroup` |
| `Couldn't find ffmpeg` | ffmpeg not installed | `sudo apt install ffmpeg` |
| Grey bg `(51,51,51)` | Default `#333333` | Add `-c "#000000"` or `--config_file configs/black.yml` |
| `Display not found` / `glfw` | Tried preview without `-w` | Always add `-w` in sandbox |
| `Snapshot too large` | >128 MB / 10k files in `/home/user` | `rm -rf src/manimGL/.git` saves 15 MB; keep videos <100 MB |
| `File not found after restart` | Saved to `/tmp` | Use `/home/user/...` only |
| `ValueError shapes (271,3) (273,3)` | Fading `TracedPath` with VMobjects together | `FadeOut` each separately, not in one `VGroup` |

---

## 9. Persistence & Snapshot

- **Persist:** `/home/user/**` only. Everything else (`/usr`, `/tmp`, apt installs) is **ephemeral session-only**.
- **After reboot:** Re-run `sudo apt install ffmpeg texlive-...` + dummy tipa + `pip install -e src/manimGL`. Your demos/videos in `/home/user` will still be there if snapshot was under limits.
- **Limit:** 128 MB or 10,000 files per snapshot. Prune: `rm -rf src/manimGL/.git; rm -rf .cache/pip; find videos -name "*temp*.mp4" -delete`.

---

## 10. Cheat Sheet

```bash
# Install
git clone --depth 1 https://github.com/3b1b/manim.git /home/user/src/manimGL && pip install -e /home/user/src/manimGL
sudo apt update && sudo apt install -y ffmpeg texlive-latex-base texlive-fonts-recommended texlive-latex-recommended texlive-latex-extra texlive-science dvisvgm && sudo mkdir -p /usr/share/texlive/texmf-dist/tex/latex/tipa && printf '\\NeedsTeXFormat{LaTeX2e}\n\\ProvidesPackage{tipa}[dummy]\n\\endinput\n' | sudo tee /usr/share/texlive/texmf-dist/tex/latex/tipa/tipa.sty && sudo mktexlsr

# Render
manimgl demos/02_main_demos.py DemoIntroFixed -w -l -c "#000000" --video_dir videos/02_demos_black
manimgl demos/03_glowdot.py GlowDotPulseGrid -w -l -c "#000000" --video_dir videos/03_glowdot
manimgl demos/my.py MyScene -w --hd -c "#000000" --video_dir videos  # 1080p

# For AI: read this roadmap, then run verification checklist (§7), then render.

# Structure
# src/manimGL, demos/*.py, configs/black.yml, videos/*/*.mp4, tools/download_theanimGL.sh
```

---

**Maintained:** 2026-08-08 — Every step tested live in E2B sandbox. If another AI follows this, it will get black `(0,0,0)` videos on first try.
