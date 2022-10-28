/*---------------------------------------------------------------------------------
        File:   Quasi-Difference Cohort
	Author: Michael Graber
	Date:   August 2012

----------------------------------------------------------------------------------*/

set more off

* Cohort
local c 1935
		
* Load dataset after income regressions
use DualEarner_sample, clear
		
* keep only observations of a particular cohort
keep if byear == `c'
		
* Declare as Panel data
sort lnr age
xtset lnr age
		
* Save temporary cohort-dataset
save temp_`c', replace	


forvalues rho_male = 750(10)1000{
	forvalues rho_spouse = 750(10)1000{
		
		* Load cohort dataset
		clear
		use temp_`c'
		
		*----------------------------------------------------------------------------------
		* Compute VARIANCE COVARIANCE MATRIX for COHORT c independent of education level //
		*----------------------------------------------------------------------------------
		
		* Compute Quasi-Difference for all income measures given a value for rho_male 
		foreach income of varlist ind_market_resid ind_disp_resid{
			gen D`rho_male'_`income' = `income' - (`rho_male'/1000) * L.`income'
		}
		
		
		* Compute Quasi-Difference for all income measures given a value for rho_spouse 
		foreach income of varlist w_market_resid w_disp_resid{
			gen D`rho_spouse'_`income' = `income' - (`rho_spouse'/1000) * L.`income'
		}
		
		
		* drop first observation 
		quietly summarize age
		drop if age == r(min)
		
		local age_min=r(min)+1
		local age_max=r(max)
			
		* Reshape to wide format
		keep lnr age D* 
		reshape wide D*, i(lnr) j(age) 			
		
		*----------------------- Male Market Income ----------------------------------------
		
		* Autocovariance
		matrix C= J(`age_max',`age_max',.)
		
		forvalues i = `age_min'(1)`age_max'{
			forvalues j = `age_min'(1)`i'{
				capture corr D`rho_male'_ind_market_resid`i' D`rho_male'_ind_market_resid`j', covariance
				if _rc == 0 {
					matrix C[`i',`j'] = r(cov_12)
					matrix C[`j',`i'] = r(cov_12)
					}
				else{
					matrix C[`i',`j'] = .
					matrix C[`j',`i'] = .
					}
				matrix C[`i',`i'] = r(Var_1)
				}
			}
			matrix list C, format(%6.4f) noheader
			
			* Export matrix as csv
			mat2txt2 C using ./moments/cohort`c'/_all/Male_Market`rho_male'.csv, replace
			
		*----------------------- Spouse Market Income ----------------------------------------
		
		* Autocovariance
		matrix C= J(`age_max',`age_max',.)
		
		forvalues i = `age_min'(1)`age_max'{
			forvalues j = `age_min'(1)`i'{
				capture corr D`rho_spouse'_w_market_resid`i' D`rho_spouse'_w_market_resid`j', covariance
				if _rc == 0 {
					matrix C[`i',`j'] = r(cov_12)
					matrix C[`j',`i'] = r(cov_12)
					}
				else{
					matrix C[`i',`j'] = .
					matrix C[`j',`i'] = .
					}
				matrix C[`i',`i'] = r(Var_1)
				}
			}
			matrix list C, format(%6.4f) noheader
			
			* Export matrix as csv
			mat2txt2 C using ./moments/cohort`c'/_all/Spouse_Market`rho_spouse'.csv, replace
			
		*----------------------- Male - Spouse Market Income ----------------------------------------
		
		* Note: Cross-Covariance matrix! Columns: Wife, Rows: Male 
		matrix C= J(`age_max',`age_max',.)
		
		forvalues i = `age_min'(1)`age_max'{
			forvalues j = `age_min'(1)`age_max'{
				capture corr D`rho_male'_ind_market_resid`i' D`rho_spouse'_w_market_resid`j', covariance
				if _rc == 0 {
					matrix C[`i',`j'] = r(cov_12)
					}
				}
			}
			matrix list C, format(%6.4f) noheader
			
			* Export matrix as csv
			mat2txt2 C using ./moments/cohort`c'/_all/Male_Spouse_Market`rho_male'`rho_spouse'.csv, replace			
			
		* ------------------------ Individual Disposable Income --------------------------------------------
		
		* Autocovariance
		matrix C= J(`age_max',`age_max',.)
		
		forvalues i = `age_min'(1)`age_max'{
			forvalues j = `age_min'(1)`i'{
				capture corr D`rho_male'_ind_disp_resid`i' D`rho_male'_ind_disp_resid`j', covariance
				if _rc == 0 {
					matrix C[`i',`j'] = r(cov_12)
					matrix C[`j',`i'] = r(cov_12)
					}
				else{
					matrix C[`i',`j'] = .
					matrix C[`j',`i'] = .
					}
				matrix C[`i',`i'] = r(Var_1)
				}
			}
			matrix list C, format(%6.4f) noheader
			
			* Export matrix as csv
			mat2txt2 C using ./moments/cohort`c'/_all/Male_Disp`rho_male'.csv, replace
			
		* ------------------------ Spouse Disposable Income --------------------------------------------
		
		* Autocovariance
		matrix C= J(`age_max',`age_max',.)
		
		forvalues i = `age_min'(1)`age_max'{
			forvalues j = `age_min'(1)`i'{
				capture corr D`rho_spouse'_w_disp_resid`i' D`rho_spouse'_w_disp_resid`j', covariance
				if _rc == 0 {
					matrix C[`i',`j'] = r(cov_12)
					matrix C[`j',`i'] = r(cov_12)
					}
				else{
					matrix C[`i',`j'] = .
					matrix C[`j',`i'] = .
					}
				matrix C[`i',`i'] = r(Var_1)
				}
			}
			matrix list C, format(%6.4f) noheader
			
			* Export matrix as csv
			mat2txt2 C using ./moments/cohort`c'/_all/Spouse_Disp`rho_spouse'.csv, replace
			
		*----------------------- Male - Spouse Disposable Income ----------------------------------------
		
		* Note: Cross-Covariance matrix! Columns: Wife, Rows: Male 
		matrix C= J(`age_max',`age_max',.)
		
		forvalues i = `age_min'(1)`age_max'{
			forvalues j = `age_min'(1)`age_max'{
				capture corr D`rho_male'_ind_disp_resid`i' D`rho_spouse'_w_disp_resid`j', covariance
				if _rc == 0 {
					matrix C[`i',`j'] = r(cov_12)
					}
				}
			}
			matrix list C, format(%6.4f) noheader
			
			* Export matrix as csv
			mat2txt2 C using ./moments/cohort`c'/_all/Male_Spouse_Disp`rho_male'`rho_spouse'.csv, replace		
		
			
		*----------------------------------------------------------------------------------------	
		* Compute VARIANCE-COVARIANCE MATRIX  for COHORT c and EDUCATION LEVEL
		*------------------------------------------------------------------------------------------
		
		forvalues educ_level = 1/3{
		
			* load temporary cohort data
			use temp_`c', clear
			
			* keep only those obs with a certain education level
			keep if education == `educ_level'
			
			* Compute Quasi-Difference for all income measures given a value for rho_male 
			foreach income of varlist ind_market_resid ind_disp_resid{
				gen D`rho_male'_`income' = `income' - (`rho_male'/1000) * L.`income'
			}
			
			* Compute Quasi-Difference for all income measures given a value for rho_spouse 
			foreach income of varlist w_market_resid w_disp_resid{
				gen D`rho_spouse'_`income' = `income' - (`rho_spouse'/1000) * L.`income'
			}
			
			* drop first observation 
			quietly summarize age
			drop if age == r(min)
			
			local age_min=r(min)+1
			local age_max=r(max)

			* Reshape to wide format
			keep lnr age D* 
			reshape wide D*, i(lnr) j(age) 			
			
			*----------------------- Male Market Income ----------------------------------------
		
			* Autocovariance
			matrix C= J(`age_max',`age_max',.)
		
			forvalues i = `age_min'(1)`age_max'{
				forvalues j = `age_min'(1)`i'{
					capture corr D`rho_male'_ind_market_resid`i' D`rho_male'_ind_market_resid`j', covariance
					if _rc == 0 {
						matrix C[`i',`j'] = r(cov_12)
						matrix C[`j',`i'] = r(cov_12)
						}
					else{
						matrix C[`i',`j'] = .
						matrix C[`j',`i'] = .
						}
					matrix C[`i',`i'] = r(Var_1)
					}
				}
			matrix list C, format(%6.4f) noheader
			
			* Export matrix as csv
			mat2txt2 C using ./moments/cohort`c'/educ`educ_level'/Male_Market`rho_male'.csv, replace
			
			*----------------------- Spouse Market Income ----------------------------------------
		
		        * Autocovariance
			matrix C= J(`age_max',`age_max',.)
		
			forvalues i = `age_min'(1)`age_max'{
				forvalues j = `age_min'(1)`i'{
					capture corr D`rho_spouse'_w_market_resid`i' D`rho_spouse'_w_market_resid`j', covariance
					if _rc == 0 {
						matrix C[`i',`j'] = r(cov_12)
						matrix C[`j',`i'] = r(cov_12)
						}
					else{
						matrix C[`i',`j'] = .
						matrix C[`j',`i'] = .
						}
					matrix C[`i',`i'] = r(Var_1)
					}
				}
			matrix list C, format(%6.4f) noheader
			
			* Export matrix as csv
			mat2txt2 C using ./moments/cohort`c'/educ`educ_level'/Spouse_Market`rho_spouse'.csv, replace
			
			*----------------------- Male - Spouse Market Income ----------------------------------------
		
			* Note: Cross-Covariance matrix! Columns: Wife, Rows: Male 
			matrix C= J(`age_max',`age_max',.)
		
			forvalues i = `age_min'(1)`age_max'{
				forvalues j = `age_min'(1)`age_max'{
					capture corr D`rho_male'_ind_market_resid`i' D`rho_spouse'_w_market_resid`j', covariance
					if _rc == 0 {
						matrix C[`i',`j'] = r(cov_12)
						}
					}
				}
			matrix list C, format(%6.4f) noheader
			
			* Export matrix as csv
			mat2txt2 C using ./moments/cohort`c'/educ`educ_level'/Male_Spouse_Market`rho_male'`rho_spouse'.csv, replace			
			
			* ------------------------ Individual Disposable Income --------------------------------------------
		
			* Autocovariance
			matrix C= J(`age_max',`age_max',.)
		
			forvalues i = `age_min'(1)`age_max'{
				forvalues j = `age_min'(1)`i'{
					capture corr D`rho_male'_ind_disp_resid`i'  D`rho_male'_ind_disp_resid`j', covariance
					if _rc == 0 {
						matrix C[`i',`j'] = r(cov_12)
						matrix C[`j',`i'] = r(cov_12)
						}
					else{
						matrix C[`i',`j'] = .
						matrix C[`j',`i'] = .
						}
					matrix C[`i',`i'] = r(Var_1)
					}
				}
			matrix list C, format(%6.4f) noheader
			
			* Export matrix as csv
			mat2txt2 C using ./moments/cohort`c'/educ`educ_level'/Male_Disp`rho_male'.csv, replace
			
			* ------------------------ Spouse Disposable Income --------------------------------------------
		
			* Autocovariance
			matrix C= J(`age_max',`age_max',.)
		
			forvalues i = `age_min'(1)`age_max'{
				forvalues j = `age_min'(1)`i'{
					capture corr D`rho_spouse'_w_disp_resid`i' D`rho_spouse'_w_disp_resid`j', covariance
					if _rc == 0 {
						matrix C[`i',`j'] = r(cov_12)
						matrix C[`j',`i'] = r(cov_12)
						}
					else{
						matrix C[`i',`j'] = .
						matrix C[`j',`i'] = .
						}
					matrix C[`i',`i'] = r(Var_1)
					}
				}
			matrix list C, format(%6.4f) noheader
			
			* Export matrix as csv
			mat2txt2 C using ./moments/cohort`c'/educ`educ_level'/Spouse_Disp`rho_spouse'.csv, replace
			
			*----------------------- Male - Spouse Disposable Income ----------------------------------------
		
			* Note: Cross-Covariance matrix! Columns: Wife, Rows: Male 
			matrix C= J(`age_max',`age_max',.)
		
			forvalues i = `age_min'(1)`age_max'{
				forvalues j = `age_min'(1)`age_max'{
					capture corr D`rho_male'_ind_disp_resid`i' D`rho_spouse'_w_disp_resid`j', covariance
					if _rc == 0 {
						matrix C[`i',`j'] = r(cov_12)
						}
					}
				}
			matrix list C, format(%6.4f) noheader
			
			* Export matrix as csv
			mat2txt2 C using ./moments/cohort`c'/educ`educ_level'/Male_Spouse_Disp`rho_male'`rho_spouse'.csv, replace
			
		}
			
	}		
			
} 


* Family Income
forvalues rho = 750(10)1000{
		
		* Load cohort dataset
		clear
		use temp_`c'
		
		*----------------------------------------------------------------------------------
		* Compute VARIANCE COVARIANCE MATRIX for COHORT c independent of education level //
		*----------------------------------------------------------------------------------
		
		* Compute Quasi-Difference for all income measures given a value for rho 
		foreach income of varlist fam_disp_resid{
			gen D`rho'_`income' = `income' - (`rho'/1000) * L.`income'
		}
		
		* drop first observation 
		quietly summarize age
		drop if age == r(min)
		
		local age_min=r(min)+1
		local age_max=r(max)
			
		* Reshape to wide format
		keep lnr age D* 
		reshape wide D*, i(lnr) j(age) 			
		
			
		* ------------------------ Family Disposable Income --------------------------------------------
		
		* Covariance Matrix (pairwise)
		matrix C= J(`age_max',`age_max',.)
		
		forvalues i = `age_min'(1)`age_max'{
			forvalues j = `age_min'(1)`i'{
				capture corr D`rho'_fam_disp_resid`i' D`rho'_fam_disp_resid`j', covariance
				if _rc == 0 {
					matrix C[`i',`j'] = r(cov_12)
					matrix C[`j',`i'] = r(cov_12)
					}
				else{
					matrix C[`i',`j'] = .
					matrix C[`j',`i'] = .
					}
				matrix C[`i',`i'] = r(Var_1)
				}
			}
			matrix list C, format(%6.4f) noheader
			
			* Export matrix as csv
			mat2txt2 C using ./moments/cohort`c'/_all/Family_Disp`rho'.csv, replace	
			
		*----------------------------------------------------------------------------------------	
		* Compute VARIANCE-COVARIANCE MATRIX  for COHORT c and EDUCATION LEVEL
		*------------------------------------------------------------------------------------------
		
		forvalues educ_level = 1/3{
		
			* load temporary cohort data
			use temp_`c', clear
			
			* keep only those obs with a certain education level
			keep if education == `educ_level'
			
			* Compute Quasi-Difference for all income measures given a value for rho 
			foreach income of varlist fam_disp_resid{
				gen D`rho'_`income' = `income' - (`rho'/1000) * L.`income'
			}
			
			* drop first observation 
			quietly summarize age
			drop if age == r(min)
			
			local age_min=r(min)+1
			local age_max=r(max)

			* Reshape to wide format
			keep lnr age D* 
			reshape wide D*, i(lnr) j(age) 			
			
			
		* ------------------------ Family Disposable Income --------------------------------------------
		
		* Covariance Matrix (pairwise)
		matrix C= J(`age_max',`age_max',.)
		
		forvalues i = `age_min'(1)`age_max'{
			forvalues j = `age_min'(1)`i'{
				capture corr D`rho'_fam_disp_resid`i' D`rho'_fam_disp_resid`j', covariance
				if _rc == 0 {
					matrix C[`i',`j'] = r(cov_12)
					matrix C[`j',`i'] = r(cov_12)
					}
				else{
					matrix C[`i',`j'] = .
					matrix C[`j',`i'] = .
					}
				matrix C[`i',`i'] = r(Var_1)
				}
			}
			matrix list C, format(%6.4f) noheader
			
			* Export matrix as csv
			mat2txt2 C using ./moments/cohort`c'/educ`educ_level'/Family_Disp`rho'.csv, replace
		}	
			
			
}
		

exit		
	
	
