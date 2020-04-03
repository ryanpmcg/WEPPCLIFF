#!/bin/sh


################################################################################
################################  SET DIRECTORY  ###############################
################################################################################

DIRECTORY=$(cd `dirname $0` && pwd)
cd $DIRECTORY
cd ..


################################################################################
##############################  GLOBAL VARIABLES  ##############################
################################################################################

TEST=("\n
	Verifying WEPPCLIFF installation (i.e. if you have not completed installation\n
	this test will fail). This test will only take a couple minutes to finish and\n
	will begin in a few seconds. Please check back momentarily for the results.\n")

CHECKSUM=("\n
	Running checksum tests. Almost done...\n")
	 
SUCCESS=("\n
	CONGRATULATIONS! Your WEPPCLIFF installation was successfully verified by 8\n
	automated test runs and 16 highly unique file outputs. Now you are ready to use\n
	WEPPCLIFF with peace of mind, knowing everything is working as intended.\n")

FAILURE=("\n
	OOPS! Something is not right. Your WEPPCLIFF installation failed at least one\n
	of 8 automated test runs. Please remove and reinstall WEPPCLIFF then try this\n
	test again. If the problem persists and you believe the problem lies within\n
	WEPPCLIFF, please create an issue at: https://github.com/ryanpmcg/WEPPCLIFF\n
	\n
	Thank you! Hopefully the WEPPCLIFF community can help you get up and running\n
	soon.\n")


################################################################################
###############################  RUN WEPPCLIFF  ################################
################################################################################

clear
echo $TEST
sleep 10

Rscript --vanilla WEPPCLIFF.R --args -o $DIRECTORY/OUTPUT -e $DIRECTORY/OUTPUT -fn AutoTest.1 -f ASOS_BPT_KMQE.csv -la y -verb t -ed 1
Rscript --vanilla WEPPCLIFF.R --args -o $DIRECTORY/OUTPUT -e $DIRECTORY/OUTPUT -fn AutoTest.2 -f AH537_BPT_CP.csv -cp t -u m PRECIP -sm 2 -la y -verb t -ei t -ee ARS -ipb t -pd t -ed 1
Rscript --vanilla WEPPCLIFF.R --args -o $DIRECTORY/OUTPUT -e $DIRECTORY/OUTPUT -fn AutoTest.3 -f AH537_BPT_IP.csv -cp f -u m PRECIP -sm 2 -la y -verb t -ei t -ee ARS -ipb t -pd t -ed 1
Rscript --vanilla WEPPCLIFF.R --args -o $DIRECTORY/OUTPUT -e $DIRECTORY/OUTPUT -fn AutoTest.4 -f AH537_1MIN_UP.csv -pi 1 -cp f -u m PRECIP -sm 2 -la y -verb t -ei t -ee ARS -ipb t -pd t -ed 1
Rscript --vanilla WEPPCLIFF.R --args -o $DIRECTORY/OUTPUT -e $DIRECTORY/OUTPUT -fn AutoTest.5 -f AH537_1MIN.csv -pi 1 -cp f -u m PRECIP -sm 2 -la y -verb t -ei t -ee ARS -ipb t -pd t -ed 1
Rscript --vanilla WEPPCLIFF.R --args -o $DIRECTORY/OUTPUT -e $DIRECTORY/OUTPUT -fn AutoTest.6 -f AH537_5MIN.csv -pi 5 -cp f -u m PRECIP -sm 2 -la y -verb t -ei t -ee ARS -ipb t -pd t -ed 1
Rscript --vanilla WEPPCLIFF.R --args -o $DIRECTORY/OUTPUT -e $DIRECTORY/OUTPUT -fn AutoTest.7 -f AH537_10MIN.csv -pi 10 -cp f -u m PRECIP -sm 2 -la y -verb t -ei t -ee ARS -ipb t -pd t -ed 1
Rscript --vanilla WEPPCLIFF.R --args -o $DIRECTORY/OUTPUT -e $DIRECTORY/OUTPUT -fn AutoTest.8 -f AH537_15MIN.csv -pi 15 -cp f -u m PRECIP -sm 2 -la y -verb t -ei t -ee ARS -ipb t -pd t -ed 1


################################################################################
#############################  RUN CHECKSUM TEST  ##############################
################################################################################

clear
echo $CHECKSUM
FAIL=0

for ITER in {1..8}
	do
		# Calculate MD5 Sums of .cli Files
		BENCH=$(md5 $DIRECTORY/BENCHMARKS/AutoTest.$ITER.cli | awk '{print $4}')
		TEMP=$(md5 $DIRECTORY/OUTPUT/AutoTest.$ITER.cli | awk '{print $4}')

		# Check MD5 Sums and Print Results
		if [ `echo $BENCH` == `echo $TEMP` ]; then
			echo " Passed CLI Test $ITER"
		else
			echo " Failed CLI Test $ITER"
			FAIL=1
		fi

		# Calculate MD5 Sums of .rds Files
		BENCH=$(md5 $DIRECTORY/BENCHMARKS/AutoTest.$ITER.rds | awk '{print $4}')
		TEMP=$(md5 $DIRECTORY/OUTPUT/AutoTest.$ITER.rds | awk '{print $4}')

		# Check MD5 Sums and Print Results
		if [ `echo $BENCH` == `echo $TEMP` ]; then
			echo " Passed RDS Test $ITER"
		else
			echo " Failed RDS Test $ITER"
			FAIL=1
		fi
	done


################################################################################
#############################  PRINT TEST RESULT  ##############################
################################################################################

if [ $FAIL == 0 ]; then
	echo $SUCCESS
else
	echo $FAILURE
fi
