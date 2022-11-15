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
// File       : Xcore_lhb_matrix_miso_1.v
// Module     : Xcore_lhb_matrix_miso_1()
// Dependancy : 
// Software   : python3.7, vivado2018.3
// Author     : Freddi Fu
// Date       : 2022-10-27
// Version    : v1.0
// Description: LHB Multi-inlet Single-outlet.
//              This file is automatically generated by Limber LHB Generator.
//              Visit https://gitee.com/qyley/lhb for support
//
//-------------------------------------------------------------------------------------------

module Xcore_lhb_matrix_miso_1#(
    // parameters
    parameter DW = 32,
    parameter RR = 0 // 0 : prior 1 : round-robin
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
    // inlet req 1 (from master 1)
    input   [32-1:0]    i_m1_lhb_req_taddr,
    input   [DW-1:0]    i_m1_lhb_req_wdata,
    input   [3-1:0]     i_m1_lhb_req_tsize,
    input               i_m1_lhb_req_write,
    input               i_m1_lhb_req_valid,
    output              o_m1_lhb_req_ready,
    // inlet rsp 1 (to master 1)
    output  [DW-1:0]    o_m1_lhb_rsp_rdata,
    output              o_m1_lhb_rsp_error,
    output              o_m1_lhb_rsp_valid,
    input               i_m1_lhb_rsp_ready,
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
    output              o_s0_lhb_rsp_ready
);

    wire [2-1:0] req_vld = {
        i_m1_lhb_req_valid,
        i_m0_lhb_req_valid
    };

    wire [2-1:0] req_grt_arbi;
    wire [2-1:0] req_grt_bus;

    limber_gnrl_arbiter #(
        .N(2),
        .RR(0)
    ) inst_limber_gnrl_arbiter (
        .i_clk           (i_clk),
        .i_rst           (i_rst),
        .i_lhb_req_valid (req_vld),
        .o_lhb_req_grant (req_grt_arbi)
    );
    
    wire [32-1:0] m0_lhb_req_taddr = {32{req_grt_bus[0]}} & i_m0_lhb_req_taddr;
    wire [DW-1:0] m0_lhb_req_wdata = {DW{req_grt_bus[0]}} & i_m0_lhb_req_wdata;
    wire [3-1:0]  m0_lhb_req_tsize =  {3{req_grt_bus[0]}} & i_m0_lhb_req_tsize;
    wire          m0_lhb_req_write =  {1{req_grt_bus[0]}} & i_m0_lhb_req_write;
    wire          m0_lhb_req_valid =  {1{req_grt_bus[0]}} & i_m0_lhb_req_valid;
    
    wire [32-1:0] m1_lhb_req_taddr = {32{req_grt_bus[1]}} & i_m1_lhb_req_taddr;
    wire [DW-1:0] m1_lhb_req_wdata = {DW{req_grt_bus[1]}} & i_m1_lhb_req_wdata;
    wire [3-1:0]  m1_lhb_req_tsize =  {3{req_grt_bus[1]}} & i_m1_lhb_req_tsize;
    wire          m1_lhb_req_write =  {1{req_grt_bus[1]}} & i_m1_lhb_req_write;
    wire          m1_lhb_req_valid =  {1{req_grt_bus[1]}} & i_m1_lhb_req_valid;
    
    assign o_m0_lhb_req_ready = {1{req_grt_bus[0]}} & i_s0_lhb_req_ready;
    assign o_m1_lhb_req_ready = {1{req_grt_bus[1]}} & i_s0_lhb_req_ready;

    assign o_s0_lhb_req_taddr = m0_lhb_req_taddr
                              | m1_lhb_req_taddr
                              ;

    assign o_s0_lhb_req_wdata = m0_lhb_req_wdata
                              | m1_lhb_req_wdata
                              ;

    assign o_s0_lhb_req_tsize = m0_lhb_req_tsize
                              | m1_lhb_req_tsize
                              ;

    assign o_s0_lhb_req_write = m0_lhb_req_write
                              | m1_lhb_req_write
                              ;

    assign o_s0_lhb_req_valid = m0_lhb_req_valid
                              | m1_lhb_req_valid
                              ;

    wire fifo_full;
    wire [2-1:0] rsp_grt_bus;
    wire fifo_wen = o_s0_lhb_req_valid && i_s0_lhb_req_ready;
    wire fifo_ren = o_s0_lhb_rsp_ready && i_s0_lhb_rsp_valid;

    limber_gnrl_fifo_syn #(
        .DW(2),
        .AW(3),
        .FORCE_X2ZERO(1)
    ) inst_limber_gnrl_fifo_syn (
        .clk   (i_clk),
        .rst   (i_rst),
        .din   (req_grt_bus),
        .wen   (fifo_wen),
        .ren   (fifo_ren),
        .empty (),
        .full  (fifo_full),
        .dout  (rsp_grt_bus)
    );

    assign req_grt_bus = {2{~fifo_full}} & req_grt_arbi;

    wire m0_lhb_rsp_ready = {1{rsp_grt_bus[0]}} & i_m0_lhb_rsp_ready;
    wire m1_lhb_rsp_ready = {1{rsp_grt_bus[1]}} & i_m1_lhb_rsp_ready;

    assign o_m0_lhb_rsp_rdata = {DW{rsp_grt_bus[0]}} & i_s0_lhb_rsp_rdata;
    assign o_m0_lhb_rsp_error =  {1{rsp_grt_bus[0]}} & i_s0_lhb_rsp_error;
    assign o_m0_lhb_rsp_valid =  {1{rsp_grt_bus[0]}} & i_s0_lhb_rsp_valid;

    assign o_m1_lhb_rsp_rdata = {DW{rsp_grt_bus[1]}} & i_s0_lhb_rsp_rdata;
    assign o_m1_lhb_rsp_error =  {1{rsp_grt_bus[1]}} & i_s0_lhb_rsp_error;
    assign o_m1_lhb_rsp_valid =  {1{rsp_grt_bus[1]}} & i_s0_lhb_rsp_valid;

    assign o_s0_lhb_rsp_ready = m0_lhb_rsp_ready
                              | m1_lhb_rsp_ready
                              ;

endmodule
