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
    affiliation: "1, 2"
  - name: Puneet Srivastava
    affiliation: 3
affiliations:
 - name: Purdue University
   index: 1
 - name: USDA ARS National Soil Erosion Research Laboratory
   index: 2
 - name: Auburn University
   index: 3
date: 2 December 2019
bibliography: paper.bib
---

# Summary

A key driver of erosion, and arguably the most labor-intensive input to erosion models, especially the Water Erosion Prediction Project (WEPP) model [@usda:1995], is climate. Even the simplest erosion models require climate inputs which are not always straightforward in their calculation. The complexity of these inputs dissuades potential users from creating their own inputs from observed data, which are almost always better than their simulated counterparts, especially when used to force erosion models for historical periods. For example, the Revised Universal Soil Loss Equation version 2 (RUSLE2) [@usda:2013] and WEPP are two of the leading soil erosion prediction models in the world today, but both still rely on climate inputs that are generated from outdated data, tools, or both.

It appears that the lack of sufficient software in this field has resulted in models being used with suboptimal climate data inputs, which can, if left unaddressed, stifle scientific discovery and advancement. RUSLE2, as currently applied commonly within the United States, relies on climate data from 1960-1999. This data is not only 20 years out of date, but the years utilized had fewer observation stations and the stations themselves used a mix of older technologies, some of which have documented quality issues that impact usability and reliability [@hollinger:2002; @usda:2013; @mcgehee:2018]. WEPP on the other hand, just had its climate database updated to the years 1974-2013 [@srivastava:2019], but those observed values are only used to create parameter files for CLImate GENerator (CLIGEN) [@nicks:1995] which is then used to create simulated climate files for WEPP. Some internal investigations at the National Soil Erosion Research Laboratory (NSERL) have identified the climate inputs to both models as a significant reason for differences in their predictions of soil loss under otherwise identical simulations.

In short, the erosion modeling community is in need of software that can at least shoulder most of the burden when preparing climate inputs for soil loss models. Therefore, we are proposing a WEPP CLImate File Formatter (WEPPCLIFF) program to begin addressing this need.

``WEPPCLIFF`` is an R-based command line tool which was originally designed to prepare climate inputs for WEPP that has been extended to perform other general functions such as quality checking, gap filling, and erosion index calculations (climate inputs for the USLE family of models). The program is also provided with extensive accompanying documentation which covers a range of topics including most notably: installation, syntax, input, output, and examples.

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