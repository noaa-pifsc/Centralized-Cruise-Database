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


ALTER TABLE CCD_CRUISE_LEGS 
ADD (UTC_TZ_OFFSET VARCHAR2(40) NOT NULL);

COMMENT ON COLUMN CCD_CRUISE_LEGS.UTC_TZ_OFFSET IS 'The numeric offset for UTC or Time Zone Name (V$TIMEZONE_NAMES.TZNAME) for the local timezone where the cruise leg occurred (e.g. US/Hawaii, US/Samoa, -09:00)';


COMMENT ON COLUMN CCD_CRUISE_LEGS.LEG_START_DATE IS 'The start date in the corresponding time zone for the given research cruise leg';

COMMENT ON COLUMN CCD_CRUISE_LEGS.LEG_END_DATE IS 'The end date in the corresponding time zone for the given research cruise leg';




CREATE OR REPLACE VIEW CCD_LEG_V
AS SELECT
CCD_CRUISE_LEGS.CRUISE_LEG_ID,
CCD_CRUISE_LEGS.LEG_NAME,
CCD_CRUISE_LEGS.LEG_START_DATE,
TO_CHAR(LEG_START_DATE, 'MM/DD/YYYY') FORMAT_LEG_START_DATE,
CCD_CRUISE_LEGS.LEG_END_DATE,
TO_CHAR(CCD_CRUISE_LEGS.LEG_END_DATE, 'MM/DD/YYYY') FORMAT_LEG_END_DATE,
(CCD_CRUISE_LEGS.LEG_END_DATE - CCD_CRUISE_LEGS.LEG_START_DATE + 1) LEG_DAS,

TO_CHAR(CCD_CRUISE_LEGS.LEG_START_DATE, 'YYYY') LEG_YEAR,

CCD_CRUISE_LEGS.UTC_TZ_OFFSET,
CEN_UTILS.CEN_UTIL_PKG.CALC_FISCAL_YEAR_FN(CCD_CRUISE_LEGS.LEG_START_DATE) LEG_FISC_YEAR,
CCD_CRUISE_LEGS.LEG_DESC,
CCD_CRUISE_LEGS.CRUISE_ID,
CCD_VESSELS.VESSEL_ID,
CCD_VESSELS.VESSEL_NAME,
CCD_VESSELS.VESSEL_DESC,
CCD_PLAT_TYPES.PLAT_TYPE_ID,
CCD_PLAT_TYPES.PLAT_TYPE_NAME,
CCD_PLAT_TYPES.PLAT_TYPE_DESC


FROM

CCD_CRUISE_LEGS
LEFT JOIN CCD_VESSELS ON
CCD_CRUISE_LEGS.VESSEL_ID = CCD_VESSELS.VESSEL_ID

LEFT JOIN CCD_PLAT_TYPES ON
CCD_CRUISE_LEGS.PLAT_TYPE_ID = CCD_PLAT_TYPES.PLAT_TYPE_ID

ORDER BY CCD_CRUISE_LEGS.LEG_START_DATE, CCD_CRUISE_LEGS.LEG_NAME;


COMMENT ON TABLE CCD_LEG_V IS 'Research Cruise Legs (View)

This query returns all research cruise legs and their associated reference tables';

COMMENT ON COLUMN CCD_LEG_V.CRUISE_LEG_ID IS 'Primary key for the CCD_CRUISE_LEGS table';
COMMENT ON COLUMN CCD_LEG_V.LEG_NAME IS 'The name of the given cruise leg';
COMMENT ON COLUMN CCD_LEG_V.LEG_START_DATE IS 'The start date in the corresponding time zone for the given research cruise leg';
COMMENT ON COLUMN CCD_LEG_V.FORMAT_LEG_START_DATE IS 'The start date in the corresponding time zone for the given research cruise leg in MM/DD/YYYY format';

COMMENT ON COLUMN CCD_LEG_V.LEG_END_DATE IS 'The end date in the corresponding time zone for the given research cruise leg';

COMMENT ON COLUMN CCD_LEG_V.FORMAT_LEG_END_DATE IS 'The end date in the corresponding time zone for the given research cruise leg in MM/DD/YYYY format';

COMMENT ON COLUMN CCD_LEG_V.LEG_DAS IS 'The number of days at sea for the given research cruise leg';

COMMENT ON COLUMN CCD_LEG_V.LEG_YEAR IS 'The calendar year for the start date of the given research cruise leg';
COMMENT ON COLUMN CCD_LEG_V.LEG_FISC_YEAR IS 'The NOAA fiscal year for the start date of the given research cruise leg';
COMMENT ON COLUMN CCD_LEG_V.LEG_DESC IS 'The description for the given research cruise leg';
COMMENT ON COLUMN CCD_LEG_V.UTC_TZ_OFFSET IS 'The numeric offset for UTC or Time Zone Name (V$TIMEZONE_NAMES.TZNAME) for the local timezone where the cruise leg occurred (e.g. US/Hawaii, US/Samoa, -09:00)';

COMMENT ON COLUMN CCD_LEG_V.CRUISE_ID IS 'The cruise for the given research cruise leg';


COMMENT ON COLUMN CCD_LEG_V.VESSEL_ID IS 'Foreign key reference to the CCD_VESSELS table for the cruise leg''s vessel';
COMMENT ON COLUMN CCD_LEG_V.VESSEL_NAME IS 'Name of the given research vessel';
COMMENT ON COLUMN CCD_LEG_V.VESSEL_DESC IS 'Description for the given research vessel';
COMMENT ON COLUMN CCD_LEG_V.PLAT_TYPE_ID IS 'Platform Type for the given research cruise leg';
COMMENT ON COLUMN CCD_LEG_V.PLAT_TYPE_NAME IS 'Name of the given Platform Type';
COMMENT ON COLUMN CCD_LEG_V.PLAT_TYPE_DESC IS 'Description for the given Platform Type';



ALTER VIEW CCD_CRUISE_V COMPILE;

