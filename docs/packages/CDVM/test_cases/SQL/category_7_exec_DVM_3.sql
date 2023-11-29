/********************************************/
--Revert data model from category 7 part 2:
/********************************************/


	--revert the CCD_CRUISES table definition:
ALTER TABLE CCD_CRUISES RENAME COLUMN CRUISE_URL2 TO CRUISE_URL;


	UPDATE DVM_QC_OBJECTS SET OBJECT_NAME = 'CCD_QC_CRUISE_V' WHERE OBJECT_NAME = 'CCD_QC_CRUISE_TEMP_V';


	--recompile invalid views:
	ALTER VIEW CCD_CRUISE_V COMPILE;
	ALTER VIEW CCD_QC_CRUISE_V COMPILE;
	ALTER VIEW CCD_QC_LEG_ALIAS_V COMPILE;
	ALTER VIEW CCD_QC_LEG_OVERLAP_V COMPILE;
	ALTER VIEW CCD_QC_LEG_V COMPILE;
	ALTER VIEW CCD_CRUISE_DELIM_V COMPILE;
	ALTER VIEW CCD_CRUISE_ISS_SUMM_V COMPILE;
	ALTER VIEW CCD_CRUISE_LEG_DELIM_V COMPILE;
	ALTER VIEW CCD_CRUISE_LEG_V COMPILE;
	ALTER VIEW CCD_CRUISE_SUMM_ISS_V COMPILE;
	ALTER VIEW CCD_CRUISE_SUMM_V COMPILE;
	ALTER VIEW CCD_CRUISE_DVM_EVAL_RPT_V COMPILE;
	ALTER VIEW CCD_CRUISE_DVM_RULE_EVAL_V COMPILE;
	ALTER VIEW CCD_CRUISE_DVM_RULE_EVAL_RPT_V COMPILE;

	ALTER VIEW CCD_LEG_DATA_SETS_V COMPILE;
	ALTER VIEW CCD_CRUISE_LEG_AGG_V COMPILE;
	ALTER VIEW CCD_CRUISE_LEG_DATA_SETS_MIN_V COMPILE;
	ALTER VIEW CCD_CRUISE_LEG_DATA_SETS_V COMPILE;


	ALTER VIEW CCD_CRUISE_DVM_RULES_V COMPILE;

	ALTER VIEW CCD_CRUISE_DVM_RULES_RPT_V COMPILE;

	ALTER VIEW DVM_RULE_SETS_RPT_V COMPILE;

	ALTER VIEW DVM_PTA_ISS_TYPES_V COMPILE;

	ALTER PACKAGE CCD_CRUISE_PKG COMPILE;
	ALTER PACKAGE DVM_PKG COMPILE;
	ALTER PACKAGE CCD_DVM_PKG COMPILE;

	ALTER VIEW DVM_PTA_RULE_SETS_HIST_RPT_V COMPILE;
	ALTER VIEW DVM_PTA_RULE_SETS_RPT_V COMPILE;

--restore the CCD_QC_LEG_ALIAS_V data QC view:
CREATE OR REPLACE View
CCD_QC_LEG_ALIAS_V
AS
SELECT
CCD_CRUISE_LEG_V.CRUISE_LEG_ID,
CRUISE_ID,
CRUISE_NAME,
LEG_NAME,
FORMAT_LEG_START_DATE,
FORMAT_LEG_END_DATE,
VESSEL_NAME,
LEG_ALIAS_NAME,
LEG_ALIAS_DESC,
CASE WHEN UPPER(LEG_ALIAS_NAME) LIKE '% (COPY)%' then 'Y' ELSE 'N' END INV_LEG_ALIAS_COPY_YN

FROM CCD_CRUISE_LEG_V
INNER JOIN
CCD_LEG_ALIASES
ON CCD_CRUISE_LEG_V.CRUISE_LEG_ID = CCD_LEG_ALIASES.CRUISE_LEG_ID

WHERE
UPPER(LEG_ALIAS_NAME) LIKE '% (COPY)%'
ORDER BY LEG_NAME
;

COMMENT ON TABLE CCD_QC_LEG_ALIAS_V IS 'Leg Alias (QC View)

