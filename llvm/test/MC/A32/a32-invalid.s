# RUN: not llvm-mc -triple=a32 < %s 2>&1 | FileCheck %s

# Out of range immediates
or a0, a1, -16385 # CHECK: :[[@LINE]]:12: error: immediate must be an integer in the range [-16384, 16383]
and ra, sp, 16384 # CHECK: :[[@LINE]]:13: error: immediate must be an integer in the range [-16384, 16383]
ldui t2, 1755879355 # CHECK: :[[@LINE]]:10: error: immediate must be a multiple of 2^12 in the range [-2147483648, 2147479552]
or a0, a1, %hi(foo) # CHECK: :[[@LINE]]:12: error: immediate must be an integer in the range [-16384, 16383]
and ra, sp, %pchi(123) # CHECK: :[[@LINE]]:13: error: immediate must be an integer in the range [-16384, 16383]
xor a2, a3, %hi(345) # CHECK: :[[@LINE]]:13: error: immediate must be an integer in the range [-16384, 16383]
ldui a0, %lo(1) # CHECK: :[[@LINE]]:10: error: immediate must be a multiple of 2^12 in the range [-2147483648, 2147479552]

# Invalid mnemonics
subs t0, t2, t1 # CHECK: :[[@LINE]]:1: error: unrecognized instruction mnemonic
nand t0, zero, 0 # CHECK: :[[@LINE]]:1: error: unrecognized instruction mnemonic

# Invalid register names
add foo, sp, 10 # CHECK: :[[@LINE]]:5: error: invalid operand for instruction
shl a10, a2, 0x20 # CHECK: :[[@LINE]]:5: error: invalid operand for instruction
lsr r32, s0, s0 # CHECK: :[[@LINE]]:5: error: invalid operand for instruction

# Invalid operand types
xor sp, 22, 220 # CHECK: :[[@LINE]]:9: error: invalid operand for instruction

# Too many operands
add ra, zero, zero, zero # CHECK: :[[@LINE]]:21: error: invalid operand for instruction
asr s2, s3, 0x50, 0x60 # CHECK: :[[@LINE]]:19: error: invalid operand for instruction

# Too few operands
or a0, a1 # CHECK: :[[@LINE]]:1: error: too few operands for instruction
xor s2, s2 # CHECK: :[[@LINE]]:1: error: too few operands for instruction

# Unrecognized operand modifier
add t0, sp, %modifer(255) # CHECK: :[[@LINE]]:14: error: unrecognized operand modifier

# Use of operand modifier on register name
add t1, %lo(t2), 1 # CHECK: :[[@LINE]]:9: error: invalid operand for instruction
