# ManimCE: Linux sandbox setup (E2B / Ubuntu / Debian)

ManimCE (Cairo renderer), LaTeX, FFmpeg, CMU Serif আর Noto Serif Bengali সহ।

```bash
bash setup_manim.sh            # ~৩ মিনিট; নিজেই পাশের font.sh চালায়
# চাইলে: FONT_USER_COPY=1 bash setup_manim.sh   → ফন্টের কপি ~/fonts-এও রাখে (~27 MB)
```

## কী install হয়
- apt: `libcairo2-dev libpango1.0-dev ffmpeg dvisvgm texlive texlive-latex-extra texlive-fonts-extra texlive-latex-recommended texlive-science tipa`
- pip: `manim ipython==8.21.0`
- ফন্ট: CMU Serif (`fonts-cmu` অথবা SourceForge), Noto Serif Bengali v3.000 (notofonts) → `/usr/local/share/fonts`

## অভিজ্ঞতা থেকে শেখা (Binomial Theorem project)
- **Sandbox প্রতিবার reset হয়।** apt বা pip দিয়ে install করা সব (manim, ffmpeg, TeX) মুছে যায়, তাই প্রতিটা নতুন session-এ আবার `setup_manim.sh` চালাতে হয়।
- `ipython==8.21.0` pin রাখুন। নতুন IPython-এর সাথে সমস্যা হয়েছিল।
- বাংলা লেখার জন্য `Text("…", font="Noto Serif Bengali")` ব্যবহার করুন। গণিতের জন্য `MathTex` ঠিকমতো কাজ করে।
- যেসব workspace-এ জায়গা সীমিত (যেমন ~128 MB snapshot), সেখানে `FONT_USER_COPY` বন্ধ রাখুন, আর render-এর পর `media/`, `__pycache__` মুছে দিন।
- মেশিন দুর্বল হলে (2 CPU, 1 GB RAM) লম্বা render চালাতে ব্যাকগ্রাউন্ড process ব্যবহার করুন। `-qm`-এ ৩৩ মিনিটের ভিডিও render করতে ~২৫ মিনিট লেগেছিল।
