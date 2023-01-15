///////////////////////////////////////////////////////////////////////////////
//
// Copyright Freddi, UESTC 
//
///////////////////////////////////////////////////////////////////////////////
`timescale 1ns / 1ps
//-----------------------------------------------------------------------------
//
// Project    : Xcore Branch Prediction Unit-global history register
// File       : Xcore_if_ghr.v
// Module     : Xcore_if_ghr.v(BPU)
// Author     : Yufei Fu(fuyufei083X@gmail.com)
// Date       : 2022-11-18
// Version    : v1.0
// Description: G-share branch predictor.
//				this is the bim with 1024 2bit counter in it to predict
//				whether a branch jump or not
//
// ----------------------------------------------------------------------------

`include "./rtl/include/params.v"
module Xcore_if_bim(
	input					i_sys_clk,
	input					i_sys_rst,
	//front end check
	input	[9:0]			i_bpu_addr, //new branch index to get prediction
	//back end update
	input					i_cmt_ghr,  // whether the branch is ture or false
	input					i_cmt_req,	// whether there is a branch information back from wb
	input	[9:0]			i_cmt_addr, // the update address
	input                   i_cmt_bits, // whether the branch is taken or not
	//output 
	output  [1:0]			o_bim_bits
);
wire i_cmt_mis = i_cmt_ghr&i_cmt_req;
wire i_cmt_true =(!i_cmt_ghr)&i_cmt_req;
wire bim_ram_en = i_cmt_mis|i_cmt_true;
wire [1:0]	cmt_bits = i_cmt_bits;
wire [9:0]	cmt_addr = i_cmt_addr;

bim_ram_1024 inst_bim_ram_1024
    (
        .a        (cmt_addr),
        .d        (cmt_bits),
        .dpra     (i_bpu_addr),
        .clk      (i_sys_clk),
        .qdpo_clk (i_sys_clk),
        .rst	   (i_sys_rst),
        .we       (bim_ram_en),
        .bim_bits     (o_bim_bits)
    );

endmodule

