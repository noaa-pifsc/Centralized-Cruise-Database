--------------------------------------------------------
--------------------------------------------------------
--Database Name: Centralized Cruise Database
--Database Description: Centralized Cruise Database to track information about each PIFSC research cruise including activities, chief scientists, regions, etc. to remove the need for each division/program to manage this information
--------------------------------------------------------
--------------------------------------------------------

--------------------------------------------------------
--Centralized Cruise Database - version 0.27 updates:
--------------------------------------------------------

--Upgraded from Version 1.2 (Git tag: DVM_db_v1.2) to  Version 1.3 (Git tag: DVM_db_v1.3) of the Data Validation Module Database (Git URL: git@gitlab.pifsc.gov:centralized-data-tools/data-validation-module.git)
@@"./upgrades/external_modules/DVM_DDL_DML_upgrade_v1.3.sql"

--Upgraded from Version 0.7 (Git tag: auth_app_db_v0.7) to  Version 0.8 (Git tag: auth_app_db_v0.8) of the Authorization Application Module Database (Git URL: git@gitlab.pifsc.gov:centralized-data-tools/authorization-application-module.git)
@@"./upgrades/external_modules/auth_app_DB_DDL_DML_update_v0.8.sql"



--define the upgrade version in the database upgrade log table:
INSERT INTO DB_UPGRADE_LOGS (UPGRADE_APP_NAME, UPGRADE_VERSION, UPGRADE_DATE, UPGRADE_DESC) VALUES ('Centralized Cruise Database', '0.27', TO_DATE('30-NOV-20', 'DD-MON-YY'), 'Upgraded from Version 1.2 (Git tag: DVM_db_v1.2) to  Version 1.3 (Git tag: DVM_db_v1.3) of the Data Validation Module Database (Git URL: git@gitlab.pifsc.gov:centralized-data-tools/data-validation-module.git).  Upgraded from Version 0.7 (Git tag: auth_app_db_v0.7) to  Version 0.8 (Git tag: auth_app_db_v0.8) of the Authorization Application Module Database (Git URL: git@gitlab.pifsc.gov:centralized-data-tools/authorization-application-module.git)');


--commit the DB_UPGRADE_LOGS record insertion
COMMIT;
