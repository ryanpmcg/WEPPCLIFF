
cd ..

PathToRscript --vanilla WEPPCLIFF.R --args -fr t

PathToRscript --vanilla WEPPCLIFF.R --args -f ASOS_BPT_KMQE.csv

PathToRscript --vanilla WEPPCLIFF.R --args -f ASOS_BPT_KMQE.csv -fn bpt -la y -verb t

PathToRscript --vanilla WEPPCLIFF.R --args -f ASOS_BPT_KMQE.csv -la y -verb t -o JUNK -pd t -sdt "2000-01-01 00:00:00" -edt "2004-12-31 24:00:00"

PathToRscript --vanilla WEPPCLIFF.R --args -f AH537_BPT_CP.csv -cp t -u m PRECIP -sm 2 -la y -ipb t

PathToRscript --vanilla WEPPCLIFF.R --args -f AH537_BPT_CP.csv -cp t -u m PRECIP -sm 2 -la y -verb t -ei t -ee AH537 -ipb t -pd t -ed 3

PathToRscript --vanilla WEPPCLIFF.R --args -f AH537_BPT_IP.csv -cp f -u m PRECIP -sm 2 -la y -verb t -ei t -ee AH537 -ipb t -pd t -ed 3

PathToRscript --vanilla WEPPCLIFF.R --args -f AH537_1MIN_UP.csv -pi 1 -cp f -u m PRECIP -sm 2 -la y -verb t -ei t -ee AH537 -ipb t -pd t -ed 3

PathToRscript --vanilla WEPPCLIFF.R --args -f AH537_1MIN.csv -pi 1 -cp f -u m PRECIP -sm 2 -la y -verb t -ei t -ee AH537 -ipb t -pd t -ed 3

PathToRscript --vanilla WEPPCLIFF.R --args -f AH537_5MIN.csv -pi 5 -cp f -u m PRECIP -sm 2 -la y -verb t -ei t -ee AH537 -ipb t -pd t -ed 3

PathToRscript --vanilla WEPPCLIFF.R --args -f AH537_10MIN.csv -pi 10 -cp f -u m PRECIP -sm 2 -la y -verb t -ei t -ee AH537 -ipb t -pd t -ed 3

PathToRscript --vanilla WEPPCLIFF.R --args -f AH537_15MIN.csv -pi 15 -cp f -u m PRECIP -sm 2 -la y -verb t -ei t -ee AH537 -ipb t -pd t -ed 3

PathToRscript --vanilla WEPPCLIFF.R --args -f AH537_15MIN_UP.csv -pi 15 -cp f -u m PRECIP -sm 2 -la y -verb t -ei t -ee AH537 -ipb t -pd t -ed 3

PathToRscript --vanilla WEPPCLIFF.R --args -f AH537_15MIN_HT.csv -pi 15 -cp f -u m PRECIP -sm 2 -la y -verb t -ei t -ee AH537 -ipb t -pd t -ed 3

PathToRscript --vanilla WEPPCLIFF.R --args -f ASOS_BPT_KMQE.csv -la y -verb t -qc t -pd t

PathToRscript --vanilla WEPPCLIFF.R --args -f ASOS_BPT_KMQE.csv -la y -verb t -qc t -pd t -id t -qi t -ed 1

PathToRscript --vanilla WEPPCLIFF.R --args -f ASOS_BPT_KMQE.csv -la y -verb t -qc t -pd t -id t -iv t -ed 1