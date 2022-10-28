/*---------------------------------------------------------------------------------
  
This file creates the 
	
	            BASELINE SAMPLE 
		    
        we use for our analysis. The selection criteria are as follows:
	(a) Norwegian males 
	(b) either single or married
	(c) born between 1925 and 1964,
	(d) age 25-60
	(e) not self-employed 
	(f) market and disposable income must be positive 
	(g) at least 4 consecutive observations
	
----------------------------------------------------------------------------------*/
	

/*              Male  who are not immigrants and residents in Norway
--------------------------------------------------------------------------------------*/ 
drop if (invkat ==  "B") | (invkat == "E") | (invkat == "G") 

 	
/*                       Birth year restriction and Age restriction
--------------------------------------------------------------------------------------------*/

keep if byear > 1924 & byear < 1965 
gen age = year - byear	

* we plot below the percentage of zero-income observations up to the age of 65
* thus we will drop observations with age > 60 further below  
keep if age >=25 & age <= 65

*save temporary dataset (non-immigrants, between age 25 and 65, non-missing income (not equivalent to zero-income)
drop if  (market == .) |  (disp_income == .) 
save temp, replace 


/*                       Self-employment restriction
--------------------------------------------------------------------------------------------*/		

* calculate percentage of self-employment by age and education
bysort age education: egen selfempl_perc_edu   = mean(self > 0)
bysort age          : egen selfempl_perc_total = mean(self > 0) 

sort age education

* Collapse dataset
duplicates drop age education, force

graph twoway (line selfempl_perc_total age) ///
          || (line selfempl_perc_edu age if education == 1) ///
          || (line selfempl_perc_edu age if education == 2) ///
          || (line selfempl_perc_edu age if education == 3), plotregion(lcolor(black)) graphregion(color(white)) bgcolor(white)  ///
              ytitle("self-employment-rate") ///
              xtitle("age") ///
              ylabel(0(.1).3, nogrid) ///
              xscale(r(25,65)) ///
              legend(order( 1 "Total" 2 "Low-Skilled" 3 "Medium-Skilled" 4 "High-Skilled"))
              graph export ./figures/SelfEmployment.eps, replace

* reload temporary dataset (non-immigrants, age 25-65, born between 1925 and 1964, non-missing income)
use temp, clear
* keep only those observations where we have zero income from self-employment
keep if self == 0
* save temporary dataset (non-immigrants, age 25-65, born between 1925 and 1964, non-missing income, non selfemployment)
save temp, replace
		
/*                       Income Restriction
--------------------------------------------------------------------------------------------*/

* calculate percentage of zero-market income by age and education
bysort age education: egen zeromarket_perc_edu   = mean(market == 0)
bysort age          : egen zeromarket_perc_total = mean(market == 0) 

bysort age education: egen nonzeromarket_perc_edu  = mean(market > 0)
bysort age          : egen nonzeromarket_perc_total= mean(market > 0)

sort age education

* Collapse dataset
duplicates drop age education, force

graph twoway (line zeromarket_perc_total age) ///	
          || (line zeromarket_perc_edu age if education == 1) ///
          || (line zeromarket_perc_edu age if education == 2) ///
          || (line zeromarket_perc_edu age if education == 3), plotregion(lcolor(black)) graphregion(color(white)) bgcolor(white)  ///
              ytitle("Non-Participation Rate") ///
              xtitle("age")   ///
              ylabel(0(.1).6, nogrid) ///
              xscale(r(25,65)) ///
              legend(order( 1 "Total" 2 "Low-Skilled" 3 "Medium-Skilled" 4 "High-Skilled"))
              graph export ./figures/ZeroIncome.eps, replace
	      
	      
graph twoway (line nonzeromarket_perc_total age) ///	
          || (line nonzeromarket_perc_edu age if education == 1) ///
          || (line nonzeromarket_perc_edu age if education == 2) ///
          || (line nonzeromarket_perc_edu age if education == 3), plotregion(lcolor(black)) graphregion(color(white)) bgcolor(white)  ///
              ytitle("Participation Rate") ///
              xtitle("age")   ///
              ylabel(.0(.1)1, nogrid) ///
              xscale(r(25,65)) ///
              legend(order( 1 "Total" 2 "Low-Skilled" 3 "Medium-Skilled" 4 "High-Skilled"))
              graph export ./figures/NonZeroIncome.eps, replace
		      
clear
use temp 

*Age Restriction: 25-60
keep if age >= 25 & age <= 60

* Drop Zero-Income observations
drop if (market <= 0) |  (market_fam <= 0) | (disp_income <= 0) |  (disp_income_fam <= 0)
* save temporary dataset (non-immigrants, age 25-65, born between 1925 and 1964, non-missing, positive income, non self-employment)
save temp, replace

/*                       At least 4 consecutive observations
--------------------------------------------------------------------------------------------*/
* Declare as Panel data
xtset lnr age

* Spells of consecutive values of age
tsspell, fcond(L.age == .)

* Calculate duration of each spell
egen age_max_spell  = max(age), by(lnr _spell)
egen age_min_spell  = min(age), by(lnr _spell)
gen spell_duration  = age_max_spell - age_min_spell + 1


* Drop all those spells with less than 4 observations
drop if spell_duration < 4
  
/*                       Education Variable: Non-missings
--------------------------------------------------------------------------------------------*/
drop if education == .

*---------------------- BASELINE SAMPLE SAVE --------------------------------------------------------------------
* Save selected sample 
save baseline_sample, replace	

rm ./temp.dta

exit

