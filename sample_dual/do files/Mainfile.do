/*----------------------------------------------------------------------------------------------

      Masterfile: Income Dynamics over the Life-Cycle - Dual Earner Sample
      
      Author: Michael Graber
      Date  : November 2013
      
      NOTE: 
      personal .ado files directory: /ssb/ovibos/h1/mga/ado/ 
      ado files used in this program: tddens.ado , mat2txt2.ado tsspell.ado 
-----------------------------------------------------------------------------------------------*/
clear all
capture log close
version 12
set more off

* Working Directory
cd "/ssb/ovibos/a1/swp/mga/wk24/BlundellGraberMogstad_JPub/November13/sample_dual"

* Graphics scheme
set scheme s2mono

* Load data

* full sample
use /ssb/ovibos/a1/swp/mga/wk24/incdata/incpro_sample_long_new, clear 

* 1-Percent Subsample for testing purpose
*use /ssb/ovibos/a1/swp/mga/wk24/incdata/incpro_1perc_sample_long, clear

* Family & Cohort
do "./do files/FamilyCohortEducation.do"

* Sample Selection
do "./do files/Selection.do"

* Residual Income
do "./do files/IncomeRegressions.do"

* Sample Size Calculations
do "./do files/SampleSize.do"

* Age Profiles
do "./do files/AgeProfiles.do"

* Quasi-Differences on a grid of rho, each part can be executed separately:

do "./do files/QD_part1.do"
do "./do files/QD_part2.do"
do "./do files/QD_part3.do"
do "./do files/QD_part4.do"
do "./do files/QD_part5.do"
do "./do files/QD_part6.do"

 
exit
