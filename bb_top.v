// Learning Verilog on ispMACH 4256ZE Breakout Board 
//
// Top Level module
//
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

