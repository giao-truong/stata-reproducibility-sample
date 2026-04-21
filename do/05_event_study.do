****************************************************
* 05_event_study.do
* Project: SSC Reform and Employment (Finland)
* Purpose: Event study and dynamic DiD analysis
****************************************************

di "Running event study analysis..."

use "$root/data/cleaned/panel_with_treatment.dta", clear

*******************************************************
* 1. Pre-trends and dynamic patterns (baseline = 2002)
*******************************************************

*** Employment ***

preserve

* Construct weights based on 2002 baseline
bysort muni_number: egen muni_weight = max(cond(year==2002, employment, .))

* Validate weights
count if missing(muni_weight)
assert r(N) == 0

* Event study estimated separately by group to assess pre-trends

xtreg employment ib2002.year [pw=muni_weight] if group == 1, fe cluster(muni_number)
estimates store treat1

xtreg employment ib2002.year [pw=muni_weight] if group == 2, fe cluster(muni_number)
estimates store treat2

xtreg employment ib2002.year [pw=muni_weight] if group == 3, fe cluster(muni_number)
estimates store control

coefplot ///
(treat1, label("Treatment 2003") msymbol(T) mcolor(maroon) lcolor(maroon) recast(connected)) ///
(treat2, label("Treatment 2005") msymbol(D) mcolor(navy) lcolor(navy) recast(connected)) ///
(control, label("Control") msymbol(s) mcolor(gs10) lcolor(gs10) recast(connected)), ///
keep(*.year) vertical baselevels noci nooffsets ///
xlabel(, labsize(small)) ///
yline(0, lcolor(gs12)) ///
xline(2003 2005 2011, lp(dash) lc(gs8)) ///
legend(position(6) rows(1)) ///
title("Employment Rate (Event Study)")

graph display
graph export "$root/output/figures/event_study_employment.png", replace

restore

---

*** Unemployment ***

preserve

bysort muni_number: egen muni_weight = max(cond(year==2002, unemployment, .))

count if missing(muni_weight)
assert r(N) == 0

* Event study estimated separately by group to assess pre-trends

xtreg unemployment ib2002.year [pw=muni_weight] if group == 1, fe cluster(muni_number)
estimates store treat1

xtreg unemployment ib2002.year [pw=muni_weight] if group == 2, fe cluster(muni_number)
estimates store treat2

xtreg unemployment ib2002.year [pw=muni_weight] if group == 3, fe cluster(muni_number)
estimates store control

coefplot ///
(treat1, label("Treatment 2003") msymbol(T) mcolor(maroon) lcolor(maroon) recast(connected)) ///
(treat2, label("Treatment 2005") msymbol(D) mcolor(navy) lcolor(navy) recast(connected)) ///
(control, label("Control") msymbol(s) mcolor(gs10) lcolor(gs10) recast(connected)), ///
keep(*.year) vertical baselevels noci nooffsets ///
xlabel(, labsize(small)) ///
yline(0, lcolor(gs12)) ///
xline(2003 2005 2011, lp(dash) lc(gs8)) ///
legend(position(6) rows(1)) ///
title("Unemployment Rate (Event Study)")

graph display
graph export "$root/output/figures/event_study_unemployment.png", replace

restore

******************************************************
* 2. Year-specific treatment effects (baseline = 2002)
******************************************************

*** Employment ***

preserve

forval y = 1998/2016 {
    if `y' != 2002 {
        gen did_`y' = (treated == 1 & year == `y')
    }
}

xtreg employment did_* i.year, fe cluster(muni_number)

coefplot, keep(did_*) vertical ///
recast(connected) ///
yline(0, lcolor(black)) ///
xline(2003 2005 2011, lp(dash)) ///
title("Dynamic DiD: Employment")

graph display
graph export "$root/output/figures/did_coefficients_employment.png", replace

restore

---

*** Unemployment ***

preserve

forval y = 1998/2016 {
    if `y' != 2002 {
        gen did_`y' = (treated == 1 & year == `y')
    }
}

xtreg unemployment did_* i.year, fe cluster(muni_number)

coefplot, keep(did_*) vertical ///
recast(connected) ///
yline(0, lcolor(black)) ///
xline(2003 2005 2011, lp(dash)) ///
title("Dynamic DiD: Unemployment")

graph display
graph export "$root/output/figures/did_coefficients_unemployment.png", replace

restore

di "Event study analysis completed."
