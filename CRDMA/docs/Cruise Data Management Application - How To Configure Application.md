# Cruise Data Management Application - How to Configure the Application

## Overview:
In order for the Cruise Data Management Application (CRDMA) to work properly the APEX parsing schema must be granted certain permissions and data must be loaded into various database tables.

## Resources:
-   [Cruise Business Rule Documentation](../../docs/Centralized%20Cruise%20Database%20-%20Business%20Rule%20Documentation.md)
    -   [Business Rule List](../../docs/Centralized%20Cruise%20Database%20-%20Business%20Rule%20List.xlsx)

## Requirements:
This application requires version 1.0 of the Cruise Database to be installed (Git tag: cen_cruise_db_v1.0)

## SOP:
-   Grant the necessary permissions to the APEX application parsing schema (CEN_CRUISE_APP)
    -   Execute the statements in the [cen_cruise_app_grant_privs.sql](../SQL/cen_cruise_app_grant_privs.sql) file using an account with DBA privileges to grant the required roles/object privileges from the external database schemas
-   Load the Centralized Authorization System (CAS) CCD groups/users
		-   Request that someone is designated a CCD administrator that can login to the corresponding CAS application to grant/revoke CRDMA permissions (e.g. [PICD CAS](https://picmidd.nmfs.local/picd/f?p=CAS) for the PIFSC development database)
-   Load the runtime configuration options
    -   Execute the appropriate load configuration values script based on the server instance the application is being deployed to (e.g. [load_config_values.dev.sql](../../SQL/queries/load_config_values.dev.sql) for the development instance) script in the CCD data schema (CEN_CRUISE) to define the runtime configuration settings for the application
    -   \*Note: For the application to run properly two separate CC_CONFIG_OPTIONS records must be defined for the development and test APEX server hostnames:
        -    Development Server Configuration (business rule: CR-DMA-022)
        -    Test Server Configuration (business rule: CR-DMA-023)
    -   \*Note: For the CAS to properly authorize standard user roles the following configuration options must be defined:
        -   CRDMA App Code (business rule: CR-DMA-021)
        -   Data Administrator Authorization (business rule: CR-DMA-004)
        -   Data Write Authorization (business rule: CR-DMA-019)
        -   Data Readonly Authorization (business rule: CR-DMA-020)
    -   \*Note: the [cc_data_generator.xlsx](https://github.com/noaa-pifsc/Centralized-Configuration/blob/master/docs/cc_data_generator.xlsx) in the Centralized Configuration project can be used to generate DML INSERT statements to load data into the CC_CONFIG_OPTIONS table
-   Define Parsing Schema Synonyms
    -   Execute the [synonym definition script](../SQL/create_CRDMA_synonyms.sql) using the CRDMA schema (CEN_CRUISE_APP) to create the synonyms for objects on external schemas that are used in the CRDMA.
