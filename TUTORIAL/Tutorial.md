# INTRODUCTION

## METADATA:

	Author:		Ryan P. McGehee
	Modified:	17 January 2024

## PURPOSE:

	Provide a basic WEPPCLIFF tutorial. This tutorial covers much of but not
	all WEPPCLIFF capabilities. Read the accompanying documentation for a
	comprehensive documentation of all functionality, syntax requirements,
	defaults, and options.

## OVERVIEW:

	This tutorial covers the following topics chronologically:

	+ SETUP & INSTALLATION
	+ BASIC FUNCTIONALITY
	+ BREAKPOINT INPUTS
	+ FIXED INTERVAL INPUTS
	+ ADVANCED FUNCTIONALITY

## INSTRUCTIONS:

	Read this file for a brief tutorial for using WEPPCLIFF. You may copy
	the commands directly from this text file into your command prompt or
	terminal to run the example datasets and learn more about WEPPCLIFF.

## WARNING:

	You must have all files in the correct structure and you must not alter
	them in any way for the program to execute correctly. For example, Excel
	changes datetime formats into its default settings if you save a file
	after opening it. So be careful please!

## REQUIREMENTS:

	You must have already installed R (version 3.6.1 or later) and all of 
	the WEPPCLIFF dependencies (covered in installation) using default
	settings. The following directory structure and content must be present
	for this tutorial to work. If you have opened any of these in another
	program or have changed the names, it will not work. If you are using
	Windows, it is recommended for this to be located on the C:/ drive.

	
		+ WEPPCLIFF/ ---+
				|
				+ WEPPCLIFF.R
				|
				+ LIBRARY/ (all dependencies here)
				|
				+ INPUT/ -------+
						|
						+ AH537_1MIN.csv
						|
						+ AH537_1MIN_UP.csv
						|
						+ AH537_5MIN.csv
						|
						+ AH537_10MIN.csv
						|
						+ AH537_15MIN.csv
						|
						+ AH537_15MIN_HT.csv
						|
						+ AH537_15MIN_UP.csv
						|
						+ AH537_BPT_CP.csv
						|
						+ AH537_BPT_IP.csv
						|
						+ ASOS_BPT_KMQE.csv

## NOTES:

	As of WEPPCLIFF Version 1.4 automated gap filling and quality checking
	routines were determined to be satisfactory for publication, but they
	are not perfect. In the near future, these routines will be evaluated
	and published in scientific literature to provide a more complete
	understanding of their capabilities and limitations.

	KEEP THESE NOTES IN MIND FOR UNDERSTANDING THE CURRENT CAPABILITIES OF
	WEPPCLIFF AS WELL AS THOSE TO BE INCLUDED IN FUTURE RELEASES.


All commands are enclosed in a code box `like this`.
All Windows-only commands are preceeded with 'WINDOWS:'.
All UNIX-only commands are preceeded with 'UNIX:'.

WINDOWS: start a new command-prompt session.
UNIX: start a new terminal session.


# SETUP & INSTALLATION:

Installation has already been covered by Install.bat or Install.sh for Windows or UNIX, respectively.
This section exists to show you how to perform installation manually if desired.

Change to the root WEPPCLIFF directory (i.e. cd path\to\WEPPCLIFF).
For my Windows machine, this is:

`cd C:\WEPPCLIFF`

WINDOWS: Add the path to Rscript to the system PATH. For my Windows machine running R-3.6.1, this is:

`setx PATH "%PATH%;C:/Program Files/R/R-3.6.1/bin/"`

WINDOWS: If that worked you need to restart your command prompt, then type: `Rscript`

WINDOWS: If that does not show the screen for Rscript, the PATH variable was not successfully updated, and you will need to use the full path to Rscript everytime you see 'Rscript' below.


The following command installs all WEPPCLIFF dependencies.

`Rscript --vanilla WEPPCLIFF.R --args -fr t`

For slow internet connections, downloads can 'time out' and cause installation to fail.
If installation was unsuccessful, you can try the same command again.
If installation is still unsuccessful, I do not support non-WEPPCLIFF issues.


# BASIC FUNCTIONALITY:

Run an example input with default settings.

`Rscript --vanilla WEPPCLIFF.R --args -f ASOS_BPT_KMQE.csv`

Change the output filename, add early license agreement, and turn on verbosity.

`Rscript --vanilla WEPPCLIFF.R --args -f ASOS_BPT_KMQE.csv -fn bpt -la y -verb t`

Change the output location, turn on graphical output, and trim the period analyzed.

`Rscript --vanilla WEPPCLIFF.R --args -f ASOS_BPT_KMQE.csv -la y -verb t -o JUNK -pd t -sdt "2000-01-01 00:00:00" -edt "2004-12-31 24:00:00"`

Use the standalone precipitation processing option (this foregoes the need for non-precipitation data at the expense of gap-filling which would not perform very well for this option compared to other options because there is no multivariate data to build the gap-filling relationships), calculate erosion indices for all 6 ARS energy equations, and export all binary and human readible files supported by WEPPCLIFF.

`Rscript --vanilla WEPPCLIFF.R --args -f ASOS_BPT_KMQE_Standalone.csv -la y -verb t -cv f -pd t -fn KMQE-Standalone -ei t -ee ARS -ed 1`


# BREAKPOINT INPUTS:

Run an example single-storm, breakpoint input with cumulative precipitation and mixed units (English and metric).

`Rscript --vanilla WEPPCLIFF.R --args -f AH537_BPT_CP.csv -cp t -u m PRECIP -sm 2 -la y -ipb t`

Run the same input and turn on graphical output, erosion index calculations, and export functionality.

