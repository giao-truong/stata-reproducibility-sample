****************************************************
* 04_descriptive.do
* Project: SSC Reform and Employment (Finland)
* Purpose: Ensure reproducible environment
****************************************************

di "Running descriptive analysis..."

use "$root/data/cleaned/panel_with_treatment.dta", clear

****************************************************
* 1. Group definition
****************************************************

gen group = .
replace group = 1 if treat_year == 2003
replace group = 2 if treat_year == 2005
replace group = 3 if treated == 0

label define group_lbl 1 "Treatment 2003" 2 "Treatment 2005" 3 "Control"
label values group group_lbl

* Validation
tab group
assert !missing(group)

****************************************************
* 2. Descriptive statistics (baseline year)
****************************************************

tabstat employment unemployment income_tax_rate tax_income ///
government_subsidies no_schools ///
relative_debtness_people relative_debtness ///
age15_64_of_all profit ///
if year == 2002, by(group) stats(mean median sd n)

****************************************************
* 3. Pre-treatment trends
****************************************************

* Define graph styles ONCE
local opt1 "msymbol(T) mcolor(black) lcolor(black)"
local opt2 "msymbol(Dh) mcolor(black) lcolor(black)"
local opt3 "msymbol(S) mcolor(black) lcolor(black)"
local opt4 "msymbol(Oh) mcolor(black) lcolor(black)"

local lines "xtitle(year) ylabel(, angle(0) grid) ///
xlabel(1995(5)2015, grid) ///
xline(2003 2005 2011, lpattern(dash) lcolor(gs12)) ///
legend(off)"

****************************************************
* 3.1 National averages
****************************************************

preserve
collapse (mean) employment unemployment tax_income government_subsidies, by(year)
gen group = 4
tempfile national
save `national'
restore

****************************************************
* 3.2 Group averages
****************************************************

preserve
keep if inlist(group, 1, 2, 3)
collapse (mean) employment unemployment tax_income government_subsidies, by(group year)

append using `national'

****************************************************
* 3.3 Graphs
****************************************************

twoway ///
(connected employment year if group==1, `opt1') ///
(connected employment year if group==2, `opt2') ///
(connected employment year if group==3, `opt3') ///
(connected employment year if group==4, `opt4'), ///
title("Employment rate (%)") ytitle("%") ///
name(g1, replace) `lines'

twoway ///
(connected unemployment year if group==1, `opt1') ///
(connected unemployment year if group==2, `opt2') ///
(connected unemployment year if group==3, `opt3') ///
(connected unemployment year if group==4, `opt4'), ///
title("Unemployment rate (%)") ytitle("%") ///
name(g2, replace) `lines'

twoway ///
(connected tax_income year if group==1, `opt1') ///
(connected tax_income year if group==2, `opt2') ///
(connected tax_income year if group==3, `opt3') ///
(connected tax_income year if group==4, `opt4'), ///
title("Income tax revenue (€)") ytitle("€") ///
name(g3, replace) `lines'

twoway ///
(connected government_subsidies year if group==1, `opt1') ///
(connected government_subsidies year if group==2, `opt2') ///
(connected government_subsidies year if group==3, `opt3') ///
(connected government_subsidies year if group==4, `opt4'), ///
title("Government subsidies (€)") ytitle("€") ///
name(g4, replace) `lines'

****************************************************
* 4. Combine and export
****************************************************

graph combine g1 g2 g3 g4, cols(2) imargin(small) iscale(0.8) ///
note("▲ Treatment 2003   ◇ Treatment 2005   ■ Control   ○ National", ///
size(small) position(6))

graph display
graph export "$root/output/figures/descriptive.png", replace

restore

di "Descriptive analysis completed."
