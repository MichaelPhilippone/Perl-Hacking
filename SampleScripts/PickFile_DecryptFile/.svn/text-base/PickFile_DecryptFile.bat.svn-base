@ECHO off

:: make a shortcut drive mapping to the script directory
IF EXIST Z: SUBST /d Z:
SUBST Z: "\\austin\healthr2\mphilippone\Code\scripts\perl\PickFile_DecryptFile"

:: now move to the claims import working directory
k:
cd "k:\Claims\Download_Claims\P2E"

perl Z:\PickFile_DecryptFile.pl >> Z:\log.log

:: get rid of the shortcut drive mapping
IF EXIST Z: SUBST /d Z: