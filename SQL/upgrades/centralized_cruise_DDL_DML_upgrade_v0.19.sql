--------------------------------------------------------
--------------------------------------------------------
--Database Name: Centralized Cruise Database
--Database Description: Centralized Cruise Database to track information about each PIFSC research cruise including activities, chief scientists, regions, etc. to remove the need for each division/program to manage this information
--------------------------------------------------------
--------------------------------------------------------

--------------------------------------------------------
--Centralized Cruise Database - version 0.19 updates:
--------------------------------------------------------



--Installing Version 0.10 (Git tag: DVM_db_v0.10) of the Data Validation Module Database (Git URL: git@gitlab.pifsc.gov:centralized-data-tools/data-validation-module.git)
@@"./external_modules/DVM_DDL_DML_upgrade_v0.10.sql";


create or replace view
CCD_CRUISE_DVM_RULES_V

AS
select
DVM_PTA_RULE_SETS_V.PTA_RULE_SET_ID,
DVM_PTA_RULE_SETS_V.PTA_ISS_ID,
DVM_PTA_RULE_SETS_V.FIRST_EVAL_DATE,
DVM_PTA_RULE_SETS_V.FORMAT_FIRST_EVAL_DATE,
DVM_PTA_RULE_SETS_V.LAST_EVAL_DATE,
DVM_PTA_RULE_SETS_V.FORMAT_LAST_EVAL_DATE,
DVM_PTA_RULE_SETS_V.RULE_SET_ID,
DVM_PTA_RULE_SETS_V.RULE_SET_ACTIVE_YN,
DVM_PTA_RULE_SETS_V.RULE_SET_CREATE_DATE,
DVM_PTA_RULE_SETS_V.FORMAT_RULE_SET_CREATE_DATE,
DVM_PTA_RULE_SETS_V.RULE_SET_INACTIVE_DATE,
DVM_PTA_RULE_SETS_V.FORMAT_RULE_SET_INACTIVE_DATE,
DVM_PTA_RULE_SETS_V.RULE_DATA_STREAM_ID,
DVM_PTA_RULE_SETS_V.RULE_DATA_STREAM_CODE,
DVM_PTA_RULE_SETS_V.RULE_DATA_STREAM_NAME,
DVM_PTA_RULE_SETS_V.RULE_DATA_STREAM_DESC,
DVM_PTA_RULE_SETS_V.RULE_DATA_STREAM_PAR_TABLE,
DVM_PTA_RULE_SETS_V.ISS_TYP_ASSOC_ID,
DVM_PTA_RULE_SETS_V.QC_OBJECT_ID,
DVM_PTA_RULE_SETS_V.OBJECT_NAME,
DVM_PTA_RULE_SETS_V.QC_OBJ_ACTIVE_YN,
DVM_PTA_RULE_SETS_V.QC_SORT_ORDER,
DVM_PTA_RULE_SETS_V.ISS_TYPE_ID,
DVM_PTA_RULE_SETS_V.ISS_TYPE_NAME,
DVM_PTA_RULE_SETS_V.ISS_TYPE_COMMENT_TEMPLATE,
DVM_PTA_RULE_SETS_V.ISS_TYPE_DESC,
DVM_PTA_RULE_SETS_V.IND_FIELD_NAME,
DVM_PTA_RULE_SETS_V.APP_LINK_TEMPLATE,
DVM_PTA_RULE_SETS_V.ISS_SEVERITY_ID,
DVM_PTA_RULE_SETS_V.ISS_SEVERITY_CODE,
DVM_PTA_RULE_SETS_V.ISS_SEVERITY_NAME,
DVM_PTA_RULE_SETS_V.ISS_SEVERITY_DESC,
DVM_PTA_RULE_SETS_V.DATA_STREAM_ID,
DVM_PTA_RULE_SETS_V.DATA_STREAM_CODE,
DVM_PTA_RULE_SETS_V.DATA_STREAM_NAME,
DVM_PTA_RULE_SETS_V.DATA_STREAM_DESC,
DVM_PTA_RULE_SETS_V.DATA_STREAM_PAR_TABLE,
DVM_PTA_RULE_SETS_V.ISS_TYPE_ACTIVE_YN,


