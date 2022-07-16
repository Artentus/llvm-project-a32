//===-- A32MCCodeEmitter.cpp - Convert A32 code to machine code -------===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//
//
// This file implements the A32MCCodeEmitter class.
//
//===----------------------------------------------------------------------===//

#include "MCTargetDesc/A32MCTargetDesc.h"
#include "llvm/ADT/Statistic.h"
#include "llvm/MC/MCAsmInfo.h"
#include "llvm/MC/MCCodeEmitter.h"
#include "llvm/MC/MCContext.h"
#include "llvm/MC/MCExpr.h"
#include "llvm/MC/MCInst.h"
#include "llvm/MC/MCInstBuilder.h"
#include "llvm/MC/MCInstrInfo.h"
#include "llvm/MC/MCRegisterInfo.h"
#include "llvm/MC/MCSubtargetInfo.h"
#include "llvm/MC/MCSymbol.h"
#include "llvm/Support/Casting.h"
#include "llvm/Support/EndianStream.h"
#include "llvm/Support/raw_ostream.h"

using namespace llvm;

#define DEBUG_TYPE "mccodeemitter"

STATISTIC(MCNumEmitted, "Number of MC instructions emitted");

namespace {
class A32MCCodeEmitter : public MCCodeEmitter {
  A32MCCodeEmitter(const A32MCCodeEmitter &) = delete;
  void operator=(const A32MCCodeEmitter &) = delete;
  MCContext &Ctx;
  MCInstrInfo const &MCII;

public:
  A32MCCodeEmitter(MCContext &ctx, MCInstrInfo const &MCII)
      : Ctx(ctx), MCII(MCII) {}

  ~A32MCCodeEmitter() override = default;

  void encodeInstruction(
    const MCInst &MI,
    raw_ostream &OS,
    SmallVectorImpl<MCFixup> &Fixups,
    const MCSubtargetInfo &STI
  ) const override;

  /// TableGen'erated function for getting the binary encoding for an
  /// instruction.
  uint64_t getBinaryCodeForInstr(
    const MCInst &MI,
    SmallVectorImpl<MCFixup> &Fixups,
    const MCSubtargetInfo &STI
  ) const;

  /// Return binary encoding of operand. If the machine operand requires
  /// relocation, record the relocation and return zero.
  unsigned getMachineOpValue(
    const MCInst &MI,
    const MCOperand &MO,
    SmallVectorImpl<MCFixup> &Fixups,
    const MCSubtargetInfo &STI
  ) const;

  unsigned getImmOpValue(
    const MCInst &MI,
    unsigned OpNo,
    SmallVectorImpl<MCFixup> &Fixups,
    const MCSubtargetInfo &STI
  ) const;
};
} // end anonymous namespace

MCCodeEmitter *llvm::createA32MCCodeEmitter(
  const MCInstrInfo &MCII,
  MCContext &Ctx
) {
  return new A32MCCodeEmitter(Ctx, MCII);
}

void A32MCCodeEmitter::encodeInstruction(
  const MCInst &MI,
  raw_ostream &OS,
  SmallVectorImpl<MCFixup> &Fixups,
  const MCSubtargetInfo &STI
) const {
  uint32_t Bits = getBinaryCodeForInstr(MI, Fixups, STI);
  support::endian::write(OS, Bits, support::little);
  ++MCNumEmitted; // Keep track of the # of mi's emitted.
}

unsigned A32MCCodeEmitter::getMachineOpValue(
  const MCInst &MI,
  const MCOperand &MO,
  SmallVectorImpl<MCFixup> &Fixups,
  const MCSubtargetInfo &STI
) const {

  if (MO.isReg())
    return Ctx.getRegisterInfo()->getEncodingValue(MO.getReg());

  if (MO.isImm())
    return static_cast<unsigned>(MO.getImm());

  llvm_unreachable("Unhandled expression!");
  return 0;
}

unsigned A32MCCodeEmitter::getImmOpValue(
  const MCInst &MI,
  unsigned OpNo,
  SmallVectorImpl<MCFixup> &Fixups,
  const MCSubtargetInfo &STI
) const {
  const MCOperand &MO = MI.getOperand(OpNo);
  return MO.getImm();
}

#include "A32GenMCCodeEmitter.inc"
