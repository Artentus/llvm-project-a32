// RUN: llvm-mc -triple=aarch64 -show-encoding -mattr=+sme < %s \
// RUN:        | FileCheck %s --check-prefixes=CHECK-ENCODING,CHECK-INST
// RUN: not llvm-mc -triple=aarch64 -show-encoding < %s 2>&1 \
// RUN:        | FileCheck %s --check-prefix=CHECK-ERROR
// RUN: llvm-mc -triple=aarch64 -filetype=obj -mattr=+sme < %s \
// RUN:        | llvm-objdump -d --mattr=+sme - | FileCheck %s --check-prefix=CHECK-INST
// RUN: llvm-mc -triple=aarch64 -filetype=obj -mattr=+sme < %s \
// RUN:   | llvm-objdump -d --mattr=-sme - | FileCheck %s --check-prefix=CHECK-UNKNOWN
// Disassemble encoding and check the re-encoding (-show-encoding) matches.
// RUN: llvm-mc -triple=aarch64 -show-encoding -mattr=+sme < %s \
// RUN:        | sed '/.text/d' | sed 's/.*encoding: //g' \
// RUN:        | llvm-mc -triple=aarch64 -mattr=+sme -disassemble -show-encoding \
// RUN:        | FileCheck %s --check-prefixes=CHECK-ENCODING,CHECK-INST

// --------------------------------------------------------------------------//
// 8-bit

uclamp  z0.b, z0.b, z0.b
// CHECK-INST: uclamp  z0.b, z0.b, z0.b
// CHECK-ENCODING: [0x00,0xc4,0x00,0x44]
// CHECK-ERROR: instruction requires: sme
// CHECK-UNKNOWN: 00 c4 00 44 <unknown>

uclamp  z21.b, z10.b, z21.b
// CHECK-INST: uclamp  z21.b, z10.b, z21.b
// CHECK-ENCODING: [0x55,0xc5,0x15,0x44]
// CHECK-ERROR: instruction requires: sme
// CHECK-UNKNOWN: 55 c5 15 44 <unknown>

uclamp  z23.b, z13.b, z8.b
// CHECK-INST: uclamp  z23.b, z13.b, z8.b
// CHECK-ENCODING: [0xb7,0xc5,0x08,0x44]
// CHECK-ERROR: instruction requires: sme
// CHECK-UNKNOWN: b7 c5 08 44 <unknown>

uclamp  z31.b, z31.b, z31.b
// CHECK-INST: uclamp  z31.b, z31.b, z31.b
// CHECK-ENCODING: [0xff,0xc7,0x1f,0x44]
// CHECK-ERROR: instruction requires: sme
// CHECK-UNKNOWN: ff c7 1f 44 <unknown>

// --------------------------------------------------------------------------//
// 16-bit

uclamp  z0.h, z0.h, z0.h
// CHECK-INST: uclamp  z0.h, z0.h, z0.h
// CHECK-ENCODING: [0x00,0xc4,0x40,0x44]
// CHECK-ERROR: instruction requires: sme
// CHECK-UNKNOWN: 00 c4 40 44 <unknown>

uclamp  z21.h, z10.h, z21.h
// CHECK-INST: uclamp  z21.h, z10.h, z21.h
// CHECK-ENCODING: [0x55,0xc5,0x55,0x44]
// CHECK-ERROR: instruction requires: sme
// CHECK-UNKNOWN: 55 c5 55 44 <unknown>

uclamp  z23.h, z13.h, z8.h
// CHECK-INST: uclamp  z23.h, z13.h, z8.h
// CHECK-ENCODING: [0xb7,0xc5,0x48,0x44]
// CHECK-ERROR: instruction requires: sme
// CHECK-UNKNOWN: b7 c5 48 44 <unknown>

uclamp  z31.h, z31.h, z31.h
// CHECK-INST: uclamp  z31.h, z31.h, z31.h
// CHECK-ENCODING: [0xff,0xc7,0x5f,0x44]
// CHECK-ERROR: instruction requires: sme
// CHECK-UNKNOWN: ff c7 5f 44 <unknown>

// --------------------------------------------------------------------------//
// 32-bit

uclamp  z0.s, z0.s, z0.s
// CHECK-INST: uclamp  z0.s, z0.s, z0.s
// CHECK-ENCODING: [0x00,0xc4,0x80,0x44]
// CHECK-ERROR: instruction requires: sme
// CHECK-UNKNOWN: 00 c4 80 44 <unknown>

uclamp  z21.s, z10.s, z21.s
// CHECK-INST: uclamp  z21.s, z10.s, z21.s
// CHECK-ENCODING: [0x55,0xc5,0x95,0x44]
// CHECK-ERROR: instruction requires: sme
// CHECK-UNKNOWN: 55 c5 95 44 <unknown>

uclamp  z23.s, z13.s, z8.s
// CHECK-INST: uclamp  z23.s, z13.s, z8.s
// CHECK-ENCODING: [0xb7,0xc5,0x88,0x44]
// CHECK-ERROR: instruction requires: sme
// CHECK-UNKNOWN: b7 c5 88 44 <unknown>

uclamp  z31.s, z31.s, z31.s
// CHECK-INST: uclamp  z31.s, z31.s, z31.s
// CHECK-ENCODING: [0xff,0xc7,0x9f,0x44]
// CHECK-ERROR: instruction requires: sme
// CHECK-UNKNOWN: ff c7 9f 44 <unknown>

// --------------------------------------------------------------------------//
// 64-bit

uclamp  z0.d, z0.d, z0.d
// CHECK-INST: uclamp  z0.d, z0.d, z0.d
// CHECK-ENCODING: [0x00,0xc4,0xc0,0x44]
// CHECK-ERROR: instruction requires: sme
// CHECK-UNKNOWN: 00 c4 c0 44 <unknown>

uclamp  z21.d, z10.d, z21.d
// CHECK-INST: uclamp  z21.d, z10.d, z21.d
// CHECK-ENCODING: [0x55,0xc5,0xd5,0x44]
// CHECK-ERROR: instruction requires: sme
// CHECK-UNKNOWN: 55 c5 d5 44 <unknown>

uclamp  z23.d, z13.d, z8.d
// CHECK-INST: uclamp  z23.d, z13.d, z8.d
// CHECK-ENCODING: [0xb7,0xc5,0xc8,0x44]
// CHECK-ERROR: instruction requires: sme
// CHECK-UNKNOWN: b7 c5 c8 44 <unknown>

uclamp  z31.d, z31.d, z31.d
// CHECK-INST: uclamp  z31.d, z31.d, z31.d
// CHECK-ENCODING: [0xff,0xc7,0xdf,0x44]
// CHECK-ERROR: instruction requires: sme
// CHECK-UNKNOWN: ff c7 df 44 <unknown>

// --------------------------------------------------------------------------//
// Test compatibility with MOVPRFX instruction.

movprfx z23, z27
// CHECK-INST: movprfx  z23, z27
// CHECK-ENCODING: [0x77,0xbf,0x20,0x04]
// CHECK-ERROR: instruction requires: sve or sme
// CHECK-UNKNOWN: 77 bf 20 04 <unknown>

uclamp  z23.b, z13.b, z8.b
// CHECK-INST: uclamp  z23.b, z13.b, z8.b
// CHECK-ENCODING: [0xb7,0xc5,0x08,0x44]
// CHECK-ERROR: instruction requires: sme
// CHECK-UNKNOWN: b7 c5 08 44 <unknown>

movprfx z23, z27
// CHECK-INST: movprfx  z23, z27
// CHECK-ENCODING: [0x77,0xbf,0x20,0x04]
// CHECK-ERROR: instruction requires: sve or sme
// CHECK-UNKNOWN: 77 bf 20 04 <unknown>

uclamp  z23.h, z13.h, z8.h
// CHECK-INST: uclamp  z23.h, z13.h, z8.h
// CHECK-ENCODING: [0xb7,0xc5,0x48,0x44]
// CHECK-ERROR: instruction requires: sme
// CHECK-UNKNOWN: b7 c5 48 44 <unknown>

movprfx z23, z27
// CHECK-INST: movprfx  z23, z27
// CHECK-ENCODING: [0x77,0xbf,0x20,0x04]
// CHECK-ERROR: instruction requires: sve or sme
// CHECK-UNKNOWN: 77 bf 20 04 <unknown>

uclamp  z23.s, z13.s, z8.s
// CHECK-INST: uclamp  z23.s, z13.s, z8.s
// CHECK-ENCODING: [0xb7,0xc5,0x88,0x44]
// CHECK-ERROR: instruction requires: sme
// CHECK-UNKNOWN: b7 c5 88 44 <unknown>

movprfx z23, z27
// CHECK-INST: movprfx  z23, z27
// CHECK-ENCODING: [0x77,0xbf,0x20,0x04]
// CHECK-ERROR: instruction requires: sve or sme
// CHECK-UNKNOWN: 77 bf 20 04 <unknown>

uclamp  z23.d, z13.d, z8.d
// CHECK-INST: uclamp  z23.d, z13.d, z8.d
// CHECK-ENCODING: [0xb7,0xc5,0xc8,0x44]
// CHECK-ERROR: instruction requires: sme
// CHECK-UNKNOWN: b7 c5 c8 44 <unknown>
