# WEPPCLIFF
An R-based command line tool designed to prepare climate inputs for WEPP, which has been extended to perform other general functions such as quality checking, gap filling, and erosion index calculations (climate inputs for USLE family models).

# CURRENT VERSION
Version 1.0.1 is the most recent upload to this repository. Version 1.1 has been developed and will be uploaded pending validation. Version 1.1 fixed bugs preventing parallel execution when using the new gap-filling model. Version 1.2 is the current development focus.

# INSTALL FILES
WEPPCLIFF.zip contains the documentation and files needed for a new installation on Windows or OSX. Linux installation is also possible (and should be relatively simple), but no support is provided in the documentation.

# KNOWN ISSUES
There are some known reliability issues when using small amounts of data (less than 3 calendar years). These are planned to be addressed in version 1.2 no later than December 2019. Most of these issues relate to using the imputation model (gap filling), plotting with missing data, and single-storm simulation mode. The gap filling (and gap detection) model performs adequately for about 95% of US stations that have been tested. It is possible to improve this in future versions as well. 

# CONTRIBUTIONS
Contributions are welcomed. Any contributions that materially improve performance, capabilities, accuracy, compatibility, etc. will be given appropriate credit and ownership. All contributions that are to be distributed as "WEPPCLIFF" must be approved by the original copyright holder, Ryan P. McGehee.
