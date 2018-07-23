// Learning Verilog on ispMACH 4256ZE Breakout Board 
//
// Top Level module
//
module bb_top(led,nrst);
  output led;
  input nrst;

  assign led[0] = nrst;

endmodule
