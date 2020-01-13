`timescale 1ns / 1ps
`include "parameters.v"
module regfile(
	 //input
	 rs1, rs2, rd, we, clk, indata,
	 //ouput
	 rv1, rv2, x31
    );
	 input [`reg_addr-1:0] rs1,rs2,rd;
    input we,clk;
	 input[`data_width-1:0] indata;
    output wire[`data_width-1:0] rv1,rv2,x31; 
	 reg [`R_no-1:0] RF [`data_width-1:0];
	 integer addr;
	 initial 
	 begin 
	 for (addr = 0;addr < `R_no; addr = addr+1)
	 begin RF[addr] = 32'h00000000; end
	 end
	 // decleration of reg file since we need 3 port usage in one clk cycle we are using array def.
	 assign rv1 = RF[rs1];
	 assign rv2 = RF[rs2];
	 assign x31 = RF[5'b11111];
	 always@(posedge clk)
	 begin
	 if(we & (rd != 5'b00000)) 
		begin RF[rd] <= indata; end // I have some doubt in the logi  implemented here. 
	 end
endmodule 