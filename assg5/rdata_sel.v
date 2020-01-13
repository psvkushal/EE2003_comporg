`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    10:50:24 11/11/2019 
// Design Name: 
// Module Name:    rdata_sel 
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
module rdata_sel(
		rdata_sel,
		rdata_per0,rdata_per1,
		rdata
    );
	 input [1:0]rdata_sel;
	 input [31:0] rdata_per0,rdata_per1;
	 output reg[31:0] rdata;
	always@(*)
		begin
			case(rdata_sel)
				2'b01 : rdata = rdata_per0; //rdata from dmem
				2'b10 : rdata = rdata_per1; //rdata from Peipheral
				default : rdata =32'h0;
			endcase
		end
endmodule 