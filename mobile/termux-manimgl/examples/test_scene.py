from manimlib import *


class MobileRenderTest(Scene):
    def construct(self):
        title = Text("ManimGL Mobile GPU").scale(0.75).to_edge(UP)

        square = Square(side_length=2.0)
        square.set_stroke(BLUE, width=8)
        square.set_fill(BLUE_E, opacity=0.25)
        square.shift(LEFT * 3)

        circle = Circle(radius=1.1)
        circle.set_stroke(YELLOW, width=8)
        circle.set_fill(YELLOW_E, opacity=0.20)

        line = Line(LEFT * 1.2, RIGHT * 1.2)
        line.set_stroke(RED, width=10)
        line.shift(RIGHT * 3)

        label = Text("clean strokes + fill").scale(0.45).next_to(circle, DOWN, buff=0.45)

        self.play(FadeIn(title), run_time=0.6)
        self.play(ShowCreation(square), ShowCreation(circle), ShowCreation(line), run_time=1.2)
        self.play(FadeIn(label), run_time=0.5)
        self.play(
            square.animate.rotate(PI / 4),
            circle.animate.scale(1.15),
            line.animate.rotate(PI / 8),
            run_time=1.0,
        )
        self.wait(0.5)
