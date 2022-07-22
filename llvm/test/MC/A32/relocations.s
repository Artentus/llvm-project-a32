# RUN: llvm-mc -triple=a32 < %s -show-encoding \
# RUN:     | FileCheck -check-prefix=INSTR -check-prefix=FIXUP %s
# RUN: llvm-mc -filetype=obj -triple=a32 -mattr=+c < %s \
# RUN:     | llvm-readobj -r - | FileCheck -check-prefix=RELOC %s

# Check prefixes:
# RELOC - Check the relocation in the object.
# FIXUP - Check the fixup on the instruction.
# INSTR - Check the instruction is handled properly by the ASMPrinter

.long foo
# RELOC: R_A32_32 foo

.quad foo
# RELOC: R_A32_64 foo

ldui t1, %hi(foo)
# RELOC: R_A32_HI20 foo 0x0
# INSTR: ldui t1, %hi(foo)
# FIXUP: fixup A - offset: 0, value: %hi(foo), kind: fixup_a32_hi20

ldui t1, %hi(foo+4)
# RELOC: R_A32_HI20 foo 0x4
# INSTR: ldui t1, %hi(foo+4)
# FIXUP: fixup A - offset: 0, value: %hi(foo+4), kind: fixup_a32_hi20

add t1, t1, %lo(foo)
# RELOC: R_A32_LO12 foo 0x0
# INSTR: add t1, t1, %lo(foo)
# FIXUP: fixup A - offset: 0, value: %lo(foo), kind: fixup_a32_lo12

add t1, t1, %lo(foo+4)
# RELOC: R_A32_LO12 foo 0x4
# INSTR: add t1, t1, %lo(foo+4)
# FIXUP: fixup A - offset: 0, value: %lo(foo+4), kind: fixup_a32_lo12

addpcui t1, %pchi(foo)
# RELOC: R_A32_HI20_PCREL foo 0x0
# INSTR: addpcui t1, %pchi(foo)
# FIXUP: fixup A - offset: 0, value: %pchi(foo), kind: fixup_a32_hi20_pcrel

addpcui t1, %pchi(foo+4)
# RELOC: R_A32_HI20_PCREL foo 0x4
# INSTR: addpcui t1, %pchi(foo+4)
# FIXUP: fixup A - offset: 0, value: %pchi(foo+4), kind: fixup_a32_hi20_pcrel

add t1, t1, %pclo(foo)
# RELOC: R_A32_LO12_PCREL foo 0x0
# INSTR: add t1, t1, %pclo(foo)
# FIXUP: fixup A - offset: 0, value: %pclo(foo), kind: fixup_a32_lo12_pcrel

jr foo
# RELOC: R_A32_BRANCH foo 0x0
# INSTR: jr foo
# FIXUP: fixup A - offset: 0, value: foo, kind: fixup_a32_branch

jr (foo+4)
# RELOC: R_A32_BRANCH foo 0x4
# INSTR: jr foo+4
# FIXUP: fixup A - offset: 0, value: foo+4, kind: fixup_a32_branch
