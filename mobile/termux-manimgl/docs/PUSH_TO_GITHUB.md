# Push this repo to GitHub

From a computer or Termux where GitHub auth is configured:

```bash
cd termux-manimgl-mobile
```

```bash
git init
```

```bash
git add .
```

```bash
git commit -m "Initial Termux ManimGL mobile GPU setup"
```

Create an empty GitHub repo, then:

```bash
git remote add origin https://github.com/<USER>/<REPO>.git
```

```bash
git branch -M main
```

```bash
git push -u origin main
```
