///////////////////////////////////////////////////////////////////////////////
//
// Copyright Freddi, UESTC 
//
///////////////////////////////////////////////////////////////////////////////
`timescale 1ns / 1ps
//-----------------------------------------------------------------------------
//
// Project    : Xcore Branch Prediction Unit
// File       : Xcore_bpu.v
// Module     : Xcore_bpu.v(BPU)
// Author     : Yufei Fu(fuyufei083X@gmail.com)
// Date       : 2022-9-24
// Version    : v1.0
// Description: Static Branch Predictor.
//              Direction:
//                B-type : jump back taken, jump forward not taken
//                JAL    : taken
//                JALR   : not taken
//              Target:
//                B-type : PC + b_ofs
//                JAL    : PC + j_ofs
//                JALR   : PC + 4
//              Since jalr target need 1~N clk to access RegFile.
//              It will freeze the IF stage until jalr get committed.
//              
// ----------------------------------------------------------------------------

module Xcore_bpu(
input bpu_clk,
input bpu_rst,

input	[31:0]		cur_instr_pc, //pc of current beq instruction 
input				    flush_valid,
input				    stall_valid,
input	[6:0]		    cur_instr_op,
input	[11:0]		instr_b_off,
input	[11:0]		instr_jar_off,

output				    bpu_jump_valid,
output	[31:0]		bpu_instr_adr
);
// jump back taken and jump forward not taken
//we no do not take jump when encountering instruction	jarl
//but when it meets jar we must jump
parameter B_TYPE = 2'b01;
parameter JAR = 2'b11;
parameter JARL = 2'b10;
parameter NONE = 2'b00;

wire bpu_valid_en;
// recognize current instruction type
wire [1:0]	instr_type;
assign instr_type = (cur_instr_op==7'b1100011) ? B_TYPE :
	(cur_instr_op==7'b1101111) ? JAR :
	(cur_instr_op==7'b1100111) ? JARL : NONE;

//obtain correct offset
wire [11:0] off;
assign off = (instr_type==2'b11) ? instr_jar_off : (instr_type==2'b01) ? instr_b_off : 'd0;

//core code to implement the functon of taking branch jump when it is backward
//while take not when it is forward...
assign bpu_valid_en = off[11]|(&instr_type);

//check pipeline status
reg bpu_stop;
always@(posedge bpu_clk or negedge bpu_rst) begin
if(!bpu_rst) 
	bpu_stop <= 1'b0;
else begin
	if(flush_valid|stall_valid)
		bpu_stop <= 1'b1;
	else 
		bpu_stop <= 1'b0;
end

end

//get output : address and control valid signal
 
assign bpu_jump_valid =  bpu_valid_en&(~bpu_stop);
assign bpu_instr_adr =	 cur_instr_pc - {21'b0, off[10:0]};


endmodule

