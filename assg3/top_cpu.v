`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    23:44:19 09/29/2019 
// Design Name: 
// Module Name:    top_cpu 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//This file is the top file for single clock processor
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
`include "parameters.v"
module CPU(
		
		//Inputs
		clk,reset,idata,drdata, 
		//Outputs
		iaddr,daddr,dwdata,we_dmem,x31, PC
		
		/*
		input clk,
		input reset,
		output reg [31:0] iaddr,  // address to instruction memory
		input [31:0] idata,   // data from instruction memory
		output reg [31:0] daddr,  // address to data memory
		input [31:0] drdata,  // data read from data memory
		output reg [31:0] dwdata, // data to be written to data memory
		output reg [3:0] we_dmem,      // write enable signal for each byte of 32-b word
		// Additional outputs for debugging
		output reg [31:0] x31,
		output reg [31:0] PC
		*/
	); 
	
		input clk;
		input reset;
		output wire [31:0] iaddr;  // address to instruction memory
		input [31:0] idata;   // data from instruction memory
		output wire [31:0] daddr;  // address to data memory
		input [31:0] drdata;  // data read from data memory
		output wire [31:0] dwdata; // data to be written to data memory
		output wire [3:0] we_dmem;      // write enable signal for each byte of 32-b word
		// Additional outputs for debugging
		output wire [31:0] x31;
		output reg [`PC_width-1:0] PC;
		
		/*
		input clk,reset;
		input [31:0] drdata,idata;
		output reg [3:0] we_dmem;
		output reg [31:0] dwdata, daddr, x31, PC, iaddr;
       */		
	 wire [`Instr_width-1:0] instr;
    wire [`OPWIDTH-1:0] op;
	 wire ALU_input_select;
	 wire [4:0] opcode; //this is that of instr
	 wire [`reg_addr-1:0] rs1,rs2,rd; //reg file address
	 wire [`data_width-1:0] rv1, rv2, indata,indata_dec, indata_alu, imm; 
	 wire [`data_width-1:0] PC_new,PC_branch;
	 wire PC_select;
	 wire we,indata_sel;
	 
	always@(posedge clk) begin
		PC = PC_new;
		if(reset)
		begin PC = 32'h00000000; end
		/*
		else
		begin PC <= PC_new; end
		*/
	end
	assign iaddr = PC;
	   decoder d_instance( 
		.instr(idata), .rv1(rv1), .rv2(rv2),.drdata(drdata),.PC(PC), //input
		.op(op), .rs1(rs1), .rs2(rs2), .rd(rd),.indata_dec(indata_dec),.indata_sel(indata_sel)
,	   .imm(imm), .ALU_input_select(ALU_input_select),.we_dmem(we_dmem),
		.dwdata(dwdata),.daddr(daddr),.PC_select(PC_select),.PC_branch(PC_branch),.we(we) //output
       );
	   regfile RF_instance (
				 .rs1(rs1), .rs2(rs2), .rd(rd), .we(we), .clk(clk),.indata(indata),//inputs
				 .rv1(rv1), .rv2(rv2), .x31(x31));//outputs
		ALU32 ALU_instance (
				 .in1(rv1), .in2_1(rv2), .in2_2(imm),.op(op),.ALU_input_select(ALU_input_select),//inputs   
				 .out(indata_alu)); //outputs 
		indata_choose indata_instance (
				 .indata_sel(indata_sel),.indata_alu(indata_alu),.indata_dec(indata_dec),
				 .indata(indata)
    );
		PC_decide PC_instance(
				 .PC_select(PC_select),.PC(PC),.PC_branch(PC_branch), //inputs 
				 .PC_new(PC_new)); //outputs 
		  //should ask if fence, ecall and ebreak should be implemented
endmodule 