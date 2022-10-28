/*---------------------------------------------------------------------------------
This file creates

- a variable 'education' = {1 (=low-skilled) , 2(=medium skilled) and 3 (=high-skilled)

and computes 
		  
- the family size
- total family income
		     
and creates a 
		   
- dummy for marital status
		   	
----------------------------------------------------------------------------------*/

*--------------------------- Cohort Variable / Birth year ---------------------------------------
quietly replace byear = byear + 1900


* ----------------------- Family-related variables --------------------------------

* Family Size
gen famsize = 1 + children + (spouse_lnr != "")   // men + # children + 1(wife=true)

* Dummy : marital status
gen married = (spouse_lnr != "") 

* Family Income
gen disp_income_fam = .
replace disp_income_fam =                   disp_income if (spouse_lnr == "") // unmarried individuals
replace disp_income_fam = (disp_income + disp_income_w) if (spouse_lnr != "") //  married individuals

gen market_fam = .
replace market_fam =              market if (spouse_lnr == "") // unmarried individuals
replace market_fam = (market + market_w) if (spouse_lnr != "") //  married individuals

* Husband's share of income
gen share_market = market/market_fam
gen share_disp   = disp_income/disp_income_fam

*----------------------- Education Levels -------------------------------------------
gen education = .

replace education = 1 if edul == 1 | edul == 2
replace education = 2 if edul == 3 | edul == 4 | edul == 5
replace education = 3 if edul == 6 | edul == 7 | edul == 8

exit 

 

