# Centralized Cruise Database - Technical Documentation

## Overview:
The Centralized Cruise Database (CCD) is used to track information about each PIFSC research cruise including activities, regions, etc. to remove the need for each division/program to manage this information. This centralized database is available for all PIFSC database users to reference with their various division data sets.

## Resources:
-   CCD Version Control Information:
    -   URL: git@gitlab.pifsc.gov:centralized-data-tools/centralized-cruise-database.git
    -   Database: 0.27 (Git tag: cen_cruise_db_v0.27)
-   [CCD View Comments](./centralized_cruise_DB_view_comments.xlsx)
-   [Cruise Data Management Application (CRDMA)](../CRDMA/docs/Cruise%20Data%20Management%20Application%20-%20Technical%20Documentation.md)
-   [CCD Diagram Documentation](./Centralized%20Cruise%20Database%20Diagram%20Documentation.md)
-   [Database Naming Conventions](./Centralized%20Cruise%20Database%20-%20DB%20Naming%20Conventions.md)
-   [PL/SQL Coding Conventions](./Centralized%20Cruise%20Database%20-%20PLSQL%20Coding%20Conventions.md)
-   [CCD Data Integration SOP](./Centralized%20Cruise%20Database%20-%20Data%20Integration%20SOP.md)
-   [CCD Oracle Package (CCDP)](./packages/CCDP/CCDP%20Documentation.md)
    -   [Automated Testing Documentation](./packages/CCDP/test%20cases/CCDP%20Testing%20Documentation.md)
    -   [CRDMA CCDP Testing Documentation](../CRDMA/docs/test_cases/packages/CCDP/CRDMA%20CCDP%20Testing%20Documentation.md)
-   [CCD Data Validation Module (CDVM)](./packages/CDVM/CDVM%20Documentation.md)
    -   [Automated Testing Documentation](./packages/CDVM/test%20cases/CDVM%20Testing%20Documentation.md)
    -   [CRDMA CDVM Testing Documentation](../CRDMA/docs/test_cases/packages/CDVM/CRDMA%20CDVM%20Testing%20Documentation.md)

## Database Setup:
-   Grant the Cruise database schema permissions
    -   Execute the sections of the [grant_info.sql](../SQL/queries/grant_info.sql) file using the schemas based on the comments to grant the CEN_CRUISE schema the necessary permissions
    -   *Note: the permissions granted to the CEN_CRUISE schema are listed in [CEN_CRUISE_permissions](./CEN_CRUISE_permissions.xlsx)
-   [Installing or Upgrading the Database](./Installing%20or%20Upgrading%20the%20Database.md)
-   Cruise/reference data can be purged and reloaded for development purposes using [refresh_ref_data.sql](../SQL/queries/refresh_ref_data.sql)
-   Grant external schemas permissions to the Centralized Cruise Database
    -   Modify the Centralized Cruise Database's [grant_external_schema_privs.sql](../SQL/queries/grant_external_schema_privs.sql) to replace the [EXTERNAL SCHEMA] placeholders with the given schema name and execute using the CEN_CRUISE schema
