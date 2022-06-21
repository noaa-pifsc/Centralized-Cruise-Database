--------------------------------------------------------
--------------------------------------------------------
--Database Name: Centralized Cruise Database
--Database Description: Centralized Cruise Database to track information about each PIFSC research cruise including activities, chief scientists, regions, etc. to remove the need for each division/program to manage this information
--------------------------------------------------------
--------------------------------------------------------

--------------------------------------------------------
--Centralized Cruise Database - version 0.25 updates:
--------------------------------------------------------

--Installed Version 1.2 (Git tag: DVM_db_v1.2) of the Data Validation Module Database (Git URL: git@gitlab.pifsc.gov:centralized-data-tools/data-validation-module.git)
@@"./upgrades/external_modules/DVM_DDL_DML_upgrade_v1.2.sql";



CREATE OR REPLACE View
CCD_QC_LEG_OVERLAP_V
AS
select
V1.CRUISE_ID CRUISE_ID,
V1.CRUISE_NAME CRUISE_NAME1,
V1.CRUISE_LEG_ID CRUISE_LEG_ID1,
V1.LEG_NAME LEG_NAME1,
V1.VESSEL_NAME VESSEL_NAME1,
V1.FORMAT_LEG_START_DATE FORMAT_LEG_START_DATE1,
V1.FORMAT_LEG_END_DATE FORMAT_LEG_END_DATE1,
V2.CRUISE_ID CRUISE_ID2,
V2.CRUISE_NAME CRUISE_NAME2,
V2.CRUISE_LEG_ID CRUISE_LEG_ID2,
V2.LEG_NAME LEG_NAME2,
V2.VESSEL_NAME VESSEL_NAME2,
V2.FORMAT_LEG_START_DATE FORMAT_LEG_START_DATE2,
V2.FORMAT_LEG_END_DATE FORMAT_LEG_END_DATE2,
CASE WHEN V1.CRUISE_ID = V2.CRUISE_ID THEN 'Y' ELSE 'N' END CRUISE_OVERLAP_YN,
CASE WHEN V1.VESSEL_ID = V2.VESSEL_ID THEN 'Y' ELSE 'N' END VESSEL_OVERLAP_YN

FROM
CCD_CRUISE_LEGS_V V1 INNER JOIN
CCD_CRUISE_LEGS_V V2
ON
--join on the same vessel or same cruise:
(V1.VESSEL_ID = V2.VESSEL_ID OR V1.CRUISE_ID = V2.CRUISE_ID)
--don't allow joins on cruise legs to itself
AND V1.CRUISE_LEG_ID <> V2.CRUISE_LEG_ID
WHERE
V1.LEG_START_DATE BETWEEN  V2.LEG_START_DATE AND V2.LEG_END_DATE
OR
V1.LEG_END_DATE BETWEEN  V2.LEG_START_DATE AND V2.LEG_END_DATE
OR
V2.LEG_START_DATE BETWEEN  V1.LEG_START_DATE AND V1.LEG_END_DATE
OR
V2.LEG_END_DATE BETWEEN  V1.LEG_START_DATE AND V1.LEG_END_DATE


ORDER BY V1.CRUISE_NAME, V1.LEG_NAME, V1.LEG_START_DATE, V1.CRUISE_ID, V1.CRUISE_LEG_ID;

COMMENT ON TABLE CCD_QC_LEG_OVERLAP_V IS 'Cruise Leg Overlap (QC View)

This query identifies data validation issues based on the cruise leg dates (e.g. cruise legs overlap, vessel legs overlap).  This QC View is implemented in the Data Validation Module';

COMMENT ON COLUMN CCD_QC_LEG_OVERLAP_V.CRUISE_ID IS 'Primary key for the first CCD_CRUISES record';
COMMENT ON COLUMN CCD_QC_LEG_OVERLAP_V.CRUISE_NAME1 IS 'The name of the first cruise designated by NOAA (e.g. SE-15-01)';
COMMENT ON COLUMN CCD_QC_LEG_OVERLAP_V.CRUISE_LEG_ID1 IS 'Primary key for the first CCD_CRUISE_LEGS record';
COMMENT ON COLUMN CCD_QC_LEG_OVERLAP_V.LEG_NAME1 IS 'The name of the first cruise leg';
COMMENT ON COLUMN CCD_QC_LEG_OVERLAP_V.VESSEL_NAME1 IS 'Name of the given research vessel for the first cruise leg';
COMMENT ON COLUMN CCD_QC_LEG_OVERLAP_V.FORMAT_LEG_START_DATE1 IS 'The start date for the first research cruise leg in MM/DD/YYYY format';
COMMENT ON COLUMN CCD_QC_LEG_OVERLAP_V.FORMAT_LEG_END_DATE1 IS 'The end date for the first research cruise leg in MM/DD/YYYY format';
COMMENT ON COLUMN CCD_QC_LEG_OVERLAP_V.CRUISE_ID2 IS 'Primary key for the second CCD_CRUISES record';
COMMENT ON COLUMN CCD_QC_LEG_OVERLAP_V.CRUISE_NAME2 IS 'The name of the second cruise designated by NOAA (e.g. SE-15-01)';
COMMENT ON COLUMN CCD_QC_LEG_OVERLAP_V.CRUISE_LEG_ID2 IS 'Primary key for the second CCD_CRUISE_LEGS record';
COMMENT ON COLUMN CCD_QC_LEG_OVERLAP_V.LEG_NAME2 IS 'The name of the second cruise leg';
COMMENT ON COLUMN CCD_QC_LEG_OVERLAP_V.VESSEL_NAME2 IS 'Name of the given research vessel for the second cruise leg';
COMMENT ON COLUMN CCD_QC_LEG_OVERLAP_V.FORMAT_LEG_START_DATE2 IS 'The start date for the second research cruise leg in MM/DD/YYYY format';
COMMENT ON COLUMN CCD_QC_LEG_OVERLAP_V.FORMAT_LEG_END_DATE2 IS 'The end date for the second research cruise leg in MM/DD/YYYY format';
COMMENT ON COLUMN CCD_QC_LEG_OVERLAP_V.CRUISE_OVERLAP_YN IS 'Field to indicate if there is an Vessel Leg Overlap error (Y) or not (N) based on whether or not two cruise leg dates for the same cruise overlap with each other';
COMMENT ON COLUMN CCD_QC_LEG_OVERLAP_V.VESSEL_OVERLAP_YN IS 'Field to indicate if there is an Vessel Leg Overlap error (Y) or not (N) based on whether or not two cruise leg dates for the same vessel overlap with each other';



create or replace view
CCD_CRUISE_ISS_SUMM_V

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
CCD_CRUISE_SUMM_V.PTA_ISS_ID,
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
NVL(NUM_ACTIVE_WARNINGS, 0) NUM_ACTIVE_WARNINGS,
NVL(NUM_ANNOT_WARNINGS, 0) NUM_ANNOT_WARNINGS,
NVL(NUM_ACTIVE_ERRORS, 0) NUM_ACTIVE_ERRORS,
NVL(NUM_ANNOT_ERRORS, 0) NUM_ANNOT_ERRORS,
(CASE WHEN NUM_ACTIVE_ERRORS IS NULL OR NUM_ACTIVE_ERRORS = 0 THEN 'Y' ELSE 'N' END) CRUISE_VALID_YN

FROM CCD_CRUISE_SUMM_V
LEFT JOIN
(
    SELECT PTA_ISS_ID,
    SUM(CASE WHEN ISS_SEVERITY_CODE = 'WARN' AND ISS_RES_TYPE_ID IS NULL THEN 1 ELSE 0 END) NUM_ACTIVE_WARNINGS,
    SUM(CASE WHEN ISS_SEVERITY_CODE = 'WARN' AND ISS_RES_TYPE_ID IS NOT NULL THEN 1 ELSE 0 END) NUM_ANNOT_WARNINGS,
    SUM(CASE WHEN ISS_SEVERITY_CODE = 'ERROR' AND ISS_RES_TYPE_ID IS NULL THEN 1 ELSE 0 END) NUM_ACTIVE_ERRORS,
    SUM(CASE WHEN ISS_SEVERITY_CODE = 'ERROR' AND ISS_RES_TYPE_ID IS NOT NULL THEN 1 ELSE 0 END) NUM_ANNOT_ERRORS
    FROM DVM_PTA_ISSUES_V
    group by PTA_ISS_ID
) DVM_ISS_INFO
ON DVM_ISS_INFO.PTA_ISS_ID = CCD_CRUISE_SUMM_V.PTA_ISS_ID
order by cruise_start_date, cruise_name;


COMMENT ON COLUMN CCD_CRUISE_ISS_SUMM_V.CRUISE_ID IS 'Primary key for the CCD_CRUISES table';
COMMENT ON COLUMN CCD_CRUISE_ISS_SUMM_V.CRUISE_NAME IS 'The name of the given cruise designated by NOAA (e.g. SE-15-01)';
COMMENT ON COLUMN CCD_CRUISE_ISS_SUMM_V.CRUISE_NOTES IS 'Any notes for the given research cruise';
COMMENT ON COLUMN CCD_CRUISE_ISS_SUMM_V.CRUISE_DESC IS 'Description for the given research cruise';
COMMENT ON COLUMN CCD_CRUISE_ISS_SUMM_V.OBJ_BASED_METRICS IS 'Objective Based Metrics for the given research cruise';
COMMENT ON COLUMN CCD_CRUISE_ISS_SUMM_V.SCI_CENTER_DIV_ID IS 'Primary key for the Science Center Division table';
COMMENT ON COLUMN CCD_CRUISE_ISS_SUMM_V.SCI_CENTER_DIV_CODE IS 'Abbreviated code for the given Science Center Division';
COMMENT ON COLUMN CCD_CRUISE_ISS_SUMM_V.SCI_CENTER_DIV_NAME IS 'Name of the given Science Center Division';
COMMENT ON COLUMN CCD_CRUISE_ISS_SUMM_V.SCI_CENTER_DIV_DESC IS 'Description for the given Science Center Division';
COMMENT ON COLUMN CCD_CRUISE_ISS_SUMM_V.SCI_CENTER_ID IS 'Primary key for the Science Center table';
COMMENT ON COLUMN CCD_CRUISE_ISS_SUMM_V.SCI_CENTER_NAME IS 'Name of the given Science Center';
COMMENT ON COLUMN CCD_CRUISE_ISS_SUMM_V.SCI_CENTER_DESC IS 'Description for the given Science Center';
COMMENT ON COLUMN CCD_CRUISE_ISS_SUMM_V.STD_SVY_NAME_ID IS 'Primary key for the Standard Survey Name table';
COMMENT ON COLUMN CCD_CRUISE_ISS_SUMM_V.STD_SVY_NAME IS 'Name of the given Standard Survey Name';
COMMENT ON COLUMN CCD_CRUISE_ISS_SUMM_V.STD_SVY_DESC IS 'Description for the given Standard Survey Name';
COMMENT ON COLUMN CCD_CRUISE_ISS_SUMM_V.SVY_FREQ_ID IS 'Primary key for the Survey Frequency table';
COMMENT ON COLUMN CCD_CRUISE_ISS_SUMM_V.SVY_FREQ_NAME IS 'Name of the given Survey Frequency';
COMMENT ON COLUMN CCD_CRUISE_ISS_SUMM_V.SVY_FREQ_DESC IS 'Description for the given Survey Frequency';
COMMENT ON COLUMN CCD_CRUISE_ISS_SUMM_V.STD_SVY_NAME_OTH IS 'Field defines a Standard Survey Name that is not included in the Standard Survey Name table';
COMMENT ON COLUMN CCD_CRUISE_ISS_SUMM_V.STD_SVY_NAME_VAL IS 'This field contains the Standard Survey Name defined for the given cruise.  If the STD_SVY_NAME_ID field is defined then the associated CCD_STD_SVY_NAMES.STD_SVY_NAME is used because the foreign key is given precedence, otherwise the STD_SVY_NAME_OTH field value is used';
COMMENT ON COLUMN CCD_CRUISE_ISS_SUMM_V.SVY_TYPE_ID IS 'Primary key for the Survey Type table';
COMMENT ON COLUMN CCD_CRUISE_ISS_SUMM_V.SVY_TYPE_NAME IS 'Name of the given Survey Type';
COMMENT ON COLUMN CCD_CRUISE_ISS_SUMM_V.SVY_TYPE_DESC IS 'Description for the given Survey Type';
COMMENT ON COLUMN CCD_CRUISE_ISS_SUMM_V.CRUISE_URL IS 'The Cruise URL (Referred to as "Survey URL" in FINSS System) for the given Cruise';
COMMENT ON COLUMN CCD_CRUISE_ISS_SUMM_V.CRUISE_CONT_EMAIL IS 'The Cruise Contact Email (Referred to as "Survey Contact Email" in FINSS System) for the given Cruise';
COMMENT ON COLUMN CCD_CRUISE_ISS_SUMM_V.PTA_ISS_ID IS 'Foreign key reference to the Issues (PTA) intersection table';
COMMENT ON COLUMN CCD_CRUISE_ISS_SUMM_V.NUM_SPP_ESA IS 'The number of associated ESA Species';
COMMENT ON COLUMN CCD_CRUISE_ISS_SUMM_V.SPP_ESA_NAME_CD_LIST IS 'Comma-delimited list of ESA Species associated with the given cruise';
COMMENT ON COLUMN CCD_CRUISE_ISS_SUMM_V.SPP_ESA_NAME_SCD_LIST IS 'Semicolon-delimited list of ESA Species associated with the given cruise';
COMMENT ON COLUMN CCD_CRUISE_ISS_SUMM_V.SPP_ESA_NAME_RC_LIST IS 'Return carriage/new line delimited list of ESA Species associated with the given cruise';
COMMENT ON COLUMN CCD_CRUISE_ISS_SUMM_V.SPP_ESA_NAME_BR_LIST IS '<BR> tag (intended for web pages) delimited list of ESA Species associated with the given cruise';
COMMENT ON COLUMN CCD_CRUISE_ISS_SUMM_V.NUM_SPP_FSSI IS 'The number of associated FSSI Species';
COMMENT ON COLUMN CCD_CRUISE_ISS_SUMM_V.SPP_FSSI_NAME_CD_LIST IS 'Comma-delimited list of FSSI Species associated with the given cruise';
COMMENT ON COLUMN CCD_CRUISE_ISS_SUMM_V.SPP_FSSI_NAME_SCD_LIST IS 'Semicolon-delimited list of FSSI Species associated with the given cruise';
COMMENT ON COLUMN CCD_CRUISE_ISS_SUMM_V.SPP_FSSI_NAME_RC_LIST IS 'Return carriage/new line delimited list of FSSI Species associated with the given cruise';
COMMENT ON COLUMN CCD_CRUISE_ISS_SUMM_V.SPP_FSSI_NAME_BR_LIST IS '<BR> tag (intended for web pages) delimited list of FSSI Species associated with the given cruise';
COMMENT ON COLUMN CCD_CRUISE_ISS_SUMM_V.NUM_SPP_MMPA IS 'The number of associated MMPA Species';
COMMENT ON COLUMN CCD_CRUISE_ISS_SUMM_V.SPP_MMPA_NAME_CD_LIST IS 'Comma-delimited list of MMPA Species associated with the given cruise';
COMMENT ON COLUMN CCD_CRUISE_ISS_SUMM_V.SPP_MMPA_NAME_SCD_LIST IS 'Semicolon-delimited list of MMPA Species associated with the given cruise';
COMMENT ON COLUMN CCD_CRUISE_ISS_SUMM_V.SPP_MMPA_NAME_RC_LIST IS 'Return carriage/new line delimited list of MMPA Species associated with the given cruise';
COMMENT ON COLUMN CCD_CRUISE_ISS_SUMM_V.SPP_MMPA_NAME_BR_LIST IS '<BR> tag (intended for web pages) delimited list of MMPA Species associated with the given cruise';
COMMENT ON COLUMN CCD_CRUISE_ISS_SUMM_V.NUM_PRIM_SVY_CATS IS 'The number of associated primary survey categories';
COMMENT ON COLUMN CCD_CRUISE_ISS_SUMM_V.PRIM_SVY_CAT_NAME_CD_LIST IS 'Comma-delimited list of primary survey categories associated with the given cruise';
COMMENT ON COLUMN CCD_CRUISE_ISS_SUMM_V.PRIM_SVY_CAT_NAME_SCD_LIST IS 'Semicolon-delimited list of primary survey categories associated with the given cruise';
COMMENT ON COLUMN CCD_CRUISE_ISS_SUMM_V.PRIM_SVY_CAT_NAME_RC_LIST IS 'Return carriage/new line delimited list of primary survey categories associated with the given cruise';
COMMENT ON COLUMN CCD_CRUISE_ISS_SUMM_V.PRIM_SVY_CAT_NAME_BR_LIST IS '<BR> tag (intended for web pages) delimited list of primary survey categories associated with the given cruise';
COMMENT ON COLUMN CCD_CRUISE_ISS_SUMM_V.NUM_SEC_SVY_CATS IS 'The number of associated secondary survey categories';
COMMENT ON COLUMN CCD_CRUISE_ISS_SUMM_V.SEC_SVY_CAT_NAME_CD_LIST IS 'Comma-delimited list of secondary survey categories associated with the given cruise';
COMMENT ON COLUMN CCD_CRUISE_ISS_SUMM_V.SEC_SVY_CAT_NAME_SCD_LIST IS 'Semicolon-delimited list of secondary survey categories associated with the given cruise';
COMMENT ON COLUMN CCD_CRUISE_ISS_SUMM_V.SEC_SVY_CAT_NAME_RC_LIST IS 'Return carriage/new line delimited list of secondary survey categories associated with the given cruise';
COMMENT ON COLUMN CCD_CRUISE_ISS_SUMM_V.SEC_SVY_CAT_NAME_BR_LIST IS '<BR> tag (intended for web pages) delimited list of secondary survey categories associated with the given cruise';
COMMENT ON COLUMN CCD_CRUISE_ISS_SUMM_V.NUM_EXP_SPP IS 'The number of associated expected species categories';
COMMENT ON COLUMN CCD_CRUISE_ISS_SUMM_V.EXP_SPP_NAME_CD_LIST IS 'Comma-delimited list of expected species categories associated with the given cruise';
COMMENT ON COLUMN CCD_CRUISE_ISS_SUMM_V.EXP_SPP_NAME_SCD_LIST IS 'Semicolon-delimited list of expected species categories associated with the given cruise';
COMMENT ON COLUMN CCD_CRUISE_ISS_SUMM_V.EXP_SPP_NAME_RC_LIST IS 'Return carriage/new line delimited list of expected species categories associated with the given cruise';
COMMENT ON COLUMN CCD_CRUISE_ISS_SUMM_V.EXP_SPP_NAME_BR_LIST IS '<BR> tag (intended for web pages) delimited list of expected species categories associated with the given cruise';
COMMENT ON COLUMN CCD_CRUISE_ISS_SUMM_V.NUM_SPP_OTH IS 'The number of associated target species - other';
COMMENT ON COLUMN CCD_CRUISE_ISS_SUMM_V.OTH_SPP_CNAME_CD_LIST IS 'Comma-delimited list of common names for target species - other associated with the given cruise';
COMMENT ON COLUMN CCD_CRUISE_ISS_SUMM_V.OTH_SPP_CNAME_SCD_LIST IS 'Semicolon-delimited list of common names for target species - other associated with the given cruise';
COMMENT ON COLUMN CCD_CRUISE_ISS_SUMM_V.OTH_SPP_CNAME_RC_LIST IS 'Return carriage/new line delimited list of common names for target species - other associated with the given cruise';
COMMENT ON COLUMN CCD_CRUISE_ISS_SUMM_V.OTH_SPP_CNAME_BR_LIST IS '<BR> tag (intended for web pages) delimited list of common names for target species - other associated with the given cruise';
COMMENT ON COLUMN CCD_CRUISE_ISS_SUMM_V.OTH_SPP_SNAME_CD_LIST IS 'Comma-delimited list of scientific names for target species - other associated with the given cruise';
COMMENT ON COLUMN CCD_CRUISE_ISS_SUMM_V.OTH_SPP_SNAME_SCD_LIST IS 'Semicolon-delimited list of scientific names for target species - other associated with the given cruise';
COMMENT ON COLUMN CCD_CRUISE_ISS_SUMM_V.OTH_SPP_SNAME_RC_LIST IS 'Return carriage/new line delimited list of scientific names for target species - other associated with the given cruise';
COMMENT ON COLUMN CCD_CRUISE_ISS_SUMM_V.OTH_SPP_SNAME_BR_LIST IS '<BR> tag (intended for web pages) delimited list of scientific names for target species - other associated with the given cruise';
COMMENT ON COLUMN CCD_CRUISE_ISS_SUMM_V.CRUISE_START_DATE IS 'The start date for the given cruise (based on the earliest associated cruise leg''s start date)';
COMMENT ON COLUMN CCD_CRUISE_ISS_SUMM_V.FORMAT_CRUISE_START_DATE IS 'The formatted start date for the given cruise (based on the earliest associated cruise leg''s start date) in MM/DD/YYYY HH24:MI:SS format';
COMMENT ON COLUMN CCD_CRUISE_ISS_SUMM_V.CRUISE_END_DATE IS 'The end date for the given cruise (based on the latest associated cruise leg''s end date)';
COMMENT ON COLUMN CCD_CRUISE_ISS_SUMM_V.FORMAT_CRUISE_END_DATE IS 'The formatted end date for the given cruise (based on the latest associated cruise leg''s end date) in MM/DD/YYYY HH24:MI:SS format';
COMMENT ON COLUMN CCD_CRUISE_ISS_SUMM_V.CRUISE_DAS IS 'The total number of days at sea for each of the legs associated with the given cruise';
COMMENT ON COLUMN CCD_CRUISE_ISS_SUMM_V.CRUISE_LEN_DAYS IS 'The total number of days between the Cruise Start and End Dates for the given cruise';
COMMENT ON COLUMN CCD_CRUISE_ISS_SUMM_V.CRUISE_YEAR IS 'The calendar year for the given cruise (based on the earliest associated cruise leg''s start date)';
COMMENT ON COLUMN CCD_CRUISE_ISS_SUMM_V.CRUISE_FISC_YEAR IS 'The NOAA fiscal year for the given cruise (based on the earliest associated cruise leg''s start date)';
COMMENT ON COLUMN CCD_CRUISE_ISS_SUMM_V.NUM_LEGS IS 'The number of cruise legs associated with the given cruise';
COMMENT ON COLUMN CCD_CRUISE_ISS_SUMM_V.LEG_NAME_CD_LIST IS 'Comma-delimited list of leg names associated with the given cruise';
COMMENT ON COLUMN CCD_CRUISE_ISS_SUMM_V.LEG_NAME_SCD_LIST IS 'Semicolon-delimited list of leg names associated with the given cruise';
COMMENT ON COLUMN CCD_CRUISE_ISS_SUMM_V.LEG_NAME_RC_LIST IS 'Return carriage/new line delimited list of leg names associated with the given cruise';
COMMENT ON COLUMN CCD_CRUISE_ISS_SUMM_V.LEG_NAME_BR_LIST IS '<BR> tag (intended for web pages) delimited list of leg names associated with the given cruise';
COMMENT ON COLUMN CCD_CRUISE_ISS_SUMM_V.LEG_NAME_DATES_CD_LIST IS 'Comma-delimited list of leg names, the associated leg dates and vessel name associated with the given cruise';
COMMENT ON COLUMN CCD_CRUISE_ISS_SUMM_V.LEG_NAME_DATES_SCD_LIST IS 'Semicolon-delimited list of leg names, the associated leg dates and vessel name associated with the given cruise';
COMMENT ON COLUMN CCD_CRUISE_ISS_SUMM_V.LEG_NAME_DATES_RC_LIST IS 'Return carriage/new line delimited list of leg names, the associated leg dates and vessel name associated with the given cruise';
COMMENT ON COLUMN CCD_CRUISE_ISS_SUMM_V.LEG_NAME_DATES_BR_LIST IS '<BR> tag (intended for web pages) delimited list of leg names, the associated leg dates and vessel name associated with the given cruise';
COMMENT ON COLUMN CCD_CRUISE_ISS_SUMM_V.NUM_REGIONS IS 'The number of unique regions associated with the associated cruise legs';
COMMENT ON COLUMN CCD_CRUISE_ISS_SUMM_V.REGION_CODE_CD_LIST IS 'Comma-delimited list of unique region codes associated with the given cruise leg';
COMMENT ON COLUMN CCD_CRUISE_ISS_SUMM_V.REGION_CODE_SCD_LIST IS 'Semicolon-delimited list of unique region codes associated with the given cruise leg';
COMMENT ON COLUMN CCD_CRUISE_ISS_SUMM_V.REGION_CODE_RC_LIST IS 'Return carriage/new line delimited list of unique region codes associated with the given cruise leg';
COMMENT ON COLUMN CCD_CRUISE_ISS_SUMM_V.REGION_CODE_BR_LIST IS '<BR> tag (intended for web pages) delimited list of unique region codes associated with the given cruise leg';
COMMENT ON COLUMN CCD_CRUISE_ISS_SUMM_V.REGION_NAME_CD_LIST IS 'Comma-delimited list of unique region names associated with the given cruise leg';
COMMENT ON COLUMN CCD_CRUISE_ISS_SUMM_V.REGION_NAME_SCD_LIST IS 'Semicolon-delimited list of unique region names associated with the given cruise leg';
COMMENT ON COLUMN CCD_CRUISE_ISS_SUMM_V.REGION_NAME_RC_LIST IS 'Return carriage/new line delimited list of unique region names associated with the given cruise leg';
COMMENT ON COLUMN CCD_CRUISE_ISS_SUMM_V.REGION_NAME_BR_LIST IS '<BR> tag (intended for web pages) delimited list of unique region names associated with the given cruise leg';
COMMENT ON COLUMN CCD_CRUISE_ISS_SUMM_V.NUM_ECOSYSTEMS IS 'The number of unique regional ecosystems associated with the associated cruise legs';
COMMENT ON COLUMN CCD_CRUISE_ISS_SUMM_V.ECOSYSTEM_CD_LIST IS 'Comma-delimited list of unique regional ecosystems associated with the given cruise leg';
COMMENT ON COLUMN CCD_CRUISE_ISS_SUMM_V.ECOSYSTEM_SCD_LIST IS 'Semicolon-delimited list of unique regional ecosystems associated with the given cruise leg';
COMMENT ON COLUMN CCD_CRUISE_ISS_SUMM_V.ECOSYSTEM_RC_LIST IS 'Return carriage/new line delimited list of unique regional ecosystems associated with the given cruise leg';
COMMENT ON COLUMN CCD_CRUISE_ISS_SUMM_V.ECOSYSTEM_BR_LIST IS '<BR> tag (intended for web pages) delimited list of unique regional ecosystems associated with the given cruise leg';
COMMENT ON COLUMN CCD_CRUISE_ISS_SUMM_V.NUM_GEAR IS 'The number of unique gear associated with the associated cruise legs';
COMMENT ON COLUMN CCD_CRUISE_ISS_SUMM_V.GEAR_CD_LIST IS 'Comma-delimited list of unique gear associated with the associated cruise legs';
COMMENT ON COLUMN CCD_CRUISE_ISS_SUMM_V.GEAR_SCD_LIST IS 'Semicolon-delimited list of unique gear associated with the associated cruise legs';
COMMENT ON COLUMN CCD_CRUISE_ISS_SUMM_V.GEAR_RC_LIST IS 'Return carriage/new line delimited list of unique gear associated with the associated cruise legs';
COMMENT ON COLUMN CCD_CRUISE_ISS_SUMM_V.GEAR_BR_LIST IS '<BR> tag (intended for web pages) delimited list of unique gear associated with the associated cruise legs';
COMMENT ON COLUMN CCD_CRUISE_ISS_SUMM_V.NUM_ACTIVE_WARNINGS IS 'Number of QC Validation Active Warnings for the given cruise';
COMMENT ON COLUMN CCD_CRUISE_ISS_SUMM_V.NUM_ANNOT_WARNINGS IS 'Number of QC Validation Annotated Warnings for the given cruise';
COMMENT ON COLUMN CCD_CRUISE_ISS_SUMM_V.NUM_ACTIVE_ERRORS IS 'Number of QC Validation Active Errors (Errors that are not annotated) for the given cruise';
COMMENT ON COLUMN CCD_CRUISE_ISS_SUMM_V.NUM_ANNOT_ERRORS IS 'Number of QC Validation Annotated Errors (Errors that have had an issue resolution specified) for the given cruise';
COMMENT ON COLUMN CCD_CRUISE_ISS_SUMM_V.CRUISE_VALID_YN IS 'Flag to indicate if the given cruise is considered valid (Y) when the only associated QC validation issues are annotated errors and/or warnings or invalid (N) when there are one or more associated active error QC validation issues';


