# ispMach learn Verilog

Learning Verilog HDL using cheap [ispMACH 4256ZE Breakout Board][]

> The goal is to learn Verilog HDL basics using simples possible tools...
                                                                  
Please see my introductory tutorial
[Getting started with ispMACH 4256ZE Breakout Board][]
for software and hardware requirements.

Also read 
[Adding RESET button to ispMACH 4256ZE Breakout Board][]
for step by step guide how to create and program basic
project - with RESET button.                                       

# Project status

Our simplest Verilog file [bb_top.v]
looks like this:
```v
module bb_top(led,nrst);
  output led;
  input nrst;

  assign led[0] = nrst;

endmodule
```

We just copy _negative reset_ (`nrst`) to LED D1 `led` (please note
that on board this LED is also negative - it lights on logical `1` output).

Our [PostFit Equations][] are that simple:
```
led = nrst ; (1 pterm, 1 signal)
```

And here is _RTL View_ from `bb_top.prj` using _Synplify Pro_:

![RTL View](https://github.com/hpaluch/ispMach-learn-verilog/blob/master/images/rtl-view.png?raw=true)


# Project outputs

Please see [Latest project reports][] files including
[HTML report][] and [JEDEC][] programming file. 



[ispMACH 4256ZE Breakout Board]: http://www.latticesemi.com/Products/DevelopmentBoardsAndKits/ispMACH4256ZEBreakoutBoard.aspx
[Getting started with ispMACH 4256ZE Breakout Board]: https://github.com/hpaluch/hpaluch.github.io/wiki/Getting-started-with-ispMACH-4256ZE-Breakout-Board
[Adding RESET button to ispMACH 4256ZE Breakout Board]: https://github.com/hpaluch/hpaluch.github.io/wiki/Adding-RESET-button-to-ispMACH-4256ZE-Breakout-Board
[Latest project reports]: https://hpaluch.github.io/ispMach-learn-verilog/
[HTML report]: https://hpaluch.github.io/ispMach-learn-verilog/bb_learn.html
[JEDEC]: https://hpaluch.github.io/ispMach-learn-verilog/bb_learn.jed
[bb_top.v]: https://github.com/hpaluch/ispMach-learn-verilog/blob/399dbd8f46ff4885d6c123b5c8e1caa9a70c43cc/bb_top.v
[PostFit Equations]:https://hpaluch.github.io/ispMach-learn-verilog/bb_learn_rpt.html#PostFit_Equations
