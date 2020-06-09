

CREATE OR REPLACE View
CCD_QC_LEG_OVERLAP_V
AS
select
V1.CRUISE_ID CRUISE_ID,
V1.CRUISE_NAME CRUISE_NAME1,
V1.CRUISE_LEG_ID CRUISE_LEG_ID1,
V1.LEG_NAME CRUISE_LEG_NAME1,
V1.VESSEL_NAME VESSEL_NAME1,
V1.FORMAT_LEG_START_DATE FORMAT_LEG_START_DATE1,
V1.FORMAT_LEG_END_DATE FORMAT_LEG_END_DATE1,
V2.CRUISE_ID CRUISE_ID2,
V2.CRUISE_NAME CRUISE_NAME2,
V2.CRUISE_LEG_ID CRUISE_LEG_ID2,
V2.LEG_NAME CRUISE_LEG_NAME2,
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

ORDER BY V1.CRUISE_NAME, V1.LEG_NAME, V1.LEG_START_DATE, V1.CRUISE_ID, V1.CRUISE_LEG_ID;

COMMENT ON TABLE CCD_QC_LEG_OVERLAP_V IS 'Cruise Leg Overlap (QC View)

This query identifies data validation issues based on the cruise leg dates (e.g. cruise legs overlap, vessel legs overlap).  This QC View is implemented in the Data Validation Module';

COMMENT ON COLUMN CCD_QC_LEG_OVERLAP_V.CRUISE_ID IS 'Primary key for the first CCD_CRUISES record';
COMMENT ON COLUMN CCD_QC_LEG_OVERLAP_V.CRUISE_NAME1 IS 'The name of the first cruise designated by NOAA (e.g. SE-15-01)';
COMMENT ON COLUMN CCD_QC_LEG_OVERLAP_V.CRUISE_LEG_ID1 IS 'Primary key for the first CCD_CRUISE_LEGS record';
COMMENT ON COLUMN CCD_QC_LEG_OVERLAP_V.CRUISE_LEG_NAME1 IS 'The name of the first cruise leg';
COMMENT ON COLUMN CCD_QC_LEG_OVERLAP_V.VESSEL_NAME1 IS 'Name of the given research vessel for the first cruise leg';
COMMENT ON COLUMN CCD_QC_LEG_OVERLAP_V.FORMAT_LEG_START_DATE1 IS 'The start date for the first research cruise leg in MM/DD/YYYY format';
COMMENT ON COLUMN CCD_QC_LEG_OVERLAP_V.FORMAT_LEG_END_DATE1 IS 'The end date for the first research cruise leg in MM/DD/YYYY format';
COMMENT ON COLUMN CCD_QC_LEG_OVERLAP_V.CRUISE_ID2 IS 'Primary key for the second CCD_CRUISES record';
COMMENT ON COLUMN CCD_QC_LEG_OVERLAP_V.CRUISE_NAME2 IS 'The name of the second cruise designated by NOAA (e.g. SE-15-01)';
COMMENT ON COLUMN CCD_QC_LEG_OVERLAP_V.CRUISE_LEG_ID2 IS 'Primary key for the second CCD_CRUISE_LEGS record';
COMMENT ON COLUMN CCD_QC_LEG_OVERLAP_V.CRUISE_LEG_NAME2 IS 'The name of the second cruise leg';
COMMENT ON COLUMN CCD_QC_LEG_OVERLAP_V.VESSEL_NAME2 IS 'Name of the given research vessel for the second cruise leg';
COMMENT ON COLUMN CCD_QC_LEG_OVERLAP_V.FORMAT_LEG_START_DATE2 IS 'The start date for the second research cruise leg in MM/DD/YYYY format';
COMMENT ON COLUMN CCD_QC_LEG_OVERLAP_V.FORMAT_LEG_END_DATE2 IS 'The end date for the second research cruise leg in MM/DD/YYYY format';
COMMENT ON COLUMN CCD_QC_LEG_OVERLAP_V.CRUISE_OVERLAP_YN IS 'Field to indicate if there is an Vessel Leg Overlap error (Y) or not (N) based on whether or not two cruise leg dates for the same cruise overlap with each other';
COMMENT ON COLUMN CCD_QC_LEG_OVERLAP_V.VESSEL_OVERLAP_YN IS 'Field to indicate if there is an Vessel Leg Overlap error (Y) or not (N) based on whether or not two cruise leg dates for the same vessel overlap with each other';


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
CASE WHEN LEG_DAS > 90 THEN 'Y' ELSE 'N' END ERR_LEG_DAS_YN


FROM CCD_CRUISE_LEGS_V
WHERE
(UPPER(LEG_NAME) LIKE '% (COPY)%')
OR (LEG_START_DATE > LEG_END_DATE)
OR (LEG_DAS <= 90 AND LEG_DAS > 30)
OR (LEG_DAS > 90)
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
CASE WHEN UPPER(CRUISE_NAME) LIKE '% (COPY)%' then 'Y' ELSE 'N' END INV_CRUISE_NAME_COPY_YN,
CASE WHEN STD_SVY_NAME_OTH IS NULL AND STD_SVY_NAME IS NULL THEN 'Y' ELSE 'N' END MISS_STD_SVY_NAME_YN,
CASE WHEN CRUISE_DAS <= 240 AND CRUISE_DAS > 120 THEN 'Y' ELSE 'N' END WARN_CRUISE_DAS_YN,
CASE WHEN CRUISE_DAS > 240 THEN 'Y' ELSE 'N' END ERR_CRUISE_DAS_YN,
CASE WHEN CRUISE_LEN_DAYS <= 280 AND CRUISE_LEN_DAYS > 160 THEN 'Y' ELSE 'N' END WARN_CRUISE_DATE_RNG_YN,
CASE WHEN CRUISE_LEN_DAYS > 280 THEN 'Y' ELSE 'N' END ERR_CRUISE_DATE_RNG_YN


