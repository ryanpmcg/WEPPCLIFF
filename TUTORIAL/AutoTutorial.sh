#!/bin/bash

DIRECTORY=$(cd `dirname $0` && pwd)

cd $DIRECTORY

cd ..

Rscript --vanilla WEPPCLIFF.R --args -fr t -la y
Rscript --vanilla WEPPCLIFF.R --args -fr t

Rscript --vanilla WEPPCLIFF.R --args -f ASOS_BPT_KMQE.csv -la y

Rscript --vanilla WEPPCLIFF.R --args -f ASOS_BPT_KMQE.csv -fn bpt -la y -verb t

Rscript --vanilla WEPPCLIFF.R --args -f ASOS_BPT_KMQE.csv -la y -verb t -o C:/WEPPCLIFF/JUNK -pd t -sdt "2000-01-01 00:00:00" -edt "2004-12-31 24:00:00"

Rscript --vanilla WEPPCLIFF.R --args -f AH537_BPT_CP.csv -cp t -u m PRECIP -sm 2 -la y -ipb t

Rscript --vanilla WEPPCLIFF.R --args -f AH537_BPT_CP.csv -cp t -u m PRECIP -sm 2 -la y -verb t -ei t -ee AH537 -ipb t -pd t -ed 3

Rscript --vanilla WEPPCLIFF.R --args -f AH537_BPT_IP.csv -cp f -u m PRECIP -sm 2 -la y -verb t -ei t -ee AH537 -ipb t -pd t -ed 3

Rscript --vanilla WEPPCLIFF.R --args -f AH537_1MIN_UP.csv -pi 1 -cp f -u m PRECIP -sm 2 -la y -verb t -ei t -ee AH537 -ipb t -pd t -ed 3

Rscript --vanilla WEPPCLIFF.R --args -f AH537_1MIN.csv -pi 1 -cp f -u m PRECIP -sm 2 -la y -verb t -ei t -ee AH537 -ipb t -pd t -ed 3

Rscript --vanilla WEPPCLIFF.R --args -f AH537_5MIN.csv -pi 5 -cp f -u m PRECIP -sm 2 -la y -verb t -ei t -ee AH537 -ipb t -pd t -ed 3

Rscript --vanilla WEPPCLIFF.R --args -f AH537_10MIN.csv -pi 10 -cp f -u m PRECIP -sm 2 -la y -verb t -ei t -ee AH537 -ipb t -pd t -ed 3

Rscript --vanilla WEPPCLIFF.R --args -f AH537_15MIN.csv -pi 15 -cp f -u m PRECIP -sm 2 -la y -verb t -ei t -ee AH537 -ipb t -pd t -ed 3

Rscript --vanilla WEPPCLIFF.R --args -f AH537_15MIN_UP.csv -pi 15 -cp f -u m PRECIP -sm 2 -la y -verb t -ei t -ee AH537 -ipb t -pd t -ed 3

Rscript --vanilla WEPPCLIFF.R --args -f AH537_15MIN_HT.csv -pi 15 -cp f -u m PRECIP -sm 2 -la y -verb t -ei t -ee AH537 -ipb t -pd t -ed 3

Rscript --vanilla WEPPCLIFF.R --args -f ASOS_BPT_KMQE.csv -la y -verb t -qc t -pd t

Rscript --vanilla WEPPCLIFF.R --args -f ASOS_BPT_KMQE.csv -la y -verb t -qc t -pd t -id t -qi t -ed 1

Rscript --vanilla WEPPCLIFF.R --args -f ASOS_BPT_KMQE.csv -la y -verb t -qc t -pd t -id t -iv t -ed 1