*============================================================
* Model Fit: Baseline Model
*============================================================
* Create list of paths to profiles and save it as filelist_modelfit.txt
! ls ./output/stata/modelfit/Cov_delta_*.csv > filelist_modelfit.txt

* Open the file that we are going to read line-by-line in the loop below
file open myfile using "./filelist_modelfit.txt", read

* Import the first set of results 
file read myfile line       // reads the 1st line of filelist_results.txt
insheet using "`line'"      // imports the first csv file 
save ./output/stata/modelfit/Cov_delta_y, replace   // save in delta_y.dta
drop _all

file read myfile line       // read the 2nd line of filelist_results.txt

while r(eof)==0 {           // continue doing this until the end of filelist_results.txt 
	insheet using "`line'"	
	append using ./output/stata/modelfit/Cov_delta_y
	save ./output/stata/modelfit/Cov_delta_y, replace
	drop _all
	file read myfile line
}
file close myfile
rm "./filelist_modelfit.txt"

* Rename variables
use ./output/stata/modelfit/Cov_delta_y
rename v1 cohort
rename v2 education
rename v3 income 
rename v4 sample
rename v5 age
rename v6 var_delta_y
rename v7 var_delta_y_model
rename v8 cov_delta_y
rename v9 cov_delta_y_model
rename v10 var_y
rename v11 var_y_model

save ./output/stata/modelfit/Cov_delta_y, replace

