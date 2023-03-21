--------------------------------------------------------
--------------------------------------------------------
--Database Name: DB Module Packager - APEX Application
--Database Description: DB Module Packager - APEX Application: This collection of custom modules is intended to provide functionality for PIFSC APEX applications
--------------------------------------------------------
--------------------------------------------------------


--------------------------------------------------------
--DB Module Packager - APEX Application - version 0.8 updates:
--------------------------------------------------------

--Installed version 1.0 (Git tag: centralized_configuration_db_v1.0) of the Centralized Configuration database (Git URL: git@gitlab.pifsc.gov:centralized-data-tools/centralized-configuration.git)
@@upgrades/external_modules/centralized_configuration_DDL_DML_upgrade_v1.0.sql


--define the upgrade version in the database upgrade log table:
INSERT INTO DB_UPGRADE_LOGS (UPGRADE_APP_NAME, UPGRADE_VERSION, UPGRADE_DATE, UPGRADE_DESC) VALUES ('DB Module Packager - APEX Application', '0.8', TO_DATE('22-NOV-21', 'DD-MON-YY'), 'Installed version 1.0 (Git tag: centralized_configuration_db_v1.0) of the Centralized Configuration database (Git URL: git@gitlab.pifsc.gov:centralized-data-tools/centralized-configuration.git)');

--commit the DB_UPGRADE_LOGS record insertion
COMMIT;
