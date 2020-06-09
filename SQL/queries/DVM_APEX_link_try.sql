


CREATE OR REPLACE View
CCD_QC_CRUISE_V
AS
SELECT
CRUISE_ID,
CRUISE_NAME,
FORMAT_CRUISE_START_DATE,
FORMAT_CRUISE_END_DATE,
STD_SVY_NAME_OTH,
STD_SVY_NAME,
NUM_LEGS,
CRUISE_DAS,
CRUISE_LEN_DAYS,
'220' APEX_PAGE_ID,
'P220_CRUISE_ID,P220_CRUISE_ID_COPY' APEX_PAGE_PARAMS,
REGEXP_SUBSTR(CRUISE_NAME, '^[A-Z]{2}\-([0-9]{2})\-[0-9]{2}$', 1, 1, 'i', 1) CRUISE_NAME_FY,
SUBSTR(TO_CHAR(CRUISE_FISC_YEAR), 3) CRUISE_FISC_YEAR_TRUNC,
CASE WHEN UPPER(CRUISE_NAME) LIKE '% (COPY)%' then 'Y' ELSE 'N' END INV_CRUISE_NAME_COPY_YN,
CASE WHEN STD_SVY_NAME_OTH IS NULL AND STD_SVY_NAME IS NULL THEN 'Y' ELSE 'N' END MISS_STD_SVY_NAME_YN,
CASE WHEN CRUISE_DAS <= 240 AND CRUISE_DAS > 120 THEN 'Y' ELSE 'N' END WARN_CRUISE_DAS_YN,
CASE WHEN CRUISE_DAS > 240 THEN 'Y' ELSE 'N' END ERR_CRUISE_DAS_YN,
CASE WHEN CRUISE_LEN_DAYS <= 280 AND CRUISE_LEN_DAYS > 160 THEN 'Y' ELSE 'N' END WARN_CRUISE_DATE_RNG_YN,
CASE WHEN CRUISE_LEN_DAYS > 280 THEN 'Y' ELSE 'N' END ERR_CRUISE_DATE_RNG_YN,
CASE WHEN NUM_PRIM_SVY_CATS IS NULL THEN 'Y' ELSE 'N' END MISS_PRIM_SVY_CAT_YN,
CASE WHEN NOT REGEXP_LIKE(CRUISE_NAME, '^[A-Z]{2}\-[0-9]{2}\-[0-9]{2}$', 'i') THEN 'Y' ELSE 'N' END INV_CRUISE_NAME_YN,
--if the CRUISE_FISC_YEAR is not null, and the CRUISE_NAME is valid, then check if the last two digits of the fiscal year don't match the extracted fiscal year
CASE WHEN (CRUISE_FISC_YEAR IS NOT NULL AND REGEXP_LIKE(CRUISE_NAME, '^[A-Z]{2}\-[0-9]{2}\-[0-9]{2}$', 'i') AND REGEXP_SUBSTR(CRUISE_NAME, '^[A-Z]{2}\-([0-9]{2})\-[0-9]{2}$', 1, 1, 'i', 1) <> SUBSTR(TO_CHAR(CRUISE_FISC_YEAR), 3)) THEN 'Y' ELSE 'N' END INV_CRUISE_NAME_FY_YN

FROM CCD_CRUISE_DELIM_V
WHERE
UPPER(CRUISE_NAME) LIKE '% (COPY)%'
OR (STD_SVY_NAME_OTH IS NULL AND STD_SVY_NAME IS NULL)
OR (CRUISE_DAS <= 240 AND CRUISE_DAS > 120)
OR (CRUISE_DAS > 240)
OR (CRUISE_LEN_DAYS <= 280 AND CRUISE_LEN_DAYS > 160)
OR (CRUISE_LEN_DAYS > 280)
OR (NUM_PRIM_SVY_CATS IS NULL)
OR (NOT REGEXP_LIKE(CRUISE_NAME, '^[A-Z]{2}\-[0-9]{2}\-[0-9]{2}$', 'i'))
OR (CRUISE_FISC_YEAR IS NOT NULL AND REGEXP_LIKE(CRUISE_NAME, '^[A-Z]{2}\-[0-9]{2}\-[0-9]{2}$', 'i') AND REGEXP_SUBSTR(CRUISE_NAME, '^[A-Z]{2}\-([0-9]{2})\-[0-9]{2}$', 1, 1, 'i', 1) <> SUBSTR(TO_CHAR(CRUISE_FISC_YEAR), 3))
ORDER BY CRUISE_NAME, CRUISE_START_DATE;


COMMENT ON TABLE CCD_QC_CRUISE_V IS 'Cruise (QC View)

This query identifies data validation issues with Cruises (e.g. invalid standard survey name, invalid cruise name, etc.).  This QC View is implemented in the Data Validation Module';

