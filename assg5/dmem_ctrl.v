`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    22:43:15 11/05/2019 
// Design Name: 
// Module Name:    dmem_ctrl 
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
module dmem_ctrl(
		dmem_indata, daddr, we_dmem, dwdata ,drdata, reg_indata, funct3, load_store_sel, dmem_sig
    );
	input [31:0] daddr; //addr in dmem
	input [2:0] funct3;
	input load_store_sel, dmem_sig;
	input [31:0] dmem_indata,drdata; //indata for dmem from reg and data read from dmem
	output reg [3:0] we_dmem; //4 write enable pins
	output reg [31:0] dwdata,reg_indata; //data that is written into dmem	 and indata for reg from dmem
	//this module will be used for altering input to dmem and reg file
	always@(daddr or dmem_indata or drdata or load_store_sel or funct3)
		begin
		we_dmem = 4'b0000;
		dwdata = 32'h00000000;
		reg_indata = 32'h00000000;
		$display("granted forall");
		if(dmem_sig)
			begin
				case(load_store_sel)
					1'b1: //store
						case(funct3)
							3'b000 : 
								begin	
									dwdata = {4{dmem_indata[7:0]}};
									we_dmem = (4'b0001 << (daddr%4));
									$display("store byte, time = %d",$time);
								end
							3'b001 :
								begin	
									dwdata = {2{dmem_indata[15:0]}};
									we_dmem = (4'b0011 << (daddr%4));
									$display("store half word, time = %d",$time);
								end
							3'b010 :
								begin	
									dwdata = dmem_indata[31:0];
									we_dmem = 4'b1111;
									$display("store word, time = %d",$time);
								end
						endcase
					1'b0: //load
						case (funct3) 
							3'b000 : 
								begin
									$display("funct3, time = %d",$time);
									case((daddr%4))
										2'b00 : begin reg_indata = {{24{drdata[7]}},drdata[7:0]}; $display("LB 0, time = %d",$time); end
										2'b01 : begin reg_indata = {{24{drdata[15]}},drdata[15:8]};$display("LB 1, time = %d",$time); end
										2'b10 : begin reg_indata = {{24{drdata[23]}},drdata[23:16]};$display("LB 2, time = %d",$time); end
										2'b11 : begin reg_indata = {{24{drdata[31]}},drdata[31:24]};$display("LB 3, time = %d",$time); end
									endcase
								end
							3'b001 :
								begin
									$display("funct3, time = %d",$time);
									case((daddr%4))
										2'b00 :begin reg_indata = {{16{drdata[15]}},drdata[15:0]};$display("LH 0, time = %d",$time); end
										2'b10 :begin reg_indata = {{16{drdata[31]}},drdata[31:16]};$display("LH 1, time = %d",$time); end
									endcase
								end
							3'b010 :reg_indata = drdata;
							3'b100 :
								begin
									$display("funct3, time = %d",$time);
									case((daddr%4))
									2'b00 : begin reg_indata[7:0] = drdata[7:0];$display("LBU 0"); end
									2'b01 : begin reg_indata[7:0] = drdata[15:8];$display("LBU 1"); end
									2'b10 : begin reg_indata[7:0] = drdata[23:16];$display("LBU 2"); end
									2'b11 : begin reg_indata[7:0] = drdata[31:24];$display("LBU 3"); end
								endcase
								end
							3'b101 :
							begin
								$display("funct3, time = %d",$time);
								case((daddr%4))
									2'b00 :begin reg_indata[15:0] = drdata[15:0];$display("LHU 0"); end
									2'b10 :begin reg_indata[15:0] = drdata[31:16];$display("LHU 1 time = %d",$time); end
								endcase
							end
						endcase
				endcase
			end
		end
endmodule 