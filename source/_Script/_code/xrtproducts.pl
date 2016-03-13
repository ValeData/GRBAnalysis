
#------------------------------------------------------------
# subroutines copied from xrtproducts
#-----------------------------------------------------------

sub RunXimage(){

	my($filename) = @_;

	use vars qw($headfilename $datamode);
	
	my $ImgFile;
	if ($datamode =~ /pc/i) {
	    $ImgFile =  &GetValPar("outdir") . "/" . $headfilename . "_sk." .  &GetValPar("plotdevice"); 
	} else {
	    $ImgFile =  &GetValPar("outdir") . "/" . $headfilename . "im." .  &GetValPar("plotdevice"); 
	}  


	if ( -f $ImgFile) {
	    if (!$Task{clobber} ) {
		&PrntChty(2, "$Task{stem}: Error: the '$ImgFile' exists\n");
		&PrntChty(2, "$Task{stem}: Error: please delete '$ImgFile' or\n");
		&PrntChty(2, "$Task{stem}: Error: set the input parameter 'clobber' to 'yes'\n");
		$Task{errmess} = "Unable to overwrite '$ImgFile' file";
		$Task{status} = 1;
		goto EXITWITHERROR;
	    } else { 
		&DeleteFile($ImgFile);
	    }
	}
	


	my ($dev) =  &GetValPar("plotdevice");
	if ( $dev eq "ps" ) { $dev = "cps"; }
	
	&RunningSub("$Task{stem}","ximage", " on '$filename'");

	# Open a temporary file with ximage commands;
         my ( $XimageFile ) =  &GetValPar("outdir") . "/" . $headfilename . ".xco";
         unlink ( $XimageFile );

         if ( ! open ( XIMFILE, ">$XimageFile" )) {
	     $Task{errmess} = "Unable to create '$XimageFile' file";
	     $Task{status} = 1;
	     goto EXITWITHERROR; 
         }

	 if (  &GetValPar("chatter") <= 4 ) {
	     print XIMFILE "chat 0\n";
	 }
        if ($datamode =~ /pc/i) {
	    print XIMFILE "read/size=600/ecol=pi/emin=30/emax=1000 $filename\n";
	    print XIMFILE "cey 2000\n";
	    print XIMFILE "smo\n";
	    print XIMFILE "cpd $ImgFile/$dev\n";
	    print XIMFILE "disp;grid\n";
	    print XIMFILE "cpd /xs\n";
	    print XIMFILE "quit";
	}elsif ($datamode =~ /im/i) {
	    my($fptr,$status,$numext,@listext);

	    @listext = &getArrayExtensionImage($filename);
	    if ($Task{status}) { goto EXITWITHERROR;}
	    
	    if ($#listext == -1) { 
		$Task{errmess} = "The $filename file is in raw coordinates. Unable to produce a sky coordinate image";
		goto EXITWITHERROR;
	    }

	    if ($#listext >= 0) {
		print XIMFILE "read/size=600 $filename+$listext[0];save_ima\n";
	    }
	    for (my $i = 1; $i <= $#listext; $i++) {
		 print XIMFILE "read/size=600 $filename+" . +$listext[$i] . ";sum_ima;save_ima\n"
	    }
	    print XIMFILE "cey 2000\n";
	    print XIMFILE "smo\n";
	    print XIMFILE "cpd $ImgFile/$dev\n";
	    print XIMFILE "disp;grid\n";
	    print XIMFILE "cpd /null\n";
	    print XIMFILE "quit\n";

	       
	} else {
	    print XIMFILE "read/size=600/xcol=detx/ycol=rawy/xpix=300/ypix=300 $filename\n";
	    print XIMFILE "cpd $ImgFile/$dev\n";
	    print XIMFILE "disp\n";
	    print XIMFILE "vplabel/bottom/margin=2.5/color=0 \"X Pixels\"\n";	    
	    print XIMFILE "vplabel/bottom/margin=2.5 \"DETX Pixels\"\n";	    
	    print XIMFILE "vplabel/left/margin=0.7/color=0/lwidth=10/position=0.33 '200'\n";	    	   
	    print XIMFILE "vplabel/left/margin=0.7/color=0/lwidth=10/position=0.67 '400'\n";	    	   
	    print XIMFILE "vplabel/left/margin=0.7/color=0/lwidth=10/position=1 \"600\"\n";	    	   
	    print XIMFILE "vplabel/left/margin=2.2/color=0 \"Y Pixels\"\n";	    	  
 	    print XIMFILE "vplabel/left/margin=2.2 \"Folded Time\"\n";	    	   
	    print XIMFILE "cpd /xs\n";
	    print XIMFILE "quit\n";
	}
	
	close ( XIMFILE );

	my ( $command ) = "ximage \@$XimageFile";
	&RunningComm("$Task{stem}",$command);
	if (  system( "ximage \@$XimageFile" ) ) {
	    &ErrorComm("RunExtractor","ximage",$command);
	    &PrntChty(2,"$Task{stem}: Error: running command: 'ximage \@$XimageFile'\n");
	    $Task{errmess} = "Error Running 'ximage'";
	    $Task{status} = 1;
	    goto EXITWITHERROR;
	}

	if ( &CompUL( &GetValPar("cleanup"), "yes" ) ) {
	    &DeleteFile($XimageFile);
	}

	 if (  &GetValPar("display") ) {
	     if (&PlotImage( $Task{viewer}, $ImgFile )) {
		 &PrntChty(2,"$Task{stem}: Warning: cannot display '$ImgFile' image\n"); 
	     }
	 }
	&SuccessSub("$Task{stem}","ximage","Created  '$ImgFile' image");
	return ;
}


