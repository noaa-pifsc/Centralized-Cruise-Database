--------------------------------------------------------
--------------------------------------------------------
--Database Name: Centralized Cruise Database
--Database Description: Centralized Cruise Database to track information about each PIFSC research cruise including activities, chief scientists, regions, etc. to remove the need for each division/program to manage this information
--------------------------------------------------------
--------------------------------------------------------


--------------------------------------------------------
--Centralized Cruise Database - version 0.15 updates:
--------------------------------------------------------

--Installed Version 0.4 of the Data Validation Module Database (Git URL: git@gitlab.pifsc.gov:centralized-data-tools/data-validation-module.git)
@@"./external_modules/DVM_DDL_DML_upgrade_v0.4.sql";




create or replace view
CCD_CRUISE_ERR_SUMM_V

AS

select
CCD_CRUISE_SUMM_V.CRUISE_ID,
CCD_CRUISE_SUMM_V.CRUISE_NAME,
CCD_CRUISE_SUMM_V.CRUISE_NOTES,
CCD_CRUISE_SUMM_V.CRUISE_DESC,
CCD_CRUISE_SUMM_V.OBJ_BASED_METRICS,
CCD_CRUISE_SUMM_V.SCI_CENTER_DIV_ID,
CCD_CRUISE_SUMM_V.SCI_CENTER_DIV_CODE,
CCD_CRUISE_SUMM_V.SCI_CENTER_DIV_NAME,
CCD_CRUISE_SUMM_V.SCI_CENTER_DIV_DESC,
CCD_CRUISE_SUMM_V.SCI_CENTER_ID,
CCD_CRUISE_SUMM_V.SCI_CENTER_NAME,
CCD_CRUISE_SUMM_V.SCI_CENTER_DESC,
CCD_CRUISE_SUMM_V.STD_SVY_NAME_ID,
CCD_CRUISE_SUMM_V.STD_SVY_NAME,
CCD_CRUISE_SUMM_V.STD_SVY_DESC,
CCD_CRUISE_SUMM_V.SVY_FREQ_ID,
CCD_CRUISE_SUMM_V.SVY_FREQ_NAME,
CCD_CRUISE_SUMM_V.SVY_FREQ_DESC,
CCD_CRUISE_SUMM_V.STD_SVY_NAME_OTH,
CCD_CRUISE_SUMM_V.STD_SVY_NAME_VAL,
CCD_CRUISE_SUMM_V.SVY_TYPE_ID,
CCD_CRUISE_SUMM_V.SVY_TYPE_NAME,
CCD_CRUISE_SUMM_V.SVY_TYPE_DESC,
CCD_CRUISE_SUMM_V.CRUISE_URL,
CCD_CRUISE_SUMM_V.CRUISE_CONT_EMAIL,
CCD_CRUISE_SUMM_V.PTA_ERROR_ID,
CCD_CRUISE_SUMM_V.NUM_SPP_ESA,
CCD_CRUISE_SUMM_V.SPP_ESA_NAME_CD_LIST,
CCD_CRUISE_SUMM_V.SPP_ESA_NAME_SCD_LIST,
CCD_CRUISE_SUMM_V.SPP_ESA_NAME_RC_LIST,
CCD_CRUISE_SUMM_V.SPP_ESA_NAME_BR_LIST,
CCD_CRUISE_SUMM_V.NUM_SPP_FSSI,
CCD_CRUISE_SUMM_V.SPP_FSSI_NAME_CD_LIST,
CCD_CRUISE_SUMM_V.SPP_FSSI_NAME_SCD_LIST,
CCD_CRUISE_SUMM_V.SPP_FSSI_NAME_RC_LIST,
CCD_CRUISE_SUMM_V.SPP_FSSI_NAME_BR_LIST,
CCD_CRUISE_SUMM_V.NUM_SPP_MMPA,
CCD_CRUISE_SUMM_V.SPP_MMPA_NAME_CD_LIST,
CCD_CRUISE_SUMM_V.SPP_MMPA_NAME_SCD_LIST,
CCD_CRUISE_SUMM_V.SPP_MMPA_NAME_RC_LIST,
CCD_CRUISE_SUMM_V.SPP_MMPA_NAME_BR_LIST,
CCD_CRUISE_SUMM_V.NUM_PRIM_SVY_CATS,
CCD_CRUISE_SUMM_V.PRIM_SVY_CAT_NAME_CD_LIST,
CCD_CRUISE_SUMM_V.PRIM_SVY_CAT_NAME_SCD_LIST,
CCD_CRUISE_SUMM_V.PRIM_SVY_CAT_NAME_RC_LIST,
CCD_CRUISE_SUMM_V.PRIM_SVY_CAT_NAME_BR_LIST,
CCD_CRUISE_SUMM_V.NUM_SEC_SVY_CATS,
CCD_CRUISE_SUMM_V.SEC_SVY_CAT_NAME_CD_LIST,
CCD_CRUISE_SUMM_V.SEC_SVY_CAT_NAME_SCD_LIST,
CCD_CRUISE_SUMM_V.SEC_SVY_CAT_NAME_RC_LIST,
CCD_CRUISE_SUMM_V.SEC_SVY_CAT_NAME_BR_LIST,
CCD_CRUISE_SUMM_V.NUM_EXP_SPP,
CCD_CRUISE_SUMM_V.EXP_SPP_NAME_CD_LIST,
CCD_CRUISE_SUMM_V.EXP_SPP_NAME_SCD_LIST,
CCD_CRUISE_SUMM_V.EXP_SPP_NAME_RC_LIST,
CCD_CRUISE_SUMM_V.EXP_SPP_NAME_BR_LIST,
CCD_CRUISE_SUMM_V.NUM_SPP_OTH,
CCD_CRUISE_SUMM_V.OTH_SPP_CNAME_CD_LIST,
CCD_CRUISE_SUMM_V.OTH_SPP_CNAME_SCD_LIST,
CCD_CRUISE_SUMM_V.OTH_SPP_CNAME_RC_LIST,
CCD_CRUISE_SUMM_V.OTH_SPP_CNAME_BR_LIST,
CCD_CRUISE_SUMM_V.OTH_SPP_SNAME_CD_LIST,
CCD_CRUISE_SUMM_V.OTH_SPP_SNAME_SCD_LIST,
CCD_CRUISE_SUMM_V.OTH_SPP_SNAME_RC_LIST,
CCD_CRUISE_SUMM_V.OTH_SPP_SNAME_BR_LIST,
CCD_CRUISE_SUMM_V.CRUISE_START_DATE,
CCD_CRUISE_SUMM_V.FORMAT_CRUISE_START_DATE,
CCD_CRUISE_SUMM_V.CRUISE_END_DATE,
CCD_CRUISE_SUMM_V.FORMAT_CRUISE_END_DATE,
CCD_CRUISE_SUMM_V.CRUISE_DAS,
CCD_CRUISE_SUMM_V.CRUISE_LEN_DAYS,
CCD_CRUISE_SUMM_V.CRUISE_YEAR,
CCD_CRUISE_SUMM_V.CRUISE_FISC_YEAR,
CCD_CRUISE_SUMM_V.NUM_LEGS,
CCD_CRUISE_SUMM_V.LEG_NAME_CD_LIST,
CCD_CRUISE_SUMM_V.LEG_NAME_SCD_LIST,
CCD_CRUISE_SUMM_V.LEG_NAME_RC_LIST,
CCD_CRUISE_SUMM_V.LEG_NAME_BR_LIST,
CCD_CRUISE_SUMM_V.LEG_NAME_DATES_CD_LIST,
CCD_CRUISE_SUMM_V.LEG_NAME_DATES_SCD_LIST,
CCD_CRUISE_SUMM_V.LEG_NAME_DATES_RC_LIST,
CCD_CRUISE_SUMM_V.LEG_NAME_DATES_BR_LIST,
CCD_CRUISE_SUMM_V.NUM_REGIONS,
CCD_CRUISE_SUMM_V.REGION_CODE_CD_LIST,
CCD_CRUISE_SUMM_V.REGION_CODE_SCD_LIST,
CCD_CRUISE_SUMM_V.REGION_CODE_RC_LIST,
CCD_CRUISE_SUMM_V.REGION_CODE_BR_LIST,
CCD_CRUISE_SUMM_V.REGION_NAME_CD_LIST,
CCD_CRUISE_SUMM_V.REGION_NAME_SCD_LIST,
CCD_CRUISE_SUMM_V.REGION_NAME_RC_LIST,
CCD_CRUISE_SUMM_V.REGION_NAME_BR_LIST,
CCD_CRUISE_SUMM_V.NUM_ECOSYSTEMS,
CCD_CRUISE_SUMM_V.ECOSYSTEM_CD_LIST,
CCD_CRUISE_SUMM_V.ECOSYSTEM_SCD_LIST,
CCD_CRUISE_SUMM_V.ECOSYSTEM_RC_LIST,
CCD_CRUISE_SUMM_V.ECOSYSTEM_BR_LIST,
CCD_CRUISE_SUMM_V.NUM_GEAR,
CCD_CRUISE_SUMM_V.GEAR_CD_LIST,
CCD_CRUISE_SUMM_V.GEAR_SCD_LIST,
CCD_CRUISE_SUMM_V.GEAR_RC_LIST,
CCD_CRUISE_SUMM_V.GEAR_BR_LIST,
NVL(NUM_WARNINGS, 0) NUM_WARNINGS,
NVL(NUM_ACTIVE_ERRORS, 0) NUM_ACTIVE_ERRORS,
NVL(NUM_ANNOT_ERRORS, 0) NUM_ANNOT_ERRORS,
(CASE WHEN NUM_ACTIVE_ERRORS IS NULL OR NUM_ACTIVE_ERRORS = 0 THEN 'Y' ELSE 'N' END) CRUISE_VALID_YN

