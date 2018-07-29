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

# Lesson 5 - running light with decoder 2 to 4

Now we have:

* 2-bit counter with asynchronous RESET (independent of clock).
  Counter code is in separate Verilog file [bb_counter.v].
* running light on LED D5 to D8 - sequence D5,D6,D7,D8,D5,...
  We use Address decoder 2-to-4 module in [bb_decoder2to4.v]
  to convert 2-bit value into 4-bit sequence

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

  wire [1:0] counter2bit;
  // connect our 2-bit counter to LEDs D3 (divide clk 2x) and D4 (divide clk 4x)
  assign led[3:2] = counter2bit;

  // counter - from clk to 2-bit dout
  bb_counter bbc1 ( .rst(rst), .clk(clk), .dout(counter2bit) );

  // decode 2-bit counter to 4 LEDs - D5 to D8 (only one lights at same time)
  bb_decoder2to4 bbdec1 ( .addrin(counter2bit), .yout(led[7:4]) );

endmodule
```

## 2-bit counter module

Our Counter module [bb_counter.v] is:
```verilog
module bb_counter(rst,clk,dout);
  input rst;
  input clk;
  output [1:0] dout;

  // 2-bit counter (divider by 4)
  // = 2'd0;  setting initial value from chapter "Initial Values in Verilog", page 315
  //   file "reference.pdf", "Synplify Pro for Lattice Reference Manual"
  reg    [1:0] counter = 2'd0; // Has no effect - some source says that 0 is default (maybe that reason?)
  assign dout[1:0] = counter;

  always @(posedge clk or posedge rst)
  begin
    if (rst)
      counter <= 2'd0;
    else
      counter <= counter + 1;
  end

endmodule
```

_Functional Simulation_ of our [bb_counter.v]
using _Aldec Active-HDL_ is:

![bb_counter functional simulation](https://raw.githubusercontent.com/hpaluch/ispMach-learn-verilog/b-lesson5-dec2to4/images/func-sim0.png)

Simulation Stimulus (_Test Fixture_ = TF) file is [bb_counter_tf.v].

> NOTE: I used different clock frequency for counter Simulation 
> (100ns = 10MHz) instead of 4.7Hz (counter used by [bb_top.v]).
>
> Timing does not matter for functional simulation
> (there are no delays accounted in functional simulation)


## Decoder 2 to 4 (bits)

Our Decoder 2 to 4 module [bb_decoder2to4.v] is:
```verilog
module bb_decoder2to4(addrin,yout);
  input  [1:0] addrin;
  output [3:0] yout;
  reg    [3:0] yout;

  always @(addrin)
  begin
    case (addrin)
      2'b00: yout = 4'b0001;
      2'b01: yout = 4'b0010;
      2'b10: yout = 4'b0100;
      2'b11: yout = 4'b1000;
    endcase
  end

endmodule
```

_Functional Simulation_ of our [bb_decoder2to4.v]
using _Aldec Active-HDL_ is:

![bb_decoder2to4 functional simulation](https://raw.githubusercontent.com/hpaluch/ispMach-learn-verilog/b-lesson5-dec2to4/images/func-sim-dec2to40.png)

Simulation Stimulus (_Test Fixture_ = TF) file is [bb_decoder2to4_tf.v].

> NOTE: I used different clock frequency for decoder simulation 
> (100ns = 10MHz) instead of 4.7Hz (counter used by [bb_top.v]).
>
> Timing does not matter for functional simulation
> (there are no delays accounted in functional simulation)

> NOTE:
>
> This module is functionally similar to [74HCT139] with these exceptions:
> * positive outputs (139 uses inverted outputs)
> * no enable input (outputs are always enabled)
> * only single decoder in this module (139 has 2 decoders) - however
>   you can instantiate this module as much as you need


Our [PostFit Equations] for whole circuit are bellow:
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

nled_4_ = !( nled_3_.Q & nled_2_.Q ) ; (1 pterm, 2 signals)

nled_5_ = !( nled_3_.Q & !nled_2_.Q ) ; (1 pterm, 2 signals)

nled_6_ = !( !nled_3_.Q & nled_2_.Q ) ; (1 pterm, 2 signals)

nled_7_ = !( !nled_3_.Q & !nled_2_.Q ) ; (1 pterm, 2 signals)
```

And here is _RTL View_ from `bb_top.prj` using _Synplify Pro_:

![RTL View - bb_top](https://raw.githubusercontent.com/hpaluch/ispMach-learn-verilog/b-lesson5-dec2to4/images/rtl-view.png)

Here is _RTL View_ just for decoder 2 to 4:

![RTL View - bb_decoder2to4](https://raw.githubusercontent.com/hpaluch/ispMach-learn-verilog/b-lesson5-dec2to4/images/rtl-view-bb_decoder2to4.png)
            
And _Technology view_ using _Synplify Pro_:

![Technology View](https://raw.githubusercontent.com/hpaluch/ispMach-learn-verilog/b-lesson5-dec2to4/images/tech-view.png)            

# Project outputs

Please checkout/download this branch to get Project outputs

# Navigation

* [Main Project Page][] - table of contents - includes list of Lessons
* [Lesson 4 - counter as module] - previous lesson


[ispMACH 4256ZE Breakout Board]: http://www.latticesemi.com/Products/DevelopmentBoardsAndKits/ispMACH4256ZEBreakoutBoard.aspx
[Getting started with ispMACH 4256ZE Breakout Board]: https://github.com/hpaluch/hpaluch.github.io/wiki/Getting-started-with-ispMACH-4256ZE-Breakout-Board
[Adding RESET button to ispMACH 4256ZE Breakout Board]: https://github.com/hpaluch/hpaluch.github.io/wiki/Adding-RESET-button-to-ispMACH-4256ZE-Breakout-Board
[JEDEC]: https://github.com/hpaluch/ispMach-learn-verilog/blob/b-lesson5-dec2to4/bb_learn.jed 
[bb_top.v]: https://github.com/hpaluch/ispMach-learn-verilog/blob/b-lesson5-dec2to4/bb_top.v
[bb_counter.v]: https://github.com/hpaluch/ispMach-learn-verilog/blob/b-lesson5-dec2to4/bb_counter.v
[bb_counter_tf.v]: https://github.com/hpaluch/ispMach-learn-verilog/blob/b-lesson5-dec2to4/bb_counter_tf.v
[bb_decoder2to4.v]: https://github.com/hpaluch/ispMach-learn-verilog/blob/b-lesson5-dec2to4/bb_decoder2to4.v
[bb_decoder2to4_tf.v]: https://github.com/hpaluch/ispMach-learn-verilog/blob/b-lesson5-dec2to4/bb_decoder2to4_tf.v
[Main Project Page]: https://github.com/hpaluch/ispMach-learn-verilog
[PostFit Equations]: https://github.com/hpaluch/ispMach-learn-verilog/blob/b-lesson5-dec2to4/equations.txt
[Lesson 4 - counter as module]: https://github.com/hpaluch/ispMach-learn-verilog/tree/b-lesson4-counter-module
[74HCT139]: http://www.ti.com/lit/ds/symlink/sn74hct139.pdf
