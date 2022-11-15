/*************************************************************************
    > File Name: alu_sim.cpp
    > Author: Freddi Fu
    > Mail: fuyufei@126.com 
    > Created Time: Sun 13 Nov 2022 02:52:28 AM PST
 ************************************************************************/


#include<iostream>
#include"verilated.h"
#include"verilated_vcd_c.h"
#include"VXcore_exe_alu.h"
using namespace std;

VerilatedContext* contextp = NULL;
VerilatedVcdC* tfp = NULL;
static VXcore_exe_alu* top;
vluint64_t main_time = 0;
//single eval
void eval_and_dump_wave(){
	top->eval();
	contextp->timeInc(1);
	tfp->dump(main_time);
}
//single cycle of the clk
//void single_cycle() {
//  top->clk = 0; eval_and_dump_wave();
//  top->clk = 1; eval_and_dump_wave();
//}
//reset_n
//void reset(int n){
//   top->reset = 0;
//   while(n-->0) single_cycle();
//   top->reset = 1;
//}
//return time
double sc_time(){
	return main_time;
}
//sim init
void sim_init(){
	contextp = new VerilatedContext;
	tfp = new VerilatedVcdC;
	top = new VXcore_exe_alu;
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

//sim main function
int main(){
	sim_init();
	top->aluctrl=0;//first give a initial value to these ports (clk and rst)
	top->a_l =0;
	top->l_r =0;
	top->u_s=0;
	top->sub_add=0;
	top->data_a=0;
	top->data_b=0;
	//reset();
	while((!(main_time>120))&&(!Verilated::gotFinish())){ //here is the loop for simulation,it is recommended
//	to use random function to generate data signal for full test
	if(main_time<=20){
	top->aluctrl = 0;
	top->data_a = 0x000FF000;
	top->data_b = 0x000FF001;
	}
	else if((20<main_time)&&(main_time < 50)){
	top->aluctrl = 1;
    top->data_a = 0x000FF000;
    top->data_b = 0x000FF002;
    top->sub_add = 1;
	top->u_s = 1;
	}
	else if((50<=main_time)&&(main_time < 80)){
    top->aluctrl = 2;
	top->data_a = 0x000FF000;
	top->data_b = 0x000FF000;
    }
	else if((80<=main_time)&&(main_time < 100)){
	top->aluctrl = 3;
    top->data_a = 0x000FF000;
    top->data_b = 0x000FF000;
	top->sub_add = 0;
	top->u_s = 0;
	}
	else if((100<=main_time)&&(main_time < 110)){
	top->aluctrl = 4;
	top->data_a = 0x000FF000;
	top->data_b = 0x000F0F00;
	}
	else if((110<=main_time)&&(main_time < 115)){
	top->aluctrl = 5;
    top->data_a = 0x000FF000;
    top->data_b = 0x000FF000;
	}
	else if((115<=main_time)&&(main_time < 120)){
	top->aluctrl = 6;
	top->data_a = 0x000FF000;
	top->data_b = 0x000FF001;
	}
	else
	{
	top->aluctrl = 0;
	}
eval_and_dump_wave();
main_time++;
	}
	sim_exit();
}
