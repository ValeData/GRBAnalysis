#!/usr/bin/perl

## This file combines libswxrtperl.pl and xrtproduct from HEASoft, with some changes.
## ----------------------------------------------------------------------------------

#
# Modul name: libswxrtperl.pl
# 
# 
# Description:	
#          Library functions for Unit Tests
#		   
# 
# Author/Date: Italian Swift Archive Center (Frascati)
# 
# History:
# 
#      0.1.0 : FT 07/02/2003 - First Release
#      0.1.1 : FT 14/05/2003 - check existence of 'fkeypar' (if LHEASOFT
#                              has not been set the 'qx' does not return
#                              error)
#      0.1.2 : RP 22/07/2003 - Minor change to GetEventDataMode
#      0.1.3 : FT 30/07/2003 - Changes to GetEventFilteredName function
#      0.1.4 : FT 03/08/2003 - Changes to GetAttOrbFileName function;
#                              muved subroutines: CrateDir, GetViewer,
#                              PlotImage, FindExecFile, SetLev2EvtFileName,
#                              and AddKeyword from xrtpipeline task
#      0.1.5 : FT 24/10/2003 - Added 'CallQuzcif' subroutine needed for 
#                              'xrtscreen' task taken from 'xrtpipeline' 
#                              Minor changes CompUL subroutine
#                              Added CheckXselectLog function 
#      0.1.6 : RP 13/11/2003 - Change CallQuzCif return two arrays outlist 
#                              and extlist
#                              Added GetHduNum , GetNumExtName functoin
#      0.1.7 : FT 14/11/2003 - Changes on GetHduNum and GetExtName subroutines
#                              TableEmpty subroutine changes
#      0.1.8 : FT 20/11/2003 - Changes on GetHduNum subroutine (problems with 
#                              the log file created by fstruct in the same
#                              directory of the input file)
#      0.1.9 : FT 20/11/2003 - Added RP subroutine 'LoadBinTable'
#      0.2.0 : FT 25/11/2003 - Added SetGtiFileName subroutine
#      0.2.1 : FT 26/11/2003 - Added ErasePath subroutine
#                              
#      0.2.2 : RP 12/12/2003 - Added  GetPfilesName(), LoadParameter(), LoadParameterFromCmdLine(),
#                              GetParameterList()  
#      0.2.3 : RP 19/01/2004 - Added getHistoryTime(), write_history(), write_parameter_list()
#      0.2.4 : RP 16/03/2004 - Added funcion UpdateChecksum
#      0.2.5 : FT 16/03/2004 - Minor Changes on GetPfilesName subroutine and comments       
#      0.2.6 : RP 16/03/2004 - Modify WriteParameterList 
#      0.2.7 : RP 18/03/2004 - write checksum when call WriteParameterList 
#      0.2.8 : RP 19/03/2004 - Added  CheckRa,CheckDec,Ra2Deg,Dec2Deg,RaDec2XY
#      0.2.9 : FT 26/03/2004 - 'GetInputParam' bug fixed parsing input parameters
#                            - Minor changes on Info and Error messages
#      0.2.10: RP 01/04/2004 - Modify LoadBinTable 
#                              Added function CheckCol, CheckColPtr 
#      0.2.11: RP 01/04/2004 - Added GetXspecChatter
#      0.2.12: RP 07/04/2004 - Bug fixed
#      0.2.13: RP 19/04/2004 - Change GetKeyword (used cfits library)
#                              Added function GetFitsPointer
#                              Remove GetHduNum 
#                              Changed parameter to TableEmpty (file,extension)
#      0.2.14: RP 21/04/2004 - Change GetKeyword  
#      0.2.13: FT 27/04/2004 - Substituted "goto EXITWITHERROR" with return   
#      0.2.14: RP 29/04/2004 - Minor change 
#      0.2.15: RP 29/04/2004 - Bug fixed
#      0.2.16: FT 05/05/2004 - Added 'GetEventStartDate' subroutine that returns
#                              $date and $time for CALDB quzcif query
#                            - New Naming Convention Handle (1 March 2004)
#                            - Added 'RunCommandAndRedirectOutput' to run a command
#                              without have output on the STDOUT but into a file. This
#                              can be used with Xselect, Ximage, Lcurve to avoid 
#                              messages on screen
#      0.2.17: FT 13/05/2004 - Changed GTI Default Name (SetGtiFileName function)
#      0.2.18: FT 17/05/2004 - Added check on GetValPar function
#      0.2.19: RP 19/07/2004 - Added check input value to CheckRa and CheckDec
#      0.2.20: FT 22/07/2004 - Added Cleanup and RenameFile subroutines
#                            - Added parameter to GetKeyword subroutine to do not
#                              print error messages if the keyword does not exist
#                              (needed to check the keyword existence without give an
#                              error)
#      0.2.21: RP 27/07/2004 - Bug fixed     
#      0.2.22: RP 29/07/2004 - Change function IsNumeric
#      0.2.23: CS 02/08/2004 - Added ExecXimage subroutine to exec ximage and 
#                              perform a check on error
#      0.2.24: FT 29/07/2004 - Added 'GetPntFromExt' and 'GetObjFromExt' functions
#      0.2.25: RP 03/08/2004 - Added function getArrayExtensionImage
#      0.2.26: RP 04/08/2004 - Added function delFitsCol to delete a list of columns from fits file
#                              Added parameter to getFitsPointer . $mode to open or READONLY or READWRITE mode
#      0.2.27: FT 05/08/2004 - Bug fixed in SetLev2EvtFileName, added handle of input compressed files
#      0.2.28: RP 06/08/2004 - Update checksum in function delFitsCol 
#      0.2.29: CS 10/08/2004 - Kill -9 ExecXimage (sun bug)
#      0.2.30: CS 19/08/2004 - Kill ExecXimage patch for SunOS
#      0.2.31: RP 29/09/2004 - Bug fixed GetFitsPointer subroutine (this should solve the
#                              Solaris problem given by 'xrttdrss' and 'xrttam'
#                              tasks during Build 9)
#      0.2.31: RP 30/09/2004 - Modify CreateDir to create parents directory
#                              Added check to CheckRa and CheckDec if is empty
#      0.2.32: FT 30/09/2004 - Added GetRootStem function. It takes the 
#                              root of a filename erasing the given 'tailstem'
#      0.2.33: RP 04/10/2004 - Added function AddKeywordExt
#      0.3.0:  FT 07/10/2004 - Added initialization of $fptr and $status to 0,
#                              this change has been suggested by Bob Wiegand
#                              (undefined variables give warnings with
#                              Astro::FITS::CFITSIO library)
#                            - added undefined variables initialization when needed
#      0.3.1:  FT 10/12/2004 - Added CallScQuzcif function
#      0.3.2:  RP 10/12/2004 - Bug fixed on Ra2Deg and Dec2Deg for negative numbers
#      0.3.3:  RP 27/01/2005 - LoadFromCmdLine: Check on range value for parameters inserted on command line
#                              Change CheckCol if parameter chkval is not defined check if value is different from 0 and TNULL value
#      0.3.4:  RP 23/02/2005 - Change function delFitsCol
#      0.3.5:  FT 21/03/2005 - Changed check on 'undefined' hask value in GetValPar subroutine. 
#      0.3.6:  FT 23/03/2005 - Changes in the CheckCol subroutine. Now returns the $Task{status}
#                              eq 1 if the colum is filled by zeros and eq 2 if the column
#                              is filled by NULLs. This is to give in the xrtproducts task 
#                              a warning message if the column is filled by nulls 
#      0.3.7:  BS 13/05/2005 - Bugs fixed
#      0.3.8:  FT 06/06/2005 - Added CheckRow funcion taken from 'xrtscreen' task
#                              needed also to 'xrtpipeline'
#                            - Added CleanTimeNulls function to run ftselect
#                              on the input file and erase rows with TIME
#                              equal to NULL
#                            - Added SetFileName function
#                            - Added AddStemBeforeExtension function 
#      0.3.9:  FT 15/09/2005 - added fits_close_file when needed
#      0.4.0:  BS 13/03/2005 - Build standard sky instrument map file name
#                              in  SetExpoMapFileName routine
#      0.4.1:  NS 24/10/2006 - Added 'GetHdStartDate' subroutine that returns
#                              $date and $time of hd file for CALDB quzcif query
#                            - Added 'GetAttitudeATTFLAG' subroutine that returns
#                              ATTFLAG keyword value in attitude file
#                            - Added function AddKeywordExtNum
#                            - Added GetImagesHduList
#      0.4.2:  NS 09/06/2007 - Change function IsNumeric
#      0.4.3:     18/10/2007 - Bug fixed in IsNumeric function
#      0.4.4:     18/12/2007 - Changed 'GetEventStartDate' function to read keywords from primary
#                              hdu if 'EVENTS' extension not exists (i.e. in pc *sk.img files)
#      0.4.5:     26/03/2008 - Changed 'SetExpoMapFileName' routine to build standard 
#                              raw instrument map file name
#      0.4.6:     30/07/2009 - Modified IsNumeric function to accept '.xx' numeric format
#      0.4.7:     14/10/2009 - Modified CallQuzCif function to set retrieve=yes in quzcif call
#      0.4.8:  NS 20/01/2015 - Added 'FindCaldbIndxFile' and 'GetCaldbVersion' routines
#
# Functions implemented in this file:
#       Cleanup(@filelist)
#       CompUL($string, $comp )
#       PrntChty($chatty, $message )
#       GetKeyword([$filename|undef],[$extname|undef],[$filepnt|undef],
#                  $keyname,\$keywordval,$checkexist); 
#       SetBool($boolval)
#       sub GetInputParam ($inspec)
#       GetSwXRTDefaultStem ($filename)
#       GetAttOrbFileName ($infile, $outdir, $default, $stem )
#       RunningTask()
#       RunningSub($task,$subrout)
#       SuccessSub($message)
#       Success($message)
#       Error($message)
#       RunningComm($task,$command)
#       ErrorComm($task,$subrout,$command)
#       GetPath($filename)
#       GetFileNameRoot($filename)
#       IsCompressed ($filename)
#       EraseLastExtension($filename)
#       GetEventDataMode($evtfile)
#       TableEmpty($filename,$extension)
#       CrateDir ($directory) - Creaes the directory if not found
#       GetViewer ( $plotdevice )
#       PlotImage($viewer, $ImageFile)
#       FindExecFile($file)
#       SetLev2EvtFileName($infile,$outdir)
#       AddKeyword ($fileandext, $keyname, $keyvalue, $comment)
#       CallQuzcif($Dataset, $Date, $Time, $Selectin )
#       CheckXselectLog()
#       GetNumExtName($filename,$extname)
#       LoadBinTable($filefits, $extname,$numext,@columns)
#       SetGtiFilName($evtfile,$outdir)
#       ErasePath($filename)
#       GetPfilesName()
#       LoadParameter()
#       LoadParameterFromCmdLine()
#       GetParameterList()
#       GetValPar($parname , $pos)
#       SetValPar($parname, $val, $col)
#       getHistoryTime() 
#       write_history($filename,$hdunum,$hist)  
#       WriteParameterList($filename,$hdunum,@list) 
#       WriteParHistory($filefits,$head,$str,$status)
#       UpdateCheckSum($file)
#       CheckRa($type,$str)
#       CheckDec($type,$str)
#       Ra2Deg($str)
#       Dec2Deg($str)
#       RaDec2XY($file,$ra,$dec,$x,$y)
#       CheckCol($filename,$extname,$colname,$chkval,$maxval,$minval)
#       CheckColPtr($fptr,$colname,$chkval,$maxval,$minval)
#       GetXspecChatter($TaskChat)
#       GetFitsPointer($filename,$extname,$pointer,$mode) mode=READONLY or READWRITE
#       GetEventStartDate($filename,\$date,\$time)
#       GetHdStartDate($hdfilename,\$date,\$time)
#       RunCommandAndRedirectOutput($command,$outfile)
#       RenameFile ( $filename, $newfilename )
#       ExecXimage ( $parameterlist )
#       GetPntFromExt($filename,[$extname|undef],[$extnum|undef],
#                     \$ra_pnt,\$dec_pnt,[\$pa_pnt|undef]);
#       GetObjFromExt($filename,[$extname|undef],[$extnum|undef],
#                     \$ra_obj,\$dec_obj);
#       getArrayExtensionImage($filefits)
#       AddKeywordExt ($filename,$extname,$datatype,$keyname,$value,$comment)
#       AddKeywordExtNum ($filename,$extnum,$datatype,$keyname,$value,$comment)
#       GrtRootStem($filename,$tailstem)
#       CallScQuzcif($Dataset, $Date, $Time, $Selectin )
#       CheckRow( $file, $ext, $gtifile, $gtiexpr, $gtiextname )  )
#       CleanTimeNulls ( $infile, $outfile, $extname )
#       AddStemBeforeExtension ($file, $stem )
#       GetAttitudeATTFLAG ($attfile, $attflag)
#       GetImagesHduList ($infile)
#
#
#       %Task = (
#               name    => <task name>,
#               version => <task version>,
#               chatter => <numb>,
#               status => 0,
#               errmess => "",
#               stem    => <task name and version>,
#               ....
#               )
#       %Default = (
#                  KEYPAR_COMMAND,
#                  ....
#                  )
#
# HEADAS tasks needed:
#        ftselect
#        ftchecksum
#        ftstat 
#
# LHEASOFT tasks needed:
#        fkeypar 
#                  
#============================================================#
#
# Specific of the task
#;

# add subroutines from xrtproducts.pl
require 'xrtproducts.pl';

use strict;
use vars qw( %Task %Default %Def);
use base qw(Task::HEAdas);
use Task qw(:codes);

use Astro::FITS::CFITSIO qw(:longnames :constants);
use File::Copy;

use Math::Trig;

%Def = (
	GTIFILESTEM   => "gti",
	LEV2STEM      => "cl",
	LEV2STEMLEN   => 2,
	LEV2STARPOINT => 20,
	LEV2LEN    => 22,
	);


my $PI =  3.14159265358979323846;
my $PIS =  3.141592653;
my $EPSR4 =    1E-7;
my $MAXR4 =  1E38;
my $MAX_INTEG = 2147483647;




sub Cleanup {

    # Remove a list of files giving a warning
    # if the file cannot be removed

    my ( @list ) = @_;

    use vars qw ( %Task );
    my $file;

    foreach $file ( @list ) {
	if ( -f $file ) {
	    if ( !unlink ( $file ) ) {
		&PrntChty(2,"$Task{stem}: Warning: Cleanup: Unable to remove '$file' file. $!\n");
	    }
	}
    }

    return 0;

} # Cleanup

