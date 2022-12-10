///////////////////////////////////////////////////////////////////////////////
//
// Copyright Freddi, UESTC 
//
///////////////////////////////////////////////////////////////////////////////
//-----------------------------------------------------------------------------
//
// Project    : Xcore cmt unit 
// File       : Xcore_mem_cmt.v
// Module     : Xcore_mem_cmt.v(CMT)
// Author     : Yufei Fu(fuyufei083X@gmail.com)
// Date       : 2022-11-16
// Version    : v1.0
// Description:  In CMT Unit, we need judge whether the instruction is fully cmpeleted and then submit it
//				avoid one struction is executed repeatly
//				if former instruction is not executed completely (as we have
//				some instr will have multiple periods in one stage) so we must
//				stall the pipeline to wait 
//				one last mux to make sure the instr is submited and writen back
//				successfully.
// ----------------------------------------------------------------------------
`timescale 1ns/1ps
//include params
`include "./rtl/include/params.v"
//module definition

module Xcore_mem_cmt(
	input               i_sys_clk,
    input               i_sys_rst,

    input               i_wb_stall,

    input   [`Width]   i_ex_instr_pc,
    input               i_ex_instr_vld,
    input   [2:0]       i_ex_instr_id,

    input               i_ex_alu_req,
    input   [`Width]   i_ex_alu_res,
    input   [`Width]   i_ex_alu_res2,
    input               i_ex_alu_cmp_res,

    input               i_ex_bjp_req,
    input   [`Width]   i_bjp_target,
    input   [`Width]   i_bjp_res,
    input               i_bjp_jump_req,
    input               i_bjp_flush_req,
    input               i_bjp_flush_type,
    input   [2:0]       i_bjp_flush_id,

    input               i_ex_lsu_req,
    input   [`Width]   i_lsu_res,
    input               i_lsu_vld,

    input               i_ex_csr_req,
    input   [`Width]   i_ex_csr,
    input               i_ex_csrrw_req,
    input   [`Width]   i_ex_csrrw_d,
    input   [11:0]      i_ex_csr_addr,
    input   [4:0]       i_ex_rd_addr,

    input               i_ex_sys_req,

    // stall IF and ID stage if execute not finish
    output              o_cmt_stall_req,

    output              o_cmt_wrbk_req,
    output  [4:0]       o_cmt_wrbk_addr,
    output  [`Width]   o_cmt_wrbk_data,

    output              o_cmt_wcsr_req,
    output  [11:0]      o_cmt_wcsr_addr,
    output  [`Width]   o_cmt_wcsr_data,

    output              o_cmt_ghr, //get the answer of last branch is correctly or not   
    output  [`Width]   o_cmt_bjp_target, // get whether the last branch is jumped or not 
    output              o_cmt_bjp_ret,

    output              o_cmt_flush_req,
    output              o_cmt_flush_type,
    output  [2:0]       o_cmt_flush_id,

    output              o_cmt_instr_vld
);

 reg commited;
    wire cmt_vld = i_ex_sys_req | i_ex_alu_req | i_ex_bjp_req | (i_ex_lsu_req&i_lsu_vld) | i_ex_csr_req;

    assign o_cmt_wrbk_data = ({`Len{i_ex_lsu_req}} & i_lsu_res)
                           | ({`Len{i_ex_csr_req}} & i_ex_csr)
                           | ({`Len{i_ex_bjp_req}} & i_bjp_res)
                           | ({`Len{i_ex_alu_req}} & (i_ex_alu_res|i_ex_alu_res2|{{`Len-1{1'b0}},i_ex_alu_cmp_res}));
    assign o_cmt_wrbk_addr = i_ex_rd_addr;
    assign o_cmt_wrbk_req  = cmt_vld&o_cmt_instr_vld;

    assign o_cmt_wcsr_data = i_ex_csrrw_req ? i_ex_csrrw_d : i_ex_alu_res;
    assign o_cmt_wcsr_addr = i_ex_csr_addr;
    assign o_cmt_wcsr_req  = i_ex_csr_req&o_cmt_instr_vld;

    assign o_cmt_stall_req = i_ex_instr_vld & ~cmt_vld&~commited;

    assign o_cmt_bjp_req = i_bjp_flush_pc_req&o_cmt_instr_vld;
    assign o_cmt_bjp_target = i_bjp_target;
    assign o_cmt_bjp_ret = i_ex_bjp_req;
    assign o_cmt_flush_req = i_bjp_flush_req&o_cmt_instr_vld;
    assign o_cmt_flush_type = i_bjp_flush_type;
    assign o_cmt_flush_id = i_bjp_flush_id;



    always @(posedge i_sys_clk or posedge i_sys_rst) begin
        if(i_sys_rst) begin
            commited <= #1 0;
        end
        else begin
            if(i_wb_stall&cmt_vld&i_ex_instr_vld)
                commited <= #1 1;
            else if(~i_wb_stall)
                commited <= #1 0;
            else
                commited <= #1 commited;
        end
    end

    assign o_cmt_instr_vld = i_ex_instr_vld & ~commited;
endmodule
