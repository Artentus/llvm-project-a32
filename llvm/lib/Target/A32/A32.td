//===-- A32.td - Describe the A32 Target Machine -------*- tablegen -*-===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//

include "llvm/Target/Target.td"

//===----------------------------------------------------------------------===//
// Registers, calling conventions, instruction descriptions.
//===----------------------------------------------------------------------===//

// include "A32Schedule.td"
include "A32RegisterInfo.td"
include "A32CallingConv.td"
include "A32InstrInfo.td"

def A32InstrInfo : InstrInfo {
  let guessInstructionProperties = 0;
}

def A32AsmParser : AsmParser {
  let ShouldEmitMatchRegisterAltName = 1;
}

//===----------------------------------------------------------------------===//
// A32 processors supported.
//===----------------------------------------------------------------------===//

def : ProcessorModel<"generic-a32", NoSchedModel, []>;

//===----------------------------------------------------------------------===//
// Define the A32 target.
//===----------------------------------------------------------------------===//

def A32 : Target {
  let InstructionSet = A32InstrInfo;
  let AssemblyParsers = [A32AsmParser];
}