COMMENT ON TABLE CCD_CRUISE_ISS_SUMM_V IS 'Research Cruise Leg Validation Issue Summary (View)

This query returns all of the research cruises and all associated comma-/semicolon-delimited list of associated reference values.  The aggregate cruise leg information is included as start and end dates and the number of legs defined for the given cruise (if any) as well as all associated comma-/semicolon-delimited unique list of associated reference values (regional ecosystems, gear, regions).  This view also contains summary information for any associated QC validation issues in the categories of active warnings, annotated warnings, active errors, and annotated errors';





--verification query to compare the cruise, cruise legs, and associated attributes to determine if a CCD_CRUISE_PKG.DEEP_COPY_CRUISE_SP procedure call was successful
CREATE OR REPLACE VIEW CCD_CCDP_DEEP_COPY_CMP_V AS
select v_orig.cruise_name orig_cruise_name, v_copy.cruise_name copy_cruise_name, v_orig.leg_name orig_leg_name, v_copy.leg_name copy_leg_name,
(CASE WHEN


 (v_orig.CRUISE_NOTES =  v_copy.CRUISE_NOTES OR (v_orig.CRUISE_NOTES IS NULL AND v_copy.CRUISE_NOTES IS NULL))
 AND (dbms_lob.substr( v_orig.CRUISE_DESC, 4000, 1 ) =  dbms_lob.substr( v_copy.CRUISE_DESC, 4000, 1 ) OR (v_orig.CRUISE_DESC IS NULL AND v_copy.CRUISE_DESC IS NULL))
 AND (v_orig.OBJ_BASED_METRICS =  v_copy.OBJ_BASED_METRICS OR (v_orig.OBJ_BASED_METRICS IS NULL AND v_copy.OBJ_BASED_METRICS IS NULL))
 AND (v_orig.SCI_CENTER_DIV_ID =  v_copy.SCI_CENTER_DIV_ID OR (v_orig.SCI_CENTER_DIV_ID IS NULL AND v_copy.SCI_CENTER_DIV_ID IS NULL))
 AND (v_orig.SCI_CENTER_DIV_CODE =  v_copy.SCI_CENTER_DIV_CODE OR (v_orig.SCI_CENTER_DIV_CODE IS NULL AND v_copy.SCI_CENTER_DIV_CODE IS NULL))
 AND (v_orig.SCI_CENTER_DIV_NAME =  v_copy.SCI_CENTER_DIV_NAME OR (v_orig.SCI_CENTER_DIV_NAME IS NULL AND v_copy.SCI_CENTER_DIV_NAME IS NULL))
 AND (v_orig.SCI_CENTER_DIV_DESC =  v_copy.SCI_CENTER_DIV_DESC OR (v_orig.SCI_CENTER_DIV_DESC IS NULL AND v_copy.SCI_CENTER_DIV_DESC IS NULL))
 AND (v_orig.SCI_CENTER_ID =  v_copy.SCI_CENTER_ID OR (v_orig.SCI_CENTER_ID IS NULL AND v_copy.SCI_CENTER_ID IS NULL))
 AND (v_orig.SCI_CENTER_NAME =  v_copy.SCI_CENTER_NAME OR (v_orig.SCI_CENTER_NAME IS NULL AND v_copy.SCI_CENTER_NAME IS NULL))
 AND (v_orig.SCI_CENTER_DESC =  v_copy.SCI_CENTER_DESC OR (v_orig.SCI_CENTER_DESC IS NULL AND v_copy.SCI_CENTER_DESC IS NULL))
 AND (v_orig.STD_SVY_NAME_ID =  v_copy.STD_SVY_NAME_ID OR (v_orig.STD_SVY_NAME_ID IS NULL AND v_copy.STD_SVY_NAME_ID IS NULL))
 AND (v_orig.STD_SVY_NAME =  v_copy.STD_SVY_NAME OR (v_orig.STD_SVY_NAME IS NULL AND v_copy.STD_SVY_NAME IS NULL))
 AND (v_orig.STD_SVY_DESC =  v_copy.STD_SVY_DESC OR (v_orig.STD_SVY_DESC IS NULL AND v_copy.STD_SVY_DESC IS NULL))
 AND (v_orig.SVY_FREQ_ID =  v_copy.SVY_FREQ_ID OR (v_orig.SVY_FREQ_ID IS NULL AND v_copy.SVY_FREQ_ID IS NULL))
 AND (v_orig.SVY_FREQ_NAME =  v_copy.SVY_FREQ_NAME OR (v_orig.SVY_FREQ_NAME IS NULL AND v_copy.SVY_FREQ_NAME IS NULL))
 AND (v_orig.SVY_FREQ_DESC =  v_copy.SVY_FREQ_DESC OR (v_orig.SVY_FREQ_DESC IS NULL AND v_copy.SVY_FREQ_DESC IS NULL))
 AND (v_orig.STD_SVY_NAME_OTH =  v_copy.STD_SVY_NAME_OTH OR (v_orig.STD_SVY_NAME_OTH IS NULL AND v_copy.STD_SVY_NAME_OTH IS NULL))
 AND (v_orig.STD_SVY_NAME_VAL =  v_copy.STD_SVY_NAME_VAL OR (v_orig.STD_SVY_NAME_VAL IS NULL AND v_copy.STD_SVY_NAME_VAL IS NULL))
 AND (v_orig.SVY_TYPE_ID =  v_copy.SVY_TYPE_ID OR (v_orig.SVY_TYPE_ID IS NULL AND v_copy.SVY_TYPE_ID IS NULL))
 AND (v_orig.SVY_TYPE_NAME =  v_copy.SVY_TYPE_NAME OR (v_orig.SVY_TYPE_NAME IS NULL AND v_copy.SVY_TYPE_NAME IS NULL))
 AND (v_orig.SVY_TYPE_DESC =  v_copy.SVY_TYPE_DESC OR (v_orig.SVY_TYPE_DESC IS NULL AND v_copy.SVY_TYPE_DESC IS NULL))
 AND (v_orig.CRUISE_URL =  v_copy.CRUISE_URL OR (v_orig.CRUISE_URL IS NULL AND v_copy.CRUISE_URL IS NULL))
 AND (v_orig.CRUISE_CONT_EMAIL =  v_copy.CRUISE_CONT_EMAIL OR (v_orig.CRUISE_CONT_EMAIL IS NULL AND v_copy.CRUISE_CONT_EMAIL IS NULL))
 AND (v_orig.NUM_LEGS =  v_copy.NUM_LEGS OR (v_orig.NUM_LEGS IS NULL AND v_copy.NUM_LEGS IS NULL))
 AND (v_orig.CRUISE_START_DATE =  v_copy.CRUISE_START_DATE OR (v_orig.CRUISE_START_DATE IS NULL AND v_copy.CRUISE_START_DATE IS NULL))
 AND (v_orig.FORMAT_CRUISE_START_DATE =  v_copy.FORMAT_CRUISE_START_DATE OR (v_orig.FORMAT_CRUISE_START_DATE IS NULL AND v_copy.FORMAT_CRUISE_START_DATE IS NULL))
 AND (v_orig.CRUISE_END_DATE =  v_copy.CRUISE_END_DATE OR (v_orig.CRUISE_END_DATE IS NULL AND v_copy.CRUISE_END_DATE IS NULL))
 AND (v_orig.FORMAT_CRUISE_END_DATE =  v_copy.FORMAT_CRUISE_END_DATE OR (v_orig.FORMAT_CRUISE_END_DATE IS NULL AND v_copy.FORMAT_CRUISE_END_DATE IS NULL))
 AND (v_orig.CRUISE_DAS =  v_copy.CRUISE_DAS OR (v_orig.CRUISE_DAS IS NULL AND v_copy.CRUISE_DAS IS NULL))
 AND (v_orig.CRUISE_LEN_DAYS =  v_copy.CRUISE_LEN_DAYS OR (v_orig.CRUISE_LEN_DAYS IS NULL AND v_copy.CRUISE_LEN_DAYS IS NULL))
 AND (v_orig.CRUISE_YEAR =  v_copy.CRUISE_YEAR OR (v_orig.CRUISE_YEAR IS NULL AND v_copy.CRUISE_YEAR IS NULL))
 AND (v_orig.CRUISE_FISC_YEAR =  v_copy.CRUISE_FISC_YEAR OR (v_orig.CRUISE_FISC_YEAR IS NULL AND v_copy.CRUISE_FISC_YEAR IS NULL))
-- AND (v_orig.LEG_NAME_RC_LIST =  v_copy.LEG_NAME_RC_LIST OR (v_orig.LEG_NAME_RC_LIST IS NULL AND v_copy.LEG_NAME_RC_LIST IS NULL))
-- AND (v_orig.LEG_NAME_DATES_RC_LIST =  v_copy.LEG_NAME_DATES_RC_LIST OR (v_orig.LEG_NAME_DATES_RC_LIST IS NULL AND v_copy.LEG_NAME_DATES_RC_LIST IS NULL))
 AND (v_orig.NUM_SPP_ESA =  v_copy.NUM_SPP_ESA OR (v_orig.NUM_SPP_ESA IS NULL AND v_copy.NUM_SPP_ESA IS NULL))
 AND (v_orig.SPP_ESA_NAME_RC_LIST =  v_copy.SPP_ESA_NAME_RC_LIST OR (v_orig.SPP_ESA_NAME_RC_LIST IS NULL AND v_copy.SPP_ESA_NAME_RC_LIST IS NULL))
 AND (v_orig.NUM_SPP_FSSI =  v_copy.NUM_SPP_FSSI OR (v_orig.NUM_SPP_FSSI IS NULL AND v_copy.NUM_SPP_FSSI IS NULL))
 AND (v_orig.SPP_FSSI_NAME_RC_LIST =  v_copy.SPP_FSSI_NAME_RC_LIST OR (v_orig.SPP_FSSI_NAME_RC_LIST IS NULL AND v_copy.SPP_FSSI_NAME_RC_LIST IS NULL))
 AND (v_orig.NUM_SPP_MMPA =  v_copy.NUM_SPP_MMPA OR (v_orig.NUM_SPP_MMPA IS NULL AND v_copy.NUM_SPP_MMPA IS NULL))
 AND (v_orig.SPP_MMPA_NAME_RC_LIST =  v_copy.SPP_MMPA_NAME_RC_LIST OR (v_orig.SPP_MMPA_NAME_RC_LIST IS NULL AND v_copy.SPP_MMPA_NAME_RC_LIST IS NULL))
 AND (v_orig.NUM_PRIM_SVY_CATS =  v_copy.NUM_PRIM_SVY_CATS OR (v_orig.NUM_PRIM_SVY_CATS IS NULL AND v_copy.NUM_PRIM_SVY_CATS IS NULL))
 AND (v_orig.PRIM_SVY_CAT_NAME_RC_LIST =  v_copy.PRIM_SVY_CAT_NAME_RC_LIST OR (v_orig.PRIM_SVY_CAT_NAME_RC_LIST IS NULL AND v_copy.PRIM_SVY_CAT_NAME_RC_LIST IS NULL))
 AND (v_orig.NUM_SEC_SVY_CATS =  v_copy.NUM_SEC_SVY_CATS OR (v_orig.NUM_SEC_SVY_CATS IS NULL AND v_copy.NUM_SEC_SVY_CATS IS NULL))
 AND (v_orig.SEC_SVY_CAT_NAME_RC_LIST =  v_copy.SEC_SVY_CAT_NAME_RC_LIST OR (v_orig.SEC_SVY_CAT_NAME_RC_LIST IS NULL AND v_copy.SEC_SVY_CAT_NAME_RC_LIST IS NULL))
 AND (v_orig.NUM_EXP_SPP =  v_copy.NUM_EXP_SPP OR (v_orig.NUM_EXP_SPP IS NULL AND v_copy.NUM_EXP_SPP IS NULL))
 AND (v_orig.EXP_SPP_NAME_RC_LIST =  v_copy.EXP_SPP_NAME_RC_LIST OR (v_orig.EXP_SPP_NAME_RC_LIST IS NULL AND v_copy.EXP_SPP_NAME_RC_LIST IS NULL))
 AND (v_orig.NUM_SPP_OTH =  v_copy.NUM_SPP_OTH OR (v_orig.NUM_SPP_OTH IS NULL AND v_copy.NUM_SPP_OTH IS NULL))
 AND (v_orig.OTH_SPP_CNAME_RC_LIST =  v_copy.OTH_SPP_CNAME_RC_LIST OR (v_orig.OTH_SPP_CNAME_RC_LIST IS NULL AND v_copy.OTH_SPP_CNAME_RC_LIST IS NULL))
 AND (v_orig.OTH_SPP_SNAME_RC_LIST =  v_copy.OTH_SPP_SNAME_RC_LIST OR (v_orig.OTH_SPP_SNAME_RC_LIST IS NULL AND v_copy.OTH_SPP_SNAME_RC_LIST IS NULL))
 --AND (v_orig.CRUISE_LEG_ID =  v_copy.CRUISE_LEG_ID OR (v_orig.CRUISE_LEG_ID IS NULL AND v_copy.CRUISE_LEG_ID IS NULL))
 AND (v_orig.LEG_NAME || ' (copy)' =  v_copy.LEG_NAME OR (v_orig.LEG_NAME IS NULL AND v_copy.LEG_NAME IS NULL))
 AND (v_orig.LEG_START_DATE =  v_copy.LEG_START_DATE OR (v_orig.LEG_START_DATE IS NULL AND v_copy.LEG_START_DATE IS NULL))
 AND (v_orig.FORMAT_LEG_START_DATE =  v_copy.FORMAT_LEG_START_DATE OR (v_orig.FORMAT_LEG_START_DATE IS NULL AND v_copy.FORMAT_LEG_START_DATE IS NULL))
 AND (v_orig.LEG_END_DATE =  v_copy.LEG_END_DATE OR (v_orig.LEG_END_DATE IS NULL AND v_copy.LEG_END_DATE IS NULL))
 AND (v_orig.FORMAT_LEG_END_DATE =  v_copy.FORMAT_LEG_END_DATE OR (v_orig.FORMAT_LEG_END_DATE IS NULL AND v_copy.FORMAT_LEG_END_DATE IS NULL))
 AND (v_orig.LEG_DAS =  v_copy.LEG_DAS OR (v_orig.LEG_DAS IS NULL AND v_copy.LEG_DAS IS NULL))
 AND (v_orig.LEG_YEAR =  v_copy.LEG_YEAR OR (v_orig.LEG_YEAR IS NULL AND v_copy.LEG_YEAR IS NULL))
 AND (v_orig.LEG_FISC_YEAR =  v_copy.LEG_FISC_YEAR OR (v_orig.LEG_FISC_YEAR IS NULL AND v_copy.LEG_FISC_YEAR IS NULL))
 AND (v_orig.LEG_DESC =  v_copy.LEG_DESC OR (v_orig.LEG_DESC IS NULL AND v_copy.LEG_DESC IS NULL))
 AND (v_orig.VESSEL_ID =  v_copy.VESSEL_ID OR (v_orig.VESSEL_ID IS NULL AND v_copy.VESSEL_ID IS NULL))
 AND (v_orig.VESSEL_NAME =  v_copy.VESSEL_NAME OR (v_orig.VESSEL_NAME IS NULL AND v_copy.VESSEL_NAME IS NULL))
 AND (v_orig.VESSEL_DESC =  v_copy.VESSEL_DESC OR (v_orig.VESSEL_DESC IS NULL AND v_copy.VESSEL_DESC IS NULL))
 AND (v_orig.PLAT_TYPE_ID =  v_copy.PLAT_TYPE_ID OR (v_orig.PLAT_TYPE_ID IS NULL AND v_copy.PLAT_TYPE_ID IS NULL))
 AND (v_orig.PLAT_TYPE_NAME =  v_copy.PLAT_TYPE_NAME OR (v_orig.PLAT_TYPE_NAME IS NULL AND v_copy.PLAT_TYPE_NAME IS NULL))
 AND (v_orig.PLAT_TYPE_DESC =  v_copy.PLAT_TYPE_DESC OR (v_orig.PLAT_TYPE_DESC IS NULL AND v_copy.PLAT_TYPE_DESC IS NULL))
 AND (v_orig.NUM_REG_ECOSYSTEMS =  v_copy.NUM_REG_ECOSYSTEMS OR (v_orig.NUM_REG_ECOSYSTEMS IS NULL AND v_copy.NUM_REG_ECOSYSTEMS IS NULL))
 AND (v_orig.REG_ECOSYSTEM_RC_LIST =  v_copy.REG_ECOSYSTEM_RC_LIST OR (v_orig.REG_ECOSYSTEM_RC_LIST IS NULL AND v_copy.REG_ECOSYSTEM_RC_LIST IS NULL))
 AND (v_orig.NUM_GEAR =  v_copy.NUM_GEAR OR (v_orig.NUM_GEAR IS NULL AND v_copy.NUM_GEAR IS NULL))
 AND (v_orig.GEAR_NAME_RC_LIST =  v_copy.GEAR_NAME_RC_LIST OR (v_orig.GEAR_NAME_RC_LIST IS NULL AND v_copy.GEAR_NAME_RC_LIST IS NULL))
 AND (v_orig.NUM_REGIONS =  v_copy.NUM_REGIONS OR (v_orig.NUM_REGIONS IS NULL AND v_copy.NUM_REGIONS IS NULL))
 AND (v_orig.REGION_CODE_RC_LIST =  v_copy.REGION_CODE_RC_LIST OR (v_orig.REGION_CODE_RC_LIST IS NULL AND v_copy.REGION_CODE_RC_LIST IS NULL))
 AND (v_orig.REGION_NAME_RC_LIST =  v_copy.REGION_NAME_RC_LIST OR (v_orig.REGION_NAME_RC_LIST IS NULL AND v_copy.REGION_NAME_RC_LIST IS NULL))
 AND (v_orig.NUM_LEG_ALIASES =  v_copy.NUM_LEG_ALIASES OR (v_orig.NUM_LEG_ALIASES IS NULL AND v_copy.NUM_LEG_ALIASES IS NULL))
 AND (REPLACE(v_orig.LEG_ALIAS_RC_LIST, chr(10), ' (copy)'||chr(10))||' (copy)' =  v_copy.LEG_ALIAS_RC_LIST OR (v_orig.LEG_ALIAS_RC_LIST IS NULL AND v_copy.LEG_ALIAS_RC_LIST IS NULL))

THEN 'Y' ELSE 'N' END) values_equal_yn

