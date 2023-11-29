# Centralized Cruise Database Data Validation Module Documentation

## Overview:
The Centralized Cruise Database (CCD) is used to track information about each PIFSC research cruise including activities, regions, etc. to remove the need for each division/program to manage this information. The CCD Data Validation Module (CDVM) was developed to extend the functionality of an existing [Data Validation Module (DVM)](https://github.com/PIFSC-NMFS-NOAA/PIFSC-DataValidationModule) to implement specific business rules defined for the CCD and associated modules.  The CDVM is utilized to perform automated data Quality Control (QC) on the CCD to help ensure the quality of the data.

## Resources:
-   [DVM](https://github.com/PIFSC-NMFS-NOAA/PIFSC-DataValidationModule)
-   [CDVM Testing](./test_cases/CDVM%20Testing%20Documentation.md)
-   [Cruise Data Management Application (CRDMA) CDVM Testing](../../../CRDMA/docs/test_cases/packages/CDVM/CRDMA%20CDVM%20Testing%20Documentation.md)
-   [CCD Documentation](../../Centralized%20Cruise%20Database%20-%20Technical%20Documentation.md)
-   [CCD Business Rules](../../Centralized%20Cruise%20Database%20-%20Business%20Rule%20Documentation.md)
    -   [CCD Business Rule List](../../Centralized%20Cruise%20Database%20-%20Business%20Rule%20List.xlsx)

## Definitions:
-   The DVM Oracle package is DVM_PKG
-   The CDVM Oracle package is CCD_DVM_PKG

## Business Rules:
-   The [DVM](https://github.com/PIFSC-NMFS-NOAA/PIFSC-DataValidationModule) implements its own [business rules](https://github.com/PIFSC-NMFS-NOAA/PIFSC-DataValidationModule/blob/master/docs/DVM%20-%20Business%20Rule%20Documentation.md)
    -   The [DVM processing errors](https://github.com/PIFSC-NMFS-NOAA/PIFSC-DataValidationModule/blob/master/docs/DVM%20-%20Business%20Rules.xlsx) have a "Scope" value of "DVM Processing Errors"
-   The CDVM implements additional [business rules](../../Centralized%20Cruise%20Database%20-%20Business%20Rule%20Documentation.md) that have a "Scope" value of "CCD Custom DVM"
    -   The CDVM processing errors [business rules](../../Centralized%20Cruise%20Database%20-%20Business%20Rule%20List.xlsx) have a "Scope" value of "CCD Custom DVM Errors"
    -   When the CDVM is used to validate a Cruise it will automatically evaluate all of the QC errors listed in the [Business Rule List](../../Centralized%20Cruise%20Database%20-%20Business%20Rule%20List.xlsx) with a "Scope" value of "Data QC"

## DVM QC Validation Criteria:
-   Technical documentation for the DVM can be found in the [DVM repository](https://github.com/PIFSC-NMFS-NOAA/PIFSC-DataValidationModule) in the [DVM Documentation](https://github.com/PIFSC-NMFS-NOAA/PIFSC-DataValidationModule/blob/master/docs/Data%20Validation%20Module%20Documentation.md) and instructions for how to define the QC criteria can be found in the [DVM SOP](https://github.com/PIFSC-NMFS-NOAA/PIFSC-DataValidationModule/blob/master/docs/How%20to%20Define%20Criteria%20in%20Data%20Validation%20Module.md).
    -   This project defines [automated DVM test cases](./test_cases/CDVM%20Testing%20Documentation.md) to ensure that the DVM and CDVM produce the desired outcome based on the defined test cases.
-   The specific QC criteria developed for the CCD database can be found in the CCD repository in the [QC Validation Criteria](../../QC%20Validation%20Criteria.xlsx) spreadsheet which was exported into [load_DVM_rules.sql](../../../SQL/queries/load_DVM_rules.sql)
-   Before executing the DVM query the [DVM Configuration QC views](#DVM_QC_config_queries) to ensure that the module configuration is valid.
-   Annotating QC Validation Issues:
    -   The [Cruise Data Management Application](../../../CRDMA/docs/Cruise%20Data%20Management%20Application%20-%20Technical%20Documentation.md) provides an interface for authorized users to review and annotate QC validation issues identified by the DVM

## DVM and CDVM Features:
-   The CDVM automated test cases are defined in the [CDVM Testing documentation](./test_cases/CDVM%20Testing%20Documentation.md)
-   The CRDMA CDVM test cases are defined in the [CRDMA CDVM Testing documentation](../../../CRDMA/docs/test_cases/packages/CDVM/CRDMA%20CDVM%20Testing%20Documentation.md)
-   Standard Reports:
    -   DVM Validation Rule Sets:
        -   Database View: DVM_RULE_SETS_RPT_V
        -   Description: This standard validation rule report can be included with the data set metadata to provide the specific data quality control criteria that was used to validate each data stream over time
    -   Cruise DVM Validation Rule Sets:
        -   Database View: CCD_CRUISE_DVM_RULES_RPT_V
        -   Description: This standard validation rule report can be included with the data set metadata or as an internal report to provide the specific data quality control criteria that was used to validate each cruise record if that level of detail is desired
    -   Cruise DVM Rule Set Evaluations:
        -   Database View: CCD_CRUISE_DVM_EVAL_RPT_V
        -   Description: This standard validation rule set evaluation report can be included with the data set metadata or as an internal report to provide the DVM rule set evaluation history for each cruise record if that level of detail is desired
    -   Cruise DVM Rule Evaluations:
        -   Database View: CCD_CRUISE_DVM_RULE_EVAL_RPT_V
        -   Description: This standard detailed report can be included with the data set metadata or as an internal report to provide information about each time the DVM was evaluated for which specific validation rules on a given cruise for each data stream if that level of detail is desired
-   <span id="DVM_QC_config_queries" class="anchor"></span>DVM QC Configuration Queries:
    -   These database views have names that begin with "DVM_STD_QC" and are used to identify invalid DVM configuration errors that will prevent the DVM from being executed successfully (e.g. data QC view is invalid). These configuration QC queries are intended to be executed after the DVM configuration has been changed or if there are problems encountered during DVM execution.
    -   The DVM_STD_QC_ALL_RPT_V combines the results of all of the standard DVM configuration QC queries for convenience.

## Implementation:
-   The CDVM procedures and functions are documented directly in the PL/SQL package and package body definitions including example PL/SQL to execute the procedures
-   User Defined Exceptions that were implemented for error handling in the CDVM are defined in the [business rules](../../Centralized%20Cruise%20Database%20-%20Business%20Rule%20List.xlsx) with a "Scope" value of "CCD Custom DVM Errors"
