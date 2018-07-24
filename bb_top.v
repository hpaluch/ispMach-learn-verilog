// Learning Verilog on ispMACH 4256ZE Breakout Board 
//
// Top Level module
//
module bb_top(nled,nrst);
  output [7:0] nled;
  input nrst;

  assign nled[0] =  nrst;
  assign nled[1] = ~nrst;
  assign nled[7:2] = 6'b111111;

endmodule

