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

#include "MCTargetDesc/A32FixupKinds.h"
#include "MCTargetDesc/A32BaseInfo.h"
#include "MCTargetDesc/A32MCExpr.h"
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
STATISTIC(MCNumFixups, "Number of MC fixups created");

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
  MCInstrDesc const &Desc = MCII.get(MI.getOpcode());
  unsigned MIFrm = Desc.TSFlags & A32II::InstFormatMask;

  // If the destination is an immediate, there is nothing to do
  if (MO.isImm())
    return MO.getImm();

  assert(MO.isExpr() && "getImmOpValue expects only expressions or immediates");
  const MCExpr *Expr = MO.getExpr();
  MCExpr::ExprKind Kind = Expr->getKind();
  A32::Fixups FixupKind = A32::fixup_a32_invalid;
  if (Kind == MCExpr::Target) {
    const A32MCExpr *RVExpr = cast<A32MCExpr>(Expr);

    switch (RVExpr->getKind()) {
    case A32MCExpr::VK_A32_Invalid:
      llvm_unreachable("Unhandled fixup kind!");
    case A32MCExpr::VK_A32_None: {
      switch (MIFrm) {
      case A32II::InstFormatBranch:
        FixupKind = A32::fixup_a32_branch;
        break;
      case A32II::InstFormatRegImm:
        FixupKind = A32::fixup_a32_lo15;
        break;
      case A32II::InstFormatUI:
        FixupKind = A32::fixup_a32_hi20;
        break;
      }

      break;
    }
    case A32MCExpr::VK_A32_LO12:
      if (MIFrm == A32II::InstFormatRegImm)
        FixupKind = A32::fixup_a32_lo12;
      else
        llvm_unreachable("VK_A32_LO12 used with unexpected instruction format");
      break;
    case A32MCExpr::VK_A32_LO12_PCREL:
      if (MIFrm == A32II::InstFormatRegImm)
        FixupKind = A32::fixup_a32_lo12_pcrel;
      else
        llvm_unreachable("VK_A32_LO12_PCREL used with unexpected instruction format");
      break;
    case A32MCExpr::VK_A32_HI20:
      if (MIFrm == A32II::InstFormatUI)
        FixupKind = A32::fixup_a32_hi20;
      else
        llvm_unreachable("VK_A32_HI20 used with unexpected instruction format");
      break;
    case A32MCExpr::VK_A32_HI20_PCREL:
      if (MIFrm == A32II::InstFormatUI)
        FixupKind = A32::fixup_a32_hi20_pcrel;
      else
        llvm_unreachable("VK_A32_HI20_PCREL used with unexpected instruction format");
      break;
    }
  } else if (Kind == MCExpr::SymbolRef &&
      cast<MCSymbolRefExpr>(Expr)->getKind() == MCSymbolRefExpr::VK_None) {

    switch (MIFrm) {
    case A32II::InstFormatBranch:
      FixupKind = A32::fixup_a32_branch;
      break;
    case A32II::InstFormatRegImm:
      FixupKind = A32::fixup_a32_lo15;
      break;
    }
  }

  assert(FixupKind != A32::fixup_a32_invalid && "Unhandled expression!");

  Fixups.push_back(
      MCFixup::create(0, Expr, MCFixupKind(FixupKind), MI.getLoc()));
  ++MCNumFixups;

  return 0;
}

#include "A32GenMCCodeEmitter.inc"
