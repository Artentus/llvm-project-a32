//===-- A32AsmParser.cpp - Parse A32 assembly to MCInst instructions --===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//

#include "MCTargetDesc/A32AsmBackend.h"
#include "MCTargetDesc/A32MCExpr.h"
#include "MCTargetDesc/A32MCTargetDesc.h"
#include "TargetInfo/A32TargetInfo.h"
#include "llvm/ADT/STLExtras.h"
#include "llvm/ADT/SmallBitVector.h"
#include "llvm/ADT/SmallString.h"
#include "llvm/ADT/SmallVector.h"
#include "llvm/ADT/Statistic.h"
#include "llvm/MC/MCAssembler.h"
#include "llvm/MC/MCContext.h"
#include "llvm/MC/MCExpr.h"
#include "llvm/MC/MCInst.h"
#include "llvm/MC/MCInstBuilder.h"
#include "llvm/MC/MCInstrInfo.h"
#include "llvm/MC/MCObjectFileInfo.h"
#include "llvm/MC/MCParser/MCAsmLexer.h"
#include "llvm/MC/MCParser/MCParsedAsmOperand.h"
#include "llvm/MC/MCParser/MCTargetAsmParser.h"
#include "llvm/MC/MCRegisterInfo.h"
#include "llvm/MC/MCStreamer.h"
#include "llvm/MC/MCSubtargetInfo.h"
#include "llvm/MC/MCValue.h"
#include "llvm/MC/TargetRegistry.h"
#include "llvm/Support/Casting.h"
#include "llvm/Support/MathExtras.h"

#include <limits>

using namespace llvm;

#define DEBUG_TYPE "a32-asm-parser"

namespace {
struct A32Operand;

class A32AsmParser : public MCTargetAsmParser {
  SMLoc getLoc() const { return getParser().getTok().getLoc(); }

  bool generateImmOutOfRangeError(OperandVector &Operands, uint64_t ErrorInfo,
                                  int64_t Lower, int64_t Upper, Twine Msg);

  bool MatchAndEmitInstruction(SMLoc IDLoc, unsigned &Opcode,
                               OperandVector &Operands, MCStreamer &Out,
                               uint64_t &ErrorInfo,
                               bool MatchingInlineAsm) override;

  bool ParseRegister(unsigned &RegNo, SMLoc &StartLoc, SMLoc &EndLoc) override;
  OperandMatchResultTy tryParseRegister(unsigned &RegNo, SMLoc &StartLoc,
                                        SMLoc &EndLoc) override;

  bool ParseInstruction(ParseInstructionInfo &Info, StringRef Name,
                        SMLoc NameLoc, OperandVector &Operands) override;

  bool ParseDirective(AsmToken DirectiveID) override;

// Auto-generated instruction matching functions
#define GET_ASSEMBLER_HEADER
#include "A32GenAsmMatcher.inc"

  OperandMatchResultTy parseImmediate(OperandVector &Operands);
  OperandMatchResultTy parseRegister(OperandVector &Operands);

  bool parseOperand(OperandVector &Operands, StringRef Mnemonic);
  OperandMatchResultTy parseOperandWithModifier(OperandVector &Operands);

public:
  enum A32MatchResultTy {
    Match_Dummy = FIRST_TARGET_MATCH_RESULT_TY,
#define GET_OPERAND_DIAGNOSTIC_TYPES
#include "A32GenAsmMatcher.inc"
#undef GET_OPERAND_DIAGNOSTIC_TYPES
  };

  static bool classifySymbolRef(const MCExpr *Expr, A32MCExpr::VariantKind &Kind);

  A32AsmParser(const MCSubtargetInfo &STI, MCAsmParser &Parser,
               const MCInstrInfo &MII, const MCTargetOptions &Options)
      : MCTargetAsmParser(Options, STI, MII) {
    setAvailableFeatures(ComputeAvailableFeatures(STI.getFeatureBits()));
  }
};

/// A32Operand - Instances of this class represent a parsed machine
/// instruction
struct A32Operand : public MCParsedAsmOperand {

  enum class KindTy {
    Token,
    Register,
    Immediate,
  } Kind;

  struct RegOp {
    MCRegister RegNum;
  };

