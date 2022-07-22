# RUN: llvm-mc -triple=a32 < %s -show-encoding \
# RUN:     | FileCheck -check-prefix=CHECK-FIXUP %s
# RUN: llvm-mc -filetype=obj -triple=a32 < %s \
# RUN:     | llvm-objdump -d - \
# RUN:     | FileCheck -check-prefix=CHECK-INSTR %s
# RUN: llvm-mc -filetype=obj -triple=a32 %s \
# RUN:     | llvm-readobj -r - | FileCheck %s -check-prefix=CHECK-REL

# Checks that fixups that can be resolved within the same object file are
# applied correctly

.LBB0:
ldui t1, %hi(val)
# CHECK-FIXUP: fixup A - offset: 0, value: %hi(val), kind: fixup_a32_hi20
# CHECK-INSTR: ldui t1, 305418240

add a1, t1, %lo(val)
# CHECK-FIXUP: fixup A - offset: 0, value: %lo(val), kind: fixup_a32_lo12
# CHECK-INSTR: add a1, t1, 1656

jr .LBB0
# CHECK-FIXUP: fixup A - offset: 0, value: .LBB0, kind: fixup_a32_branch
# CHECK-INSTR: jr 0x0

add t1, t1, %pclo(.LBB0)
# CHECK-FIXUP: fixup A - offset: 0, value: %pclo(.LBB0), kind: fixup_a32_lo12_pcrel
# CHECK-INSTR: add t1, t1, 4084

add a1, t1, small
# CHECK-FIXUP: fixup A - offset: 0, value: small, kind: fixup_a32_lo15
# CHECK-INSTR: add a1, t1, 4660

.set val, 0x12345678
.set small, 0x1234

# CHECK-REL-NOT: R_A32