COMMENT ON COLUMN CCD_QC_CRUISE_V.CRUISE_ID IS 'Primary key for the CCD_CRUISES table';
COMMENT ON COLUMN CCD_QC_CRUISE_V.CRUISE_NAME IS 'The name of the given cruise designated by NOAA (e.g. SE-15-01)';
COMMENT ON COLUMN CCD_QC_CRUISE_V.FORMAT_CRUISE_START_DATE IS 'The formatted start date for the given cruise (based on the earliest associated cruise leg''s start date) in MM/DD/YYYY HH24:MI:SS format';
COMMENT ON COLUMN CCD_QC_CRUISE_V.FORMAT_CRUISE_END_DATE IS 'The formatted end date for the given cruise (based on the latest associated cruise leg''s end date) in MM/DD/YYYY HH24:MI:SS format';
COMMENT ON COLUMN CCD_QC_CRUISE_V.STD_SVY_NAME_OTH IS 'Field defines a Standard Survey Name that is not included in the Standard Survey Name table';
COMMENT ON COLUMN CCD_QC_CRUISE_V.STD_SVY_NAME IS 'Name of the given Survey Type';
COMMENT ON COLUMN CCD_QC_CRUISE_V.INV_CRUISE_NAME_COPY_YN IS 'Field to indicate if there is an Invalid Copied Cruise Name error (Y) or not (N) based on whether or not the value of CRUISE_NAME contains "(copy)"';
COMMENT ON COLUMN CCD_QC_CRUISE_V.MISS_STD_SVY_NAME_YN IS 'Field to indicate if there is a missing Standard Survey Name error (Y) or not (N) based on whether or not both STD_SVY_NAME_OTH and STD_SVY_NAME_ID are NULL';

COMMENT ON COLUMN CCD_QC_CRUISE_V.CRUISE_DAS IS 'The total number of days at sea for each of the legs associated with the given cruise';
COMMENT ON COLUMN CCD_QC_CRUISE_V.CRUISE_LEN_DAYS IS 'The total number of days between the Cruise Start and End Dates for the given cruise';

COMMENT ON COLUMN CCD_QC_CRUISE_V.NUM_LEGS IS 'The number of cruise legs associated with the given cruise';


COMMENT ON COLUMN CCD_QC_CRUISE_V.APEX_PAGE_ID IS 'The page number for the corresponding CRDMA apex page that allows the cruise record to be updated so the error can be reviewed and resolved/annotated';

COMMENT ON COLUMN CCD_QC_CRUISE_V.APEX_PAGE_PARAMS IS 'The APEX page parameters for the corresponding CRDMA apex page that allows the cruise record to be updated so the error can be reviewed and resolved/annotated';


COMMENT ON COLUMN CCD_QC_CRUISE_V.WARN_CRUISE_DAS_YN IS 'Field to indicate if there is an abnormally high number of days at sea warning (> 120 days) for the given cruise (Y) or not (N) based on the associated leg dates';
COMMENT ON COLUMN CCD_QC_CRUISE_V.ERR_CRUISE_DAS_YN IS 'Field to indicate if there is an unacceptably high number of days at sea error ( > 240 days) for the given cruise (Y) or not (N) based on the associated leg dates';
COMMENT ON COLUMN CCD_QC_CRUISE_V.WARN_CRUISE_DATE_RNG_YN IS 'Field to indicate if there is an abnormally high cruise length warning ( > 160 days) for the given cruise (Y) or not (N) based on the associated leg dates';
COMMENT ON COLUMN CCD_QC_CRUISE_V.ERR_CRUISE_DATE_RNG_YN IS 'Field to indicate if there is an unacceptably high cruise length error ( > 280 days) for the given cruise (Y) or not (N) based on the associated leg dates';

COMMENT ON COLUMN CCD_QC_CRUISE_V.MISS_PRIM_SVY_CAT_YN IS 'Field to indicate if there isn''t at least one Primary Survey Category defined for the given cruise (Y) or not (N)';

COMMENT ON COLUMN CCD_QC_CRUISE_V.CRUISE_NAME_FY IS 'The extracted fiscal year value from the Cruise Name based on the naming convention [SN]-[YR]-[##] where [YR] is a two digit year with a leading zero';
COMMENT ON COLUMN CCD_QC_CRUISE_V.CRUISE_FISC_YEAR_TRUNC IS 'The two digit fiscal year value derived from the Cruise''s Fiscal Year';
COMMENT ON COLUMN CCD_QC_CRUISE_V.INV_CRUISE_NAME_YN IS 'Field to indicate if the Cruise Name is valid (Y) or not (N) based on the required naming convention [SN]-[YR]-[##] where [SN] is a valid NOAA ship name, [YR] is a two digit year with a leading zero, and [##] is a sequential number with a leading zero';
COMMENT ON COLUMN CCD_QC_CRUISE_V.INV_CRUISE_NAME_FY_YN IS 'Field to indicate if the Cruise Name''s extracted Fiscal Year value matches the Cruise''s Fiscal Year (Y) or not (N) based on the Cruise Name naming convention [SN]-[YR]-[##] where [YR] is a two digit year with a leading zero';

