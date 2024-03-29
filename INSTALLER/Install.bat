@ECHO.
@ECHO.
@ECHO Searching for valid Rscript applications in 'C:\Program Files\R'
DIR "C:\Program Files\R" /s /b | FIND "bin\Rscript.exe"
@ECHO.
@ECHO.
@ECHO Please copy one of the paths above to save in your system path.
@ECHO If no matching file was found, you will need to install R first.
@ECHO This script assumes the default location and does not look elsewhere.
@ECHO If you installed elsewhere, you are responsible for knowing where.
@ECHO.
@ECHO off
SET /p PathToRscript=Enter the path to Rscript here (do not use quotes even if there is a space in the name; this script will take care of that for you):
@ECHO on
@ECHO.
@ECHO.
@ECHO You selected %PathToRscript%
SETX PATH "%PATH%;%PathToRscript%"
@ECHO.
@ECHO.
DIR ".." /s /b | FIND "WEPPCLIFF.R" > TMP.txt
SET /p PathToWEPPCLIFF=<TMP.txt
DEL TMP.txt
CD ..
"%PathToRscript%" --vanilla "%PathToWEPPCLIFF%" --args -fr t
TIMEOUT /t 10 /nobreak
