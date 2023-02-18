// Verilated -*- C++ -*-
// DESCRIPTION: Verilator output: Design implementation internals
// See VXcore_if_mdec.h for the primary calling header

#include "verilated.h"

#include "VXcore_if_mdec___024root.h"

VL_ATTR_COLD void VXcore_if_mdec___024root___eval_static(VXcore_if_mdec___024root* vlSelf) {
    if (false && vlSelf) {}  // Prevent unused
    VXcore_if_mdec__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    VXcore_if_mdec___024root___eval_static\n"); );
}

VL_ATTR_COLD void VXcore_if_mdec___024root___eval_initial(VXcore_if_mdec___024root* vlSelf) {
    if (false && vlSelf) {}  // Prevent unused
    VXcore_if_mdec__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    VXcore_if_mdec___024root___eval_initial\n"); );
}

VL_ATTR_COLD void VXcore_if_mdec___024root___eval_final(VXcore_if_mdec___024root* vlSelf) {
    if (false && vlSelf) {}  // Prevent unused
    VXcore_if_mdec__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    VXcore_if_mdec___024root___eval_final\n"); );
}

VL_ATTR_COLD void VXcore_if_mdec___024root___eval_triggers__stl(VXcore_if_mdec___024root* vlSelf);
#ifdef VL_DEBUG
VL_ATTR_COLD void VXcore_if_mdec___024root___dump_triggers__stl(VXcore_if_mdec___024root* vlSelf);
#endif  // VL_DEBUG
VL_ATTR_COLD void VXcore_if_mdec___024root___eval_stl(VXcore_if_mdec___024root* vlSelf);

VL_ATTR_COLD void VXcore_if_mdec___024root___eval_settle(VXcore_if_mdec___024root* vlSelf) {
    if (false && vlSelf) {}  // Prevent unused
    VXcore_if_mdec__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    VXcore_if_mdec___024root___eval_settle\n"); );
    // Init
    CData/*0:0*/ __VstlContinue;
    // Body
    vlSelf->__VstlIterCount = 0U;
    __VstlContinue = 1U;
    while (__VstlContinue) {
        __VstlContinue = 0U;
        VXcore_if_mdec___024root___eval_triggers__stl(vlSelf);
        if (vlSelf->__VstlTriggered.any()) {
            __VstlContinue = 1U;
            if (VL_UNLIKELY((0x64U < vlSelf->__VstlIterCount))) {
#ifdef VL_DEBUG
                VXcore_if_mdec___024root___dump_triggers__stl(vlSelf);
#endif
                VL_FATAL_MT("rtl/core/Xcore_if_mdec.v", 20, "", "Settle region did not converge.");
            }
            vlSelf->__VstlIterCount = ((IData)(1U) 
                                       + vlSelf->__VstlIterCount);
            VXcore_if_mdec___024root___eval_stl(vlSelf);
        }
    }
}

#ifdef VL_DEBUG
VL_ATTR_COLD void VXcore_if_mdec___024root___dump_triggers__stl(VXcore_if_mdec___024root* vlSelf) {
    if (false && vlSelf) {}  // Prevent unused
    VXcore_if_mdec__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    VXcore_if_mdec___024root___dump_triggers__stl\n"); );
    // Body
    if ((1U & (~ (IData)(vlSelf->__VstlTriggered.any())))) {
        VL_DBG_MSGF("         No triggers active\n");
    }
    if (vlSelf->__VstlTriggered.at(0U)) {
        VL_DBG_MSGF("         'stl' region trigger index 0 is active: Internal 'stl' trigger - first iteration\n");
    }
}
#endif  // VL_DEBUG

void VXcore_if_mdec___024root___ico_sequent__TOP__0(VXcore_if_mdec___024root* vlSelf);

VL_ATTR_COLD void VXcore_if_mdec___024root___eval_stl(VXcore_if_mdec___024root* vlSelf) {
    if (false && vlSelf) {}  // Prevent unused
    VXcore_if_mdec__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    VXcore_if_mdec___024root___eval_stl\n"); );
    // Body
    if (vlSelf->__VstlTriggered.at(0U)) {
        VXcore_if_mdec___024root___ico_sequent__TOP__0(vlSelf);
    }
}

#ifdef VL_DEBUG
VL_ATTR_COLD void VXcore_if_mdec___024root___dump_triggers__ico(VXcore_if_mdec___024root* vlSelf) {
    if (false && vlSelf) {}  // Prevent unused
    VXcore_if_mdec__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    VXcore_if_mdec___024root___dump_triggers__ico\n"); );
    // Body
    if ((1U & (~ (IData)(vlSelf->__VicoTriggered.any())))) {
        VL_DBG_MSGF("         No triggers active\n");
    }
    if (vlSelf->__VicoTriggered.at(0U)) {
        VL_DBG_MSGF("         'ico' region trigger index 0 is active: Internal 'ico' trigger - first iteration\n");
    }
}
#endif  // VL_DEBUG

#ifdef VL_DEBUG
VL_ATTR_COLD void VXcore_if_mdec___024root___dump_triggers__act(VXcore_if_mdec___024root* vlSelf) {
    if (false && vlSelf) {}  // Prevent unused
    VXcore_if_mdec__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    VXcore_if_mdec___024root___dump_triggers__act\n"); );
    // Body
    if ((1U & (~ (IData)(vlSelf->__VactTriggered.any())))) {
        VL_DBG_MSGF("         No triggers active\n");
    }
}
#endif  // VL_DEBUG

#ifdef VL_DEBUG
VL_ATTR_COLD void VXcore_if_mdec___024root___dump_triggers__nba(VXcore_if_mdec___024root* vlSelf) {
    if (false && vlSelf) {}  // Prevent unused
    VXcore_if_mdec__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    VXcore_if_mdec___024root___dump_triggers__nba\n"); );
    // Body
    if ((1U & (~ (IData)(vlSelf->__VnbaTriggered.any())))) {
        VL_DBG_MSGF("         No triggers active\n");
    }
}
#endif  // VL_DEBUG

VL_ATTR_COLD void VXcore_if_mdec___024root___ctor_var_reset(VXcore_if_mdec___024root* vlSelf) {
    if (false && vlSelf) {}  // Prevent unused
    VXcore_if_mdec__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    VXcore_if_mdec___024root___ctor_var_reset\n"); );
    // Body
    vlSelf->i_pref_instr = VL_RAND_RESET_I(32);
    vlSelf->i_pc_instr_vld = VL_RAND_RESET_I(1);
    vlSelf->o_mdec_b = VL_RAND_RESET_I(1);
    vlSelf->o_mdec_jal = VL_RAND_RESET_I(1);
    vlSelf->o_mdec_jalr = VL_RAND_RESET_I(1);
    vlSelf->o_mdec_b_ofs = VL_RAND_RESET_I(32);
    vlSelf->o_mdec_jal_ofs = VL_RAND_RESET_I(32);
    vlSelf->o_mdec_jalr_ofs = VL_RAND_RESET_I(32);
    vlSelf->o_mdec_instr_vld = VL_RAND_RESET_I(1);
    vlSelf->__VstlIterCount = 0;
    vlSelf->__VicoIterCount = 0;
    vlSelf->__VactIterCount = 0;
    vlSelf->__VactContinue = 0;
}
