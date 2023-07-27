![Logo of the project](https://cienciadedatosysalud.org/wp-content/uploads/logo-Data-Science-VPM.png)

<small><i>This project follows the structure built using the [Common Data Model Builder](https://github.com/cienciadedatosysalud/cdmb), a tool that allows you to create common data models to facilitate interoperability and reproducibility of the analyses.</i></small>


# ATLAS FARMACIA - OPIOIDES

---

# Outputs
Outputs structure and content is described below including the files and folders that are generated when creating a research project with the `cdmb` Python library. There are four main folders corresponding to:

- __docs/CDM/__
  - **cdmb_config.json**: Configuration file.
  - **cohort_definition_inclusion.csv**: csv file that defines the criteria (i.e., codes) for inclusion in a cohort.
  - **cohort_definition_exclusion.csv**: csv file that defines the criteria (i.e., codes) for exclusion in a cohort.
  - **common_datamodel.xlsx**: The definition of the common data model in Excel format.
  - **entities/**: Folder structure where, for each defined entity, the catalogs and the established validation rules are stored.
  - **ER.gv, ER.gv.png**: an Entity-Relationship Diagram of the entities included in the CDM.
  - **synthetic-data/**: Folder structure contaning an automatically generated set of 1000 synthetic records per entity included en the CDM.
  - **hashed_files_list.json**: List of the files generated or used after generating the project with their md5 hash. This file must be kept hidden 
and should be used to cross-check with the results obtained from the analysis from the original input files.
- __inputs/__
  - **data.duckdb**: Database that temporarily contains the data entered by the user (synthetic data by default)
- __outputs/__
  - (Default directory of all the outputs produced in the project execution)
- __src/__
  - __analysis-scripts/__
    - (directory where the analysis scripts developed by the user are stored)
    - **_quarto.yml**: File containing the Metadata to execute Quarto documents.
  - __check_load-scripts/__
    - **check_load.py**: Script in charge of the mapping between the files introduced by the user (./inputs) and map them to the defined entities (inputs/data.duckdb). 
    In the loading process, the following checks are performed: Name of the variables match; the format/type of the variables match those established in the configuration.
    - __inputs/__: Auxiliary folder for the script 'check_load.py'.
  - __dqa-scripts/__
    - **dqa.py**: Data Quality Assesment script by default.
  - **validation-scripts/**
    - **validator.py**: Script in charge of applying the validation rules to the data.
    - **valididator_report.qmd**: Quarto document that generates a report in html from the results obtained from 'validator.py'. 
    - **_quarto.yml**: File containing metadata to execute Quarto documents.
- **ro-crate-metadata.json**: Accessible and practical formal metadata description for use in a wider variety of situations, 
from an individual researcher working with a folder of data, to large data-intensive computational research environments. For more information, visit [RO-Crate](https://www.researchobject.org/ro-crate/).
- **man_container_deployment.md**: From Data Science for Health Services and Policy Research group we provide in the following
  GitHub repository, a solution, for the deployment of the generated project. This step is optional.
- **LICENSE.md**: Project license.


## Requirements/Dependencies 

## R dependencies
Version of Rbase used: **4.2.3**

Version of [Quarto](https://quarto.org/) used: **1.2.475**

| library    | version | link                                                                                    |
|------------|---------|-----------------------------------------------------------------------------------------|
| DuckDB     | 0.8.1   | https://duckdb.org/                                                                     |
| jsonlite   | 1.8.7   | https://cran.r-project.org/web/packages/jsonlite/index.html                             |
| kableExtra | 1.3.4   | https://cran.r-project.org/web/packages/kableExtra/vignettes/awesome_table_in_html.html |
| Hmisc      | 4.7.1   | https://cran.r-project.org/package=Hmisc                                                |
| sf         | 1.0_14  | https://cran.r-project.org/web/packages/sf/index.html                                   |
| sjmisc     | 2.8.9   | https://cran.r-project.org/web/packages/sjmisc/index.html                               |
| gt         | 0.9.0   | https://cran.r-project.org/web/packages/gt/index.html                                   |
| logger     | 0.2.2   | https://cran.r-project.org/web/packages/logger/index.html                               |
| cowplot    | 1.1.1   | https://cran.r-project.org/web/packages/cowplot/index.html                              |
| ggalluvial | 0.12.5  | https://cran.r-project.org/web/packages/ggalluvial/index.html                           |
| ggalluvial | 0.9.3   | https://cran.r-project.org/web/packages/ggrepel/index.html                              |
| ggplot2    | 3.4.2   | https://cran.r-project.org/web/packages/ggplot2/index.html                              |
| plotly     | 4.10.2  | https://cran.r-project.org/web/packages/plotly/index.html                               |

## Python dependencies
Version of Python used: **>=3.9.2**

| library         | version | link                                                    |
|-----------------|---------|---------------------------------------------------------|
| pandas          | 1.5.3   | https://pandas.pydata.org/                              |
| DuckDB          | 0.8.1   | https://duckdb.org/                                     |
| ydata_profiling | 4.1.2   | https://ydata-profiling.ydata.ai/docs/master/index.html |


# Authoring

| Surname, name | Affiliation | ![orcid](https://orcid.org/sites/default/files/images/orcid_16x16.png) ORCID |
|---------------|-------------|------------------------------------------------------------------------------|
| Grupo de Investigación en Ciencia de Datos para Servicios y Políticas de Salud | Instituto Aragonés de Ciencias de la Salud (IACS), Instituto de Investigación Sanitaria de Aragón (IIS) | |
| Martínez-Lizaga, Natalia | Instituto Aragonés de Ciencias de la Salud (IACS) | https://orcid.org/0000-0002-9586-7955 |
| Estupiñan-Romero, Francisco | Instituto Aragonés de Ciencias de la Salud (IACS) | https://orcid.org/0000-0002-6285-8120 |
| Ridao-López, Manuel | Instituto de Investigación Sanitaria de Aragón (IIS) | https://orcid.org/0000-0001-7837-5759 |
| González-Galindo, Javier | Instituto Aragonés de Ciencias de la Salud (IACS) | https://orcid.org/0000-0002-8783-5478 |
| Royo-Sierra, Santiago | Instituto Aragonés de Ciencias de la Salud (IACS) | https://orcid.org/0000-0002-0048-4370 |
| Bernal-Delgado, Enrique | Instituto Aragonés de Ciencias de la Salud (IACS) | https://orcid.org/0000-0002-0961-3298 |

__Project leader: [Bernal-Delgado, Enrique](https://orcid.org/0000-0002-0961-3298)__


# Previous version(s):
A previous version (v.1.0.3) of this common data model not compliant with the structure produced by the `cdmb` Python library has been published in ZENODO at
 
[![DOI](https://zenodo.org/badge/DOI/10.5281/zenodo.8016643.svg)](https://doi.org/10.5281/zenodo.8016643)

# How to contribute
- Repository: https://github.com/cienciadedatosysalud/atlas-farmacia
- Issue tracker: https://github.com/cienciadedatosysalud/atlas-farmacia/issues

# References
- Data Science for Health Services and Policy Research group: https://cienciadedatosysalud.org/en/
- Common Data Model Builder library :https://github.com/cienciadedatosysalud/cdmb
- Analytic Software Pipeline Interface for Reproducible Execution (ASPIRE): https://github.com/cienciadedatosysalud/ASPIRE
- Atlas VPM community in Zenodo: https://zenodo.org/communities/atlasvpm
- Research Object Crate (RO-Crate): https://www.researchobject.org/ro-crate/
- ORCID: https://orcid.org/

<a href="https://creativecommons.org/licenses/by/4.0/" target="_blank" ><img src="https://img.shields.io/badge/license-CC--BY%204.0-lightgrey" alt="License: CC-BY 4.0"></a>

