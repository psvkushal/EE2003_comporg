In this assignment multi cycle processor based on RISCV processor is built which can handle forwarding, branch prediction and stalling
Improvments to be done :
  In the code the mux8 which is used is created from mux2 which is 2x1 which when synthesized in Xilinx FPGA wastes spac 
  because the implemenatation is done as LUT's and they are 4x2 so instead if 2x1 mux it will be desirable to use a 4x2 mux as 
  building block
