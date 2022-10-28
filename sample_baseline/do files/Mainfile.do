/*----------------------------------------------------------------------------------------------

      Masterfile: Income Dynamics over the Life-Cycle - Baseline Sample
      
      Author: Michael Graber
      Date  : December 2013
      
      NOTE: 
      personal .ado files directory: /ssb/ovibos/h1/mga/ado/ 
      ado files used in this program: mat2txt2.ado tsspell.ado 
-----------------------------------------------------------------------------------------------*/
clear all
capture log close
version 12
set more off

* Working Directory
cd "/ssb/ovibos/a1/swp/mga/wk24/BlundellGraberMogstad_JPub/December13/sample_baseline"

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

* Auto-Covariances of Residual Log-Income
do "./do files/AutoCovariance.do"  

* Sample Size Calculations
do "./do files/SampleSize.do"

* Age Profiles
do "./do files/AgeProfiles.do"

* Late - vs. early exits: Earnings levels and growth
do "./do files/LabourMarketExit.do"

* Calculate the Autocovariance matrix of the Quasi-Differences on a grid of rho \in [0.75,0.76,...,1]
do "./do files/AutoCovarianceQuasiDifference"

exit
