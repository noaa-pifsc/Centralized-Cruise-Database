# Version 1.0 Deployment Scripts

## Overview
This document provides information about the various files developed to safely deploy version 1.0 of the Centralized Cruise Database (CCD) and version 1.0 of the Cruise Data Management Application (CRDMA).  The rollback scripts are included in the event that the upgrade fails and the database and application version must be rolled back to its previous state.

## Resources
-   [automated deployments](./automated_deployments)
    -   These scripts were developed to automate and log the process of deploying/rolling back the database and application to support the system upgrade
    -   Note: All scripts should be run from the SQL directory in the repository root directory using SQL Plus utilizing the relative paths of the scripts in this directory
    -   Script Inventory:
        -   deploy_[INSTANCE]_v1.0.sql (e.g. [deploy_dev_v1.0.sql](./automated_deployments/deploy_dev_v1.0.sql)) - deploys version 1.0 of the database to a blank schema on the [INSTANCE] database
        -   deploy_apex_[INSTANCE]_v1.0.sql (e.g. [deploy_apex_dev_v1.0.sql](./automated_deployments/deploy_apex_dev_v1.0.sql)) - deploys version 1.0 of the APEX application (pre-upgrade production version) to the [INSTANCE] database
        -   deploy_[INSTANCE]_rollback_to_0.0.sql (e.g. [deploy_dev_rollback_to_0.0.sql](./automated_deployments/deploy_dev_rollback_to_0.0.sql)) - perform a rollback of the database upgrade from version 1.0 to 0.0 on the [INSTANCE] database
        -   deploy_apex_[INSTANCE]_rollback_to_0.0.sql (e.g. [deploy_apex_dev_rollback_to_0.0.sql](./automated_deployments/deploy_apex_dev_rollback_to_0.0.sql))
-   [calling_scripts](./calling_scripts)
    -   These scripts were developed to make it easier to execute the automated deployment scripts from a given working copy of the repository.  
    -   Replace the [working copy root] placeholders with the actual path to the root directory of the working copy of this repository before executing the statements.  When prompted provide the database credentials in SQL*Plus format (e.g. SCHEMA/PASSWORD@HOSTNAME/SID)
    -   Script Inventory:
        -   [INSTANCE]_deployment_script_upgrade_v0.0_to_v1.0.sql (e.g. [dev_deployment_script_upgrade_v0.0_to_v1.0.sql](./calling_scripts/dev_deployment_script_upgrade_v0.0_to_v1.0.sql)) - deploys version 1.0 of the database to a blank schema and deploys version 1.0 of the application to the [INSTANCE] schema
        -   [INSTANCE]_deployment_script_rollback_v1.0_to_v0.0.sql (e.g. [dev_deployment_script_rollback_v1.0_to_v0.0.sql](./calling_scripts/dev_deployment_script_rollback_v1.0_to_v0.0.sql)) - perform a rollback of the database upgrade from version 1.0 to 0.0 (pre-upgrade production version) and remove the APEX application (pre-upgrade production version) from the [INSTANCE] server
-   [rollback](./rollback)
    -   These scripts were developed to rollback the database upgrade from version 2.0 to 1.6 to revert the database to its previous state before an upgrade if the application does not work or there is another issue.
    -   Script Inventory:
        -   [db_downgrade_1.0_to_0.0.sql](./rollback/db_downgrade_1.0_to_0.0.sql) - contains the DDL to revert the database changes due to the upgrade from version 1.0 to 0.0.
        -   [drop_app_synonyms.sql](./rollback/drop_app_synonyms.sql) - contains the DDL to remove the application schema's synonyms.
        -   [remove_apex_app.sql](./rollback/remove_apex_app.sql) - contains the DDL to delete the APEX application.
-   [apex](./apex)
    -   These scripts contain different versions of the APEX application necessary to upgrade the APEX application version
    -   Script Inventory:
        -   [f287-v1.0.sql](./apex/f287-v1.0.sql) - contains version 1.0 of the APEX application to deploy the new application
        -   [create_CRDMA_synonyms.sql](./apex/create_CRDMA_synonyms.sql) - contains the application schema's synonym definitions
-   [db](./db)
    -   These scripts contain the database scripts to support the deployment of version 1.0 of the database
    -   Script Inventory:
        -   [define_data_schema_synonyms.sql](./db/define_data_schema_synonyms.sql) - creates the synonyms in the data schema for external objects referenced in the data schema
        -   [grant_CCD_role_permissions.sql](./db/grant_CCD_role_permissions.sql) - grants the CCD database roles the necessary permissions on objects defined in the data schema
        -   load_[INSTANCE]_ref_data.sql (e.g. [load_dev_test_ref_data.sql](./db/load_dev_test_ref_data.sql)) - loads the reference and cruise data for the specified database instance
        -   [load_config_values.sql](./db/load_config_values.sql) - defines the configuration values for version 1.0 of the application
        -   [load_DVM_rules.sql](./db/load_DVM_rules.sql) - defines the DVM rules for version 1.0 of the database
