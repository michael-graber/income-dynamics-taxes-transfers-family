/*---------------------------------------------------------------------------------
 
	Description: This file regresses
	
	(a) individual male log income
	(b) family log income
	
	on
	dummies for
	
	1.) education (male)
	2.) region    (male)
	3.) family size
	4.) marital status
	5.) marital status*family size 
	6.) age
	7.) age²
	8.) age*education
	9.) age²*education

for each year separately and predicts log-income and the residual	
----------------------------------------------------------------------------------*/

* Load Baseline Sample
clear
use baseline_sample


* Individual Male Income
gen log_disp_income    = log(disp_income)
gen log_market         = log(market)


* Family Income
gen log_disp_income_fam  = log(disp_income_fam)
gen log_market_fam       = log(market_fam)


* ---------------------------- Regression for each year separately --------------------------

* Residual Individual Male Income
gen ind_disp_resid = .
gen ind_market_resid = .


* Residual Family Income
gen fam_disp_resid = .
gen fam_market_resid = .


forvalues t = 1967/2006 {


	* Individual Male Income	
	reg log_disp_income i.education i.reg i.famsize i.married i.famsize#i.married c.age c.age#c.age c.age#i.education (c.age#c.age)#i.education if year == `t' 
	predict resid if e(sample), residuals
	replace ind_disp_resid = resid if year == `t'
	drop resid
	
	reg log_market i.education i.reg i.famsize i.married  i.famsize#i.married c.age c.age#c.age c.age#i.education (c.age#c.age)#i.education   if year == `t'
	predict resid if e(sample), residuals
	replace ind_market_resid = resid if year == `t' 
	drop resid 
	

	* Family Income
	reg log_disp_income_fam i.education i.reg i.famsize i.married  i.famsize#i.married c.age c.age#c.age c.age#i.education (c.age#c.age)#i.education  if year == `t' 
	predict resid if e(sample), residuals
	replace fam_disp_resid = resid if year == `t'
	drop resid 
	
	reg log_market_fam i.education i.reg i.famsize i.married  i.famsize#i.married c.age c.age#c.age c.age#i.education (c.age#c.age)#i.education    if year == `t'
	predict resid if e(sample), residuals 
	replace fam_market_resid = resid if year == `t'
	drop resid 
	
	
	}


* save current dataset
save baseline_sample,replace
	
exit
