# 03 — Commands

## GPU render

```bash
rendergpu file.py SceneName --hd
```

## CPU fallback

```bash
rendercpu file.py SceneName --hd
```

## Legacy aliases

```bash
rendergl file.py SceneName --hd
```

Same as GPU.

```bash
rendergl-safe file.py SceneName --hd
```

Same as CPU.

## Quality flags

```text
-l      480p
-m      720p
--hd    1080p
--uhd   4K
```

In ManimGL, `-h` is help, not high quality.

## Output layout

```text
videos/<file_stem>/<quality>/<backend>/<SceneName>.mp4
```

Example:

```text
videos/test_scene/1080p/gpu/MobileRenderTest.mp4
```

## Smoke tests

```bash
test-manimgl-mobile
```

With actual quick 480p render:

```bash
test-manimgl-mobile --render
```

## Background mode

```bash
background rendergpu test_scene.py MobileRenderTest --hd
```

```bash
check-background
```

```bash
stop-background
```


## CPU-only test

```bash
test-manimgl-cpu
```

With actual quick 480p CPU render:

```bash
test-manimgl-cpu --render
```

## CPU background render

```bash
background rendercpu test_scene.py MobileRenderTest --hd
```
