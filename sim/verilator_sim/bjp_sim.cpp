/*///////////////////////////////////////////////////////////////////////////////////
> File Name: bjp_sim.cpp
> Version : 1.0
> Author: Freddi Fu
> mail: fuyufei083x@163.com
///////////////////////////////////////////////////////////////////////////*/
// Created Time: Fri 06 Jan 2023 08:04:07 PM PST
#include<iostream>
using namespace std;
#include"verilated.h"
#include"verilated_vcd_c.h"
#include"VXcore_mem_bjp.h"
//initialization
VerilatedContext* contextp = NULL;
VerilatedVcdC* tfp = NULL;
static VXcore_mem_bjp* top;
vluint64_t main_time = 0;
//singal eval
void eval_and_dump_wave(){
	top->eval();
	contextp->timeInc(1);
	tfp->dump(main_time);
}

double sc_time(){
 return main_time;
}

void sim_init(){
	contextp = new VerilatedContext;
	tfp = new VerilatedVcdC;
	top = new VXcore_mem_bjp;
	contextp->traceEverOn(true);
	top->trace(tfp,0);
	tfp->open("dump.vcd");
}

void sim_exit(){
	eval_and_dump_wave();
	top->final();
	tfp->close();
	delete top;
}

int main(){
	sim_init();
	top->i_ex_bjp_req=0;
	top->i_ex_b_req=0;
	top->i_ex_jal_req=0;
	top->i_ex_beq_req=0;
	top->i_ex_bne_req=0;
    top->i_ex_blt_req=0;
	top->i_ex_bgt_req=0;
	top->i_ex_blte_req=0;
	top->i_ex_bgte_req=0;
	top->i_ex_fencei_req=0;
	top->i_ex_alu_res=0;
	top->i_ex_alu_cmp_res=0;
	top->i_ex_instr_pc=0;
	top->i_ex_instr_deci=0;
	top->i_ex_bim_bits=0;
	while((!(main_time>50))&&(!Verilated::gotFinish())){
		if(main_time<=5){
	top->i_ex_bjp_req=(rand()% (1-0 + 1)) + 0;
	top->i_ex_b_req=0;
	top->i_ex_jal_req=1;
	top->i_ex_beq_req=0;
	top->i_ex_bne_req=0;
    top->i_ex_blt_req=0;
	top->i_ex_bgt_req=0;
	top->i_ex_blte_req=0;
	top->i_ex_bgte_req=0;
	top->i_ex_fencei_req=0;
	top->i_ex_alu_res=rand()% 1024 + 1;
	top->i_ex_alu_cmp_res=(rand()% (3-0 +1)) + 0;
	top->i_ex_instr_pc=rand()% 1024 + 1;
	top->i_ex_instr_deci=1;
	top->i_ex_bim_bits=2;
    }
		else if((main_time>5)&&(main_time<=10)){
	top->i_ex_bjp_req=(rand()% (1-0 + 1)) + 0;
	top->i_ex_b_req=1;
	top->i_ex_jal_req=0;
	top->i_ex_beq_req=1;
	top->i_ex_bne_req=0;
    top->i_ex_blt_req=0;
	top->i_ex_bgt_req=0;
	top->i_ex_blte_req=0;
	top->i_ex_bgte_req=0;
	top->i_ex_fencei_req=0;
	top->i_ex_alu_res=rand()% 1024 + 1;
	top->i_ex_alu_cmp_res=(rand()% (3-0 +1)) + 0;
	top->i_ex_instr_pc=rand()% 1024 + 1;
	top->i_ex_instr_deci=(rand()% (1-0 +1)) + 0;
	top->i_ex_bim_bits=rand()% 3 + 1;
	}
		else if((main_time>10)&&(main_time<=15)){
	top->i_ex_bjp_req=(rand()% (1-0 + 1) + 0);
	top->i_ex_b_req=1;
	top->i_ex_jal_req=0;
	top->i_ex_beq_req=0;
	top->i_ex_bne_req=1;
    top->i_ex_blt_req=0;
	top->i_ex_bgt_req=0;
	top->i_ex_blte_req=0;
	top->i_ex_bgte_req=0;
	top->i_ex_fencei_req=0;
	top->i_ex_alu_res=rand()% 1024 + 1;
	top->i_ex_alu_cmp_res=(rand()% (3-0 +1) + 0);
	top->i_ex_instr_pc=rand()% 1024 + 1;
	top->i_ex_instr_deci=(rand()% (1-0 +1)) + 0;
	top->i_ex_bim_bits=rand()% 3 + 1;
	}
		else if((main_time>15)&&(main_time<=20)){
	top->i_ex_bjp_req=(rand()% (1-0 + 1) + 0);
	top->i_ex_b_req=1;
	top->i_ex_jal_req=0;
	top->i_ex_beq_req=0;
	top->i_ex_bne_req=0;
    top->i_ex_blt_req=1;
	top->i_ex_bgt_req=0;
	top->i_ex_blte_req=0;
	top->i_ex_bgte_req=0;
	top->i_ex_fencei_req=0;
	top->i_ex_alu_res=rand()% 1024 + 1;
	top->i_ex_alu_cmp_res=(rand()% (3-0 +1) + 0);
	top->i_ex_instr_pc=rand()% 1024 + 1;
	top->i_ex_instr_deci=(rand()% (1-0 +1)) + 0;
	top->i_ex_bim_bits=rand()% 3 + 1;
	}
		else if((main_time>20)&&(main_time<=25)){
	top->i_ex_bjp_req=(rand()% (1-0 + 1) + 0);
	top->i_ex_b_req=1;
	top->i_ex_jal_req=0;
	top->i_ex_beq_req=0;
	top->i_ex_bne_req=0;
    top->i_ex_blt_req=0;
	top->i_ex_bgt_req=1;
	top->i_ex_blte_req=0;
	top->i_ex_bgte_req=0;
	top->i_ex_fencei_req=0;
	top->i_ex_alu_res=rand()% 1024 + 1;
	top->i_ex_alu_cmp_res=(rand()% (3-0 +1) + 0);
	top->i_ex_instr_pc=rand()% 1024 + 1;
	top->i_ex_instr_deci=(rand()% (1-0 +1)) + 0;
	top->i_ex_bim_bits=rand()% 3 + 1;
	}
		else if((main_time>25)&&(main_time<=30)){
	top->i_ex_bjp_req=(rand()% (1-0 + 1) + 0);
	top->i_ex_b_req=1;
	top->i_ex_jal_req=0;
	top->i_ex_beq_req=0;
	top->i_ex_bne_req=0;
    top->i_ex_blt_req=0;
	top->i_ex_bgt_req=0;
	top->i_ex_blte_req=1;
	top->i_ex_bgte_req=0;
	top->i_ex_fencei_req=0;
	top->i_ex_alu_res=rand()% 1024 + 1;
	top->i_ex_alu_cmp_res=(rand()% (3-0 +1) + 0);
	top->i_ex_instr_pc=rand()% 1024 + 1;
	top->i_ex_instr_deci=(rand()% (1-0 +1)) + 0;
	top->i_ex_bim_bits=rand()% 3 + 1;
	}
		else if((main_time>30)&&(main_time<=35)){
	top->i_ex_bjp_req=(rand()% (1-0 + 1) + 0);
	top->i_ex_b_req=1;
	top->i_ex_jal_req=0;
	top->i_ex_beq_req=0;
	top->i_ex_bne_req=0;
    top->i_ex_blt_req=0;
	top->i_ex_bgt_req=0;
	top->i_ex_blte_req=0;
	top->i_ex_bgte_req=1;
	top->i_ex_fencei_req=0;
	top->i_ex_alu_res=rand()% 1024 + 1;
	top->i_ex_alu_cmp_res=(rand()% (3-0 +1) + 0);
	top->i_ex_instr_pc=rand()% 1024 + 1;
	top->i_ex_instr_deci=(rand()% (1-0 +1)) + 0;
	top->i_ex_bim_bits=rand()% 3 + 1;
	}
		else if((main_time>35)&&(main_time<=40)){
	top->i_ex_bjp_req=(rand()% (1-0 + 1) + 0);
	top->i_ex_b_req=1;
	top->i_ex_jal_req=0;
	top->i_ex_beq_req=0;
	top->i_ex_bne_req=0;
    top->i_ex_blt_req=0;
	top->i_ex_bgt_req=0;
	top->i_ex_blte_req=0;
	top->i_ex_bgte_req=0;
	top->i_ex_fencei_req=1;
	top->i_ex_alu_res=rand()% 1024 + 1;
	top->i_ex_alu_cmp_res=(rand()% (3-0 +1) + 0);
	top->i_ex_instr_pc=rand()% 1024 + 1;
	top->i_ex_instr_deci=(rand()% (1-0 +1)) + 0;
	top->i_ex_bim_bits=rand()% 3 + 1;
	}
		else{
	top->i_ex_bjp_req=(rand()% (1-0 + 1) + 0);
	top->i_ex_b_req=1;
	top->i_ex_jal_req=1;
	top->i_ex_beq_req=0;
	top->i_ex_bne_req=1;
    top->i_ex_blt_req=1;
	top->i_ex_bgt_req=0;
	top->i_ex_blte_req=0;
	top->i_ex_bgte_req=0;
	top->i_ex_fencei_req=0;
	top->i_ex_alu_res=rand()% 1024 + 1;
	top->i_ex_alu_cmp_res=(rand()% (3-0 +1) + 0);
	top->i_ex_instr_pc=rand()% 1024 + 1;
	top->i_ex_instr_deci=(rand()% (1-0 +1)) + 0;
	top->i_ex_bim_bits=rand()% 3 + 1;
	}
		main_time++;
		eval_and_dump_wave();
	}
	sim_exit();
}


