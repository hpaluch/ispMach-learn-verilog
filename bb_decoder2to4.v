// Learning Verilog on ispMACH 4256ZE Breakout Board 
//
// Decoder 2 to 4 (similar to 74139 but WITHOUT inverting outputs)
//
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
