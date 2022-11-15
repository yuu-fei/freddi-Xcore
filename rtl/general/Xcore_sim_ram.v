///////////////////////////////////////////////////////////////////////////////
`timescale 1ns / 1ps
//-----------------------------------------------------------------------------
//
// Project    : Xcore  sim ram 
// File       : Xcore_sim_ram.v
// Module     : Xcore_sim_ram(ram simulation module)
// Author     : Yufei Fu(fuyufei083X@gmail.com)
// Date       : 2022-10-26
// Version    : v1.0
// Description: Verilog module Single port RAM with write-enable, chip sel,
//              no reset, with output register.
//              Such that read write data cost 1 clk.
//              origin from hbird e203 sirv_sim_ram.
//              
// ----------------------------------------------------------------------------

module Xcore_sim_ram
#(
	parameter DP = 1024,  // ram depth is 1024
	parameter FORCE_ZERO = 0, //generate to set the ram into 0
	parameter DW = 16,    // data width
	parameter MW = 2,	  // wen width	
	parameter AW = 10,	  // adress width
	parameter INIT_EN = 0,
	parameter INIT_SRC = "/home/final_project"  // file directory of which will be written into ram
)
(
	input           clk,
	input  [DW-1:0] din,
	input  [AW-1:0] addr,
	input		    cs,
	input		    wen,
	input  [MW-1:0] wem,
	
	output [DW-1:0] dout
);

//initiate ram 
reg [DW-1:0] ram_r [0:DP-1];

//readmem function 
if(INIT_EN==1)
	initial begin $readmemb(INIT_SRC, ram_r); 
end
reg  [AW-1:0] addr_r;
wire [MW-1:0] wen_r;
wire ren;

assign ren = cs & (~wen);
assign wen_r = ({MW{cs & wen}} & wem);

always@(posedge clk)
begin
	if(ren) begin
		addr_r <= addr;
	end
end
//write in different modes
genvar i;
generate
	for (i = 0; i < MW; i = i+1) begin :mem
        if((8*i+8) > DW ) begin: last
          always @(posedge clk) begin
            if (wen_r[i]) begin
               ram_r[addr][DW-1:8*i] <= din[DW-1:8*i];
            end
          end
        end
        else begin: non_last
          always @(posedge clk) begin
            if (wen_r[i]) begin
               ram_r[addr][8*i+7:8*i] <= din[8*i+7:8*i];
            end
          end
        end
      end
endgenerate
//read when ren is enabled
wire [DW-1:0] dout_pre;
  assign dout_pre = ram_r[addr_r];

  generate
   if(FORCE_ZERO == 1) begin: force_x_to_zero
      for (i = 0; i < DW; i = i+1) begin:force_x_gen
          `ifndef SYNTHESIS//{
         assign dout[i] = (dout_pre[i] === 1'bx) ? 1'b0 : dout_pre[i];
          `else//}{
         assign dout[i] = dout_pre[i];
          `endif//}
      end
   end
   else begin:no_force_x_to_zero
     assign dout = dout_pre;
   end
  endgenerate


endmodule
