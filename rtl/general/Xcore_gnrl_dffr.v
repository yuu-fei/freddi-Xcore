//copyright 2022-2023 Yufei FU(Freedi),UESTC
//
//github"git@github.com:yuu-fei/freddi-Xcore.git"
////////////////////////////////////////////////////////////////////
`timescale 1ns/1ps
//------------------------------------------------------------------
//
//project : Freedi_Xcore CPU
//module : Xcore_gnrl_dffr.v
//
//author : Yufei Fu
//data : 2022/9/20
//version : 1.0
//
//description: this is the general dffr used in the CPU
//------------------------------------------------------------------

module Xcore_gnrl_dffr #(
 parameter DW = 8
)(
input clk,
input reset,
input [DW-1:0] dtin,
output [DW-1:0] dffo
);

reg [DW-1:0] dffo_reg = {DW{1'b0}};
always@(posedge clk or negedge reset) begin
 if(!reset==1'b1)
	 dffo_reg <= {DW {1'b0}};
 else
	 dffo_reg <= #1 dtin;
end

assign dffo = dffo_reg;

endmodule
