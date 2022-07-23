//===-- A32CallingConv.td - Calling Conventions A32 ----*- tablegen -*-===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//
//
// This describes the calling conventions for the A32 architecture.
//
//===----------------------------------------------------------------------===//

// A32 32-bit C return-value convention.
def RetCC_A32 : CallingConv<[CCIfType<[i32], CCAssignToReg<[R3, R4]>>]>;

// A32 32-bit C calling convention.
def CC_A32 : CallingConv<[
  // Promote i8/i16 args to i32
  CCIfType<[ i8, i16 ], CCPromoteToType<i32>>,

  // All arguments get passed in integer registers if there is space.
  CCIfType<[i32], CCAssignToReg<[ R3, R4, R5, R6, R7, R8, R9, R10 ]>>,

  // Could be assigned to the stack in 8-byte aligned units, but unsupported
  CCAssignToStack<8, 8>
]>;

def CSR : CalleeSavedRegs<(add R1, (sequence "R%u", 19, 31))>;
