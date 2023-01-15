///////////////////////////////////////////////////////////////////////////////
//
// Copyright Freddi, UESTC 
//
///////////////////////////////////////////////////////////////////////////////
`timescale 1ns / 1ps
//-----------------------------------------------------------------------------
//
// Project    : Xcore Branch Prediction Unit-Branch Target Buffer
// File       : Xcore_if_btb.v
// Module     : Xcore_if_btb.v(BPU)
// Author     : Yufei Fu(fuyufei083X@gmail.com)
// Date       : 2022-11-20
// Version    : v1.0
// Description: G-share branch predictor.
//				this is a look up table to reserve jump address and it is able
//				to search the target adress by index and tag as well as valid
//				signal
//				buffer sturcture : tag valid target type 16 1 16 3
//				128 entry number
// ----------------------------------------------------------------------------
`include "./rtl/include/params.v"

module Xcore_if_btb(
 input				i_sys_clk,
 input				i_sys_rst,
 //preif signal adress
 input [`WIDTH]		i_pref_pc,
 //front end update
 input [`WIDTH]		i_bpu_instr_pc,
 input				i_bpu_btb_update,
 input [2:0]		i_bpu_btb_type, // branch 100 jal 010 jalr 001
 input [`WIDTH]		i_bpu_btb_target,
 input				i_bpu_btb_valid,
 //back end update
 input [`WIDTH]		i_wb_instr_pc,
 input [2:0]		i_wb_cmt_type,
 input				i_wb_cmt_req,
 input [`WIDTH]		i_wb_cmt_target,

 //output
 output [`WIDTH]	o_btb_target,
 output	[2:0]		o_btb_type,
 output				o_btb_hit
 
);
localparam	ENTRY_NUM = 128;
localparam  ILEN      = $clog2(ENTRY_NUM);

wire [35:0] btb_wdata = i_wb_cmt_req ? {i_wb_instr_pc[15:0],1'b1,i_wb_cmt_target[15:0],i_wb_cmt_type} :
	{i_bpu_instr_pc[15:0],i_bpu_btb_valid,i_bpu_btb_target[15:0],i_bpu_btb_type}; //36 bits
wire [6:0] btb_waddr = i_wb_cmt_req ? i_wb_instr_pc[ILEN+2-1:2] : i_bpu_instr_pc[ILEN+2-1:2];
wire [15:0] btb_tag0;
wire [2:0]  btb_type0;
wire [15:0] btb_target0;
wire		btb_valid0;

btb_ram_128 btb_ram_128(
		.a(btb_waddr), 
        .d(btb_wdata), 
        .dpra(i_pref_pc[ILEN+2-1:2]), 
        .clk(i_sys_clk), 
		.rst(i_sys_rst),
        .we(i_wb_cmt_req|i_bpu_btb_update), 
        .dpo({btb_tag0, btb_valid0, btb_target0, btb_type0})
);
//all the pc can get data out from the bram but we must know whether it is hit
//or not so the decision we use the data is made in bpu nor directly from the
//btb, it is just a buffer
reg [`WIDTH] btb_target_r;
reg	[2:0]	 btb_type_r;
reg			 btb_hit_r;
reg  [15:0]	pref_pc_r;
//wire  tag_valid = &(i_pref_pc[15:0]^~btb_tag0);
always@(posedge i_sys_clk or negedge i_sys_rst) begin
	if(!i_sys_rst) begin
		btb_target_r <= 'd0;
		btb_hit_r <= 'd0;
		btb_type_r <= 'd0;
		pref_pc_r <= 'd0;
	end
	else begin
		pref_pc_r <= i_pref_pc[15:0];
		btb_target_r <= {i_pref_pc[31:16], btb_target0};
		btb_type_r <= btb_type0;
		btb_hit_r <= btb_valid0&(&(pref_pc_r^~btb_tag0));
	end
end
 assign o_btb_target = btb_target_r;
 assign o_btb_type = btb_type_r;
 assign o_btb_hit = btb_hit_r;

 endmodule