COMMENT ON COLUMN CCD_CRUISE_V.CRUISE_START_DATE IS 'The start date in the corresponding time zone for the given cruise (based on the earliest associated cruise leg''s start date)';
COMMENT ON COLUMN CCD_CRUISE_V.FORMAT_CRUISE_START_DATE IS 'The formatted start date in the corresponding time zone for the given cruise (based on the earliest associated cruise leg''s start date) in MM/DD/YYYY HH24:MI:SS format';
COMMENT ON COLUMN CCD_CRUISE_V.CRUISE_END_DATE IS 'The end date in the corresponding time zone for the given cruise (based on the latest associated cruise leg''s end date)';
COMMENT ON COLUMN CCD_CRUISE_V.FORMAT_CRUISE_END_DATE IS 'The formatted end date in the corresponding time zone for the given cruise (based on the latest associated cruise leg''s end date) in MM/DD/YYYY HH24:MI:SS format';


ALTER VIEW CCD_CRUISE_DELIM_V COMPILE;

COMMENT ON COLUMN CCD_CRUISE_DELIM_V.CRUISE_START_DATE IS 'The start date in the corresponding time zone for the given cruise (based on the earliest associated cruise leg''s start date)';
COMMENT ON COLUMN CCD_CRUISE_DELIM_V.FORMAT_CRUISE_START_DATE IS 'The formatted start date in the corresponding time zone for the given cruise (based on the earliest associated cruise leg''s start date) in MM/DD/YYYY HH24:MI:SS format';
COMMENT ON COLUMN CCD_CRUISE_DELIM_V.CRUISE_END_DATE IS 'The end date in the corresponding time zone for the given cruise (based on the latest associated cruise leg''s end date)';
COMMENT ON COLUMN CCD_CRUISE_DELIM_V.FORMAT_CRUISE_END_DATE IS 'The formatted end date in the corresponding time zone for the given cruise (based on the latest associated cruise leg''s end date) in MM/DD/YYYY HH24:MI:SS format';

ALTER VIEW CCD_CRUISE_SUMM_V COMPILE;


COMMENT ON COLUMN CCD_CRUISE_SUMM_V.CRUISE_START_DATE IS 'The start date in the corresponding time zone for the given cruise (based on the earliest associated cruise leg''s start date)';
COMMENT ON COLUMN CCD_CRUISE_SUMM_V.FORMAT_CRUISE_START_DATE IS 'The formatted start date in the corresponding time zone for the given cruise (based on the earliest associated cruise leg''s start date) in MM/DD/YYYY HH24:MI:SS format';
COMMENT ON COLUMN CCD_CRUISE_SUMM_V.CRUISE_END_DATE IS 'The end date in the corresponding time zone for the given cruise (based on the latest associated cruise leg''s end date)';
COMMENT ON COLUMN CCD_CRUISE_SUMM_V.FORMAT_CRUISE_END_DATE IS 'The formatted end date in the corresponding time zone for the given cruise (based on the latest associated cruise leg''s end date) in MM/DD/YYYY HH24:MI:SS format';

ALTER VIEW CCD_CRUISE_SUMM_ISS_V COMPILE;

COMMENT ON COLUMN CCD_CRUISE_SUMM_ISS_V.CRUISE_START_DATE IS 'The start date in the corresponding time zone for the given cruise (based on the earliest associated cruise leg''s start date)';
COMMENT ON COLUMN CCD_CRUISE_SUMM_ISS_V.FORMAT_CRUISE_START_DATE IS 'The formatted start date in the corresponding time zone for the given cruise (based on the earliest associated cruise leg''s start date) in MM/DD/YYYY HH24:MI:SS format';
COMMENT ON COLUMN CCD_CRUISE_SUMM_ISS_V.CRUISE_END_DATE IS 'The end date in the corresponding time zone for the given cruise (based on the latest associated cruise leg''s end date)';
COMMENT ON COLUMN CCD_CRUISE_SUMM_ISS_V.FORMAT_CRUISE_END_DATE IS 'The formatted end date in the corresponding time zone for the given cruise (based on the latest associated cruise leg''s end date) in MM/DD/YYYY HH24:MI:SS format';


ALTER VIEW CCD_CCDP_DEEP_COPY_CMP_V COMPILE;

ALTER VIEW CCD_CRUISE_DVM_EVAL_RPT_V COMPILE;

COMMENT ON COLUMN CCD_CRUISE_DVM_EVAL_RPT_V.FORMAT_CRUISE_START_DATE IS 'The formatted start date in the corresponding time zone for the given cruise (based on the earliest associated cruise leg''s start date) in MM/DD/YYYY HH24:MI:SS format';
COMMENT ON COLUMN CCD_CRUISE_DVM_EVAL_RPT_V.FORMAT_CRUISE_END_DATE IS 'The formatted end date in the corresponding time zone for the given cruise (based on the latest associated cruise leg''s end date) in MM/DD/YYYY HH24:MI:SS format';

ALTER VIEW CCD_CRUISE_DVM_RULES_RPT_V COMPILE;

COMMENT ON COLUMN CCD_CRUISE_DVM_RULES_RPT_V.FORMAT_CRUISE_START_DATE IS 'The formatted start date in the corresponding time zone for the given cruise (based on the earliest associated cruise leg''s start date) in MM/DD/YYYY HH24:MI:SS format';
COMMENT ON COLUMN CCD_CRUISE_DVM_RULES_RPT_V.FORMAT_CRUISE_END_DATE IS 'The formatted end date in the corresponding time zone for the given cruise (based on the latest associated cruise leg''s end date) in MM/DD/YYYY HH24:MI:SS format';

ALTER VIEW CCD_CRUISE_DVM_RULES_V COMPILE;

COMMENT ON COLUMN CCD_CRUISE_DVM_RULES_V.CRUISE_START_DATE IS 'The start date in the corresponding time zone for the given cruise (based on the earliest associated cruise leg''s start date)';
COMMENT ON COLUMN CCD_CRUISE_DVM_RULES_V.FORMAT_CRUISE_START_DATE IS 'The formatted start date in the corresponding time zone for the given cruise (based on the earliest associated cruise leg''s start date) in MM/DD/YYYY HH24:MI:SS format';
COMMENT ON COLUMN CCD_CRUISE_DVM_RULES_V.CRUISE_END_DATE IS 'The end date in the corresponding time zone for the given cruise (based on the latest associated cruise leg''s end date)';
COMMENT ON COLUMN CCD_CRUISE_DVM_RULES_V.FORMAT_CRUISE_END_DATE IS 'The formatted end date in the corresponding time zone for the given cruise (based on the latest associated cruise leg''s end date) in MM/DD/YYYY HH24:MI:SS format';

