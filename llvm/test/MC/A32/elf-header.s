# RUN: llvm-mc %s -filetype=obj -triple=a32 | llvm-readobj -h - \
# RUN:     | FileCheck -check-prefix=A32 %s

# A32: Format: elf32-a32
# A32: Arch: a32
# A32: AddressSize: 32bit
# A32: ElfHeader {
# A32:   Ident {
# A32:     Magic: (7F 45 4C 46)
# A32:     Class: 32-bit (0x1)
# A32:     DataEncoding: LittleEndian (0x1)
# A32:     FileVersion: 1
# A32:     OS/ABI: SystemV (0x0)
# A32:     ABIVersion: 0
# A32:   }
# A32:   Type: Relocatable (0x1)
# A32:   Machine: EM_A32 (0x320)
# A32:   Version: 1
# A32:   Flags [ (0x0)
# A32:   ]
# A32: }
