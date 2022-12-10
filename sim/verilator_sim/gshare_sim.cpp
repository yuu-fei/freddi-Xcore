/*///////////////////////////////////////////////////////////////////////////////////
> File Name: gshare_sim.cpp
> Version : 1.0
> Author: Freddi Fu
> mail: fuyufei083x@163.com
///////////////////////////////////////////////////////////////////////////*/
//> Created Time: Fri 09 Dec 2022 09:21:34 AM PST
#include<iostream>
using namespace std;
#include "verilated.h"
#include "verilated_vcd_c.h"
#include "VXcore_gshare_bpu.h"
//initialization
VerilatedContext* contextp = NULL;
VerilatedVcdC* tfp = NULL;
static VXcore_gshare_bpu* top;
vluint64_t main_time = 0;
//single eval
void eval_and_dump_wave(){
	top->eval();
	contextp->timeInc(1);
	tfp->dump(contextp->time());
}
//single cycle of the clk:
void single_cycle() {
  top->i_sys_clk = 0; eval_and_dump_wave();
  top->i_sys_clk = 1; eval_and_dump_wave();
}
//reset_n
void reset(int n){
   top->i_sys_rst = 0;
   while(n-->0) single_cycle();
   top->i_sys_rst = 1;
}
//return time
double sc_time(){
	return main_time;
}
//sim init
void sim_init(){
	contextp = new VerilatedContext;
	tfp = new VerilatedVcdC;
	top = new VXcore_gshare_bpu;
	contextp->traceEverOn(true);
	top->trace(tfp,0);
	tfp->open("dump.vcd");
}
//sim exit
void sim_exit(){
	eval_and_dump_wave();
	top->final();
	tfp->close();
	delete top;
}
int main(){//main simulation here
	sim_init();
	top->i_cmt_ghr = 0;
    top->i_cmt_req = 0;
    top->i_cmt_ghr_target = 0;
	top->i_cmt_ghr_val = 0;
	top->i_cmt_bits = 0;
    top->i_pref_pc_vld = 0;
    top->i_pref_instr_pc = 0;
    top->i_pref_instr_vld = 0;
    top->i_mdec_b = 0;
    top->i_mdec_jal = 0;
    top->i_mdec_jalr = 0;
    top->i_mdec_b_ofs = 0;
    top->i_mdec_jal_ofs = 0;
    top->i_mdec_jalr_ofs = 0;
	top->i_wb_instr_pc = 0;
	top->i_wb_cmt_type = 0;
	top->i_wb_cmt_target = 0;

	reset(10);
	while((!(main_time>100))&&(!Verilated::gotFinish())){ //here is the loop for simulation,it is recommended
//	to use random function to generate data signal for full test
	if(main_time<=30){
	//number = (rand()%(maxValue - minValue +1)) + minValue;
	top->i_cmt_ghr = (rand()% (1-0 + 1))+0;
    top->i_cmt_req = (rand()% (1-0 + 1))+0;
    top->i_cmt_ghr_target = (rand()% (1-0 + 1))+0;
	top->i_cmt_ghr_val = (rand()% (3-0 + 1))+0;
	top->i_cmt_bits = (rand()% (3-0 + 1))+0;
	top->i_wb_instr_pc = (rand()% (1023-0 + 1))+0;
	top->i_wb_cmt_type = (rand()% (7-0 + 1))+0;
	top->i_wb_cmt_target = (rand()% (1023-0 + 1))+0;
    top->i_pref_pc_vld = 1;
    top->i_pref_instr_pc = 0x000000FF;
    top->i_pref_instr_vld = 1;
    top->i_mdec_b = 1;
    top->i_mdec_jal = 0;
    top->i_mdec_jalr = 0;
    top->i_mdec_b_ofs = 0x000000FF;
    top->i_mdec_jal_ofs = 1;
    top->i_mdec_jalr_ofs = 1; 
	single_cycle();
	}
	else if((main_time>30)&&(main_time<=60))
	{
	top->i_cmt_ghr = (rand()% (1-0 + 1))+0;
    top->i_cmt_req = (rand()% (1-0 + 1))+0;
    top->i_cmt_ghr_target = (rand()% (1-0 + 1))+0;
	top->i_cmt_ghr_val = (rand()% (3-0 + 1))+0;
	top->i_cmt_bits = (rand()% (3-0 + 1))+0;
	top->i_wb_instr_pc = (rand()% (1023-0 + 1))+0;
	top->i_wb_cmt_type = (rand()% (7-0 + 1))+0;
	top->i_wb_cmt_target = (rand()% (1023-0 + 1))+0;
    top->i_pref_pc_vld = 1;
    top->i_pref_instr_pc = 0x000000FF;
    top->i_pref_instr_vld = 1;
    top->i_mdec_b = 0;
    top->i_mdec_jal = 1;
    top->i_mdec_jalr = 0;
    top->i_mdec_b_ofs = 1;
    top->i_mdec_jal_ofs = 0x000000FF;
    top->i_mdec_jalr_ofs = 1; 
	single_cycle();
	}
	else {
	top->i_cmt_ghr = (rand()% (1-0 + 1))+0;
    top->i_cmt_req = (rand()% (1-0 + 1))+0;
    top->i_cmt_ghr_target = (rand()% (1-0 + 1))+0;
	top->i_cmt_ghr_val = (rand()% (3-0 + 1))+0;
	top->i_cmt_bits = (rand()% (3-0 + 1))+0;
	top->i_wb_instr_pc = (rand()% (1023-0 + 1))+0;
	top->i_wb_cmt_type = (rand()% (7-0 + 1))+0;
	top->i_wb_cmt_target = (rand()% (1023-0 + 1))+0;
    top->i_pref_pc_vld = 1;
    top->i_pref_instr_pc = 0x000000FF;
    top->i_pref_instr_vld = 1;
    top->i_mdec_b = 0;
    top->i_mdec_jal = 0;
    top->i_mdec_jalr = 1;
    top->i_mdec_b_ofs = 1;
    top->i_mdec_jal_ofs = 1;
    top->i_mdec_jalr_ofs = 0x000000FF; 
	single_cycle();

	}
//eval_and_dump_wave();
main_time++;
	}
	sim_exit();
}
