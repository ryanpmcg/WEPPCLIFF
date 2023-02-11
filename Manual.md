# WEPPCLIFF MANUAL

## METADATA:

	Author:		Ryan P. McGehee
	Modified:	4 March 2022

## PURPOSE:

	Provide a manual of WEPPCLIFF (v1.6) syntax, which is easily accessible.

## NOTES:

	WEPPCLIFF is always being improved, which means that its functions and
	syntax may change over time, but changes are only made when absolutely
	necessary. Most commands, especially core functionality, will not change
	much over time.
	
	As of WEPPCLIFF Version 1.6 automated gap filling and quality checking
	routines were determined to be satisfactory for continued use, but they
	are not perfect. These routines were broadly evaluated and published in
	"An Updated Isoerodent Map of the Conterminous United States" (McGehee 
	et al. 2022). They found the gap filling model added substantial value
	to stations with gaps, but the filled storm data tended to be less 
	erosive than the original storms by about 10% on average. This will
	likely be addressed in a future update. But users should be aware of
	the limitation in the meantime.

	KEEP THESE NOTES IN MIND FOR UNDERSTANDING THE CURRENT CAPABILITIES OF
	WEPPCLIFF AS WELL AS THOSE TO BE INCLUDED IN FUTURE RELEASES.

## INSTALLATION ARGUMENTS:
**FLAG**|**NAME**|**DEFAULT**|**OPTIONS**|**DESCRIPTION**
-----|-----|-----|-----|-----
fr|first run|F|T / F|determines whether or not dependencies should be installed; this should be T for the first run and F for all subsequent runs on a machine
la|license agreement| |Y / N|the default is to not provide a response to the license agreement

## INPUT/OUTPUT ARGUMENTS:
**FLAG**|**NAME**|**DEFAULT**|**OPTIONS**|**DESCRIPTION**
-----|-----|-----|-----|-----
d|input directory|./INPUT|a directory|the parent directory of the single input file or the directory of files to process; the WEPPCLIFF home directory is the default local root
o|output directory|./OUTPUT|a directory|the location where all .cli files will be written; the WEPPCLIFF home directory is the default local root
e|export directory|./EXPORT|a directory|the location where all binary .rds (binary) or .json (text) files will be written; the WEPPCLIFF home directory is the default local root
p|plot directory|./PLOTS|a directory|the location where all graphical output files will be written; the WEPPCLIFF home directory is the default local root
l|library directory|./LIBRARY|a directory|the location where all WEPPCLIFF dependency files will be written; the WEPPCLIFF home directory is the default local root
f|filename|NONE|.txt, .csv, or .tsv file|the input file if there is only one; leaving this blank will cause the program to try and process all files in the input directory; accepts tab or comma separated entries (must be .tsv or .csv, respectively) or you can specify a delimiter for .txt files with -delim
fn|output filename|station|a string|the name which will be used as default for all files written during WEPPCLIFF processing; specifying 'station' will search the input data for a station name to be assigned to the outputs (especially useful for parallel processing)
delim|file delimiter|a single space|a string|specifies a delimiter to use when the input file is of type .txt
fsp|file search pattern|NA|a string|specifies a pattern for grep-based searching and subsetting of input files
isc|ignore search case|F|T / F|specifies whether the case (capitalization) of the search pattern should be ignored
rs|recursive search|F|T / F|specifies whether the input file search (with or without the search pattern) should be recursive (i.e., search child directories)

## FUNCTIONALITY ARGUMENTS:
**FLAG**|**NAME**|**DEFAULT**|**OPTIONS**|**DESCRIPTION**
-----|-----|-----|-----|-----
u|units|M|M <vars> / E <vars>|the units of the input file (Metric or English) followed by variables which are exceptions must be specified in order for the correct conversions to be applied
qc|quality control|F|T / F|determines whether or not to perform quality control routines for the input data; the flags -qcop, -qcth, and -qcdf control the methodology
id|impute missing data|F|T / F|determines whether or not to engage a multiple imputation model to fill missing data; the flags -im, -io, -qi, and -iv control the methodology
pd|plot data|F|T / F|determines whether or not to create graphical output for both inputs to WEPPCLIFF and resulting output data
ed|export data|0|0 / 1 / 2 / 3 / 4 / 5 / 6|determines whether or not to generate binary or human readible output of internal calculations; (0) no files written; (1) all supported export files written; (2) a single .rds binary file written (1 and 2 are the only options that export all internal calculations); (3-6) .csv text files written for only precipitation, daily, storm, or breakpoint timeseries dataframes, respectively
alt|alternative data|F|T / F|specifies whether or not to use alternative data to calculate minimum, maximum, and dew point temperatures; this requires the variables AIR\_TEMP and REL\_HUM
pmd|preserve missing data|F|T / F|specifies whether or not to maintain NA values throughout execution; when true, this converts all non-numeric inputs and calculations and the WEPPCLIFF missing data value (-99999) values to NA; internal calculations and plots are affected according to various conventions throughout execution

