; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -mtriple=i386-apple-darwin -mattr=+ssse3 -show-mc-encoding | FileCheck %s --check-prefixes=SSE,X86-SSE
; RUN: llc < %s -mtriple=i386-apple-darwin -mattr=+avx -show-mc-encoding | FileCheck %s --check-prefixes=AVX,AVX1,X86-AVX1
; RUN: llc < %s -mtriple=i386-apple-darwin -mattr=+avx512f,+avx512bw,+avx512dq,+avx512vl -show-mc-encoding | FileCheck %s --check-prefixes=AVX,AVX512,X86-AVX512
; RUN: llc < %s -mtriple=x86_64-apple-darwin -mattr=+ssse3 -show-mc-encoding | FileCheck %s --check-prefixes=SSE,X64-SSE
; RUN: llc < %s -mtriple=x86_64-apple-darwin -mattr=+avx -show-mc-encoding | FileCheck %s --check-prefixes=AVX,AVX1,X64-AVX1
; RUN: llc < %s -mtriple=x86_64-apple-darwin -mattr=+avx512f,+avx512bw,+avx512dq,+avx512vl -show-mc-encoding | FileCheck %s --check-prefixes=AVX,AVX512,X64-AVX512

define <4 x i32> @test_x86_ssse3_phadd_d_128(<4 x i32> %a0, <4 x i32> %a1) {
; SSE-LABEL: test_x86_ssse3_phadd_d_128:
; SSE:       ## %bb.0:
; SSE-NEXT:    phaddd %xmm1, %xmm0 ## encoding: [0x66,0x0f,0x38,0x02,0xc1]
; SSE-NEXT:    ret{{[l|q]}} ## encoding: [0xc3]
;
; AVX-LABEL: test_x86_ssse3_phadd_d_128:
; AVX:       ## %bb.0:
; AVX-NEXT:    vphaddd %xmm1, %xmm0, %xmm0 ## encoding: [0xc4,0xe2,0x79,0x02,0xc1]
; AVX-NEXT:    ret{{[l|q]}} ## encoding: [0xc3]
  %res = call <4 x i32> @llvm.x86.ssse3.phadd.d.128(<4 x i32> %a0, <4 x i32> %a1) ; <<4 x i32>> [#uses=1]
  ret <4 x i32> %res
}
declare <4 x i32> @llvm.x86.ssse3.phadd.d.128(<4 x i32>, <4 x i32>) nounwind readnone


define <8 x i16> @test_x86_ssse3_phadd_sw_128(<8 x i16> %a0, <8 x i16> %a1) {
; SSE-LABEL: test_x86_ssse3_phadd_sw_128:
; SSE:       ## %bb.0:
; SSE-NEXT:    phaddsw %xmm1, %xmm0 ## encoding: [0x66,0x0f,0x38,0x03,0xc1]
; SSE-NEXT:    ret{{[l|q]}} ## encoding: [0xc3]
;
; AVX-LABEL: test_x86_ssse3_phadd_sw_128:
; AVX:       ## %bb.0:
; AVX-NEXT:    vphaddsw %xmm1, %xmm0, %xmm0 ## encoding: [0xc4,0xe2,0x79,0x03,0xc1]
; AVX-NEXT:    ret{{[l|q]}} ## encoding: [0xc3]
  %res = call <8 x i16> @llvm.x86.ssse3.phadd.sw.128(<8 x i16> %a0, <8 x i16> %a1) ; <<8 x i16>> [#uses=1]
  ret <8 x i16> %res
}
declare <8 x i16> @llvm.x86.ssse3.phadd.sw.128(<8 x i16>, <8 x i16>) nounwind readnone


define <8 x i16> @test_x86_ssse3_phadd_w_128(<8 x i16> %a0, <8 x i16> %a1) {
; SSE-LABEL: test_x86_ssse3_phadd_w_128:
; SSE:       ## %bb.0:
; SSE-NEXT:    phaddw %xmm1, %xmm0 ## encoding: [0x66,0x0f,0x38,0x01,0xc1]
; SSE-NEXT:    ret{{[l|q]}} ## encoding: [0xc3]
;
; AVX-LABEL: test_x86_ssse3_phadd_w_128:
; AVX:       ## %bb.0:
; AVX-NEXT:    vphaddw %xmm1, %xmm0, %xmm0 ## encoding: [0xc4,0xe2,0x79,0x01,0xc1]
; AVX-NEXT:    ret{{[l|q]}} ## encoding: [0xc3]
  %res = call <8 x i16> @llvm.x86.ssse3.phadd.w.128(<8 x i16> %a0, <8 x i16> %a1) ; <<8 x i16>> [#uses=1]
  ret <8 x i16> %res
}
declare <8 x i16> @llvm.x86.ssse3.phadd.w.128(<8 x i16>, <8 x i16>) nounwind readnone


define <4 x i32> @test_x86_ssse3_phsub_d_128(<4 x i32> %a0, <4 x i32> %a1) {
; SSE-LABEL: test_x86_ssse3_phsub_d_128:
; SSE:       ## %bb.0:
; SSE-NEXT:    phsubd %xmm1, %xmm0 ## encoding: [0x66,0x0f,0x38,0x06,0xc1]
; SSE-NEXT:    ret{{[l|q]}} ## encoding: [0xc3]
;
; AVX-LABEL: test_x86_ssse3_phsub_d_128:
; AVX:       ## %bb.0:
; AVX-NEXT:    vphsubd %xmm1, %xmm0, %xmm0 ## encoding: [0xc4,0xe2,0x79,0x06,0xc1]
; AVX-NEXT:    ret{{[l|q]}} ## encoding: [0xc3]
  %res = call <4 x i32> @llvm.x86.ssse3.phsub.d.128(<4 x i32> %a0, <4 x i32> %a1) ; <<4 x i32>> [#uses=1]
  ret <4 x i32> %res
}
declare <4 x i32> @llvm.x86.ssse3.phsub.d.128(<4 x i32>, <4 x i32>) nounwind readnone


define <8 x i16> @test_x86_ssse3_phsub_sw_128(<8 x i16> %a0, <8 x i16> %a1) {
; SSE-LABEL: test_x86_ssse3_phsub_sw_128:
; SSE:       ## %bb.0:
; SSE-NEXT:    phsubsw %xmm1, %xmm0 ## encoding: [0x66,0x0f,0x38,0x07,0xc1]
; SSE-NEXT:    ret{{[l|q]}} ## encoding: [0xc3]
;
; AVX-LABEL: test_x86_ssse3_phsub_sw_128:
; AVX:       ## %bb.0:
; AVX-NEXT:    vphsubsw %xmm1, %xmm0, %xmm0 ## encoding: [0xc4,0xe2,0x79,0x07,0xc1]
; AVX-NEXT:    ret{{[l|q]}} ## encoding: [0xc3]
  %res = call <8 x i16> @llvm.x86.ssse3.phsub.sw.128(<8 x i16> %a0, <8 x i16> %a1) ; <<8 x i16>> [#uses=1]
  ret <8 x i16> %res
}
declare <8 x i16> @llvm.x86.ssse3.phsub.sw.128(<8 x i16>, <8 x i16>) nounwind readnone


define <8 x i16> @test_x86_ssse3_phsub_w_128(<8 x i16> %a0, <8 x i16> %a1) {
; SSE-LABEL: test_x86_ssse3_phsub_w_128:
; SSE:       ## %bb.0:
; SSE-NEXT:    phsubw %xmm1, %xmm0 ## encoding: [0x66,0x0f,0x38,0x05,0xc1]
; SSE-NEXT:    ret{{[l|q]}} ## encoding: [0xc3]
;
; AVX-LABEL: test_x86_ssse3_phsub_w_128:
; AVX:       ## %bb.0:
; AVX-NEXT:    vphsubw %xmm1, %xmm0, %xmm0 ## encoding: [0xc4,0xe2,0x79,0x05,0xc1]
; AVX-NEXT:    ret{{[l|q]}} ## encoding: [0xc3]
  %res = call <8 x i16> @llvm.x86.ssse3.phsub.w.128(<8 x i16> %a0, <8 x i16> %a1) ; <<8 x i16>> [#uses=1]
  ret <8 x i16> %res
}
declare <8 x i16> @llvm.x86.ssse3.phsub.w.128(<8 x i16>, <8 x i16>) nounwind readnone


define <8 x i16> @test_x86_ssse3_pmadd_ub_sw_128(<16 x i8> %a0, <16 x i8> %a1) {
; SSE-LABEL: test_x86_ssse3_pmadd_ub_sw_128:
; SSE:       ## %bb.0:
; SSE-NEXT:    pmaddubsw %xmm1, %xmm0 ## encoding: [0x66,0x0f,0x38,0x04,0xc1]
; SSE-NEXT:    ret{{[l|q]}} ## encoding: [0xc3]
;
; AVX1-LABEL: test_x86_ssse3_pmadd_ub_sw_128:
; AVX1:       ## %bb.0:
; AVX1-NEXT:    vpmaddubsw %xmm1, %xmm0, %xmm0 ## encoding: [0xc4,0xe2,0x79,0x04,0xc1]
; AVX1-NEXT:    ret{{[l|q]}} ## encoding: [0xc3]
;
; AVX512-LABEL: test_x86_ssse3_pmadd_ub_sw_128:
; AVX512:       ## %bb.0:
; AVX512-NEXT:    vpmaddubsw %xmm1, %xmm0, %xmm0 ## EVEX TO VEX Compression encoding: [0xc4,0xe2,0x79,0x04,0xc1]
; AVX512-NEXT:    ret{{[l|q]}} ## encoding: [0xc3]
  %res = call <8 x i16> @llvm.x86.ssse3.pmadd.ub.sw.128(<16 x i8> %a0, <16 x i8> %a1) ; <<8 x i16>> [#uses=1]
  ret <8 x i16> %res
}
declare <8 x i16> @llvm.x86.ssse3.pmadd.ub.sw.128(<16 x i8>, <16 x i8>) nounwind readnone


; Make sure we don't commute this operation.
define <8 x i16> @test_x86_ssse3_pmadd_ub_sw_128_load_op0(ptr %ptr, <16 x i8> %a1) {
; X86-SSE-LABEL: test_x86_ssse3_pmadd_ub_sw_128_load_op0:
; X86-SSE:       ## %bb.0:
; X86-SSE-NEXT:    movl {{[0-9]+}}(%esp), %eax ## encoding: [0x8b,0x44,0x24,0x04]
; X86-SSE-NEXT:    movdqa (%eax), %xmm1 ## encoding: [0x66,0x0f,0x6f,0x08]
; X86-SSE-NEXT:    pmaddubsw %xmm0, %xmm1 ## encoding: [0x66,0x0f,0x38,0x04,0xc8]
; X86-SSE-NEXT:    movdqa %xmm1, %xmm0 ## encoding: [0x66,0x0f,0x6f,0xc1]
; X86-SSE-NEXT:    retl ## encoding: [0xc3]
;
; X86-AVX1-LABEL: test_x86_ssse3_pmadd_ub_sw_128_load_op0:
; X86-AVX1:       ## %bb.0:
; X86-AVX1-NEXT:    movl {{[0-9]+}}(%esp), %eax ## encoding: [0x8b,0x44,0x24,0x04]
; X86-AVX1-NEXT:    vmovdqa (%eax), %xmm1 ## encoding: [0xc5,0xf9,0x6f,0x08]
; X86-AVX1-NEXT:    vpmaddubsw %xmm0, %xmm1, %xmm0 ## encoding: [0xc4,0xe2,0x71,0x04,0xc0]
; X86-AVX1-NEXT:    retl ## encoding: [0xc3]
;
; X86-AVX512-LABEL: test_x86_ssse3_pmadd_ub_sw_128_load_op0:
; X86-AVX512:       ## %bb.0:
; X86-AVX512-NEXT:    movl {{[0-9]+}}(%esp), %eax ## encoding: [0x8b,0x44,0x24,0x04]
; X86-AVX512-NEXT:    vmovdqa (%eax), %xmm1 ## EVEX TO VEX Compression encoding: [0xc5,0xf9,0x6f,0x08]
; X86-AVX512-NEXT:    vpmaddubsw %xmm0, %xmm1, %xmm0 ## EVEX TO VEX Compression encoding: [0xc4,0xe2,0x71,0x04,0xc0]
; X86-AVX512-NEXT:    retl ## encoding: [0xc3]
;
; X64-SSE-LABEL: test_x86_ssse3_pmadd_ub_sw_128_load_op0:
; X64-SSE:       ## %bb.0:
; X64-SSE-NEXT:    movdqa (%rdi), %xmm1 ## encoding: [0x66,0x0f,0x6f,0x0f]
; X64-SSE-NEXT:    pmaddubsw %xmm0, %xmm1 ## encoding: [0x66,0x0f,0x38,0x04,0xc8]
; X64-SSE-NEXT:    movdqa %xmm1, %xmm0 ## encoding: [0x66,0x0f,0x6f,0xc1]
; X64-SSE-NEXT:    retq ## encoding: [0xc3]
;
; X64-AVX1-LABEL: test_x86_ssse3_pmadd_ub_sw_128_load_op0:
; X64-AVX1:       ## %bb.0:
; X64-AVX1-NEXT:    vmovdqa (%rdi), %xmm1 ## encoding: [0xc5,0xf9,0x6f,0x0f]
; X64-AVX1-NEXT:    vpmaddubsw %xmm0, %xmm1, %xmm0 ## encoding: [0xc4,0xe2,0x71,0x04,0xc0]
; X64-AVX1-NEXT:    retq ## encoding: [0xc3]
;
; X64-AVX512-LABEL: test_x86_ssse3_pmadd_ub_sw_128_load_op0:
; X64-AVX512:       ## %bb.0:
; X64-AVX512-NEXT:    vmovdqa (%rdi), %xmm1 ## EVEX TO VEX Compression encoding: [0xc5,0xf9,0x6f,0x0f]
; X64-AVX512-NEXT:    vpmaddubsw %xmm0, %xmm1, %xmm0 ## EVEX TO VEX Compression encoding: [0xc4,0xe2,0x71,0x04,0xc0]
; X64-AVX512-NEXT:    retq ## encoding: [0xc3]
  %a0 = load <16 x i8>, ptr %ptr
  %res = call <8 x i16> @llvm.x86.ssse3.pmadd.ub.sw.128(<16 x i8> %a0, <16 x i8> %a1) ; <<8 x i16>> [#uses=1]
  ret <8 x i16> %res
}


define <8 x i16> @test_x86_ssse3_pmul_hr_sw_128(<8 x i16> %a0, <8 x i16> %a1) {
; SSE-LABEL: test_x86_ssse3_pmul_hr_sw_128:
; SSE:       ## %bb.0:
; SSE-NEXT:    pmulhrsw %xmm1, %xmm0 ## encoding: [0x66,0x0f,0x38,0x0b,0xc1]
; SSE-NEXT:    ret{{[l|q]}} ## encoding: [0xc3]
;
; AVX1-LABEL: test_x86_ssse3_pmul_hr_sw_128:
; AVX1:       ## %bb.0:
; AVX1-NEXT:    vpmulhrsw %xmm1, %xmm0, %xmm0 ## encoding: [0xc4,0xe2,0x79,0x0b,0xc1]
; AVX1-NEXT:    ret{{[l|q]}} ## encoding: [0xc3]
;
; AVX512-LABEL: test_x86_ssse3_pmul_hr_sw_128:
; AVX512:       ## %bb.0:
; AVX512-NEXT:    vpmulhrsw %xmm1, %xmm0, %xmm0 ## EVEX TO VEX Compression encoding: [0xc4,0xe2,0x79,0x0b,0xc1]
; AVX512-NEXT:    ret{{[l|q]}} ## encoding: [0xc3]
  %res = call <8 x i16> @llvm.x86.ssse3.pmul.hr.sw.128(<8 x i16> %a0, <8 x i16> %a1) ; <<8 x i16>> [#uses=1]
  ret <8 x i16> %res
}
declare <8 x i16> @llvm.x86.ssse3.pmul.hr.sw.128(<8 x i16>, <8 x i16>) nounwind readnone


define <16 x i8> @test_x86_ssse3_pshuf_b_128(<16 x i8> %a0, <16 x i8> %a1) {
; SSE-LABEL: test_x86_ssse3_pshuf_b_128:
; SSE:       ## %bb.0:
; SSE-NEXT:    pshufb %xmm1, %xmm0 ## encoding: [0x66,0x0f,0x38,0x00,0xc1]
; SSE-NEXT:    ret{{[l|q]}} ## encoding: [0xc3]
;
; AVX1-LABEL: test_x86_ssse3_pshuf_b_128:
; AVX1:       ## %bb.0:
; AVX1-NEXT:    vpshufb %xmm1, %xmm0, %xmm0 ## encoding: [0xc4,0xe2,0x79,0x00,0xc1]
; AVX1-NEXT:    ret{{[l|q]}} ## encoding: [0xc3]
;
; AVX512-LABEL: test_x86_ssse3_pshuf_b_128:
; AVX512:       ## %bb.0:
; AVX512-NEXT:    vpshufb %xmm1, %xmm0, %xmm0 ## EVEX TO VEX Compression encoding: [0xc4,0xe2,0x79,0x00,0xc1]
; AVX512-NEXT:    ret{{[l|q]}} ## encoding: [0xc3]
  %res = call <16 x i8> @llvm.x86.ssse3.pshuf.b.128(<16 x i8> %a0, <16 x i8> %a1) ; <<16 x i8>> [#uses=1]
  ret <16 x i8> %res
}
declare <16 x i8> @llvm.x86.ssse3.pshuf.b.128(<16 x i8>, <16 x i8>) nounwind readnone


define <16 x i8> @test_x86_ssse3_psign_b_128(<16 x i8> %a0, <16 x i8> %a1) {
; SSE-LABEL: test_x86_ssse3_psign_b_128:
; SSE:       ## %bb.0:
; SSE-NEXT:    psignb %xmm1, %xmm0 ## encoding: [0x66,0x0f,0x38,0x08,0xc1]
; SSE-NEXT:    ret{{[l|q]}} ## encoding: [0xc3]
;
; AVX-LABEL: test_x86_ssse3_psign_b_128:
; AVX:       ## %bb.0:
; AVX-NEXT:    vpsignb %xmm1, %xmm0, %xmm0 ## encoding: [0xc4,0xe2,0x79,0x08,0xc1]
; AVX-NEXT:    ret{{[l|q]}} ## encoding: [0xc3]
  %res = call <16 x i8> @llvm.x86.ssse3.psign.b.128(<16 x i8> %a0, <16 x i8> %a1) ; <<16 x i8>> [#uses=1]
  ret <16 x i8> %res
}
declare <16 x i8> @llvm.x86.ssse3.psign.b.128(<16 x i8>, <16 x i8>) nounwind readnone


define <4 x i32> @test_x86_ssse3_psign_d_128(<4 x i32> %a0, <4 x i32> %a1) {
; SSE-LABEL: test_x86_ssse3_psign_d_128:
; SSE:       ## %bb.0:
; SSE-NEXT:    psignd %xmm1, %xmm0 ## encoding: [0x66,0x0f,0x38,0x0a,0xc1]
; SSE-NEXT:    ret{{[l|q]}} ## encoding: [0xc3]
;
; AVX-LABEL: test_x86_ssse3_psign_d_128:
; AVX:       ## %bb.0:
; AVX-NEXT:    vpsignd %xmm1, %xmm0, %xmm0 ## encoding: [0xc4,0xe2,0x79,0x0a,0xc1]
; AVX-NEXT:    ret{{[l|q]}} ## encoding: [0xc3]
  %res = call <4 x i32> @llvm.x86.ssse3.psign.d.128(<4 x i32> %a0, <4 x i32> %a1) ; <<4 x i32>> [#uses=1]
  ret <4 x i32> %res
}
declare <4 x i32> @llvm.x86.ssse3.psign.d.128(<4 x i32>, <4 x i32>) nounwind readnone


define <8 x i16> @test_x86_ssse3_psign_w_128(<8 x i16> %a0, <8 x i16> %a1) {
; SSE-LABEL: test_x86_ssse3_psign_w_128:
; SSE:       ## %bb.0:
; SSE-NEXT:    psignw %xmm1, %xmm0 ## encoding: [0x66,0x0f,0x38,0x09,0xc1]
; SSE-NEXT:    ret{{[l|q]}} ## encoding: [0xc3]
;
; AVX-LABEL: test_x86_ssse3_psign_w_128:
; AVX:       ## %bb.0:
; AVX-NEXT:    vpsignw %xmm1, %xmm0, %xmm0 ## encoding: [0xc4,0xe2,0x79,0x09,0xc1]
; AVX-NEXT:    ret{{[l|q]}} ## encoding: [0xc3]
  %res = call <8 x i16> @llvm.x86.ssse3.psign.w.128(<8 x i16> %a0, <8 x i16> %a1) ; <<8 x i16>> [#uses=1]
  ret <8 x i16> %res
}
declare <8 x i16> @llvm.x86.ssse3.psign.w.128(<8 x i16>, <8 x i16>) nounwind readnone
