// Copyright (C) 1991-2013 Altera Corporation
// Your use of Altera Corporation's design tools, logic functions 
// and other software and tools, and its AMPP partner logic 
// functions, and any output files from any of the foregoing 
// (including device programming or simulation files), and any 
// associated documentation or information are expressly subject 
// to the terms and conditions of the Altera Program License 
// Subscription Agreement, Altera MegaCore Function License 
// Agreement, or other applicable license agreement, including, 
// without limitation, that your use is for the sole purpose of 
// programming logic devices manufactured by Altera and sold by 
// Altera or its authorized distributors.  Please refer to the 
// applicable agreement for further details.

// *****************************************************************************
// This file contains a Verilog test bench template that is freely editable to  
// suit user's needs .Comments are provided in each section to help the user    
// fill out necessary details.                                                  
// *****************************************************************************
// Generated on "02/14/2021 20:52:56"
                                                                                
// Verilog Test Bench template for design : top_traffic
// 
// Simulation tool : ModelSim-Altera (Verilog)
// 

`timescale 1 ps/ 1 ps
module top_traffic_sim();
// constants                                           
reg [11:0] key;
reg sys_clk;
reg sys_rst_n;
reg emergency;
// wires                                               
wire [5:0]  led;
wire [7:0]  seg_led;
wire [3:0]  sel;

// assign statements (if any)                          
top_traffic i1( 
	.emergency(emergency),
	.key(key),
	.led(led),
	.seg_led(seg_led),
	.sel(sel),
	.sys_clk(sys_clk),
	.sys_rst_n(sys_rst_n)
);

initial begin
    sys_clk        <= 1'b0;
    sys_rst_n      <= 1'b1;
	emergency      <= 1'b0;
	key            <= 12'b0000_0000_0000;
	# 20 sys_rst_n <= 1'b0;
    # 20 sys_rst_n <= 1'b1;
end

always # 10 sys_clk = ~sys_clk; 
                                                                                             
endmodule

