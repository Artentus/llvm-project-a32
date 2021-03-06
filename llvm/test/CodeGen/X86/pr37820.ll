; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -mtriple=x86_64-unknown-linux-gnu %s -o - | FileCheck %s

@a = external dso_local local_unnamed_addr global i64, align 8
@c = external dso_local local_unnamed_addr global i64, align 8
@b = external dso_local local_unnamed_addr global i64, align 8

; Should generate a 16-bit load

define void @foo() {
; CHECK-LABEL: foo:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    movzwl a+6(%rip), %eax
; CHECK-NEXT:    movq %rax, b(%rip)
; CHECK-NEXT:    retq
entry:
  %0 = load i64, ptr @a, align 8
  %1 = load i64, ptr @c, align 8
  %and = and i64 %1, -16384
  %add = add nsw i64 %and, 4503359447364223024
  %shr = lshr i64 %0, %add
  %conv1 = and i64 %shr, 4294967295
  store i64 %conv1, ptr @b, align 8
  ret void
}
