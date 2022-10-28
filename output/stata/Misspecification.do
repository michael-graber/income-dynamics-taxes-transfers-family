*============================================================
* Misspecification Bias
*============================================================

* Load results
use ./output/results, clear

keep if cohort    == 19251964    // average cohort
keep if sample    == "sample_baseline" 
keep if income    == "market"
drop if education == "pooled"
keep model education age sigma2 omega2

gen diff_profile_sigma2 = .
gen diff_profile_omega2 = .
gen diff_constant_sigma2 = .
gen diff_constant_omega2 = .
gen diff_noMA_sigma2 = .
gen diff_noMA_omega2 = .

save temp, replace

* Calculate difference (baseline - profile)
keep if model == "model_baseline" | model == "model_profile"
sort age education model

replace diff_profile_sigma2 = sigma2[_n] - sigma2[_n+1] if education[_n] == education[_n+1] & age[_n] == age[_n+1]
replace diff_profile_omega2 = omega2[_n] - omega2[_n+1] if education[_n] == education[_n+1] & age[_n] == age[_n+1] 

append using temp

* Calculate difference (constant - baseline)
keep if model == "model_baseline" | model == "model_constant"
sort age education model
drop if model == "model_baseline" & diff_profile_sigma2 == .

replace diff_constant_sigma2 = -(sigma2[_n] - sigma2[_n+1]) if education[_n] == education[_n+1] & age[_n] == age[_n+1]
replace diff_constant_omega2 = -(omega2[_n] - omega2[_n+1]) if education[_n] == education[_n+1] & age[_n] == age[_n+1] 

append using temp

* Calculate difference (noMA - baseline)
keep if model == "model_baseline" | model == "model_noMA"
sort age education model
drop if model == "model_baseline" & diff_profile_sigma2 == .

replace diff_noMA_sigma2 = -(sigma2[_n] - sigma2[_n+1]) if education[_n] == education[_n+1] & age[_n] == age[_n+1]
replace diff_noMA_omega2 = -(omega2[_n] - omega2[_n+1]) if education[_n] == education[_n+1] & age[_n] == age[_n+1] 

* Plots

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

	graph twoway (line diff_profile_omega2  age if education == "`skills'" & age <= 58) ///
		  || (line diff_constant_omega2 age if education == "`skills'" & age <= 58) ///
		  || (line diff_noMA_omega2     age if education == "`skills'" & age <=58),  plotregion(lcolor(black)) graphregion(color(white)) bgcolor(white) ///
	xlabel(25 (5) 55) ///
	ylabel(-0.15 (0.05) 0.15, nogrid) ///
	xtitle("age")  ///
	ytitle("{&Delta}var({&epsilon}{subscript:i,a})") ///
	legend(order( 1 "Homogeneous Profiles" 2 "Age-invariant Variances" 3 "No MA")) ///
	subtitle(`group') 
	graph export ./output/stata/figures/TransitoryShocks/Bias_market_`skills'_Average.eps, replace
}

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

	graph twoway (line diff_profile_sigma2  age if education == "`skills'" & age <= 58) ///
		  || (line diff_constant_sigma2 age if education == "`skills'" & age <= 58) ///
		  || (line diff_noMA_sigma2     age if education == "`skills'" & age <=58),  plotregion(lcolor(black)) graphregion(color(white)) bgcolor(white) ///
	xlabel(25 (5) 55) ///
	ylabel(-0.2 (0.05) 0.2, nogrid) ///
	xtitle("age")  ///
	ytitle("{&Delta}var(u{subscript:i,a})") ///
	legend(order( 1 "Homogeneous Profiles" 2 "Age-invariant Variances" 3 "No MA")) ///
	subtitle(`group') 
	graph export ./output/stata/figures/PermanentShocks/Bias_market_`skills'_Average.eps, replace
}
