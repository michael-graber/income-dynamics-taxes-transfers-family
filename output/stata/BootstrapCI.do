/*================================================================================================
                Bootstrap Standard Errors

Description: This do file calculates bootstrapped standard errors		
		 
Author: Michael Graber
==================================================================================================*/

* Load results
use ./output/results, clear

* keep only estimates on bootstrap samples
keep if substr(sample,1,8) == "bssample"

* Calculate bootstrap CI for age-variant parameters
keep model education income sample age sigma2 omega2
bysort model education income age: egen CI_l_sigma2  = pctile(sigma2), p(2.5)
bysort model education income age: egen CI_u_sigma2  = pctile(sigma2), p(97.5)
bysort model education income age: egen CI_l_omega2  = pctile(omega2), p(2.5)
bysort model education income age: egen CI_u_omega2  = pctile(omega2), p(97.5)

keep model education income age CI*
duplicates drop model education income age, force

gen sample = "sample_baseline"       // bootstrap samples of baseline sample, need these two variables to match below
gen cohort = 19251964                // estimates are obtained by estimating the model after averaging the moments across cohorts

save ./output/CI, replace

* Match the CI to the file containing the results and bootstrap standard errors
use ./output/results, replace
merge 1:1 cohort model education income sample age using ./output/CI
drop _merge
save ./output/results, replace

exit

