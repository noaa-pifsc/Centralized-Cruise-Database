--------------------------------------------------------
--------------------------------------------------------
--Database Name: DB Module Packager - APEX Application
--Database Description: DB Module Packager - APEX Application: This collection of custom modules is intended to provide functionality for PIFSC APEX applications
--------------------------------------------------------
--------------------------------------------------------


--------------------------------------------------------
--DB Module Packager - APEX Application - version 1.0 updates:
--------------------------------------------------------

--Upgraded from Version 1.0 (Git tag: auth_app_db_v1.0) to Version 1.1 (Git tag: auth_app_db_v1.1) of the Authorization Application Module Database (Git URL: git@gitlab.pifsc.gov:centralized-data-tools/authorization-application-module.git)
@@upgrades/external_modules/auth_app_DB_DDL_DML_update_v1.1.sql


--define the upgrade version in the database upgrade log table:
INSERT INTO DB_UPGRADE_LOGS (UPGRADE_APP_NAME, UPGRADE_VERSION, UPGRADE_DATE, UPGRADE_DESC) VALUES ('DB Module Packager - APEX Application', '1.0', TO_DATE('14-APR-22', 'DD-MON-YY'), 'Upgraded from Version 1.0 (Git tag: auth_app_db_v1.0) to Version 1.1 (Git tag: auth_app_db_v1.1) of the Authorization Application Module Database (Git URL: git@gitlab.pifsc.gov:centralized-data-tools/authorization-application-module.git)');

--commit the DB_UPGRADE_LOGS record insertion
COMMIT;