from CCD_CRUISE_LEG_DELIM_V v_orig
inner join CCD_CRUISE_LEG_DELIM_V v_copy
ON
v_orig.cruise_name||' (copy)' = v_copy.cruise_name
AND
(v_orig.leg_name||' (copy)' = v_copy.leg_name OR (v_orig.leg_name IS NULL AND v_copy.leg_name IS NULL))

order by v_orig.cruise_name,
v_orig.leg_name;


COMMENT ON TABLE CCD_CCDP_DEEP_COPY_CMP_V IS 'Cruise Oracle Package Deep Copy Procedure Verification Query (View)

This verification query retrieves all cruise information and associated attributes and associated cruise legs and associated attributes for all deep copies of cruises based on the "(copy)" naming convention for cruise names, leg names, and leg alias names.  This view is utilized to determine if a given CCD_CRUISE_PKG.DEEP_COPY_CRUISE_SP procedure call was successful';

COMMENT ON COLUMN CCD_CCDP_DEEP_COPY_CMP_V.VALUES_EQUAL_YN IS 'Flag to indicate if the cruise attributes, cruise legs, and cruise leg attributes for each cruise that was copied using the Deep Copy functionality all match (Y) or if they do not match (N)';


COMMENT ON COLUMN CCD_CCDP_DEEP_COPY_CMP_V.ORIG_CRUISE_NAME IS 'The Name of the Cruise that was copied by the Deep Copy procedure';
COMMENT ON COLUMN CCD_CCDP_DEEP_COPY_CMP_V.COPY_CRUISE_NAME IS 'The Name of the Cruise that was created by the Deep Copy procedure';
COMMENT ON COLUMN CCD_CCDP_DEEP_COPY_CMP_V.ORIG_LEG_NAME IS 'The Name of the Cruise Leg that was copied by the Deep Copy procedure';
COMMENT ON COLUMN CCD_CCDP_DEEP_COPY_CMP_V.COPY_LEG_NAME IS 'The Name of the Cruise Leg that was created by the Deep Copy procedure';







	--CCD DVM Package Specification:
	CREATE OR REPLACE PACKAGE CCD_DVM_PKG
	AUTHID DEFINER
	--this package provides functions and procedures to interact with the CCD package module

	AS

		--this procedure executes the DVM for all CCD_CRUISES records
		--example usage:
/*
		--set the DBMS_OUTPUT buffer limit:
		SET SERVEROUTPUT ON size 1000000;

		exec DBMS_OUTPUT.ENABLE(NULL);


		--this code snippet will run the data validation module to validate all cruises returned by the SELECT query.  This can be used to batch process cruises

		DECLARE

			V_PROC_RETURN_CODE PLS_INTEGER;

		BEGIN

			--execute the DVM for each cruise in the database
			CCD_DVM_PKG.BATCH_EXEC_DVM_CRUISE_SP;

		EXCEPTION
			when others THEN

				dbms_output.put_line('The DVM batch execution was NOT successful: '|| SQLCODE || '- ' || SQLERRM);

		END;
*/
		PROCEDURE BATCH_EXEC_DVM_CRUISE_SP;

		--procedure that executes the DVM for a given CCD_CRUISES record (based on P_CRUISE_ID)
		--all error conditions will raise an application exception and will be logged in the database
/*
		--example usage:

		DECLARE
			V_CRUISE_ID NUMBER := 10;
		BEGIN

			CCD_DVM_PKG.EXEC_DVM_CRUISE_SP(V_CRUISE_ID);

			DBMS_output.put_line('The cruise record (CRUISE_ID: '||V_CRUISE_ID||') was evaluated successfully');

			--commit the successful validation records
			COMMIT;

			EXCEPTION
				WHEN OTHERS THEN
					DBMS_output.put_line(SQLERRM);

					DBMS_output.put_line('The cruise record (CRUISE_ID: '||V_CRUISE_ID||') was not evaluated successfully');

		END;

*/
		PROCEDURE EXEC_DVM_CRUISE_SP (P_CRUISE_ID IN NUMBER);

		--procedure that executes the DVM for a given CCD_CRUISES record (based on P_CRUISE_NAME)
		--all error conditions will raise an application exception and will be logged in the database
/*
		--example usage:

		DECLARE
			V_CRUISE_NAME VARCHAR2(2000) := 'SE-20-04';
		BEGIN

			CCD_DVM_PKG.EXEC_DVM_CRUISE_SP(V_CRUISE_NAME);

			DBMS_output.put_line('The cruise record ('||V_CRUISE_NAME||') was evaluated successfully');

			--commit the successful validation records
			COMMIT;

			EXCEPTION
				WHEN OTHERS THEN
					DBMS_output.put_line(SQLERRM);

					DBMS_output.put_line('The cruise record ('||V_CRUISE_NAME||') was not evaluated successfully');

		END;
*/
		PROCEDURE EXEC_DVM_CRUISE_SP (P_CRUISE_NAME IN VARCHAR2);


		--procedure that executes the DVM for a given CCD_CRUISES record (based on P_CRUISE_ID) and returns a return code (P_SP_RET_CODE) with a value that indicates if the DVM executed successfully instead of raising an exception.  A P_SP_RET_CODE value of 1 indicates a successful execution and a value of 0 indicates it was not successful.  The P_EXC_MSG parameter will contain the exception message if the P_SP_RET_CODE indicates there was a processing error.  This procedure allows a PL/SQL block to continue even if the DVM has an exception
/*
		--example usage:

		DECLARE
			V_SP_RET_CODE PLS_INTEGER;

			V_EXC_MSG VARCHAR2(4000);

			V_CRUISE_ID NUMBER := 10;
		BEGIN

			CCD_DVM_PKG.EXEC_DVM_CRUISE_RC_SP(V_CRUISE_ID, V_SP_RET_CODE, V_EXC_MSG);

			IF (V_SP_RET_CODE = 1) THEN

				DBMS_output.put_line('The cruise record ('||V_CRUISE_ID||') was evaluated successfully');

				--commit the successful validation records
				COMMIT;
			ELSE
					DBMS_output.put_line(V_EXC_MSG);

					DBMS_output.put_line('The cruise record ('||V_CRUISE_ID||') was not evaluated successfully');
			END IF;

		END;
*/
		PROCEDURE EXEC_DVM_CRUISE_RC_SP (P_CRUISE_ID IN NUMBER, P_SP_RET_CODE OUT PLS_INTEGER, P_EXC_MSG OUT VARCHAR2);

		--procedure that executes the DVM for a given CCD_CRUISES record (based on P_CRUISE_NAME) and returns a return code (P_SP_RET_CODE) with a value that indicates if the DVM executed successfully instead of raising an exception.  A P_SP_RET_CODE value of 1 indicates a successful execution and a value of 0 indicates it was not successful.  The P_EXC_MSG parameter will contain the exception message if the P_SP_RET_CODE indicates there was a processing error.  This procedure allows a PL/SQL block to continue even if the DVM has an exception
/*
		--example usage:

		DECLARE
			V_SP_RET_CODE PLS_INTEGER;

			V_EXC_MSG VARCHAR2(4000);

			V_CRUISE_NAME VARCHAR2(2000) := 'SE-20-04';
		BEGIN

			CCD_DVM_PKG.EXEC_DVM_CRUISE_RC_SP(V_CRUISE_NAME, V_SP_RET_CODE, V_EXC_MSG);

			IF (V_SP_RET_CODE = 1) THEN

				DBMS_output.put_line('The cruise record (CRUISE_NAME: '||V_CRUISE_NAME||') was evaluated successfully');

				--commit the successful validation records
				COMMIT;
			ELSE
					DBMS_output.put_line(V_EXC_MSG);

					DBMS_output.put_line('The cruise record (CRUISE_NAME: '||V_CRUISE_NAME||') was not evaluated successfully');
			END IF;

		END;
*/
		PROCEDURE EXEC_DVM_CRUISE_RC_SP (P_CRUISE_NAME IN VARCHAR2, P_SP_RET_CODE OUT PLS_INTEGER, P_EXC_MSG OUT VARCHAR2);


		--procedure that executes the DVM for a given CCD_CRUISES record (based on P_CRUISE_ID) by calling the EXEC_DVM_CRUISE_SP on the P_CRUISE_ID and then calling EXEC_DVM_CRUISE_SP on each of the records that is related to the P_CRUISE_ID via the CCD_QC_LEG_OVERLAP_V QC view so that the overlapping leg errors can be associated with the matching cruises from the CCD_QC_LEG_OVERLAP_V QC view.
		--all error conditions will raise an application exception and will be logged in the database
/*
		--example usage:

		DECLARE
			V_CRUISE_ID NUMBER := 10;
		BEGIN

			CCD_DVM_PKG.EXEC_DVM_CRUISE_OVERLAP_SP(V_CRUISE_ID);

			DBMS_output.put_line('The cruise record (CRUISE_ID: '||V_CRUISE_ID||') and any overlapping cruises were evaluated successfully');

			--commit the successful validation records
			COMMIT;

			EXCEPTION
				WHEN OTHERS THEN
					DBMS_output.put_line(SQLERRM);

					DBMS_output.put_line('The cruise record (CRUISE_ID: '||V_CRUISE_ID||') and any overlapping cruises were NOT evaluated successfully');
		END;

*/
	  PROCEDURE EXEC_DVM_CRUISE_OVERLAP_SP (P_CRUISE_ID IN NUMBER);


		--procedure that executes the DVM for a given CCD_CRUISES record (based on P_CRUISE_NAME) by calling the EXEC_DVM_CRUISE_SP on the corresponding CRUISE_ID and then calling EXEC_DVM_CRUISE_SP on each of the records that is related to the CRUISE_ID via the CCD_QC_LEG_OVERLAP_V QC view so that the overlapping leg errors can be associated with the matching cruises from the CCD_QC_LEG_OVERLAP_V QC view.
		--all error conditions will raise an application exception and will be logged in the database
		/*
			--example usage:

			DECLARE
				V_CRUISE_NAME VARCHAR2 (1000) := 'SE-15-01';
			BEGIN

				CCD_DVM_PKG.EXEC_DVM_CRUISE_OVERLAP_SP(V_CRUISE_NAME);

				DBMS_output.put_line('The cruise record (CRUISE_NAME: '||V_CRUISE_NAME||') and any overlapping cruises were evaluated successfully');

				--commit the successful validation records
				COMMIT;

				EXCEPTION
					WHEN OTHERS THEN
						DBMS_output.put_line(SQLERRM);

						DBMS_output.put_line('The cruise record (CRUISE_NAME: '||V_CRUISE_NAME||') and any overlapping cruises were NOT evaluated successfully');
			END;
		*/
	  PROCEDURE EXEC_DVM_CRUISE_OVERLAP_SP (P_CRUISE_NAME IN VARCHAR2);

		--this procedure deletes a given cruise leg (identified by P_CRUISE_LEG_ID) and re-evaluates the DVM for all cruises that overlapped (using CCD_QC_LEG_OVERLAP_V) with the deleted cruise leg's cruise to ensure those cruise DVM records are up to date.  If there is a processing error the transaction will be rolled back to the state before the procedure was executed.
		--all error conditions will raise an application exception and will be logged in the database
/*
		--example usage:

		--delete the cruise leg (SE-20-05 Leg 1):
		DECLARE
			V_LEG_ID NUMBER := 10;
		BEGIN




		  CEN_CRUISE.CCD_DVM_PKG.DELETE_LEG_OVERLAP_SP (V_LEG_ID);

		 	DBMS_output.put_line('The Cruise Leg (CRUISE_LEG_ID: '||V_LEG_ID||') was deleted successfully');

			--commit the successful validation records
			COMMIT;

			EXCEPTION
				WHEN OTHERS THEN
		       DBMS_output.put_line(SQLERRM);

		 			DBMS_output.put_line('The Cruise Leg (CRUISE_LEG_ID: '||V_LEG_ID||') was NOT deleted successfully');

		END;

*/
		PROCEDURE DELETE_LEG_OVERLAP_SP (P_CRUISE_LEG_ID IN PLS_INTEGER);


		--this procedure deletes a given cruise leg (identified by P_LEG_NAME) and re-evaluates the DVM for all cruises that overlapped (using CCD_QC_LEG_OVERLAP_V) with the deleted cruise leg's cruise to ensure those cruise DVM records are up to date.  If there is a processing error the transaction will be rolled back to the state before the procedure was executed.
		--all error conditions will raise an application exception and will be logged in the database
