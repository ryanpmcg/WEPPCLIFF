@ECHO OFF
DIR "C:\Program Files\R" /s /b | FIND "bin\Rscript.exe" > TMP.txt
SET /p PathToRscript=<TMP.txt
DEL TMP.txt
cd ..

CLS
ECHO Verifying WEPPCLIFF installation. This test will only take a couple minutes and & ECHO will begin in a few seconds. Please check back momentarily for the results. & ECHO.
TIMEOUT 2

"%PathToRscript%" --vanilla WEPPCLIFF.R --args -o AUTOTEST/OUTPUT -e AUTOTEST/OUTPUT -fn AutoTest.1 -f ASOS_BPT_KMQE.csv -la y -verb t -ed 1
"%PathToRscript%" --vanilla WEPPCLIFF.R --args -o AUTOTEST/OUTPUT -e AUTOTEST/OUTPUT -fn AutoTest.2 -f AH537_BPT_CP.csv -cp t -u m PRECIP -sm 2 -la y -verb t -ei t -ee ARS -ipb t -pd t -ed 1
"%PathToRscript%" --vanilla WEPPCLIFF.R --args -o AUTOTEST/OUTPUT -e AUTOTEST/OUTPUT -fn AutoTest.3 -f AH537_BPT_IP.csv -cp f -u m PRECIP -sm 2 -la y -verb t -ei t -ee ARS -ipb t -pd t -ed 1
"%PathToRscript%" --vanilla WEPPCLIFF.R --args -o AUTOTEST/OUTPUT -e AUTOTEST/OUTPUT -fn AutoTest.4 -f AH537_1MIN_UP.csv -pi 1 -cp f -u m PRECIP -sm 2 -la y -verb t -ei t -ee ARS -ipb t -pd t -ed 1
"%PathToRscript%" --vanilla WEPPCLIFF.R --args -o AUTOTEST/OUTPUT -e AUTOTEST/OUTPUT -fn AutoTest.5 -f AH537_1MIN.csv -pi 1 -cp f -u m PRECIP -sm 2 -la y -verb t -ei t -ee ARS -ipb t -pd t -ed 1
"%PathToRscript%" --vanilla WEPPCLIFF.R --args -o AUTOTEST/OUTPUT -e AUTOTEST/OUTPUT -fn AutoTest.6 -f AH537_5MIN.csv -pi 5 -cp f -u m PRECIP -sm 2 -la y -verb t -ei t -ee ARS -ipb t -pd t -ed 1
"%PathToRscript%" --vanilla WEPPCLIFF.R --args -o AUTOTEST/OUTPUT -e AUTOTEST/OUTPUT -fn AutoTest.7 -f AH537_10MIN.csv -pi 10 -cp f -u m PRECIP -sm 2 -la y -verb t -ei t -ee ARS -ipb t -pd t -ed 1
"%PathToRscript%" --vanilla WEPPCLIFF.R --args -o AUTOTEST/OUTPUT -e AUTOTEST/OUTPUT -fn AutoTest.8 -f AH537_15MIN.csv -pi 15 -cp f -u m PRECIP -sm 2 -la y -verb t -ei t -ee ARS -ipb t -pd t -ed 1

REM CLS
REM ECHO Running checksum tests. Almost done... & ECHO.
REM SET FAIL=0
REM FOR /L %%ITER IN (1,1,8)
REM	DO ()
REM if %FAIL%==0 (ECHO. & ECHO CONGRATULATIONS! Your WEPPCLIFF installation was successfully verified by 8 & ECHO automated test runs and 16 highly unique file outputs. Now you are ready to use & ECHO WEPPCLIFF with peace of mind, knowing everything is working as intended. & ECHO ) else (ECHO OOPS! Something is not right. Your WEPPCLIFF installation failed at least one & ECHO of 8 automated test runs. Please remove and reinstall WEPPCLIFF then try this & ECHO test again. If the problem persists and you believe the problem lies within & ECHO WEPPCLIFF, please create an issue at: https://github.com/ryanpmcg/WEPPCLIFF & ECHO  & ECHO Thank you! Hopefully the WEPPCLIFF community can help you get up and running & ECHO soon. & ECHO.)