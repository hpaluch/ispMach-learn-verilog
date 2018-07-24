# ispMach learn Verilog

Learning Verilog HDL using cheap [ispMACH 4256ZE Breakout Board][]

> The goal is to learn Verilog HDL basics using simples possible tools...

Requirements - please read/setup following:
* [Getting started with ispMACH 4256ZE Breakout Board][]
* [Adding RESET button to ispMACH 4256ZE Breakout Board][]

# Table of contents

Please go to [Main Project Page] for table of contents and introduction

# Lesson 1 - direct wire

We just copy _negative reset_ (`nrst`) to negative LED D1 `nled`.

This circuit uses following signals/names:

Name|Pin|Direction|Function
----|---|---------|--------
nrst|72|Input|Negative RESET - active in `0` right after power-up or on button press
nled|71|Output|Negative LED D1 on board - lights when `0` on input


Our simplest Verilog file [bb_top.v]
looks like this:
```verilog
module bb_top(nled,nrst);
  output nled;
  input nrst;

  assign nled = nrst;

endmodule
```

Our _PostFit Equations_ are that simple:
```
nled = nrst ; (1 pterm, 1 signal)
```

And here is _RTL View_ from `bb_top.prj` using _Synplify Pro_:

![RTL View](https://raw.githubusercontent.com/hpaluch/ispMach-learn-verilog/b-lesson1-direct-wire/images/rtl-view.png)
            

# Project outputs

Please checkout right versions of report (GitHub pages show latest report only.)


[ispMACH 4256ZE Breakout Board]: http://www.latticesemi.com/Products/DevelopmentBoardsAndKits/ispMACH4256ZEBreakoutBoard.aspx
[Getting started with ispMACH 4256ZE Breakout Board]: https://github.com/hpaluch/hpaluch.github.io/wiki/Getting-started-with-ispMACH-4256ZE-Breakout-Board
[Adding RESET button to ispMACH 4256ZE Breakout Board]: https://github.com/hpaluch/hpaluch.github.io/wiki/Adding-RESET-button-to-ispMACH-4256ZE-Breakout-Board
[JEDEC]: https://github.com/hpaluch/ispMach-learn-verilog/blob/b-lesson1-direct-wire/bb_learn.jed 
[bb_top.v]: https://github.com/hpaluch/ispMach-learn-verilog/blob/b-lesson1-direct-wire/bb_top.v
[Main Project Page]: https://github.com/hpaluch/ispMach-learn-verilog
