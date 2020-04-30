#!/bin/sh

DIRECTORY=$(cd `dirname $0` && pwd)
cd $DIRECTORY
cd ..

Rscript --vanilla WEPPCLIFF.R --args -fr t