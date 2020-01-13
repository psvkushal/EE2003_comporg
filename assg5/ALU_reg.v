`timescale 1ns / 1ps
`include "parameters.v"
module ALU32 (
    in1, in2_1,in2_2, op, out,ALU_input_select,branch,funct3,PC_select
);
    input [`data_width-1:0] in1, in2_1,in2_2;
    input [`OPWIDTH-1:0] op;
	 input [2:0] funct3;
	 input branch;
    output reg [`data_width-1:0] out;
	 output reg PC_select;
	 reg [`reg_width-1:0] in2;
	 input ALU_input_select;
    always @(in1 or in2 or op or ALU_input_select or in2_1 or in2_2 or out or funct3 or branch) 
		begin
		  PC_select = 0;
		  case (ALU_input_select)
				1'b0 : in2 = in2_1; 
				1'b1 : in2 = in2_2;
				default : in2 = in2_2;
		  endcase
        casez (op)
		  6'b?00000: out = in1 + in2;   //ADDI
		  6'b?01000: begin
							if($signed(in1) < $signed(in2)) begin out = 32'b00000001; end
							else begin out = 32'b00000000; end // SLTI
							if(((out[0] == 1'b1) ^ (funct3[0])) & branch)
								begin PC_select = 1; end
						 end
		  6'b?01100: begin
							if(in1 < in2) begin out = 32'b00000001; end		
							else begin out = 32'b00000000; end // SLTIU
							if(((out[0] == 1'b1) ^ (funct3[0])) & branch)
								begin PC_select = 1; end
						 end
		  6'b?10000: out = in1 ^ in2; //XORI
		  6'b?11000: out = in1 | in2; //ORI
		  6'b?11100: out = in1 & in2; //ANDI
		  6'b000100: out = in1 << in2[4:0]; //SLLI
		  6'b010100: out = in1 >> in2[4:0]; //SRLI
		  6'b110100: out = $signed(in1) >>> in2[4:0]; //SRAI
		  6'b000001: out = in1 + in2; //ADD
		  6'b100001: begin 
							out = in1 - in2; //SUB
							if(((out == 32'b00000000)^(funct3[0]))&branch)//BEQ
								begin PC_select = 1; end
						 end
		  6'b000101: out = in1 << in2[4:0]; //SLL
		  6'b010101: out = in1 >> in2[4:0]; //SRL
		  6'b110101: out = $signed(in1) >>> in2[4:0]; //SRA
		  6'b001001: begin
							if($signed(in1) < $signed(in2)) begin out = 1; end
							else begin out = 0;  end //SLT
						 end
		  6'b001101: begin
							if(in1 < in2) begin out = 1; end
							else begin out = 0; end //SLTU
						 end
		  6'b010001: out = in1 ^ in2; //XOR
		  6'b011001: out = in1 | in2; //OR
		  6'b011101: out = in1 & in2; //AND
		  default out = 32'h00000000;
		  endcase
		 end
    
endmodule 