CCD_CRUISE_V.CRUISE_ID,
CCD_CRUISE_V.CRUISE_NAME,
CCD_CRUISE_V.CRUISE_NOTES,
CCD_CRUISE_V.CRUISE_DESC,
CCD_CRUISE_V.OBJ_BASED_METRICS,
CCD_CRUISE_V.SCI_CENTER_DIV_ID,
CCD_CRUISE_V.SCI_CENTER_DIV_CODE,
CCD_CRUISE_V.SCI_CENTER_DIV_NAME,
CCD_CRUISE_V.SCI_CENTER_DIV_DESC,
CCD_CRUISE_V.SCI_CENTER_ID,
CCD_CRUISE_V.SCI_CENTER_NAME,
CCD_CRUISE_V.SCI_CENTER_DESC,
CCD_CRUISE_V.STD_SVY_NAME_ID,
CCD_CRUISE_V.STD_SVY_NAME,
CCD_CRUISE_V.STD_SVY_DESC,
CCD_CRUISE_V.SVY_FREQ_ID,
CCD_CRUISE_V.SVY_FREQ_NAME,
CCD_CRUISE_V.SVY_FREQ_DESC,
CCD_CRUISE_V.STD_SVY_NAME_OTH,
CCD_CRUISE_V.STD_SVY_NAME_VAL,
CCD_CRUISE_V.SVY_TYPE_ID,
CCD_CRUISE_V.SVY_TYPE_NAME,
CCD_CRUISE_V.SVY_TYPE_DESC,
CCD_CRUISE_V.CRUISE_URL,
CCD_CRUISE_V.CRUISE_CONT_EMAIL,
CCD_CRUISE_V.NUM_LEGS,
CCD_CRUISE_V.CRUISE_START_DATE,
CCD_CRUISE_V.FORMAT_CRUISE_START_DATE,
CCD_CRUISE_V.CRUISE_END_DATE,
CCD_CRUISE_V.FORMAT_CRUISE_END_DATE,
CCD_CRUISE_V.CRUISE_DAS,
CCD_CRUISE_V.CRUISE_LEN_DAYS,
CCD_CRUISE_V.CRUISE_YEAR,
CCD_CRUISE_V.CRUISE_FISC_YEAR,
CCD_CRUISE_V.LEG_NAME_CD_LIST,
CCD_CRUISE_V.LEG_NAME_SCD_LIST,
CCD_CRUISE_V.LEG_NAME_RC_LIST,
CCD_CRUISE_V.LEG_NAME_BR_LIST,
CCD_CRUISE_V.LEG_NAME_DATES_CD_LIST,
CCD_CRUISE_V.LEG_NAME_DATES_SCD_LIST,
CCD_CRUISE_V.LEG_NAME_DATES_RC_LIST,
CCD_CRUISE_V.LEG_NAME_DATES_BR_LIST
FROM
DVM_PTA_RULE_SETS_V INNER JOIN
CCD_CRUISE_V ON
DVM_PTA_RULE_SETS_V.PTA_ISS_ID = CCD_CRUISE_V.PTA_ISS_ID
order by
CCD_CRUISE_V.SCI_CENTER_NAME,
CCD_CRUISE_V.STD_SVY_NAME,
CCD_CRUISE_V.CRUISE_NAME,
DVM_PTA_RULE_SETS_V.DATA_STREAM_CODE,
DVM_PTA_RULE_SETS_V.ISS_TYPE_NAME
;

COMMENT ON TABLE CCD_CRUISE_DVM_RULES_V IS 'Cruise DVM Rules (View)

This view returns all of the DVM PTA validation rule sets and all related validation rule set information and cruise information';

