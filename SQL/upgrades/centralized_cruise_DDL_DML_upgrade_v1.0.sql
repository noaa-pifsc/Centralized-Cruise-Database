--------------------------------------------------------
--------------------------------------------------------
--Database Name: Centralized Cruise Database
--Database Description: Centralized Cruise Database to track information about each PIFSC research cruise including activities, chief scientists, regions, etc. to remove the need for each division/program to manage this information
--------------------------------------------------------
--------------------------------------------------------

--------------------------------------------------------
--Centralized Cruise Database - version 1.0 updates:
--------------------------------------------------------

--Upgraded from Version 0.4 (Git tag: APX_Cust_Err_Handler_db_v0.4) to  Version 1.0 (Git tag: APX_Cust_Err_Handler_db_v1.0) of the APEX custom error handler module database (Git URL: git@picgitlab.nmfs.local:centralized-data-tools/apex_tools.git in the "Error Handling" folder)
@@"./upgrades/external_modules/Error_Handler_DDL_DML_upgrade_v1.0.sql"


--drop all AUTH_APP objects to use the CAS versions of the objects
DROP TABLE AUTH_APP_GROUPS cascade constraints PURGE;
DROP TABLE AUTH_APP_GROUPS_HIST cascade constraints PURGE;
DROP SEQUENCE AUTH_APP_GROUPS_HIST_SEQ;
DROP SEQUENCE AUTH_APP_GROUPS_SEQ;
DROP PACKAGE AUTH_APP_PKG;
DROP TABLE AUTH_APP_USERS cascade constraints PURGE;
DROP TABLE AUTH_APP_USERS_HIST cascade constraints PURGE;
DROP SEQUENCE AUTH_APP_USERS_HIST_SEQ;
DROP SEQUENCE AUTH_APP_USERS_SEQ;
DROP VIEW AUTH_APP_USERS_V;
DROP TABLE AUTH_APP_USER_GROUPS cascade constraints PURGE;
DROP TABLE AUTH_APP_USER_GROUPS_HIST cascade constraints PURGE;
DROP SEQUENCE AUTH_APP_USER_GROUPS_HIST_SEQ;
DROP SEQUENCE AUTH_APP_USER_GROUPS_SEQ;
DROP VIEW AUTH_APP_USER_GROUPS_V;

--delete the DB upgrade log records for the Authorization Application Database:
DELETE FROM DB_UPGRADE_LOGS WHERE UPGRADE_APP_NAME = 'Authorization Application Database';


--define the upgrade version in the database upgrade log table:
INSERT INTO DB_UPGRADE_LOGS (UPGRADE_APP_NAME, UPGRADE_VERSION, UPGRADE_DATE, UPGRADE_DESC) VALUES ('Centralized Cruise Database', '1.0', TO_DATE('30-MAR-23', 'DD-MON-YY'), 'Upgraded from Version 0.4 (Git tag: APX_Cust_Err_Handler_db_v0.4) to  Version 1.0 (Git tag: APX_Cust_Err_Handler_db_v1.0) of the APEX custom error handler module database (Git URL: git@picgitlab.nmfs.local:centralized-data-tools/apex_tools.git in the "Error Handling" folder).  Dropped the standalone AAM');


--commit the DB_UPGRADE_LOGS record insertion
COMMIT;
