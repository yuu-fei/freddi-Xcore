///////////////////////////////////////////////////////////////////////////////
//
// Copyright Freddi, UESTC 
//
///////////////////////////////////////////////////////////////////////////////
`timescale 1ns / 1ps
//-----------------------------------------------------------------------------
//
// Project    : fifo SRAM 64 depth
// File       : fifo_ram_64.v
// Module     : fifo_ram_64.v(fifo_ram)
// Author     : Yufei Fu(fuyufei083X@gmail.com)
// Date       : 2022-12-20
// Version    : v1.0
// Description: 64 depth ram for syn and asyn fifo 
//				
//
// ----------------------------------------------------------------------------

module fifo_ram_64(
//input signals 
	input	[31:0]	d,
    input   [5:0]   dpra,
    input   [5:0]   a,
	input	     	ren,
	input			clk,
	input			wen,
	input 			rst,
	output	[31:0]	dpo
);

reg [31:0] reg_r[0:63];
reg	[31:0] dpo_r;
//**********************************************************************
//read process
always@(posedge clk or negedge rst)
 begin
	if(rst==1'b0) 
        begin
		dpo_r <= 'd0;
	    end
	else if(wen&ren) 
        begin 
		dpo_r <= d;
	    end
	else if(ren)
        begin
		dpo_r <= reg_r[dpra];
        end
    else
        dpo_r <= dpo_r;
end
//**********************************************************************
//write process
always@(posedge clk) begin
	if(wen) 
    begin
		reg_r[a] <= d;
	end
	else
		reg_r[a] <= reg_r[a];
end

assign dpo = dpo_r;

endmodule