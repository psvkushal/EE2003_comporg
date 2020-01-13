`timescale 1ns / 1ps

module dmem(
    clk, daddr, dwdata, we,
    drdata, ce
);
    input wire clk, ce;
    input wire [31:0] daddr;
    input wire [31:0] dwdata;
    input wire [3:0] we;
    output wire [31:0] drdata;
	 reg [7:0] m[0:127];
    initial $readmemh("dmem_ini.mem",m);

    wire [31:0] add0,add1,add2,add3;
	 
	 assign add0 = (daddr & 32'hfffffffc) + 32'h00000000;
	 assign add1 = (daddr & 32'hfffffffc) + 32'h00000001;
	 assign add2 = (daddr & 32'hfffffffc) + 32'h00000002;
	 assign add3 = (daddr & 32'hfffffffc) + 32'h00000003;
	 
	 assign drdata = {m[add3],m[add2],m[add1],m[add0]};
	 
    always @(posedge clk) begin
        if (we[0]&ce)
            m[add0]= dwdata[7:0];
        if (we[1]&ce)
            m[add1]= dwdata[15:8];
        if (we[2]&ce)
            m[add2]= dwdata[23:16];
        if (we[3]&ce)
            m[add3]= dwdata[31:24];
    end
endmodule 