## PRECIPITATION ARGUMENTS:
**FLAG**|**NAME**|**DEFAULT**|**OPTIONS**|**DESCRIPTION**
-----|-----|-----|-----|-----
cp|cumulative precipitation|F|T / F|specifies whether or not input precipitation data is cumulative (T) or incremental (F)
pi|precipitation interval|F|F / positive integer|specifies a precipitation time interval in minutes to use; (F) indicates that the data provided are already in breakpoint format (i.e. the interval is exactly the difference between measured values
ai|aggregation interval|F|F / positive integer*|specifies a precipitation time interval in minutes to use for aggregating (summing) precipitation amounts; *the integer must be exactly divisible into 1440; (F) indicates that no aggregation should be performed; aggregated precipitation will result in equal amounts with different characteristics; this can be used to simulate the effect of coarser gauge measurements on various hydrologic and erosion outcomes
ei|erosion index|F|T / F|specifies whether or not erosion indices should be calculated
ee|energy equation|R2|ALL / ARS / MM / BF / AH282 / AH537 / AH703 / R2 / USER <exp>|specifies the energy equation to be used to calculate erosion indices; options include: Brown-Foster (BF), McGregor-Mutchler (MM), any of the three Agricultural Handbooks (282/537/703), the RUSLE2 version of the BF equation (R2) or a user specified equation (which must be followed by an acceptable Base R expression in terms of intensity as 'i'); an option for all equations (ALL) including the USER equation is available (USER is NULL if unspecified) and (ARS) uses all equations except for the USER equation

## STORM CONTROL ARGUMENTS:
**FLAG**|**NAME**|**DEFAULT**|**OPTIONS**|**DESCRIPTION**
-----|-----|-----|-----|-----
sid|storm identifier|1|1:n|specifies which storm to use when -sm 2 (single event) is specified; this changes according to the storm separation method and parameters; this can also be used with -sdt for a known start time
tth|time threshold|6|a positive number|the time threshold (in hours) to be used for summing precipitation in storm separation
dth|depth threshold|1.27|a positive number|the depth threshold (in mm) to be used for determining breaks between storms

## QUALITY CONTROL ARGUMENTS:
**FLAG**|**NAME**|**DEFAULT**|**OPTIONS**|**DESCRIPTION**
-----|-----|-----|-----|-----
qcop|quality checking option|B|B / P / E|specifies the quality control method to use where values exceeding critical limits are called outliers and are removed; P allows physical rate and range limits to be applied to each of the 9 variables; E initiates several empirical tests to apply including: spiking, streaking, sticking, and return period (some additional control is possible through the other quality control arguments); B, the default, applies both
chkth|checking threshold|0.9|a positive number|specifies the fraction of rate data (lowest %) that can be ignored during quality checking for spiking
spkth|spiking threshold|0.9|a positive number|specifies the fraction a potential 'spike' must recover in order to be treated and removed as an actual 'spike'; not applied to precipitation
strth|streaking threshold|2|a positive integer|specifies the minimum number of consecutive identical values to be treated and removed as a 'streak'; not applied to precipitation
stkth|sticking threshold|4|a positive integer|specifies the number of non-consecutive values over which to check for a potential 'stick'; not applied to precipitation
rp|return period|1000|a positive number|specifies the return period in years above which all values should be removed from the dataset as 'outliers' or 'unrepresentative' values; not yet released; only applied to precipitation

## IMPUTE CONTROL ARGUMENTS:
**FLAG**|**NAME**|**DEFAULT**|**OPTIONS**|**DESCRIPTION**
-----|-----|-----|-----|-----
im|impute method|DEFAULT|see 'mice' help|specifies the method to use for those imputation models which are not restricted by WEPPCLIFF; the default is to use the original imputation model design for WEPPCLIFF
io|iteration override|100|a positive integer|a maximum number of iterations to use for imputation; WEPPCLIFF will  never use less than 10 iterations ; the default number of iterations used is determined by the ratio of present data to missing data
qi|quick impute|F|T / F|determines whether or not to set parameters for the fastest possible imputation model that is minimally sufficient for reliable results
iv|impute verbosity|F|T / F|determines whether or not to print imputation progress; this can be very helpful if there are significant gaps or the data are being used to extend output beyond the observed time period

## DATETIME CONTROL ARGUMENTS:
**FLAG**|**NAME**|**DEFAULT**|**OPTIONS**|**DESCRIPTION**
-----|-----|-----|-----|-----
tz|time zone|GMT|an OlsonNames() time zone|specifies the time zone to set for the system environment (will change back to default after program executes)
sdt|start datetime|first datetime|a datetime|specifies the start time to which data will be trimmed; if -sm is 1 the data will be trimmed to the first calendar year >= -sdt; if -sm is 2 the data will be trimmed to -sdt exactly
edt|end datetime|last datetime|a datetime|specifies the end time to which data will be trimmed; if -sm is 1 the data will be trimmed to the first calendar year <= -edt; if -sm is 2 the data will be trimmed to -edt exactly
rtb|round time bounds|M|M / D / H / F|rounds the start and end of complete data to the beginning and ending of the first and last month (M), day (D), hour (H), or does not round (F); this exists to make sure that virtually complete years are not wasted
ipb|ignore precipitation bounds|F|T / F|specifies whether or not to include the precipitation timeseries in determining where the data should be trimmed to
dtf1|datetime format 1|%Y-%m-%d %H:%M:%S|an R datetime format string|the datetime (or date) format used to process precipitation data; see R Help for more information on formatting options; the default is in the format YYYY-MM-DD HH:MM:SS
dtf2|datetime format 2|dtf1|an R datetime format string|the datetime (or date) format used to process alternative data; see R Help for more information on formatting options; the default is the same as that of precipitation data
dtf3|datetime format 3|dtf1|an R datetime format string|the datetime (or date) format used to process daily data; see R Help for more information on formatting options; the default is the same as that of precipitation data

## CLIGEN FORMAT CONTROL ARGUMENTS:
**FLAG**|**NAME**|**DEFAULT**|**OPTIONS**|**DESCRIPTION**
-----|-----|-----|-----|-----
cv|CLIGEN version|0.0|F / 0.0 / 4.3 / 5.3|when performing standalone precipitation analyses, use 'F' (quality checking, gap filling, and .cli file creation are not supported in this mode); when creating .cli files from precipitation and other climate information, generally this should be 0.0 because observed data is not from CLIGEN, but the option exists to change this for some WEPP applications only the most common versions (4.3 and 5.3) are supported now
sm|simulation mode|1|1 / 2|determines whether WEPPCLIFF should create a continuous CLI file (1) or an event-wise CLI file (2); this can be for a single storm or a series of storms, but this mode has not yet been validated with WEPP
bf|breakpoint format|1|0 / 1|determines whether WEPPCLIFF output should be written identical to 'ip-tp' format, daily CLIGEN output (0) or in breakpoint format (1); daily ip and tp calculations differ from similar variables in WEPPCLIFF dataframes (i.e., these are not interchangeable)
wi|wind information|1|0 / 1|determines whether wind information should be used (1) in the CLI file or ignored (0); this is only relevant for WEPP and has no impact on the WEPPCLIFF program execution

## OPTIMIZATION ARGUMENTS:
**FLAG**|**NAME**|**DEFAULT**|**OPTIONS**|**DESCRIPTION**
-----|-----|-----|-----|-----
mp|multiprocessing|T|T / F / # of cores|determines whether or not stations (when there are more than 1) will be processed in parallel; it is automatically disabled for 1 station since not much time would be saved; cores will be determined automatically if not specified directly

## DEVELOPER ARGUMENTS:
**FLAG**|**NAME**|**DEFAULT**|**OPTIONS**|**DESCRIPTION**
-----|-----|-----|-----|-----
prof|profile code|F|T / F|specifies whether or not to initiate the profiling routine and to generate profiles in the profiling directory
pint|profile interval|0.02|a positive number|specifies the time interval to use when profiling code
mepr|profile memory|F|T / F|specifies whether or not to include memory profiling
gcpr|profile garbage collection|F|T / F|specifies whether or not to include garbage collection profiling
lnpr|profile lines|F|T / F|specifies whether or not to include line profiling
warn|show warnings|F|T / F|specifies whether or not warnings should be printed
verb|verbosity|F|T / F|specifies the amount of terminal output (essentially provides more execution progress reports to the terminal for single station operation)
