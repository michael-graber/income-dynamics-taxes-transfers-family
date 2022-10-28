

* load Marginal Tax Rates
use ./output/stata/AverageTaxRates_SinglePerson, clear

graph twoway (line tau_2006 y_2006 if y_2006 <= 1100000) ///
          || (line tau_2004 y_2004 if y_2004 <= 1100000) ///
		  || (line tau_2001 y_2001 if y_2001 <= 1100000) ///
		  || (line tau_1994 y_1994 if y_1994 <= 1100000) ///
		  || (line tau_1979 y_1979 if y_1979 <= 1100000), plotregion(lcolor(black)) graphregion(color(white)) bgcolor(white)  ///
xtitle("Income (2001 NOK)")  /// 
xscale( r(0 1100000)) ///
ylabel(0 (10) 80, nogrid) ///
ytitle("Average tax rate (%)") ///
legend(order ( 1 "Single person, 2006" 2 "Single person, 2004" 3 "Single person, 2001" 4 "Single person, 1994" 5 "Single person, 1979" )) 
graph export ./output/stata/figures/TaxRates/AverageTaxRatesSinglePerson.eps, replace

use ./output/stata/AverageTaxRates_SingleEarnerCouple, clear

graph twoway (line tau_2006 y_2006 if y_2006 <= 1100000) ///
          || (line tau_2004 y_2004 if y_2004 <= 1100000) ///
		  || (line tau_2001 y_2001 if y_2001 <= 1100000) ///
		  || (line tau_1994 y_1994 if y_1994 <= 1100000) ///
		  || (line tau_1979 y_1979 if y_1979 <= 1100000), plotregion(lcolor(black)) graphregion(color(white)) bgcolor(white) ///
xtitle("Income (2001 NOK)")  ///
ylabel(0 (10) 80, nogrid) ///
xscale( r(0 1100000)) ///
ytitle("Average tax rate (%)") ///
legend(order ( 1 "Single earner couple, 2006" 2 "Single earner couple, 2004" 3 "Single earner couple, 2001" 4 "Single earner couple, 1994" 5 "Single earner couple, 1979" )) 
graph export ./output/stata/figures/TaxRates/AverageTaxRatesSingleEarnerCouple.eps, replace

