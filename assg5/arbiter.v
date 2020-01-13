`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    23:15:24 11/09/2019 
// Design Name: 
// Module Name:    arbiter 
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
module arbiter(
		addr_per, addr_cpu,  wdata_per, wdata_cpu, rdata_cpu, rdata_per, we_cpu, we_per, ce
    );
	 //addr - addr into which data is being written or taken out
	 //wdata - data to be written
	 //rdata - data that is read
	 //we - write enable signal
	 //ce[0] - for dmem , ce[1]- for peripheral
	 input [31:0]addr_cpu;
	 input [31:0]wdata_cpu;
	 input [3:0]we_cpu;
	 input [31:0] rdata_per;
	 output reg [31:0]addr_per;
	 output reg[31:0]wdata_per;
	 output reg[3:0]we_per;
	 output reg[31:0]rdata_cpu;
	 output reg[1:0]ce; 
	 always@(addr_cpu or wdata_cpu or we_cpu or rdata_per)
			begin
				addr_per = addr_cpu;
				wdata_per= wdata_cpu;
				we_per = we_cpu;
				rdata_cpu = rdata_per;
				ce[0] = ~|((addr_cpu & (32'hffffff80))^(32'h00000000)); //ce for dmem
				ce[1] = ~|((addr_cpu & (32'hfffffff0))^(32'h00000200)); //ce for peripheal
			end
endmodule
