// Learning Verilog on ispMACH 4256ZE Breakout Board 
//
// Top Level module
//
module bb_top(nled,nrst);
  output nled;
  input nrst;

  assign nled = nrst;

endmodule