foreach skills in lowskill mediumskill highskill  {
	
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
	
	* Variance of Growth Rates
	* Market Income
	graph twoway (line var_delta_y       age if income == "market" & education == "`skills'" & age <= 58 & age >= 27) ///
		  || (line var_delta_y_model age if income == "market" & education == "`skills'" & age <= 58 & age >= 27),  plotregion(lcolor(black)) graphregion(color(white)) bgcolor(white) ///
	xlabel(25 (5) 55) ///
	ylabel(0 (.1) .5, nogrid) ///
	xtitle("age")  ///
	ytitle("var({&Delta}y{subscript:i,a})") ///
	legend(order(1 "Data" 2 "Model"))  ///
	subtitle("Market Income") 
	graph export ./output/stata/figures/ModelFit/var_delta_y_`skills'_market_Average.eps, replace
	
	
	* Disposable Income
	graph twoway (line var_delta_y       age if income == "disposable" & education == "`skills'" & age <= 58 & age >= 27) ///
		  || (line var_delta_y_model age if income == "disposable" & education == "`skills'" & age <= 58 & age >= 27),  plotregion(lcolor(black)) graphregion(color(white)) bgcolor(white) ///
	xlabel(25 (5) 55) ///
	ylabel(0 (.1) .5, nogrid) ///
	xtitle("age")  ///
	ytitle("var({&Delta}y{subscript:i,a})") ///
	legend(order(1 "Data" 2 "Model"))  ///
	subtitle("Disposable Income") 
	graph export ./output/stata/figures/ModelFit/var_delta_y_`skills'_disposable_Average.eps, replace
	
	
	* Disposable Family Income
	graph twoway (line var_delta_y       age if income == "disposable(family)" & education == "`skills'" & age <= 58 & age >= 27) ///
		  || (line var_delta_y_model age if income == "disposable(family)" & education == "`skills'" & age <= 58 & age >= 27),  plotregion(lcolor(black)) graphregion(color(white)) bgcolor(white) ///
	xlabel(25 (5) 55) ///
	ylabel(0 (.1) .5, nogrid) ///
	xtitle("age")  ///
	ytitle("var({&Delta}y{subscript:i,a})") ///
	legend(order(1 "Data" 2 "Model"))  ///
	subtitle("Family Disposable Income") 
	graph export ./output/stata/figures/ModelFit/var_delta_y_`skills'_disposable_family_Average.eps, replace
	
	
	*Covariance of Growth Rates
	* Market Income
	graph twoway (line cov_delta_y       age if income == "market" & education == "`skills'" & age <= 58 & age >= 27) ///
		  || (line cov_delta_y_model age if income == "market" & education == "`skills'" & age <= 58 & age >= 27),  plotregion(lcolor(black)) graphregion(color(white)) bgcolor(white) ///
	xlabel(25 (5) 55) ///
	ylabel(-.1 (.025) 0.025, nogrid) ///
	xtitle("age")  ///
	ytitle("cov({&Delta}y{subscript:i,a},{&Delta}y{subscript:i,a+1})") ///
	legend(order(1 "Data" 2 "Model"))  ///
	subtitle("Market Income") 
	graph export ./output/stata/figures/ModelFit/cov_delta_y_`skills'_market_Average.eps, replace
	
	
	* Disposable Income
	graph twoway (line cov_delta_y       age if income == "disposable" & education == "`skills'" & age <= 58 & age >= 27) ///
		  || (line cov_delta_y_model age if income == "disposable" & education == "`skills'" & age <= 58 & age >= 27),  plotregion(lcolor(black)) graphregion(color(white)) bgcolor(white) ///
	xlabel(25 (5) 55) ///
	ylabel(-.1 (.025) 0.025, nogrid) ///
	xtitle("age")  ///
	ytitle("cov({&Delta}y{subscript:i,a},{&Delta}y{subscript:i,a+1})") ///
	legend(order(1 "Data" 2 "Model"))  ///
	subtitle("Disposable Income") 
	graph export ./output/stata/figures/ModelFit/cov_delta_y_`skills'_disposable_Average.eps, replace
	
	
	* Disposable Family Income
	graph twoway (line cov_delta_y       age if income == "disposable(family)" & education == "`skills'" & age <= 58 & age >= 27) ///
		  || (line cov_delta_y_model age if income == "disposable(family)" & education == "`skills'" & age <= 58 & age >= 27),  plotregion(lcolor(black)) graphregion(color(white)) bgcolor(white) ///
	xlabel(25 (5) 55) ///
	ylabel(-.1 (.025) 0.025, nogrid) ///
	xtitle("age")  ///
	ytitle("cov({&Delta}y{subscript:i,a},{&Delta}y{subscript:i,a+1})") ///
	legend(order(1 "Data" 2 "Model"))  ///
	subtitle("Family Disposable Income") 
	graph export ./output/stata/figures/ModelFit/cov_delta_y_`skills'_disposable_family_Average.eps, replace
	
	*Variance (levels)
	* Market Income
	graph twoway (line var_y       age if income == "market" & education == "`skills'" & age <= 58) ///
		  || (line var_y_model age if income == "market" & education == "`skills'"  & age <= 58),  plotregion(lcolor(black)) graphregion(color(white)) bgcolor(white) ///
	xlabel(25 (5) 55) ///
	ylabel(0 (.25) 1, nogrid) ///
	xtitle("age")  ///
	ytitle("var(y{subscript:i,a})") ///
	legend(order(1 "Data" 2 "Model"))  ///
	subtitle("Market Income") 
	graph export ./output/stata/figures/ModelFit/var_y_`skills'_market_Average.eps, replace
	
	
	* Disposable Income
	graph twoway (line var_y       age if income == "disposable" & education == "`skills'" & age <= 58) ///
		  || (line var_y_model age if income == "disposable" & education == "`skills'" & age <= 58),  plotregion(lcolor(black)) graphregion(color(white)) bgcolor(white) ///
	xlabel(25 (5) 55) ///
	ylabel(0 (.25) 1, nogrid) ///
	xtitle("age")  ///
	ytitle("var(y{subscript:i,a})") ///
	legend(order(1 "Data" 2 "Model"))  ///
	subtitle("Disposable Income") 
	graph export ./output/stata/figures/ModelFit/var_y_`skills'_disposable_Average.eps, replace
	
	
	* Disposable Family Income
	graph twoway (line var_y       age if income == "disposable(family)" & education == "`skills'" & age <= 58) ///
		  || (line var_y_model age if income == "disposable(family)" & education == "`skills'" & age <= 58),  plotregion(lcolor(black)) graphregion(color(white)) bgcolor(white) ///
	xlabel(25 (5) 55) ///
	ylabel(0 (.25) 1, nogrid) ///
	xtitle("age")  ///
	ytitle("var(y{subscript:i,a})") ///
	legend(order(1 "Data" 2 "Model"))  ///
	subtitle("Family Disposable Income") 
	graph export ./output/stata/figures/ModelFit/var_y_`skills'_disposable_family_Average.eps, replace
	
	
	
}
