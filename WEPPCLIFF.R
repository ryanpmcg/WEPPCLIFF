#############################################################################
############################## PROGRAM METADATA #############################
#############################################################################

#  Version: 1.7
#  Last Updated by: Ryan P. McGehee
#  Last Updated on: 15 February 2023
#  Purpose: This program was first designed to create an appropriate input
#           climate file (.cli) for a WEPP model run. However, the program
#           has evolved into a much more advanced and capable tool. See the
#           accompanying documentation for more information.


#############################################################################
############################## DEFINE FUNCTIONS #############################
#############################################################################

# A function to print the WEPPCLIFF logo to screen.
print_weppcliff_logo = function() {
  LOGO = {"
________________________________________________________________________________
________________________________________________________________________________

 ___      ___ _______ _______  _______  _______ ___     _______ _______ _______
 | |  __  | | |  ___/ |  __  | |  __  | |  ___/ | |     |__ __| |  ___/ |  ___/
 | | /  \\ | | | |___  | |__| | | |__| | | |     | |       | |   | |___  | |___
 | |/ /\\ \\| | |  __/  |  ____| |  ____| | |     | |       | |   |  __/  |  __/
 \\   /  \\   / | |___  | |      | |      | |___  | |___   _| |_  | |     | |
  \\_/    \\_/  |_____| |_|      |_|      |_____| |_____| |_____| |_|     |_|

________________________________________________________________________________
________________________________________________________________________________
"}
  
  cat(rep(lr, 30))
  cat(LOGO)}


# A function to print a license agreement.
print_license_agreement = function() {
  LICENSE = {"
  WEPP Climate File Formatter (WEPPCLIFF) Version 1.7
  Copyright (c) 2023 Ryan P. McGehee

  This program is free software: you can redistribute it and/or modify
  it under the terms of the GNU General Public License as published by
  the Free Software Foundation (GNU GPL v3.0).

  This program is distributed in the hope that it will be useful,
  but WITHOUT ANY WARRANTY; without even the implied warranty of
  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
  GNU General Public License for more details.

  You should have received a copy of the GNU General Public License
  along with this program.  If not, see <http://www.gnu.org/licenses/>.
  
  Please provide an appropriate citation in any published work as follows:

  McGehee, R.P., D.C. Flanagan, and P. Srivastava. 2020. WEPPCLIFF:
      A command-line tool to process climate inputs for soil loss models.
      Journal of Open Source Software. https://doi.org/10.21105/joss.02029
      Repository available at: https://github.com/ryanpmcg/WEPPCLIFF

  Corresponding Author: R.P. McGehee
  E-mail: ryanpmcgehee@gmail.com"}
  
  cat(lr)
  cat(LICENSE)
  cat(lr)}


# A function to prompt a license agreement and accept user response.
prompt_license_agreement = function() {
  print_license_agreement()
  cat(lr, lr, "Do you accept these conditions? (Y/N)", lr, lr, collapse = "")
  stdin = file("stdin")
  response = readLines(stdin, n = 1L)
  close(stdin)
  if (toupper(response) != "Y"){
    stop("You must acknowledge your agreement to the license conditions with 'Y or y' to use this software.")}}


# A function to create directories if they do not exist.
create_directory = function(var) {
  logic = dir.exists(toupper(var))
  if (logic == F){dir.create(var)}}


# A function to create the WEPPCLIFF base directory.
create_base_directory = function() {
  dirs = c(l, d, o, e, p)
  for (i in dirs){create_directory(i)}}


# A function to find this file location. Credit: Katie Barnhart @kbarnhart
find_this_file = function() {
  cmdArgs = commandArgs(trailingOnly = FALSE)
  needle = "--file="
  match = grep(needle, cmdArgs)
  if (length(match) > 0) {return(normalizePath(sub(needle, "", cmdArgs[match])))
  } else {return(normalizePath(sys.frames()[[1]]$ofile))}}


# A function to determine directory location.
set_wds = function() {
  
  # Set a global home directory.
  home.dir <<- dirname(find_this_file())
  
  # Set base directories.
  dir.names = c("lib.dir", "in.dir", "out.dir", "ex.dir", "plot.dir")
  dir.locs = c(l, d, o, e, p)
  for (i in 1:length(dir.names)) {assign(dir.names[i], dir.locs[i], envir = .GlobalEnv)}}


# A function to install R package dependencies on the first run.
install_dependencies = function() {
  cat("Installing R package dependencies...", lr, lr, sep = "")
  lapply(package.list, install.packages, lib = lib.dir, type = "binary", repos = "http://cran.us.r-project.org")
  cat(lr, lr, "Done.", lr, lr, sep = "")}


# A function to locate acceptable arguments.
parse_arg_locations = function() {
  for (i in flags){
    x = which(args == paste("-", i, sep = ""))
    assign(paste(i, ".loc", sep = ""), x, envir = .GlobalEnv)}}


# A function to assign an early license agreement to a variable.
early_license_agreement = function() {
  
  # Get the argument location and value to assign to a variable.
  la <<- 'NULL'
  value = args[get("la.loc") + 1]
  if (length(value) > 0){assign('la', value, envir = .GlobalEnv)}}


# A function to assign arguments to global variables and print to screen.
assign_args_to_vars = function() {
  
  # Print argument header.
  cat(rep(lr, 2))
  cat(paste(rep("*", 80), collapse = ""), lr, lr)
  cat(paste(" User Specified Arguments:", length(grep("-", args)) - 1, "of", length(flags), "possible arguments.", lr, lr, collapse = ""))
  cat(paste(rep("*", 80), collapse = ""), lr)
  cat(rep(lr, 2))
  
  # Reset counters.
  counter = 1
  flagcounter = 1
  
  # Loop over arguments.
  for (i in flags){
    
    # Print for each argument grouping.
    if (counter %in% flagcount) {
      if (counter != 1) {
        cat(rep(lr, 2))
        cat(" ", paste(rep("*", 44), collapse = ""), lr, lr)}
      spaces = floor((45 - nchar(flagtypes[flagcounter])) / 2)
      cat(paste(rep(" ", spaces), collapse = ""),flagtypes[flagcounter], lr)
      flagcounter = flagcounter + 1}
    
    # Get the argument location and value to assign to a variable.
    x = get(paste(i, ".loc", sep = ""))
    value = args[x + 1]
    if (length(value) > 0){assign(paste(i), value, envir = .GlobalEnv)}
    if (length(value) == 0){assign(paste(i), NULL, envir = .GlobalEnv)}
    
    # Determine leader length and print arguments to screen.
    leader = paste(rep("-", 40 - nchar(flagnames[counter]) - nchar(i)), collapse = "")
    cat(paste(lr,"",flagnames[counter], leader, i, ":\t", args[x + 1], "",collapse = ""))
    counter = counter + 1}
  
  # End argument printing.
  cat(rep(lr, 3))
  cat(paste(rep("*", 80), collapse = ""), lr)
  cat(rep(lr, 2))}


# A function to fill unspecified arguments with defaults (# Def:).
assign_empty_args = function() {
  
  # Execute initial assignment.
  runif(1) #Forces creation of the global variable: .Random.seed
  if (length(d) == 0){assign("d", paste(home.dir, "/INPUT", sep = ""), envir = .GlobalEnv)} # Def: current directory
  if (length(o) == 0){assign("o", paste(home.dir, "/OUTPUT", sep = ""), envir = .GlobalEnv)} # Def: current directory
  if (length(e) == 0){assign("e", paste(home.dir, "/EXPORT", sep = ""), envir = .GlobalEnv)} # Def: current directory
  if (length(p) == 0){assign("p", paste(home.dir, "/PLOTS", sep = ""), envir = .GlobalEnv)} # Def: current directory
  if (length(l) == 0){assign("l", paste(home.dir, "/LIBRARY", sep = ""), envir = .GlobalEnv)} # Def: current directory
  if (length(u) == 0){assign("u", "m", envir = .GlobalEnv)} # Def: metric units
  if (length(fn) == 0){assign("fn", "station", envir = .GlobalEnv)} # Def: output file name will be "out.cli"
  if (length(fr) == 0){assign("fr", "f", envir = .GlobalEnv)} # Def: not first run
  if (length(la) == 0){assign("la", NULL, envir = .GlobalEnv)} # Def: NULL placeholder
  if (length(mp) == 0){assign("mp", "t", envir = .GlobalEnv)} # Def: multicore operation
  if (length(qc) == 0){assign("qc", "f", envir = .GlobalEnv)} # Def: do not check quality
  if (length(rp) == 0){assign("rp", 1000, envir = .GlobalEnv)} # Def: 1000-year or higher return period events are removed
  if (length(id) == 0){assign("id", "f", envir = .GlobalEnv)} # Def: do not fill data
  if (length(pd) == 0){assign("pd", "f", envir = .GlobalEnv)} # Def: do not plot data
  if (length(ed) == 0){assign("ed", 0, envir = .GlobalEnv)} # Def: do not export data
  if (length(cp) == 0){assign("cp", "f", envir = .GlobalEnv)} # Def: non-cumulative precipitation data
  if (length(pi) == 0){assign("pi", "f", envir = .GlobalEnv)} # Def: breakpoint format assumed
  if (length(ai) == 0){assign("ai", "f", envir = .GlobalEnv)} # Def: no aggregation performed
  if (length(cv) == 0){assign("cv", "0.0", envir = .GlobalEnv)} # Def: CLIGEN Version Unspecified
  if (length(sm) == 0){assign("sm", 1, envir = .GlobalEnv)} # Def: continuous simulation mode
  if (length(bf) == 0){assign("bf", 1, envir = .GlobalEnv)} # Def: breakpoint format CLI file
  if (length(wi) == 0){assign("wi", 1, envir = .GlobalEnv)} # Def: wind information provided
  if (length(ei) == 0){assign("ei", "f", envir = .GlobalEnv)} # Def: do not calculate erosion indices
  if (length(ee) == 0){assign("ee", "R2", envir = .GlobalEnv)} # Def: use the RUSLE2 energy equation
  if (length(im) == 0){assign("im", "DEFAULT", envir = .GlobalEnv)} # Def: use the default WEPPCLIFF imputation design
  if (length(io) == 0){assign("io", 100, envir = .GlobalEnv)} # Def: use up to 100 iterations
  if (length(qi) == 0){assign("qi", "f", envir = .GlobalEnv)} # Def: do not cut corners on imputation
  if (length(iv) == 0){assign("iv", "f", envir = .GlobalEnv)} # Def: do not print imputation progress
  if (length(tz) == 0){assign("tz", "GMT", envir = .GlobalEnv)} # Def: use GMT for the time zone
  if (length(rs) == 0){assign("rs", "f", envir = .GlobalEnv)} # Def: do not use recursive search
  if (length(fsp) == 0){assign("fsp", NULL, envir = .GlobalEnv)} # Def: no search pattern
  if (length(isc) == 0){assign("isc", "f", envir = .GlobalEnv)} # Def: does not ignore search case
  if (length(alt) == 0){assign("alt", "f", envir = .GlobalEnv)} # Def: alternative data provided
  if (length(pmd) == 0){assign("pmd", "f", envir = .GlobalEnv)} # Def: do not preserve missingness
  if (length(sid) == 0){assign("sid", 1, envir = .GlobalEnv)} # Def: use first storm in list
  if (length(sdt) == 0){assign("sdt", "start", envir = .GlobalEnv)} # Def: use earliest acceptable datetime
  if (length(edt) == 0){assign("edt", "end", envir = .GlobalEnv)} # Def: use latest acceptable datetime
  if (length(ipb) == 0){assign("ipb", "f", envir = .GlobalEnv)} # Def: do not ignore precipitation for rounding
  if (length(rtb) == 0){assign("rtb", "m", envir = .GlobalEnv)} # Def: do not round start and end times
  if (length(tth) == 0){assign("tth", 6, envir = .GlobalEnv)} # Def: 6-hour time (break b/w storms)
  if (length(dth) == 0){assign("dth", 1.27, envir = .GlobalEnv)} # Def: 1.27 mm depth (break b/w storms)
  if (length(qcop) == 0){assign("qcop", "b", envir = .GlobalEnv)} # Def: uses physical and empirical methods for quality control
  if (length(dtf1) == 0){assign("dtf1", "%Y-%m-%d %H:%M:%S", envir = .GlobalEnv)} # Def: a standard datetime format
  if (length(dtf2) == 0){assign("dtf2", dtf1, envir = .GlobalEnv)} # Def: same as dtf1 (input or default)
  if (length(dtf3) == 0){assign("dtf3", dtf1, envir = .GlobalEnv)} # Def: same as dtf1 (input or default)
  if (length(prof) == 0){assign("prof", "f", envir = .GlobalEnv)} # Def: production mode (as opposed to profiling mode)
  if (length(pint) == 0){assign("pint", 0.02, envir = .GlobalEnv)} # Def: time in seconds between profile sampling
  if (length(mepr) == 0){assign("mepr", "f", envir = .GlobalEnv)} # Def: exclude memory profiling
  if (length(gcpr) == 0){assign("gcpr", "f", envir = .GlobalEnv)} # Def: exclude garbage collect profiling
  if (length(lnpr) == 0){assign("lnpr", "f", envir = .GlobalEnv)} # Def: exclude line profiling
  if (length(warn) == 0){assign("warn", "f", envir = .GlobalEnv)} # Def: turn off warnings
  if (length(verb) == 0){assign("verb", "f", envir = .GlobalEnv)} # Def: verbosity off
  if (length(chkth) == 0){assign("chkth", 0.9, envir = .GlobalEnv)} # Def: check the most extreme 10% of data
  if (length(spkth) == 0){assign("spkth", 0.9, envir = .GlobalEnv)} # Def: 90% recovery indicates a spike
  if (length(strth) == 0){assign("strth", 2, envir = .GlobalEnv)} # Def: anything more than 2 consecutive identical values can be a streak
  if (length(stkth) == 0){assign("stkth", 4, envir = .GlobalEnv)} # Def: anything separated by 4 or less observations can be a stick
  if (length(delim) == 0){assign("delim", " ", envir = .GlobalEnv)}} # Def: space delimiter


# A function to halt execution for invalid arguments.
check_args = function() {
  
  # Create patterns for grep searching.
  u.patterns = paste("m", "e", collapse = "|")
  tf.patterns = paste("t", "f", collapse = "|")
  ed.patterns = paste(0:6, collapse = "|")
  sm.patterns = paste("1", "2", collapse = "|")
  bf.patterns = paste("0", "1", collapse = "|")
  wi.patterns = paste("0", "1", collapse = "|")
  mp.patterns = paste("t", "f", 1:10000, collapse = "|")
  pi.patterns = paste("f", 1:1440, collapse = "|")
  cv.patterns = paste("f", "0.0", "4.3", "5.3", collapse = "|")
  rtb.patterns = paste("m", "d", "h", "f", collapse = "|")
  
  # Perform grep searching.
  if (length(grepl(u, u.patterns, ignore.case = T)) == 0){stop("Invalid Argument: [-u] must be specified as 'm' (metric) or 'e' (english) followed by any exceptions.")}
  if (grepl(fr, tf.patterns, ignore.case = T) != T){stop("Invalid Argument: [-fr] must be specified as 't' (true) or 'f' (false).")}
  if (grepl(mp, mp.patterns, ignore.case = T) != T){stop("Invalid Argument: [-mp] must be specified as 't' (true), 'f' (false), or an integer number of cores.")}
  if (grepl(qc, tf.patterns, ignore.case = T) != T){stop("Invalid Argument: [-qc] must be specified as 't' (true) or 'f' (false).")}
  if (grepl(id, tf.patterns, ignore.case = T) != T){stop("Invalid Argument: [-id] must be specified as 't' (true) or 'f' (false).")}
  if (grepl(pd, tf.patterns, ignore.case = T) != T){stop("Invalid Argument: [-pd] must be specified as 't' (true) or 'f' (false).")}
  if (grepl(ed, ed.patterns, ignore.case = T) != T){stop("Invalid Argument: [-ed] must be specified as '0' (off), '1' (all), '2' (rds), '3-6' (precip, daily, storm or breakpoint csv).")}
  if (grepl(cp, tf.patterns, ignore.case = T) != T){stop("Invalid Argument: [-cp] must be specified as 't' (true) or 'f' (false).")}
  if (grepl(pi, pi.patterns, ignore.case = T) != T){stop("Invalid Argument: [-pi] must be specified as 'f' (false) or an integer up to 1440 (in minutes).")}
  if (grepl(ai, pi.patterns, ignore.case = T) != T){stop("Invalid Argument: [-ai] must be specified as 'f' (false) or an integer up to 1440 (in minutes).")}
  if (grepl(sm, sm.patterns, ignore.case = T) != T){stop("Invalid Argument: [-sm] must be specified as '1' (continuous) or '2' (event).")}
  if (grepl(bf, bf.patterns, ignore.case = T) != T){stop("Invalid Argument: [-bf] must be specified as '0' (daily) or '1' (breakpoint).")}
  if (grepl(wi, wi.patterns, ignore.case = T) != T){stop("Invalid Argument: [-wi] must be specified as '0' (exclude) or '1' (include).")}
  if (grepl(ei, tf.patterns, ignore.case = T) != T){stop("Invalid Argument: [-ei] must be specified as 't' (true) or 'f' (false).")}
  if (grepl(cv, cv.patterns, ignore.case = T) != T){stop("Invalid Argument: [-cv] must be specified as 'f' (false) or one of the supported CLIGEN version control numbers (0.0, 4.3, or 5.3).")}
  if (grepl(rs, tf.patterns, ignore.case = T) != T){stop("Invalid Argument: [-rs] must be specified as 't' (true) or 'f' (false).")}
  if (grepl(isc, tf.patterns, ignore.case = T) != T){stop("Invalid Argument: [-isc] must be specified as 't' (true) or 'f' (false).")}
  if (grepl(ipb, tf.patterns, ignore.case = T) != T){stop("Invalid Argument: [-ipb] must be specified as 't' (true) or 'f' (false).")}
  if (grepl(rtb, rtb.patterns, ignore.case = T) != T){stop("Invalid Argument: [-rtb] must be specified as 'm' (month), 'd' (day), 'h' (hour), or 'f' (false).")}
  if (grepl(alt, tf.patterns, ignore.case = T) != T){stop("Invalid Argument: [-alt] must be specified as 't' (true) or 'f' (false).")}
  if (grepl(pmd, tf.patterns, ignore.case = T) != T){stop("Invalid Argument: [-pmd] must be specified as 't' (true) or 'f' (false).")}
  if (toupper(ai) != "F") {if (1440 %% as.numeric(ai) > 0) {stop("Invalid Argument: [-ai]; 1440 must be perfectly divisible by the specified integer.")}}}


# A function to assign final values to arguments.
assign_final_args = function() {
  
  # Execute final assignment.
  if (toupper(pmd) == "T") {pmd <<- T}
  if (toupper(pmd) == "F") {pmd <<- F}}


# A function to load all R package dependencies.
load_packages = function() {
  t.time = system.time({
    cat("Loading R package dependencies... ")
    lapply(package.list, library, lib.loc = lib.dir, character.only = T, quietly = T, verbose = F, attach.required = T)})
  cat("Completed in", t.time[3],"seconds.", lr, lr)}


# A function to load the input file used in calculations.
load_input_file = function(f) {
  setwd(d)
  t.time = system.time({
    
    # Search for file type.
    txt = grep(".txt", f, ignore.case = T)
    tsv = grep(".tsv", f, ignore.case = T)
    csv = grep(".csv", f, ignore.case = T)
    
    # Handle common errors.
    if (sum(txt, tsv, csv) == 0) {stop("The input file does not contain an acceptable extension (.txt or .csv).")}
    if (sum(txt, tsv, csv) > 1) {stop("The input file contains more than one acceptable extension.")}
    
    # Load file otherwise.
    if (toupper(verb) == "T") {cat(lr, "Loading input file... ")}
    if (length(txt) == 1){file = suppressMessages(read_table(f, delim, col_types=cols(DT_1="c", DT_2="c", DT_3="c")))}
    if (length(tsv) == 1){file = suppressMessages(read_tsv(f, col_types=cols(DT_1="c", DT_2="c", DT_3="c")))}
    if (length(csv) == 1){file = suppressMessages(read_csv(f, col_types=cols(DT_1="c", DT_2="c", DT_3="c")))}})
  
  setwd(home.dir)
  return(file)}


# A function to check the input file format.
check_input_format = function(file) {
  file = as.data.frame(file)
  
  # Check R data conversion.
  if(is.data.frame(file) == F){stop("The input file could not be stored as a data frame.")}
  
  # Check input variables.
  oldNames = colnames(file)
  vars = c("DT_1", "PRECIP", "DT_3", "MAX_TEMP", "MIN_TEMP", "SO_RAD", "W_VEL", "W_DIR", "DP_TEMP")
  if (toupper(alt) == "T") {vars = c("DT_1", "PRECIP", "DT_2", "AIR_TEMP", "REL_HUM", "DT_3", "SO_RAD", "W_VEL", "W_DIR")}
  if (toupper(cv) == "F") {vars = c("DT_1", "PRECIP")}
  present = which(vars %in% oldNames)
  missing = vars[-present]
  if(length(missing) > 0){cat("Some expected variables are missing:", missing, "", lr, lr); stop()}
  
  return(file)}


# A function to load input files in a directory.
load_input_directory = function() {
  t.time = system.time({
    cat("Parsing input files... ")
    
    # Get list of files.
    if (toupper(rs) == "T") {rs = T}
    if (toupper(rs) == "F") {rs = F}
    if (toupper(isc) == "T") {isc = T}
    if (toupper(isc) == "F") {isc = F}
    files = dir(d, full.names = T, pattern = fsp, recursive = rs, ignore.case = isc)

    # Parse file types.
    txt = grep(".txt", files)
    tsv = grep(".tsv", files)
    csv = grep(".csv", files)
    
    # Handle errors.
    all = c(txt, tsv, csv)
    if (sum(duplicated(all)) > 0) {files = files[-all[duplicated(all)]]}})
  
  cat("Completed in", t.time[3],"seconds.", lr, lr)
  
  return(files)}


# A function to check for missing columns and pad them with NA.
preprocess_file = function(file) {
  t.time = system.time({
    if (toupper(verb) == "T") {cat(lr, "Preprocessing data... ")}
    vars = c("STATION", "LAT", "LON", "ELEV", "DT_1", "PRECIP", "DT_2", "AIR_TEMP", "REL_HUM",
             "DT_3", "MAX_TEMP", "MIN_TEMP", "SO_RAD","W_VEL", "W_DIR", "DP_TEMP")
    for (i in vars){
      logic = i %in% colnames(file)
      if (logic == F){
        old_names = colnames(file)
        file = cbind(file, NA)
        colnames(file) = c(old_names, i)}}})
  return(file)}


# A function to create the multiprocessing virtual cluster environment.
create_cluster = function(s, mp) {
  cat("Creating multiprocessing virtual cluster... ")
  
  # Determine a good number of cores to use.
  tmp = mp
  cores = detectCores()
  cores.90 = floor(cores * 0.90)
  cores.4b = cores - 4
  max.cores = max(1, cores.90, cores.4b)
  
  # Create a cluster based on user input, stations detected, and available cores.
  if (length(na.omit(as.numeric(mp))) >= 1) {max.cores = as.numeric(mp)}
  if (length(na.omit(as.numeric(mp))) == 0) {tmp = mp; mp = s}
  cluster = makeCluster(min(s, max.cores))
  registerDoParallel(cluster)
  cat("Done. Cores deployed:", min(s, max.cores), "", lr, lr)
  mp = tmp}


# A function to store data for processing.
store_data = function(file) {
  if (toupper(verb) == "T") {cat(lr,"Storing in memory...")}
  
  # Convert to dataframe and read variables.
  file = as.data.frame(file[[1]], stringsAsFactors = F)
  long.vars = c("DT_1", "PRECIP", "DT_2", "AIR_TEMP", "REL_HUM", "DT_3", "MAX_TEMP", "MIN_TEMP", "SO_RAD","W_VEL", "W_DIR", "DP_TEMP")
  short.vars = c("STATION", "LAT", "LON", "ELEV", "OBS_YRS", "B_YR", "YRS_SIM")
  
  # Store time series variables.
  for (j in long.vars){
    if (is.null(file[[j]]) == T){assign(j, NA)}
    if (is.null(file[[j]]) == F){assign(j, file[[j]])}}
  
  # Store scalars.
  for (j in short.vars){
    if (is.null(file[[j]]) == T){assign(j, NA)}
    if (is.null(file[[j]]) == F){assign(j, file[[j]][1])}}
  
  # Create the primary data structure and fill.
  data = list()
  data[[1]] = data.frame(DT_1, PRECIP)
  data[[2]] = data.frame(DT_2, AIR_TEMP, REL_HUM)
  data[[3]] = data.frame(DT_3, MIN_TEMP, MAX_TEMP, SO_RAD, W_VEL, W_DIR, DP_TEMP)
  data[[4]] = c(STATION, LAT, LON, ELEV, OBS_YRS, B_YR, YRS_SIM)
  names(data[[4]]) = short.vars
  
  return(data)}


# A function to change type to dataframe and class to numeric.
convert_data = function(data) {
  if (toupper(verb) == "T") {cat(lr,"Converting data format...")}
  for (j in 1:3){
    data[[j]] = as.data.frame(data[[j]], stringsAsFactors = F)
    data[[j]] = convert_df_type(data[[j]], 2:ncol(data[[j]]), "ftn")}
  return(data)}


# A function to remove dataframe rows with no datetime.
remove_missing_datetime_rows = function(data) {
  for (j in 1:3) {data[[j]] = data[[j]][!is.na(data[[j]][,1]),]}
  return(data)}


# A function to find and replace missing or unuseable data values.
preserve_missing_data = function(data, group) {
  for (j in group) {data[[j]] = df_find_replace(df = data[[j]], cols = 2:ncol(data[[j]]), find = T, null = T, nan = T, na = T, inf = T, vals = -99999, replace = NA)}
  return(data)}


# A function to change columns in a dataframe to numeric or character.
convert_df_type = function(df, cols, type) {
  if (type == "c" | type == "ftn") {for (j in cols) {df[,j] = as.character(df[,j])}}
  if (type == "n" | type == "ftn") {for (j in cols) {df[,j] = as.numeric(df[,j])}}
  return(df)}


# A function to find and replace values in a dataframe.
df_find_replace = function(df, cols, find, null, nan, na, inf, vals, replace) {
  for (j in cols) {df[,j] = vec_find_replace(vec = df[,j], find = find, null = null, nan = nan, na = na, inf = inf, vals = vals, replace = replace)}
  return(df)}


# A function to find and replace values in a vector.
vec_find_replace = function(vec, find, inf, null, nan, na, vals, replace) {
  
  # Set conditions.
  if (length(null) == 0) {null = F}
  if (length(find) == 0) {find = F}
  if (length(inf) == 0) {inf = F}
  if (length(nan) == 0) {nan = F}
  if (length(na) == 0) {na = F}
  
  # Execute.
  if (null == T) {vec[is.null(vec)] = replace}
  if (find == T) {vec[vec %in% vals] = replace}
  if (inf == T) {vec[is.infinite(vec)] = replace}
  if (nan == T) {vec[is.nan(vec)] = replace}
  if (na == T) {vec[is.na(vec)] = replace}
  
  return(vec)}


# A function to calculate duration data.
create_duration_data = function(data, x) {
  if (toupper(verb) == "T") {cat(lr,"Analyzing data intervals...")}
  
  # Loop over each of the variable groups.
  dt_list = c("DT_1", "DT_2", "DT_3")
  dtf_list = c(dtf1, dtf2, dtf3)
  
  # Loop over each variable grouping.
  for (j in x){
    
    # Convert to datetime (POSIX Count).
    if (length(na.omit(data[[j]][[dt_list[j]]])) == 0) {stop("Datetime data may not be handled correctly. Please check the input file(s) and arguments.")}
    if (length(na.omit(data[[j]][[dt_list[j]]])) > 0) {
      data[[j]][[dt_list[j]]] = format(as.POSIXct(gsub("T|Z", " ", as.character(data[[j]][[dt_list[j]]])), format = dtf_list[j]), format = "%Y-%m-%d %H:%M:%S")
      data[[j]] = data[[j]][complete.cases(data[[j]][,1]),]}

    # Handle precipitation and non-precipitation breaks.
    if (j == 1) {
      
      # Convert fixed format to breakpoint format if appropriate.
      if (toupper(pi) != "F") {
        precip.interval = as.numeric(pi)
        new.dates = as.POSIXct(data[[j]][[dt_list[j]]]) - (60 * precip.interval)
        rmv.dates = which(new.dates %in% data[[j]][[dt_list[j]]])
        if (length(rmv.dates) > 0) {
          add.dates = new.dates[-rmv.dates]
          zeroes = c(rep(0, length(add.dates)))
          new.rows = data.frame(add.dates, zeroes)
          names(new.rows) = c("DT_1", "PRECIP")
          data[[j]] = rbind(data[[j]], new.rows)
        }
      }
    }
    
    # Sort data.
    data[[j]] = data[[j]][order(data[[j]][[dt_list[j]]]),]

    # Calculate time differences in minutes.
    dif = difftime(tail(data[[j]][[dt_list[j]]], -1), head(data[[j]][[dt_list[j]]], -1), units = "mins")
    dif = as.numeric(dif)
    dif = c(dif[1], dif)
    data[[j]]$DUR = dif
    data[[j]][[dt_list[j]]] = as.POSIXlt(data[[j]][[dt_list[j]]])}
  
  # Keep only positive precipitation values and potential storm starts.
  p_rows = which(data[[1]]$PRECIP != 0)
  z_rows = which(data[[1]]$PRECIP == 0)
  s_rows = p_rows-1
  b_rows = intersect(z_rows, s_rows)
  data[[1]] = data[[1]][union(p_rows, b_rows),]
  data[[1]] = data[[1]][order(data[[1]]$DT_1),]
  
  # Modify midnight breakpoint crossings.
  data[[1]] = modify_midnight_breakpoints(df = data[[1]], dtf = dtf1)
  
  return(data)}


# A function to modify breakpoints that cross midnight.
modify_midnight_breakpoints = function(df, dtf) {
  
  # Calculate time from midnight.
  df$TFM = sapply(as.POSIXlt(as.character(df$DT_1), format = dtf), function(x) x$hour * 60 + x$min  + x$sec / 60)

  # Compare time from midnight to break duration.
  dif.vec = df$TFM - df$DUR
  
  # Keep crosses only if precipitation is occurring.
  crosses = intersect(which(dif.vec < 0), which(df$PRECIP > 0))
  
  # Calculate new midnight break chracteristics.
  pcp.frac = -dif.vec[crosses] / df$DUR[crosses]
  pcp.new = pcp.frac * df$PRECIP[crosses]
  dt.new = format(as.POSIXlt(as.POSIXct(df$DT_1[crosses]) - df$TFM[crosses] * 60), "%Y-%m-%d %H:%M:%S")
  dur.new = df$DUR[crosses] - df$TFM[crosses]
  
  # Reduce the original precipitation after the midnight break
  df$PRECIP[crosses] = df$PRECIP[crosses] - pcp.new
  df$DUR[crosses] = df$DUR[crosses] - dur.new
  
  # Remove the TFM column.
  df = df[,-4]
  
  # Create a new dataframe with midnight breakpoints.
  df.new = data.frame(dt.new, pcp.new, dur.new)
  names(df.new) = names(df)

  # Combine dataframes.
  df.out = rbind(df, df.new)
  df.out = df.out[order(df.out$DT_1),]
  
  return(df.out)}


# A function to aggregate precipitation breakpoints to a specific interval.
aggregate_precip_data = function(data) {
  
  # Subset Precipitation Dataframe
  df = data[[1]]
  
  # Create Columns for Clustering
  minDate = as.Date(substr(min(df$DT_1), 1, 10))
  maxDate = as.Date(substr(max(df$DT_1), 1, 10))
  df$Year = as.numeric(substr(df$DT_1, 1, 4))
  df$Month = as.numeric(substr(df$DT_1, 6, 7))
  df$Day = as.numeric(substr(df$DT_1, 9, 10))
  df$Hour = as.numeric(substr(df$DT_1, 12, 13))
  df$Minute = as.numeric(substr(df$DT_1, 15, 16))
  df$Cluster = (df$Hour*60 + df$Minute) %/% as.numeric(ai)
  
  # Aggregate Data
  aggDF = aggregate(PRECIP ~ Year + Month + Day + Cluster, data = df, function(x) sum(x, na.rm = T))
  aggDF$Cluster = aggDF$Cluster*as.numeric(ai)
  aggDF$Hour = aggDF$Cluster%/%60
  aggDF$Minute = aggDF$Cluster - aggDF$Hour*60
  aggDF$DT_1 = as.POSIXct(paste(aggDF$Year, "-", aggDF$Month, "-", aggDF$Day, " ", formatC(aggDF$Hour, width = 2, format = "d", flag = "0"), ":", formatC(aggDF$Minute, width = 2, format = "d", flag = "0"), ":00", sep = ""), format = "%Y-%m-%d %H:%M:%S")
  aggDF$DT_2 = aggDF$DT_1 - as.numeric(ai)*60
  
  # Reformat Output
  outDF = data.frame(sort(unique(c(aggDF$DT_1, aggDF$DT_2))))
  names(outDF) = c("DT_1")
  outDF = merge(outDF, aggDF[,c(5,8)], by = c("DT_1"), all = T)
  outDF$DUR = as.numeric(ai)
  outDF$PRECIP[is.na(outDF$PRECIP)] = 0
  data[[1]] = outDF
  
  return(data)
}


# A function to convert units from English to metric.
convert_units = function(data) {
  if (toupper(verb) == "T") {cat(lr,"Converting units...")}
  var.list = c("PRECIP", "AIR_TEMP", "MAX_TEMP", "MIN_TEMP", "SO_RAD", "W_VEL", "DP_TEMP", "ELEV")
  
  # Parse arguments.
  if (length(u.loc) == 0){vars = NULL}
  if (length(u.loc) > 0){
    x = grep("-", args)
    x = x[x >= u.loc]
    start = x[1]+2
    end = min(x[2]-1, max(length(args)), na.rm = T)
    vars = toupper(args[start:end])
    if (start > end){vars = NA}}
  
  # Handle solar radiation (which must be in english units as opposed to metric units).
  if (length(grep("SO_RAD", vars, ignore.case = T)) > 0){vars = vars[!grepl("SO_RAD", vars, ignore.case = T)]}
  else {vars = na.omit(c(vars, "SO_RAD"))}
  
  # Handle missing elevation data.
  if (is.na(data[[4]][["ELEV"]]) == T) {data[[4]][["ELEV"]] = "0"}
  if (as.numeric(data[[4]][["ELEV"]]) == -99999) {data[[4]][["ELEV"]] = "0"}
  
  # Most or all units are metric (convert exceptions).
  if (toupper(u) == "M"){}
  
  # Most or all units are english (do not convert exceptions).
  if (length(vars) == 0){vars = NA}
  if (toupper(u) == "E"){vars = var.list[!grepl(paste(vars, collapse = "|"), var.list, ignore.case = T)]}
  
  # Perform simple conversions.
  if ("PRECIP" %in% vars){data[[1]]$PRECIP = data[[1]]$PRECIP*25.4} # Conversion from in to mm
  if ("MAX_TEMP" %in% vars){data[[3]]$MAX_TEMP = (data[[3]]$MAX_TEMP - 32) * 5/9} # Conversion from F to C
  if ("MIN_TEMP" %in% vars){data[[3]]$MIN_TEMP = (data[[3]]$MIN_TEMP - 32) * 5/9} # Conversion from F to C
  if ("AIR_TEMP" %in% vars){data[[2]]$AIR_TEMP = (data[[2]]$AIR_TEMP - 32) * 5/9} # Conversion from F to C
  if ("DP_TEMP" %in% vars){data[[3]]$DP_TEMP = (data[[3]]$DP_TEMP - 32) * 5/9} # Conversion from F to C
  if ("SO_RAD" %in% vars){data[[3]]$SO_RAD = data[[3]]$SO_RAD * data[[3]]$DUR * 60 / 41840} # Conversion from W/m^2 to Langleys
  if ("W_VEL" %in% vars){data[[3]]$W_VEL = data[[3]]$W_VEL * 0.44704} # Conversion from mph to m/s
  if ("ELEV" %in% vars & length(na.omit(data[[4]][["ELEV"]])) > 0){ # Make sure elevation was provided
    data[[4]][["ELEV"]] = as.numeric(data[[4]][["ELEV"]]) * 0.3048} # Conversion from ft to m
  
  # Replace missing metadata with zero values.
  if (is.na(data[[4]][["STATION"]])) {data[[4]][["STATION"]] = "STATION"}
  if (is.na(data[[4]][["LAT"]])) {data[[4]][["LAT"]] = "0"}
  if (is.na(data[[4]][["LON"]])) {data[[4]][["LON"]] = "0"}
  if (is.na(data[[4]][["ELEV"]])) {data[[4]][["ELEV"]] = "0"}
  
  return(data)}


# A function to initialize quality checking data.
initialize_qc_data = function(data) {
  for (j in 1:3) {data[[j + 4]] = data[[j]]}
  return(data)}


# A function to check input data quality.
quality_check_inputs = function(data) {
  if (toupper(verb) == "T") {cat(lr,"Checking input data quality...")}
  chkth = as.numeric(chkth)
  spkth = as.numeric(spkth)
  strth = as.numeric(strth)
  stkth = as.numeric(stkth)
  data = create_rate_qc_data(data)
  data = run_nonprecip_checks(data)
  data = run_precip_checks(data)
  data = remove_qc_fails(data)
  return(data)}


# A function to extract rates from breakpoint format data.
create_rate_qc_data = function(data) {
  
  # Set variable name and location vectors.
  nm = c("PRECIP", "AIR_TEMP", "REL_HUM", "MIN_TEMP", "MAX_TEMP", "SO_RAD", "W_VEL", "W_DIR", "DP_TEMP")
  r.loc = c(5, 6, 6, 7, 7, 7, 7, 7, 7)
  
  # Use variable data and duration data to determine rates of change.
  for (j in 1:length(nm)) {
    VAR = data[[r.loc[j]]][[nm[j]]]
    DUR = data[[r.loc[j]]]$DUR
    DEL = c(0, diff(VAR))
    if (length(DEL) == length(VAR)) {data[[r.loc[j]]][[paste(nm[j], "_DEL", sep = "")]] = DEL}
    data[[r.loc[j]]][[paste(nm[j], "_QC", sep = "")]] = rep("PASS", length(VAR))}
  
  return(data)}


# A function to impose non-precipitation quality checks on the data.
run_nonprecip_checks = function(data) {
  
  # Set variable name, limit, and location vectors.
  nm = c("PRECIP", "AIR_TEMP", "REL_HUM", "MIN_TEMP", "MAX_TEMP", "SO_RAD", "W_VEL", "W_DIR", "DP_TEMP")
  i.uv.lims = c(2000, 70, 1000, 45, 60, 2865, 120, 360, 40)
  i.lv.lims = c(0, -100, 0, -90, -20, 0, 0, 0, -25)
  i.r.lims = c(35, 1, 1, 1, 1, 30, 1, 360, 1)
  i.loc = c(5, 6, 6, 7, 7, 7, 7, 7, 7)
  fnm = paste(nm, "_DEL", sep = "")
  qcnm = paste(nm, "_QC", sep = "")
  
  # Record QC failures.
  for (j in 2:length(nm)) {
    if (nrow(data[[i.loc[j]]]) > 0) {
      dur.vec = data[[i.loc[j]]]$DUR
      var.vec = data[[i.loc[j]]][[nm[j]]]
      del.vec = data[[i.loc[j]]][[fnm[j]]]
      rat.vec = del.vec / dur.vec
      qcr.vec = data[[i.loc[j]]][[qcnm[j]]]
      
      # Perform physical quality checking.
      if (toupper(qcop) %in% c("B", "P")) {
        qcr.vec = extreme_limit_test(var.vec, qcr.vec, i.uv.lims[j], i.lv.lims[j], "VALUE")
        qcr.vec = extreme_limit_test(rat.vec, qcr.vec, i.r.lims[j], -i.r.lims[j], "RATE")}
      
      # Perform empirical quality checking
      if (toupper(qcop) %in% c("B", "E")) {
        qcr.vec = rle_streak_test(var.vec, qcr.vec, strth, "STREAK")
        qcr.vec = snr_spike_test(dur.vec, del.vec, rat.vec, qcr.vec, chkth, spkth, "SPIKE")
        qcr.vec = rle_stick_test(qcr.vec, stkth, "STICK")}
      
      # Store results.
      data[[i.loc[j]]][[qcnm[j]]] = qcr.vec}}
  
  return(data)}


# A function to record extreme values from a data vector in a data quality vector.
extreme_limit_test = function(data.vec, qcr.vec, upper.limit, lower.limit, flag) {
  num.loc = !is.na(data.vec)
  if (sum(num.loc) > 0) {
    qcr.vec[num.loc][data.vec[num.loc] > upper.limit] = flag
    qcr.vec[num.loc][data.vec[num.loc] < lower.limit] = flag}
  return(qcr.vec)}


# A function to record streaks from a data vector in a data quality vector.
rle_streak_test = function(data.vec, qcr.vec, str.th, flag) {
  rle.data = rle(data.vec)
  loc.data = cumsum(rle.data$lengths)
  streak.intersect = which(rle.data$lengths >= str.th)
  streak.ends = loc.data[streak.intersect]
  streak.lengths = rle.data$lengths[streak.intersect]
  streak.begins = streak.ends - (streak.lengths - 1)
  streaks = unlist(mapply(function(x, y) x:y, streak.begins, streak.ends))
  qcr.vec[streaks] = flag
  return(qcr.vec)}


# A function to record spikes from a data vector in a data quality vector.
snr_spike_test = function(dur.vec, del.vec, rat.vec, qcr.vec, chk.th, spk.th, flag) {
  
  # Perform basic calculations and setup.
  noise = var(rat.vec, na.rm = T)
  snr.vec = abs(rat.vec) / noise
  lcrit = length(snr.vec)
  crit.diff = 1 - spk.th
  
  # Limit how much data to check.
  short.dur = which(dur.vec <= 360)
  high.dels = which(abs(del.vec) > quantile(abs(del.vec), chk.th, na.rm = T))
  high.rats = which(abs(rat.vec) > quantile(abs(rat.vec), chk.th, na.rm = T))
  high.snrs = which(snr.vec > quantile(snr.vec, chk.th, na.rm = T))
  highs = Reduce(intersect, list(short.dur, high.dels, high.rats, high.snrs))
  if (lcrit %in% highs) {highs = highs[-which(highs == lcrit)]}
  
  # Continue calculations.
  heads = rat.vec[highs]
  tails = rat.vec[highs + 1]
  norm.diff = abs(heads + tails) / (abs(heads) + abs(tails))
  results = norm.diff < crit.diff
  qcr.vec[results] = flag
  
  return(qcr.vec)}


# A function to record sticks from a data quality vector in a data quality vector.
rle_stick_test = function(qcr.vec, stk.th, flag) {
  
  # Setup rle analysis.
  rle.data = rle(qcr.vec)
  loc.data = cumsum(rle.data$lengths)
  short.lengths = which(rle.data$lengths <= stk.th)
  qcr.passes = which(rle.data$values == "PASS")
  qcr.checks = intersect(short.lengths, qcr.passes)
  
  # Check potential sticks.
  if (length(qcr.checks) > 0) {
    qcr.starts = qcr.checks - 1
    qcr.ends = qcr.checks + 1
    qcr.identical = which(rle.data$values[qcr.starts] == rle.data$values[qcr.ends])
    
    # Record actual sticks.
    if (length(qcr.identical) > 0) {
      qcr.vec[loc.data[qcr.checks[qcr.identical]]] = flag}}
  
  return(qcr.vec)}


# A function to impose precipitation quality checks on the data.
run_precip_checks = function(data) {
  var.vec = data[[5]][["PRECIP"]]
  
  # Perform empirical quality checking
  if (toupper(qcop) %in% c("B", "E")) {
    data[[5]][["PRECIP_QC"]] = return_period_test(var.vec, data[[5]][["PRECIP_QC"]], rp, "RARE")}
  
  return(data)}


# A function to handle quality checking failures.
return_period_test = function(data.vec, qcr.vec, max.return.period, flag) {
  return(qcr.vec)}


# A function to handle quality checking failures.
remove_qc_fails = function(data) {
  
  # Set variable name and location vectors.
  nm = c("PRECIP", "AIR_TEMP", "REL_HUM", "MIN_TEMP", "MAX_TEMP", "SO_RAD", "W_VEL", "W_DIR", "DP_TEMP")
  i.loc = c(5, 6, 6, 7, 7, 7, 7, 7, 7)
  qcnm = paste(nm, "_QC", sep = "")
  
  # Replace QC failures.
  for (j in 1:length(nm)) {
    if (nrow(data[[i.loc[j]]]) > 0) {
      var.vec = data[[i.loc[j]]][[nm[j]]]
      qcr.vec = data[[i.loc[j]]][[qcnm[j]]]
      var.vec[qcr.vec != "PASS"] = NA
      data[[i.loc[j]]][[nm[j]]] = var.vec}}
  
  return(data)}


# A function to check output daily data quality.
quality_check_outputs = function(data, dly.df) {
  if (toupper(verb) == "T") {cat(lr,"Checking output data quality...")}
  data = impose_daily_value_limits(data, dly.df)
  return(data)}


# A function to impose physical limitations on data.
impose_daily_value_limits = function(data, dly.df) {
  
  # Set daily value limits.
  d.u.lims = c(2000, 60, 500, 45, 60, 1432, 60, 360, 40)
  d.l.lims = c(0, -90, 0, -90, -20, 1, 0, 0, -25)
  
  # Set names.
  nm = c("PRECIP", "AIR_TEMP", "REL_HUM", "MIN_TEMP", "MAX_TEMP", "SO_RAD", "W_VEL", "W_DIR", "DP_TEMP")
  names(d.u.lims) = nm
  names(d.l.lims) = nm
  
  # Replace extreme values with NA.
  for (j in nm) {data[[dly.df]][[j]] = extreme_limit_replace(data[[dly.df]][[j]], d.u.lims[[j]], d.l.lims[[j]], NA)}
  
  return(data)}


# A function to record extreme value failures in a vector.
extreme_limit_replace = function(data.vec, upper.limit, lower.limit, flag) {
  num.loc = !is.na(data.vec)
  if (sum(num.loc) > 0) {
    data.vec[num.loc][data.vec[num.loc] > upper.limit] = flag
    data.vec[num.loc][data.vec[num.loc] < lower.limit] = flag}
  return(data.vec)}


# A function to obtain an acceptable period of data (sm = 1) or storm event (sm = 2).
trim_data = function(data, precip.ts.df, alt.ts.df, d.ts.df, event.list) {
  if (toupper(verb) == "T") {cat(lr,"Trimming to specified time period...")}
  
  # General Setup
  data = break_storms(data, precip.ts.df, event.list)
  
  # Use all variables for time bounds.
  if (toupper(alt) == "T" & toupper(ipb) == "F" & toupper(cv) != "F"){
    maxs = c(max(data[[precip.ts.df]]$DT_1, na.rm = T), max(data[[alt.ts.df]]$DT_2, na.rm = T), max(data[[d.ts.df]]$DT_3, na.rm = T))
    mins = c(min(data[[precip.ts.df]]$DT_1, na.rm = T), min(data[[alt.ts.df]]$DT_2, na.rm = T), min(data[[d.ts.df]]$DT_3, na.rm = T))}
  
  # Exclude only alternative variables for time
  if (toupper(alt) == "F" & toupper(ipb) == "F" & toupper(cv) != "F"){
    maxs = c(max(data[[precip.ts.df]]$DT_1, na.rm = T), max(data[[d.ts.df]]$DT_3, na.rm = T))
    mins = c(min(data[[precip.ts.df]]$DT_1, na.rm = T), min(data[[d.ts.df]]$DT_3, na.rm = T))}
  
  # Exclude only precipitation variables for time bounds.
  if (toupper(alt) == "T" & toupper(ipb) == "T" & toupper(cv) != "F"){
    maxs = c(max(data[[alt.ts.df]]$DT_2, na.rm = T), max(data[[d.ts.df]]$DT_3, na.rm = T))
    mins = c(min(data[[alt.ts.df]]$DT_2, na.rm = T), min(data[[d.ts.df]]$DT_3, na.rm = T))}
  
  # Use only daily variables for time bounds.
  if (toupper(alt) == "F" & toupper(ipb) == "T" & toupper(cv) != "F"){
    maxs = c(max(data[[d.ts.df]]$DT_3, na.rm = T))
    mins = c(min(data[[d.ts.df]]$DT_3, na.rm = T))}  
  
  # Use only precipitation variables for time bounds.
  if (toupper(cv) == "F"){
    maxs = c(max(data[[precip.ts.df]]$DT_1, na.rm = T))
    mins = c(min(data[[precip.ts.df]]$DT_1, na.rm = T))}
  
  # Record Bounds
  start = max(mins, na.rm = T)
  end = min(maxs, na.rm = T)

  # Trim data to exact bounds based on user inputs.
  if (toupper(alt) == "T") {groups = 5:7}
  if (toupper(alt) == "F") {groups = c(5, 7)}
  if (toupper(cv) == "F") {groups = 5}
  bounds = time_bounds(start, end)
  dt_list = c("DT_1", "DT_2", "DT_3")
  
  for (j in groups){
    data[[j]] = data[[j]][data[[j]][[dt_list[j - 4]]] >= bounds[1],]
    data[[j]] = data[[j]][data[[j]][[dt_list[j - 4]]] <= bounds[2],]}
  
  # Store expected number of days for final checking.
  daysCount <<- difftime(bounds[2], bounds[1], units = "days")
  
  # Record station observation data.
  data[[4]][["B_YR"]] = format(bounds[1], format = "%Y")
  data[[4]][["OBS_YRS"]] = as.numeric(diff.Date(c(bounds[3], bounds[4])))/365.2425
  data[[4]][["YRS_SIM"]] = as.numeric(diff.Date(c(bounds[1], bounds[2])))/365.2425
  
  return(data)}


# A function to calculate breaks between storms.
break_storms = function(data, in.index, out.index) {
  if (toupper(verb) == "T") {cat(lr,"Separating storms...")}
  data[[in.index]] = data[[in.index]][complete.cases(data[[in.index]]$PRECIP),]
  data[[in.index]] = cum_to_inc(data[[in.index]])
  data[[in.index]] = identify_storms(data[[in.index]])
  if (toupper(ei) == "T"){data[[in.index]] = int_30m(data[[in.index]])}
  data[[out.index]] = split(data[[in.index]], data[[in.index]]$SID)
  return(data)}


# A function to convert cumulative precipitation data to incremental data.
cum_to_inc = function(df) {
  if (toupper(cp) == "T"){
    if (toupper(verb) == "T") {cat(lr,"Converting to incremental precipitation...")}
    difs = c(0, diff(as.numeric(df$PRECIP)))
    difs[which(difs < 0)] = df$PRECIP[which(difs < 0)]
    df$PRECIP = as.numeric(difs)}
  zeros = which(df$PRECIP == 0)
  if (length(zeros) > 0){df = df[-zeros,]}
  df$INT = df$PRECIP / (df$DUR / 60)
  return(df)}


# A function to identify storm events.
identify_storms = function(df) {
  
  # Create antecedent and cumulative time counts.
  dif = c(df$DUR[1], difftime(tail(df$DT_1, -1), head(df$DT_1, -1), units = "mins"))
  df$ANT = dif
  df$BTW = df$ANT - df$DUR
  df$CUM = cumsum(df$ANT)
  
  # Determine connectivity.
  df = evaluate_connectivity(df)
  
  # Increase event count unless connected.
  d.logic = c(1, as.numeric(!(tail(df$D_CON, length(df$D_CON) - 1) * head(df$D_CON, length(df$D_CON) - 1))))
  t.logic = as.numeric(df$T_CON)
  e.logic = as.numeric(d.logic == 1 | t.logic == 1)
  e.id = cumsum(e.logic)
  
  # Save and return results.
  df$SID = e.id
  return(df)}


# A function to evaluate storm event connectivity.
evaluate_connectivity = function(df) {
  
  # Determine rows for more optimal performance (by subsetting).
  minutes = as.numeric(tth) * 60
  rows = ceiling(minutes / min(df$DUR[df$DUR > 0], na.rm = T))
  
  # Determine storm connectivity.
  df$SUM_BEF_TTH = smart_window_sum(df$CUM, df$PRECIP, df$DUR, rows, "reverse", minutes)
  df$SUM_AFT_TTH = smart_window_sum(df$CUM, df$PRECIP, df$DUR, rows, "forward", minutes)
  df$D_CON = (df$SUM_BEF_TTH >= as.numeric(dth) | df$SUM_AFT_TTH >= as.numeric(dth))
  df$T_CON = df$BTW >= minutes
  return(df)}


# A function to calculate 30-minute intensities.
int_30m = function(df) {
  if (toupper(verb) == "T") {cat(lr,"Calculating 30-minute intensities...")}
  
  # Determine rows for more optimal performance (by subsetting).
  minutes = 30
  rows = ceiling(minutes / min(df$DUR[df$DUR > 0], na.rm = T))
  
  # Determine storm connectivity.
  df$INT_BEF_30 = smart_window_sum(df$CUM, df$PRECIP, df$DUR, rows, "reverse", minutes) * 2
  df$INT_AFT_30 = smart_window_sum(df$CUM, df$PRECIP, df$DUR, rows, "forward", minutes) * 2
  
  # Save and return 30-minute intensity calculations.
  return(df)}


# A function to sum a fixed time window over variable rows of data time.
smart_window_sum = function(cum.vec, sum.vec, dur.vec, rows, direction, threshold) {
  
  # Loop over each breakpoint.
  sum.out = rep(NA, length(cum.vec))
  for (j in 1:length(cum.vec)) {#30){#
    
    # Subset by optimal row count first.
    window = c(max(j - rows, 1, na.rm = T):min(j + rows, length(cum.vec), na.rm = T))
    dur.cut = dur.vec[window]
    cum.cut = cum.vec[window]
    sum.cut = sum.vec[window]
    
    # Set directional conditions for reverse.
    if (direction == "reverse") {
      now = cum.vec[j]
      lim = max(-1, now - threshold, na.rm = T)
      aft = cum.cut > lim
      bef = cum.cut <= now}
    
    # Set directional conditions for forward.
    if (direction == "forward") {
      now = cum.vec[j] - dur.vec[j]
      lim = now + threshold
      aft = cum.cut > now
      bef = (cum.cut - dur.cut) < lim}
    
    # Subset by actual start and end (include crossings).
    win.log = as.logical(bef * aft)
    cum.cut = cum.cut[win.log]
    dur.cut = dur.cut[win.log]
    sum.cut = sum.cut[win.log]
    
    # Split window crossing amounts and sum.
    if (direction == "reverse") {
      edge = 1
      sum.var = sum(sum.cut, na.rm = T)
      cross = lim - (cum.cut[edge] - dur.cut[edge])
      if (cross > 0) {
        adj.var = sum.cut[edge] * cross / dur.cut[edge]
        sum.var = sum.var - adj.var}}
    
    if (direction == "forward") {
      edge = length(cum.cut)
      sum.var = sum(sum.cut, na.rm = T)
      if (edge > 0){
        cross = cum.cut[edge] - lim
        if (cross > 0) {
          adj.var = sum.cut[edge] * cross / dur.cut[edge]
          sum.var = sum.var - adj.var}}}
    
    # Return the summed variable.
    sum.out[j] = sum.var}
  
  return(sum.out)}


# A function to find an acceptable calendar year start and end datetime.
time_bounds = function(start, end) {
  
  # Get the first time or user start time if later.
  if (toupper(sdt) == "START"){first.dt = start}
  if (toupper(sdt) != "START"){first.dt = strptime(sdt, format = dtf1)}
  
  # Get the last time or user end time if earlier.
  if (toupper(edt) == "END"){last.dt = end}
  if (toupper(edt) != "END"){last.dt = strptime(edt, format = dtf1)}
  
  # Determine bounds if continuous simulation is specified.
  if (sm == 1) {
    good.start = start_of_year(first.dt)
    good.end = end_of_year(last.dt)
    bounds = c(good.start, good.end, first.dt, last.dt)
    if (good.start > good.end){stop(lr, lr, "Insufficient Data: At least one full calendar year must be available with your DATETIME CONTROL ARGUMENTS.", lr, lr, collapse = "")}}
  
  # Determine bounds if event simulation is specified.
  if (sm == 2) {
    good.start = start_of_day(first.dt)
    good.end = end_of_day(last.dt)
    bounds = c(good.start, good.end, first.dt, last.dt)
    if (good.start > good.end) {stop(lr, lr, "Insufficient Data: At least one precipitation event and daily data for the same day must be available with your DATETIME CONTROL ARGUMENTS.", lr, lr, collapse = "")}}
  
  return(bounds)}


# A function to find the exact beginning of the next full calendar year.
start_of_year = function(date) {
  
  # Determine the actual start and setup rounded times.
  real.start = as.POSIXlt(date, format = dtf1)
  good.start = real.start
  month.start = real.start
  day.start = real.start
  hour.start = real.start
  
  # Determine a good start for the complete data.
  good.start$mon = 0
  good.start$mday = 1
  good.start$hour = 0
  good.start$min = 0
  good.start$sec = 0
  
  # Check for January data.
  month.start$mon = 1
  month.start$mday = 1
  month.start$hour = 0
  month.start$min = 0
  month.start$sec = 0
  
  # Round to the start of the first day of complete data.
  day.start$hour = 0
  day.start$min = 0
  day.start$sec = 0
  
  # Round to the start of the first hour of complete data.
  hour.start$min = 0
  hour.start$sec = 0
  
  # Round the ending date based on user input.
  if (toupper(rtb) == "M") {if (real.start > month.start) {good.start$year = good.start$year + 1}}
  if (toupper(rtb) == "D") {if (day.start > good.start) {good.start$year = good.start$year + 1}}
  if (toupper(rtb) == "H") {if (hour.start > good.start) {good.start$year = good.start$year + 1}}
  if (toupper(rtb) == "F") {if (real.start > good.start) {good.start$year = good.start$year + 1}}
  
  return(good.start)}


# A function to find the exact beginning of the next full calendar year.
start_of_day = function(date) {
  
  # Determine the actual start and setup rounded times.
  real.start = as.POSIXlt(date, format = dtf1)
  good.start = real.start

  # Determine a good start for the complete data.
  good.start$hour = 0
  good.start$min = 0
  good.start$sec = 0
  
  return(good.start)}


# A function to find the exact end of the last full calendar year.
end_of_year = function(date) {
  
  # Determine the actual end and setup rounded times.
  real.end = as.POSIXlt(date, format = dtf1)
  good.end = real.end
  month.end = real.end
  day.end = real.end
  hour.end = real.end
  
  # Determine a good end for the complete data.
  good.end$mon = 11
  good.end$mday = 31
  good.end$hour = 23
  good.end$min = 59
  good.end$sec = 59
  
  # Check for december data.
  month.end$mon = 10
  month.end$mday = 30
  month.end$hour = 23
  month.end$min = 59
  month.end$sec = 59
  
  # Round to the end of the last day of complete data.
  day.end$hour = 23
  day.end$min = 59
  day.end$sec = 59
  
  # Round to the end of the last hour of complete data.
  hour.end$min = 59
  hour.end$sec = 59
  
  # Round the ending date based on user input.
  if (toupper(rtb) == "M") {if (real.end < month.end) {good.end$year = good.end$year - 1}}
  if (toupper(rtb) == "D") {if (day.end < good.end) {good.end$year = good.end$year - 1}}
  if (toupper(rtb) == "H") {if (hour.end < good.end) {good.end$year = good.end$year - 1}}
  if (toupper(rtb) == "F") {if (real.end < good.end) {good.end$year = good.end$year - 1}}
  
  return(good.end)}


# A function to find the exact end of the last full calendar year.
end_of_day = function(date) {
  
  # Determine the actual end and setup rounded times.
  real.end = as.POSIXlt(date, format = dtf1)
  good.end = real.end

  # Determine a good end for the complete data.
  good.end$hour = 23
  good.end$min = 59
  good.end$sec = 59
  
  return(good.end)}


# A function to calculate erosion indices.
calculate_erosion_indices = function(data, storm.list, storm.df) {
  if (toupper(verb) == "T") {cat(lr,"Calculating erosion indices...")}
  
  # Parse arguments for user specified equation.
  x.1 = which(args %in% c("ALL", "all"))
  x.2 = which(args %in% c("USER", "user"))
  x = c(x.1, x.2)
  user_input = NA
  if (length(x) > 0){user_input = args[x + 1]}
  
  # Set energy equations: i is intensity in mm/hr.
  AH282 = parse(text = "0.119 + 0.0873 * log10(i)")
  AH537 = parse(text = "0.119 + 0.0873 * log10(i)")
  AH703 = parse(text = "0.119 + 0.0873 * log10(i)")
  BF = parse(text = "0.29 * (1 - 0.72 * exp(-0.05 * i))")
  MM = parse(text = "0.273 + 0.2168 * exp(-0.048 * i) - 0.4126 * exp(-0.072 * i)")
  R2 = parse(text = "0.29 * (1 - 0.72 * exp(-0.082 * i))")
  USER = parse(text = paste(user_input))
  
  # Select equations to use.
  if (toupper(ee) == "ALL"){eqn = c("AH282", "AH537", "AH703", "BF", "MM", "R2", "USER")}
  if (toupper(ee) == "ARS"){eqn = c("AH282", "AH537", "AH703", "BF", "MM", "R2")}
  if (toupper(ee) == "AH282"){eqn = "AH282"}
  if (toupper(ee) == "AH537"){eqn = "AH537"}
  if (toupper(ee) == "AH703"){eqn = "AH703"}
  if (toupper(ee) == "BF"){eqn = "BF"}
  if (toupper(ee) == "MM"){eqn = "MM"}
  if (toupper(ee) == "R2"){eqn = "R2"}
  if (toupper(ee) == "USER"){eqn = "USER"}
  
  # Loop over each equation.
  for (name in eqn){
    exp = get(name)
    
    # Loop over each storm.
    for (storm in 1:length(data[[storm.list]])){
      i = data[[storm.list]][[storm]]$INT
      
      # Limit intensity for some equations.
      if (name == "AH537"){i[i > 76] = 76}
      if (name == "AH703"){i[i > 76] = 76}
      
      # Evaluate energy expression for energy density and calculate kinetic energy for each intensity.
      data[[storm.list]][[storm]][[paste(name, "_ED", sep = "")]] = eval(exp)
      data[[storm.list]][[storm]][[paste(name, "_KE", sep = "")]] = data[[storm.list]][[storm]][[paste(name, "_ED", sep = "")]] * data[[storm.list]][[storm]]$PRECIP}}
  
  # Calculate and store other important storm parameters.
  dtimes = sapply(data[[storm.list]], function(x) format(as.POSIXct(x$DT_1[1]), "%Y-%m-%d %H:%M:%S"), USE.NAMES = F)
  depth = sapply(data[[storm.list]], function(x) sum(x$PRECIP, na.rm = T), USE.NAMES = F)
  dur = sapply(data[[storm.list]], function(x) max(x$CUM, na.rm = T) - min(x$CUM, na.rm = T) + x$DUR[1], USE.NAMES = F)
  pdur = sapply(data[[storm.list]], function(x) sum(x$DUR, na.rm = T), USE.NAMES = F)
  ip = sapply(data[[storm.list]], function(x) max(x$INT, na.rm = T), USE.NAMES = F)
  itw = sapply(data[[storm.list]], function(x) weighted.mean(x$INT, x$DUR, na.rm = T), USE.NAMES = F)
  idw = sapply(data[[storm.list]], function(x) weighted.mean(x$INT, x$PRECIP, na.rm = T), USE.NAMES = F)
  i30 = sapply(data[[storm.list]], function(x) max(x$INT_BEF_30, x$INT_AFT_30, na.rm = T), USE.NAMES = F)
  tp = sapply(data[[storm.list]], function(x) {
    t.vec = x$CUM - min(x$CUM, na.rm = T) + x$DUR[1]
    tp.vec = which(x$INT == max(x$INT, na.rm = T))
    return(median(t.vec[tp.vec], na.rm = T)/max(t.vec, na.rm = T))}, USE.NAMES = F)
  
  # When storm duration is less than 30 minutes, I30 is twice the depth of the storm.
  i30[which(dur < 30)] = 2*depth[which(dur < 30)]
  
  # Calculate storm kinetic energy.
  ke.list = lapply(eqn, function(x) {
    name = paste(x, "_KE", sep = "")
    out = sapply(data[[storm.list]], function(y) sum(y[[name]], na.rm = T), USE.NAMES = F)
    return(out)})
  ke.names = unlist(lapply(eqn, function(x) paste(x, "_KE", sep = "")))
  names(ke.list) = ke.names
  
  # Calculate storm erosion indices.
  ei.list = lapply(names(ke.list), function(x) {
    y = ke.list[[x]]
    max.i30 = i30
    if (x == "AH537_KE"){max.i30[max.i30 > 64] = 64}
    out = max.i30 * y
    return(out)})
  ei.names = sapply(eqn, function(x) paste(x, "_EI", sep = ""))
  names(ei.list) = ei.names
  
  # Convert outputs to dataframes.
  ke.df = list.cbind(ke.list)
  ei.df = list.cbind(ei.list)
  sp.df = as.data.frame(cbind(format(as.POSIXct(dtimes, origin = "1970-01-01")), depth, dur, pdur, pdur/dur, ip, tp, itw, idw, i30))
  names(sp.df) = c("DT", "DEPTH", "DUR", "PDUR", "PRATIO", "PEAKINT", "PEAKTIME", "TIME_WM_INT", "DEPTH_WM_INT", "I30")
  
  # Calculate storm antecedent times.
  sp.df$ANT = c(NA, difftime(tail(sp.df$DT, -1), head(sp.df$DT, -1), units = "mins"))
  
  # Store output.
  data[[storm.df]] = cbind(sp.df, ke.df, ei.df)
  tmp = c(F, sapply(data[[storm.df]], is.factor)[-1])
  data[[storm.df]][tmp] = sapply(data[[storm.df]][tmp], function(x) as.numeric(as.character(x)))
  return(data)}


# A function to process daily max/min temperature, solar radiation, wind speed and direction, and dew point temperature data.
process_daily_data = function(data, dly.in, alt.in, dly.ts, mly.ts, yly.ts, mly.mn) {
  if (toupper(verb) == "T") {cat(lr,"Processing daily data...")}
  
  # Find daily average data.
  data[[dly.in]] = data[[dly.in]][complete.cases(data[[dly.in]][,1]),]
  dates = format(data[[dly.in]][,1], format = "%Y%m%d")
  tmin = aggregate(data[[dly.in]]$MIN_TEMP, by = list(dates), FUN = min, simplify = F, na.rm = !pmd)
  tmax = aggregate(data[[dly.in]]$MAX_TEMP, by = list(dates), FUN = max, simplify = F, na.rm = !pmd)$x
  dew = aggregate(data[[dly.in]]$DP_TEMP, by = list(dates), FUN = mean, simplify = F, na.rm = !pmd)$x
  wvel = aggregate(data[[dly.in]]$W_VEL, by = list(dates), FUN = mean, simplify = F, na.rm = !pmd)$x
  wdir = aggregate(data[[dly.in]]$W_DIR, by = list(dates), FUN = mean, simplify = F, na.rm = !pmd)$x
  rad = aggregate(data[[dly.in]]$SO_RAD, by = list(dates), FUN = sum, simplify = F, na.rm = !pmd)$x
  
  # Combine and store in primary data structure.
  d.dly = as.data.frame(tmin[,1], stringsAsFactors = F)
  d.dly = cbind(d.dly, as.data.frame(cbind(tmin$x, tmax, rad, wvel, wdir, dew)), stringsAsFactors = F)
  names(d.dly) = c("YYYYMMDD", "MIN_TEMP", "MAX_TEMP", "SO_RAD", "W_VEL", "W_DIR", "DP_TEMP")
  d.dly = convert_df_type(d.dly, 1, "c")
  d.dly = convert_df_type(d.dly, 2:ncol(d.dly), "n")
  d.dly = df_find_replace(d.dly, 2:ncol(d.dly), find = T, null = T, nan = T, na = T, inf = T, vals = -99999, replace = NA)
  agg.names = c("MIN_TEMP", "MAX_TEMP", "SO_RAD", "W_VEL", "W_DIR", "DP_TEMP")

  # Overwrite with optional alternative data.
  if (toupper(alt) == "T") {
    d.alt = process_alt_data(data, alt.in)
    d.dly = use_alt_data(d.alt, d.dly)
    agg.names = c("MIN_TEMP", "MAX_TEMP", "SO_RAD", "W_VEL", "W_DIR", "DP_TEMP", "AIR_TEMP", "REL_HUM")}
  data[[dly.ts]] = d.dly
  
  # Calculate monthly time series data.
  YYYYMM = format(as.Date(d.dly$YYYYMMDD, format = "%Y%m%d"), format = "%Y%m")
  mn.ts = aggregate(d.dly[,-1], by = list(YYYYMM), FUN = mean, simplify = F, na.rm = !pmd)
  names(mn.ts) = c("YYYYMM", agg.names)
  mn.ts = convert_df_type(mn.ts, 1:ncol(mn.ts), "n")
  mn.ts = df_find_replace(mn.ts, 2:ncol(mn.ts), find = T, null = T, nan = T, na = T, inf = T, vals = -99999, replace = NA)
  data[[mly.ts]] = mn.ts
  
  # Calculate annual time series data.
  YYYY = format(as.Date(d.dly$YYYYMMDD, format = "%Y%m%d"), format = "%Y")
  an.ts = aggregate(d.dly[,-1], by = list(YYYY), FUN = mean, simplify = F, na.rm = !pmd)
  names(an.ts) = c("YYYY", agg.names)
  an.ts = convert_df_type(an.ts, 1:ncol(an.ts), "n")
  an.ts = df_find_replace(an.ts, 2:ncol(an.ts), find = T, null = T, nan = T, na = T, inf = T, vals = -99999, replace = NA)
  data[[yly.ts]] = an.ts
  
  # Find monthly average data.
  mn = format(as.Date(d.dly$YYYYMMDD, format = "%Y%m%d"), format = "%m")
  m.mean = aggregate(d.dly[,-1], by = list(mn), FUN = mean, simplify = F, na.rm = !pmd)
  names(m.mean) = c("MM", agg.names)
  m.mean = convert_df_type(m.mean, 1:ncol(m.mean), "n")
  m.mean = df_find_replace(m.mean, 2:ncol(m.mean), find = T, null = T, nan = T, na = T, inf = T, vals = -99999, replace = NA)
  
  # Fill missing monthly averages with NA.
  m.mean = fill_agg_df(m.mean, "MM", 1:12, NA)
  m.mean = convert_df_type(m.mean, 1:ncol(m.mean), "n")
  data[[mly.mn]] = m.mean
  
  return(data)}


# A function to process optional sub-daily air temperature and relative humidity data.
process_alt_data = function(data, alt.in) {
  if (toupper(verb) == "T") {cat(lr,"Processing alternative data...")}
  
  # Calculate dew point temperature time series.
  data[[alt.in]]$DT_2 = as.POSIXlt(data[[alt.in]]$DT_2)
  dates = format(data[[alt.in]]$DT_2, format = "%Y%m%d")
  dp.temp = dew_point_temperature(data[[alt.in]]$AIR_TEMP, data[[alt.in]]$REL_HUM)
  dp.temp = vec_find_replace(dp.temp, find = T, null = T, nan = T, na = T, inf = T, vals = -99999, replace = NA)
  
  # Find daily alternative temperature data.
  d.t.min = aggregate(data[[alt.in]]$AIR_TEMP, by = list(dates), FUN = min, simplify = F, na.rm = T)
  d.t.max = aggregate(data[[alt.in]]$AIR_TEMP, by = list(dates), FUN = max, simplify = F, na.rm = T)$x
  d.a.temp = aggregate(data[[alt.in]]$AIR_TEMP, by = list(dates), FUN = mean, simplify = F, na.rm = T)$x
  d.rel.hum = aggregate(data[[alt.in]]$REL_HUM, by = list(dates), FUN = mean, simplify = F, na.rm = T)$x
  d.dp.temp = aggregate(dp.temp, by = list(dates), FUN = mean, simplify = F, na.rm = T)$x
  
  # Combine and store in primary data structure.
  d.alt = as.data.frame(d.t.min[,1], stringsAsFactors = F)
  d.alt = cbind(d.alt, as.data.frame(cbind(d.t.min$x, d.t.max, d.dp.temp, d.a.temp, d.rel.hum)), stringsAsFactors = F)
  names(d.alt) = c("YYYYMMDD", "ALT_MIN_TEMP", "ALT_MAX_TEMP", "ALT_DP_TEMP", "AIR_TEMP", "REL_HUM")
  d.alt = convert_df_type(d.alt, 1, "c")
  d.alt = convert_df_type(d.alt, 2:ncol(d.alt), "n")
  d.alt = df_find_replace(d.alt, 2:ncol(d.alt), find = T, null = T, nan = T, na = T, inf = T, vals = -99999, replace = NA)
  
  return(d.alt)}


# A function to calculate dew point temperature from relative humidity and air temperature data.
dew_point_temperature = function(air_temp, rel_hum) {
  rel_hum[rel_hum == 0] = 1
  A1 = 7.625
  B1 = 243.04
  top = B1 * (log(rel_hum/100) + (A1 * air_temp)/(B1 + air_temp))
  bottom = A1 - log(rel_hum/100) - (A1 * air_temp)/(B1 + air_temp)
  dp_temp = top / bottom
  return(dp_temp)}


# A function to replace daily data calculations of max, min, and dp temperature with alternative data.
use_alt_data = function(d.alt, d.dly) {
  out.df = merge(d.dly, d.alt, by = "YYYYMMDD", all.x = T)[,c(1, 8, 9, 4, 5, 6, 10, 11, 12)]
  names(out.df) = c("YYYYMMDD", "MIN_TEMP", "MAX_TEMP", "SO_RAD", "W_VEL", "W_DIR", "DP_TEMP", "AIR_TEMP", "REL_HUM")
  out.df = convert_df_type(out.df, 1, "c")
  out.df = convert_df_type(out.df, 2:ncol(out.df), "n")
  out.df = df_find_replace(out.df, 2:ncol(out.df), find = T, null = T, nan = T, na = T, inf = T, vals = -99999, replace = NA)
  return(out.df)}


# A function to process precipitation data.
process_precip_data = function(data, pcp.in, dly.ts, mly.ts, yly.ts, mly.mn) {
  if (toupper(verb) == "T") {cat(lr,"Processing precipitation data...")}
  
  # Generate daily event metadata and find daily precipitation data.
  data[[pcp.in]]$DT_1 = as.POSIXlt(data[[pcp.in]]$DT_1)
  dates = format(data[[pcp.in]]$DT_1, format = "%Y%m%d")
  d.bps = aggregate(data[[pcp.in]]$PRECIP, by = list(dates), FUN = length, simplify = F)
  d.events = aggregate(data[[pcp.in]]$SID, by = list(dates), FUN = unique, simplify = F, na.rm = !pmd)$x
  e.len = as.numeric(sapply(d.events, function(x) length(x)))
  e.max = as.numeric(sapply(d.events, function(x) max(x)))
  e.min = as.numeric(sapply(d.events, function(x) min(x)))
  d.p.sum = aggregate(data[[pcp.in]]$PRECIP, by = list(dates), FUN = sum, simplify = F, na.rm = !pmd)$x
  
  # Combine results and store in primary data structure.
  d.precip = as.data.frame(d.bps[,1], stringsAsFactors = F)
  d.precip = cbind(d.precip, as.data.frame(cbind(d.bps$x, e.len, e.max, e.min, d.p.sum)), stringsAsFactors = F)
  names(d.precip) = c("YYYYMMDD", "BPS", "ELEN", "EMAX", "EMIN", "PRECIP")
  d.precip = convert_df_type(d.precip, 1, "c")
  d.precip = convert_df_type(d.precip, 2:ncol(d.precip), "n")
  d.precip = df_find_replace(d.precip, 2:ncol(d.precip), find = T, null = T, nan = T, na = T, inf = T, vals = -99999, replace = NA)
  
  # Merge with daily time series data.
  if (toupper(cv) != "F") {d.precip = merge(data[[dly.ts]], d.precip, by = "YYYYMMDD", all.x = T)}
  data[[dly.ts]] = d.precip

  # Find monthly precipitation.
  m.sum = aggregate(d.precip$PRECIP, by = list(format(as.Date(d.precip$YYYYMMDD, format = "%Y%m%d"), format = "%Y%m")), FUN = sum, simplify = F, na.rm = T)
  m.bps = aggregate(d.precip$BPS, by = list(format(as.Date(d.precip$YYYYMMDD, format = "%Y%m%d"), format = "%Y%m")), FUN = sum, simplify = F, na.rm = T)$x
  m.eln = aggregate(d.precip$ELEN, by = list(format(as.Date(d.precip$YYYYMMDD, format = "%Y%m%d"), format = "%Y%m")), FUN = sum, simplify = F, na.rm = T)$x
  m.ts = as.data.frame(m.sum[,1], stringsAsFactors = F)
  m.ts = cbind(m.ts, as.data.frame(cbind(m.sum$x, m.bps, m.eln), stringsAsFactors = F))
  names(m.ts) = c("YYYYMM", "PRECIP", "BPS", "ELEN")
  m.ts = convert_df_type(m.ts, 1, "c")
  m.ts = convert_df_type(m.ts, 2:ncol(m.ts), "n")
  m.ts = df_find_replace(m.ts, 2:ncol(m.ts), find = T, null = T, nan = T, na = T, inf = T, vals = -99999, replace = NA)
  
  # Merge with monthly time series data.
  if (toupper(cv) != "F") {m.ts = merge(data[[mly.ts]], m.ts, by = "YYYYMM", all.x = T)}
  data[[mly.ts]] = m.ts
  
  # Find annual precipitation.
  an.sum = aggregate(d.precip$PRECIP, by = list(format(as.Date(d.precip$YYYYMMDD, format = "%Y%m%d"), format = "%Y")), FUN = sum, simplify = F, na.rm = T)
  an.bps = aggregate(d.precip$BPS, by = list(format(as.Date(d.precip$YYYYMMDD, format = "%Y%m%d"), format = "%Y")), FUN = sum, simplify = F, na.rm = T)$x
  an.eln = aggregate(d.precip$ELEN, by = list(format(as.Date(d.precip$YYYYMMDD, format = "%Y%m%d"), format = "%Y")), FUN = sum, simplify = F, na.rm = T)$x
  an.ts = as.data.frame(an.sum[,1], stringsAsFactors = F)
  an.ts = cbind(an.ts, as.data.frame(cbind(an.sum$x, an.bps, an.eln), stringsAsFactors = F))
  names(an.ts) = c("YYYY", "PRECIP", "BPS", "ELEN")
  an.ts = convert_df_type(an.ts, 1, "c")
  an.ts = convert_df_type(an.ts, 2:ncol(an.ts), "n")
  an.ts = df_find_replace(an.ts, 2:ncol(an.ts), find = T, null = T, nan = T, na = T, inf = T, vals = -99999, replace = NA)
  
  # Merge with annual time series data.
  if (toupper(cv) != "F") {an.ts = merge(data[[yly.ts]], an.ts, by = "YYYY", all.x = T)}
  data[[yly.ts]] = an.ts
  
  # Find monthly average precipitation.
  m.pcp = aggregate(m.ts$PRECIP, by = list(format(as.Date(paste(m.ts$YYYYMM, "01", sep = ""), format = "%Y%m%d"), format = "%m")), FUN = mean, simplify = F, na.rm = !pmd)
  m.bps = aggregate(m.ts$BPS, by = list(format(as.Date(paste(m.ts$YYYYMM, "01", sep = ""), format = "%Y%m%d"), format = "%m")), FUN = mean, simplify = F, na.rm = !pmd)$x
  m.eln = aggregate(m.ts$ELEN, by = list(format(as.Date(paste(m.ts$YYYYMM, "01", sep = ""), format = "%Y%m%d"), format = "%m")), FUN = mean, simplify = F, na.rm = !pmd)$x
  m.mn = as.data.frame(m.pcp[,1], stringsAsFactors = F)
  m.mn = cbind(m.mn, as.data.frame(cbind(m.pcp$x, m.bps, m.eln), stringsAsFactors = F))
  names(m.mn) = c("MM", "PRECIP", "BPS", "ELEN")
  m.mn = convert_df_type(m.mn, 1:ncol(m.mn), "n")
  m.mn = df_find_replace(m.mn, 2:ncol(m.mn), find = T, null = T, nan = T, na = T, inf = T, vals = -99999, replace = NA)
  
  # Fill missing monthly average precipitation with zero precipitation.
  m.mn = fill_agg_df(m.mn, "MM", 1:12, 0)
  m.mn = convert_df_type(m.mn, 1:ncol(m.mn), "n")
  
  # Merge with monthly time series data.
  if (toupper(cv) != "F") {m.mn = merge(data[[mly.mn]], m.mn, by = "MM", all.x = T)}
  data[[mly.mn]] = m.mn
  
  return(data)}


# A function to fill missing rows in an aggregated dataframe. The column names must be identical.
fill_agg_df = function(agg.df, col.name, obs, val) {
  
  # Find missing data.
  existing = agg.df[[col.name]]
  existing = which(existing %in% obs)
  missing = obs[-existing]
  
  # Create filler data.
  na.matrix = matrix(NA, nrow = length(missing), ncol = ncol(agg.df) - 1)
  add.df = as.data.frame(cbind(missing, na.matrix))
  names(add.df) = names(agg.df)
  
  # Combine and sort.
  out.df = as.data.frame(rbind(add.df, agg.df))
  out.df = out.df[order(as.numeric(out.df[[col.name]])),]
  
  return(out.df)}


# A function to fill missing daily data.
fill_data = function(data, pcp.ts.in, dly.ts.in, dly.ts.out, pcp.ts.out) {
  if (toupper(verb) == "T") {cat(lr,"Preparing to impute data...")}
  
  # Remove missing datetime rows from inputs.
  data[[pcp.ts.in]] = data[[pcp.ts.in]][!is.na(data[[pcp.ts.in]]$DT_1),]
  data[[dly.ts.in]] = data[[dly.ts.in]][!is.na(data[[dly.ts.in]]$YYYYMMDD),]
  
  # Create clustering column for daily and precipitation dataframes.
  data[[pcp.ts.out]] = data.frame(data[[pcp.ts.in]]$DT_1, na.omit(create_cluster_col(data[[pcp.ts.in]], "DT_1", "%Y-%m-%d %H:%M:%S")))
  data[[dly.ts.out]] = create_cluster_col(data[[dly.ts.in]], "YYYYMMDD", "%Y%m%d")

  # Rename columns.
  names(data[[pcp.ts.out]]) = c("DT_1", names(data[[pcp.ts.out]][,-1]))
  
  # Prepare gap filling data frames.
  dly.var.df = data[[dly.ts.out]][,c(2, 5, 4, 3, 8, 6, 7)]
  dly.pcp.df = data[[dly.ts.out]][,c(2, (ncol(data[[dly.ts.out]])-4):ncol(data[[dly.ts.out]]))]
  pcp.ts.df = data[[pcp.ts.out]]
  
  # Prepare event factor column.
  dly.var.df$EVENT = 0
  dly.var.df$EVENT[dly.pcp.df$PRECIP > 0] = 1
  dly.var.df$EVENT = as.factor(dly.var.df$EVENT)
  dly.pcp.df$BPS[is.na(dly.pcp.df$BPS)] = 0

  # Create split factor
  dly.pcp.df$COUNT = 1:nrow(dly.pcp.df)
  pcp.present = is.na(dly.pcp.df$BPS) == F
  split.fact = as.factor(unname(unlist(apply(dly.pcp.df[pcp.present,], 1, function(x) rep(x[["COUNT"]], x[["BPS"]])))))
  
  # Split precipitation time series
  pcp.ts.list = split(pcp.ts.df[1:sum(dly.pcp.df$BPS, na.rm = T),], split.fact)
  
  # Prepare dataframe for finding missing precipitation.
  dly.mis.df = data.frame(data[[dly.ts.out]][,c(1,13)], dly.var.df)
  names(dly.mis.df) = c("YYYYMMDD", "PRECIP", names(dly.var.df))
  
  # Insert NAs for missing precipitation days to be filled.
  dly.mis.df = find_missing_precip(dly.mis.df)
  
  # Create a column to track rows for recombining.
  dly.var.df = data.frame(as.factor(dly.var.df$CLUSTER), dly.mis.df[,4:10])
  names(dly.var.df) = c("CLUSTER", names(dly.var.df)[-1])

  # Impute missing daily solar radiation data.
  if (toupper(verb) == "T") {cat(lr,"Imputing daily solar radiation data...")}
  dly.var.df[,1:2] = impute_by_cluster(dly.var.df, "midastouch")[,1:2]

  # Impute missing daily maximum and minimum temperature data.
  if (toupper(verb) == "T") {cat(lr,"Imputing daily max/min temperature data...")}
  dly.var.df[,1:4] = impute_by_cluster(dly.var.df[,1:4], "midastouch")
  implausible.cases = which(dly.var.df$MIN_TEMP >= dly.var.df$MAX_TEMP)
  
  # Reimpute (occasional) implausible temperature imputations.
  counter = 0
  continue = F
  if (length(implausible.cases > 0)) {continue = T}
  while (continue == T) {
    counter = counter + 1
    if (toupper(verb) == "T") {cat(lr,"Reimputing implausible temperature data...")}
    dly.var.df$MIN_TEMP[implausible.cases] = NA
    dly.var.df[,1:4] = impute_by_cluster(dly.var.df[,1:4], "midastouch")
    implausible.cases = which(dly.var.df$MIN_TEMP >= dly.var.df$MAX_TEMP)
    continue = F
    if (length(implausible.cases > 0)) {continue = T}
    if (counter == 10) {continue = F}}
  
  # Substitute minimum with maximum for cases that cannot be handled by imputation.
  if (length(implausible.cases > 0)) {
    dly.var.df$MIN_TEMP[implausible.cases] = dly.var.df$MAX_TEMP[implausible.cases]}
  
  # Impute missing daily dew point temperature and wind data.
  if (toupper(verb) == "T") {cat(lr,"Imputing daily dew point temperature and wind data...")}
  dly.var.df[,1:7] = impute_by_cluster(dly.var.df[,1:7], "midastouch")
  
  # Impute missing daily precipitation event data.
  if (toupper(verb) == "T") {cat(lr,"Imputing daily precipitation event data...")}
  dly.var.df[,1:8] = impute_by_cluster(dly.var.df[,1:8], "cart")
  
  # Subset only precipitation events.
  date.match = data[[dly.ts.out]][dly.var.df$EVENT == 1, 1]
  cluster.match = data[[dly.ts.out]][dly.var.df$EVENT == 1, 2]
  dly.eve.var.df = dly.var.df[dly.var.df$EVENT == 1,]
  dly.eve.pcp.df = dly.pcp.df[dly.var.df$EVENT == 1, c(2:3, 6)]
  dly.eve.con.df = dly.pcp.df[dly.var.df$EVENT == 1, c(3:5)]
  dly.eve.pcp.df$BPS[dly.eve.pcp.df$BPS == 0] = NA
  
  # Combine precipitation event dataframes.
  dly.eve.df = data.frame(dly.eve.var.df[,-1], dly.eve.pcp.df, date.match)
  names(dly.eve.df) = c(names(dly.eve.var.df[,-1]), names(dly.eve.pcp.df), "YYYYMMDD")
  
  # Recompute clusters.
  dly.eve.df[["YYYYMMDD"]] = as.character(dly.eve.df[["YYYYMMDD"]])
  dly.eve.df = create_cluster_col(dly.eve.df, "YYYYMMDD", "%Y%m%d")
  dly.eve.df = dly.eve.df[complete.cases(dly.eve.df[,1:9]), 2:ncol(dly.eve.df)]
  
  # Impute missing precipitation characteristics data.
  if (toupper(verb) == "T") {cat(lr,"Imputing daily event characteristics data...")}
  dly.imp.df = data.frame(date.match, impute_by_cluster(dly.eve.df, "midastouch"))
  
  # Combine daily data and save in the primary data structure.
  dly.pcp.df = dly.imp.df[,c(1, 10:ncol(dly.imp.df))]
  names(dly.pcp.df) = c("YYYYMMDD", "BPS", "ELEN", "PRECIP")
  dly.var.df = data.frame(dly.mis.df$YYYYMMDD, dly.var.df[,c(4:2, 6, 7, 5)])
  names(dly.var.df) = c("YYYYMMDD", "MIN_TEMP", "MAX_TEMP", "SO_RAD", "W_VEL", "W_DIR", "DP_TEMP")
  dly.out.df = merge(dly.var.df, dly.pcp.df, by = "YYYYMMDD", all.x = T)
  data[[dly.ts.out]] = dly.out.df
  
  # Recombine event data.
  dly.eve.df = data.frame(dly.imp.df, dly.eve.con.df)
  empty.days = which(is.na(dly.eve.df$EMAX == T))
  
  # Create empty elements in precipitation time series list.
  fil.ts.list = list()
  fil.list = 1:nrow(dly.eve.df)
  pcp.list = fil.list
  
  # Complete precipitation imputation if new events are to be imputed.
  if (length(empty.days) > 0) {pcp.list = fil.list[-empty.days]}
  
  # Copy existing precipitation data to the correct positions.
  for (i in 1:length(pcp.list)) {fil.ts.list[[pcp.list[i]]] = pcp.ts.list[[i]]}
  
  # Create structure for new events to be imputed.
  if (length(empty.days) > 0) {
    
    # Create new empty dataframes for the correct positions.
    cols = ncol(data[[pcp.ts.in]]) + 2
    for (i in 1:length(empty.days)) {fil.ts.list[[empty.days[i]]] = data.frame(matrix(NA, nrow = dly.eve.df$BPS[empty.days[i]], ncol = cols))}
    
    # Name new empty dataframes in the correct positions.
    for (i in 1:length(empty.days)) {names(fil.ts.list[[empty.days[i]]]) = names(pcp.ts.list[[1]])}
    
    # Add known daily information to the filled positions.
    for (i in 1:length(empty.days)) {fil.ts.list[[empty.days[i]]][,1] = as.POSIXct(as.character(date.match[empty.days[i]]), format = "%Y%m%d")}
    for (i in 1:length(empty.days)) {fil.ts.list[[empty.days[i]]][,2] = date.match[empty.days[i]]}
    for (i in 1:length(empty.days)) {fil.ts.list[[empty.days[i]]][,3] = cluster.match[empty.days[i]]}}
  
  # Convert precipitation time series list to dataframe.
  pcp.ts.df = rbindlist(fil.ts.list)
  
  # Recompute clusters.
  pcp.ts.df[["YYYYMMDD"]] = as.character(pcp.ts.df[["YYYYMMDD"]])
  pcp.ts.df = create_cluster_col(pcp.ts.df[,-3], "YYYYMMDD", "%Y%m%d")
  pcp.ts.df = pcp.ts.df[complete.cases(pcp.ts.df$DT_1),]
  
  # Create imputation dataframe.
  datetimes = format(as.POSIXct(pcp.ts.df$DT_1), "%Y-%m-%d %H:%M:%S")
  imp.ts.df = pcp.ts.df[,c(2, 4, 5)]
  imp.ts.df$HOUR = as.numeric(substr(datetimes, 12, 13))
  imp.ts.df$MINUTE = as.numeric(substr(datetimes, 15, 16))
  imp.ts.df$SECOND = as.numeric(substr(datetimes, 18, 19))
  imp.ts.df[is.na(pcp.ts.df$PRECIP) == T, 2:6] = NA
  
  # Impute missing precipitation time series values.
  if (toupper(verb) == "T") {cat(lr,"Imputing precipitation time series...")}
  imp.ts.df = impute_by_cluster(imp.ts.df, "midastouch")
  
  # Reformat time series data.
  if (toupper(verb) == "T") {cat(lr,"Returning imputed data...")}
  imp.ts.df$DT_1 = paste(pcp.ts.df$YYYYMMDD, " ", imp.ts.df$HOUR, ":", imp.ts.df$MINUTE, ":", imp.ts.df$SECOND, sep = "")
  imp.ts.df$DT_1 = as.POSIXct(imp.ts.df$DT_1, format = "%Y%m%d %H:%M:%S")
  imp.ts.df = imp.ts.df[,c(7, 2:3)]

  # Change duplicated times.
  continue = T
  counter = 0
  if (toupper(verb) == "T") {cat(lr,"Recomputing overlapped precipitation events...")}
  
  # Combining duplicated precipitation events.
  while (continue == T) {
    counter = counter + 1
    imp.ts.df = imp.ts.df[order(imp.ts.df$DT_1),]
    dup.locs = which(duplicated(imp.ts.df$DT_1) == T)
    if (length(dup.locs) > 0) {
      imp.ts.df$PRECIP[dup.locs - 1] = imp.ts.df$PRECIP[dup.locs - 1] + imp.ts.df$PRECIP[dup.locs]
      imp.ts.df = imp.ts.df[-dup.locs,]
      pcp.ts.df = pcp.ts.df[-dup.locs,]
      dup.locs = which(duplicated(imp.ts.df$DT_1) == T)
    }
    if (counter == 10000) {continue = F}
    if (length(dup.locs) == 0) {continue = F}}
  
  # Reducing overlapping durations.
  lap.time = as.POSIXct(imp.ts.df$DT_1) + imp.ts.df$DUR*60
  lap.diff = as.numeric(difftime(lap.time, c(as.POSIXct(tail(imp.ts.df$DT_1, nrow(imp.ts.df)-1)), NA), units = "mins"))
  lap.diff[lap.diff < 0] = 0
  lap.locs = which(lap.diff > 0)
  if (length(lap.locs) > 0) {imp.ts.df$DUR[lap.locs] = imp.ts.df$DUR[lap.locs] - lap.diff[lap.locs]}

  # Combine precipitation time series data.
  pcp.ts.df = pcp.ts.df[,-c(1:2)]
  pcp.ts.df[,1:3] = imp.ts.df
  
  # Recompute antecedent times.
  if (toupper(verb) == "T") {cat(lr,"Recomputing antecedent times...")}
  dif = c(0, difftime(tail(pcp.ts.df$DT_1, -1), head(pcp.ts.df$DT_1, -1), units = "mins"))
  pcp.ts.df$ANT = dif
  pcp.ts.df$CUM = cumsum(pcp.ts.df$ANT)
  
  # Store precipitation time series data.
  data[[pcp.ts.out]] = pcp.ts.df
  
  # Recompute daily precipitation amounts.
  if (toupper(verb) == "T") {cat(lr,"Recomputing daily precipitation amounts...")}
  
  # Set NA values to 0.
  data[[dly.ts.out]]$BPS[is.na(data[[dly.ts.out]]$BPS)] = 0
  data[[dly.ts.out]]$ELEN[is.na(data[[dly.ts.out]]$ELEN)] = 0
  data[[dly.ts.out]]$PRECIP[is.na(data[[dly.ts.out]]$PRECIP)] = 0
  
  # Use breakpoint counts to sum daily precipitation.
  e.row = unname(unlist(c(cumsum(data[[dly.ts.out]]$BPS))))
  s.row = c(1, e.row[-length(e.row)] + 1)
  r.row = mapply(function(x, y) {x:y}, s.row, e.row)
  i.pcp = unname(unlist(lapply(r.row, function(x) sum(pcp.ts.df$PRECIP[x]))))
  data[[dly.ts.out]]$PRECIP = i.pcp
  
  return(data)}


# A function to return a timeseries dataframe with a clustering column.
create_cluster_col = function(in.df, dt.col.name, dt.format) {
  
  # Determine start and end times.
  in.df[[dt.col.name]] = format(as.POSIXct(in.df[[dt.col.name]], format = dt.format), dt.format)
  start = min(as.Date(in.df[[dt.col.name]], format = dt.format))
  end = max(as.Date(in.df[[dt.col.name]], format = dt.format))

  # Stop if there are less than 50 observations.
  if (length(na.omit(in.df)[[dt.col.name]]) < 50) {stop("Insufficient Data: at least 50 complete observations of all variables must be present for gap filling.")}
  
  # Create sequence for cluster analysis.
  data.seq = unique(format(as.Date(in.df[[dt.col.name]], format = dt.format), "%Y%m%d"))
  
  # Stop if there is less than one year of data.
  diff = difftime(end, start, units = "days")
  if (as.numeric(diff) < 366) {stop("Insufficient Data: at least one year of mostly complete data must be present for gap filling.")}
  
  # Change start and end times if user specified dates are different.
  if (toupper(sdt) != "START") {start = as.Date(sdt, format = dtf1)}
  if (toupper(edt) != "END") {end = as.Date(edt, format = dtf1)}
  
  # Stop if there is less than one year of data.
  diff = difftime(end, start, units = "days")
  if (as.numeric(diff) < 366) {stop("Insufficient Data: at least one year of mostly complete data must be present for gap filling.")}
  
  # Create sequence for filling.
  fill.seq = format(seq(start, end, by = "days"), "%Y%m%d")
  
  # Convert datetime column if necessary.
  if (dt.format != "%Y%m%d") {in.df[[dt.col.name]] = format(as.Date(in.df[[dt.col.name]], format = dt.format), "%Y%m%d")}
  
  # Prepare clustering vectors.
  mns = as.numeric(substr(data.seq, 5, 6))
  qtr = as.numeric(substr(data.seq, 7, 8))
  qtr[qtr <= 7] = 1
  qtr[qtr >= 24] = 4
  qtr[qtr >= 16] = 3
  qtr[qtr >= 8] = 2
  hmn = 2 * mns
  hmn[qtr <= 2] = hmn[qtr <= 2] - 1
  qmn = 2 * hmn
  qmn[qtr == 1] = qmn[qtr == 1] - 1
  qmn[qtr == 3] = qmn[qtr == 3] - 1
  
  # Catalog for each clustering method.
  min.len.mns = min(sapply(unique(mns), function(x) length(which(mns == x))))
  min.len.hmn = min(sapply(unique(hmn), function(x) length(which(hmn == x))))
  min.len.qmn = min(sapply(unique(qmn), function(x) length(which(qmn == x))))
  
  # Prepare clustering vectors.
  dts = as.POSIXlt(fill.seq, format = "%Y%m%d")
  dys = as.numeric(format(dts, "%Y%m%d"))
  mns = as.numeric(substr(dys, 5, 6))
  qtr = as.numeric(substr(dys, 7, 8))
  qtr[qtr <= 7] = 1
  qtr[qtr >= 24] = 4
  qtr[qtr >= 16] = 3
  qtr[qtr >= 8] = 2
  hmn = 2 * mns
  hmn[qtr <= 2] = hmn[qtr <= 2] - 1
  qmn = 2 * hmn
  qmn[qtr == 1] = qmn[qtr == 1] - 1
  qmn[qtr == 3] = qmn[qtr == 3] - 1
  
  # Determine the best clustering method.
  if (min.len.mns < 30) {out.df = data.frame(dys, 1); names(out.df) = c(dt.col.name, "CLUSTER")}
  if (min.len.mns >= 30) {out.df = data.frame(dys, mns); names(out.df) = c(dt.col.name, "CLUSTER")}
  if (min.len.hmn >= 30) {out.df = data.frame(dys, hmn); names(out.df) = c(dt.col.name, "CLUSTER")}
  if (min.len.qmn >= 30) {out.df = data.frame(dys, qmn); names(out.df) = c(dt.col.name, "CLUSTER")}
  
  # Create merged dataframe.
  merge.df = merge(out.df, in.df, by = dt.col.name, all = T)
  names(merge.df) = c("YYYYMMDD", names(merge.df)[2:ncol(merge.df)])
  return(merge.df)}


# A function to impute missing data by cluster.
impute_by_cluster = function(fil.df, imp.method) {

  # Get unique clusters for filling.
  clusters = unique(fil.df$CLUSTER)
  
  # Impute for each cluster.
  for (j in clusters){
    
    # Subset input dataframe and record subset rows.
    locs = which(fil.df$CLUSTER == j)
    tmp.df = as.data.frame(fil.df[locs, 2:ncol(fil.df)])
    
    # Setup the joint multiple impute model and run.
    progress = F
    imputations = 1
    max.iter = max(20, ceiling(100 - 100 * nrow(na.omit(tmp.df)) / nrow(tmp.df)))
    max.iter = min(as.numeric(io), max.iter)
    if (toupper(im) != "DEFAULT") {imp.method = tolower(im)}
    if (toupper(qi) == "T") {imp.method = "cart"; max.iter = 10}
    if (toupper(iv) == "T") {progress = T}
    block.mn = make.blocks(tmp.df, partition = "collect")
    imp = mice(tmp.df, blocks = block.mn, m = imputations, maxit = max.iter, print = progress, method = imp.method)
    
    # Complete each cluster subset with filled data.
    fil.df[locs, 2:ncol(fil.df)] = complete(imp, imputations)}
  
  return(fil.df)}


# A function to impute missing data.
impute_by_df = function(fil.df, imp.method) {
  
  # Setup the joint multiple impute model and run.
  progress = F
  imputations = 1
  max.iter = max(20, ceiling(100 - 100 * nrow(na.omit(fil.df)) / nrow(fil.df)))
  max.iter = min(as.numeric(io), max.iter)
  if (toupper(im) != "DEFAULT") {imp.method = tolower(im)}
  if (toupper(qi) == "T") {imp.method = "cart"; max.iter = 10}
  if (toupper(iv) == "T") {progress = T}
  block.mn = make.blocks(fil.df, partition = "collect")
  imp = mice(fil.df, blocks = block.mn, m = imputations, maxit = max.iter, print = progress, method = imp.method)
  
  # Complete each cluster subset with filled data.
  fil.df = complete(imp, imputations)
  
  return(fil.df)}


# A function to determine likely missing precipitation periods.
find_missing_precip = function(in.df) {
  
  # Prepare dataframe for monthly RLE analysis.
  in.df$YYYYMM = as.numeric(substr(in.df$YYYYMMDD, 1, 6))
  yrs.observed = length(unique(as.numeric(substr(in.df$YYYYMMDD, 1, 4))))
  
  # Convert event data to numeric.
  in.df$EVENT = as.numeric(as.character(in.df$EVENT))
  
  # Count events in each subset (annual, monthly, and cluster).
  monthly.events = aggregate(in.df$EVENT, by = list(in.df$YYYYMM), FUN = sum, na.rm = T)
  cluster.events = aggregate(in.df$EVENT, by = list(in.df$CLUSTER), FUN = sum, na.rm = T)
  
  # Optional aggregation for low precipitation amount detection.
  #monthly.sums = aggregate(in.df$PRECIP, by = list(in.df$YYYYMM), FUN = sum, na.rm = T)
  #monthly.sums$MM = as.numeric(substr(monthly.sums[,1], 5, 6))
  #monthly.iqr = aggregate(monthly.sums$x, by = list(monthly.sums$MM), FUN = IQR, na.rm = T)
  #monthly.lwq = aggregate(monthly.sums$x, by = list(monthly.sums$MM), FUN = quantile, probs = 0.25, na.rm = T)
  #monthly.llim = aggregate(monthly.sums$x, by = list(monthly.sums$MM), FUN = quantile, probs = 0.05, na.rm = T)
  
  # Get the frequency and duration of missing streaks.
  monthly.rle = rle(monthly.events[,2])
  zero.streaks = monthly.rle$lengths[which(monthly.rle$values == 0)]
  
  # Treat infrequent events as missing.
  if (length(zero.streaks) < 7) {streak.max = 0}
  
  # Treat infrequent events by distribution.
  if (length(zero.streaks) > 6) {
    zero.bins = unname(table(as.numeric(cut(zero.streaks, 3))))
    if (length(zero.bins) < 3) {streak.max = 0}
    if (length(zero.bins) == 3) {
      if (zero.bins[1] < zero.bins[2] & zero.bins[3] < zero.bins[2]) {streak.max = unname(quantile(zero.streaks, probs = 0.75))}
      if (zero.bins[1] >= zero.bins[2]) {streak.max = 0}}}
  
  # Flag large missing month streaks as NA.
  streak.intersect = which(monthly.rle$values == 0)
  streak.ends = cumsum(monthly.rle$lengths)[streak.intersect]
  streak.lengths = monthly.rle$lengths[streak.intersect]
  streak.begins = streak.ends - (streak.lengths - 1)
  streaks = mapply(function(x, y) x:y, streak.begins, streak.ends)
  streaks = streaks[sapply(streaks, function(x) length(x)) > streak.max]
  missing.months = unlist(lapply(streaks, function(x) monthly.events[x, 1]))
  in.df$EVENT[which(in.df$YYYYMM %in% missing.months)] = NA
  
  # Flag consistently dry clusters as non-events.
  abs.limit = 7      # Based on quarter-month clustering limit
  rel.limit = 0.025  # Based on less than 2.5% probability of an event in a given year
  dry.clusters = unique(c(which(cluster.events[,2] <= abs.limit), which(cluster.events[,2] / yrs.observed < rel.limit)))
  missing.days = which(is.na(in.df$EVENT) == T)
  dry.days = which(in.df$CLUSTER %in% cluster.events[dry.clusters, 1])
  zero.days = intersect(missing.days, dry.days)
  in.df$EVENT[zero.days] = 0
  
  return(in.df)}


# A function to create graphical output.
graph_data = function(data) {
  if (toupper(verb) == "T") {cat(lr,"Plotting data...")}
  
  # Create plotting directory structure.
  setwd(p)
  dir.list = c("INPUT", "OUTPUT", "OTHER")
  for (j in dir.list){create_directory(j)}
  
  # Prepare input plot vectors.
  var.nm = c("PRECIP", "AIR_TEMP", "REL_HUM", "MIN_TEMP", "MAX_TEMP", "SO_RAD", "W_VEL", "W_DIR", "DP_TEMP")
  pretty.nm = c("PRECIPITATION", "AIR TEMPERATURE", "RELATIVE HUMIDITY", "MINIMUM TEMPERATURE", "MAXIMUM TEMPERATURE", "SOLAR RADIATION", "WIND VELOCITY", "WIND DIRECTION", "DEW POINT TEMPERATURE")
  var.u = c("mm", "C", "%", "C", "C", "Langleys/Day", "m/s", "Degrees from North (CW)", "C")
  og.l = c(1, 2, 2, 3, 3, 3, 3, 3, 3)
  qc.l = c(5, 6, 6, 7, 7, 7, 7, 7, 7)
  plot.type = c("h", "l", "l", "l", "l", "l", "l", "l", "l")
  stat.nm = fn
  if (toupper(fn) == "STATION"){stat.nm = data[[4]][["STATION"]]}
  
  # Create input plots.
  for (j in 1:length(var.nm)){
    setwd("INPUT")
    dt.vec = data[[og.l[j]]][,1]
    dt.qc = data[[qc.l[j]]][,1]
    var.vec = data[[og.l[j]]][[var.nm[j]]]
    var.qc = data[[qc.l[j]]][[var.nm[j]]]
    create_input_plots(var.nm[j], pretty.nm[j], var.u[j], var.vec, dt.vec, var.qc, dt.qc, stat.nm, plot.type[j])}
  
  # Prepare output plot vectors if continuous simulation.
  if (sm == 1) {
    var.nm = c("PRECIP", "BPS", "ELEN", "AIR_TEMP", "REL_HUM", "MIN_TEMP", "MAX_TEMP", "SO_RAD", "W_VEL", "W_DIR", "DP_TEMP")
    pretty.nm = c("PRECIPITATION", "BREAKPOINTS", "STORMS", "AIR TEMPERATURE", "RELATIVE HUMIDITY", "MINIMUM TEMPERATURE", "MAXIMUM TEMPERATURE", "SOLAR RADIATION", "WIND VELOCITY", "WIND DIRECTION", "DEW POINT TEMPERATURE")
    var.u = c("mm", "#", "#", "C", "%", "C", "C", "Langleys/Day", "m/s", "Degrees from North (CW)", "C")
    plot.type = c("h", "h", "h", "l", "l", "l", "l", "l", "l", "l", "l")
    
    # Create output plots.
    plot.list = c("ANNUAL", "MONTHLY", "DAILY", "STORMS")
    for (i in plot.list){
      for (j in 1:length(var.nm)) {
        setwd(p)
        setwd("OUTPUT")
        create_directory(i)
        setwd(i)
        if (i == "ANNUAL"){try(annual_plots(data, 12, 20, var.nm[j], pretty.nm[j], var.u[j], stat.nm), silent = T)}
        if (i == "MONTHLY"){try(monthly_plots(data, 13, 21, var.nm[j], pretty.nm[j], var.u[j], stat.nm), silent = T)}
        if (i == "DAILY"){try(daily_plots(data, 10, 18, var.nm[j], pretty.nm[j], var.u[j], stat.nm, plot.type[j]), silent = T)}
        if (toupper(ei) == "T") {
          if (i == "STORMS"){storm_plots(data, 9, 17, stat.nm)}}}}}
  
  # Flexible plot functionality.
  setwd(p)
  setwd("OTHER")
  create_other_plots(data, stat.nm)
  
  setwd(home.dir)}


# A function to create plots for each variable.
create_input_plots = function(var.nm, pty.nm, var.u, var.vec, dt.vec, var.qc, dt.qc, stat.nm, plot.type) {
  create_directory(pty.nm)
  setwd(pty.nm)
  
  # Exclude missing data.
  vec.keep = intersect(which(!is.na(dt.vec) == T), which(!is.na(var.vec) == T))
  qc.keep = intersect(which(!is.na(dt.qc) == T), which(!is.na(var.qc) == T))
  var.vec = var.vec[vec.keep]
  dt.vec = dt.vec[vec.keep]
  var.qc = var.qc[qc.keep]
  dt.qc = dt.qc[qc.keep]
  
  # Plot time series (original vs quality checked).
  if (length(na.omit(var.vec)) > 0) {
    png(paste(stat.nm, pty.nm, "INPUT TS.png", sep = " "), width = 2160, height = 1080, pointsize = 36)
    plot(dt.vec, var.vec, type = plot.type, main = paste("INPUT", pty.nm, "TIMESERIES", sep = " "), xlab = "DATETIME", ylab = paste(pty.nm, " (", var.u, ")", sep = ""))
    if (length(var.qc) > 0 & toupper(qc) == "T") {lines(dt.qc, var.qc, type = plot.type, col = "red")}
    par(fig=c(0, 1, 0, 1), oma=c(0, 0, 0, 0), mar=c(0, 0, 0, 0), new=TRUE)
    plot(0, 0, type='n', bty='n', xaxt='n', yaxt='n')
    legend("topright", inset=c(0.0425,0), legend = c("Original", "Quality-Checked"), lty = c(1, 1), col = c("black", "red"))
    dev.off()}
  
  # Plot histogram (original vs quality checked) if continuous simulation.
  if (length(na.omit(var.vec)) > 0 & sm == 1) {
    UL = max(var.vec)
    LL = min(var.vec)
    bins = seq(LL, UL, by = (UL-LL)/100)
    png(paste(stat.nm, pty.nm, "INPUT HIST.png", sep = " "), width = 2160, height = 2160, pointsize = 48)
    if (length(var.qc) > 0 & toupper(qc) == "T") {
      hist(var.qc, freq = F, breaks = bins, xlim = c(LL, UL), col = "red", main = paste("INPUT", pty.nm, "HISTOGRAM", sep = " "), xlab = paste(pty.nm, " (", var.u, ")", sep = ""))
      hist(var.vec, freq = F, breaks = bins, density = 10, add = T)}
    if (length(var.qc) == 0 | toupper(qc) == "F") {
      hist(var.vec, freq = F, breaks = bins, xlim = c(LL, UL), density = 10, main = paste("INPUT", pty.nm, "HISTOGRAM", sep = " "), xlab = paste(pty.nm, " (", var.u, ")", sep = ""))}
    legend("topright", legend = c("Original", "Quality-Checked"), density = c(10, NA), fill = c("black", "red"))
    dev.off()}
  
  # Boxplot placeholder.
  # boxplot(var ~ mns, main = paste("Boxplot of ", j, sep = ""), xlab = paste(j, " (", var.unit, ")", sep = ""))
  
  setwd(p)}


# A function to create annual plots for output data.
annual_plots = function(data, og.df, gf.df, var.nm, pty.nm, var.u, stat.nm) {
  
  # Load original data.
  var.vec = data[[og.df]][[var.nm]]
  dt.vec = data[[og.df]]$YYYY
  var.gf = NULL
  dt.gf = NULL
  
  # Load gap filled data if appropriate.
  if (toupper(id) == "T") {
    var.gf = data[[gf.df]][[var.nm]]
    dt.gf = data[[gf.df]]$YYYY}
  
  # Plot time series (original vs gap filled).
  if (length(na.omit(var.vec)) > 0) {
    png(paste(stat.nm, pty.nm, "ANNUAL TS.png", sep = " "), width = 2160, height = 1080, pointsize = 36)
    if (length(var.gf) > 0) {
      barplot(var.gf, names.arg = dt.vec, col = "red", main = paste("ANNUAL", pty.nm, "TIMESERIES", sep = " "), xlab = "YEAR", ylab = paste(pty.nm, " (", var.u, ")", sep = ""))
      barplot(var.vec, density = 10, add = T)}
    if (length(var.gf) == 0) {
      barplot(var.vec, names.arg = dt.vec, density = 10, main = paste("ANNUAL", pty.nm, "TIMESERIES", sep = " "), xlab = "YEAR", ylab = paste(pty.nm, " (", var.u, ")", sep = ""))}
    par(fig=c(0, 1, 0, 1), oma=c(0, 0, 0, 0), mar=c(0, 0, 0, 0), new=TRUE)
    plot(0, 0, type='n', bty='n', xaxt='n', yaxt='n')
    legend("topright", inset=c(0.0425,0), legend = c("Original", "Gap-Filled"), density = c(10, NA), fill = c("black", "red"))
    dev.off()}
  
  setwd(p)}


# A function to create monthly plots for output data.
monthly_plots = function(data, og.df, gf.df, var.nm, pty.nm, var.u, stat.nm) {
  
  # Load original data.
  var.vec = data[[og.df]][[var.nm]]
  dt.vec = data[[og.df]]$MM
  var.gf = NULL
  dt.gf = NULL
  
  # Load gap filled data if appropriate.
  if (toupper(id) == "T") {
    var.gf = data[[gf.df]][[var.nm]]
    dt.gf = data[[gf.df]]$MM}
  
  # Plot aggregates (original vs gap filled).
  if (length(na.omit(var.vec)) > 0) {
    png(paste(stat.nm, pty.nm, "MONTHLY MEAN.png", sep = " "), width = 2160, height = 1080, pointsize = 36)
    if (length(var.gf) > 0) {
      barplot(var.gf, names.arg = dt.vec, col = "red", main = paste("MONTHLY MEAN", pty.nm, sep = " "), xlab = "MONTH", ylab = paste(pty.nm, " (", var.u, ")", sep = ""))
      barplot(var.vec, density = 10, add = T)}
    if (length(var.gf) == 0) {
      barplot(var.vec, names.arg = dt.vec, density = 10, main = paste("MONTHLY MEAN", pty.nm, sep = " "), xlab = "MONTH", ylab = paste(pty.nm, " (", var.u, ")", sep = ""))}
    par(fig=c(0, 1, 0, 1), oma=c(0, 0, 0, 0), mar=c(0, 0, 0, 0), new=TRUE)
    plot(0, 0, type='n', bty='n', xaxt='n', yaxt='n')
    legend("topright", inset=c(0.0425,0), legend = c("Original", "Gap-Filled"), density = c(10, NA), fill = c("black", "red"))
    dev.off()}
  
  setwd(p)}


# A function to create daily plots for output data.
daily_plots = function(data, og.df, gf.df, var.nm, pty.nm, var.u, stat.nm, plot.type) {
  
  # Load original data.
  var.vec = data[[og.df]][[var.nm]]
  dt.vec = as.Date(as.character(data[[og.df]]$YYYYMMDD), format = "%Y%m%d")
  var.gf = NULL
  dt.gf = NULL
  dt.range = c(min(dt.vec), max(dt.vec))

  # Load gap filled data if appropriate.
  if (toupper(id) == "T") {
    var.gf = data[[gf.df]][[var.nm]]
    dt.gf = as.Date(as.character(data[[gf.df]]$YYYYMMDD), format = "%Y%m%d")
    dt.range = c(min(dt.gf, dt.range[1]), max(dt.gf, dt.range[2]))
    
    # Remove original values.
    dups = which(!is.na(var.vec))
    var.gf[dups] = NA}
  
  # Plot time series (original vs gap filled).
  if (length(na.omit(var.vec)) > 0) {
    png(paste(stat.nm, pty.nm, "DAILY TS.png", sep = " "), width = 2160, height = 1080, pointsize = 36)
    plot(dt.vec, var.vec, type = plot.type, main = paste("DAILY", pty.nm, "TIMESERIES", sep = " "), xlim = dt.range, xlab = "DATE", ylab = paste(pty.nm, " (", var.u, ")", sep = ""))
    if (length(var.gf) > 0) {lines(dt.gf, var.gf, type = plot.type, col = "red")}
    par(fig=c(0, 1, 0, 1), oma=c(0, 0, 0, 0), mar=c(0, 0, 0, 0), new=TRUE)
    plot(0, 0, type='n', bty='n', xaxt='n', yaxt='n')
    legend("topright", inset=c(0.0425,0), legend = c("Original", "Gap-Filled"), lty = c(1, 1), col = c("black", "red"))
    dev.off()}
  
  setwd(p)}


# A function to create storm plots for output data.
storm_plots = function(data, og.df, gf.df, stat.nm) {
  
  # Prepare storm plot vectors.
  col.list = colnames(data[[og.df]])[-1]
  eqn.count = (length(col.list) - 10)/2
  unit.list = c("mm", "min", "min", "fraction", "mm/hr", "fraction", "mm/hr", "mm/hr", "mm/hr", "min",
                rep("MJ/ha", eqn.count), rep("MJ-mm/ha-hr", eqn.count))
  
  # Loop over variables.
  for (k in 1:length(col.list)) {
    
    # Load original data.
    var.vec = data[[og.df]][[col.list[k]]]
    dt.vec = data[[og.df]][["DT"]]
    var.gf = NULL
    
    # Load gap filled data if appropriate.
    if (toupper(id) == "T") {
      var.gf = data[[gf.df]][[col.list[k]]]
      dt.gf = data[[gf.df]][["DT"]]
      
      # Remove original values.
      dups = which(dt.gf %in% na.omit(dt.vec))
      var.gf = var.gf[-dups]}
    
    # Plot histogram (original vs quality checked).
    if (length(na.omit(var.vec)) > 0) {
      UL = max(var.vec, na.rm = T)
      LL = min(var.vec, na.rm = T)
      bins = seq(LL, UL, by = (UL-LL)/100)
      png(paste(stat.nm, col.list[k], "STORM HIST.png", sep = " "), width = 2160, height = 2160, pointsize = 48)
      if (length(var.gf) > 0) {
        hist(var.gf, freq = F, breaks = bins, xlim = c(LL, UL), col = "red", main = paste("STORM", col.list[k], "HISTOGRAM", sep = " "), xlab = paste(col.list[k], " (", unit.list[k], ")", sep = ""))
        hist(var.vec, freq = F, breaks = bins, density = 10, add = T)}
      if (length(var.gf) == 0) {
        hist(var.vec, freq = F, breaks = bins, xlim = c(LL, UL), density = 10, main = paste("STORM", col.list[k], "HISTOGRAM", sep = " "), xlab = paste(col.list[k], " (", unit.list[k], ")", sep = ""))}
      legend("topright", inset=c(-0.2,0), legend = c("Original", "Gap-Filled"), density = c(10, NA), fill = c("black", "red"))
      dev.off()}}
  
  setwd(p)}


# A function to create plots on demand.
create_other_plots = function(data, stat.nm) {
  
  # Plot intensity time series (with zero preciptiation moments).
  # CONDITIONS:
  if (sm == 2) {
    
    # Set vectors.
    plot.df = data[[5]]
    df.now = as.data.frame(plot.df$DT_1)
    df.now$INT = plot.df$INT
    names(df.now) = c("DT", "INT")
    
    # Add zeros.
    dt.new = df.now$DT - plot.df$DUR * 60
    keep = !(dt.new %in% df.now$DT)
    df.new = as.data.frame(dt.new[keep])
    df.new$INT = 0
    names(df.new) = c("DT", "INT")
    
    # Combine dataframes.
    df.out = rbind(df.now, df.new)
    df.out = df.out[order(df.out$DT),]
    
    if (length(na.omit(df.out$DT)) > 0) {
      png(paste(stat.nm, "INPUT INTENSITY TS.png", sep = " "), width = 2160, height = 1080, pointsize = 36)
      plot(df.out$DT, df.out$INT, type = "S", main = "INPUT INTENSITY TIMESERIES", xlab = "Datetime", ylab = "INTENSITY (mm/hr)")
      dev.off()}}
  
  setwd(p)}


# A function to create annual summary data.
annual_summary = function(data, yly.ts, an.sum.loc) {
  data[[an.sum.loc]] = summary(data[[yly.ts]])
  return(data)}


# A function to export the primary data structure to file.
export_data = function(data) {
  
  # Prepare for export.
  if (toupper(verb) == "T") {cat(lr,"Exporting data...")}
  if (toupper(fn) == "STATION"){fn = data[[4]]["STATION"]}
  create_directory(e)
  setwd(e)
  
  # Perform export.
  if (ed == 6) {eb = "T"}
  if (ed %in% c(1,2)) {saveRDS(data, paste(fn, ".rds", sep = ""))}
  if (ed %in% c(1,3)) {export_to_csv(data, 5, 15, "PRECIP")}
  if (ed %in% c(1,4)) {export_to_csv(data, 10, 18, "DAILY")}
  if (ed %in% c(1,5)) {export_to_csv(data, 9, 17, "STORM")}
  if (ed %in% c(1,6)) {export_pcp_bps(data, 5, 15, "BPS")}

  setwd(home.dir)}


# A function to create csv output for a specified dataframe.
export_to_csv = function(data, og.df, gf.df, csv.nm) {
  setwd(e)
  df.loc = ifelse(toupper(id) == "T", gf.df, og.df)
  if (toupper(fn) == "STATION"){fn = data[[4]]["STATION"]}
  write_csv(data[[df.loc]], paste(fn, csv.nm, "DATA.csv", sep = " "))
  setwd(home.dir)}


# A function to create csv output for a specified dataframe.
export_pcp_bps = function(data, og.df, gf.df, csv.nm) {
  setwd(e)
  df.loc = ifelse(toupper(id) == "T", gf.df, og.df)
  if (toupper(fn) == "STATION"){fn = data[[4]]["STATION"]}
  
  # Set vectors.
  plot.df = data[[df.loc]]
  df.now = as.data.frame(plot.df$DT_1)
  df.now$PRECIP = plot.df$PRECIP
  names(df.now) = c("DT", "PRECIP")
  
  # Add zeros.
  dt.new = df.now$DT - plot.df$DUR * 60
  keep = !(dt.new %in% df.now$DT)
  df.new = as.data.frame(dt.new[keep])
  df.new$PRECIP = 0
  names(df.new) = c("DT", "PRECIP")
  
  # Combine dataframes.
  df.out = rbind(df.now, df.new)
  df.out = df.out[order(df.out$DT),]
  
  # Write to file.
  write_csv(df.out, paste(fn, csv.nm, "DATA.csv", sep = " "))
  setwd(home.dir)}


# A function to create header data for .cli file creation function.
generate_header_data = function(data) {
  if (toupper(verb) == "T") {cat(lr,"Generating header data...")}
  mm.loc = ifelse(toupper(id) == "T", 21, 13)
  
  # Get station data.
  station = data[[4]][["STATION"]]
  lat = format(round(as.numeric(data[[4]][["LAT"]]), 4), justify = "right", width = 8, nsmall = 4)
  lon = format(round(as.numeric(data[[4]][["LON"]]), 4), justify = "right", width = 9, nsmall = 4)
  elev = format(round(as.numeric(data[[4]][["ELEV"]]), 2), justify = "right", width = 6, nsmall = 2)
  oyr = format(round(as.numeric(data[[4]][["OBS_YRS"]]), 0), justify = "right", width = 3, nsmall = 0)
  byr = format(round(as.numeric(data[[4]][["B_YR"]]), 0), justify = "right", width = 4, nsmall = 0)
  syr = format(round(as.numeric(data[[4]][["YRS_SIM"]]), 0), justify = "right", width = 3, nsmall = 0)
  
  # Get monthly average data.
  m.min.t = data[[mm.loc]]$MIN_TEMP
  m.max.t = data[[mm.loc]]$MAX_TEMP
  m.sorad = data[[mm.loc]]$SO_RAD
  m.precip = data[[mm.loc]]$PRECIP
  
  # Prepare fixed format header.
  h.1 = paste(" ", cv, lr,
              "   ", sm, "   ", bf, "   ", wi, lr,
              "   ", "Station:", " ", station, lr,
              " Latitude Longitude Elevation (m) Obs. Years   Beginning Year  Years Simulated ", lr, sep = "")
  h.2 = paste(" ", lat, " ", lon, "     ", elev, "         ", oyr, "           ", byr, "             ", syr, sep = "")
  h.3 = paste(lr, " Observed monthly ave max temperature (C)", lr,
              " ", paste(format(round(m.max.t, 1), justify = "right", width = 5, nsmall = 1), collapse = " "),
              lr, " Observed monthly ave min temperature (C)", lr,
              " ", paste(format(round(m.min.t, 1), justify = "right", width = 5, nsmall = 1), collapse = " "),
              lr, " Observed monthly ave solar radiation (Langleys/day)", lr,
              " ", paste(format(round(m.sorad, 1), justify = "right", width = 5, nsmall = 1), collapse = " "),
              lr, " Observed monthly ave precipitation (mm)", lr,
              " ", paste(format(round(m.precip, 1), justify = "right", width = 5, nsmall = 1), collapse = " "), sep = "")
  
  # Prepare fixed format, non-breakpoint format column headers.
  if (bf == 0){
    h.4 = paste(lr, " Day Month Year  Prcp   Dur   TP     IP  T-Max  T-Min   Rad   W-Vel  W-Dir  T-Dew")
    h.5 = paste(lr, "                 (mm)   (h) (0-1)  (>=1)  (C)    (C)   (L/d)  (m/s)  (Deg)   (C)")}
  
  # Prepare fixed format, breakpoint format column headers.
  if (bf == 1){
    h.4 = paste(lr, " Day Month Year  Breaks  T-Max  T-Min   Rad   W-Vel  W-Dir  T-Dew")
    h.5 = paste(lr, "                   (#)    (C)    (C)   (L/d)  (m/s)  (Deg)   (C)")}
  
  # Combine and return.
  header = paste(h.1, h.2, h.3, h.4, h.5, sep = "")
  return(header)}


# A function to create export data for .cli file creation function.
generate_export_data = function(data, dly.loc, pcp.loc) {
  if (toupper(verb) == "T") {cat(lr,"Generating body data...")}
  
  # Format date data.
  dates = as.character(data[[dly.loc]][,1])
  dy = format(as.integer(format(as.Date(dates, format = "%Y%m%d"), format = "%d")), justify = "right", width = 2)
  mn = format(as.integer(format(as.Date(dates, format = "%Y%m%d"), format = "%m")), justify = "right", width = 2)
  yr = format(as.integer(format(as.Date(dates, format = "%Y%m%d"), format = "%Y")), justify = "right", width = 4)
  
  # Prepare daily data.
  daily_df = data[[dly.loc]]
  if (sm == 2) {daily_df = daily_df[1,]}
  dates = daily_df$YYYYMMDD
  daily_bps_adj = rep(0, nrow(daily_df))
  daily_df$BPS[is.na(daily_df$BPS)] = 0

  # Prepare precipitation data.
  pcp_df = data[[pcp.loc]]
  pcp_days = format(as.Date(as.character(pcp_df$DT_1)), format = "%Y%m%d")
  pcp_times = as.numeric(format(pcp_df$DT_1, "%H")) * 3600 + as.numeric(format(pcp_df$DT_1, "%M")) * 60 + as.numeric(format(pcp_df$DT_1, "%S"))
  pcp_times[pcp_times == 0] = 24 * 3600
  clock_resets = c(NA, tail(pcp_times, length(pcp_times) - 1) - head(pcp_times, length(pcp_times) - 1))

  # Move a midnight breakpoint to the previous day.
  decrease_days = pcp_days[grepl("00:00:00", pcp_df$DT_1)]
  increase_days = format(as.Date(decrease_days, format = "%Y%m%d") - 1, format = "%Y%m%d")
  daily_bps_adj[which(daily_df$YYYYMMDD %in% decrease_days)] = daily_bps_adj[which(daily_df$YYYYMMDD %in% decrease_days)] - 1
  daily_bps_adj[which(daily_df$YYYYMMDD %in% increase_days)] = daily_bps_adj[which(daily_df$YYYYMMDD %in% increase_days)] + 1

  # Add a breakpoint for everyday there is precipitation.
  updated_bps = daily_df$BPS + daily_bps_adj
  updated_bps[which(updated_bps > 0)] = updated_bps[which(updated_bps > 0)] + 1
  daily_df$BPS = updated_bps

  # Add a breakpoint for every non-precipitation breakpoint.
  pcp_new_days = which(clock_resets < 0 | pcp_df$ANT >= 1440 | pcp_df$DUR >= 1440)
  pcp_rain_gap = which((pcp_df$BTW) > 0)
  pcp_gap_increase = setdiff(pcp_rain_gap, pcp_new_days)
  pcp_gap_days = format(pcp_df$DT_1[pcp_gap_increase], format = "%Y%m%d")
  midnight_gap = format(pcp_df$DT_1[pcp_gap_increase], format = "%H%M%S")
  pcp_gap_days[midnight_gap == "000000"] = format(as.POSIXct(pcp_df$DT_1[pcp_gap_increase][midnight_gap == "000000"] - 24*3600), format = "%Y%m%d")
  increase_days = unname(sapply(pcp_gap_days, function(x) which(daily_df$YYYYMMDD %in% x)))
  rle_days = rle(increase_days)
  if (length(rle_days$values) > 0) {updated_bps[rle_days$values] = (mapply(function(x,y) updated_bps[x] + y, rle_days$values, rle_days$lengths))}
  
  # Compute non-breakpoint CLIGEN parameters.
  pcpDF = aggregate(pcp_df$PRECIP, by = list(as.Date(pcp_df$DT_1)), function(x) sum(x, na.rm = T))      # daily precipitation
  durDF = aggregate(pcp_df$DUR, by = list(as.Date(pcp_df$DT_1)), function(x) sum(x, na.rm = T))         # daily duration
  intDF = aggregate(pcp_df$INT, by = list(as.Date(pcp_df$DT_1)), function(x) max(x, na.rm = T))         # daily max intensity
  lenDF = aggregate(pcp_df$DUR, by = list(as.Date(pcp_df$DT_1)), function(x) length(x))                 # daily breakpoints
  iavDF = pcpDF
  ipkDF = pcpDF
  tpkDF = pcpDF
  tpkDF$x = 0
  iavDF$x = pcpDF$x/(durDF$x/60)                                                                        # daily average intensity
  ipkDF$x = intDF$x/iavDF$x                                                                             # daily ip ratio
  
  # Compute time-to-peak CLIGEN parameter.
  begin = 0
  for (i in 1:length(lenDF$x)) {
    end = begin + lenDF$x[i]
    range = (begin+1):end
    durations = pcp_df$DUR[range]
    intensities = pcp_df$INT[range]
    maxLocation = which.max(intensities)
    peakDuration = durations[maxLocation]
    previousDurations = durations[0:(maxLocation-1)]
    if (length(previousDurations) > 0) {peakTime = sum(previousDurations) + peakDuration/2}
    if (length(previousDurations) == 0) {peakTime = peakDuration/2}
    tpkDF[i,2] = peakTime/sum(durations)
    begin = end
  }
  
  # Merge results.
  cligenPCPDF = data.frame(pcpDF[,1], pcpDF$x, durDF$x/60, tpkDF$x, ipkDF$x)
  cligenPCPDF[,1] = format(as.Date(cligenPCPDF[,1]), "%Y%m%d")
  names(cligenPCPDF) = c("YYYYMMDD", "AMOUNT", "DURATION", "TP", "IP")
  dailyMergeDF = merge(daily_df, cligenPCPDF, by = "YYYYMMDD", all = T)
  
  # Zero non-precipitation rows.
  zeros = is.na(dailyMergeDF$AMOUNT)
  dailyMergeDF$AMOUNT[zeros] = 0
  dailyMergeDF$DURATION[zeros] = 0
  dailyMergeDF$TP[zeros] = 0
  dailyMergeDF$IP[zeros] = 0
  
  # Handle errors.
  dailyMergeDF$DURATION[dailyMergeDF$DURATION > 24] = 24
  dailyMergeDF$TP[dailyMergeDF$TP > 1] = 1
  dailyMergeDF$TP[dailyMergeDF$TP < 0] = 0
  dailyMergeDF$IP[dailyMergeDF$IP < 1] = 1
  
  # Format columns.
  nbrkpt = format(as.integer(daily_df$BPS), justify = "right", width = 3, nsmall = 0)
  adjbrkpt = format(as.integer(updated_bps), justify = "right", width = 3, nsmall = 0)
  tmin = format(round(as.numeric(daily_df$MIN_TEMP), 1), justify = "right", width = 5, nsmall = 1)
  tmax = format(round(as.numeric(daily_df$MAX_TEMP), 1), justify = "right", width = 5, nsmall = 1)
  rad = format(round(as.numeric(daily_df$SO_RAD), 1), justify = "right", width = 5, nsmall = 1)
  wvel = format(round(as.numeric(daily_df$W_VEL), 1), justify = "right", width = 5, nsmall = 1)
  wdir = format(round(as.numeric(daily_df$W_DIR), 1), justify = "right", width = 5, nsmall = 1)
  dew = format(round(as.numeric(daily_df$DP_TEMP), 1), justify = "right", width = 5, nsmall = 1)
  amount = format(round(as.numeric(dailyMergeDF$AMOUNT), 2), justify = "right", width = 5, nsmall = 2)
  duration = format(round(as.numeric(dailyMergeDF$DURATION), 2), justify = "right", width = 5, nsmall = 2)
  tp = format(round(as.numeric(dailyMergeDF$TP), 2), justify = "right", width = 5, nsmall = 2)
  ip = format(round(as.numeric(dailyMergeDF$IP), 2), justify = "right", width = 5, nsmall = 2)
  
  # Combine and export.
  if (bf == 1) {df_out = cbind(dy, mn, yr, nbrkpt, tmax, tmin, rad, wvel, wdir, dew, adjbrkpt)}
  if (bf == 0) {df_out = cbind(dy, mn, yr, amount, duration, tp, ip, tmax, tmin, rad, wvel, wdir, dew)}
  export = list(df_out, daily_df)
  return(export)}


# A function to write data to a .cli file.
create_cli_file = function(data, header, export) {
  if (toupper(verb) == "T") {cat(lr,"Generating .cli file...")}
  
  # Import data.
  pcp.loc = ifelse(toupper(id) == "T", 15, 5)
  df = export[[1]]
  daily_df = export[[2]]
  pcp_df = data[[pcp.loc]]
  pcp_df$DT_1 = format(as.POSIXct(pcp_df$DT_1), "%Y-%m-%d %H:%M:%S")

  # Initialize loop counters.
  current.pcp = 1
  last.pcp = 0
  daily_rows = 1:nrow(daily_df)
  
  # Handle Single Storm Simulation Mode
  if (as.numeric(sid) > 1 | sm == 2){
    
    # Get Start and End Times
    storm.loc = min(which(pcp_df$SID == sid))
    end.loc = max(which(pcp_df$SID == sid))
    start = as.POSIXct(as.Date(pcp_df$DT_1[storm.loc]), format = "%Y-%m-%d")
    end = as.POSIXct(as.Date(pcp_df$DT_1[end.loc]), format = "%Y-%m-%d")
    daily.start = as.numeric(format(as.Date(start, format = "%Y-%m-%d"), format = "%Y%m%d"))
    daily.end = as.numeric(format(as.Date(end, format = "%Y-%m-%d"), format = "%Y%m%d"))
    
    # Trim Dataframes
    gt_rows = which(pcp_df$DT_1 >= start)
    current.pcp = min(gt_rows)
    daily.dates = as.numeric(daily_df$YYYYMMDD)
    gt_rows = which(daily.dates >= daily.start)
    lt_rows = which(daily.dates <= daily.end)
    daily_rows = intersect(gt_rows, lt_rows)
    
    # Recompute Day Count
    daysCount <<- difftime(end, start, units = "days")}
  
  # Prepare precipitation data.
  pcp_df$HOUR = substr(pcp_df$DT_1, 12, 13)
  pcp_df$MIN = substr(pcp_df$DT_1, 15, 16)
  pcp_df$HOUR[intersect(which(pcp_df$HOUR == "00"), which(pcp_df$MIN == "00"))] = "24"
  
  # Stop when there are missing data.
  if (nrow(daily_df) < ceiling(as.numeric(daysCount))){
    stop("There are missing data. Rerun and perform quality checking [-qc] and fill missing data [-id].")}
  
  # Create file.
  create_directory(o)
  setwd(o)
  if (toupper(fn) == "STATION"){fn = data[[4]]["STATION"]}
  of = paste(fn, ".cli", sep = "")
  file.create(of, overwrite = T)
  
  # Write header.
  temp.file = header

  # Write daily lines.
  time.next.status = F
  zero.out = format(round(0, 2), justify = "right", width = 6, nsmall = 2)
  for (i in daily_rows){
    
    # Handle breakpoint and non-breakpoint formats.
    if (bf == 0) {temp.new = paste(lr, "  ", df[i,1], "   ", df[i,2], "  ", df[i,3], " ", df[i,4], " ", df[i,5], " ", df[i,6], " ", df[i,7], " ", df[i,8], "  ", df[i,9], "  ", df[i,10], "  ", df[i,11], "  ", df[i,12], "  ", df[i,13], sep = "")}
    if (bf == 1) {temp.new = paste(lr, "  ", df[i,1], "   ", df[i,2], "  ", df[i,3], "    ", df[i,11], "   ", df[i,5], "  ", df[i,6], "  ", df[i,7], "  ", df[i,8], "  ", df[i,9], "  ", df[i,10], sep = "")}
    temp.file = append(temp.file, temp.new)
    
    # Write breakpoint format output.
    if (bf == 1) {

      # Write the first breakpoint of the day.
      if (daily_df$BPS[i] > 0){
        bp.time = as.numeric(pcp_df$HOUR[current.pcp]) + as.numeric(pcp_df$MIN[current.pcp])/60 - as.numeric(pcp_df$DUR[current.pcp])/60
        time.out = format(round(bp.time, 3), justify = "right", width = 6, nsmall = 3)
        temp.new = paste(lr, time.out, " ", zero.out, sep = "")
        temp.file = append(temp.file, temp.new)
        bp.depth = 0
        new.day = T
  
        # Write precipitation lines (precip and non-precip breaks).
        last.pcp = current.pcp + daily_df$BPS[i] - 2
        for (j in current.pcp:last.pcp){
          
          # Write non-precip breaks.
          if (new.day == F & pcp_df$BTW[j] > 0){
            bp.time = as.numeric(pcp_df$HOUR[j]) + as.numeric(pcp_df$MIN[j])/60 - as.numeric(pcp_df$DUR[j])/60
            time.out = format(round(bp.time, 3), justify = "right", width = 6, nsmall = 3)
            depth.out = format(round(bp.depth, 2), justify = "right", width = 6, nsmall = 2)
            temp.new = paste(lr, time.out, " ", depth.out, sep = "")
            temp.file = append(temp.file, temp.new)}
          
          # Write precip breaks.
          bp.time = as.numeric(pcp_df$HOUR[j]) + as.numeric(pcp_df$MIN[j])/60
          bp.depth = as.numeric(pcp_df$PRECIP[j]) + bp.depth
          time.out = format(round(bp.time, 3), justify = "right", width = 6, nsmall = 3)
          depth.out = format(round(bp.depth, 2), justify = "right", width = 6, nsmall = 2)
          temp.new = paste(lr, time.out, " ", depth.out, sep = "")
          temp.file = append(temp.file, temp.new)
          
          # Stop if the end of the dataframe is encountered.
          if (j == last.pcp){need.break = F; break()}
          if ((j + 1) > nrow(pcp_df)){need.break = F; break()}
          new.day = F}}}
    
    # Setup for the next iteration.
    current.pcp = last.pcp + 1}
  
  # Write output to file. "Sink" is supposedly faster than "write_lines" for Windows implementations.
  sink(of, append = F)
  cat(temp.file)
  sink()
  
  setwd(home.dir)}


# A function to end multiprocessing.
kill_cluster = function() {
  cat("Killing multiprocessing virtual cluster... ")
  stopImplicitCluster()
  cat("Done.", lr, lr)}


# A function for printing "data" objects (intended to be used primarily as a development utility).
view_data = function(data) {
  for (i in 1:length(data)){
    print(class(data[[i]]))
    if(class(data[[i]]) == "data.frame"){print(data[[i]][1:5,])}
    #if(class(data[[i]]) == "list"){print(data[[i]][1:5])}
  }}


# A function to stop program execution quietly.
stop_quietly = function() {
  opt = options(show.error.messages = FALSE)
  on.exit(options(opt))
  stop()}


# A function to execute a filling and post-filling workflow.
fill_workflow = function(data) {

  # Perform filling routines.
  data = fill_data(data, 5, 10, 18, 15)
  alt <<- "f"
  
  # Recompute storm, precipitation, and daily values.
  data = break_storms(data, 15, 16)
  data = process_daily_data(data, 18, NA, 18, 19, 20, 21)
  data = process_precip_data(data, 15, 18, 19, 20, 21)
  data = calculate_erosion_indices(data, 16, 17)
  data = annual_summary(data, 20, 22)
  
  # Recompute metadata.
  data[[4]][["B_YR"]] = substr(data[[18]]$YYYYMMDD[1], 1, 4)
  data[[4]][["YRS_SIM"]] = floor(as.numeric(difftime(as.Date(data[[18]]$YYYYMMDD[nrow(data[[18]])], format = "%Y%m%d"), as.Date(data[[18]]$YYYYMMDD[1], format = "%Y%m%d")))/365.2425)
  return(data)}


# A function to perform the core workflow of WEPPCLIFF.
core_workflow = function(file) {
  file = list(file)
  assign_final_args()
  if (toupper(alt) == "F") {x = c(1, 3)}
  if (toupper(cv) == "F") {x = 1; id = "f"; qc = "f"}
  data = store_data(file)
  data = convert_data(data)
  data = remove_missing_datetime_rows(data)
  data = preserve_missing_data(data, x)
  data = create_duration_data(data, x)
  if (toupper(ai) != "F") {data = aggregate_precip_data(data)}
  data = convert_units(data)
  data = initialize_qc_data(data)
  if (toupper(qc) == "T"){data = quality_check_inputs(data)}
  data = trim_data(data, 5, 6, 7, 8)
  if (toupper(ei) == "T") {data = calculate_erosion_indices(data, 8, 9)}
  if (toupper(cv) != "F") {data = process_daily_data(data, 7, 6, 10, 11, 12, 13)}
  data = process_precip_data(data, 5, 10, 11, 12, 13)
  if (toupper(qc) == "T"){data = quality_check_outputs(data, 10)}
  data = annual_summary(data, 12, 14)
  data = preserve_missing_data(data, 13)
  if (toupper(id) == "T") {data = fill_workflow(data)}
  if (toupper(pd) == "T") {try(graph_data(data), silent = T)}
  if (ed > 0) {export_data(data)}
  if (toupper(cv) != "F") {
    header = generate_header_data(data)
    if (toupper(id) == "F") {export = generate_export_data(data, 10, 5)}
    if (toupper(id) == "T") {export = generate_export_data(data, 18, 15)}
    create_cli_file(data, header, export)}}


# A function to execute the WEPPCLIFF workflow in parallel.
parallel_execution = function(files, s) {
  
  # Print first line to screen.
  cat("Detected", s, "stations. Parallel processing has been enabled.", lr, lr)
  
  # Create multiprocessing cluster.
  create_cluster(s, mp)
  
  # Notify the user and create a log file.
  cat("Processing... see the log file (log.txt) for progress.", lr, lr)
  file.create("log.txt", overwrite = T)
  
  # Loop over each station file.
  foreach(iter = 1:s, .export = export.list, .verbose = F) %dopar% {
    
    # Set the library for each core.
    lapply(par.pack.list, library, lib.loc = lib.dir, character.only = T, quietly = T, verbose = F, attach.required = T)
    
    # Print progress to the log file.
    setwd(o)
    sink("log.txt", append = F)
    cat(paste("Processing ", iter, " of ", s, " stations... ", sep = ""))
    sink()
    
    # Load a file.
    f = files[iter]
    file = load_input_file(f)
    check_input_format(file)
    file = preprocess_file(file)
    
    # Perform the core workflow.
    core_workflow(file)}
  
  # Kill the multiprocessing cluster.
  kill_cluster()}


# A function to execute the WEPPCLIFF workflow in series.
series_execution = function(files, s) {
  
  # Print first line to screen.
  if (s > 1){cat("Detected", s, "stations. Parallel processing has been disabled.", lr, lr)}
  if (s == 1){cat("Detected 1 station. Parallel processing has been disabled.", lr, lr)}
  
  # Loop over each station file.
  for (iter in 1:s) {
    
    # Time the execution.
    t.time = system.time({
      
      # Print for each station.
      if (s > 1){cat(paste("Processing ", iter, " of ", s, " stations... ", sep = ""))}
      if (s == 1){cat(paste("Processing station... ", sep = ""))}
      
      # Load a file.
      f = files[iter]
      file = load_input_file(f)
      check_input_format(file)
      file = preprocess_file(file)
      
      # Perform the core workflow.
      core_workflow(file)})
    
    # Print execution time results for each station.
    cat("Completed in", t.time[3],"seconds.", lr, lr)}}


# The main program function.
main = function() {
  home.dir <<- getwd()

  # Read in arguments.
  parse_arg_locations()
  early_license_agreement()
  
  # Print logo and license information.
  print_weppcliff_logo()
  if (toupper(la) == "Y") {print_license_agreement()}
  if (toupper(la) != "Y") {prompt_license_agreement()}
  
  # Initiate run.
  assign_args_to_vars()
  assign_empty_args()
  create_base_directory()
  set_wds()
  Sys.setenv(TZ = tz)
  
  # First run installation.
  if (fr == "t"){
    install_dependencies()
    suppressMessages(load_packages())
    cat("Installation successful. WEPPCLIFF is now ready to run.",lr, collapse = "")
    stop_quietly()}
  
  # Read from file and store for processing.
  t.time = system.time({
    
    # Check arguments and load libraries.
    check_args()
    suppressMessages(load_packages())
    
    # Load a single file (if specified).
    if (length(f) == 1) {s = 1; files = f}
    
    # Load a directory of files (if specified).
    if (length(f) == 0) {files = load_input_directory(); s = length(files)}
    
    # Process stations based on the number of stations.
    if (toupper(mp) != "F" && s > 1) {parallel_execution(files, s)}
    if (toupper(mp) == "F" || s <= 1) {series_execution(files, s)}})
  
  # Print total execution time results for this run instance and closing message.
  cat("Program executed successfully in", t.time[3],"seconds... now exiting WEPPCLIFF script.", lr, lr, lr)
  cat(paste(rep("*", 80), collapse = ""), lr, lr)}


#############################################################################
############################### Global Objects ##############################
#############################################################################

# This list is not comprehensive (does not include runtime defined objects).
# There are still some global objects defined during execution.

lr = "\n"                                 # A universal line return.
x = 1:3                                   # Datetime groups to quality check.
args = commandArgs(trailingOnly = T)      # User specified arguments (stdin).

flags = c("fr", "la",
          "d", "o", "e", "p", "l", "f", "fn", "delim", "fsp", "isc", "rs",
          "u", "qc", "id", "pd", "ed", "alt", "pmd",
          "cp", "pi", "ai", "ei", "ee",
          "sid", "tth", "dth",
          "qcop", "chkth", "spkth", "strth", "stkth", "rp",
          "im", "io", "qi", "iv",
          "tz", "sdt", "edt", "rtb", "ipb", "dtf1", "dtf2", "dtf3",
          "cv", "sm", "bf", "wi", 
          "mp",
          "prof", "pint", "mepr", "gcpr", "lnpr", "warn", "verb")

flagnames = c("First Run", "License Agreement",
              "Input Directory", "Output Directory", "Export Directory", "Plot Directory", "Library Directory", "Input Filename", "Output Filename", "File Delimiter", "File Search Pattern", "Ignore Search Case", "Recursive Search",
              "Unit Conversion", "Quality Check", "Impute Missing Data", "Plot Data", "Export Data", "Use Alternative Data", "Preserve Missing Data",
              "Cumulative Precipitation", "Precipitation Interval", "Aggregation Interval", "Calculate Erosion Indices", "Energy Equation(s)",
              "Storm Identifier", "Storm Separation Time Threshhold", "Storm Separation Depth Threshhold",
              "Quality Checking Option", "Checking Threshold", "Spiking Threshold", "Streaking Threshold", "Sticking Threshold", "Return Period",
              "Impute Method", "Iteration Override", "Quick Impute", "Impute Verbosity",
              "Time Zone", "Start Datetime", "End Datetime", "Round Time Bounds", "Ignore Precipitation Bounds", "Precipitation Datetime Format", "Alternative Data Datetime Format", "Non-Precipitation Datetime Format",
              "CLIGEN Version", "Simulation Mode", "Breakpoint Format", "Wind Information",
              "Multiprocessing",
              "Profile Code", "Profile Interval", "Profile Memory", "Profile Garbage Collection", "Profile Lines", "Show Warnings", "Verbosity")

flagtypes = c("INSTALLATION ARGUMENTS",
              "INPUT/OUTPUT ARGUMENTS",
              "FUNCTIONALITY ARGUMENTS",
              "PRECIPITATION ARGUMENTS",
              "STORM CONTROL ARGUMENTS",
              "QUALITY CONTROL ARGUMENTS",
              "IMPUTE CONTROL ARGUMENTS",
              "DATETIME CONTROL ARGUMENTS",
              "CLIGEN FILE FORMAT ARGUMENTS",
              "OPTIMIZATION ARGUMENTS",
              "DEVELOPER ARGUMENTS")

flagcount = c(1,
              3,
              14,
              20,
              26,
              29,
              35,
              39,
              47,
              51,
              52)

var.e.list = c("lr", "args", flags, "u.loc", "ee.loc", "home.dir", "lib.dir", "package.list", "par.pack.list")
package.list = c("backports", "crayon", "vctrs", "tzdb", "cli", "vroom", "readr", "rlist", "iterators", "foreach", "doParallel", "EnvStats", "mice", "RcppParallel", "withr", "ggplot2", "profvis", "data.table", "jsonlite")
par.pack.list = c("backports", "crayon", "vctrs", "tzdb", "cli", "vroom", "readr", "rlist", "EnvStats", "mice", "withr", "ggplot2", "profvis", "data.table", "jsonlite")
function.e.list = c(lsf.str())
export.list = c(var.e.list, function.e.list)


#############################################################################
############################## Troubleshooting ##############################
#############################################################################

#traceback()        # Uncomment to trace errors.
#view_data(data)    # Move and uncomment to print data to screen.
#options(warn = 2)  # Uncomment to stop execution at the first warning.
# Set to 0 to ignore warnings.

# Move and uncomment to print global objects.
#print(names(as.list(.GlobalEnv)))
#saveRDS(data, "C:/RDebug/temp2.rds")
#data = readRDS("C:/RDebug/temp2.rds")


#############################################################################
################################ Run Program ################################
#############################################################################

main()


#############################################################################
############################# Developer Options #############################
#############################################################################

if (toupper(warn) == "T") {warnings()}
if (toupper(prof) == "T") {
  run.time = Sys.time()
  Rprof(paste("PROFILE ", run.time, ".txt", sep = ""), interval = as.numeric(pint),
        memory.profiling = as.logical(toupper(mepr)), gc.profiling = as.logical(toupper(gcpr)),
        line.profiling = as.logical(toupper(lnpr), numfiles = 10000, bufsize = 1000000))
  main()
  Rprof(NULL)
  summaryRprof(paste("PROFILE ", run.time, ".txt", sep = ""))}


#############################################################################
############################### Code Archive ################################
#############################################################################

# package.list = c("backports", "crayon", "vctrs", "readr", "rlist", "iterators", "foreach", "doParallel", "hashmap", "EnvStats", "mice", "RcppParallel", "withr", "ggplot2", "LambertW", "profvis", "data.table")

# # A function to split data for parallel or standard processing.
# split_data = function(file) {
#   t.time = system.time({
#     cat("Splitting data by station... ")
#     stats = na.omit(unique(file$STATION))
#     if(length(stats) > 1){file = split(file, file$STATION)}
#     if(length(stats) <= 1){file = list(file)}})
#   cat("Completed in", t.time[3],"seconds.", lr, lr)
#   return(file)}

# # A function to build a hashed R environment (slow construction, fastest lookup, flexible values, named keys only).
# hash_env = function(k, v) {
#   if (length(k) == length(v)){
#     my_env = new.env(hash = T)
#     for (i in paste(k)){my_env[[i]] = v}}
#   return(myenv)}

# # A function to build an Rcpp hash map (fast construction, fast lookup, atomic values, atomic keys).
# hash_rcpp = function(k, v) {
#   if (length(k) == length(v)){my_hm = hashmap(k, v)}
#   return(my_hm)}

# # A function to check input timezone and set to default if not supported.
# check_tz = function(data) {
#   stat_data = as.data.frame(unname(data[[4]]), stringsAsFactors = F)
#   if (length(na.omit(data[[4]][["TZ"]])) > 0){tz_input = data[[4]][["TZ"]]}
#   else {tz_input = NA}
#   if (length(na.omit(tz_input)) == 0){tz_input = tz}
#   tz_check = which(OlsonNames() == tz_input)
#   tz_input = OlsonNames()[tz_check]
#   if (length(tz_check) != 1){tz_input = "GMT"}
#   Sys.setenv(TZ = tz_input)
#   return(tz_input)}

# # A function to normalize a vector (using maximum-minimum values).
# normalize = function(vec) {
#   min.vec = min(vec, na.rm = T)
#   cnt.vec = vec - min.vec
#   max.vec = max(vec, na.rm = T)
#   rng.vec = max.vec - min.vec
#   nml.vec = cnt.vec/rng.vec
#   return(nml.vec)}




