; RUN: llc -mtriple=i686-windows-msvc < %s | FileCheck %s

; Mostly make sure that llvm.eh.recoverfp doesn't crash if the parent
; function lacks a personality.

declare ptr @llvm.frameaddress(i32)
declare ptr @llvm.eh.recoverfp(ptr, ptr)

define i32 @main() {
entry:
  ret i32 0
}

define internal i32 @"filt$main"() {
entry:
  %ebp = tail call ptr @llvm.frameaddress(i32 1)
  %parentfp = tail call ptr @llvm.eh.recoverfp(ptr @main, ptr %ebp)
  %info.addr = getelementptr inbounds i8, ptr %ebp, i32 -20
  %0 = load ptr, ptr %info.addr, align 4
  %1 = load ptr, ptr %0, align 4
  %2 = load i32, ptr %1, align 4
  %matches = icmp eq i32 %2, u0xC0000005
  %r = zext i1 %matches to i32
  ret i32 %r
}

; CHECK: _main:
; CHECK: xorl %eax, %eax
; CHECK: retl

; CHECK: _filt$main:
; CHECK: retl