FROM CCD_CRUISE_SUMM_V
LEFT JOIN
(
    SELECT PTA_ERROR_ID,
    SUM(CASE WHEN ERR_SEVERITY_CODE = 'WARN' THEN 1 ELSE 0 END) NUM_WARNINGS,
    SUM(CASE WHEN ERR_SEVERITY_CODE = 'ERROR' AND ERR_RES_TYPE_ID IS NULL THEN 1 ELSE 0 END) NUM_ACTIVE_ERRORS,
    SUM(CASE WHEN ERR_SEVERITY_CODE = 'ERROR' AND ERR_RES_TYPE_ID IS NOT NULL THEN 1 ELSE 0 END) NUM_ANNOT_ERRORS
    FROM CEN_CRUISE.DVM_PTA_ERRORS_V
    group by PTA_ERROR_ID
) DVM_ERR_INFO
ON DVM_ERR_INFO.PTA_ERROR_ID = CCD_CRUISE_SUMM_V.PTA_ERROR_ID
order by cruise_start_date, cruise_name;


COMMENT ON COLUMN CCD_CRUISE_ERR_SUMM_V.CRUISE_ID IS 'Primary key for the CCD_CRUISES table';
COMMENT ON COLUMN CCD_CRUISE_ERR_SUMM_V.CRUISE_NAME IS 'The name of the given cruise designated by NOAA (e.g. SE-15-01)';
COMMENT ON COLUMN CCD_CRUISE_ERR_SUMM_V.CRUISE_NOTES IS 'Any notes for the given research cruise';
COMMENT ON COLUMN CCD_CRUISE_ERR_SUMM_V.CRUISE_DESC IS 'Description for the given research cruise';
COMMENT ON COLUMN CCD_CRUISE_ERR_SUMM_V.OBJ_BASED_METRICS IS 'Objective Based Metrics for the given research cruise';
COMMENT ON COLUMN CCD_CRUISE_ERR_SUMM_V.SCI_CENTER_DIV_ID IS 'Primary key for the Science Center Division table';
COMMENT ON COLUMN CCD_CRUISE_ERR_SUMM_V.SCI_CENTER_DIV_CODE IS 'Abbreviated code for the given Science Center Division';
COMMENT ON COLUMN CCD_CRUISE_ERR_SUMM_V.SCI_CENTER_DIV_NAME IS 'Name of the given Science Center Division';
COMMENT ON COLUMN CCD_CRUISE_ERR_SUMM_V.SCI_CENTER_DIV_DESC IS 'Description for the given Science Center Division';
COMMENT ON COLUMN CCD_CRUISE_ERR_SUMM_V.SCI_CENTER_ID IS 'Primary key for the Science Center table';
COMMENT ON COLUMN CCD_CRUISE_ERR_SUMM_V.SCI_CENTER_NAME IS 'Name of the given Science Center';
COMMENT ON COLUMN CCD_CRUISE_ERR_SUMM_V.SCI_CENTER_DESC IS 'Description for the given Science Center';
COMMENT ON COLUMN CCD_CRUISE_ERR_SUMM_V.STD_SVY_NAME_ID IS 'Primary key for the Standard Survey Name table';
COMMENT ON COLUMN CCD_CRUISE_ERR_SUMM_V.STD_SVY_NAME IS 'Name of the given Standard Survey Name';
COMMENT ON COLUMN CCD_CRUISE_ERR_SUMM_V.STD_SVY_DESC IS 'Description for the given Standard Survey Name';
COMMENT ON COLUMN CCD_CRUISE_ERR_SUMM_V.SVY_FREQ_ID IS 'Primary key for the Survey Frequency table';
COMMENT ON COLUMN CCD_CRUISE_ERR_SUMM_V.SVY_FREQ_NAME IS 'Name of the given Survey Frequency';
COMMENT ON COLUMN CCD_CRUISE_ERR_SUMM_V.SVY_FREQ_DESC IS 'Description for the given Survey Frequency';
COMMENT ON COLUMN CCD_CRUISE_ERR_SUMM_V.STD_SVY_NAME_OTH IS 'Field defines a Standard Survey Name that is not included in the Standard Survey Name table';
COMMENT ON COLUMN CCD_CRUISE_ERR_SUMM_V.STD_SVY_NAME_VAL IS 'This field contains the Standard Survey Name defined for the given cruise.  If the STD_SVY_NAME_ID field is defined then the associated CCD_STD_SVY_NAMES.STD_SVY_NAME is used because the foreign key is given precedence, otherwise the STD_SVY_NAME_OTH field value is used';
COMMENT ON COLUMN CCD_CRUISE_ERR_SUMM_V.SVY_TYPE_ID IS 'Primary key for the Survey Type table';
COMMENT ON COLUMN CCD_CRUISE_ERR_SUMM_V.SVY_TYPE_NAME IS 'Name of the given Survey Type';
COMMENT ON COLUMN CCD_CRUISE_ERR_SUMM_V.SVY_TYPE_DESC IS 'Description for the given Survey Type';
COMMENT ON COLUMN CCD_CRUISE_ERR_SUMM_V.CRUISE_URL IS 'The Cruise URL (Referred to as "Survey URL" in FINSS System) for the given Cruise';
COMMENT ON COLUMN CCD_CRUISE_ERR_SUMM_V.CRUISE_CONT_EMAIL IS 'The Cruise Contact Email (Referred to as "Survey Contact Email" in FINSS System) for the given Cruise';
COMMENT ON COLUMN CCD_CRUISE_ERR_SUMM_V.PTA_ERROR_ID IS 'Foreign key reference to the Errors (PTA) intersection table';
COMMENT ON COLUMN CCD_CRUISE_ERR_SUMM_V.NUM_SPP_ESA IS 'The number of associated ESA Species';
COMMENT ON COLUMN CCD_CRUISE_ERR_SUMM_V.SPP_ESA_NAME_CD_LIST IS 'Comma-delimited list of ESA Species associated with the given cruise';
COMMENT ON COLUMN CCD_CRUISE_ERR_SUMM_V.SPP_ESA_NAME_SCD_LIST IS 'Semicolon-delimited list of ESA Species associated with the given cruise';
COMMENT ON COLUMN CCD_CRUISE_ERR_SUMM_V.SPP_ESA_NAME_RC_LIST IS 'Return carriage/new line delimited list of ESA Species associated with the given cruise';
COMMENT ON COLUMN CCD_CRUISE_ERR_SUMM_V.SPP_ESA_NAME_BR_LIST IS '<BR> tag (intended for web pages) delimited list of ESA Species associated with the given cruise';
COMMENT ON COLUMN CCD_CRUISE_ERR_SUMM_V.NUM_SPP_FSSI IS 'The number of associated FSSI Species';
COMMENT ON COLUMN CCD_CRUISE_ERR_SUMM_V.SPP_FSSI_NAME_CD_LIST IS 'Comma-delimited list of FSSI Species associated with the given cruise';
COMMENT ON COLUMN CCD_CRUISE_ERR_SUMM_V.SPP_FSSI_NAME_SCD_LIST IS 'Semicolon-delimited list of FSSI Species associated with the given cruise';
COMMENT ON COLUMN CCD_CRUISE_ERR_SUMM_V.SPP_FSSI_NAME_RC_LIST IS 'Return carriage/new line delimited list of FSSI Species associated with the given cruise';
COMMENT ON COLUMN CCD_CRUISE_ERR_SUMM_V.SPP_FSSI_NAME_BR_LIST IS '<BR> tag (intended for web pages) delimited list of FSSI Species associated with the given cruise';
COMMENT ON COLUMN CCD_CRUISE_ERR_SUMM_V.NUM_SPP_MMPA IS 'The number of associated MMPA Species';
COMMENT ON COLUMN CCD_CRUISE_ERR_SUMM_V.SPP_MMPA_NAME_CD_LIST IS 'Comma-delimited list of MMPA Species associated with the given cruise';
COMMENT ON COLUMN CCD_CRUISE_ERR_SUMM_V.SPP_MMPA_NAME_SCD_LIST IS 'Semicolon-delimited list of MMPA Species associated with the given cruise';
COMMENT ON COLUMN CCD_CRUISE_ERR_SUMM_V.SPP_MMPA_NAME_RC_LIST IS 'Return carriage/new line delimited list of MMPA Species associated with the given cruise';
COMMENT ON COLUMN CCD_CRUISE_ERR_SUMM_V.SPP_MMPA_NAME_BR_LIST IS '<BR> tag (intended for web pages) delimited list of MMPA Species associated with the given cruise';
COMMENT ON COLUMN CCD_CRUISE_ERR_SUMM_V.NUM_PRIM_SVY_CATS IS 'The number of associated primary survey categories';
COMMENT ON COLUMN CCD_CRUISE_ERR_SUMM_V.PRIM_SVY_CAT_NAME_CD_LIST IS 'Comma-delimited list of primary survey categories associated with the given cruise';
COMMENT ON COLUMN CCD_CRUISE_ERR_SUMM_V.PRIM_SVY_CAT_NAME_SCD_LIST IS 'Semicolon-delimited list of primary survey categories associated with the given cruise';
COMMENT ON COLUMN CCD_CRUISE_ERR_SUMM_V.PRIM_SVY_CAT_NAME_RC_LIST IS 'Return carriage/new line delimited list of primary survey categories associated with the given cruise';
COMMENT ON COLUMN CCD_CRUISE_ERR_SUMM_V.PRIM_SVY_CAT_NAME_BR_LIST IS '<BR> tag (intended for web pages) delimited list of primary survey categories associated with the given cruise';
COMMENT ON COLUMN CCD_CRUISE_ERR_SUMM_V.NUM_SEC_SVY_CATS IS 'The number of associated secondary survey categories';
COMMENT ON COLUMN CCD_CRUISE_ERR_SUMM_V.SEC_SVY_CAT_NAME_CD_LIST IS 'Comma-delimited list of secondary survey categories associated with the given cruise';
COMMENT ON COLUMN CCD_CRUISE_ERR_SUMM_V.SEC_SVY_CAT_NAME_SCD_LIST IS 'Semicolon-delimited list of secondary survey categories associated with the given cruise';
COMMENT ON COLUMN CCD_CRUISE_ERR_SUMM_V.SEC_SVY_CAT_NAME_RC_LIST IS 'Return carriage/new line delimited list of secondary survey categories associated with the given cruise';
COMMENT ON COLUMN CCD_CRUISE_ERR_SUMM_V.SEC_SVY_CAT_NAME_BR_LIST IS '<BR> tag (intended for web pages) delimited list of secondary survey categories associated with the given cruise';
COMMENT ON COLUMN CCD_CRUISE_ERR_SUMM_V.NUM_EXP_SPP IS 'The number of associated expected species categories';
COMMENT ON COLUMN CCD_CRUISE_ERR_SUMM_V.EXP_SPP_NAME_CD_LIST IS 'Comma-delimited list of expected species categories associated with the given cruise';
COMMENT ON COLUMN CCD_CRUISE_ERR_SUMM_V.EXP_SPP_NAME_SCD_LIST IS 'Semicolon-delimited list of expected species categories associated with the given cruise';
COMMENT ON COLUMN CCD_CRUISE_ERR_SUMM_V.EXP_SPP_NAME_RC_LIST IS 'Return carriage/new line delimited list of expected species categories associated with the given cruise';
COMMENT ON COLUMN CCD_CRUISE_ERR_SUMM_V.EXP_SPP_NAME_BR_LIST IS '<BR> tag (intended for web pages) delimited list of expected species categories associated with the given cruise';
COMMENT ON COLUMN CCD_CRUISE_ERR_SUMM_V.NUM_SPP_OTH IS 'The number of associated target species - other';
COMMENT ON COLUMN CCD_CRUISE_ERR_SUMM_V.OTH_SPP_CNAME_CD_LIST IS 'Comma-delimited list of common names for target species - other associated with the given cruise';
COMMENT ON COLUMN CCD_CRUISE_ERR_SUMM_V.OTH_SPP_CNAME_SCD_LIST IS 'Semicolon-delimited list of common names for target species - other associated with the given cruise';
COMMENT ON COLUMN CCD_CRUISE_ERR_SUMM_V.OTH_SPP_CNAME_RC_LIST IS 'Return carriage/new line delimited list of common names for target species - other associated with the given cruise';
COMMENT ON COLUMN CCD_CRUISE_ERR_SUMM_V.OTH_SPP_CNAME_BR_LIST IS '<BR> tag (intended for web pages) delimited list of common names for target species - other associated with the given cruise';
COMMENT ON COLUMN CCD_CRUISE_ERR_SUMM_V.OTH_SPP_SNAME_CD_LIST IS 'Comma-delimited list of scientific names for target species - other associated with the given cruise';
COMMENT ON COLUMN CCD_CRUISE_ERR_SUMM_V.OTH_SPP_SNAME_SCD_LIST IS 'Semicolon-delimited list of scientific names for target species - other associated with the given cruise';
COMMENT ON COLUMN CCD_CRUISE_ERR_SUMM_V.OTH_SPP_SNAME_RC_LIST IS 'Return carriage/new line delimited list of scientific names for target species - other associated with the given cruise';
COMMENT ON COLUMN CCD_CRUISE_ERR_SUMM_V.OTH_SPP_SNAME_BR_LIST IS '<BR> tag (intended for web pages) delimited list of scientific names for target species - other associated with the given cruise';
COMMENT ON COLUMN CCD_CRUISE_ERR_SUMM_V.CRUISE_START_DATE IS 'The start date for the given cruise (based on the earliest associated cruise leg''s start date)';
COMMENT ON COLUMN CCD_CRUISE_ERR_SUMM_V.FORMAT_CRUISE_START_DATE IS 'The formatted start date for the given cruise (based on the earliest associated cruise leg''s start date) in MM/DD/YYYY HH24:MI:SS format';
COMMENT ON COLUMN CCD_CRUISE_ERR_SUMM_V.CRUISE_END_DATE IS 'The end date for the given cruise (based on the latest associated cruise leg''s end date)';
COMMENT ON COLUMN CCD_CRUISE_ERR_SUMM_V.FORMAT_CRUISE_END_DATE IS 'The formatted end date for the given cruise (based on the latest associated cruise leg''s end date) in MM/DD/YYYY HH24:MI:SS format';
COMMENT ON COLUMN CCD_CRUISE_ERR_SUMM_V.CRUISE_DAS IS 'The total number of days at sea for each of the legs associated with the given cruise';
COMMENT ON COLUMN CCD_CRUISE_ERR_SUMM_V.CRUISE_LEN_DAYS IS 'The total number of days between the Cruise Start and End Dates for the given cruise';
COMMENT ON COLUMN CCD_CRUISE_ERR_SUMM_V.CRUISE_YEAR IS 'The calendar year for the given cruise (based on the earliest associated cruise leg''s start date)';
COMMENT ON COLUMN CCD_CRUISE_ERR_SUMM_V.CRUISE_FISC_YEAR IS 'The NOAA fiscal year for the given cruise (based on the earliest associated cruise leg''s start date)';
COMMENT ON COLUMN CCD_CRUISE_ERR_SUMM_V.NUM_LEGS IS 'The number of cruise legs associated with the given cruise';
COMMENT ON COLUMN CCD_CRUISE_ERR_SUMM_V.LEG_NAME_CD_LIST IS 'Comma-delimited list of leg names associated with the given cruise';
COMMENT ON COLUMN CCD_CRUISE_ERR_SUMM_V.LEG_NAME_SCD_LIST IS 'Semicolon-delimited list of leg names associated with the given cruise';
COMMENT ON COLUMN CCD_CRUISE_ERR_SUMM_V.LEG_NAME_RC_LIST IS 'Return carriage/new line delimited list of leg names associated with the given cruise';
COMMENT ON COLUMN CCD_CRUISE_ERR_SUMM_V.LEG_NAME_BR_LIST IS '<BR> tag (intended for web pages) delimited list of leg names associated with the given cruise';
COMMENT ON COLUMN CCD_CRUISE_ERR_SUMM_V.LEG_NAME_DATES_CD_LIST IS 'Comma-delimited list of leg names, the associated leg dates and vessel name associated with the given cruise';
COMMENT ON COLUMN CCD_CRUISE_ERR_SUMM_V.LEG_NAME_DATES_SCD_LIST IS 'Semicolon-delimited list of leg names, the associated leg dates and vessel name associated with the given cruise';
COMMENT ON COLUMN CCD_CRUISE_ERR_SUMM_V.LEG_NAME_DATES_RC_LIST IS 'Return carriage/new line delimited list of leg names, the associated leg dates and vessel name associated with the given cruise';
COMMENT ON COLUMN CCD_CRUISE_ERR_SUMM_V.LEG_NAME_DATES_BR_LIST IS '<BR> tag (intended for web pages) delimited list of leg names, the associated leg dates and vessel name associated with the given cruise';
COMMENT ON COLUMN CCD_CRUISE_ERR_SUMM_V.NUM_REGIONS IS 'The number of unique regions associated with the associated cruise legs';
COMMENT ON COLUMN CCD_CRUISE_ERR_SUMM_V.REGION_CODE_CD_LIST IS 'Comma-delimited list of unique region codes associated with the given cruise leg';
COMMENT ON COLUMN CCD_CRUISE_ERR_SUMM_V.REGION_CODE_SCD_LIST IS 'Semicolon-delimited list of unique region codes associated with the given cruise leg';
COMMENT ON COLUMN CCD_CRUISE_ERR_SUMM_V.REGION_CODE_RC_LIST IS 'Return carriage/new line delimited list of unique region codes associated with the given cruise leg';
COMMENT ON COLUMN CCD_CRUISE_ERR_SUMM_V.REGION_CODE_BR_LIST IS '<BR> tag (intended for web pages) delimited list of unique region codes associated with the given cruise leg';
COMMENT ON COLUMN CCD_CRUISE_ERR_SUMM_V.REGION_NAME_CD_LIST IS 'Comma-delimited list of unique region names associated with the given cruise leg';
COMMENT ON COLUMN CCD_CRUISE_ERR_SUMM_V.REGION_NAME_SCD_LIST IS 'Semicolon-delimited list of unique region names associated with the given cruise leg';
COMMENT ON COLUMN CCD_CRUISE_ERR_SUMM_V.REGION_NAME_RC_LIST IS 'Return carriage/new line delimited list of unique region names associated with the given cruise leg';
COMMENT ON COLUMN CCD_CRUISE_ERR_SUMM_V.REGION_NAME_BR_LIST IS '<BR> tag (intended for web pages) delimited list of unique region names associated with the given cruise leg';
COMMENT ON COLUMN CCD_CRUISE_ERR_SUMM_V.NUM_ECOSYSTEMS IS 'The number of unique regional ecosystems associated with the associated cruise legs';
COMMENT ON COLUMN CCD_CRUISE_ERR_SUMM_V.ECOSYSTEM_CD_LIST IS 'Comma-delimited list of unique regional ecosystems associated with the given cruise leg';
COMMENT ON COLUMN CCD_CRUISE_ERR_SUMM_V.ECOSYSTEM_SCD_LIST IS 'Semicolon-delimited list of unique regional ecosystems associated with the given cruise leg';
COMMENT ON COLUMN CCD_CRUISE_ERR_SUMM_V.ECOSYSTEM_RC_LIST IS 'Return carriage/new line delimited list of unique regional ecosystems associated with the given cruise leg';
COMMENT ON COLUMN CCD_CRUISE_ERR_SUMM_V.ECOSYSTEM_BR_LIST IS '<BR> tag (intended for web pages) delimited list of unique regional ecosystems associated with the given cruise leg';
COMMENT ON COLUMN CCD_CRUISE_ERR_SUMM_V.NUM_GEAR IS 'The number of unique gear associated with the associated cruise legs';
COMMENT ON COLUMN CCD_CRUISE_ERR_SUMM_V.GEAR_CD_LIST IS 'Comma-delimited list of unique gear associated with the associated cruise legs';
COMMENT ON COLUMN CCD_CRUISE_ERR_SUMM_V.GEAR_SCD_LIST IS 'Semicolon-delimited list of unique gear associated with the associated cruise legs';
COMMENT ON COLUMN CCD_CRUISE_ERR_SUMM_V.GEAR_RC_LIST IS 'Return carriage/new line delimited list of unique gear associated with the associated cruise legs';
COMMENT ON COLUMN CCD_CRUISE_ERR_SUMM_V.GEAR_BR_LIST IS '<BR> tag (intended for web pages) delimited list of unique gear associated with the associated cruise legs';
COMMENT ON COLUMN CCD_CRUISE_ERR_SUMM_V.NUM_WARNINGS IS 'Number of QC Validation Warnings for the given cruise';
COMMENT ON COLUMN CCD_CRUISE_ERR_SUMM_V.NUM_ACTIVE_ERRORS IS 'Number of QC Validation Active Errors (Errors that are not annotated) for the given cruise';
COMMENT ON COLUMN CCD_CRUISE_ERR_SUMM_V.NUM_ANNOT_ERRORS IS 'Number of QC Validation Annotated Errors (Errors that have had an error resolution specified) for the given cruise';
COMMENT ON COLUMN CCD_CRUISE_ERR_SUMM_V.CRUISE_VALID_YN IS 'Flag to indicate if the given cruise is considered valid (Y) when the only associated QC validation issues are annotated errors and/or warnings or invalid (N) when there are one or more associated active error QC validation issues';