COMMENT ON COLUMN CCD_CRUISE_DVM_RULES_V.PTA_RULE_SET_ID IS 'The primary key field for the DVM_PTA_RULE_SETS table';
COMMENT ON COLUMN CCD_CRUISE_DVM_RULES_V.PTA_ISS_ID IS 'Foreign key reference to the PTA Issue record associated validation rule set (DVM_PTA_ISSUES)';
COMMENT ON COLUMN CCD_CRUISE_DVM_RULES_V.FIRST_EVAL_DATE IS 'The date/time the rule set was first evaluated for the given parent issue record';
COMMENT ON COLUMN CCD_CRUISE_DVM_RULES_V.FORMAT_FIRST_EVAL_DATE IS 'The formatted date/time the rule set was first evaluated for the given parent issue record (MM/DD/YYYY HH24:MI format)';
COMMENT ON COLUMN CCD_CRUISE_DVM_RULES_V.LAST_EVAL_DATE IS 'The date/time the rule set was most recently evaluated for the given parent issue record';
COMMENT ON COLUMN CCD_CRUISE_DVM_RULES_V.FORMAT_LAST_EVAL_DATE IS 'The formatted date/time the rule set was most recently evaluated for the given parent issue record (MM/DD/YYYY HH24:MI format)';
COMMENT ON COLUMN CCD_CRUISE_DVM_RULES_V.RULE_SET_ID IS 'Primary key for the DVM_RULE_SETS table';
COMMENT ON COLUMN CCD_CRUISE_DVM_RULES_V.RULE_SET_ACTIVE_YN IS 'Flag to indicate if the given rule set is currently active (Y) or inactive (N).  Only one rule set can be active at any given time';
COMMENT ON COLUMN CCD_CRUISE_DVM_RULES_V.RULE_SET_CREATE_DATE IS 'The date/time that the given rule set was created';
COMMENT ON COLUMN CCD_CRUISE_DVM_RULES_V.FORMAT_RULE_SET_CREATE_DATE IS 'The formatted date/time that the given rule set was created (MM/DD/YYYY HH24:MI:SS format)';
COMMENT ON COLUMN CCD_CRUISE_DVM_RULES_V.RULE_SET_INACTIVE_DATE IS 'The date/time that the given rule set was deactivated (due to a change in active rules)';
COMMENT ON COLUMN CCD_CRUISE_DVM_RULES_V.FORMAT_RULE_SET_INACTIVE_DATE IS 'The formatted date/time that the given rule set was deactivated (due to a change in active rules) (MM/DD/YYYY HH24:MI:SS format)';
COMMENT ON COLUMN CCD_CRUISE_DVM_RULES_V.RULE_DATA_STREAM_ID IS 'Foreign key reference to the DVM_DATA_STREAMS table that represents the rule set''s data stream for the given DVM rule set';
COMMENT ON COLUMN CCD_CRUISE_DVM_RULES_V.RULE_DATA_STREAM_CODE IS 'The code for the given validation rule set''s data stream';
COMMENT ON COLUMN CCD_CRUISE_DVM_RULES_V.RULE_DATA_STREAM_NAME IS 'The name for the given validation rule set''s data stream';
COMMENT ON COLUMN CCD_CRUISE_DVM_RULES_V.RULE_DATA_STREAM_DESC IS 'The description for the given validation rule set''s data stream';
COMMENT ON COLUMN CCD_CRUISE_DVM_RULES_V.RULE_DATA_STREAM_PAR_TABLE IS 'The Data stream''s parent table name for the given validation rule set (used when evaluating QC validation criteria to specify a given parent table)';
COMMENT ON COLUMN CCD_CRUISE_DVM_RULES_V.ISS_TYP_ASSOC_ID IS 'Primary Key for the DVM_ISS_TYP_ASSOC table';
COMMENT ON COLUMN CCD_CRUISE_DVM_RULES_V.QC_OBJECT_ID IS 'The Data QC Object that the issue type is determined from.  If this is NULL it is not associated with a QC query validation constraint (e.g. DB issue)';
COMMENT ON COLUMN CCD_CRUISE_DVM_RULES_V.OBJECT_NAME IS 'The name of the object that is used in the given QC validation criteria';
COMMENT ON COLUMN CCD_CRUISE_DVM_RULES_V.QC_OBJ_ACTIVE_YN IS 'Flag to indicate if the QC object is active (Y) or inactive (N)';
COMMENT ON COLUMN CCD_CRUISE_DVM_RULES_V.QC_SORT_ORDER IS 'Relative sort order for the QC object to be executed in';
COMMENT ON COLUMN CCD_CRUISE_DVM_RULES_V.ISS_TYPE_ID IS 'The issue type for the given issue';
COMMENT ON COLUMN CCD_CRUISE_DVM_RULES_V.ISS_TYPE_NAME IS 'The name of the given QC validation criteria';
COMMENT ON COLUMN CCD_CRUISE_DVM_RULES_V.ISS_TYPE_COMMENT_TEMPLATE IS 'The template for the specific issue description that exists in the specific issue condition.  This field should contain placeholders in the form: [PLACEHOLDER] where PLACEHOLDER is the corresponding field name in the result set that will have its placeholder replaced by the corresponding result set field value.  This is NULL only when XML_QC_OBJ_ID is NULL';
COMMENT ON COLUMN CCD_CRUISE_DVM_RULES_V.ISS_TYPE_DESC IS 'The description for the given QC validation issue type';
COMMENT ON COLUMN CCD_CRUISE_DVM_RULES_V.IND_FIELD_NAME IS 'The field in the result set that indicates if the current issue type has been identified.  A ''Y'' value indicates that the given issue condition has been identified.  When XML_QC_OBJ_ID is NULL this is the constant name that is used to refer to the current issue type';
COMMENT ON COLUMN CCD_CRUISE_DVM_RULES_V.APP_LINK_TEMPLATE IS 'The template for the specific application link to resolve the given data issue.  This is intended to provide the necessary parameters in a given URL that can be used to generate the full URL based on the server (e.g. generate the parameters for a given cruise leg and the APEX application will use the APP_ID and APP_SESSION at runtime to generate the full URL - f?p=[APP_ID]:220:[APP_SESSION]::NO::CRUISE_ID,CRUISE_ID_COPY:[CRUISE_ID],)';
COMMENT ON COLUMN CCD_CRUISE_DVM_RULES_V.ISS_SEVERITY_ID IS 'The Severity of the given issue type criteria.  These indicate the status of the given issue (e.g. warnings, data issues, violations of law, etc.)';
COMMENT ON COLUMN CCD_CRUISE_DVM_RULES_V.ISS_SEVERITY_CODE IS 'The code for the given issue severity';
COMMENT ON COLUMN CCD_CRUISE_DVM_RULES_V.ISS_SEVERITY_NAME IS 'The name for the given issue severity';
COMMENT ON COLUMN CCD_CRUISE_DVM_RULES_V.ISS_SEVERITY_DESC IS 'The description for the given issue severity';
COMMENT ON COLUMN CCD_CRUISE_DVM_RULES_V.DATA_STREAM_ID IS 'Foreign key reference to the DVM_DATA_STREAMS table that represents the issue type''s data stream for the given DVM rule set';
COMMENT ON COLUMN CCD_CRUISE_DVM_RULES_V.DATA_STREAM_CODE IS 'The code for the given issue type''s data stream';
COMMENT ON COLUMN CCD_CRUISE_DVM_RULES_V.DATA_STREAM_NAME IS 'The name for the given issue type''s data stream';
COMMENT ON COLUMN CCD_CRUISE_DVM_RULES_V.DATA_STREAM_DESC IS 'The description for the given issue type''s data stream';
COMMENT ON COLUMN CCD_CRUISE_DVM_RULES_V.DATA_STREAM_PAR_TABLE IS 'The Data stream''s parent table name (used when evaluating QC validation criteria to specify a given parent table)';
COMMENT ON COLUMN CCD_CRUISE_DVM_RULES_V.ISS_TYPE_ACTIVE_YN IS 'Flag to indicate if the given issue type criteria is active';