-   [Centralized CTD Database](https://gitlab.pifsc.gov/centralized-data-tools/centralized-ctd) test data can be reloaded by executing the [CTD_test_case_reload_ref_data.sql](../SQL/queries/Centralized%20CTD/CTD_test_case_reload_ref_data.sql) script on the CEN_CRUISE schema
    -   **\*\*Note**: The automated test cases require this script to be executed on a development/test instance. DVM rules and data will be purged from the database, to avoid data loss do not execute this on a production database.

## Features:
-   The database requires the Centralized Utilities to be deployed on the CEN_UTILS schema in order for the database views to work properly when querying the cruise and cruise leg information
    -   Version Control Information:
        -   URL (Git): git@gitlab.pifsc.gov:centralized-data-tools/centralized-utilities.git
        -   Database: 0.9 (Git tag: cen_utils_db_v0.9)
-   The Data Validation Module (DVM) is used to perform QC validation on the Centralized Cruise Database data managed in this database. Custom data validation criteria were developed for this operational data set.
    -   Version Control Information:
        -   URL (Git): git@gitlab.pifsc.gov:centralized-data-tools/data-validation-module.git
        -   Database: 1.3 (Git tag: DVM_db_v1.3)
-   The Database Version Control Module is used to track the database version installed on a given database schema.
    -   Version Control Information:
        -   URL (Git): git@gitlab.pifsc.gov:centralized-data-tools/database-version-control-module.git
        -   Application: 0.14 (Git tag: db_vers_ctrl_v0.14)
        -   Database: 0.2 (Git tag: db_vers_ctrl_db_v0.2)
-   The Database Logging Module is used to log CDIM execution information in the database.
    -   Version Control Information:
        -   URL (Git): git@gitlab.pifsc.gov:centralized-data-tools/database-logging-module.git
        -   Database: 0.2 (Git tag: db_log_db_v0.2)
-   The Authorization Application Module was originally designed to manage application access and permissions within the application. This is a flexible method that allows users and permission groups to be defined that will determine if a user has enabled access to the application and what permission(s) they have in the application.
    -   Version Control Information:
        -   URL (Git): git@gitlab.pifsc.gov:centralized-data-tools/authorization-application-module.git
        -   Database: 0.8 (Git tag: auth_app_db_v0.8)
-   The PIFSC APEX custom error handling function has been implemented on the application to suppress sensitive error information within the database application to satisfy Security Control: SI-11.
    -   Version Control Information:
        -   URL: git@gitlab.pifsc.gov:centralized-data-tools/apex_tools.git in the "Error Handling" folder
        -   Database: 0.2 (Git tag: APX_Cust_Err_Handler_db_v0.2)

## Data Flow:
-   [Data Flow Diagram (DFD)](./DFD/Centralized%20Cruise%20DFD.pdf)
-   [DFD Documentation](./DFD/Centralized%20Cruise%20Data%20Flow%20Diagram%20Documentation.md)

## Business Rules:
-   The business rules for the CCD are defined in the [Business Rule Documentation](./Centralized%20Cruise%20Database%20-%20Business%20Rule%20Documentation.md) and each specific business rule listed in the [Business Rule List](./Centralized%20Cruise%20Database%20-%20Business%20Rule%20List.xlsx) with a Scope of "Cruise DB" apply to the underlying database and rules with a Scope of "Data QC" apply to the QC criteria used to evaluate Cruise data in the underlying database.

## Custom CCD Oracle Packages:
-   The [CDVM](./packages/CDVM/CDVM%20Documentation.md) was developed to extend the functionality of an existing [Data Validation Module (DVM)](https://gitlab.pifsc.gov/centralized-data-tools/data-validation-module) to implement specific business rules defined for the CCD and associated modules
-   The [CCDP](./packages/CCDP/CCDP%20Documentation.md) was developed to provide functions and stored procedures for the CCD to provide functionality for the database and associated module(s)

## Cruise Database Reference Data:
-   Cruise Legs and Cruise Leg Aliases:
    -   [Cruise Leg Name Alias Documentation](./Cruise%20Leg%20Name%20Alias%20Documentation.md)
        -   There is no limit on the number of cruise leg aliases that can be defined for a given cruise leg
        -   The information for the defined cruise leg aliases can be viewed by querying the CEN_CRUISE.CCD_CRUISE_LEG_DELIM_V view
    -   [Cruise_Leg_DDL_DML_generator.xlsx](./Cruise_Leg_DDL_DML_generator.xlsx) contains sheets labeled "Cruises", "Cruise Legs", "Cruise Leg Aliases" that defines the cruises (CCD_CRUISES), cruise legs (CCD_CRUISE_LEGS), and cruise leg aliases (CCD_LEG_ALIASES) respectively for each research cruise defined in the Centralized Cruise database. The DML to load this reference data is generated in labeled columns.
        -   These DML statements can be exported to a DML file so these values can be easily loaded into a given database schema.
    -   An [APEX application](../CRDMA/docs/Cruise%20Data%20Management%20Application%20-%20Technical%20Documentation.md) is available to manage the cruises, cruise legs, and leg aliases

## Test Data Set:
-   The [CTD_test_case_reload_ref_data.sql](../SQL/queries/Centralized%20CTD/CTD_test_case_reload_ref_data.sql) script provides the test data for [version 0.27](https://gitlab.pifsc.gov/centralized-data-tools/centralized-cruise-database/-/tags/cen_cruise_db_v0.27) of the CCD for the [Centralized Utilities Database (CUD)](https://gitlab.pifsc.gov/centralized-data-tools/centralized-utilities) [Data Package (UDP)](https://gitlab.pifsc.gov/centralized-data-tools/centralized-utilities/-/blob/master/docs/packages/UDP_UDLP/UDP%20UDLP%20Documentation.md) starting in [version 0.10](https://gitlab.pifsc.gov/centralized-data-tools/centralized-utilities/-/tags/cen_utils_db_v0.10) of the CUD  
    -   The [test_data-cen_utils_db_v0.10](https://gitlab.pifsc.gov/centralized-data-tools/centralized-cruise-database/-/tags/test_data-cen_utils_db_v0.10) tag on the CCD repository indicates the version of the CCD that was developed for version 0.10 of the CUD
