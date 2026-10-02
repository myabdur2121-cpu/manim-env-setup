# 06 — Background mode

The installer adds this command:

```bash
background <command> [args...]
```

Example GPU render:

```bash
cd ~/manimgl-workspace
background rendergpu test_scene.py MobileRenderTest --hd
```

Check progress:

```bash
check-background
```

Stop latest job:

```bash
stop-background
```

Logs live here:

```text
~/manimgl-workspace/background/latest.log
~/manimgl-workspace/background/<timestamp>.log
```

If Termux:API commands are available, `background` also uses `termux-wake-lock` while the render runs and releases it when finished.
