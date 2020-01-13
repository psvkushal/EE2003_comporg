`include "parameters.v"
module cpu_tb();
    reg clk, reset;
    wire [`Instr_width-1:0] iaddr, daddr;
    wire [`data_width-1:0] idata , drdata, dwdata;
    wire [`WE_width-1:0] we_dmem;
    wire [`data_width-1:0] x31, PC;
    CPU dut1 (
        .clk(clk),
        .reset(reset),
        .iaddr(iaddr),
        .idata(idata),
        .daddr(daddr),
        .drdata(drdata),
        .dwdata(dwdata),
        .we_dmem(we_dmem),
        .x31(x31),
        .PC(PC)
    );

	 imem dut2(
			.iaddr(iaddr),
			.idata(idata)
	 );
	 
	 dmem dut3(
			.clk(clk),
			.daddr(daddr),
			.dwdata(dwdata),
			.drdata(drdata),
			.we(we_dmem)
	 );
    always #5 clk = !clk;  //clk of time period of 10ns
    initial begin
        clk = 0;
        reset = 1;
        #100
        reset = 0;
    end

endmodule

module imem(
    iaddr,
	 idata
);
    input [31:0] iaddr;
    output wire [31:0] idata;
	 reg [31:0] m_imem[0:31];
    initial $readmemh("imem5_ini.mem",m_imem);

    assign idata = m_imem[iaddr[31:2]];
endmodule

module dmem(
    clk, daddr, dwdata, we,
    drdata
);
    input wire clk;
    input wire [31:0] daddr;
    input wire [31:0] dwdata;
    input wire [3:0] we;
    output wire [31:0] drdata;
	 reg [7:0] m[0:127];
    initial $readmemh("dmem_ini.mem",m);

    wire [31:0] add0,add1,add2,add3;
	 
	 assign add0 = (daddr & 32'hfffffffc) + 32'h00000000;
	 assign add1 = (daddr & 32'hfffffffc) + 32'h00000001;
	 assign add2 = (daddr & 32'hfffffffc) + 32'h00000002;
	 assign add3 = (daddr & 32'hfffffffc) + 32'h00000003;
	 
	 assign drdata = {m[add3],m[add2],m[add1],m[add0]};
	 
    always @(posedge clk) begin
        if (we[0]==1)
            m[add0]= dwdata[7:0];
        if (we[1]==1)
            m[add1]= dwdata[15:8];
        if (we[2]==1)
            m[add2]= dwdata[23:16];
        if (we[3]==1)
            m[add3]= dwdata[31:24];
    end
endmodule 