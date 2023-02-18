// Verilated -*- C++ -*-
// DESCRIPTION: Verilator output: Design implementation internals
// See VXcore_if_mdec.h for the primary calling header

#include "verilated.h"

#include "VXcore_if_mdec___024root.h"

VL_INLINE_OPT void VXcore_if_mdec___024root___ico_sequent__TOP__0(VXcore_if_mdec___024root* vlSelf) {
    if (false && vlSelf) {}  // Prevent unused
    VXcore_if_mdec__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    VXcore_if_mdec___024root___ico_sequent__TOP__0\n"); );
    // Body
    vlSelf->o_mdec_b_ofs = (((- (IData)((vlSelf->i_pref_instr 
                                         >> 0x1fU))) 
                             << 0xcU) | ((0x800U & 
                                          (vlSelf->i_pref_instr 
                                           << 4U)) 
                                         | ((0x7e0U 
                                             & (vlSelf->i_pref_instr 
                                                >> 0x14U)) 
                                            | (0x1eU 
                                               & (vlSelf->i_pref_instr 
                                                  >> 7U)))));
    vlSelf->o_mdec_jal_ofs = (((- (IData)((vlSelf->i_pref_instr 
                                           >> 0x1fU))) 
                               << 0x14U) | ((0xff000U 
                                             & vlSelf->i_pref_instr) 
                                            | ((0x800U 
                                                & (vlSelf->i_pref_instr 
                                                   >> 9U)) 
                                               | (0x7feU 
                                                  & (vlSelf->i_pref_instr 
                                                     >> 0x14U)))));
    vlSelf->o_mdec_jalr_ofs = (((- (IData)((vlSelf->i_pref_instr 
                                            >> 0x1fU))) 
                                << 0xbU) | (0x7feU 
                                            & (vlSelf->i_pref_instr 
                                               >> 0x14U)));
    vlSelf->o_mdec_b = (0x63U == (0x7fU & vlSelf->i_pref_instr));
    vlSelf->o_mdec_jal = (0x6fU == (0x7fU & vlSelf->i_pref_instr));
    vlSelf->o_mdec_jalr = (0x67U == (0x7fU & vlSelf->i_pref_instr));
    vlSelf->o_mdec_instr_vld = ((IData)(vlSelf->i_pc_instr_vld) 
                                & ((IData)(vlSelf->o_mdec_b) 
                                   | ((IData)(vlSelf->o_mdec_jal) 
                                      | (IData)(vlSelf->o_mdec_jalr))));
}

void VXcore_if_mdec___024root___eval_ico(VXcore_if_mdec___024root* vlSelf) {
    if (false && vlSelf) {}  // Prevent unused
    VXcore_if_mdec__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    VXcore_if_mdec___024root___eval_ico\n"); );
    // Body
    if (vlSelf->__VicoTriggered.at(0U)) {
        VXcore_if_mdec___024root___ico_sequent__TOP__0(vlSelf);
    }
}

void VXcore_if_mdec___024root___eval_act(VXcore_if_mdec___024root* vlSelf) {
    if (false && vlSelf) {}  // Prevent unused
    VXcore_if_mdec__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    VXcore_if_mdec___024root___eval_act\n"); );
}

void VXcore_if_mdec___024root___eval_nba(VXcore_if_mdec___024root* vlSelf) {
    if (false && vlSelf) {}  // Prevent unused
    VXcore_if_mdec__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    VXcore_if_mdec___024root___eval_nba\n"); );
}

void VXcore_if_mdec___024root___eval_triggers__ico(VXcore_if_mdec___024root* vlSelf);
#ifdef VL_DEBUG
VL_ATTR_COLD void VXcore_if_mdec___024root___dump_triggers__ico(VXcore_if_mdec___024root* vlSelf);
#endif  // VL_DEBUG
void VXcore_if_mdec___024root___eval_triggers__act(VXcore_if_mdec___024root* vlSelf);
#ifdef VL_DEBUG
VL_ATTR_COLD void VXcore_if_mdec___024root___dump_triggers__act(VXcore_if_mdec___024root* vlSelf);
#endif  // VL_DEBUG
#ifdef VL_DEBUG
VL_ATTR_COLD void VXcore_if_mdec___024root___dump_triggers__nba(VXcore_if_mdec___024root* vlSelf);
#endif  // VL_DEBUG

