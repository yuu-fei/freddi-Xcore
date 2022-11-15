////////////////////////////////////////////////////////////////////////////////////////
//  date: 2022/11/8
//  author : YUfei Fu
//  email: yufei083X@gmail.com
//
//  this is the testbench of moudle Xcore_mux4
//  ////////////////////////////////////////////////////////////////////////////////////
`timescale 1ns/1ps

module mux4_test();

reg signal0, signal1, signal2, signal3, scl, dir_en;
wire dout;

//stantiate
Xcore_mux4 tb(
	.signal0(signal0),
	.signal1(signal1),
	.signal2(signal2),
	.signal3(signal3),
	.scl(scl),
	.dir_en(dir_en),
	.mux_out(dout)
);

initial begin
	$dumpfile("dump.vcd");
	$dumpvars(0,tb);
end

task run;
	begin
		signal0<='d0;
		signal1<='d0;
		signal2<='d0;
		signal3<='d0;
		scl<='d0;
		dir_en<='d0;
		#10 signal3<=1'd1;
		#10 scl<=1'd1; dir_en<=1'd1;
		#10 if(dout==1'b1) begin
			$display("one round simulation passed!!!");
		end
		#10 dir_en<=1'd0;
		#10 if(dout==1'b0) begin
			$display("second round simulation passed!!!");
		end
		#10 scl<=1'd0; dir_en<=1'd1;
		#10 signal1<=1'd1;
		#10 if(dout==1'b1) begin
			$display("third round simulation passed!!!");
		end
		#10 dir_en<=1'd0;
		signal2<=1'd1;
		signal0<=1'd1;
		#10 if(dout==1'b1) begin
			$display("fourth round simulation passed!!!");
		end
	end
endtask

initial begin
	run();
	#10 $stop;
	end
	endmodule

