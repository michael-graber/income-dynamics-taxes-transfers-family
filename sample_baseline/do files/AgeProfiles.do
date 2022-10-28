/*---------------------------------------------------------------------------------
   
Description: This file 

- calculates the common across age and cohorts education-specific time effect E(y_t|education=e) and normalises this time effect to be zero in year 1990
- removes the normalised time effect from log-income measure y_t and calculates E(y_t|age,education,cohort) and Var(y_t|age,education,cohort)
- averaging these measures over cohorts (each cohort has the same weight) yields the education-specific average age profiles for log-income and its variance

- furthermore this file calculates some age profiles regarding the family composition and the spouse's labour force participation
	
----------------------------------------------------------------------------------*/

* Load dataset obtained after performing income regressions
clear
use baseline_sample

* Descriptive Statistics: Age Range for each Cohort
log using AgeRangeCohorts, replace

* Age Range Cohorts:
bysort byear: summarize age
log close 

* Compute E(y_t|education = e) (where y_t is the actual log income):
* COMMON ACROSS AGE and COHORTS EDUCATION SPECIFIC TIME EFFECT

by year education, sort: egen imarket_time = mean(log_market)
by year education, sort: egen idisp_time   = mean(log_disp_income)
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
gen y_market_fam_noTE   = log_market_fam  - fmarket_time
gen y_disp_fam_noTE     = log_disp_income_fam - fdisp_time 

* Compute E(y_t|age,cohort,education) where y_t is log income (education-specific calendar time effects removed)
by age byear education, sort: egen imarket_age_cohort   = mean(y_market_noTE)
by age byear education, sort: egen idisp_age_cohort     = mean(y_disp_noTE)
by age byear education, sort: egen fmarket_age_cohort   = mean(y_market_fam_noTE)
by age byear education, sort: egen fdisp_age_cohort     = mean(y_disp_fam_noTE)


* Compute Var(y_t|age,cohort,education) where y_t is log income (education-specific calendar time effects removed)
by age byear education, sort: egen temp1   = sd(y_market_noTE)
by age byear education, sort: egen temp2   = sd(y_disp_noTE)
by age byear education, sort: egen temp3   = sd(y_market_fam_noTE)
by age byear education, sort: egen temp4   = sd(y_disp_fam_noTE)

gen Vimarket_age_cohort  = (temp1)^2
gen Vidisp_age_cohort    = (temp2)^2
gen Vfmarket_age_cohort  = (temp3)^2
gen Vfdisp_age_cohort    = (temp4)^2

drop temp1 temp2 temp3 temp4  

* Variance of the residual
by age byear education, sort: egen temp1   = sd(ind_market_resid) 
by age byear education, sort: egen temp2   = sd(ind_disp_resid)   
by age byear education, sort: egen temp3   = sd(fam_market_resid) 
by age byear education, sort: egen temp4   = sd(fam_disp_resid)   

gen VRimarket_age_cohort  = (temp1)^2
gen VRidisp_age_cohort    = (temp2)^2
gen VRfmarket_age_cohort  = (temp3)^2
gen VRfdisp_age_cohort    = (temp4)^2

drop temp1 temp2 temp3 temp4  

 

*============= Family and Female Labour Supply Related Statistics ==================

* Family Size over the Life Cycle for the different cohorts
by byear education age, sort: egen n_family_age_cohort = mean(famsize)


* Percentage of married men
by byear education age, sort: egen married_age_cohort = mean(married)


* save current dataset 
* (includes residuals from income regression and income variables with education-specific Calendar time effect removed)
save baseline_sample, replace


*----------- Collapse observations: Only one observation per cohort, age and education -------------------  
duplicates drop byear age education, force


* ----------------- Compute Average Profiles ----------------------------------------

* Average Profiles
by  age education, sort: egen  imarket_age = mean(imarket_age_cohort)
by  age education, sort: egen   idisp_age  = mean(idisp_age_cohort)
by  age education, sort: egen fmarket_age  = mean(fmarket_age_cohort)
by  age education, sort: egen fdisp_age    = mean(fdisp_age_cohort)

by  age education, sort: egen Vimarket_age = mean(Vimarket_age_cohort)
by  age education, sort: egen Vidisp_age   = mean(Vidisp_age_cohort)
by  age education, sort: egen Vfmarket_age = mean(Vfmarket_age_cohort)
by  age education, sort: egen Vfdisp_age   = mean(Vfdisp_age_cohort)

* Variance residual income
by  age education, sort: egen VRimarket_age = mean(VRimarket_age_cohort)
by  age education, sort: egen VRidisp_age   = mean(VRidisp_age_cohort)
by  age education, sort: egen VRfmarket_age = mean(VRfmarket_age_cohort)
by  age education, sort: egen VRfdisp_age   = mean(VRfdisp_age_cohort)


