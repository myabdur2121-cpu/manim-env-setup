# 01 — Fresh Termux steps

Run step-by-step:

```bash
pkg update
```

```bash
pkg install git
```

```bash
git clone <YOUR_REPO_URL> termux-manimgl-mobile
```

```bash
cd termux-manimgl-mobile
```

```bash
bash install.sh
```

After install:

```bash
cd ~/manimgl-workspace
```

```bash
check-manimgl-gpu
```

```bash
rendergpu test_scene.py MobileRenderTest --hd
```

CPU fallback:

```bash
rendercpu test_scene.py MobileRenderTest --hd
```
