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
//				this is a 2 bit history register so actually it is a register 
//				it is updated front and back : 
//				front is from bpu about its prediction answer
//				back is from the wb stage to get the last branch jump answer
//				if it is wrong update all the history or just update the last
//				bit
//				states: 1 is jumped and 0 is not jumped
// ----------------------------------------------------------------------------

`include"./rtl/include/params.v"
module Xcore_if_ghr(
	input				i_sys_clk,
	input				i_sys_rst,
	//front end update
	input				i_bpu_taken,
	input				i_bpu_req,
	//back end update
	input				i_cmt_ghr, //get the answer whether the last branch is predicted correctly 0 or not 1;
	input				i_cmt_req, // whether this is a branch feedback
	input				i_cmt_target, //get whether the last branch is jumped 1 or not 0
	input [`GHRLEN-1:0] i_cmt_ghr_val,
	//output
	output	[`GHRLEN-1:0]	 o_ghr_val
);
wire i_cmt_mis = i_cmt_ghr&i_cmt_req;
wire i_cmt_true =(!i_cmt_ghr)&i_cmt_req;
reg [`GHRLEN-1:0] ghr_r;

always@(posedge i_sys_clk or negedge i_sys_rst) begin
	if(!i_sys_rst) begin
		ghr_r <= 'd0;
	end
	else begin
		if(i_cmt_mis) 
			ghr_r <= i_cmt_ghr_val;
		else if(i_cmt_true&i_bpu_req)
			ghr_r <= {i_cmt_target,i_bpu_taken};
		else if(i_cmt_true&(!i_bpu_req))
			ghr_r <= {ghr_r[`GHRLEN-2:0],i_cmt_target};
		else if(i_bpu_req&(!i_cmt_true)&(!i_cmt_mis))
			ghr_r <= {ghr_r[`GHRLEN-2:0],i_bpu_taken};
		else begin
			ghr_r <= ghr_r;
		end
	end
end

assign o_ghr_val = ghr_r;
endmodule

