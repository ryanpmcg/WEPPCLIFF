@ECHO.
@ECHO.
@ECHO Searching for valid Rscript applications in 'C:\Program Files\R'
DIR "C:\Program Files\R" /s /b | FIND "bin\Rscript.exe"
@ECHO.
@ECHO.
@ECHO Please copy one of the paths above to save in your system path.
@ECHO If no matching file was found, you will need to install R first.
@ECHO.
@ECHO off
SET /p PathToRscript=Enter the path to Rscript here:
@ECHO on
@ECHO.
@ECHO.
@ECHO You selected %PathToRscript%
@ECHO.
@ECHO.
DIR ".." /s /b | FIND "WEPPCLIFF.R" > TMP.txt
SET /p PathToWEPPCLIFF=<TMP.txt
DEL TMP.txt
CD ..

"%PathToRscript%" --vanilla "%PathToWEPPCLIFF%" --args -f ASOS_BPT_KMQE.csv -la y
"%PathToRscript%" --vanilla "%PathToWEPPCLIFF%" --args -f ASOS_BPT_KMQE.csv -fn bpt -la y -verb t
"%PathToRscript%" --vanilla "%PathToWEPPCLIFF%" --args -f ASOS_BPT_KMQE.csv -la y -verb t -o JUNK -pd t -sdt "2000-01-01 00:00:00" -edt "2004-12-31 24:00:00"
"%PathToRscript%" --vanilla "%PathToWEPPCLIFF%" --args -f AH537_BPT_CP.csv -cp t -u m PRECIP -sm 2 -la y -ipb t
"%PathToRscript%" --vanilla "%PathToWEPPCLIFF%" --args -f AH537_BPT_CP.csv -cp t -u m PRECIP -sm 2 -la y -verb t -ei t -ee AH537 -ipb t -pd t -ed 3
"%PathToRscript%" --vanilla "%PathToWEPPCLIFF%" --args -f AH537_BPT_IP.csv -cp f -u m PRECIP -sm 2 -la y -verb t -ei t -ee AH537 -ipb t -pd t -ed 3
"%PathToRscript%" --vanilla "%PathToWEPPCLIFF%" --args -f AH537_1MIN_UP.csv -pi 1 -cp f -u m PRECIP -sm 2 -la y -verb t -ei t -ee AH537 -ipb t -pd t -ed 3
"%PathToRscript%" --vanilla "%PathToWEPPCLIFF%" --args -f AH537_1MIN.csv -pi 1 -cp f -u m PRECIP -sm 2 -la y -verb t -ei t -ee AH537 -ipb t -pd t -ed 3
"%PathToRscript%" --vanilla "%PathToWEPPCLIFF%" --args -f AH537_5MIN.csv -pi 5 -cp f -u m PRECIP -sm 2 -la y -verb t -ei t -ee AH537 -ipb t -pd t -ed 3
"%PathToRscript%" --vanilla "%PathToWEPPCLIFF%" --args -f AH537_10MIN.csv -pi 10 -cp f -u m PRECIP -sm 2 -la y -verb t -ei t -ee AH537 -ipb t -pd t -ed 3
"%PathToRscript%" --vanilla "%PathToWEPPCLIFF%" --args -f AH537_15MIN.csv -pi 15 -cp f -u m PRECIP -sm 2 -la y -verb t -ei t -ee AH537 -ipb t -pd t -ed 3
"%PathToRscript%" --vanilla "%PathToWEPPCLIFF%" --args -f AH537_15MIN_UP.csv -pi 15 -cp f -u m PRECIP -sm 2 -la y -verb t -ei t -ee AH537 -ipb t -pd t -ed 3
"%PathToRscript%" --vanilla "%PathToWEPPCLIFF%" --args -f AH537_15MIN_HT.csv -pi 15 -cp f -u m PRECIP -sm 2 -la y -verb t -ei t -ee AH537 -ipb t -pd t -ed 3
"%PathToRscript%" --vanilla "%PathToWEPPCLIFF%" --args -f ASOS_BPT_KMQE.csv -la y -verb t -qc t -pd t
"%PathToRscript%" --vanilla "%PathToWEPPCLIFF%" --args -f ASOS_BPT_KMQE.csv -la y -verb t -qc t -pd t -id t -qi t -ed 1
"%PathToRscript%" --vanilla "%PathToWEPPCLIFF%" --args -f ASOS_BPT_KMQE.csv -la y -verb t -qc t -pd t -id t -iv t -ed 1
