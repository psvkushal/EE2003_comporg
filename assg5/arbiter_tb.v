`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   12:13:58 11/10/2019
// Design Name:   arbiter
// Module Name:   /home/kushal/comporg/cpu_perpheral/arbiter_tb.v
// Project Name:  cpu_perpheral
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: arbiter
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module arbiter_tb;

	reg [31:0] wdata_cpu;
	reg [31:0] rdata_per0;
	reg [3:0] we_cpu;
	reg [31:0] addr_cpu;
	reg clk, reset;
	
	wire [31:0] addr_per;
	wire [31:0] rdata_cpu,rdata_per1,rdata_per;
	wire [3:0] we_per;
	wire [1:0] ce;
	wire [31:0] wdata_per;
	// Instantiate the Unit Under Test (UUT)
	arbiter uut1 (
		.addr_per(addr_per), 
		.addr_cpu(addr_cpu),
		.wdata_cpu(wdata_cpu),
		.wdata_per(wdata_per),
		.rdata_cpu(rdata_cpu), 
		.rdata_per(rdata_per), 
		.we_cpu(we_cpu), 
		.we_per(we_per), 
		.ce(ce)
	);
	peripheral uut2 (
		.clk(clk),
		.reset(reset),
		.ce(ce[1]),
		.we(we_per),
		.addr(addr_per),
		.wdata(wdata_per),
		.rdata(rdata_per1)
	);
	rdata_sel uut3 (
		.rdata_sel(ce),
		.rdata_per0(rdata_per0),
		.rdata_per1(rdata_per1),
		.rdata(rdata_per)
	);
	parameter BASE = 32'h0000080;
	always #5 clk = !clk;
	initial begin
		// Initialize Inputs
		wdata_cpu = 0;
		we_cpu = 0;
		reset = 1; 
		clk = 1;
		rdata_per0 = 32'h0;
		// Wait 100 ns for global reset to finish
		#8;
			reset = 0;
			wdata_cpu = 32'h1;
			we_cpu = 4'b1111;
			addr_cpu = BASE + 4;
		#10
			wdata_cpu = 32'h2;
			we_cpu = 4'b1111;
			addr_cpu = BASE + 4;
		#10
			wdata_cpu = 32'h3;
			we_cpu = 4'b1111;
			addr_cpu = BASE + 4;
		#10
			wdata_cpu = 32'h9;
			we_cpu = 4'b1111;
			addr_cpu = BASE + 8;
		#10
			wdata_cpu = 32'h0;
			we_cpu = 4'b1111;
			addr_cpu = BASE + 12;
		#10
			wdata_cpu = 32'h0;
			we_cpu = 4'b1111;
			addr_cpu = BASE + 0;
		#10
			wdata_cpu = 32'h0;
			we_cpu = 4'b1111;
			addr_cpu = BASE + 8;
		#10
			wdata_cpu = 32'h0;
			we_cpu = 4'b1111;
			addr_cpu = BASE + 12;
		// Add stimulus here
	end
      
endmodule

