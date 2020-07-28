--------------------------------------------------------
--------------------------------------------------------
--Database Name: Centralized Cruise Database
--Database Description: Centralized Cruise Database to track information about each PIFSC research cruise including activities, chief scientists, regions, etc. to remove the need for each division/program to manage this information
--------------------------------------------------------
--------------------------------------------------------

--------------------------------------------------------
--Centralized Cruise Database - version 0.21 updates:
--------------------------------------------------------

--Installing Version 0.12 (Git tag: DVM_db_v0.12) of the Data Validation Module Database (Git URL: git@gitlab.pifsc.gov:centralized-data-tools/data-validation-module.git)
@@"./external_modules/DVM_DDL_DML_upgrade_v0.12.sql";



--define missing view columns from previous update:
COMMENT ON COLUMN CCD_CRUISE_DVM_RULE_EVAL_RPT_V.SCI_CENTER_DIV_NAME IS 'Name of the given Science Center Division';
COMMENT ON COLUMN CCD_CRUISE_DVM_RULE_EVAL_RPT_V.CRUISE_ID IS 'Primary key for the CCD_CRUISES table';
COMMENT ON COLUMN CCD_CRUISE_DVM_RULE_EVAL_RPT_V.CRUISE_NAME IS 'The name of the given cruise designated by NOAA (e.g. SE-15-01)';
COMMENT ON COLUMN CCD_CRUISE_DVM_RULE_EVAL_RPT_V.STD_SVY_NAME_VAL IS 'This field contains the Standard Survey Name defined for the given cruise.  If the STD_SVY_NAME_ID field is defined then the associated CCD_STD_SVY_NAMES.STD_SVY_NAME is used because the foreign key is given precedence, otherwise the STD_SVY_NAME_OTH field value is used';
COMMENT ON COLUMN CCD_CRUISE_DVM_RULE_EVAL_RPT_V.NUM_LEGS IS 'The number of cruise legs associated with the given cruise';
COMMENT ON COLUMN CCD_CRUISE_DVM_RULE_EVAL_RPT_V.FORMAT_CRUISE_START_DATE IS 'The formatted start date for the given cruise (based on the earliest associated cruise leg''s start date) in MM/DD/YYYY format';
COMMENT ON COLUMN CCD_CRUISE_DVM_RULE_EVAL_RPT_V.FORMAT_CRUISE_END_DATE IS 'The formatted end date for the given cruise (based on the latest associated cruise leg''s end date) in MM/DD/YYYY format';
COMMENT ON COLUMN CCD_CRUISE_DVM_RULE_EVAL_RPT_V.LEG_NAME_CD_LIST IS 'Comma-delimited list of leg names associated with the given cruise';
COMMENT ON COLUMN CCD_CRUISE_DVM_RULE_EVAL_RPT_V.RULE_SET_ACTIVE_YN IS 'Flag to indicate if the given rule set is currently active (Y) or inactive (N).  Only one rule set can be active at any given time';
COMMENT ON COLUMN CCD_CRUISE_DVM_RULE_EVAL_RPT_V.FORMAT_RULE_SET_CREATE_DATE IS 'The formatted date/time that the given rule set was created (MM/DD/YYYY HH24:MI:SS format)';
COMMENT ON COLUMN CCD_CRUISE_DVM_RULE_EVAL_RPT_V.FORMAT_RULE_SET_INACTIVE_DATE IS 'The formatted date/time that the given rule set was deactivated (due to a change in active rules) (MM/DD/YYYY HH24:MI:SS format)';
COMMENT ON COLUMN CCD_CRUISE_DVM_RULE_EVAL_RPT_V.RULE_DATA_STREAM_CODE IS 'The code for the given validation rule set''s data stream';
COMMENT ON COLUMN CCD_CRUISE_DVM_RULE_EVAL_RPT_V.RULE_DATA_STREAM_NAME IS 'The name for the given validation rule set''s data stream';
COMMENT ON COLUMN CCD_CRUISE_DVM_RULE_EVAL_RPT_V.ISS_TYPE_NAME IS 'The name of the given QC validation criteria';
COMMENT ON COLUMN CCD_CRUISE_DVM_RULE_EVAL_RPT_V.ISS_TYPE_DESC IS 'The description for the given QC validation issue type';
COMMENT ON COLUMN CCD_CRUISE_DVM_RULE_EVAL_RPT_V.ISS_SEVERITY_CODE IS 'The code for the given issue severity';
COMMENT ON COLUMN CCD_CRUISE_DVM_RULE_EVAL_RPT_V.ISS_SEVERITY_NAME IS 'The name for the given issue severity';
COMMENT ON COLUMN CCD_CRUISE_DVM_RULE_EVAL_RPT_V.FORMAT_EVAL_DATE IS 'The formatted date/time the given parent record was evaluated using the DVM for the associated data stream (in MM/DD/YYYY HH24:MI:SS format)';


--define the upgrade version in the database upgrade log table:
INSERT INTO DB_UPGRADE_LOGS (UPGRADE_APP_NAME, UPGRADE_VERSION, UPGRADE_DATE, UPGRADE_DESC) VALUES ('Centralized Cruise Database', '0.21', TO_DATE('28-JUL-20', 'DD-MON-YY'), 'Installed Version 0.12 (Git tag: DVM_db_v0.12) of the Data Validation Module Database (Git URL: git@gitlab.pifsc.gov:centralized-data-tools/data-validation-module.git).  Defined the column comments for the CCD_CRUISE_DVM_RULE_EVAL_RPT_V view that were missed on the last update');

--commit the DB_UPGRADE_LOGS record insertion
COMMIT;
