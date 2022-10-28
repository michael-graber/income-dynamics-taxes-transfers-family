/*---------------------------------------------------------------------------------

This file computes E(y_t|stay=t+1,t<t_max_cohort) and E(y_t|leave=t+1,t<t_max_cohort)
where leave = t+1 means that we do not observe any income for an individual 
	
		
----------------------------------------------------------------------------------*/

clear 
use baseline_sample

* Create a temporary variable that indicates the age until which we observe a cohort
bysort byear: egen age_max_cohort = max(age)

* Create a dummy variable that indicates if individual is observed next period
sort lnr year
gen d_stay = .
replace d_stay = 1 if (lnr[_n] == lnr[_n+1] & year[_n]+1 == year[_n+1] & age < age_max_cohort) // y_t is observed next period
replace d_stay = 0 if (lnr[_n] != lnr[_n+1] & age < age_max_cohort) | (lnr[_n] == lnr[_n+1] & year[_n]+1 != year[_n+1] & age < age_max_cohort)    // last observation before leaving or last observation before leaving, but individual returns later on again.

*----------------- Definition: Early Exits ----------------------------------------------

* Declare as Panel data
sort lnr age
xtset lnr age

* Compute a simple moving average of log-income (with education-specific time effect removed): mean(current income + L.income + L2.income)
tssmooth ma y_market_MA2_noTE   = y_market_noTE, window(2 1)

* ------------------- Levels ---------------------------------------------------------------------------------------------------

* Compute E(y_t|age,cohort,education,d_stay) where y_t is log income with education-specific time effect removed
by byear age education d_stay, sort: egen market_age_cohort_edu_stay    = mean(y_market_noTE)    


* Compute MA2(y_t|age,cohort,education,d_stay) where y_t is log income
by byear age education d_stay, sort: egen market_MA2_age_cohort_edu_stay    = mean(y_market_MA2_noTE)     

* =============================== Average over Cohorts ==================================================================

*----------- Collapse observations: Only one observation per cohort, age, education and indicator-exit -------------------  
duplicates drop byear age education d_stay, force

* ------------------------------- Levels --------------------------------------------------------------------------------


* Compute E(y_t|age,cohort,education,d_stay) where y_t is log income
by age education d_stay, sort: egen market_age_edu_stay    = mean(market_age_cohort_edu_stay)    

* Compute MA2(y_t|age,cohort,education,d_stay) where y_t is actual log income
by age education d_stay, sort: egen market_MA2_age_edu_stay    = mean(market_MA2_age_cohort_edu_stay )     

* Collapse observations
duplicates drop age education d_stay, force
sort education age 


* -------------------------- Plot Profiles at the end of the life Cycle ----------------------------------------------

drop if age < 45

forvalues edu =1/3 {

	if `edu' == 1 {
		local skill "Low-Skilled"
		}
	else if `edu' == 2 {
		local skill "Medium-Skilled"
		}
	else if `edu' == 3 {
		local skill "High-Skilled"
		}
		
		
* ---------------------------- Levels ------------------------------------------------------
		
* Profile Individual Market Income
graph twoway (line  market_age_edu_stay      age if education == `edu'  & d_stay == 1) ///
          || (line  market_MA2_age_edu_stay  age if education == `edu'  & d_stay == 1) /// 
          || (line  market_age_edu_stay      age if education == `edu'  & d_stay == 0)  ///
	  || (line  market_MA2_age_edu_stay  age if education == `edu'  & d_stay == 0), plotregion(lcolor(black)) graphregion(color(white)) bgcolor(white) ///
	ytitle("Individual market income") ///
	ylabel(10.0(.5)12.6 , nogrid) /// 
	xlabel(45(5)60) ///
	legend(order( 1 "E(y|staying next year)" 2 "MA(2) in y|staying next year" 3 "E(y|exiting next year)" 4 "MA(2) in y|exiting next year"))
	graph export ./figures/Selection_individual_market_end_of_lcycle`edu'.eps, replace		
				
}	

exit