sub GetInputParameters {

    use vars qw( %Task $datamode @Par %Ind);
  
    my ( $name, $indref, $p);

    ($indref,@Par) = &GetParameterList();

    $Task{chatter} = 3;

    if ($Task{status}) { goto EXITWITHERROR;}

    
    %Ind = %$indref;

    if (! &LoadParameterFromCmdLine(@ARGV)) {
	&PrntChty(2,"$Task{stem}: Error: $Task{errmess}\n");
	return 1;
    }
    

    if (&GetValPar("infile","set") == 0 )  {
	my $Stringa = "";
	chop($Stringa = `pquery2 xrtproducts infile`);
	if ( !$Stringa) {
	    &PrntChty(2,"$Task{stem}: Error: running: 'pquery2 xrtproducts infile'\n");
	    return 1;
	}
	&SetValPar("infile",$Stringa);
	&SetValPar("infile",2,"set");
    }



    #Check if it is a list of files

      
    if (&GetValPar("infile") =~ /^@/) {
	my($fv) = substr(&GetValPar("infile"),1);
	
	if( ! -f $fv ) {
	    $Task{status} = 0;
	    $Task{errmess} = "Input Event File List: '$fv' not found";
	    goto EXITWITHERROR;
	}
	
	if ( ! open(FILELIST,$fv ) ) {
	    $Task{errmess} = "Cannot open '$fv' file";
	    goto EXITWITHERROR;
	}

	while (<FILELIST>) {
	    chop();
	    push(@filelist,$_);
	    if (! -f $_) {  
		$Task{errmess} = "Input Event File: '$_' not found";
		goto EXITWITHERROR;
	    }
	}
	close(FILELIST);
    }
    else {
	$filelist[0] = &GetValPar("infile");
	if( ! -f  &GetValPar("infile") ) {
	    $Task{errmess} = "Input Event File: '" . &GetValPar("infile") . "' not found";
	    goto EXITWITHERROR;
	}
    }

    $datamode = &GetEventDataMode($filelist[0]);
    if ( $Task{status} ) {
	goto EXITWITHERROR;
    }

    if ($datamode !~ /(lr|pu|wt|pc|im)/)  {
	$Task{errmess} = "Incorrect Data Mode: '$datamode' ; '$filelist[0]' event file";
	goto EXITWITHERROR;
    }


    if ($datamode !~ /(lr|pu|im)/) { 
	if ( &GetValPar("regionfile","set") == 0 ) {
	    my $Stringa = "";
	    chop($Stringa = qx(pquery2 xrtproducts regionfile));
	    if ( !$Stringa ) {
		print "ERROR: error running: 'pquery2 xrtproducts regionfile'\n";
		return 1;
	    }
	    &SetValPar("regionfile", $Stringa);
	    &SetValPar("regionfile",2,"set");
	}
    }

    if ($datamode ne "im") {

	&GetKeyword($filelist[0], "EVENTS", undef, "OBS_MODE", \$obsmode);
	if ( $Task{status} ) {
	    goto EXITWITHERROR;
	}

	if ( &GetValPar("phafile","set") == 0 ) {
	    my $Stringa = "";
	    chop($Stringa = qx(pquery2 xrtproducts phafile));
	    if ( !$Stringa ) {
		&PrntChty(2,"$Task{stem}: Error: running: 'pquery2 xrtproducts phafile'\n");
		return 1;
	    }
	    &SetValPar("phafile", $Stringa);
	    &SetValPar("phafile",2,"set");
	}
    }

    #filelc
    if ( &GetValPar("lcfile","set") == 0 ) {
	my $Stringa = "";
	chop($Stringa = qx(pquery2 xrtproducts lcfile));
	if ( !$Stringa ) {
	    print "ERROR: error running: 'pquery2 xrtproducts lcfile'\n";
	    return 1;
	}
	&SetValPar("lcfile", $Stringa);
	&SetValPar("lcfile",2,"set");
    }

    #expofile
    if ( &GetValPar("expofile","set") == 0 ) {
	my $Stringa = "";
	chop($Stringa = qx(pquery2 xrtproducts expofile));
	if ( !$Stringa ) {
	    print "ERROR: error running: 'pquery2 xrtproducts expofile'\n";
	    return 1;
	}
	&SetValPar("expofile", $Stringa);
	&SetValPar("expofile",2,"set");
    }

    if ( &GetValPar("bkgextract","set") == 0 ) {
	my $Stringa = "";
	chop($Stringa = qx(pquery2 xrtproducts bkgextract));
	if ( !$Stringa ) {
	    print "ERROR: error running: 'pquery2 xrtproducts bkgextract'\n";
	    return 1;
	}
	&SetValPar("bkgextract", $Stringa);
	&SetValPar("bkgextract",2,"set");
    }

    if ( &GetValPar("correctlc","set") == 0 ) {
	my $Stringa = "";
	chop($Stringa = qx(pquery2 xrtproducts correctlc));
	if ( !$Stringa ) {
	    print "ERROR: error running: 'pquery2 xrtproducts correctlc'\n";
	    return 1;
	}
	&SetValPar("correctlc", $Stringa);
	&SetValPar("correctlc",2,"set");
    }


    foreach $p (@Par) {
	if (($p->{set} == 1) && (!&RequestParameter($p->{name}))) {
	    &PrntChty(2,"$Task{stem}: Error: $Task{errmess}\n");
	    return 1;
	}
    }

    $Task{errmess} = "";
   if (! &LoadParameter()) {
       &PrntChty(2,"$Task{stem}: Error: $Task{errmess}\n");
       return 1;
   }

    $Task{chatter} = &GetValPar("chatter");

    if (&GetValPar("ra","set") != 0 )  {
	if (!&CheckRa("RA",&GetValPar("ra"))) { goto EXITWITHERROR;}
    }
    if (&GetValPar("dec","set") != 0 )  {
	if (!&CheckDec("DEC",&GetValPar("dec"))) { goto EXITWITHERROR;}
	
    }

    if( (&GetValPar("lcfile") =~ /$Default{NONE}/i) && (&CompUL( &GetValPar("correctlc"),"yes")) ){ 
	&PrntChty(2,"$Task{stem}: Error: Parameter lcfile set to NONE, cannot correct source light-curve.\n");
	goto EXITWITHERROR;
    }


    return 0;
} # GetInputParameters



