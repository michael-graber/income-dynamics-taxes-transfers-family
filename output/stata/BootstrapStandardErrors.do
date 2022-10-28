/*================================================================================================
                Bootstrap Standard Errors

Description: This do file calculates bootstrapped standard errors of age-invariant parameters		
		 
Author: Michael Graber
==================================================================================================*/

* ------- Bootstrap Standard Errors Age-Invariant Parameters -------------------------------------*

* Load results
use ./output/results, clear

* keep only estimates on bootstrap samples 
keep if substr(sample,1,8) == "bssample"
duplicates drop model education income sample rho theta var_alpha var_beta rho_alpha_beta, force  // drop age dimension

bysort model education income    : egen sterr_rho            = sd(rho)
bysort model education income    : egen sterr_theta          = sd(theta)
bysort model education income    : egen sterr_var_alpha      = sd(var_alpha)
bysort model education income    : egen sterr_var_beta       = sd(var_beta)
bysort model education income    : egen sterr_rho_alpha_beta = sd(rho_alpha_beta)

* Collapse dataset to include only the standard-errors for each model, education and income
keep model education income sterr*
duplicates drop model education income, force 

gen sample = "sample_baseline"       // bootstrap samples of baseline sample, need these two variables to match below
gen cohort = 19251964                // estimates are obtained by estimating the model after averaging the moments across cohorts

save ./output/standarderrors_age_invariant, replace

* Match the standard errors to the file containing the results
use ./output/results, replace
merge m:1 cohort model education income sample using ./output/standarderrors_age_invariant
drop _merge
save ./output/results, replace


* ------- Bootstrap Standard Errors Age-Variant Parameters -------------------------------------*

* Load results
use ./output/results, clear

* keep only estimates on bootstrap samples 
keep if substr(sample,1,8) == "bssample"

bysort model education income age    : egen sterr_sigma2       = sd(sigma2)
bysort model education income age    : egen sterr_omega2       = sd(omega2)


* Collapse dataset to include only the standard-errors for each model, education, income and age
keep model education income age sterr*
duplicates drop model education income age sterr* , force
gen sample = "sample_baseline"       // bootstrap samples of baseline sample, need these two variables to match below
gen cohort = 19251964                // estimates are obtained by estimating the model after averaging the moments across cohorts

save ./output/standarderrors_age_variant, replace

* Match the standard errors to the file containing the results
use ./output/results, replace
merge 1:1 cohort model education income sample age using ./output/standarderrors_age_variant
drop _merge
save ./output/results, replace

exit

