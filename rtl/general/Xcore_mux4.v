//copyright 2022-2023 Yufei FU(Freedi),UESTC
//
//github"git@github.com:yuu-fei/freddi-Xcore.git"
////////////////////////////////////////////////////////////////////
`timescale 1ns/1ps
//------------------------------------------------------------------
//
//project : Freedi_Xcore CPU
//module : Xcore_mux4.v
//
//author : Yufei Fu
//data : 2022/9/26
//version : 1.0
//
//description: this is the general 4 signal mux  used in the CPU
//------------------------------------------------------------------

module Xcore_mux4(
//4 input 1 bit signals
	input signal0,
	input signal1,
	input signal2,
	input signal3,
//two control signals L/R & scl
	input scl,
	input dir_en,

//output 
	output mux_out
);

assign mux_out = ({scl, dir_en}==2'b11) ? signal3 : 
	({scl, dir_en}==2'b01) ? signal1 : (signal2&signal0);

endmodule
