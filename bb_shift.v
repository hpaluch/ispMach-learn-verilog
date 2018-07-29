// Learning Verilog on ispMACH 4256ZE Breakout Board 
//
// Circular Shift register, dout is: 1, 2, 4, 8, 1, 2,...
//
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
