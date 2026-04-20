****************************************************
* 03_construct_variables.do
* Project: SSC Reform and Employment (Finland)
* Purpose: Ensure reproducible environment
****************************************************

****************************************************
* 03_construct_variables.do
* Project: SSC Reform and Employment (Finland)
* Purpose: Define treatment and control groups
****************************************************

di "Constructing treatment and control variables..."

use "$root/data/cleaned/panel.dta", clear

****************************************************
* 1. CONTROL AREAS
****************************************************

gen control = 0

replace control = 1 if inlist(municipality, "Ii", "Iisalmi", "Kaavi", "Keminmaa", "Kiuruvesi")
replace control = 1 if inlist(municipality, "Kontiolahti", "Kuusamo", "Kärsämäki", "Lapinlahti", "Liminka")
replace control = 1 if inlist(municipality, "Liperi", "Muhos", "Pielavesi", "Polvijärvi", "Pudasjärvi")
replace control = 1 if inlist(municipality, "Pyhäjärvi", "Pyhäntä", "Ranua", "Siikalatva", "Simo")
replace control = 1 if inlist(municipality, "Sonkajärvi", "Taivalkoski", "Tervola", "Tohmajärvi", "Tornio")
replace control = 1 if inlist(municipality, "Tuusniemi", "Tyrnävä", "Utajärvi", "Vieremä")

****************************************************
* 2. TREATMENT AREAS (timing)
****************************************************

gen treat_year = .

* Wave 1 (2003)
local wave2003 "Enontekiö" "Inari" "Kemijärvi" "Kittilä" "Kolari" "Muonio" ///
               "Pelkosenniemi" "Pello" "Posio" "Salla" "Savukoski" ///
               "Sodankylä" "Utsjoki" "Ylitornio"

foreach m in `wave2003' {
    replace treat_year = 2003 if municipality == `"`m'"'
}

* Wave 2 (2005)
replace treat_year = 2005 if inlist(municipality, ///
"Kajaani", "Kuhmo", "Hyrynsalmi", "Paltamo", "Puolanka", ///
"Ristijärvi", "Sotkamo", "Suomussalmi", "Vaala")

****************************************************
* 3. Treatment indicator
****************************************************

gen treated = !missing(treat_year)

****************************************************
* 4. Validation checks (VERY IMPORTANT)
****************************************************

* Check overlap (should be zero)
count if treated == 1 & control == 1
assert r(N) == 0

* Check group sizes
tab treated

* Check treatment timing
tab treat_year if treated == 1

* Ensure no missing classification
count if missing(treated)
assert r(N) == 0

****************************************************
* Save dataset
****************************************************

save "$root/data/cleaned/panel_with_treatment.dta", replace

di "Variable construction completed successfully."
