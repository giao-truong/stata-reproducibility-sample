# SSC Reform and Employment in Finland (2003–2011)

## 📌 Project Overview

This project evaluates the impact of reduced employer social security contributions (SSC) on municipal-level employment outcomes in Northern and Eastern Finland. The policy reform was implemented in two waves (2003 and 2005), allowing for a difference-in-differences (DiD) research design.

The analysis uses panel data at the municipality-year level and examines both employment and unemployment rates.

---

## 📊 Research Design

The empirical strategy is based on:

* Difference-in-Differences (DiD) estimation
* Event study analysis to assess pre-treatment trends
* Fixed effects panel regressions with municipality and year effects

Treatment is defined based on exposure to SSC reductions, with staggered implementation across municipalities.

---

## Repository Structure

* `master.do` — Main script to run the full pipeline

* `do/` — Modular scripts:

  * `01_setup.do` — Environment setup and package installation
  * `02_clean.do` — Data merging and cleaning
  * `03_construct_variables.do` — Treatment and control definitions
  * `04_descriptive.do` — Summary statistics and descriptive plots
  * `05_event_study.do` — Event study and dynamic DiD analysis
  * `06_did_regressions.do` — Main regression results

* `data/` — Data folders (raw data not included)

* `output/` — Generated tables and figures

* `logs/` — Execution logs

---

## ⚙️ Reproducibility

To reproduce the results:

1. Place the required `.dta` datasets in:

   ```
   data/raw/
   ```

2. Open Stata and run:

   ```
   do master.do
   ```

3. Outputs will be saved in:

   * `output/tables/`
   * `output/figures/`

---

## Software Requirements

* Stata 17 or newer
* Required packages (installed automatically):

  * `estout`
  * `coefplot`
  * `outreg2`

---

## Notes

* The repository follows a structured reproducibility pipeline inspired by best practices in empirical research.
* Raw data is not included due to access restrictions.
* All results can be reproduced once the input data is provided.

---

## Author Contribution

All code in this repository was written by the applicant as part of an empirical microeconometrics project.
