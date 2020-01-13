`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   04:11:01 09/10/2019
// Design Name:   dmem
// Module Name:   /home/kushal/comporg/assg2/dmem_tb.v
// Project Name:  assg2
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: dmem
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////
`include "parameters.v"

module dmem_tb;

	reg clk;
	reg [`dmem_width-1:0] mem [`dmem_depth-1:0];
	reg [`dmem_width-1:0] daddr;
	reg [3:0] we;
	reg [`dmem_width-1:0] indata_d, outdata;

	// Outputs
	reg [`dmem_width-1:0] outdmem;
	
	always 
	begin #5 clk = ~ clk; end
	integer total,error;
	
	// Instantiate the Unit Under Test (UUT)
	dmem uut (
		.daddr(daddr), 
		.clk(clk), 
		.we(we), 
		.indata(indata_d), 
		.outdata(outdata)
	);
//task for checking dmem
	task check_write_dmem();
		input integer i;
		begin
			indata_d = mem[i];
			$display($time,"i = %d,indata_d = %d",i,indata_d);
			daddr <= i;
			we <= 4'hf;
			@(posedge clk)
			begin end
		end
	endtask
	
	task check_read_dmem();
		input integer i;
		begin
			we = 4'h0;
			daddr <= i;
			outdmem = mem[i];
			@(posedge clk)
				if(outdmem == outdata)
					begin
						$display($time,"passed inaddr = %d read for dmem, i = %d, outdata = %d",daddr,i,outdata);
					end else begin
						error = error + 1;
						$display($time,"failed inaddr = %d read for dmem i = %d,outdata = %d ",daddr,i,outdata);
						end
					total = total + 1;	
		end
	endtask

	initial begin
		// Initialize Inputs
		daddr = 0;
		clk = 1;
		total = 0;
		error = 0;
		$readmemh("dmem_data.txt",mem);
		check_write_dmem(100);
		check_write_dmem(120);
		check_write_dmem(140);
		check_read_dmem(100);
		check_read_dmem(120);
		check_read_dmem(140);
	if (error > 0) begin
			$display("Fail no of error = %d, no of cases = %d",error,total);
		end else begin
			$display("Pass no of error = %d, no of cases = %d",error,total);
		end
	end
endmodule

