****************************************************
* 02_clean.do
* Project: SSC Reform and Employment (Finland)
* Purpose: Ensure reproducible environment
****************************************************

di "Starting data cleaning..."

****************************************************
* Load base dataset
****************************************************

use "$root/data/raw/Employment.dta", clear

count
di "Initial observations (Employment): " r(N)

****************************************************
* Merge unemployment data
****************************************************

merge 1:1 municipality year using "$root/data/raw/Unemployment.dta"

tab _merge

* Ensure no unmatched using-only observations
assert _merge != 2

drop _merge

****************************************************
* Merge additional municipal data
****************************************************

merge 1:1 municipality year using "$root/data/raw/Additional_muni_data.dta"

tab _merge

assert _merge != 2

drop _merge

****************************************************
* Fix known data issues
****************************************************

* Correct municipality ID
replace muni_number = 445 if municipality == "Parainen"

* Drop missing IDs
count if missing(muni_number)
drop if missing(muni_number)

****************************************************
* Variable name correction (safe)
****************************************************

capture confirm variable goverment_subsidies
if !_rc {
    rename goverment_subsidies government_subsidies
}

****************************************************
* Panel validation
****************************************************

duplicates report municipality year

isid muni_number year

xtset muni_number year

****************************************************
* Final dataset check
****************************************************

count
di "Final observations: " r(N)

****************************************************
* Save cleaned dataset
****************************************************

save "$root/data/cleaned/panel.dta", replace

di "Data cleaning completed successfully."