/*
		--example usage:

		--delete the cruise leg (SE-20-05 Leg 1):
		DECLARE
			V_LEG_NAME VARCHAR2(2000) := 'SE-20-05 Leg 1';
		BEGIN


		  CEN_CRUISE.CCD_DVM_PKG.DELETE_LEG_OVERLAP_SP (V_LEG_NAME);

		 	DBMS_output.put_line('The Cruise Leg (LEG_NAME: '||V_LEG_NAME||') was deleted successfully');

			--commit the successful validation records
			COMMIT;

			EXCEPTION
				WHEN OTHERS THEN
		      DBMS_output.put_line(SQLERRM);

				 	DBMS_output.put_line('The Cruise Leg (LEG_NAME: '||V_LEG_NAME||') was NOT deleted successfully');
		END;

*/
		PROCEDURE DELETE_LEG_OVERLAP_SP (P_LEG_NAME IN VARCHAR2);

	END CCD_DVM_PKG;
	/


	--CCD DVM Package Body:
	create or replace PACKAGE BODY CCD_DVM_PKG
	--this package provides procedures to validate the cruise database
	AS

		--this procedure executes the DVM for all CCD_CRUISES records
		PROCEDURE BATCH_EXEC_DVM_CRUISE_SP IS

			--variable to hold the return code value from procedures
			V_SP_RET_CODE PLS_INTEGER;

			--variable to store the constructed log source string for the current procedure's log messages:
			V_TEMP_LOG_SOURCE DB_LOG_ENTRIES.LOG_SOURCE%TYPE;

			--variable to store the exception message:
			V_EXCEPTION_MSG VARCHAR2(2000);

			--variable to store the number of cruises that were successfully evaluated with the DVM
			V_SUCC_COUNTER PLS_INTEGER := 0;

			--variable to store the number of cruises that were not successfully evaluated with the DVM
			V_ERR_COUNTER PLS_INTEGER := 0;


		BEGIN

			--construct the DB_LOG_ENTRIES.LOG_SOURCE value for all logging messages in this procedure based on the procedure/function name and parameters:
			V_TEMP_LOG_SOURCE := 'CCD_DVM_PKG.BATCH_EXEC_DVM_CRUISE_SP ()';

	    DB_LOG_PKG.ADD_LOG_ENTRY('DEBUG', V_TEMP_LOG_SOURCE, 'running the CCD_DVM_PKG.BATCH_EXEC_DVM_CRUISE_SP() procedure', V_SP_RET_CODE);

			--query for CRUISE_ID values for all active data files:
			FOR rec IN (SELECT CRUISE_ID FROM CCD_CRUISES)

			--loop through each CRUISE_ID returned by the SELECT query to execute the CCD_DVM_PKG.EXEC_DVM_CRUISE_SP() procedure:
 			LOOP



				--run the validator procedure on the given data stream(s) and primary key value:
				EXEC_DVM_CRUISE_RC_SP(rec.CRUISE_ID, V_SP_RET_CODE, V_EXCEPTION_MSG);
				IF (V_SP_RET_CODE = 1) THEN
					--the DVM was executed successfully
					DB_LOG_PKG.ADD_LOG_ENTRY('DEBUG', V_TEMP_LOG_SOURCE, 'The current cruise record ('||rec.CRUISE_ID||') was validated successfully', V_SP_RET_CODE);

					--increment the success counter:
					V_SUCC_COUNTER := V_SUCC_COUNTER + 1;
				ELSE
					--the DVM was NOT executed successfully
					DB_LOG_PKG.ADD_LOG_ENTRY('ERROR', V_TEMP_LOG_SOURCE, 'The current cruise record ('||rec.CRUISE_ID||') was not validated successfully:'||chr(10)||V_EXCEPTION_MSG, V_SP_RET_CODE);


					--increment the error counter:
					V_ERR_COUNTER := V_ERR_COUNTER + 1;

				END IF;

			END LOOP;


			--provide a summary of how many were successfully evaluated and were not successfully evaluated
	    DB_LOG_PKG.ADD_LOG_ENTRY('INFO', V_TEMP_LOG_SOURCE, 'Out of '||(V_SUCC_COUNTER + V_ERR_COUNTER)||' total cruise records there were '||V_SUCC_COUNTER||' that were successfully processed and '||V_ERR_COUNTER||' that were unsuccessful', V_SP_RET_CODE);

	    DBMS_output.put_line('Out of '||(V_SUCC_COUNTER + V_ERR_COUNTER)||' total cruise records there were '||V_SUCC_COUNTER||' that were successfully processed and '||V_ERR_COUNTER||' that were unsuccessful');


      EXCEPTION

        --catch all PL/SQL database exceptions:

				WHEN NO_DATA_FOUND THEN
					--there are no cruise records retrieved by the

					--provide a summary of how many were successfully evaluated and were not successfully evaluated
			    DB_LOG_PKG.ADD_LOG_ENTRY('INFO', V_TEMP_LOG_SOURCE, 'There were no cruises returned by the batch DVM query, the DVM was not executed', V_SP_RET_CODE);

	    		DBMS_output.put_line('There were no cruises returned by the query, the DVM was not executed');

        WHEN OTHERS THEN
		  		--catch all other errors:

					--generate the exception message:
					V_EXCEPTION_MSG := 'The Batch DVM procedure did not complete successfully:'||chr(10)|| SQLERRM;

					--log the procedure processing error:
					DB_LOG_PKG.ADD_LOG_ENTRY ('ERROR', V_TEMP_LOG_SOURCE, V_EXCEPTION_MSG, V_SP_RET_CODE);

					--raise a custom application error:
					RAISE_APPLICATION_ERROR (-20506, V_EXCEPTION_MSG);

		END BATCH_EXEC_DVM_CRUISE_SP;

		--procedure that executes the DVM for a given CCD_CRUISES record (based on P_CRUISE_ID)
		--all error conditions will raise an application exception and will be logged in the database
		PROCEDURE EXEC_DVM_CRUISE_SP (P_CRUISE_ID IN NUMBER) IS

			--procedure variable to store the return codes from each procedure call to determine the results of the procedure execution
			V_SP_RET_CODE PLS_INTEGER;

			--array of varchar2 strings to define the data stream code(s) to be evaluated for the given parent record
	    V_DATA_STREAM_CODE DVM_PKG.VARCHAR_ARRAY_NUM;

			--variable to store the constructed log source string for the current procedure's log messages:
			V_TEMP_LOG_SOURCE DB_LOG_ENTRIES.LOG_SOURCE%TYPE;

			--variable to store the exception message:
			V_EXCEPTION_MSG VARCHAR2(2000);

			--exception for a blank CRUISE_ID parameter:
			EXC_BLANK_REQ_PARAMS EXCEPTION;

		BEGIN

			--construct the DB_LOG_ENTRIES.LOG_SOURCE value for all logging messages in this procedure based on the procedure/function name and parameters:
			V_TEMP_LOG_SOURCE := 'CCD_DVM_PKG.EXEC_DVM_CRUISE_SP (P_CRUISE_ID: '||P_CRUISE_ID||')';

	    DB_LOG_PKG.ADD_LOG_ENTRY('DEBUG', V_TEMP_LOG_SOURCE, 'running the CCD_DVM_PKG.EXEC_DVM_CRUISE_SP() procedure', V_SP_RET_CODE);

			--check if the P_CRUISE_ID parameter is blank
			IF (P_CRUISE_ID IS NULL) THEN
				--the P_CRUISE_ID parameter is blank

				--generate the exception message:
				V_EXCEPTION_MSG := 'The Cruise ID parameter was not specified';

				--log the processing error:
				DB_LOG_PKG.ADD_LOG_ENTRY ('ERROR', V_TEMP_LOG_SOURCE, V_EXCEPTION_MSG, V_SP_RET_CODE);

				--raise the defined exception:
				RAISE EXC_BLANK_REQ_PARAMS;


			END IF;


			--define the data stream codes for the given data stream (hard-coded due to RPL data stream):
			V_DATA_STREAM_CODE(1) := 'CCD';

      --run the validator procedure on the given data stream(s) and primary key value:
      DVM_PKG.VALIDATE_PARENT_RECORD_SP(V_DATA_STREAM_CODE, P_CRUISE_ID);

			--The parent record was evaluated successfully
    	DB_LOG_PKG.ADD_LOG_ENTRY('SUCCESS', V_TEMP_LOG_SOURCE, 'The DVM_PKG.VALIDATE_PARENT_RECORD() procedure was executed successfully', V_SP_RET_CODE);



      EXCEPTION

        --catch all PL/SQL database exceptions:

				WHEN EXC_BLANK_REQ_PARAMS THEN
					--The P_CRUISE_ID parameter was not defined

					--raise a custom application error:
					RAISE_APPLICATION_ERROR (-20507, V_EXCEPTION_MSG);

        WHEN OTHERS THEN
				  --catch all other errors:


					--generate the exception message:
					V_EXCEPTION_MSG := 'The Cruise could not be successfully processed by the DVM: '||chr(10)||SQLERRM;

					--log the processing error:
					DB_LOG_PKG.ADD_LOG_ENTRY ('ERROR', V_TEMP_LOG_SOURCE, V_EXCEPTION_MSG, V_SP_RET_CODE);

					--raise a custom application error:
					RAISE_APPLICATION_ERROR (-20508, V_EXCEPTION_MSG);


		END EXEC_DVM_CRUISE_SP;

		--procedure that executes the DVM for a given CCD_CRUISES record (based on P_CRUISE_NAME)
		--all error conditions will raise an application exception and will be logged in the database
		PROCEDURE EXEC_DVM_CRUISE_SP (P_CRUISE_NAME IN VARCHAR2) IS

			--procedure variable to store the return codes from each procedure call to determine the results of the procedure execution
			V_SP_RET_CODE PLS_INTEGER;

			--variable to store the CRUISE_ID for the specified P_CRUISE_NAME value
			V_CRUISE_ID PLS_INTEGER;

			--variable to store the constructed log source string for the current procedure's log messages:
			V_TEMP_LOG_SOURCE DB_LOG_ENTRIES.LOG_SOURCE%TYPE;

			--variable to store the exception message:
			V_EXCEPTION_MSG VARCHAR2(2000);

			--exception for blank cruise name:
			EXC_BLANK_REQ_PARAMS EXCEPTION;

		BEGIN

			--construct the DB_LOG_ENTRIES.LOG_SOURCE value for all logging messages in this procedure based on the procedure/function name and parameters:
			V_TEMP_LOG_SOURCE := 'CCD_DVM_PKG.EXEC_DVM_CRUISE_SP (P_CRUISE_NAME: '||P_CRUISE_NAME||')';

	    DB_LOG_PKG.ADD_LOG_ENTRY('DEBUG', V_TEMP_LOG_SOURCE, 'running the CCD_DVM_PKG.EXEC_DVM_CRUISE_SP() procedure', V_SP_RET_CODE);

			--check if the P_CRUISE_NAME parameter is blank
			IF (P_CRUISE_NAME IS NULL) THEN
				--the P_CRUISE_NAME parameter is blank

				--generate the exception message:
				V_EXCEPTION_MSG := 'The Cruise Name parameter was not specified';

				--log the processing error:
				DB_LOG_PKG.ADD_LOG_ENTRY ('ERROR', V_TEMP_LOG_SOURCE, V_EXCEPTION_MSG, V_SP_RET_CODE);

				--raise the defined exception:
				RAISE EXC_BLANK_REQ_PARAMS;


			END IF;


			--query for the cruise_id for the corresponding P_CRUISE_NAME value
			SELECT CRUISE_ID INTO V_CRUISE_ID FROM CCD_CRUISES WHERE UPPER(CRUISE_NAME) = UPPER(P_CRUISE_NAME);

			--run the validator procedure on the given primary key value:
			CCD_DVM_PKG.EXEC_DVM_CRUISE_SP(V_CRUISE_ID);

      EXCEPTION

				WHEN EXC_BLANK_REQ_PARAMS THEN
					--The P_CRUISE_NAME parameter was not defined

					--raise a custom application error:
					RAISE_APPLICATION_ERROR (-20507, V_EXCEPTION_MSG);

				WHEN NO_DATA_FOUND THEN
					--catch not matching cruise record error:

					--generate the exception message:
					V_EXCEPTION_MSG := 'A cruise record with a cruise name "'||P_CRUISE_NAME||'" could not be found in the database';

					--log the processing error:
			    DB_LOG_PKG.ADD_LOG_ENTRY('ERROR', V_TEMP_LOG_SOURCE, V_EXCEPTION_MSG, V_SP_RET_CODE);

					--raise a custom application error:
					RAISE_APPLICATION_ERROR (-20509, V_EXCEPTION_MSG);


        --catch all PL/SQL database exceptions:
        WHEN OTHERS THEN
				  --catch all other errors:

					--check to see if this is a general DVM processing error
					IF (SQLCODE = -20508) then
						--this is a general DVM processing error, raise the same exception since the error has already been logged

						--re raise the exception:
						RAISE;

					ELSE
						--this is not a general DVM processing error, raise the same exception since the error has already been logged

						--generate the exception message:
						V_EXCEPTION_MSG := 'The DVM_PKG.VALIDATE_PARENT_RECORD() procedure could not be successfully processed: '||chr(10)||SQLERRM;

						--log the processing error:
						DB_LOG_PKG.ADD_LOG_ENTRY ('ERROR', V_TEMP_LOG_SOURCE, V_EXCEPTION_MSG, V_SP_RET_CODE);

						--raise a custom application error:
						RAISE_APPLICATION_ERROR (-20508, V_EXCEPTION_MSG);

					END IF;

		END EXEC_DVM_CRUISE_SP;


		--procedure that executes the DVM for a given CCD_CRUISES record (based on P_CRUISE_ID) and returns a return code (P_SP_RET_CODE) with a value that indicates if the DVM executed successfully instead of raising an exception.  A P_SP_RET_CODE value of 1 indicates a successful execution and a value of 0 indicates it was not successful.  The P_EXC_MSG parameter will contain the exception message if the P_SP_RET_CODE indicates there was a processing error.  This procedure allows a PL/SQL block to continue even if the DVM has an exception
		PROCEDURE EXEC_DVM_CRUISE_RC_SP (P_CRUISE_ID IN NUMBER, P_SP_RET_CODE OUT PLS_INTEGER, P_EXC_MSG OUT VARCHAR2) IS

			--procedure variable to store the return codes from each procedure call to determine the results of the procedure execution
			V_SP_RET_CODE PLS_INTEGER;

			--variable to store the constructed log source string for the current procedure's log messages:
			V_TEMP_LOG_SOURCE DB_LOG_ENTRIES.LOG_SOURCE%TYPE;

		begin

			--construct the DB_LOG_ENTRIES.LOG_SOURCE value for all logging messages in this procedure based on the procedure/function name and parameters:
			V_TEMP_LOG_SOURCE := 'EXEC_DVM_CRUISE_RC_SP (P_CRUISE_ID: '||P_CRUISE_ID||')';

			--execute the DVM for the P_CRUISE_ID:
			EXEC_DVM_CRUISE_SP (P_CRUISE_ID);

			--if there was no exception then the procedure was successful:

			--set the successful return code:
			P_SP_RET_CODE := 1;


		EXCEPTION
			WHEN OTHERS THEN

				--set the exception message parameter to provide information about the processing error:
				P_EXC_MSG := SQLERRM;

				--set the errpr return code:
				P_SP_RET_CODE := 0;

				--log the processing error:
				DB_LOG_PKG.ADD_LOG_ENTRY ('ERROR', V_TEMP_LOG_SOURCE, SQLERRM, V_SP_RET_CODE);


		END EXEC_DVM_CRUISE_RC_SP;

		--procedure that executes the DVM for a given CCD_CRUISES record (based on P_CRUISE_NAME) and returns a return code (P_SP_RET_CODE) with a value that indicates if the DVM executed successfully instead of raising an exception.  A P_SP_RET_CODE value of 1 indicates a successful execution and a value of 0 indicates it was not successful.  The P_EXC_MSG parameter will contain the exception message if the P_SP_RET_CODE indicates there was a processing error.  This procedure allows a PL/SQL block to continue even if the DVM has an exception
		PROCEDURE EXEC_DVM_CRUISE_RC_SP (P_CRUISE_NAME IN VARCHAR2, P_SP_RET_CODE OUT PLS_INTEGER, P_EXC_MSG OUT VARCHAR2) IS

			--procedure variable to store the return codes from each procedure call to determine the results of the procedure execution
			V_SP_RET_CODE PLS_INTEGER;

			--variable to store the constructed log source string for the current procedure's log messages:
			V_TEMP_LOG_SOURCE DB_LOG_ENTRIES.LOG_SOURCE%TYPE;

		begin

			--construct the DB_LOG_ENTRIES.LOG_SOURCE value for all logging messages in this procedure based on the procedure/function name and parameters:
			V_TEMP_LOG_SOURCE := 'EXEC_DVM_CRUISE_RC_SP (P_CRUISE_NAME: '||P_CRUISE_NAME||')';

			--execute the DVM for the P_CRUISE_NAME:
			EXEC_DVM_CRUISE_SP (P_CRUISE_NAME);

			--if there was no exception then the procedure was successful:

			--set the successful return code:
			P_SP_RET_CODE := 1;


		EXCEPTION
			WHEN OTHERS THEN

				--set the exception message parameter to provide information about the processing error:
				P_EXC_MSG := SQLERRM;

				--set the error return code:
				P_SP_RET_CODE := 0;

				--log the processing error:
				DB_LOG_PKG.ADD_LOG_ENTRY ('ERROR', V_TEMP_LOG_SOURCE, SQLERRM, V_SP_RET_CODE);


		END EXEC_DVM_CRUISE_RC_SP;




		--procedure that executes the DVM for a given CCD_CRUISES record (based on P_CRUISE_ID) by calling the EXEC_DVM_CRUISE_SP on the P_CRUISE_ID and then calling EXEC_DVM_CRUISE_SP on each of the records that is related to the P_CRUISE_ID via the CCD_QC_LEG_OVERLAP_V QC view so that the overlapping leg errors can be associated with the matching cruises from the CCD_QC_LEG_OVERLAP_V QC view.
		--all error conditions will raise an application exception and will be logged in the database
		PROCEDURE EXEC_DVM_CRUISE_OVERLAP_SP (P_CRUISE_ID IN NUMBER) IS

			--variable to store the return code from procedure calls:
			V_SP_RET_CODE PLS_INTEGER;

			--this variable will track if the duplicate casts have had the DVM package executed successfully so the value of P_SP_RET_CODE can be set
			V_SUCC_EXEC BOOLEAN := true;

			--variable to store the constructed log source string for the current procedure's log messages:
			V_TEMP_LOG_SOURCE DB_LOG_ENTRIES.LOG_SOURCE%TYPE;

			--variable to store the exception message:
			V_EXCEPTION_MSG VARCHAR2(2000);

			--exception for a blank CRUISE_ID parameter:
			EXC_BLANK_REQ_PARAMS EXCEPTION;

		BEGIN

			--construct the DB_LOG_ENTRIES.LOG_SOURCE value for all logging messages in this procedure based on the procedure/function name and parameters:
			V_TEMP_LOG_SOURCE := 'CCD_DVM_PKG.EXEC_DVM_CRUISE_OVERLAP_SP (P_CRUISE_ID: '||P_CRUISE_ID||')';

	    DB_LOG_PKG.ADD_LOG_ENTRY('DEBUG', V_TEMP_LOG_SOURCE, 'running the CCD_DVM_PKG.EXEC_DVM_CRUISE_OVERLAP_SP() procedure', V_SP_RET_CODE);


			--check if the P_CRUISE_ID parameter is blank
			IF (P_CRUISE_ID IS NULL) THEN
				--the P_CRUISE_ID parameter is blank

				--generate the exception message:
				V_EXCEPTION_MSG := 'The Cruise ID parameter was not specified';

				--log the processing error:
				DB_LOG_PKG.ADD_LOG_ENTRY ('ERROR', V_TEMP_LOG_SOURCE, V_EXCEPTION_MSG, V_SP_RET_CODE);

				--raise the defined exception:
				RAISE EXC_BLANK_REQ_PARAMS;


			END IF;




			--set the rollback save point so that the entire procedure's effects can be rolled back if the procedure can't be successfully executed:
			SAVEPOINT DVM_CRUISE_REC;


	    DB_LOG_PKG.ADD_LOG_ENTRY('DEBUG', V_TEMP_LOG_SOURCE, 'running the CCD_DVM_PKG.EXEC_DVM_CRUISE_SP('||P_CRUISE_ID||') procedure', V_SP_RET_CODE);

			--execute the DVM on the specified cruise record
			CCD_DVM_PKG.EXEC_DVM_CRUISE_SP(P_CRUISE_ID);

			--the DVM execution was successful:

	    DB_LOG_PKG.ADD_LOG_ENTRY('DEBUG', V_TEMP_LOG_SOURCE, 'The CCD_DVM_PKG.EXEC_DVM_CRUISE_SP('||P_CRUISE_ID||') was successful, query for the other data files related by the CCD_QC_DUP_CASTS_V view', V_SP_RET_CODE);

			--query for any leg/vessel overlap for the specified cruise (do not revalidate the same cruise if there is an overlap with another associated cruise leg since the initial execution will identify those validation issues)
			FOR rec IN (SELECT CRUISE_ID FROM CCD_QC_LEG_OVERLAP_V WHERE CRUISE_ID2 = P_CRUISE_ID AND CRUISE_ID <> P_CRUISE_ID)
			--loop through each CRUISE_ID returned by the SELECT query to execute the CCD_DVM_PKG.EXEC_DVM_CRUISE_SP() procedure:
			LOOP

				--execute the CCD_DVM_PKG.EXEC_DVM_CRUISE_SP() procedure on the current rec.CRUISE_ID value:
		    DB_LOG_PKG.ADD_LOG_ENTRY('DEBUG', V_TEMP_LOG_SOURCE, 'execute the CCD_DVM_PKG.EXEC_DVM_CRUISE_SP('||rec.CRUISE_ID||') procedure on the overlapping cruise', V_SP_RET_CODE);

				CCD_DVM_PKG.EXEC_DVM_CRUISE_SP(rec.CRUISE_ID);

				--the DVM was successful:

				--log the successful execution:
		    DB_LOG_PKG.ADD_LOG_ENTRY('DEBUG', V_TEMP_LOG_SOURCE, 'The CCD_DVM_PKG.EXEC_DVM_CRUISE_SP('||rec.CRUISE_ID||') procedure was successful', V_SP_RET_CODE);

			END LOOP;


			--if there are no execptions it indicate the procedure was successful:
			DB_LOG_PKG.ADD_LOG_ENTRY('SUCCESS', V_TEMP_LOG_SOURCE, 'EXEC_DVM_CRUISE_OVERLAP_SP('||P_CRUISE_ID||') was completed successfully', V_SP_RET_CODE);



			EXCEPTION
        --catch all PL/SQL database exceptions:

				WHEN EXC_BLANK_REQ_PARAMS THEN
					--The P_CRUISE_ID parameter was not defined

					--raise a custom application error:
					RAISE_APPLICATION_ERROR (-20510, V_EXCEPTION_MSG);

        WHEN OTHERS THEN
				  --catch all other errors:


					--rollback all of the DML that was executed in the procedure since one of the DVM executions failed:
					ROLLBACK TO SAVEPOINT DVM_CRUISE_REC;

					--generate the exception message:
					V_EXCEPTION_MSG := 'The DVM procedure could not be successfully processed for the cruise(s): '||chr(10)||SQLERRM;

					--log the processing error:
					DB_LOG_PKG.ADD_LOG_ENTRY ('ERROR', V_TEMP_LOG_SOURCE, V_EXCEPTION_MSG, V_SP_RET_CODE);

					--raise a custom application error:
					RAISE_APPLICATION_ERROR (-20511, V_EXCEPTION_MSG);

		END EXEC_DVM_CRUISE_OVERLAP_SP;



		--procedure that executes the DVM for a given CCD_CRUISES record (based on P_CRUISE_NAME) by calling the EXEC_DVM_CRUISE_SP on the corresponding CRUISE_ID and then calling EXEC_DVM_CRUISE_SP on each of the records that is related to the CRUISE_ID via the CCD_QC_LEG_OVERLAP_V QC view so that the overlapping leg errors can be associated with the matching cruises from the CCD_QC_LEG_OVERLAP_V QC view.
		--all error conditions will raise an application exception and will be logged in the database
		PROCEDURE EXEC_DVM_CRUISE_OVERLAP_SP (P_CRUISE_NAME IN VARCHAR2) IS

			--procedure variable to store the return codes from each procedure call to determine the results of the procedure execution
			V_SP_RET_CODE PLS_INTEGER;

			--variable to store the CRUISE_ID for the specified P_CRUISE_NAME value
			V_CRUISE_ID PLS_INTEGER;

			--variable to store the constructed log source string for the current procedure's log messages:
			V_TEMP_LOG_SOURCE DB_LOG_ENTRIES.LOG_SOURCE%TYPE;

			--variable to store the exception message:
			V_EXCEPTION_MSG VARCHAR2(2000);

			--exception for blank cruise name:
			EXC_BLANK_REQ_PARAMS EXCEPTION;

		BEGIN

			--construct the DB_LOG_ENTRIES.LOG_SOURCE value for all logging messages in this procedure based on the procedure/function name and parameters:
			V_TEMP_LOG_SOURCE := 'CCD_DVM_PKG.EXEC_DVM_CRUISE_OVERLAP_SP (P_CRUISE_NAME: '||P_CRUISE_NAME||')';

	    DB_LOG_PKG.ADD_LOG_ENTRY('DEBUG', V_TEMP_LOG_SOURCE, 'running the CCD_DVM_PKG.EXEC_DVM_CRUISE_OVERLAP_SP() procedure', V_SP_RET_CODE);


			--check if the P_CRUISE_NAME parameter is blank
			IF (P_CRUISE_NAME IS NULL) THEN
				--the P_CRUISE_NAME parameter is blank

				--generate the exception message:
				V_EXCEPTION_MSG := 'The Cruise Name parameter was not specified';

				--log the processing error:
				DB_LOG_PKG.ADD_LOG_ENTRY ('ERROR', V_TEMP_LOG_SOURCE, V_EXCEPTION_MSG, V_SP_RET_CODE);

				--raise the defined exception:
				RAISE EXC_BLANK_REQ_PARAMS;


			END IF;


			--query for the cruise_id for the corresponding P_CRUISE_NAME value
			SELECT CRUISE_ID INTO V_CRUISE_ID FROM CCD_CRUISES WHERE UPPER(CRUISE_NAME) = UPPER(P_CRUISE_NAME);

			--run the validator procedure on the given primary key value:
			CCD_DVM_PKG.EXEC_DVM_CRUISE_OVERLAP_SP(V_CRUISE_ID);



      EXCEPTION
        --catch all PL/SQL database exceptions:

				WHEN EXC_BLANK_REQ_PARAMS THEN
					--The P_CRUISE_NAME parameter was not defined

					--raise a custom application error:
					RAISE_APPLICATION_ERROR (-20510, V_EXCEPTION_MSG);

				WHEN NO_DATA_FOUND THEN
					--catch not matching cruise record error:


					--generate the exception message:
					V_EXCEPTION_MSG := 'A cruise record with a cruise name "'||P_CRUISE_NAME||'" could not be found in the database';

					--log the processing error:
			    DB_LOG_PKG.ADD_LOG_ENTRY('ERROR', V_TEMP_LOG_SOURCE, V_EXCEPTION_MSG, V_SP_RET_CODE);

					--raise a custom application error:
					RAISE_APPLICATION_ERROR (-20512, V_EXCEPTION_MSG);

        WHEN OTHERS THEN
				  --catch all other errors:


					--check to see if this is a general DVM processing error
					IF (SQLCODE = -20511) then
						--this is a general DVM processing error, raise the same exception since the error has already been logged

						--re raise the exception:
						RAISE;

					ELSE


						--generate the exception message:
						V_EXCEPTION_MSG := 'The DVM procedure could not be successfully processed for the cruise(s): '||chr(10)||SQLERRM;

						--log the processing error:
						DB_LOG_PKG.ADD_LOG_ENTRY ('ERROR', V_TEMP_LOG_SOURCE, V_EXCEPTION_MSG, V_SP_RET_CODE);

						--raise a custom application error:
						RAISE_APPLICATION_ERROR (-20511, V_EXCEPTION_MSG);
					END IF;

		END EXEC_DVM_CRUISE_OVERLAP_SP;

		--this procedure deletes a given cruise leg (identified by P_CRUISE_LEG_ID) and re-evaluates the DVM for all cruises that overlapped (using CCD_QC_LEG_OVERLAP_V) with the deleted cruise leg's cruise to ensure those cruise DVM records are up to date.  If there is a processing error the transaction will be rolled back to the state before the procedure was executed.
		--all error conditions will raise an application exception and will be logged in the database
		PROCEDURE DELETE_LEG_OVERLAP_SP (P_CRUISE_LEG_ID IN PLS_INTEGER)

		IS
			--procedure variable to store the return codes from each procedure call to determine the results of the procedure execution
			V_SP_RET_CODE PLS_INTEGER;

			--variable to store the constructed log source string for the current procedure's log messages:
			V_TEMP_LOG_SOURCE DB_LOG_ENTRIES.LOG_SOURCE%TYPE;

			--variable to store the exception message:
			V_EXCEPTION_MSG VARCHAR2(2000);

			--exception for blank required parameters:
			EXC_BLANK_PARAMS EXCEPTION;

			--array variable to store the Cruise ID values of all cruises that overlap with the specified cruise so they can have the DVM re-evaluated after the cruise is deleted
	    V_OVERLAP_CRUISE_IDS apex_application_global.vc_arr2;

			--variable to store the number of cruises that overlap with the specific cruise:
			V_NUM_OVERLAP PLS_INTEGER;

			--variable to store the specified cruise leg's name:
			V_LEG_NAME CCD_CRUISE_LEGS.LEG_NAME%TYPE;

			--variable to store the specified cruise leg's name:
			V_CRUISE_NAME CCD_CRUISES.CRUISE_NAME%TYPE;

			--variable to store the associated cruise ID for the specified cruise leg:
			V_CRUISE_ID NUMBER;

		begin

			--set the rollback save point so that the entire procedure's effects can be rolled back if the procedure can't be successfully executed:
			SAVEPOINT DEL_LEG_SAVEPOINT;

			--construct the DB_LOG_ENTRIES.LOG_SOURCE value for all logging messages in this procedure based on the procedure/function name and parameters:
			V_TEMP_LOG_SOURCE := 'DELETE_LEG_OVERLAP_SP (P_CRUISE_LEG_ID: '||P_CRUISE_LEG_ID||')';

	    DB_LOG_PKG.ADD_LOG_ENTRY('DEBUG', V_TEMP_LOG_SOURCE, 'running DELETE_LEG_OVERLAP_SP ()', V_SP_RET_CODE);

			IF (P_CRUISE_LEG_ID IS NULL) THEN
				--the P_CRUISE_LEG_ID parameter is blank, raise an exception:

				--generate the exception message:
				V_EXCEPTION_MSG := 'The Cruise Leg ID parameter was not specified';

				--log the processing error:
				DB_LOG_PKG.ADD_LOG_ENTRY ('ERROR', V_TEMP_LOG_SOURCE, V_EXCEPTION_MSG, V_SP_RET_CODE);

				--raise the blank parameter exception:
				RAISE EXC_BLANK_PARAMS;

			END IF;

			--query for the cruise ID and store the cruise name in V_CRUISE_NAME
			SELECT CRUISE_ID, LEG_NAME, CRUISE_NAME INTO V_CRUISE_ID, V_LEG_NAME, V_CRUISE_NAME FROM CCD_CRUISE_LEGS_V WHERE CRUISE_LEG_ID = P_CRUISE_LEG_ID;

			--query to see if there are any overlapping cruise IDs:
			SELECT COUNT(*) INTO V_NUM_OVERLAP
			FROM
			(
				SELECT DISTINCT CRUISE_ID FROM CCD_QC_LEG_OVERLAP_V WHERE CRUISE_ID2 = V_CRUISE_ID AND CRUISE_ID <> V_CRUISE_ID
			);

			DB_LOG_PKG.ADD_LOG_ENTRY ('DEBUG', V_TEMP_LOG_SOURCE, 'There are '||V_NUM_OVERLAP||' cruise records that overlap with the specified cruise', V_SP_RET_CODE);


			--check if there are one or more overlapping cruises:
			IF (V_NUM_OVERLAP > 0) THEN
				--there is at least one overlapping cruise:

		    --query for any leg/vessel overlap for the specified cruise (do not revalidate the same cruise if there is an overlap with another associated cruise leg since the initial execution will identify those validation issues)
		    FOR rec IN (SELECT DISTINCT CRUISE_ID FROM CCD_QC_LEG_OVERLAP_V WHERE CRUISE_ID2 = V_CRUISE_ID AND CRUISE_ID <> V_CRUISE_ID)

		    --loop through each CRUISE_ID returned by the SELECT query so these overlapping cruise IDs can be re-evaluated by the DVM after the cruise leg is updated:
		    LOOP
		        V_OVERLAP_CRUISE_IDS(V_OVERLAP_CRUISE_IDS.COUNT + 1) :=  rec.CRUISE_ID;
		    END LOOP;

			END IF;

			--delete the cruise from the DB:
			DELETE FROM CCD_CRUISE_LEGS WHERE CRUISE_LEG_ID = P_CRUISE_LEG_ID;

	    --loop through the overlapping cruise IDs and re-evaluate them:
	    for i in 1..V_OVERLAP_CRUISE_IDS.count
	    loop
	      DB_LOG_PKG.ADD_LOG_ENTRY ('DEBUG', V_TEMP_LOG_SOURCE, 'Run the DVM on the CRUISE_ID: '||V_OVERLAP_CRUISE_IDS(i), V_SP_RET_CODE);

	      --execute the DVM on the current cruise:
	      CCD_DVM_PKG.EXEC_DVM_CRUISE_SP (TO_NUMBER(V_OVERLAP_CRUISE_IDS(i)));

				--the DVM executed successfully:
        DB_LOG_PKG.ADD_LOG_ENTRY ('DEBUG', V_TEMP_LOG_SOURCE, 'The DVM was successfully executed', V_SP_RET_CODE);


	    end loop;


			--re-evaluate the cruise for the deleted cruise leg:
      CCD_DVM_PKG.EXEC_DVM_CRUISE_SP (V_CRUISE_ID);

			--the DVM was successfully executed on the deleted cruise leg's associated cruise

			--log the processing error:
      DB_LOG_PKG.ADD_LOG_ENTRY ('DEBUG', V_TEMP_LOG_SOURCE, 'the DVM was successfully executed on the deleted cruise leg''s associated cruise', V_SP_RET_CODE);


		EXCEPTION
	    --catch all PL/SQL database exceptions:

			WHEN EXC_BLANK_PARAMS then
				--blank CRUISE_LEG_ID parameter:

				--rollback all of the DML that was executed in the procedure since the procedure failed:
