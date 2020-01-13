`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   15:13:06 08/28/2019
// Design Name:   regfile
// Module Name:   /home/kushal/comporg/assg2/mem_tb.v
// Project Name:  assg2
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: regfile
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////
/*
there will be some difference in instantiating in reading of RF and imem as in RF data is being
read asynchronously and incase of imem data is being read synchronously so there will be 
difference in which index data that has to be compared to.
*/
`include "parameters.v"
module mem_tb();
	integer total, error, i;
	//total keeps track of the number of cases have been done
	//error keeps track of the errors in the simulation
	
	// reg file signals
	reg [`reg_w-1:0] rs1, rs2, rd;
	reg we, clk;
	reg [`R_no-2:0] RF_mem [`mem_w-1:0];  
	reg [`mem_w-1:0] out_rf,indata;
	wire [`mem_w-1:0] rv1, rv2;
	
	
	// instantiating regfile
	regfile uut (
		.rs1(rs1), .rs2(rs2), .rd(rd), .we(we), .clk(clk), .indata(indata), 
		.rv1(rv1), .rv2(rv2)
	);
	
	always begin
	#5 clk = ~clk; //creating a 10ns clk this line will generate it
	end
	
	// task for checking Register file
	task check_RF(); //REG file
	input	integer i;  //you will have to specify the data type
		begin
			rs1 <= i;
			rs2 <= i;
			rd <= i+1;
			we = 1;
			indata <= RF_mem[i+1];
			if(i)
		begin out_rf <= RF_mem[i]; end
		else begin out_rf <= RF_mem[0]; end
			@(posedge clk);
			if((rv1 == out_rf)&(rv2 == out_rf))
			begin
				$display($time,"passed inaddr = %d read and write functional",rs1);
			end else begin
				error = error + 1;
				$display($time,"failed inaddr = %d read and write functional",rs1);
			end
			total = total + 1;
			end
		endtask
		
	
	initial begin
		//intialising the values
		clk = 1;
		total = 0;
		error = 0;
		i = 0;
		rs1 = 5'b00000;
		rs2 = 5'b00000;
		rd = 5'b00001; 
		$readmemh("RF_data.txt",RF_mem);
		@(posedge clk)
		for(i = 0;i < `R_no;i = i+1)
		begin 
		check_RF(i); 
		end
		if (error > 0) begin
			$display("Fail no of error = %d, no of cases = %d",error,total);
		end else begin
			$display("Pass no of error = %d, no of cases = %d",error,total);
		end
	end    
endmodule 