  struct ImmOp {
    const MCExpr *Val;
  };

  SMLoc StartLoc, EndLoc;
  union {
    StringRef Tok;
    RegOp Reg;
    ImmOp Imm;
  };

  A32Operand(KindTy K) : MCParsedAsmOperand(), Kind(K) {}

public:
  A32Operand(const A32Operand &o) : MCParsedAsmOperand() {
    Kind = o.Kind;
    StartLoc = o.StartLoc;
    EndLoc = o.EndLoc;
    switch (Kind) {
    case KindTy::Register:
      Reg = o.Reg;
      break;
    case KindTy::Immediate:
      Imm = o.Imm;
      break;
    case KindTy::Token:
      Tok = o.Tok;
      break;
    }
  }

  bool isToken() const override { return Kind == KindTy::Token; }
  bool isReg() const override { return Kind == KindTy::Register; }
  bool isImm() const override { return Kind == KindTy::Immediate; }
  bool isMem() const override { return false; }

  bool evaluateConstantImm(const MCExpr *Expr, int64_t &Imm, A32MCExpr::VariantKind &VK) const {
    if (auto *RE = dyn_cast<A32MCExpr>(Expr)) {
      VK = RE->getKind();
      return RE->evaluateAsConstant(Imm);
    }

    if (auto CE = dyn_cast<MCConstantExpr>(Expr)) {
      VK = A32MCExpr::VK_A32_None;
      Imm = CE->getValue();
      return true;
    }

    return false;
  }

  bool isImm15() const {
    A32MCExpr::VariantKind VK = A32MCExpr::VK_A32_None;
    int64_t Imm;
    bool IsValid;
    if (!isImm())
      return false;
    bool IsConstantImm = evaluateConstantImm(getImm(), Imm, VK);
    if (!IsConstantImm)
      IsValid = A32AsmParser::classifySymbolRef(getImm(), VK);
    else
      IsValid = isInt<15>(Imm);
    return IsValid && (
      VK == A32MCExpr::VK_A32_None
      || VK == A32MCExpr::VK_A32_LO12
      || VK == A32MCExpr::VK_A32_LO12_PCREL);
  }

  bool isImm22() const {
    A32MCExpr::VariantKind VK = A32MCExpr::VK_A32_None;
    int64_t Imm;
    bool IsValid;
    if (!isImm())
      return false;
    bool IsConstantImm = evaluateConstantImm(getImm(), Imm, VK);
    if (!IsConstantImm)
      IsValid = A32AsmParser::classifySymbolRef(getImm(), VK);
    else
      IsValid = isShiftedInt<20, 2>(Imm);
    return IsValid && VK == A32MCExpr::VK_A32_None;
  }

  bool isUI20() const {
    A32MCExpr::VariantKind VK = A32MCExpr::VK_A32_None;
    int64_t Imm;
    bool IsValid;
    if (!isImm())
      return false;
    bool IsConstantImm = evaluateConstantImm(getImm(), Imm, VK);
    if (!IsConstantImm)
      IsValid = A32AsmParser::classifySymbolRef(getImm(), VK);
    else
      IsValid = isShiftedInt<20, 12>(Imm);
    return IsValid && (
      VK == A32MCExpr::VK_A32_None
      || VK == A32MCExpr::VK_A32_HI20
      || VK == A32MCExpr::VK_A32_HI20_PCREL);
  }

  /// getStartLoc - Gets location of the first token of this operand
  SMLoc getStartLoc() const override { return StartLoc; }
  /// getEndLoc - Gets location of the last token of this operand
  SMLoc getEndLoc() const override { return EndLoc; }

  unsigned getReg() const override {
    assert(Kind == KindTy::Register && "Invalid type access!");
    return Reg.RegNum.id();
  }

  const MCExpr *getImm() const {
    assert(Kind == KindTy::Immediate && "Invalid type access!");
    return Imm.Val;
  }

  StringRef getToken() const {
    assert(Kind == KindTy::Token && "Invalid type access!");
    return Tok;
  }

  void print(raw_ostream &OS) const override {
    switch (Kind) {
    case KindTy::Immediate:
      OS << *getImm();
      break;
    case KindTy::Register:
      OS << "<register r" << getReg() << ">";
      break;
    case KindTy::Token:
      OS << "'" << getToken() << "'";
      break;
    }
  }

