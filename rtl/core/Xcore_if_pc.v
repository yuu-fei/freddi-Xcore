`timescale 1ns / 1ps
/*========================================FILE_HEADER=====================================
# Author:  Freddi Fu(fuyufei083x@163.com)
#
# Critical Timing: 2022-2023 -
#
# date: 2023-01-14 23:52
#
# Filename: Xcore_if_pc.v
#
# Module Name: Xcore_if_pc.v
#
# VERSION      LAST MODIFID    Instance Modules           DESCRIPTION
#   1.0         2022-1-15        none/dff               the program counter of the processor.
#
#  function: if there is no jump from bpu, then plus four +4 pc -> pc + 4 
#            if there should jump, then jump to the branch target from bpu pc -> branch pc
#            if there should stall, then the stall signal is high to make no new instr is fetched
#            if there should flush, then jump to the the pc provided by the flush target
#
=========================================FILE_HEADER====================================*/
`include"./rtl/include/params.v"
module Xcore_if_pc(
// clk and reset signals
    input                       i_sys_clk,
	input                       i_sys_rst,
// input instruction and bpu information
    input      [`WIDTH]         i_iram_instr,
	input                       i_bpu_redir, // taken for 1 and not taken for 0
	input      [`WIDTH]         i_bpu_target,
//	input      [1:0]            i_bpu_bits,
	input                       i_bpu_btb_err, /* if there is am error, the target may be useless and 
	we need to update the btb and get information from the cmt module to receive flush signal*/ 
// flush and jump control
    input                       i_flush_pc_req,
	input      [`WIDTH]         i_flush_pc_target,
	input                       i_if_stall,
// outputs
    output     [`WIDTH]         o_pc_addr,
	output     [`WIDTH]         o_pc_bpu_addr, // the address information given to bpu for update 
	output                      o_pc_req,
	output     [`WIDTH]         o_pc_instr,
	output                      o_pc_addr_valid,
	output                      o_pc_instr_valid
);
//****************************************************************************************  
//period counter
reg [1:0]                       period_cnt;
always@(posedge i_sys_clk or negedge i_sys_rst)
begin
	if(i_sys_rst==1'b0)
		period_cnt <= 'd0;
	else if(i_if_stall==1'b1)
		period_cnt <= period_cnt;
	else if(period_cnt==2'b11)
		period_cnt <= 'd0;
	else
		period_cnt <= period_cnt + 1'b1;
end
//****************************************************************************************  
//the fetch process
reg [`WIDTH]                   pc_addr_r;
always@(posedge i_sys_clk or negedge i_sys_rst)
begin
	if(i_sys_rst==1'b0)
		pc_addr_r <= 'd1;
	else if(i_if_stall==1'b1)
		pc_addr_r <= pc_addr_r;
	else if((period_cnt==2'b11)&&(i_flush_pc_req==1'b1))
		pc_addr_r <= i_flush_pc_target;
	else if(period_cnt == 2'b11)
		pc_addr_r <= (i_bpu_redir&(~i_bpu_btb_err)) ? i_bpu_target : (pc_addr_r + 32'd4);
	else
		pc_addr_r <= pc_addr_r;
end
//****************************************************************************************  
//enable signals
reg                           pc_valid;
reg                           instr_valid;
reg                           iram_req;
always@(posedge i_sys_clk or negedge i_sys_rst)
begin
	if(i_sys_rst==1'b0)
	begin
		pc_valid <= 'd0;
		instr_valid <= 'd0;
		iram_req <= 'd0;
	end
	else if(i_if_stall==1'b1)
	begin
		pc_valid <= 'd0;
		instr_valid <= 'd0;
		iram_req <= 'd0;
	end
	else if(period_cnt==2'b11)
	begin
		pc_valid <= 1'b1;
		iram_req <= 1'b1;
		instr_valid <= 1'b0;
	end
	else if(period_cnt==2'b00)
	begin	
		pc_valid <= 1'b0;
		iram_req <= 1'b0;
		instr_valid <= 1'b1;
	end
	else 
	begin
		pc_valid <= 'd0;
		instr_valid <= 'd0;
		iram_req <= 'd0;
	end
end
//****************************************************************************************  
//outputs
assign o_pc_req = iram_req;
assign o_pc_addr = pc_addr_r;
assign o_pc_instr = i_iram_instr;
assign o_pc_bpu_addr = pc_addr_r;
assign o_pc_addr_valid = pc_valid;
assign o_pc_instr_valid = instr_valid;

endmodule