COMMENT ON COLUMN CCD_CRUISE_DVM_RULES_V.CRUISE_ID IS 'Primary key for the CCD_CRUISES table';
COMMENT ON COLUMN CCD_CRUISE_DVM_RULES_V.CRUISE_NAME IS 'The name of the given cruise designated by NOAA (e.g. SE-15-01)';
COMMENT ON COLUMN CCD_CRUISE_DVM_RULES_V.CRUISE_NOTES IS 'Any notes for the given research cruise';
COMMENT ON COLUMN CCD_CRUISE_DVM_RULES_V.CRUISE_DESC IS 'Description for the given research cruise';
COMMENT ON COLUMN CCD_CRUISE_DVM_RULES_V.OBJ_BASED_METRICS IS 'Objective Based Metrics for the given research cruise';
COMMENT ON COLUMN CCD_CRUISE_DVM_RULES_V.SCI_CENTER_DIV_ID IS 'Primary key for the Science Center Division table';
COMMENT ON COLUMN CCD_CRUISE_DVM_RULES_V.SCI_CENTER_DIV_CODE IS 'Abbreviated code for the given Science Center Division';
COMMENT ON COLUMN CCD_CRUISE_DVM_RULES_V.SCI_CENTER_DIV_NAME IS 'Name of the given Science Center Division';
COMMENT ON COLUMN CCD_CRUISE_DVM_RULES_V.SCI_CENTER_DIV_DESC IS 'Description for the given Science Center Division';
COMMENT ON COLUMN CCD_CRUISE_DVM_RULES_V.SCI_CENTER_ID IS 'Primary key for the Science Center table';
COMMENT ON COLUMN CCD_CRUISE_DVM_RULES_V.SCI_CENTER_NAME IS 'Name of the given Science Center';
COMMENT ON COLUMN CCD_CRUISE_DVM_RULES_V.SCI_CENTER_DESC IS 'Description for the given Science Center';
COMMENT ON COLUMN CCD_CRUISE_DVM_RULES_V.STD_SVY_NAME_ID IS 'Primary key for the Standard Survey Name table';
COMMENT ON COLUMN CCD_CRUISE_DVM_RULES_V.STD_SVY_NAME IS 'Name of the given Standard Survey Name';
COMMENT ON COLUMN CCD_CRUISE_DVM_RULES_V.STD_SVY_DESC IS 'Description for the given Standard Survey Name';
COMMENT ON COLUMN CCD_CRUISE_DVM_RULES_V.SVY_FREQ_ID IS 'Primary key for the Survey Frequency table';
COMMENT ON COLUMN CCD_CRUISE_DVM_RULES_V.SVY_FREQ_NAME IS 'Name of the given Survey Frequency';
COMMENT ON COLUMN CCD_CRUISE_DVM_RULES_V.SVY_FREQ_DESC IS 'Description for the given Survey Frequency';
COMMENT ON COLUMN CCD_CRUISE_DVM_RULES_V.STD_SVY_NAME_OTH IS 'Field defines a Standard Survey Name that is not included in the Standard Survey Name table';
COMMENT ON COLUMN CCD_CRUISE_DVM_RULES_V.STD_SVY_NAME_VAL IS 'This field contains the Standard Survey Name defined for the given cruise.  If the STD_SVY_NAME_ID field is defined then the associated CCD_STD_SVY_NAMES.STD_SVY_NAME is used because the foreign key is given precedence, otherwise the STD_SVY_NAME_OTH field value is used';
COMMENT ON COLUMN CCD_CRUISE_DVM_RULES_V.SVY_TYPE_ID IS 'Primary key for the Survey Type table';
COMMENT ON COLUMN CCD_CRUISE_DVM_RULES_V.SVY_TYPE_NAME IS 'Name of the given Survey Type';
COMMENT ON COLUMN CCD_CRUISE_DVM_RULES_V.SVY_TYPE_DESC IS 'Description for the given Survey Type';
COMMENT ON COLUMN CCD_CRUISE_DVM_RULES_V.CRUISE_URL IS 'The Cruise URL (Referred to as "Survey URL" in FINSS System) for the given Cruise';
COMMENT ON COLUMN CCD_CRUISE_DVM_RULES_V.CRUISE_CONT_EMAIL IS 'The Cruise Contact Email (Referred to as "Survey Contact Email" in FINSS System) for the given Cruise';
COMMENT ON COLUMN CCD_CRUISE_DVM_RULES_V.PTA_ISS_ID IS 'Foreign key reference to the Issues (PTA) intersection table';
COMMENT ON COLUMN CCD_CRUISE_DVM_RULES_V.NUM_LEGS IS 'The number of cruise legs associated with the given cruise';
COMMENT ON COLUMN CCD_CRUISE_DVM_RULES_V.CRUISE_START_DATE IS 'The start date for the given cruise (based on the earliest associated cruise leg''s start date)';
COMMENT ON COLUMN CCD_CRUISE_DVM_RULES_V.FORMAT_CRUISE_START_DATE IS 'The formatted start date for the given cruise (based on the earliest associated cruise leg''s start date) in MM/DD/YYYY format';
COMMENT ON COLUMN CCD_CRUISE_DVM_RULES_V.CRUISE_END_DATE IS 'The end date for the given cruise (based on the latest associated cruise leg''s end date)';
COMMENT ON COLUMN CCD_CRUISE_DVM_RULES_V.FORMAT_CRUISE_END_DATE IS 'The formatted end date for the given cruise (based on the latest associated cruise leg''s end date) in MM/DD/YYYY format';
COMMENT ON COLUMN CCD_CRUISE_DVM_RULES_V.CRUISE_DAS IS 'The total number of days at sea for each of the legs associated with the given cruise';
COMMENT ON COLUMN CCD_CRUISE_DVM_RULES_V.CRUISE_LEN_DAYS IS 'The total number of days between the Cruise Start and End Dates for the given cruise';
COMMENT ON COLUMN CCD_CRUISE_DVM_RULES_V.CRUISE_YEAR IS 'The calendar year for the given cruise (based on the earliest associated cruise leg''s start date)';
COMMENT ON COLUMN CCD_CRUISE_DVM_RULES_V.CRUISE_FISC_YEAR IS 'The calendar year for the given cruise (based on the earliest associated cruise leg''s start date)';
COMMENT ON COLUMN CCD_CRUISE_DVM_RULES_V.LEG_NAME_CD_LIST IS 'Comma-delimited list of leg names associated with the given cruise';
COMMENT ON COLUMN CCD_CRUISE_DVM_RULES_V.LEG_NAME_SCD_LIST IS 'Semicolon-delimited list of leg names associated with the given cruise';
COMMENT ON COLUMN CCD_CRUISE_DVM_RULES_V.LEG_NAME_RC_LIST IS 'Return carriage/new line delimited list of leg names associated with the given cruise';
COMMENT ON COLUMN CCD_CRUISE_DVM_RULES_V.LEG_NAME_BR_LIST IS '<BR> tag (intended for web pages) delimited list of leg names associated with the given cruise';
COMMENT ON COLUMN CCD_CRUISE_DVM_RULES_V.LEG_NAME_DATES_CD_LIST IS 'Comma-delimited list of leg names, the associated leg dates and vessel name associated with the given cruise';
COMMENT ON COLUMN CCD_CRUISE_DVM_RULES_V.LEG_NAME_DATES_SCD_LIST IS 'Semicolon-delimited list of leg names, the associated leg dates and vessel name associated with the given cruise';
COMMENT ON COLUMN CCD_CRUISE_DVM_RULES_V.LEG_NAME_DATES_RC_LIST IS 'Return carriage/new line delimited list of leg names, the associated leg dates and vessel name associated with the given cruise';
COMMENT ON COLUMN CCD_CRUISE_DVM_RULES_V.LEG_NAME_DATES_BR_LIST IS '<BR> tag (intended for web pages) delimited list of leg names, the associated leg dates and vessel name associated with the given cruise';



