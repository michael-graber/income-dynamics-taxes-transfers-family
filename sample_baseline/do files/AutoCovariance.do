/*---------------------------------------------------------------------------------
        File:   AutoCovariance
	Author: Michael Graber
	Date:   December 2013
	
	this file computes
	
	- the autocovariance matrix Cov(y_ia,y_ia+1),
	- where y_ia is residual income.
----------------------------------------------------------------------------------*/

forvalues c = 1925(1)1964 {		
	
	* Load dataset after income regressions
	use baseline_sample, clear
	
	* keep cohort c
	keep if byear == `c'
				
	* Declare as Panel data
	sort lnr age
	xtset lnr age
	
	* Save temporary cohort-dataset
	save temp_`c', replace	

	quietly summarize age
		
	local age_min=r(min)
	local age_max=r(max)
				
	* Reshape to wide format
	keep lnr age ind_market_resid ind_disp_resid fam_disp_resid
	reshape wide ind_market_resid ind_disp_resid fam_disp_resid, i(lnr) j(age) 			
		
	*----------------------- Individual Market Income ----------------------------------------
		
	* Covariance Matrix (pairwise)
	matrix C= J(`age_max',`age_max',.)
		
	forvalues i = `age_min'(1)`age_max'{
		forvalues j = `age_min'(1)`i'{
			capture corr ind_market_resid`i' ind_market_resid`j', covariance
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
	mat2txt2 C using ./moments/autocov/cohort`c'/_all/Individual_Market.csv, replace
			
	* ------------------------ Individual Disposable Income --------------------------------------------
		
	* Covariance Matrix (pairwise)
	matrix C= J(`age_max',`age_max',.)
		
	forvalues i = `age_min'(1)`age_max'{
		forvalues j = `age_min'(1)`i'{
			capture corr ind_disp_resid`i' ind_disp_resid`j', covariance
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
	mat2txt2 C using ./moments/autocov/cohort`c'/_all/Individual_Disp.csv, replace
			
	* ------------------------ Family Disposable Income --------------------------------------------
		
	* Covariance Matrix (pairwise)
	matrix C= J(`age_max',`age_max',.)
		
	forvalues i = `age_min'(1)`age_max'{
		forvalues j = `age_min'(1)`i'{
			capture corr fam_disp_resid`i' fam_disp_resid`j', covariance
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
	mat2txt2 C using ./moments/autocov/cohort`c'/_all/Family_Disp.csv, replace	
			
	*----------------------------------------------------------------------------------------	
	* Compute VARIANCE-COVARIANCE MATRIX  for COHORT c and EDUCATION LEVEL
	*------------------------------------------------------------------------------------------
		
	forvalues educ_level = 1/3{
	
		* load temporary cohort data
		use temp_`c', clear
			
		* keep only those obs with a certain education level
		keep if education == `educ_level'
			
		quietly summarize age
		
		local age_min=r(min)
		local age_max=r(max)

		* Reshape to wide format
		keep lnr age ind_market_resid ind_disp_resid fam_disp_resid
		reshape wide ind_market_resid ind_disp_resid fam_disp_resid, i(lnr) j(age) 		
			
		*----------------------- Individual Market Income ----------------------------------------
		
		* Covariance Matrix (pairwise)
		matrix C= J(`age_max',`age_max',.)
		
		forvalues i = `age_min'(1)`age_max'{
			forvalues j = `age_min'(1)`i'{
				capture corr ind_market_resid`i' ind_market_resid`j', covariance
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
		mat2txt2 C using ./moments/autocov/cohort`c'/educ`educ_level'/Individual_Market.csv, replace
			
		* ------------------------ Individual Disposable Income --------------------------------------------
		
		* Covariance Matrix (pairwise)
		matrix C= J(`age_max',`age_max',.)
		
		forvalues i = `age_min'(1)`age_max'{
			forvalues j = `age_min'(1)`i'{
				capture corr ind_disp_resid`i' ind_disp_resid`j', covariance
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
		mat2txt2 C using ./moments/autocov/cohort`c'/educ`educ_level'/Individual_Disp.csv, replace
			
		* ------------------------ Family Disposable Income --------------------------------------------
		
		* Covariance Matrix (pairwise)
		matrix C= J(`age_max',`age_max',.)
		
		forvalues i = `age_min'(1)`age_max'{
			forvalues j = `age_min'(1)`i'{
				capture corr fam_disp_resid`i' fam_disp_resid`j', covariance
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
		mat2txt2 C using ./moments/autocov/cohort`c'/educ`educ_level'/Family_Disp.csv, replace
	}

}	
			
		

exit		
	
	
