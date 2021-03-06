; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -mtriple=riscv32 -verify-machineinstrs -mattr=+f \
; RUN:     -target-abi ilp32f < %s \
; RUN:   | FileCheck -check-prefix=RV32-ILP32FD %s
; RUN: llc -mtriple=riscv32 -verify-machineinstrs -mattr=+d \
; RUN:     -target-abi ilp32d < %s \
; RUN:   | FileCheck -check-prefix=RV32-ILP32FD %s

; This file contains tests that should have identical output for the ilp32f
; and ilp32d ABIs.

define i32 @callee_float_in_fpr(i32 %a, float %b) nounwind {
; RV32-ILP32FD-LABEL: callee_float_in_fpr:
; RV32-ILP32FD:       # %bb.0:
; RV32-ILP32FD-NEXT:    fcvt.w.s a1, fa0, rtz
; RV32-ILP32FD-NEXT:    add a0, a0, a1
; RV32-ILP32FD-NEXT:    ret
  %b_fptosi = fptosi float %b to i32
  %1 = add i32 %a, %b_fptosi
  ret i32 %1
}

define i32 @caller_float_in_fpr() nounwind {
; RV32-ILP32FD-LABEL: caller_float_in_fpr:
; RV32-ILP32FD:       # %bb.0:
; RV32-ILP32FD-NEXT:    addi sp, sp, -16
; RV32-ILP32FD-NEXT:    sw ra, 12(sp) # 4-byte Folded Spill
; RV32-ILP32FD-NEXT:    lui a0, %hi(.LCPI1_0)
; RV32-ILP32FD-NEXT:    flw fa0, %lo(.LCPI1_0)(a0)
; RV32-ILP32FD-NEXT:    li a0, 1
; RV32-ILP32FD-NEXT:    call callee_float_in_fpr@plt
; RV32-ILP32FD-NEXT:    lw ra, 12(sp) # 4-byte Folded Reload
; RV32-ILP32FD-NEXT:    addi sp, sp, 16
; RV32-ILP32FD-NEXT:    ret
  %1 = call i32 @callee_float_in_fpr(i32 1, float 2.0)
  ret i32 %1
}

; Must keep define on a single line due to an update_llc_test_checks.py limitation
define i32 @callee_float_in_fpr_exhausted_gprs(i64 %a, i64 %b, i64 %c, i64 %d, i32 %e, float %f) nounwind {
; RV32-ILP32FD-LABEL: callee_float_in_fpr_exhausted_gprs:
; RV32-ILP32FD:       # %bb.0:
; RV32-ILP32FD-NEXT:    lw a0, 0(sp)
; RV32-ILP32FD-NEXT:    fcvt.w.s a1, fa0, rtz
; RV32-ILP32FD-NEXT:    add a0, a0, a1
; RV32-ILP32FD-NEXT:    ret
  %f_fptosi = fptosi float %f to i32
  %1 = add i32 %e, %f_fptosi
  ret i32 %1
}

define i32 @caller_float_in_fpr_exhausted_gprs() nounwind {
; RV32-ILP32FD-LABEL: caller_float_in_fpr_exhausted_gprs:
; RV32-ILP32FD:       # %bb.0:
; RV32-ILP32FD-NEXT:    addi sp, sp, -16
; RV32-ILP32FD-NEXT:    sw ra, 12(sp) # 4-byte Folded Spill
; RV32-ILP32FD-NEXT:    li a1, 5
; RV32-ILP32FD-NEXT:    lui a0, %hi(.LCPI3_0)
; RV32-ILP32FD-NEXT:    flw fa0, %lo(.LCPI3_0)(a0)
; RV32-ILP32FD-NEXT:    li a0, 1
; RV32-ILP32FD-NEXT:    li a2, 2
; RV32-ILP32FD-NEXT:    li a4, 3
; RV32-ILP32FD-NEXT:    li a6, 4
; RV32-ILP32FD-NEXT:    sw a1, 0(sp)
; RV32-ILP32FD-NEXT:    li a1, 0
; RV32-ILP32FD-NEXT:    li a3, 0
; RV32-ILP32FD-NEXT:    li a5, 0
; RV32-ILP32FD-NEXT:    li a7, 0
; RV32-ILP32FD-NEXT:    call callee_float_in_fpr_exhausted_gprs@plt
; RV32-ILP32FD-NEXT:    lw ra, 12(sp) # 4-byte Folded Reload
; RV32-ILP32FD-NEXT:    addi sp, sp, 16
; RV32-ILP32FD-NEXT:    ret
  %1 = call i32 @callee_float_in_fpr_exhausted_gprs(
      i64 1, i64 2, i64 3, i64 4, i32 5, float 6.0)
  ret i32 %1
}