by  age education, sort: egen married_age  = mean(married_age_cohort)
by  age education, sort: egen n_family_age = mean(n_family_age_cohort)


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
		
	
* Average Profile: Family and Individual Income
graph twoway  (line imarket_age age if education == `edu') ///
           || (line idisp_age   age if education == `edu') ///
	   || (line fdisp_age age if education == `edu'), plotregion(lcolor(black))  graphregion(color(white)) bgcolor(white) ///
	ytitle("log-income") ///
	xtitle("age")  ///
	xlabel(25(5)60) ///
	ylabel(11.2(0.3)12.6 , nogrid)  ///
	legend(order( 1 "Market Income" 2 "Disposable Income" 3 "Family Disposable Income"))
	graph export ./figures/AgeProfile_y_`edu'.eps, replace	
		

* Average Profile: Variance Family and Individual Income
graph twoway  (line Vimarket_age age if education == `edu') ///
           || (line Vidisp_age   age if education == `edu') ///
	   || (line Vfdisp_age age if education == `edu'), plotregion(lcolor(black))  graphregion(color(white)) bgcolor(white) ///
	ytitle("Var(log-income)") ///
	xtitle("age")  ///
	xlabel(25(5)60) ///
	ylabel(0(.25)1.0 , nogrid)  ///
	legend(order( 1 "Market Income" 2 "Disposable Income" 3 "Family Disposable Income"))
	graph export ./figures/AgeProfile_Var_y_`edu'.eps, replace	

* Average Profile: Variance Family and Individual Income (residual)
graph twoway  (line VRimarket_age age if education == `edu') ///
           || (line VRidisp_age   age if education == `edu') ///
	   || (line VRfdisp_age age if education == `edu'), plotregion(lcolor(black))  graphregion(color(white)) bgcolor(white) ///
	ytitle("Var(y)") ///
	xtitle("age")  ///
	xlabel(25(5)60) ///
	ylabel(0(0.25)1.0 , nogrid)  ///
	legend(order( 1 "Market Income" 2 "Disposable Income" 3 "Family Disposable Income"))
	graph export ./figures/AgeProfile_Var_Residual_y_`edu'.eps, replace	
				
* Average Profile: Fraction of married couples
graph twoway (line married_age age if education == `edu'), plotregion(lcolor(black))  graphregion(color(white)) bgcolor(white) ///
	ytitle("marriage-rate") ///
	xtitle("age")   ///
	xlabel(25(5)60) ///
	ylabel(0.3(.1)1.0 , nogrid) 
	graph export ./figures/AgeProfile_married_`edu'.eps, replace	
			
}	



* ========================= EXPORT DATA ==============================================
* Export Average Profiles
* Collapse observations
duplicates drop age education, force
outsheet age education imarket_age idisp_age fmarket_age fdisp_age     using ./moments/AgeProfiles.csv, comma replace
outsheet age education Vimarket_age Vidisp_age Vfmarket_age Vfdisp_age using ./moments/AgeProfilesVariances.csv, comma replace


* ============================= Working Wives ==========================================
clear
use baseline_sample

* Keep only couples
keep if married == 1

* Percentage of working wifes of married couples
gen indicator_workingwife = 0
replace indicator_workingwife = 1 if (market_w > 0 & market_w !=.)
by byear education age, sort: egen workFemale_age_cohort = mean(indicator_workingwife)

*----------- Collapse observations: Only one observation per cohort, age and education -------------------  
duplicates drop byear age education, force

* Compute average profile
by  education age, sort: egen workFemale_age   = mean(workFemale_age_cohort) 


* ---------------------- Cohort-Specific profile ------------------------------------------------------------

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
		
			
graph twoway (line workFemale_age_cohort age if byear == 1925 & education == `edu') ///
           ||(line workFemale_age_cohort age if byear == 1930 & education == `edu') ///
	   ||(line workFemale_age_cohort age if byear == 1935 & education == `edu') ///
	   ||(line workFemale_age_cohort age if byear == 1940 & education == `edu') ///
	   ||(line workFemale_age_cohort age if byear == 1945 & education == `edu') ///
	   ||(line workFemale_age_cohort age if byear == 1950 & education == `edu') ///
	   ||(line workFemale_age_cohort age if byear == 1955 & education == `edu') ///
	   ||(line workFemale_age_cohort age if byear == 1960 & education == `edu'), plotregion(lcolor(black)) graphregion(color(white)) bgcolor(white) ///
	ytitle("LFP-rate") ///	 
	ylabel(0.0(.2)1.0 , nogrid) ///
	xlabel(25(5)60) ///
	xtitle("age") ///
	legend(order( 1 "1925" 2 "1930" 3 "1935" 4 "1940" 5 "1945" 6 "1950" 7 "1955" 8 "1960"))
	graph export ./figures/AgeProfile_wivesworking_cohort_`edu'.eps, replace			

			
		
}

* --------------- Average Profiles --------------------------------------------------------------------------------
* Collapse observations
duplicates drop age education, force
sort education age


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
		
			
* Average Profile: Fraction of wives working
graph twoway (line workFemale_age age if education == `edu'), plotregion(lcolor(black))  graphregion(color(white)) bgcolor(white) ///
	xlabel(25(5)60) ///
	ytitle("LFP-rate") ///
        xtitle("age") ///
	ylabel(0.0(.2)1.0 , nogrid) 
	graph export ./figures/AgeProfile_wivesworking_`edu'.eps, replace	
				
		
}

	
exit
