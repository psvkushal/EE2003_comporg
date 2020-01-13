`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    19:33:30 10/19/2019 
// Design Name: 
// Module Name:    indata_choose 
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
module indata_choose(
		indata_sel,indata_alu,indata_dec,indata
    );
	 input indata_sel;
	 input [31:0] indata_alu,indata_dec;
	 output reg [31:0] indata;
	 always@(*)
		begin
			case (indata_sel)
				1'b0 : indata = indata_alu;
				1'b1 : indata = indata_dec;
			endcase
		end
endmodule
