/*===========================================================
                Figures
		 
		 Author: Michael Graber
		 Date: January 2014
============================================================*/
clear all
set more off

cd "/data/uctpmgr/BitBucket/BlundellGraberMogstad"

* Graphics scheme
set scheme s2mono

* Import all .csv files that contain the results for all models, all education groups and all samples  
* and save them in file "results" in the present working directory
do ./output/stata/ImportResults.do

* Calculate bootstrapped standard errors
do ./output/stata/BootstrapStandardErrors.do

* Calculate bootstrapped CI
do ./output/stata/BootstrapCI.do

* Export Tables
do ./output/stata/Tables.do

* Tax Rates
do ./output/stata/AverageTaxRates.do
do ./output/stata/MargTaxRates.do

* Sample Sizes
do ./output/stata/SampleSizes.do

* Variance of Permanent Shocks:  Life Cycle Profiles and absolute differences between models and samples, and between family and individual income for the baseline sample
do ./output/stata/VarPermShocks.do	
	
* Variance of Transitory Shocks: Life Cycle Profiles and absolute differences between models and samples
do ./output/stata/VarTransShocks.do

* Heterogenous Profiles:
do ./output/stata/HeterogenousProfiles.do

* Business Cycle Effects: Gap in GDP and Variance of Permanent Shocks: Cohort 1950 and 1962
do ./output/stata/BusinessCycle.do

* Tax Reform Effects: 2001
do ./output/stata/TaxReform.do

* Misspecification
do ./output/stata/Misspecification.do

* Model Fit
*do ./output/stata/ModelFit.do

exit





