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
  assign led[7:4] = 4'h0;

  wire clk; // 4.7Hz internal clock from OSCTIMER module  
  assign led[1]   = clk; // output 4.7Hz clock on LED D2

  defparam I1.TIMER_DIV = "1048576";
  OSCTIMER I1 (.DYNOSCDIS(1'b0), .TIMERRES(1'b0), .OSCOUT(), .TIMEROUT(clk) );

  // connect our 2-bit counter to LED D3 (divide clk 2x) and D4 (divide clk 4x)
  bb_counter bbc1 ( .rst(rst), .clk(clk), .dout(led[3:2]));
endmodule