COMMENT ON TABLE CCD_CRUISE_ERR_SUMM_V IS 'Research Cruise Leg Error Summary (View)

This query returns all of the research cruises and all associated comma-/semicolon-delimited list of associated reference values.  The aggregate cruise leg information is included as start and end dates and the number of legs defined for the given cruise (if any) as well as all associated comma-/semicolon-delimited unique list of associated reference values (regional ecosystems, gear, regions).  This view also contains summary information for any associated QC validation issues in the categories of warnings, active errors and annotated errors';




CREATE OR REPLACE VIEW
CCD_CRUISE_SUMM_ERR_V
AS SELECT
CCD_CRUISE_SUMM_V.CRUISE_ID,
CCD_CRUISE_SUMM_V.CRUISE_NAME,
CCD_CRUISE_SUMM_V.CRUISE_NOTES,
CCD_CRUISE_SUMM_V.CRUISE_DESC,
CCD_CRUISE_SUMM_V.OBJ_BASED_METRICS,
CCD_CRUISE_SUMM_V.SCI_CENTER_DIV_ID,
CCD_CRUISE_SUMM_V.SCI_CENTER_DIV_CODE,
CCD_CRUISE_SUMM_V.SCI_CENTER_DIV_NAME,
CCD_CRUISE_SUMM_V.SCI_CENTER_DIV_DESC,
CCD_CRUISE_SUMM_V.SCI_CENTER_ID,
CCD_CRUISE_SUMM_V.SCI_CENTER_NAME,
CCD_CRUISE_SUMM_V.SCI_CENTER_DESC,
CCD_CRUISE_SUMM_V.STD_SVY_NAME_ID,
CCD_CRUISE_SUMM_V.STD_SVY_NAME,
CCD_CRUISE_SUMM_V.STD_SVY_DESC,
CCD_CRUISE_SUMM_V.SVY_FREQ_ID,
CCD_CRUISE_SUMM_V.SVY_FREQ_NAME,
CCD_CRUISE_SUMM_V.SVY_FREQ_DESC,
CCD_CRUISE_SUMM_V.STD_SVY_NAME_OTH,
CCD_CRUISE_SUMM_V.STD_SVY_NAME_VAL,
CCD_CRUISE_SUMM_V.SVY_TYPE_ID,
CCD_CRUISE_SUMM_V.SVY_TYPE_NAME,
CCD_CRUISE_SUMM_V.SVY_TYPE_DESC,
CCD_CRUISE_SUMM_V.CRUISE_URL,
CCD_CRUISE_SUMM_V.CRUISE_CONT_EMAIL,
CCD_CRUISE_SUMM_V.PTA_ERROR_ID,
CCD_CRUISE_SUMM_V.NUM_SPP_ESA,
CCD_CRUISE_SUMM_V.SPP_ESA_NAME_CD_LIST,
CCD_CRUISE_SUMM_V.SPP_ESA_NAME_SCD_LIST,
CCD_CRUISE_SUMM_V.SPP_ESA_NAME_RC_LIST,
CCD_CRUISE_SUMM_V.SPP_ESA_NAME_BR_LIST,
CCD_CRUISE_SUMM_V.NUM_SPP_FSSI,
CCD_CRUISE_SUMM_V.SPP_FSSI_NAME_CD_LIST,
CCD_CRUISE_SUMM_V.SPP_FSSI_NAME_SCD_LIST,
CCD_CRUISE_SUMM_V.SPP_FSSI_NAME_RC_LIST,
CCD_CRUISE_SUMM_V.SPP_FSSI_NAME_BR_LIST,
CCD_CRUISE_SUMM_V.NUM_SPP_MMPA,
CCD_CRUISE_SUMM_V.SPP_MMPA_NAME_CD_LIST,
CCD_CRUISE_SUMM_V.SPP_MMPA_NAME_SCD_LIST,
CCD_CRUISE_SUMM_V.SPP_MMPA_NAME_RC_LIST,
CCD_CRUISE_SUMM_V.SPP_MMPA_NAME_BR_LIST,
CCD_CRUISE_SUMM_V.NUM_PRIM_SVY_CATS,
CCD_CRUISE_SUMM_V.PRIM_SVY_CAT_NAME_CD_LIST,
CCD_CRUISE_SUMM_V.PRIM_SVY_CAT_NAME_SCD_LIST,
CCD_CRUISE_SUMM_V.PRIM_SVY_CAT_NAME_RC_LIST,
CCD_CRUISE_SUMM_V.PRIM_SVY_CAT_NAME_BR_LIST,
CCD_CRUISE_SUMM_V.NUM_SEC_SVY_CATS,
CCD_CRUISE_SUMM_V.SEC_SVY_CAT_NAME_CD_LIST,
CCD_CRUISE_SUMM_V.SEC_SVY_CAT_NAME_SCD_LIST,
CCD_CRUISE_SUMM_V.SEC_SVY_CAT_NAME_RC_LIST,
CCD_CRUISE_SUMM_V.SEC_SVY_CAT_NAME_BR_LIST,
CCD_CRUISE_SUMM_V.NUM_EXP_SPP,
CCD_CRUISE_SUMM_V.EXP_SPP_NAME_CD_LIST,
CCD_CRUISE_SUMM_V.EXP_SPP_NAME_SCD_LIST,
CCD_CRUISE_SUMM_V.EXP_SPP_NAME_RC_LIST,
CCD_CRUISE_SUMM_V.EXP_SPP_NAME_BR_LIST,
CCD_CRUISE_SUMM_V.NUM_SPP_OTH,
CCD_CRUISE_SUMM_V.OTH_SPP_CNAME_CD_LIST,
CCD_CRUISE_SUMM_V.OTH_SPP_CNAME_SCD_LIST,
CCD_CRUISE_SUMM_V.OTH_SPP_CNAME_RC_LIST,
CCD_CRUISE_SUMM_V.OTH_SPP_CNAME_BR_LIST,
CCD_CRUISE_SUMM_V.OTH_SPP_SNAME_CD_LIST,
CCD_CRUISE_SUMM_V.OTH_SPP_SNAME_SCD_LIST,
CCD_CRUISE_SUMM_V.OTH_SPP_SNAME_RC_LIST,
CCD_CRUISE_SUMM_V.OTH_SPP_SNAME_BR_LIST,
CCD_CRUISE_SUMM_V.CRUISE_START_DATE,
CCD_CRUISE_SUMM_V.FORMAT_CRUISE_START_DATE,
CCD_CRUISE_SUMM_V.CRUISE_END_DATE,
CCD_CRUISE_SUMM_V.FORMAT_CRUISE_END_DATE,
CCD_CRUISE_SUMM_V.CRUISE_DAS,
CCD_CRUISE_SUMM_V.CRUISE_LEN_DAYS,
CCD_CRUISE_SUMM_V.CRUISE_YEAR,
CCD_CRUISE_SUMM_V.CRUISE_FISC_YEAR,
CCD_CRUISE_SUMM_V.NUM_LEGS,
CCD_CRUISE_SUMM_V.LEG_NAME_CD_LIST,
CCD_CRUISE_SUMM_V.LEG_NAME_SCD_LIST,
CCD_CRUISE_SUMM_V.LEG_NAME_RC_LIST,
CCD_CRUISE_SUMM_V.LEG_NAME_BR_LIST,
CCD_CRUISE_SUMM_V.LEG_NAME_DATES_CD_LIST,
CCD_CRUISE_SUMM_V.LEG_NAME_DATES_SCD_LIST,
CCD_CRUISE_SUMM_V.LEG_NAME_DATES_RC_LIST,
CCD_CRUISE_SUMM_V.LEG_NAME_DATES_BR_LIST,
CCD_CRUISE_SUMM_V.NUM_REGIONS,
CCD_CRUISE_SUMM_V.REGION_CODE_CD_LIST,
CCD_CRUISE_SUMM_V.REGION_CODE_SCD_LIST,
CCD_CRUISE_SUMM_V.REGION_CODE_RC_LIST,
CCD_CRUISE_SUMM_V.REGION_CODE_BR_LIST,
CCD_CRUISE_SUMM_V.REGION_NAME_CD_LIST,
CCD_CRUISE_SUMM_V.REGION_NAME_SCD_LIST,
CCD_CRUISE_SUMM_V.REGION_NAME_RC_LIST,
CCD_CRUISE_SUMM_V.REGION_NAME_BR_LIST,
CCD_CRUISE_SUMM_V.NUM_ECOSYSTEMS,
CCD_CRUISE_SUMM_V.ECOSYSTEM_CD_LIST,
CCD_CRUISE_SUMM_V.ECOSYSTEM_SCD_LIST,
CCD_CRUISE_SUMM_V.ECOSYSTEM_RC_LIST,
CCD_CRUISE_SUMM_V.ECOSYSTEM_BR_LIST,
CCD_CRUISE_SUMM_V.NUM_GEAR,
CCD_CRUISE_SUMM_V.GEAR_CD_LIST,
CCD_CRUISE_SUMM_V.GEAR_SCD_LIST,
CCD_CRUISE_SUMM_V.GEAR_RC_LIST,
CCD_CRUISE_SUMM_V.GEAR_BR_LIST,
DVM_PTA_ERRORS_V.CREATE_DATE,
DVM_PTA_ERRORS_V.FORMATTED_CREATE_DATE,
DVM_PTA_ERRORS_V.LAST_EVAL_DATE,
DVM_PTA_ERRORS_V.FORMATTED_LAST_EVAL_DATE,
DVM_PTA_ERRORS_V.ERROR_ID,
DVM_PTA_ERRORS_V.ERROR_DESCRIPTION,
DVM_PTA_ERRORS_V.ERROR_NOTES,
DVM_PTA_ERRORS_V.ERROR_TYPE_ID,
DVM_PTA_ERRORS_V.ERR_TYPE_NAME,
DVM_PTA_ERRORS_V.ERR_TYPE_COMMENT_TEMPLATE,
DVM_PTA_ERRORS_V.QC_OBJECT_ID,
DVM_PTA_ERRORS_V.OBJECT_NAME,
DVM_PTA_ERRORS_V.QC_OBJ_ACTIVE_YN,
DVM_PTA_ERRORS_V.QC_SORT_ORDER,
DVM_PTA_ERRORS_V.ERR_TYPE_DESC,
DVM_PTA_ERRORS_V.IND_FIELD_NAME,
DVM_PTA_ERRORS_V.APP_LINK_TEMPLATE,
DVM_PTA_ERRORS_V.APP_LINK_URL,
DVM_PTA_ERRORS_V.ERR_SEVERITY_ID,
DVM_PTA_ERRORS_V.ERR_SEVERITY_CODE,
DVM_PTA_ERRORS_V.ERR_SEVERITY_NAME,
DVM_PTA_ERRORS_V.ERR_SEVERITY_DESC,
DVM_PTA_ERRORS_V.DATA_STREAM_ID,
DVM_PTA_ERRORS_V.DATA_STREAM_CODE,
DVM_PTA_ERRORS_V.DATA_STREAM_NAME,
DVM_PTA_ERRORS_V.DATA_STREAM_DESC,
DVM_PTA_ERRORS_V.ERR_TYPE_ACTIVE_YN,
DVM_PTA_ERRORS_V.ERR_RES_TYPE_ID,
DVM_PTA_ERRORS_V.ERR_RES_TYPE_CODE,
DVM_PTA_ERRORS_V.ERR_RES_TYPE_NAME,
DVM_PTA_ERRORS_V.ERR_RES_TYPE_DESC
FROM CCD_CRUISE_SUMM_V
INNER JOIN
DVM_PTA_ERRORS_V
ON CCD_CRUISE_SUMM_V.PTA_ERROR_ID = DVM_PTA_ERRORS_V.PTA_ERROR_ID
order by CRUISE_START_DATE,
CRUISE_NAME,
ERR_TYPE_NAME;

