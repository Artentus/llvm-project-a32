; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -fast-isel -mtriple=i686-unknown-unknown -O0 -mcpu=knl | FileCheck %s

; ModuleID = 'convert'
source_filename = "convert"
target datalayout = "e-m:e-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-unknown-linux-gnu"

define ptr @japi1_convert_690(ptr, ptr, i32) {
; CHECK-LABEL: japi1_convert_690:
; CHECK:       # %bb.0: # %top
; CHECK-NEXT:    subl $12, %esp
; CHECK-NEXT:    .cfi_def_cfa_offset 16
; CHECK-NEXT:    movl {{[0-9]+}}(%esp), %eax
; CHECK-NEXT:    movl %eax, {{[-0-9]+}}(%e{{[sb]}}p) # 4-byte Spill
; CHECK-NEXT:    calll julia.gc_root_decl@PLT
; CHECK-NEXT:    movl %eax, {{[-0-9]+}}(%e{{[sb]}}p) # 4-byte Spill
; CHECK-NEXT:    calll jl_get_ptls_states@PLT
; CHECK-NEXT:    # kill: def $ecx killed $eax
; CHECK-NEXT:    movl {{[-0-9]+}}(%e{{[sb]}}p), %eax # 4-byte Reload
; CHECK-NEXT:    movl 4(%eax), %eax
; CHECK-NEXT:    movb (%eax), %al
; CHECK-NEXT:    andb $1, %al
; CHECK-NEXT:    movzbl %al, %eax
; CHECK-NEXT:    movl %eax, (%esp)
; CHECK-NEXT:    calll jl_box_int32@PLT
; CHECK-NEXT:    movl {{[-0-9]+}}(%e{{[sb]}}p), %ecx # 4-byte Reload
; CHECK-NEXT:    movl %eax, (%ecx)
; CHECK-NEXT:    addl $12, %esp
; CHECK-NEXT:    .cfi_def_cfa_offset 4
; CHECK-NEXT:    retl
top:
  %3 = alloca ptr
  store volatile ptr %1, ptr %3
  %4 = call ptr @julia.gc_root_decl()
  %5 = call ptr @jl_get_ptls_states()
  %6 = getelementptr ptr, ptr %5, i64 3
  %7 = load ptr, ptr %6
  %8 = getelementptr ptr, ptr %1, i64 1
  %9 = load ptr, ptr %8
  %10 = load i8, ptr %9
  %11 = trunc i8 %10 to i1
  %12 = zext i1 %11 to i8
  %13 = zext i8 %12 to i32
  %14 = call ptr @jl_box_int32(i32 signext %13)
  store ptr %14, ptr %4
  ret ptr %14
}

declare ptr @jl_get_ptls_states()

declare ptr @jl_box_int32(i32)

declare ptr @julia.gc_root_decl()
