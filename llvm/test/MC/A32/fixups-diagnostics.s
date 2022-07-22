# RUN: not llvm-mc -triple=a32 -filetype=obj < %s -o /dev/null 2>&1 | FileCheck %s

  jr distant # CHECK: :[[@LINE]]:3: error: address out of range
  jr unaligned # CHECK: :[[@LINE]]:3: error: address must be 4-byte aligned
  add a1, t1, large_val # CHECK: :[[@LINE]]:3: error: value out of range

  .byte 0
unaligned:
  .byte 0
  .byte 0
  .byte 0

  .zero 1<<22
distant:

.set large_val, 0x8000