  static std::unique_ptr<A32Operand> createToken(StringRef Str, SMLoc S) {
    auto Op = std::make_unique<A32Operand>(KindTy::Token);
    Op->Tok = Str;
    Op->StartLoc = S;
    Op->EndLoc = S;
    return Op;
  }

  static std::unique_ptr<A32Operand> createReg(unsigned RegNo, SMLoc S,
                                               SMLoc E, bool IsGPRAsFPR = false) {
    auto Op = std::make_unique<A32Operand>(KindTy::Register);
    Op->Reg.RegNum = RegNo;
    Op->StartLoc = S;
    Op->EndLoc = E;
    return Op;
  }

  static std::unique_ptr<A32Operand> createImm(const MCExpr *Val, SMLoc S, SMLoc E) {
    auto Op = std::make_unique<A32Operand>(KindTy::Immediate);
    Op->Imm.Val = Val;
    Op->StartLoc = S;
    Op->EndLoc = E;
    return Op;
  }

  void addExpr(MCInst &Inst, const MCExpr *Expr) const {
    assert(Expr && "Expr shouldn't be null!");
    int64_t Imm = 0;
    bool IsConstant = false;
    if (auto *RE = dyn_cast<A32MCExpr>(Expr)) {
      IsConstant = RE->evaluateAsConstant(Imm);
    } else if (auto *CE = dyn_cast<MCConstantExpr>(Expr)) {
      IsConstant = true;
      Imm = CE->getValue();
    }

    if (IsConstant)
      Inst.addOperand(MCOperand::createImm(Imm));
    else
      Inst.addOperand(MCOperand::createExpr(Expr));
  }

  // Used by the TableGen Code
  void addRegOperands(MCInst &Inst, unsigned N) const {
    assert(N == 1 && "Invalid number of operands!");
    Inst.addOperand(MCOperand::createReg(getReg()));
  }

  void addImmOperands(MCInst &Inst, unsigned N) const {
    assert(N == 1 && "Invalid number of operands!");
    addExpr(Inst, getImm());
  }
};
} // end anonymous namespace.

#define GET_REGISTER_MATCHER
#define GET_SUBTARGET_FEATURE_NAME
#define GET_MATCHER_IMPLEMENTATION
#define GET_MNEMONIC_SPELL_CHECKER
#include "A32GenAsmMatcher.inc"

bool A32AsmParser::generateImmOutOfRangeError(
    OperandVector &Operands,
    uint64_t ErrorInfo,
    int64_t Lower,
    int64_t Upper,
    Twine Msg = "immediate must be an integer in the range"
) {
  SMLoc ErrorLoc = ((A32Operand &)*Operands[ErrorInfo]).getStartLoc();
  return Error(ErrorLoc, Msg + " [" + Twine(Lower) + ", " + Twine(Upper) + "]");
}

bool A32AsmParser::MatchAndEmitInstruction(SMLoc IDLoc, unsigned &Opcode,
                                             OperandVector &Operands,
                                             MCStreamer &Out,
                                             uint64_t &ErrorInfo,
                                             bool MatchingInlineAsm) {
  MCInst Inst;

  switch (MatchInstructionImpl(Operands, Inst, ErrorInfo, MatchingInlineAsm)) {
  default:
    break;
  case Match_Success:
    Inst.setLoc(IDLoc);
    Out.emitInstruction(Inst, getSTI());
    return false;
  case Match_MissingFeature:
    return Error(IDLoc, "instruction use requires an option to be enabled");
  case Match_MnemonicFail:
    return Error(IDLoc, "unrecognized instruction mnemonic");
  case Match_InvalidOperand: {
    SMLoc ErrorLoc = IDLoc;
    if (ErrorInfo != ~0U) {
      if (ErrorInfo >= Operands.size())
        return Error(ErrorLoc, "too few operands for instruction");

      ErrorLoc = ((A32Operand &)*Operands[ErrorInfo]).getStartLoc();
      if (ErrorLoc == SMLoc())
        ErrorLoc = IDLoc;
    }
    return Error(ErrorLoc, "invalid operand for instruction");
  }
  case Match_InvalidImm15: {
    SMLoc ErrorLoc = ((A32Operand &)*Operands[ErrorInfo]).getStartLoc();
    return Error(ErrorLoc, "immediate must be an integer in the range [" + Twine(-(1 << 14)) + ", " + Twine((1 << 14) - 1) + "]");
  }
  case Match_InvalidImm22: {
    SMLoc ErrorLoc = ((A32Operand &)*Operands[ErrorInfo]).getStartLoc();
    return Error(ErrorLoc, "immediate must be a multiple of 4 in the range [" + Twine(-(1 << 21)) + ", " + Twine((1 << 21) - 4) + "]");
  }
  case Match_InvalidUI20: {
    SMLoc ErrorLoc = ((A32Operand &)*Operands[ErrorInfo]).getStartLoc();
    return Error(ErrorLoc, "immediate must be a multiple of 2^12 in the range [" + Twine(-((int64_t)1 << 31)) + ", " + Twine(((int64_t)1 << 31) - ((int64_t)1 << 12)) + "]");
  }
  }

  llvm_unreachable("Unknown match type detected!");
}