--				ROLLBACK TO SAVEPOINT DEL_LEG_SAVEPOINT;


				--raise a custom application error:
				RAISE_APPLICATION_ERROR (-20501, V_EXCEPTION_MSG);

			WHEN NO_DATA_FOUND THEN
				--no records were returned by the query:

				--construct the exception message:
				V_EXCEPTION_MSG := 'The cruise leg record was not found in the database';

				--log the processing error
				DB_LOG_PKG.ADD_LOG_ENTRY ('ERROR', V_TEMP_LOG_SOURCE, V_EXCEPTION_MSG, V_SP_RET_CODE);

				--rollback all of the DML that was executed in the procedure since the procedure failed:
				ROLLBACK TO SAVEPOINT DEL_LEG_SAVEPOINT;


				--raise a custom application error:
				RAISE_APPLICATION_ERROR (-20502, V_EXCEPTION_MSG);

	    WHEN OTHERS THEN
	  		--catch all other errors:

				--check if there was a foreign key constraint violation when the cruise leg deletion was attempted
				IF (SQLCODE = -2292) THEN
					--this is a foreign key constraint error

					--generate the exception message:
					V_EXCEPTION_MSG := 'One or more child records exist for the cruise leg record, you must delete them before you can delete the cruise leg';

					--log the procedure processing error:
					DB_LOG_PKG.ADD_LOG_ENTRY ('ERROR', V_TEMP_LOG_SOURCE, V_EXCEPTION_MSG, V_SP_RET_CODE);

					--rollback all of the DML that was executed in the procedure since the procedure failed:
					ROLLBACK TO SAVEPOINT DEL_LEG_SAVEPOINT;

					--raise a custom application error:
					RAISE_APPLICATION_ERROR (-20505, V_EXCEPTION_MSG);

				ELSIF (SQLCODE = -20512) THEN
					--This was a Cruise DVM Overlap Procesing Error:

					--generate the exception message:
					V_EXCEPTION_MSG := 'The specified Cruise or overlapping Cruise could not be validated using the DVM:'||chr(10)||SQLERRM;

					--there was an error processing the current cruise leg's aliases
					DB_LOG_PKG.ADD_LOG_ENTRY('ERROR', V_TEMP_LOG_SOURCE, V_EXCEPTION_MSG, V_SP_RET_CODE);

					--rollback all of the DML that was executed in the procedure since the procedure failed:
					ROLLBACK TO SAVEPOINT DEL_LEG_SAVEPOINT;

					--raise a custom application error:
					RAISE_APPLICATION_ERROR (-20503, V_EXCEPTION_MSG);



				ELSE
					--this is a PL/SQL processing error

					--generate the exception message:
					V_EXCEPTION_MSG := 'The cruise leg record deletion could not be processed successfully:'||chr(10)|| SQLERRM;

					--log the procedure processing error:
					DB_LOG_PKG.ADD_LOG_ENTRY ('ERROR', V_TEMP_LOG_SOURCE, V_EXCEPTION_MSG, V_SP_RET_CODE);

					--rollback all of the DML that was executed in the procedure since the procedure failed:
					ROLLBACK TO SAVEPOINT DEL_LEG_SAVEPOINT;

					--raise a custom application error:
					RAISE_APPLICATION_ERROR (-20504, V_EXCEPTION_MSG);
				END IF;

		END DELETE_LEG_OVERLAP_SP;

		--this procedure deletes a given cruise leg (identified by P_LEG_NAME) and re-evaluates the DVM for all cruises that overlapped (using CCD_QC_LEG_OVERLAP_V) with the deleted cruise leg's cruise to ensure those cruise DVM records are up to date.  If there is a processing error the transaction will be rolled back to the state before the procedure was executed.
		--all error conditions will raise an application exception and will be logged in the database
		PROCEDURE DELETE_LEG_OVERLAP_SP (P_LEG_NAME IN VARCHAR2) IS

			--procedure variable to store the return codes from each procedure call to determine the results of the procedure execution
			V_SP_RET_CODE PLS_INTEGER;

			--variable to store the CRUISE_LEG_ID for the specified P_LEG_NAME value
			V_CRUISE_LEG_ID PLS_INTEGER;

			--variable to store the constructed log source string for the current procedure's log messages:
			V_TEMP_LOG_SOURCE DB_LOG_ENTRIES.LOG_SOURCE%TYPE;

			--variable to store the exception message:
			V_EXCEPTION_MSG VARCHAR2(2000);

			--exception for blank leg name:
			EXC_BLANK_LEG_NAME EXCEPTION;

		BEGIN

			--construct the DB_LOG_ENTRIES.LOG_SOURCE value for all logging messages in this procedure based on the procedure/function name and parameters:
			V_TEMP_LOG_SOURCE := 'DELETE_LEG_OVERLAP_SP (P_LEG_NAME: '||P_LEG_NAME||')';

	    DB_LOG_PKG.ADD_LOG_ENTRY('DEBUG', V_TEMP_LOG_SOURCE, 'running DELETE_LEG_OVERLAP_SP ()', V_SP_RET_CODE);


			--check if the P_LEG_NAME parameter is blank
			IF (P_LEG_NAME IS NULL) THEN
				--the P_LEG_NAME parameter is blank

				--generate the exception message:
				V_EXCEPTION_MSG := 'The Leg Name parameter was not specified';

				--log the processing error:
				DB_LOG_PKG.ADD_LOG_ENTRY ('ERROR', V_TEMP_LOG_SOURCE, V_EXCEPTION_MSG, V_SP_RET_CODE);

				--raise the defined exception:
				RAISE EXC_BLANK_LEG_NAME;


			END IF;


			--query for the cruise_leg_id for the corresponding P_LEG_NAME value
			SELECT CRUISE_LEG_ID INTO V_CRUISE_LEG_ID FROM CCD_CRUISE_LEGS WHERE UPPER(LEG_NAME) = UPPER(P_LEG_NAME);

			--delete the cruise leg and evaluate the DVM on the associated cruise and any previosuly overlapping cruises:
			DELETE_LEG_OVERLAP_SP(V_CRUISE_LEG_ID);



      EXCEPTION
        --catch all PL/SQL database exceptions:

				WHEN EXC_BLANK_LEG_NAME then
					--blank LEG_NAME parameter:

					--raise a custom application error:
					RAISE_APPLICATION_ERROR (-20501, V_EXCEPTION_MSG);


				WHEN NO_DATA_FOUND THEN
					--catch not matching cruise leg record error:


					--generate the exception message:
					V_EXCEPTION_MSG := 'A cruise leg record with a name "'||P_LEG_NAME||'" could not be found in the database';

					--log the processing error:
			    DB_LOG_PKG.ADD_LOG_ENTRY('ERROR', V_TEMP_LOG_SOURCE, V_EXCEPTION_MSG, V_SP_RET_CODE);

					--raise a custom application error:
					RAISE_APPLICATION_ERROR (-20502, V_EXCEPTION_MSG);

        WHEN OTHERS THEN
				  --catch all other errors:

					--check if there are any special exceptions for the DELETE_LEG_OVERLAP_SP (P_CRUISE_LEG_ID) procedure
					IF (SQLCODE IN (-20503, -20504, -20505)) THEN
						--this is a special exception from the DELETE_LEG_OVERLAP_SP (P_CRUISE_LEG_ID) procedure

						--re raise the exception:
						RAISE;

					ELSE


						--generate the exception message:
						V_EXCEPTION_MSG := 'The specific Cruise Leg could not be deleted and along with any previously overlapping cruises re-validated successfully: '||chr(10)||SQLERRM;

						--log the processing error:
						DB_LOG_PKG.ADD_LOG_ENTRY ('ERROR', V_TEMP_LOG_SOURCE, V_EXCEPTION_MSG, V_SP_RET_CODE);

						--raise a custom application error:
						RAISE_APPLICATION_ERROR (-20504, V_EXCEPTION_MSG);
					END IF;

		END DELETE_LEG_OVERLAP_SP;



	end CCD_DVM_PKG;
	/



	--CCD_CRUISE_PKG Package Specification:
	CREATE OR REPLACE PACKAGE CCD_CRUISE_PKG
	AUTHID DEFINER
	--this package provides functions and procedures to interact with the Cruise package module

	AS

		--function that accepts a P_LEG_ALIAS value and returns the CRUISE_LEG_ID value for the CCD_CRUISE_LEGS record that has a corresponding CCD_LEG_ALIASES record with a LEG_ALIAS_NAME that matches the P_LEG_ALIAS value.  It returns NULL if no match is found
		FUNCTION LEG_ALIAS_TO_CRUISE_LEG_ID_FN (P_LEG_ALIAS VARCHAR2) RETURN NUMBER;

	  --Append Reference Preset Options function
	  --function that accepts a list of colon-delimited integers (P_DELIM_VALUES) representing the primary key values of the given reference table preset options.  The P_OPTS_QUERY is the query for the primary key values for the given options query with a primary key parameter that will be used with the defined primary key value (P_PK_VAL) when executing the query to return the associated primary key values.  The return value will be the colon-delimited string that contains any additional primary key values that were returned by the P_OPTS_QUERY
	  FUNCTION APPEND_REF_PRE_OPTS_FN (P_DELIM_VALUES IN VARCHAR2, P_OPTS_QUERY IN VARCHAR2, P_PK_VAL IN NUMBER) RETURN VARCHAR2;


		--Deep copy cruise stored procedure:
		--This procedure accepts a P_CRUISE_ID parameter that contains the CRUISE_ID primary key integer value that will have all of its associated records copied (cruise name, leg names, and leg alias names will be copied with a naming convention but all other associated records will be loaded as-is to the new cruise record).  The value of P_SP_RET_CODE is 1 if the cruise record was successfully processed and the records were copied and 0 if the procedure encountered any errors during execution, if there were errors the SQL transaction will be rolled back.  P_PROC_RETURN_MSG will contain a message to indicate that the procedure was completed successfully or unsuccessfully with information about the results so they can be provided to the user.  P_PROC_RETURN_CRUISE_ID contains the CRUISE_ID for the newly inserted cruise record so it can be provided to the user, in the APEX application it is used to construct a URL to allow an authorized user to view/edit the newly copied cruise record
		--all error conditions will raise an application exception and will be logged in the database
		--Example usage:
		/*
		set serveroutput on;
		DECLARE
			    V_PROC_RETURN_CODE PLS_INTEGER;
	        V_PROC_RETURN_MSG VARCHAR2(4000);
			    V_PROC_RETURN_CRUISE_ID PLS_INTEGER;

		 			V_CRUISE_ID NUMBER := 123;
			BEGIN

		        --execute the deep copy procedure:
			    CEN_CRUISE.CCD_CRUISE_PKG.DEEP_COPY_CRUISE_SP(V_CRUISE_ID, V_PROC_RETURN_CODE, V_PROC_RETURN_MSG, V_PROC_RETURN_CRUISE_ID);

					DBMS_OUTPUT.PUT_LINE ('The value of V_PROC_RETURN_CODE is: '||V_PROC_RETURN_CODE);

					DBMS_OUTPUT.PUT_LINE (V_PROC_RETURN_MSG);

					DBMS_OUTPUT.PUT_LINE ('The deep copy was successful');

					EXCEPTION
						WHEN OTHERS THEN
							DBMS_OUTPUT.PUT_LINE(SQLERRM);

			        DBMS_OUTPUT.PUT_LINE('The deep copy was NOT successful');
			END;
		*/
		PROCEDURE DEEP_COPY_CRUISE_SP (P_CRUISE_ID IN PLS_INTEGER, P_SP_RET_CODE OUT PLS_INTEGER, P_PROC_RETURN_MSG OUT VARCHAR2, P_PROC_RETURN_CRUISE_ID OUT PLS_INTEGER);



		--Deep copy cruise stored procedure:
		--This procedure accepts a P_CRUISE_NAME parameter that contains the unique CRUISE_NAME value that will have all of its associated records copied (cruise name, leg names, and leg alias names will be copied with a naming convention but all other associated records will be loaded as-is to the new cruise record).  The value of P_SP_RET_CODE is 1 if the cruise record was successfully processed and the records were copied and 0 if the procedure encountered any errors during execution, if there were errors the SQL transaction will be rolled back.  P_PROC_RETURN_MSG will contain a message to indicate that the procedure was completed successfully or unsuccessfully with information about the results so they can be provided to the user.  P_PROC_RETURN_CRUISE_ID contains the CRUISE_ID for the newly inserted cruise record so it can be provided to the user, in the APEX application it is used to construct a URL to allow an authorized user to view/edit the newly copied cruise record
		--all error conditions will raise an application exception and will be logged in the database
		--Example usage:
		/*
		set serveroutput on;
		DECLARE
			 V_SP_RET_CODE PLS_INTEGER;
			 V_PROC_RETURN_MSG VARCHAR2(4000);
			 V_PROC_RETURN_CRUISE_ID PLS_INTEGER;

			 V_CRUISE_NAME VARCHAR2 (1000) := 'XYZ-789';

		BEGIN


				--execute the deep copy procedure:
			 CEN_CRUISE.CCD_CRUISE_PKG.DEEP_COPY_CRUISE_SP(V_CRUISE_NAME, V_SP_RET_CODE, V_PROC_RETURN_MSG, V_PROC_RETURN_CRUISE_ID);


			 DBMS_output.put_line('The deep copy was successful');

			 DBMS_OUTPUT.PUT_LINE(V_PROC_RETURN_MSG);


			 EXCEPTION

				 WHEN OTHERS THEN


					 DBMS_OUTPUT.PUT_LINE('The deep copy was NOT successful');

					 DBMS_OUTPUT.PUT_LINE(V_PROC_RETURN_MSG);

					 DBMS_OUTPUT.PUT_LINE(SQLERRM);

		END;
		*/
		PROCEDURE DEEP_COPY_CRUISE_SP (P_CRUISE_NAME IN VARCHAR2, P_SP_RET_CODE OUT PLS_INTEGER, P_PROC_RETURN_MSG OUT VARCHAR2, P_PROC_RETURN_CRUISE_ID OUT PLS_INTEGER);


		--procedure to copy all associated cruise values (e.g. CCD_CRUISE_EXP_SPP) from the source cruise (P_SOURCE_CRUISE_ID) to the new cruise (P_NEW_CRUISE_ID) utilizing the COPY_ASSOC_VALS_SP procedure to actually copy the attribute records, the list of static tables are used as a parameter in addition to the foreign key field name for the CCD_CRUISES table.
		--all error conditions will raise an application exception and will be logged in the database
		PROCEDURE COPY_ASSOC_CRUISE_VALS_SP (P_SOURCE_CRUISE_ID IN PLS_INTEGER, P_NEW_CRUISE_ID IN PLS_INTEGER);

		--procedure to copy all associated cruise leg values (e.g.CCD_LEG_GEAR) from the source cruise (P_SOURCE_CRUISE_LEG_ID) to the new cruise (P_NEW_CRUISE_LEG_ID) utilizing the COPY_ASSOC_VALS_SP procedure to actually copy the attribute records, the list of static tables are used as a parameter in addition to the foreign key field name for the CCD_CRUISE_LEGS table.
		--all error conditions will raise an application exception and will be logged in the database
		PROCEDURE COPY_ASSOC_LEG_VALS_SP (P_SOURCE_CRUISE_LEG_ID IN PLS_INTEGER, P_NEW_CRUISE_LEG_ID IN PLS_INTEGER);

		--procedure to copy all values associated with the given source cruise/cruise leg (based on P_PK_FIELD_NAME and P_SOURCE_ID) for the specified tables (P_TABLE_LIST array) and associate them with the new cruise/cruise leg (based on P_NEW_ID).
		--all error conditions will raise an application exception and will be logged in the database
		PROCEDURE COPY_ASSOC_VALS_SP (P_TABLE_LIST IN apex_application_global.vc_arr2, P_PK_FIELD_NAME IN VARCHAR2, P_SOURCE_ID IN PLS_INTEGER, P_NEW_ID IN PLS_INTEGER);

		--this procedure copies all leg aliases from the cruise leg with CRUISE_LEG_ID = P_SOURCE_LEG_ID to a newly inserted cruise leg with CRUISE_LEG_ID = P_NEW_LEG_ID modifying each leg alias to append (copy) to it.  The value of P_SP_RET_CODE will be 1 if the procedure successfully processed the leg aliases from the given source leg to the new leg and 0 if it was not, if it was unsuccessful the SQL transaction will be rolled back.  The procedure checks for unique key constraint violations and reports any error message using the P_PROC_RETURN_MSG parameter
		--all error conditions will raise an application exception and will be logged in the database
		PROCEDURE COPY_LEG_ALIASES_SP (P_SOURCE_LEG_ID IN PLS_INTEGER, P_NEW_LEG_ID IN PLS_INTEGER, P_PROC_RETURN_MSG OUT VARCHAR2);



	END CCD_CRUISE_PKG;
	/

	--CCD_CRUISE_PKG Package Body:
	create or replace PACKAGE BODY CCD_CRUISE_PKG
	--this package provides functions and procedures to interact with the CTD package module
	IS

		--package variable to store the original procedure arguments for a given CCD_DVM_PKG execution so it can be added to a standard DB Logging module entry
		PV_LOG_MSG_HEADER DB_LOG_ENTRIES.LOG_SOURCE%TYPE;





		--function that accepts a P_LEG_ALIAS value and returns the CRUISE_LEG_ID value for the CCD_CRUISE_LEGS record that has a corresponding CCD_LEG_ALIASES record with a LEG_ALIAS_NAME that matches the P_LEG_ALIAS value.  It returns NULL if no match is found
		FUNCTION LEG_ALIAS_TO_CRUISE_LEG_ID_FN (P_LEG_ALIAS VARCHAR2)
			RETURN NUMBER is

						--variable to store the cruise_leg_id associated with the leg alias record with leg_alias_name = P_LEG_ALIAS
						v_cruise_leg_id NUMBER;

						--return code from procedure calls
						V_SP_RET_CODE PLS_INTEGER;

		BEGIN

				--query for the cruise_leg_id primary key value from the cruise leg that matches any associated leg aliases
        select ccd_cruise_legs_v.cruise_leg_id into v_cruise_leg_id
        from ccd_cruise_legs_v inner join ccd_leg_aliases on ccd_leg_aliases.cruise_leg_id = ccd_cruise_legs_v.cruise_leg_id
        AND UPPER(ccd_leg_aliases.LEG_ALIAS_NAME) = UPPER(P_LEG_ALIAS);


				--return the value of CRUISE_LEG_ID from the query
				RETURN v_cruise_leg_id;

				--exception handling:
				EXCEPTION

					WHEN NO_DATA_FOUND THEN

          --no results returned by the query, return NULL

					RETURN NULL;

					--catch all PL/SQL database exceptions:
					WHEN OTHERS THEN

					--catch all other errors:

					--return NULL to indicate the error:
					RETURN NULL;

		END LEG_ALIAS_TO_CRUISE_LEG_ID_FN;




	  --Append Reference Preset Options function
	  --function that accepts a list of colon-delimited integers (P_DELIM_VALUES) representing the primary key values of the given reference table preset options.  The P_OPTS_QUERY is the query for the primary key values for the given options query with a primary key parameter that will be used with the defined primary key value (P_PK_VAL) when executing the query to return the associated primary key values.  The return value will be the colon-delimited string that contains any additional primary key values that were returned by the P_OPTS_QUERY
	  FUNCTION APPEND_REF_PRE_OPTS_FN (P_DELIM_VALUES IN VARCHAR2, P_OPTS_QUERY IN VARCHAR2, P_PK_VAL IN NUMBER) RETURN VARCHAR2

	  IS

	    --array to store the parsed colon-delimited values from P_DELIM_VALUES
	    l_selected apex_application_global.vc_arr2;

	    --return code to be used by calls to the DB_LOG_PKG package:
	    V_SP_RET_CODE PLS_INTEGER;

	    --variable to track if the current result set primary key value is already contained in the colon-delimited list of values:
	    V_ID_FOUND BOOLEAN := FALSE;

	    --variable to store the current primary key value returned by the query:
	    V_OPT_PK_VAL NUMBER;

	    --reference cursor to handle dynamic query
	    TYPE cur_typ IS REF CURSOR;

	    --reference cursor variable:
	    c cur_typ;

	  BEGIN

	    DB_LOG_PKG.ADD_LOG_ENTRY('DEBUG', 'APPEND_REF_PRE_OPTS', 'executing APPEND_REF_PRE_OPTS_FN('||P_DELIM_VALUES||', '||P_OPTS_QUERY||', '||P_PK_VAL||')', V_SP_RET_CODE);

	    --parse the P_DELIM_VALUES string into an array so they can be processed
	   l_selected := apex_util.string_to_table(P_DELIM_VALUES);


	    --query for the primary key values using the P_OPTS_QUERY and the primary key value P_PK_VAL and loop through the result set
	    OPEN c FOR P_OPTS_QUERY USING P_PK_VAL;
	      LOOP

	          --retrieve the primary key values into the V_OPT_PK_VAL variable:
	          FETCH c INTO V_OPT_PK_VAL;
	          EXIT WHEN c%NOTFOUND;

	          --initialize the V_ID_FOUND boolean variable to indicate that a matching primary key value has not been found in the l_selected array:
	          V_ID_FOUND := FALSE;


	        --loop through the l_selected array to check if there is a match for the current result set primary key value
	        for i in 1..l_selected.count loop

	--            DB_LOG_PKG.ADD_LOG_ENTRY('DEBUG', 'APPEND_REF_PRE_OPTS', 'The current shuttle option is: '||l_selected(i), V_SP_RET_CODE);

	            --check if the current l_selected array element matches the current result set primary key value
	            IF (l_selected(i) = V_OPT_PK_VAL) THEN
	              --the values match, update V_ID_FOUND to indicate that the match has been found
	                V_ID_FOUND := TRUE;
	            END IF;
	        end loop;

	        --check to see if a match has been found for the current result set primary key and the l_selected array elements
	        IF NOT V_ID_FOUND THEN
	          --a match has not been found, add the result set primary key value to the array:

	--            DB_LOG_PKG.ADD_LOG_ENTRY('DEBUG', 'APPEND_REF_PRE_OPTS', 'None of the shuttle option values match the current option, add it to the l_selected array', V_SP_RET_CODE);

	            --add the ID to the list of selected values:
	            l_selected(l_selected.count + 1) := V_OPT_PK_VAL;
	        END IF;


	      END LOOP;
	    CLOSE c;



	     DB_LOG_PKG.ADD_LOG_ENTRY('DEBUG', 'APPEND_REF_PRE_OPTS', 'The return value is: '||apex_util.table_to_string(l_selected, ':'), V_SP_RET_CODE);

	     --convert the array to a colon-delimited string so it can be used directly in a shuttle field
	     return apex_util.table_to_string(l_selected, ':');

	  END APPEND_REF_PRE_OPTS_FN;



		--Deep copy cruise stored procedure:
		--This procedure accepts a P_CRUISE_ID parameter that contains the CRUISE_ID primary key integer value that will have all of its associated records copied (cruise name, leg names, and leg alias names will be copied with a naming convention but all other associated records will be loaded as-is to the new cruise record).  The value of P_SP_RET_CODE is 1 if the cruise record was successfully processed and the records were copied and 0 if the procedure encountered any errors during execution, if there were errors the SQL transaction will be rolled back.  P_PROC_RETURN_MSG will contain a message to indicate that the procedure was completed successfully or unsuccessfully with information about the results so they can be provided to the user.  P_PROC_RETURN_CRUISE_ID contains the CRUISE_ID for the newly inserted cruise record so it can be provided to the user, in the APEX application it is used to construct a URL to allow an authorized user to view/edit the newly copied cruise record
		--all error conditions will raise an application exception and will be logged in the database
		PROCEDURE DEEP_COPY_CRUISE_SP (P_CRUISE_ID IN PLS_INTEGER, P_SP_RET_CODE OUT PLS_INTEGER, P_PROC_RETURN_MSG OUT VARCHAR2, P_PROC_RETURN_CRUISE_ID OUT PLS_INTEGER) IS

	    --return code to be used by calls to the DB_LOG_PKG package:
	    V_SP_RET_CODE PLS_INTEGER;

			--variable to store the constructed log source string for the current procedure's log messages:
			V_TEMP_LOG_SOURCE DB_LOG_ENTRIES.LOG_SOURCE%TYPE;

			--variable to store the exception message:
			V_EXCEPTION_MSG VARCHAR2(2000);


			--variable to store the cruise_id for the newly created cruise record:
			V_NEW_CRUISE_ID PLS_INTEGER;

			--variable to store the cruise_leg_id for the newly created cruise leg record:
			V_NEW_CRUISE_LEG_ID PLS_INTEGER;


			--variable to store the current cruise_leg_id that is being processed for the cruise that is being copied:
			V_CURR_CRUISE_LEG_ID PLS_INTEGER;


			--variable to hold the total number of associated cruise legs:
			V_NUM_LEGS PLS_INTEGER;

			--variable to store the dynamic query string:
			V_QUERY_STRING VARCHAR2(4000);

			--ref cursor type
			TYPE cur_typ IS REF CURSOR;

			--cursor type variable:
	    c cur_typ;

			--record variable to store the CCD_CRUISES record values that are being copied from CRUISE_ID = P_CRUISE_ID to a new CCD_CRUISES record
	    cruise_tab CCD_CRUISES%rowtype;

			--variable type for an array of CCD_CRUISE_LEGS rows that are used to store the value returned by the query for cruise legs associated with the existing CCD_CRUISES record where CRUISE_ID = P_CRUISE_ID
	    type leg_tab is table of CCD_CRUISE_LEGS%rowtype index by binary_integer;

	    --cruise leg table type variable to store the CCD_CRUISE_LEGS record values returned by the query for the given CCD_CRUISES record so they can be inserted and associated with the new cruise record
	    v_leg_tab leg_tab;


			--variable to store the current leg name that is being processed so it can be reported in the event there is an error during the processing
			v_current_leg_name varchar2(2000);

			--variable to store the current cruise name that is being processed so it can be reported in the event there is an error during the processing
			v_current_cruise_name varchar2(2000);

			--exception for a blank CRUISE_ID parameter:
			EXC_BLANK_CRUISE_ID EXCEPTION;

		begin

			--construct the DB_LOG_ENTRIES.LOG_SOURCE value for all logging messages in this procedure and all subsequent calls based on the procedure/function name and parameters:
			PV_LOG_MSG_HEADER := 'DEEP_COPY_CRUISE_SP (P_CRUISE_ID: '||P_CRUISE_ID||')';

			--check if the P_CRUISE_ID parameter is blank
			IF (P_CRUISE_ID IS NULL) THEN
				--the P_CRUISE_ID parameter is blank

				--generate the exception message:
				V_EXCEPTION_MSG := 'The Cruise ID parameter was not specified';

				--log the processing error:
				DB_LOG_PKG.ADD_LOG_ENTRY ('ERROR', PV_LOG_MSG_HEADER, V_EXCEPTION_MSG, V_SP_RET_CODE);

				--raise the defined exception:
				RAISE EXC_BLANK_CRUISE_ID;


			END IF;


			--set the rollback save point so that the deep copy can be rolled back if the procedure can't be successfully executed:
			SAVEPOINT DEEP_COPY_SAVEPOINT;

	  	DB_LOG_PKG.ADD_LOG_ENTRY('DEBUG', PV_LOG_MSG_HEADER, 'Running DEEP_COPY_CRUISE_SP('||P_CRUISE_ID||')', V_SP_RET_CODE);

			--retrieve the current CCD_CRUISES record's information into the cruise_tab variable so it can be used to insert the new CCD_CRUISES record copy into the database
	    SELECT * into cruise_tab from ccd_cruises where cruise_id = P_CRUISE_ID;


	  	DB_LOG_PKG.ADD_LOG_ENTRY('DEBUG', PV_LOG_MSG_HEADER, 'The cruise record was queried successfully: '||cruise_tab.CRUISE_NAME, V_SP_RET_CODE);

			--store the cruise name in v_current_cruise_name so it can be used for an error message if there was a unique key constraint violation
			v_current_cruise_name := cruise_tab.CRUISE_NAME;

			--insert the CCD_CRUISES record based on the values in the CCD_CRUISES record where CRUISE_ID = P_CRUISE_ID:
			--append the " (copy)" to the cruise name and reuse all other values from the copied cruise record:
			INSERT INTO CCD_CRUISES (CRUISE_NAME, CRUISE_NOTES, SVY_TYPE_ID, SCI_CENTER_DIV_ID, STD_SVY_NAME_ID, SVY_FREQ_ID, CRUISE_URL, CRUISE_CONT_EMAIL, STD_SVY_NAME_OTH, CRUISE_DESC, OBJ_BASED_METRICS)
			VALUES (cruise_tab.CRUISE_NAME||' (copy)', cruise_tab.CRUISE_NOTES, cruise_tab.SVY_TYPE_ID, cruise_tab.SCI_CENTER_DIV_ID, cruise_tab.STD_SVY_NAME_ID, cruise_tab.SVY_FREQ_ID, cruise_tab.CRUISE_URL, cruise_tab.CRUISE_CONT_EMAIL, cruise_tab.STD_SVY_NAME_OTH, cruise_tab.CRUISE_DESC, cruise_tab.OBJ_BASED_METRICS)
			RETURNING CCD_CRUISES.CRUISE_ID INTO V_NEW_CRUISE_ID;

			--set the value of the out parameter so the new cruise ID can be used in the application
			P_PROC_RETURN_CRUISE_ID := V_NEW_CRUISE_ID;

	  	DB_LOG_PKG.ADD_LOG_ENTRY('DEBUG', PV_LOG_MSG_HEADER, 'The cruise record was copied successfully, new ID: '||V_NEW_CRUISE_ID, V_SP_RET_CODE);

			--insert the associated cruise attributes:
			COPY_ASSOC_CRUISE_VALS_SP (P_CRUISE_ID, V_NEW_CRUISE_ID);

			--the cruise attributes were processed successfully

			DB_LOG_PKG.ADD_LOG_ENTRY('DEBUG', PV_LOG_MSG_HEADER, 'The associated cruise attributes were successfully copied', V_SP_RET_CODE);


			--query for the number of cruise legs associated with the specified CCD_CRUISES record and store in the V_NUM_LEGS variable:
			SELECT count(*) INTO V_NUM_LEGS from ccd_cruise_legs where CRUISE_ID = P_CRUISE_ID;

			DB_LOG_PKG.ADD_LOG_ENTRY('DEBUG', PV_LOG_MSG_HEADER, 'The cruise legs were queried successfully, NUM_LEGS = '||V_NUM_LEGS, V_SP_RET_CODE);


			--check to see if there are any legs associated with the specified cruise:
			IF (V_NUM_LEGS > 0) then
				--there were one or more cruise legs associated with the specified cruise record:

				DB_LOG_PKG.ADD_LOG_ENTRY('DEBUG', PV_LOG_MSG_HEADER, 'There are one or more cruise legs, query for them and copy them in the database', V_SP_RET_CODE);

				--query for all associated cruise legs and store the results in v_leg_tab for processing
				select * bulk collect into v_leg_tab from ccd_cruise_legs where cruise_id = P_CRUISE_ID;

				--loop through each of the associated cruise legs and insert copies/associate attribute records:
				for i in v_leg_tab.first..v_leg_tab.last loop

					--set the current leg name so it can be used in the event there is a unique key constraint error:
					v_current_leg_name := v_leg_tab(i).LEG_NAME;

					DB_LOG_PKG.ADD_LOG_ENTRY('DEBUG', PV_LOG_MSG_HEADER, 'INSERT the new cruise leg copy - the value of v_leg_tab.CRUISE_LEG_ID is: '||v_leg_tab(i).CRUISE_LEG_ID, V_SP_RET_CODE);

					--insert the new cruise leg with the values in the source cruise leg and " (copy)" appended to the leg name and associate it with the new cruise record that was just inserted (identified by V_NEW_CRUISE_ID).  Return the CCD_CRUISE_LEGS.CRUISE_LEG_ID primary key into V_NEW_CRUISE_LEG_ID so it can be used to associate the cruise leg attributes
					INSERT INTO CCD_CRUISE_LEGS (LEG_NAME, LEG_START_DATE, LEG_END_DATE, LEG_DESC, CRUISE_ID, VESSEL_ID, PLAT_TYPE_ID)
					VALUES (v_leg_tab(i).LEG_NAME||' (copy)', v_leg_tab(i).LEG_START_DATE, v_leg_tab(i).LEG_END_DATE, v_leg_tab(i).LEG_DESC, V_NEW_CRUISE_ID, v_leg_tab(i).VESSEL_ID, v_leg_tab(i).PLAT_TYPE_ID)
					RETURNING CRUISE_LEG_ID INTO V_NEW_CRUISE_LEG_ID;

					DB_LOG_PKG.ADD_LOG_ENTRY('DEBUG', PV_LOG_MSG_HEADER, 'The cruise leg copy was successfully inserted - the value of V_NEW_CRUISE_LEG_ID is: '||V_NEW_CRUISE_LEG_ID, V_SP_RET_CODE);

					--Copy the source cruise leg attributes to the newly inserted cruise leg record::
					COPY_ASSOC_LEG_VALS_SP (v_leg_tab(i).CRUISE_LEG_ID, V_NEW_CRUISE_LEG_ID);

					--the associated attributes for the new cruise leg were processed successfully:

					DB_LOG_PKG.ADD_LOG_ENTRY('DEBUG', PV_LOG_MSG_HEADER, 'The cruise leg copy was successfully inserted, copy the leg aliases - the value of V_NEW_CRUISE_LEG_ID is: '||V_NEW_CRUISE_LEG_ID, V_SP_RET_CODE);


					--copy the cruise leg aliases:
					COPY_LEG_ALIASES_SP (v_leg_tab(i).CRUISE_LEG_ID, V_NEW_CRUISE_LEG_ID, P_PROC_RETURN_MSG);

					--the leg aliases were processed successfully:

					DB_LOG_PKG.ADD_LOG_ENTRY('DEBUG', PV_LOG_MSG_HEADER, 'The leg aliases were processed successfully', V_SP_RET_CODE);

				end loop;

				DB_LOG_PKG.ADD_LOG_ENTRY('DEBUG', PV_LOG_MSG_HEADER, 'The cruise legs were successfully processed', V_SP_RET_CODE);

			END IF;

			--execute the DVM on the newly inserted cruise and any overlaps the new cruise caused:
			CCD_DVM_PKG.EXEC_DVM_CRUISE_OVERLAP_SP (V_NEW_CRUISE_ID);

			--the DVM was executed successfully:

			--generate the success message to indicate the "deep copy" was successful, if the script reaches this point it was successful
			P_PROC_RETURN_MSG := 'The Cruise "'||cruise_tab.CRUISE_NAME||'" was successfully copied as "'||cruise_tab.CRUISE_NAME||' (copy)" and '||V_NUM_LEGS||' legs were copied and associated with the new Cruise.  The DVM was used to validate the new Cruise';

			DB_LOG_PKG.ADD_LOG_ENTRY('SUCCESS', PV_LOG_MSG_HEADER, P_PROC_RETURN_MSG, V_SP_RET_CODE);

			--set the success code:
			P_SP_RET_CODE := 1;



			--exception handling:
	    EXCEPTION


					WHEN EXC_BLANK_CRUISE_ID THEN
						--The P_CRUISE_ID parameter was not defined

						--raise a custom application error:
						RAISE_APPLICATION_ERROR (-20601, V_EXCEPTION_MSG);

					--check for no data found errors (when querying for the CCD_CRUISES record)
					WHEN NO_DATA_FOUND then
						--the CCD_CRUISES record identified by P_CRUISE_ID could not be retrieved successfully

						--generate the exception message:
						V_EXCEPTION_MSG := 'The specified Cruise could not be retrieved successfully';


						--there was an error processing the current cruise leg's aliases
						DB_LOG_PKG.ADD_LOG_ENTRY('ERROR', PV_LOG_MSG_HEADER, V_EXCEPTION_MSG, V_SP_RET_CODE);

            --there was a PL/SQL error, rollback the SQL transaction:
						--rollback all of the Deep Copy DML since the deep copy was unsuccessful:
						ROLLBACK TO SAVEPOINT DEEP_COPY_SAVEPOINT;

						--raise a custom application error:
						RAISE_APPLICATION_ERROR (-20602, V_EXCEPTION_MSG);


						--no data was saved, there is no need to rollback the transaction

					--check for unique key errors
					WHEN DUP_VAL_ON_INDEX THEN
						--there was a unique key index error, check if this was during the insertion of the cruise record or an associated leg record:

  					DB_LOG_PKG.ADD_LOG_ENTRY('DEBUG', PV_LOG_MSG_HEADER, 'The Cruise/Cruise Leg could not be copied successfully, there was a unique key constraint error: ' || SQLCODE || '- ' || SQLERRM, V_SP_RET_CODE);

            --there was a PL/SQL error, rollback the SQL transaction:
						--rollback all of the Deep Copy DML since the deep copy was unsuccessful:
						ROLLBACK TO SAVEPOINT DEEP_COPY_SAVEPOINT;


						--check to see if the cruise leg name is set, if not then there were no legs processed so it must be the cruise that was not processed successfully with the unique key constraint:
						if (v_current_leg_name IS NULL) THEN
							--this was an error when processing the CCD_CRUISES table:


							--generate the exception message:
							V_EXCEPTION_MSG := 'The Cruise "'||v_current_cruise_name||'" could not be copied successfully, there is already a cruise named "'||v_current_cruise_name||' (copy)"';


							--there was an error processing the current cruise leg's aliases
							DB_LOG_PKG.ADD_LOG_ENTRY('ERROR', PV_LOG_MSG_HEADER, V_EXCEPTION_MSG, V_SP_RET_CODE);

							--raise a custom application error:
							RAISE_APPLICATION_ERROR (-20603, V_EXCEPTION_MSG);

						else
							--this was an error when processing the CCD_CRUISE_LEGS table:


							--generate the exception message:
							V_EXCEPTION_MSG := 'The Cruise leg "'||v_current_leg_name||'" could not be copied successfully, there was already a cruise leg named "'||v_current_leg_name||' (copy)"';

							--there was an error processing the current cruise leg's aliases
							DB_LOG_PKG.ADD_LOG_ENTRY('ERROR', PV_LOG_MSG_HEADER, V_EXCEPTION_MSG, V_SP_RET_CODE);

							--raise a custom application error:
							RAISE_APPLICATION_ERROR (-20605, V_EXCEPTION_MSG);

						END IF;


	        --catch all PL/SQL database exceptions:
	        WHEN OTHERS THEN
            --catch all other errors:

						--check if this is a Cruise DVM Overlap Procesing Error:
						IF (SQLCODE = -20512) THEN
							--this is a Cruise DVM Overlap Procesing Error

							--generate the exception message:
							V_EXCEPTION_MSG := 'The copied Cruise could not be validated using the DVM:'||chr(10)||SQLERRM;

							--there was an error processing the current cruise leg's aliases
							DB_LOG_PKG.ADD_LOG_ENTRY('ERROR', PV_LOG_MSG_HEADER, V_EXCEPTION_MSG, V_SP_RET_CODE);


	            --there was a PL/SQL error, rollback the SQL transaction:
							--rollback all of the Deep Copy DML since the deep copy was unsuccessful:
							ROLLBACK TO SAVEPOINT DEEP_COPY_SAVEPOINT;

							--raise a custom application error:
							RAISE_APPLICATION_ERROR (-20610, V_EXCEPTION_MSG);

						ELSE

							--generate the exception message:
							V_EXCEPTION_MSG := 'The specified Cruise and associated attributes could not be copied successfully'||chr(10)||SQLERRM;

							--there was an error processing the current cruise leg's aliases
							DB_LOG_PKG.ADD_LOG_ENTRY('ERROR', PV_LOG_MSG_HEADER, V_EXCEPTION_MSG, V_SP_RET_CODE);


	            --there was a PL/SQL error, rollback the SQL transaction:
							--rollback all of the Deep Copy DML since the deep copy was unsuccessful:
							ROLLBACK TO SAVEPOINT DEEP_COPY_SAVEPOINT;

							--raise a custom application error:
							RAISE_APPLICATION_ERROR (-20611, V_EXCEPTION_MSG);
						END IF;

		end DEEP_COPY_CRUISE_SP;

		--Deep copy cruise stored procedure:
		--This procedure accepts a P_CRUISE_NAME parameter that contains the unique CRUISE_NAME value that will have all of its associated records copied (cruise name, leg names, and leg alias names will be copied with a naming convention but all other associated records will be loaded as-is to the new cruise record).  The value of P_SP_RET_CODE is 1 if the cruise record was successfully processed and the records were copied and 0 if the procedure encountered any errors during execution, if there were errors the SQL transaction will be rolled back.  P_PROC_RETURN_MSG will contain a message to indicate that the procedure was completed successfully or unsuccessfully with information about the results so they can be provided to the user.  P_PROC_RETURN_CRUISE_ID contains the CRUISE_ID for the newly inserted cruise record so it can be provided to the user, in the APEX application it is used to construct a URL to allow an authorized user to view/edit the newly copied cruise record
		--all error conditions will raise an application exception and will be logged in the database
		PROCEDURE DEEP_COPY_CRUISE_SP (P_CRUISE_NAME IN VARCHAR2, P_SP_RET_CODE OUT PLS_INTEGER, P_PROC_RETURN_MSG OUT VARCHAR2, P_PROC_RETURN_CRUISE_ID OUT PLS_INTEGER) IS

			--procedure variable to store the return codes from each procedure call to determine the results of the procedure execution
			V_SP_RET_CODE PLS_INTEGER;

			--variable to store the CRUISE_ID for the specified P_CRUISE_NAME value
			V_CRUISE_ID PLS_INTEGER;

			--variable to store the constructed log source string for the current procedure's log messages:
			V_TEMP_LOG_SOURCE DB_LOG_ENTRIES.LOG_SOURCE%TYPE;

			--variable to store the exception message:
			V_EXCEPTION_MSG VARCHAR2(2000);

			--exception for blank cruise name:
			EXC_BLANK_CRUISE_NAME EXCEPTION;


		BEGIN

			--construct the DB_LOG_ENTRIES.LOG_SOURCE value for all logging messages in this procedure based on the procedure/function name and parameters:
			V_TEMP_LOG_SOURCE := 'DEEP_COPY_CRUISE_SP (P_CRUISE_NAME: '||P_CRUISE_NAME||')';

	    DB_LOG_PKG.ADD_LOG_ENTRY('DEBUG', V_TEMP_LOG_SOURCE, 'running DEEP_COPY_CRUISE_SP ()', V_SP_RET_CODE);


			--check if the P_CRUISE_NAME parameter is blank
			IF (P_CRUISE_NAME IS NULL) THEN
				--the P_CRUISE_NAME parameter is blank

				--generate the exception message:
				V_EXCEPTION_MSG := 'The Cruise Name parameter was not specified';

				--log the processing error:
				DB_LOG_PKG.ADD_LOG_ENTRY ('ERROR', V_TEMP_LOG_SOURCE, V_EXCEPTION_MSG, V_SP_RET_CODE);

				--raise the defined exception:
				RAISE EXC_BLANK_CRUISE_NAME;


			END IF;


			--query for the cruise_id for the corresponding P_CRUISE_NAME value
			SELECT CRUISE_ID INTO V_CRUISE_ID FROM CCD_CRUISES WHERE UPPER(CRUISE_NAME) = UPPER(P_CRUISE_NAME);

			--deep copy the cruise and evaluate the DVM on the new cruise and any overlapping cruises:
			DEEP_COPY_CRUISE_SP (V_CRUISE_ID, V_SP_RET_CODE, P_PROC_RETURN_MSG, P_PROC_RETURN_CRUISE_ID);

      EXCEPTION
        --catch all PL/SQL database exceptions:

				WHEN EXC_BLANK_CRUISE_NAME then
					--blank CRUISE_NAME parameter:

					--raise a custom application error:
					RAISE_APPLICATION_ERROR (-20601, V_EXCEPTION_MSG);


				WHEN NO_DATA_FOUND THEN
					--catch no matching cruise record error:


					--generate the exception message:
					V_EXCEPTION_MSG := 'A cruise record with a name "'||P_CRUISE_NAME||'" could not be found in the database';

					--log the processing error:
			    DB_LOG_PKG.ADD_LOG_ENTRY('ERROR', V_TEMP_LOG_SOURCE, V_EXCEPTION_MSG, V_SP_RET_CODE);

					--raise a custom application error:
					RAISE_APPLICATION_ERROR (-20602, V_EXCEPTION_MSG);

        WHEN OTHERS THEN
				  --catch all other errors:

					--check if there are any special exceptions for the DEEP_COPY_CRUISE_SP (P_CRUISE_ID) procedure
					IF (SQLCODE IN (-20603, -20605, -20610, -20611)) THEN
						--this is a special exception from the DEEP_COPY_CRUISE_SP (P_CRUISE_ID) procedure

						--re raise the exception:
						RAISE;

					ELSE


						--generate the exception message:
						V_EXCEPTION_MSG := 'The Cruise (P_CRUISE_NAME: '||P_CRUISE_NAME||') and associated attributes could not be copied successfully'||chr(10)||SQLERRM;

						--log the processing error:
						DB_LOG_PKG.ADD_LOG_ENTRY ('ERROR', V_TEMP_LOG_SOURCE, V_EXCEPTION_MSG, V_SP_RET_CODE);

						--raise a custom application error:
						RAISE_APPLICATION_ERROR (-20611, V_EXCEPTION_MSG);
					END IF;


		END DEEP_COPY_CRUISE_SP;

		--procedure to copy all associated cruise values (e.g. CCD_CRUISE_EXP_SPP) from the source cruise (P_SOURCE_CRUISE_ID) to the new cruise (P_NEW_CRUISE_ID) utilizing the COPY_ASSOC_VALS_SP procedure to actually copy the attribute records, the list of static tables are used as a parameter in addition to the foreign key field name for the CCD_CRUISES table.
		--all error conditions will raise an application exception and will be logged in the database
		PROCEDURE COPY_ASSOC_CRUISE_VALS_SP (P_SOURCE_CRUISE_ID IN PLS_INTEGER, P_NEW_CRUISE_ID IN PLS_INTEGER) IS

	    --return code to be used by calls to the DB_LOG_PKG package:
	    V_SP_RET_CODE PLS_INTEGER;

			--variable to store the constructed log source string for the current procedure's log messages:
			V_TEMP_LOG_SOURCE DB_LOG_ENTRIES.LOG_SOURCE%TYPE;

			--variable to store the exception message:
			V_EXCEPTION_MSG VARCHAR2(2000);


			--string array variable to define the different cruise attribute tables:
			P_TABLE_LIST apex_application_global.vc_arr2;


		BEGIN


			--construct the DB_LOG_ENTRIES.LOG_SOURCE value for all logging messages in this procedure based on the procedure/function name and parameters:
			V_TEMP_LOG_SOURCE := PV_LOG_MSG_HEADER||' - COPY_ASSOC_CRUISE_VALS_SP (P_SOURCE_CRUISE_ID: '||P_SOURCE_CRUISE_ID||', P_NEW_CRUISE_ID: '||P_NEW_CRUISE_ID||')';


			DB_LOG_PKG.ADD_LOG_ENTRY('DEBUG', V_TEMP_LOG_SOURCE, 'Running COPY_ASSOC_CRUISE_VALS_SP ('||P_SOURCE_CRUISE_ID||', '||P_NEW_CRUISE_ID||')', V_SP_RET_CODE);


			--define the different cruise attribute tables that need to be processed in a new array:
			P_TABLE_LIST(1) := 'CCD_CRUISE_EXP_SPP';
			P_TABLE_LIST(2) := 'CCD_CRUISE_SPP_ESA';
			P_TABLE_LIST(3) := 'CCD_CRUISE_SPP_FSSI';
			P_TABLE_LIST(4) := 'CCD_CRUISE_SPP_MMPA';
			P_TABLE_LIST(5) := 'CCD_CRUISE_SVY_CATS';
			P_TABLE_LIST(6) := 'CCD_TGT_SPP_OTHER';

			--copy all of the associated records with the source cruise to the new cruise
			COPY_ASSOC_VALS_SP (P_TABLE_LIST, 'CRUISE_ID', P_SOURCE_CRUISE_ID, P_NEW_CRUISE_ID);

	    EXCEPTION

	      WHEN OTHERS THEN
	        --catch all other errors:

					--generate the exception message:
					V_EXCEPTION_MSG := 'The cruise attribute records could not be copied:'||chr(10)|| SQLERRM;

					--log the procedure processing error:
					DB_LOG_PKG.ADD_LOG_ENTRY ('ERROR', V_TEMP_LOG_SOURCE, V_EXCEPTION_MSG, V_SP_RET_CODE);

					--raise a custom application error:
					RAISE_APPLICATION_ERROR (-20604, V_EXCEPTION_MSG);

		END COPY_ASSOC_CRUISE_VALS_SP;


		--procedure to copy all associated cruise leg values (e.g.CCD_LEG_GEAR) from the source cruise (P_SOURCE_CRUISE_LEG_ID) to the new cruise (P_NEW_CRUISE_LEG_ID) utilizing the COPY_ASSOC_VALS_SP procedure to actually copy the attribute records, the list of static tables are used as a parameter in addition to the foreign key field name for the CCD_CRUISE_LEGS table.
		--all error conditions will raise an application exception and will be logged in the database
		PROCEDURE COPY_ASSOC_LEG_VALS_SP (P_SOURCE_CRUISE_LEG_ID IN PLS_INTEGER, P_NEW_CRUISE_LEG_ID IN PLS_INTEGER) IS

			--return code to be used by calls to the DB_LOG_PKG package:
			V_SP_RET_CODE PLS_INTEGER;

			--variable to store the constructed log source string for the current procedure's log messages:
			V_TEMP_LOG_SOURCE DB_LOG_ENTRIES.LOG_SOURCE%TYPE;

			--variable to store the exception message:
			V_EXCEPTION_MSG VARCHAR2(2000);

			--string array variable to define the different cruise leg attribute tables:
			P_TABLE_LIST apex_application_global.vc_arr2;



		BEGIN


			--construct the DB_LOG_ENTRIES.LOG_SOURCE value for all logging messages in this procedure based on the procedure/function name and parameters:
			V_TEMP_LOG_SOURCE := PV_LOG_MSG_HEADER||' - COPY_ASSOC_LEG_VALS_SP (P_SOURCE_CRUISE_LEG_ID: '||P_SOURCE_CRUISE_LEG_ID||', P_NEW_CRUISE_LEG_ID: '||P_NEW_CRUISE_LEG_ID||')';


			DB_LOG_PKG.ADD_LOG_ENTRY('DEBUG', V_TEMP_LOG_SOURCE, 'Running COPY_ASSOC_LEG_VALS_SP ('||P_SOURCE_CRUISE_LEG_ID||', '||P_NEW_CRUISE_LEG_ID||')', V_SP_RET_CODE);


			--define the different cruise leg attribute tables that need to be processed in a new array:
			P_TABLE_LIST(1) := 'CCD_LEG_ECOSYSTEMS';
			P_TABLE_LIST(2) := 'CCD_LEG_GEAR';
			P_TABLE_LIST(3) := 'CCD_LEG_REGIONS';

			--copy all of the associated records with the source cruise leg to the new cruise leg
			COPY_ASSOC_VALS_SP (P_TABLE_LIST, 'CRUISE_LEG_ID', P_SOURCE_CRUISE_LEG_ID, P_NEW_CRUISE_LEG_ID);


			EXCEPTION

				WHEN OTHERS THEN
					--catch all other errors:

					--generate the exception message:
					V_EXCEPTION_MSG := 'The cruise leg attribute records could not be copied:'||chr(10)|| SQLERRM;

					--log the procedure processing error:
					DB_LOG_PKG.ADD_LOG_ENTRY ('ERROR', V_TEMP_LOG_SOURCE, V_EXCEPTION_MSG, V_SP_RET_CODE);

					--raise a custom application error:
					RAISE_APPLICATION_ERROR (-20606, V_EXCEPTION_MSG);

		END COPY_ASSOC_LEG_VALS_SP;


		--procedure to copy all values associated with the given source cruise/cruise leg (based on P_PK_FIELD_NAME and P_SOURCE_ID) for the specified tables (P_TABLE_LIST array) and associate them with the new cruise/cruise leg (based on P_NEW_ID).
		--all error conditions will raise an application exception and will be logged in the database
		PROCEDURE COPY_ASSOC_VALS_SP (P_TABLE_LIST IN apex_application_global.vc_arr2, P_PK_FIELD_NAME IN VARCHAR2, P_SOURCE_ID IN PLS_INTEGER, P_NEW_ID IN PLS_INTEGER) IS

	    --return code to be used by calls to the DB_LOG_PKG package:
	    V_SP_RET_CODE PLS_INTEGER;

			--variable to store the constructed log source string for the current procedure's log messages:
			V_TEMP_LOG_SOURCE DB_LOG_ENTRIES.LOG_SOURCE%TYPE;

			--variable to store the exception message:
			V_EXCEPTION_MSG VARCHAR2(2000);

			--string array variable to store the different columns for a given cruise attribute table:
			V_FIELD_LIST apex_application_global.vc_arr2;

			--variable to store the number records for the given attribute table that are related to the cruise that is being copied:
			V_NUM_ATTRIBUTES PLS_INTEGER;

			--variable to store the dynamic query string:
			V_QUERY_STRING VARCHAR2(4000);

			--variable to store the table name for the current table that is being processed
			V_CURR_TABLE_NAME VARCHAR2(30);

		BEGIN

			--construct the DB_LOG_ENTRIES.LOG_SOURCE value for all logging messages in this procedure based on the procedure/function name and parameters:
			V_TEMP_LOG_SOURCE := PV_LOG_MSG_HEADER||' - COPY_ASSOC_VALS_SP (P_TABLE_LIST: ('||APEX_UTIL.table_to_string(P_TABLE_LIST, ', ')||'), P_PK_FIELD_NAME: '||P_PK_FIELD_NAME||', P_SOURCE_ID: '||P_SOURCE_ID||', P_NEW_ID: '||P_NEW_ID||')';

			DB_LOG_PKG.ADD_LOG_ENTRY('DEBUG', V_TEMP_LOG_SOURCE, 'Running COPY_ASSOC_VALS_SP ()', V_SP_RET_CODE);

			--loop through each table, query for the fields that should be set from the source record and then construct the INSERT-SELECT queries for each of the cruise/cruise leg attributes:
		  for i in 1..P_TABLE_LIST.count LOOP

				DB_LOG_PKG.ADD_LOG_ENTRY('DEBUG', V_TEMP_LOG_SOURCE, 'Process the current table: '||P_TABLE_LIST(i), V_SP_RET_CODE);

				--store the current table name:
				V_CURR_TABLE_NAME := P_TABLE_LIST(i);

				--generate the SQL to check if there are any records for each of the attribute tables, if not there is no need to process them:
				V_QUERY_STRING := 'SELECT count(*) FROM '||P_TABLE_LIST(i)||' WHERE '||P_PK_FIELD_NAME||' = :PK_ID';

				--execute the query and store the record count as V_NUM_ATTRIBUTES
				EXECUTE IMMEDIATE V_QUERY_STRING INTO V_NUM_ATTRIBUTES USING P_SOURCE_ID;

				DB_LOG_PKG.ADD_LOG_ENTRY('DEBUG', V_TEMP_LOG_SOURCE, 'The number of records for the current attribute table is: '||V_NUM_ATTRIBUTES, V_SP_RET_CODE);

				--check to see if there are any associated records for the current attribute table:
				IF (V_NUM_ATTRIBUTES > 0) THEN
					--there are one or more records associated with the current cruise/cruise leg attribute table

					DB_LOG_PKG.ADD_LOG_ENTRY('DEBUG', V_TEMP_LOG_SOURCE, 'There was at least one associated record for the current attribute table, generate the INSERT..SELECT query', V_SP_RET_CODE);


					--query for all of the field names that are not auditing fields or the PK field (P_PK_FIELD_NAME) so the values can be used to generate a SQL insert statement to insert the attribute table records associated with the source record (P_SOURCE_ID for either CCD_CRUISES or CCD_CRUISE_LEGS based on P_PK_FIELD_NAME) for the destination record (P_NEW_ID):
					select distinct user_tab_cols.column_name bulk collect into V_FIELD_LIST
					from user_tab_cols
					where user_tab_cols.table_name = P_TABLE_LIST(i) AND user_tab_cols.column_name not in ('CREATE_DATE', 'CREATED_BY', P_PK_FIELD_NAME)
					AND user_tab_cols.column_name not in (select user_cons_columns.column_name from user_cons_columns inner join user_constraints on user_constraints.constraint_name = user_cons_columns.constraint_name and user_constraints.owner = user_cons_columns.owner WHERE user_constraints.constraint_type = 'P' AND user_cons_columns.table_name = user_tab_cols.table_name AND user_cons_columns.owner = sys_context( 'userenv', 'current_schema' ));

					DB_LOG_PKG.ADD_LOG_ENTRY('DEBUG', V_TEMP_LOG_SOURCE, 'The attribute table query was successful, generate the INSERT..SELECT query', V_SP_RET_CODE);

					--construct the SQL INSERT statement to insert the current attribute record for the new cruise/cruise leg record (based on P_PK_FIELD_NAME) based on the source record (P_SOURCE_ID) for the new record (P_NEW_ID)
					V_QUERY_STRING := 'INSERT INTO '||P_TABLE_LIST(i)||' ('||apex_util.table_to_string(V_FIELD_LIST, ',')||', '||P_PK_FIELD_NAME||') SELECT '||apex_util.table_to_string(V_FIELD_LIST, ',')||', :NEW_ID FROM '||P_TABLE_LIST(i)||' WHERE '||P_PK_FIELD_NAME||' = :SOURCE_ID';

					DB_LOG_PKG.ADD_LOG_ENTRY('DEBUG', V_TEMP_LOG_SOURCE, 'The value of the generated string is: '||V_QUERY_STRING, V_SP_RET_CODE);

					--execute the SQL INSERT query:
					EXECUTE IMMEDIATE V_QUERY_STRING USING P_NEW_ID, P_SOURCE_ID;

					DB_LOG_PKG.ADD_LOG_ENTRY('DEBUG', V_TEMP_LOG_SOURCE, 'The insert-select query was successful', V_SP_RET_CODE);


				END IF;
		  END LOOP;

			--handle SQL exceptions
		  EXCEPTION

		    --catch all PL/SQL database exceptions:
		    WHEN OTHERS THEN
		      --catch all other errors:

					--generate the exception message:
					V_EXCEPTION_MSG := 'The cruise/leg attribute records for the '||V_CURR_TABLE_NAME||' table could not be copied due to a NO_DATA_FOUND error:'||chr(10)|| SQLERRM;

					--log the procedure processing error:
					DB_LOG_PKG.ADD_LOG_ENTRY ('ERROR', V_TEMP_LOG_SOURCE, V_EXCEPTION_MSG, V_SP_RET_CODE);

					--raise a custom application error:
					RAISE_APPLICATION_ERROR (-20607, V_EXCEPTION_MSG);

		END COPY_ASSOC_VALS_SP;


		--this procedure copies all leg aliases from the cruise leg with CRUISE_LEG_ID = P_SOURCE_LEG_ID to a newly inserted cruise leg with CRUISE_LEG_ID = P_NEW_LEG_ID modifying each leg alias to append (copy) to it.  The value of P_SP_RET_CODE will be 1 if the procedure successfully processed the leg aliases from the given source leg to the new leg and 0 if it was not, if it was unsuccessful the SQL transaction will be rolled back.  The procedure checks for unique key constraint violations and reports any error message using the P_PROC_RETURN_MSG parameter
		--all error conditions will raise an application exception and will be logged in the database
		PROCEDURE COPY_LEG_ALIASES_SP (P_SOURCE_LEG_ID IN PLS_INTEGER, P_NEW_LEG_ID IN PLS_INTEGER, P_PROC_RETURN_MSG OUT VARCHAR2) IS
	    --return code to be used by calls to the DB_LOG_PKG package:
	    V_SP_RET_CODE PLS_INTEGER;

			--variable to store the constructed log source string for the current procedure's log messages:
			V_TEMP_LOG_SOURCE DB_LOG_ENTRIES.LOG_SOURCE%TYPE;

			--variable to store the exception message:
			V_EXCEPTION_MSG VARCHAR2(2000);


			--type to store CCD_LEG_ALIASES records from a BULK_COLLECT query:
	    type leg_alias_table is table of CCD_LEG_ALIASES%rowtype index by binary_integer;

			--variable to store CCD_LEG_ALIASES records
			v_leg_aliases leg_alias_table;

			--variable to store the number of leg alias records (CCD_LEG_ALIASES) associated with the source cruise leg record
			v_num_aliases PLS_INTEGER;

			--variable to store the current leg alias name
			v_curr_leg_alias_name VARCHAR2(1000);

		BEGIN

			--construct the DB_LOG_ENTRIES.LOG_SOURCE value for all logging messages in this procedure based on the procedure/function name and parameters:
			V_TEMP_LOG_SOURCE := PV_LOG_MSG_HEADER||' - COPY_LEG_ALIASES_SP (P_SOURCE_LEG_ID: '||P_SOURCE_LEG_ID||', P_NEW_LEG_ID: '||P_NEW_LEG_ID||')';


			DB_LOG_PKG.ADD_LOG_ENTRY('DEBUG', V_TEMP_LOG_SOURCE, 'Running COPY_LEG_ALIASES_SP ()', V_SP_RET_CODE);

			--query for the number of leg alias records associated with the specified leg
			SELECT COUNT(*) into v_num_aliases from CCD_LEG_ALIASES where CRUISE_LEG_ID = P_SOURCE_LEG_ID;

			DB_LOG_PKG.ADD_LOG_ENTRY('DEBUG', V_TEMP_LOG_SOURCE, 'There are '||v_num_aliases||' leg aliases for the specified cruise leg', V_SP_RET_CODE);


			--check to see if there are any legs aliases associated with the specified cruise leg:
			IF (v_num_aliases > 0) then
				--there are one or more leg aliases for the specified leg

				--retrieve all of the leg aliases for the specified leg (P_SOURCE_LEG_ID) and store in the v_leg_aliases variable:
				SELECT * bulk collect INTO v_leg_aliases FROM CCD_LEG_ALIASES where CRUISE_LEG_ID = P_SOURCE_LEG_ID order by UPPER(LEG_ALIAS_NAME);

				--loop through the leg aliases and insert them for the new cruise leg (P_NEW_LEG_ID)
		    for i in v_leg_aliases.first..v_leg_aliases.last loop

					DB_LOG_PKG.ADD_LOG_ENTRY('DEBUG', V_TEMP_LOG_SOURCE, 'Insert the leg alias: '||v_leg_aliases(i).LEG_ALIAS_NAME, V_SP_RET_CODE);

					--save the current leg alias name so it can be used to generate an error message in the event of a PL/SQL or DB error:
					v_curr_leg_alias_name := v_leg_aliases(i).LEG_ALIAS_NAME;

					--insert the leg alias with the alias name convention " (copy)" appended for the new cruise leg (P_NEW_LEG_ID)
					INSERT INTO CCD_LEG_ALIASES (LEG_ALIAS_NAME, LEG_ALIAS_DESC, CRUISE_LEG_ID) VALUES (v_leg_aliases(i).LEG_ALIAS_NAME||' (copy)', v_leg_aliases(i).LEG_ALIAS_DESC, P_NEW_LEG_ID);

					DB_LOG_PKG.ADD_LOG_ENTRY('DEBUG', V_TEMP_LOG_SOURCE, 'Insert the leg alias: '||v_leg_aliases(i).LEG_ALIAS_NAME, V_SP_RET_CODE);

				end loop;

			END IF;

			--handle exceptions
	    EXCEPTION

				--check for unique key constraint errors
				WHEN DUP_VAL_ON_INDEX THEN

					--generate the exception message:
					V_EXCEPTION_MSG := 'The Cruise leg alias "'||v_curr_leg_alias_name||'" could not be copied successfully, there was already a cruise leg alias "'||v_curr_leg_alias_name||' (copy)"';

					--there was an error processing the current cruise leg's aliases
					DB_LOG_PKG.ADD_LOG_ENTRY('ERROR', PV_LOG_MSG_HEADER, V_EXCEPTION_MSG, V_SP_RET_CODE);

					--raise a custom application error:
					RAISE_APPLICATION_ERROR (-20608, V_EXCEPTION_MSG);

	      --catch all PL/SQL database exceptions:
	      WHEN OTHERS THEN
	        --catch all other errors:

					--generate the exception message:
					V_EXCEPTION_MSG := 'The Cruise leg alias "'||v_curr_leg_alias_name||'" could not be copied successfully';

					--there was an error processing the current cruise leg's aliases
					DB_LOG_PKG.ADD_LOG_ENTRY('ERROR', PV_LOG_MSG_HEADER, V_EXCEPTION_MSG, V_SP_RET_CODE);

					--raise a custom application error:
					RAISE_APPLICATION_ERROR (-20609, V_EXCEPTION_MSG);

		END COPY_LEG_ALIASES_SP;




	end CCD_CRUISE_PKG;

