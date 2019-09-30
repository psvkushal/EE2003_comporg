`include "parameters.v"

module DummyDecoder (
    instr,
    op
);
    input [`width-1:0] instr;
    output reg [`OPWIDTH-1:0] op;

    always @(instr) begin
        // Use a case statement or some other logic to generate suitable op code
        op = {instr[30],instr[14:12],instr[6:5]}; // - replace this with some proper logic
    end

endmodule
