# Centralized Cruise Database - Technical Documentation

## Overview:
The Centralized Cruise Database (CCD) is used to track information about each PIFSC research cruise including activities, regions, etc. to remove the need for each division/program to manage this information. This centralized database is available for all PIFSC database users to reference with their various division data sets.

## Resources:
-   Centralized Cruise Database Version Control Information:
    -   URL: git@gitlab.pifsc.gov:centralized-data-tools/centralized-cruise-database.git
    -   Database: 0.25 (Git tag: cen_cruise_db_v0.25)
-   [Comments for all centralized cruise database Views](./centralized_cruise_DB_view_comments.xlsx)
-   [Cruise Data Management Application Technical Documentation](../CRDMA/docs/Cruise%20Data%20Management%20Application%20-%20Technical%20Documentation.md)
-   [Cruise Database Diagram Documentation](./Centralized%20Cruise%20Database%20Diagram%20Documentation.md)
-   [Database Naming Conventions](./Centralized%20Cruise%20Database%20-%20DB%20Naming%20Conventions.md)
-   [PL/SQL Coding Conventions](./Centralized%20Cruise%20Database%20-%20PLSQL%20Coding%20Conventions.md)
-   [Data Integration SOP](./Centralized%20Cruise%20Database%20-%20Data%20Integration%20SOP.md)
-   CCDP Oracle Package
    -   [Testing Documentation](./test%20cases/CCD_CRUISE_PKG/CCDP%20Testing%20Documentation.md)
-   Data Validation Module (DVM)
    -   [Testing Documentation](./test%20cases/DVM_PKG/Centralized%20Cruise%20Database%20DVM%20Testing%20Documentation.md)

## Database Setup:
-   Grant the Cruise database schema permissions
    -   Execute the sections of the [grant_info.sql](../SQL/queries/grant_info.sql) file using the schemas based on the comments to grant the CEN_CRUISE schema the necessary permissions
    -   *Note: the permissions granted to the CEN_CRUISE schema are listed in [CEN_CRUISE_permissions](./CEN_CRUISE_permissions.xlsx)
-   [Installing or Upgrading the Database](./Installing%20or%20Upgrading%20the%20Database.md)
-   Cruise/reference data can be purged and reloaded for development purposes using [refresh_ref_data.sql](../SQL/queries/refresh_ref_data.sql)
-   Grant external schemas permissions to the Centralized Cruise Database
    -   Modify the Centralized Cruise Database's [grant_external_schema_privs.sql](../SQL/queries/grant_external_schema_privs.sql) to replace the [EXTERNAL SCHEMA] placeholders with the given schema name and execute using the CEN_CRUISE schema

## Features:
-   The database requires the Centralized Utilities to be deployed on the CEN_UTILS schema in order for the database views to work properly when querying the cruise and cruise leg information
    -   Version Control Information:
        -   URL (Git): <git@gitlab.pifsc.gov:centralized-data-tools/centralized-utilities.git>
        -   Database: 0.9 (Git tag: cen_utils_db_v0.9)
-   The Data Validation Module (DVM) is used to perform QC validation on the Centralized Cruise Database data managed in this database. Custom data validation criteria were developed for this operational data set.
    -   Version Control Information:
        -   URL (Git): <git@gitlab.pifsc.gov:centralized-data-tools/data-validation-module.git>
        -   Database: 1.2 (Git tag: DVM_db_v1.2)
-   The Database Version Control Module is used to track the database version installed on a given database schema.
    -   Version Control Information:
        -   URL (Git): <git@gitlab.pifsc.gov:centralized-data-tools/database-version-control-module.git>
        -   Application: 0.14 (Git tag: db_vers_ctrl_v0.14)
        -   Database: 0.2 (Git tag: db_vers_ctrl_db_v0.2)
-   The Database Logging Module is used to log CDIM execution information in the database.
    -   Version Control Information:
        -   URL (Git): <git@gitlab.pifsc.gov:centralized-data-tools/database-logging-module.git>
        -   Database: 0.2 (Git tag: db_log_db_v0.2)
-   The Authorization Application Module was originally designed to manage application access and permissions within the application. This is a flexible method that allows users and permission groups to be defined that will determine if a user has enabled access to the application and what permission(s) they have in the application.
    -   Version Control Information:
        -   URL (Git): <git@gitlab.pifsc.gov:centralized-data-tools/authorization-application-module.git>
        -   Database: 0.7 (Git tag: auth_app_db_v0.7)
-   The PIFSC APEX custom error handling function has been implemented on the application to suppress sensitive error information within the database application to satisfy Security Control: SI-11.
    -   Version Control Information:
        -   URL: <git@gitlab.pifsc.gov:centralized-data-tools/apex_tools.git> in the "Error Handling" folder
        -   Database: 0.2 (Git tag: APX_Cust_Err_Handler_db_v0.2)