sub RunXselect {

    my ($xcofile,$evtfile) = @_;
    use vars qw( %Task );
    my ( $command, $ret, $par, %extractor );


    &RunningSub("$Task{stem}","xselect", " on '$xcofile'");

    # set expression specific the the datamode
    #
    # Build the command line to run 'extractor'
    #

   $command = "xselect @" . $xcofile;
  

    &RunningComm("$Task{stem}",$command);
    
    $ret = 0;
    $ret = system( $command );
    
    if ( $ret != 0 ) {
	&ErrorComm("$Task{stem}","xselect",$command);
        $Task{errmess} = "Error running 'xselect'";
	$Task{status} = 1;
	goto EXITWITHERROR;
    }

    # check errors from 'xselect.log' file
    $ret = 0;
    $ret = &CheckXselectLog();

    if ( $ret != 0 ) {
	&ErrorComm("$Task{stem}","xselect",$command);
        $Task{errmess} = "Error running 'xselect'";
	$Task{status} = 1;
	return 1;
    }

    my $strmsg = "";

    if (&GetValPar("lcfile") !~ /$Default{NONE}/i) { $strmsg = "Light Curve ";}
    if (&GetValPar("phafile") !~ /$Default{NONE}/i) {$strmsg =  $strmsg eq "" ? "Spectrum " : $strmsg . ",Spectrum ";}


    if ($datamode !~ /(lr|pu)/i) {
      if (&GetValPar("imagefile") !~ /$Default{NONE}/i) { $strmsg = $strmsg eq "" ? "Image" : $strmsg . "and Image ";}
    }

    &SuccessSub("$Task{stem}","xselect","$strmsg generated for '$evtfile'");
    return 0;
    
} # RunExtractor