ALTER VIEW CCD_CRUISE_DVM_RULE_EVAL_RPT_V COMPILE;

COMMENT ON COLUMN CCD_CRUISE_DVM_RULE_EVAL_RPT_V.FORMAT_CRUISE_START_DATE IS 'The formatted start date in the corresponding time zone for the given cruise (based on the earliest associated cruise leg''s start date) in MM/DD/YYYY HH24:MI:SS format';
COMMENT ON COLUMN CCD_CRUISE_DVM_RULE_EVAL_RPT_V.FORMAT_CRUISE_END_DATE IS 'The formatted end date in the corresponding time zone for the given cruise (based on the latest associated cruise leg''s end date) in MM/DD/YYYY HH24:MI:SS format';

ALTER VIEW CCD_CRUISE_DVM_RULE_EVAL_V COMPILE;

COMMENT ON COLUMN CCD_CRUISE_DVM_RULE_EVAL_V.CRUISE_START_DATE IS 'The start date in the corresponding time zone for the given cruise (based on the earliest associated cruise leg''s start date)';
COMMENT ON COLUMN CCD_CRUISE_DVM_RULE_EVAL_V.FORMAT_CRUISE_START_DATE IS 'The formatted start date in the corresponding time zone for the given cruise (based on the earliest associated cruise leg''s start date) in MM/DD/YYYY HH24:MI:SS format';
COMMENT ON COLUMN CCD_CRUISE_DVM_RULE_EVAL_V.CRUISE_END_DATE IS 'The end date in the corresponding time zone for the given cruise (based on the latest associated cruise leg''s end date)';
COMMENT ON COLUMN CCD_CRUISE_DVM_RULE_EVAL_V.FORMAT_CRUISE_END_DATE IS 'The formatted end date in the corresponding time zone for the given cruise (based on the latest associated cruise leg''s end date) in MM/DD/YYYY HH24:MI:SS format';

ALTER VIEW CCD_CRUISE_ISS_SUMM_V COMPILE;

COMMENT ON COLUMN CCD_CRUISE_ISS_SUMM_V.CRUISE_START_DATE IS 'The start date in the corresponding time zone for the given cruise (based on the earliest associated cruise leg''s start date)';
COMMENT ON COLUMN CCD_CRUISE_ISS_SUMM_V.FORMAT_CRUISE_START_DATE IS 'The formatted start date in the corresponding time zone for the given cruise (based on the earliest associated cruise leg''s start date) in MM/DD/YYYY HH24:MI:SS format';
COMMENT ON COLUMN CCD_CRUISE_ISS_SUMM_V.CRUISE_END_DATE IS 'The end date in the corresponding time zone for the given cruise (based on the latest associated cruise leg''s end date)';
COMMENT ON COLUMN CCD_CRUISE_ISS_SUMM_V.FORMAT_CRUISE_END_DATE IS 'The formatted end date in the corresponding time zone for the given cruise (based on the latest associated cruise leg''s end date) in MM/DD/YYYY HH24:MI:SS format';

ALTER VIEW CCD_QC_CRUISE_V COMPILE;

COMMENT ON COLUMN CCD_QC_CRUISE_V.FORMAT_CRUISE_START_DATE IS 'The formatted start date in the corresponding time zone for the given cruise (based on the earliest associated cruise leg''s start date) in MM/DD/YYYY HH24:MI:SS format';
COMMENT ON COLUMN CCD_QC_CRUISE_V.FORMAT_CRUISE_END_DATE IS 'The formatted end date in the corresponding time zone for the given cruise (based on the latest associated cruise leg''s end date) in MM/DD/YYYY HH24:MI:SS format';



COMMENT ON COLUMN CCD_CRUISE_LEG_DELIM_V.CRUISE_START_DATE IS 'The start date in the corresponding time zone for the given cruise (based on the earliest associated cruise leg''s start date)';
COMMENT ON COLUMN CCD_CRUISE_LEG_DELIM_V.FORMAT_CRUISE_START_DATE IS 'The formatted start date in the corresponding time zone for the given cruise (based on the earliest associated cruise leg''s start date) in MM/DD/YYYY HH24:MI:SS format';
COMMENT ON COLUMN CCD_CRUISE_LEG_DELIM_V.CRUISE_END_DATE IS 'The end date in the corresponding time zone for the given cruise (based on the latest associated cruise leg''s end date)';
COMMENT ON COLUMN CCD_CRUISE_LEG_DELIM_V.FORMAT_CRUISE_END_DATE IS 'The formatted end date in the corresponding time zone for the given cruise (based on the latest associated cruise leg''s end date) in MM/DD/YYYY HH24:MI:SS format';


CREATE OR REPLACE VIEW
CCD_CRUISE_LEGS_V
AS
SELECT
CCD_CRUISE_V.CRUISE_ID,
CCD_CRUISE_V.CRUISE_NAME,
CCD_CRUISE_V.CRUISE_NOTES,
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
CCD_CRUISE_V.CRUISE_YEAR,
CCD_CRUISE_V.CRUISE_FISC_YEAR,
CCD_CRUISE_V.LEG_NAME_CD_LIST,
CCD_CRUISE_V.LEG_NAME_SCD_LIST,
CCD_CRUISE_V.LEG_NAME_RC_LIST,
CCD_CRUISE_V.LEG_NAME_BR_LIST,
CCD_CRUISE_V.LEG_NAME_DATES_CD_LIST,
CCD_CRUISE_V.LEG_NAME_DATES_SCD_LIST,
CCD_CRUISE_V.LEG_NAME_DATES_RC_LIST,
CCD_CRUISE_V.LEG_NAME_DATES_BR_LIST,








