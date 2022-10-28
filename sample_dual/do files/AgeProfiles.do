/*---------------------------------------------------------------------------------
   
Description: This file 

- calculates the common across age and cohorts education-specific time effect E(y_t|education=e) and normalises this time effect to be zero in year 1990
- removes the normalised time effect from log-income measure y_t and calculates E(y_t|age,education,cohort) and Var(y_t|age,education,cohort)
- averaging these measures over cohorts (each cohort has the same weight) yields the education-specific average age profiles for log-income and its variance
	
----------------------------------------------------------------------------------*/

* Load dataset obtained after performing income regressions
clear
use DualEarner_sample

* Descriptive Statistics: Age Range for each Cohort
log using AgeRangeCohorts, replace

* Age Range Cohorts:
bysort byear: summarize age
log close 

* Compute E(y_t|education = e) (where y_t is the actual log income):
* COMMON ACROSS AGE and COHORTS EDUCATION SPECIFIC TIME EFFECT

by year education, sort: egen imarket_time = mean(log_market)
by year education, sort: egen idisp_time   = mean(log_disp_income)

by year education, sort: egen wmarket_time = mean(log_market_w)
by year education, sort: egen wdisp_time   = mean(log_disp_income_w)

by year education, sort: egen fmarket_time = mean(log_market_fam)
by year education, sort: egen fdisp_time   = mean(log_disp_income_fam)


*NORMALISE TIME EFFECT TO BE ZERO IN YEAR 1990

forvalues edu = 1/3 {
	
	* Normalised Time Effect Income Profiles
	summarize imarket_time if year == 1990 & education == `edu'
	gen temp1 = r(mean)
	replace  imarket_time = imarket_time - temp1 if education == `edu'
	drop temp1
	
	summarize idisp_time if year == 1990 & education == `edu'
	gen temp1 = r(mean)
	replace  idisp_time = idisp_time - temp1 if education == `edu'
	drop temp1
	
	summarize wmarket_time if year == 1990 & education == `edu'
	gen temp1 = r(mean)
	replace  wmarket_time = wmarket_time - temp1 if education == `edu'
	drop temp1
	
	summarize wdisp_time if year == 1990 & education == `edu'
	gen temp1 = r(mean)
	replace  wdisp_time = wdisp_time - temp1 if education == `edu'
	drop temp1
	
	summarize fmarket_time if year == 1990 & education == `edu'
	gen temp1 = r(mean)
	replace  fmarket_time = fmarket_time - temp1 if education == `edu'
	drop temp1
	
	summarize fdisp_time if year == 1990 & education == `edu'
	gen temp1 = r(mean)
	replace  fdisp_time = fdisp_time - temp1 if education == `edu'
	drop temp1
	
	}


* Subtract Normalised Time effect from Log-income
gen y_market_noTE       = log_market - imarket_time
gen y_disp_noTE         = log_disp_income - idisp_time

gen y_market_w_noTE     = log_market_w - wmarket_time
gen y_disp_w_noTE       = log_disp_income_w - wdisp_time

gen y_market_fam_noTE   = log_market_fam  - fmarket_time
gen y_disp_fam_noTE     = log_disp_income_fam - fdisp_time 

* Compute E(y_t|age,cohort,education) where y_t is log income (education-specific calendar time effects removed)
by age byear education, sort: egen imarket_age_cohort   = mean(y_market_noTE)
by age byear education, sort: egen idisp_age_cohort     = mean(y_disp_noTE)

by age byear education, sort: egen wmarket_age_cohort   = mean(y_market_w_noTE)
by age byear education, sort: egen wdisp_age_cohort     = mean(y_disp_w_noTE)

by age byear education, sort: egen fmarket_age_cohort   = mean(y_market_fam_noTE)
by age byear education, sort: egen fdisp_age_cohort     = mean(y_disp_fam_noTE)


* Compute Var(y_t|age,cohort,education) where y_t is log income (education-specific calendar time effects removed)
by age byear education, sort: egen temp1   = sd(y_market_noTE)
by age byear education, sort: egen temp2   = sd(y_disp_noTE)

by age byear education, sort: egen temp5   = sd(y_market_w_noTE)
by age byear education, sort: egen temp6   = sd(y_disp_w_noTE)

by age byear education, sort: egen temp3   = sd(y_market_fam_noTE)
by age byear education, sort: egen temp4   = sd(y_disp_fam_noTE)

gen Vimarket_age_cohort  = (temp1)^2
gen Vidisp_age_cohort    = (temp2)^2

gen Vwmarket_age_cohort  = (temp5)^2
gen Vwdisp_age_cohort    = (temp6)^2

