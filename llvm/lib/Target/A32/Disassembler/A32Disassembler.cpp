//===-- A32Disassembler.cpp - Disassembler for A32 --------------------===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//
//
// This file implements the A32Disassembler class.
//
//===----------------------------------------------------------------------===//

#include "MCTargetDesc/A32MCTargetDesc.h"
#include "TargetInfo/A32TargetInfo.h"
#include "llvm/MC/MCContext.h"
#include "llvm/MC/MCDecoderOps.h"
#include "llvm/MC/MCDisassembler/MCDisassembler.h"
#include "llvm/MC/MCInst.h"
#include "llvm/MC/MCInstrInfo.h"
#include "llvm/MC/MCRegisterInfo.h"
#include "llvm/MC/MCSubtargetInfo.h"
#include "llvm/MC/TargetRegistry.h"
#include "llvm/Support/Endian.h"

using namespace llvm;

#define DEBUG_TYPE "a32-disassembler"

typedef MCDisassembler::DecodeStatus DecodeStatus;

namespace {
class A32Disassembler : public MCDisassembler {
  std::unique_ptr<MCInstrInfo const> const MCII;

public:
  A32Disassembler(const MCSubtargetInfo &STI, MCContext &Ctx,
                    MCInstrInfo const *MCII)
      : MCDisassembler(STI, Ctx), MCII(MCII) {}

  DecodeStatus getInstruction(MCInst &Instr, uint64_t &Size,
                              ArrayRef<uint8_t> Bytes, uint64_t Address,
                              raw_ostream &CStream) const override;
};
} // end anonymous namespace

static MCDisassembler *createA32Disassembler(const Target &T,
                                               const MCSubtargetInfo &STI,
                                               MCContext &Ctx) {
  return new A32Disassembler(STI, Ctx, T.createMCInstrInfo());
}

extern "C" LLVM_EXTERNAL_VISIBILITY void LLVMInitializeA32Disassembler() {
  TargetRegistry::RegisterMCDisassembler(getTheA32Target(), createA32Disassembler);
}

static const unsigned GPRDecoderTable[] = {
  A32::R0,  A32::R1,  A32::R2,  A32::R3,
  A32::R4,  A32::R5,  A32::R6,  A32::R7,
  A32::R8,  A32::R9,  A32::R10, A32::R11,
  A32::R12, A32::R13, A32::R14, A32::R15,
  A32::R16, A32::R17, A32::R18, A32::R19,
  A32::R20, A32::R21, A32::R22, A32::R23,
  A32::R24, A32::R25, A32::R26, A32::R27,
  A32::R28, A32::R29, A32::R30, A32::R31
};

static DecodeStatus DecodeGPRRegisterClass(MCInst &Inst, uint64_t RegNo,
                                           uint64_t Address,
                                           const void *Decoder) {
   if (RegNo > sizeof(GPRDecoderTable))
     return MCDisassembler::Fail;

   // We must define our own mapping from RegNo to register identifier.
   // Accessing index RegNo in the register class will work in the case that
   // registers were added in ascending order, but not in general.
   unsigned Reg = GPRDecoderTable[RegNo];
   Inst.addOperand(MCOperand::createReg(Reg));
   return MCDisassembler::Success;
}

template <unsigned N>
static DecodeStatus decodeImmOperand(MCInst &Inst, uint64_t Imm,
                                      int64_t Address, const void *Decoder) {
  assert(isUInt<N>(Imm) && "Invalid immediate");
  // Sign-extend the number in the bottom N bits of Imm
  Inst.addOperand(MCOperand::createImm(SignExtend64<N>(Imm)));
  return MCDisassembler::Success;
}

#include "A32GenDisassemblerTables.inc"

DecodeStatus A32Disassembler::getInstruction(MCInst &MI, uint64_t &Size,
                                               ArrayRef<uint8_t> Bytes,
                                               uint64_t Address,
                                               raw_ostream &CS) const {
  Size = 4;
  if (Bytes.size() < 4) {
    Size = 0;
    return MCDisassembler::Fail;
  }

  // Get the four bytes of the instruction.
  uint32_t Inst = support::endian::read32le(Bytes.data());

  return decodeInstruction(DecoderTable32, MI, Inst, Address, this, STI);
}
