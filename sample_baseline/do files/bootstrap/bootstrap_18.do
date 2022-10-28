
* Working Directory
cd "/data/uctpmgr/BitBucket/BlundellGraberMogstad/sample_baseline"

set more off

use main_sample, clear
set seed 83590

local bs  18

* Draw bootstrap sample clustered by person-identifier and stratified by cohort. Note that
* the newly created person-identfier bootstrap_id is only unique at the strata level. This
* however does not cause any problems, because we calculate AutoCov of QD by cohorts, so
* we can use this id as panel identifier.

bsample, cluster(lnr) idcluster(bootstrap_id) strata(byear)
save bsample_`bs', replace
	
* Run first stage regressions
do "./do files/bootstrap/IncomeRegressions.do"
save bsample_`bs', replace
	
* Calculate AutoCovariances of Quasi-Differences
forvalues cohort = 1925/1964 {
		
	* Load dataset after income regressions
	use bsample_`bs', clear
		
	* keep only observations of a particular cohort
	keep if byear == `cohort'
		
	* Declare as Panel data using bootstrap_id as panel identifier
	sort  bootstrap_id age
	xtset bootstrap_id age
		
	* Save temporary cohort-dataset
	save temp_`bs'_`cohort', replace	
			
	forvalues rho = 750(10)1000{
		
		* Load cohort dataset
		clear
		use temp_`bs'_`cohort'
		
		* Compute Quasi-Difference for a given value for rho
		gen D`rho'_ind_market_resid =  ind_market_resid - (`rho'/1000) * L.ind_market_resid
		
		* drop first observation 
		quietly summarize age
		drop if age == r(min)
		
		local age_min=r(min)+1
		local age_max=r(max)
			
		* Reshape to wide format
		keep bootstrap_id age D* 
		reshape wide D*, i(bootstrap_id) j(age) 			
		
		*----------------------------------------------------------------------------------
		* AUTOCOVARIANCE OF QUASI-DIFFERENCES: INDIVIDUAL MARKET INCOME - POOLED
		*----------------------------------------------------------------------------------
		
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
		mat2txt2 C using ./bootstrap_moments/bssample_`bs'/cohort`cohort'/_all/Individual_Market`rho'.csv, replace
				
				
		*----------------------------------------------------------------------------------------
		* AUTOCOVARIANCE OF QUASI-DIFFERENCES: INDIVIDUAL MARKET INCOME - EDUCATION - SPECIFIC
		*----------------------------------------------------------------------------------------
		
		forvalues education = 1(1)3 {
			
			* Load cohort dataset
			clear
			use temp_`bs'_`cohort'
			
			* Education
			keep if education == `education'
			
			* Compute Quasi-Difference for a given value for rho
			gen D`rho'_ind_market_resid =  ind_market_resid - (`rho'/1000) * L.ind_market_resid
		
			* drop first observation 
			quietly summarize age
			drop if age == r(min)
		
			local age_min=r(min)+1
			local age_max=r(max)
			
			* Reshape to wide format
			keep bootstrap_id age D* 
			reshape wide D*, i(bootstrap_id) j(age) 		
			
		
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
			mat2txt2 C using ./bootstrap_moments/bssample_`bs'/cohort`cohort'/educ`education'/Individual_Market`rho'.csv, replace
		}
		
		
		
		*----------------------------------------------------------------------------------
		* AUTOCOVARIANCE OF QUASI-DIFFERENCES: INDIVIDUAL DISPOSABLE INCOME - POOLED
		*----------------------------------------------------------------------------------
		
		* Load cohort dataset
		clear
		use temp_`bs'_`cohort'
		
		* Compute Quasi-Difference for a given value for rho 
		gen D`rho'_ind_disp_resid =  ind_disp_resid - (`rho'/1000) * L.ind_disp_resid
		
		* drop first observation 
		quietly summarize age
		drop if age == r(min)
		
		local age_min=r(min)+1
		local age_max=r(max)
			
		* Reshape to wide format
		keep bootstrap_id age D* 
		reshape wide D*, i(bootstrap_id) j(age) 			
		
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
		mat2txt2 C using ./bootstrap_moments/bssample_`bs'/cohort`cohort'/_all/Individual_Disp`rho'.csv, replace
		
		
		*-------------------------------------------------------------------------------------------
		* AUTOCOVARIANCE OF QUASI-DIFFERENCES: INDIVIDUAL DISPOSABLE INCOME - EDUCATION SPECIFIC
		*------------------------------------------------------------------------------------------
		
		forvalues education = 1(1)3 {
		
			* Load cohort dataset
			clear
			use temp_`bs'_`cohort'
			
			* education
			keep if education ==  `education'
			
			* Compute Quasi-Difference for a given value for rho 
			gen D`rho'_ind_disp_resid =  ind_disp_resid - (`rho'/1000) * L.ind_disp_resid
		
			* drop first observation 
			quietly summarize age
			drop if age == r(min)
		
			local age_min=r(min)+1
			local age_max=r(max)
			
			* Reshape to wide format
			keep bootstrap_id age D* 
			reshape wide D*, i(bootstrap_id) j(age) 			
		
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
			mat2txt2 C using ./bootstrap_moments/bssample_`bs'/cohort`cohort'/educ`education'/Individual_Disp`rho'.csv, replace
		}
		
		
		*----------------------------------------------------------------------------------
		* AUTOCOVARIANCE OF QUASI-DIFFERENCES: FAMILY DISPOSABLE INCOME - POOLED
		*----------------------------------------------------------------------------------

		
		* Load cohort dataset
		clear
		use temp_`bs'_`cohort'
		
		* Compute Quasi-Difference for a given value for rho 
		gen D`rho'_fam_disp_resid =  fam_disp_resid - (`rho'/1000) * L.fam_disp_resid
		
		* drop first observation 
		quietly summarize age
		drop if age == r(min)
		
		local age_min=r(min)+1
		local age_max=r(max)
			
		* Reshape to wide format
		keep bootstrap_id age D* 
		reshape wide D*, i(bootstrap_id) j(age) 			
		
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
		mat2txt2 C using ./bootstrap_moments/bssample_`bs'/cohort`cohort'/_all/Family_Disp`rho'.csv, replace
		
						
		
		*----------------------------------------------------------------------------------
		* AUTOCOVARIANCE OF QUASI-DIFFERENCES: FAMILY DISPOSABLE INCOME - EDUCATION SPECIFIC
		*----------------------------------------------------------------------------------
		
		forvalues education = 1(1)3{
		
			* Load cohort dataset
			clear
			use temp_`bs'_`cohort'
			
			* education
			keep if education == `education'
		
			* Compute Quasi-Difference for a given value for rho 
			gen D`rho'_fam_disp_resid =  fam_disp_resid - (`rho'/1000) * L.fam_disp_resid
		
			* drop first observation 
			quietly summarize age
			drop if age == r(min)
		
			local age_min=r(min)+1
			local age_max=r(max)
			
			* Reshape to wide format
			keep bootstrap_id age D* 
			reshape wide D*, i(bootstrap_id) j(age) 			
		
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
			mat2txt2 C using ./bootstrap_moments/bssample_`bs'/cohort`cohort'/educ`education'/Family_Disp`rho'.csv, replace
		}
			
		
		
	}
	* Remove files from disk
	rm ./temp_`bs'_`cohort'.dta					
}
rm ./bsample_`bs'.dta

exit