CREATE OR REPLACE VIEW CCD_CRUISE_DVM_RULES_RPT_V


AS

SELECT
CCD_CRUISE_DVM_RULES_V.PTA_RULE_SET_ID,
CCD_CRUISE_DVM_RULES_V.PTA_ISS_ID,
CCD_CRUISE_DVM_RULES_V.FORMAT_FIRST_EVAL_DATE,
CCD_CRUISE_DVM_RULES_V.FORMAT_LAST_EVAL_DATE,
CCD_CRUISE_DVM_RULES_V.RULE_SET_ID,
CCD_CRUISE_DVM_RULES_V.RULE_SET_ACTIVE_YN,
CCD_CRUISE_DVM_RULES_V.FORMAT_RULE_SET_CREATE_DATE,
CCD_CRUISE_DVM_RULES_V.FORMAT_RULE_SET_INACTIVE_DATE,
CCD_CRUISE_DVM_RULES_V.RULE_DATA_STREAM_CODE,
CCD_CRUISE_DVM_RULES_V.RULE_DATA_STREAM_NAME,
CCD_CRUISE_DVM_RULES_V.RULE_DATA_STREAM_PAR_TABLE,
CCD_CRUISE_DVM_RULES_V.IND_FIELD_NAME,
CCD_CRUISE_DVM_RULES_V.ISS_TYPE_NAME,
CCD_CRUISE_DVM_RULES_V.ISS_TYPE_DESC,
CCD_CRUISE_DVM_RULES_V.ISS_SEVERITY_CODE,
CCD_CRUISE_DVM_RULES_V.ISS_SEVERITY_NAME,
CCD_CRUISE_DVM_RULES_V.SCI_CENTER_DIV_NAME,
CCD_CRUISE_DVM_RULES_V.CRUISE_ID,
CCD_CRUISE_DVM_RULES_V.CRUISE_NAME,
CCD_CRUISE_DVM_RULES_V.STD_SVY_NAME_VAL,
CCD_CRUISE_DVM_RULES_V.NUM_LEGS,
CCD_CRUISE_DVM_RULES_V.FORMAT_CRUISE_START_DATE,
CCD_CRUISE_DVM_RULES_V.FORMAT_CRUISE_END_DATE,
CCD_CRUISE_DVM_RULES_V.LEG_NAME_CD_LIST

