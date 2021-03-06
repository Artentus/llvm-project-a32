; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -mtriple=x86_64-unknown-linux-gnu -mattr=avx -O0 | FileCheck %s

; We should not be emitting a sign extend using a %ymm register.

define void @test55() {
; CHECK-LABEL: test55:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    pushq %rbp
; CHECK-NEXT:    .cfi_def_cfa_offset 16
; CHECK-NEXT:    .cfi_offset %rbp, -16
; CHECK-NEXT:    movq %rsp, %rbp
; CHECK-NEXT:    .cfi_def_cfa_register %rbp
; CHECK-NEXT:    andq $-32, %rsp
; CHECK-NEXT:    subq $96, %rsp
; CHECK-NEXT:    vmovdqa {{.*#+}} xmm0 = [26680,34632,63774,2423,35015,60307,6240,1951]
; CHECK-NEXT:    vmovdqa %xmm0, {{[0-9]+}}(%rsp)
; CHECK-NEXT:    vmovdqa {{[0-9]+}}(%rsp), %xmm0
; CHECK-NEXT:    vmovdqa %xmm0, {{[0-9]+}}(%rsp)
; CHECK-NEXT:    vmovdqa {{[0-9]+}}(%rsp), %xmm1
; CHECK-NEXT:    vpmovsxwd %xmm1, %xmm2
; CHECK-NEXT:    # implicit-def: $ymm0
; CHECK-NEXT:    vmovaps %xmm2, %xmm0
; CHECK-NEXT:    vpshufd {{.*#+}} xmm1 = xmm1[2,3,2,3]
; CHECK-NEXT:    vpmovsxwd %xmm1, %xmm1
; CHECK-NEXT:    vinsertf128 $1, %xmm1, %ymm0, %ymm0
; CHECK-NEXT:    vmovdqa %ymm0, (%rsp)
; CHECK-NEXT:    movq %rbp, %rsp
; CHECK-NEXT:    popq %rbp
; CHECK-NEXT:    .cfi_def_cfa %rsp, 8
; CHECK-NEXT:    vzeroupper
; CHECK-NEXT:    retq
entry:
  %id11762 = alloca <8 x i16>, align 16
  %.compoundliteral = alloca <8 x i16>, align 16
  %id11761 = alloca <8 x i32>, align 32
  store <8 x i16> <i16 26680, i16 -30904, i16 -1762, i16 2423, i16 -30521, i16 -5229, i16 6240, i16 1951>, ptr %.compoundliteral, align 16
  %0 = load <8 x i16>, ptr %.compoundliteral, align 16
  store <8 x i16> %0, ptr %id11762, align 16
  %1 = load <8 x i16>, ptr %id11762, align 16
  %conv = sext <8 x i16> %1 to <8 x i32>
  store <8 x i32> %conv, ptr %id11761, align 32
  ret void
}
