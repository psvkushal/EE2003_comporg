`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    23:57:40 09/15/2019 
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
	 //dmem input
	 wire [3:0] we;
	 wire [`dmem_width-1:0] indata; 
	 wire [`dmem_addr-1:0] daddr;
	 //dmem output
	 wire [`dmem_width-1:0] outdata;
	 //icon ctrl
	 wire [35:0] VIO;
	 
	 dmem instance1(
    .daddr(daddr), .clk(clk), .we(we) , .indata(indata), //input
	 .outdata(outdata) //output
	 );
	 
	 icon instance2(
    .CONTROL0(VIO) // INOUT BUS [35:0]
    );
	 
	 vio instance3 (
    .CONTROL(VIO), // INOUT BUS [35:0]
    .CLK(clk), // IN
    .SYNC_OUT({we,daddr,indata}), // IN BUS [67:0] 4 + 32 + 32
    .SYNC_IN({outdata}) // OUT BUS [31:0]  32  
	 );
	 
endmodule
