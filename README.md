# ispMach learn Verilog

Learning Verilog HDL using cheap [ispMACH 4256ZE Breakout Board][]

> The goal is to learn Verilog HDL basics using simples possible tools...

Requirements - please read/setup following:
* [Getting started with ispMACH 4256ZE Breakout Board][]
* [Adding RESET button to ispMACH 4256ZE Breakout Board][]

# Lesson 1 - direct wire

We just copy _negative reset_ (`nrst`) to negative LED D1 `nled` (please note
that on board this LED is also negative - it lights on logical `1` output).

This circuit uses following signals/names:

Name|Pin|Direction|Function
----|---|---------|--------
nrst|72|Input|Negative RESET - active in `0` right after power-up or on button press
nled|71|Output|Negative LED D1 on board - ligts when `0` on input


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

![RTL View](https://github.com/hpaluch/ispMach-learn-verilog/blob/master/images/rtl-view.png?raw=true)


# Project outputs

Please checkout right versions of report (GitHub pages show latest report only.)

# Latest project output
Here are outputs from latest `master` branch:
* [Latest project reports]  - splash screen
* [HTML report] - main synthesis report 
* [PostFit Equations] - latest postfit equations

[ispMACH 4256ZE Breakout Board]: http://www.latticesemi.com/Products/DevelopmentBoardsAndKits/ispMACH4256ZEBreakoutBoard.aspx
[Getting started with ispMACH 4256ZE Breakout Board]: https://github.com/hpaluch/hpaluch.github.io/wiki/Getting-started-with-ispMACH-4256ZE-Breakout-Board
[Adding RESET button to ispMACH 4256ZE Breakout Board]: https://github.com/hpaluch/hpaluch.github.io/wiki/Adding-RESET-button-to-ispMACH-4256ZE-Breakout-Board
[Latest project reports]: https://hpaluch.github.io/ispMach-learn-verilog/
[HTML report]: https://hpaluch.github.io/ispMach-learn-verilog/bb_learn.html
[JEDEC]: https://hpaluch.github.io/ispMach-learn-verilog/bb_learn.jed
[bb_top.v]: https://github.com/hpaluch/ispMach-learn-verilog/blob/50855298dfcba6d568ee74d0cd7eacdf01f259cf/bb_top.v
[PostFit Equations]:https://hpaluch.github.io/ispMach-learn-verilog/bb_learn_rpt.html#PostFit_Equations
