`timescale 1ns / 1ps

module imem(
    iaddr,
	 idata
);
    input [31:0] iaddr;
    output wire [31:0] idata;
	 reg [31:0] m_imem[0:31];
    initial $readmemh("imem_peri2_in.mem",m_imem);
	 
    assign idata = m_imem[iaddr[31:2]];
endmodule 