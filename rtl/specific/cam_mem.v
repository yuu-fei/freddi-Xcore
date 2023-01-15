`timescale 1ns / 1ps
/*========================================FILE_HEADER=====================================
# Author:  Freddi Fu(fuyufei083x@163.com)
#
# Critical Timing: 2022-2023 -
#
# date: 2023-01-05 01:10
#
# Filename: cam_mem.v
#
# Module Name: cam_mem.v
#
# VERSION      LAST MODIFID    Instance Modules           DESCRIPTION
#   1.0       2022-1-5          sram                  the context addressable memory
#                                                     input data and check the address out
#
=========================================FILE_HEADER====================================*/
//`include"./rtl/include/params.v"
module cam_mem #(
	parameter CAM_DEPTH = 8,
	          CAM_WIDTH = 48,
			  CAM_PTR = 3
)
(
//input clk and signals
    input                    i_clk,
	input                    i_search, //search enable signal
	input  [CAM_WIDTH-1:0]   i_contents, //wirte data input
	input                    i_write_tocam, //wirte enavble signal (should add postfix 'en')
	input  [CAM_PTR-1:0]     i_wr_addr, // write adress(it is still a ram)
	input                    i_search_empty_loc, 
	input                    i_evict_one_loc,
//output signals
    output                   o_match,
	output [0:CAM_DEPTH-1]   o_valid_status,
	output [CAM_PTR-1:0]     o_match_adress,
	output                   o_got_empty_loc,
	output [CAM_PTR-1:0]     o_camaddr_empty,
	output [CAM_PTR-1:0]     o_camaddr_evict,
	output                   o_got_oneloc_evicted
);
//****************************************************************************************  
reg [(CAM_WIDTH-1):0]        cam [0:(CAM_DEPTH-1)];
reg [0:(CAM_DEPTH-1)]        valid_status; //data status valid or empty
reg [CAM_PTR-1:0]            camaddr_empty; //empty address 
reg [CAM_PTR-1:0]            match_address; // the match address information
reg                          match; //whether it is matched or not 
reg [CAM_PTR-1:0]            camaddr_evict; //full and choose an addr to update
reg                          got_oneloc_evicted;
reg                          got_empty_loc;
//****************************************************************************************  
//initialize the CAM
integer i;
always@(*)
begin
	for(i=0;i<CAM_DEPTH;i=i+1)
	begin
		valid_status[i] = 1'b0;
		cam[i] = 'd0;
	end
end
//****************************************************************************************  
//performs wirte to cam
always@(posedge i_clk)
begin
	if(i_write_tocam)
	begin
		cam[i_wr_addr] = i_contents;
		valid_status[i_wr_addr] = 1'b1;
	end
end
//****************************************************************************************  
//search for match address
integer j;
always@(posedge i_clk)
begin
	match = 1'b0;
	match_address = 'd0;
	if(i_search==1'b1)
	begin
		for(j=0;j<CAM_DEPTH;j=j+1)
		begin
			if((i_contents===cam[j])&&(!match))
			begin
				match = 1'b1;
				match_address = j;
			end
			else
			begin
				match = 1'b0;
			    match_address = 'd0;
			end
		end
	end
end
//****************************************************************************************  
//looke for empty location in the memory
always@(posedge i_clk)
begin
	if(i_search_empty_loc)
	begin
		if(!valid_status[0])
		begin
			got_empty_loc = 1'b1;
			camaddr_empty = 'd0;
		end
		if(!valid_status[1])
		begin
			got_empty_loc = 1'b1;
			camaddr_empty = 'd1;
		end
		if(!valid_status[2])
		begin
			got_empty_loc = 1'b1;
			camaddr_empty = 'd2;
		end
		if(!valid_status[3])
		begin
			got_empty_loc = 1'b1;
			camaddr_empty = 'd3;
		end
		if(!valid_status[4])
		begin
			got_empty_loc = 1'b1;
			camaddr_empty = 'd4;
		end
		if(!valid_status[5])
		begin
			got_empty_loc = 1'b1;
			camaddr_empty = 'd5;
		end
		if(!valid_status[6])
		begin
			got_empty_loc = 1'b1;
			camaddr_empty = 'd6;
		end
		if(!valid_status[7])
		begin
			got_empty_loc = 1'b1;
			camaddr_empty = 'd7;
		end
	end
	else
		got_empty_loc = 1'b0;
end
//****************************************************************************************  
//when cam is full it evicts a new empty place for data update
always@(posedge i_clk)
begin
	if(i_evict_one_loc)
	begin
		got_oneloc_evicted = 1'b1;
		camaddr_evict = ($random%CAM_DEPTH);
	end
	else
		got_oneloc_evicted = 1'b0;
end
//****************************************************************************************
//output
assign o_match = match;
assign o_match_adress = match_address;
assign o_valid_status = valid_status;
assign o_camaddr_empty = camaddr_empty;
assign o_got_empty_loc = got_empty_loc;
assign o_camaddr_evict = camaddr_evict;
assign o_got_oneloc_evicted = got_oneloc_evicted;

endmodule

