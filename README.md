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

# Lesson 6 - running light with rotating shift register

Now we have:

* running light on LED D5 to D8 - sequence D5,D6,D7,D8,D5,...
  We use rotating shift register in [bb_shift.v]

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
nled[2]|63|Output|LED D3 - off
nled[3]|62|Output|LED D4 - off
nled[4]|61|Output|LED D5 - running light in sequence D5,D6,D7,D8,D5,...
nled[5]|60|Output|LED D6 - running light in sequence D5,D6,D7,D8,D5,... 
nled[6]|59|Output|LED D7 - running light in sequence D5,D6,D7,D8,D5,...
nled[7]|58|Output|LED D8 - running light in sequence D5,D6,D7,D8,D5,...

Our top-level Verilog file [bb_top.v] is:
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

  wire clk; // 4.7Hz internal clock from OSCTIMER module  
  assign led[1]   = clk; // output 4.7Hz clock on LED D2

  defparam I1.TIMER_DIV = "1048576";
  OSCTIMER I1 (.DYNOSCDIS(1'b0), .TIMERRES(1'b0), .OSCOUT(), .TIMEROUT(clk) );

  // LED D3 & D4 off
  assign led[3:2] = 2'b00;

  // running light on LED D5 to D8 using circular shift register
  bb_shift bbs1 ( .clk(clk), .rst(rst), .dout(led[7:4]) );

endmodule
```

## 4-bit rotating shift register

The whole sequential logic is contained in this
rotating shift register.

Our Shift register module [bb_shift.v] is:
```verilog
module bb_shift(clk,rst,dout);
  input   clk;
  input   rst;
  output [3:0] dout;
  reg    [3:0] dout = 4'h1; // power-up value

  always @(posedge clk or posedge rst)
  begin
  if (rst)
    dout <= 4'h1; // asynchronous reset value
  else
    dout <= { dout[2:0], dout[3] };
  end

endmodule
```

_Functional Simulation_ of our [bb_shift.v]
using _Aldec Active-HDL_ is:

![bb_shift functional simulation](https://raw.githubusercontent.com/hpaluch/ispMach-learn-verilog/b-lesson6-shift/images/func-sim0.png)

Simulation Stimulus (_Test Fixture_ = TF) file is [bb_shift_tf.v].

> NOTE: I used different clock frequency for counter Simulation 
> (100ns = 10MHz) instead of 4.7Hz (counter used by [bb_top.v]).
>
> Timing does not matter for functional simulation
> (there are no delays accounted in functional simulation)


Our [PostFit Equations] for whole circuit are bellow:
```
_dup_gnd_n_n = 0 ; (0 pterm, 0 signal)

bbs1_dout_0_.D = bbs1_dout_3_.Q ; (1 pterm, 1 signal)
bbs1_dout_0_.C = clk ; (1 pterm, 1 signal)
bbs1_dout_0_.AP = !nrst ; (1 pterm, 1 signal)

bbs1_dout_1_.D = bbs1_dout_0_.Q ; (1 pterm, 1 signal)
bbs1_dout_1_.C = clk ; (1 pterm, 1 signal)
bbs1_dout_1_.AR = !nrst ; (1 pterm, 1 signal)

bbs1_dout_2_.D = bbs1_dout_1_.Q ; (1 pterm, 1 signal)
bbs1_dout_2_.C = clk ; (1 pterm, 1 signal)
bbs1_dout_2_.AR = !nrst ; (1 pterm, 1 signal)

bbs1_dout_3_.D = bbs1_dout_2_.Q ; (1 pterm, 1 signal)
bbs1_dout_3_.C = clk ; (1 pterm, 1 signal)
bbs1_dout_3_.AR = !nrst ; (1 pterm, 1 signal)

gnd_n_n = 0 ; (0 pterm, 0 signal)

nled_0_ = nrst ; (1 pterm, 1 signal)

nled_1_ = !clk ; (1 pterm, 1 signal)

nled_2_ = 1 ; (1 pterm, 0 signal)

nled_3_ = 1 ; (1 pterm, 0 signal)