FROM CCD_CRUISE_DVM_RULES_V
order by
CCD_CRUISE_DVM_RULES_V.SCI_CENTER_DIV_NAME,
CCD_CRUISE_DVM_RULES_V.CRUISE_NAME,
CCD_CRUISE_DVM_RULES_V.CRUISE_START_DATE,
CCD_CRUISE_DVM_RULES_V.RULE_DATA_STREAM_NAME,
CCD_CRUISE_DVM_RULES_V.RULE_SET_CREATE_DATE,
CCD_CRUISE_DVM_RULES_V.RULE_SET_ID,
CCD_CRUISE_DVM_RULES_V.ISS_TYPE_NAME;

COMMENT ON COLUMN CCD_CRUISE_DVM_RULES_RPT_V.PTA_RULE_SET_ID IS 'The primary key field for the DVM_PTA_RULE_SETS table';
COMMENT ON COLUMN CCD_CRUISE_DVM_RULES_RPT_V.PTA_ISS_ID IS 'Foreign key reference to the Issues (PTA) intersection table';
COMMENT ON COLUMN CCD_CRUISE_DVM_RULES_RPT_V.FORMAT_FIRST_EVAL_DATE IS 'The formatted date/time the rule set was first evaluated for the given parent issue record (MM/DD/YYYY HH24:MI format)';
COMMENT ON COLUMN CCD_CRUISE_DVM_RULES_RPT_V.FORMAT_LAST_EVAL_DATE IS 'The formatted date/time the rule set was most recently evaluated for the given parent issue record (MM/DD/YYYY HH24:MI format)';
COMMENT ON COLUMN CCD_CRUISE_DVM_RULES_RPT_V.RULE_SET_ID IS 'Primary key for the DVM_RULE_SETS table';
COMMENT ON COLUMN CCD_CRUISE_DVM_RULES_RPT_V.RULE_SET_ACTIVE_YN IS 'Flag to indicate if the given rule set is currently active (Y) or inactive (N).  Only one rule set can be active at any given time';
COMMENT ON COLUMN CCD_CRUISE_DVM_RULES_RPT_V.FORMAT_RULE_SET_CREATE_DATE IS 'The formatted date/time that the given rule set was created (MM/DD/YYYY HH24:MI:SS format)';
COMMENT ON COLUMN CCD_CRUISE_DVM_RULES_RPT_V.FORMAT_RULE_SET_INACTIVE_DATE IS 'The formatted date/time that the given rule set was deactivated (due to a change in active rules) (MM/DD/YYYY HH24:MI:SS format)';
COMMENT ON COLUMN CCD_CRUISE_DVM_RULES_RPT_V.RULE_DATA_STREAM_CODE IS 'The code for the given validation rule set''s data stream';
COMMENT ON COLUMN CCD_CRUISE_DVM_RULES_RPT_V.RULE_DATA_STREAM_NAME IS 'The name for the given validation rule set''s data stream';
COMMENT ON COLUMN CCD_CRUISE_DVM_RULES_RPT_V.RULE_DATA_STREAM_PAR_TABLE IS 'The Data stream''s parent table name for the given validation rule set (used when evaluating QC validation criteria to specify a given parent table)';
COMMENT ON COLUMN CCD_CRUISE_DVM_RULES_RPT_V.IND_FIELD_NAME IS 'The field in the result set that indicates if the current issue type has been identified.  A ''Y'' value indicates that the given issue condition has been identified.  When XML_QC_OBJ_ID is NULL this is the constant name that is used to refer to the current issue type';
COMMENT ON COLUMN CCD_CRUISE_DVM_RULES_RPT_V.ISS_TYPE_NAME IS 'The name of the given QC validation criteria';
COMMENT ON COLUMN CCD_CRUISE_DVM_RULES_RPT_V.ISS_TYPE_DESC IS 'The description for the given QC validation issue type';
COMMENT ON COLUMN CCD_CRUISE_DVM_RULES_RPT_V.ISS_SEVERITY_CODE IS 'The code for the given issue severity';
COMMENT ON COLUMN CCD_CRUISE_DVM_RULES_RPT_V.ISS_SEVERITY_NAME IS 'The name for the given issue severity';
COMMENT ON COLUMN CCD_CRUISE_DVM_RULES_RPT_V.SCI_CENTER_DIV_NAME IS 'Name of the given Science Center Division';
COMMENT ON COLUMN CCD_CRUISE_DVM_RULES_RPT_V.CRUISE_ID IS 'Primary key for the CCD_CRUISES table';
COMMENT ON COLUMN CCD_CRUISE_DVM_RULES_RPT_V.CRUISE_NAME IS 'The name of the given cruise designated by NOAA (e.g. SE-15-01)';
COMMENT ON COLUMN CCD_CRUISE_DVM_RULES_RPT_V.STD_SVY_NAME_VAL IS 'This field contains the Standard Survey Name defined for the given cruise.  If the STD_SVY_NAME_ID field is defined then the associated CCD_STD_SVY_NAMES.STD_SVY_NAME is used because the foreign key is given precedence, otherwise the STD_SVY_NAME_OTH field value is used';
COMMENT ON COLUMN CCD_CRUISE_DVM_RULES_RPT_V.NUM_LEGS IS 'The number of cruise legs associated with the given cruise';
COMMENT ON COLUMN CCD_CRUISE_DVM_RULES_RPT_V.FORMAT_CRUISE_START_DATE IS 'The formatted start date for the given cruise (based on the earliest associated cruise leg''s start date) in MM/DD/YYYY format';
COMMENT ON COLUMN CCD_CRUISE_DVM_RULES_RPT_V.FORMAT_CRUISE_END_DATE IS 'The formatted end date for the given cruise (based on the latest associated cruise leg''s end date) in MM/DD/YYYY format';
COMMENT ON COLUMN CCD_CRUISE_DVM_RULES_RPT_V.LEG_NAME_CD_LIST IS 'Comma-delimited list of leg names associated with the given cruise';

