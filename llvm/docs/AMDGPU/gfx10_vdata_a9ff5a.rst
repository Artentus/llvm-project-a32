..
    **************************************************
    *                                                *
    *   Automatically generated file, do not edit!   *
    *                                                *
    **************************************************

.. _amdgpu_synid_gfx10_vdata_a9ff5a:

vdata
=====

Input data for an atomic instruction.

Optionally may serve as an output data:

* If :ref:`glc<amdgpu_synid_glc>` is specified, gets the memory value before the operation.

*Size:* depends on :ref:`dmask<amdgpu_synid_dmask>`:

* :ref:`dmask<amdgpu_synid_dmask>` may specify 2 data elements for 32-bit-per-pixel surfaces or 4 data elements for 64-bit-per-pixel surfaces. Each data element occupies 1 dword.


  Note: the surface data format is indicated in the image resource constant but not in the instruction.

*Operands:* :ref:`v<amdgpu_synid_v>`
