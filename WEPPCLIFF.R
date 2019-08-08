#############################################################################
############################## PROGRAM METADATA #############################
#############################################################################

#  Version: 1.0 (the initial public release)
#  Last Updated by: Ryan P. McGehee
#  Last Updated on: 8 August 2019
#  Purpose: This program was first designed to create an appropriate input
#           climate file (.cli) for a WEPP model run. However, the program
#           has evolved into a much more advanced and capable tool. See the
#           accompanying documentation for more information.


#############################################################################
############################## DEFINE FUNCTIONS #############################
#############################################################################

# A function to print the WEPPCLIFF logo to screen.
print_weppcliff_logo = function() {
  LOGO = {"\033[1;37m
________________________________________________________________________________
________________________________________________________________________________
\033[1;31m
 ___      ___ _______ _______  _______  _______ ___     _______ _______ _______
 | |  __  | | |  ___/ |  __  | |  __  | |  ___/ | |     |__ __| |  ___/ |  ___/
 | | /  \\ | | | |___  | |__| | | |__| | | |     | |       | |   | |___  | |___
 | |/ /\\ \\| | |  __/  |  ____| |  ____| | |     | |       | |   |  __/  |  __/
 \\   /  \\   / | |___  | |      | |      | |___  | |___   _| |_  | |     | |
  \\_/    \\_/  |_____| |_|      |_|      |_____| |_____| |_____| |_|     |_|
\033[1;37m
________________________________________________________________________________
________________________________________________________________________________
\033[0m"}
  
  cat(rep(lr, 30))
  cat(LOGO)}


# A function to print a license agreement and accept user response.
print_license_agreement = function() {
  LICENSE = {"\033[0m
  WEPP Climate File Formatter (WEPPCLIFF) Version 1.0
  Copyright (c) 2019 Ryan P. McGehee

  This is free and open source software, and as the exclusive property of the
      copyright holder, it is licensed under the Apache License 2.0.

  \033[1mUNDER THIS LICENSE YOU CAN FREELY:
      Execute, study, copy, or modify this software for your own personal use.\033[0m

  \033[1mUNDER THIS LICENSE YOU CANNOT:
      Distribute, sell, or profit from this software or any derivatives thereof
      (i.e. your own modifications) without the copyright holder's written and
      notorized agreement.

  Please provide an appropriate citation in any published work as follows:

  McGehee, R.P. 2019. WEPP Climate File Formatter (WEPPCLIFF). Available at:
      https://github.com/ryanpmcg/WEPPCLIFF

  Corresponding Author: R.P. McGehee
  E-mail: ryanpmcgehee@gmail.com\033[0m"}
  
  cat(lr)
  cat(LICENSE)}


# A function to print a license agreement and accept user response.
prompt_license_agreement = function() {
  print_license_agreement()
  cat(lr, lr, "\033[1;31mDo you accept these conditions? (Y/N)\033[0m", lr, lr, collapse = "")
  stdin = file("stdin")
  response = readLines(stdin, n = 1L)
  close(stdin)
  if (toupper(response) != "Y"){
    stop("\033[1;31mYou must acknowledge your agreement to the license conditions with 'Y or y' to use this software.\033[0m")}}


# A function to create directories if they do not exist.
create_directory = function(var) {
  logic = dir.exists(toupper(var))
  if (logic == F){dir.create(var)}}


# A function to create the WEPPCLIFF base directory.
create_base_directory = function() {
  dirs = c("LIBRARY", "INPUT", "OUTPUT", "EXPORT", "PLOTS", "RUNS", "PROFILES")
  for (i in dirs){create_directory(i)}}


# A function to determine directory location.
set_wds = function() {
  home.dir <<- getwd()
  dir.names = c("lib.dir", "in.dir", "out.dir", "ex.dir", "plot.dir", "run.dir", "prof.dir")
  dir.locs = c("LIBRARY", "INPUT", "OUTPUT", "EXPORT", "PLOTS", "RUNS", "PROFILES")
  for (i in 1:length(dir.names)) {assign(dir.names[i], paste(home.dir, "/", dir.locs[i], sep = ""), envir = .GlobalEnv)}}


# A function to install R package dependencies on the first run.
install_dependencies = function() {
  cat("\033[0;37mInstalling R package dependencies...\033[0m", lr, lr, sep = "")
  lapply(package.list, install.packages, lib = lib.dir, type = "binary", repos = "http://cran.us.r-project.org")
  cat(lr, lr, "\033[0;37mDone.\033[0m", lr, lr, sep = "")}


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
  cat(paste("\033[0;37m User Specified Arguments:", length(grep("-", args)) - 1, "of", length(flags), "possible arguments.\033[0m", lr, lr, collapse = ""))
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
      cat(paste(rep(" \033[1;31m", spaces), collapse = ""),flagtypes[flagcounter], lr)
      flagcounter = flagcounter + 1}
    
    # Get the argument location and value to assign to a variable.
    x = get(paste(i, ".loc", sep = ""))
    value = args[x + 1]
    if (length(value) > 0){assign(paste(i), value, envir = .GlobalEnv)}
    if (length(value) == 0){assign(paste(i), NULL, envir = .GlobalEnv)}
    
    # Determine leader length and print arguments to screen.
    leader = paste(rep("-", 40 - nchar(flagnames[counter]) - nchar(i)), collapse = "")
    cat(paste(lr,"\033[0;37m",flagnames[counter], leader, i, ":\t", args[x + 1], "\033[0m",collapse = ""))
    counter = counter + 1}
  
  # End argument printing.
  cat(rep(lr, 3))
  cat(paste(rep("*", 80), collapse = ""), lr)
  cat(rep(lr, 2))}


# A function to fill unspecified arguments with defaults (# Def:).
assign_empty_args = function() {
  if (length(d) == 0){assign("d", in.dir, envir = .GlobalEnv)} # Def: current directory
  if (length(o) == 0){assign("o", out.dir, envir = .GlobalEnv)} # Def: current directory
  if (length(e) == 0){assign("e", ex.dir, envir = .GlobalEnv)} # Def: current directory
  if (length(u) == 0){assign("u", "m", envir = .GlobalEnv)} # Def: metric units
  if (length(fn) == 0){assign("fn", "out", envir = .GlobalEnv)} # Def: output file name will be "out.cli"
  if (length(fr) == 0){assign("fr", "f", envir = .GlobalEnv)} # Def: not first run
  if (length(la) == 0){assign("la", NULL, envir = .GlobalEnv)} # Def: NULL placeholder
  if (length(mp) == 0){assign("mp", "t", envir = .GlobalEnv)} # Def: multicore operation
  if (length(qc) == 0){assign("qc", "f", envir = .GlobalEnv)} # Def: do not check quality
  if (length(id) == 0){assign("id", "f", envir = .GlobalEnv)} # Def: do not fill data
  if (length(pd) == 0){assign("pd", "f", envir = .GlobalEnv)} # Def: do not plot data
  if (length(ed) == 0){assign("ed", 1, envir = .GlobalEnv)} # Def: export data in R binary file format
  if (length(cp) == 0){assign("cp", "f", envir = .GlobalEnv)} # Def: non-cumulative precipitation data
  if (length(pi) == 0){assign("pi", "f", envir = .GlobalEnv)} # Def: breakpoint format assumed
  if (length(cv) == 0){assign("cv", "0.0", envir = .GlobalEnv)} # Def: CLIGEN Version Unspecified
  if (length(sm) == 0){assign("sm", 1, envir = .GlobalEnv)} # Def: continuous simulation mode
  if (length(bf) == 0){assign("bf", 1, envir = .GlobalEnv)} # Def: breakpoint format CLI file
  if (length(wi) == 0){assign("wi", 1, envir = .GlobalEnv)} # Def: wind information provided
  if (length(tz) == 0){assign("tz", "GMT", envir = .GlobalEnv)} # Def: UTC (GMT) Timezone
  if (length(ei) == 0){assign("ei", "f", envir = .GlobalEnv)} # Def: do not calculate erosion indices
  if (length(ee) == 0){assign("ee", "BF", envir = .GlobalEnv)} # Def: use the Brown Foster (BF) energy equation
  if (length(im) == 0){assign("im", "DEFAULT", envir = .GlobalEnv)} # Def: use the default WEPPCLIFF imputation design
  if (length(io) == 0){assign("io", 100, envir = .GlobalEnv)} # Def: use up to 100 iterations
  if (length(qi) == 0){assign("qi", "f", envir = .GlobalEnv)} # Def: do not cut corners on imputation
  if (length(iv) == 0){assign("iv", "f", envir = .GlobalEnv)} # Def: do not print imputation progress
  if (length(alt) == 0){assign("alt", "f", envir = .GlobalEnv)} # Def: alternative data provided
  if (length(sid) == 0){assign("sid", 1, envir = .GlobalEnv)} # Def: use first storm in list
  if (length(sdt) == 0){assign("sdt", "start", envir = .GlobalEnv)} # Def: use earliest acceptable datetime
  if (length(edt) == 0){assign("edt", "end", envir = .GlobalEnv)} # Def: use latest acceptable datetime
  if (length(rtb) == 0){assign("rtb", "t", envir = .GlobalEnv)} # Def: round time bounds
  if (length(tth) == 0){assign("tth", 6, envir = .GlobalEnv)} # Def: 6-hour time (break b/w storms)
  if (length(dth) == 0){assign("dth", 1.27, envir = .GlobalEnv)} # Def: 1.27 mm depth (break b/w storms)
  if (length(qcop) == 0){assign("qcop", "b", envir = .GlobalEnv)} # Def: uses physical and stochastic methods for outlier detection
  if (length(qcth) == 0){assign("qcth", 0.95, envir = .GlobalEnv)} # Def: checks only the highest 5% rates of change (stochastic only)
  if (length(qcdf) == 0){assign("qcdf", 0.2, envir = .GlobalEnv)} # Def: 80% value recovery is an outlier (stochastic only)
  if (length(dtf1) == 0){assign("dtf1", "%Y-%m-%d %H:%M:%S", envir = .GlobalEnv)} # Def: a standard datetime format
  if (length(dtf2) == 0){assign("dtf2", dtf1, envir = .GlobalEnv)} # Def: same as dtf1 (input or default)
  if (length(dtf3) == 0){assign("dtf3", dtf1, envir = .GlobalEnv)} # Def: same as dtf1 (input or default)
  if (length(prof) == 0){assign("prof", "f", envir = .GlobalEnv)} # Def: production mode (as opposed to profiling mode)
  if (length(pint) == 0){assign("pint", 0.02, envir = .GlobalEnv)} # Def: time in seconds between profile sampling
  if (length(mepr) == 0){assign("mepr", "f", envir = .GlobalEnv)} # Def: exclude memory profiling
  if (length(gcpr) == 0){assign("gcpr", "f", envir = .GlobalEnv)} # Def: exclude garbage collect profiling
  if (length(lnpr) == 0){assign("lnpr", "f", envir = .GlobalEnv)} # Def: exclude line profiling
  if (length(warn) == 0){assign("warn", "f", envir = .GlobalEnv)} # Def: turn off warnings
  if (length(verb) == 0){assign("verb", "f", envir = .GlobalEnv)}} # Def: verbosity off


# A function to halt execution for invalid arguments.
check_args = function() {
  tf.patterns = paste("t", "f", collapse = "|")
  mp.patterns = paste("t", "f", 1:10000, collapse = "|")
  pi.patterns = paste("f", 1:1440, collapse = "|")
  u.patterns = paste("m", "e", collapse = "|")
  if (grepl(fr, tf.patterns, ignore.case = T) != T){stop("\033[1;31mInvalid Argument: [-fr] must be specified as 't' (true) or 'f' (false).\033[0m")}
  if (grepl(mp, mp.patterns, ignore.case = T) != T){stop("\033[1;31mInvalid Argument: [-mp] must be specified as 't' (true), 'f' (false), or an integer number of cores.\033[0m")}
  if (grepl(qc, tf.patterns, ignore.case = T) != T){stop("\033[1;31mInvalid Argument: [-qc] must be specified as 't' (true) or 'f' (false).\033[0m")}
  if (grepl(id, tf.patterns, ignore.case = T) != T){stop("\033[1;31mInvalid Argument: [-id] must be specified as 't' (true) or 'f' (false).\033[0m")}
  if (grepl(pd, tf.patterns, ignore.case = T) != T){stop("\033[1;31mInvalid Argument: [-pd] must be specified as 't' (true) or 'f' (false).\033[0m")}
  if (grepl(cp, tf.patterns, ignore.case = T) != T){stop("\033[1;31mInvalid Argument: [-cp] must be specified as 't' (true) or 'f' (false).\033[0m")}
  if (grepl(pi, pi.patterns, ignore.case = T) != T){stop("\033[1;31mInvalid Argument: [-pi] must be specified as 'f' (false) or an integer (in minutes).\033[0m")}
  if (grepl(ei, tf.patterns, ignore.case = T) != T){stop("\033[1;31mInvalid Argument: [-ei] must be specified as 't' (true) or 'f' (false).\033[0m")}
  if (grepl(rtb, tf.patterns, ignore.case = T) != T){stop("\033[1;31mInvalid Argument: [-rtb] must be specified as 't' (true) or 'f' (false).\033[0m")}
  if (grepl(alt, tf.patterns, ignore.case = T) != T){stop("\033[1;31mInvalid Argument: [-alt] must be specified as 't' (true) or 'f' (false).\033[0m")}
  if (length(grepl(u, u.patterns, ignore.case = T)) == 0){stop("\033[1;31mInvalid Argument: [-u] must be specified as 'm' (metric) or 'e' (english) followed by any exceptions.\033[0m")}
  if ((tz %in% OlsonNames()) == F){stop("\033[1;31mInvalid Argument: Time zone option [-tz] not supported. Check 'OlsonNames()' in R documentation for supported time zones.\033[0m")}
  if (bf == 0){stop("\033[1;31mUnsupported Argument: Non-breakpoint format output [-bf 0] not yet supported.\033[0m")}}


# A function to load all R package dependencies.
load_packages = function() {
  t.time = system.time({
    cat("\033[0;37mLoading R package dependencies... \033[0m")
    lapply(package.list, library, lib.loc = lib.dir, character.only = T, quietly = T, verbose = F, attach.required = T)})
  cat("\033[0;37mCompleted in", t.time[3],"seconds.\033[0m", lr, lr)}


# A function to load the input file used in calculations.
load_input_file = function() {
  setwd(d)
  t.time = system.time({
    
    # Search for file type.
    txt = grep(".txt", f, ignore.case = T)
    tsv = grep(".tsv", f, ignore.case = T)
    csv = grep(".csv", f, ignore.case = T)
    
    # Handle common errors.
    if (sum(txt, tsv, csv) == 0){stop("\033[0;37mThe input file does not contain an acceptable extension (.txt or .csv).\033[0m")}
    if (sum(txt, tsv, csv) > 1){stop("\033[0;37mThe input file contains more than one acceptable extension.\033[0m")}
    
    # Load file otherwise.
    cat("\033[0;37mLoading input file... \033[0m")
    if (length(txt) == 1){file = suppressMessages(read_table(f, delim))}
    if (length(tsv) == 1){file = suppressMessages(read_tsv(f))}
    if (length(csv) == 1){file = suppressMessages(read_csv(f))}})
  
  cat("\033[0;37mCompleted in", t.time[3],"seconds.\033[0m", lr, lr)
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
  if(toupper(alt) == "T"){vars = c("DT_1", "PRECIP", "DT_2", "AIR_TEMP", "REL_HUM", "DT_3", "SO_RAD", "W_VEL", "W_DIR")}
  present = which(vars %in% oldNames)
  missing = vars[-present]
  if(length(missing) > 0){cat("\033[0;37mSome expected variables are missing:", missing, "\033[0m", lr, lr); stop()}
  return(file)}


# A function to load input files in a directory.
load_input_directory = function() {
  setwd(d)
  
  # Get list of files.
  files = dir(d)
  
  # Create multiprocessing cluster.
  create_cluster(length(files), mp)
  
  t.time = system.time({
    cat("\033[0;37mLoading input files... \033[0m")
    
    # Loop over each file.
    file = foreach(i = 1:length(files), .packages = "readr") %dopar% {
      
      # Search for file type.
      txt = grep(".txt", files[i], ignore.case = T)
      tsv = grep(".tsv", files[i], ignore.case = T)
      csv = grep(".csv", files[i], ignore.case = T)
      
      # Handle common errors.
      if (sum(txt, tsv, csv) == 0){stop("\033[0;37mThe input file does not contain an acceptable extension (.txt or .csv).\033[0m")}
      if (sum(txt, tsv, csv) > 1){stop("\033[0;37mThe input file contains more than one acceptable extension.\033[0m")}
      
      # Load files otherwise.
      if (length(txt) == 1){return(suppressMessages(read_table(files[i], delim)))}
      if (length(tsv) == 1){return(suppressMessages(read_tsv(files[i])))}
      if (length(csv) == 1){return(suppressMessages(read_csv(files[i])))}}})
  
  cat("\033[0;37mCompleted in", t.time[3],"seconds.\033[0m", lr, lr)
  kill_cluster()
  setwd(home.dir)
  return(file)}


# A function to check for missing columns and pad them with NA.
preprocess_file = function(file) {
  t.time = system.time({
    cat("\033[0;37mPreprocessing data... \033[0m")
    vars = c("STATION", "TZ", "LAT", "LON", "ELEV", "DT_1", "PRECIP", "DT_2", "AIR_TEMP", "REL_HUM",
             "DT_3", "MAX_TEMP", "MIN_TEMP", "SO_RAD","W_VEL", "W_DIR", "DP_TEMP")
    for (i in vars){
      logic = i %in% colnames(file)
      if (logic == F){
        old_names = colnames(file)
        file = cbind(file, NA)
        colnames(file) = c(old_names, i)}}})
  cat("\033[0;37mCompleted in", t.time[3],"seconds.\033[0m", lr, lr)
  return(file)}


# A function to split data for parallel or standard processing.
split_data = function(file) {
  t.time = system.time({
    cat("\033[0;37mSplitting data by station... \033[0m")
    stats = na.omit(unique(file$STATION))
    if(length(stats) > 1){file = split(file, file$STATION)}
    if(length(stats) <= 1){file = list(file)}})
  cat("\033[0;37mCompleted in", t.time[3],"seconds.\033[0m", lr, lr)
  return(file)}


# A function to create the multiprocessing virtual cluster environment.
create_cluster = function(s, mp) {
  cat("\033[0;37mCreating multiprocessing virtual cluster... \033[0m")
  cores = detectCores()
  status = F
  if (length(na.omit(as.numeric(mp))) == 0){tmp = mp; mp = s; status = T}
  mp = as.numeric(mp)
  cluster = makeCluster(min(s, mp, cores))
  registerDoParallel(cluster)
  cat("\033[0;37mDone. Cores deployed:", min(s, mp, cores), "\033[0m", lr, lr)
  if (status == T){mp = tmp}}


# A function to build a hashed R environment (slow construction, fastest lookup, flexible values, named keys only).
hash_env = function(k, v) {
  if (length(k) == length(v)){
    my_env = new.env(hash = T)
    for (i in paste(k)){my_env[[i]] = v}}
  return(myenv)}


# A function to build an Rcpp hash map (fast construction, fast lookup, atomic values, atomic keys).
hash_rcpp = function(k, v) {
  if (length(k) == length(v)){my_hm = hashmap(k, v)}
  return(my_hm)}


# A function to store data for processing.
store_data = function(file) {
  if (toupper(verb) == "T") {cat(lr,"Storing in memory...")}
  file = as.data.frame(file[[1]], stringsAsFactors = F)
  long.vars = c("DT_1", "PRECIP", "DT_2", "AIR_TEMP", "REL_HUM", "DT_3",
                "MAX_TEMP", "MIN_TEMP", "SO_RAD","W_VEL", "W_DIR", "DP_TEMP")
  short.vars = c("STATION", "TZ", "LAT", "LON", "ELEV", "OBS_YRS", "B_YR", "YRS_SIM")
  for (i in long.vars){
    if (is.null(file[[i]]) == T){assign(i, NA)}
    if (is.null(file[[i]]) == F){assign(i, file[[i]])}}
  for (i in short.vars){
    if (is.null(file[[i]]) == T){assign(i, NA)}
    if (is.null(file[[i]]) == F){assign(i, file[[i]][1])}}
  data = list()
  data[[1]] = data.frame(DT_1, PRECIP)
  data[[2]] = data.frame(DT_2, AIR_TEMP, REL_HUM)
  data[[3]] = data.frame(DT_3, MIN_TEMP, MAX_TEMP, SO_RAD, W_VEL, W_DIR, DP_TEMP)
  data[[4]] = c(STATION, TZ, LAT, LON, ELEV, OBS_YRS, B_YR, YRS_SIM)
  names(data[[4]]) = short.vars
  return(data)}


# A function to change type to dataframe and class to numeric.
convert_data = function(data) {
  if (toupper(verb) == "T") {cat(lr,"Converting data format...")}
  for (i in 1:3){
    data[[i]] = as.data.frame(data[[i]], stringsAsFactors = F)
    for (j in 2:ncol(data[[i]])) {data[[i]][[j]] = as.numeric(data[[i]][[j]])}}
  return(data)}


# A function to calculate duration data.
create_duration_data = function(data) {
  if (toupper(verb) == "T") {cat(lr,"Analyzing data intervals...")}
  
  # Loop over each of the variable groups.
  checked_tz <<- check_tz(data)
  dt_list = c("DT_1", "DT_2", "DT_3")
  dtf_list = c(dtf1, dtf2, dtf3)
  
  # Loop over each variable grouping.
  if (toupper(alt) == "T") {groups = 1:3}
  if (toupper(alt) == "F") {groups = c(1, 3)}
  for (i in groups){
    
    # Convert to datetime (POSIX Count).
    if (length(na.omit(data[[i]][[dt_list[i]]])) == 0) {stop("Datetime data is not being handled correctly. Please check the input file(s) and arguments.")}
    if (length(na.omit(data[[i]][[dt_list[i]]])) > 0) {
      data[[i]][[dt_list[i]]] = as.POSIXct(as.character(data[[i]][[dt_list[i]]]), format = dtf_list[i])}
    
    # Handle precipitation and non-precipitation breaks.
    if (i == 1) {
      
      # Convert fixed format to breakpoint format if appropriate.
      if (toupper(pi) != "F") {
        precip.interval = as.numeric(pi)
        new.dates = data[[i]][[dt_list[i]]] - (60 * precip.interval)
        rmv.dates = which(new.dates %in% data[[i]][[dt_list[i]]])
        if (length(rmv.dates) > 0) {add.dates = new.dates[-rmv.dates]}
        zeroes = c(rep(0, length(add.dates)))
        new.rows = data.frame(add.dates, zeroes)
        names(new.rows) = c("DT_1", "PRECIP")
        data[[i]] = rbind(data[[i]], new.rows)}}
    
    # Sort data.
    data[[i]] = data[[i]][order(data[[i]][[dt_list[i]]]),]
    
    # Calculate time differences in minutes.
    dif = difftime(tail(data[[i]][[dt_list[i]]], -1), head(data[[i]][[dt_list[i]]], -1), units = "mins")
    dif = as.numeric(dif)
    dif = c(dif[1], dif)
    data[[i]][["DUR"]] = dif}
  
  # Keep only positive precipitation values and potential storm starts.
  p_rows = which(data[[1]][["PRECIP"]] != 0)
  z_rows = which(data[[1]][["PRECIP"]] == 0)
  s_rows = p_rows-1
  b_rows = intersect(z_rows, s_rows)
  data[[1]] = data[[1]][union(p_rows, b_rows),]
  data[[1]] = data[[1]][order(data[[1]][["DT_1"]]),]
  
  return(data)}


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
  
  # Most or all units are metric (convert exceptions).
  if (toupper(u) == "M"){}
  
  # Most or all units are english (do not convert exceptions).
  if (length(vars) == 0){vars = NA}
  if (toupper(u) == "E"){vars = var.list[!grepl(paste(vars, collapse = "|"), var.list, ignore.case = T)]}
  
  # Perform simple conversions.
  if ("PRECIP" %in% vars){data[[1]][["PRECIP"]] = data[[1]][["PRECIP"]]*25.4} # Conversion from in to mm
  if ("MAX_TEMP" %in% vars){data[[3]][["MAX_TEMP"]] = (data[[3]][["MAX_TEMP"]] - 32) * 5/9} # Conversion from F to C
  if ("MIN_TEMP" %in% vars){data[[3]][["MIN_TEMP"]] = (data[[3]][["MIN_TEMP"]] - 32) * 5/9} # Conversion from F to C
  if ("AIR_TEMP" %in% vars){data[[2]][["AIR_TEMP"]] = (data[[2]][["AIR_TEMP"]] - 32) * 5/9} # Conversion from F to C
  if ("DP_TEMP" %in% vars){data[[3]][["DP_TEMP"]] = (data[[3]][["DP_TEMP"]] - 32) * 5/9} # Conversion from F to C
  if ("SO_RAD" %in% vars){data[[3]][["SO_RAD"]] = data[[3]][["SO_RAD"]] * data[[3]][["DUR"]] * 60 / 41840} # Conversion from W/m^2 to Langleys
  if ("W_VEL" %in% vars){data[[3]][["W_VEL"]] = data[[3]][["W_VEL"]] * 0.44704} # Conversion from mph to m/s
  if ("ELEV" %in% vars && length(na.omit(data[[4]][["ELEV"]])) > 0){ # Make sure elevation was provided
    data[[4]][["ELEV"]] = as.numeric(data[[4]][["ELEV"]]) * 0.3048} # Conversion from ft to m
  return(data)}


# A function to check input timezone and set to default if not supported.
check_tz = function(data) {
  stat_data = as.data.frame(unname(data[[4]]), stringsAsFactors = F)
  if (length(na.omit(data[[4]][["TZ"]])) > 0){tz_input = data[[4]][["TZ"]]}
  else {tz_input = NA}
  if (length(na.omit(tz_input)) == 0){tz_input = tz}
  tz_check = which(OlsonNames() == tz_input)
  tz_input = OlsonNames()[tz_check]
  if (length(tz_check) != 1){tz_input = "GMT"}
  Sys.setenv(TZ = tz_input)
  return(tz_input)}


# A function to check data quality.
check_quality = function(data, x) {
  if (toupper(verb) == "T") {cat(lr,"Checking data quality...")}
  data = impose_physical_limits(data, x)
  data = build_rate_data(data, x)
  return(data)}


# A function to impose physical limitations on data.
impose_physical_limits = function(data, x) {
  
  # Define global physical limits in the format: c(max, min).
  precip = c(2500, 0)  # in mm (a sum of depth)
  ar.tmp = c(60, -90)  # in C (an average temperature)
  rel.hm = c(1000, 0)  # in % (an average percentage)
  mn.tmp = c(60, -90)  # in C (an average temperature)
  mx.tmp = c(60, -90)  # in C (an average temperature)
  so.rad = c(2500, 0)  # in langleys (a sum of energy)
  wd.vel = c(120, 0)   # in m/s (an average velocity)
  wd.dir = c(360, 0)   # in degrees (an average angle)
  dp.tmp = c(40, -25)  # in C (an average temperature)
  
  # Build lists.
  var.list = list(c("PRECIP"), c("AIR_TEMP", "REL_HUM"), c("MIN_TEMP", "MAX_TEMP", "SO_RAD", "W_VEL", "W_DIR", "DP_TEMP"))
  physical.limits = list(list(precip), list(ar.tmp, rel.hm), list(mn.tmp, mx.tmp, so.rad, wd.vel, wd.dir, dp.tmp))
  
  # Loop over datetime groups.
  for (i in x){
    names(physical.limits[[i]]) = var.list[[i]]
    
    # Loop over variable groups.
    for (j in var.list[[i]]){
      data[[i]][[j]][data[[i]][[j]] > physical.limits[[i]][[j]][[1]]] = physical.limits[[i]][[j]][[1]]
      data[[i]][[j]][data[[i]][[j]] < physical.limits[[i]][[j]][[2]]] = physical.limits[[i]][[j]][[2]]}}
  
  return(data)}


# A function to extract rates from breakpoint format data.
build_rate_data = function(data, x) {
  
  # Build lists.
  data[[5]] = list()
  var.list = list(c("PRECIP"), c("AIR_TEMP", "REL_HUM"), c("MIN_TEMP", "MAX_TEMP", "SO_RAD", "W_VEL", "W_DIR", "DP_TEMP"))
  lim.list = c(5, 1, 1, 1, 1, 5, 1, 180, 1)
  counter = 0
  
  # Loop over datetime groups.
  for (i in x){
    DT = data[[i]][[paste("DT_", i, sep = "")]]
    DUR = data[[i]][["DUR"]]
    MN = as.numeric(format(as.Date(as.POSIXlt(DT, origin = "1970-01-01 00:00.00 UTC"), tz = checked_tz, format = "%Y%m%d"), format = "%m"))
    tmp = as.data.frame(cbind(DT, MN))
    
    # Loop over variable groups and build tables.
    for (j in var.list[[i]]){
      counter = counter + 1
      limit = lim.list[counter]
      tmp[[paste(j, "_VAR", sep = "")]] = data[[i]][[j]]
      tmp[[paste(j, "_RATE", sep = "")]] = c(NA, diff(tmp[[paste(j, "_VAR", sep = "")]]))/DUR
      
      # Handle wind direction differently.
      if (j == "W_DIR"){
        vec = tmp[[paste(j, "_RATE", sep = "")]]
        real = which(is.na(vec) == F)
        new = vec[real]
        new = new * DUR[real]
        new[new > 180] = new[new > 180] - 360
        new[new < -180] = new[new < -180] + 360
        new = new / DUR[real]
        vec[real] = new
        tmp[[paste(j, "_RATE", sep = "")]] = vec}
      
      # Handle quality control methods.
      if (mean(DUR, na.rm = T) >= 180) {next}
      if (toupper(qc) == "T"){
        
        # Determine outliers (physically, stochastically, or both).
        if (toupper(qcop) == "P"){outliers = physical_qc(tmp, limit, j)}
        if (toupper(qcop) == "S"){outliers = stochastic_qc(tmp, j)}
        if (toupper(qcop) == "B"){
          P.outliers = physical_qc(tmp, limit, j)
          S.outliers = stochastic_qc(tmp, j)
          outliers = unique(c(P.outliers, S.outliers))}
        
        # Replace data.
        tmp[[paste(j, "_VAR", sep = "")]][outliers] = NA
        data[[i]][[j]] = tmp[[paste(j, "_VAR", sep = "")]]}}
    
    data[[5]][[i]] = tmp}
  
  return(data)}


# A function to detect physically defined outliers.
physical_qc = function(tmp, limit, j) {
  vec = tmp[[paste(j, "_RATE", sep = "")]]
  vec[is.na(vec) == T] = 0
  outliers = which(abs(vec) > limit)
  return(outliers)}


# A function to detect stochastically defined outliers.
stochastic_qc = function(tmp, j) {
  
  # IF RATE OF CHANGE VARIABILITY CHANGES SIGNIFICANTLY THROUGHOUT THE YEAR, THEN ALTER CODE TO PERFORM THIS FOR EACH MONTH.
  # Determine signal and noise component.
  vec = tmp[[paste(j, "_RATE", sep = "")]]
  noise = var(na_parse(vec), na.rm = T)
  tmp[[paste(j, "_SNR", sep = "")]] = abs(vec)/noise
  
  # Determine critical signal to noise ratio and critical normalized difference (Stochastic).
  # If the signal surpasses the absolute snr it is checked. If it then recovers (1 - qcdf) * 100 % of its value, it is an outlier.
  snr = quantile(tmp[[paste(j, "_SNR", sep = "")]], as.numeric(qcth), na.rm = T)
  
  # Handle last row.
  lcrit = length(tmp[[paste(j, "_SNR", sep = "")]])
  
  # Find extreme signal to noise values.
  highs = which(tmp[[paste(j, "_SNR", sep = "")]] > snr)
  if (lcrit %in% highs){highs = highs[-which(highs == lcrit)]}
  heads = vec[highs]
  tails = vec[highs + 1]
  ndiff = abs(heads + tails) / (abs(heads) + abs(tails))
  results = ndiff < qcdf
  return(highs[results])}


# A function to replace zeroes, infinites, and nulls with NA.
na_parse = function(vec) {
  vec[vec == 0 | is.infinite(vec) == T | is.null(vec) == T] = NA
  return(vec)}


# A function to remove NA rows within the main data structure (first two dataframes).
remove_na_rows = function(data) {
  if (toupper(verb) == "T") {cat(lr,"Removing empty rows...")}
  for (j in 1:2) {data[[j]] = as.data.frame(na.omit(data[[j]]))}
  return(data)}


# A function to obtain an acceptable period of data (sm = 1) or storm event (sm = 2).
trim_data = function(data) {
  if (toupper(verb) == "T") {cat(lr,"Trimming to specified time period...")}
  
  # General Setup
  data = break_storms(data, 1, 7)
  
  # Handle Alternative Data Present
  if (toupper(alt) == "T"){
    maxs = c(max(data[[1]][["DT_1"]], na.rm = T), max(data[[2]][["DT_2"]], na.rm = T), max(data[[3]][["DT_3"]], na.rm = T))
    mins = c(min(data[[1]][["DT_1"]], na.rm = T), min(data[[2]][["DT_2"]], na.rm = T), min(data[[3]][["DT_3"]], na.rm = T))}
  
  # Handle Alternative Data Absent
  if (toupper(alt) == "F"){
    maxs = c(max(data[[1]][["DT_1"]], na.rm = T), max(data[[3]][["DT_3"]], na.rm = T))
    mins = c(min(data[[1]][["DT_1"]], na.rm = T), min(data[[3]][["DT_3"]], na.rm = T))}
  
  # Record Bounds
  start = max(mins, na.rm = T)
  end = min(maxs, na.rm = T)
  
  # Trim data to exact bounds based on user inputs.
  if (toupper(alt) == "T") {groups = 1:3}
  if (toupper(alt) == "F") {groups = c(1, 3)}
  bounds = time_bounds(start, end, checked_tz)
  dt_list = c("DT_1", "DT_2", "DT_3")
  for (i in groups){
    data[[i]] = data[[i]][data[[i]][[dt_list[i]]] >= bounds[1],]
    data[[i]] = data[[i]][data[[i]][[dt_list[i]]] <= bounds[2],]}
  
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
  data[[in.index]] = cum_to_inc(data[[in.index]])
  data[[in.index]] = identify_storms(data[[in.index]])
  if (toupper(ei) == "T"){data[[in.index]] = int_30m(data[[in.index]])}
  data[[out.index]] = split(data[[in.index]], data[[in.index]][["EVENT_ID"]])
  return(data)}


# A function to convert cumulative precipitation data to incremental data.
cum_to_inc = function(precip_data) {
  if (toupper(cp) == "T"){
    if (toupper(verb) == "T") {cat(lr,"Converting to incremental precipitation...")}
    difs = c(0, diff(as.numeric(precip_data[["PRECIP"]])))
    difs[which(difs < 0)] = precip_data[["PRECIP"]][which(difs < 0)]
    precip_data[["PRECIP"]] = as.numeric(difs)}
  zeros = which(precip_data[["PRECIP"]] == 0)
  if (length(zeros) > 0){precip_data = precip_data[-zeros,]}
  precip_data[["INTENSITY"]] = precip_data[["PRECIP"]]/(precip_data[["DUR"]]/60)
  return(precip_data)}


# A function to identify storm events.
identify_storms = function(precip_data) {
  dates = as.POSIXlt(precip_data[["DT_1"]])
  dif = c(0, difftime(tail(precip_data[["DT_1"]], -1), head(precip_data[["DT_1"]], -1), units = "mins"))
  precip_data[["ANT_TIME"]] = dif
  precip_data[["CUM_TIME"]] = cumsum(precip_data[["ANT_TIME"]])
  precip_data = evaluate_connectivity(precip_data)
  event_id = c()
  counter = 1
  for (i in 2:nrow(precip_data)){
    e_con_bef = precip_data[["E_CON_BEF"]][i]
    e_con_aft = precip_data[["E_CON_AFT"]][i]
    p_con_bef = precip_data[["E_CON_BEF"]][i-1]
    p_con_aft = precip_data[["E_CON_AFT"]][i-1]
    if (((e_con_bef == F && e_con_aft == F) || (e_con_aft == T && p_con_aft == F) || (p_con_bef == T && e_con_bef == F)) && p_con_aft == F){counter = counter + 1}
    event_id = append(event_id, counter)}
  precip_data[["EVENT_ID"]] = c(1, event_id)
  return(precip_data)}


# A function to evaluate storm event connectivity.
evaluate_connectivity = function(precip_data) {
  cum_depth.before = c()
  cum_depth.after = c()
  rows = ceiling(as.numeric(tth)*60/min(precip_data[["DUR"]][precip_data[["DUR"]] > 0]))
  for (i in 1:nrow(precip_data)){
    now = precip_data[["CUM_TIME"]][i]
    indexWindow = c(max(i-rows, 1):min(i+rows, nrow(precip_data)))
    cumtimeWindow = precip_data[["CUM_TIME"]][indexWindow]
    depthWindow = precip_data[["PRECIP"]][indexWindow]
    start = max(0, now - as.numeric(tth)*60)
    end = now + as.numeric(tth)*60
    after.start = cumtimeWindow >= start
    before.now = cumtimeWindow < now
    after.now = cumtimeWindow > now
    before.end = cumtimeWindow <= end
    tmp.before = sum(depthWindow[as.logical(before.now * after.start)], na.rm = T)
    tmp.after = sum(depthWindow[as.logical(before.end * after.now)], na.rm = T)
    cum_depth.before = append(cum_depth.before, tmp.before)
    cum_depth.after = append(cum_depth.after, tmp.after)}
  precip_data[["P_SUM_BEF"]] = cum_depth.before
  precip_data[["P_SUM_AFT"]] = cum_depth.after
  precip_data[["E_CON_BEF"]] = F
  precip_data[["E_CON_AFT"]] = F
  precip_data[["E_CON_BEF"]][which(precip_data[["P_SUM_BEF"]] > as.numeric(dth))] = T
  precip_data[["E_CON_AFT"]][which(precip_data[["P_SUM_AFT"]] > as.numeric(dth))] = T
  return(precip_data)}


# A function to calculate 30-minute intensities.
int_30m = function(precip_data) {
  if (toupper(verb) == "T") {cat(lr,"Calculating 30-minute intensities...")}
  int30 = c()
  for (i in 1:nrow(precip_data)){ #### EXECUTION TIME KILLER ####
    now = precip_data[["DT_1"]][i]
    start = now - 1800 # 30 Minutes in Seconds
    end = now
    after.start = precip_data[["DT_1"]] > start
    before.now = precip_data[["DT_1"]] <= now
    rows = as.logical(before.now * after.start)
    x = precip_data[["INTENSITY"]][rows]
    w = precip_data[["DUR"]][rows]
    if (sum(w) > 30){
      w[1] = 30 - sum(w[-1])}
    if (sum(w) < 30){
      x = append(x, 0)
      w = append(w, 30-sum(w))}
    last30 = weighted.mean(x, w, na.rm = T)
    int30 = append(int30, last30)}
  precip_data[["30_MIN_INT"]] = int30
  return(precip_data)}


# A function to find an acceptable calendar year start and end datetime.
time_bounds = function(start, end, checked_tz) {
  if (toupper(sdt) == "START"){first.dt = start}
  if (toupper(sdt) != "START"){first.dt = max(c(strptime(sdt, format = dtf1, tz = checked_tz), start), na.rm = T)}
  if (toupper(edt) == "END"){last.dt = end}
  if (toupper(edt) != "END"){last.dt = min(strptime(edt, format = dtf1, tz = checked_tz), end, na.rm = T)}
  if (as.numeric(sid) > 1 | sm == 2) {bounds = c(first.dt, last.dt)}
  if (sm == 1) {
    good.start = start_of_year(first.dt, checked_tz)
    good.end = end_of_year(last.dt, checked_tz)
    bounds = c(good.start, good.end, first.dt, last.dt)
    if (good.start > good.end){stop(lr, lr, "\033[0;37mInvalid Date Range: At least one full calendar year must be specified with [-sdt] and [-edt].\033[0m", lr, lr, collapse = "")}}
  return(bounds)}


# A function to find the exact beginning of the next full calendar year.
start_of_year = function(date, tz_input) {
  real.start = as.POSIXlt(date, format = dtf1, tz = tz_input)
  good.start = real.start
  rounded.start = real.start
  
  # Determine a good start for the complete data.
  good.start$mon = 0
  good.start$mday = 1
  good.start$hour = 0
  good.start$min = 0
  good.start$sec = 0
  
  # Round to the start of the first day of complete data.
  rounded.start$hour = 0
  rounded.start$min = 0
  rounded.start$sec = 0
  
  # Use the rounded start of complete data.
  if (toupper(rtb) == "T"){if (rounded.start > good.start){good.start$year = good.start$year + 1}}
  
  # Use the exact start of complete data.
  if (toupper(rtb) == "F"){if (real.start > good.start){good.start$year = good.start$year + 1}}
  
  return(good.start)}


# A function to find the exact end of the last full calendar year.
end_of_year = function(date, tz_input) {
  real.end = as.POSIXlt(date, format = dtf1, tz = tz_input)
  good.end = real.end
  rounded.end = real.end
  
  # Determine a good end for the complete data.
  good.end$mon = 11
  good.end$mday = 31
  good.end$hour = 23
  good.end$min = 59
  good.end$sec = 59
  
  # Round to the end of the last day of complete data.
  rounded.end$hour = 23
  rounded.end$min = 59
  rounded.end$sec = 59
  
  # Use the rounded end of complete data.
  if (toupper(rtb) == "T"){if (rounded.end < good.end){good.end$year = good.end$year - 1}}
  
  # Use the exact end of complete data.
  if (toupper(rtb) == "F"){if (real.end < good.end){good.end$year = good.end$year - 1}}
  
  return(good.end)}


# A function to normalize a vector (using maximum-minimum values).
normalize = function(vec) {
  min.vec = min(vec, na.rm = T)
  cnt.vec = vec - min.vec
  max.vec = max(vec, na.rm = T)
  rng.vec = max.vec - min.vec
  nml.vec = cnt.vec/rng.vec
  return(nml.vec)}


# A function to process precipitation data.
process_precip_data = function(data, pcp.index, dly.pcp.index, mn.ts.index, mn.index) {
  if (toupper(verb) == "T") {cat(lr,"Processing precipitation data...")}
  
  # Generate daily event metadata and find daily precipitation data.
  dates = format(data[[pcp.index]][["DT_1"]], tz = checked_tz, format = "%Y%m%d")
  d.bps = aggregate(data[[pcp.index]][["PRECIP"]], by = list(dates), FUN = length, simplify = T)
  d.events = aggregate(data[[pcp.index]][["EVENT_ID"]], by = list(dates), FUN = unique, simplify = T, na.rm = T)
  e.len = as.numeric(unlist(lapply(d.events[,2], function(x) length(x))))
  e.max = as.numeric(unlist(lapply(d.events[,2], function(x) max(x))))
  e.min = as.numeric(unlist(lapply(d.events[,2], function(x) min(x))))
  d.p.sum = aggregate(data[[pcp.index]][["PRECIP"]], by = list(dates), FUN = sum, simplify = T, na.rm = T)
  d.precip = cbind(d.bps, e.len, e.max, e.min, d.p.sum[,2])
  names(d.precip) = c("YYYYMMDD", "D_BPS", "E_LEN", "E_MAX", "E_MIN", "PRECIP")
  data[[dly.pcp.index]] = d.precip
  
  # Find monthly precipitation.
  m.p.sum = aggregate(d.p.sum[,2], by = list(format(as.Date(d.p.sum[,1], tz = checked_tz, format = "%Y%m%d"), format = "%Y%m")), FUN = sum, simplify = T, na.rm = T)
  names(m.p.sum) = c("YYYYMM", "PRECIP")
  data[[mn.ts.index]] = m.p.sum
  
  # Find monthly average precipitation.
  m.p.mean = aggregate(m.p.sum[,2], by = list(format(as.Date(paste(m.p.sum[,1], "01", sep = ""), tz = checked_tz, format = "%Y%m%d"), format = "%m")), FUN = mean, simplify = T, na.rm = T)
  names(m.p.mean) = c("MM", "PRECIP")
  data[[mn.index]] = m.p.mean
  
  return(data)}


# A function to process optional sub-daily air temperature and relative humidity data.
process_alt_data = function(data, alt.index, dly.alt.index) {
  if (toupper(verb) == "T") {cat(lr,"Processing alternative data...")}
  
  # Find dew point temperature.
  dates = format(data[[alt.index]][["DT_2"]], tz = checked_tz, format = "%Y%m%d")
  dp.temp = cbind(dates, dew_point_temperature(data[[alt.index]][["AIR_TEMP"]], data[[alt.index]][["REL_HUM"]]))
  names(dp.temp) = c("YYYYMMDD", "DP_TEMP")
  data[[alt.index]][["DP_TEMP"]] = as.numeric(dp.temp[,2])
  
  # Find daily alternative temperature data.
  d.t.min = aggregate(data[[alt.index]][["AIR_TEMP"]], by = list(dates), FUN = min, simplify = T, na.rm = T)
  d.t.max = aggregate(data[[alt.index]][["AIR_TEMP"]], by = list(dates), FUN = max, simplify = T, na.rm = T)
  d.dp.temp = aggregate(as.numeric(dp.temp[,2]), by = list(dates), FUN = mean, simplify = T, na.rm = T)
  d.alt = cbind(d.t.min, d.t.max[,2], d.dp.temp[,2])
  names(d.alt) = c("YYYYMMDD", "D_MIN_T", "D_MAX_T", "D_DP_T")
  data[[dly.alt.index]] = d.alt
  
  return(data)}


# A function to calculate dew point temperature from relative humidity and air temperature data.
dew_point_temperature = function(air_temp, rel_hum) {
  rel_hum[rel_hum == 0] = 1
  A1 = 7.625
  B1 = 243.04
  top = B1 * (log(rel_hum/100) + (A1 * air_temp)/(B1 + air_temp))
  bottom = A1 - log(rel_hum/100) - (A1 * air_temp)/(B1 + air_temp)
  dp_temp = top / bottom
  return(dp_temp)}


# A function to process daily max/min temperature, solar radiation, wind speed and direction, and dew point temperature data.
process_daily_data = function(data, dly.in.index, dly.alt.index, dly.out.index, mly.out.index) {
  if (toupper(verb) == "T") {cat(lr,"Processing daily data...")}
  
  # Find daily average data.
  dates = format(data[[dly.in.index]][["DT_3"]], tz = checked_tz, format = "%Y%m%d")
  tmin = aggregate(data[[dly.in.index]][["MIN_TEMP"]], by = list(dates), FUN = min, simplify = T, na.rm = T)
  tmax = aggregate(data[[dly.in.index]][["MAX_TEMP"]], by = list(dates), FUN = max, simplify = T, na.rm = T)
  dew = aggregate(data[[dly.in.index]][["DP_TEMP"]], by = list(dates), FUN = mean, simplify = T, na.rm = T)
  wvel = aggregate(data[[dly.in.index]][["W_VEL"]], by = list(dates), FUN = mean, simplify = T, na.rm = T)
  wdir = aggregate(data[[dly.in.index]][["W_DIR"]], by = list(dates), FUN = mean, simplify = T, na.rm = T)
  rad = aggregate(data[[dly.in.index]][["SO_RAD"]], by = list(dates), FUN = sum, simplify = T, na.rm = T)
  
  # Assemble data.
  data[[dly.out.index]] = cbind(tmin, tmax[,2], rad[,2], wvel[,2], wdir[,2], dew[,2])
  names(data[[dly.out.index]]) = c("YYYYMMDD", "MIN_TEMP", "MAX_TEMP", "SO_RAD", "W_VEL", "W_DIR", "DP_TEMP")

  # Overwrite with optional alternative data.
  if (toupper(alt) == "T") {data = use_alt_data(data, dly.alt.index, dly.out.index)}
  
  # Find monthly average data.
  mn = format(as.Date(data[[dly.out.index]][["YYYYMMDD"]], tz = checked_tz, format = "%Y%m%d"), format = "%m")
  m.tmin = aggregate(data[[dly.out.index]][["MIN_TEMP"]], by = list(mn), FUN = mean, simplify = T, na.rm = T)
  m.tmax = aggregate(data[[dly.out.index]][["MAX_TEMP"]], by = list(mn), FUN = mean, simplify = T, na.rm = T)
  m.rad = aggregate(data[[dly.out.index]][["SO_RAD"]], by = list(mn), FUN = mean, simplify = T, na.rm = T)
  m.wvel = aggregate(data[[dly.out.index]][["W_VEL"]], by = list(mn), FUN = mean, simplify = T, na.rm = T)
  m.wdir = aggregate(data[[dly.out.index]][["W_DIR"]], by = list(mn), FUN = mean, simplify = T, na.rm = T)
  m.dew = aggregate(data[[dly.out.index]][["DP_TEMP"]], by = list(mn), FUN = mean, simplify = T, na.rm = T)
  data[[mly.out.index]] = cbind(m.tmin, m.tmax[,2], m.rad[,2], m.wvel[,2], m.wdir[,2], m.dew[,2])
  names(data[[mly.out.index]]) = c("MM", "MIN_TEMP", "MAX_TEMP", "SO_RAD", "W_VEL", "W_DIR", "DP_TEMP")
  
  return(data)}


# A function to replace daily data calculations of max, min, and dp temperature with alternative data.
use_alt_data = function(data, dly.alt.index, dly.out.index) {
  alt_df = data[[dly.alt.index]]
  daily_df = data[[dly.out.index]]
  out_df = merge(daily_df, alt_df, by = "YYYYMMDD", all = T)
  data[[dly.out.index]] = data.frame(out_df[c(1, 8, 9, 4, 5, 6, 10)])
  names(data[[dly.out.index]]) = c("YYYYMMDD", "MIN_TEMP", "MAX_TEMP", "SO_RAD", "W_VEL", "W_DIR", "DP_TEMP")
  return(data)}


# A function to calculate erosion indices.
calculate_erosion_indices = function(data, storm.list.index, storm.df.index) {
  if (toupper(verb) == "T") {cat(lr,"Calculating erosion indices...")}
  
  # Parse arguments for user specified equation.
  x.1 = which(args == "ALL")
  x.2 = which(args == "USER")
  x = c(x.1, x.2)
  user_input = NA
  if (length(x) > 0){user_input = args[x + 1]}
  
  # Set energy equations: i is intensity in mm/hr.
  AH282 = parse(text = "0.119 + 0.0873 * log10(i)")
  AH537 = parse(text = "0.119 + 0.0873 * log10(i)")
  AH703 = parse(text = "0.119 + 0.0873 * log10(i)")
  BF = parse(text = "0.29 * (1 - 0.72 * exp(-0.05 * i))")
  MM = parse(text = "0.273 + 0.2168 * exp(-0.048 * i) - 0.4126 * exp(-0.072 * i)")
  USER = parse(text = paste(user_input))
  
  # Select equations to use.
  if (toupper(ee) == "ALL"){eqn = c("AH282", "AH537", "AH703", "BF", "MM", "USER")}
  if (toupper(ee) == "AH282"){eqn = "AH282"}
  if (toupper(ee) == "AH537"){eqn = "AH537"}
  if (toupper(ee) == "AH703"){eqn = "AH703"}
  if (toupper(ee) == "BF"){eqn = "BF"}
  if (toupper(ee) == "MM"){eqn = "MM"}
  if (toupper(ee) == "USER"){eqn = "USER"}
  
  # Loop over each equation.
  for (name in eqn){
    exp = get(name)
    
    # Loop over each storm.
    for (storm in 1:length(data[[storm.list.index]])){
      i = data[[storm.list.index]][[storm]][["INTENSITY"]]
      
      # Limit intensity for some equations.
      if (name == "AH537"){i[i > 76] = 76}
      if (name == "AH703"){i[i > 76] = 76}
      
      # Evaluate energy expression for energy density and calculate kinetic energy for each intensity.
      data[[storm.list.index]][[storm]][[paste(name, "_ED", sep = "")]] = eval(exp)
      data[[storm.list.index]][[storm]][[paste(name, "_KE", sep = "")]] = data[[storm.list.index]][[storm]][[paste(name, "_ED", sep = "")]] * data[[storm.list.index]][[storm]][["PRECIP"]]}}
  
  # Calculate and store other important storm parameters.
  dtimes = unname(unlist(lapply(data[[storm.list.index]], function(x) x[["DT_1"]][1])))
  depth = unname(unlist(lapply(data[[storm.list.index]], function(x) sum(x[["PRECIP"]], na.rm = T))))
  dur = unname(unlist(lapply(data[[storm.list.index]], function(x) max(x[["CUM_TIME"]], na.rm = T) - min(x[["CUM_TIME"]], na.rm = T) + x[["DUR"]][1])))
  pdur = unname(unlist(lapply(data[[storm.list.index]], function(x) sum(x[["DUR"]], na.rm = T))))
  ip = unname(unlist(lapply(data[[storm.list.index]], function(x) max(x[["INTENSITY"]], na.rm = T))))
  itw = unname(unlist(lapply(data[[storm.list.index]], function(x) weighted.mean(x[["INTENSITY"]], x[["DUR"]], na.rm = T))))
  idw = unname(unlist(lapply(data[[storm.list.index]], function(x) weighted.mean(x[["INTENSITY"]], x[["PRECIP"]], na.rm = T))))
  i30 = unname(unlist(lapply(data[[storm.list.index]], function(x) max(x[["30_MIN_INT"]], na.rm = T))))
  tp = unname(unlist(lapply(data[[storm.list.index]], function(x) {
    t.vec = x[["CUM_TIME"]] - min(x[["CUM_TIME"]], na.rm = T) + x[["DUR"]][1]
    tp.vec = which(x[["INTENSITY"]] == max(x[["INTENSITY"]], na.rm = T))
    return(median(t.vec[tp.vec], na.rm = T)/max(t.vec, na.rm = T))})))
  
  # When storm duration is less than 30 minutes, I30 is twice the depth of the storm.
  i30[which(dur < 30)] = 2*depth[which(dur < 30)]
  
  # Calculate storm kinetic energy.
  ke.list = lapply(eqn, function(x) {
    name = paste(x, "_KE", sep = "")
    out = unname(unlist(lapply(data[[storm.list.index]], function(y) sum(y[[name]], na.rm = T))))
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
  ei.names = unlist(lapply(eqn, function(x) paste(x, "_EI", sep = "")))
  names(ei.list) = ei.names
  
  # Convert outputs to dataframes.
  ke.df = list.cbind(ke.list)
  ei.df = list.cbind(ei.list)
  sp.df = as.data.frame(cbind(format(as.POSIXct(dtimes, origin = "1970-01-01")), depth, dur, pdur, pdur/dur, ip, tp, itw, idw, i30))
  names(sp.df) = c("DT", "DEPTH", "DUR", "P_DUR", "P_RATIO", "PEAK_INT", "PEAK_TIME", "TIME_WM_INT", "DEPTH_WM_INT", "MAX_30_MIN_INT")
  
  # Calculate storm antecedent times.
  sp.df[["ANT_TIME"]] = c(NA, difftime(tail(sp.df[["DT"]], -1), head(sp.df[["DT"]], -1), units = "mins"))
  
  # Store output.
  data[[storm.df.index]] = cbind(sp.df, ke.df, ei.df)
  tmp = c(F, sapply(data[[storm.df.index]], is.factor)[-1])
  data[[storm.df.index]][tmp] = sapply(data[[storm.df.index]][tmp], function(x) as.numeric(as.character(x)))
  return(data)}


# A function to fill missing daily data.
fill_data = function(data, pcp.in.index, dly.pcp.in.index, dly.var.in.index, dly.pcp.fil.index, dly.var.fil.index, pcp.fil.index) {
  if (toupper(verb) == "T") {cat(lr,"Preparing to impute data...")}

  # Create clustering column for daily and precipitation dataframes.
  data[[pcp.fil.index]] = data.frame(data[[pcp.in.index]][["DT_1"]], na.omit(create_cluster_col(data[[pcp.in.index]], "DT_1", "%Y-%m-%d %H:%M:%S")))
  data[[dly.var.fil.index]] = create_cluster_col(data[[dly.var.in.index]], "YYYYMMDD", "%Y%m%d")
  
  # Rename if necessary.
  names(data[[pcp.fil.index]]) = c("DT_1", names(data[[pcp.fil.index]][,-1]))

  # Merge with daily dataframe with daily precipitation dataframe.
  data[[dly.var.fil.index]] = merge(data[[dly.var.fil.index]], data[[dly.pcp.in.index]], by = "YYYYMMDD", all = T)

  # Subset and order daily dataframe (columns) for imputation.
  dly.var.df = data[[dly.var.fil.index]][,c(2, 5, 4, 3, 8, 6, 7)]
  dly.pcp.df = data[[dly.var.fil.index]][,c(2, 9:13)]
  pcp.ts.df = data[[pcp.fil.index]]
  
  # Prepare event factor column.
  dly.var.df[["EVENT"]] = 0
  dly.var.df[["EVENT"]][dly.pcp.df[["PRECIP"]] > 0] = 1
  dly.var.df[["EVENT"]] = as.factor(dly.var.df[["EVENT"]])
  dly.pcp.df[["D_BPS"]][is.na(dly.pcp.df[["D_BPS"]]) == T] = 0
  
  # Create split factor
  dly.pcp.df[["COUNT"]] = 1:nrow(dly.pcp.df)
  pcp.present = is.na(dly.pcp.df[["D_BPS"]]) == F
  split.fact = as.factor(unname(unlist(apply(dly.pcp.df[pcp.present,], 1, function(x) rep(x[["COUNT"]], x[["D_BPS"]])))))
  
  # Split precipitation time series
  pcp.ts.list = split(pcp.ts.df[1:sum(dly.pcp.df[["D_BPS"]], na.rm = T),], split.fact)
  
  # Prepare dataframe for finding missing precipitation.
  dly.mis.df = data.frame(data[[dly.var.fil.index]][,1], dly.var.df)
  names(dly.mis.df) = c("YYYYMMDD", names(dly.var.df))
  
  # Insert NAs for missing precipitation days to be filled.
  dly.mis.df = find_missing_precip(dly.mis.df)
  dly.mis.df[["EVENT"]][dly.mis.df[["MISSING"]] == 1] = NA
  
  # Create a column to track rows for recombining.
  dly.var.df = data.frame(as.factor(dly.var.df[["CLUSTER"]]), dly.mis.df[,3:9])
  names(dly.var.df) = c("CLUSTER", names(dly.var.df)[-1])
  
  # Impute missing daily solar radiation data.
  if (toupper(verb) == "T") {cat(lr,"Imputing daily solar radiation data...")}
  dly.var.df[,1:2] = impute_by_df(dly.var.df[,1:2], "cart")
  
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
  date.match = data[[dly.var.fil.index]][dly.var.df[["EVENT"]] == 1, 1]
  cluster.match = data[[dly.var.fil.index]][dly.var.df[["EVENT"]] == 1, 2]
  dly.eve.var.df = dly.var.df[dly.var.df[["EVENT"]] == 1,]
  dly.eve.pcp.df = dly.pcp.df[dly.var.df[["EVENT"]] == 1, c(2, 6)]
  dly.eve.con.df = dly.pcp.df[dly.var.df[["EVENT"]] == 1, c(3:5)]
  dly.eve.pcp.df[["D_BPS"]][dly.eve.pcp.df[["D_BPS"]] == 0] = NA
  
  # Combine precipitation event dataframes.
  dly.eve.df = data.frame(dly.eve.var.df, dly.eve.pcp.df)
  
  # Impute missing precipitation characteristics data.
  if (toupper(verb) == "T") {cat(lr,"Imputing daily event characteristics data...")}
  dly.imp.df = data.frame(date.match, impute_by_cluster(dly.eve.df, "midastouch"))
  
  # Store daily precipitation data.
  dly.pcp.df = dly.imp.df[,c(1, 10:11)]
  names(dly.pcp.df) = c("YYYYMMDD", "D_BPS", "PRECIP")
  data[[dly.pcp.fil.index]] = dly.pcp.df
  
  # Store daily non-precipitation data.
  dly.var.df = data.frame(as.POSIXct(as.character(dly.mis.df[["YYYYMMDD"]]), format = "%Y%m%d"), dly.var.df[,c(4:2, 6, 7, 5)])
  names(dly.var.df) = c("DT_3", "MIN_TEMP", "MAX_TEMP", "SO_RAD", "W_VEL", "W_DIR", "DP_TEMP")
  data[[dly.var.fil.index]] = dly.var.df
  
  # Recombine event data.
  dly.eve.df = data.frame(dly.imp.df, dly.eve.con.df)
  empty.days = which(is.na(dly.eve.df[["E_LEN"]] == T))

  # Create empty elements in precipitation time series list.
  fil.ts.list = list()
  fil.list = 1:nrow(dly.eve.df)
  pcp.list = fil.list
  if (length(empty.days) > 0) {pcp.list = fil.list[-empty.days]}
  
  # Copy existing precipitation data to the correct positions.
  for (i in 1:length(pcp.list)) {fil.ts.list[[pcp.list[i]]] = pcp.ts.list[[i]]}
  
  # Create new empty dataframes for the correct positions.
  cols = ifelse(toupper(ei) == "T", 14, 13)
  for (i in 1:length(empty.days)) {fil.ts.list[[empty.days[i]]] = data.frame(matrix(NA, nrow = dly.eve.df[["D_BPS"]][empty.days[i]], ncol = cols))}
  
  # Name new empty dataframes in the correct positions.
  for (i in 1:length(empty.days)) {names(fil.ts.list[[empty.days[i]]]) = names(pcp.ts.list[[1]])}
  
  # Add known daily information to the filled positions.
  for (i in 1:length(empty.days)) {fil.ts.list[[empty.days[i]]][,1] = as.POSIXct(as.character(date.match[empty.days[i]]), format = "%Y%m%d")}
  for (i in 1:length(empty.days)) {fil.ts.list[[empty.days[i]]][,2] = date.match[empty.days[i]]}
  for (i in 1:length(empty.days)) {fil.ts.list[[empty.days[i]]][,3] = cluster.match[empty.days[i]]}
  
  # Convert precipitation time series list to dataframe.
  pcp.ts.df = rbindlist(fil.ts.list)

  # Create imputation dataframe.
  imp.ts.df = pcp.ts.df[,c(3:5)]
  imp.ts.df[["HOUR"]] = as.numeric(substr(pcp.ts.df[["DT_1"]], 12, 13))
  imp.ts.df[["MINUTE"]] = as.numeric(substr(pcp.ts.df[["DT_1"]], 15, 16))
  imp.ts.df[["SECOND"]] = as.numeric(substr(pcp.ts.df[["DT_1"]], 18, 19))
  imp.ts.df[is.na(pcp.ts.df[["PRECIP"]]) == T, 2:6] = NA
  
  # Impute missing precipitation time series values.
  if (toupper(verb) == "T") {cat(lr,"Imputing precipitation time series...")}
  imp.ts.df = impute_by_cluster(imp.ts.df, "midastouch")

  # Reformat time series data.
  if (toupper(verb) == "T") {cat(lr,"Returning imputed data...")}
  imp.ts.df[["DT_1"]] = paste(pcp.ts.df[["YYYYMMDD"]], " ", imp.ts.df[["HOUR"]], ":", imp.ts.df[["MINUTE"]], ":", imp.ts.df[["SECOND"]], sep = "")
  imp.ts.df[["DT_1"]] = as.POSIXct(imp.ts.df[["DT_1"]], format = "%Y%m%d %H:%M:%S")
  imp.ts.df = imp.ts.df[,c(7, 2:3)]

  # Change duplicated times.
  continue = T
  counter = 0
  if (toupper(verb) == "T") {cat(lr,"Moving duplicated precipitation events...")}
  while (continue == T) {
    counter = counter + 1
    imp.ts.df = imp.ts.df[order(imp.ts.df[["DT_1"]]),]
    dup.locs = which(duplicated(imp.ts.df[["DT_1"]]) == T)
    imp.ts.df[["DT_1"]][dup.locs] = imp.ts.df[["DT_1"]][dup.locs - 1] - imp.ts.df[["DUR"]][dup.locs] * 60
    if (counter == 10000) {continue = F}
    if (length(dup.locs) == 0) {continue = F}}
  
  # Combine precipitation time series data.
  pcp.ts.df = pcp.ts.df[,-c(2:3)]
  pcp.ts.df[,1:3] = imp.ts.df
  
  # Recompute antecedent times.
  if (toupper(verb) == "T") {cat(lr,"Recomputing antecedent times...")}
  dif = c(0, difftime(tail(pcp.ts.df[["DT_1"]], -1), head(pcp.ts.df[["DT_1"]], -1), units = "mins"))
  pcp.ts.df[["ANT_TIME"]] = dif
  pcp.ts.df[["CUM_TIME"]] = cumsum(pcp.ts.df[["ANT_TIME"]])
  
  # Calculate scale factors for daily precipitation matching.
  if (toupper(verb) == "T") {cat(lr,"Scaling breakpoint precipitation amounts...")}
  e.row = unname(unlist(c(cumsum(data[[dly.pcp.fil.index]]["D_BPS"]))))
  s.row = c(1, e.row[-length(e.row)] + 1)
  r.row = mapply(function(x, y) {x:y}, s.row, e.row)
  i.pcp = unname(unlist(lapply(r.row, function(x) sum(pcp.ts.df$PRECIP[x]))))
  pcp.sf = as.list(data[[dly.pcp.fil.index]]$PRECIP/i.pcp)
  
  # Scale precipitation time series to match imputed daily amounts.
  pcp.ts.df$PRECIP = unlist(mapply(function(x, y) {pcp.ts.df$PRECIP[x] * y}, r.row, pcp.sf))
  
  # Check scaled daily precipitation amounts.
  #f.pcp = unname(unlist(lapply(r.row, function(x) sum(pcp.ts.df$PRECIP[x]))))
  
  # Store precipitation time series data.
  data[[pcp.fil.index]] = pcp.ts.df
  
  return(data)}


# A function to return a timeseries dataframe with a clustering column.
create_cluster_col = function(in.df, dt.col.name, dt.format) {
  
  # Determine start and end times if unspecified.
  start = as.Date(in.df[[dt.col.name]][1], format = dt.format)
  end = as.Date(in.df[[dt.col.name]][nrow(in.df)], format = dt.format)
  
  # Change start and end times if user specified dates are different.
  if (toupper(sdt) != "START") {start = as.Date(sdt, format = dtf1)}
  if (toupper(edt) != "END") {end = as.Date(edt, format = dtf1)}
  
  # Create sequences for filling and stop if data insufficient (~3 years).
  seq = format(seq(start, end, by = "days"), "%Y%m%d")
  if (nrow(na.omit(in.df)) < 1000) {stop("\033[1;31mInsufficient Data: at least three years of data must be present for reliable filling.\033[0m")}
  
  # Convert datetime column if necessary.
  if (dt.format != "%Y%m%d") {in.df[[dt.col.name]] = format(as.Date(in.df[[dt.col.name]], format = dt.format), "%Y%m%d")}
  
  # Prepare clustering vectors.
  dts = as.POSIXlt(seq, format = "%Y%m%d")
  dys = as.numeric(format(dts, "%Y%m%d"))
  mns = as.numeric(substr(dys, 5, 6))
  hlf = as.numeric(substr(dys, 7, 8))
  hlf[hlf <= 15] = 1
  hlf[hlf >= 16] = 2
  hmn = 2 * mns
  hmn[hlf == 1] = hmn[hlf == 1] - 1
  #jul = sapply(as.POSIXlt(dts), function(x) x$yday + 1)
  
  # Determine the best clustering method.
  min.len.mns = min(sapply(unique(mns), function(x) length(which(mns == x))))
  min.len.hmn = min(sapply(unique(hmn), function(x) length(which(hmn == x))))
  if (min.len.mns < 30) {out.df = data.frame(dys, 1); names(out.df) = c(dt.col.name, "CLUSTER")}
  if (min.len.mns >= 30) {out.df = data.frame(dys, mns); names(out.df) = c(dt.col.name, "CLUSTER")}
  if (min.len.hmn >= 30) {out.df = data.frame(dys, hmn); names(out.df) = c(dt.col.name, "CLUSTER")}
  
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
  
  # Prepare dataframe for clustering.
  in.df[["YYYY"]] = as.numeric(substr(in.df[["YYYYMMDD"]], 1, 4))
  in.df[["YYYYMM"]] = as.numeric(substr(in.df[["YYYYMMDD"]], 1, 6))
  in.df[["CLUSTER"]] = as.numeric(substr(in.df[["YYYYMMDD"]], 5, 6))
  
  # Classify station as wet, moderate, or dry (for maximum annual consecutive dry day estimate).
  day.class = table(na.omit(in.df)$EVENT)
  wet.ratio = day.class[2] / sum(day.class)
  if (wet.ratio >= 0.333) {max.cons.dry.est = 28} # 4 consecutive dry weeks
  if (wet.ratio <= 0.333) {max.cons.dry.est = 56} # 8 consecutive dry weeks
  if (wet.ratio <= 0.167) {max.cons.dry.est = 84} # 12 consecutive dry weeks
  
  # Check total time series.
  full.tally = rle(as.numeric(as.character(in.df$EVENT)))
  in.df$MISSING = 0
  
  # Mark long periods with no precipitation as missing.
  if (length(which(full.tally$lengths >= max.cons.dry.est)) > 0) {
    
    # Logic operations.
    long.runs = which(full.tally$lengths >= max.cons.dry.est)
    miss.runs = which(full.tally$values == 0)
    miss.lens = full.tally$lengths[intersect(long.runs, miss.runs)]
    miss.ends = cumsum(full.tally$lengths)[intersect(long.runs, miss.runs)]
    miss.starts = miss.ends - miss.lens + 1
    miss.series = unlist(mapply(function(x, y) {x:y}, miss.starts, miss.ends))
    
    # Mark missing days (rows).
    in.df$MISSING[miss.series] = 1}
  
  # Make major event gaps NA.
  in.df$EVENT[in.df$MISSING == 1] = NA
  
  # Check for each cluster (month) if there are enough observations.
  if (min(table(na.omit(in.df)$CLUSTER)) >= 280) {
    
    # Preallocate storage.
    clusters = unique(in.df$CLUSTER)
    length = length(clusters)
    stats = data.frame(matrix(NA, nrow = length, ncol = 6))
    
    # Compute dry day statistics by cluster.
    for (j in 1:length) {
      
      # Subset by cluster.
      cluster.locs = which(in.df$CLUSTER == clusters[j])
      cluster.df = in.df[cluster.locs,]
      
      # Preallocate storage.
      yr.months = unique(cluster.df$YYYYMM)
      yr.length = length(yr.months)
      yr.stats = data.frame(matrix(NA, nrow = yr.length, ncol = 6))
      
      # Get clustered annual results.
      for (k in 1:yr.length) {
        
        # Subset per annum.
        annual.locs = which(cluster.df$YYYYMM == yr.months[k])
        annual.df = cluster.df[annual.locs,]
        
        # Tally runs.
        tally = rle(as.numeric(as.character(annual.df$EVENT)))
        table = table(tally$lengths[tally$values == 0])
        dry7 = sum(table[as.numeric(names(table)) >= 7])
        dry14 = sum(table[as.numeric(names(table)) >= 14])
        dry21 = sum(table[as.numeric(names(table)) >= 21])
        dry28 = sum(table[as.numeric(names(table)) >= 28])
        drys = sum(annual.df$EVENT == 0)
        
        # Store results.
        yr.stats[k,] = c(yr.months[k], drys, dry7, dry14, dry21, dry28)}
      
      # Compute two-tail 95% CI upper bound (roughly 20-year) quantiles.
      drys.95 = ceiling(quantile(yr.stats[,2], 0.975, na.rm = T))
      dry7.95 = ceiling(quantile(yr.stats[,3], 0.975, na.rm = T))
      dry14.95 = ceiling(quantile(yr.stats[,4], 0.975, na.rm = T))
      dry21.95 = ceiling(quantile(yr.stats[,5], 0.975, na.rm = T))
      dry28.95 = ceiling(quantile(yr.stats[,6], 0.975, na.rm = T))
      
      # Store results.
      stats[j,] = c(clusters[j], drys.95, dry7.95, dry14.95, dry21.95, dry28.95)}
    
    # Classify wet months (more than 1/3 wet days and up to 2 non-consecutive dry weeks in 20 years).
    wet.months = which(stats$X2 <= 20 & stats$X3 <= 2)
    
    # Classify moderate months (more than 1/6 wet days and up to 2 consecutive dry weeks in 20 years).
    mod.months = which(stats$X2 <= 25 & stats$X4 <= 1)
    if (length(intersect(wet.months, mod.months)) > 0) {mod.months = mod.months[-which(wet.months %in% mod.months)]}
    
    # Classify dry months (less than 1/6 wet days or more than 2 consecutive dry weeks in 20 years).
    dry.months = stats$X1
    if (length(c(wet.months, mod.months)) > 0) {dry.months = dry.months[-which(dry.months %in% c(wet.months, mod.months))]}
    
    # Loop over month types (wet, moderate, and dry).
    month.types = list(wet.months, mod.months, dry.months)
    mn.cons.dds = c(14, 21, 28)
    for (j in 1:3) {
      
      # Loop over months.
      for (k in month.types[[j]]) {
        
        # Mark long periods with no precipitation as missing.
        if (length(which(full.tally$lengths >= mn.cons.dds[j])) > 0) {
          
          # Logic operations.
          long.runs = which(full.tally$lengths >= mn.cons.dds[j])
          miss.runs = which(full.tally$values == 0)
          miss.lens = full.tally$lengths[intersect(long.runs, miss.runs)]
          miss.ends = cumsum(full.tally$lengths)[intersect(long.runs, miss.runs)]
          miss.starts = miss.ends - miss.lens + 1
          miss.series = unlist(mapply(function(x, y) {x:y}, miss.starts, miss.ends))
          miss.months = in.df$CLUSTER[miss.series]
          
          # Mark missing days (rows) if in month analyzed.
          miss.match = which(miss.months %in% k)
          miss.series = miss.series[miss.match]
          in.df$MISSING[miss.series] = 1}}}}
  
  return(in.df)}


# A function to create graphical output.
graph_data = function(data, x) {
  if (toupper(verb) == "T") {cat(lr,"Plotting data...")}
  
  # Build rate data if qc = F.
  if (toupper(qc) == "F"){data = build_rate_data(data, x)}
  
  # Create directory structure.
  setwd(plot.dir)
  dir.list = c("INPUT", "OUTPUT")
  for (j in dir.list){create_directory(j)}
  
  # Loop over variable groups and variables.
  var.list = list(c("PRECIP"), c("AIR_TEMP", "REL_HUM"), c("MIN_TEMP", "MAX_TEMP", "SO_RAD", "W_VEL", "DP_TEMP"))
  var.unit = list(c("mm"), c("C", "%"), c("C", "C", "Langleys", "m/s", "C"))
  for (i in x){
    for (j in var.list[[i]]){
      
      # Get datetime, state, and rate data (by variable name).
      cols = c(1, 2, grep(j, names(data[[5]][[i]])))
      tmp = data[[5]][[i]][,cols]
      
      # Create INPUT directories and plots.
      setwd("INPUT")
      create_input_plots(j, var.unit[[i]][[which(var.list[[i]] == j)]], tmp, data)}}
  
  # Create OUTPUT directories.
  plot.list = c("ANNUAL", "MONTHLY", "DAILY", "STORMS")
  for (i in plot.list){
    setwd(plot.dir)
    setwd("OUTPUT")
    create_directory(i)
    setwd(i)
    
    # Create OUTPUT plots.
    if (i == "DAILY"){daily_plots(data)}
    if (i == "MONTHLY"){monthly_plots(data)}
    if (as.numeric(data[[4]][["YRS_SIM"]]) >= 5){
      if (i == "ANNUAL"){annual_plots(data)}
      if (toupper(ei) == "T"){
        if (i == "STORMS"){storm_plots(data)}}}}
  
  setwd(home.dir)}


# A function to create plots for each variable.
create_input_plots = function(j, var.unit, tmp, data) {
  create_directory(j)
  setwd(j)
  
  # Get station name.
  if (toupper(fn) == "STATION"){fn = data[[4]]["STATION"]}
  
  # Set vectors.
  tmp = na.omit(tmp)
  dt = as.POSIXlt(tmp[["DT"]], origin = "1970-01-01 00:00.00 UTC")
  mns = as.factor(tmp[["MN"]])
  var = tmp[[paste(j, "_VAR", sep = "")]]
  rate = tmp[[paste(j, "_RATE", sep = "")]]
  
  # Plot variable state data if it is present.
  if(length(unique(var)) > 1){
    s_var = sample(var, min(5000, length(var)))
    if (length(var) > 0){
      
      # Time Series
      pdf(paste(fn, "_", j, "_var_time_series.pdf", sep = ""), width = 6, height = 3, pointsize = 10)
      plot(dt, var, type = "l", main = paste("Time series of ", j, sep = ""), xlab = "Date", ylab = paste(j, " (", var.unit, ")", sep = ""))
      dev.off()
      
      # Histogram
      pdf(paste(fn, "_", j, "_var_histogram.pdf", sep = ""), width = 6, height = 6, pointsize = 10)
      hist(var, main = paste("Histogram of ", j, sep = ""), xlab = paste(j, " (", var.unit, ")", sep = ""))
      dev.off()
      
      # Boxplot
      pdf(paste(fn, "_", j, "_var_boxplot.pdf", sep = ""), width = 6, height = 6, pointsize = 10)
      boxplot(var ~ mns, main = paste("Boxplot of ", j, sep = ""), xlab = paste(j, " (", var.unit, ")", sep = ""))
      dev.off()
      
      # Normality
      pdf(paste(fn, "_", j, "_var_normality.pdf", sep = ""), width = 6, height = 6, pointsize = 10)
      test_norm(s_var)
      dev.off()}}
  
  # Plot variable rate data if it is present.
  if(length(unique(rate)) > 1){
    s_rate = sample(rate, min(5000, length(rate)))
    if (length(rate) > 0){
      
      # Time Series
      pdf(paste(fn, "_", j, "_rate_time_series.pdf", sep = ""), width = 6, height = 3, pointsize = 10)
      plot(dt, rate, type = "l", main = paste("Time series of changes in ", j, sep = ""), xlab = "Date", ylab = paste("Change in ", j, " (", var.unit, ")", sep = ""))
      dev.off()
      
      # Histogram
      pdf(paste(fn, "_", j, "_rate_histogram.pdf", sep = ""), width = 6, height = 6, pointsize = 10)
      hist(rate, main = paste("Histogram of changes in ", j, sep = ""), xlab = paste("Change in ", j, " (", var.unit, ")", sep = ""))
      dev.off()
      
      # Boxplot
      pdf(paste(fn, "_", j, "_rate_boxplot.pdf", sep = ""), width = 6, height = 6, pointsize = 10)
      boxplot(log(abs(rate)) ~ mns, main = paste("Boxplot of changes in ", j, " (Log Transformed)", sep = ""), xlab = paste(j, " (", var.unit, ")", sep = ""))
      dev.off()
      
      # Normality
      pdf(paste(fn, "_", j, "_rate_normality.pdf", sep = ""), width = 6, height = 6, pointsize = 10)
      test_norm(s_rate)
      dev.off()}}
  
  setwd(plot.dir)}


# A function to create annual plots for output data.
annual_plots = function(data) {
  
  # Get station name.
  if (toupper(fn) == "STATION"){fn = data[[4]]["STATION"]}
  
  # Plot for each daily dataset.
  d.list = c(8, 12)
  unit.list = c("Breakpoints", "mm", "C", "C", "Langleys/Day", "m/s", "Degrees (cc) from N", "C")
  counter = 0
  for (i in d.list){
    tmp = data[[i]]
    if (i == 8){tmp = tmp[,-3:-5]; kind = "sum";
    tmp = aggregate(tmp[,-1], by = list(format(as.Date(tmp[,1], format = "%Y%m%d"), format = "%Y")), FUN = sum)}
    if (i == 12){kind = "mean";
    tmp = aggregate(tmp[,-1], by = list(format(as.Date(tmp[,1], format = "%Y%m%d"), format = "%Y")), FUN = mean)}
    
    # Plot for each variable.
    for (j in colnames(tmp)[-1]){
      counter = counter + 1
      unit = unit.list[counter]
      pdf(paste(fn, "_", j, "_annual_", kind, ".pdf", sep = ""), width = 6, height = 4, pointsize = 10)
      barplot(tmp[[paste(j)]], names.arg = tmp[,1], main = paste("Annual ", j, sep = ""), xlab = "Year", ylab = paste(j, " (", unit, ")", sep = ""))
      dev.off()}}
  
  setwd(plot.dir)}


# A function to create monthly plots for output data.
monthly_plots = function(data) {
  
  # Get station name.
  if (toupper(fn) == "STATION"){fn = data[[4]]["STATION"]}
  
  # Plot for each monthly dataset.
  mn.list = c(10, 13)
  unit.list = c("mm", "C", "C", "Langleys/Day", "m/s", "Degrees (cc) from N", "C")
  counter = 0
  for (i in mn.list){
    tmp = data[[i]]
    
    # Plot for each variable.
    for (j in colnames(tmp)[-1]){
      counter = counter + 1
      unit = unit.list[counter]
      pdf(paste(fn, "_", j, "_monthly_means.pdf", sep = ""), width = 6, height = 4, pointsize = 10)
      barplot(tmp[[paste(j)]], names.arg = tmp[,1], main = paste("Monthly Mean ", j, sep = ""), xlab = "Month (1-12)", ylab = paste(j, " (", unit, ")", sep = ""))
      dev.off()}}
  
  setwd(plot.dir)}


# A function to create daily plots for output data.
daily_plots = function(data) {
  
  # Get station name.
  if (toupper(fn) == "STATION"){fn = data[[4]]["STATION"]}
  
  # Plot for each daily dataset.
  d.list = c(8, 12)
  unit.list = c("Breakpoints", "mm", "C", "C", "Langleys/Day", "m/s", "Degrees (cc) from N", "C")
  counter = 0
  for (i in d.list){
    tmp = data[[i]]
    if (i == 8){tmp = tmp[,-3:-5]; g.type = "p"; kind = "sum"}
    if (i == 12){g.type = "l"; kind = "mean"}
    
    # Plot for each variable.
    for (j in colnames(tmp)[-1]){
      counter = counter + 1
      unit = unit.list[counter]
      pdf(paste(fn, "_", j, "_daily_", kind, ".pdf", sep = ""), width = 6, height = 4, pointsize = 10)
      plot(as.Date(tmp[,1], format = "%Y%m%d"), tmp[[paste(j)]], type = g.type, main = paste("Daily ", j, sep = ""), xlab = "Date", ylab = paste(j, " (", unit, ")", sep = ""))
      dev.off()}}
  
  setwd(plot.dir)}


# A function to create storm plots for output data.
storm_plots = function(data) {
  
  # Get station name.
  if (toupper(fn) == "STATION"){fn = data[[4]]["STATION"]}
  
  # Plot for each dataset.
  counter = 0
  col.list = colnames(data[[14]])[-1]
  eqn.count = (length(col.list) - 9)/2
  unit.list = c("mm", "min", "min", "min", "%", "mm/hr", "fraction", "mm/hr", "mm/hr", "mm/hr",
                rep("MJ-mm/Ha-hr", eqn.count), rep("MJ/Ha-hr", eqn.count))
  
  # Plot time series of storm characteristics.
  create_directory("TIME_SERIES")
  setwd("TIME_SERIES")
  for (j in col.list){
    tmp = data[[14]][[paste(j)]]
    dates = as.Date(data[[14]][,1], format = "%Y-%m-%d %H:%M:%S")
    counter = counter + 1
    unit = unit.list[counter]
    pdf(paste(fn, "_", j, "_storm_char_time_series.pdf", sep = ""), width = 6, height = 4, pointsize = 10)
    plot(dates, tmp, type = "p", xlab = "Datetime", ylab = paste(j, " (", unit, ")", sep = ""),
         main = paste("Storm Characteristics Time Series (", j, ")", sep = ""))
    dev.off()}
  setwd("..")
  
  # Prepare monthly storm characteristic data.
  tmp = data[[14]][,-1]
  tmp.sum = aggregate(tmp, by = list(format(as.Date(dates, format = "%Y-%m-%d"), format = "%Y%m")), FUN = sum)
  tmp.avg = aggregate(tmp, by = list(format(as.Date(dates, format = "%Y-%m-%d"), format = "%Y%m")), FUN = mean)
  tmp.med = aggregate(tmp, by = list(format(as.Date(dates, format = "%Y-%m-%d"), format = "%Y%m")), FUN = median)
  Month = substr(tmp.sum[,1], 5, 6)
  mn.sum = data.frame(Month, tmp.sum[,-1])[,c(-6, -7, -8, -9, -10, -11)]
  mn.avg = data.frame(Month, tmp.avg[,-1])
  mn.med = data.frame(Month, tmp.med[,-1])
  loop.list = list(mn.sum, mn.avg, mn.med)
  name.list = c("Summed", "Mean", "Median")
  sumu.list = c("mm", "min", "min", "min", rep("MJ-mm/Ha-hr", eqn.count), rep("MJ/Ha-hr", eqn.count))
  refu.list = list(sumu.list, unit.list, unit.list)
  col.pal.1 = c("#1F28A2", "#5A5DA6", "#9394C0", "#F1F1F1", "#C18989", "#9D4B4B",
                "#7C0607", "#9D4B4B", "#C18989", "#F1F1F1", "#9394C0", "#5A5DA6")
  
  # Loop over each statistic.
  create_directory("DENSITY")
  setwd("DENSITY")
  for (k in 1:3){
    df = loop.list[[k]]
    counter = 0
    create_directory(toupper(name.list[k]))
    setwd(name.list[k])
    col.list = colnames(df)
    
    # Create monthly density plots.
    for (j in col.list[-1]){
      counter = counter + 1
      unit = refu.list[[k]][counter]
      ggplot(df) +
        geom_density(aes(x = df[[paste(j)]], fill = Month), alpha = 0.4) +
        labs(title = paste("Density of Monthly ", name.list[k], " Storm: ", j, sep = ""), x = paste(j, " (", unit, ")", sep = ""), y = "Density") +
        scale_fill_manual(values = col.pal.1) +
        geom_vline(aes(xintercept = mean(df[[paste(j)]], na.rm = T)), linetype = "dashed") +
        theme_classic()
      ggsave(paste(fn, "_monthly_", tolower(name.list[k]), "_", j, "_density.pdf", sep = ""), width = 6, height = 4)}
    setwd("..")}
  setwd("..")
  setwd(plot.dir)}


# A function to export the primary data structure to file.
export_data = function(data) {
  if (toupper(verb) == "T") {cat(lr,"Exporting data...")}
  setwd(e)
  if (toupper(fn) == "STATION"){fn = data[[4]]["STATION"]}
  if (ed == 1){saveRDS(data, paste(fn, ".rds", sep = ""))}
  if (ed == 2){list.save(data, paste(fn, ".json", sep = ""))}
  setwd(home.dir)}


# A function to create header data for .cli file creation function.
generate_header_data = function(data) {
  if (toupper(verb) == "T") {cat(lr,"Generating header data...")}
  
  # Get station data.
  station = data[[4]][["STATION"]]
  lat = format(round(as.numeric(data[[4]][["LAT"]]), 4), justify = "right", width = 8, nsmall = 4)
  lon = format(round(as.numeric(data[[4]][["LON"]]), 4), justify = "right", width = 9, nsmall = 4)
  elev = format(round(as.numeric(data[[4]][["ELEV"]]), 2), justify = "right", width = 6, nsmall = 2)
  oyr = format(round(as.numeric(data[[4]][["OBS_YRS"]]), 0), justify = "right", width = 3, nsmall = 0)
  byr = format(round(as.numeric(data[[4]][["B_YR"]]), 0), justify = "right", width = 4, nsmall = 0)
  syr = format(round(as.numeric(data[[4]][["YRS_SIM"]]), 0), justify = "right", width = 3, nsmall = 0)
  
  # Get monthly average data.
  m.min.t = data[[13]][,2]
  m.max.t = data[[13]][,3]
  m.sorad = data[[13]][,4]
  m.precip = data[[10]][,2]
  
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
    h.4 = paste(lr, " Day Month Year  Prcp  Dur   TP     IP  T-Max  T-Min   Rad   W-Vel  W-Dir  T-Dew")
    h.5 = paste(lr, "                 (mm)  (h)               (C)    (C)   (L/d)  (m/s)  (Deg)   (C)")}
  
  # Prepare fixed format, breakpoint format column headers.
  if (bf == 1){
    h.4 = paste(lr, " Day Month Year  Breaks  T-Max  T-Min   Rad   W-Vel  W-Dir  T-Dew")
    h.5 = paste(lr, "                   (#)    (C)    (C)   (L/d)  (m/s)  (Deg)   (C)")}
  
  # Combine and return.
  header = paste(h.1, h.2, h.3, h.4, h.5, sep = "")
  return(header)}


# A function to create export data for .cli file creation function.
generate_export_data = function(data, bps.loc, dly.loc, pcp.loc) {
  if (toupper(verb) == "T") {cat(lr,"Generating body data...")}
  
  # Format date data.
  dates = as.character(data[[dly.loc]][,1])
  dy = format(as.integer(format(as.Date(dates, format = "%Y%m%d"), format = "%d")), justify = "right", width = 2)
  mn = format(as.integer(format(as.Date(dates, format = "%Y%m%d"), format = "%m")), justify = "right", width = 2)
  yr = format(as.integer(format(as.Date(dates, format = "%Y%m%d"), format = "%Y")), justify = "right", width = 4)
  
  # Prepare daily data.
  daily_df = Reduce(function(...) merge(..., all=TRUE), list(data[[bps.loc]], data[[dly.loc]]))
  dates = daily_df[["YYYYMMDD"]]
  if (sm == 2) {daily_df = daily_df[1,]}
  
  # Prepare precipitation data.
  pcp_df = data[[pcp.loc]]
  pcp_df[["ADJ_NEW_DAY"]] = F
  pcp_df[["NON_PCP_TIME"]] = pcp_df[["ANT_TIME"]] - pcp_df[["DUR"]]
  pcp_df[["MIDNIGHT"]] = grepl("00:00:00", pcp_df[["DT_1"]])
  
  # Move a midnight breakpoint to the previous day.
  pcp_df[["BPT_ADJ"]] = c(as.numeric(pcp_df[["MIDNIGHT"]])[-1], 0)
  pcp_df[["BPT_ADJ"]][pcp_df[["MIDNIGHT"]]] = -1
  
  # Update daily data.
  increase_days = substr(pcp_df[["DT_1"]][c(pcp_df[["MIDNIGHT"]][-1], F)], 1, 10)
  decrease_days = substr(pcp_df[["DT_1"]][pcp_df[["MIDNIGHT"]]], 1, 10)
  daily_days = paste(substr(dates, 1, 4), "-", substr(dates, 5, 6), "-", substr(dates, 7, 8), sep = "")
  increase = which(daily_days %in% increase_days)
  decrease = which(daily_days %in% decrease_days)
  daily_df[["D_BPS"]][increase][is.na(daily_df[["D_BPS"]][increase])] = 0
  daily_df[["D_BPS"]][increase] = daily_df[["D_BPS"]][increase] + 1
  daily_df[["D_BPS"]][decrease][is.na(daily_df[["D_BPS"]][decrease])] = 0
  daily_df[["D_BPS"]][decrease] = daily_df[["D_BPS"]][decrease] - 1
  
  # Add a breakpoint for everyday there is precipitation.
  tmp = daily_df[["D_BPS"]]
  tmp[is.na(tmp) == T] = 0
  precip_days = tmp > 0
  daily_df[["ADJ_BPS"]] = daily_df[["D_BPS"]]
  daily_df[["ADJ_BPS"]][precip_days] = daily_df[["ADJ_BPS"]][precip_days] + 1
  
  # Add a breakpoint for every non-precipitation breakpoint.
  NBPTS = unique(c(1, cumsum(tmp) + 1))
  if (NBPTS[length(NBPTS)] > nrow(pcp_df)){NBPTS = NBPTS[-length(NBPTS)]}
  pcp_df[["NEW_DAY"]] = F
  pcp_df[["NEW_DAY"]][NBPTS] = T
  pcp_df[["DAY"]] = cumsum(pcp_df[["NEW_DAY"]])
  pcp_df[["NON_PCP_BP"]] = F
  pcp_df[["NON_PCP_BP"]][intersect(which(pcp_df[["NEW_DAY"]] == F), which(pcp_df[["NON_PCP_TIME"]] > 0))] = T
  increase = aggregate(pcp_df[["NON_PCP_BP"]], by = list(pcp_df[["DAY"]]), FUN = sum)[,2]
  daily_df[["ADJ_BPS"]][precip_days] = daily_df[["ADJ_BPS"]][precip_days] + increase
  
  # Use new nbrkpt values.
  daily_df[["D_BPS"]][is.na(daily_df[["D_BPS"]])] = 0
  daily_df[["ADJ_BPS"]][is.na(daily_df[["ADJ_BPS"]])] = 0
  
  # Format columns.
  nbrkpt = format(as.integer(daily_df[["D_BPS"]]), justify = "right", width = 3, nsmall = 0)
  adjbrkpt = format(as.integer(daily_df[["ADJ_BPS"]]), justify = "right", width = 3, nsmall = 0)
  tmin = format(round(as.numeric(daily_df[["MIN_TEMP"]]), 1), justify = "right", width = 5, nsmall = 1)
  tmax = format(round(as.numeric(daily_df[["MAX_TEMP"]]), 1), justify = "right", width = 5, nsmall = 1)
  rad = format(round(as.numeric(daily_df[["SO_RAD"]]), 1), justify = "right", width = 5, nsmall = 1)
  wvel = format(round(as.numeric(daily_df[["W_VEL"]]), 1), justify = "right", width = 5, nsmall = 1)
  wdir = format(round(as.numeric(daily_df[["W_DIR"]]), 1), justify = "right", width = 5, nsmall = 1)
  dew = format(round(as.numeric(daily_df[["DP_TEMP"]]), 1), justify = "right", width = 5, nsmall = 1)
  
  # Combine and export.
  df_out = cbind(dy, mn, yr, nbrkpt, adjbrkpt, tmax, tmin, rad, wvel, wdir, dew)
  export = list(df_out, daily_df)
  return(export)}


# A function to write data to a .cli file.
create_cli_file = function(data, header, export) {
  if (toupper(verb) == "T") {cat(lr,"Generating .cli file...")}
  
  # Import data.
  pcp.loc = ifelse(toupper(id) == "T", 17, 1)
  df = export[[1]]
  daily_df = export[[2]]
  pcp_df = data[[pcp.loc]]
  
  # Initialize loop counters.
  current.pcp = 1
  last.pcp = 0
  daily_rows = 1:nrow(daily_df)
  
  # Handle Single Storm Simulation Mode
  if (as.numeric(sid) > 1 | sm == 2){
    
    # Get Start and End Times
    storm.loc = min(which(data[[1]][["EVENT_ID"]] == sid))
    end.loc = max(which(data[[1]][["EVENT_ID"]] == sid))
    start = as.POSIXct(as.Date(data[[1]][["DT_1"]][storm.loc]), format = "%Y-%m-%d")
    end = as.POSIXct(as.Date(data[[1]][["DT_1"]][end.loc]), format = "%Y-%m-%d")
    daily.start = as.numeric(format(as.Date(start, format = "%Y-%m-%d"), format = "%Y%m%d"))
    daily.end = as.numeric(format(as.Date(end, format = "%Y-%m-%d"), format = "%Y%m%d"))
    
    # Trim Dataframes
    gt_rows = which(pcp_df[["DT_1"]] >= start)
    current.pcp = min(gt_rows)
    
    daily.dates = as.numeric(daily_df[["YYYYMMDD"]])
    gt_rows = which(daily.dates >= daily.start)
    lt_rows = which(daily.dates <= daily.end)
    daily_rows = intersect(gt_rows, lt_rows)
    
    # Recompute Day Count
    daysCount <<- difftime(end, start, units = "days")}
  
  # Prepare precipitation data.
  pcp_df[["HOUR"]] = substr(pcp_df[["DT_1"]], 12, 13)
  pcp_df[["MIN"]] = substr(pcp_df[["DT_1"]], 15, 16)
  pcp_df[["HOUR"]][intersect(which(pcp_df[["HOUR"]] == "00"), which(pcp_df[["MIN"]] == "00"))] = "24"
  
  # Stop when there are missing data.
  if (nrow(daily_df) < ceiling(as.numeric(daysCount))){
    stop("There are missing data. Rerun and perform quality checking [-qc] and fill missing data [-id].")}
  
  # Create file.
  setwd(o)
  if (toupper(fn) == "STATION"){fn = data[[4]]["STATION"]}
  of = paste(fn, ".cli", sep = "")
  file.create(of, overwrite = T)
  
  # Write header.
  temp.file = header
  
  # Write daily lines.
  time.next.status = F
  for (i in daily_rows){
    current.day = i
    temp.new = paste(lr, "  ", df[i,1], "   ", df[i,2], "  ", df[i,3], "    ", df[i,5], "   ", df[i,6], "  ", df[i,7],
                     "  ",   df[i,8], "  ",  df[i,9], "  ", df[i,10], "  ",   df[i,11], sep = "")
    temp.file = append(temp.file, temp.new)
    
    # Write the first breakpoint of the day.
    if (daily_df[i, 2] > 0){
      bp.time = as.numeric(pcp_df[["HOUR"]][current.pcp]) + as.numeric(pcp_df[["MIN"]][current.pcp])/60 - as.numeric(pcp_df[["DUR"]][current.pcp])/60
      bp.depth = 0
      time.out = format(round(bp.time, 3), justify = "right", width = 6, nsmall = 3)
      depth.out = format(round(bp.depth, 2), justify = "right", width = 6, nsmall = 2)
      temp.new = paste(lr, time.out, " ", depth.out, sep = "")
      temp.file = append(temp.file, temp.new)
      need.break = F
      last.pcp = current.pcp + daily_df[i, 2] - 1
      
      # Write precipitation lines (precip and non-precip breaks).
      for (j in current.pcp:last.pcp){
        
        # Write non-precip breaks.
        if (need.break == T){
          bp.time = as.numeric(pcp_df[["HOUR"]][j]) + as.numeric(pcp_df[["MIN"]][j])/60 - as.numeric(pcp_df[["DUR"]][j])/60
          time.out = format(round(bp.time, 3), justify = "right", width = 6, nsmall = 3)
          depth.out = format(round(bp.depth, 2), justify = "right", width = 6, nsmall = 2)
          temp.new = paste(lr, time.out, " ", depth.out, sep = "")
          temp.file = append(temp.file, temp.new)
          need.break = F}
        
        # Write precip breaks.
        if (need.break == F){
          bp.time = as.numeric(pcp_df[["HOUR"]][j]) + as.numeric(pcp_df[["MIN"]][j])/60
          bp.depth = as.numeric(pcp_df[["PRECIP"]][j]) + bp.depth
          time.out = format(round(bp.time, 3), justify = "right", width = 6, nsmall = 3)
          depth.out = format(round(bp.depth, 2), justify = "right", width = 6, nsmall = 2)
          temp.new = paste(lr, time.out, " ", depth.out, sep = "")
          temp.file = append(temp.file, temp.new)}
        
        # Determine if a non-precip break is needed in the next iteration.
        if (j == last.pcp){need.break = F; break()}
        if ((j + 1) > nrow(pcp_df)){need.break = F; break()}
        non_pcp_time = pcp_df[["ANT_TIME"]][j + 1] - pcp_df[["DUR"]][j + 1]
        if (non_pcp_time > 0){need.break = T}
        if (non_pcp_time == 0){need.break = F}}}
    
    # Setup for the next iteration.
    current.pcp = last.pcp + 1}
  
  # Write output to file. "Sink" is supposedly faster than "write_lines" for Windows implementations.
  sink(of, append = F)
  cat(temp.file)
  sink()
  
  setwd(home.dir)}


# A function to end multiprocessing.
kill_cluster = function() {
  cat("\033[0;37mKilling multiprocessing virtual cluster... \033[0m")
  stopImplicitCluster()
  cat("\033[0;37mDone.\033[0m", lr, lr)}


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


# A function to execute the WEPPCLIFF workflow in parallel.
parallel_execution = function(file, s) {
  
  # Print first line to screen.
  cat("\033[0;37mDetected", s, "stations. Parallel processing has been enabled.\033[0m", lr, lr)
  
  # Create multiprocessing cluster.
  create_cluster(s, mp)
  
  # Notify the user and create a log file.
  cat("\033[0;37mProcessing... see the log file (log.txt) for progress.\033[0m", lr, lr)
  file.create("log.txt", overwrite = T)
  
  # Loop over each station file.
  foreach(iter = 1:length(file), .export = export.list, .verbose = F) %dopar% {
    
    # Set the library for each core.
    lapply(package.list, library, lib.loc = lib.dir, character.only = T, quietly = T, verbose = F, attach.required = T)
    
    # Print progress to the log file.
    setwd(o)
    sink("log.txt", append = F)
    cat(paste("Processing ", iter, " of ", length(file), " stations... ", sep = ""))
    sink()
    
    # Perform the core workflow.
    core_workflow(file[iter])}
  
  # Kill the multiprocessing cluster.
  kill_cluster()}


# A function to execute the WEPPCLIFF workflow in series.
series_execution = function(file, s) {
  
  # Print first line to screen.
  if (s > 1){cat("\033[0;37mDetected", s, "stations. Parallel processing has been disabled.\033[0m", lr, lr)}
  if (s == 1){cat("\033[0;37mDetected 1 station. Parallel processing has been disabled.\033[0m", lr, lr)}
  
  # Loop over each station file.
  for (iter in 1:length(file)) {
    
    # Time the execution.
    t.time = system.time({
      
      # Print for each station.
      if (s > 1){cat(paste("\033[0;37mProcessing ", iter, " of ", length(file), " stations... \033[0m", sep = ""))}
      if (s == 1){cat(paste("\033[0;37mProcessing station... \033[0m", sep = ""))}
      
      # Perform the core workflow.
      core_workflow(file[iter])})
    
    # Print execution time results for each station.
    cat("\033[0;37mCompleted in", t.time[3],"seconds.\033[0m", lr, lr)}}


# A function to execute a filling and post-filling workflow.
fill_workflow = function(data) {
  
  # Perform filling routines.
  data = fill_data(data, 1, 8, 12, 15, 16, 17)
  
  # Recompute storm, precipitation, and daily values.
  data = break_storms(data, 17, 7)
  data = process_precip_data(data, 17, 8, 9, 10)
  alt <<- "f"
  data = process_daily_data(data, 16, 11, 12, 13)
  
  # Recompute metadata.
  data[[4]][["B_YR"]] = substr(data[[12]]$YYYYMMDD[1], 1, 4)
  data[[4]][["OBS_YRS"]] = floor(as.numeric(difftime(as.Date(data[[3]]$DT_3[nrow(data[[3]])]), as.Date(data[[3]]$DT_3[1])))/365.2425)
  data[[4]][["YRS_SIM"]] = floor(as.numeric(difftime(as.Date(data[[12]]$YYYYMMDD[nrow(data[[12]])], format = "%Y%m%d"), as.Date(data[[12]]$YYYYMMDD[1], format = "%Y%m%d")))/365.2425)
  return(data)}


# A function to perform the core workflow of WEPPCLIFF.
core_workflow = function(file) {
  data = store_data(file)
  data = convert_data(data)
  data = create_duration_data(data)
  data = convert_units(data)
  if (toupper(alt) == "F") {x = c(1, 3)}
  if (toupper(qc) == "T"){data = check_quality(data, x)}
  data = remove_na_rows(data)
  data = trim_data(data)
  if (toupper(alt) == "T") {data = process_alt_data(data, 2, 11)}
  data = process_precip_data(data, 1, 8, 9, 10)
  data = process_daily_data(data, 3, 11, 12, 13)
  if (toupper(id) == "T") {data = fill_workflow(data)}
  if (toupper(ei) == "T") {data = calculate_erosion_indices(data, 7, 14)}
  if (toupper(pd) == "T") {graph_data(data, x)}
  if (ed > 0) {export_data(data)}
  header = generate_header_data(data)
  if (toupper(id) == "F") {export = generate_export_data(data, 8, 12, 1)}
  if (toupper(id) == "T") {export = generate_export_data(data, 8, 12, 17)}
  create_cli_file(data, header, export)}


# The main program function.
main = function() {
  
  # Read in arguments.
  parse_arg_locations()
  early_license_agreement()
  
  # Print logo and license information.
  print_weppcliff_logo()
  if (toupper(la) == "Y") {print_license_agreement()}
  if (toupper(la) != "Y") {prompt_license_agreement()}
  
  # Initiate run.
  create_base_directory()
  set_wds()
  assign_args_to_vars()
  assign_empty_args()
  
  # First run installation.
  if (fr == "t"){
    install_dependencies()
    suppressMessages(load_packages())
    cat("\033[0;37mInstallation successful. WEPPCLIFF is now ready to run.\033[0m",lr, collapse = "")
    stop_quietly()}
  
  # Read from file and store for processing.
  t.time = system.time({
    
    # Check arguments and load libraries.
    check_args()
    suppressMessages(load_packages())
    
    # Load a single file (if specified).
    if (length(f) == 1) {
      file = load_input_file()
      check_input_format(file)
      file = preprocess_file(file)
      file = split_data(file)}
    
    # Load a directory of files (if specified).
    if (length(f) == 0) {file = load_input_directory()}
    s = length(file)
    
    # Process stations based on the number of stations.
    if (toupper(mp) != "F" && s > 1) {parallel_execution(file, s)}
    if (toupper(mp) == "F" || s <= 1) {series_execution(file, s)}})
  
  # Print total execution time results for this run instance and closing message.
  cat("\033[0;37mProgram executed successfully in", t.time[3],"seconds... now exiting WEPPCLIFF script.\033[0m", lr, lr, lr)
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
          "d", "o", "e", "f", "fn", "delim",
          "u", "qc", "id", "pd", "ed", "alt",
          "cp", "pi", "ei", "ee",
          "sid", "tth", "dth",
          "qcop", "qcth", "qcdf",
          "im", "io", "qi", "iv",
          "sdt", "edt", "tz", "rtb", "dtf1", "dtf2", "dtf3",
          "cv", "sm", "bf", "wi", 
          "mp", "rows",
          "prof", "pint", "mepr", "gcpr", "lnpr", "warn", "verb")

flagnames = c("First Run", "License Agreement",
              "Input Directory", "Output Directory", "Export Directory", "Input Filename", "Output Filename", "File Delimiter",
              "Unit Conversion", "Quality Check", "Impute Missing Data", "Plot Data", "Export Data", "Use Alternative Data",
              "Cumulative Precipitation", "Precipitation Interval", "Calculate Erosion Indices", "Energy Equation(s)",
              "Storm Identifier", "Storm Separation Time Threshhold", "Storm Separation Depth Threshhold",
              "Quality Checking Option", "Stochastic QC Threshhold", "Stochastic QC Critical Difference",
              "Impute Method", "Iteration Override", "Quick Impute", "Impute Verbosity",
              "Start Datetime", "End Datetime", "Timezone", "Round Time Bounds", "Precipitation Datetime Format", "Alternative Data Datetime Format", "Non-Precipitation Datetime Format",
              "CLIGEN Version", "Simulation Mode", "Breakpoint Format", "Wind Information",
              "Multiprocessing", "Row Read Optimization",
              "Profile Code", "Profile Interval", "Profile Memory", "Profile Garbage Collection", "Profile Lines", "Show Warnings", "Verbosity")

flagtypes = c("INSTALLATION ARGUMENTS",
              "INPUT/OUTPUT ARGUMENTS",
              "FUNCTIONALITY ARGUMENTS",
              "PRECIPITATION ARGUMENTS",
              "STORM CONTROL ARGUMENTS",
              "QUALITY CONTROL ARGUMENTS",
              "IMPUTE CONTROL ARGUMENTS",
              "DATETIME ARGUMENTS",
              "CLIGEN FILE FORMAT ARGUMENTS",
              "OPTIMIZATION ARGUMENTS",
              "DEVELOPER ARGUMENTS")

flagcount = c(1,
              3,
              9,
              15,
              19,
              22,
              25,
              29,
              36,
              40,
              42)

var.e.list = c("lr", "args", flags, "u.loc", "ee.loc", "home.dir", "lib.dir", "package.list")
package.list = c("readr", "rlist", "doParallel", "hashmap", "EnvStats", "mice",
                 "RcppParallel", "LambertW", "ggplot2", "profvis", "crayon", "data.table")
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