COMMENT ON TABLE CCD_CRUISE_SUMM_ERR_V IS 'Cruise Summary and Associated Validation Errors (View)

This view returns the Cruise summary data and associated validation issues from the DVM that have one or more validation errors/warnings';

COMMENT ON COLUMN CCD_CRUISE_SUMM_ERR_V.CRUISE_ID IS 'Primary key for the CCD_CRUISES table';
COMMENT ON COLUMN CCD_CRUISE_SUMM_ERR_V.CRUISE_NAME IS 'The name of the given cruise designated by NOAA (e.g. SE-15-01)';
COMMENT ON COLUMN CCD_CRUISE_SUMM_ERR_V.CRUISE_NOTES IS 'Any notes for the given research cruise';
COMMENT ON COLUMN CCD_CRUISE_SUMM_ERR_V.CRUISE_DESC IS 'Description for the given research cruise';
COMMENT ON COLUMN CCD_CRUISE_SUMM_ERR_V.OBJ_BASED_METRICS IS 'Objective Based Metrics for the given research cruise';
COMMENT ON COLUMN CCD_CRUISE_SUMM_ERR_V.SCI_CENTER_DIV_ID IS 'Primary key for the Science Center Division table';
COMMENT ON COLUMN CCD_CRUISE_SUMM_ERR_V.SCI_CENTER_DIV_CODE IS 'Abbreviated code for the given Science Center Division';
COMMENT ON COLUMN CCD_CRUISE_SUMM_ERR_V.SCI_CENTER_DIV_NAME IS 'Name of the given Science Center Division';
COMMENT ON COLUMN CCD_CRUISE_SUMM_ERR_V.SCI_CENTER_DIV_DESC IS 'Description for the given Science Center Division';
COMMENT ON COLUMN CCD_CRUISE_SUMM_ERR_V.SCI_CENTER_ID IS 'Primary key for the Science Center table';
COMMENT ON COLUMN CCD_CRUISE_SUMM_ERR_V.SCI_CENTER_NAME IS 'Name of the given Science Center';
COMMENT ON COLUMN CCD_CRUISE_SUMM_ERR_V.SCI_CENTER_DESC IS 'Description for the given Science Center';
COMMENT ON COLUMN CCD_CRUISE_SUMM_ERR_V.STD_SVY_NAME_ID IS 'Primary key for the Standard Survey Name table';
COMMENT ON COLUMN CCD_CRUISE_SUMM_ERR_V.STD_SVY_NAME IS 'Name of the given Standard Survey Name';
COMMENT ON COLUMN CCD_CRUISE_SUMM_ERR_V.STD_SVY_DESC IS 'Description for the given Standard Survey Name';
COMMENT ON COLUMN CCD_CRUISE_SUMM_ERR_V.SVY_FREQ_ID IS 'Primary key for the Survey Frequency table';
COMMENT ON COLUMN CCD_CRUISE_SUMM_ERR_V.SVY_FREQ_NAME IS 'Name of the given Survey Frequency';
COMMENT ON COLUMN CCD_CRUISE_SUMM_ERR_V.SVY_FREQ_DESC IS 'Description for the given Survey Frequency';
COMMENT ON COLUMN CCD_CRUISE_SUMM_ERR_V.STD_SVY_NAME_OTH IS 'Field defines a Standard Survey Name that is not included in the Standard Survey Name table';
COMMENT ON COLUMN CCD_CRUISE_SUMM_ERR_V.STD_SVY_NAME_VAL IS 'This field contains the Standard Survey Name defined for the given cruise.  If the STD_SVY_NAME_ID field is defined then the associated CCD_STD_SVY_NAMES.STD_SVY_NAME is used because the foreign key is given precedence, otherwise the STD_SVY_NAME_OTH field value is used';
COMMENT ON COLUMN CCD_CRUISE_SUMM_ERR_V.SVY_TYPE_ID IS 'Primary key for the Survey Type table';
COMMENT ON COLUMN CCD_CRUISE_SUMM_ERR_V.SVY_TYPE_NAME IS 'Name of the given Survey Type';
COMMENT ON COLUMN CCD_CRUISE_SUMM_ERR_V.SVY_TYPE_DESC IS 'Description for the given Survey Type';
COMMENT ON COLUMN CCD_CRUISE_SUMM_ERR_V.CRUISE_URL IS 'The Cruise URL (Referred to as "Survey URL" in FINSS System) for the given Cruise';
COMMENT ON COLUMN CCD_CRUISE_SUMM_ERR_V.CRUISE_CONT_EMAIL IS 'The Cruise Contact Email (Referred to as "Survey Contact Email" in FINSS System) for the given Cruise';
COMMENT ON COLUMN CCD_CRUISE_SUMM_ERR_V.PTA_ERROR_ID IS 'Foreign key reference to the Errors (PTA) intersection table';
COMMENT ON COLUMN CCD_CRUISE_SUMM_ERR_V.NUM_SPP_ESA IS 'The number of associated ESA Species';
COMMENT ON COLUMN CCD_CRUISE_SUMM_ERR_V.SPP_ESA_NAME_CD_LIST IS 'Comma-delimited list of ESA Species associated with the given cruise';
COMMENT ON COLUMN CCD_CRUISE_SUMM_ERR_V.SPP_ESA_NAME_SCD_LIST IS 'Semicolon-delimited list of ESA Species associated with the given cruise';
COMMENT ON COLUMN CCD_CRUISE_SUMM_ERR_V.SPP_ESA_NAME_RC_LIST IS 'Return carriage/new line delimited list of ESA Species associated with the given cruise';
COMMENT ON COLUMN CCD_CRUISE_SUMM_ERR_V.SPP_ESA_NAME_BR_LIST IS '<BR> tag (intended for web pages) delimited list of ESA Species associated with the given cruise';
COMMENT ON COLUMN CCD_CRUISE_SUMM_ERR_V.NUM_SPP_FSSI IS 'The number of associated FSSI Species';
COMMENT ON COLUMN CCD_CRUISE_SUMM_ERR_V.SPP_FSSI_NAME_CD_LIST IS 'Comma-delimited list of FSSI Species associated with the given cruise';
COMMENT ON COLUMN CCD_CRUISE_SUMM_ERR_V.SPP_FSSI_NAME_SCD_LIST IS 'Semicolon-delimited list of FSSI Species associated with the given cruise';
COMMENT ON COLUMN CCD_CRUISE_SUMM_ERR_V.SPP_FSSI_NAME_RC_LIST IS 'Return carriage/new line delimited list of FSSI Species associated with the given cruise';
COMMENT ON COLUMN CCD_CRUISE_SUMM_ERR_V.SPP_FSSI_NAME_BR_LIST IS '<BR> tag (intended for web pages) delimited list of FSSI Species associated with the given cruise';
COMMENT ON COLUMN CCD_CRUISE_SUMM_ERR_V.NUM_SPP_MMPA IS 'The number of associated MMPA Species';
COMMENT ON COLUMN CCD_CRUISE_SUMM_ERR_V.SPP_MMPA_NAME_CD_LIST IS 'Comma-delimited list of MMPA Species associated with the given cruise';
COMMENT ON COLUMN CCD_CRUISE_SUMM_ERR_V.SPP_MMPA_NAME_SCD_LIST IS 'Semicolon-delimited list of MMPA Species associated with the given cruise';
COMMENT ON COLUMN CCD_CRUISE_SUMM_ERR_V.SPP_MMPA_NAME_RC_LIST IS 'Return carriage/new line delimited list of MMPA Species associated with the given cruise';
COMMENT ON COLUMN CCD_CRUISE_SUMM_ERR_V.SPP_MMPA_NAME_BR_LIST IS '<BR> tag (intended for web pages) delimited list of MMPA Species associated with the given cruise';
COMMENT ON COLUMN CCD_CRUISE_SUMM_ERR_V.NUM_PRIM_SVY_CATS IS 'The number of associated primary survey categories';
COMMENT ON COLUMN CCD_CRUISE_SUMM_ERR_V.PRIM_SVY_CAT_NAME_CD_LIST IS 'Comma-delimited list of primary survey categories associated with the given cruise';
COMMENT ON COLUMN CCD_CRUISE_SUMM_ERR_V.PRIM_SVY_CAT_NAME_SCD_LIST IS 'Semicolon-delimited list of primary survey categories associated with the given cruise';
COMMENT ON COLUMN CCD_CRUISE_SUMM_ERR_V.PRIM_SVY_CAT_NAME_RC_LIST IS 'Return carriage/new line delimited list of primary survey categories associated with the given cruise';
COMMENT ON COLUMN CCD_CRUISE_SUMM_ERR_V.PRIM_SVY_CAT_NAME_BR_LIST IS '<BR> tag (intended for web pages) delimited list of primary survey categories associated with the given cruise';
COMMENT ON COLUMN CCD_CRUISE_SUMM_ERR_V.NUM_SEC_SVY_CATS IS 'The number of associated secondary survey categories';
COMMENT ON COLUMN CCD_CRUISE_SUMM_ERR_V.SEC_SVY_CAT_NAME_CD_LIST IS 'Comma-delimited list of secondary survey categories associated with the given cruise';
COMMENT ON COLUMN CCD_CRUISE_SUMM_ERR_V.SEC_SVY_CAT_NAME_SCD_LIST IS 'Semicolon-delimited list of secondary survey categories associated with the given cruise';
COMMENT ON COLUMN CCD_CRUISE_SUMM_ERR_V.SEC_SVY_CAT_NAME_RC_LIST IS 'Return carriage/new line delimited list of secondary survey categories associated with the given cruise';
COMMENT ON COLUMN CCD_CRUISE_SUMM_ERR_V.SEC_SVY_CAT_NAME_BR_LIST IS '<BR> tag (intended for web pages) delimited list of secondary survey categories associated with the given cruise';
COMMENT ON COLUMN CCD_CRUISE_SUMM_ERR_V.NUM_EXP_SPP IS 'The number of associated expected species categories';
COMMENT ON COLUMN CCD_CRUISE_SUMM_ERR_V.EXP_SPP_NAME_CD_LIST IS 'Comma-delimited list of expected species categories associated with the given cruise';
COMMENT ON COLUMN CCD_CRUISE_SUMM_ERR_V.EXP_SPP_NAME_SCD_LIST IS 'Semicolon-delimited list of expected species categories associated with the given cruise';
COMMENT ON COLUMN CCD_CRUISE_SUMM_ERR_V.EXP_SPP_NAME_RC_LIST IS 'Return carriage/new line delimited list of expected species categories associated with the given cruise';
COMMENT ON COLUMN CCD_CRUISE_SUMM_ERR_V.EXP_SPP_NAME_BR_LIST IS '<BR> tag (intended for web pages) delimited list of expected species categories associated with the given cruise';
COMMENT ON COLUMN CCD_CRUISE_SUMM_ERR_V.NUM_SPP_OTH IS 'The number of associated target species - other';
COMMENT ON COLUMN CCD_CRUISE_SUMM_ERR_V.OTH_SPP_CNAME_CD_LIST IS 'Comma-delimited list of common names for target species - other associated with the given cruise';
COMMENT ON COLUMN CCD_CRUISE_SUMM_ERR_V.OTH_SPP_CNAME_SCD_LIST IS 'Semicolon-delimited list of common names for target species - other associated with the given cruise';
COMMENT ON COLUMN CCD_CRUISE_SUMM_ERR_V.OTH_SPP_CNAME_RC_LIST IS 'Return carriage/new line delimited list of common names for target species - other associated with the given cruise';
COMMENT ON COLUMN CCD_CRUISE_SUMM_ERR_V.OTH_SPP_CNAME_BR_LIST IS '<BR> tag (intended for web pages) delimited list of common names for target species - other associated with the given cruise';
COMMENT ON COLUMN CCD_CRUISE_SUMM_ERR_V.OTH_SPP_SNAME_CD_LIST IS 'Comma-delimited list of scientific names for target species - other associated with the given cruise';
COMMENT ON COLUMN CCD_CRUISE_SUMM_ERR_V.OTH_SPP_SNAME_SCD_LIST IS 'Semicolon-delimited list of scientific names for target species - other associated with the given cruise';
COMMENT ON COLUMN CCD_CRUISE_SUMM_ERR_V.OTH_SPP_SNAME_RC_LIST IS 'Return carriage/new line delimited list of scientific names for target species - other associated with the given cruise';
COMMENT ON COLUMN CCD_CRUISE_SUMM_ERR_V.OTH_SPP_SNAME_BR_LIST IS '<BR> tag (intended for web pages) delimited list of scientific names for target species - other associated with the given cruise';
COMMENT ON COLUMN CCD_CRUISE_SUMM_ERR_V.CRUISE_START_DATE IS 'The start date for the given cruise (based on the earliest associated cruise leg''s start date)';
COMMENT ON COLUMN CCD_CRUISE_SUMM_ERR_V.FORMAT_CRUISE_START_DATE IS 'The formatted start date for the given cruise (based on the earliest associated cruise leg''s start date) in MM/DD/YYYY HH24:MI:SS format';
COMMENT ON COLUMN CCD_CRUISE_SUMM_ERR_V.CRUISE_END_DATE IS 'The end date for the given cruise (based on the latest associated cruise leg''s end date)';
COMMENT ON COLUMN CCD_CRUISE_SUMM_ERR_V.FORMAT_CRUISE_END_DATE IS 'The formatted end date for the given cruise (based on the latest associated cruise leg''s end date) in MM/DD/YYYY HH24:MI:SS format';
COMMENT ON COLUMN CCD_CRUISE_SUMM_ERR_V.CRUISE_DAS IS 'The total number of days at sea for each of the legs associated with the given cruise';
COMMENT ON COLUMN CCD_CRUISE_SUMM_ERR_V.CRUISE_LEN_DAYS IS 'The total number of days between the Cruise Start and End Dates for the given cruise';
COMMENT ON COLUMN CCD_CRUISE_SUMM_ERR_V.CRUISE_YEAR IS 'The calendar year for the given cruise (based on the earliest associated cruise leg''s start date)';
COMMENT ON COLUMN CCD_CRUISE_SUMM_ERR_V.CRUISE_FISC_YEAR IS 'The calendar year for the given cruise (based on the earliest associated cruise leg''s start date)';
COMMENT ON COLUMN CCD_CRUISE_SUMM_ERR_V.NUM_LEGS IS 'The number of cruise legs associated with the given cruise';
COMMENT ON COLUMN CCD_CRUISE_SUMM_ERR_V.LEG_NAME_CD_LIST IS 'Comma-delimited list of leg names associated with the given cruise';
COMMENT ON COLUMN CCD_CRUISE_SUMM_ERR_V.LEG_NAME_SCD_LIST IS 'Semicolon-delimited list of leg names associated with the given cruise';
COMMENT ON COLUMN CCD_CRUISE_SUMM_ERR_V.LEG_NAME_RC_LIST IS 'Return carriage/new line delimited list of leg names associated with the given cruise';
COMMENT ON COLUMN CCD_CRUISE_SUMM_ERR_V.LEG_NAME_BR_LIST IS '<BR> tag (intended for web pages) delimited list of leg names associated with the given cruise';
COMMENT ON COLUMN CCD_CRUISE_SUMM_ERR_V.LEG_NAME_DATES_CD_LIST IS 'Comma-delimited list of leg names, the associated leg dates and vessel name associated with the given cruise';
COMMENT ON COLUMN CCD_CRUISE_SUMM_ERR_V.LEG_NAME_DATES_SCD_LIST IS 'Semicolon-delimited list of leg names, the associated leg dates and vessel name associated with the given cruise';
COMMENT ON COLUMN CCD_CRUISE_SUMM_ERR_V.LEG_NAME_DATES_RC_LIST IS 'Return carriage/new line delimited list of leg names, the associated leg dates and vessel name associated with the given cruise';
COMMENT ON COLUMN CCD_CRUISE_SUMM_ERR_V.LEG_NAME_DATES_BR_LIST IS '<BR> tag (intended for web pages) delimited list of leg names, the associated leg dates and vessel name associated with the given cruise';
COMMENT ON COLUMN CCD_CRUISE_SUMM_ERR_V.NUM_REGIONS IS 'The number of unique regions associated with the associated cruise legs';
COMMENT ON COLUMN CCD_CRUISE_SUMM_ERR_V.REGION_CODE_CD_LIST IS 'Comma-delimited list of unique region codes associated with the given cruise leg';
COMMENT ON COLUMN CCD_CRUISE_SUMM_ERR_V.REGION_CODE_SCD_LIST IS 'Semicolon-delimited list of unique region codes associated with the given cruise leg';
COMMENT ON COLUMN CCD_CRUISE_SUMM_ERR_V.REGION_CODE_RC_LIST IS 'Return carriage/new line delimited list of unique region codes associated with the given cruise leg';
COMMENT ON COLUMN CCD_CRUISE_SUMM_ERR_V.REGION_CODE_BR_LIST IS '<BR> tag (intended for web pages) delimited list of unique region codes associated with the given cruise leg';
COMMENT ON COLUMN CCD_CRUISE_SUMM_ERR_V.REGION_NAME_CD_LIST IS 'Comma-delimited list of unique region names associated with the given cruise leg';
COMMENT ON COLUMN CCD_CRUISE_SUMM_ERR_V.REGION_NAME_SCD_LIST IS 'Semicolon-delimited list of unique region names associated with the given cruise leg';
COMMENT ON COLUMN CCD_CRUISE_SUMM_ERR_V.REGION_NAME_RC_LIST IS 'Return carriage/new line delimited list of unique region names associated with the given cruise leg';
COMMENT ON COLUMN CCD_CRUISE_SUMM_ERR_V.REGION_NAME_BR_LIST IS '<BR> tag (intended for web pages) delimited list of unique region names associated with the given cruise leg';
COMMENT ON COLUMN CCD_CRUISE_SUMM_ERR_V.NUM_ECOSYSTEMS IS 'The number of unique regional ecosystems associated with the associated cruise legs';
COMMENT ON COLUMN CCD_CRUISE_SUMM_ERR_V.ECOSYSTEM_CD_LIST IS 'Comma-delimited list of unique regional ecosystems associated with the given cruise leg';
COMMENT ON COLUMN CCD_CRUISE_SUMM_ERR_V.ECOSYSTEM_SCD_LIST IS 'Semicolon-delimited list of unique regional ecosystems associated with the given cruise leg';
COMMENT ON COLUMN CCD_CRUISE_SUMM_ERR_V.ECOSYSTEM_RC_LIST IS 'Return carriage/new line delimited list of unique regional ecosystems associated with the given cruise leg';
COMMENT ON COLUMN CCD_CRUISE_SUMM_ERR_V.ECOSYSTEM_BR_LIST IS '<BR> tag (intended for web pages) delimited list of unique regional ecosystems associated with the given cruise leg';
COMMENT ON COLUMN CCD_CRUISE_SUMM_ERR_V.NUM_GEAR IS 'The number of unique gear associated with the associated cruise legs';
COMMENT ON COLUMN CCD_CRUISE_SUMM_ERR_V.GEAR_CD_LIST IS 'Comma-delimited list of unique gear associated with the associated cruise legs';
COMMENT ON COLUMN CCD_CRUISE_SUMM_ERR_V.GEAR_SCD_LIST IS 'Semicolon-delimited list of unique gear associated with the associated cruise legs';
COMMENT ON COLUMN CCD_CRUISE_SUMM_ERR_V.GEAR_RC_LIST IS 'Return carriage/new line delimited list of unique gear associated with the associated cruise legs';
COMMENT ON COLUMN CCD_CRUISE_SUMM_ERR_V.GEAR_BR_LIST IS '<BR> tag (intended for web pages) delimited list of unique gear associated with the associated cruise legs';
COMMENT ON COLUMN CCD_CRUISE_SUMM_ERR_V.CREATE_DATE IS 'The date on which the DVM was first executed on this Cruise in the database';
COMMENT ON COLUMN CCD_CRUISE_SUMM_ERR_V.FORMATTED_CREATE_DATE IS 'The formatted date/time on which this record was created in the database (MM/DD/YYYY HH24:MI)';
COMMENT ON COLUMN CCD_CRUISE_SUMM_ERR_V.LAST_EVAL_DATE IS 'The date on which the DVM was last evaluated based on its associated validation criteria that was active at when the given associated data stream parent record was first evaluated';
COMMENT ON COLUMN CCD_CRUISE_SUMM_ERR_V.FORMATTED_LAST_EVAL_DATE IS 'The formatted date/time on which this record was last evaluated based on its associated validation criteria that was active at when the given associated data stream parent record was first evaluated (MM/DD/YYYY HH24:MI)';
COMMENT ON COLUMN CCD_CRUISE_SUMM_ERR_V.ERROR_ID IS 'Primary Key for the SPT_ERRORS table';
COMMENT ON COLUMN CCD_CRUISE_SUMM_ERR_V.ERROR_DESCRIPTION IS 'The description of the given XML Data File error';
COMMENT ON COLUMN CCD_CRUISE_SUMM_ERR_V.ERROR_NOTES IS 'Manually entered notes for the corresponding data error';
COMMENT ON COLUMN CCD_CRUISE_SUMM_ERR_V.ERROR_TYPE_ID IS 'The Error Type for the given error';
COMMENT ON COLUMN CCD_CRUISE_SUMM_ERR_V.ERR_TYPE_NAME IS 'The name of the given QC validation criteria';
COMMENT ON COLUMN CCD_CRUISE_SUMM_ERR_V.ERR_TYPE_COMMENT_TEMPLATE IS 'The template for the specific error description that exists in the specific error condition.  This field should contain placeholders in the form: [PLACEHOLDER] where PLACEHOLDER is the corresponding field name in the result set that will have its placeholder replaced by the corresponding result set field value.  This is NULL only when XML_QC_OBJ_ID is NULL';
COMMENT ON COLUMN CCD_CRUISE_SUMM_ERR_V.QC_OBJECT_ID IS 'The Data QC Object that the error type is determined from.  If this is NULL it is not associated with a QC query validation constraint (e.g. DB error)';
COMMENT ON COLUMN CCD_CRUISE_SUMM_ERR_V.OBJECT_NAME IS 'The name of the object that is used in the given QC validation criteria';
COMMENT ON COLUMN CCD_CRUISE_SUMM_ERR_V.QC_OBJ_ACTIVE_YN IS 'Flag to indicate if the QC object is active (Y) or inactive (N)';
COMMENT ON COLUMN CCD_CRUISE_SUMM_ERR_V.QC_SORT_ORDER IS 'Relative sort order for the QC object to be executed in';
COMMENT ON COLUMN CCD_CRUISE_SUMM_ERR_V.ERR_TYPE_DESC IS 'The description for the given QC validation error type';
COMMENT ON COLUMN CCD_CRUISE_SUMM_ERR_V.IND_FIELD_NAME IS 'The field in the result set that indicates if the current error type has been identified.  A ''Y'' value indicates that the given error condition has been identified.  When XML_QC_OBJ_ID is NULL this is the constant name that is used to refer to the current error type';


