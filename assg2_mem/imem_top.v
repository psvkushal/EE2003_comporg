`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    20:03:19 09/15/2019 
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
	 wire [`imem_width-1:0] iaddr;
	 wire we;
	 wire [`imem_width-1:0] idata;
	 wire [35:0] VIO;
	 imem instance1(
		//input 
		.iaddr(iaddr), .clk(clk),
		//output
		.idata(idata),
		//dummy input
		.we(we)
	  );
	  
	  icon instance2(
    .CONTROL0(VIO) // INOUT BUS [35:0]
     );
	  vio instance3 (
    .CONTROL(VIO), // INOUT BUS [35:0]
    .CLK(clk), // IN
    .SYNC_IN({idata}), // IN BUS [31:0]
    .SYNC_OUT({we,iaddr}) // OUT BUS [32:0]
	 );


	  
endmodule 