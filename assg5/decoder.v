`timescale 1ns / 1ps
`include "parameters.v"

module decoder(
	 //input
	 instr, rv1, rv2,PC,
    //output
	 op, rs1, rs2, rd, ALU_input_select, daddr,dmem_sig,
	 PC_select, PC_branch, we, indata_dec, indata_sel,ALU_input,branch,funct3, load_store_sel
);
    input [`Instr_width-1:0] instr;
	 input [`data_width-1:0] PC;
	 input [`reg_width-1:0]rv1, rv2;
	 input [`data_width-1:0]daddr;
    output reg [`OPWIDTH-1:0] op;
	 output reg ALU_input_select;
	 output reg [`reg_addr-1:0] rs1,rs2,rd; //reg file address
 	 output reg [`data_width-1:0] indata_dec,ALU_input;
	 //imm is the immediate value, indata is the input write data to RF
	 //daddr, dwdata, drdata are described top_cpu module 
    output reg PC_select, we;
	 output reg [`PC_width-1:0] PC_branch;
	 output reg [1:0]indata_sel; 
	 output reg load_store_sel;
	 output reg [2:0] funct3;
	 reg [31:0] imm;
	 output reg branch, dmem_sig; 
	 reg [4:0] opcode;
	 always@(*)
	  begin
		  opcode = instr[6:2];
		  funct3 = instr[14:12];
		  rs1    = instr[19:15];
		  rs2    = instr[24:20];
		  rd    = instr[11:7];
		  PC_select = 0; 
		  we = 0;
		  indata_dec = 32'h00000000;
		  PC_select = 0; 
		  branch = 0;
		  ALU_input_select = 0;
		  PC_branch = 32'h00000000;
		  op = 6'b000000;
		  indata_sel = 2'b00;
		  ALU_input = 32'h00000000;
		  load_store_sel = 1;
		  dmem_sig = 0;
		  case (opcode)
				/*LUI*/    5'b01101 : imm = {instr[31:12],{12{1'b0}}};
				/*AUIPC*/  5'b00101 : imm = {instr[31:12],{12{1'b0}}};
				/*JAL*/    5'b11011 : imm = {{20{instr[31]}},instr[31],instr[19:12],instr[20],instr[30:21],{1'b0}};
				/*JALR*/   5'b11001 : imm = {{20{instr[31]}},instr[31:20]};
				/*branch*/ 5'b11000 : imm = {{19{instr[31]}},instr[31],instr[7],instr[30:25],instr[11:8],{1'b0}}; //why did they keep this complicated?
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
				 indata_sel = 2'b10;
				 end
		  if(opcode == 5'b00101) //AUIPC
			    begin  
				 indata_dec = PC + imm;
				 indata_sel = 2'b10;
				 end
		  if(opcode == 5'b11011) //JAL
				 begin
					indata_sel = 2'b10;
				   PC_branch = (PC + imm);
				   PC_select = 1;
					indata_dec = PC + 4;
				 end
		  if(opcode == 5'b11001) //JALR
				 begin
					indata_sel = 2'b10;
				   PC_branch = rv1 + imm;
					PC_branch[0] = 1'b0;
				   indata_dec= PC + 4; //what is expected to be present stored
				   PC_select = 1;
				 end
		  if(opcode == 5'b11000) //branch
			begin
				 PC_branch = PC + imm;
				 if ((funct3 == 3'b000)|(funct3== 3'b001)) //BEQ and BNE respectively
				 begin
					op = 6'b100001;
					branch = 1;
				 end					
				 if ((funct3== 3'b100)|(funct3== 3'b101)) //BLT and BGE respectively
				 begin
					op = 6'b?01000;
					branch = 1;
             end
				 if ((funct3== 3'b110)|(funct3== 3'b111)) //BLTU or BGEU respectively
				 begin
					op = 6'b?01100;
					branch = 1;
  				 end
			end
		  if(opcode == 5'b00000) //load
				begin
					$display("load, time = %d",$time);
				   indata_sel = 2'b01; //whether to choose indata from alu or decoder
					ALU_input_select = 1;
					ALU_input = imm;
					op =  6'b000001;
					load_store_sel = 0;
					dmem_sig = 1;
				end
		  if(opcode == 5'b01000) //store
				begin
					$display("store, time = %d",$time);
					ALU_input_select = 1;
					ALU_input = imm;
					op =  6'b000001;
					load_store_sel = 1;
					dmem_sig = 1;
				end
		  if(opcode == 5'b00100) //ALU operation with imm
				begin
					$display("alui, time = %d",$time);
					op = {instr[30],instr[14:12],instr[6:5]};
				   ALU_input_select = 1;
					indata_sel = 2'b00;
					ALU_input = imm;
				end
		  if(opcode == 5'b01100) //ALU operation on reg
		  begin
					$display("alu, time = %d",$time);
		         op = {instr[30],instr[14:12],instr[6:5]};
				   ALU_input_select = 0;
					indata_sel = 2'b00;
		  end
	  end
endmodule 