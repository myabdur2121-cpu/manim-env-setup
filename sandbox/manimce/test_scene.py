"""Setup ঠিক আছে কিনা দ্রুত পরীক্ষা:  manim -ql test_scene.py SetupCheck"""
from manim import *


class SetupCheck(Scene):
    def construct(self):
        self.camera.background_color = "#0B1736"
        bn = Text("বাংলা ফন্ট ঠিক আছে", font="Noto Serif Bengali", font_size=44)
        en = Text("CMU Serif works", font="CMU Serif", font_size=36)
        tex = MathTex(r"(A+B)^n=\sum_{r=0}^{n}\binom{n}{r}A^{n-r}B^r")
        VGroup(bn, en, tex).arrange(DOWN, buff=0.5)
        self.play(Write(bn), FadeIn(en), Write(tex))
        self.wait(0.5)
