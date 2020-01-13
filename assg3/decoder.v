`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    12:02:40 09/29/2019 
// Design Name: 
// Module Name:    decoder 
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


module decoder(
    //input
	 instr, rv1, rv2,drdata,PC,
    //output
	 op, rs1, rs2, rd, imm, ALU_input_select, daddr, dwdata, 
	 PC_select, PC_branch, we_dmem, we, indata_dec, indata_sel
);
    input [`Instr_width-1:0] instr;
	 input [`data_width-1:0] PC;
	 input [`reg_width-1:0]rv1, rv2;
	 input [`data_width-1:0]	drdata;
    output reg [`OPWIDTH-1:0] op;
	 output reg ALU_input_select;
	 output reg [`reg_addr-1:0] rs1,rs2,rd; //reg file address
 	 output reg [`data_width-1:0] imm, indata_dec;
	 //imm is the immediate value, indata is the input write data to RF
	 output reg [`data_width-1:0] daddr,dwdata;
	 //daddr, dwdata, drdata are described top_cpu module 
    output reg PC_select, we;
	 output reg [`PC_width-1:0] PC_branch;
	 output reg [3:0] we_dmem; 
	 output reg indata_sel;
	 integer data_shift;
	 reg [4:0] opcode;
	 reg [6:0] funct7;
	 reg [2:0] funct3;
	 reg [1:0] k;
	 always@(*)
	  begin
		  opcode = instr[6:2];
		  funct7 = instr[31:25];
		  funct3 = instr[14:12];
		  rs1    = instr[19:15];
		  rs2    = instr[24:20];
		  rd    = instr[11:7];
		  PC_select = 0; 
		  we_dmem = 4'b0000;
		  we = 0;
		  indata_dec = 32'h00000000;
		  case (opcode)
				/*LUI*/    5'b01101 :begin imm = {instr[31:12],{12{1'b0}}}; $display("imm = %4h, instr = %4h", imm, instr);end 
				/*AUIPC*/  5'b00101 : imm = {instr[31:12],{12{1'b0}}};
				/*JAL*/    5'b11011 : imm = {{20{instr[31]}},instr[31],instr[19:12],instr[20],instr[30:21],{1'b0}};
				/*JALR*/   5'b11001 : imm = {{20{instr[31]}},instr[31:20]};
				/*branch*/ 5'b11000 : imm = {{19{instr[31]}},instr[31],instr[7],instr[30:25],instr[11:8],{1'b1}}; //why did they keep this complicated?
				/*load*/   5'b00000 : imm = {{20{instr[31]}},instr[31:20]};
				/*store*/  5'b01000 : imm = {{20{instr[31]}},instr[31:25],instr[11:7]};
				/*ALU I*/  5'b00100 : imm = {{20{instr[31]}},instr[31:20]}; //sign extending the data to 32 bits
				default  : imm = 32'h00000000;
			endcase
			case (opcode)
				/*LUI*/    5'b01101 : we = 1; 
				/*AUIPC*/  5'b00101 : we = 1;
				/*JAL*/    5'b11011 : we = 1;
				/*JALR*/   5'b11001 : we = 1;
				/*load*/   5'b00000 : we = 1;
				/*ALU I*/  5'b00100 : we = 1;
				/*ALU reg*/5'b01100 : we = 1; 
				default  : we = 0;
			endcase
		  if(opcode == 5'b01101) //LUI
				 begin   
				 indata_dec = imm;
				 $display("imm = %4h", imm);
				 indata_sel = 1;
				 end
		  if(opcode == 5'b00101) //AUIPC
			    begin  
				 indata_dec = PC + imm;
				 indata_sel = 1;
				 end
		  if(opcode == 5'b11011) //JAL
				 begin
					$display("JAL");
					indata_sel = 1;
				   PC_branch = (PC + imm);
				   PC_select = 1;
					indata_dec = PC + 4;
				 end
		  if(opcode == 5'b11001) //JALR
				 begin
					$display("JALR");
					indata_sel = 1;
				   PC_branch = rv1 + imm;
				   indata_dec= PC + 4; //what is expected to be present stored
				   PC_select = 1;
				 end
		  if(opcode == 5'b11000) //branch
			begin
				 PC_branch = PC + imm;
				 if (funct3 == 3'b000) //BEQ
				 begin
					if(rv1 == rv2) 
					begin PC_select = 1; end 
				 end
				 if (funct3 == 3'b001) //BNE
				 begin
					if(rv1 != rv2)
					begin PC_select = 1; end
             end					
				 if (funct3 == 3'b100) //BLT
				 begin
					if($signed(rv1) < $signed(rv2))
					begin PC_select = 1; end
             end					
				 if (funct3 == 3'b101) //BGE
				 begin
					if($signed(rv1) >= $signed(rv2))
					begin PC_select = 1; end
				 end
				 if (funct3 == 3'b110) //BLTU
				 begin
					if(rv1 < rv2)
					begin PC_select = 1; end 
  				 end
				 if (funct3 == 3'b111) //BGEU
				 begin
					if(rv1 >= rv2)
					begin PC_select = 1; end
             end
			end
		  if(opcode == 5'b00000) //load
					begin
					indata_sel = 1;
				   daddr = rv1 + imm;
					case (funct3) 
						3'b000 : 
									begin
										case((daddr%4))
											2'b00 : begin indata_dec = {{24{drdata[7]}},drdata[7:0]}; $display("LB 0"); end
											2'b01 : begin indata_dec = {{24{drdata[15]}},drdata[15:8]};$display("LB 1"); end
											2'b10 : begin indata_dec = {{24{drdata[23]}},drdata[23:16]};$display("LB 2"); end
											2'b11 : begin indata_dec = {{24{drdata[31]}},drdata[31:24]};$display("LB 3"); end
										endcase
									end
						3'b001 :
									begin
										case((daddr%4))
											2'b00 :begin indata_dec = {{16{drdata[15]}},drdata[15:0]};$display("LH 0"); end
											2'b10 :begin indata_dec = {{16{drdata[31]}},drdata[31:16]};$display("LH 1, time = %d",$time); end
										endcase
									end
						3'b010 :indata_dec = drdata;
						3'b100 :
									begin
										case((daddr%4))
											2'b00 : begin indata_dec[7:0] = drdata[7:0];$display("LBU 0"); end
											2'b01 : begin indata_dec[7:0] = drdata[15:8];$display("LBU 1"); end
											2'b10 : begin indata_dec[7:0] = drdata[23:16];$display("LBU 2"); end
											2'b11 : begin indata_dec[7:0] = drdata[31:24];$display("LBU 3"); end
										endcase
									end
						3'b101 :
									begin
										case((daddr%4))
											2'b00 :begin indata_dec[15:0] = drdata[15:0];$display("LHU 0"); end
											2'b10 :begin indata_dec[15:0] = drdata[31:16];$display("LHU 1 time = %d",$time); end
										endcase
									end
					endcase
					end
		  if(opcode == 5'b01000) //store
					begin
					$display("store /n");
				   daddr = rv1 + imm;
					case(funct3)
					3'b000 : 
						begin	
						 dwdata = {4{rv2[7:0]}};
						 case(daddr%4) 
							2'b00 : we_dmem = 4'b0001;
							2'b01 : we_dmem = 4'b0010;
							2'b10 : we_dmem = 4'b0100;
							2'b11 : we_dmem = 4'b1000;
						 endcase
						end
					3'b001 :
						begin	
						 dwdata = {2{rv2[15:0]}};
						 case(daddr%4) 
							2'b00 : we_dmem = 4'b0011;
							2'b10 : we_dmem = 4'b1100;
							default : we_dmem = 4'b0000; 
						 endcase
						end
					3'b010 :
					   begin	
						 dwdata = rv2[31:0];
						 we_dmem = 4'b1111;
						end
					endcase
					end
//				   dwdata = rs2[8*(1<<funct3)-1:0]; //here funct3 is 0,2,4 for B,H,W so 8*2^0,8*2^1...
				 //also it will not matter what the remaining bits value will be given in dwdata 
//				   we = { {(4-(1<<funct3)){1'b0}} ,1<<funct3};
		  if(opcode == 5'b00100) //ALU operation with imm
		  begin
					op = {instr[30],instr[14:12],instr[6:5]};
				   ALU_input_select = 1;
					indata_sel = 0;
		  end
		  if(opcode == 5'b01100) //ALU operation on reg
		  begin
		         op = {instr[30],instr[14:12],instr[6:5]};
				   ALU_input_select = 0;
					indata_sel = 0;
		  end
	  end
endmodule 