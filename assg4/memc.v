`timescale 1ns / 1ps
module memc(
memdata,
addr,
type,
ioout,
memin
    );
input [31:0] memdata;
input [1:0] addr;
input [3:0] type;
//wire [3:0] io;
//wire [31:0] data;
output [3:0] ioout;
output [31:0] memin;
assign ioout = (type !=0)? (type<<addr):type;//error I may face is half word write with addr ending 11
assign memin = (type!=0)? (memdata<<{{addr},3'b000}):memdata;
//assign ioout = {io[0],io[1],io[2],io[3]};
//assign memin = {data[7:0],data[15:8],data[23:16],data[31:24]};
endmodule