This query identifies data validation issues with Cruise Leg Aliases (e.g. invalid alias name).	This QC View is implemented in the Data Validation Module';
COMMENT ON COLUMN CCD_QC_LEG_ALIAS_V.CRUISE_ID IS 'Primary key for the CCD_CRUISES table';
COMMENT ON COLUMN CCD_QC_LEG_ALIAS_V.CRUISE_NAME IS 'The name of the given cruise designated by NOAA (e.g. SE-15-01)';
COMMENT ON COLUMN CCD_QC_LEG_ALIAS_V.CRUISE_LEG_ID IS 'Primary key for the CCD_CRUISE_LEGS table';
COMMENT ON COLUMN CCD_QC_LEG_ALIAS_V.LEG_NAME IS 'The name of the given cruise leg';
COMMENT ON COLUMN CCD_QC_LEG_ALIAS_V.VESSEL_NAME IS 'Name of the given research vessel';
COMMENT ON COLUMN CCD_QC_LEG_ALIAS_V.LEG_ALIAS_NAME IS 'The cruise leg alias name for the given cruise leg';
COMMENT ON COLUMN CCD_QC_LEG_ALIAS_V.LEG_ALIAS_DESC IS 'The cruise leg alias description for the given cruise leg';
COMMENT ON COLUMN CCD_QC_LEG_ALIAS_V.INV_LEG_ALIAS_COPY_YN IS 'Field to indicate if there is an Invalid Copied Leg Alias Name error (Y) or not (N) based on whether or not the value of LEG_ALIAS_NAME contains "(copy)"';




COMMENT ON COLUMN CCD_QC_LEG_ALIAS_V.FORMAT_LEG_START_DATE IS 'The start date in the corresponding time zone for the given research cruise leg in MM/DD/YYYY format';
COMMENT ON COLUMN CCD_QC_LEG_ALIAS_V.FORMAT_LEG_END_DATE IS 'The end date in the corresponding time zone for the given research cruise leg in MM/DD/YYYY format';



CREATE OR REPLACE View
CCD_QC_LEG_V
AS
SELECT
CCD_CRUISES.CRUISE_ID,
CCD_CRUISES.CRUISE_NAME,
CCD_LEG_DELIM_V.CRUISE_LEG_ID,
CCD_LEG_DELIM_V.LEG_NAME,
CCD_LEG_DELIM_V.FORMAT_LEG_START_DATE,
CCD_LEG_DELIM_V.FORMAT_LEG_END_DATE,
CCD_LEG_DELIM_V.VESSEL_NAME,
CCD_LEG_DELIM_V.LEG_DAS,
CCD_LEG_DELIM_V.TZ_NAME,
CASE WHEN UPPER(CCD_LEG_DELIM_V.LEG_NAME) LIKE '% (COPY)%' then 'Y' ELSE 'N' END INV_LEG_NAME_COPY_YN,
CASE WHEN CCD_LEG_DELIM_V.LEG_START_DATE > CCD_LEG_DELIM_V.LEG_END_DATE then 'Y' ELSE 'N' END INV_LEG_DATES_YN,
CASE WHEN CCD_LEG_DELIM_V.LEG_DAS <= 90 AND CCD_LEG_DELIM_V.LEG_DAS > 30 THEN 'Y' ELSE 'N' END WARN_LEG_DAS_YN,
CASE WHEN CCD_LEG_DELIM_V.LEG_DAS > 90 THEN 'Y' ELSE 'N' END ERR_LEG_DAS_YN,
CASE WHEN CCD_LEG_DELIM_V.NUM_GEAR = 0 THEN 'Y' ELSE 'N' END MISS_GEAR_YN,
CASE WHEN CCD_LEG_DELIM_V.NUM_DATA_SETS = 0 THEN 'Y' ELSE 'N' END MISS_DATA_SET_YN,
CASE WHEN NOT EXISTS (SELECT * from V$TIMEZONE_NAMES WHERE UPPER(TZNAME) = UPPER(CCD_LEG_DELIM_V.TZ_NAME)) THEN 'Y' ELSE 'N' END INV_TZ_NAME_YN