CREATE OR REPLACE View
CCD_QC_LEG_V
AS
SELECT
CRUISE_ID,
CRUISE_NAME,
CRUISE_LEG_ID,
LEG_NAME,
FORMAT_LEG_START_DATE,
FORMAT_LEG_END_DATE,
VESSEL_NAME,
LEG_DAS,
CASE WHEN UPPER(LEG_NAME) LIKE '% (COPY)%' then 'Y' ELSE 'N' END INV_LEG_NAME_COPY_YN,
CASE WHEN LEG_START_DATE > LEG_END_DATE then 'Y' ELSE 'N' END INV_LEG_DATES_YN,
CASE WHEN LEG_DAS <= 90 AND LEG_DAS > 30 THEN 'Y' ELSE 'N' END WARN_LEG_DAS_YN,
CASE WHEN LEG_DAS > 90 THEN 'Y' ELSE 'N' END ERR_LEG_DAS_YN,
CASE WHEN NUM_GEAR IS NULL THEN 'Y' ELSE 'N' END MISS_GEAR_YN


FROM CCD_CRUISE_LEG_DELIM_V
WHERE
CRUISE_LEG_ID IS NOT NULL AND
((UPPER(LEG_NAME) LIKE '% (COPY)%')
OR (LEG_START_DATE > LEG_END_DATE)
OR (LEG_DAS <= 90 AND LEG_DAS > 30)
OR (LEG_DAS > 90)
OR (NUM_GEAR IS NULL))
ORDER BY
LEG_NAME, LEG_START_DATE;

COMMENT ON TABLE CCD_QC_LEG_V IS 'Cruise Leg (QC View)

This query identifies data validation issues with Cruise Legs (e.g. invalid leg dates, invalid leg name, etc.).  This QC View is implemented in the Data Validation Module';

COMMENT ON COLUMN CCD_QC_LEG_V.CRUISE_ID IS 'Primary key for the CCD_CRUISES table';
COMMENT ON COLUMN CCD_QC_LEG_V.CRUISE_NAME IS 'The name of the given cruise designated by NOAA (e.g. SE-15-01)';
COMMENT ON COLUMN CCD_QC_LEG_V.CRUISE_LEG_ID IS 'Primary key for the CCD_CRUISE_LEGS table';
COMMENT ON COLUMN CCD_QC_LEG_V.LEG_NAME IS 'The name of the given cruise leg';
COMMENT ON COLUMN CCD_QC_LEG_V.FORMAT_LEG_START_DATE IS 'The start date for the given research cruise leg in MM/DD/YYYY format';
COMMENT ON COLUMN CCD_QC_LEG_V.FORMAT_LEG_END_DATE IS 'The end date for the given research cruise leg in MM/DD/YYYY format';
COMMENT ON COLUMN CCD_QC_LEG_V.VESSEL_NAME IS 'Name of the given research vessel';
COMMENT ON COLUMN CCD_QC_LEG_V.INV_LEG_NAME_COPY_YN IS 'Field to indicate if there is an Invalid Copied Leg Name error (Y) or not (N) based on whether or not the value of LEG_NAME contains "(copy)"';
COMMENT ON COLUMN CCD_QC_LEG_V.INV_LEG_DATES_YN IS 'Field to indicate if there is an Invalid Leg Dates error (Y) or not (N) based on whether or not the LEG_START_DATE occurs after the LEG_END_DATE';
COMMENT ON COLUMN CCD_QC_LEG_V.LEG_DAS IS 'The number of days at sea for the given research cruise leg';

COMMENT ON COLUMN CCD_QC_LEG_V.WARN_LEG_DAS_YN IS 'Field to indicate if there is an abnormally high number of days at sea warning (> 30 days) for the given cruise leg (Y) or not (N) based on the leg dates';
COMMENT ON COLUMN CCD_QC_LEG_V.ERR_LEG_DAS_YN IS 'Field to indicate if there is an unacceptably high number of days at sea error (> 90 days) for the given cruise leg (Y) or not (N) based on the leg dates';

COMMENT ON COLUMN CCD_QC_LEG_V.MISS_GEAR_YN IS 'Field to indicate if there isn''t at least one Gear type defined for the given cruise leg (Y) or not (N)';