bool A32AsmParser::ParseRegister(unsigned &RegNo, SMLoc &StartLoc,
                                   SMLoc &EndLoc) {
  if (tryParseRegister(RegNo, StartLoc, EndLoc) != MatchOperand_Success)
    return Error(StartLoc, "invalid register name");
  return false;
}

OperandMatchResultTy A32AsmParser::tryParseRegister(unsigned &RegNo,
                                                      SMLoc &StartLoc,
                                                      SMLoc &EndLoc) {
  const AsmToken &Tok = getParser().getTok();
  StartLoc = Tok.getLoc();
  EndLoc = Tok.getEndLoc();
  RegNo = 0;
  StringRef Name = getLexer().getTok().getIdentifier();

  if (!MatchRegisterName(Name) || !MatchRegisterAltName(Name)) {
    getParser().Lex(); // Eat identifier token.
    return MatchOperand_Success;
  }

  return MatchOperand_NoMatch;
}

OperandMatchResultTy A32AsmParser::parseRegister(OperandVector &Operands) {
  SMLoc S = getLoc();
  SMLoc E = SMLoc::getFromPointer(S.getPointer() - 1);

  switch (getLexer().getKind()) {
  default:
    return MatchOperand_NoMatch;
  case AsmToken::Identifier:
    StringRef Name = getLexer().getTok().getIdentifier();
    unsigned RegNo = MatchRegisterName(Name);
    if (RegNo == 0) {
      RegNo = MatchRegisterAltName(Name);
      if (RegNo == 0)
        return MatchOperand_NoMatch;
    }
    getLexer().Lex();
    Operands.push_back(A32Operand::createReg(RegNo, S, E));
  }
  return MatchOperand_Success;
}

OperandMatchResultTy A32AsmParser::parseImmediate(OperandVector &Operands) {
  SMLoc S = getLoc();
  SMLoc E = SMLoc::getFromPointer(S.getPointer() - 1);
  const MCExpr *Res;

  switch (getLexer().getKind()) {
  default:
    return MatchOperand_NoMatch;
  case AsmToken::LParen: {
    getParser().Lex(); // Eat '('

    const MCExpr *SubExpr;
    if (getParser().parseParenExpression(SubExpr, E))
      return MatchOperand_ParseFail;

    Res = A32MCExpr::create(SubExpr, A32MCExpr::VK_A32_None, getContext());
    break;
  }
  case AsmToken::Dot:
  case AsmToken::Minus:
  case AsmToken::Plus:
  case AsmToken::Exclaim:
  case AsmToken::Tilde:
  case AsmToken::Integer:
  case AsmToken::String:
    if (getParser().parseExpression(Res))
      return MatchOperand_ParseFail;
    break;
  case AsmToken::Identifier: {
    StringRef Identifier;
    if (getParser().parseIdentifier(Identifier))
      return MatchOperand_ParseFail;
    MCSymbol *Sym = getContext().getOrCreateSymbol(Identifier);
    Res = MCSymbolRefExpr::create(Sym, MCSymbolRefExpr::VK_None, getContext());
    break;
  }
  case AsmToken::Percent:
    return parseOperandWithModifier(Operands);
  }

  Operands.push_back(A32Operand::createImm(Res, S, E));
  return MatchOperand_Success;
}

