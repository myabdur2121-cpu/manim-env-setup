# 06 — Background mode

Background mode uses **tmux + optional Termux wake-lock**.

This matches the earlier Termux background-agent pattern:

```text
background command
→ create detached tmux session
→ run render inside tmux
→ write logs
→ optional termux-wake-lock
→ terminal can be closed/detached
```

## Start background GPU render

```bash
cd ~/manimgl-workspace
background rendergpu test_scene.py MobileRenderTest --hd
```

## Start background CPU render

```bash
background rendercpu test_scene.py MobileRenderTest --hd
```

## Check progress

```bash
check-background
```

## Attach to live tmux session

```bash
attach-background
```

Detach from tmux without stopping render:

```text
Ctrl-b then d
```

## Stop latest background session

```bash
stop-background
```

## Logs

```text
~/manimgl-workspace/background/latest.log
~/manimgl-workspace/background/<timestamp>.log
```

## Important limitation

This is stronger than a plain `command &`, but it is still not a true Android system service.

It should survive closing/detaching the terminal UI, but it will not survive:

- Termux app force-stop
- Android killing Termux under memory/battery pressure
- phone reboot

For best result, disable battery optimization for Termux and Termux:API in Android settings.
