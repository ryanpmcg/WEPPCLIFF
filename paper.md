---
title: 'WEPPCLIFF: A command-line tool to process climate inputs for soil loss models'
tags:
  - R
  - WEPP
  - CLIGEN
  - RIST
  - USLE
  - erosivity
authors:
  - name: Ryan P. McGehee
    orcid: 0000-0003-0464-9774
    affiliation: "1, 2"
  - name: Dennis C. Flanagan
    affiliation: "2, 1"
  - name: Puneet Srivastava
    affiliation: "3"
affiliations:
 - name: Purdue University
   index: 1
 - name: USDA ARS National Soil Erosion Research Laboratory
   index: 2
 - name: Auburn University
   index: 3
date: 22 November 2019
bibliography: paper.bib

# Summary

A key driver of erosion and arguably the most labor-intensive input to erosion
models, especially the Water Erosion Prediction Project (WEPP) model
[@usda:1995], is climate. Even the simplest erosion models require climate
inputs which are not always straightforward in their calculation. The
complexity of these inputs dissuades potential users from creating their own
inputs from observed data, which are almost always better than their simulated
counterparts, especially when used to force erosion models for historical
periods. For example, the Revised Universal Soil Loss Equation version 2 (RUSLE2)
[@usda:2013] and WEPP are two of the leading soil erosion prediction models in
the world today, but both still rely on climate inputs that are either outdated
or simulated. RUSLE2, as currently applied commonly within the United States,
relies on climate data from 1960-1999, which is not only 20 years out of date,
but the years utilized had fewer observation
stations and the stations themselves used a mix of older technologies, some of
which have documented quality issues that impact usability and reliability
[@hollinger:2002; @usda:2013; @mcgehee:2018]. WEPP on the other hand, just had
its database updated to the years 1974-2013 [@srivastava:2019], but those
observed values are only used to create parameter files for CLIGEN which is then
used to create simulated climate files for WEPP. In short, the erosion modeling
community can do better, and our users are in need of software that can at least
shoulder most of the burden when preparing climate inputs for popular soil loss
models. Hence the need
for WEPPCLIFF.

WEPPCLIFF is An R-based command line tool which was originally designed to
prepare these climate inputs for WEPP, which has been extended to perform other
general functions such as quality checking, gap filling, and erosion index
calculations (climate inputs for USLE family models). The program is provided
with accompanying documentation which walks a user through installation and a
brief tutorial for usage. A comprehensive section on syntax and accepted inputs
is also provided in the documentation.

# General Execution Description

WEPPCLIFF begins execution based on user input via the terminal, which first
assigns arguments into memory space, checks important arguments for syntax,
loads (or installs if it is the first run) required packages, and reads in the
user specified data file(s). WEPPCLIFF accepts delimited input files of named
time series weather data and station metadata in either single or multi-file
formats. The program then executes in the following order: basic throughput
operations (preprocessing and station splitting), structural operations, data
formatting, time series analysis, unit conversion, quality checking (optional),
trimming, storm separation, variable group operations, gap detection and filling
(optional), plotting (optional), data export (optional), and finally climate
file creation. The output format is always a 'breakpoint' format .cli file.

The current runtime (as of version 1.1) is on the order of seconds to minutes
for the vast majority of inputs. Most of the runtime overhead is a result of
storm separation, gap filling, and plotting. A single station of breakpoint
precipitation and daily weather variables will take much less time than, for
example, 1-minute precipitation and weather variables. Increasing the input
time period has a roughly linear effect on runtime. Parallel execution is
possible when processing multiple stations (in single or multi-file format).
WEPPCLIFF's implementation of parallel execution has a relatively small overhead
at the beginning of execution (where all data and packages are copied to each
core), then execution time reduction is almost perfectly proportional to the
number of cores used. This is limited though by memory capacity for large files
and disk read/write speeds when using many cores.

# Comparing to Existing Software