sub CompUL {
    my ( $string1, $string2 ) = @_;
    # The subroutine performs a insensitive case
    # compare of two strings. It returns
    # 1 if the strings are equal or 0 if not
    if ( lc($string1) eq lc($string2) ) { return 1; }
    return 0;
} # CompUL

sub PrntChty {
    my ( $chatty, $message ) = @_;
    use vars qw ( %Task );
    if ( $chatty <= $Task{chatter} ) {
	print"$message";
    }
    return;
} # PrntChty

sub SetBool {

    my ( $val ) = @_;
    my ( $ret );
    use vars qw ( %Task );

    if ( $val =~ /[yY]/ ) { $ret = 1; }
    elsif ( $val =~ /[nN]/ ) { $ret = 0; }
    else { $Task{status} = 1; }

    return $ret;

} # SetBool

sub GetInputParam {

# This function parses the input parameter specification.
# The $inspec must be of format: <parametername>=<parametervalue>

    my ( $inspec ) = @_;
    use vars qw ( %Task );

    if ( $Task{status} ) { return; }

    my ( $ind ) = index ( $inspec, '=' ); 
    my ( $inpar ) = substr($inspec,0,$ind-1);
    my ( $inval ) = substr($inspec,$ind+1);

    if ( $ind <= 0 || !$inpar || ( !$inval && $inval ne "0" )) {
	print"$Task{'stem'}: Error: Parsing input parameter: $inspec\n";
	print"$Task{'stem'}: Error: Please specify parameters with format: <parametername>=<parametervalue> without blanks\n";
	print"$Task{'stem'}: Error: Type 'fhelp $Task{name}' for more information on parameters\n";
	$Task{status} = 1;
	return;
    }	
    return ($inval);

} #GetInputParam

sub GetAttOrbFileName {

    my ( $default, $stemout, $stemin ) = @_;

    use vars qw ( %Task %Default );
    my ( $AttOrb , $InStem );

    my ( $ATTORBEXTENSION ) = "s.attorb";

    # Define attorbfilename

    if ( &CompUL( $default, $Default{DEFAULT} ) && &CompUL( $stemout, $Default{DEFAULT} )) {
	$AttOrb = "$stemin$ATTORBEXTENSION";
    }
    elsif ( &CompUL( $default, $Default{DEFAULT} ) && !&CompUL( $stemout, $Default{DEFAULT} )) {
	# Use Input Stem
	$AttOrb = "$stemout$ATTORBEXTENSION";
    }
    else { $AttOrb = "$default"; }

    &PrntChty(3,"$Task{stem}: Info: GetAttOrbFileName: Output Attitude Orbit File will be $AttOrb\n");

    return $AttOrb;

} # GetAttOrbFileName

sub GetSwXRTDefaultStem {

    my ( $infile ) = @_;
    use vars qw ( %Task );

    my ( $STDXPos ) =  13;

    my ( $infilenopath ) = substr($infile,rindex( $infile, '/' )+1);
    # take  stem
    if ( substr( $infilenopath,0,2 ) !~ "sw" || rindex( $infilenopath , 'x' ) != $STDXPos )
    {
	&PrntChty(2,"$Task{stem}: Error: GetSwXRTDefaultStem: Input file name '$infile',\n");
	&PrntChty(2,"$Task{stem}: Error: GetSwXRTDefaultStem: does not match SWIFT/XRT standard naming conventions\n");
	$Task{errmess} = "Cannot define standard stem of files";
	$Task{status} = 1;
	return ;
    }

    my $OutStr = substr($infilenopath,0,$STDXPos);
    return ($OutStr);

} # GetSwXRTtDefaultStem

sub RunningTask {
    use vars qw (%Task);

    &PrntChty(2,"--------------------------------------------------------------\n");
    &PrntChty(2,"             Running ' $Task{name} version $Task{version} '\n");
    &PrntChty(2,"--------------------------------------------------------------\n");

} # RunningTask

sub RunningSub {
    use vars qw (%Task);
    my ($task,$subrout,$message) = @_;
    if ( !defined($message) ) { $message = ""; }
    &PrntChty(3,"$Task{stem}: Info: Running '$subrout' $message\n");
} # RunningSub

sub SuccessSub {
    use vars qw (%Task);
    my ($task,$subrout, $message) = @_;
    if ( !defined($message) ) { $message = ""; }
    &PrntChty(3,"$Task{stem}: Info: '$subrout' exit with success. $message\n");
} # RunningSub

sub Success {
    my ( $message ) = $_;
    use vars qw ( %Task );
    &PrntChty(2,"----------------------------------------------------------\n");
    if ( !defined($message) ) { $message = ""; }
    &PrntChty(2,"$Task{stem}: Exit with success $message\n"); 
    &PrntChty(2,"------------------------------------------------------------\n");
} # $Success

sub Error {
    my ( $message ) = $_;
    use vars qw (%Task);
    &PrntChty(2,"-------------------- $Task{name}  error -----------------------\n");
    if ( defined($message) ) {
	&PrntChty(2,"$Task{'stem'}: $message\n");
    }
    &PrntChty(2,"$Task{'stem'}: $Task{errmess}\n");
    &PrntChty(2,"--------------------------------------------------------------\n");
} # Error

sub RunningComm {
    use vars qw (%Task);
    my($task,$command) = @_;
    &PrntChty(4,"$Task{stem}: Command: $command\n");
} # RunningComm

sub ErrorComm {
    use vars qw (%Task);
    my($task,$subrout,$command) = @_;
    &PrntChty(3,"$Task{stem}: Error: running '$subrout'\n");
    &PrntChty(3,"$Task{stem}: Error: The run was: $command \n");
} # ErrorComm

sub GetPath {
    my ( $filename ) = @_;
    my ( $i, $path );

    $i = rindex( $filename, '/' );
    if ( $i == -1 ) { $path = "."; }
    else { $path = substr($filename,0,rindex( $filename, '/' )+1); }
    return $path;
} # GetPath

sub GetFileNameRoot {
    my ( $infile ) = @_;
    my $infilenopath = substr($infile,rindex( $infile, '/' )+1);
    if ( &IsCompressed($infilenopath) ) { $infilenopath = &EraseLastExtension($infilenopath); }
    $infilenopath = &EraseLastExtension($infilenopath);
    return $infilenopath;
} # GetFileNameRoot

sub IsCompressed {
    my ( $infile ) = @_;
    my ( @ZIPEXTENSIONS ) = (".gz",".Z");
    my $ext;

    foreach $ext ( @ZIPEXTENSIONS ) {
	if ( $infile =~ /$ext$/ ) { return 1; }
    }
    return 0;
} # IsCompressed

sub EraseLastExtension {
    my ( $infile ) = @_;
    my $infile2;
    my $i =  rindex( $infile, '.' );
    if ( $i == -1 ) { $infile2 = $infile; }
    else { $infile2 = substr($infile,0,$i); }
    return $infile2;
} # EraseLastExtension

sub ErasePath {
    my ( $infile ) = @_;
    my $infile2;
    my $i =  rindex( $infile, '/' ) + 1;
    if ( $i <= 0 ) { $infile2 = $infile; }
    else { $infile2 = substr($infile,$i); }
    return $infile2;
} # ErasePath

sub GetEventDataMode {

    my ( $file ) = @_;
    use vars qw (%Task %Default);
    my (%xrtmodes, $numext, $value, $comm);

    %xrtmodes = (
		 PHOTON => "pc",
		 LOWRATE => "lr",
		 PILEDUP => "pu",
		 WINDOWED => "wt",
		 SHORTIMA => "im",
		 LONGIMA => "im",
		 );

    my ($fptr, $status) = (0, 0);
    fits_open_file($fptr,$file,READONLY,$status);
    if ($status) {
	$Task{status} = 1;
	$Task{errmess} = "Unable to open fits file : $file";
	return;
    }

    fits_get_num_hdus($fptr,$numext,$status);
    if ($status) {
	$Task{status} =1;
	$Task{errmess} = "Unable to get number of extensions from file : $file\n";
	fits_close_file($fptr,$status);
	return;
    }    

    for (my $i = 1; $i <= $numext; $i++) {

	fits_movabs_hdu($fptr,$i,ANY_HDU,$status);
	if ($status) {
	    $Task{errmess} = "Running movabs_hdu (num extension: $i) in $file";
	    &PrntChty(2,"$Task{stem}: Error: GetEventDataMode: $Task{errmess}\n");
	    $Task{status} = 1;
	    return ;
	}

	fits_read_keyword($fptr,"DATAMODE",$value,$comm,$status);
	if (!$status) {
	    fits_close_file($fptr,$status);

	    $value =~ s/ |\'//g;
	    
	    # Get datamode
	    if ( !$xrtmodes{$value} ) { 
		&PrntChty(2,"$Task{stem}: Error: GetEventDataMode: DATAMODE ($value) read from '$file'\n");
		&PrntChty(2,"$Task{stem}: Error: GetEventDataMode: is not a SWIFT/XRT valid datamode\n");
		$Task{errmess} = "Unable to define '$file' datamode";
		$Task{status} = 1;
		return ;
	    }

	    return $xrtmodes{$value};
	} else {$status = 0;}
	
    }

    fits_close_file($fptr,$status);
    
    $Task{status} = 1;
    $Task{errmess} = "Error: Reading datamode in $file";
    return;


} # GetEventDataMode

sub TableEmpty {

# Input file name and extension: sring filename+extension
# Return status:
#        0: table not empty
#        1: table empty or error

    my ($filename,$extension) = @_;
    use vars qw (%Task);

    # Get keyword
    my ($keyword);
    &GetKeyword($filename,$extension,undef,"NAXIS2",\$keyword); 
    if ($Task{status}){return 1;}
    $keyword =~ s/ |\'//g;

    if ( $keyword == 0 ) { return 1; } # the table is empty

    return 0; # the table is not empty

} # TableEmpty


#sub CheckExec {
#
#    my ( $exec ) = @_;
#    my ( $sdir );
#    my ( @searchp )=split(/:/,$ENV{'PATH'});
#
#    foreach $sdir (@searchp) {
#	 if ( -x "$sdir/$exec" ) { return 0; }
#    }
#
#    return 1;
#
#} # CheckExec

sub FindExecFile {

	 my ( $file ) = @_;
	 my ( @searchp )=split(/:/, $ENV{'PATH'});
	 my ( $sdir );

	 foreach $sdir (@searchp){
	     if ( -x "$sdir/$file" ) { return 1; }
	 }

	 # Executable Not Found
	 return 0;

} # FindExecFile

sub CreateDir {

    my ( $directory ) = @_;
    use vars qw (%Task);

    if ( !-d  $directory ) {
	&PrntChty(4,"$Task{stem}: Info: CreateDir: Creating '$directory' directory\n");
	#if ( ! mkdir -p $directory, 0777) {
	if ( system("mkdir -p -m 0777 $directory")) {
	    $Task{error} = "Creating Directory '$directory: $!'\n";
	    $Task{status} = 1;
	    return 1;
	}
    }
    return 0;

} # CreateDir

sub GetViewer {

    my ( $plotdevice ) = @_ ;
    my ( $task );
    use vars qw (%Task);

    my ( @PlotGifList ) = ("xv", "gqview","kview" );
    my ( @PlotPsList ) = ("gv", "ghostview");

    if ( $plotdevice =~ /gif/ ) {
	foreach $task (@PlotGifList) {
	    if ( &FindExecFile($task) ) {
		return $task;
		last;
	    }
	    else {
		&PrntChty(4,"$Task{stem}: Error: GetViewer: .... $task not found\n");
	    }
	}
    } # Image into gif format
		
    elsif ($plotdevice =~ "ps" ) {
	foreach $task (@PlotPsList) {
	    if ( &FindExecFile($task) ) {
		return $task;
		last;
	    }
	    else {
		&PrntChty(4,"$Task{stem}: Error: GetViewer: .... $task not found\n");
	    }
	}
    }

    # No viewer found
    return 0;
} #GetViewer


sub PlotImage {
#
# Find the Image Viewer good for the Image File Format
#
    my ( $viewer, $ImageFile) = @_ ;
    use vars qw (%Task);

    my ( $command ) = "$viewer $ImageFile &";
    if ( !-f $ImageFile ) {
	&PrntChty(1,"$Task{stem}: Error: PlotImage: cannot display '$ImageFile': file not found\n");
	return 1;
    }
    if ( system ( $command ) ) {
	&PrntChty(1,"$Task{stem}: Error: PlotImage: running '$viewer' Viewer\n");
	return 1;
    }

    return 0;

} # Plot Image


