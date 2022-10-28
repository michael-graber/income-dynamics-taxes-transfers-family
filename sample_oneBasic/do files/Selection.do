/*---------------------------------------------------------------------------------
  
This file creates the 
	
	            >1 BASIC AMOUNT SAMPLE 
		    
        we use for our analysis. The selection criteria are as follows:
	(a) Norwegian males 
	(b) either single or married
	(c) born between 1925 and 1964,
	(d) age 25-60
	(e) not self-employed 
	(f) market and disposable income must be positive and market income must be at least 1 basic amount
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


/*                       Self-employment restriction
--------------------------------------------------------------------------------------------*/		

* keep only those observations where we have zero income from self-employment
keep if self == 0
		
/*                       Income Restriction
--------------------------------------------------------------------------------------------*/

* Dataset loaded: Norwegian males, born between 1925 and 1964, age 25-65, not self-employed, non-missing income

* Drop Zero-Income observations
drop if (market <= 0) |  (market_fam <= 0) | (disp_income <= 0) |  (disp_income_fam <= 0)

* keep only observations that are at least 1 basic amount
* generate variable that gives the basic amount in a given year (see email Magne)
gen basic = .
replace basic = 5400 if year == 1967
replace basic = 5900 if year == 1968
replace basic = 6400 if year == 1969
replace basic = 6800 if year == 1970
replace basic = 7400 if year == 1971
replace basic = 7900 if year == 1972
replace basic = 8500 if year == 1973
replace basic = 9533 if year == 1974
replace basic = 10800 if year == 1975
replace basic = 12000 if year == 1976
replace basic = 13383 if year == 1977
replace basic = 14550 if year == 1978
replace basic = 15200 if year == 1979
replace basic = 16633 if year == 1980
replace basic = 18658 if year == 1981
replace basic = 20667 if year == 1982
replace basic = 22333 if year == 1983
replace basic = 23667 if year == 1984
replace basic = 25333 if year == 1985
replace basic = 27433 if year == 1986
replace basic = 29267 if year == 1987
replace basic = 30850 if year == 1988
replace basic = 32275 if year == 1989
replace basic = 33575 if year == 1990
replace basic = 35033 if year == 1991
replace basic = 36167 if year == 1992
replace basic = 37033 if year == 1993
replace basic = 37820 if year == 1994
replace basic = 38847 if year == 1995
replace basic = 40410 if year == 1996
replace basic = 42000 if year == 1997
replace basic = 45370 if year == 1998
replace basic = 46950 if year == 1999
replace basic = 48377 if year == 2000
replace basic = 50603 if year == 2001
replace basic = 53233 if year == 2002
replace basic = 55964 if year == 2003
replace basic = 58139 if year == 2004
replace basic = 60059 if year == 2005
replace basic = 62161 if year == 2006
replace basic = 65505 if year == 2007
replace basic = 69108 if year == 2008
replace basic = 72006 if year == 2009
replace basic = 74721 if year == 2010
replace basic = 78024 if year == 2011

* Select only those income observations that are above 1 basic amount
keep if market > basic

/*                      Age Restriction: 25-60
--------------------------------------------------------------------------------------------*/

keep if age >= 25 & age <= 60

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


*---------------------- SAVE SAMPLE --------------------------------------------------------------------
* Save selected sample
save work_1basic_sample, replace


exit

