; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -mattr=fma4 | FileCheck %s

target triple = "x86_64-unknown-unknown"

declare <4 x float> @llvm.x86.fma4.vfmadd.ss(<4 x float>, <4 x float>, <4 x float>)
declare <2 x double> @llvm.x86.fma4.vfmadd.sd(<2 x double>, <2 x double>, <2 x double>)

define void @fmadd_aab_ss(ptr %a, ptr %b) {
; CHECK-LABEL: fmadd_aab_ss:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vmovss {{.*#+}} xmm0 = mem[0],zero,zero,zero
; CHECK-NEXT:    vfmaddss {{.*#+}} xmm0 = (xmm0 * xmm0) + mem
; CHECK-NEXT:    vmovss %xmm0, (%rdi)
; CHECK-NEXT:    retq
  %a.val = load float, ptr %a
  %av0 = insertelement <4 x float> undef, float %a.val, i32 0
  %av1 = insertelement <4 x float> %av0, float 0.000000e+00, i32 1
  %av2 = insertelement <4 x float> %av1, float 0.000000e+00, i32 2
  %av  = insertelement <4 x float> %av2, float 0.000000e+00, i32 3

  %b.val = load float, ptr %b
  %bv0 = insertelement <4 x float> undef, float %b.val, i32 0
  %bv1 = insertelement <4 x float> %bv0, float 0.000000e+00, i32 1
  %bv2 = insertelement <4 x float> %bv1, float 0.000000e+00, i32 2
  %bv  = insertelement <4 x float> %bv2, float 0.000000e+00, i32 3

  %vr = call <4 x float> @llvm.x86.fma4.vfmadd.ss(<4 x float> %av, <4 x float> %av, <4 x float> %bv)

  %sr = extractelement <4 x float> %vr, i32 0
  store float %sr, ptr %a
  ret void
}

define void @fmadd_aba_ss(ptr %a, ptr %b) {
; CHECK-LABEL: fmadd_aba_ss:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vmovss {{.*#+}} xmm0 = mem[0],zero,zero,zero
; CHECK-NEXT:    vfmaddss {{.*#+}} xmm0 = (xmm0 * mem) + xmm0
; CHECK-NEXT:    vmovss %xmm0, (%rdi)
; CHECK-NEXT:    retq
  %a.val = load float, ptr %a
  %av0 = insertelement <4 x float> undef, float %a.val, i32 0
  %av1 = insertelement <4 x float> %av0, float 0.000000e+00, i32 1
  %av2 = insertelement <4 x float> %av1, float 0.000000e+00, i32 2
  %av  = insertelement <4 x float> %av2, float 0.000000e+00, i32 3

  %b.val = load float, ptr %b
  %bv0 = insertelement <4 x float> undef, float %b.val, i32 0
  %bv1 = insertelement <4 x float> %bv0, float 0.000000e+00, i32 1
  %bv2 = insertelement <4 x float> %bv1, float 0.000000e+00, i32 2
  %bv  = insertelement <4 x float> %bv2, float 0.000000e+00, i32 3

  %vr = call <4 x float> @llvm.x86.fma4.vfmadd.ss(<4 x float> %av, <4 x float> %bv, <4 x float> %av)

  %sr = extractelement <4 x float> %vr, i32 0
  store float %sr, ptr %a
  ret void
}

define void @fmadd_aab_sd(ptr %a, ptr %b) {
; CHECK-LABEL: fmadd_aab_sd:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vmovsd {{.*#+}} xmm0 = mem[0],zero
; CHECK-NEXT:    vfmaddsd {{.*#+}} xmm0 = (xmm0 * xmm0) + mem
; CHECK-NEXT:    vmovsd %xmm0, (%rdi)
; CHECK-NEXT:    retq
  %a.val = load double, ptr %a
  %av0 = insertelement <2 x double> undef, double %a.val, i32 0
  %av  = insertelement <2 x double> %av0, double 0.000000e+00, i32 1

  %b.val = load double, ptr %b
  %bv0 = insertelement <2 x double> undef, double %b.val, i32 0
  %bv  = insertelement <2 x double> %bv0, double 0.000000e+00, i32 1

  %vr = call <2 x double> @llvm.x86.fma4.vfmadd.sd(<2 x double> %av, <2 x double> %av, <2 x double> %bv)

  %sr = extractelement <2 x double> %vr, i32 0
  store double %sr, ptr %a
  ret void
}

define void @fmadd_aba_sd(ptr %a, ptr %b) {
; CHECK-LABEL: fmadd_aba_sd:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vmovsd {{.*#+}} xmm0 = mem[0],zero
; CHECK-NEXT:    vfmaddsd {{.*#+}} xmm0 = (xmm0 * mem) + xmm0
; CHECK-NEXT:    vmovsd %xmm0, (%rdi)
; CHECK-NEXT:    retq
  %a.val = load double, ptr %a
  %av0 = insertelement <2 x double> undef, double %a.val, i32 0
  %av  = insertelement <2 x double> %av0, double 0.000000e+00, i32 1

  %b.val = load double, ptr %b
  %bv0 = insertelement <2 x double> undef, double %b.val, i32 0
  %bv  = insertelement <2 x double> %bv0, double 0.000000e+00, i32 1

  %vr = call <2 x double> @llvm.x86.fma4.vfmadd.sd(<2 x double> %av, <2 x double> %bv, <2 x double> %av)

  %sr = extractelement <2 x double> %vr, i32 0
  store double %sr, ptr %a
  ret void
}

