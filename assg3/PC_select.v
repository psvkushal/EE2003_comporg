`timescale 1ns / 1ps

module PC_decide(
		PC_select, PC, PC_branch,PC_new
    );
	 input PC_select;
	 input [31:0] PC,PC_branch;
	 output reg [31:0] PC_new;
	always@(*)
	begin
		case (PC_select)
			1'b0 :PC_new = PC + 4;
			1'b1 : PC_new = PC_branch;
		endcase
 	end

endmodule
