`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    17:05:39 09/03/2019 
// Design Name: 
// Module Name:    dmem 
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
module dmem(
    daddr, clk, we , indata, //input
	 outdata //output
	 );
	 input [`dmem_addr-1:0] daddr;
	 input clk;
	 input [3:0] we; // 4 enable input signals required
	 input [`dmem_width-1:0] indata;
	 output reg [`dmem_width-1:0] outdata;
	 reg [`dmem_width/4-1:0] dmem0 [`dmem_depth-1:0];
	 reg [`dmem_width/4-1:0] dmem1 [`dmem_depth-1:0];
	 reg [`dmem_width/4-1:0] dmem2 [`dmem_depth-1:0];
	 reg [`dmem_width/4-1:0] dmem3 [`dmem_depth-1:0];
	 /*
	 it seems like if all the above dmem are written in one line
	 then only one them is recognised so i have to keep them in seperate lines
	 */
	 always@(posedge clk)
	 begin
		if(~we[0])
		begin outdata[`Byte-1:0]<= dmem0[daddr]; end 
		if(~we[1])
		begin outdata[2*`Byte-1:`Byte] <= dmem1[daddr]; end 
		if(~we[2])
		begin outdata[3*`Byte-1:2*`Byte] <= dmem2[daddr]; end 
		if(~we[3])
		begin outdata[4*`Byte-1:3*`Byte] <= dmem3[daddr]; end 
		//assign outdata = 0;
		//concatenating the values together in the 4 memory parts
		if(we[0])
		begin dmem0[daddr] <= indata[`Byte-1:0]; end
		if(we[1])
		begin dmem1[daddr] <= indata[2*`Byte-1:`Byte]; end
		if(we[2])
		begin dmem2[daddr] <= indata[3*`Byte-1:2*`Byte]; end
		if(we[3])
		begin dmem3[daddr] <= indata[4*`Byte-1:3*`Byte]; end
	 end
endmodule 