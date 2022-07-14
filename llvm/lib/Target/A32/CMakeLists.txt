add_llvm_component_group(A32)

add_llvm_target(A32CodeGen
  A32TargetMachine.cpp

  LINK_COMPONENTS
  Analysis
  AsmPrinter
  Core
  IPO
  CodeGen
  MC
  #A32Desc
  A32Info
  SelectionDAG
  Support
  Target
  TransformUtils
  GlobalISel

  ADD_TO_COMPONENT
  A32
  )

add_subdirectory(TargetInfo)
