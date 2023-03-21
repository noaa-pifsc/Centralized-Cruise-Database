--------------------------------------------------------
--------------------------------------------------------
--Database Name: DB Module Packager - APEX Application
--Database Description: DB Module Packager - APEX Application: This collection of custom modules is intended to provide functionality for PIFSC APEX applications
--------------------------------------------------------
--------------------------------------------------------


--------------------------------------------------------
--DB Module Packager - APEX Application - version 0.7 updates:
--------------------------------------------------------

--Upgraded from Version 0.2 (Git tag: APX_Cust_Err_Handler_db_v0.2) to  Version 0.4 (Git tag: APX_Cust_Err_Handler_db_v0.4) of the APEX custom error handler module database (Git URL: git@gitlab.pifsc.gov:centralized-data-tools/apex_tools.git in the "Error Handling" folder)
@@upgrades/external_modules/Error_Handler_DDL_DML_upgrade_v0.3.sql
@@upgrades/external_modules/Error_Handler_DDL_DML_upgrade_v0.4.sql


--define the upgrade version in the database upgrade log table:
INSERT INTO DB_UPGRADE_LOGS (UPGRADE_APP_NAME, UPGRADE_VERSION, UPGRADE_DATE, UPGRADE_DESC) VALUES ('DB Module Packager - APEX Application', '0.7', TO_DATE('26-OCT-21', 'DD-MON-YY'), 'Upgraded from Version 0.2 (Git tag: APX_Cust_Err_Handler_db_v0.2) to  Version 0.4 (Git tag: APX_Cust_Err_Handler_db_v0.4) of the APEX custom error handler module database (Git URL: git@gitlab.pifsc.gov:centralized-data-tools/apex_tools.git in the "Error Handling" folder)');

--commit the DB_UPGRADE_LOGS record insertion
COMMIT;