gen Vfmarket_age_cohort  = (temp3)^2
gen Vfdisp_age_cohort    = (temp4)^2

drop temp1 temp2 temp3 temp4  temp5 temp6
 

* save current dataset as baseline sample 
* (includes residuals from income regression and income variables with education-specific Calendar time effect removed)
save DualEarner_sample, replace

*----------- Collapse observations: Only one observation per cohort, age and education -------------------  
duplicates drop byear age education, force



* ----------------- Compute Average Profiles (each cohort has the same weight) ----------------------------------------

* Average Profiles
by  age education, sort: egen  imarket_age = mean(imarket_age_cohort)
by  age education, sort: egen   idisp_age  = mean(idisp_age_cohort)

by  age education, sort: egen  wmarket_age = mean(wmarket_age_cohort)
by  age education, sort: egen   wdisp_age  = mean(wdisp_age_cohort)

by  age education, sort: egen fmarket_age  = mean(fmarket_age_cohort)
by  age education, sort: egen fdisp_age    = mean(fdisp_age_cohort)

by  age education, sort: egen Vimarket_age = mean(Vimarket_age_cohort)
by  age education, sort: egen Vidisp_age   = mean(Vidisp_age_cohort)

by  age education, sort: egen Vwmarket_age = mean(Vwmarket_age_cohort)
by  age education, sort: egen Vwdisp_age   = mean(Vwdisp_age_cohort)

by  age education, sort: egen Vfmarket_age = mean(Vfmarket_age_cohort)
by  age education, sort: egen Vfdisp_age   = mean(Vfdisp_age_cohort)


* Collapse observations
duplicates drop age education, force
sort education age

* -------------------------- Plot Average Profiles ----------------------------------------------

