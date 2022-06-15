--------------------------------------------------------
--------------------------------------------------------
--Database Name: Centralized Cruise Database
--Database Description: Centralized Cruise Database to track information about each PIFSC research cruise including activities, chief scientists, regions, etc. to remove the need for each division/program to manage this information
--------------------------------------------------------
--------------------------------------------------------

--------------------------------------------------------
--Centralized Cruise Database - version 0.22 updates:
--------------------------------------------------------

--Installing Version 0.13 (Git tag: DVM_db_v0.13) of the Data Validation Module Database (Git URL: git@gitlab.pifsc.gov:centralized-data-tools/data-validation-module.git)
@@"./upgrades/external_modules/DVM_DDL_DML_upgrade_v0.13.sql";




--define the upgrade version in the database upgrade log table:
INSERT INTO DB_UPGRADE_LOGS (UPGRADE_APP_NAME, UPGRADE_VERSION, UPGRADE_DATE, UPGRADE_DESC) VALUES ('Centralized Cruise Database', '0.22', TO_DATE('28-JUL-20', 'DD-MON-YY'), 'Installed Version 0.13 (Git tag: DVM_db_v0.13) of the Data Validation Module Database (Git URL: git@gitlab.pifsc.gov:centralized-data-tools/data-validation-module.git)');

--commit the DB_UPGRADE_LOGS record insertion
COMMIT;
