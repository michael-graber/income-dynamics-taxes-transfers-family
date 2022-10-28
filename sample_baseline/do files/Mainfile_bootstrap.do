/*----------------------------------------------------------------------------------------------

      Masterfile for bootstrap: Income Dynamics over the Life-Cycle - Baseline Sample
      
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
cd "/ssb/ovibos/a1/swp/mga/wk24/BlundellGraberMogstad_JPub/December13/sample_baseline"

* Graphics scheme
set scheme s2mono

* Load data

* full sample
use /ssb/ovibos/a1/swp/mga/wk24/incdata/incpro_sample_long_new, clear 

* 1-Percent Subsample for testing purpose
*use /ssb/ovibos/a1/swp/mga/wk24/incdata/incpro_1perc_sample_long, clear

* Family & Cohort
do "./do files/bootstrap/FamilyCohortEducation.do"

* Sample Selection
do "./do files/bootstrap/Selection.do"

save main_sample, replace

* The following files can be executed separately. Given the main_sample, we will draw a bootstrap sample
* clustered by panel (i.e. person-identifier) and stratified by cohorts. We then run the first stage
* regressions and then calculate the Autocovariances of the Quasi-difference. We do this in each of the following 70 files,
* so to obtain 70 bootstrapped moments overall.

do "./do files/bootstrap/bootstrap_1.do"
do "./do files/bootstrap/bootstrap_2.do"
do "./do files/bootstrap/bootstrap_3.do"
do "./do files/bootstrap/bootstrap_4.do"
do "./do files/bootstrap/bootstrap_5.do"
do "./do files/bootstrap/bootstrap_6.do"
do "./do files/bootstrap/bootstrap_7.do"
do "./do files/bootstrap/bootstrap_8.do"
do "./do files/bootstrap/bootstrap_9.do"
do "./do files/bootstrap/bootstrap_10.do"

do "./do files/bootstrap/bootstrap_11.do"
do "./do files/bootstrap/bootstrap_12.do"
do "./do files/bootstrap/bootstrap_13.do"
do "./do files/bootstrap/bootstrap_14.do"
do "./do files/bootstrap/bootstrap_15.do"
do "./do files/bootstrap/bootstrap_16.do"
do "./do files/bootstrap/bootstrap_17.do"
do "./do files/bootstrap/bootstrap_18.do"
do "./do files/bootstrap/bootstrap_19.do"
do "./do files/bootstrap/bootstrap_20.do"

do "./do files/bootstrap/bootstrap_21.do"
do "./do files/bootstrap/bootstrap_22.do"
do "./do files/bootstrap/bootstrap_23.do"
do "./do files/bootstrap/bootstrap_24.do"
do "./do files/bootstrap/bootstrap_25.do"
do "./do files/bootstrap/bootstrap_26.do"
do "./do files/bootstrap/bootstrap_27.do"
do "./do files/bootstrap/bootstrap_28.do"
do "./do files/bootstrap/bootstrap_29.do"
do "./do files/bootstrap/bootstrap_30.do"

do "./do files/bootstrap/bootstrap_31.do"
do "./do files/bootstrap/bootstrap_32.do"
do "./do files/bootstrap/bootstrap_33.do"
do "./do files/bootstrap/bootstrap_34.do"
do "./do files/bootstrap/bootstrap_35.do"
do "./do files/bootstrap/bootstrap_36.do"
do "./do files/bootstrap/bootstrap_37.do"
do "./do files/bootstrap/bootstrap_38.do"
do "./do files/bootstrap/bootstrap_39.do"
do "./do files/bootstrap/bootstrap_40.do"

do "./do files/bootstrap/bootstrap_41.do"
do "./do files/bootstrap/bootstrap_42.do"
do "./do files/bootstrap/bootstrap_43.do"
do "./do files/bootstrap/bootstrap_44.do"
do "./do files/bootstrap/bootstrap_45.do"
do "./do files/bootstrap/bootstrap_46.do"
do "./do files/bootstrap/bootstrap_47.do"
do "./do files/bootstrap/bootstrap_48.do"
do "./do files/bootstrap/bootstrap_49.do"
do "./do files/bootstrap/bootstrap_50.do"

do "./do files/bootstrap/bootstrap_51.do"
do "./do files/bootstrap/bootstrap_52.do"
do "./do files/bootstrap/bootstrap_53.do"
do "./do files/bootstrap/bootstrap_54.do"
do "./do files/bootstrap/bootstrap_55.do"
do "./do files/bootstrap/bootstrap_56.do"
do "./do files/bootstrap/bootstrap_57.do"
do "./do files/bootstrap/bootstrap_58.do"
do "./do files/bootstrap/bootstrap_59.do"
do "./do files/bootstrap/bootstrap_60.do"

do "./do files/bootstrap/bootstrap_61.do"
do "./do files/bootstrap/bootstrap_62.do"
do "./do files/bootstrap/bootstrap_63.do"
do "./do files/bootstrap/bootstrap_64.do"
do "./do files/bootstrap/bootstrap_65.do"
do "./do files/bootstrap/bootstrap_66.do"
do "./do files/bootstrap/bootstrap_67.do"
do "./do files/bootstrap/bootstrap_68.do"
do "./do files/bootstrap/bootstrap_69.do"
do "./do files/bootstrap/bootstrap_70.do"

exit