forvalues edu =1/3{

	if `edu' == 1 {
		local skill "Low-Skilled"
		}
	else if `edu' == 2 {
		local skill "Medium-Skilled"
		}
	else if `edu' == 3 {
		local skill "High-Skilled"
		}
		
		
* Average Profile Individual Market Income and Individual Disposable Income
graph twoway (line imarket_age age if education == `edu') ///
           ||(line idisp_age   age if education == `edu'), plotregion(lcolor(black)) graphregion(color(white)) bgcolor(white)  ///
	ytitle("log-income") ///
	xtitle("age") ///
	xlabel(25(5)60) ///
	ylabel(11.2(0.3)12.6 , nogrid) ///
	legend(order( 1 "Market Income" 2 "Disposable Income"))
	graph export ./figures/AgeProfile_y_individual_`edu'.eps, replace		

* Average Profile Spouses Market Income and Spouses Disposable Income
graph twoway (line wmarket_age age if education == `edu') ///
           ||(line wdisp_age   age if education == `edu'), plotregion(lcolor(black)) graphregion(color(white)) bgcolor(white)  ///
	ytitle("log-income") ///
	xtitle("age") ///
	xlabel(25(5)60) ///
	ylabel(11.2(0.3)12.6 , nogrid) ///
	legend(order( 1 "Market Income" 2 "Disposable Income"))
	graph export ./figures/AgeProfile_y_spouse_`edu'.eps, replace
	
* Average Profile: Family Market Income and Family Disposable Income
graph twoway (line fmarket_age age if education == `edu') ///
           ||(line fdisp_age   age if education == `edu'), plotregion(lcolor(black)) graphregion(color(white)) bgcolor(white) ///
	ytitle("log-income") ///
	xtitle("age")  ///
	xlabel(25(5)60) ///
	ylabel(11.2(0.3)12.6 , nogrid)  ///
	legend(order( 1 "Market Income" 2 "Disposable Income"))
	graph export ./figures/AgeProfile_y_family_`edu'.eps, replace	
	
* Average Profile: Individual and Spouse Income
graph twoway  (line imarket_age age if education == `edu') ///
           || (line idisp_age   age if education == `edu') ///
	   || (line wmarket_age age if education == `edu') ///
	   || (line wdisp_age age if education == `edu'), plotregion(lcolor(black)) graphregion(color(white)) bgcolor(white) ///
	ytitle("log-income") ///
	xtitle("age")  ///
	xlabel(25(5)60) ///
	ylabel(11.2(0.3)12.6 , nogrid)  ///
	legend(order( 1 "Market Income" 2 "Disposable Income" 3 "Market Income (Spouse)" 4 "Disposable Income (Spouse)"))
	graph export ./figures/AgeProfile_y_individual_spouse_`edu'.eps, replace	
			
* Average Profile: Individual, Spouse and Family Disposable Income
graph twoway  (line idisp_age   age if education == `edu') ///
	   || (line wdisp_age   age if education == `edu') ///
	   || (line fdisp_age   age if education == `edu'), plotregion(lcolor(black)) graphregion(color(white)) bgcolor(white) ///
	ytitle("log-income") ///
	xtitle("age")  ///
	xlabel(25(5)60) ///
	ylabel(11.2(0.3)12.6 , nogrid)  ///
	legend(order( 1 "Disposable Income" 2 "Disposable Income (Spouse)" 3 "Disposable Income (Family)"))
	graph export ./figures/AgeProfile_y_`edu'.eps, replace	
			
	
* Average Profile: Variance of individual market income and Variance of individual disposable income
graph twoway (line Vimarket_age  age if education == `edu') ///
           ||(line Vidisp_age    age if education == `edu'), plotregion(lcolor(black)) graphregion(color(white)) bgcolor(white) ///
	ytitle("Var(log-income)") ///
	xtitle("age") ///	
	xlabel(25(5)60) ///
	ylabel(0(.25)1.0 , nogrid)  ///
	legend(order( 1 "Market Income" 2 "Disposable Income"))
	graph export ./figures/AgeProfile_Var_y_individual_`edu'.eps, replace

* Average Profile: Variance of spouse market income and Variance of spouse disposable income
graph twoway (line Vwmarket_age  age if education == `edu') ///
           ||(line Vwdisp_age    age if education == `edu'), plotregion(lcolor(black)) graphregion(color(white)) bgcolor(white) ///
	ytitle("Var(log-income)") ///
	xtitle("age") ///	
	xlabel(25(5)60) ///
	ylabel(0(.25)1.25 , nogrid)  ///
	legend(order( 1 "Market Income" 2 "Disposable Income"))
	graph export ./figures/AgeProfile_Var_y_spouse_`edu'.eps, replace
	
	
* Average Profile: Variance of family market income and Variance of family disposable income
graph twoway (line Vfmarket_age  age if education == `edu') ///
           ||(line Vfdisp_age    age if education == `edu'), plotregion(lcolor(black)) graphregion(color(white)) bgcolor(white) ///
	ytitle("Var(log-income)") /// 
	xtitle("age")  ///
	xlabel(25(5)60) ///
	ylabel(0(.25)1.0 , nogrid)  ///
	legend(order( 1 "Market Income" 2 "Disposable Income"))	   
	graph export ./figures/AgeProfile_Var_y_family_`edu'.eps, replace

* Average Profile: Variance of Individual and Spouse Income
graph twoway  (line Vimarket_age age if education == `edu') ///
           || (line Vidisp_age   age if education == `edu') ///
	   || (line Vwmarket_age age if education == `edu') ///
	   || (line Vwdisp_age age if education == `edu'), plotregion(lcolor(black)) graphregion(color(white)) bgcolor(white) ///
	ytitle("Var(log-income)") ///
	xtitle("age")  ///
	xlabel(25(5)60) ///
	ylabel(0(0.25)1.25 , nogrid)  ///
	legend(order( 1 "Market Income" 2 "Disposable Income" 3 "Market Income (Spouse)" 4 "Disposable Income (Spouse)"))
	graph export ./figures/AgeProfile_Var_y_individual_spouse_`edu'.eps, replace	
	
* Average Profile: Variance of Individual, Spouse and Family Disposable Income
graph twoway  (line Vidisp_age   age if education == `edu') ///
	   || (line Vwdisp_age   age if education == `edu') ///
	   || (line Vfdisp_age   age if education == `edu'), plotregion(lcolor(black)) graphregion(color(white)) bgcolor(white) ///
	ytitle("Var(log-income)") ///
	xtitle("age")  ///
	xlabel(25(5)60) ///
	ylabel(0(0.25)1.0 , nogrid)  ///
	legend(order( 1 "Disposable Income" 2 "Disposable Income (Spouse)" 3 "Disposable Income (Family)"))
	graph export ./figures/AgeProfile_Var_y_`edu'.eps, replace	
	

}	



* ========================= EXPORT DATA ==============================================
* Export Average Profiles
* Collapse observations
duplicates drop age education, force
outsheet age education imarket_age idisp_age wmarket_age wdisp_age fmarket_age fdisp_age       using ./moments/AgeProfiles.csv, comma replace
outsheet age education Vimarket_age Vidisp_age Vwmarket_age Vwdisp_age Vfmarket_age Vfdisp_age using ./moments/AgeProfilesVariances.csv, comma replace	
exit
