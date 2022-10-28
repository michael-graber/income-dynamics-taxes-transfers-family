/*===========================================================
       Heterogenous Profiles
		 
		 Author: Michael Graber

============================================================*/
* Import Log-Income Age Profiles of baseline samples and save them in Stata format
insheet using ./sample_baseline/moments/AgeProfiles.csv, clear

* recode and rename variables
rename education education_old
rename imarket_age profile_market
rename idisp_age profile_disposable
rename fdisp_age profile_familydisposable
drop fmarket_age
gen education = ""
replace education = "lowskill"    if education_old == 1
replace education = "mediumskill" if education_old == 2
replace education = "highskill"   if education_old == 3
drop education_old
drop if age == 25
drop if age > 58
save ./sample_baseline/moments/AgeProfiles, replace

*============================================================
* Model with Heterogenous profiles and Baseline Sample
*============================================================		
* Load results for the average cohort
use ./output/results, clear
drop if age > 58

keep if model     == "model_profile" 
keep if sample    == "sample_baseline"
keep if cohort    == 19251964
drop if education == "pooled"

* Add age profiles to the data
merge m:1 age education using ./sample_baseline/moments/AgeProfiles
keep if _merge == 3

* Calculate profiles
forvalues lambda = -2(1)2 {
	local i = `lambda' + 3
	gen profile_market_`i' = profile_market + `lambda' * sqrt(var_beta) * (age - 25)
	gen profile_disposable_`i' = profile_disposable + `lambda' * sqrt(var_beta) * (age - 25)
	gen profile_familydisposable_`i' = profile_familydisposable + `lambda' * sqrt(var_beta) * (age - 25)
}

sort age

foreach skills in lowskill mediumskill highskill  {
	
	if `"`skills'"' == "pooled" {
			local group = "Pooled" 
		}
		if `"`skills'"' == "lowskill" {
			local group = "Low-Skill" 
		}
		if `"`skills'"' == "mediumskill" {
			local group = "Medium-Skill" 
		}
		if `"`skills'"' == "highskill" {
			local group = "High-Skill" 
		}
	
	* Market Income
	graph twoway (line profile_market_1 age if income == "market" & education == "`skills'" & age <= 58) ///
		  || (line profile_market_2 age if income == "market" & education == "`skills'" & age <= 58) ///
		  || (line profile_market_3 age if income == "market" & education == "`skills'" & age <= 58) ///
		  || (line profile_market_4 age if income == "market" & education == "`skills'" & age <= 58) ///
		  || (line profile_market_5 age if income == "market" & education == "`skills'" & age <= 58),  plotregion(lcolor(black)) graphregion(color(white)) bgcolor(white) ///
	xlabel(25 (5) 55) ///
	ylabel(11 (1) 14, nogrid) ///
	xtitle("age")  ///
	ytitle("log-income") ///
	legend(off)  ///
	subtitle(`group') 
	graph export ./output/stata/figures/Profiles/model_profile_sample_baseline_`skills'_market_Average.eps, replace
	
	/*
	* Disposable Income
	graph twoway (line profile_disposable_1 age if income == "disposable" & education == "`skills'" & age <= 57) ///
		  || (line profile_disposable_2 age if income == "disposable" & education == "`skills'" & age <= 57) ///
		  || (line profile_disposable_3 age if income == "disposable" & education == "`skills'" & age <= 57) ///
		  || (line profile_disposable_4 age if income == "disposable" & education == "`skills'" & age <= 57) ///
		  || (line profile_disposable_5 age if income == "disposable" & education == "`skills'" & age <= 57),  plotregion(lcolor(black)) graphregion(color(white)) bgcolor(white) ///
	xlabel(25 (5) 57) ///
	ylabel(9.5 (1) 14, nogrid) ///
	xtitle("age")  ///
	ytitle("log-income") ///
	legend(off)  ///
	subtitle(`group') 
	graph export ./output/stata_separateCohorts/figures/Profiles/model_profile_sample_baseline_`skills'_disposable_Average.eps, replace
	
	* Disposable Family Income
	graph twoway (line profile_familydisposable_1 age if income == "disposable(family)" & education == "`skills'" & age <= 57) ///
		  || (line profile_familydisposable_2 age if income == "disposable(family)" & education == "`skills'" & age <= 57) ///
		  || (line profile_familydisposable_3 age if income == "disposable(family)" & education == "`skills'" & age <= 57) ///
		  || (line profile_familydisposable_4 age if income == "disposable(family)" & education == "`skills'" & age <= 57) ///
		  || (line profile_familydisposable_5 age if income == "disposable(family)" & education == "`skills'" & age <= 57),  plotregion(lcolor(black)) graphregion(color(white)) bgcolor(white) ///
	xlabel(25 (5) 57) ///
	ylabel(9.5 (1) 14, nogrid) ///
	xtitle("age")  ///
	ytitle("log-income") ///
	legend(off)  ///
	subtitle(`group') 
	graph export ./output/stata_separateCohorts/figures/Profiles/model_profile_sample_baseline_`skills'_disposablefamily_Average.eps, replace
	*/
}
	
