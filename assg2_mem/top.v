`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    18:54:32 09/15/2019 
// Design Name: 
// Module Name:    top 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
`include "parameters.v"
module top(
    input clk
    );
	 //never forget to keep wires in top file for connection between modules
	 wire [`reg_w-1:0] rs1, rs2, rd;
	 wire we;
	 wire [`mem_w-1:0] indata ;
	 wire [`mem_w-1:0] rv1, rv2;
	 wire [35:0] VIO;
	 
    regfile instance1(
	 //input
	 .rs1(rs1), .rs2(rs2), .rd(rd), .we(we), .clk(clk), .indata(indata),
	 //ouput
	 .rv1(rv1), .rv2(rv2)
    );
	 icon instance2 (
    .CONTROL0(VIO) // INOUT BUS [35:0]
	 );
	 vio instance3 (
    .CONTROL(VIO), // INOUT BUS [35:0]
    .ASYNC_IN({rv1, rv2}), // IN BUS [63:0]  32 + 32 = 64
    .ASYNC_OUT({we, rs1, rs2, rd, indata}) // OUT BUS [47:0] 1 + 5 + 5 + 5 + 32 = 48 
);
	
endmodule
