; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -mtriple=aarch64-linux-gnu -mattr=+sme -verify-machineinstrs < %s | FileCheck %s

define <vscale x 16 x i8> @test_uclamp_i8(<vscale x 16 x i8> %a, <vscale x 16 x i8> %b, <vscale x 16 x i8> %c) {
; CHECK-LABEL: test_uclamp_i8:
; CHECK:       // %bb.0:
; CHECK-NEXT:    uclamp z2.b, z0.b, z1.b
; CHECK-NEXT:    mov z0.d, z2.d
; CHECK-NEXT:    ret
  %res = call <vscale x 16 x i8> @llvm.aarch64.sve.uclamp.nxv16i8(<vscale x 16 x i8> %a, <vscale x 16 x i8> %b, <vscale x 16 x i8> %c)
  ret <vscale x 16 x i8> %res
}

define <vscale x 8 x i16> @test_uclamp_i16(<vscale x 8 x i16> %a, <vscale x 8 x i16> %b, <vscale x 8 x i16> %c) {
; CHECK-LABEL: test_uclamp_i16:
; CHECK:       // %bb.0:
; CHECK-NEXT:    uclamp z2.h, z0.h, z1.h
; CHECK-NEXT:    mov z0.d, z2.d
; CHECK-NEXT:    ret
  %res = call <vscale x  8 x i16> @llvm.aarch64.sve.uclamp.nxv8i16(<vscale x  8 x i16> %a, <vscale x 8 x i16> %b, <vscale x 8 x i16> %c)
  ret <vscale x 8 x i16> %res
}

define <vscale x 4 x i32> @test_uclamp_i32(<vscale x 4 x i32> %a, <vscale x 4 x i32> %b, <vscale x 4 x i32> %c) {
; CHECK-LABEL: test_uclamp_i32:
; CHECK:       // %bb.0:
; CHECK-NEXT:    uclamp z2.s, z0.s, z1.s
; CHECK-NEXT:    mov z0.d, z2.d
; CHECK-NEXT:    ret
  %res = call <vscale x 4 x i32> @llvm.aarch64.sve.uclamp.nxv4i32(<vscale x 4 x i32> %a, <vscale x 4 x i32> %b, <vscale x 4 x i32> %c)
  ret <vscale x 4 x i32> %res
}

define <vscale x 2 x i64> @test_uclamp_i64(<vscale x 2 x i64> %a, <vscale x 2 x i64> %b, <vscale x 2 x i64> %c) {
; CHECK-LABEL: test_uclamp_i64:
; CHECK:       // %bb.0:
; CHECK-NEXT:    uclamp z2.d, z0.d, z1.d
; CHECK-NEXT:    mov z0.d, z2.d
; CHECK-NEXT:    ret
  %res = call <vscale x 2 x i64> @llvm.aarch64.sve.uclamp.nxv2i64(<vscale x 2 x i64> %a, <vscale x 2 x i64> %b, <vscale x 2 x i64> %c)
  ret <vscale x 2 x i64> %res
}

declare <vscale x 16 x i8> @llvm.aarch64.sve.uclamp.nxv16i8(<vscale x 16 x i8>, <vscale x 16 x i8>, <vscale x 16 x i8>)
declare <vscale x 8 x i16> @llvm.aarch64.sve.uclamp.nxv8i16(<vscale x 8 x i16>, <vscale x 8 x i16>, <vscale x 8 x i16>)
declare <vscale x 4 x i32> @llvm.aarch64.sve.uclamp.nxv4i32(<vscale x 4 x i32>, <vscale x 4 x i32>, <vscale x 4 x i32>)
declare <vscale x 2 x i64> @llvm.aarch64.sve.uclamp.nxv2i64(<vscale x 2 x i64>, <vscale x 2 x i64>, <vscale x 2 x i64>)