FROM
CCD_CRUISES INNER JOIN
CCD_LEG_DELIM_V
ON CCD_CRUISES.CRUISE_ID = CCD_LEG_DELIM_V.CRUISE_ID
WHERE
CCD_LEG_DELIM_V.CRUISE_LEG_ID IS NOT NULL AND
((UPPER(CCD_LEG_DELIM_V.LEG_NAME) LIKE '% (COPY)%')
OR (CCD_LEG_DELIM_V.LEG_START_DATE > CCD_LEG_DELIM_V.LEG_END_DATE)
OR (CCD_LEG_DELIM_V.LEG_DAS <= 90 AND CCD_LEG_DELIM_V.LEG_DAS > 30)
OR (CCD_LEG_DELIM_V.LEG_DAS > 90)
OR (CCD_LEG_DELIM_V.NUM_GEAR = 0)
OR (CCD_LEG_DELIM_V.NUM_DATA_SETS = 0)
OR NOT EXISTS (SELECT * from V$TIMEZONE_NAMES WHERE UPPER(TZNAME) = UPPER(CCD_LEG_DELIM_V.TZ_NAME))
)

ORDER BY
CCD_LEG_DELIM_V.LEG_NAME, CCD_LEG_DELIM_V.LEG_START_DATE;

COMMENT ON TABLE CCD_QC_LEG_V IS 'Cruise Leg (QC View)

This query identifies data validation issues with Cruise Legs (e.g. invalid leg dates, invalid leg name, etc.).	This QC View is implemented in the Data Validation Module';

COMMENT ON COLUMN CCD_QC_LEG_V.CRUISE_ID IS 'Primary key for the CCD_CRUISES table';
COMMENT ON COLUMN CCD_QC_LEG_V.CRUISE_NAME IS 'The name of the given cruise designated by NOAA (e.g. SE-15-01)';
COMMENT ON COLUMN CCD_QC_LEG_V.CRUISE_LEG_ID IS 'Primary key for the CCD_CRUISE_LEGS table';
COMMENT ON COLUMN CCD_QC_LEG_V.LEG_NAME IS 'The name of the given cruise leg';
COMMENT ON COLUMN CCD_QC_LEG_V.VESSEL_NAME IS 'Name of the given research vessel';
COMMENT ON COLUMN CCD_QC_LEG_V.INV_LEG_NAME_COPY_YN IS 'Field to indicate if there is an Invalid Copied Leg Name error (Y) or not (N) based on whether or not the value of LEG_NAME contains "(copy)"';
COMMENT ON COLUMN CCD_QC_LEG_V.INV_LEG_DATES_YN IS 'Field to indicate if there is an Invalid Leg Dates error (Y) or not (N) based on whether or not the LEG_START_DATE occurs after the LEG_END_DATE';

COMMENT ON COLUMN CCD_QC_LEG_V.INV_TZ_NAME_YN IS 'Field to indicate if there is an Invalid Timezone Name error (Y) or not (N) based on the Oracle timezone reference list';

COMMENT ON COLUMN CCD_QC_LEG_V.LEG_DAS IS 'The number of days at sea for the given research cruise leg';

COMMENT ON COLUMN CCD_QC_LEG_V.WARN_LEG_DAS_YN IS 'Field to indicate if there is an abnormally high number of days at sea warning (> 30 days) for the given cruise leg (Y) or not (N) based on the leg dates';
COMMENT ON COLUMN CCD_QC_LEG_V.ERR_LEG_DAS_YN IS 'Field to indicate if there is an unacceptably high number of days at sea error (> 90 days) for the given cruise leg (Y) or not (N) based on the leg dates';

COMMENT ON COLUMN CCD_QC_LEG_V.MISS_GEAR_YN IS 'Field to indicate if there isn''t at least one Gear type defined for the given cruise leg (Y) or not (N)';

COMMENT ON COLUMN CCD_QC_LEG_V.MISS_DATA_SET_YN IS 'Field to indicate if there isn''t at least one data set associated with the given cruise leg (Y) or not (N)';


COMMENT ON COLUMN CCD_QC_LEG_V.TZ_NAME IS 'The numeric offset for UTC or Time Zone Name (V$TIMEZONE_NAMES.TZNAME) for the local timezone where the cruise leg occurred (e.g. US/Hawaii, US/Samoa, Etc/GMT+9)';


COMMENT ON COLUMN CCD_QC_LEG_V.FORMAT_LEG_START_DATE IS 'The start date in the corresponding time zone for the given research cruise leg in MM/DD/YYYY format';

COMMENT ON COLUMN CCD_QC_LEG_V.FORMAT_LEG_END_DATE IS 'The end date in the corresponding time zone for the given research cruise leg in MM/DD/YYYY format';

ALTER VIEW CCD_CCDP_DEEP_COPY_CMP_V COMPILE;

--delete the DVM records:
@@"../../../../../SQL/queries/delete_all_DVM_recs.sql";
