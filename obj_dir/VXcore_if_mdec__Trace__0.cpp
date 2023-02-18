// Verilated -*- C++ -*-
// DESCRIPTION: Verilator output: Tracing implementation internals
#include "verilated_vcd_c.h"
#include "VXcore_if_mdec__Syms.h"


void VXcore_if_mdec___024root__trace_chg_sub_0(VXcore_if_mdec___024root* vlSelf, VerilatedVcd::Buffer* bufp);

void VXcore_if_mdec___024root__trace_chg_top_0(void* voidSelf, VerilatedVcd::Buffer* bufp) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    VXcore_if_mdec___024root__trace_chg_top_0\n"); );
    // Init
    VXcore_if_mdec___024root* const __restrict vlSelf VL_ATTR_UNUSED = static_cast<VXcore_if_mdec___024root*>(voidSelf);
    VXcore_if_mdec__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    if (VL_UNLIKELY(!vlSymsp->__Vm_activity)) return;
    // Body
    VXcore_if_mdec___024root__trace_chg_sub_0((&vlSymsp->TOP), bufp);
}

void VXcore_if_mdec___024root__trace_chg_sub_0(VXcore_if_mdec___024root* vlSelf, VerilatedVcd::Buffer* bufp) {
    if (false && vlSelf) {}  // Prevent unused
    VXcore_if_mdec__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    VXcore_if_mdec___024root__trace_chg_sub_0\n"); );
    // Init
    uint32_t* const oldp VL_ATTR_UNUSED = bufp->oldp(vlSymsp->__Vm_baseCode + 1);
    // Body
    bufp->chgIData(oldp+0,(vlSelf->i_pref_instr),32);
    bufp->chgBit(oldp+1,(vlSelf->i_pc_instr_vld));
    bufp->chgBit(oldp+2,(vlSelf->o_mdec_b));
    bufp->chgBit(oldp+3,(vlSelf->o_mdec_jal));
    bufp->chgBit(oldp+4,(vlSelf->o_mdec_jalr));
    bufp->chgIData(oldp+5,(vlSelf->o_mdec_b_ofs),32);
    bufp->chgIData(oldp+6,(vlSelf->o_mdec_jal_ofs),32);
    bufp->chgIData(oldp+7,(vlSelf->o_mdec_jalr_ofs),32);
    bufp->chgBit(oldp+8,(vlSelf->o_mdec_instr_vld));
    bufp->chgCData(oldp+9,((0x7fU & vlSelf->i_pref_instr)),7);
    bufp->chgCData(oldp+10,((7U & (vlSelf->i_pref_instr 
                                   >> 0xcU))),3);
    bufp->chgCData(oldp+11,((0x1fU & (vlSelf->i_pref_instr 
                                      >> 7U))),5);
    bufp->chgCData(oldp+12,((0x1fU & (vlSelf->i_pref_instr 
                                      >> 0xfU))),5);
}

void VXcore_if_mdec___024root__trace_cleanup(void* voidSelf, VerilatedVcd* /*unused*/) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    VXcore_if_mdec___024root__trace_cleanup\n"); );
    // Init
    VXcore_if_mdec___024root* const __restrict vlSelf VL_ATTR_UNUSED = static_cast<VXcore_if_mdec___024root*>(voidSelf);
    VXcore_if_mdec__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VlUnpacked<CData/*0:0*/, 1> __Vm_traceActivity;
    // Body
    vlSymsp->__Vm_activity = false;
    __Vm_traceActivity[0U] = 0U;
}
