/*================================================================================================
                Import Results

Description: This do file imports all .csv files that contain the results 
for all models, education groups, incomes and samples (including bootstrap samples)  
and saves them in one file results.dta in the present working directory.		
		 
Author: Michael Graber
==================================================================================================*/

* Create list of paths to results and save it as filelist_results.txt
! ls ./model_*/results/sample*.csv ./model_*/results/bssample*.csv  >filelist_results.txt

* Open the file that we are going to read line-by-line in the loop below
file open myfile using "./filelist_results.txt", read

* Import the first set of results 
file read myfile line       // reads the 1st line of filelist_results.txt
insheet using "`line'"      // imports the first csv file 
save ./output/results.dta, replace   // save in results
drop _all

file read myfile line       // read the 2nd line of filelist_results.txt

while r(eof)==0 {           // continue doing this until the end of filelist_results.txt 
	insheet using "`line'"	
	append using ./output/results
	save ./output/results, replace
	drop _all
	file read myfile line
}
file close myfile
rm "./filelist_results.txt"

* Load results and rename variables (follows from the structure exported from matlab, see ResultCellArray.m)
use ./output/results, clear
 
rename v1 cohort
rename v2 model
rename v3 education
rename v4 income
rename v5 sample
rename v6 age
rename v7 rho
rename v8 var_alpha
rename v9 var_beta
rename v10 rho_alpha_beta
rename v11 sigma2
rename v12 omega2
rename v13 theta
rename v14 rho_spouse
rename v15 var_alpha_spouse
rename v16 var_beta_spouse
rename v17 rho_alpha_beta_spouse
rename v18 sigma2_spouse
rename v19 omega2_spouse
rename v20 theta_spouse
rename v21 cov_sigma_male_spouse
rename v22 cov_omega_male_spouse
rename v23 cov_alpha
rename v24 cov_beta

save ./output/results, replace

exit

