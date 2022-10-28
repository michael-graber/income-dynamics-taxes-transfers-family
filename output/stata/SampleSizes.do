/*=======================================================================================================
                Sample Sizes
		 
		 Author: Michael Graber
		 
========================================================================================================*/

* Number of observations by age of people born 
* between 1925 and 1964 who are between age 25 and 60 using
* data from 1967 to 2006 - by education
*--------------------------------------------------------------------------------------------------------
insheet using ./sample_baseline/moments/Total_Observations_19251964_age_education.csv, clear
* Create age vector from 25 onwards
drop v1
gen age = _n + 24
* Rename variables
rename c1 LowSkill
rename c2 MediumSkill
rename c3 HighSkill
* Total
gen Pooled = LowSkill + MediumSkill + HighSkill
* sample Indicator
gen sample = "total"
save ./sample_baseline/moments/Total_Observations_19251964_age_education, replace

	
*Number of observations in the baseline sample by age and education
*--------------------------------------------------------------------------------------------------------
insheet using ./sample_baseline/moments/observations_age_education.csv, clear
* Create age vector from 25 onwards 
drop v1
gen age = _n + 24
* Rename variables
rename c1 LowSkill
rename c2 MediumSkill
rename c3 HighSkill
* Total
rename v5 Pooled
replace Pooled = LowSkill + MediumSkill + HighSkill
* sample Indicator
gen sample = "sample_baseline"
save ./sample_baseline/moments/observations_age_education, replace


* ================= Figures  ==============================================================================

use          ./sample_baseline/moments/observations_age_education, clear
append using ./sample_baseline/moments/Total_Observations_19251964_age_education

* Low Skilled
graph twoway (line LowSkill age if sample == "total") ///
||(line LowSkill age if sample == "sample_baseline"), plotregion(lcolor(black)) graphregion(color(white)) bgcolor(white) ///
xlabel(25 (5) 60) ///
ylabel(0 (250000) 500000, nogrid) ///
xtitle("age")  ///
ytitle(Sample Size) ///
legend(order( 1 "Total" 2 "Baseline Sample")) ///
subtitle("Low-Skill") 
graph export ./output/stata/figures/SampleSize/ObsAge/LowSkill.eps, replace

* Medium Skilled
graph twoway (line MediumSkill age if sample == "total") ///
||(line MediumSkill age if sample == "sample_baseline"), plotregion(lcolor(black)) graphregion(color(white)) bgcolor(white) ///
xlabel(25 (5) 60) ///
ylabel(0 (250000) 500000, nogrid) ///
xtitle("age")  ///
ytitle(Sample Size) ///
legend(order( 1 "Total" 2 "Baseline Sample")) ///
subtitle("Medium-Skill") 
graph export ./output/stata/figures/SampleSize/ObsAge/MediumSkill.eps, replace

* High Skilled
graph twoway (line HighSkill age if sample == "total") ///
||(line HighSkill age if sample == "sample_baseline"), plotregion(lcolor(black)) graphregion(color(white)) bgcolor(white) ///
xlabel(25 (5) 60) ///
ylabel(0 (250000) 500000, nogrid) ///
xtitle("age")  ///
ytitle(Sample Size) ///
legend(order( 1 "Total" 2 "Baseline Sample")) ///
subtitle("High-Skill") 
graph export ./output/stata/figures/SampleSize/ObsAge/HighSkill.eps, replace

	
	
*Number of individuals by cohort
*--------------------------------------------------------------------
insheet using ./sample_baseline/moments/samplesize_cohort.csv, clear
* Create birth-year vector from 1925 to 1964 
drop v1
gen year = _n + 1924
* Rename variables
rename c1 Individuals
* sample Indicator
gen sample = "sample_baseline"
save ./sample_baseline/moments/samplesize_cohort, replace
	
*Number of individuals by skill group
*--------------------------------------------------------------------
insheet using ./sample_baseline/moments/samplesize_education.csv, clear 
drop v1 v3
*Rearrange data/ reshape for practical purposes
gen MediumSkill = c1[2]
gen HighSkill   = c1[3]
* Rename variable
rename c1 LowSkill
drop if _n > 1
* Total
gen Pooled = LowSkill + MediumSkill + HighSkill
* Percentage
gen LowSkill_perc = LowSkill/Pooled
gen MediumSkill_perc = MediumSkill/Pooled
gen HighSkill_perc = HighSkill/Pooled
* sample Indicator
gen sample = "sample_baseline"
save ./sample_baseline/moments/samplesize_education, replace
	
	
* ================= Total Number of individuals ===============================================
log using ./output/stata/figures/SampleSize/N_individuals, replace
log off

use ./sample_baseline/moments/samplesize_education, clear

log on
* The total number of individuals is:
bysort sample: list Pooled

* The Percentage of Low-Skilled Individuals is 
bysort sample: list LowSkill_perc

* The Percentage of Medium-Skilled Individuals is 
bysort sample: list MediumSkill_perc

* The Percentage of High-Skilled Individuals is 
bysort sample: list HighSkill_perc

log off

use ./sample_baseline/moments/samplesize_cohort, clear
log on
* Average Number of Individuals per Cohort: (mean)
bysort sample: summarize Individuals
log off
log close


exit
