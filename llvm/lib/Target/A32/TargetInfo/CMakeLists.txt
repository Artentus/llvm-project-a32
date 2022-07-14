add_llvm_component_library(LLVMA32Info
  A32TargetInfo.cpp

  LINK_COMPONENTS
  MC
  Support

  ADD_TO_COMPONENT
  A32
  )