; Must keep define on a single line due to an update_llc_test_checks.py limitation
define i32 @callee_float_in_gpr_exhausted_fprs(float %a, float %b, float %c, float %d, float %e, float %f, float %g, float %h, float %i) nounwind {
; RV32-ILP32FD-LABEL: callee_float_in_gpr_exhausted_fprs:
; RV32-ILP32FD:       # %bb.0:
; RV32-ILP32FD-NEXT:    fmv.w.x ft0, a0
; RV32-ILP32FD-NEXT:    fcvt.w.s a0, fa7, rtz
; RV32-ILP32FD-NEXT:    fcvt.w.s a1, ft0, rtz
; RV32-ILP32FD-NEXT:    add a0, a0, a1
; RV32-ILP32FD-NEXT:    ret
  %h_fptosi = fptosi float %h to i32
  %i_fptosi = fptosi float %i to i32
  %1 = add i32 %h_fptosi, %i_fptosi
  ret i32 %1
}

define i32 @caller_float_in_gpr_exhausted_fprs() nounwind {
; RV32-ILP32FD-LABEL: caller_float_in_gpr_exhausted_fprs:
; RV32-ILP32FD:       # %bb.0:
; RV32-ILP32FD-NEXT:    addi sp, sp, -16
; RV32-ILP32FD-NEXT:    sw ra, 12(sp) # 4-byte Folded Spill
; RV32-ILP32FD-NEXT:    lui a0, %hi(.LCPI5_0)
; RV32-ILP32FD-NEXT:    flw fa0, %lo(.LCPI5_0)(a0)
; RV32-ILP32FD-NEXT:    lui a0, %hi(.LCPI5_1)
; RV32-ILP32FD-NEXT:    flw fa1, %lo(.LCPI5_1)(a0)
; RV32-ILP32FD-NEXT:    lui a0, %hi(.LCPI5_2)
; RV32-ILP32FD-NEXT:    flw fa2, %lo(.LCPI5_2)(a0)
; RV32-ILP32FD-NEXT:    lui a0, %hi(.LCPI5_3)
; RV32-ILP32FD-NEXT:    flw fa3, %lo(.LCPI5_3)(a0)
; RV32-ILP32FD-NEXT:    lui a0, %hi(.LCPI5_4)
; RV32-ILP32FD-NEXT:    flw fa4, %lo(.LCPI5_4)(a0)
; RV32-ILP32FD-NEXT:    lui a0, %hi(.LCPI5_5)
; RV32-ILP32FD-NEXT:    flw fa5, %lo(.LCPI5_5)(a0)
; RV32-ILP32FD-NEXT:    lui a0, %hi(.LCPI5_6)
; RV32-ILP32FD-NEXT:    flw fa6, %lo(.LCPI5_6)(a0)
; RV32-ILP32FD-NEXT:    lui a0, %hi(.LCPI5_7)
; RV32-ILP32FD-NEXT:    flw fa7, %lo(.LCPI5_7)(a0)
; RV32-ILP32FD-NEXT:    lui a0, 266496
; RV32-ILP32FD-NEXT:    call callee_float_in_gpr_exhausted_fprs@plt
; RV32-ILP32FD-NEXT:    lw ra, 12(sp) # 4-byte Folded Reload
; RV32-ILP32FD-NEXT:    addi sp, sp, 16
; RV32-ILP32FD-NEXT:    ret
  %1 = call i32 @callee_float_in_gpr_exhausted_fprs(
      float 1.0, float 2.0, float 3.0, float 4.0, float 5.0, float 6.0,
      float 7.0, float 8.0, float 9.0)
  ret i32 %1
}

; Must keep define on a single line due to an update_llc_test_checks.py limitation
define i32 @callee_float_on_stack_exhausted_gprs_fprs(i64 %a, float %b, i64 %c, float %d, i64 %e, float %f, i64 %g, float %h, float %i, float %j, float %k, float %l, float %m) nounwind {
; RV32-ILP32FD-LABEL: callee_float_on_stack_exhausted_gprs_fprs:
; RV32-ILP32FD:       # %bb.0:
; RV32-ILP32FD-NEXT:    flw ft0, 0(sp)
; RV32-ILP32FD-NEXT:    fcvt.w.s a0, ft0, rtz
; RV32-ILP32FD-NEXT:    add a0, a6, a0
; RV32-ILP32FD-NEXT:    ret
  %g_trunc = trunc i64 %g to i32
  %m_fptosi = fptosi float %m to i32
  %1 = add i32 %g_trunc, %m_fptosi
  ret i32 %1
}

