/*===========================================================
     Variance of Transitory Shocks over the Life Cycle
		 
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

	graph twoway rarea CI_u_omega2 CI_l_omega2  age if education == "`skills'" & income == "market", sort color(gs14) ///
		  || rarea CI_u_omega2 CI_l_omega2  age if education == "`skills'" & income == "disposable", sort color(gs14) /// 
		  || rarea CI_u_omega2 CI_l_omega2  age if education == "`skills'" & income == "disposable(family)", sort color(gs14) ///
		  || (line omega2 age if education == "`skills'" & income == "market" ,lpattern(solid)) ///
		  || (line omega2 age if education == "`skills'" & income == "disposable",  lpattern(dash) ) ///
		  || (line omega2 age if education == "`skills'" & income == "disposable(family)",  lpattern(shortdash)), plotregion(lcolor(black)) graphregion(color(white)) bgcolor(white) ///
	xlabel(25 (5) 55) ///
	ylabel(0 (0.05) 0.2, nogrid) ///
	xtitle("age")  ///
	ytitle("var({&epsilon}{subscript:i,a})") ///
	legend(order( 4 "Market Income" 5 "Disposable Income" 6 "Family Disposable Income")) ///
	subtitle(`group') 
	graph export ./output/stata/figures/TransitoryShocks/model_baseline_sample_baseline_`skills'_Average.eps, replace
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

	graph twoway (line omega2 age if education == "`skills'" & income == "market") ///
		  || (line omega2 age if education == "`skills'" & income == "disposable") ///
		  || (line omega2 age if education == "`skills'" & income == "disposable(family)"), plotregion(lcolor(black)) graphregion(color(white)) bgcolor(white) ///
	xlabel(25 (5) 55) ///
	ylabel(0 (0.05) 0.2, nogrid) ///
	xtitle("age")  ///
	ytitle("var({&epsilon}{subscript:i,a})") ///
	legend(order( 1 "Market Income" 2 "Disposable Income" 3 "Family Disposable Income")) ///
	subtitle(`group') 
	graph export ./output/stata/figures/TransitoryShocks/model_baseline_sample_oneBasic_`skills'_Average.eps, replace
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

	graph twoway rarea CI_u_omega2 CI_l_omega2  age if education == "`skills'" & income == "market", sort color(gs14) ///
		  || rarea CI_u_omega2 CI_l_omega2  age if education == "`skills'" & income == "disposable", sort color(gs14) /// 
		  || rarea CI_u_omega2 CI_l_omega2  age if education == "`skills'" & income == "disposable(family)", sort color(gs14) ///
		  || (line omega2 age if education == "`skills'" & income == "market" ,  lpattern(solid)) ///
		  || (line omega2 age if education == "`skills'" & income == "disposable" ,  lpattern(dash)) ///
		  || (line omega2 age if education == "`skills'" & income == "disposable(family)",  lpattern(shortdash)), plotregion(lcolor(black)) graphregion(color(white)) bgcolor(white) ///
	xlabel(25 (5) 55) ///
	ylabel(0 (0.05) 0.2, nogrid) ///
	xtitle("age")  ///
	ytitle("var({&epsilon}{subscript:i,a})") ///
	legend(order( 4 "Market Income" 5 "Disposable Income" 6 "Family Disposable Income")) ///
	subtitle(`group') 
	graph export ./output/stata/figures/TransitoryShocks/model_profile_sample_baseline_`skills'_Average.eps, replace
}






*=======================================================================================================
* Dual Earner Model and Dual Earner Sample - Variance of Transitory Shocks
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

	graph twoway (line omega2 age        if model == "model_baseline" & education == "`skills'" & income == "disposable(family)") ///
		  || (line omega2 age        if model == "model_dual"     & education == "`skills'" & income == "disposable" ) ///
		  || (line omega2_spouse age if model == "model_dual"     & education == "`skills'" & income == "disposable"), plotregion(lcolor(black)) graphregion(color(white)) bgcolor(white) ///
	xlabel(25 (5) 55) ///
	ylabel(0 (0.05) 0.15, nogrid) ///
	xtitle("age")  ///
	ytitle("var({&epsilon}{subscript:i,a})") ///
	legend(order( 1 "Disposable Income (Family)" 2 "Disposable Income (Male)" 3 "Disposable Income (Spouse)")) ///
	subtitle(`group') 
	graph export ./output/stata/figures/TransitoryShocks/model_dual_sample_dual_`skills'_Average.eps, replace
}

*=======================================================================================================
* Dual Earner Model and Dual Earner Sample - Correlation of Transitory Shocks
*=======================================================================================================
use ./output/results, clear

keep if model  == "model_dual" 
keep if sample == "sample_dual"
keep if cohort == 19251964   // average cohort
drop if age > 58


* Correlation coefficient
gen rho_omega = cov_omega_male_spouse/sqrt(omega2*omega2_spouse)

foreach skills in pooled lowskill mediumskill highskill  {
	
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

	graph twoway (line rho_omega age  if education == "`skills'" & income == "market" & rho_omega < .2 & rho_omega > -.2) ///
		  || (line rho_omega age  if education == "`skills'" & income == "disposable" & rho_omega < .2 & rho_omega > -.2), plotregion(lcolor(black)) graphregion(color(white)) bgcolor(white) ///
	xlabel(25 (5) 55) ///
	ylabel(-.15 (0.05) .15, nogrid) ///
	xtitle("age")  ///
	ytitle({&rho}{subscript:a}) ///
	legend(order( 1 "Market Income" 2 "Disposable Income")) ///
	subtitle(`group') 
	graph export ./output/stata/figures/TransitoryShocks/CorrCoefficient_model_dual_sample_dual_`skills'_Average.eps, replace
}

*============================================================
* Model without MA structure and Baseline Sample
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
		
	graph twoway rarea CI_u_omega2 CI_l_omega2  age if education == "`skills'" & income == "market", sort color(gs14) ///
		  || rarea CI_u_omega2 CI_l_omega2  age if education == "`skills'" & income == "disposable", sort color(gs14) /// 
		  || rarea CI_u_omega2 CI_l_omega2  age if education == "`skills'" & income == "disposable(family)", sort color(gs14) ///
                  || (line omega2 age if education == "`skills'" & income == "market" ,  lpattern(solid)) ///
		  || (line omega2 age if education == "`skills'" & income == "disposable" ,  lpattern(dash)) ///
		  || (line omega2 age if education == "`skills'" & income == "disposable(family)" ,  lpattern(shortdash)), plotregion(lcolor(black)) graphregion(color(white)) bgcolor(white) ///
	xlabel(25 (5) 55) ///
	ylabel(0 (0.05) 0.2, nogrid) ///
	xtitle("age")  ///
	ytitle("var({&epsilon}{subscript:i,a})") ///
	legend(order( 4 "Market Income" 5 "Disposable Income" 6 "Family Disposable Income")) ///
	subtitle(`group') 
	graph export ./output/stata/figures/TransitoryShocks/model_noMA_sample_baseline_`skills'_Average.eps, replace
}

