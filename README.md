# ispMach learn Verilog

Learning Verilog HDL using cheap [ispMACH 4256ZE Breakout Board][]

> The goal is to learn Verilog HDL basics using simples possible tools...

Requirements - please read/setup following:
* [Getting started with ispMACH 4256ZE Breakout Board][]
* [Adding RESET button to ispMACH 4256ZE Breakout Board][]

# Table of contents

Please go to [Main Project Page] for table of contents and introduction

# Lesson 2 - inverter

We copy _negative reset_ (`nrst`) to negative LED D1 `nled`
and inverted (=positive) reset to LED D2

This circuit uses following signals/names:

Name|Pin|Direction|Function
----|---|---------|--------
nrst|72|Input|Negative RESET - active in `0` right after power-up or on button press
nled[0]|71|Output|Negative LED D1 on board - lights when `0` on input
nled[1]|70|Output|Positive LED D2 - lights when RESET is `1` (idle)
nled[2]|63|Output|LED D3 - off
nled[3]|62|Output|LED D4 - off
nled[4]|61|Output|LED D5 - off
nled[5]|60|Output|LED D6 - off
nled[6]|59|Output|LED D7 - off
nled[7]|58|Output|LED D8 - off


Our Verilog file [bb_top.v]
looks like this:
```verilog
module bb_top(nled,nrst);
  output [7:0] nled;
  input nrst;

  assign nled[0] =  nrst;
  assign nled[1] = ~nrst;
  assign nled[7:2] = 6'b111111;

endmodule
```

Our _PostFit Equations_ are that simple:
```
nled_0_ = nrst ; (1 pterm, 1 signal)
nled_1_ = !nrst ; (1 pterm, 1 signal)
nled_2_ = 1 ; (1 pterm, 0 signal)
nled_3_ = 1 ; (1 pterm, 0 signal)
nled_4_ = 1 ; (1 pterm, 0 signal)
nled_5_ = 1 ; (1 pterm, 0 signal)
nled_6_ = 1 ; (1 pterm, 0 signal)
nled_7_ = 1 ; (1 pterm, 0 signal)
```

And here is _RTL View_ from `bb_top.prj` using _Synplify Pro_:

![RTL View](https://raw.githubusercontent.com/hpaluch/ispMach-learn-verilog/b-lesson2-invert/images/rtl-view.png)
            

# Project outputs

Please checkout right versions of report (GitHub pages show latest report only.)


[ispMACH 4256ZE Breakout Board]: http://www.latticesemi.com/Products/DevelopmentBoardsAndKits/ispMACH4256ZEBreakoutBoard.aspx
[Getting started with ispMACH 4256ZE Breakout Board]: https://github.com/hpaluch/hpaluch.github.io/wiki/Getting-started-with-ispMACH-4256ZE-Breakout-Board
[Adding RESET button to ispMACH 4256ZE Breakout Board]: https://github.com/hpaluch/hpaluch.github.io/wiki/Adding-RESET-button-to-ispMACH-4256ZE-Breakout-Board
[JEDEC]: https://github.com/hpaluch/ispMach-learn-verilog/blob/b-lesson2-invert/bb_learn.jed 
[bb_top.v]: https://github.com/hpaluch/ispMach-learn-verilog/blob/b-lesson2-invert/bb_top.v
[Main Project Page]: https://github.com/hpaluch/ispMach-learn-verilog
