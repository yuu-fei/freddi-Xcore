`timescale 1ns / 1ps
/*========================================FILE_HEADER=====================================
# Author:  Freddi Fu
#
# Critical Timing: 2022-2023 -
#
# date: 2022-12-14 18:56
#
# Filename: Xcore_fifo_syn.v
#
# Description: Xcore_fifo_syn.v
#
# VERSION      LAST MODIFID    AUTHOR           DESCRIPTION
#   1.0           2022-12-10  Freddi Fu         writesomethinghere
#
#
=========================================FILE_HEADER====================================*/
`include"./rtl/include/params.v"
module Xcore_fifo_syn #(
	parameter FIFO_PTR = 6, //fifo pointer width
	parameter FIFO_DEPTH = 64, //fifo depth
	parameter FIFO_WIDTH = 32 //fifo data width
)
(
	//input clk rst 
	input		        	i_sys_clk,
	input		        	i_sys_rst,
	//data input    
    input  [FIFO_WIDTH-1:0] i_data,
	//write and read enable signals
	input                   i_write_en,
	input                   i_read_en,
	//data output
	output [FIFO_WIDTH-1:0] o_data,
	output                  o_fifo_empty,
	output                  o_fifo_full,
	output [FIFO_PTR:0]     o_room_avail,
	output [FIFO_PTR:0]     o_data_avail              
);
    localparam FIFO_DEPTH_MINUS1 = FIFO_DEPTH -1;//as there is zero adress so it is the maximum adress
	/*the signals are called based on the order in which the name was given
	rather than the order in which it was used*/ 
	//write and read pointers
	reg  [FIFO_PTR-1:0]   write_ptr;
	reg  [FIFO_PTR-1:0]   read_ptr; //you need reg type to store information
	wire [FIFO_PTR-1:0]   write_ptr_nxt;
	wire [FIFO_PTR-1:0]   read_ptr_nxt;
	//other useful information
	reg  [FIFO_PTR:0]     num_entries;
	wire [FIFO_PTR:0]     num_entries_nxt;
	reg                   fifo_empty,fifo_full;
	wire                  fifo_empty_nxt,fifo_full_nxt;
	reg  [FIFO_PTR:0]     fifo_room_avail;
	wire [FIFO_PTR:0]     fifo_room_avail_nxt;
	wire [FIFO_PTR:0]     fifo_data_avail;
//******************************************************************************************
//write-pointer control logic
always@(*)   
begin //combinational logic block and we write in the always block
	if(i_write_en)
	begin
		if(write_ptr==FIFO_DEPTH_MINUS1)
			write_ptr_nxt = 'd0;
		else
			write_ptr_nxt = write_ptr + 1'b1;
	end
	else
	begin
		write_ptr_nxt = write_ptr;
	end
end
//******************************************************************************************
//read-pointer control logic
always@(*) begin
	if(i_read_en)
	begin
		if(read_ptr==FIFO_DEPTH_MINUS1)
			read_ptr_nxt = 'd0;
		else
			read_ptr_nxt = read_ptr + 1'b1;
	end
	else
	begin
		read_ptr_nxt = read_ptr;
	end
end
//*****************************************************************************************
//it is better you fill this blank row with such kind  of a notation
//Calculate number of occupied entries in the fifo
always@(*)
begin
	if(i_write_en&&i_read_en)
		num_entries_nxt = num_entries;
	else if(i_write_en&&(!i_read_en))
		num_entries_nxt = num_entries + 1'b1;
	else if((!i_write_en)&&i_read_en)
		num_entries_nxt = num_entries - 1'b1;
	else 
		num_entries_nxt = num_entries;
end

assign fifo_empty_nxt = (num_entries_nxt=='d0);
assign fifo_full_nxt = (num_entries_nxt==FIFO_DEPTH);
assign fifo_room_avail_nxt = (FIFO_DEPTH-num_entries_nxt);
assign fifo_data_avail = num_entries;
//*********************************************************************************
always@(posedge i_sys_clk or negedge i_sys_rst)
begin
	if(i_sys_rst==1'b0) 
	begin
		write_ptr <= 'd0;
		read_ptr <= 'd0;
		num_entries <= 'd0;
		fifo_full <= 1'b0;
		fifo_empty <= 1'b1;
		fifo_room_avail <= FIFO_DEPTH;
	end
	else
	begin
		write_ptr <= write_ptr_nxt;
		read_ptr <= read_ptr_nxt;
        num_entries <= num_entries_nxt;
		fifo_full <= fifo_full_nxt;
		fifo_empty <= fifo_empty_nxt;
		fifo_room_avail <= fifo_room_avail_nxt;
	end
end
//*********************************************************************************
//SRAM instance
fifo_ram_64  u_fifo_ram_64 (
    .d                       ( i_data      ),
    .dpra                    ( read_ptr   ),
    .a                       ( write_ptr      ),
    .ren                     ( i_read_en    ),
    .clk                     ( i_sys_clk    ),
    .wen                     ( i_write_en    ),
    .rst                     ( i_sys_rst    ),
    .dpo                     ( o_data    )
);
assign o_fifo_full = fifo_full;
assign o_fifo_empty = fifo_empty;
assign o_room_avail = fifo_room_avail;
assign o_data_avail = fifo_data_avail;

endmodule

