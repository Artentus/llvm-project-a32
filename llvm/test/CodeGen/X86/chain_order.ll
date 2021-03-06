; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -mcpu=corei7-avx -mtriple=x86_64-linux | FileCheck %s

; A test from pifft (after SLP-vectorization) that fails when we drop the chain on newly merged loads.
define void @cftx020(ptr nocapture %a) {
; CHECK-LABEL: cftx020:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    vmovsd {{.*#+}} xmm0 = mem[0],zero
; CHECK-NEXT:    vmovsd {{.*#+}} xmm1 = mem[0],zero
; CHECK-NEXT:    vmovhpd {{.*#+}} xmm0 = xmm0[0],mem[0]
; CHECK-NEXT:    vmovhpd {{.*#+}} xmm1 = xmm1[0],mem[0]
; CHECK-NEXT:    vaddpd %xmm1, %xmm0, %xmm0
; CHECK-NEXT:    vmovupd (%rdi), %xmm1
; CHECK-NEXT:    vmovupd %xmm0, (%rdi)
; CHECK-NEXT:    vsubpd 16(%rdi), %xmm1, %xmm0
; CHECK-NEXT:    vmovupd %xmm0, 16(%rdi)
; CHECK-NEXT:    retq
entry:
  %0 = load double, ptr %a, align 8
  %arrayidx1 = getelementptr inbounds double, ptr %a, i64 2
  %1 = load double, ptr %arrayidx1, align 8
  %arrayidx2 = getelementptr inbounds double, ptr %a, i64 1
  %2 = load double, ptr %arrayidx2, align 8
  %arrayidx3 = getelementptr inbounds double, ptr %a, i64 3
  %3 = load double, ptr %arrayidx3, align 8
  %4 = insertelement <2 x double> undef, double %0, i32 0
  %5 = insertelement <2 x double> %4, double %3, i32 1
  %6 = insertelement <2 x double> undef, double %1, i32 0
  %7 = insertelement <2 x double> %6, double %2, i32 1
  %8 = fadd <2 x double> %5, %7
  store <2 x double> %8, ptr %a, align 8
  %9 = insertelement <2 x double> undef, double %0, i32 0
  %10 = insertelement <2 x double> %9, double %2, i32 1
  %11 = insertelement <2 x double> undef, double %1, i32 0
  %12 = insertelement <2 x double> %11, double %3, i32 1
  %13 = fsub <2 x double> %10, %12
  store <2 x double> %13, ptr %arrayidx1, align 8
  ret void
}
