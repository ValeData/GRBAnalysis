dlXRT
=======

.. highlight:: bash

dlXRT is used for download necessary files for Swift-XRT and Swift-BAT data analysis.

**Input:** observation ID and instrument name

**Output:** event file, housekeeping file and attitude file

**Example**::

		./dlxrt 
		Please input the observation ID (eg.00554620000):
		00554620000
		Please input instrument xrt/bat (eg. xrt):
		xrt
		......
		......
		Download finished.

**Source code:**

.. literalinclude:: _code/dlXRT
   :linenos:
   :language: perl