sub SetLev2EvtFileName {

    my ( $infile,$outdir ) = @_;
    use vars qw (%Task);

    my ( $stemlev2 ) = "cl";
    my ( $filenopath ) = substr($infile,rindex( $infile, '/' )+1);

    # Check if the event file is compressed
    my ( @splitfields ) = split ( /\./,$filenopath);
    if ( $splitfields[$#splitfields] eq "gz" || $splitfields[$#splitfields] eq "Z" ) { 
	pop @splitfields; }
    my ( $filenozip ) = join '.', @splitfields;

    my ( $filenoext ) = substr($filenozip,0,rindex( $filenozip, '.' ));
    my ( $ext ) = substr($filenozip,rindex( $filenozip, '.' ));

    if ( $filenoext =~ /(l1a|ufre)/ ) { $filenoext =~ s/(l1a|ufre)/$stemlev2/; }
    elsif ( $filenoext =~ /(l1|uf)/ ) { $filenoext=~ s/(l1|uf)/$stemlev2/; }
    else { $filenoext .= $stemlev2; }

    my ( $lev2filename ) = "$outdir/$filenoext$ext";
    &PrntChty(3,"$Task{stem}: Info: SetLev2EvtFileName: Filtered Event File will be $lev2filename\n");

    return $lev2filename;
} # SetLev2EvtFileName

sub SetExpoMapFileName {

    my ( $infile,$outdir ) = @_;
    use vars qw (%Task);

    my ( $stemexpo ) = "ex.img";
    my ( $steminstr ) = "rawinstr.img";
    my ( $filenopath ) = substr($infile,rindex( $infile, '/' )+1);

    # Check if the event file is compressed
    my ( @splitfields ) = split ( /\./,$filenopath);
    if ( $splitfields[$#splitfields] eq "gz" || $splitfields[$#splitfields] eq "Z" ) { 
	pop @splitfields; }
    my ( $filenozip ) = join '.', @splitfields;

    my ( $filenoext ) = substr($filenozip,0,rindex( $filenozip, '.' ));
    
    my ($instrnoext) = $filenoext;

    $filenoext=~ s/(cl)/$stemexpo/; 
    $instrnoext =~ s/(cl)/$steminstr/;
    my ( $expofilename ) = "$outdir/$filenoext";
    my ( $instrfilename ) = "$outdir/$instrnoext";

    &PrntChty(3,"$Task{stem}: Info: SetExpoMapFileName: Exposure Map File will be $expofilename\n");
    &PrntChty(3,"$Task{stem}: Info: SetExpoMapFileName: Raw Instrument Map will be $instrfilename\n");

    return $expofilename, $instrfilename;
} # SetExpoMapFileName


sub AddKeyword {

    my ( $fileandext, $keyname, $keyvalue, $comment ) = @_ ;

    use vars qw ( %Task %Default);

    my ( $PARKEY_COMMAND ) = 'fparkey';

    if ( !&FindExecFile($PARKEY_COMMAND) ) {

	&PrntChty(2,"$Task{stem}: Error: AddKeyword: Executable '$PARKEY_COMMAND' not found in User Path\n");
	$Task{errmess} = "Error: Executable '$PARKEY_COMMAND' not found in User Path";
	$Task{status} = 1;
	return 1;
    }

    my $cmd = "$PARKEY_COMMAND $keyvalue $fileandext $keyname add=yes ";


    if (defined($comment)) {
	$cmd .= "comm='$comment'";
    }

    if ( my($FkeyRet) = qx($cmd) ) {
	&PrntChty(2,"$Task{stem}: Error: AddKeyword: Running $cmd \n");
	$Task{errmess} = "Error: Running '$PARKEY_COMMAND $fileandext $keyname'";
	$Task{status} = 1;
	return 1;
    }

    return 0;

} # AddKeyword

sub CallQuzcif {


    my ( $Dataset, $Date, $Time, $Selection , $expnumfile ) = @_;  
    my ( $field,@dummy, @outlist , @extlist);
    use vars qw ( %Task );

    # The function performs a query to the CALDB database based
    # on $Dataset, $Date, $Time, $Selection parameters (see below
    # for the input parameter description.
    # The function return two array 'outlist' and 'extlist' with the result of the query.
    # The array is filled with filenames and extensions from the quzcif query
    # For example: if the 'quzcif' query gives only one match the array will
    #              content : $outlist[0] = filename
    #                        $extlist[0] = extension
    #              if the 'quzcif' query gives two matches the array will
    #              content : $outlist[0] = filename1
    #                        $extlist[0] = extension1
    #                        $outlist[1] = filename2
    #                        $extlist[1] = extension2
    #              etc ....
    # $Dataset - 'Calibration Dataset Codename'
    # $Date    - 'Requested Date in yyyy-mm-dd format' or "NOW" for the must up to date dataset
    # $Time    - 'Requested Time in hh:mm:ss format' or "-" if $date = "NOW"
    # $Selection - "Boolean selection expression for Boundary params" or "-" if not required

    # Check CALDB environment
	
	## different from original one:

    if ( !$ENV{CALDB} ) {
	&PrntChty(2,"$Task{stem}: Error: CallQuzcif: CALDB environment not set\n");
	&PrntChty(2,"$Task{stem}: Error: CallQuzcif: Please set the CALDB environment or specify the input parameter for '$Dataset'\n");
	$Task{status} = 1;
	return (\@outlist,\@extlist);
    }
	#print "Dataset is $Dataset \n";
    my ( $command ) = "quzcif SWIFT XRT - - $Dataset $Date $Time \"$Selection\" retrieve+ clobber=yes"; 
    &PrntChty(2,"$Task{stem}: Info: CallQuzcif: Running $command\n"); 
    my ( @ret ) = qx($command);
    &PrntChty(2,"CallQuzcif: Info: Output 'quzcif' Command: \nCallQuzcif: Info:@ret");

    if ( $#ret == -1 ) {
	&PrntChty(2,"$Task{stem}: Error: CallQuzcif: No Calibration File Found for '$Dataset' dataset\n");
	&PrntChty(2,"$Task{stem}: Error: CallQuzcif: 'quzcif' command: \"$command\"\n");
	$Task{status} = 1;
	return (\@outlist,\@extlist);
    }

    if ( $#ret != $expnumfile-1) {
	my $n = $#ret +1;
	&PrntChty(2,"$Task{stem}: Error: CallQuzcif: Found " . $n . " calibration file(s) instead of $expnumfile file(s)\n");
	$Task{status} = 1;
	return (\@outlist,\@extlist);
    }				 

    foreach $field ( @ret ) {

	my ( $file, $ext );

	if ( $field =~ "ERROR" ) {
	     &PrntChty(2,"$Task{stem}: Error: CallQuzcif: 'quzcif': @ret\n");
	     $Task{status} = 1;
	     return (\@outlist,\@extlist);
	}

	($file, $ext ) = split /\s+/,$field;
	push @outlist, $file;
	push @extlist, $ext;

    }

    return (\@outlist,\@extlist);

} # CallQuzcif


sub CheckXselectLog {

    # No error code returned by xselect
    # check errors from 'xselect.log' found in
    # current directory
    my $ret = 0;
    my $XselectLog = "xselect.log";
    if ( !-f $XselectLog ) {
	PrntChty(3,"$Task{stem}: Warning: CheckXselectLog: '$XselectLog' not found\n");
	PrntChty(3,"$Task{stem}: Warning: CheckXselectLog: no checks on 'xselect' run performed\n");
    }
    else {
	if ( ! open ( XSELECTLOG, "<$XselectLog" )) {
	    PrntChty(3,"$Task{stem}: Warning: CheckXselectLog: Cannot read '$XselectLog' file\n");
	    PrntChty(3,"$Task{stem}: Warning: CheckXselectLog: no checks on 'xselect' run performed\n");
	}
	else {
	    while ( <XSELECTLOG> ) { 
		if ( $_ =~ /Error/ ) {
		    chop;
		    PrntChty(2,"$Task{stem}: Error: CheckXselectLog: following error message found for 'xselect' run:\n");
		    PrntChty(2,"$Task{stem}: Error: CheckXselectLog: '$_'\n");
		    $ret = 1;
		}
	    }
	    close XSELECTLOG;
	}
    }

    return $ret;

} # CheckXselectLog


#Return number of extension with extname=parameter
# if not found return -1
sub GetNumExtName {

    my ($filename,$extname) = @_;

    my ($numext, $fptr, $status) = (0, 0, 0);

    fits_open_file($fptr,$filename,READONLY,$status);
    if ($status) {
	$Task{status} = 1;
	&PrntChty(2,"$Task{stem}: Error: GetNumExtName: Fitsio 'fits_open_file' error '$status' on '$filename' file\n");
	$Task{errmess} = "Unable to open fits file : $filename";
	return 5;
    }
    fits_movnam_hdu($fptr,ANY_HDU,$extname,0,$status);
    if ($status == BAD_HDU_NUM ) {
	  &PrntChty(4,"$Task{stem}: Warning: GetNumExtName: not found '$extname' extension\n");
	  &PrntChty(4,"$Task{stem}: Warning: GetNumExtName: in '$filename' file\n");
	  fits_close_file($fptr,$status);
	  return -1;
    } elsif ($status) {
	$Task{status} = 1;
	$Task{errmess} = "Unable to move to the extension '$extname' of '$filename'";
	fits_close_file($fptr,$status);
	return;
    }

    fits_get_hdu_num($fptr,$numext);
    fits_close_file($fptr,$status);
    
    return $numext-1;
 
} # GetNumExtName

sub LoadBinTable
{
    my ($filefits, $extname,$numext,@columns) = @_;
    use vars qw ( %Task );

    my $status = 0;
    my $fits = Astro::FITS::CFITSIO::open_file($filefits, READONLY, $status);
    if (not $fits) {
	 &PrntChty(2,"$Task{stem}: Error: LoadBinTable: CFITSIO::open_file: error on '$filefits' file\n");
	 $Task{status} = 1;
	 return;
    }
    
    if (defined($extname) && ($extname ne "")) {
	 $fits->movnam_hdu(BINARY_TBL, $extname, 0, $status);
	 if ( $status ) {
	     &PrntChty(2,"$Task{stem}: Error: LoadBinTable: movnam_hdu: error on '$filefits' file\n");
	     &PrntChty(2,"$Task{stem}: Error: LoadBinTable: unable to move to extname: $extname\n");
	     $Task{status} = 1;
	     return;
	 }
    } else {
	 
	 $fits->movabs_hdu($numext+1,undef,$status);
	 if ( $status ) {
	     &PrntChty(2,"$Task{stem}: Error: LoadBinTable: movabs_hdu: error on '$filefits' file\n");
	     &PrntChty(2,"$Task{stem}: Error: LoadBinTable: unable to move to ext num: $numext\n");
	     $Task{status} = 1;
	     return;
	 }
    }

    my $count = -1;
    $fits->get_num_rows($count, $status);
    if ($status) {
	&PrntChty(2,"$Task{stem}: Error: LoadBinTable: get_num_rows: error on '$filefits' file\n");
	&PrntChty(2,"$Task{stem}: Error: LoadBinTable: unable to get the number of rows\n");
	$Task{status} = 1;
	return ;
	 
    }

    foreach my $col (@columns) {

	 $col->{data} = [ ];

	 my $index = -1;
	 my $null  = -1;
	 my $nulls = -1;
	 my ( $type,$repeat,$width, $tzeroval,$comm );

	 if ($fits->get_colnum(0, $col->{name}, $index, $status)) {
	     &PrntChty(2,"$Task{stem}: Error: LoadBinTable: get_colnum: error on '$filefits' file\n");
	     &PrntChty(2,"$Task{stem}: Error: LoadBinTable: unable to get colnum: '$col->{name}'\n");
	     $Task{status} = 1;
	     return ;
	 }

	 if ($fits->get_coltype($index,$type,$repeat,$width,$status)) {
	     &PrntChty(2,"$Task{stem}: Error: LoadBinTable: Unable to get column type ($col) file : $filefits\n");
	     $Task{status} = 1;
	     return ;
	 }
  
	 $fits->read_key(TULONG,"TZERO$index",$tzeroval,$comm,$status);
	 if ($status == KEY_NO_EXIST ) {
	     $tzeroval = -1;
	     $status = 0;
	 }

	 my $tscal = 1;

	 $fits->read_key(TINT,"TSCAL$index",$tscal,$comm,$status);
	 if ($status == KEY_NO_EXIST ) {
	     $tscal = 1;
	     $status = 0;
	 }

	 if ($type == TINT) {
	     if (($tscal == 1) &&($tzeroval == 32768)) {
		 $type = TUINT;
	     }
	 }
	 if ($type == TLONG) {
	     if (($tscal == 1) &&($tzeroval == 2147483648 )) {
		 $type = TULONG;
	     }
	 }

#	 print "Column name: $col->{name} index: $index type: $type (numero righe: $count)\n";
#	 print TDOUBLE . " " . TSHORT . "\n"; 
	 $fits->read_col($type,$index, 1, 1, $count, $null,$col->{data}, $nulls, $status);
	 if ($status) {
	      &PrntChty(2,"Task{stem}: Error: LoadBinTable: unable to read column: '$col->{name}'\n");
	      &PrntChty(2,"Task{stem}: Error: LoadBinTable: from file: $filefits\n");
	      $Task{status} = 1;
	      return ;
	 }

    }

    $fits->close_file($status);

    # convert from parallel arrays to array of keyed structs
    my @table = ();
    for (my $i = 0; $i < $count; ++$i) {
	 my %record;
	 foreach my $col (@columns) {
	     $record{$col->{name}} = $col->{data}[$i];
	 }


	 push(@table, \%record);
    }
    
    return @table;

} # LoadBinTable

sub SetGtiFileName {

# The subroutine returns the GTI file name following
# standard neming convention

    my ( $evtfile, $outdir ) = @_;
    use vars qw ( %Task %Def );

    # Cut off event file extension and path
    my ($InStem) = &GetFileNameRoot ( $evtfile );
    if ( length($InStem) == $Def{LEV2LEN} ) {
	$InStem = substr($InStem,0,$Def{LEV2STARPOINT});
    }

    my ($gtifile) = "$outdir/$InStem$Def{GTIFILESTEM}.fits";

    return $gtifile;

} # SetGtiFileName

sub GetPfilesName {
    
    use vars qw ( %Task);

    my ($file1,$file2);
    my $filename = $Task{name} . ".par";

    if ($ENV{PFILES} eq "") {
	    &PrntChty(2,"$Task{stem}: Error: GetPfilesName: PFILES environment variable not found\n");
	    $Task{errmess} ="PFILES environment variable not found";
	    $Task{status} = 1;
	    return;
    }

    my @path = split(/[;:]/,$ENV{PFILES});
    
    $file1 = $path[0] . "/" . $filename;

    if (($#path>0) && ($ENV{PFCLOBBER}==1)) {
	for (my $i = 1; $i <= $#path; $i++) {
	    $file2 = $path[$i] . "/" . $filename;
	    if ( -f $file2 ) {
		if ((stat($file2))[10] > (stat($file1))[10]) {
		    if (!copy ($file2,$file1)) {
			&PrntChty(2,"$Task{stem}: Error: GetPfilesName: Cannot copy parameter file $file2 into $file1\n");
			$Task{errmess} ="Cannot copy parameter file $file2 into $file1";
			$Task{status} = 1;
			return;
		    }
		}
	    }
	}
    }


    if (! -f $file1) {
	&PrntChty(2,"$Task{stem}: Error: GetPfilesName: Parameter file $file1 not found \n");
	$Task{errmess} ="Parameter file '$file1' not found";
	$Task{status} = 1;
	return;
    }
    
    return $file1;

} # GetPfilesName


sub GetParameterList {
    use vars(%Task);

    my $pfile = &GetPfilesName();
    if ($Task{status}) { 
	&PrntChty(2,"$Task{stem}: Error: GetParameterList: Cannot get parameter file name\n");
	return;
    }

    if (!open(FILEPAR,$pfile)) {
	$Task{errmess} = "Cannot open input parameter file ($pfile)";
	$Task{status} = 1;
	return;
    }

    my @arr_par;
    my $i = 0;
    my %keyind;
    while (<FILEPAR>) {
	chomp();

	if (! ($_ =~ /^#/)) {
	
	       my ($name,$type,$mode,$defvalue,$minval,$maxval,$description) = split(",");
	       
	       my %hash;
	       
	       $defvalue =~ s/^\s+//; # remove leading spaces
	       $defvalue =~ s/\s+$//; # remove trailing spaces	
	       $defvalue =~ s/^"//g;; #Remove apex
               $defvalue =~ s/"$//g;; #Remove apex
	       
	       
	       $hash{name} = $name;
	       $hash{defval} = $defvalue; 
	       #if ($type eq "h") {
		   $hash{val} = $defvalue;
	      # } else {
	#	   $hash{val} = "DEFAULT";
	 #      }
	       $hash{set} = 0;
	       $hash{type} = $type;  
	       $hash{maxval} = $maxval; 
	       $hash{minval} = $minval; 
	       
	       #$arr_par[$i] = \%hash;
	       
	       push (@arr_par,\%hash);
	       
	       $keyind{$name} = $i;
	       
	       $i++;
	   }
	}

	close FILEPAR;
	
    return (\%keyind , @arr_par);

} # GetParameterList


sub LoadParameterFromCmdLine {

    my (@ARGV) = @_;

    use vars qw(@Par %Ind);

    my ( $name, $value, $p);


    if ($#Par < 0) {
	&PrntChty(2,"$Task{stem}: Error: LoadParameterFromCmdLine: List of input parameter is empty \n");
	$Task{errmess} ="LoadParameterFromCmdLine the List of input parameters is empty";
	$Task{status} = 0;
	return 0;

    }

    
    foreach $p (@ARGV) {
	
	($name,$value) = split("=",$p);
	
	if (! exists($Ind{$name})) {
	    &PrntChty(2,"$Task{stem}: Error: parsing input parameter '$name'\n");
	    &PrntChty(2,"$Task{stem}: Error: Parameter name '$name' not found or sintax error\n");
	    &PrntChty(2,"$Task{stem}: Error: Please specify parameters with format: <parametername>=<parametervalue>\n");
	    &PrntChty(2,"$Task{stem}: Error: without blanks\n");
	    &PrntChty(2,"$Task{stem}: Error: Type 'fhelp $Task{name}' for more information on parameters\n");
	    return 0;
	} else {
	    
	    my $v = GetInputParam ($p);
	    
	    if (($Par[$Ind{$name}]->{type} eq "r") || ($Par[$Ind{$name}]->{type} eq "i")) {
		if (($Par[$Ind{$name}]->{minval} ne "") && ($Par[$Ind{$name}]->{maxval} ne "")) {
		    
		    if (($v < $Par[$Ind{$name}]->{minval}) || ($v > $Par[$Ind{$name}]->{maxval})) {
			&PrntChty(2,"$Task{stem}: Error: parsing input parameter '$name'\n");
			&PrntChty(2,"$Task{stem}: Error: Value is out of range minvalue=$Par[$Ind{$name}]->{minval} maxvalue=$Par[$Ind{$name}]->{maxval}\n");
			$Task{errmess} = "LoadParameterFromCmdLine: Parameter $name value is out of range";
			$Task{status} = 0;
			return 0;
		    }
		}
	    }

	    $Par[$Ind{$name}]->{val} = $v;
	    if ($Task{status}) { return 0;}
	    
	    $Par[$Ind{$name}]->{set} = 1;
	}
	
    }

    return 1;

} # LoadParameterFromCmdLine

sub LoadParameter {


    use vars qw(@Par %Ind %Task);
    
    my ($val, $p);

    foreach $p (@Par ) {
	if ( &RequestParameter($p->{name})) {
	    $val = "";
	    if ($p->{set} == 0) {
		chop($val = `pquery2 $Task{name} $p->{name}`);
		$p->{set} = 2;
		#if ( !$val  && $val != 0) {
		if ($val eq "") {
		    &PrntChty(2,"$Task{stem}: Error: LoadParameter: Running 'pquery2 $Task{name} $p->{name}'\n");
		    $Task{errmess} ="Running 'pquery2 $Task{name} $p->{name}'";
		    $Task{status} = 1;
		    return 0;
		} 
		else { $p->{val} = $val;}
	    }
	}
    }
    
    #Reset string of message populate from RequestParameter in case of error
    $Task{errmess} = "";
    return 1;

} # LoadParameter


sub GetValPar {

    my ( $parname , $pos) = @_;

    use vars qw(@Par %Ind %Task);

    my $p;

    if ( !defined($pos) ) { $p = "val";}
    else {$p = $pos;}

    if ( $p eq "val" && !defined($Ind{$parname}) ) {
	$Task{status} = 1;
	$Task{errmess} = "Parameter '$parname' not found in the input parameter file";
	&PrntChty(2,"$Task{stem}: Error: GetValPar: $Task{errmess}\n");
	return;
    }

    return $Par[$Ind{$parname}]->{$p};

} # GetValPar

sub SetValPar {

    my ( $parname , $val,$col) = @_;

    use vars qw(@Par %Ind %Task);

    my $pos;

    if ( !defined($col) ) { $pos = "val";}
    else {$pos = $col;}
    
    my $name = exists($Ind{$parname});

    if ($name) {
    	$Par[$Ind{$parname}]->{$pos} = $val;
    } else {
	$Task{status} = 1;
	$Task{errmess} = "Parameter $parname not found";
    }
} # SetValPar


sub getHistoryTime {

    my @f = localtime();

    my $s = sprintf("%04d-%02d-%02dT%02d:%02d:%02d",$f[5]+1900,$f[4]+1,@f[3,2,1,0]);

    return $s;
    
} # getHistoryTime


# Write History Parameter List
# hdunum < 0 to write in all extension

sub write_history {

    my ($filename,$hdunum,$hist) = @_;

    use vars qw (%Task);
   
    my  ($p,$start);

    if ( &GetValPar("history") =~ /no/i) {
	return 0;
    }


    if (&IsCompressed($filename)) {
	&PrntChty(2,"$Task{stem}: Error: write_history: Cannot write history into a compressed file (file : $filename)\n");
	$Task{status} = 1;
	return 1;
    }
   
    my $status = 0;
    my $fits = Astro::FITS::CFITSIO::open_file($filename, READWRITE, $status);
    if (not $fits) {
	&PrntChty(2,"$Task{stem}: Error: write_history: Unable to open '$filename' file\n");
	$Task{status} = 1;
	return 1;
    }


    if ($hdunum < 0) {
	$start = 1;
	$fits->get_num_hdus($hdunum,$status);
	if ( $status ) {
	    &PrntChty(2,"$Task{stem}: Error: write_history: unable to get the number of HDUs\n");
	    &PrntChty(2,"$Task{stem}: Error: write_history: of '$filename' file\n");
	    $Task{status} = 1;
	    $fits->close_file($status);
	    return 1;
	}
    } else { 
	$start = $hdunum;
    }
    

    for (my $ind = $start; $ind<=$hdunum; $ind++) {

	$fits->movabs_hdu($ind,undef,$status);
	if ($status) {
	    $Task{errmess} = "Running movabs_hdu (num $ind) on $filename";
	    &PrntChty(2,"$Task{stem}: Error: write_history: $Task{errmess}\n");
	    return 1;
	}

	$fits->write_history($hist,$status);
	if ($status) {  
	    $Task{errmess} = "Running write_history (num $ind) on $filename";
	    &PrntChty(2,"$Task{stem}: Error: write_history: $Task{errmess}\n");
	    return 1;
	}

	$fits->write_chksum($status);
	if ($status) {
	    $Task{errmess} = "Running write_chksum (num $ind) on $filename";
	    &PrntChty(2,"$Task{stem}: Error: write_history: $Task{errmess}\n");
	    $Task{status} = 1;
	    return 1;
	}
	
    }
    
    $fits->close_file($status);

    return 0;

} # write_history



#Write History Parameter List
# hdunum < 0 to write in all extension

sub WriteParameterList {
    my ($filename,$hdunum,@list) = @_;

    use vars qw (%Task);
   
    my  ($start);


     if ( &GetValPar("history") =~ /no/i) {
	return 0;
    }

    if (&IsCompressed($filename)) {
	&PrntChty(2,"$Task{stem}: Error: WriteParameterList: Cannot write history into a compressed file (file : $filename)\n");
	$Task{status} = 1;
	$Task{errmess} = "Cannot write history into a compressed file (file : $filename)";
	return 1;
    }
   
    my $status = 0;
    my $fits = Astro::FITS::CFITSIO::open_file($filename, READWRITE, $status);
    if (not $fits) {
	&PrntChty(2,"$Task{stem}: Error: WriteParameterList: Unable to open '$filename' file\n");
	$Task{status} = 1;
	return 1;
    }


    if ($hdunum < 0) {
	$start = 1;
	$fits->get_num_hdus($hdunum,$status);
	if ( $status ) {
	    &PrntChty(2,"$Task{stem}: Error: WriteParameterList: unable to get the number of HDUs\n");
	    &PrntChty(2,"$Task{stem}: Error: WriteParameterList: of '$filename' file\n");
	    $Task{status} = 1;
	    $fits->close_file($status);
	    return;
	}
    } else { 
	$start = $hdunum;
    }
    

    for (my $ind = $start; $ind<=$hdunum; $ind++) {
	
	$fits->movabs_hdu($ind,undef,$status);
	if ($status) {  
	    &PrntChty(2, "$Task{stem}: Error: WriteParameterList: Running 'fits->movabs_hdu' (num $ind) on $filename\n");
	    $Task{errmess} = "Running movabs_hdu (num $ind) on $filename";
	    $Task{status} = 1;
	    return 1;
	}

	my $p;

	$fits->write_history(" ",$status); 
	$fits->write_history("START PARAMETER list for $Task{stem} at " . &getHistoryTime(),$status); 
	$fits->write_history(" ",$status); 
    


	my $numpar = 0;
	
	foreach $p (@list) {
	    $numpar++;
	    &WriteParHistory($fits,"P" . $numpar . " ",$p->{name} . " = " . $p->{val},\$status);
	    #$fits->write_history($p->{name} . " = " . $p->{val},$status);
	    if ($status) {  
		&PrntChty(2, "$Task{stem}: Error: Running: 'fits->write_history' on $filename\n");
		$Task{errmess} ="Error running write_history on $filename";
		$Task{status} = 1;
	    return 1;
	    }
	}
	$fits->write_history(" ",$status); 
    
	$fits->write_history("END PARAMETER list for $Task{stem}",$status);
			


	$fits->write_chksum($status);
	if ($status) {
	    $Task{errmess} = "Running write_chksum (num $ind) on $filename";
	    &PrntChty(2,"$Task{stem}: Error: $Task{errmess}\n");
	    $Task{status} = 1;
	    return 0;
	}


    }
    
    $fits->close_file($status);

    return 0;
} # WriteParameterList


    
sub WriteParHistory {
    my ($filefits,$head,$str,$status) = @_;
    
    my ($len,$part,$beg,$end,@liststr);

    my $const = "HISTORY ";

    $part = 80 - length($const) - length($head);
    $beg = 0;
    $end = $part;

    while ($beg < length($str)) {
	push @liststr, substr($str,$beg,$end);
	$beg +=$part;
    }

    for (my $i = 0; $i <= $#liststr; $i++) {
	$filefits->write_history("$head" . "$liststr[$i]",$$status);
    }

    
} # WriteParHistory 

sub UpdateCheckSum {

    my ($file) = @_;
    
    my $status = 0;
    my $fits = Astro::FITS::CFITSIO::open_file($file, READWRITE, $status);
    
    my $hdunum;

    $fits->get_num_hdus($hdunum,$status);
    if ( $status ) {
	&PrntChty(2,"$Task{stem}: Error: UpdateCheckSum: unable to get the number of HDUs\n");
	&PrntChty(2,"$Task{stem}: Error: UpdateCheckSum: of '$file' file\n");
	$Task{status} = 1;
	$fits->close_file($status);
	return;
    }

    for (my $ind = 1; $ind<=$hdunum; $ind++) {
	
	$fits->movabs_hdu($ind,undef,$status);
	if ($status) {
	    $Task{errmess} = "Running movabs_hdu (num $ind) on $file";
	    &PrntChty(2,"$Task{stem}: Error: UpdateCheckSum: $Task{errmess}\n");
	    $Task{status} = 1;
	    return 0;
	}

	
	$fits->write_chksum($status);
	if ($status) {
	    $Task{errmess} = "Running write_chksum (num $ind) on $file";
	    &PrntChty(2,"$Task{stem}: Error: UpdateCheckSum: $Task{errmess}\n");
	    $Task{status} = 1;
	    return 0;
	}

    }

    $fits->close_file($status);
    return 1;

} # UpdateCheckSum


sub IsNumeric {
    my $InputString = shift;
    
    if ($InputString !~ /^([-|+])?[0-9]*([.|,]([0-9]*))?((e|E)([-|+])?[0-9]+)?$/) {
	return 0;
    }
    else {
	return 1;	
    }	
}


sub CheckRa {

    my ($type,$str) = @_;

    use vars qw(%Task);

    my (@l, $hh, $mm, $ss, $rag) ;

    &PrntChty(3,"CheckRa : Info: CheckRa: Performing check on RA '$str' string\n");


    (@l) = split(" ",$str);

    if (&trimValue($str) eq "") {
	$Task{errmess} = "Invalid $type sintax. Please specify $type with format 'hh mm ss.s' or 'xx.xx'(deg)";
	$Task{status} = 1;
	return 0;
    }


    for (my $ind =0; $ind <=$#l; $ind++) {
	if (! &IsNumeric($l[$ind])) {
	    $Task{errmess} = "Invalid $type sintax. Please specify $type with format 'hh mm ss.s' or 'xx.xx'(deg)";
	    $Task{status} = 1;
	    return 0;
	}
    }

    if ($#l == 0) { 
	$rag = $l[0];
    }
    else {	
	if ($#l >= 3) {
	    $Task{errmess} = "Invalid $type sintax. Please specify $type with format 'hh mm ss.s' or 'xx.xx'(deg)";
	    $Task{status} = 1;
	    return 0;
	}
	
	$hh = $l[0];
	$mm = $l[1]+0;
	$ss = $l[2]+0;
	
	if (($hh < 0) || ($hh > 23)) {
	    $Task{errmess} = "Invalid $type range. Please check $type input";
	    $Task{status} = 1;
	    return 0;
	}


	if (($mm < 0) ||  ($mm > 59)) {
	    $Task{errmess} = "Invalid $type range. Please check $type input";
	    $Task{status} = 1;
	    return 0;
	}

	if (($ss < 0) ||  ($ss > 59.9)) {
	    $Task{errmess} = "Invalid $type range. Please check $type input";
	    $Task{status} = 1;
	    return 0;
	}
	
    
	$rag = &Ra2Deg($str);

    }

    if (($rag < 0) || ($rag > 360)) {
	$Task{errmess} = "Invalid $type range. Please check $type input";
	$Task{status} = 1;
	return 0;
    }

    return 1;
} # CheckRa 

sub CheckDec {

    my ($type,$str) = @_;

    use vars qw(%Task);

    my ($dd,$mm,$ss,@l,$deg) ;

    &PrntChty(3,"CheckDec: Info: CheckDec: Performing check on DEC '$str' string\n");
    
    if (&trimValue($str) eq "") {
	$Task{errmess} = "Invalid $type sintax. Please specify $type with format 'dd mm ss.s' or 'xx.xx'(deg)";
	$Task{status} = 1;
	return 0;
    }


    (@l) = split(" ",$str);

    for (my $ind =0; $ind <=$#l; $ind++) {
	if (! &IsNumeric($l[$ind])) {
	    $Task{errmess} = "Invalid $type sintax. Please specify $type with format 'dd mm ss.s' or 'xx.xx'(deg)";
	    $Task{status} = 1;
	    return 0;
	}
    }


    if ($#l == 0) { 
	$deg = $l[0];
    }
    else {	
	if ($#l >= 3) {
	    $Task{errmess} = "Invalid $type sintax. Please specify $type with format 'dd mm ss.s' or 'xx.xx'(deg)";
	    $Task{status} = 1;
	    return 0;
	}
	
	$dd = $l[0];
	$mm = $l[1]+0;
	$ss = $l[2]+0;

	my $neg = 0;

	if ($str =~ /^\-/) {
	    $neg = 1;
	    $dd = 0 - $dd;
	}

	if (($dd < -90) || ($dd > 90)) {
	    $Task{errmess} = "Invalid $type range. Please check $type input";
	    $Task{status} = 1;
	    return 0;
	}


	if (($mm < 0) ||  ($mm > 59)) {
	    $Task{errmess} = "Invalid $type range. Please check $type input";
	    $Task{status} = 1;
	    return 0;
	}

	if (($ss < 0) ||  ($ss > 59.9)) {
	    $Task{errmess} = "Invalid $type range. Please check $type input";
	    $Task{status} = 1;
	    return 0;
	}

    
	$deg = &Dec2Deg($str);
	if ($neg) { $deg = 0 - $deg;}

    }
    if (($deg < -90) || ($deg > 90)) {
	$Task{errmess} = "Invalid $type range. Please check $type input";
	$Task{status} = 1;
	return 0;
    }

    return 1;

} # CheckDec


sub Ra2Deg {

    my ($str) = @_;

    use vars qw(%Task);

    my ($hh,$mm,$ss,@l,$result) ;

    (@l) = split(" ",$str);
    if ($#l == 0) { 
	$result = $l[0];
    }
    else {	
	
	$hh = $l[0];
	$mm = $l[1]+0;
	$ss = $l[2]+0;

	if ($hh =~ /^-/) { $mm *=-1;$ss*=-1;}

	$result = $hh*15 + ($mm*15/60) + ($ss*15/3600);
    }

    return $result;


} # Ra2Deg



sub Dec2Deg {

    my ($str) = @_;

    use vars qw(%Task);

    my ($dd,$mm,$ss,@l,$result) ;


    ($dd,$mm,$ss) = split(" ",$str);

    (@l) = split(" ",$str);
    if ($#l == 0) { 
	$result = $l[0];
    }
    else {	
	
	$dd = $l[0];
	$mm = $l[1]+0;
	$ss = $l[2]+0;

	if ($dd =~ /^-/) { $mm *=-1;$ss*=-1;}

	$result = $dd + ($mm/60) + ($ss/3600);
    }

    return $result;


} # Dec2Deg

sub RaDec2XY {

    my ($file,$ra,$dec,$x,$y) = @_;

    use vars qw($PI $datamode);

    my ($xsize,$ysize,$radian,$roll2,$gamma1,$ximh,$yimh,$dera,$derar,$decr,$decnomr,$rar,$rarnomr,
	$ralde,$ranom,$decnom,$ranomr,$aixnor,$aiynor,$pixelsize,$aix,$aiy,$numcolx,$numcoly, $roll);



    &PrntChty(3,"$Task{'stem'}: Info: RaDec2XY: Converting ra: $ra deg and dec: $dec deg into x,y pixel\n");


    my ($fptr,$status,$comm) = (0, 0);
    fits_open_file($fptr,$file,READONLY,$status);
    if ($status) {
	$Task{status} = 1;
	$Task{errmess} = "Unable to open fits file : $file";
	return 0;
    }
    
    fits_movnam_hdu($fptr,ANY_HDU,"EVENTS",0,$status);
    if ($status) {
	$Task{status} = 1;
	$Task{errmess} = "Cannot move into EVENTS extension in '$file' file";
	fits_close_file($fptr,$status);
	return 0;
    }

    fits_get_colnum($fptr,0,"X",$numcolx,$status);
    if ($status) { 
	$Task{status} = 1;
	$Task{errmess} = "Column X not found in '$file' file";
	fits_close_file($fptr,$status);
	return 0;
    }
    fits_get_colnum($fptr,0,"Y",$numcoly,$status);
    if ($status) { 
	$Task{status} = 1;
	$Task{errmess} = "Column Y not found in '$file' file";
	fits_close_file($fptr,$status);
	return 0;
    }

    fits_read_keyword($fptr,"TCRVL" . $numcolx,$ranom,$comm,$status);
    if ( $status) { 
	$Task{status} = 1;
	$Task{errmess} = "Keyword TCRVL$numcolx not found in '$file' file";
	fits_close_file($fptr,$status);
	return 0;
    }
    fits_read_keyword($fptr,"TCRVL" . $numcoly,$decnom,$comm,$status);
    if ( $status) { 
	$Task{status} = 1;
	$Task{errmess} = "Keyword TCRVL$numcolx not found in '$file' file";
	fits_close_file($fptr,$status);
	return 0;
    }

    fits_read_keyword($fptr,"TCDLT" . $numcolx,$pixelsize,$comm,$status);
    if ( $status) { 
	$Task{status} = 1;
	$Task{errmess} = "Keyword TCRVL$numcolx not found in '$file' file";
	fits_close_file($fptr,$status);
	return 0;
    }
    fits_close_file($fptr,$status);

    $xsize = 1000;
    $ysize = 1000;

    $radian = 180 / $PI;

    $roll = 270;

    $roll2 = -$roll + 270;
    $gamma1 = -$roll2/$radian;

    $ximh = $xsize/2 + 0.5;
    $yimh = $ysize/2 + 0.5;
    $dera = $ranom - $ra;

    if ($dera < -300) {
	$dera = $ranom + 360 - $ra;
    }
    $derar = $dera/$radian;
    $decr = $dec/$radian;
    $decnomr= $decnom/$radian;
    $rar=$ra/$radian;
    $ranomr=$ranom/$radian;
    
    $ralde=acos((sin($decr)*sin($decnomr))+(cos($decr)*cos($decnomr)*cos($derar)));

    $aixnor=0.0;
    $aiynor=0.0;
    if($ralde !=0) {
	$aixnor = $ralde/sin($ralde)*$radian/-$pixelsize*cos($decr)*sin($derar);
	$aiynor = $ralde/sin($ralde)*$radian/-$pixelsize*(sin($decr)*cos($decnomr)- cos($decr)*sin($decnomr)*cos($derar));
    }

    $aix = $aixnor*cos($gamma1) - $aiynor*sin($gamma1) + $ximh;
    $aiy = $aiynor*cos($gamma1) - $aixnor*sin($gamma1) + $yimh;

    $$x = $aix;
    $$y = $aiy;

    &PrntChty(3,"$Task{'stem'}: Info: RaDec2XY: Calculated x: ${aix}pixel and y: ${aiy}pixel\n");

    if (($aix < 0) || ($aix > 1000)) {
        $Task{errmess} = "Sky X coordinate out of range (0,1000)";
	return 0;
    }

    if (($aiy < 0) || ($aiy > 1000)) {
        $Task{errmess} = "Sky Y coordinate out of range (0,1000)";
	return 0;
    }
    return 1;
} # RaDec2XY



#When chkval is not defined 
#Check if value is different from 0 and TNULL value (if TNULL value is not exist 
# default value is -1)

sub CheckCol {
    
    my ($filename,$extname,$colname,$chkval,$maxval,$minval) = @_;

    use vars qw (%Task);

    my ($fptr,$status) = (0, 0);
    fits_open_file($fptr,$filename,READONLY,$status);
    if ($status) {
	$Task{status} = 1;
	&PrntChty(2,"$Task{stem}: Error: CheckCol: Cannot open file: $filename\n");
	&PrntChty(2,"$Task{stem}: Error: CheckCol: CFITSIO error: $status\n");
	$Task{errmess} = "Unable to open fits file : $filename";
	return 0;
    }
    fits_movnam_hdu($fptr,ANY_HDU,$extname,0,$status);
    if ($status) {
	$Task{status} = 1;
	&PrntChty(2,"$Task{stem}: Error: CheckCol: Cannot move to extension name $extname in file $filename\n");
	&PrntChty(2,"$Task{stem}: Error: CheckCol: CFITSIO error: $status\n");
	$Task{errmess} = "Error: Cannot move to extension name $extname in file $filename";
	fits_close_file($fptr,$status);
	return 0;
    }

    my $chk = &CheckColPtr($fptr,$colname,$chkval,$maxval,$minval);

    fits_close_file($fptr,$status);

    return $chk;

}#CheckCol

sub CheckColPtr {
    
    my ($fptr,$colname,$chkval,$maxval,$minval) = @_;
    
    my ($numcol,$type,$repeat,$width,@column,$nulls,$tzeroval,$comm);

    use vars (%Task);

    $nulls = -1;

    my $max = -9999999;
    my $min =  9999999;


    my $count = -1;
    my $status = 0;
    fits_get_num_rows($fptr,$count, $status);
    if ($status) {
	&PrntChty(2,"$Task{stem}: Error: CheckColPtr: Cannot get the Fits File number of rows\n");
	&PrntChty(2,"$Task{stem}: Error: CheckColPtr: CFITSIO error: $status\n");
	$Task{errmess} = "Getting number rows";
	$Task{status} = 1;
	return 0;
    }

    fits_get_colnum($fptr,0,$colname,$numcol,$status);
    if ($status) { 
	&PrntChty(2,"$Task{stem}: Error: CheckColPtr: Cannot get the '$colname' column number\n");
	&PrntChty(2,"$Task{stem}: Error: CheckColPtr: CFITSIO error: $status\n");
	$Task{status} = 1;
	$Task{errmess} = "Column $colname not found";
	return 0;
    }


    fits_read_key($fptr,TULONG,"TZERO$numcol",$tzeroval,$comm,$status);
    if ($status == KEY_NO_EXIST ) {
	$tzeroval = -1;
	$status = 0;
    } elsif ($status) {
	$Task{status} = 1;
	&PrntChty(2,"$Task{stem}: Error: CheckColPtr: Cannot read the 'TZERO$numcol' keyword\n");
	&PrntChty(2,"$Task{stem}: Error: CheckColPtr: CFITSIO error: $status\n");
	$Task{errmess} = "Error reading keyword TZERO$numcol unexpected error";
	return 0;
    }


    my $tscal = 1;

    fits_get_coltype($fptr,$numcol,$type,$repeat,$width,$status);

    fits_read_key($fptr,TINT,"TSCAL$numcol",$tscal,$comm,$status);
    if ($status == KEY_NO_EXIST ) {
	$tscal = 1;
	$status = 0;
    } elsif ($status) {
	$Task{status} = 1;
	&PrntChty(2,"$Task{stem}: Error: CheckColPtr: Cannot read the 'TSCAL$numcol' keyword\n");
	&PrntChty(2,"$Task{stem}: Error: CheckColPtr: CFITSIO error: $status\n");
	$Task{errmess} = "Error reading keyword TSCAL$numcol unexpected error";
	return 0;
    }


    my $nullval = 0;

    if (!defined($chkval)) {

	fits_read_key($fptr,TINT,"TNULL$numcol",$nullval,$comm,$status);
	if ($status == KEY_NO_EXIST ) {
	    $nullval = -1;
	    $status = 0;
	}

    }

    if ($type == TINT) {
	if (($tscal == 1) &&($tzeroval == 32768)) {
	    $type = TUINT;
	}
    }
    if ($type == TLONG) {
	if (($tscal == 1) &&($tzeroval == 2147483648 )) {
	    $type = TULONG;
	}
    }
    my @nulls;

    fits_read_col($fptr,$type,$numcol, 1, 1, $count, 0,\@column,$nulls,  $status);

    if ($status) {
	&PrntChty(2,"$Task{stem}: Error: CheckColPtr: Cannot read column '$colname'\n");
	&PrntChty(2,"$Task{stem}: Error: CheckColPtr: CFITSIO error: $status\n");
	$Task{errmess} = "reading column: $colname file";
	$Task{status} = 1;
	return 0;
    }


    my $err = 0;
    my $isnullval = 1;
    my $iszero = 1;

    for (my $ind =0; $ind <= $#column; $ind++) {
	if (defined($chkval)) {
	    if ($column[$ind] != $chkval) {
		$err =1;
	    }
	} else {
	    if (($column[$ind] != 0)) {
		$iszero=0;
		$err =1;
	    }
	    if (($column[$ind] != $nullval)) {
		$isnullval=0;
		$err =1;
	    }

	}
	if ($column[$ind] > $max) { $max = $column[$ind];}
	if ($column[$ind] < $min) { $min = $column[$ind];}
    }

    if (defined($maxval)) {
	$$maxval = $max;
    }

    if (defined($minval)) {
	$$minval = $min;
    }

    if ( !defined($chkval) ) {
	if ($isnullval) { $Task{status} = 2; return 1;}
	elsif ($iszero){ $Task{status} = 1; return 1;}
    }

    if ($err) { return 0;}
    return 1;


}# CheckColPtr


sub GetXspecChatter {

    # xspec chatter ranges from 0 to 25

    my ( $TaskChat ) = @_;

    if ( $TaskChat < 3 ) { return 0; }
    elsif ( $TaskChat <= 4 ) { return 5; } 
    else { return 10; } 

} # GetXspecChatte

sub GetFitsPointer {
    
    # This routines returns the pointer to the 
    # fits fileextension or $pointer if
    # defined

    my ($filename,$extname,$pointer,$mode) = @_;

    use vars qw (%Task);

    if (! defined($mode)) { $mode = READONLY;}

    my ($fptr,$status) = (0, 0);

    if (defined($pointer)) { $fptr = $pointer;}
    else {
	
	fits_open_file($fptr,$filename,$mode,$status);
	if ($status) {
	    $Task{status} = 1;
	    &PrntChty(2,"$Task{stem}: Error: GetFitsPointer: Cannot open fits file: $filename\n");
	    &PrntChty(2,"$Task{stem}: Error: GetFitsPointer: CFITSIO error: $status\n");
	    $Task{errmess} = "Unable to open fits file: $filename";
	    return;
	}
    }

    if (defined($extname)) {
	fits_movnam_hdu($fptr,ANY_HDU,$extname,0,$status);
	if ($status) {
	    $Task{status} = 1;
	    &PrntChty(2,"$Task{stem}: Error: GetFitsPointer: Cannot move to extension '$extname' of file '$filename'\n");
	    &PrntChty(2,"$Task{stem}: Error: GetFitsPointer: CFITSIO error: $status\n");
	    $Task{errmess} = "Cannot move into extension '$extname' of file '$filename'";
	    return;
	}
    }
    
    return $fptr;
      
    

 }#GetFitsPointer


sub GetKeyword {

    # This subroutine returns the value of the "keyname"
    # taken from the heder extension "extname" of the
    # input "filename" or from the extension where the
    # fits file pointer "pointer" is set
    # FT 23/07/2004 - added $checkexist parameter to
    #                 do not print a message if the
    #                 keyword does not exist. If the
    #                 key does not exist the subroutine
    #                 returns the KEY_NO_EXIST code

    my ( $filename, $extname, $pointer, $keyname, $keyvalue, $checkexist ) = @_ ;

    use vars (%Task);

    my $fptr = &GetFitsPointer($filename,$extname,$pointer);
    if ($Task{status}) { 
	$Task{errmess} = "Unable to open '$filename' file";
        $Task{status} = 1;
	return 1;
    }
    
    my ($comm,$value,$str);
    my $status = 0;
    fits_read_keyword($fptr,$keyname,$value,$comm,$status);
    if ($status) {
	$Task{status} = $status;
	if ( !($checkexist && $status==KEY_NO_EXIST) ) {
	    if (defined($filename)) { $str = "Error reading keyword $keyname in file $filename";}
	    else {$str= "Error reading keyword $keyname";}
	    &PrntChty(2,"$Task{stem}: Error: GetKeyword: FITSIO error: $status\n");
	    $Task{errmess} = $str;
	    fits_get_errstatus($status,$str);
	    &PrntChty(2,"$Task{stem}: Error: GetKeyword: FITSIO error: $str\n");
	}
	fits_close_file($fptr,$status);
	return 1;
    }

    $value =~ s/^\s+//; # remove leading spaces
    $value =~ s/\s+$//; # remove trailing spaces	
    $value =~ s/^'//g;; #Remove apex
    $value =~ s/'$//g;; #Remove apex
    $value =~ s/\s+$//g;; #Remove right space

    $$keyvalue= $value;

	
    if (defined($filename)) {
	fits_close_file($fptr,$status);
	if ($status) {
	    $Task{status} = $status;
	    fits_get_errstatus($status,$str);;
	    $Task{errmess} = $str;
	    return 1;
	}
    }

    return 0;

} #GetKeyword


sub trim { # (string) -> trimmed string
  my $s=shift;
 chomp($s);  # get rid of \n
 $s =~ s/^\s+//; # remove leading spaces
 $s =~ s/\s+$//; # remove trailing spaces
 return $s;
} # /sub

sub GetEventStartDate { 

    # This subroutine returns the observation Date and Time
    # with the format needed for CALDB query
    # The Observation Start date is taken from EVENTS
    # extension for PC, WT, and PD modes (if exists..) and from the
    # primary extension for IM mode

    my ( $evtfile, $date, $time ) = @_;
    
    my $mode = &GetEventDataMode ( $evtfile );
    if ( $Task{status} ) { return; }

    my ( $extension );

    if ( $mode eq "pc" || $mode eq "pu" || $mode eq "wt" || $mode eq "lr" ) {

	my $numext = &GetNumExtName( $evtfile, "EVENTS" );
	
	if($numext > -1){
	    $extension = "EVENTS";
	}
	else{
	    $extension = undef; 
	} 
    }
    elsif ( $mode eq "im" ) { $extension = undef; }
    else { 
	&PrntChty(2,"$Task{stem}: Error: GetEventStartDate: Event File: '$evtfile'\n"); 
	&PrntChty(2,"$Task{stem}: Error: GetEventStartDate: Data Mode '$mode' not supported\n"); 
	$Task{errmess} = "Data Mode '$mode' not supported";
	$Task{status} = 1;
	return 1; 
    }

    &GetKeyword($evtfile,$extension,undef,"DATE-OBS",\$$date);
    if ( $Task{status} ) {return 1;}

    my $Tstr = substr($$date,10,1);

    if ( $Tstr eq "T" ) {
	$$time = substr($$date,11);
	$$date = substr($$date,0,10);
    }
    else {
	&GetKeyword($evtfile,$extension,undef,"TIME-OBS",\$$time);
	if ( $Task{status} ) {return 1;}
    }

    &PrntChty(4,"$Task{stem}: Info: GetEventStartDate: Obsevation start date: $$date $$time,\n"); 
    &PrntChty(4,"$Task{stem}: Info: GetEventStartDate: from event file: $evtfile\n"); 

    return 0;

} # GetEventStartDate


sub GetHdStartDate { 

    # This subroutine returns the observation Date and Time
    # with the format needed for CALDB query
    # The Observation Start date is taken from FRAME
    # extension in hd file

    my ( $hdfile, $date, $time ) = @_;
    
    &GetKeyword($hdfile,"FRAME",undef,"DATE-OBS",\$$date);
    if ( $Task{status} ) {return 1;}

    my $Tstr = substr($$date,10,1);

    if ( $Tstr eq "T" ) {
	$$time = substr($$date,11);
	$$date = substr($$date,0,10);
    }
    else {
	&GetKeyword($hdfile,"FRAME",undef,"TIME-OBS",\$$time);
	if ( $Task{status} ) {return 1;}
    }

    &PrntChty(4,"$Task{stem}: Info: GetHdStartDate: Obsevation start date: $$date $$time,\n"); 
    &PrntChty(4,"$Task{stem}: Info: GetHdStartDate: from hd file: $hdfile\n"); 

    return 0;

} # GetHdStartDate


sub RunCommandAndRedirectOutput {

    # This subroutine before performing a call to the 'system' using
    # input 'command' redirects standard output in the
    # ouput file

    my ( $command, $outfile ) = @_;

    # dup STDOUT

    if ( ! open ( OLDSTDOUT, ">&STDOUT" ) ) {
	&PrntChty(2, "$Task{stem}: Error: RunCommandAndRedirectOutput: Couldn't dup STDOUT: $!\n");
	$Task{status} = 1;
	return 1;
    }

    # re-direct STDOUT to outfile 

    if ( !open (STDOUT, ">> $outfile") ) {
	&PrntChty(2, "$Task{stem}: Error: RunCommandAndRedirectOutput: Can't open $outfile: $!\n"); 
	$Task{status} = 1;
	return 1;
    }

    my ( $ret ) = 0;
    $ret = system ( $command );

    close STDOUT;

    # restore original STDOUT 
    
    if ( ! open (STDOUT, ">&OLDSTDOUT") ) {
	&PrntChty(2,"$Task{stem}: Error:RunCommandAndRedirectOutput:  Can't restore STDOUT: $!\n"); 
	$Task{status} = 1;
	return 1;
    }

    close OLDSTDOUT;

    if ( $ret ) {
	&PrntChty(2,"$Task{stem}: Error: RunCommandAndRedirectOutput: 'system' exit with error: $ret\n"); 
	$Task{message} = "'system' command error: $ret\n"; 
	$Task{status} = 1;
	return 1;
    }

    return 0;

}

sub RenameFile {

    # Copy the $file1 into $file2 and delate
    # the $file1. The function returns an error if the
    # $file2 cannot be created but gives only a warning message if 
    # the $file1 cannot be removed


    my ( $file1, $file2 ) = @_;

    if (!copy($file1, $file2)) {
	$Task{status} = 1;
	$Task{errmess} = "Unable to copy file: '$file1' in '$file2'. $!";
	return 1;
    }

    else {
	if ( !unlink($file1) ) {
	    &PrntChty(2,"$Task{stem}: Warning: RenameFile: Unable to remove '$file1' file. $!\n");
	}
    }

    return 0;

} #RenameFile

sub ExecXimage
{
   my ($param) = @_;

   my $line = "";
   my $err = 0;
   my $cmd = "ximage \"$param\"";

   &RunningSub("ExecXimage","ximage");
   &RunningComm("ExecXimage",$cmd);
   my $p = open(FILEH, "$cmd |");
   if ($p)
   {
      while(<FILEH>)
      {
         &PrntChty(3,"$Task{stem}: ExecXimage: $_");
         if ($_ =~ /^ Failed to execute startup command/)
         {
            $err = 1;
            last;
         }
      }
      $_ = "";
      if (`uname` =~ /SunOS/)
      {
         my @pid = `ps -af|grep "ximage $param"\$|grep -v grep`;
         $p = $pid[1];
      }
      kill 15, $p;
      close(FILEH);
   }
   return $err;
}


sub GetPntFromExt {

    my ($filename,$extname,$extnum,$ra_pnt,$dec_pnt,$pa_pnt) = @_;

    if ( $pa_pnt ) {
	&PrntChty(4,"$Task{stem}: Info: GetPntFromExt: Reading RA_PNT, DEC_PNT and PA_PNT Keywords\n");
    }
    else {
	&PrntChty(4,"$Task{stem}: Info: GetPntFromExt: Reading RA_PNT and DEC_PNT Keywords\n"); 
    }
    &PrntChty(4,"$Task{stem}: Info: GetPntFromExt: from '$filename' file\n");

    &GetKeyword($filename,$extname,$extnum,"RA_PNT",$ra_pnt);
    if ( $Task{status} ) { return 1; }

    &GetKeyword($filename,$extname,$extnum,"DEC_PNT",$dec_pnt);
    if ( $Task{status} ) { return 1; }

    if ( $pa_pnt ) {
	&GetKeyword($filename,$extname,$extnum,"PA_PNT",$pa_pnt);
	if ( $Task{status} ) { return 1; }
    }

} # GetPntFromExt

sub GetObjFromExt {

    my ($filename,$extname,$extnum,$ra_obj,$dec_obj) = @_;

    &PrntChty(4,"$Task{stem}: Info: GetObjFromExt: Reading RA_OBJ, DEC_OBJ and PA_OBJ Keywords\n");
    &PrntChty(4,"$Task{stem}: Info: GetObjFromExt: from '$filename' file\n");

    &GetKeyword($filename,$extname,$extnum,"RA_OBJ",$ra_obj);
    if ( $Task{status} ) { return 1; }

    &GetKeyword($filename,$extname,$extnum,"DEC_OBJ",$dec_obj);
    if ( $Task{status} ) { return 1; }

} # GetObjFromExt

#Return a array with list of extension number where type of relative header is IMAGE_HDU
# and check if CTYPE1 =="RA--TAN" and CTYPE2= "DEC--TAN"
sub getArrayExtensionImage() {
    my ($filename) = @_;
    
    
    my($numext,$hdutype,@list,$value1,$value2,$comm);
    my($fptr,$status)=(0,0);
    fits_open_file($fptr,$filename,READONLY,$status);
    if ($status) {
	$Task{status} = 1;
	$Task{errmess} = "Unable to open fits file : $filename";
	return;
    }
    
    fits_get_num_hdus($fptr,$numext,$status);
    if ($status) {
	$Task{status} =1;
	$Task{errmess} = "Unable to get number of extensions from file : $filename";
	fits_close_file($fptr,$status);
	return;
    }

    for (my $i = 1; $i < $numext; $i++) {
	fits_movabs_hdu($fptr,$i+1,ANY_HDU,$status);
	if ($status) {
	    $Task{errmess} = "Running movabs_hdu (num extension: " . $i+1 . ") in $filename";
	    &PrntChty(2,"$Task{stem}: Error: getArrayExtensionImage: $Task{errmess}\n");
	    $Task{status} = 1;
	    fits_close_file($fptr,$status);
	    return ;
	}
	fits_get_hdu_type($fptr,$hdutype,$status);
	if ($status) {
	    $Task{status} =1;
	    $Task{errmess} = "Unable to get number of extensions from file : $filename";
	    fits_close_file($fptr,$status);
	    return;
	}


	if ($hdutype == IMAGE_HDU) {
	    fits_read_keyword($fptr,"CTYPE1",$value1,$comm,$status);
	    if ($status) {
		fits_close_file($fptr,$status);
		$Task{errmess} = "Running read_keyword CTYPE1 (num extension: $i) in $filename";
		&PrntChty(2,"$Task{stem}: Error: getArrayExtensionImage: $Task{errmess}\n");
		$Task{status} = 1;
		fits_close_file($fptr,$status);
		return ;
	    }
	    fits_read_keyword($fptr,"CTYPE2",$value2,$comm,$status);
	    if ($status) {
		fits_close_file($fptr,$status);
		$Task{errmess} = "Running read_keyword CTYPE2 (num extension: $i) in $filename";
		&PrntChty(2,"$Task{stem}: Error: getArrayExtensionImage: $Task{errmess}\n");
		$Task{status} = 1;
		fits_close_file($fptr,$status);
		return ;
	    }
	    $value1 = &trimValue($value1);
	    $value2 = &trimValue($value2);
	    if ($value1 ne "RA---TAN") {
		&PrntChty(2,"$Task{stem}: Warning: Keyword CTYPE1 is not equal to 'RA---TAN' ($value1) in $filename+$i\n");
	    } elsif ($value2 ne "DEC--TAN") {
		&PrntChty(2,"$Task{stem}: Warning: Keyword CTYPE2 is not equal to 'DEC---TAN' ($value2) in $filename+$i\n");
	    } else {
		push @list,$i;
	    }
	}
    }


    fits_close_file($fptr,$status);


    return @list;
   

} #getArrayExtensionImage


sub trimValue() {
    my $value=shift;
    $value =~ s/^\s+//; # remove leading spaces
    $value =~ s/\s+$//; # remove trailing spaces	
    $value =~ s/^'//g;; #Remove apex
    $value =~ s/'$//g;; #Remove apex
    $value =~ s/\s+$//g;; #Remove right space
    return $value;

}


# Delete a list of column name. Return 1 in case of error 

sub delFitsCol() {
    my ($filename,$extname,@listCol) = @_;

    my ($colname,$index);

    my $status = 0;

    foreach $colname (@listCol) {
	 my $fptr = &GetFitsPointer($filename,$extname,undef,READWRITE);
	 if ($Task{status}) { 
	     return 1;
	 }

        fits_get_colnum($fptr,0, $colname , $index, $status);
	if ($status) {
	    &PrntChty(5,"$Task{stem}: Warning: Column '$colname' not found in $filename file\n");
	} else {
	
	
	    &PrntChty(5,"$Task{stem}: Info: delFitsColumn: Delete column : '$colname' in $filename file\n");
	    fits_delete_col($fptr,$index,$status);
	    if ($status) {
		&PrntChty(2,"$Task{stem}: Error: delFitsCol: Unable to delete colname: '$colname'\n");
		$Task{errmess} = "Unable to delete column name $colname from $filename file";
		$Task{status} = 1;
		return 1;
	    }

	    fits_write_chksum($fptr,$status);
	    if ($status) {
		$Task{errmess} = "Error running write_chksum  $filename file , $extname extension";
		&PrntChty(2,"$Task{stem}: Error: delFitsCol - Running write_chksum on file $filename\n");
		$Task{status} = 1;
		return 0;
	    }
	}
	$status =0;
	
    
    
	 fits_close_file($fptr,$status);
	 if ($status) { 
	     $Task{errmess} = "delFitsCol: Unable to close file : $filename";
	     return 1;
	 }
     }
    return 0;
}

sub GetRootStem {

# It takes the root of a filename erasing the given 'tailstem'
#   i.e: infile = /home/user/rootfiletest.txt
#        tailstem = test.txt
#        return (rootfile)

    my ( $infile , $tailstem) = @_;
    use vars qw ( %Task );

    my ( $infilenopath ) = substr($infile,rindex( $infile, '/' )+1);

    # take the root stem

    if ( $infilenopath =~ /$tailstem$/ ) {$infilenopath =~ s/$tailstem//g;}
    else {	$Task{errmess} = "Cannot define standard stem of files";
		$Task{status} = 1;       
	        return;             }

    return ($infilenopath);

} # GetRootStem



sub AddKeywordExt {
    
    my ($filename,$extname,$datatype,$keyname,$value,$comment) = @_;

    use vars qw (%Task);

    my ($fptr,$status) = (0,0);

    fits_open_file($fptr,$filename,READWRITE,$status);
    if ($status) {
	$Task{status} = 1;
	&PrntChty(2,"$Task{stem}: Error: AddKeywordExt: Cannot open file: $filename\n");
	&PrntChty(2,"$Task{stem}: Error: AddKeywordExt: CFITSIO error: $status\n");
	$Task{errmess} = "Unable to open fits file : $filename";
	return 0;
    }
    fits_movnam_hdu($fptr,ANY_HDU,$extname,0,$status);
    if ($status) {
	$Task{status} = 1;
	&PrntChty(2,"$Task{stem}: Error: AddKeywordExt: Cannot move to extension name $extname in file $filename\n");
	&PrntChty(2,"$Task{stem}: Error: AddKeywordExt: CFITSIO error: $status\n");
	$Task{errmess} = "Error: AddKeywordExt: Cannot move to extension name $extname in file $filename";
	fits_close_file($fptr,$status);
	return 0;
    }

    fits_update_key($fptr,$datatype, $keyname,$value,$comment,$status);
    if ($status) {
	$Task{status} = 1;
	$Task{errmess} = "Error writing keyword $keyname to file $filename";
	fits_close_file($fptr,$status);
	return 0;
    }
    fits_write_chksum($fptr,$status);
   if ($status) {
	$Task{status} = 1;
	&PrntChty(2,"$Task{stem}: Error: AddKeywordExt: Cannot write checksum to extension name $extname in file $filename\n");
	&PrntChty(2,"$Task{stem}: Error: AddKeywordExt: CFITSIO error: $status\n");
	$Task{errmess} = "Error: Cannot write checksum dddd file $filename";
	fits_close_file($fptr,$status);
	return 0;
    }

    fits_close_file($fptr,$status);

    return 1;
}

sub AddKeywordExtNum {
    
    my ($filename,$extnum,$datatype,$keyname,$value,$comment) = @_;

    use vars qw (%Task);

    my ($fptr,$status,$exttype) = (0,0,0);

    fits_open_file($fptr,$filename,READWRITE,$status);
    if ($status) {
	$Task{status} = 1;
	&PrntChty(2,"$Task{stem}: Error: AddKeywordExtNum: Cannot open file: $filename\n");
	&PrntChty(2,"$Task{stem}: Error: AddKeywordExtNum: CFITSIO error: $status\n");
	$Task{errmess} = "Unable to open fits file : $filename";
	return 0;
    }
    fits_movabs_hdu($fptr,$extnum,$exttype,$status);
    if ($status) {
	$Task{status} = 1;
	&PrntChty(2,"$Task{stem}: Error: AddKeywordExtNum: Cannot move to extension number $extnum in file $filename\n");
	&PrntChty(2,"$Task{stem}: Error: AddKeywordExtNum: CFITSIO error: $status\n");
	$Task{errmess} = "Error: AddKeywordExtNum: Cannot move to extension number $extnum in file $filename";
	fits_close_file($fptr,$status);
	return 0;
    }

    fits_update_key($fptr,$datatype, $keyname,$value,$comment,$status);
    if ($status) {
	$Task{status} = 1;
	$Task{errmess} = "Error writing keyword $keyname to file $filename";
	fits_close_file($fptr,$status);
	return 0;
    }
    fits_write_chksum($fptr,$status);
   if ($status) {
	$Task{status} = 1;
	&PrntChty(2,"$Task{stem}: Error: AddKeywordExtNum: Cannot write checksum to extension number $extnum in file $filename\n");
	&PrntChty(2,"$Task{stem}: Error: AddKeywordExtNum: CFITSIO error: $status\n");
	$Task{errmess} = "Error: Cannot write checksum in file $filename";
	fits_close_file($fptr,$status);
	return 0;
    }

    fits_close_file($fptr,$status);

    return 1;
}


sub CallScQuzcif {


    my ( $Dataset, $Date, $Time, $Selection , $expnumfile ) = @_;  
    my ( $field,@dummy, @outlist , @extlist);
    use vars qw ( %Task );

    # The function performs a query to the CALDB database based
    # on $Dataset, $Date, $Time, $Selection parameters (see below
    # for the input parameter description.
    # The function return two array 'outlist' and 'extlist' with the result of the query.
    # The array is filled with filenames and extensions from the quzcif query
    # For example: if the 'quzcif' query gives only one match the array will
    #              content : $outlist[0] = filename
    #                        $extlist[0] = extension
    #              if the 'quzcif' query gives two matches the array will
    #              content : $outlist[0] = filename1
    #                        $extlist[0] = extension1
    #                        $outlist[1] = filename2
    #                        $extlist[1] = extension2
    #              etc ....
    # $Dataset - 'Calibration Dataset Codename'
    # $Date    - 'Requested Date in yyyy-mm-dd format' or "NOW" for the must up to date dataset
    # $Time    - 'Requested Time in hh:mm:ss format' or "-" if $date = "NOW"
    # $Selection - "Boolean selection expression for Boundary params" or "-" if not required

    # Check CALDB environment

    if ( !$ENV{CALDB} ) {
	&PrntChty(2,"$Task{stem}: Error: CallScQuzcif: CALDB environment not set\n");
	&PrntChty(2,"$Task{stem}: Error: CallScQuzcif: Please set the CALDB environment or specify the input parameter for '$Dataset'\n");
	$Task{status} = 1;
	return (\@outlist,\@extlist);
    }

    my ( $command ) = "quzcif SWIFT SC - - $Dataset $Date $Time \"$Selection\" retrieve+ clobber=yes"; 
    &PrntChty(5,"$Task{stem}: Info: CallScQuzcif: Running $command\n"); 
    my ( @ret ) = qx($command);
    &PrntChty(5,"CallScQuzcif: Info: Output 'quzcif' Command: \nCallScQuzcif: Info:@ret");

    if ( $#ret == -1 ) {
	&PrntChty(2,"$Task{stem}: Error: CallScQuzcif: No Calibration File Found for '$Dataset' dataset\n");
	&PrntChty(2,"$Task{stem}: Error: CallScQuzcif: 'quzcif' command: \"$command\"\n");
	$Task{status} = 1;
	return (\@outlist,\@extlist);
    }

    if ( $#ret != $expnumfile-1) {
	my $n = $#ret +1;
	&PrntChty(2,"$Task{stem}: Error: CallScQuzcif: Found " . $n . " calibration file(s) instead of $expnumfile file(s)\n");
	$Task{status} = 1;
	return (\@outlist,\@extlist);
    }				 

    foreach $field ( @ret ) {

	my ( $file, $ext );

	if ( $field =~ "ERROR" ) {
	     &PrntChty(2,"$Task{stem}: Error: CallScQuzcif: 'quzcif': @ret\n");
	     $Task{status} = 1;
	     return (\@outlist,\@extlist);
	}

	($file, $ext ) = split /\s+/,$field;
	push @outlist, $file;
	push @extlist, $ext;

    }

    return (\@outlist,\@extlist);

} # CallScQuzcif


sub CheckRow {

    use vars qw( %Task );

    my ( $file, $ext, $gtifile, $gtiexpr, $gtiextname ) = @_ ;


    my ( @splitexpr, $ee ) ;
    my ( @columns );

    @splitexpr = split ( /&&/,$gtiexpr );

    my ( @lt_col, @le_col, @e_col, @gt_col, @ge_col ); 
    my ( @lt_val, @le_val, @e_val, @gt_val, @ge_val ); 

    foreach $ee ( @splitexpr ) {
	if ( $ee =~ /(\w+)>=(.*)/ ) { 
	    push @ge_col, $1;
	    push @ge_val, $2;
	} 
	elsif ( $ee =~ /(\w+)>(.*)/ ) {
	    push @gt_col, $1;
	    push @gt_val, $2;
	}
	elsif ( $ee =~ /(\w+)==(.*)/ ) {
	    push @e_col, $1;
	    push @e_val, $2;
	}
	elsif ( $ee =~ /(\w+)<=(.*)/ ) {
	    push @le_col, $1;
	    push @le_val, $2;
	}
	elsif ( $ee =~ /(\w+)<(.*)/ ) {
	    push @lt_col, $1;
	    push @lt_val, $2;
	}
	else {
	    &PrntChty(2,"$Task{stem}: Error: Screening Expression '$ee' not allowed\n");
	    $Task{errmess} = "Cannot Pars screening expression";
	    $Task{status} = 1;
	    return 1;
	}
	push @columns, { name => $1 };
    }

    push @columns, { name => "TIME" };
    push @columns, { name => "ENDTIME" };

    my (@table) = &LoadBinTable($file,"",$ext,@columns);
    if ( $Task{status} ) { return -1;}

    my ( $col, $ind );
    my ( $ok ) = 1;

    $ind = -1;
    foreach $col ( @lt_col ) {
	$ind ++;
	if ( !($table[0]->{$col} <= $lt_val[$ind]) ) { 
	    $ok = 0; 
	    &PrntChty(4,"$Task{stem}: Warning: found '$col' set to '$table[0]->{$col}' that is > '$lt_val[$ind]'\n"); 
	    goto end_check; } 
    }
    $ind = -1;
    foreach $col ( @le_col ) {
	$ind ++;
	if ( !($table[0]->{$col} < $le_val[$ind]) ) { 
	    $ok = 0; 
	    &PrntChty(4,"$Task{stem}: Warning: found '$col' set to '$table[0]->{$col}' that is >= '$le_val[$ind]'\n"); 
	    goto end_check; }; 
    }
    $ind = -1;
    foreach $col ( @e_col ) {
	$ind ++;
	if ( !($table[0]->{$col} == $e_val[$ind]) ) { 
	    $ok = 0; 
	    &PrntChty(4,"$Task{stem}: Warning: found '$col' set to '$table[0]->{$col}' that is != '$e_val[$ind]'\n"); 
	    goto end_check; }; 
    }
    $ind = -1;
    foreach $col ( @gt_col ) {
	$ind ++;
	if ( !($table[0]->{$col} > $gt_val[$ind]) ) { 
	    $ok = 0; 
	    &PrntChty(4,"$Task{stem}: Warning: found '$col' set to '$table[0]->{$col}' that is <= '$gt_val[$ind]'\n"); 
	    goto end_check; }; 
    }
    $ind = -1;
    foreach $col ( @ge_col ) {
	$ind ++;
	if ( !($table[0]->{$col} >= $ge_val[$ind]) ) { 
	    $ok = 0; 
	    &PrntChty(4,"$Task{stem}: Warning: found '$col' set to '$table[0]->{$col}' that is < '$ge_val[$ind]'\n"); 
	    goto end_check; }; 
    }

end_check:

    # Cheate the GTI file, if the row does not match the
    # expression the GTI file will be empty

    my ($fptr,$status) = (0,0);

    &PrntChty(3,"$Task{stem}: Info: Creating '$gtifile' file\n");

    fits_create_file($fptr,$gtifile,$status);
 
    if ($status) {
	$Task{status} = 1;
	$Task{errmess} = "$Task{stem}: Error: cannot create $gtifile";
	return 1;
    }
	    
    fits_write_imghdr($fptr,16,0,0,$status);
    if ($status) {
	$Task{status} = 1;
	$Task{errmess} = "Cannot create $gtifile Primary Header";
	return 1;
    }

    my $tform = [ qw(1D 1D) ];
    my $ttype = [ qw(START STOP) ];
    my $tunit = [ ( 'sec', 'sec' ) ];
    
    my $nrows = 0;
    my $tfields = 2;
    my $pcount = 0;
    my $binname = $gtiextname;
    
    fits_insert_btbl($fptr,$nrows,$tfields,$ttype,$tform,$tunit,$binname,0,$status);
    if ($status) {
	$Task{status} = 1;
	$Task{errmess} = "Cannot create $gtifile '$gtiextname' extension";
	return 1;
    }

    if ( $ok ) {
	&PrntChty(3,"$Task{stem}: Info: Output GTI file with START: $table[0]->{TIME} and STOP: $table[0]->{ENDTIME}\n");
	fits_write_col($fptr,TDOUBLE,1,1,1,1, $table[0]->{TIME},$status);
	if ($status) {
	    $Task{status} = 1;
	    $Task{errmess} = "Cannot write $gtifile 'START' value";
	    return 1;
	}
	fits_write_col($fptr,TDOUBLE,2,1,1,1, $table[0]->{ENDTIME},$status);
	if ($status) {
	    $Task{status} = 1;
	    $Task{errmess} = "Cannot create $gtifile 'STOP' value";
	    return 1;
	}
    }
    else {
	&PrntChty(3,"$Task{stem}: Warning: The '$file' row does not match Timing conditions\n");
	&PrntChty(3,"$Task{stem}: Warning: Created Empty GTI '$gtifile'\n");
    }

    fits_close_file($fptr,$status);
    if ($status) {
	&PrntChty(2,"$Task{stem}: Error: 'fits_close_file' error on '$gtifile'\n");
	$Task{status} = 1;
	$Task{errmess} = "cannot close '$gtifile' file";
	return 1;
    }

    return 0;

} # CheckRow

sub CleanTimeNulls {

#
# The subroutine returns: 
#
#     - 1 if some NULLs have been found in the TIME column and 
#         the selection have been applied 
#              _or_ 
#         if there is an error
#
#     - 0 if no NULLs have been found so no selection needed
#
    my ( $infile, $outfile, $extension ) = @_;

    my ( $ret, $par, $command, %ftselect );
    my $expr = "\"\!isnull(TIME)&&TIME!=-1\"";
    my $null = 0;
    my $outdir = substr($outfile,0,rindex($outfile,"/"));

#
# Check if the input file has NULLS in the TIME column
#
    $null = &RunFtstat($infile,$extension,"TIME","null",$outdir);
    if ( $Task{status} ) { return 1; }

#
# If There are some NULLs in the TIME column runfselect
#

    if ( $null ) {

	&PrntChty(3,"$Task{stem}: Warning: CleanTimeNulls: Found some records in the\n");
	&PrntChty(3,"$Task{stem}: Warning: CleanTimeNulls: '$infile' file with\n");
	&PrntChty(3,"$Task{stem}: Warning: CleanTimeNulls: TIME value set to NULL\n");
	&RunningSub("CleanTimeNulls","ftselect", " to select from '$infile' rows with expression '$expr'");

#
# Build the command line to run 'ftselect'
#
	
	%ftselect = (
		     infile       => $infile,
		     outfile      => $outfile,
		     expression   => $expr,
		     copyall      => "yes",              
		     clobber      => "no",
		     chatter      => $Task{chatter},
		     history      => $Task{history},
		     );
	
	$command = "ftselect";
	for $par ( keys %ftselect ) { $command .= " $par=$ftselect{$par}"; } 
	
	&RunningComm("CleanTimeNulls",$command);
	
	$ret = 0;
	$ret = system( $command );
	
	if ( $ret != 0 ) {
	    &ErrorComm("CleanTimeNulls","ftselect",$command);
	    $Task{errmess} = "Error: running 'ftselect'";
	    $Task{status} = 1;
	    return 1;
	}
	
	# update checksum
	
	if ( system("ftchecksum $outfile update=yes chatter=0") ) {
	    &PrntChty(1,"$Task{stem}: Error: Error updating checksum\n"); 
	    $Task{errmess} = "Error: updating checksum";
	    $Task{status} = 1;
	    return 1;
	}
	
	&SuccessSub("CleanTimeNulls","ftselect","'$infile' filtered");
	return 1;
    }
    else {
	&PrntChty(4,"$Task{stem}: Info: CleanTimeNulls: Clean of the '$infile' not needed\n");
	return 0;
    }

} # CleanTimeNulls


sub RunFtstat {

    my ( $file, $ext, $col, $stat1, $outdir ) = @_;

    my ( $ret, $par, $command, %ftstat );

    my ($tmpoutfile) = $outdir.$$."ftstat.out";
    unlink ( $tmpoutfile );

#
# Build the command line to run 'ftselect'
#
	
	%ftstat = (
		     infile       => "\'$file\[$ext\]\[col $col\]'",
		     outfile      => "$tmpoutfile",
		     centroid     => "yes",
		     clip         => "no",              
		     nsigma       => 3,   
		     maxiter      => 20,
		     );
	
	$command = "ftstat";

	for $par ( keys %ftstat ) { $command .= " $par=$ftstat{$par}"; } 
	
	&RunningComm("RunFtstat",$command);
	
	$ret = 0;
	$ret = system( $command );
	
	if ( $ret != 0 ) {
	    &ErrorComm("RunFtstat","ftstat",$command);
	    $Task{errmess} = "Error: running 'ftstat'";
	    $Task{status} = 1;
	    return 1;
	}
	
    # Get the value of the ftstat parameter '$stat1'

    $command = "pget ftstat $stat1";
    
    &RunningComm("RunFtstat",$command);
    
    $ret = 0;
    $ret = `$command`;
    chop $ret;

    &PrntChty(4,"$Task{stem}: Info: RunFtstat: Read '$stat1' value = '$ret' for column '$col'\n");
    &PrntChty(4,"$Task{stem}: Info: RunFtstat: in the '$file' file\n");

    unlink ( $tmpoutfile );

    return $ret;

} # RunFtstat

sub SetFileName {

    my ( $outfileparam, $stemout, $stemin, $defaultext, $dir ) = @_;

    use vars qw ( %Task %Default );
    my ( $Filename );

    # Define attorbfilename

    if ( &CompUL( $outfileparam, $Default{DEFAULT} ) && &CompUL( $stemout, $Default{DEFAULT} )) {
	$Filename = "$dir/$stemin$defaultext";
    }
    elsif ( &CompUL( $outfileparam, $Default{DEFAULT} ) && !&CompUL( $stemout, $Default{DEFAULT} )) {
	# Use Input Stem
	$Filename = "$dir/$stemout$defaultext";
    }
    else { $Filename = "$outfileparam"; }

    &PrntChty(4,"$Task{stem}: Info: SetFileName: The file name will be $Filename\n");

    return $Filename;

} # SetFileName

sub AddStemBeforeExtension {

    my ($file, $stem ) = @_;
    my $ext = "";
    my ($filenozip, $filenoext);

    if ( $file =~ /(.gz|.Z)$/ ) {
	$filenozip = substr($file,0,rindex($file,'.'));
    } else { $filenozip = $file; }

    if ( rindex($filenozip,'.') > 0 ) {
	$filenoext = substr($file,0,rindex($filenozip,'.'));
	$ext       = substr($file,rindex($filenozip,'.'));
    } else { $filenoext = $filenozip; }

    return "$filenoext$stem$ext";

}


sub GetAttitudeATTFLAG { 
  
    # This subroutine returns the ATTFLAG keyword value
    # in the attitude file
    # The ATTFLAG keyword is taken from ATTITUDE
    # extension in attitude file
    # If ATTFLAG key not exist (old attitude file)
    # return the default value '100' for old files
  
    my ( $attfile, $attflag ) = @_;
    
    my ($fptrin, $status) = (0,0);
    
    fits_open_file($fptrin,$attfile,READONLY,$status);
    if ($status) {
	$Task{status} = 1;
	$Task{errmess} = "Unable to open fits file : $attfile";
	return 1;
    }
    
    my ($attflag_value, $attflag_comm);
    
    fits_movnam_hdu($fptrin,ANY_HDU,"ATTITUDE",0,$status);
    if ( $status ) {
	$Task{errmess} ="Unable to move to extname 'ATTITUDE' in attitude file $attfile";
	$Task{status} = 1;
	return 1;
    }
    
    fits_read_key_str($fptrin,"ATTFLAG",$attflag_value,$attflag_comm,$status); 
    if ($status == KEY_NO_EXIST ) {
	$attflag_value = "100";
	&PrntChty(2,"$Task{stem}: Warning: GetAttitudeATTFLAG: 'ATTFLAG' keyword not found in $attfile\n");
	&PrntChty(2,"$Task{stem}: Warning: GetAttitudeATTFLAG: using default value '100'\n");
	$status = 0;
    } elsif ($status) {
	$Task{errmess} = "Error reading ATTFLAG keyword in file $attfile";
	$Task{status} = 1;
	return 1;
    }
    
    $$attflag = $attflag_value;
    
    fits_close_file($fptrin,$status);
    
    return 0;
    
}

sub GetImagesHduList{

    my ($infile) = @_;
    my $ffp;
    my $count = 0;
    my $status=0;
    my @hdu_list ;
    my $hdun = 1;
    my $type;
 
    
    fits_open_file($ffp,$infile,READONLY,$status);
    
    if ($status) {
	$Task{status} = 1;
	$Task{errmess} = "Unable to open fits file : $infile" ;
	return; 
    }
   
    while (!fits_movabs_hdu($ffp, $hdun, $type, $status))
    {
	if ($type eq IMAGE_HDU)
	{
	    $hdu_list[$count] = $hdun;
	    $count ++;
	}     
	$hdun ++;
    }

    $Task{status} = 0;
    $Task{errmess} = " ";
    return @hdu_list;

} #GetImagesHduList


sub FindCaldbIndxFile {

# This function find the calibration index file path

    my ( $mission, $instrument, $caldbindxfile ) = @_;

    my $line;

    if (!open(FILECONFIG,"<$ENV{CALDBCONFIG}")) {
	$Task{errmess} = "cannot open CALDB config file $ENV{CALDBCONFIG}.";
	$Task{status} = 1;
	#&PrntChty(2,"$Task{stem}: Error: FindCaldbIndxFile: $Task{errmess}\n");
	return 1;
    }

    while ( $line = <FILECONFIG>) {
	
	chop($line);

	if (!($line=~ /^\#/))
	      {
		  my ($lmission,$linstrument,$ldevice,$ldirectory,$lfileindx,$lp6,$lp7)= split(/\s+/, $line);
		  
		  if(($mission eq $lmission)&&($instrument eq $linstrument))
		  {
		      if ($ldevice eq "CALDB")
		      {
			  $ldevice=$ENV{CALDB};
		      }

		      $$caldbindxfile = $ldevice ."/". $ldirectory ."/". $lfileindx;
		      return 0;
		  }
	      }
    }

    $Task{errmess} = "caldb.indx file not found for mission='$mission' and instrument='$instrument'";
    $Task{status} = 1;
    #&PrntChty(2,"$Task{stem}: Error: FindCaldbIndxFile: $Task{errmess}\n");
    return 1;

} #FindCaldbIndxFile


sub GetCaldbVersion {

    my ( $caldbversion ) = @_;
    my ( $caldbindxfile );
    my ( $fptr, $status, $numext ) = ( 0, 0, 0 );
    my ( $value, $comm, $i );

    use vars qw(%Task);


    # Check the environment variables 'CALDB' e 'CALDBCONFIG'
    
    if ( !$ENV{CALDB} ) {
	$Task{errmess} = "CALDB environment variable not found";
	$Task{status} = 1;
	#&PrntChty(2,"$Task{stem}: Error: GetCaldbVersion: $Task{errmess}\n");
	return 1;
    }
    
    if ( !(-d $ENV{CALDB}) ) {
	$Task{errmess} = "$ENV{CALDB} NOT a valid directory.";
	$Task{status} = 1;
	#&PrntChty(2,"$Task{stem}: Error: GetCaldbVersion: $Task{errmess}\n");
	return 1;
    }
    
    if ( !$ENV{CALDBCONFIG} ) {
	$Task{errmess} = "CALDBCONFIG environment variable not found";
	$Task{status} = 1;
	#&PrntChty(2,"$Task{stem}: Error: GetCaldbVersion: $Task{errmess}\n");
	return 1;
    }
    
    if ( !(-f $ENV{CALDBCONFIG}) ) {
	$Task{errmess} = "$ENV{CALDBCONFIG} NOT a valid file.";
	$Task{status} = 1;
	#&PrntChty(2,"$Task{stem}: Error: GetCaldbVersion: $Task{errmess}\n");
	return 1;
    }


    # Find the calibration index file path

    &FindCaldbIndxFile("SWIFT","XRT",\$caldbindxfile);
    if ( $Task{status} ) {
	#&PrntChty(2,"$Task{stem}: Error: GetCaldbVersion: unable to find the calibration index file.\n");
	return 1;
    }


    # Read the CALDB version from the calibration index file

    if(!(-f $caldbindxfile)){
	$Task{errmess} = "'$caldbindxfile' calibration index file NOT found.";
	$Task{status} = 1;
	#&PrntChty(2,"$Task{stem}: Error: GetCaldbVersion: $Task{errmess}\n");
	return 1;	
    }
    
    fits_open_file($fptr,$caldbindxfile,READONLY,$status);
    if ($status) {
	$Task{errmess} = "Unable to open fits file '$caldbindxfile'";
	$Task{status} = 1;
	#&PrntChty(2,"$Task{stem}: Error: GetCaldbVersion: $Task{errmess}\n");
	return 1;
    }
    
    fits_get_num_hdus($fptr,$numext,$status);
    if ($status) {
	$Task{errmess} = "Unable to get num hdu in file '$caldbindxfile'";
	$Task{status} = 1;
	#&PrntChty(2,"$Task{stem}: Error: GetCaldbVersion: $Task{errmess}\n");
	return 1;
    }

    for ( $i = 1; $i <= $numext; $i++) {

	$status=0;
	fits_movabs_hdu($fptr,$i,ANY_HDU,$status);
	if ($status) {
	    $Task{errmess} = "Unable to open HDU number $i-1 in file '$caldbindxfile'";
	    $Task{status} = 1;
	    #&PrntChty(2,"$Task{stem}: Error: GetCaldbVersion: $Task{errmess}\n");
	    return 1;
	}

	fits_read_keyword($fptr,"CALDBVER",$value,$comm,$status);
	if (!$status) {
	    fits_close_file($fptr,$status);
	    $$caldbversion = &trimValue($value);
	    return 0;
	}
    }


    fits_close_file($fptr,$status);


    $Task{errmess} = "Unable to find 'CALDBVER' in HDU of file '$caldbindxfile'";
    $Task{status} = 1;
    #&PrntChty(2,"$Task{stem}: Error: GetCaldbVersion: $Task{errmess}\n");
    return 1;

} # GetCaldbVersion


1;
