/*===========================================================
        Gap in GDP and the Variance of Permanent Shocks
		       Entering the Labour Market
			   
		 Author: Michael Graber
		
============================================================*/

* load cohort-specific results 
use ./output/results, clear

keep if (cohort == 1956 | cohort == 1962)
keep if model     == "model_baseline"
keep if sample    == "sample_baseline"
keep if income    == "market"
keep if education == "pooled"

gen year = cohort + age		
merge m:1 year using ./output/stata/magne_gdp	
keep if _merge == 3
		
* Figure
graph twoway (line sigma2 age if cohort == 1956) || (line sigma2 age if cohort == 1962), name(Sigma2_1956_1962)  plotregion(lcolor(black)) graphregion(color(white)) bgcolor(white) ///
xlabel(25 (5) 55) ///
ylabel(0 (0.05) 0.15, nogrid) ///
xtitle("age")  ///
ytitle("var(u{superscript:c}{subscript:i,a})") ///
legend(off) 
		
graph twoway (line hp_linb_gdp_20001600_1 age if cohort == 1956) ||  (line hp_linb_gdp_20001600_1 age  if cohort == 1962), name(D_GDP_1956_1962)  plotregion(lcolor(black)) graphregion(color(white)) bgcolor(white) ///
ytitle("gap in log-GDP") ///
xscale(r(20,60)) ///
yscale(r(-.1,.1)) ///
ylabel(-.1(.05).1, nogrid) ///
legend(order( 1 "1956" 2 "1962")) ///
xlabel(20(10)60)
	
graph combine Sigma2_1956_1962 D_GDP_1956_1962, xcommon	cols(1)
graph export ./output/stata/figures/BusinessCycle/GapinGDP_pooled_1956_1962_market.eps, replace
graph drop _all
		
exit
