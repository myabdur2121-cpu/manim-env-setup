# বাংলা + English PDF: XeLaTeX (Linux sandbox)

Narration স্ক্রিপ্টের প্রিন্ট PDF বানাতে এটা ব্যবহার হয়েছিল (Noto Serif Bengali + CMU Serif)।

```bash
sudo apt-get update
sudo DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
    texlive-xetex texlive-latex-recommended texlive-latex-extra lmodern fontconfig poppler-utils
```

## ফন্ট (fontspec, ফাইলের path দিয়ে)
```latex
\usepackage{fontspec}
\setmainfont{NotoSerifBengali}[Path=fonts/,Extension=.ttf,UprightFont=*-Regular,BoldFont=*-Bold,Script=Bengali]
\newfontfamily\cmu{cmun}[Path=fonts/,Extension=.ttf,UprightFont=*rm,BoldFont=*bx,ItalicFont=*ti]
\newcommand\en[1]{{\cmu #1}}   % English শব্দ CMU Serif-এ
```

- ফন্ট ফাইল পাওয়া যাবে: Noto `NotoSerifBengali-v3.000.zip` (github.com/notofonts/bengali), CMU `cm-unicode-0.7.0-ttf.tar.xz` (SourceForge)
- **XeLaTeX** ব্যবহার করুন। এটা HarfBuzz দিয়ে বাংলা যুক্তাক্ষর ঠিকভাবে জোড়ে।
- ⚠️ `needspace` প্যাকেজ `\penalty-100` যোগ করে। এতে পাতার নিচে বড় ফাঁকা জায়গা থেকে যেতে পারে। তার বদলে heading-এর পরে `\nobreak` দিন।
- পুরো উদাহরণ: `my_work/year2026/binomial_theorem/practice/pdf/build_pdf.py`
