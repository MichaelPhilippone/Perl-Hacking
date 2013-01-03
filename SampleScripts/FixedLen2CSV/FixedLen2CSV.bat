@ECHO off

SET PERLEXE="c:\strawberry\perl\bin\perl.exe"
SET SCRIPT="\\austin\healthr2\mphilippone\Code\scripts\perl\FixedLen2CSV\FixedLen2CSV.pl"
SET FILESPEC="\\austin\healthr2\mphilippone\Code\scripts\perl\FixedLen2CSV\FileSpec.txt"

SET ORIGPATH_TEST="\\austin\healthr2\mphilippone\Code\scripts\perl\DownloadDHCFDailyFiles\AllianceDatasets"
SET ORIGPATH_A="\\Sunshine\Electronic Transmissions\Alliance-Daily\dataset"
SET ORIGPATH_M="\\Sunshine\Electronic Transmissions\Medicaid-Daily\dataset"


:: ... ... ... ... ... DO NOT EDIT ANYTHING BELOW THIS LINE ... ... ... ... ... 

:: ----------------------------------------------------------------------------
IF NOT EXIST %PERLEXE% GOTO :noPerl
IF NOT EXIST %SCRIPT% GOTO :noScript
IF NOT EXIST %FILESPEC% GOTO :noSpec
:: ------------------------------------------------------------------------
:: %PERLEXE% %SCRIPTNAME% %ORIGPATH_TEST% %FILESPEC%
%PERLEXE% %SCRIPT% %ORIGPATH_M% %FILESPEC%
%PERLEXE% %SCRIPT% %ORIGPATH_A% %FILESPEC%
:: ------------------------------------------------------------------------
GOTO :quit
:noPerl
	ECHO perl executable not found at: %PERLEXE%
	ECHO Please ensure your system has a working version of perl installed
	GOTO :quit
:noScript
	ECHO script file not found at: %SCRIPT%
	ECHO Please ensure the script parameter is pointing to the right location
	GOTO :quit
:noSpec
	ECHO file spec not found at: %FILESPEC%
	ECHO Please ensure the file spec parameter is pointing to the right location
	GOTO :quit
:quit
	ECHO Exiting