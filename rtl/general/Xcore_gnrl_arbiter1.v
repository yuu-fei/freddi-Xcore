//copyright 2022-2023 Yufei FU(Freedi),UESTC
//
//github"git@github.com:yuu-fei/freddi-Xcore.git"
////////////////////////////////////////////////////////////////////
`timescale 1ns/1ps
//------------------------------------------------------------------
//
//project : Freedi_Xcore CPU
//module : Xcore_gnrl_arbiter1.v
//
//author : Yufei Fu
//data : 2022/9/20
//version : 1.0
//
//description: this is the general MUX used in the CPU,which can be used to
//judge N-1	data signals
//------------------------------------------------------------------

module Xcore_gnrl_arbiter1 #(
 parameter SIGNUM = 4,
 parameter SCLNUM = 4
)(
 input wire [SIGNUM-1:0] signal,
 input [SCLNUM-1:0] scl,
 output dout
);
 wire [SIGNUM-1:0] data_inprocess; 
 genvar i;
 generate 
	 for(i=0;i<SIGNUM;i=i+1) begin
	 assign data_inprocess[i] = scl[i]&signal[i]; 
	 end
 endgenerate
assign dout = |data_inprocess;

endmodule

