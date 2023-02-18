`timescale 1ns / 1ps
/*========================================FILE_HEADER=====================================
# Author:  Freddi Fu(fuyufei083x@163.com)
#
# Critical Timing: 2022-2023 -
#
# date: 2023-02-17 04:43
#
# Filename: Xcore_if_mdec.v
#
# Module Name: Xcore_if_mdec.v
#
# VERSION      LAST MODIFID    Instance Modules           DESCRIPTION
#   1.0         2023-2-17        none                this is the decode module for bpu
#                                                    it provides the simple information of an instruction
#                                                    including the type of it and its offset
#
=========================================FILE_HEADER====================================*/
`include"./rtl/include/params.v"
module Xcore_if_mdec (
//input 
    input   [`WIDTH]   i_pref_instr, //input instruction
	input              i_pc_instr_vld, //whether pc is working normally
//output
    output              o_mdec_b,
    output              o_mdec_jal,
    output              o_mdec_jalr,
    output  [`WIDTH]    o_mdec_b_ofs,
    output  [`WIDTH]    o_mdec_jal_ofs,
    output  [`WIDTH]    o_mdec_jalr_ofs,
//whether the instruction is a branch 
    output              o_mdec_instr_vld
);
//****************************************************************************************  
    // key information obtain
    wire    [6:0]   opcode = i_pref_instr[6:0];
    wire    [2:0]   funct3 = i_pref_instr[14:12];
    wire    [4:0]   rd = i_pref_instr[11:7];
    wire    [4:0]   rs1 = i_pref_instr[19:15];
//****************************************************************************************  
    wire predec_jalr = opcode==7'b1100111;
    // wire predec_ret = 1'b0;
    wire predec_b = opcode==7'b1100011;
    wire predec_jal = opcode==7'b1101111;
// offset data (32 bit) = 32-immewidth 'b0 + offset decode, i_pref_instr[31]
// is just zero
    wire [`WIDTH] predec_b_ofs = {{`LEN-12{i_pref_instr[31]}}, i_pref_instr[7], i_pref_instr[30:25], i_pref_instr[11:8], 1'b0};
    wire [`WIDTH] predec_jal_ofs = {{`LEN-20{i_pref_instr[31]}}, i_pref_instr[19:12], i_pref_instr[20], i_pref_instr[30:21], 1'b0};
    wire [`WIDTH] predec_jalr_ofs = {{`LEN-11{i_pref_instr[31]}},  i_pref_instr[30:21], 1'b0};
//****************************************************************************************  
//assignment 
    assign o_mdec_b = predec_b;
    assign o_mdec_jal = predec_jal;
    assign o_mdec_jalr = predec_jalr;
    assign o_mdec_b_ofs = predec_b_ofs;
    assign o_mdec_jal_ofs = predec_jal_ofs;
    assign o_mdec_jalr_ofs = predec_jalr_ofs;
    assign o_mdec_instr_vld = i_pc_instr_vld&(predec_b|predec_jal|predec_jalr);
endmodule
