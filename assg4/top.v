`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    11:56:36 09/17/2019 
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
    input clk
    ); //Only input from the outside is clock
	 
	 //wire reset,rdy;
	 wire [35:0] VIO_CONTROL;/*ILA_CONTROL*/
	 //Control wires used by ICON to control VIO and ILA
	 

    wire clkm, reset;
    wire [31:0] iaddr, idata;
    wire [31:0] daddr, drdata, dwdata;
    wire [3:0] we;
    wire [31:0] x31, pc;
CPU_pipe instanceA (
        .clk(clkm),
        .rst(reset),
        .iaddr(iaddr),
        .idata(idata),
        .daddr(daddr),
        .drdata(drdata),
        .dwdata(dwdata),
        .we(we),
        .x31(x31),
        .pc(pc)
    );	 
dmem instanceB(
		.clk(clkm),
		.daddr(daddr),
		.dwdata(dwdata),
		.drdata(drdata),
		.we(we)
		);
	 
imem instanceC(
		.iaddr(iaddr), 
		.idata(idata)
	);
//Calls for ICON, VIO and ILA blocks
icon0 instanceD (
	 .CONTROL0(VIO_CONTROL) 
);

vio0 instanceE (
    .CONTROL(VIO_CONTROL), // INOUT BUS [35:0]
    .CLK(clk), // IN
	 .ASYNC_OUT({clkm,reset}),// IN BUS [1:0]
    .SYNC_IN({iaddr,idata,daddr,drdata,dwdata,we,x31,pc}) // IN BUS [227:0]
);
/*
ila ila_inst (
			.CONTROL(ILA_CONTROL), // INOUT BUS [35:0]
			.CLK(clk), // IN
			.TRIG0(clk), //IN BUS [0:0]
			.TRIG1(reset), // IN BUS [0:0]
			.TRIG2(iaddr), // IN BUS [31:0]
			.TRIG3(idata), // IN BUS [31:0]
			.TRIG4(daddr), // IN BUS [31:0]
			.TRIG5(drdata), // IN BUS [31:0]
			.TRIG6(dwdata), // IN BUS [31:0]
			.TRIG7(we), // IN BUS [3:0]
			.TRIG8(x31), // IN BUS [31:0]
			.TRIG9(PC) // IN BUS [31:0]
		);

*/
endmodule

/*
UCF statement to be added in constraints file-
NET "clk" LOC = "C9"  | IOSTANDARD = LVCMOS33 ;
*/