nled_4_.D = !bbs1_dout_3_.Q ; (1 pterm, 1 signal)
nled_4_.C = clk ; (1 pterm, 1 signal)
nled_4_.AR = !nrst ; (1 pterm, 1 signal)

nled_5_.D = !bbs1_dout_0_.Q ; (1 pterm, 1 signal)
nled_5_.C = clk ; (1 pterm, 1 signal)
nled_5_.AP = !nrst ; (1 pterm, 1 signal)

nled_6_.D = !bbs1_dout_1_.Q ; (1 pterm, 1 signal)
nled_6_.C = clk ; (1 pterm, 1 signal)
nled_6_.AP = !nrst ; (1 pterm, 1 signal)

nled_7_.D = !bbs1_dout_2_.Q ; (1 pterm, 1 signal)
nled_7_.C = clk ; (1 pterm, 1 signal)
nled_7_.AP = !nrst ; (1 pterm, 1 signal)
```

> NOTE:
>
> I'm not sure why there is 2 times more D flip-flops than expected
> (4 shuld be enough - and this is also number in RTL/Technology views).
>
> I guess that it is because pin constraints of LEDs do not allow laying
> out D flip-flops as needed for rotated bits.
>
> It is noteworthy that this variant (which seems to be much simpler
> just one shift register instead of counter + address decoder)
> uses more resources as is visible in [Reports 5 vs 6 diff].


And here is _RTL View_ from `bb_top.prj` using _Synplify Pro_:

![RTL View - bb_top](https://raw.githubusercontent.com/hpaluch/ispMach-learn-verilog/b-lesson6-shift/images/rtl-view.png)

Here is _RTL View_ just for 4-bit rotating shift register:

![RTL View - bb_shift](https://raw.githubusercontent.com/hpaluch/ispMach-learn-verilog/b-lesson6-shift/images/rtl-view-bb_shift.png)
            
And _Technology view_ using _Synplify Pro_:

![Technology View](https://raw.githubusercontent.com/hpaluch/ispMach-learn-verilog/b-lesson6-shift/images/tech-view.png)            

# Project outputs

Please checkout/download this branch to get Project outputs

# Navigation

* [Main Project Page][] - table of contents - includes list of Lessons
* [Lesson 5 - running light with decoder 2to4] - previous lesson


[ispMACH 4256ZE Breakout Board]: http://www.latticesemi.com/Products/DevelopmentBoardsAndKits/ispMACH4256ZEBreakoutBoard.aspx
[Getting started with ispMACH 4256ZE Breakout Board]: https://github.com/hpaluch/hpaluch.github.io/wiki/Getting-started-with-ispMACH-4256ZE-Breakout-Board
[Adding RESET button to ispMACH 4256ZE Breakout Board]: https://github.com/hpaluch/hpaluch.github.io/wiki/Adding-RESET-button-to-ispMACH-4256ZE-Breakout-Board
[JEDEC]: https://github.com/hpaluch/ispMach-learn-verilog/blob/b-lesson6-shift/bb_learn.jed 
[bb_top.v]: https://github.com/hpaluch/ispMach-learn-verilog/blob/b-lesson6-shift/bb_top.v
[bb_shift.v]: https://github.com/hpaluch/ispMach-learn-verilog/blob/b-lesson6-shift/bb_shift.v
[bb_shift_tf.v]: https://github.com/hpaluch/ispMach-learn-verilog/blob/b-lesson6-shift/bb_shift_tf.v
[Main Project Page]: https://github.com/hpaluch/ispMach-learn-verilog
[PostFit Equations]: https://github.com/hpaluch/ispMach-learn-verilog/blob/b-lesson6-shift/equations.txt
[Lesson 5 - running light with decoder 2to4]: https://github.com/hpaluch/ispMach-learn-verilog/tree/b-lesson5-dec2to4
[Reports 5 vs 6 diff]: https://github.com/hpaluch/ispMach-learn-verilog/compare/b-lesson5-dec2to4...b-lesson6-shift#diff-5e31d9b95204be9fe4cdb2896e699c64