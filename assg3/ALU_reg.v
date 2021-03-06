`timescale 1ns / 1ps
`include "parameters.v"
module ALU32 (
    in1, in2_1,in2_2, op, out,ALU_input_select
);
    input [`data_width-1:0] in1, in2_1,in2_2;
    input [`OPWIDTH-1:0] op;
    output reg [`data_width-1:0] out;
	 reg [`reg_width-1:0] in2;
	 input ALU_input_select;
    always @(in1 or in2 or op) begin
		  case (ALU_input_select)
			1'b0 : assign in2 = in2_1; 
			1'b1 : assign in2 = in2_2;
		endcase
        casez (op)
		  6'b?00000:
						begin
						out = in1 + in2;   //ADDI
						end
		  6'b?01000: if($signed(in1) < $signed(in2)) begin out = 1; end
					else begin out = 0; end // SLTI
		  6'b?01100:if(in1 < in2) begin out = 1; end		
					else begin out = 0; end // SLTIU
		  6'b?10000: out = in1 ^ in2; //XORI
		  6'b?11000: out = in1 | in2; //ORI
		  6'b?11100: out = in1 & in2; //ANDI
		  6'b000100: out = in1 << in2[4:0]; //SLLI
		  6'b010100: out = in1 >> in2[4:0]; //SRLI
		  6'b110100: out = $signed(in1) >>> in2[4:0]; //SRAI
		  6'b000001: out = in1 + in2; //ADD
		  6'b100001: out = in1 - in2; //SUB
		  6'b000101: out = in1 << in2[4:0]; //SLL
		  6'b010101: out = in1 >> in2[4:0]; //SRL
		  6'b110101: out = $signed(in1) >>> in2[4:0]; //SRA
		  6'b001001: if($signed(in1) < $signed(in2)) begin out = 1; end
						else begin out = 0;  end //SLT
		  6'b001101:if(in1 < in2) begin out = 1; end
						else begin out = 0; end //SLTU
		  6'b010001: out = in1 ^ in2; //XOR
		  6'b011001: out = in1 | in2; //OR
		  6'b011101: out = in1 & in2; //AND
		  endcase
		 end
    
endmodule 