/





--define the upgrade version in the database upgrade log table:
INSERT INTO DB_UPGRADE_LOGS (UPGRADE_APP_NAME, UPGRADE_VERSION, UPGRADE_DATE, UPGRADE_DESC) VALUES ('Centralized Cruise Database', '0.25', TO_DATE('10-SEP-20', 'DD-MON-YY'), 'Installed Version 1.2 (Git tag: DVM_db_v1.2) of the Data Validation Module Database (Git URL: git@gitlab.pifsc.gov:centralized-data-tools/data-validation-module.git).  Fixed a bug with the CCD_QC_LEG_OVERLAP_V view.  The CCD_CRUISE_ISS_SUMM_V view was updated to include annotated warnings. A new view CCD_CCDP_DEEP_COPY_CMP_V was developed to help verify that a given CCD_CRUISE_PKG.DEEP_COPY_CRUISE_SP procedure was successful. Updated the CCD_CRUISE_PKG package to implement custom Oracle exceptions and standardize error logging information for error handling purposes. Removed procedure return codes to simplify the code in favor of exceptions except for the CCD_CRUISE_PKG.DEEP_COPY_CRUISE_SP procedure to maintain the current CRDMA functionality.  Updated the CCD_CRUISE_PKG.DEEP_COPY_CRUISE_SP procedure to automatically rollback the transaction to before the procedure call if there is a processing error.  Overloaded the CCD_CRUISE_PKG.DEEP_COPY_CRUISE_SP procedure with a cruise name argument.  Updated the CCD_DVM_PKG package to implement custom Oracle exceptions and standardize error logging information for error handling purposes. Removed procedure return codes to simplify the code in favor of exceptions.  Implemented a new procedure CCD_DVM_PKG.EXEC_DVM_CRUISE_RC_SP to provide the numeric return code for use cases where an exception is not desirable (e.g. batch DVM executions).  Overloaded CCD_DVM_PKG.EXEC_DVM_CRUISE_RC_SP with a cruise name.  A new CCD_DVM_PKG.DELETE_LEG_OVERLAP_SP procedure was developed to help ensure that the DVM information is accurate following the deletion of a cruise leg.  CCD_DVM_PKG.DELETE_LEG_OVERLAP_SP procedure will rollback the transaction to the point before it was executed if there are any processing errors.');


--commit the DB_UPGRADE_LOGS record insertion
COMMIT;