COMMENT ON TABLE CCD_CRUISE_DVM_RULES_RPT_V IS 'Cruise DVM Rules Report (View)

This view returns all of the DVM PTA validation rule sets and all related validation rule set information and cruise information.  This query generates a standard validation rule report that can be included with the data set metadata or as an internal report to provide the specific data quality control criteria that was used to validate each cruise record if that level of detail is desired';


--define the upgrade version in the database upgrade log table:
INSERT INTO DB_UPGRADE_LOGS (UPGRADE_APP_NAME, UPGRADE_VERSION, UPGRADE_DATE, UPGRADE_DESC) VALUES ('Centralized Cruise Database', '0.19', TO_DATE('23-JUL-20', 'DD-MON-YY'), 'Installed Version 0.10 (Git tag: DVM_db_v0.10) of the Data Validation Module Database (Git URL: git@gitlab.pifsc.gov:centralized-data-tools/data-validation-module.git).  Updated the CCD_CRUISE_DVM_RULES_V view to utilize the DVM_PTA_RULE_SETS_V directly instead of joining the DVM tables and views individually.  Developed CCD_CRUISE_DVM_RULES_RPT_V as a standard report that can be included with the data set metadata or as an internal report to provide the specific data quality control criteria that was used to validate each cruise record if that level of detail is desired');

--commit the DB_UPGRADE_LOGS record insertion
COMMIT;
