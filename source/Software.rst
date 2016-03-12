#####################
Software Installation
#####################

.. contents::
	:local:

.. highlight:: bash

*Swift* - HEASoft 
=================
HEASoft_  developed by NASA is the major software for the *Swift* data reeducation, it provides several tools including ``xselect`` for data selection and ``xspec`` for spectrum fitting.

This example is for MacOS.

*	Install ``XQuartz`` for X window environment from xquartz.org_.

*	Install ``Xcode`` from `App Store`_, then by typing::

		xcode-select --install

	in the terminal to install the ``Command Line Tools``.

*	Install ``gfortron`` from HPC_.

*	Download the compiled package of ``HEAsoft`` from NASA's HEASARC_, here shows an example for Mac OS 10.11:

 .. image:: _image/heasoft_download.png
 
*	Uncompress HEAsoft to your application folder, here I put it in ``/Applications/heasoft/``, then go to ``/Applications/heasoft/x86_64-apple-darwin15.0.0/BUILD_DIR``, and run::

		./configure >& config.out &
		

*	Create ``.bash_profile`` file in your home root folder ``/Users/Yourname/``, add the content::
		
		HEADAS=/Applications/heasoft/x86_64-apple-darwin15.0.0
		export HEADAS
		source $HEADAS/headas-init.sh

*	Download **DS9 for X Window** from `Smithsonian Astrophysical Observatory`_, Uncompress ``DS9`` and ``ds9.zip`` to ``/Applications/heasoft/x86_64-apple-darwin15.0.0/bin``.

*	Done.


*Fermi* - Science Tools & rmfit
===============================


Local CALDB Setup
=================

Calibration database (CALDB) system stores and indexes datasets associated with the calibration of satellites.

We are going to install the local CALDB in ``/Applications/heasoft/CALDB_LOCAL``:

*	Downloading `CALDB setup files`_,  and uncompress to ``/Applications/heasoft/CALDB_LOCAL``.

*	Downloading `CALDB Calibration Data`_,  and uncompress to ``/Applications/heasoft/CALDB_LOCAL``.

	The structure inside ``/Applications/heasoft/`` will be like::

		CALDB_LOCAL
		├── data 
		│	├── glast
		│	│	├── lat
		│	│	└── gbm
		│	└── swift
		│		├── bat
		│		├── xrt
		│		├── uvot
		│		└── mis
		└── software
		    └── tools
		        ├── alias_config.fits
		        ├── caldb.config
		        ├── caldbinit.csh
		        ├── caldbinit.sh
		        ├── caldbinit.unix
		        ├── caldbinit.vms
		        └── caldbinit_iraf.unix

*	Add to ``~/.bash_profile``::
	
		### LOCAL CALDB #########
		CALDB=/Applications/heasoft/CALDB_LOCAL
		export CALDB
		CALDBCONFIG=$CALDB/software/tools/caldb.config
		export CALDBCONFIG
		CALDBALIAS=$CALDB/software/tools/alias_config.fits
		export CALDBALIAS
		source $CALDB/software/tools/caldbinit.sh

	
*	Done. We can check if the local CALDB is corrected installed by running ``caldbinfo``, open a new terminal::
		
		caldbinfo INST SWIFT XRT
		** caldbinfo 1.0.2
		... Local CALDB appears to be set-up & accessible
		** caldbinfo 1.0.2 completed successfully

.. _xquartz.org: http://www.xquartz.org/index.html
.. _`App Store`: https://developer.apple.com/xcode/download/
.. _HPC: http://hpc.sourceforge.net
.. _HEASOFT: http://heasarc.nasa.gov/lheasoft/
.. _HEASARC: http://heasarc.nasa.gov/lheasoft/download.html
.. _`Smithsonian Astrophysical Observatory`: http://ds9.si.edu/site/Download.html
.. _`CALDB setup files`: http://heasarc.gsfc.nasa.gov/FTP/caldb/software/tools/caldb_setup_files.tar.Z 
.. _`CALDB Calibration Data`: http://heasarc.gsfc.nasa.gov/docs/heasarc/caldb/caldb_supported_missions.html