CCD_LEG_V.CRUISE_LEG_ID,
CCD_LEG_V.LEG_NAME,
CCD_LEG_V.LEG_START_DATE,
CCD_LEG_V.FORMAT_LEG_START_DATE,
CCD_LEG_V.LEG_END_DATE,
CCD_LEG_V.FORMAT_LEG_END_DATE,
CCD_LEG_V.LEG_YEAR,
CCD_LEG_V.LEG_DAS,
CCD_LEG_V.LEG_FISC_YEAR,
CCD_LEG_V.LEG_DESC,
CCD_LEG_V.UTC_TZ_OFFSET,
CCD_LEG_V.VESSEL_ID,
CCD_LEG_V.VESSEL_NAME,
CCD_LEG_V.VESSEL_DESC,
CCD_LEG_V.PLAT_TYPE_ID,
CCD_LEG_V.PLAT_TYPE_NAME,
CCD_LEG_V.PLAT_TYPE_DESC

FROM CCD_CRUISE_V
LEFT JOIN
CCD_LEG_V ON
CCD_CRUISE_V.CRUISE_ID = CCD_LEG_V.CRUISE_ID
order by
CCD_LEG_V.LEG_START_DATE,
CCD_LEG_V.LEG_NAME,
CCD_LEG_V.VESSEL_NAME;



COMMENT ON COLUMN CCD_CRUISE_LEGS_V.CRUISE_ID IS 'Primary key for the CCD_CRUISES table';
COMMENT ON COLUMN CCD_CRUISE_LEGS_V.CRUISE_NAME IS 'The name of the given cruise designated by NOAA (e.g. SE-15-01)';
COMMENT ON COLUMN CCD_CRUISE_LEGS_V.CRUISE_NOTES IS 'Any notes for the given research cruise';
COMMENT ON COLUMN CCD_CRUISE_LEGS_V.SCI_CENTER_ID IS 'Primary key for the Science Center table';
COMMENT ON COLUMN CCD_CRUISE_LEGS_V.SCI_CENTER_NAME IS 'Name of the given Science Center';
COMMENT ON COLUMN CCD_CRUISE_LEGS_V.SCI_CENTER_DESC IS 'Description for the given Science Center';
COMMENT ON COLUMN CCD_CRUISE_LEGS_V.STD_SVY_NAME_ID IS 'Primary key for the Standard Survey Name table';
COMMENT ON COLUMN CCD_CRUISE_LEGS_V.STD_SVY_NAME IS 'Name of the given Standard Survey Name';
COMMENT ON COLUMN CCD_CRUISE_LEGS_V.STD_SVY_DESC IS 'Description for the given Standard Survey Name';
COMMENT ON COLUMN CCD_CRUISE_LEGS_V.SVY_FREQ_ID IS 'Primary key for the Survey Frequency table';
COMMENT ON COLUMN CCD_CRUISE_LEGS_V.SVY_FREQ_NAME IS 'Name of the given Survey Frequency';
COMMENT ON COLUMN CCD_CRUISE_LEGS_V.SVY_FREQ_DESC IS 'Description for the given Survey Frequency';
COMMENT ON COLUMN CCD_CRUISE_LEGS_V.STD_SVY_NAME_OTH IS 'Field defines a Standard Survey Name that is not included in the Standard Survey Name table';
COMMENT ON COLUMN CCD_CRUISE_LEGS_V.STD_SVY_NAME_VAL IS 'This field contains the Standard Survey Name defined for the given cruise.  If the STD_SVY_NAME_ID field is defined then the associated CCD_STD_SVY_NAMES.STD_SVY_NAME is used because the foreign key is given precedence, otherwise the STD_SVY_NAME_OTH field value is used';


COMMENT ON COLUMN CCD_CRUISE_LEGS_V.SVY_TYPE_ID IS 'Primary key for the Survey Type table';
COMMENT ON COLUMN CCD_CRUISE_LEGS_V.SVY_TYPE_NAME IS 'Name of the given Survey Type';
COMMENT ON COLUMN CCD_CRUISE_LEGS_V.SVY_TYPE_DESC IS 'Description for the given Survey Type';


COMMENT ON COLUMN CCD_CRUISE_LEGS_V.CRUISE_URL IS 'The Cruise URL (Referred to as "Survey URL" in FINSS System) for the given Cruise';
COMMENT ON COLUMN CCD_CRUISE_LEGS_V.CRUISE_CONT_EMAIL IS 'The Cruise Contact Email (Referred to as "Survey Contact Email" in FINSS System) for the given Cruise';


COMMENT ON COLUMN CCD_CRUISE_LEGS_V.CRUISE_LEG_ID IS 'Primary key for the CCD_CRUISE_LEGS table';
COMMENT ON COLUMN CCD_CRUISE_LEGS_V.LEG_NAME IS 'The name of the given cruise leg';

COMMENT ON COLUMN CCD_CRUISE_LEGS_V.LEG_START_DATE IS 'The start date in the corresponding time zone for the given research cruise leg';
COMMENT ON COLUMN CCD_CRUISE_LEGS_V.FORMAT_LEG_START_DATE IS 'The start date in the corresponding time zone for the given research cruise leg in MM/DD/YYYY format';

COMMENT ON COLUMN CCD_CRUISE_LEGS_V.LEG_END_DATE IS 'The end date in the corresponding time zone for the given research cruise leg';

COMMENT ON COLUMN CCD_CRUISE_LEGS_V.FORMAT_LEG_END_DATE IS 'The end date in the corresponding time zone for the given research cruise leg in MM/DD/YYYY format';

COMMENT ON COLUMN CCD_CRUISE_LEGS_V.LEG_DAS IS 'The number of days at sea for the given research cruise leg';
COMMENT ON COLUMN CCD_CRUISE_LEGS_V.LEG_YEAR IS 'The calendar year for the start date of the given research cruise leg';
COMMENT ON COLUMN CCD_CRUISE_LEGS_V.LEG_FISC_YEAR IS 'The NOAA fiscal year for the start date of the given research cruise leg';
COMMENT ON COLUMN CCD_CRUISE_LEGS_V.LEG_DESC IS 'The description for the given research cruise leg';
COMMENT ON COLUMN CCD_CRUISE_LEGS_V.UTC_TZ_OFFSET IS 'The numeric offset for UTC or Time Zone Name (V$TIMEZONE_NAMES.TZNAME) for the local timezone where the cruise leg occurred (e.g. US/Hawaii, US/Samoa, -09:00)';