#Return value of a specific extension

sub GetValue(){
        my ($filename,$key,$extension) = @_;
        my ($row,$val);
	
	$row = `fkeyprint $filename+$extension $key | grep -i "$key\[ \]*="`;
        chop($row);
        my ($p,$comment) = split(/\//,$row);
        ($p,$val) = split(/=/,$p);
        $val = trim($val);
	chomp($val);  # get rid of \n
	$val =~ s/^\s+//; # remove leading spaces
	$val =~ s/\s+$//; # remove trailing spaces	
	$val =~ s/^'//g;; #Remove apex
        $val =~ s/'$//g;; #Remove apex
	$val =~ s/\s+$//g;; #Remove right space
        return $val;
}

#----------------------------------------------------------------------#
#  FUNCTION:  hashValueAscendingNum                                    #
#                                                                      #
#  PURPOSE:   Help sort a hash by the hash 'value', not the 'key'.     #
#             Values are returned in ascending numeric order (lowest   #
#             to highest).                                             #
#----------------------------------------------------------------------#


sub hashValueAscendingNum {
    use vars qw(%htstart);
   $htstart{$a} <=> $htstart{$b};   
}

#Sort file for TSTART : parameter array of file
sub SortArrayTStart {
	
	my (@file) = @_;
	my ($i,@f,$key,$tstart);

	for ($i=0; $i <= $#file ; $i++) {
	    &GetKeyword($file[$i],"EVENTS",undef, "TSTART", \$tstart);
	    if ( $Task{status} ) { goto EXITWITHERROR; }
	    $htstart{$i} = $tstart;
	}

	$i = -1;
	foreach $key (sort hashValueAscendingNum (keys(%htstart))) {
   		$i++;
   		$f[$i] = $file[$key];

	}

	return @f;

}
	

#Return name file without path

sub getFileName() {

	my ($fn) = @_;
	my $pos = rindex($fn,"/");
	if ($pos == -1) {return $fn;}
	else {return substr($fn,$pos+1);}
} 




sub RequestParameter(){
    use vars qw ($datamode %Default %Task);
    my ($par_name) = @_;
   
    $Task{errmess} = "Input parameters not compatible with datamode: $datamode";

    if ($datamode eq "im") {
	if ((uc(&GetValPar("gtifile")) ne "$Default{NONE}") && ($par_name eq "gtifile")) {
	    $Task{errmess} = "Cannot insert $par_name when datamode=IMAGING";
	    return 0;
	}
	if ((uc(&GetValPar("expofile")) ne "$Default{NONE}") && ($par_name eq "expofile")) {
	    $Task{errmess} = "Cannot insert $par_name when datamode=IMAGING";
	    return 0;
	}
	if (($par_name eq "pilow") || ($par_name eq "pihigh")) {
	    $Task{errmess} = "Cannot insert $par_name when datamode=IMAGING";
	    return 0;
	}	
	if (($par_name eq "infile") || ($par_name eq "outdir") || 
	    ($par_name eq "stemout") || ($par_name eq "display") || ($par_name eq "plotdevice") || ($par_name eq "chatter") ||  
	    ($par_name eq "history")  || ($par_name eq "cleanup")|| ($par_name eq "clobber") || ($par_name eq "correctlc") || ($par_name eq "expofile") ){ 
	    return 1;
	}
	else { return 0;}
    }

    if (($par_name eq "regionfile") && &CompUL(&GetValPar("regionfile"),$Default{NONE}) ) {
	&PrntChty(2,"$Task{stem}: Error: Cannot specify '$par_name=NONE'\n");
	&PrntChty(2,"$Task{stem}: Error: Please set '$par_name' to 'DEFAULT' or supply an extraction region file\n");
	$Task{errmess} = "Cannot insert $par_name=NONE";
	return 0;
    }

    if ( (($par_name eq "ra") || ($par_name eq "dec") || ($par_name eq "radius"))
	 && ((&GetValPar("phafile") =~ /$Default{NONE}/i) && (&GetValPar("lcfile") =~ /$Default{NONE}/i)))
    {
	$Task{errmess} = "Cannot insert $par_name when phafile=NONE and lcfile=NONE";
	return 0;
    } 
	
    if (($par_name eq "rmffile") || ($par_name eq "mirfile") || ($par_name eq "psfflag") || 
	($par_name eq "fitsfile") ||  ($par_name eq "psffile") || ($par_name eq "vigfile") || ($par_name eq "inarffile") || ($par_name eq "expofile")) {
	if (&GetValPar("phafile") !~ /$Default{NONE}/i) {
	    return 1;
	} else { 
	    $Task{errmess} = "Cannot insert $par_name when phafile=NONE";
	    return 0;
	}
    }
	
    if ((&GetValPar("lcfile") =~ /$Default{NONE}/i) && (($par_name eq "binsize") || ($par_name eq "pilow") || ($par_name eq "pihigh"))) {
	 $Task{errmess} = "Cannot insert $par_name when lcfile=NONE";
	return 0;
    }

    if ( (&CompUL( &GetValPar("bkgextract"),"no")) && (($par_name eq "bkgregionfile") || ($par_name eq "bkglcfile") || ($par_name eq "bkgphafile"))) {
	 $Task{errmess} = "Cannot insert $par_name when bkgextract=no";
	return 0;
    }

    if ( (&CompUL( &GetValPar("correctlc"),"no")) && (($par_name eq "attfile") || ($par_name eq "hdfile")) ) {
	 $Task{errmess} = "Cannot insert $par_name when correctlc=no";
	return 0;
    }

    if ($datamode eq "pc") {

	if (($par_name eq "ra") && !&CompUL(&GetValPar("regionfile"),$Default{DEFAULT}) ) { 
	     $Task{errmess} = "Cannot insert $par_name when input region file name is specified";
	    return 0;
	 }

	if (($par_name eq "dec") && !&CompUL(&GetValPar("regionfile"),$Default{DEFAULT}) ) { 
	     $Task{errmess} = "Cannot insert $par_name when input region file name is specified";
	    return 0;
	 }

	if (($par_name eq "radius") && !&CompUL(&GetValPar("regionfile"),$Default{DEFAULT}) ) { 
	     $Task{errmess} = "Cannot insert $par_name when input region file name is specified";
	    return 0;
	 }
    
	return 1;
    }

    if ($datamode eq "wt") {

	if (($par_name eq "ra") && !&CompUL(&GetValPar("regionfile"),$Default{DEFAULT}) ) { 
	     $Task{errmess} = "Cannot insert $par_name when input region file name is specified";
	    return 0;
	 }

	if (($par_name eq "dec") && !&CompUL(&GetValPar("regionfile"),$Default{DEFAULT}) ) { 
	     $Task{errmess} = "Cannot insert $par_name when input region file name is specified";
	    return 0;
	 }

	if (($par_name eq "radius") && !&CompUL(&GetValPar("regionfile"),$Default{DEFAULT}) ) { 
	     $Task{errmess} = "Cannot insert $par_name when input region file name is specified";
	    return 0;
	 }
	
	return 1;
    }
    
    if ($datamode =~ /(lr|pu)/i) {
	if (($par_name eq "radius") || ($par_name eq "regionfile") || 
	    ($par_name eq "imagefile") || (($par_name eq "ra") || ($par_name eq "dec"))){ 
	    return 0;
	}
	return 1;
    }

    $Task{errmess} = "";
    return 1;
} # RequestParameter


#Return filename of rmf file
# return empty string if file not found or if there are more rmf file 
## different from original: 1) comment and change "if ($Task{status} == KEY_NO_EXIST)"
##							2) add "$datamode = &GetEventDataMode($filename);"
sub GetRmfFile(){

    
    my ($filename,$reffile,$refext,@rmffile,@extfile) = @_;

    use vars qw($datamode);

    my ($strmode,$grade,$rmffile);
    my ($StartDate, $StartTime, $xrtvsub);


    # Get Observation Start Date
    &GetEventStartDate($filename, \$StartDate, \$StartTime);
    if ( $Task{status} ) { return "";}

    # Get XRTVSUB
    &GetKeyword ($filename, "EVENTS", undef, "XRTVSUB", \$xrtvsub, 1);
    if ( $Task{status} ) {
#	if ($Task{status} == KEY_NO_EXIST){
#	    $xrtvsub="0";
#	    &PrntChty(2,"$Task{stem}: Warning: 'XRTVSUB' keyword not found in '$filename'\n");
#	    &PrntChty(2,"$Task{stem}: Warning: using default value '0'\n");
#	    $Task{status}=0;
#	}
#	else{
	    &PrntChty(2,"$Task{stem}: Warning: cannot read 'XRTVSUB' keyword in file '$filename'\n");
	    &PrntChty(2,"$Task{stem}: Warning: using default value '0'\n");
		$xrtvsub="0";
		$Task{status}=0;
	    #return "";
#	}
    }

    # Get Grade
    $grade = &GetGrade($filename);
    if ($Task{status}) { return "";}

#    if ($grade <0) {return "";}
	$datamode = &GetEventDataMode($filename);
	#print "datamode: $datamode \n";

    if ($datamode =~ /pc/i) {$strmode = "datamode.eq.photon"}
    elsif ($datamode =~ /wt/i) { $strmode = "datamode.eq.windowed";}
    else { $strmode = "datamode.eq.lowrate";}
    
    $strmode = $strmode . ".and.grade.eq.G$grade";
    $strmode = $strmode . ".and.XRTVSUB.eq.$xrtvsub";

   ($reffile,$refext) = &CallQuzcif ("matrix", $StartDate, $StartTime,"$strmode",1);

    @rmffile = @$reffile;
    @extfile = @$refext;

    if ($Task{status}) {
	$Task{errmess} = "Unable to get rmf file from CALDB";
	return "";
    } else {
	return $rmffile[0];
    }
}




#Return value of DSVALn keyword
#return -1 in case of errors
sub GetGrade() {
    my ($filename) =  @_;

    my ($i,$numext,$val);

    #Get extension EVENTS
    $numext = &GetNumExtName($filename,"EVENTS");
     if ($numext < 0) {
	 $Task{status} = 1;
	 return -1;
    }  
    
    for ($i = 1; $i <= 99; $i++) {
	&GetKeyword($filename,"EVENTS", undef,"DSTYP$i",\$val);
	&PrntChty(5,"$Task{stem}:Get keyword DSTYP$i ($numext) value: $val\n");
	if ( $Task{status} ) {return -1; }
	

	if ($val =~ /GRADE/i) {
	    &GetKeyword($filename,"EVENTS", undef,"DSVAL$i",\$val);
	    if ($Task{status}) { return -1;}
	    return $val;
	}
    }

    $Task{status} = "Cannot find DSTYPm keyword in $filename"; 
    return -1;
}


sub RunXrtLcCorr {

    my ( $lcfile, $infile, $stemout ) = @_;

    my ( $par, $ret );
    my ( $command, %xrtlccorr );

    my ( $outinstrfile, $corrfile, $outfile );

    use vars qw ( %Task %Default );


    # Set DEFAULT name of the output files
    if ( uc(&GetValPar("outinstrfile")) eq $Default{DEFAULT} ) {
	$outinstrfile =  &GetValPar("outdir") ."/" . $stemout . "_srawinstr.img";
    } 
    else { 
	$outinstrfile = &GetValPar("outdir") ."/" . &GetValPar("outinstrfile"); 
    }

    if ( uc(&GetValPar("corrfile")) eq $Default{DEFAULT} ) {
	$corrfile =  &GetValPar("outdir") ."/" . $stemout . "sr_corrfact.fits";
    } 
    else { 
	$corrfile = &GetValPar("outdir") ."/" . &GetValPar("corrfile"); 
    }

    if ( uc(&GetValPar("lccorrfile")) eq $Default{DEFAULT} ) {
	$outfile =  &GetValPar("outdir") ."/" . $stemout . "sr_corr.lc";
    } 
    else { 
	$outfile = &GetValPar("outdir") ."/" . &GetValPar("lccorrfile"); 
    }


    %xrtlccorr = (
		  lcfile          => $lcfile,
		  regionfile      => "NONE",
		  outfile         => $outfile,
		  corrfile        => $corrfile,
		  teldef          => "CALDB",
		  aberration      => "no",
		  attinterpol     => "no",
		  attfile         => &GetValPar("attfile"),
		  srcx            => -1,
		  srcy            => -1,
		  psffile         => "CALDB",
		  psfflag         => "yes",
		  energy          => &GetValPar("lcenergy"),
		  createinstrmap  => "yes",
		  outinstrfile    => $outinstrfile,
		  infile          => $infile,
		  hdfile          => &GetValPar("hdfile"),
		  fovfile         => "CALDB",
		  vigfile         => "CALDB",
		  wtnframe        => &GetValPar("wtnframe"),
		  pcnframe        => &GetValPar("pcnframe"),
		  chatter         => &GetValPar("chatter"),
		  history         => &GetValPar("history"),
		  clobber         => &GetValPar("clobber"),
		  );


    $command = "xrtlccorr";
    for $par ( keys %xrtlccorr ) { $command .= " $par=$xrtlccorr{$par}"; } 


    &RunningSub("RunXrtLcCorr","xrtlccorr"," on '$lcfile'");
    &RunningComm("RunXrtLcCorr",$command);

    $ret = 0;
    $ret = system( $command );

    if ( $ret != 0 ) {
	&ErrorComm("RunXrtLcCorr","xrtlccorr",$command);
        $Task{errmess} = "ERROR running 'xrtlccorr'";
	$Task{status} = 1;
	return 1;
    }

    &SuccessSub("RunXrtLcCorr","xrtlccorr");
    return 0;

} # RunXrtLcCorr
1;