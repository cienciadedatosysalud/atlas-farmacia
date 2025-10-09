![Logo of the project](https://cienciadedatosysalud.org/wp-content/uploads/logo-Data-Science-VPM.png)

# ATLAS FARMACIA
Technical notes and documentation on the common data model of the project "Variations in the prescription, consumption and expenditure of antibiotics, opioids, antidepressants, antipsychotics by basic health area in the National Health System".

This publication corresponds to the Common Data Model (CDM) specification for the implementation of a federated network analysis of variations in the prescription, consumption and expenditure of antibiotics, opioids,
antidepressants, antipsychotics by basic health area in the National Health System.

## Aims
### General aim: 
To estimate the rates of consumption, pharmaceutical expenditure and number of patients treated in a series of drug groups (specifically, opioids, antibiotics, antidepressants, antipsychotics) and certain therapeutic subgroups of them according to the [ATC code](https://www.whocc.no/atc_ddd_index/) in the basic health areas (BHA) of the participating Autonomous Communities and to analyze whether the possible variations detected are systematic or explainable by chance.

### Main specific aim:
- To describe and map (geographical analysis) consumption rates and pharmaceutical expenditure by basic health zones.
- To analyze the possible existence of differences between zones using small area analysis.
- To analyze the existence of associations between consumption rates of different therapeutic subgroups.

### Study Design: 
It is a observational, retrospective, longitudinal and ecological study of standardized rates of consumption and pharmaceutical expenditure in 2 therapeutic groups (antibiotics, opioids, antidepressants, antipsychotics) and therapeutic subgroups. These rates were estimated as Defined Daily Dose (DDD) per 1000 inhabitants per day in each basic health area.

### Cohort definition opioids: 
All Dispensations of opioid drugs in the participating Autonomous Communities at the basic health area level in the study period
#### Inclusion criteria: 
Over 14 years of age with a health card with an active prescription for an opioid drug and dispensing/billing of at least one package of this drug in the study period.
#### Exclusion criteria: 
Patients 14 years or younger, patients without an active health card, and patients without dispensing/billing for an opioid drug.

- [Atlas VPM Farmacia - Opioides (README)](atlas_opioides/README.md)


### Cohort definition antibiotics: 
All Dispensations of antibiotic drugs in the participating Autonomous Communities at the basic health area level in the study period
#### Inclusion criteria: 
All patients with a health card with an active prescription for an antibiotic drug and dispensing/billing of at least one package of this drug in the study period.
#### Exclusion criteria: 
Patients without an active health card, and patients without dispensing/billing for an antibiotic drug.

- [Atlas VPM Farmacia - Antibióticos (README)](atlas_antibioticos/README.md)


### Cohort definition antidepressants: 
All Dispensations of antidepressants drugs in the participating Autonomous Communities at the basic health area level in the study period
#### Inclusion criteria: 
All patients with a health card with an active prescription for an antidepressants drug and dispensing/billing of at least one package of this drug in the study period.
#### Exclusion criteria: 
Patients without an active health card, and patients without dispensing/billing for an antidepressants drug.

- [Atlas VPM Farmacia - Antidepresivos (README)](atlas_antidepresivos/README.md)


### Cohort definition antipsychotics: 
All Dispensations of antipsychotics drugs in the participating Autonomous Communities at the basic health area level in the study period
#### Inclusion criteria: 
All patients with a health card with an active prescription for an antipsychotics drug and dispensing/billing of at least one package of this drug in the study period.
#### Exclusion criteria: 
Patients without an active health card, and patients without dispensing/billing for an antipsychotics drug.

- [Atlas VPM Farmacia - Antipsicóticos (README)](atlas_antipsicoticos/README.md)


### Study period: 
From 01-01-2013 until 31-12-2024 (or the more recent date available) for antibiotics and opioids.

From 01-01-2017 until 31-12-2024 (or the more recent date available) for antidepressants and antipsychotics.

## IN ORDER TO RUN THE DOCKER AND ANTIBIOTICS, OPIOIDS, ANTIDEPRESSANTS, ANTIPSYCHOTICS ANALYSIS, FOLLOW THE NEXT STEPS
## 1-HOW TO RUN THE DOCKER
Use the following code snippet to create the container.
```bash
docker pull ghcr.io/cienciadedatosysalud/atlas-farmacia:latest

docker run -d -p 127.0.0.1:3000:3000 --name atlas-farmacia-aspire ghcr.io/cienciadedatosysalud/atlas-farmacia:latest

```
Open your web browser at http://localhost:3000.

## 2-Run the analysis of variations in the consumption of antibiotics.
Follow the steps below.
  1. Map your data in the "MAP DATA" tab.
  2. If everything has worked well, in the "RUN ANALYSIS" tab, select the project "Variaciones en el consumo de antibióticos por ZBS (y CCAA)" and select the script "**antibioticos_report.qmd**"
  3. Go to the "OUTPUTS" tab and download the results.

## 3-Run the analysis of variations in the consumption of opioids.
Follow the steps below.
  1. Map your data in the "MAP DATA" tab.
  2. If everything has worked well, in the "RUN ANALYSIS" tab, select the project "Variaciones en el consumo de opioides por ZBS (y CCAA)" and select the script "**opioides_report.qmd**"
  3. Go to the "OUTPUTS" tab and download the results.

## 4-Run the analysis of variations in the consumption of antidepressants.
Follow the steps below.
  1. Map your data in the "MAP DATA" tab.
  2. If everything has worked well, in the "RUN ANALYSIS" tab, select the project "Variaciones en el consumo de antidepresivos por ZBS (y CCAA)" and select the script "**antidepresivos_report.qmd**"
  3. Go to the "OUTPUTS" tab and download the results.


## 5-Run the analysis of variations in the consumption of antipsychotics.
Follow the steps below.
  1. Map your data in the "MAP DATA" tab.
  2. If everything has worked well, in the "RUN ANALYSIS" tab, select the project "Variaciones en el consumo de antipsicóticos por ZBS (y CCAA)" and select the script "**antipsicoticos_report.qmd**"
  3. Go to the "OUTPUTS" tab and download the results.

## MINIMUM REQUIREMENTS FOR DEPLOYMENT 


[![DOI](https://zenodo.org/badge/671438742.svg)](https://zenodo.org/badge/latestdoi/671438742)
<a href="https://creativecommons.org/licenses/by/4.0/" target="_blank" ><img src="https://img.shields.io/badge/license-CC--BY%204.0-lightgrey" alt="License: CC-BY 4.0"></a>
