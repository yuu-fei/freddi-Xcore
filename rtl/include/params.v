///////////////////////////////////////////////////////////////////////////////
//
// Copyright Freddi, UESTC 
//
///////////////////////////////////////////////////////////////////////////////
`timescale 1ns / 1ps
//-----------------------------------------------------------------------------
//
// Project    : Xcore inlcude global params
// File       : params.v
// Module     : params.v(global include)
// Author     : Yufei Fu(fuyufei083X@gmail.com)
// Date       : 2022-9-25
// Version    : v1.0
// Description: include parameters
//              these parameters are used to control the possible structure of
//              the CPU by checking whether you macro it or not in this file
//              
// ----------------------------------------------------------------------------
`define XCORE_XPARAMS // include the file


`define SIM_SOURCE //for simulation

`ifndef SIM_SOURCE
    `define FPGA_SOURCE
`endif

`define XCORE_HAS_BPU //whether it has bpu
`define XCORE_HAS_BYPASS //whether it has bypass datapath


// init prograsm addr
//`define pcRstEntry 32'h00000000
// Instruction align

// RV32IM data lenth
`define WIDTH 31:0
`define LEN 32

//Stall Control bit
`define STWIDTH 1:0
`define STLEN 2
`define STJARLCODE 0



// OpCode
`define opcodeWidth 6:0

`define RV32I_LUI       7'b0110111
`define RV32I_AUIPC     7'b0010111
`define RV32I_JAL       7'b1101111
`define RV32I_JALR      7'b1100111
`define RV32I_B         7'b1100011
`define RV32I_LOAD      7'b0000011
`define RV32I_STORE     7'b0100011
`define RV32I_ALU       7'b0010011
`define RV32I_ALUR      7'b0110011
`define RV32I_FENCE     7'b0001111
`define RV32I_E         7'b1110011

`define INST_NOP            32'h00000013
`define INST_MRET           32'h30200073
`define INST_ECALL          32'h00000073
`define INST_EBREAK         32'h00100073
`define INST_DRET           32'h7b200073

// CSR Addr
// User-level
`define CSR_CYCLE       12'hc00 // ok
`define CSR_CYCLEH      12'hc80 // ok
`define CSR_TIME        12'hc01
`define CSR_TIMEH       12'hc81
`define CSR_INSTRET     12'hc02 // ok
`define CSR_INSTRETH    12'hc82 // ok

// Mechine-level
`define CSR_MTVEC       12'h305
`define CSR_MCAUSE      12'h342
`define CSR_MEPC        12'h341
`define CSR_MIE         12'h304
`define CSR_MSTATUS     12'h300
`define CSR_MSCRATCH    12'h340
`define CSR_MHARTID     12'hF14
`define CSR_MISA        12'h301

// Xcore Custom User-Level 110011xxxxxx
`define CSR_BJPRET      12'hcc0
`define CSR_BJPRETH     12'hcc1
`define CSR_BJPHIT      12'hcc2
`define CSR_BJPHITH     12'hcc3

// only used for verification
`define CSR_SSTATUS     12'h100
// Debug
`define CSR_DCSR        12'h7b0
`define CSR_DPC         12'h7b1
`define CSR_DSCRATCH0   12'h7b2
`define CSR_DSCRATCH1   12'h7b3
`define CSR_TSELECT     12'h7A0
`define CSR_TDATA1      12'h7A1
`define CSR_TDATA2      12'h7A2
`define CSR_TDATA3      12'h7A3
`define CSR_MCONTEXT    12'h7A8
`define CSR_SCONTEXT    12'h7AA
