/*---------------------------------------------------------------------------------
     
This file creates and exports some summary statistics regarding the sample size
	
----------------------------------------------------------------------------------*/

* Load Baseline Sample
use DualEarner_sample, clear

*Calculate number of observations at a given age and education and export as csv file
tabulate age education, matcell(x) 
mat2txt2 x using ./moments/observations_age_education.csv, replace
* Structure of csv table: rows: age [25:60], columns: [low-skilled, medium-skilled, high-skilled]

* Calculate number of observations at a given year and education and export as csv file
tabulate year education, matcell(y)
mat2txt2 y using ./moments/observations_year_education.csv, replace
* Structure of csv table: rows: year [1967:2006], columns: [low-skilled, medium-skilled, high-skilled]

* Calculate sample size (number of individuals and number of individuals per cohort)
* collapse dataset
duplicates drop lnr, force // only one observation per individual
tabulate byear, matcell(z)
mat2txt2 z using ./moments/samplesize_cohort.csv, replace
* Structure of csv table: rows: birthyear [1925:1964], column: number of individuals

tabulate education, matcell(xx)
mat2txt2 xx using ./moments/samplesize_education.csv, replace
* Structure of csv table: rows: skill level[low-skilled,medium-skilled,high-skilled], column: number of individuals

exit

