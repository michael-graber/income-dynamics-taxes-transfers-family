/*===========================================================
     Variance of Permanent Shocks over the Life Cycle
		 
		 Author: Michael Graber

============================================================*/

*============================================================
* Baseline Model and Baseline Sample
*============================================================
* Load results
use ./output/results, clear

keep if model  == "model_baseline" 
keep if sample == "sample_baseline"
keep if cohort == 19251964   // average cohort

drop if age > 58


foreach skills in pooled lowskill mediumskill highskill {
	
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
	graph twoway rarea CI_u_sigma2 CI_l_sigma2 age if education == "`skills'" & income == "market", sort color(gs14) ///
		  || rarea CI_u_sigma2 CI_l_sigma2 age if education == "`skills'" & income == "disposable", sort color(gs14) /// 
		  || rarea CI_u_sigma2 CI_l_sigma2 age if education == "`skills'" & income == "disposable(family)", sort color(gs14) ///
	          || (line sigma2 age if education == "`skills'" & income == "market", lpattern(solid)) ///
		  || (line sigma2 age if education == "`skills'" & income == "disposable", lpattern(dash)) ///
		  || (line sigma2 age if education == "`skills'" & income == "disposable(family)", lpattern(shortdash)),plotregion(lcolor(black)) graphregion(color(white)) bgcolor(white) ///
	xlabel(25 (5) 55) ///
	ylabel(0 (0.05) 0.3, nogrid) ///
	xtitle("age")  ///
	ytitle("var(u{subscript:i,a})") ///
	legend(order( 4 "Market Income" 5 "Disposable Income" 6 " Family Disposable Income")) ///
	subtitle(`group') 
	graph export ./output/stata/figures/PermanentShocks/model_baseline_sample_baseline_`skills'_Average.eps, replace
}


	
*============================================================
* Baseline Model and One Basic Sample
*============================================================
* Load results
use ./output/results, clear

keep if model  == "model_baseline" 
keep if sample == "sample_oneBasic"
keep if cohort == 19251964   // average cohort
drop if age > 58



foreach skills in pooled lowskill mediumskill highskill {
	
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

	graph twoway (line sigma2 age if education == "`skills'" & income == "market") ///
		  || (line sigma2 age if education == "`skills'" & income == "disposable") ///
		  || (line sigma2 age if education == "`skills'" & income == "disposable(family)"),plotregion(lcolor(black)) graphregion(color(white)) bgcolor(white) ///
	xlabel(25 (5) 55) ///
	ylabel(0 (0.05) 0.3, nogrid) ///
	xtitle("age")  ///
	ytitle("var(u{subscript:i,a})") ///
	legend(order( 1 "Market Income" 2 "Disposable Income" 3 "Family Disposable Income")) ///
	subtitle(`group') 
	graph export ./output/stata/figures/PermanentShocks/model_baseline_sample_oneBasic_`skills'_Average.eps, replace
}

*============================================================
* Heterogenous Profiles Model and Baseline Sample
*============================================================
* Load results
use ./output/results, clear

keep if model  == "model_profile" 
keep if sample == "sample_baseline"
keep if cohort == 19251964   // average cohort
drop if age > 58



foreach skills in pooled lowskill mediumskill highskill{
	
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

	graph twoway rarea CI_u_sigma2 CI_l_sigma2 age if education == "`skills'" & income == "market", sort color(gs14) ///
		  || rarea CI_u_sigma2 CI_l_sigma2 age if education == "`skills'" & income == "disposable", sort color(gs14) /// 
		  || rarea CI_u_sigma2 CI_l_sigma2 age if education == "`skills'" & income == "disposable(family)", sort color(gs14) ///
	          || (line sigma2 age if education == "`skills'" & income == "market", lpattern(solid)) ///
		  || (line sigma2 age if education == "`skills'" & income == "disposable", lpattern(dash)) ///
		  || (line sigma2 age if education == "`skills'" & income == "disposable(family)", lpattern(shortdash)),plotregion(lcolor(black)) graphregion(color(white)) bgcolor(white) ///
	xlabel(25 (5) 55) ///
	ylabel(0 (0.05) 0.3, nogrid) ///
	xtitle("age")  ///
	ytitle("var(u{subscript:i,a})") ///
	legend(order( 4 "Market Income" 5 "Disposable Income" 6 "Family Disposable Income")) ///
	subtitle(`group') 
	graph export ./output/stata/figures/PermanentShocks/model_profile_sample_baseline_`skills'_Average.eps, replace
}


*=======================================================================================================
* Dual Earner Model and Dual Earner Sample - Variance of Permanent Shocks
*=======================================================================================================
* Load results
use ./output/results, clear

keep if model  == "model_dual" || model == "model_baseline"
keep if sample == "sample_dual"
keep if cohort == 19251964   // average cohort
drop if age > 58

foreach skills in pooled lowskill mediumskill highskill {
	
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

	graph twoway (line sigma2 age        if model == "model_baseline" & education == "`skills'" & income == "disposable(family)") ///
		  || (line sigma2 age        if model == "model_dual"     & education == "`skills'" & income == "disposable") ///
		  || (line sigma2_spouse age if model == "model_dual"     & education == "`skills'" & income == "disposable"), plotregion(lcolor(black)) graphregion(color(white)) bgcolor(white) ///
	xlabel(25 (5) 55) ///
	ylabel(0 (0.05) 0.3, nogrid) ///
	xtitle("age")  ///
	ytitle("var(u{subscript:i,a})") ///
	legend(order( 1 "Family Disposable Income" 2 "Disposable Income" 3 " Spouse Disposable Income")) ///
	subtitle(`group') 
	graph export ./output/stata/figures/PermanentShocks/model_dual_sample_dual_`skills'_Average.eps, replace
}

*=======================================================================================================
* Dual Earner Model and Dual Earner Sample - Correlation of Permanent Shocks
*=======================================================================================================
use ./output/results, clear

keep if model  == "model_dual" 
keep if sample == "sample_dual"
keep if cohort == 19251964   // average cohort
drop if age > 58

* Correlation coefficient
gen rho_sigma = cov_sigma_male_spouse/sqrt(sigma2*sigma2_spouse)

foreach skills in pooled lowskill mediumskill highskill {
	
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

	graph twoway (line rho_sigma age  if education == "`skills'" & income == "market") ///
		  || (line rho_sigma age  if education == "`skills'" & income == "disposable"),plotregion(lcolor(black)) graphregion(color(white)) bgcolor(white) ///
	xlabel(25 (5) 55) ///
	ylabel(-.15 (0.05) .15, nogrid) ///
	xtitle("age")  ///
	ytitle({&rho}{subscript:a}) ///
	legend(order( 1 "Market Income" 2 "Disposable Income")) ///
	subtitle(`group') 
	graph export ./output/stata/figures/PermanentShocks/CorrCoefficient_model_dual_sample_dual_`skills'_Average.eps, replace
}


*============================================================
*  Model without MA and Baseline Sample
*============================================================
use ./output/results, clear

keep if model  == "model_noMA" 
keep if sample == "sample_baseline"
keep if cohort == 19251964   // average cohort
drop if age > 58


foreach skills in pooled lowskill mediumskill highskill {
	
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

	graph twoway rarea CI_u_sigma2 CI_l_sigma2 age if education == "`skills'" & income == "market", sort color(gs14) ///
		  || rarea CI_u_sigma2 CI_l_sigma2 age if education == "`skills'" & income == "disposable", sort color(gs14) /// 
		  || rarea CI_u_sigma2 CI_l_sigma2 age if education == "`skills'" & income == "disposable(family)", sort color(gs14) ///
	          || (line sigma2 age if education == "`skills'" & income == "market", lpattern(solid)) ///
		  || (line sigma2 age if education == "`skills'" & income == "disposable", lpattern(dash)) ///
		  || (line sigma2 age if education == "`skills'" & income == "disposable(family)", lpattern(shortdash)),plotregion(lcolor(black)) graphregion(color(white)) bgcolor(white) ///
	xlabel(25 (5) 55) ///
	ylabel(0 (0.05) 0.3, nogrid) ///
	xtitle("age")  ///
	ytitle("var(u{subscript:i,a})") ///
	legend(order( 4 "Market Income" 5 "Disposable Income" 6 "Family Disposable Income")) ///
	subtitle(`group') 
	graph export ./output/stata/figures/PermanentShocks/model_noMA_sample_baseline_`skills'_Average.eps, replace
}




