# 00 — Copy-paste fresh Termux install

Run these commands in a fresh Termux app.

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

After setup:

```bash
cd ~/manimgl-workspace
```

```bash
check-manimgl-gpu
```

```bash
rendergpu test_scene.py MobileRenderTest --hd
```

Background render:

```bash
background rendergpu test_scene.py MobileRenderTest --hd
```

Check background log:

```bash
check-background
```

Attach live background tmux session:

```bash
attach-background
```

Run full quick test including a 480p render:

```bash
test-manimgl-mobile --render
```


CPU fallback render:

```bash
rendercpu test_scene.py MobileRenderTest --hd
```

CPU render test:

```bash
test-manimgl-cpu --render
```
