getpar
=======

.. highlight:: bash

getpar is used for get observational parameters from event file.

**Input:** event file name

**Output:** observational parameters

**Example**::

		getpar sw00585834000xwtw2po_cl.evt 
		OBJECT = 'GRB140206a'
		OBS_ID = '00585834000'
		TSTART = 4.133639020059217E+08
		TSTOP = 4.134087866215617E+08
		RA_OBJ = 145.3342917
		DEC_OBJ = 66.7606944
		TRIGTIME = 413363851.776
		ATTFLAG = '110
		
		
		getpar sw00585834000xwtw2po_cl.evt TRIGTIME
		TRIGTIME = 413363851.776

**Source code:**

.. literalinclude:: _code/getpar
   :linenos:
   :language: perl