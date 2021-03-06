`timescale 1ns / 1ps

module cpu_pipe_tb();
    reg clk, reset;
    wire [31:0] iaddr, idata;
    wire [31:0] daddr, drdata, dwdata;
    wire [3:0] we;
    wire [31:0] x31, pc,errorbits,wrongaddr;
	 wire [29:0] count;
	assign count= iaddr[31:2]+1;
    CPU_pipe dut (
        .clk(clk),
        .rst(reset),
        .iaddr(iaddr),
        .idata(idata),
        .daddr(daddr),
        .drdata(drdata),
        .dwdata(dwdata),
        .we(we),
        .x31(x31),
        .pc(pc),
		  .errorbits(errorbits),
		  .wrongaddr(wrongaddr)
    );
	 
	 dmem dmem(
		.clk(clk),
		.daddr(daddr),
		.dwdata(dwdata),
		.drdata(drdata),
		.we(we)
		);
	 
	 imem imem(
		.iaddr(iaddr), 
		.idata(idata)
	);
	
    always #5 clk = ~clk;
    initial begin
	     reset = 1;
        clk = 0;
        #100
        reset = 0;
		 #10020
		 reset=1;
    end
endmodule
