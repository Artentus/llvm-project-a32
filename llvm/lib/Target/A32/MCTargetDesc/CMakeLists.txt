add_llvm_component_library(LLVMA32Desc
  A32AsmBackend.cpp
  A32ELFObjectWriter.cpp
  A32InstPrinter.cpp
  A32MCAsmInfo.cpp
  A32MCCodeEmitter.cpp
  A32MCTargetDesc.cpp

  LINK_COMPONENTS
  MC
  A32Info
  Support

  ADD_TO_COMPONENT
  A32
)
