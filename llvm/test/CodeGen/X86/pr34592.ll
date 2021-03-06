; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -mtriple=x86_64-unknown-unknown -mattr=avx2 -O0 | FileCheck %s

define <16 x i64> @pluto(<16 x i64> %arg, <16 x i64> %arg1, <16 x i64> %arg2, <16 x i64> %arg3, <16 x i64> %arg4) {
; CHECK-LABEL: pluto:
; CHECK:       # %bb.0: # %bb
; CHECK-NEXT:    pushq %rbp
; CHECK-NEXT:    .cfi_def_cfa_offset 16
; CHECK-NEXT:    .cfi_offset %rbp, -16
; CHECK-NEXT:    movq %rsp, %rbp
; CHECK-NEXT:    .cfi_def_cfa_register %rbp
; CHECK-NEXT:    andq $-32, %rsp
; CHECK-NEXT:    subq $32, %rsp
; CHECK-NEXT:    vmovaps %ymm4, %ymm10
; CHECK-NEXT:    vmovaps %ymm3, %ymm9
; CHECK-NEXT:    vmovaps %ymm1, %ymm8
; CHECK-NEXT:    vmovaps 240(%rbp), %ymm4
; CHECK-NEXT:    vmovaps 208(%rbp), %ymm3
; CHECK-NEXT:    vmovaps 176(%rbp), %ymm1
; CHECK-NEXT:    vmovaps 144(%rbp), %ymm1
; CHECK-NEXT:    vmovaps 112(%rbp), %ymm11
; CHECK-NEXT:    vmovaps 80(%rbp), %ymm11
; CHECK-NEXT:    vmovaps 48(%rbp), %ymm11
; CHECK-NEXT:    vmovaps 16(%rbp), %ymm11
; CHECK-NEXT:    vpblendd {{.*#+}} ymm0 = ymm6[0,1,2,3,4,5],ymm2[6,7]
; CHECK-NEXT:    vpunpcklqdq {{.*#+}} ymm1 = ymm1[0],ymm3[0],ymm1[2],ymm3[2]
; CHECK-NEXT:    vpermq {{.*#+}} ymm1 = ymm1[0,2,1,3]
; CHECK-NEXT:    vpermq {{.*#+}} ymm0 = ymm0[3,1,2,1]
; CHECK-NEXT:    vpblendd {{.*#+}} ymm0 = ymm0[0,1],ymm1[2,3,4,5],ymm0[6,7]
; CHECK-NEXT:    vperm2i128 {{.*#+}} ymm1 = ymm7[2,3],ymm6[0,1]
; CHECK-NEXT:    vxorps %xmm2, %xmm2, %xmm2
; CHECK-NEXT:    vpblendd {{.*#+}} ymm2 = ymm1[0,1],ymm2[2,3],ymm1[4,5,6,7]
; CHECK-NEXT:    vpunpcklqdq {{.*#+}} ymm1 = ymm7[0],ymm5[0],ymm7[2],ymm5[2]
; CHECK-NEXT:    vpermq {{.*#+}} ymm1 = ymm1[2,1,2,3]
; CHECK-NEXT:    vpermq {{.*#+}} ymm4 = ymm4[1,1,1,1]
; CHECK-NEXT:    vpblendd {{.*#+}} ymm1 = ymm1[0,1],ymm4[2,3,4,5],ymm1[6,7]
; CHECK-NEXT:    vmovaps %xmm3, %xmm4
; CHECK-NEXT:    vmovaps %xmm7, %xmm3
; CHECK-NEXT:    vpblendd {{.*#+}} xmm4 = xmm3[0,1],xmm4[2,3]
; CHECK-NEXT:    # implicit-def: $ymm3
; CHECK-NEXT:    vmovaps %xmm4, %xmm3
; CHECK-NEXT:    vpermq {{.*#+}} ymm4 = ymm3[0,0,1,3]
; CHECK-NEXT:    vpslldq {{.*#+}} ymm3 = zero,zero,zero,zero,zero,zero,zero,zero,ymm5[0,1,2,3,4,5,6,7],zero,zero,zero,zero,zero,zero,zero,zero,ymm5[16,17,18,19,20,21,22,23]
; CHECK-NEXT:    vpblendd {{.*#+}} ymm3 = ymm3[0,1],ymm4[2,3,4,5],ymm3[6,7]
; CHECK-NEXT:    movq %rbp, %rsp
; CHECK-NEXT:    popq %rbp
; CHECK-NEXT:    .cfi_def_cfa %rsp, 8
; CHECK-NEXT:    retq
bb:
  %tmp = select <16 x i1> <i1 false, i1 false, i1 false, i1 false, i1 false, i1 false, i1 false, i1 false, i1 false, i1 false, i1 true, i1 true, i1 false, i1 false, i1 false, i1 false>, <16 x i64> %arg, <16 x i64> %arg1
  %tmp5 = select <16 x i1> <i1 true, i1 false, i1 false, i1 true, i1 true, i1 false, i1 false, i1 true, i1 false, i1 true, i1 false, i1 false, i1 false, i1 false, i1 false, i1 false>, <16 x i64> %arg2, <16 x i64> zeroinitializer
  %tmp6 = select <16 x i1> <i1 false, i1 true, i1 true, i1 true, i1 false, i1 false, i1 false, i1 false, i1 true, i1 true, i1 false, i1 false, i1 false, i1 true, i1 true, i1 true>, <16 x i64> %arg3, <16 x i64> %tmp5
  %tmp7 = shufflevector <16 x i64> %tmp, <16 x i64> %tmp6, <16 x i32> <i32 11, i32 18, i32 24, i32 9, i32 14, i32 29, i32 29, i32 6, i32 14, i32 28, i32 8, i32 9, i32 22, i32 12, i32 25, i32 6>
  ret <16 x i64> %tmp7
}
