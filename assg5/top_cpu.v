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
	 wire [`reg_addr-1:0] rs1,rs2,rd; //reg file address
	 wire [`data_width-1:0] rv1, rv2, indata,indata_dmem,indata_dec, indata_alu, ALU_input; 
	 wire [`data_width-1:0] PC_new,PC_branch;
	 wire PC_select,PC_select_alu;
	 wire we;
	 wire [1:0] indata_sel;
	 wire [2:0] funct3;
	 wire [31:0]in_dmem;
	 reg IF_ID_reg; 
	 reg ID_EX_reg;
	 reg EX_MEM_reg;
	 reg MEM_WB_reg;
	always@(posedge clk) begin
		PC = PC_new;
		if(reset)
		begin 
		PC = 32'h00000000;
		end
		
	end
	assign iaddr = PC;
	assign daddr = indata_alu;
	   decoder d_instance( 
		.instr(idata), .rv1(rv1), .rv2(rv2),.PC(PC), //input
		.op(op), .rs1(rs1), .rs2(rs2), .rd(rd),.indata_sel(indata_sel),
	   .ALU_input_select(ALU_input_select),.PC_branch(PC_branch),.we(we),
		.daddr(daddr),.PC_select(PC_select),.ALU_input(ALU_input),.funct3(funct3),.dmem_sig(dmem_sig),
		.branch(branch),.load_store_sel(load_store_sel),.indata_dec(indata_dec)	//output
       );
	   regfile RF_instance (
				 .rs1(rs1), .rs2(rs2), .rd(rd), .we(we), .clk(clk),.indata(indata),//inputs
				 .rv1(rv1), .rv2(rv2), .x31(x31));//outputs
		ALU32 ALU_instance (
				 .in1(rv1), .in2_1(rv2), .in2_2(ALU_input),.op(op),
				 .ALU_input_select(ALU_input_select),.branch(branch),.funct3(funct3),//inputs
				 .out(indata_alu),.PC_select(PC_select_alu)); //outputs 
		indata_choose indata_instance (
				 .indata_sel(indata_sel),.indata_alu(indata_alu),
				 .indata_dmem(indata_dmem),.indata_dec(indata_dec),
				 .indata(indata));
		dmem_ctrl ctrl_instance (
				 .dmem_indata(rv2), .daddr(daddr), .funct3(funct3), .drdata(drdata),
				 .load_store_sel(load_store_sel), .dmem_sig(dmem_sig), //input
				 .reg_indata(indata_dmem), .we_dmem(we_dmem), .dwdata(dwdata) //ouput
				 );
		PC_decide PC_instance(
				 .PC_select(PC_select),.PC_select_alu(PC_select_alu),.PC(PC)
				 ,.PC_branch(PC_branch), //inputs 
				 .PC_new(PC_new)); //outputs 
		  //should ask if fence, ecall and ebreak should be implemented
endmodule 