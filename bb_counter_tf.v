

// TOOL:     vlog2tf
// DATE:     07/27/18  16:38:21 
// TITLE:    Lattice Semiconductor Corporation
// MODULE:   bb_counter
// DESIGN:   bb_counter
// FILENAME: bb_counter.tft
// PROJECT:  bb_learn
// VERSION:  1.0
// This file is auto generated by the ispLEVER


`timescale 1 ns / 1 ns

// Define Module for Test Fixture
module bb_counter_tf();

// Inputs
    reg rst;
    reg clk;

// Outputs
    wire [1:0] dout;

// Bidirs

// Instantiate the UUT
    bb_counter UUT (
        .rst(rst), 
        .clk(clk), 
        .dout(dout)
        );

// Initialize Inputs
// You can add your stimulus here
    initial begin
             rst = 0;
             clk = 0;
	 #25 rst = 1;
	#100 rst = 0;
    end

    always
	#50 clk = ~clk;

endmodule // bb_counter_tf