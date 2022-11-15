/*************************************************************************
    > File Name: regf_sim.cpp
    > Author: Freddi Fu
    > Mail: fuyufei083x@163.com 
    > Created Time: Sun 13 Nov 2022 10:50:39 PM PST
 ************************************************************************/

#include<iostream>
#include"verilated.h"
#include"verilated_vcd_c.h"
#include"VXcore_id_regf.h"
using namespace std;

VerilatedContext* contextp = NULL;
VerilatedVcdC* tfp = NULL;
static VXcore_id_regf* top;
vluint64_t main_time = 0;
//single eval
void eval_and_dump_wave(){
	top->eval();
	contextp->timeInc(1);
	tfp->dump(main_time);
}
//single cycle of the clk
void single_cycle() {
  top->regf_clk = !top->regf_clk; eval_and_dump_wave();
}
//reset_n
void reset(int n){
   while(n-->0) {
   top->regf_rst = 0;
   single_cycle();
   main_time++;
   }
   top->regf_rst = 1;
   single_cycle();
   main_time++;
}
//return time
double sc_time(){
	return main_time;
}
//sim init
void sim_init(){
	contextp = new VerilatedContext;
	tfp = new VerilatedVcdC;
	top = new VXcore_id_regf;
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
int main(){
	sim_init();
	top->instr_id_rs1 = 0;//first give a initial value to these ports (clk and rst)
	top->instr_id_rs2 = 0;
	top->id_wd = 0;
	top->regwrite = 0;
	top->id_write_data = 0;
	top->regf_clk = 0;
	reset(5);
	while((!(main_time>80))&&(!Verilated::gotFinish())){ //here is the loop for simulation,it is recommended
//	to use random function to generate data signal for full test
	if((main_time<=20)&&(main_time%2==0)){
	top->regwrite = 1;
	top->id_wd = rand()% 31 + 1;
	top->id_write_data = rand()% 15 + 1;
	}
	else if((20<=main_time)&&(main_time < 80)){
        top->regwrite = 0;
        top->id_wd = rand()% 31 + 1;
        top->instr_id_rs1 = rand()% 31 + 1;
        top->instr_id_rs2 = rand()% 31 + 1;
       }
	else
	{
	top->regwrite = top->regwrite;
	top->id_wd = top->id_wd;
	top->id_write_data = top->id_write_data;
	}
       single_cycle();
	main_time++;
	}
	sim_exit();
}
