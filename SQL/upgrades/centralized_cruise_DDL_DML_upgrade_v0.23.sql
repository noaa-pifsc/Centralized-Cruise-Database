--------------------------------------------------------
--------------------------------------------------------
--Database Name: Centralized Cruise Database
--Database Description: Centralized Cruise Database to track information about each PIFSC research cruise including activities, chief scientists, regions, etc. to remove the need for each division/program to manage this information
--------------------------------------------------------
--------------------------------------------------------

--------------------------------------------------------
--Centralized Cruise Database - version 0.23 updates:
--------------------------------------------------------



--Installing Version 1.0 (Git tag: DVM_db_v1.0) of the Data Validation Module Database (Git URL: git@gitlab.pifsc.gov:centralized-data-tools/data-validation-module.git)
@@"./external_modules/DVM_DDL_DML_upgrade_v1.0.sql";

--recompile invalid views caused by the DVM upgrade:
alter view CCD_CRUISE_DVM_RULE_EVAL_RPT_V compile;

alter view CCD_CRUISE_DVM_RULE_EVAL_V compile;
alter view CCD_CRUISE_DVM_RULES_RPT_V compile;
alter view CCD_CRUISE_DVM_RULES_V compile;
alter view CCD_CRUISE_ISS_SUMM_V compile;
alter view CCD_CRUISE_SUMM_ISS_V compile;
alter package CCD_DVM_PKG compile;


--define the upgrade version in the database upgrade log table:
INSERT INTO DB_UPGRADE_LOGS (UPGRADE_APP_NAME, UPGRADE_VERSION, UPGRADE_DATE, UPGRADE_DESC) VALUES ('Centralized Cruise Database', '0.23', TO_DATE('30-JUL-20', 'DD-MON-YY'), 'Installed Version 1.0 (Git tag: DVM_db_v1.0) of the Data Validation Module Database (Git URL: git@gitlab.pifsc.gov:centralized-data-tools/data-validation-module.git).  Recompiled views and the CCD_DVM_PKG package that were invalidated by the DVM DB upgrade');


--commit the DB_UPGRADE_LOGS record insertion
COMMIT;
