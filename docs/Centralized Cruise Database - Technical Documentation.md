# Centralized Cruise Database - Technical Documentation

## Overview:
The Centralized Cruise Database (CCD) is used to track information about each PIFSC research cruise including activities, regions, etc. to remove the need for each division/program to manage this information. This centralized database is available for all PIFSC database users to reference with their various division data sets.

## Resources:
-   CCD Version Control Information:
    -   URL: git@picgitlab.nmfs.local:centralized-data-tools/centralized-cruise-database.git
    -   Database: 1.0 (Git tag: cen_cruise_db_v1.0)
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
-   Create separate database schemas for the database (data schema) and each application (application schemas):
    -   Database Schemas:
        -   Data Schema: CEN_CRUISE
        -   APEX Application: CEN_CRUISE_APP
    -   Procedure: [Oracle Resource Request SOP](https://docs.google.com/document/d/1cSru4Cy7Ccl3sd-3UrOFb5cqmOPtzjd0khG1lX0VSE0/edit#bookmark=kix.87qwoqx35jfc)
-   Execute the role/permissions queries below using a DBA account:
    -   Create the CCD roles by executing the [create_CRUISE_roles.sql](../SQL/queries/create_CRUISE_roles.sql) script.
    -   Grant the necessary permissions to the data schema by executing the [grant_data_schema_privs.sql](../SQL/queries/grant_data_schema_privs.sql) script.
-   ### Automated Installation
    -   The automated database deployments utilize the [Database Version Control Module SOP](https://github.com/PIFSC-NMFS-NOAA/PIFSC-DBVersionControlModule/blob/master/docs/DB%20Version%20Control%20Module%20SOP.MD)
    -   open a command line window and switch the directory to the [SQL folder](../SQL/) of your working copy of this repository
    -   Execute the corresponding deployment script for the given database instance using the "@" syntax (e.g. [deploy_dev.sql](../SQL/deploy_dev.sql) for the development database instance) and enter the data schema credentials to deploy the database
-   ### Manual Installation
    -   \*\*Note: all of the following scripts are executed on the data schema (CEN_CRUISE)
    -   Define the data schema synonyms by executing the [define_data_schema_synonyms.sql](../SQL/queries/define_data_schema_synonyms.sql)
    -   [Installing or Upgrading the Database](./Installing%20or%20Upgrading%20the%20Database.md)
    -   Grant the permissions on the objects in the MOUSS schema to the defined MOUSS roles by executing the [grant_CCD_role_permissions.sql](../SQL/queries/grant_CCD_role_permissions.sql) script
    -   (Development and Test only) Load the MOUSS test data by executing the test data script [load_dev_test_ref_data.sql](../SQL/queries/load_dev_test_ref_data.sql)
    -   (Production only) Load the MOUSS data by executing the test data script [load_ref_data.sql](../SQL/queries/load_ref_data.sql)
    -   Load the DVM rules by executing the [load_DVM_rules.sql](../SQL/queries/load_DVM_rules.sql) script
    -   Load the configuration values by executing the [load_config_values.sql](../SQL/queries/load_config_values.sql) script
-   Cruise/reference data can be purged and reloaded for development purposes using [refresh_ref_data.sql](../SQL/queries/refresh_ref_data.sql)
-   Grant external schemas permissions to the Centralized Cruise Database
    -   Modify the Centralized Cruise Database's [grant_external_schema_privs.sql](../SQL/queries/grant_external_schema_privs.sql) to replace the [EXTERNAL SCHEMA] placeholders with the given schema name and execute using the CEN_CRUISE schema
    -   For detailed information on integrating the CCD into a new/existing data system refer to the [CCD Data Integration SOP](./Centralized%20Cruise%20Database%20-%20Data%20Integration%20SOP.md)

## External Dependencies
-   The Centralized Utilities Database is utilized in multiple CCD objects to perform calculations
    -   URL (Git): git@picgitlab.nmfs.local:centralized-data-tools/centralized-utilities.git
    -   Database: 1.0 (Git tag: cen_utils_db_v1.0)
-   The PARR Tools Database is integrated into the CCD to provide information about the Cruise Leg data sets and data set packages  
    -   URL (Git): git@picgitlab.nmfs.local:centralized-data-tools/parr-tools.git
    -   Database: 1.3 (Git tag: PIFSC_Data_Set_db_v1.3)
-   The Centralized Authorization System (CAS) is used to perform authentication and authorization for the MOUSS data management application
    -   Repository URL: git@picgitlab.nmfs.local:centralized-data-tools/authorization-application-module.git in the "CAS" folder
    -   Version: 1.2 (git tag: central_auth_app_db_v1.2)
-   The CCD data schema permissions are listed in [CEN_CRUISE_permissions.xlsx](./CEN_CRUISE_permissions.xlsx)

## Features:
-   DB Version Control Module (VCM)
    -   Repository URL: git@github.com:PIFSC-NMFS-NOAA/PIFSC-DBVersionControlModule.git
    -   Version: 1.0 (git tag: db_vers_ctrl_db_v1.0)
-   DB Logging Module (DLM)
    -   Repository URL: git@github.com:PIFSC-NMFS-NOAA/PIFSC-DBLoggingModule.git
    -   Version: 0.3 (git tag: db_log_db_v0.3)
-   Error Handler Module
    -   Repository URL: git@picgitlab.nmfs.local:centralized-data-tools/apex_tools.git in the "Error Handling" folder
    -   Version: 1.0 (git tag: APX_Cust_Err_Handler_db_v1.0)
-   Data Validation Module (DVM)
    -   Repository URL: git@github.com:PIFSC-NMFS-NOAA/PIFSC-DataValidationModule.git
    -   Version: 1.5 (git tag: DVM_db_v1.5)
-   APEX Feedback Form (AFF)
    -   Repository URL: git@picgitlab.nmfs.local:centralized-data-tools/apex-feedback-form.git
    -   Version: 0.1 (git tag: apex_feedback_form_db_v0.1)
-   Centralized Configuration (CC) project
    -   Repository URL: git@picgitlab.nmfs.local:centralized-data-tools/centralized-configuration.git
    -   Version: 1.0 (git tag: centralized_configuration_db_v1.0)
-   Data history tracking package
    -   Version Control Information:
        -   URL: svn://badfish.pifsc.gov/Oracle/DSC/trunk/apps/db/dsc/dsc_pkgs
        -   Files: dsc_cre_hist_objs_pkg.pks (package specs) and dsc_cre_hist_objs_pkg.pkb (package body)
    -   Description: This was developed by the PIFSC Systems Design Team (SDT) to track data changes to a given table over time to facilitate accountability, troubleshooting, etc.

## Database Diagram:
-   [CCD Diagram Documentation](./Centralized%20Cruise%20Database%20Diagram%20Documentation.md)
    -   [CCD Diagram](./data_model/cruise_db_diagram.pdf)

## Data Flow:
-   [Data Flow Diagram (DFD)](./DFD/Centralized%20Cruise%20DFD.pdf)
-   [DFD Documentation](./DFD/Centralized%20Cruise%20Data%20Flow%20Diagram%20Documentation.md)

## Business Rules:
-   The business rules for the CCD are defined in the [Business Rule Documentation](./Centralized%20Cruise%20Database%20-%20Business%20Rule%20Documentation.md) and each specific business rule listed in the [Business Rule List](./Centralized%20Cruise%20Database%20-%20Business%20Rule%20List.xlsx) with a Scope of "Cruise DB" apply to the underlying database and rules with a Scope of "Data QC" apply to the QC criteria used to evaluate Cruise data in the underlying database.

## Database Roles:
-   There are multiple database roles defined by the CCD to make permissions management easier
    -   Business Rules:
        -   Database Administrator Role (CR-DB-018)
        -   Database Read/Write Role (CR-DB-019)
        -   Database Readonly Role (CR-DB-020)
        -   Database CRDMA Role (CR-DB-021)
        -   Database Integration Role (CR-DB-022)
    -   The database role permissions are listed in [CCD_Role_Permissions.xlsx](./CCD_Role_Permissions.xlsx)

## Custom CCD Oracle Packages:
-   The [CDVM](./packages/CDVM/CDVM%20Documentation.md) was developed to extend the functionality of an existing [Data Validation Module (DVM)](https://picgitlab.nmfs.local/centralized-data-tools/data-validation-module) to implement specific business rules defined for the CCD and associated modules
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
-   [Centralized CTD Database](https://picgitlab.nmfs.local/centralized-data-tools/centralized-ctd) test data can be reloaded by executing the [CTD_test_case_reload_ref_data.sql](../SQL/queries/Centralized%20CTD/CTD_test_case_reload_ref_data.sql) script using the CCD data schema (CEN_CRUISE) to provide the test data for [version 0.27](https://picgitlab.nmfs.local/centralized-data-tools/centralized-cruise-database/-/tags/cen_cruise_db_v0.27) of the CCD for the [Centralized Utilities Database (CUD)](https://picgitlab.nmfs.local/centralized-data-tools/centralized-utilities) [Data Package (UDP)](https://picgitlab.nmfs.local/centralized-data-tools/centralized-utilities/-/blob/master/docs/packages/UDP_UDLP/UDP%20UDLP%20Documentation.md) starting in [version 0.10](https://picgitlab.nmfs.local/centralized-data-tools/centralized-utilities/-/tags/cen_utils_db_v0.10) of the CUD  
    -   **\*\*Note**: Do not execute this script on a production database.  DVM rules and data will be purged from the database.  The automated CTD database test cases require this script to be executed on a development/test instance.
    -   The [test_data-cen_utils_db_v0.10](https://picgitlab.nmfs.local/centralized-data-tools/centralized-cruise-database/-/tags/test_data-cen_utils_db_v0.10) tag on the CCD repository indicates the version of the CCD that was developed for version 0.10 of the CUD
