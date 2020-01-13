`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    00:32:15 11/10/2019 
// Design Name: 
// Module Name:    peripheral 
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
module peripheral(
		clk, reset, ce, we, addr , wdata,
		rdata
	);
		input clk, reset;
		input ce;
		input [3:0]we;
		input [31:0] addr;  // only 2-bit address needed to decode 4 registers
		input [31:0] wdata;
		output reg [31:0] rdata;
		reg [31:0] ACCUM,rdata1;
		reg [31:0] COUNT;
		/*
		always@(*)
			begin
				case((addr>>2)%4)
						2'b10 : //BASE + 8
								begin
									if(ce)
										begin rdata = ACCUM ; end
								end
						2'b11 : //BASE + 12
								begin
									if(ce)
										begin rdata = COUNT ; end
								end
						default:
								rdata = 32'haa;
				endcase
			end
		always@(posedge clk)
			begin
				if(reset)
					begin
						ACCUM = 32'h0;
						COUNT = 32'h0;
					end
				case ((addr>>2)%4) 
					2'b00 ://BASE + 0
							begin
								if(ce)
									begin
										ACCUM = 32'h0;
										COUNT = 32'h0;
										rdata = 32'h0;
									end
							end
					2'b01 ://BASE + 4
							begin
								if(ce&(&we))
									begin 
										ACCUM = ACCUM + wdata;
										COUNT = COUNT + 1;
										rdata = ACCUM;
									end
							end
					default:
								begin
									ACCUM = ACCUM;
									COUNT = COUNT;
								end
				endcase
			end
			*/
		wire [1:0] innt;
		assign innt =(addr>>2)%4;
		always@(*)
			begin
				case(innt)
						2'b10 : //BASE + 8
								begin
									if(ce)
										begin rdata <= ACCUM ; end
								end
						2'b11 : //BASE + 12
								begin
									if(ce)
										begin rdata <= COUNT ; end
								end
						2'b00 :if(ce) rdata<=rdata1; 
						2'b01 :if(ce) rdata<=rdata1;
						default:
								rdata <= 32'haa;
				endcase
			end
		always@(posedge clk)
			begin
			if (~innt[1] & ce | reset) ACCUM <= (innt[0] & ~reset)? ((&we)? ACCUM + wdata :ACCUM):32'h0;
			if (~innt[1] & ce | reset) COUNT <= (innt[0] & ~reset)? ((&we)? COUNT + 1 :COUNT):32'h0;
			if (~innt[1] & ce | reset) rdata1 <= (innt[0] & ~reset)? ((&we)? ACCUM :rdata1):32'h0;
			end
endmodule 