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


*save temporary dataset (non-immigrants, between age 25 and 65, non-missing income)
drop if  (market == .) |  (disp_income == .) 

* keep only those observations where we have zero income from self-employment
keep if self == 0

*Age Restriction: 25-60
keep if age >= 25 & age <= 60

* Drop Zero-Income observations
drop if (market <= 0) |  (market_fam <= 0) | (disp_income <= 0) |  (disp_income_fam <= 0)


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

exit

