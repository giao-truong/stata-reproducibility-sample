****************************************************
* 06_did_regressions.do
* Project: SSC Reform and Employment (Finland)
* Purpose: Estimate DiD models
****************************************************

di "Running DiD regressions..."

use "$root/data/cleaned/panel_with_treatment.dta", clear

****************************************************
* Sample restrictions and panel setup
****************************************************

* Restrict analysis period
keep if inrange(year, 1998, 2016)

* Verify panel structure
isid muni_number year
xtset muni_number year

****************************************************
* Construct time indicators
****************************************************

gen exp1 = inrange(year, 2003, 2011)
gen exp2 = (year >= 2012)
gen recession = inrange(year, 2009, 2011)

gen wave1 = (treat_year == 2003)
gen wave2 = (treat_year == 2005)

****************************************************
* DiD for employment
****************************************************

preserve
eststo clear

* Model 1: baseline
eststo m1: xtreg employment ///
i.wave1#i.exp1 ///
i.wave2#i.exp1 ///
i.treated#i.recession ///
i.treated#i.exp2 ///
i.year if !missing(treated), ///
fe cluster(muni_number)

* Model 2: with controls
eststo m2: xtreg employment ///
i.wave1#i.exp1 ///
i.wave2#i.exp1 ///
i.treated#i.recession ///
i.treated#i.exp2 ///
tax_income government_subsidies profit ///
i.year if !missing(treated), ///
fe cluster(muni_number)

* Model 3: dynamic DiD
eststo m3: xtreg employment ///
i.year##i.treated ///
tax_income government_subsidies profit ///
if !missing(treated), ///
fe cluster(muni_number)

* Joint significance test
testparm i.year#i.treated
local f_stat = r(F)
local f_p    = r(p)

estadd scalar joint_F = `f_stat'
estadd scalar joint_p = `f_p'

* Export results
esttab m1 m2 m3 using "$root/output/tables/employment_results.rtf", replace ///
cells("b(star fmt(3)) se(fmt(3))") ///
se star(* 0.10 ** 0.05 *** 0.01) ///
compress label ///
title("Effect of Payroll Tax Reform on Employment") ///
stats(joint_F joint_p N r2_w, ///
labels("Joint F-test" "Prob > F" "Observations" "R-squared (within)") ///
fmt(3 4 0 3)) ///
drop(*.year) ///
addnotes("Municipality and year fixed effects included", ///
"Standard errors clustered at municipality level")

restore

****************************************************
* DiD for unemployment
****************************************************

preserve
eststo clear

eststo m1: xtreg unemployment ///
i.wave1#i.exp1 ///
i.wave2#i.exp1 ///
i.treated#i.recession ///
i.treated#i.exp2 ///
i.year if !missing(treated), ///
fe cluster(muni_number)

eststo m2: xtreg unemployment ///
i.wave1#i.exp1 ///
i.wave2#i.exp1 ///
i.treated#i.recession ///
i.treated#i.exp2 ///
tax_income government_subsidies profit ///
i.year if !missing(treated), ///
fe cluster(muni_number)

eststo m3: xtreg unemployment ///
i.year##i.treated ///
tax_income government_subsidies profit ///
if !missing(treated), ///
fe cluster(muni_number)

testparm i.year#i.treated
local f_stat = r(F)
local f_p    = r(p)

estadd scalar joint_F = `f_stat'
estadd scalar joint_p = `f_p'

esttab m1 m2 m3 using "$root/output/tables/unemployment_results.rtf", replace ///
cells("b(star fmt(3)) se(fmt(3))") ///
se star(* 0.10 ** 0.05 *** 0.01) ///
compress label ///
title("Effect of Payroll Tax Reform on Unemployment") ///
stats(joint_F joint_p N r2_w, ///
labels("Joint F-test" "Prob > F" "Observations" "R-squared (within)") ///
fmt(3 4 0 3)) ///
drop(*.year) ///
addnotes("Municipality and year fixed effects included", ///
"Standard errors clustered at municipality level")

restore

di "DiD regressions completed."
