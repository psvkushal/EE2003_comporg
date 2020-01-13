`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    14:23:58 10/24/2019 
// Design Name: 
// Module Name:    top 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module top(
			clk
    );
	 input wire clk;
	 wire clk_asyn, reset;
	 wire [31:0]  rdata_per, rdata_per0, rdata_per1,x31 ,PC, idata, iaddr;
	 wire [3:0] we_dmem;
	 wire [35:0] vio_ctrl, ila_ctrl;
	 wire [1:0]ce;
	 CPU cpu_inst(
		  .clk(clk_asyn),
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
	 imem imem_inst(
			.iaddr(iaddr),
			.idata(idata)
	 );
	
	 dmem dmem_inst(
			.clk(clk_asyn),
			.daddr(addr_per),
			.dwdata(wdata_per),
			.drdata(rdata_per0),
			.we(we_dmem)
	 );
	arbiter arbiter_inst(
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
	rdata_sel dut6 (
		.rdata_sel(ce),
		.rdata_per0(rdata_per0),
		.rdata_per1(rdata_per1),
		.rdata(rdata_per)
	);
	peripheral per_inst(
			.clk(clk_asyn),
			.reset(reset),
			.ce(ce[1]),
			.we(we_per),
			.addr(addr_per),
			.wdata(wdata_per),
			.rdata(rdata_per1)
	);
	 icon icon_inst (
			.CONTROL0(vio_ctrl), // INOUT BUS [35:0]
			.CONTROL1(ila_ctrl) // INOUT BUS [35:0]
		);
	 ila ila_inst (
			.CONTROL(ila_ctrl), // INOUT BUS [35:0]
			.CLK(clk), // IN
			.TRIG0(clk), //IN BUS [0:0]
			.TRIG1(reset), // IN BUS [0:0]
			.TRIG2(iaddr), // IN BUS [31:0]
			.TRIG3(idata), // IN BUS [31:0]
			.TRIG4(addr_cpu), // IN BUS [31:0]
			.TRIG5(rdata_cpu), // IN BUS [31:0]
			.TRIG6(wdata_cpu), // IN BUS [31:0]
			.TRIG7(we_dmem), // IN BUS [3:0]
			.TRIG8(x31), // IN BUS [31:0]
			.TRIG9(PC) // IN BUS [31:0]
		);
	vio vio_inst (
			.CONTROL(vio_ctrl), // INOUT BUS [35:0]
			.ASYNC_IN({x31,PC,idata}), // IN BUS [63:0]
			.ASYNC_OUT({clk_asyn,reset}) // OUT BUS [1:0]
		);
endmodule
