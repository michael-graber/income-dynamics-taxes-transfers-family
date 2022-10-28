/*----------------------------------------------
         Tables

This do file exports the data
for the tables shown in the paper as csv 
files
------------------------------------------------*/	 

* Baseline Model and Baseline Sample
use ./output/results, clear
keep if model  == "model_baseline"
keep if sample == "sample_baseline"
keep if cohort == 19251964
keep model sample age income education rho theta var_alpha sigma2 omega2 sterr_rho sterr_sigma2 sterr_omega2 sterr_theta sterr_var_alpha 

outsheet using ./output/stata/tables/TableBaseline.csv, comma replace

* Model with age-independent variances and Baseline Sample
use ./output/results, clear
keep if model  == "model_constant"
keep if sample == "sample_baseline"
keep if income == "market"
keep if cohort == 19251964
keep model sample age income education rho sigma2 omega2 theta var_alpha sterr_rho sterr_sigma2 sterr_omega2 sterr_theta sterr_var_alpha 

outsheet using ./output/stata/tables/TableAgeIndependent.csv, comma replace


* Model with heterogenous profiles and Baseline Sample
use ./output/results, clear
keep if model  == "model_profile"
keep if sample == "sample_baseline"
keep if income == "market"
keep if cohort == 19251964
keep model sample income education rho theta var_alpha var_beta rho_alpha_beta sterr_rho sterr_theta sterr_var_alpha sterr_var_beta sterr_rho_alpha_beta

outsheet using ./output/stata/tables/TableProfiles.csv, comma replace

 
