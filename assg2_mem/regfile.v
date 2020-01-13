//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    14:47:10 08/28/2019 
// Design Name: 
// Module Name:    regfile 
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
`timescale 1ns / 1ps
`include "parameters.v"
//module for regfile

module regfile(
	 //input
	 rs1, rs2, rd, we, clk, indata,
	 //ouput
	 rv1, rv2
    );
	 input [`reg_w-1:0] rs1,rs2,rd;
    input we,clk;
	 input[`mem_w-1:0] indata;
    output wire[`mem_w-1:0] rv1,rv2;
	 reg [`R_no-1:0] RF [`mem_w-1:0]; 
	 integer addr;
	 initial 
	 begin 
	 for (addr = 0;addr < `R_no; addr = addr+1)
	 begin RF[addr] = 32'h00000000; end
	 end
	 // decleration of reg file since we need 3 port usage in one clk cycle we are using array def.
	 assign rv1 = RF[rs1];
	 assign rv2 = RF[rs2];
	 always@(posedge clk)
	 begin
	 if(we & (rd != 5'b00000)) 
		begin RF[rd] <= indata; end // I have some doubt in the logi  implemented here. 
	 end
endmodule