void VXcore_if_mdec___024root___eval(VXcore_if_mdec___024root* vlSelf) {
    if (false && vlSelf) {}  // Prevent unused
    VXcore_if_mdec__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    VXcore_if_mdec___024root___eval\n"); );
    // Init
    CData/*0:0*/ __VicoContinue;
    VlTriggerVec<0> __VpreTriggered;
    IData/*31:0*/ __VnbaIterCount;
    CData/*0:0*/ __VnbaContinue;
    // Body
    vlSelf->__VicoIterCount = 0U;
    __VicoContinue = 1U;
    while (__VicoContinue) {
        __VicoContinue = 0U;
        VXcore_if_mdec___024root___eval_triggers__ico(vlSelf);
        if (vlSelf->__VicoTriggered.any()) {
            __VicoContinue = 1U;
            if (VL_UNLIKELY((0x64U < vlSelf->__VicoIterCount))) {
#ifdef VL_DEBUG
                VXcore_if_mdec___024root___dump_triggers__ico(vlSelf);
#endif
                VL_FATAL_MT("rtl/core/Xcore_if_mdec.v", 20, "", "Input combinational region did not converge.");
            }
            vlSelf->__VicoIterCount = ((IData)(1U) 
                                       + vlSelf->__VicoIterCount);
            VXcore_if_mdec___024root___eval_ico(vlSelf);
        }
    }
    __VnbaIterCount = 0U;
    __VnbaContinue = 1U;
    while (__VnbaContinue) {
        __VnbaContinue = 0U;
        vlSelf->__VnbaTriggered.clear();
        vlSelf->__VactIterCount = 0U;
        vlSelf->__VactContinue = 1U;
        while (vlSelf->__VactContinue) {
            vlSelf->__VactContinue = 0U;
            VXcore_if_mdec___024root___eval_triggers__act(vlSelf);
            if (vlSelf->__VactTriggered.any()) {
                vlSelf->__VactContinue = 1U;
                if (VL_UNLIKELY((0x64U < vlSelf->__VactIterCount))) {
#ifdef VL_DEBUG
                    VXcore_if_mdec___024root___dump_triggers__act(vlSelf);
#endif
                    VL_FATAL_MT("rtl/core/Xcore_if_mdec.v", 20, "", "Active region did not converge.");
                }
                vlSelf->__VactIterCount = ((IData)(1U) 
                                           + vlSelf->__VactIterCount);
                __VpreTriggered.andNot(vlSelf->__VactTriggered, vlSelf->__VnbaTriggered);
                vlSelf->__VnbaTriggered.set(vlSelf->__VactTriggered);
                VXcore_if_mdec___024root___eval_act(vlSelf);
            }
        }
        if (vlSelf->__VnbaTriggered.any()) {
            __VnbaContinue = 1U;
            if (VL_UNLIKELY((0x64U < __VnbaIterCount))) {
#ifdef VL_DEBUG
                VXcore_if_mdec___024root___dump_triggers__nba(vlSelf);
#endif
                VL_FATAL_MT("rtl/core/Xcore_if_mdec.v", 20, "", "NBA region did not converge.");
            }
            __VnbaIterCount = ((IData)(1U) + __VnbaIterCount);
            VXcore_if_mdec___024root___eval_nba(vlSelf);
        }
    }
}

#ifdef VL_DEBUG
void VXcore_if_mdec___024root___eval_debug_assertions(VXcore_if_mdec___024root* vlSelf) {
    if (false && vlSelf) {}  // Prevent unused
    VXcore_if_mdec__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    VXcore_if_mdec___024root___eval_debug_assertions\n"); );
    // Body
    if (VL_UNLIKELY((vlSelf->i_pc_instr_vld & 0xfeU))) {
        Verilated::overWidthError("i_pc_instr_vld");}
}
#endif  // VL_DEBUG
