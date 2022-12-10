/*///////////////////////////////////////////////////////////////////////////////////
> File Name: Gbpu_sim.cpp
> Version : 1.0
> Author: Freddi Fu
> mail: fuyufei083x@163.com
///////////////////////////////////////////////////////////////////////////*/
// Created Time: Sun 04 Dec 2022 09:25:14 PM PST
#include<iostream>
using namespace std;
#include "verilated.h"
#include "verilated_vcd_c.h"
#include "VXcore_if_bpu.h"
//initialization
VerilatedContext* contextp = NULL;
VerilatedVcdC* tfp = NULL;
static VXcore_if_bpu* top;
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
	top = new VXcore_if_bpu;
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
	top->i_btb_target = 0;
    top->i_btb_type = 0;
    top->i_btb_hit = 0;
    top->i_bim_bits = 0;
    top->i_pref_pc_vld = 0;
    top->i_pref_instr_pc = 0;
    top->i_pref_instr_vld = 0;
    top->i_mdec_b = 0;
    top->i_mdec_jal = 0;
    top->i_mdec_jalr = 0;
    top->i_mdec_b_ofs = 0;
    top->i_mdec_jal_ofs = 0;
    top->i_mdec_jalr_ofs = 0; 
	

	reset(10);
	while((!(main_time>100))&&(!Verilated::gotFinish())){ //here is the loop for simulation,it is recommended
//	to use random function to generate data signal for full test
	if(main_time<=30){
	//number = (rand()%(maxValue - minValue +1)) + minValue;
	top->i_btb_target = rand()% 0xFFFFFFFF + 1;
    top->i_btb_type = rand()% 7 + 1;
    top->i_btb_hit = (rand()% (1-0 + 1) )+ 0;
    top->i_bim_bits = (rand()% (3-0 + 1)) + 0;
    top->i_pref_pc_vld = 1;
    top->i_pref_instr_pc = 0x000FF000;
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
	top->i_btb_target = rand()% 0xFFFFFFFF + 1;
    top->i_btb_type = rand()% 7 + 1;
    top->i_btb_hit = (rand()% (1 -0 + 1)) + 0;
    top->i_bim_bits = (rand()% (3-0 + 1)) + 0;
    top->i_pref_pc_vld = 1;
    top->i_pref_instr_pc = 0x000FF000;
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
	top->i_btb_target = rand()% 0xFFFFFFFF + 1;
    top->i_btb_type = rand()% 7 + 1;
    top->i_btb_hit = rand()% 1 + 1;
    top->i_bim_bits = rand()% 3 + 1;
    top->i_pref_pc_vld = 1;
    top->i_pref_instr_pc = 0x000FF000;
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