COMMENT ON COLUMN CCD_CRUISE_LEGS_V.VESSEL_ID IS 'Foreign key reference to the CCD_VESSELS table for the cruise leg''s vessel';
COMMENT ON COLUMN CCD_CRUISE_LEGS_V.VESSEL_NAME IS 'Name of the given research vessel';
COMMENT ON COLUMN CCD_CRUISE_LEGS_V.VESSEL_DESC IS 'Description for the given research vessel';
COMMENT ON COLUMN CCD_CRUISE_LEGS_V.PLAT_TYPE_ID IS 'Platform Type for the given research cruise leg';
COMMENT ON COLUMN CCD_CRUISE_LEGS_V.PLAT_TYPE_NAME IS 'Name of the given Platform Type';
COMMENT ON COLUMN CCD_CRUISE_LEGS_V.PLAT_TYPE_DESC IS 'Description for the given Platform Type';


COMMENT ON COLUMN CCD_CRUISE_LEGS_V.CRUISE_START_DATE IS 'The start date in the corresponding time zone for the given cruise (based on the earliest associated cruise leg''s start date)';
COMMENT ON COLUMN CCD_CRUISE_LEGS_V.FORMAT_CRUISE_START_DATE IS 'The formatted start date in the corresponding time zone for the given cruise (based on the earliest associated cruise leg''s start date) in MM/DD/YYYY HH24:MI:SS format';
COMMENT ON COLUMN CCD_CRUISE_LEGS_V.CRUISE_END_DATE IS 'The end date in the corresponding time zone for the given cruise (based on the latest associated cruise leg''s end date)';
COMMENT ON COLUMN CCD_CRUISE_LEGS_V.FORMAT_CRUISE_END_DATE IS 'The formatted end date in the corresponding time zone for the given cruise (based on the latest associated cruise leg''s end date) in MM/DD/YYYY HH24:MI:SS format';
COMMENT ON COLUMN CCD_CRUISE_LEGS_V.CRUISE_DAS IS 'The total number of days at sea for each of the legs associated with the given cruise';


COMMENT ON COLUMN CCD_CRUISE_LEGS_V.CRUISE_YEAR IS 'The calendar year for the given cruise (based on the earliest associated cruise leg''s start date)';
COMMENT ON COLUMN CCD_CRUISE_LEGS_V.CRUISE_FISC_YEAR IS 'The calendar year for the given cruise (based on the earliest associated cruise leg''s start date)';
COMMENT ON COLUMN CCD_CRUISE_LEGS_V.NUM_LEGS IS 'The number of cruise legs associated with the given cruise';
COMMENT ON COLUMN CCD_CRUISE_LEGS_V.LEG_NAME_CD_LIST IS 'Comma-delimited list of leg names associated with the given cruise';
COMMENT ON COLUMN CCD_CRUISE_LEGS_V.LEG_NAME_SCD_LIST IS 'Semicolon-delimited list of leg names associated with the given cruise';
COMMENT ON COLUMN CCD_CRUISE_LEGS_V.LEG_NAME_RC_LIST IS 'Return carriage/new line delimited list of leg names associated with the given cruise';
COMMENT ON COLUMN CCD_CRUISE_LEGS_V.LEG_NAME_BR_LIST IS '<BR> tag (intended for web pages) delimited list of leg names associated with the given cruise';


COMMENT ON COLUMN CCD_CRUISE_LEGS_V.LEG_NAME_DATES_CD_LIST IS 'Comma-delimited list of leg names, the associated leg dates and vessel name associated with the given cruise';
COMMENT ON COLUMN CCD_CRUISE_LEGS_V.LEG_NAME_DATES_SCD_LIST IS 'Semicolon-delimited list of leg names, the associated leg dates and vessel name associated with the given cruise';
COMMENT ON COLUMN CCD_CRUISE_LEGS_V.LEG_NAME_DATES_RC_LIST IS 'Return carriage/new line delimited list of leg names, the associated leg dates and vessel name associated with the given cruise';
COMMENT ON COLUMN CCD_CRUISE_LEGS_V.LEG_NAME_DATES_BR_LIST IS '<BR> tag (intended for web pages) delimited list of leg names, the associated leg dates and vessel name associated with the given cruise';



COMMENT ON TABLE CCD_CRUISE_LEGS_V IS 'Research Cruises and Associated Cruise Legs (View)

This query returns all research cruise legs and their associated reference tables as well as all associated cruise legs with their associated reference tables';