There is only one other tool which we are aware of that already provides similar
services, but it is not an open source software, nor does it provide the same
capabilities as WEPPCLIFF. This program is called Rainfall Intensity
Summarization Tool (RIST) [@usda:2019], which was developed at the USDA ARS
National Sedimentation Laboratory (NSL) a sister lab to the National Soil
Erosion Research Laboratory (NSERL) who supported the development and validation
of WEPPCLIFF. RIST supports more input formats than WEPPCLIFF, but it does not
provide advanced functionality such as gap detection and filling, quality
checking, or parallel execution (important when processing many files). However,
even RIST's support for other models is limited. The main benefit of using
observed weather data in WEPP is that the actual observed intensities are being
used, but RIST only provides inputs to WEPP that are in the 'daily tp/ip'
format. Therefore, WEPP is still using its double exponential storm generator
when computing rainfall breakpoints, which are of the utmost importance to
infiltration and runoff calculations. WEPPCLIFF, on the other hand provides
climate inputs in the 'breakpoint' format file, which actually uses the
breakpoints from the observed data.

WEPPCLIFF and RIST were recently used side-by-side in the WEPP & RUSLE2 Model
Comparison Study for Iowa, a joint research effort between the NSERL and NSL
ARS laboratories. During that time WEPPCLIFF was used to find a significant
error in RIST that was causing kinetic energy and erosivity calculations to be
26% and 21% too low, respectively (due to the first interval of every storm
being excluded from calculations). RIST was updated in May 2019 with the
corrected routines, and now both programs report values with differences less
than 3% (rounding and some short duration storms that are not included in the
RIST results account for the differences). It appears that the RIST error(s)
were limited to only fixed-interval data formats and that breakpoint format
data was handled correctly. For reference, fixed-interval formats are by far
the most common, and that data type is what all the national climate inputs to
soil loss models are based on [@noaa:2014].

# Validation

The routines in WEPPCLIFF were based on the work of [@mcgehee:2018] who were
able to use fixed-interval data and a simplified methodology to reproduce the
same results as the best quality breakpoint precipitation data reported by
[@mcgregor:1995]. Since that time, we have been refining the approach and the
software to apply them nationally (and internationally) with a consistent
methodology. Therefore, breakpoint calculations were validated by the published
results in the Agricultural Handbooks (282, 537, and 703) [@wischmeier:1965;
@wischmeier:1978; @renard:1997] as well as RIST. And fixed-interval calculations
were validated by breakpoint calculations wherever they were available to use.

# Current and Future Applications

Currently WEPPCLIFF is being used to create a national database of observed
climate inputs for WEPP to be published alongside its CLIGEN database. This will
provide users the option of using simulated climate data for the period of their
choice or observed data, which may be more reliable than simulated data. We have
seen in our internal testing that the differences in observed and simulated data
from the same time period can be more than 20% different for erosivity in any
given month, more than 25% different for runoff, and more than 60% different for
soil loss. There are several reasons for these differences that we will publish
in the near future in appropriate journals. The national database for observed
values will include original results (no advanced operations), quality checked
results, gap filled results, and 50-year and 100-year extensions of the filled
data (for return period analyses and comparisons with CLIGEN). The extensions
are made possible by the fully joint, multiple imputation model used for gap
filling [@vanbuuren:2011], and unlike CLIGEN, all daily correlations amoung
weather variables are preserved.

In the future, we anticipate that some routines, especially quality checking,
gap detection, gap filling, and storm separation, will be updated with new state
of the science approaches. Now that an open source program is published in a
language that is both widely used and highly productive, more scientists can
offer their talents and ideas and data to prepare new climate inputs for soil
loss models and share them more easily with the larger community without wasting
their time and resources on formatting, quality checking, filling missing data,
etc.

# Citations

[@hollinger:2002]
[@mcgehee:2018]
[@mcgregor:1995]
[@noaa:2014]
[@usda:1995]
[@usda:2013]
[@usda:2019]
[@renard:1997]
[@srivastava:2019]
[@vanbuuren:2011]
[@wischmeier:1965]
[@wischmeier:1978]

# Acknowledgements

This work was supported primarily by funding through USDA ARS and resources at
Purdue University, which were used to develop and refine the program. Critical
knowledge and experience gained during Ryan's MS Thesis study at Auburn
University was also a significant factor in the success of the project.

# References
