--------------------------------------------------------
--------------------------------------------------------
--Database Name: Centralized Cruise Database
--Database Description: Centralized Cruise Database to track information about each PIFSC research cruise including activities, chief scientists, regions, etc. to remove the need for each division/program to manage this information
--------------------------------------------------------
--------------------------------------------------------


--------------------------------------------------------
--Centralized Cruise Database - version 0.5 updates:
--------------------------------------------------------


--Installed Version 0.7 of the Authorization Application Module Database (Git URL: git@gitlab.pifsc.gov:centralized-data-tools/authorization-application-module.git)
@@"./external_modules/auth_app_DB_DDL_DML_update_v0.7.sql";

--define the upgrade version in the database upgrade log table:
INSERT INTO DB_UPGRADE_LOGS (UPGRADE_APP_NAME, UPGRADE_VERSION, UPGRADE_DATE, UPGRADE_DESC) VALUES ('Centralized Cruise Database', '0.5', TO_DATE('31-OCT-19', 'DD-MON-YY'), 'Upgraded the Authorization Application Module Database from 0.6 to 0.7 to implement the new ICAM/Whitepages user authentication');

--commit the DB_UPGRADE_LOGS record insertion
COMMIT;
