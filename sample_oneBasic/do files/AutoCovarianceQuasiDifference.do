/*---------------------------------------------------------------------------------	
	this file computes
	
	- the autocovariance of the quasi-difference on a grid of rho \in [0.75,0.76,...,1]
	- for each cohort and each education group
----------------------------------------------------------------------------------*/


forvalues c = 1925(1)1964 { 
	
	* Load dataset after income regressions
	use work_1basic_sample, clear
		
	* keep only observations of a particular cohort
	keep if byear == `c'
		
	* Declare as Panel data
	sort lnr age
	xtset lnr age
		
	* Save temporary cohort-dataset
	save temp_`c', replace	


	forvalues rho = 750(10)1000{
		
		* Load cohort dataset
		clear
		use temp_`c'
		
		*----------------------------------------------------------------------------------
		* Compute VARIANCE COVARIANCE MATRIX for COHORT c independent of education level //
		*----------------------------------------------------------------------------------
		
		* Compute Quasi-Difference for all income measures given a value for rho 
		foreach income of varlist ind_market_resid ind_disp_resid fam_disp_resid{
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
		
		*----------------------- Individual Market Income ----------------------------------------
		
		* Covariance Matrix (pairwise)
		matrix C= J(`age_max',`age_max',.)
		
		forvalues i = `age_min'(1)`age_max'{
			forvalues j = `age_min'(1)`i'{
				capture corr D`rho'_ind_market_resid`i' D`rho'_ind_market_resid`j', covariance
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
			mat2txt2 C using ./moments/cohort`c'/_all/Individual_Market`rho'.csv, replace
			
		* ------------------------ Individual Disposable Income --------------------------------------------
		
		* Covariance Matrix (pairwise)
		matrix C= J(`age_max',`age_max',.)
		
		forvalues i = `age_min'(1)`age_max'{
			forvalues j = `age_min'(1)`i'{
				capture corr D`rho'_ind_disp_resid`i' D`rho'_ind_disp_resid`j', covariance
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
			mat2txt2 C using ./moments/cohort`c'/_all/Individual_Disp`rho'.csv, replace
			
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
			foreach income of varlist ind_market_resid ind_disp_resid fam_market_resid fam_disp_resid{
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
			
		*----------------------- Individual Market Income ----------------------------------------
		
		* Covariance Matrix (pairwise)
		matrix C= J(`age_max',`age_max',.)
		
		forvalues i = `age_min'(1)`age_max'{
			forvalues j = `age_min'(1)`i'{
				capture corr D`rho'_ind_market_resid`i' D`rho'_ind_market_resid`j', covariance
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
			mat2txt2 C using ./moments/cohort`c'/educ`educ_level'/Individual_Market`rho'.csv, replace
			
		* ------------------------ Individual Disposable Income --------------------------------------------
		
		* Covariance Matrix (pairwise)
		matrix C= J(`age_max',`age_max',.)
		
		forvalues i = `age_min'(1)`age_max'{
			forvalues j = `age_min'(1)`i'{
				capture corr D`rho'_ind_disp_resid`i' D`rho'_ind_disp_resid`j', covariance
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
			mat2txt2 C using ./moments/cohort`c'/educ`educ_level'/Individual_Disp`rho'.csv, replace
			
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
	
	* remove temporary cohort dataset
	rm ./temp_`c'.dta
}	
		

exit		
	
	
