`timescale 1ns / 1ps
/*========================================FILE_HEADER=====================================
# Author:  Freddi Fu
#
# Critical Timing: 2022-2023 -
#
# date: 2022-12-09 01:09
#
# Filename: Xcore_gshare_bpu.v
#
# Description: Xcore_gshare_bpu.v
#
# VERSION      LAST MODIFID    AUTHOR           DESCRIPTION
#   1.0           2022-12-10  Freddi Fu         writesomethinghere
#
#
=========================================FILE_HEADER====================================*/
`include"./rtl/include/params.v"
module Xcore_gshare_bpu(
    input   i_sys_clk,
    input   i_sys_rst,
    //ghr backend update
    input   i_cmt_ghr, //get the answer whether the last branch is predicted correctly 0 or not 1;
    input   i_cmt_req, // whether this is a branch feedback
    input   i_cmt_ghr_target,
    input   [`GHRLEN-1:0]   i_cmt_ghr_val,
    //bim backend update
    input   [1:0]           i_cmt_bits,
    //bpu
    input               i_pref_instr_vld, 
    input               i_pref_pc_vld,
    input   [`WIDTH]    i_pref_instr_pc,
    input               i_mdec_b,
    input               i_mdec_jal,
    input               i_mdec_jalr,
    input   [`WIDTH]    i_mdec_b_ofs,
    input   [`WIDTH]    i_mdec_jal_ofs,
    input   [`WIDTH]    i_mdec_jalr_ofs,
    //btb backend update
    input   [`WIDTH]    i_wb_instr_pc,
    input   [2:0]       i_wb_cmt_type,
    //input               i_wb_cmt_req;
    input   [`WIDTH]    i_wb_cmt_target,
//output
    output              o_bpu_redir,
    output  [`WIDTH]    o_bpu_target,
    output  [2-1:0]     o_bpu_bits,
    output              o_bpu_btb_err
);

// Xcore_if_ghr Inputs
wire  bpu_taken;
wire  bpu_req;

// Xcore_if_ghr Outputs
wire  [`GHRLEN-1:0]  ghr_val;

Xcore_if_ghr  u_Xcore_if_ghr (
    .i_sys_clk               ( i_sys_clk       ),
    .i_sys_rst               ( i_sys_rst       ),
    .i_bpu_taken             ( bpu_taken     ),
    .i_bpu_req               ( bpu_req       ),
    .i_cmt_ghr               ( i_cmt_ghr       ),
    .i_cmt_req               ( i_cmt_req       ),
    .i_cmt_target            ( i_cmt_ghr_target    ),
    .i_cmt_ghr_val           ( i_cmt_ghr_val   ),

    .o_ghr_val               ( ghr_val       )
);

// Xcore_if_bim Outputs
wire  [1:0]  bim_bits;

Xcore_if_bim  u_Xcore_if_bim (
    .i_sys_clk               ( i_sys_clk    ),
    .i_sys_rst               ( i_sys_rst    ),
    .i_bpu_addr              ( {i_pref_instr_pc[7:0],ghr_val} ),
    .i_cmt_ghr               ( i_cmt_ghr    ),
    .i_cmt_req               ( i_cmt_req    ),
    .i_cmt_addr              ( i_wb_instr_pc[9:0]  ),
    .i_cmt_bits              ( i_cmt_bits   ),

    .o_bim_bits              ( bim_bits   )
);

// Xcore_if_bpu Outputs
//btb-bpu update
wire  [`WIDTH]    instr_pc;

Xcore_if_bpu  u_Xcore_if_bpu (
    .i_sys_clk               ( i_sys_clk        ),
    .i_sys_rst               ( i_sys_rst        ),
    .i_btb_target            ( btb_target     ),
    .i_btb_type              ( btb_type       ),
    .i_btb_hit               ( btb_hit        ),
    .i_bim_bits              ( bim_bits       ),
    .i_pref_pc_vld           ( i_pref_pc_vld    ),
    .i_pref_instr_pc         ( i_pref_instr_pc  ),
    .i_pref_instr_vld        ( i_pref_instr_vld ),
    .i_mdec_b                ( i_mdec_b         ),
    .i_mdec_jal              ( i_mdec_jal       ),
    .i_mdec_jalr             ( i_mdec_jalr      ),
    .i_mdec_b_ofs            ( i_mdec_b_ofs     ),
    .i_mdec_jal_ofs          ( i_mdec_jal_ofs   ),
    .i_mdec_jalr_ofs         ( i_mdec_jalr_ofs  ),
    .o_bpu_instr_pc          ( instr_pc   ),
    .o_bpu_btb_update        ( bpu_btb_update ),
    .o_bpu_btb_type          ( bpu_btb_type   ),
    .o_bpu_btb_target        ( bpu_btb_target ),
    .o_bpu_btb_valid         ( bpu_btb_valid  ),
    .o_bpu_ghr_req           ( bpu_taken   ),
    .o_bpu_ghr_taken         ( bpu_req  ),
    .o_bpu_redir             ( o_bpu_redir      ),
    .o_bpu_target            ( o_bpu_target     ),
    .o_bpu_bits              ( o_bpu_bits       ),
    .o_bpu_btb_err           ( o_bpu_btb_err    )
);
// Xcore_if_btb Inputs
 
wire                  bpu_btb_update;
wire [2:0]            bpu_btb_type;
wire [`WIDTH]         bpu_btb_target;
wire                  bpu_btb_valid;

 

// Xcore_if_btb Outputs
wire  [`WIDTH]  btb_target;
wire  [2:0]      btb_type;
wire            btb_hit;

Xcore_if_btb  u_Xcore_if_btb (
    .i_sys_clk               ( i_sys_clk        ),
    .i_sys_rst               ( i_sys_rst        ),
    .i_pref_pc               ( i_pref_instr_pc  ),
    .i_bpu_instr_pc          ( instr_pc  ),
    .i_bpu_btb_update        ( bpu_btb_update ),
    .i_bpu_btb_type          ( bpu_btb_type   ),
    .i_bpu_btb_target        ( bpu_btb_target ),
    .i_bpu_btb_valid         ( bpu_btb_valid  ),
    .i_wb_instr_pc           ( i_wb_instr_pc    ),
    .i_wb_cmt_type           ( i_wb_cmt_type    ),
    .i_wb_cmt_req            ( i_cmt_req     ),
    .i_wb_cmt_target         ( i_wb_cmt_target  ),
    .o_btb_type              ( btb_type       ),
    .o_btb_target            ( btb_target     ),
    .o_btb_hit               ( btb_hit        )
);
endmodule

