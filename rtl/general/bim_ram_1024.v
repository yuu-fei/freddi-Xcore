///////////////////////////////////////////////////////////////////////////////
//
// Copyright Freddi, UESTC 
//
///////////////////////////////////////////////////////////////////////////////
`timescale 1ns / 1ps
//-----------------------------------------------------------------------------
//
// Project    : Xcore bim ram 1024
// File       : bim_ram_1024.v
// Module     : bim_ram-1024.v(bim_ram)
// Author     : Yufei Fu(fuyufei083X@gmail.com)
// Date       : 2022-11-20
// Version    : v1.0
// Description: bim_ram 1024 
//				
//
// ----------------------------------------------------------------------------

module bim_ram_1024(
	input	[9:0]	a,
	input	[1:0]	d,
	input	[9:0]	dpra,
	input			clk,
	input			qdpo_clk,
	input			we,
	input 			rst,
	output	[1:0]	bim_bits
);

reg [1:0] reg_r[0:1023];
reg	[1:0] bim_bits_o;
//read process
always@(posedge qdpo_clk) begin
	if (!rst) begin
		bim_bits_o<='d0;
		end
		else  begin
	if(we&(dpra==a)) begin
		bim_bits_o <= d;
	end
	else
		bim_bits_o <= reg_r[dpra];
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

assign bim_bits = bim_bits_o;

endmodule

