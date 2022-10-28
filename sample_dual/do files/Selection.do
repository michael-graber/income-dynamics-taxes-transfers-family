/*---------------------------------------------------------------------------------
  
This file creates the 
	
	            DUAL EARNER SAMPLE 
		    
        we use for our analysis. The selection criteria are as follows:
	(a) Norwegian males
	*(b) married*
	(c) born between 1925 and 1964,
	(d) age 25-60
	(e) both are not self-employed 
	(f) market and disposable income must be positive
	*(g) spouse's market and disposable income mus tbe positive*
	(h) at least 4 consecutive observations
	
----------------------------------------------------------------------------------*/
	

/*              Male  who are married and not immigrants and residents in Norway
--------------------------------------------------------------------------------------*/ 
drop if (invkat ==  "B") | (invkat == "E") | (invkat == "G") 

* Drop observations when the individual was not married
drop if (spouse_lnr == "")
 	
/*                       Birth year restriction and Age restriction
--------------------------------------------------------------------------------------------*/
keep if byear > 1924 & byear < 1965 
gen age = year - byear	
keep if age >= 25 & age <= 60

* keep only those observations where we have zero income from self-employment
keep if self   == 0
keep if self_w == 0

* Drop Zero-Income or missing income observations for both male and spouse (dual earner)
drop if (market <= 0)        | (market == .) 
drop if (market_w <= 0)      | (market_w == .)   
drop if (disp_income <= 0)   | (disp_income == .)
drop if (disp_income_w <= 0) | (disp_income_w == . )

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

*---------------------- DUAL EARNER SAMPLE SAVE --------------------------------------------------------------------
* Save selected sample 
save DualEarner_sample, replace	

exit