COMMENT ON COLUMN DVM_PTA_ERRORS_V.APP_LINK_TEMPLATE IS 'The template for the specific application link to resolve the given data issue.  This is intended to provide the necessary parameters in a given URL that can be used to generate the full URL based on the server (e.g. generate the parameters for a given cruise leg and the APEX application will use the [APP_ID] and [APP_SESSION] placeholders at runtime to generate the full URL - f?p=[APP_ID]:220:[APP_SESSION]::NO::CRUISE_ID,CRUISE_ID_COPY:[CRUISE_ID],)';
COMMENT ON COLUMN DVM_PTA_ERRORS_V.APP_LINK_URL IS 'The generated specific application link URL to resolve the given data issue.  This is generated at runtime of the DVM based on the values returned by the corresponding QC query and by the related DVM_ERROR_TYPES record''s APP_LINK_TEMPLATE value';





COMMENT ON COLUMN CCD_CRUISE_SUMM_ERR_V.ERR_SEVERITY_ID IS 'The Severity of the given error type criteria.  These indicate the status of the given error (e.g. warnings, data errors, violations of law, etc.)';
COMMENT ON COLUMN CCD_CRUISE_SUMM_ERR_V.ERR_SEVERITY_CODE IS 'The code for the given error severity';
COMMENT ON COLUMN CCD_CRUISE_SUMM_ERR_V.ERR_SEVERITY_NAME IS 'The name for the given error severity';
COMMENT ON COLUMN CCD_CRUISE_SUMM_ERR_V.ERR_SEVERITY_DESC IS 'The description for the given error severity';
COMMENT ON COLUMN CCD_CRUISE_SUMM_ERR_V.DATA_STREAM_ID IS 'Primary Key for the SPT_DATA_STREAMS table';
COMMENT ON COLUMN CCD_CRUISE_SUMM_ERR_V.DATA_STREAM_CODE IS 'The code for the given data stream';
COMMENT ON COLUMN CCD_CRUISE_SUMM_ERR_V.DATA_STREAM_NAME IS 'The name for the given data stream';
COMMENT ON COLUMN CCD_CRUISE_SUMM_ERR_V.DATA_STREAM_DESC IS 'The description for the given data stream';
COMMENT ON COLUMN CCD_CRUISE_SUMM_ERR_V.ERR_TYPE_ACTIVE_YN IS 'Flag to indicate if the given error type criteria is active';
COMMENT ON COLUMN CCD_CRUISE_SUMM_ERR_V.ERR_RES_TYPE_ID IS 'Primary Key for the SPT_ERR_RES_TYPES table';
COMMENT ON COLUMN CCD_CRUISE_SUMM_ERR_V.ERR_RES_TYPE_CODE IS 'The Error Resolution Type code';
COMMENT ON COLUMN CCD_CRUISE_SUMM_ERR_V.ERR_RES_TYPE_NAME IS 'The Error Resolution Type name';
COMMENT ON COLUMN CCD_CRUISE_SUMM_ERR_V.ERR_RES_TYPE_DESC IS 'The Error Resolution Type description';



--define the upgrade version in the database upgrade log table:
INSERT INTO DB_UPGRADE_LOGS (UPGRADE_APP_NAME, UPGRADE_VERSION, UPGRADE_DATE, UPGRADE_DESC) VALUES ('Centralized Cruise Database', '0.15', TO_DATE('14-MAY-20', 'DD-MON-YY'), 'Renamed the CCD_CRUISE_SUMM_ERR_V to CCD_CRUISE_ERR_SUMM_V from version 0.14 so it can be implemented in the APEX application.  Restored CCD_CRUISE_SUMM_ERR_V from version 0.11 and added the new APP_LINK_TEMPLATE and APP_LINK_URL fields since it is used to verify the DVM_PKG test cases.  Installed Version 0.4 of the Data Validation Module Database (Git URL: git@gitlab.pifsc.gov:centralized-data-tools/data-validation-module.git)');

--commit the DB_UPGRADE_LOGS record insertion
COMMIT;
