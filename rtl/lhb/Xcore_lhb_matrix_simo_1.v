`timescale 1ns / 1ps
///////////////////////////////////////////////////////////////////////////////
//
// Copyright yufei, UESTC 
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
//
///////////////////////////////////////////////////////////////////////////////
//-------------------------------------------------------------------------------------------
//
// Project    : Xcore LHB
// File       : Xcore_lhb_matrix_simo_1.v
// Module     : Xcore_lhb_matrix_simo_1()
// Dependancy : 
// Software   : python3.7, vivado2018.3
// Author     : Freddi Fu
// Date       : 2022-10-27
// Version    : v1.0
// Description: LHB Single-inlet Multi-outlet.
//              This file is automatically generated by Limber LHB Generator.
//              Visit https://gitee.com/qyley/lhb for support
//
//-------------------------------------------------------------------------------------------

module Xcore_lhb_matrix_simo_1#(
    // parameters
    parameter DW = 32
)(
    input               i_clk,
    input               i_rst,  // high active

    // inlet req 0 (from master 0)
    input   [32-1:0]    i_m0_lhb_req_taddr,
    input   [DW-1:0]    i_m0_lhb_req_wdata,
    input   [3-1:0]     i_m0_lhb_req_tsize,
    input               i_m0_lhb_req_write,
    input               i_m0_lhb_req_valid,
    output              o_m0_lhb_req_ready,
    // inlet rsp 0 (to master 0)
    output  [DW-1:0]    o_m0_lhb_rsp_rdata,
    output              o_m0_lhb_rsp_error,
    output              o_m0_lhb_rsp_valid,
    input               i_m0_lhb_rsp_ready,
    // outlet req 0 (to slave 0)
    output  [32-1:0]    o_s0_lhb_req_taddr,
    output  [DW-1:0]    o_s0_lhb_req_wdata,
    output  [3-1:0]     o_s0_lhb_req_tsize,
    output              o_s0_lhb_req_write,
    output              o_s0_lhb_req_valid,
    input               i_s0_lhb_req_ready,
    // outlet rsp 0 (from slave 0)
    input   [DW-1:0]    i_s0_lhb_rsp_rdata,
    input               i_s0_lhb_rsp_error,
    input               i_s0_lhb_rsp_valid,
    output              o_s0_lhb_rsp_ready,
    // outlet req 1 (to slave 1)
    output  [32-1:0]    o_s1_lhb_req_taddr,
    output  [DW-1:0]    o_s1_lhb_req_wdata,
    output  [3-1:0]     o_s1_lhb_req_tsize,
    output              o_s1_lhb_req_write,
    output              o_s1_lhb_req_valid,
    input               i_s1_lhb_req_ready,
    // outlet rsp 1 (from slave 1)
    input   [DW-1:0]    i_s1_lhb_rsp_rdata,
    input               i_s1_lhb_rsp_error,
    input               i_s1_lhb_rsp_valid,
    output              o_s1_lhb_rsp_ready,
    // outlet req 2 (to slave 2)
    output  [32-1:0]    o_s2_lhb_req_taddr,
    output  [DW-1:0]    o_s2_lhb_req_wdata,
    output  [3-1:0]     o_s2_lhb_req_tsize,
    output              o_s2_lhb_req_write,
    output              o_s2_lhb_req_valid,
    input               i_s2_lhb_req_ready,
    // outlet rsp 2 (from slave 2)
    input   [DW-1:0]    i_s2_lhb_rsp_rdata,
    input               i_s2_lhb_rsp_error,
    input               i_s2_lhb_rsp_valid,
    output              o_s2_lhb_rsp_ready
);

    localparam S0_LO = 32'h0000_0000;
    localparam S0_AW = 15;

    localparam S1_LO = 32'h1000_0000;
    localparam S1_AW = 15;

    localparam S2_LO = 32'h2000_0000;
    localparam S2_AW = 4;

    wire [3-1:0] req_sel_dec;
    wire [3-1:0] req_sel_bus;
    assign req_sel_dec[0] = i_m0_lhb_req_valid && (i_m0_lhb_req_taddr[31:S0_AW]==(S0_LO>>S0_AW));
    assign req_sel_dec[1] = i_m0_lhb_req_valid && (i_m0_lhb_req_taddr[31:S1_AW]==(S1_LO>>S1_AW));
    assign req_sel_dec[2] = i_m0_lhb_req_valid && (i_m0_lhb_req_taddr[31:S2_AW]==(S2_LO>>S2_AW));

    assign o_s0_lhb_req_taddr = i_m0_lhb_req_taddr;
    assign o_s0_lhb_req_wdata = i_m0_lhb_req_wdata;
    assign o_s0_lhb_req_tsize = i_m0_lhb_req_tsize;
    assign o_s0_lhb_req_write = i_m0_lhb_req_write;
    assign o_s0_lhb_req_valid = req_sel_bus[0];

    assign o_s1_lhb_req_taddr = i_m0_lhb_req_taddr;
    assign o_s1_lhb_req_wdata = i_m0_lhb_req_wdata;
    assign o_s1_lhb_req_tsize = i_m0_lhb_req_tsize;
    assign o_s1_lhb_req_write = i_m0_lhb_req_write;
    assign o_s1_lhb_req_valid = req_sel_bus[1];

    assign o_s2_lhb_req_taddr = i_m0_lhb_req_taddr;
    assign o_s2_lhb_req_wdata = i_m0_lhb_req_wdata;
    assign o_s2_lhb_req_tsize = i_m0_lhb_req_tsize;
    assign o_s2_lhb_req_write = i_m0_lhb_req_write;
    assign o_s2_lhb_req_valid = req_sel_bus[2];

    assign o_m0_lhb_req_ready = (req_sel_bus[0]&i_s0_lhb_req_ready)
                              | (req_sel_bus[1]&i_s1_lhb_req_ready)
                              | (req_sel_bus[2]&i_s2_lhb_req_ready)
                              ;

    wire fifo_full;
    wire [3-1:0] rsp_sel_bus;
    wire fifo_wen = i_m0_lhb_req_valid && o_m0_lhb_req_ready;
    wire fifo_ren = o_m0_lhb_rsp_valid && i_m0_lhb_rsp_ready;

    limber_gnrl_fifo_syn #(
        .DW(3),
        .AW(3),
        .FORCE_X2ZERO(1)
    ) inst_limber_gnrl_fifo_syn (
        .clk   (i_clk),
        .rst   (i_rst),
        .din   (req_sel_bus),
        .wen   (fifo_wen),
        .ren   (fifo_ren),
        .empty (),
        .full  (fifo_full),
        .dout  (rsp_sel_bus)
    );

    assign req_sel_bus = {3{~fifo_full}} & req_sel_dec;

    wire    [DW-1:0]    s0_lhb_rsp_rdata = {DW{rsp_sel_bus[0]}} & i_s0_lhb_rsp_rdata;
    wire                s0_lhb_rsp_error =  {1{rsp_sel_bus[0]}} & i_s0_lhb_rsp_error;
    wire                s0_lhb_rsp_valid =  {1{rsp_sel_bus[0]}} & i_s0_lhb_rsp_valid;

    wire    [DW-1:0]    s1_lhb_rsp_rdata = {DW{rsp_sel_bus[1]}} & i_s1_lhb_rsp_rdata;
    wire                s1_lhb_rsp_error =  {1{rsp_sel_bus[1]}} & i_s1_lhb_rsp_error;
    wire                s1_lhb_rsp_valid =  {1{rsp_sel_bus[1]}} & i_s1_lhb_rsp_valid;

    wire    [DW-1:0]    s2_lhb_rsp_rdata = {DW{rsp_sel_bus[2]}} & i_s2_lhb_rsp_rdata;
    wire                s2_lhb_rsp_error =  {1{rsp_sel_bus[2]}} & i_s2_lhb_rsp_error;
    wire                s2_lhb_rsp_valid =  {1{rsp_sel_bus[2]}} & i_s2_lhb_rsp_valid;

    assign o_m0_lhb_rsp_rdata = s0_lhb_rsp_rdata
                              | s1_lhb_rsp_rdata
                              | s2_lhb_rsp_rdata
                              ;

    assign o_m0_lhb_rsp_error = s0_lhb_rsp_error
                              | s1_lhb_rsp_error
                              | s2_lhb_rsp_error
                              ;

    assign o_m0_lhb_rsp_valid = s0_lhb_rsp_valid
                              | s1_lhb_rsp_valid
                              | s2_lhb_rsp_valid
                              ;

    assign o_s0_lhb_rsp_ready = {1{rsp_sel_bus[0]}} & i_m0_lhb_rsp_ready;
    assign o_s1_lhb_rsp_ready = {1{rsp_sel_bus[1]}} & i_m0_lhb_rsp_ready;
    assign o_s2_lhb_rsp_ready = {1{rsp_sel_bus[2]}} & i_m0_lhb_rsp_ready;

endmodule
