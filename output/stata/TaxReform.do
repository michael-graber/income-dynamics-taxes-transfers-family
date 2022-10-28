/*===========================================================
        Tax Reform and the Variance of Shocks
		    
			   
		 Author: Michael Graber
		
============================================================*/

* load cohort-specific results 
use ./output/results, clear

keep if model     == "model_baseline"
keep if education == "pooled"
keep if income    == "disposable"
keep if sample    == "sample_baseline"
keep if (cohort == 1944 | cohort == 1949 | cohort == 1954 | cohort == 1959 | cohort == 1964 )

sort age 

* Variance of Transitory Shocks
graph twoway (line omega2 age if cohort == 1944 & omega2 < 0.125) ///
           ||(line omega2 age if cohort == 1949 & omega2 < 0.125) ///
	   ||(line omega2 age if cohort == 1954 & omega2 < 0.125) ///
	   ||(line omega2 age if cohort == 1959 & omega2 < 0.125) ///
	   ||(line omega2 age if cohort == 1964 & omega2 < 0.125) ,  plotregion(lcolor(black)) graphregion(color(white)) bgcolor(white) ///
	xlabel(25 (5) 57) ///
	ylabel(0 (0.025) 0.125, nogrid) ///
	xtitle("age")  ///
	ytitle("var({&epsilon}{superscript:c}{subscript:i,a})") ///
	legend(order( 1 "1944" 2 "1949" 3 "1954" 4 "1959" 5 "1964")) 
	graph export ./output/stata/figures/TaxReform/TaxReform_disposable_pooled_TransitoryShocks.eps, replace
		

exit

