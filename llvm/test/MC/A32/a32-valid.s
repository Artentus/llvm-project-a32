# RUN: llvm-mc %s -triple=a32 -show-encoding \
# RUN:     | FileCheck -check-prefixes=CHECK,CHECK-INST %s
# RUN: llvm-mc -filetype=obj -triple=a32 < %s \
# RUN:     | llvm-objdump -d -r - | FileCheck -check-prefix=CHECK-OBJ %s

# CHECK-INST: nop
# CHECK: encoding: [0x00,0x00,0x00,0x00]
nop

# CHECK-INST: and ra, sp, a0
# CHECK-OBJ: and ra, sp, a0
# CHECK: encoding: [0xa1,0x20,0x06,0x00]
and ra, sp, a0

# CHECK-INST: xor a1, a2, 10
# CHECK-OBJ: xor a1, a2, 10
# CHECK: encoding: [0x32,0x52,0x14,0x00]
xor a1, a2, 10

# CHECK-INST: mul a3, a4, -10
# CHECK-OBJ: mul a3, a4, -10
# CHECK: encoding: [0x52,0x73,0xec,0xff]
mul a3, a4, -10

# CHECK-INST: link t1, 8
# CHECK: encoding: [0x24,0x06,0x10,0x00]
link t1, 8

# CHECK-INST: ldui t2, 1755879355
# CHECK-OBJ: ldui t2, 1755877376
# CHECK: encoding: [0xc4,0x26,0x2a,0x3a]
ldui t2, 1755879355
