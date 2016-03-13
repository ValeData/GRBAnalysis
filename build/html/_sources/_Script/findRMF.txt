findRMF
=======

.. highlight:: bash

findRMF is used for finding the corresponding response matrix file from event file.

**Input:** ``.evt`` event file name

**Output:** ``.rmf`` response matrix file name

**Example**::

		$ ./findRMF 
		Please input the FITS filename:
		sw00271019000xpcw2po_cl.evt
		: Warning: cannot read 'XRTVSUB' keyword in file 'sw00271019000xpcw2po_cl.evt'
		: Warning: using default value '0'
		: Info: CallQuzcif: Running quzcif SWIFT XRT - - matrix 2007-03-18 07:37:09 "datamode.eq.photon.and.grade.eq.G0:12.and.XRTVSUB.eq.0" retrieve+ clobber=yes
		CallQuzcif: Info: Output 'quzcif' Command: 
		CallQuzcif: Info:/Applications/heasoft/CALDB_LOCAL/data/swift/xrt/cpf/rmf/swxpc0to12s0_20070101v012.rmf   1

**Source code:**

.. literalinclude:: _code/findRMF
   :linenos:
   :language: perl