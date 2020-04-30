@ECHO OFF
DIR "C:\Program Files\R" /s /b | FIND "bin\Rscript.exe" > TMP.txt
SET /p PathToRscript=<TMP.txt
DIR "C:\" /b | FIND "C:\WEPPCLIFF" > TMP.txt
SET /p PathToWEPPCLIFF=<TMP.txt
DEL TMP.txt
CD "C:\WEPPCLIFF"

"%PathToRscript%" --vanilla WEPPCLIFF.R --args -fr t