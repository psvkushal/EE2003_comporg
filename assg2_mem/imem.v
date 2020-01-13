`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    12:39:55 09/03/2019 
// Design Name: 
// Module Name:    imem 
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

//module for imem
`include "parameters.v"

module imem(
	//input 
	iaddr, clk,
	//output
	idata,
	//dummy input
	we
	);
	input [`imem_width-1:0] iaddr; //input address to imem
	input we; //just a dummy for instatiating bram
	input clk;
	output reg [`imem_width-1:0] idata; //output data
	reg [`imem_width-1:0] IMEM [`imem_depth-1:0]; //reg in which IMEM data is stored
	initial
	begin $readmemh("imem_data.txt",IMEM); end
	always@(posedge clk)
		begin
			idata <= IMEM[iaddr];
		end
endmodule
