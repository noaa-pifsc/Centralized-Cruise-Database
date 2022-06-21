--------------------------------------------------------
--------------------------------------------------------
--Database Name: Centralized Cruise Database
--Database Description: Centralized Cruise Database to track information about each PIFSC research cruise including activities, chief scientists, regions, etc. to remove the need for each division/program to manage this information
--------------------------------------------------------
--------------------------------------------------------

--------------------------------------------------------
--Centralized Cruise Database - version 0.28 updates:
--------------------------------------------------------

--Upgraded from Version 0.2 (Git tag: db_log_db_v0.2) to  Version 0.3 (Git tag: db_log_db_v0.3) of the Database Logging Module Database (Git URL: git@github.com:PIFSC-NMFS-NOAA/PIFSC-DBLoggingModule.git)
@@"./upgrades/external_modules/DB_log_DDL_DML_upgrade_v0.3.sql"


--Upgraded from Version 1.3 (Git tag: DVM_db_v1.3) to  Version 1.4 (Git tag: DVM_db_v1.4) of the Data Validation Module Database (Git URL: git@gitlab.pifsc.gov:centralized-data-tools/data-validation-module.git)
@@"./upgrades/external_modules/DVM_DDL_DML_upgrade_v1.4.sql"

--Upgraded from Version 0.8 (Git tag: auth_app_db_v0.8) to  Version 1.2 (Git tag: auth_app_db_v1.2) of the Authorization Application Module Database (Git URL: git@gitlab.pifsc.gov:centralized-data-tools/authorization-application-module.git)
@@"./upgrades/external_modules/auth_app_DB_DDL_DML_update_v1.0.sql"
@@"./upgrades/external_modules/auth_app_DB_DDL_DML_update_v1.1.sql"
@@"./upgrades/external_modules/auth_app_DB_DDL_DML_update_v1.2.sql"

--Installed version 0.1 (Git tag: apex_feedback_form_db_v0.1) of the APEX Feedback Form database (Git URL: git@picgitlab.nmfs.local:centralized-data-tools/apex-feedback-form.git)
@@"./upgrades/external_modules/apex_feedback_form_DDL_DML_upgrade_v0.1.sql"

--Installed version 1.0 (Git tag: centralized_configuration_db_v1.0) of the Centralized Configuration database (Git URL: git@picgitlab.nmfs.local:centralized-data-tools/centralized-configuration.git)
@@"./upgrades/external_modules/centralized_configuration_DDL_DML_upgrade_v1.0.sql"

--Upgraded from Version 0.2 (Git tag: APX_Cust_Err_Handler_db_v0.2) to  Version 0.4 (Git tag: APX_Cust_Err_Handler_db_v0.4) of the APEX custom error handler module database (Git URL: git@picgitlab.nmfs.local:centralized-data-tools/apex_tools.git in the "Error Handling" folder)
@@"./upgrades/external_modules/Error_Handler_DDL_DML_upgrade_v0.3.sql"
@@"./upgrades/external_modules/Error_Handler_DDL_DML_upgrade_v0.4.sql"


ALTER PACKAGE CCD_CRUISE_PKG COMPILE;
ALTER PACKAGE CCD_DVM_PKG COMPILE;


--define the upgrade version in the database upgrade log table:
INSERT INTO DB_UPGRADE_LOGS (UPGRADE_APP_NAME, UPGRADE_VERSION, UPGRADE_DATE, UPGRADE_DESC) VALUES ('Centralized Cruise Database', '0.28', TO_DATE('14-JUN-22', 'DD-MON-YY'), 'Upgraded from Version 0.2 (Git tag: db_log_db_v0.2) to  Version 0.3 (Git tag: db_log_db_v0.3) of the Database Logging Module Database (Git URL: git@github.com:PIFSC-NMFS-NOAA/PIFSC-DBLoggingModule.git).  Upgraded from Version 1.3 (Git tag: DVM_db_v1.3) to  Version 1.4 (Git tag: DVM_db_v1.4) of the Data Validation Module Database (Git URL: git@gitlab.pifsc.gov:centralized-data-tools/data-validation-module.git).  Upgraded from Version 0.8 (Git tag: auth_app_db_v0.8) to  Version 1.2 (Git tag: auth_app_db_v1.2) of the Authorization Application Module Database (Git URL: git@gitlab.pifsc.gov:centralized-data-tools/authorization-application-module.git).  Installed version 0.1 (Git tag: apex_feedback_form_db_v0.1) of the APEX Feedback Form database (Git URL: git@picgitlab.nmfs.local:centralized-data-tools/apex-feedback-form.git).  Installed version 1.0 (Git tag: centralized_configuration_db_v1.0) of the Centralized Configuration database (Git URL: git@picgitlab.nmfs.local:centralized-data-tools/centralized-configuration.git).  Upgraded from Version 0.2 (Git tag: APX_Cust_Err_Handler_db_v0.2) to  Version 0.4 (Git tag: APX_Cust_Err_Handler_db_v0.4) of the APEX custom error handler module database (Git URL: git@picgitlab.nmfs.local:centralized-data-tools/apex_tools.git in the "Error Handling" folder).');


--commit the DB_UPGRADE_LOGS record insertion
COMMIT;