CREATE OR REPLACE VIEW
CCD_LEG_DELIM_V
AS
SELECT
CCD_LEG_V.CRUISE_LEG_ID,
CCD_LEG_V.LEG_NAME,
CCD_LEG_V.LEG_START_DATE,
CCD_LEG_V.FORMAT_LEG_START_DATE,
CCD_LEG_V.LEG_END_DATE,
CCD_LEG_V.FORMAT_LEG_END_DATE,
CCD_LEG_V.LEG_DAS,
CCD_LEG_V.LEG_YEAR,
CCD_LEG_V.LEG_FISC_YEAR,
CCD_LEG_V.LEG_DESC,
CCD_LEG_V.UTC_TZ_OFFSET,
CCD_LEG_V.CRUISE_ID,
CCD_LEG_V.VESSEL_ID,
CCD_LEG_V.VESSEL_NAME,
CCD_LEG_V.VESSEL_DESC,
CCD_LEG_V.PLAT_TYPE_ID,
CCD_LEG_V.PLAT_TYPE_NAME,
CCD_LEG_V.PLAT_TYPE_DESC,
LEG_ECOSYSTEMS_DELIM.NUM_REG_ECOSYSTEMS,
LEG_ECOSYSTEMS_DELIM.REG_ECOSYSTEM_CD_LIST,
LEG_ECOSYSTEMS_DELIM.REG_ECOSYSTEM_SCD_LIST,
LEG_ECOSYSTEMS_DELIM.REG_ECOSYSTEM_RC_LIST,
LEG_ECOSYSTEMS_DELIM.REG_ECOSYSTEM_BR_LIST,
LEG_GEAR_DELIM.NUM_GEAR,
LEG_GEAR_DELIM.GEAR_NAME_CD_LIST,
LEG_GEAR_DELIM.GEAR_NAME_SCD_LIST,
LEG_GEAR_DELIM.GEAR_NAME_RC_LIST,
LEG_GEAR_DELIM.GEAR_NAME_BR_LIST,
LEG_REGION_DELIM.NUM_REGIONS,
LEG_REGION_DELIM.REGION_CODE_CD_LIST,
LEG_REGION_DELIM.REGION_CODE_SCD_LIST,
LEG_REGION_DELIM.REGION_CODE_RC_LIST,
LEG_REGION_DELIM.REGION_CODE_BR_LIST,
LEG_REGION_DELIM.REGION_NAME_CD_LIST,
LEG_REGION_DELIM.REGION_NAME_SCD_LIST,
LEG_REGION_DELIM.REGION_NAME_RC_LIST,
LEG_REGION_DELIM.REGION_NAME_BR_LIST,
LEG_ALIAS_DELIM.NUM_LEG_ALIASES,
LEG_ALIAS_DELIM.LEG_ALIAS_CD_LIST,
LEG_ALIAS_DELIM.LEG_ALIAS_SCD_LIST,
LEG_ALIAS_DELIM.LEG_ALIAS_RC_LIST,
LEG_ALIAS_DELIM.LEG_ALIAS_BR_LIST



FROM CCD_LEG_V

LEFT JOIN
(SELECT CRUISE_LEG_ID,
 count(*) NUM_REG_ECOSYSTEMS,
LISTAGG(REG_ECOSYSTEM_NAME, ', ') WITHIN GROUP (ORDER BY UPPER(REG_ECOSYSTEM_NAME)) as REG_ECOSYSTEM_CD_LIST,
LISTAGG(REG_ECOSYSTEM_NAME, '; ') WITHIN GROUP (ORDER BY UPPER(REG_ECOSYSTEM_NAME)) as REG_ECOSYSTEM_SCD_LIST,
LISTAGG(REG_ECOSYSTEM_NAME, chr(10)) WITHIN GROUP (ORDER BY UPPER(REG_ECOSYSTEM_NAME)) as REG_ECOSYSTEM_RC_LIST,
LISTAGG(REG_ECOSYSTEM_NAME, '<BR>') WITHIN GROUP (ORDER BY UPPER(REG_ECOSYSTEM_NAME)) as REG_ECOSYSTEM_BR_LIST

 FROM
 CCD_REG_ECOSYSTEMS
 INNER JOIN
 CCD_LEG_ECOSYSTEMS

 ON CCD_REG_ECOSYSTEMS.REG_ECOSYSTEM_ID = CCD_LEG_ECOSYSTEMS.REG_ECOSYSTEM_ID
 group by CCD_LEG_ECOSYSTEMS.CRUISE_LEG_ID
) LEG_ECOSYSTEMS_DELIM
ON CCD_LEG_V.CRUISE_LEG_ID = LEG_ECOSYSTEMS_DELIM.CRUISE_LEG_ID



LEFT JOIN
(SELECT CRUISE_LEG_ID,
 count(*) NUM_GEAR,
LISTAGG(GEAR_NAME, ', ') WITHIN GROUP (ORDER BY UPPER(GEAR_NAME)) as GEAR_NAME_CD_LIST,
LISTAGG(GEAR_NAME, '; ') WITHIN GROUP (ORDER BY UPPER(GEAR_NAME)) as GEAR_NAME_SCD_LIST,
LISTAGG(GEAR_NAME, chr(10)) WITHIN GROUP (ORDER BY UPPER(GEAR_NAME)) as GEAR_NAME_RC_LIST,
LISTAGG(GEAR_NAME, '<BR>') WITHIN GROUP (ORDER BY UPPER(GEAR_NAME)) as GEAR_NAME_BR_LIST

 FROM
 CCD_GEAR
 INNER JOIN
 CCD_LEG_GEAR

 ON CCD_GEAR.GEAR_ID = CCD_LEG_GEAR.GEAR_ID
 group by CCD_LEG_GEAR.CRUISE_LEG_ID
) LEG_GEAR_DELIM
ON CCD_LEG_V.CRUISE_LEG_ID = LEG_GEAR_DELIM.CRUISE_LEG_ID




LEFT JOIN
(SELECT CRUISE_LEG_ID,
 count(*) num_regions,
LISTAGG(REGION_CODE, ', ') WITHIN GROUP (ORDER BY UPPER(REGION_CODE)) as REGION_CODE_CD_LIST,
LISTAGG(REGION_CODE, '; ') WITHIN GROUP (ORDER BY UPPER(REGION_CODE)) as REGION_CODE_SCD_LIST,
LISTAGG(REGION_CODE, chr(10)) WITHIN GROUP (ORDER BY UPPER(REGION_CODE)) as REGION_CODE_RC_LIST,
LISTAGG(REGION_CODE, '<BR>') WITHIN GROUP (ORDER BY UPPER(REGION_CODE)) as REGION_CODE_BR_LIST,
LISTAGG(REGION_NAME, ', ') WITHIN GROUP (ORDER BY UPPER(REGION_NAME)) as REGION_NAME_CD_LIST,
LISTAGG(REGION_NAME, '; ') WITHIN GROUP (ORDER BY UPPER(REGION_NAME)) as REGION_NAME_SCD_LIST,
LISTAGG(REGION_NAME, chr(10)) WITHIN GROUP (ORDER BY UPPER(REGION_NAME)) as REGION_NAME_RC_LIST,
LISTAGG(REGION_NAME, '<BR>') WITHIN GROUP (ORDER BY UPPER(REGION_NAME)) as REGION_NAME_BR_LIST

 FROM
 CCD_REGIONS
 INNER JOIN
 CCD_LEG_REGIONS

 ON CCD_REGIONS.REGION_ID = CCD_LEG_REGIONS.REGION_ID
 group by CCD_LEG_REGIONS.CRUISE_LEG_ID
) LEG_REGION_DELIM
ON CCD_LEG_V.CRUISE_LEG_ID = LEG_REGION_DELIM.CRUISE_LEG_ID




