`include "parameters.v"
module cpu_tb();
    reg clk, reset;
    wire [`Instr_width-1:0] iaddr;
    wire [`data_width-1:0] idata;
    wire [`WE_width-1:0] we_dmem;
    wire [`data_width-1:0] x31, PC;
	 wire [31:0] wdata_cpu;
	 wire [31:0] rdata_per,rdata_per0,rdata_per1;
	 wire [31:0] addr_cpu;
	
	 wire [31:0] addr_per;
	 wire [31:0] rdata_cpu;
	 wire [3:0] we_per;
	 wire [1:0] ce;
	 wire [31:0] wdata_per;
    CPU dut1 (
        .clk(clk),
        .reset(reset),
        .iaddr(iaddr),
        .idata(idata),
        .daddr(addr_cpu),
        .drdata(rdata_cpu),
        .dwdata(wdata_cpu),
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
			.daddr(addr_per),
			.dwdata(wdata_per),
			.drdata(rdata_per0),
			.we(we_dmem),
			.ce(ce[0])
	 );
	 arbiter dut4(
			.addr_per(addr_per),
			.addr_cpu(addr_cpu),
			.wdata_per(wdata_per),
			.wdata_cpu(wdata_cpu),
			.rdata_cpu(rdata_cpu),
			.rdata_per(rdata_per),
			.we_cpu(we_dmem),
			.we_per(we_per),
			.ce(ce)
	 );
	 peripheral dut5 (
		.clk(clk),
		.reset(reset),
		.ce(ce[1]),
		.we(we_per),
		.addr(addr_per),
		.wdata(wdata_per),
		.rdata(rdata_per1)
	);
	rdata_sel dut6 (
		.rdata_sel(ce),
		.rdata_per0(rdata_per0),
		.rdata_per1(rdata_per1),
		.rdata(rdata_per)
	);
    always #5 clk = !clk;  //clk of time period of 10ns
    initial begin
        clk = 0;
        reset = 1;
        #100
        reset = 0;
    end

endmodule 