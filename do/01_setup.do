****************************************************
* 01_setup.do
* Project: SSC Reform and Employment (Finland)
* Purpose: Ensure reproducible environment
****************************************************

****************************************************
* 01_setup.do
* Project: SSC Reform and Employment (Finland)
* Purpose: Ensure reproducible environment
****************************************************

version 17
set more off

****************************************************
* Version check
****************************************************

if c(version) < 17 {
    di as error "This project requires Stata 17 or higher."
    exit 1
}

****************************************************
* Reproducibility settings
****************************************************

set seed 12345

****************************************************
* Install required packages (if missing)
****************************************************

* estout (esttab, eststo, estadd)
cap which esttab
if _rc {
    di "Installing estout..."
    quietly ssc install estout
}

* coefplot
cap which coefplot
if _rc {
    di "Installing coefplot..."
    quietly ssc install coefplot
}

* outreg2 (optional fallback)
cap which outreg2
if _rc {
    di "Installing outreg2..."
    quietly ssc install outreg2
}

****************************************************
* Verify installation
****************************************************

di "Checking installed packages:"

di "esttab:"
which esttab

di "coefplot:"
which coefplot

di "outreg2:"
which outreg2

****************************************************
* Done
****************************************************

display "Setup completed successfully."