define i32 @caller_float_on_stack_exhausted_gprs_fprs() nounwind {
; RV32-ILP32FD-LABEL: caller_float_on_stack_exhausted_gprs_fprs:
; RV32-ILP32FD:       # %bb.0:
; RV32-ILP32FD-NEXT:    addi sp, sp, -16
; RV32-ILP32FD-NEXT:    sw ra, 12(sp) # 4-byte Folded Spill
; RV32-ILP32FD-NEXT:    lui a1, 267520
; RV32-ILP32FD-NEXT:    lui a0, %hi(.LCPI7_0)
; RV32-ILP32FD-NEXT:    flw fa0, %lo(.LCPI7_0)(a0)
; RV32-ILP32FD-NEXT:    lui a0, %hi(.LCPI7_1)
; RV32-ILP32FD-NEXT:    flw fa1, %lo(.LCPI7_1)(a0)
; RV32-ILP32FD-NEXT:    lui a0, %hi(.LCPI7_2)
; RV32-ILP32FD-NEXT:    flw fa2, %lo(.LCPI7_2)(a0)
; RV32-ILP32FD-NEXT:    lui a0, %hi(.LCPI7_3)
; RV32-ILP32FD-NEXT:    flw fa3, %lo(.LCPI7_3)(a0)
; RV32-ILP32FD-NEXT:    lui a0, %hi(.LCPI7_4)
; RV32-ILP32FD-NEXT:    flw fa4, %lo(.LCPI7_4)(a0)
; RV32-ILP32FD-NEXT:    lui a0, %hi(.LCPI7_5)
; RV32-ILP32FD-NEXT:    flw fa5, %lo(.LCPI7_5)(a0)
; RV32-ILP32FD-NEXT:    lui a0, %hi(.LCPI7_6)
; RV32-ILP32FD-NEXT:    flw fa6, %lo(.LCPI7_6)(a0)
; RV32-ILP32FD-NEXT:    lui a0, %hi(.LCPI7_7)
; RV32-ILP32FD-NEXT:    flw fa7, %lo(.LCPI7_7)(a0)
; RV32-ILP32FD-NEXT:    li a0, 1
; RV32-ILP32FD-NEXT:    li a2, 3
; RV32-ILP32FD-NEXT:    li a4, 5
; RV32-ILP32FD-NEXT:    li a6, 7
; RV32-ILP32FD-NEXT:    sw a1, 0(sp)
; RV32-ILP32FD-NEXT:    li a1, 0
; RV32-ILP32FD-NEXT:    li a3, 0
; RV32-ILP32FD-NEXT:    li a5, 0
; RV32-ILP32FD-NEXT:    li a7, 0
; RV32-ILP32FD-NEXT:    call callee_float_on_stack_exhausted_gprs_fprs@plt
; RV32-ILP32FD-NEXT:    lw ra, 12(sp) # 4-byte Folded Reload
; RV32-ILP32FD-NEXT:    addi sp, sp, 16
; RV32-ILP32FD-NEXT:    ret
  %1 = call i32 @callee_float_on_stack_exhausted_gprs_fprs(
      i64 1, float 2.0, i64 3, float 4.0, i64 5, float 6.0, i64 7, float 8.0,
      float 9.0, float 10.0, float 11.0, float 12.0, float 13.0)
  ret i32 %1
}

define float @callee_float_ret() nounwind {
; RV32-ILP32FD-LABEL: callee_float_ret:
; RV32-ILP32FD:       # %bb.0:
; RV32-ILP32FD-NEXT:    lui a0, %hi(.LCPI8_0)
; RV32-ILP32FD-NEXT:    flw fa0, %lo(.LCPI8_0)(a0)
; RV32-ILP32FD-NEXT:    ret
  ret float 1.0
}

define i32 @caller_float_ret() nounwind {
; RV32-ILP32FD-LABEL: caller_float_ret:
; RV32-ILP32FD:       # %bb.0:
; RV32-ILP32FD-NEXT:    addi sp, sp, -16
; RV32-ILP32FD-NEXT:    sw ra, 12(sp) # 4-byte Folded Spill
; RV32-ILP32FD-NEXT:    call callee_float_ret@plt
; RV32-ILP32FD-NEXT:    fmv.x.w a0, fa0
; RV32-ILP32FD-NEXT:    lw ra, 12(sp) # 4-byte Folded Reload
; RV32-ILP32FD-NEXT:    addi sp, sp, 16
; RV32-ILP32FD-NEXT:    ret
  %1 = call float @callee_float_ret()
  %2 = bitcast float %1 to i32
  ret i32 %2
}