LEFT JOIN
(SELECT CRUISE_LEG_ID,
 count(*) NUM_LEG_ALIASES,
LISTAGG(LEG_ALIAS_NAME, ', ') WITHIN GROUP (ORDER BY UPPER(LEG_ALIAS_NAME)) as LEG_ALIAS_CD_LIST,
LISTAGG(LEG_ALIAS_NAME, '; ') WITHIN GROUP (ORDER BY UPPER(LEG_ALIAS_NAME)) as LEG_ALIAS_SCD_LIST,
LISTAGG(LEG_ALIAS_NAME, chr(10)) WITHIN GROUP (ORDER BY UPPER(LEG_ALIAS_NAME)) as LEG_ALIAS_RC_LIST,
LISTAGG(LEG_ALIAS_NAME, '<BR>') WITHIN GROUP (ORDER BY UPPER(LEG_ALIAS_NAME)) as LEG_ALIAS_BR_LIST

 FROM
 CCD_LEG_ALIASES

 group by CCD_LEG_ALIASES.CRUISE_LEG_ID
) LEG_ALIAS_DELIM
ON CCD_LEG_V.CRUISE_LEG_ID = LEG_ALIAS_DELIM.CRUISE_LEG_ID




ORDER BY LEG_START_DATE, LEG_NAME;




COMMENT ON COLUMN CCD_LEG_DELIM_V.CRUISE_LEG_ID IS 'Primary key for the CCD_CRUISE_LEGS table';
COMMENT ON COLUMN CCD_LEG_DELIM_V.LEG_NAME IS 'The name of the given cruise leg';



COMMENT ON COLUMN CCD_LEG_DELIM_V.LEG_START_DATE IS 'The start date in the corresponding time zone for the given research cruise leg';
COMMENT ON COLUMN CCD_LEG_DELIM_V.FORMAT_LEG_START_DATE IS 'The start date in the corresponding time zone for the given research cruise leg in MM/DD/YYYY format';

COMMENT ON COLUMN CCD_LEG_DELIM_V.LEG_END_DATE IS 'The end date in the corresponding time zone for the given research cruise leg';

COMMENT ON COLUMN CCD_LEG_DELIM_V.FORMAT_LEG_END_DATE IS 'The end date in the corresponding time zone for the given research cruise leg in MM/DD/YYYY format';

COMMENT ON COLUMN CCD_LEG_DELIM_V.LEG_DAS IS 'The number of days at sea for the given research cruise leg';

COMMENT ON COLUMN CCD_LEG_DELIM_V.LEG_YEAR IS 'The calendar year for the start date of the given research cruise leg';
COMMENT ON COLUMN CCD_LEG_DELIM_V.LEG_FISC_YEAR IS 'The NOAA fiscal year for the start date of the given research cruise leg';
COMMENT ON COLUMN CCD_LEG_DELIM_V.LEG_DESC IS 'The description for the given research cruise leg';

COMMENT ON COLUMN CCD_LEG_DELIM_V.UTC_TZ_OFFSET IS 'The numeric offset for UTC or Time Zone Name (V$TIMEZONE_NAMES.TZNAME) for the local timezone where the cruise leg occurred (e.g. US/Hawaii, US/Samoa, -09:00)';

COMMENT ON COLUMN CCD_LEG_DELIM_V.CRUISE_ID IS 'The cruise for the given research cruise leg';


COMMENT ON COLUMN CCD_LEG_DELIM_V.VESSEL_ID IS 'Foreign key reference to the CCD_VESSELS table for the cruise leg''s vessel';
COMMENT ON COLUMN CCD_LEG_DELIM_V.VESSEL_NAME IS 'Name of the given research vessel';
COMMENT ON COLUMN CCD_LEG_DELIM_V.VESSEL_DESC IS 'Description for the given research vessel';
COMMENT ON COLUMN CCD_LEG_DELIM_V.PLAT_TYPE_ID IS 'Platform Type for the given research cruise leg';
COMMENT ON COLUMN CCD_LEG_DELIM_V.PLAT_TYPE_NAME IS 'Name of the given Platform Type';
COMMENT ON COLUMN CCD_LEG_DELIM_V.PLAT_TYPE_DESC IS 'Description for the given Platform Type';
COMMENT ON COLUMN CCD_LEG_DELIM_V.NUM_REG_ECOSYSTEMS IS 'The number of associated Regional Ecosystems';
COMMENT ON COLUMN CCD_LEG_DELIM_V.REG_ECOSYSTEM_CD_LIST IS 'Comma-delimited list of Regional Ecosystems associated with the given cruise leg';
COMMENT ON COLUMN CCD_LEG_DELIM_V.REG_ECOSYSTEM_SCD_LIST IS 'Semicolon-delimited list of Regional Ecosystems associated with the given cruise leg';
COMMENT ON COLUMN CCD_LEG_DELIM_V.REG_ECOSYSTEM_RC_LIST IS 'Return carriage/new line delimited list of Regional Ecosystems associated with the given cruise leg';
COMMENT ON COLUMN CCD_LEG_DELIM_V.REG_ECOSYSTEM_BR_LIST IS '<BR> tag (intended for web pages) delimited list of Regional Ecosystems associated with the given cruise leg';



COMMENT ON COLUMN CCD_LEG_DELIM_V.NUM_GEAR IS 'The number of associated gear';
COMMENT ON COLUMN CCD_LEG_DELIM_V.GEAR_NAME_CD_LIST IS 'Comma-delimited list of gear associated with the given cruise leg';
COMMENT ON COLUMN CCD_LEG_DELIM_V.GEAR_NAME_SCD_LIST IS 'Semicolon-delimited list of gear associated with the given cruise leg';
COMMENT ON COLUMN CCD_LEG_DELIM_V.GEAR_NAME_RC_LIST IS 'Return carriage/new line delimited list of gear associated with the given cruise leg';
COMMENT ON COLUMN CCD_LEG_DELIM_V.GEAR_NAME_BR_LIST IS '<BR> tag (intended for web pages) delimited list of gear associated with the given cruise leg';

