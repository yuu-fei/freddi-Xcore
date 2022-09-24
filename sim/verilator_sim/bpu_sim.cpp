/*************************************************************************
    > File Name: bpu_sim.cpp
    > Author: Freedi Fu
    > Mail: yufei083x@gmail.com 
    > Created Time: Tue 24 Sep 2022 20:39:11 PM PDT
 ************************************************************************/

#include<iostream>
#include "verilated.h"
#include "verilated_vcd_c.h"
#include "VXcore_bpu.h"
using namespace std;
//initialization
VerilatedContext* contextp = NULL;
VerilatedVcdC* tfp = NULL;
static VXcore_bpu* top;
vluint64_t main_time = 0;
//single eval
void eval_and_dump_wave(){
	top->eval();
	contextp->timeInc(1);
	tfp->dump(contextp->time());
}
//single cycle of the clk: 
void single_cycle() {
  top->bpu_clk = 0; eval_and_dump_wave();
  top->bpu_clk = 1; eval_and_dump_wave();
}
//reset_n
void reset(int n){
   top->bpu_rst = 0;
   while(n-->0) single_cycle();
   top->bpu_rst = 1;
}
//return time
double sc_time(){
	return main_time;
}
//sim init
void sim_init(){
	contextp = new VerilatedContext;
	tfp = new VerilatedVcdC;
	top = new VXcore_bpu;
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
	top->cur_instr_pc = 0;
	top->flush_valid = 0;
	top->stall_valid = 0;
	top->cur_instr_op = 0;
	top->instr_jar_off = 0;
	top->instr_b_off = 0;
	top->bpu_rst = 0;
	
	//reset();
	while((!(main_time>500))&&(!Verilated::gotFinish())){ //here is the loop for simulation,it is recommended
//	to use random function to generate data signal for full test
	top->bpu_rst=1;
	if(main_time<=450){
	//number = (rand()%(maxValue - minValue +1)) + minValue;
	top->cur_instr_pc = (rand() % (0xF0FFFFFF - 0x00FFFFFF +1)) + 0x00FFFFFF;
	top->flush_valid = 0;
    top->stall_valid = 0;
    top->cur_instr_op = rand() % 127 + 1; 
    top->instr_jar_off = rand() % 4095 + 1;
    top->instr_b_off = rand() % 4095 + 1;
	single_cycle();
	}
	else
	{
	top->cur_instr_pc = (rand() % (0xF0FFFFFF - 0x00FFFFFF +1)) + 0x00FFFFFF;
	top->flush_valid = 0;
	top->stall_valid = 1;
	top->cur_instr_op = rand() % 127 + 1;
	top->instr_jar_off = rand() % 4095 + 1;
	top->instr_b_off = rand() % 4095 + 1;
	top->bpu_clk = ~top->bpu_clk;
	single_cycle();
	}
//eval_and_dump_wave();
main_time++;
	}
	sim_exit();
}

