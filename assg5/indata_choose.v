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
		indata_sel,indata_alu,indata_dmem,indata,indata_dec
    );
	 input [1:0]indata_sel;
	 input [31:0] indata_alu,indata_dmem,indata_dec;
	 output reg [31:0] indata;
	 always@(indata_sel or indata_alu or indata_dmem or indata_dec)
		begin
			case (indata_sel)
					2'b00 : indata = indata_alu;
					2'b01 : indata = indata_dmem;
					2'b10 : indata = indata_dec;
					default : indata = 32'h00000000;
			endcase
		end
endmodule