COMMENT ON COLUMN CCD_LEG_DELIM_V.NUM_REGIONS IS 'The number of associated regions';
COMMENT ON COLUMN CCD_LEG_DELIM_V.REGION_CODE_CD_LIST IS 'Comma-delimited list of region codes associated with the given cruise leg';
COMMENT ON COLUMN CCD_LEG_DELIM_V.REGION_CODE_SCD_LIST IS 'Semicolon-delimited list of region codes associated with the given cruise leg';
COMMENT ON COLUMN CCD_LEG_DELIM_V.REGION_CODE_RC_LIST IS 'Return carriage/new line delimited list of region codes associated with the given cruise leg';
COMMENT ON COLUMN CCD_LEG_DELIM_V.REGION_CODE_BR_LIST IS '<BR> tag (intended for web pages) delimited list of region codes associated with the given cruise leg';


COMMENT ON COLUMN CCD_LEG_DELIM_V.REGION_NAME_CD_LIST IS 'Comma-delimited list of region names associated with the given cruise leg';
COMMENT ON COLUMN CCD_LEG_DELIM_V.REGION_NAME_SCD_LIST IS 'Semicolon-delimited list of region names associated with the given cruise leg';
COMMENT ON COLUMN CCD_LEG_DELIM_V.REGION_NAME_RC_LIST IS 'Return carriage/new line delimited list of region names associated with the given cruise leg';
COMMENT ON COLUMN CCD_LEG_DELIM_V.REGION_NAME_BR_LIST IS '<BR> tag (intended for web pages) delimited list of region names associated with the given cruise leg';

COMMENT ON COLUMN CCD_LEG_DELIM_V.NUM_LEG_ALIASES IS 'The number of associated leg aliases';
COMMENT ON COLUMN CCD_LEG_DELIM_V.LEG_ALIAS_CD_LIST IS 'Comma-delimited list of leg aliases associated with the given cruise leg';
COMMENT ON COLUMN CCD_LEG_DELIM_V.LEG_ALIAS_SCD_LIST IS 'Semicolon-delimited list of leg aliases associated with the given cruise leg';
COMMENT ON COLUMN CCD_LEG_DELIM_V.LEG_ALIAS_RC_LIST IS 'Return carriage/new line delimited list of leg aliases associated with the given cruise leg';
COMMENT ON COLUMN CCD_LEG_DELIM_V.LEG_ALIAS_BR_LIST IS '<BR> tag (intended for web pages) delimited list of leg aliases associated with the given cruise leg';



COMMENT ON TABLE CCD_LEG_DELIM_V IS 'Research Cruise Legs Delimited Reference Values (View)

This query returns all of the research cruise legs and their associated reference tables (e.g. Vessel, Platform Type, etc.) as well as the comma-/semicolon-delimited list of associated reference values (e.g. regional ecosystems, gear, regions, leg aliases, etc.)';


ALTER VIEW CCD_QC_LEG_V COMPILE;


COMMENT ON COLUMN CCD_QC_LEG_V.FORMAT_LEG_START_DATE IS 'The start date in the corresponding time zone for the given research cruise leg in MM/DD/YYYY format';

COMMENT ON COLUMN CCD_QC_LEG_V.FORMAT_LEG_END_DATE IS 'The end date in the corresponding time zone for the given research cruise leg in MM/DD/YYYY format';

ALTER VIEW CCD_QC_LEG_OVERLAP_V COMPILE;

COMMENT ON COLUMN CCD_QC_LEG_OVERLAP_V.FORMAT_LEG_START_DATE1 IS 'The start date in the corresponding time zone for the first research cruise leg in MM/DD/YYYY format';
COMMENT ON COLUMN CCD_QC_LEG_OVERLAP_V.FORMAT_LEG_END_DATE1 IS 'The end date in the corresponding time zone for the first research cruise leg in MM/DD/YYYY format';

COMMENT ON COLUMN CCD_QC_LEG_OVERLAP_V.FORMAT_LEG_START_DATE2 IS 'The start date in the corresponding time zone for the second research cruise leg in MM/DD/YYYY format';
COMMENT ON COLUMN CCD_QC_LEG_OVERLAP_V.FORMAT_LEG_END_DATE2 IS 'The end date in the corresponding time zone for the second research cruise leg in MM/DD/YYYY format';


ALTER VIEW CCD_QC_LEG_ALIAS_V COMPILE;

COMMENT ON COLUMN CCD_QC_LEG_ALIAS_V.FORMAT_LEG_START_DATE IS 'The start date in the corresponding time zone for the given research cruise leg in MM/DD/YYYY format';
COMMENT ON COLUMN CCD_QC_LEG_ALIAS_V.FORMAT_LEG_END_DATE IS 'The end date in the corresponding time zone for the given research cruise leg in MM/DD/YYYY format';


ALTER PACKAGE CCD_CRUISE_PKG COMPILE;
ALTER PACKAGE CCD_DVM_PKG COMPILE;

--define the upgrade version in the database upgrade log table:
INSERT INTO DB_UPGRADE_LOGS (UPGRADE_APP_NAME, UPGRADE_VERSION, UPGRADE_DATE, UPGRADE_DESC) VALUES ('Centralized Cruise Database', '1.0', TO_DATE('01-MAY-23', 'DD-MON-YY'), 'Upgraded from Version 0.4 (Git tag: APX_Cust_Err_Handler_db_v0.4) to  Version 1.0 (Git tag: APX_Cust_Err_Handler_db_v1.0) of the APEX custom error handler module database (Git URL: git@picgitlab.nmfs.local:centralized-data-tools/apex_tools.git in the "Error Handling" folder).  Dropped the standalone AAM.  Adding TZ offset to cruise legs table');


--commit the DB_UPGRADE_LOGS record insertion
COMMIT;
