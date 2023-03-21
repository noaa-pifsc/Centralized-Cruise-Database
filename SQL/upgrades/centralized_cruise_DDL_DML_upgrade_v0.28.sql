--------------------------------------------------------
--------------------------------------------------------
--Database Name: Centralized Cruise Database
--Database Description: Centralized Cruise Database to track information about each PIFSC research cruise including activities, chief scientists, regions, etc. to remove the need for each division/program to manage this information
--------------------------------------------------------
--------------------------------------------------------

--------------------------------------------------------
--Centralized Cruise Database - version 0.28 updates:
--------------------------------------------------------

--Installed Versions 0.6 (Git tag: DMP_APX_v0.6) to 1.2 (Git tag: DMP_APX_v1.2) of the APEX use case version of the DB Module Packager (Git URL: git@picgitlab.nmfs.local:centralized-data-tools/db-module-packager.git).  The installed versions of the database modules matched the previous version of the Centralized Cruise Database
@@"./upgrades/external_modules/APEX_app_DDL_DML_upgrade_v0.6.sql"
@@"./upgrades/external_modules/APEX_app_DDL_DML_upgrade_v0.7.sql"
@@"./upgrades/external_modules/APEX_app_DDL_DML_upgrade_v0.8.sql"
@@"./upgrades/external_modules/APEX_app_DDL_DML_upgrade_v0.9.sql"
@@"./upgrades/external_modules/APEX_app_DDL_DML_upgrade_v1.0.sql"
@@"./upgrades/external_modules/APEX_app_DDL_DML_upgrade_v1.1.sql"
@@"./upgrades/external_modules/APEX_app_DDL_DML_upgrade_v1.2.sql"


ALTER PACKAGE CCD_CRUISE_PKG COMPILE;
ALTER PACKAGE CCD_DVM_PKG COMPILE;


--define the upgrade version in the database upgrade log table:
INSERT INTO DB_UPGRADE_LOGS (UPGRADE_APP_NAME, UPGRADE_VERSION, UPGRADE_DATE, UPGRADE_DESC) VALUES ('Centralized Cruise Database', '0.28', TO_DATE('14-JUN-22', 'DD-MON-YY'), 'Installed Versions 0.6 (Git tag: DMP_APX_v0.6) to 1.2 (Git tag: DMP_APX_v1.2) of the APEX use case version of the DB Module Packager (Git URL: git@picgitlab.nmfs.local:centralized-data-tools/db-module-packager.git).  The installed versions of the database modules matched the previous version of the Centralized Cruise Database');


--commit the DB_UPGRADE_LOGS record insertion
COMMIT;
