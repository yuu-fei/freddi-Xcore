///////////////////////////////////////////////////////////////////////////////
//
// Copyright Freddi, UESTC 
//
///////////////////////////////////////////////////////////////////////////////
`timescale 1ns / 1ps
//-----------------------------------------------------------------------------
//
// Project    : Xcore btb ram 128
// File       : btb_ram_128.v
// Module     : btb_ram_128.v(btb_ram)
// Author     : Yufei Fu(fuyufei083X@gmail.com)
// Date       : 2022-11-20
// Version    : v1.0
// Description: btb_ram_ 128 
//				
//
// ----------------------------------------------------------------------------

module btb_ram_128(
	input	[6:0]	a,
	input	[35:0]	d,
	input	[6:0]	dpra,
	input			clk,
	input			we,
	input 			rst,
	output	[35:0]	dpo
);

reg [35:0] reg_r[0:127];
reg	[35:0] dpo_o;
//read process
always@(posedge clk) begin
	if(!rst) begin
		dpo_o <= 'd0;
		end
		else begin
	if(we&(dpra==a)) begin
		dpo_o <= d;
	end
	else
		dpo_o <= reg_r[dpra];
end
end
//write process
always@(posedge clk) begin
	if(we) begin
		reg_r[a] <= d;
	end
	else
		reg_r[a] <= reg_r[a];
end

assign dpo = dpo_o;

endmodule

