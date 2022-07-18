add_llvm_component_group(A32)

set(LLVM_TARGET_DEFINITIONS A32.td)

tablegen(LLVM A32GenAsmMatcher.inc -gen-asm-matcher)
tablegen(LLVM A32GenAsmWriter.inc -gen-asm-writer)
tablegen(LLVM A32GenDisassemblerTables.inc -gen-disassembler)
tablegen(LLVM A32GenRegisterInfo.inc -gen-register-info)
tablegen(LLVM A32GenInstrInfo.inc -gen-instr-info)
tablegen(LLVM A32GenMCCodeEmitter.inc -gen-emitter)
tablegen(LLVM A32GenSubtargetInfo.inc -gen-subtarget)

add_public_tablegen_target(A32CommonTableGen)

add_llvm_target(A32CodeGen
  A32TargetMachine.cpp

  LINK_COMPONENTS
  Analysis
  AsmPrinter
  Core
  IPO
  CodeGen
  MC
  A32Desc
  A32Info
  SelectionDAG
  Support
  Target
  TransformUtils
  GlobalISel

  ADD_TO_COMPONENT
  A32
  )

add_subdirectory(AsmParser)
add_subdirectory(Disassembler)
add_subdirectory(MCTargetDesc)
add_subdirectory(TargetInfo)
