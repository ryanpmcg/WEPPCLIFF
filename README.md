# WEPPCLIFF
An R-based command line tool designed to prepare climate inputs for WEPP, which has been extended to perform other general functions such as quality checking, gap filling, and erosion index calculations (climate inputs for USLE family models).

# How to Install
Follow the following steps closely! 

1. Clone this repository to your own preferred location (for Windows, it is recommended to use the C:/ drive).
2. Install R version 3.6.1 or later (WEPPCLIFF was most recently validated with R-3.6.1).
3. Run the following command from the WEPPCLIFF home directory (contains WEPPCLIFF.R):

Rscript --vanilla WEPPCLIFF.R --args -fr t

If you are using windows you may need to add Rscript to the system PATH variable. This and many other items are covered in a tutorial. If you are having trouble with installation or want to learn how to use WEPPCLIFF go to the TUTORIAL directory.

# Run Tutorial Manually (as Intended) on UNIX or Windows.
Open the Tutorial.txt file (and WEPPCLIFF Documentation.pdf if more information is desired) and follow the instructions within. Otherwise, follow instructions below for an automated tutorial and testing.

# Run Automated Tutorial on UNIX or Windows
UNIX: From the directory containing WEPPCLIFF.R run: bash ./TUTORIAL/AutoTutorial.sh\n
Windows: From the directory containing WEPPCLIFF.R run: ./TUTORIAL/AutoTutorial.bat

# Run Automated Test (Installation Validation)
UNIX: From the directory containing WEPPCLIFF.R run: bash ./AUTOTEST/AutoTest.sh\n
Windows: From the directory containing WEPPCLIFF.R run: ./AUTOTEST/AutoTest.bat

# Current Version
Version 1.4 is the most recent upload to this repository. Version 1.4 focused on improvements to basic trimming operations, quality checking, and data export. Future versions are attempting to focus on ways to improve the gap filling model. The current model works well for most aspects of the climate outputs, but there is room for improvement. The current wish list includes adding rates of change and more storm characteristics to the gap filling model.

# Contributions
Contributions are always warmly welcomed. Any contributions that materially improve performance, capabilities, accuracy, compatibility, etc. will be gladly incorporated in the source code, credited, and distributed through this repository.
