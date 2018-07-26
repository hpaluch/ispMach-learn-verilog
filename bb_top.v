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

