///////////////////////////////////////////////////////////////////////////////
//
// Copyright Freddi, UESTC 
//
///////////////////////////////////////////////////////////////////////////////
`timescale 1ns / 1ps
//-----------------------------------------------------------------------------
//
// Project    : Xcore Branch Prediction Unit-bpu core unit
// File       : Xcore_if_bpu.v
// Module     : Xcore_if_bpu.v(BPU)
// Author     : Yufei Fu(fuyufei083X@gmail.com)
// Date       : 2022-11-20
// Version    : v1.0
// Description: G-share branch predictor.
//				core branch unit to associate the rest part of the unit
//				It contains the overall output but each module has its own
//				inputs
// ----------------------------------------------------------------------------
`include"./rtl/include/params.v"
module Xcore_if_bpu(
	input i_sys_clk,
    input i_sys_rst,
	//btb target
	input   [`WIDTH]    i_btb_target,
    input   [3-1:0]     i_btb_type,
    input               i_btb_hit,
	//bim output 
	input   [1:0]		i_bim_bits,
	//mdec and outer input pc& instr
	input               i_pref_pc_vld, // valid signal of pc //as long as there is a pc input
    input   [`WIDTH]    i_pref_instr_pc, //pc input 
    //primary decode get the type of the input instr and know whether it is
	//a branch 
	input               i_pref_instr_vld, // branch instruction valid 
    input               i_mdec_b,
    input               i_mdec_jal,
    input               i_mdec_jalr,
    input   [`WIDTH]    i_mdec_b_ofs,
    input   [`WIDTH]    i_mdec_jal_ofs,
    input   [`WIDTH]    i_mdec_jalr_ofs,

    //input   [`WIDTH]    i_of_gpr_ra,
	// update btb // no need to update bim as it only has back end update
    output  [`WIDTH]    o_bpu_instr_pc,
    output              o_bpu_btb_update,
    output  [3-1:0]     o_bpu_btb_type, //branch 100 jar 010 jalr 001
    output  [`WIDTH]    o_bpu_btb_target,
    output              o_bpu_btb_valid,
	// update ghr
    output              o_bpu_ghr_req,
    output              o_bpu_ghr_taken,


    // next line
    output              o_bpu_redir,
    output  [`WIDTH]    o_bpu_target,
    output  [2-1:0]     o_bpu_bits,
    output              o_bpu_btb_err
);
 reg too_many_bjp;
    always@(posedge i_sys_clk or negedge i_sys_rst)begin
        if(!i_sys_rst)begin
            too_many_bjp <= 0;
        end else begin
            if(o_bpu_redir)
                too_many_bjp <= 1;
            else
                too_many_bjp <= 0;
        end
    end

    wire bpu_en = i_pref_instr_vld&(i_mdec_b | i_mdec_jal|i_mdec_jalr);//enable signal 
    wire [`WIDTH] bpu_ofs = {`LEN{i_mdec_jal}} & i_mdec_jal_ofs
                           | {`LEN{i_mdec_b}}   & i_mdec_b_ofs;
    wire [`WIDTH] bpu_base =  i_pref_pc_vld ? i_pref_instr_pc : 'd0;
    wire [`WIDTH] bpu_tar =  bpu_base + bpu_ofs;

    // BTB target, this is in a fast path: BTB -> pc_mux -> BUS -> ITCM
    // btb_hit & bib_miss
    wire btb_hit = i_btb_hit&i_pref_instr_vld;
    wire btb_miss = ~i_btb_hit&i_pref_instr_vld;
	//check type correction 
    wire btb_vld = (i_btb_type[0]&i_mdec_jalr)
                  | (i_btb_type[1]&i_mdec_jal)
                  | (i_btb_type[2]&i_mdec_b);  //i_mdec is changing !!!
	//btb target 
	wire [`WIDTH] btb_tar = (btb_miss|btb_err) ? bpu_tar: (btb_hit&btb_vld&bpu_en) ? i_btb_target : 'd0;
    // fast path
    wire bpu_taken = ((btb_hit&bpu_en) & (i_bim_bits[1]|i_bim_bits[0]))|(i_bim_bits[1]&i_bim_bits[0]);

    // slow path, the btb_err seems not very ok, don't use it
    //wire bpu_taken = btb_miss & (i_mdec_jal|i_mdec_ret|(i_mdec_b&i_bim_bits[1]));
    wire btb_err = btb_hit & (~btb_vld);   //check whether ther is something wrong with btb  output
	wire bpu_jalr= i_pref_instr_vld & i_mdec_jalr;
	wire bpu_jal = i_pref_instr_vld & i_mdec_jal;
    assign o_bpu_redir = bpu_jalr ? 1'b0 : bpu_jal ? 1'b1 : bpu_taken&~too_many_bjp&i_pref_instr_vld;
    assign o_bpu_target = btb_tar;


    // Path : ITCM -> BUS -> mdec -> addr_adder -> BTB
    assign o_bpu_btb_update = (bpu_en|btb_err);
    assign o_bpu_instr_pc = i_pref_instr_pc;
    assign o_bpu_btb_type = {i_mdec_b, i_mdec_jal, i_mdec_jalr};
    assign o_bpu_btb_target = bpu_tar;
    assign o_bpu_btb_valid = bpu_en;

    // We don't update BIM in IF stage despite of the hysteretic effect
    //assign o_bpu_bim_update = 1'b0;
    //assign o_bpu_bim_bits =  2'b0;

    assign o_bpu_ghr_req = i_mdec_b;
    assign o_bpu_ghr_taken = o_bpu_redir;

    // Forward BIM state to wb_bjp
    assign o_bpu_bits = i_bim_bits;

    // If btb record a false instr type, we set the next instr invalid and redirect.
    assign o_bpu_btb_err = btb_err;

endmodule
