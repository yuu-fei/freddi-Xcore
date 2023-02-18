// Verilated -*- C++ -*-
// DESCRIPTION: Verilator output: Tracing implementation internals
#include "verilated_vcd_c.h"
#include "VXcore_if_mdec__Syms.h"


VL_ATTR_COLD void VXcore_if_mdec___024root__trace_init_sub__TOP__0(VXcore_if_mdec___024root* vlSelf, VerilatedVcd* tracep) {
    if (false && vlSelf) {}  // Prevent unused
    VXcore_if_mdec__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    VXcore_if_mdec___024root__trace_init_sub__TOP__0\n"); );
    // Init
    const int c = vlSymsp->__Vm_baseCode;
    // Body
    tracep->declBus(c+1,"i_pref_instr", false,-1, 31,0);
    tracep->declBit(c+2,"i_pc_instr_vld", false,-1);
    tracep->declBit(c+3,"o_mdec_b", false,-1);
    tracep->declBit(c+4,"o_mdec_jal", false,-1);
    tracep->declBit(c+5,"o_mdec_jalr", false,-1);
    tracep->declBus(c+6,"o_mdec_b_ofs", false,-1, 31,0);
    tracep->declBus(c+7,"o_mdec_jal_ofs", false,-1, 31,0);
    tracep->declBus(c+8,"o_mdec_jalr_ofs", false,-1, 31,0);
    tracep->declBit(c+9,"o_mdec_instr_vld", false,-1);
    tracep->pushNamePrefix("Xcore_if_mdec ");
    tracep->declBus(c+1,"i_pref_instr", false,-1, 31,0);
    tracep->declBit(c+2,"i_pc_instr_vld", false,-1);
    tracep->declBit(c+3,"o_mdec_b", false,-1);
    tracep->declBit(c+4,"o_mdec_jal", false,-1);
    tracep->declBit(c+5,"o_mdec_jalr", false,-1);
    tracep->declBus(c+6,"o_mdec_b_ofs", false,-1, 31,0);
    tracep->declBus(c+7,"o_mdec_jal_ofs", false,-1, 31,0);
    tracep->declBus(c+8,"o_mdec_jalr_ofs", false,-1, 31,0);
    tracep->declBit(c+9,"o_mdec_instr_vld", false,-1);
    tracep->declBus(c+10,"opcode", false,-1, 6,0);
    tracep->declBus(c+11,"funct3", false,-1, 2,0);
    tracep->declBus(c+12,"rd", false,-1, 4,0);
    tracep->declBus(c+13,"rs1", false,-1, 4,0);
    tracep->declBit(c+5,"predec_jalr", false,-1);
    tracep->declBit(c+3,"predec_b", false,-1);
    tracep->declBit(c+4,"predec_jal", false,-1);
    tracep->declBus(c+6,"predec_b_ofs", false,-1, 31,0);
    tracep->declBus(c+7,"predec_jal_ofs", false,-1, 31,0);
    tracep->declBus(c+8,"predec_jalr_ofs", false,-1, 31,0);
    tracep->popNamePrefix(1);
}

VL_ATTR_COLD void VXcore_if_mdec___024root__trace_init_top(VXcore_if_mdec___024root* vlSelf, VerilatedVcd* tracep) {
    if (false && vlSelf) {}  // Prevent unused
    VXcore_if_mdec__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    VXcore_if_mdec___024root__trace_init_top\n"); );
    // Body
    VXcore_if_mdec___024root__trace_init_sub__TOP__0(vlSelf, tracep);
}

VL_ATTR_COLD void VXcore_if_mdec___024root__trace_full_top_0(void* voidSelf, VerilatedVcd::Buffer* bufp);
void VXcore_if_mdec___024root__trace_chg_top_0(void* voidSelf, VerilatedVcd::Buffer* bufp);
void VXcore_if_mdec___024root__trace_cleanup(void* voidSelf, VerilatedVcd* /*unused*/);

VL_ATTR_COLD void VXcore_if_mdec___024root__trace_register(VXcore_if_mdec___024root* vlSelf, VerilatedVcd* tracep) {
    if (false && vlSelf) {}  // Prevent unused
    VXcore_if_mdec__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    VXcore_if_mdec___024root__trace_register\n"); );
    // Body
    tracep->addFullCb(&VXcore_if_mdec___024root__trace_full_top_0, vlSelf);
    tracep->addChgCb(&VXcore_if_mdec___024root__trace_chg_top_0, vlSelf);
    tracep->addCleanupCb(&VXcore_if_mdec___024root__trace_cleanup, vlSelf);
}

VL_ATTR_COLD void VXcore_if_mdec___024root__trace_full_sub_0(VXcore_if_mdec___024root* vlSelf, VerilatedVcd::Buffer* bufp);

VL_ATTR_COLD void VXcore_if_mdec___024root__trace_full_top_0(void* voidSelf, VerilatedVcd::Buffer* bufp) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    VXcore_if_mdec___024root__trace_full_top_0\n"); );
    // Init
    VXcore_if_mdec___024root* const __restrict vlSelf VL_ATTR_UNUSED = static_cast<VXcore_if_mdec___024root*>(voidSelf);
    VXcore_if_mdec__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    // Body
    VXcore_if_mdec___024root__trace_full_sub_0((&vlSymsp->TOP), bufp);
}

VL_ATTR_COLD void VXcore_if_mdec___024root__trace_full_sub_0(VXcore_if_mdec___024root* vlSelf, VerilatedVcd::Buffer* bufp) {
    if (false && vlSelf) {}  // Prevent unused
    VXcore_if_mdec__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    VXcore_if_mdec___024root__trace_full_sub_0\n"); );
    // Init
    uint32_t* const oldp VL_ATTR_UNUSED = bufp->oldp(vlSymsp->__Vm_baseCode);
    // Body
    bufp->fullIData(oldp+1,(vlSelf->i_pref_instr),32);
    bufp->fullBit(oldp+2,(vlSelf->i_pc_instr_vld));
    bufp->fullBit(oldp+3,(vlSelf->o_mdec_b));
    bufp->fullBit(oldp+4,(vlSelf->o_mdec_jal));
    bufp->fullBit(oldp+5,(vlSelf->o_mdec_jalr));
    bufp->fullIData(oldp+6,(vlSelf->o_mdec_b_ofs),32);
    bufp->fullIData(oldp+7,(vlSelf->o_mdec_jal_ofs),32);
    bufp->fullIData(oldp+8,(vlSelf->o_mdec_jalr_ofs),32);
    bufp->fullBit(oldp+9,(vlSelf->o_mdec_instr_vld));
    bufp->fullCData(oldp+10,((0x7fU & vlSelf->i_pref_instr)),7);
    bufp->fullCData(oldp+11,((7U & (vlSelf->i_pref_instr 
                                    >> 0xcU))),3);
    bufp->fullCData(oldp+12,((0x1fU & (vlSelf->i_pref_instr 
                                       >> 7U))),5);
    bufp->fullCData(oldp+13,((0x1fU & (vlSelf->i_pref_instr 
                                       >> 0xfU))),5);
}
