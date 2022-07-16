//===-- A32MCTargetDesc.h - A32 Target Descriptions ---------*- C++ -*-===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//
//
// This file provides A32 specific target descriptions.
//
//===----------------------------------------------------------------------===//

#ifndef LLVM_LIB_TARGET_A32_MCTARGETDESC_A32MCTARGETDESC_H
#define LLVM_LIB_TARGET_A32_MCTARGETDESC_A32MCTARGETDESC_H

#include "llvm/Config/config.h"
#include "llvm/MC/MCTargetOptions.h"
#include "llvm/Support/DataTypes.h"
#include <memory>

namespace llvm {
class MCAsmBackend;
class MCCodeEmitter;
class MCContext;
class MCInstrInfo;
class MCObjectTargetWriter;
class MCRegisterInfo;
class MCSubtargetInfo;
class Target;

MCCodeEmitter *createA32MCCodeEmitter(
    const MCInstrInfo &MCII,
    MCContext &Ctx
);

MCAsmBackend *createA32AsmBackend(
    const Target &T,
    const MCSubtargetInfo &STI,
    const MCRegisterInfo &MRI,
    const MCTargetOptions &Options
);

std::unique_ptr<MCObjectTargetWriter> createA32ELFObjectWriter(
    uint8_t OSABI,
    bool Is64Bit
);
}

// Defines symbolic names for A32 registers.
#define GET_REGINFO_ENUM
#include "A32GenRegisterInfo.inc"

// Defines symbolic names for A32 instructions.
#define GET_INSTRINFO_ENUM
#define GET_INSTRINFO_MC_HELPER_DECLS
#include "A32GenInstrInfo.inc"

#define GET_SUBTARGETINFO_ENUM
#include "A32GenSubtargetInfo.inc"

#endif
