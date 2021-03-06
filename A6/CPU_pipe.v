`timescale 1ns / 1ps

module CPU_pipe(
    clk,
	 rst,
    drdata,
    we,
    dwdata,
    daddr,
    idata,
    iaddr,
	 pc,
	 x31,
	 errorbits,
	 wrongaddr
    );
input clk;
input rst;
input [31:0] drdata;
input [31:0] idata;

wire erldst;
output [3:0] we;
output [31:0] dwdata;
output [31:0] daddr;
output [31:0] iaddr;
output [31:0] pc;
output [31:0] x31;
output [31:0] errorbits;
output [31:0] wrongaddr;


parameter s1 = 64;
parameter s2 = 165;
parameter s3 = 141;
parameter s4 = 108;

reg [s1-1:0] IF_ID;
reg [s2-1:0] ID_EX;
reg [s3-1:0] EX_MEM;
reg [s4-1:0] MEM_WB;
wire st0,st1,st2,loadc,memh1,memh2,exh1,exh2;
reg [31:0] erroraddr,saddr,scause;
wire [31:0] memin;
wire [3:0] iobytes;
wire [3:0] extra;
wire Z, N, V,errorins;
wire [31:0] rv1, rv2, regwrite;
wire [31:0] imm, pcimm, aluout,next_addr,finregw,frv1,frv2,error_next;
wire [3:0] alu_op; 
wire r, jal, ui, u_control, i, s, branch,jalr,pcsrc,dready;
wire mem_read, mem_read_sext,regwe;

assign we = ({4{EX_MEM[103]}} & extra);
assign daddr = EX_MEM[31:0];
assign pc=iaddr;

//forwarding 
assign exh1 = ((~EX_MEM[102]) & (EX_MEM[100] & ( ID_EX[63:59] == EX_MEM[108:104]) & (~( EX_MEM[108:104] == 0))));
assign exh2 = ((~EX_MEM[102]) & (EX_MEM[100] & ( ID_EX[68:64] == EX_MEM[108:104])  & (~( EX_MEM[108:104] == 0))));
assign memh1 = ~exh1 & ((MEM_WB[100] & (MEM_WB[107:103] == ID_EX[63:59])) & ~(MEM_WB[107:103] ==5'b00000));
assign memh2 = ~exh2 & ((MEM_WB[100] & (MEM_WB[107:103] == ID_EX[68:64])) & ~(MEM_WB[107:103] ==5'b00000));

Mux4 #(32) mux4a(.A(ID_EX[132:101]), .B(finregw), .C(EX_MEM[31:0]), .D(EX_MEM[31:0]), .sel({exh1,memh1}), .O(frv1));
Mux4 #(32) mux4b(.A(ID_EX[100:69]), .B(finregw), .C(EX_MEM[31:0]), .D(EX_MEM[31:0]), .sel({exh2,memh2}), .O(frv2));


//error detection
errordetect errordetect (.idata(idata), .error(errorbits[2:0]));
assign errorbits[3] = (EX_MEM[103] | EX_MEM[102]) & (erldst | (daddr > 32'h0000007c) );
assign errorbits[4] = (iaddr > 32'h 0000007c);


assign errorbits[31:5] = 0;
assign error_next = (errorins | errorbits[3])? erroraddr : next_addr;
assign wrongaddr = ({32{(errorins | errorbits[3])}} & ((errorins)? iaddr : EX_MEM[140:109]));
assign errorins = (errorbits[0] | errorbits[1] | errorbits[2] | errorbits[4]);
//Individual modules


ProgramCounter pc1(.clk(clk),.rst(rst), .addr(iaddr), .next_addr(error_next),.pcsrc(pcsrc | errorins | errorbits[3]),.st0(st0));

DataPath dp(.pc(ID_EX[164:133]), .memin(memin), .pcimm(pcimm), .rv1(frv1), .rv2(frv2), .regwrite(regwrite), .alu_op(ID_EX[50:47]), .imm(ID_EX[46:15]), .aluout(aluout), .r(ID_EX[14]), .jal(ID_EX[13]), .ui(ID_EX[12]), .u_control(ID_EX[11]), .i(ID_EX[10]), .s(ID_EX[9]), .branch(ID_EX[8]),.jalr(ID_EX[7]), .Z(Z), .N(N), .V(V));

Decoder dc(.word(IF_ID[31:0]), .alu_op(alu_op), .imm(imm), .r(r), .jal(jal), .ui(ui), .u_control(u_control), .i(i), .s(s), .branch(branch),.jalr(jalr), .mem_read(mem_read), .mem_read_sext(mem_read_sext),.regwe(regwe), .iobytes(iobytes));

RegisterFile file(.clk(clk), .rst(rst), .rs1(IF_ID[19:15]), .rs2(IF_ID[24:20]), .rd(MEM_WB[107:103]), .rv1(rv1), .rv2(rv2), .indata(finregw), .we(MEM_WB[100]),.x31(x31));

memc mem1(.memdata(EX_MEM[95:64]),.addr(EX_MEM[1:0]),.type(EX_MEM[99:96]),.ioout(extra),.memin(dwdata),.error(erldst));

branch branch1(.Z(Z),.N(N),.V(V),.branch(ID_EX[8]),.ui(ID_EX[12]),.u_control(ID_EX[11]),.jal(ID_EX[13]),.jalr(ID_EX[7]),.funct3(ID_EX[58:56]),.pcimm(pcimm),.aluout(aluout),.next_addr(next_addr),.pcsrc(pcsrc));

regc regc(.regwrite(MEM_WB[95:64]), .memout(MEM_WB[31:0]), .iobytes(MEM_WB[99:96]),.aluout(MEM_WB[33:32]), .mem_read(MEM_WB[102]), .mem_read_sext(MEM_WB[101]),.finregw(finregw));

//temp used the initially for other part
assign dready = 1'b0;

//assigning to registers
always @(posedge clk) begin
	if(st1) IF_ID<={iaddr,idata};
	if(st2) ID_EX<={IF_ID[63:32],rv1,rv2,IF_ID[24:7],alu_op,imm,r,jal,ui,u_control,i,s,branch,jalr,mem_read,mem_read_sext,regwe,iobytes};
	if (~errorbits[3] & ~dready) EX_MEM<={ID_EX[164:133],ID_EX[55:51],ID_EX[9],ID_EX[6:0],memin,regwrite,aluout};
	if (~errorbits[3] & ~dready) MEM_WB<={EX_MEM[108:104],EX_MEM[102:96],EX_MEM[63:0],drdata};
	if(pcsrc  | errorins | errorbits[3]) IF_ID<=64'h0000000000000fb3;
	if(pcsrc | ~loadc | errorbits[3]) ID_EX<=165'hf8000000004831;
	if(errorbits[3]) EX_MEM<=109'h1f31000000000000000000000000;
	if (errorbits[3]) MEM_WB<={wrongaddr};
	if (errorins | errorbits[3]) 
		begin
			saddr<=wrongaddr;
			scause<=errorbits;
		end
	if(rst)
		begin
			IF_ID<=0;
			ID_EX<=0;
			EX_MEM<=0;
			MEM_WB<=0;
			erroraddr<= 32'h00000074;//change later to values from dmem using load mechanism
			saddr<=0;
			scause<=0;
		end
	end
	
//signals used for stalling
assign loadc =	~(ID_EX[6] & ((IF_ID[19:15] == ID_EX[55:51]) | (IF_ID[24:20] == ID_EX[55:51])) & (ID_EX[55:51] !=5'b00000));
assign st0 =	 loadc | pcsrc & ~dready;
assign st1 =	 loadc & ~pcsrc & ~errorins & ~errorbits[3] & ~dready;
assign st2 =	 loadc & ~pcsrc & ~errorbits[3] & ~dready;


//initialization
initial begin
	IF_ID<=0;
	ID_EX<=0;
	EX_MEM<=0;
	MEM_WB<=0;
	erroraddr<= 32'h00000074;
	saddr<=0;
	scause<=0;
end

endmodule