FROM CCD_CRUISE_V
WHERE
UPPER(CRUISE_NAME) LIKE '% (COPY)%'
OR (STD_SVY_NAME_OTH IS NULL AND STD_SVY_NAME IS NULL)
OR (CRUISE_DAS <= 240 AND CRUISE_DAS > 120)
OR (CRUISE_DAS > 240)
OR (CRUISE_LEN_DAYS <= 280 AND CRUISE_LEN_DAYS > 160)
OR (CRUISE_LEN_DAYS > 280)

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

COMMENT ON COLUMN CCD_QC_CRUISE_V.WARN_CRUISE_DAS_YN IS 'Field to indicate if there is an abnormally high number of days at sea warning (> 120 days) for the given cruise (Y) or not (N) based on the associated leg dates';
COMMENT ON COLUMN CCD_QC_CRUISE_V.ERR_CRUISE_DAS_YN IS 'Field to indicate if there is an unacceptably high number of days at sea error ( > 240 days) for the given cruise (Y) or not (N) based on the associated leg dates';
COMMENT ON COLUMN CCD_QC_CRUISE_V.WARN_CRUISE_DATE_RNG_YN IS 'Field to indicate if there is an abnormally high cruise length warning ( > 160 days) for the given cruise (Y) or not (N) based on the associated leg dates';
COMMENT ON COLUMN CCD_QC_CRUISE_V.ERR_CRUISE_DATE_RNG_YN IS 'Field to indicate if there is an unacceptably high cruise length error ( > 280 days) for the given cruise (Y) or not (N) based on the associated leg dates';


CREATE OR REPLACE View
CCD_QC_LEG_ALIAS_V
AS
SELECT
CCD_CRUISE_LEGS_V.CRUISE_LEG_ID,
CRUISE_ID,
CRUISE_NAME,
LEG_NAME,
FORMAT_LEG_START_DATE,
FORMAT_LEG_END_DATE,
VESSEL_NAME,
LEG_ALIAS_NAME,
LEG_ALIAS_DESC,
CASE WHEN UPPER(LEG_ALIAS_NAME) LIKE '% (COPY)%' then 'Y' ELSE 'N' END INV_LEG_ALIAS_COPY_YN

FROM CCD_CRUISE_LEGS_V
INNER JOIN
CCD_LEG_ALIASES
ON CCD_CRUISE_LEGS_V.CRUISE_LEG_ID = CCD_LEG_ALIASES.CRUISE_LEG_ID

WHERE
UPPER(LEG_ALIAS_NAME) LIKE '% (COPY)%'
ORDER BY LEG_NAME
;

COMMENT ON TABLE CCD_QC_LEG_ALIAS_V IS 'Leg Alias (QC View)

This query identifies data validation issues with Cruise Leg Aliases (e.g. invalid alias name).  This QC View is implemented in the Data Validation Module';
COMMENT ON COLUMN CCD_QC_LEG_ALIAS_V.CRUISE_ID IS 'Primary key for the CCD_CRUISES table';
COMMENT ON COLUMN CCD_QC_LEG_ALIAS_V.CRUISE_NAME IS 'The name of the given cruise designated by NOAA (e.g. SE-15-01)';
COMMENT ON COLUMN CCD_QC_LEG_ALIAS_V.CRUISE_LEG_ID IS 'Primary key for the CCD_CRUISE_LEGS table';
COMMENT ON COLUMN CCD_QC_LEG_ALIAS_V.LEG_NAME IS 'The name of the given cruise leg';
COMMENT ON COLUMN CCD_QC_LEG_ALIAS_V.FORMAT_LEG_START_DATE IS 'The start date for the given research cruise leg in MM/DD/YYYY format';
COMMENT ON COLUMN CCD_QC_LEG_ALIAS_V.FORMAT_LEG_END_DATE IS 'The end date for the given research cruise leg in MM/DD/YYYY format';
COMMENT ON COLUMN CCD_QC_LEG_ALIAS_V.VESSEL_NAME IS 'Name of the given research vessel';
COMMENT ON COLUMN CCD_QC_LEG_ALIAS_V.LEG_ALIAS_NAME IS 'The cruise leg alias name for the given cruise leg';
COMMENT ON COLUMN CCD_QC_LEG_ALIAS_V.LEG_ALIAS_DESC IS 'The cruise leg alias description for the given cruise leg';
COMMENT ON COLUMN CCD_QC_LEG_ALIAS_V.INV_LEG_ALIAS_COPY_YN IS 'Field to indicate if there is an Invalid Copied Leg Alias Name error (Y) or not (N) based on whether or not the value of LEG_ALIAS_NAME contains "(copy)"';
