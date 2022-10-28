


* load Marginal Tax Rates
use ./output/stata/MarginalTaxRates2006, clear

graph twoway (line MargTaxRate IncomeSinglePerson) /// 
          || (line MargTaxRate_couple IncomeSingleEarnerCouple), plotregion(lcolor(black)) graphregion(color(white)) bgcolor(white) ///
xtitle("Income (2001 NOK)")  ///
xscale( r(0 1100000)) ///
ylabel(0 (10) 50 , nogrid) ///
ytitle("Marginal tax rate (%)") ///
legend(order ( 1 "Single person, 2006" 2 "Single earner couple, 2006")) 
graph export ./output/stata/figures/TaxRates/MarginalTaxRates2006.eps, replace
