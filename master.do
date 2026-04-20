****************************************************
* MASTER DO FILE
* Reproducibility Pipeline
****************************************************

****************************************************
* MASTER DO FILE
* Reproducibility Pipeline
****************************************************

clear all
set more off
version 17

timer on 1

global root "`c(pwd)'"

cap mkdir "$root/data/cleaned"
cap mkdir "$root/output"
cap mkdir "$root/output/tables"
cap mkdir "$root/output/figures"
cap mkdir "$root/logs"

log using "$root/logs/master.log", replace text

di "Starting reproducibility pipeline..."

capture noisily do "$root/do/01_setup.do"
if _rc {
    di as error "01_setup.do failed"
    exit 1
}

di "Running data cleaning..."
capture noisily do "$root/do/02_clean.do"
if _rc {
    di as error "02_clean.do failed"
    exit 1
}

di "Running variable construction..."
capture noisily do "$root/do/03_construct_variables.do"
if _rc {
    di as error "03_construct_variables.do failed"
    exit 1
}

di "Running descriptive analysis..."
capture noisily do "$root/do/04_descriptive.do"
if _rc {
    di as error "04_descriptive.do failed"
    exit 1
}

di "Running event study..."
capture noisily do "$root/do/05_event_study.do"
if _rc {
    di as error "05_event_study.do failed"
    exit 1
}

di "Running DiD regressions..."
capture noisily do "$root/do/06_did_regressions.do"
if _rc {
    di as error "06_did_regressions.do failed"
    exit 1
}

log close

timer off 1
timer list

display "Pipeline completed successfully."
