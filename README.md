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
UNIX: From the directory containing WEPPCLIFF.R run: bash ./TUTORIAL/AutoTutorial.sh

Windows: From the directory containing WEPPCLIFF.R run: ./TUTORIAL/AutoTutorial.bat

# Run Automated Test (Installation Validation)
UNIX: From the directory containing WEPPCLIFF.R run: bash ./AUTOTEST/AutoTest.sh

Windows: From the directory containing WEPPCLIFF.R run: ./AUTOTEST/AutoTest.bat

# Current Version
Version 1.4.1 is the most recent upload to this repository. Version 1.4 focused on improvements to basic trimming operations, quality checking, and data export. Future versions are attempting to focus on ways to improve the gap filling model. The current model works well for most aspects of the climate outputs, but there is room for improvement. The current wish list includes adding rates of change and more storm characteristics to the gap filling model.

# Contributions
Contributions are always warmly welcomed. Any contributions that materially improve performance, capabilities, accuracy, compatibility, etc. will be gladly incorporated in the source code, credited, and distributed through this repository. Ideally, contributions should proceed something like the following, but this should not be legalistic in any way:
1. An issue is opened to see if the proposed changes have not already been considered and would be useful.
2. If the feedback is positive, the contributor should fork the repository and make their proposed changes to the code.
3. When edits to the branch (and testing by the contributor) are completed, the contributor should make a pull request.
4. If there are no problems, the new changes will be merged and distributed with the next version release.

# Support
Only WEPPCLIFF-related issues are supported. If you have trouble with installing R, running command-line scripts, or other basics, support is not guaranteed. With that said, you may ask questions on the General Questions and Support Issue here: https://github.com/ryanpmcg/WEPPCLIFF/issues/11.

# Issues
To report a potential bug, suggest an improvement, or raise other points to the community, please open an issue. If there is a problem, please provide the following:
1. Your OS and applicable hardware limitations
2. Your version of R
3. Your WEPPCLIFF command
4. Your input files
5. Your output (if there is any) and the correct output (if applicable)
6. Your WEPPCLIFF/AUTOTEST/OUTPUT folder as a .zip file (if applicable)

# Conduct
Do not let this become an issue. Obviously poor conduct will result in a ban.