`Rscript --vanilla WEPPCLIFF.R --args -f AH537_BPT_CP.csv -cp t -u m PRECIP -sm 2 -la y -verb t -ei t -ee AH537 -ipb t -pd t -ed 3`

Run the same command using incremental precipitation inputs.

`Rscript --vanilla WEPPCLIFF.R --args -f AH537_BPT_IP.csv -cp f -u m PRECIP -sm 2 -la y -verb t -ei t -ee AH537 -ipb t -pd t -ed 3`


# FIXED-INTERVAL INPUTS:

Run several variations of the same command as before using various fixed interval products.

One-minute (unlimited precision) data.

`Rscript --vanilla WEPPCLIFF.R --args -f AH537_1MIN_UP.csv -pi 1 -cp f -u m PRECIP -sm 2 -la y -verb t -ei t -ee AH537 -ipb t -pd t -ed 3`

One-minute (0.01 inch precision) data.

`Rscript --vanilla WEPPCLIFF.R --args -f AH537_1MIN.csv -pi 1 -cp f -u m PRECIP -sm 2 -la y -verb t -ei t -ee AH537 -ipb t -pd t -ed 3`

Five-minute (0.01 inch precision) data.

`Rscript --vanilla WEPPCLIFF.R --args -f AH537_5MIN.csv -pi 5 -cp f -u m PRECIP -sm 2 -la y -verb t -ei t -ee AH537 -ipb t -pd t -ed 3`

Ten-minute (0.01 inch precision) data.

`Rscript --vanilla WEPPCLIFF.R --args -f AH537_10MIN.csv -pi 10 -cp f -u m PRECIP -sm 2 -la y -verb t -ei t -ee AH537 -ipb t -pd t -ed 3`

Fifteen-minute (0.01 inch precision) data.

`Rscript --vanilla WEPPCLIFF.R --args -f AH537_15MIN.csv -pi 15 -cp f -u m PRECIP -sm 2 -la y -verb t -ei t -ee AH537 -ipb t -pd t -ed 3`

Fifteen-minute (unlimited precision) data.

`Rscript --vanilla WEPPCLIFF.R --args -f AH537_15MIN_UP.csv -pi 15 -cp f -u m PRECIP -sm 2 -la y -verb t -ei t -ee AH537 -ipb t -pd t -ed 3`

Fifteen-minute (0.1 inch precision) data.

`Rscript --vanilla WEPPCLIFF.R --args -f AH537_15MIN_HT.csv -pi 15 -cp f -u m PRECIP -sm 2 -la y -verb t -ei t -ee AH537 -ipb t -pd t -ed 3`

Guess which one of all the above inputs is used for national conservation planning efforts (as of April 2020)... Yep. The last one. Sigh.


# ADVANCED FUNCTIONALITY:

Run the first example again with quality checking and graphical output.

`Rscript --vanilla WEPPCLIFF.R --args -f ASOS_BPT_KMQE.csv -la y -verb t -qc t -pd t`

Run the example again with gap filling (quick version) and binary data export.

`Rscript --vanilla WEPPCLIFF.R --args -f ASOS_BPT_KMQE.csv -la y -verb t -qc t -pd t -id t -qi t -ed 1`

If you are patient, run the example again with gap filling (the super-tedious, has-to-be-right, OCD version) and filling verbosity on.

`Rscript --vanilla WEPPCLIFF.R --args -f ASOS_BPT_KMQE.csv -la y -verb t -qc t -pd t -id t -iv t -ed 1`

Begin an R session in either RStudio or your terminal (whichever you prefer) and load the binary data using the following:

`data = readRDS("C:/WEPPCLIFF/EXPORT/KMQE.rds")`

Access any object in the primary data structure (a list of objects) with the following:

## ORIGINAL INPUTS (AFTER FORMATTING / PREPROCESSING):

	input_precipitation_dataframe			= data[[1]]
	input_alternative_dataframe			= data[[2]]
	input_daily_dataframe				= data[[3]]
	input_station_metadata_vector			= data[[4]]

## WEPPCLIFF ALTERED INPUTS (QC / TRIMMING / CONVERSIONS / ETC):

	trimmed_qc_precipitation_dataframe		= data[[5]]
	trimmed_qc_alternative_dataframe		= data[[6]]
	trimmed_qc_daily_dataframe			= data[[7]]

## STORM SEPARATION DERIVATIVES:

	storm_breakpoints_list				= data[[8]]
	storm_characteristics_dataframe			= data[[9]]

## AGGREGATED TIMESERIES DATA AND STATISTICAL SUMMARIES:

	aggregated_daily_timeseries_dataframe		= data[[10]]
	aggregated_monthly_timeseries_dataframe		= data[[11]]
	aggregated_yearly_timeseries_dataframe		= data[[12]]
	aggregated_monthly_means_dataframe		= data[[13]]
	annual_summary_output				= data[[14]]

## GAP-FILLED VERSIONS OF PRIOR STRUCTURES:

	gap_filled_precipitation_dataframe		= data[[15]]
	gap_filled_storm_breakpoints_list		= data[[16]]
	gap_filled_storm_characteristics_dataframe	= data[[17]]
	gap_filled_daily_timeseries_dataframe		= data[[18]]
	gap_filled_monthly_timeseries_dataframe		= data[[19]]
	gap_filled_yearly_timeseries_dataframe		= data[[20]]
	gap_filled_monthly_mean_dataframe		= data[[21]]
	gap_filled_annual_summary_output		= data[[22]]

## NOTE:

	Some of the above may be empty (NULL) if various options are not specified.