/// Looks at a token type and creates the relevant operand from this
/// information, adding to Operands. If operand was parsed, returns false, else
/// true.
bool A32AsmParser::parseOperand(OperandVector &Operands, StringRef Mnemonic) {
  // Attempt to parse token as register
  if (parseRegister(Operands) == MatchOperand_Success)
    return false;

  // Attempt to parse token as an immediate
  if (parseImmediate(Operands) == MatchOperand_Success)
    return false;

  // Finally we have exhausted all options and must declare defeat.
  Error(getLoc(), "unknown operand");
  return true;
}

OperandMatchResultTy A32AsmParser::parseOperandWithModifier(OperandVector &Operands) {
  SMLoc S = getLoc();
  SMLoc E = SMLoc::getFromPointer(S.getPointer() - 1);

  if (getLexer().getKind() != AsmToken::Percent) {
    Error(getLoc(), "expected '%' for operand modifier");
    return MatchOperand_ParseFail;
  }

  getParser().Lex(); // Eat '%'

  if (getLexer().getKind() != AsmToken::Identifier) {
    Error(getLoc(), "expected valid identifier for operand modifier");
    return MatchOperand_ParseFail;
  }
  StringRef Identifier = getParser().getTok().getIdentifier();
  A32MCExpr::VariantKind VK = A32MCExpr::getVariantKindForName(Identifier);
  if (VK == A32MCExpr::VK_A32_Invalid) {
    Error(getLoc(), "unrecognized operand modifier");
    return MatchOperand_ParseFail;
  }

  getParser().Lex(); // Eat the identifier
  if (getLexer().getKind() != AsmToken::LParen) {
    Error(getLoc(), "expected '('");
    return MatchOperand_ParseFail;
  }
  getParser().Lex(); // Eat '('

  const MCExpr *SubExpr;
  if (getParser().parseParenExpression(SubExpr, E)) {
    return MatchOperand_ParseFail;
  }

  const MCExpr *ModExpr = A32MCExpr::create(SubExpr, VK, getContext());
  Operands.push_back(A32Operand::createImm(ModExpr, S, E));
  return MatchOperand_Success;
}

bool A32AsmParser::ParseInstruction(ParseInstructionInfo &Info,
                                      StringRef Name, SMLoc NameLoc,
                                      OperandVector &Operands) {
  // First operand is token for instruction
  Operands.push_back(A32Operand::createToken(Name, NameLoc));

  // If there are no more operands, then finish
  if (getLexer().is(AsmToken::EndOfStatement))
    return false;

  // Parse first operand
  if (parseOperand(Operands, Name))
    return true;

  // Parse until end of statement, consuming commas between operands
  while (getLexer().is(AsmToken::Comma)) {
    // Consume comma token
    getLexer().Lex();

    // Parse next operand
    if (parseOperand(Operands, Name))
      return true;
  }

  if (getLexer().isNot(AsmToken::EndOfStatement)) {
    SMLoc Loc = getLexer().getLoc();
    getParser().eatToEndOfStatement();
    return Error(Loc, "unexpected token");
  }

  getParser().Lex(); // Consume the EndOfStatement.
  return false;
}

bool A32AsmParser::classifySymbolRef(const MCExpr *Expr, A32MCExpr::VariantKind &Kind) {
  Kind = A32MCExpr::VK_A32_None;

  if (const A32MCExpr *RE = dyn_cast<A32MCExpr>(Expr)) {
    Kind = RE->getKind();
    Expr = RE->getSubExpr();
  }

  MCValue Res;
  MCFixup Fixup;
  if (Expr->evaluateAsRelocatable(Res, nullptr, &Fixup))
    return Res.getRefKind() == A32MCExpr::VK_A32_None;
  return false;
}

bool A32AsmParser::ParseDirective(AsmToken DirectiveID) {
  return true;
}

extern "C" LLVM_EXTERNAL_VISIBILITY void LLVMInitializeA32AsmParser() {
  RegisterMCAsmParser<A32AsmParser> X(getTheA32Target());
}
