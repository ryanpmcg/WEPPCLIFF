# WEPPCLIFF
An R-based command line tool designed to prepare climate inputs for WEPP, which has been extended to perform other general functions such as quality checking, gap filling, and erosion index calculations (climate inputs for USLE family models). This software was published in the Journal of Open Source Software [![DOI](https://joss.theoj.org/papers/10.21105/joss.02029/status.svg)](https://doi.org/10.21105/joss.02029).

## Important Note -- Updated 19 April 2024
WEPPCLIFF v1.7 is not compatible with the latest version of R and Windows (which have historically had more compatibility issues). The issue stems from certain required packages not being available (at this time) for installation and changes to datetime formatting in one or both of the softwares resulting in incorrectly handled datetime strings. It is recommended to use R v3.6.1 and WEPPCLIFF v1.5 in this case, but the user must verify that they have all the packages from the CRAN archive and that they work for their current OS. Thus, some newer features (beyond WEPPCLIFF v1.5) will not be supported in Windows until there is interest and funding to do so. However, these capabilities continue to be supported on UNIX machines.

## How to Install
Follow the following steps closely! 

1. Clone this repository to your own preferred location (for Windows, it is recommended to use the C:/ drive).
2. Install R version 3.6.1 or later (WEPPCLIFF was most recently validated with R-4.2.2).
3. If you are using Windows, install the corresponding version of Rtools from [here](https://cran.r-project.org/bin/windows/Rtools/).
4. From the directory containing WEPPCLIFF.R run:

(UNIX) `bash ./INSTALLER/Install.sh`  --OR-- (Windows) `./INSTALLER/Install.bat`

## Run Tutorial Manually (as Intended) on UNIX or Windows.
Open the [Tutorial](https://github.com/ryanpmcg/WEPPCLIFF/blob/master/TUTORIAL/Tutorial.md) (and [WEPPCLIFF Documentation](https://github.com/ryanpmcg/WEPPCLIFF/blob/master/WEPPCLIFF%20Documentation%20(v1.5).pdf) if more information is desired) and follow the instructions within. Otherwise, follow instructions below for an automated tutorial and testing. For a comprehensive list of WEPPCLIFF flags and arguments, see the [Manual](https://github.com/ryanpmcg/WEPPCLIFF/blob/master/Manual.md).

## Run Automated Tutorial on UNIX or Windows
UNIX: From the directory containing WEPPCLIFF.R run: `bash ./TUTORIAL/AutoTutorial.sh`

Windows: From the directory containing WEPPCLIFF.R run: `./TUTORIAL/AutoTutorial.bat`

## Run Automated Test (Installation Validation)
UNIX: From the directory containing WEPPCLIFF.R run: `bash ./AUTOTEST/AutoTest.sh`

Windows: From the directory containing WEPPCLIFF.R run: `./AUTOTEST/AutoTest.bat`

## Current Version
Version 1.7 is the most recent upload to this repository, which included a major update to support automated aggregation of precipitation data. This new functionality can be accessed via the option: '-ai <intervalInMinutes>' as long as 1440 is divisible by the integer. The [Manual](https://github.com/ryanpmcg/WEPPCLIFF/blob/master/Manual.md) has been updated with these changes, though the [WEPPCLIFF Documentation](https://github.com/ryanpmcg/WEPPCLIFF/blob/master/WEPPCLIFF%20Documentation%20(v1.5).pdf) is not planned to be updated until the next major release. Improvements to the gap-filling model (including a comprehensive validation of its capabilities) are planned for the next major release (i.e., WEPPCLIFF v2.0).

## Contributions
Contributions are always warmly welcomed. Any contributions that materially improve performance, capabilities, accuracy, compatibility, etc. will be gladly incorporated in the source code, credited, and distributed through this repository. Ideally, contributions should proceed something like the following, but this should not be legalistic in any way:
1. An issue is opened to see if the proposed changes have not already been considered and would be useful.
2. If the feedback is positive, the contributor should fork the repository and make their proposed changes to the code.
3. When edits to the branch (and testing by the contributor) are completed, the contributor should make a pull request.
4. If there are no problems, the new changes will be merged and distributed with the next version release.

## Support
Only WEPPCLIFF-related issues are supported. If you have trouble with installing R, running command-line scripts, or other basics, support is not guaranteed. With that said, you may ask questions on the General Questions and Support Issue here: https://github.com/ryanpmcg/WEPPCLIFF/issues/11.

## Issues
To report a potential bug, suggest an improvement, or raise other points to the community, please open an issue. If there is a problem, please provide the following:
1. Your OS and applicable hardware limitations
2. Your version of R
3. Your WEPPCLIFF command
4. Your input files
5. Your output (if there is any) and the correct output (if applicable)
6. Your WEPPCLIFF/AUTOTEST/OUTPUT folder as a .zip file (if applicable)

## Conduct
Do not let this become an issue. Obviously poor conduct will result in a ban.

## Dependencies
WEPPCLIFF is grateful to the open source community and relies on the hard work of others for part of its own success. All of this work from others is represented by the various packages listed below, which are required for various portions of WEPPCLIFF code to work (listed in order of installation).

1. backports
2. crayon
3. vctrs
4. tzdb
5. cli
6. vroom
7. readr
8. rlist
9. iterators
10. foreach
11. doParallel
12. EnvStats
13. mice
14. RcppParallel
15. withr
16. ggplot2
17. profvis
18. data.table
19. jsonlite
20. climextRemes
