# manim-env-setup

Manim চালানোর **সব setup এক জায়গায়**: Google Colab, Linux sandbox, ManimGL, ManimCE, ফন্ট আর LaTeX।

## কোন পরিবেশে কোনটা ব্যবহার করবেন

| পরিবেশ | Manim | কী ব্যবহার করবেন | ধরন |
|---|---|---|---|
| **Google Colab** (CPU/GPU) | ManimGL (3b1b) | [`colab/manimgl/`](colab/manimgl/) | pip package + `%%manimgl` magic |
| **Google Colab** (CPU, OpenGL) | ManimCE | [`colab/manimce-opengl/quick-start-cpu.md`](colab/manimce-opengl/quick-start-cpu.md) | cell-by-cell গাইড |
| **Google Colab** (NVIDIA GPU, EGL) | ManimCE | [`colab/manimce-opengl/gpu-nvidia-egl.md`](colab/manimce-opengl/gpu-nvidia-egl.md) | ধাপে ধাপে গাইড |
| **Linux sandbox** (E2B / Ubuntu / Debian) | ManimCE (Cairo) | [`sandbox/manimce/`](sandbox/manimce/) | `setup_manim.sh` + `font.sh` ✅ পরীক্ষিত |
| **Linux sandbox** (E2B) | ManimGL | [`sandbox/manimgl/manimgl-e2b-sandbox.md`](sandbox/manimgl/manimgl-e2b-sandbox.md) | সম্পূর্ণ গাইড |
| **Android Termux / Mobile** (Pixel/Adreno) | ManimGL (3b1b) | [`mobile/termux-manimgl/`](mobile/termux-manimgl/) | auto installer + GPU/CPU wrappers + background mode |
| যেকোনো Linux | বাংলা PDF (XeLaTeX) | [`sandbox/latex-pdf/`](sandbox/latex-pdf/) | কমান্ড |

## Android Termux quick command

Fresh Termux থেকে mobile setup চালাতে:

```bash
pkg update
```

```bash
pkg install git
```

```bash
git clone https://github.com/myabdur2121-cpu/manim-env-setup.git
```

```bash
cd manim-env-setup/mobile/termux-manimgl
```

```bash
bash install.sh
```

Test render:

```bash
cd ~/manimgl-workspace
```

```bash
rendergpu test_scene.py MobileRenderTest --hd
```

Background render:

```bash
background rendergpu test_scene.py MobileRenderTest --hd
```

Check background job:

```bash
check-background
```

## ফন্ট
সব setup-এ একই দুটো ফন্ট: **CMU Serif** (Computer Modern, English) আর **Noto Serif Bengali** (বাংলা)।

## Folder

```
manim-env-setup/
├── pyproject.toml              # pip install -e . → manim_setup, manimgl (Colab ManimGL API)
├── mobile/
│   └── termux-manimgl/        # Android Termux ManimGL mobile GPU setup
├── colab/
│   ├── manimgl/                # আগে ছিল আলাদা repo: manim-setup
│   │   ├── README.md
│   │   ├── manim_setup/        # public API: setup_all(), setup_gpu() …
│   │   ├── manimgl/            # colab_setup, colab_magic, gpu_tools, file_tools …
│   │   └── examples/
│   └── manimce-opengl/         # আগে ছিল আলাদা repo: manimCE-opengl-render-smooth-setup
│       ├── quick-start-cpu.md
│       └── gpu-nvidia-egl.md
└── sandbox/
    ├── manimce/                # setup_manim.sh, font.sh
    ├── manimgl/                # manimgl-e2b-sandbox.md
    └── latex-pdf/              # XeLaTeX (বাংলা PDF)
```

## উৎস
এই repo বানানো হয়েছে এগুলো একসাথে করে:
- `manim-setup` → `colab/manimgl/`
- `manimCE-opengl-render-smooth-setup` → `colab/manimce-opengl/` + `sandbox/manimgl/`
- `my_work/year2026/binomial_theorem/scripts/` (একই ফাইল `Ai_prompt_repo-/manim_setup/`-এও আছে) → `sandbox/manimce/`
