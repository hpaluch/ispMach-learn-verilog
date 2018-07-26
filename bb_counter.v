// Learning Verilog on ispMACH 4256ZE Breakout Board 
//
// 2-bit counter module with async reset
//
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