## Data Flow:
-   [Data Flow Diagram (DFD)](./DFD/Centralized%20Cruise%20DFD.pdf)
-   [DFD Documentation](./DFD/Centralized%20Cruise%20Data%20Flow%20Diagram%20Documentation.md)

## Business Rules:
-   The business rules for the Centralized CTD Database are defined in the [Business Rule Documentation](./Centralized%20Cruise%20Database%20-%20Business%20Rule%20Documentation.md) and each specific business rule listed in the [Business Rule List](./Centralized%20Cruise%20Database%20-%20Business%20Rule%20List.xlsx) with a Scope of "Cruise DB" apply to the underlying database and rules with a Scope of "Data QC" apply to the QC criteria used to evaluate Cruise data in the underlying database.

## DVM QC Validation Criteria:
-   Technical documentation for the DVM can be found in the [DVM repository](https://gitlab.pifsc.gov/centralized-data-tools/data-validation-module) in the [DVM Documentation](https://gitlab.pifsc.gov/centralized-data-tools/data-validation-module/-/blob/master/docs/Data%20Validation%20Module%20Documentation.MD) and instructions for how to define the QC criteria can be found in the docs\How to Define Criteria in Data Validation Module.md document.
    -   This project defines the [automated DVM test cases](./test%20cases/DVM_PKG/Centralized%20Cruise%20Database%20DVM%20Testing%20Documentation.md) to ensure that the DVM produces the desired outcome based on the defined test cases.
-   The specific QC criteria developed for the CCD database can be found in the CCD repository in the [QA_QC Validation Criteria](./QA_QC%20Validation%20Criteria.xlsx) spreadsheet which was exported into [load_DVM_rules.sql](../SQL/queries/load_DVM_rules.sql)
-   Before executing the DVM query the [DVM Configuration QC views](#DVM_QC_config_queries) to ensure that the module configuration is valid.
-   To validate a given cruise record using the DVM execute the CCD_DVM_PKG package's EXEC_DVM_CRUISE_SP procedure or EXEC_DVM_CRUISE_OVERLAP_SP procedure with the corresponding CRUISE_NAME or CRUISE_ID value for the specified cruise record.
    -   EXEC_DVM_CRUISE_OVERLAP_SP is a special procedure that will validate the record as well as any records that have a cruise leg overlap (either same cruise or vessel) and it is intended for execution when a given cruise or its associated records have been updated and the user would like all overlapping cruises to be revalidated as well so their associated validation records are up-to-date
    -   The BATCH_EXEC_DVM_CRUISE_SP procedure queries for all cruises and executes the EXEC_DVM_CRUISE_SP procedure on each cruise. This is intended for validating a batch of cruises (e.g. a new fiscal year) before using the data for reporting purposes or exporting to external systems to ensure the cruise data is valid.
-   To view the specific data QC validation issues query the CCD_CRUISE_SUMM_ISS_V view
-   Annotating QC Validation Issues:
    -   The [Cruise Data Management Application](../CRDMA/docs/Cruise%20Data%20Management%20Application%20-%20Technical%20Documentation.md) provides an interface for authorized users to review and annotate QC validation issues identified by the DVM
-   DVM Error Codes:
    -   A list of custom error codes that are implemented in the DVM can be found in the [DVM repository](https://gitlab.pifsc.gov/centralized-data-tools/data-validation-module) in the [Business Rules spreadsheet](https://gitlab.pifsc.gov/centralized-data-tools/data-validation-module/-/blob/master/docs/DVM%20-%20Business%20Rules.xlsx) where the "Scope" column values are "DVM Processing Errors"

## DVM Features:
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

## Cruise Database Reference Data:
-   Cruise Legs and Cruise Leg Aliases:
    -   [Cruise Leg Name Alias Documentation](./Cruise%20Leg%20Name%20Alias%20Documentation.md)
        -   There is no limit on the number of cruise leg aliases that can be defined for a given cruise leg
        -   The information for the defined cruise leg aliases can be viewed by querying the CEN_CRUISE.CCD_CRUISE_LEG_DELIM_V view
    -   [Cruise_Leg_DDL_DML_generator.xlsx](./Cruise_Leg_DDL_DML_generator.xlsx) contains sheets labeled "Cruises", "Cruise Legs", "Cruise Leg Aliases" that defines the cruises (CCD_CRUISES), cruise legs (CCD_CRUISE_LEGS), and cruise leg aliases (CCD_LEG_ALIASES) respectively for each research cruise defined in the Centralized Cruise database. The DML to load this reference data is generated in labeled columns.
        -   These DML statements can be exported to a DML file so these values can be easily loaded into a given database schema.
    -   An [APEX application](../CRDMA/docs/Cruise%20Data%20Management%20Application%20-%20Technical%20Documentation.md) is available to manage the cruises, cruise legs, and leg aliases
