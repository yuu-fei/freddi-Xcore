`timescale 1ns / 1ps
/*========================================FILE_HEADER=====================================
# Author:  Freddi Fu(fuyufei083x@163.com)
#
# Critical Timing: 2022-2023 -
#
# date: 2022-12-21 18:57
#
# Filename: Xcore_fifo_asyn.v
#
# Module Name: Xcore_fifo_asyn.v
#
# VERSION      LAST MODIFID    Instance Modules           DESCRIPTION
#   1.0       2022-12-10        fifo_bim_64_a.v         This is an asyn fifo with 64 depth
#
#
=========================================FILE_HEADER====================================*/

module Xcore_fifo_asyn #(
    parameter FIFO_DEPTH = 64,
	parameter FIFO_WIDTH = 32,
	parameter FIFO_PTR =   6
)
(
    //clk and rst input  
	input                        i_clk_r,
	input                        i_rst_r,
	input                        i_clk_w,
	input                        i_rst_w,
	//write and read enable signal 
	input                        i_write_en,
    input                        i_read_en,
	//write data 
	input  [FIFO_WIDTH-1:0]      i_data,
	//pointer control signals 
	input                        i_snapshot_wrptr, //whether we need to take a snapshot
	input                        i_rollback_wrptr, //whether the pointer should read back the snapshot
	input                        i_reset_wrptr, //reset the pointer
    input                        i_snapshot_rdptr, //control signals for the read pointer
	input                        i_rollback_rdptr,
	input                        i_reset_rdptr,
	//output 
	output [FIFO_WIDTH-1:0]      o_data,
	output                       o_fifo_full,
	output                       o_fifo_empty,
	output [FIFO_PTR:0]          o_data_avail,
	output [FIFO_PTR:0]          o_room_avail
);
    localparam FIFO_TWICEDAPTH_MINUS1 = (2*FIFO_DEPTH)-1;
//************************************************************************************************
    reg    [FIFO_PTR:0]          wr_ptr_wab;
	wire   [FIFO_PTR:0]          wr_ptr_wab_nxt; //extra wraparound bit
// this is the pointer used in the fifo
	reg    [FIFO_PTR:0]          room_avail;
	wire   [FIFO_PTR:0]          room_avail_nxt;
	reg    [FIFO_PTR:0]          data_avail;
	wire   [FIFO_PTR:0]          data_avail_nxt;
	reg    [FIFO_PTR:0]          wr_ptr_snapshot_value;
	wire   [FIFO_PTR:0]          wr_ptr_snapshot_value_nxt;
    reg                          fifo_full;
	wire                         fifo_full_nxt;
	reg                          fifo_empty;
	wire                         fifo_empty_nxt;
	reg    [FIFO_PTR:0]          rd_ptr_wab;
	wire   [FIFO_PTR:0]          rd_ptr_wab_nxt;
	reg    [FIFO_PTR:0]          rd_ptr_snapshot_value;
	wire   [FIFO_PTR:0]          rd_ptr_snapshot_value_nxt;
	wire   [FIFO_PTR-1:0]        wr_ptr;
	wire   [FIFO_PTR-1:0]        rd_ptr; // pointers without wraparound bit
//*************************************************************************************************
//write pointer logic
always@(*)
begin
	if(i_reset_wrptr) 
      wr_ptr_wab_nxt = 'd0;
    else if(i_rollback_wrptr)
		wr_ptr_wab_nxt = wr_ptr_snapshot_value;
	else if(i_write_en&&(wr_ptr_wab == FIFO_TWICEDAPTH_MINUS1))
		wr_ptr_wab_nxt = 'd0;
	else if(i_write_en)
		wr_ptr_wab_nxt = wr_ptr_wab + 1'b1;
	else 
		wr_ptr_wab_nxt = wr_ptr_wab;
end
//*************************************************************************************************
//take a snapshot of the write poniter that can be reload it later 
assign wr_ptr_snapshot_value_nxt =
	i_snapshot_wrptr ? wr_ptr_wab : wr_ptr_snapshot_value;
always@(posedge i_clk_w or negedge i_rst_w)
begin
	if(i_rst_w==1'b0)
	begin
		wr_ptr_wab <= 'd0;
		wr_ptr_snapshot_value <= 'd0;
	end
	else 
	begin
		wr_ptr_wab <= wr_ptr_wab_nxt;
		wr_ptr_snapshot_value <= wr_ptr_snapshot_value_nxt;
	end
end
//************************************************************************************************
//convert the write pointer into the gray code in the write domain (it is
//a combinational logic)
//but for standard design requirement we need a reg before the output
wire [FIFO_PTR:0] wr_ptr_wab_gray_nxt;
reg [FIFO_PTR:0] wr_ptr_wab_gray;
generate 
genvar i;
	for(i=0;i<=(FIFO_PTR);i=i+1)
	begin
		assign wr_ptr_wab_gray_nxt[i] = wr_ptr_wab_nxt[i]^wr_ptr_wab_nxt[i+1];
	end
endgenerate
always@(posedge i_clk_w or negedge i_rst_w)
begin
	if(i_rst_w==1'b0)
		wr_ptr_wab_gray <= 'd0;
	else 
		wr_ptr_wab_gray <= wr_ptr_wab_gray_nxt;
end
//************************************************************************************************
//synchronize the write gray code into the read domain
reg [FIFO_PTR:0] wr_ptr_wab_gray1;
reg [FIFO_PTR:0] wr_ptr_wab_gray2;
always@(posedge i_clk_r or negedge i_rst_r)
begin
	if(i_rst_r==1'b0)
	begin
		wr_ptr_wab_gray1 <= 'd0;
		wr_ptr_wab_gray2 <= 'd0;
	end
	else 
	begin
		wr_ptr_wab_gray1 <= wr_ptr_wab_gray;
		wr_ptr_wab_gray2 <= wr_ptr_wab_gray1;
	end
end
//************************************************************************************************
//convert the gray code into the binary code 
wire [FIFO_PTR:0] wr_ptr_wab_bin_nxt;
reg  [FIFO_PTR:0] wr_ptr_wab_bin;

genvar j;
generate 
	for(j=0;j<=FIFO_PTR;j=j+1)
	begin
        assign wr_ptr_wab_bin_nxt[j] = wr_ptr_wab_gray2[j]^wr_ptr_wab_bin_nxt[j+1];
	end
endgenerate
always@(posedge i_clk_r or negedge i_rst_r)
begin
	if(i_rst_r==1'b0)
		wr_ptr_wab_bin <= 'd0;
	else 
		wr_ptr_wab_bin <= wr_ptr_wab_bin_nxt;
end
//************************************************************************************************
//read pointer control logic
always@(*)
begin
	if(i_reset_rdptr) 
      rd_ptr_wab_nxt = 'd0;
    else if(i_rollback_rdptr)
		rd_ptr_wab_nxt = rd_ptr_snapshot_value;
	else if(i_read_en&&(rd_ptr_wab == FIFO_TWICEDAPTH_MINUS1))
		rd_ptr_wab_nxt = 'd0;
	else if(i_read_en)
		rd_ptr_wab_nxt = rd_ptr_wab + 1'b1;
	else 
		rd_ptr_wab_nxt = rd_ptr_wab;
end
//************************************************************************************************
//read pointer snapshot
assign rd_ptr_snapshot_value_nxt =
	i_snapshot_rdptr ? rd_ptr_wab : rd_ptr_snapshot_value;
always@(posedge i_clk_r or negedge i_rst_r)
begin
	if(i_rst_r==1'b0)
	begin
		rd_ptr_wab <= 'd0;
		rd_ptr_snapshot_value <= 'd0;
	end
	else 
	begin
		rd_ptr_wab <= rd_ptr_wab_nxt;
		rd_ptr_snapshot_value <= rd_ptr_snapshot_value_nxt;
	end
end
//************************************************************************************************
//conversion
wire [FIFO_PTR:0] rd_ptr_wab_gray_nxt;
reg [FIFO_PTR:0] rd_ptr_wab_gray;
generate 
genvar k;
	for(k=0;k<=(FIFO_PTR);k=k+1)
	begin
		assign rd_ptr_wab_gray_nxt[k] = rd_ptr_wab_nxt[k]^rd_ptr_wab_nxt[k+1];
	end
endgenerate
always@(posedge i_clk_r or negedge i_rst_r)
begin
	if(i_rst_r==1'b0)
		rd_ptr_wab_gray <= 'd0;
	else 
		rd_ptr_wab_gray <= rd_ptr_wab_gray_nxt;
end
//************************************************************************************************
//synchronize the read gray code into the wirte domain
reg [FIFO_PTR:0] rd_ptr_wab_gray1;
reg [FIFO_PTR:0] rd_ptr_wab_gray2;
always@(posedge i_clk_w or negedge i_rst_w)
begin
	if(i_rst_w==1'b0)
	begin
		rd_ptr_wab_gray1 <= 'd0;
		rd_ptr_wab_gray2 <= 'd0;
	end
	else 
	begin
		rd_ptr_wab_gray1 <= rd_ptr_wab_gray;
		rd_ptr_wab_gray2 <= rd_ptr_wab_gray1;
	end
end
//************************************************************************************************
//convert the gray code into the binary code 
wire [FIFO_PTR:0] rd_ptr_wab_bin_nxt;
reg  [FIFO_PTR:0] rd_ptr_wab_bin;

generate 
genvar m;
	for(m=0;m<=FIFO_PTR;m=m+1)
	begin
        assign rd_ptr_wab_bin_nxt[m] = rd_ptr_wab_gray2[m]^rd_ptr_wab_bin_nxt[m+1];
	end
endgenerate
always@(posedge i_clk_w or negedge i_rst_w)
begin
	if(i_rst_w==1'b0)
		rd_ptr_wab_bin <= 'd0;
	else 
		rd_ptr_wab_bin <= rd_ptr_wab_bin_nxt;
end
//get the pointers without the wraparound bit
assign wr_ptr = wr_ptr_wab[FIFO_PTR-1:0];
assign rd_ptr = rd_ptr_wab[FIFO_PTR-1:0];
//************************************************************************************************

//SRAM instantiation
fifo_bim_64_a fifo_bim_64_a_u(
    .wrclk(i_clk_w),
	.wr_data(i_data),
	.wren(i_write_en),
	.wr_ptr(wr_ptr),
	.rdclk(i_clk_r),
	.rden(i_read_en),
	.rd_ptr(rd_ptr),
	.rd_data(o_data),
	.rd_rst(i_rst_r)
);
//************************************************************************************************
//generate fifo_full
assign fifo_full_nxt = (wr_ptr_wab[FIFO_PTR]!=rd_ptr_wab_bin[FIFO_PTR]) &&
	(wr_ptr_wab[FIFO_PTR-1:0]==rd_ptr_wab_bin[FIFO_PTR-1:0]);
assign room_avail_nxt = (wr_ptr_wab[FIFO_PTR]==rd_ptr_wab_bin[FIFO_PTR]) ?
	(FIFO_DEPTH - (wr_ptr_wab[FIFO_PTR-1:0]-rd_ptr_wab_bin[FIFO_PTR-1:0])) :/*why choose read room 
	information here? because you can get a room information with redundancy space*/
	(rd_ptr_wab_bin[FIFO_PTR-1:0]- wr_ptr_wab[FIFO_PTR-1:0]);
//generate fifo_empty
assign fifo_empty_nxt = (rd_ptr_wab[FIFO_PTR:0]==wr_ptr_wab_bin[FIFO_PTR:0]);
assign data_avail_nxt = (rd_ptr_wab[FIFO_PTR]==wr_ptr_wab_bin[FIFO_PTR]) ?
	(wr_ptr_wab_bin[FIFO_PTR-1:0] - rd_ptr_wab[FIFO_PTR-1:0]) :
	(FIFO_DEPTH - (rd_ptr_wab[FIFO_PTR-1:0]-wr_ptr_wab_bin[FIFO_PTR-1:0]));
always@(posedge i_clk_w or negedge i_rst_w)
begin
	if(i_rst_w==1'b0)
	begin
		fifo_full <= 'd0;
	    room_avail <= 'd0;
	end
	else
	begin
		fifo_full <= fifo_full_nxt;
	    room_avail <= room_avail_nxt;
	end
end
always@(posedge i_clk_r or negedge i_rst_r)
begin
	if(i_rst_r==1'b0)
	begin
		fifo_empty <= 'd0;
		data_avail <= 'd0;
	end
	else
	begin
		fifo_empty <= fifo_full_nxt;
		data_avail <= data_avail_nxt;
	end
end
//*************************************************************************************************
assign o_fifo_full = fifo_full;
assign o_room_avail = room_avail;
assign o_fifo_empty = fifo_empty;
assign o_data_avail = data_avail;

endmodule

