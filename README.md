# ispMach learn Verilog

Learning Verilog HDL using cheap [ispMACH 4256ZE Breakout Board][]

# Table of contents

Please go to [Main Project Page] for table of contents and introduction

> NOTE: This design requires working RESET circuit:
>
> ![RESET circuit](https://raw.githubusercontent.com/wiki/hpaluch/hpaluch.github.io/files/latt_reset_schema_cut.png)
>
> Please read [Adding RESET button to ispMACH 4256ZE Breakout Board][] for
> complete instructions and tips.

# Lesson 3 - counter with RESET

Now we have 2-bit counter with asynchronous RESET (independent of clock)

> NOTE:
>
> Although counter is hold on `0` value on RESET, the
> clock `clk` signal is not hold by RESET (it ticks independently)

This circuit uses following signals/names:

Name|Pin|Direction|Function
----|---|---------|--------
nrst|72|Input|Negative RESET - active in `0` right after power-up or on button press
nled[0]|71|Output|lights on when RESET is active (`nrst=0`)
nled[1]|70|Output|LED D2 - blinks at 4.7Hz timer output on `clk` signal
nled[2]|63|Output|LED D3 - counter bit 0 - blinks 2x slower than D2
nled[3]|62|Output|LED D4 - counter bit 1 - blinks 2x slower than D3
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

  wire   rst; // positive RESET
  assign rst = ~nrst;

  wire  [7:0] led; // positive LEDs
  assign nled = ~led;

  // now we can use positive logic (1=active, 0=inactive)
  assign led[0]   = rst;
  assign led[7:4] = 4'h0;

  wire clk; // 4.7Hz internal clock from OSCTIMER module  
  assign led[1]   = clk; // output 4.7Hz clock on LED D2

  defparam I1.TIMER_DIV = "1048576";
  OSCTIMER I1 (.DYNOSCDIS(1'b0), .TIMERRES(1'b0), .OSCOUT(), .TIMEROUT(clk) );

  // 2-bit counter (divider by 4)
  // = 2'd0;  setting initial value from chapter "Initial Values in Verilog", page 315
  //   file "reference.pdf", "Synplify Pro for Lattice Reference Manual"
  reg    [1:0] counter = 2'd0; // Has no effect - some source says that 0 is default (maybe that reason?)
  assign led[3:2] = counter;

  always @(posedge clk or posedge rst)
  begin
    if (rst)
      counter <= 2'd0;
    else
      counter <= counter + 1;
  end

endmodule
```

Our [PostFit Equations] are bellow:
```
_dup_gnd_n_n = 0 ; (0 pterm, 0 signal)

gnd_n_n = 0 ; (0 pterm, 0 signal)

nled_0_ = nrst ; (1 pterm, 1 signal)

nled_1_ = !clk ; (1 pterm, 1 signal)

nled_2_.D = !nled_2_.Q ; (1 pterm, 1 signal)
nled_2_.C = clk ; (1 pterm, 1 signal)
nled_2_.AP = !nrst ; (1 pterm, 1 signal)

nled_3_.D = nled_3_.Q & nled_2_.Q
    # !nled_3_.Q & !nled_2_.Q ; (2 pterms, 2 signals)
nled_3_.C = clk ; (1 pterm, 1 signal)
nled_3_.AP = !nrst ; (1 pterm, 1 signal)

nled_4_ = 1 ; (1 pterm, 0 signal)

nled_5_ = 1 ; (1 pterm, 0 signal)

nled_6_ = 1 ; (1 pterm, 0 signal)

nled_7_ = 1 ; (1 pterm, 0 signal)
```

And here is _RTL View_ from `bb_top.prj` using _Synplify Pro_:

![RTL View](https://raw.githubusercontent.com/hpaluch/ispMach-learn-verilog/b-lesson3-counter-w-rst/images/rtl-view.png)
            

# Project outputs

Please checkout/download this branch to get Project outputs

# Navigation

* [Main Project Page][] - table of contents - includes list of Lessons
* [Lesson 2 - inverter][]
* [Lesson 4 - counter as module][]


[ispMACH 4256ZE Breakout Board]: http://www.latticesemi.com/Products/DevelopmentBoardsAndKits/ispMACH4256ZEBreakoutBoard.aspx
[Getting started with ispMACH 4256ZE Breakout Board]: https://github.com/hpaluch/hpaluch.github.io/wiki/Getting-started-with-ispMACH-4256ZE-Breakout-Board
[Adding RESET button to ispMACH 4256ZE Breakout Board]: https://github.com/hpaluch/hpaluch.github.io/wiki/Adding-RESET-button-to-ispMACH-4256ZE-Breakout-Board
[JEDEC]: https://github.com/hpaluch/ispMach-learn-verilog/blob/b-lesson3-counter-w-rst/bb_learn.jed 
[bb_top.v]: https://github.com/hpaluch/ispMach-learn-verilog/blob/b-lesson3-counter-w-rst/bb_top.v
[Main Project Page]: https://github.com/hpaluch/ispMach-learn-verilog
[PostFit Equations]: https://github.com/hpaluch/ispMach-learn-verilog/blob/b-lesson3-counter-w-rst/equations.txt
[Lesson 2 - inverter]: https://github.com/hpaluch/ispMach-learn-verilog/tree/b-lesson2-invert
[Lesson 4 - counter as module]: https://github.com/hpaluch/ispMach-learn-verilog/tree/b-lesson4-counter-module


