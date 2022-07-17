add_llvm_component_library(LLVMA32AsmParser
  A32AsmParser.cpp

  LINK_COMPONENTS
  MC
  MCParser
  A32Desc
  A32Info
  Support

  ADD_TO_COMPONENT
  A32
  )
