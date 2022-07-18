add_llvm_component_library(LLVMA32Disassembler
  A32Disassembler.cpp

  LINK_COMPONENTS
  MC
  MCDisassembler
  A32Desc
  A32Info
  Support

  ADD_TO_COMPONENT
  A32
  )
