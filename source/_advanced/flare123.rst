####################################################
The standard procedure of doing X-ray flare analysis
####################################################

Spectrum Preparation
====================

1	Download event and related files.

2	Choose time bins::

	 2.1) At least two bins, A and B, A is the rising part of flare, B is the decaying part of flare.	
	 2.2) If there is a flat part C, C is taken as one bin.
	 2.3) Split A and B to small bins (A1, A2, B1, B2 ...) if meet following criteria, C is always only one bin.
		2.3.1) At least 400 counts per bin.
		2.3.2) Signal to noise ratio > 25.
		2.3.3) At most 2 small bins in A, and 3 small bins in B.
		2.3.4) If the PC data in A or in B cannot comform to the above criteria, bin the PC data in A or in B as one bin. 
		
3	Generate spectra and light curves
	
	3.1) filter time then extract the image, time file shall be named (A1time.txt ...)
	3.2) from the image, select source region (10~20 pixels) and back ground region (40~80 pixels), size depends on the count flux.
		 Region is a circle for PC mode and a rectangle for WT mode, region file names shall be (A1source.reg, A1back.reg ...)
	3.3) extract event, spectrum, and light curve, names shall be (A1.evt, A1.pi, A1.lc ...).

4	Generate exposure map, then generate the ancillary response file (A1.arf) with psf and exposure map. 
   
5	Find the name of redistribution matrix file (.rmf) from the output when running xrtmkarf, copy the .rmf file to the current folder.
 
6	Bin spectrum, minimun 20 counts/bin for chi-sqaure, and minimum 1 counts/bin for c-stat, binned spectrum named (A1_20.grp, A1_1.grp).

Some commands:

- 3.3 Extract event file:
	extract event copyall=yes

- 4 Generate exposure map:
	xrtexpomap infile=sw00374210000xpcw3po_cl.evt attfile=sw00374210000sat.fits hdfile=sw00374210000xhd.hk outdir=./

- 4 Generate ancillary response file:
	grppha infile=A1.pha outfile=A1_20.grp comm='group min 20 & exit'
	grppha infile=A1.pha outfile=A1_1.grp comm='group min 1 & exit'