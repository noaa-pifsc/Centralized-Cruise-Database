/********************************************/
--Revert queries from category 7 part 1:
/********************************************/

--revert the primary key query:
ALTER TABLE DVM_ISS_TYP_ASSOC
ADD CONSTRAINT DVM_ISS_TYP_ASSOC_PK PRIMARY KEY
(
  ISS_TYP_ASSOC_ID
)
ENABLE;


--remove the compound primary key from DVM_ISSUES_HIST:
ALTER TABLE DVM_ISSUES_HIST
DROP CONSTRAINT DVM_ISSUES_HIST_PK;

--ALTER TABLE DVM_ISSUES_HIST MODIFY (H_SEQNUM NULL);

ALTER TABLE DVM_ISSUES_HIST
MODIFY (H_TYPE_OF_CHANGE NULL);



ALTER TABLE DVM_ISSUES_HIST
ADD CONSTRAINT DVM_ISSUES_HIST_PK PRIMARY KEY
(
  H_SEQNUM
)
ENABLE;

--remove the compound primary key from DVM_ISS_SEVERITY_HIST:

ALTER TABLE DVM_ISS_SEVERITY_HIST
DROP CONSTRAINT DVM_ISS_SEVERITY_HIST_PK;

-- ALTER TABLE DVM_ISS_SEVERITY_HIST MODIFY (H_SEQNUM NULL);

ALTER TABLE DVM_ISS_SEVERITY_HIST
MODIFY (ISS_SEVERITY_ID NULL);


ALTER TABLE DVM_ISS_SEVERITY_HIST
ADD CONSTRAINT DVM_ISS_SEVERITY_HIST_PK PRIMARY KEY
(
  H_SEQNUM
)
ENABLE;


--update the data stream to the original parent table
UPDATE DVM_DATA_STREAMS SET DATA_STREAM_PAR_TABLE = 'CCD_CRUISES' WHERE DATA_STREAM_CODE = 'CCD_TEST2';

--update the data stream to the original parent table
UPDATE DVM_DATA_STREAMS SET DATA_STREAM_PAR_TABLE = 'CCD_CRUISES' WHERE DATA_STREAM_CODE = 'CCD_TEST';

	--remove the test data stream
	DELETE FROM DVM_DATA_STREAMS WHERE DATA_STREAM_CODE = 'CCD_TEST3';

	--remove the test data stream
	DELETE FROM DVM_DATA_STREAMS WHERE DATA_STREAM_CODE = 'CCD_TEST4';


	--remove the test data stream
	DELETE FROM DVM_DATA_STREAMS WHERE DATA_STREAM_CODE = 'CCD_TEST5';

	--revert the issue type's comment template :
	UPDATE DVM_ISS_TYPES SET APP_LINK_TEMPLATE = REPLACE(APP_LINK_TEMPLATE, '[CRUISE_ID][ABC][DEF]', '[CRUISE_ID]') WHERE IND_FIELD_NAME = 'INV_CRUISE_NAME_YN';



	--revert the issue type's comment template :
	UPDATE DVM_ISS_TYPES SET APP_LINK_TEMPLATE = REPLACE(APP_LINK_TEMPLATE, '[CRUISE_LEG_ID1][GHI][JKL]', '[CRUISE_LEG_ID1]') WHERE IND_FIELD_NAME = 'VESSEL_OVERLAP_YN';

	--revert the issue type's comment template :
	UPDATE DVM_ISS_TYPES SET ISS_TYPE_COMMENT_TEMPLATE = REPLACE(ISS_TYPE_COMMENT_TEMPLATE, '[CRUISE_NAME][ABC][DEF]', '[CRUISE_NAME]') WHERE IND_FIELD_NAME = 'INV_CRUISE_NAME_YN';


	--revert the issue type's comment template :
	UPDATE DVM_ISS_TYPES SET ISS_TYPE_COMMENT_TEMPLATE = REPLACE(ISS_TYPE_COMMENT_TEMPLATE, '[CRUISE_NAME1][XYZ]', '[CRUISE_NAME1]') WHERE IND_FIELD_NAME = 'VESSEL_OVERLAP_YN';

	--remove the duplicate active rule set:
	DELETE FROM DVM_RULE_SETS WHERE RULE_SET_CREATE_DATE = (SELECT MAX(RULE_SET_CREATE_DATE) FROM DVM_RULE_SETS WHERE RULE_SET_ACTIVE_YN = 'Y');

	--re-enable all QC object validation rules:
	UPDATE DVM_QC_OBJECTS SET QC_OBJ_ACTIVE_YN = 'Y' WHERE OBJECT_NAME IN ('CCD_QC_LEG_ALIAS_V', 'CCD_QC_LEG_OVERLAP_V', 'CCD_QC_CRUISE_V');

	UPDATE DVM_ISS_TYPES SET ISS_TYPE_ACTIVE_YN = 'Y' WHERE IND_FIELD_NAME IN ('ERR_LEG_DAS_YN', 'MISS_GEAR_YN', 'WARN_LEG_DAS_YN');


	--update the indicator fields to revert the missing QC view field names:
	UPDATE DVM_ISS_TYPES SET IND_FIELD_NAME = 'CRUISE_OVERLAP_YN' WHERE ISS_TYPE_NAME = 'Cruise Leg Overlap';

	UPDATE DVM_ISS_TYPES SET IND_FIELD_NAME = 'MISS_GEAR_YN' WHERE ISS_TYPE_NAME = 'Missing Leg Gear';


--update the indicator field to revert the non-character data type:
	UPDATE DVM_ISS_TYPES SET IND_FIELD_NAME = 'INV_CRUISE_NAME_FY_YN' WHERE ISS_TYPE_NAME = 'Mismatched Cruise Name and Fiscal Year';

	UPDATE DVM_ISS_TYPES SET IND_FIELD_NAME = 'INV_LEG_DATES_YN' WHERE ISS_TYPE_NAME = 'Invalid Leg Dates';



--setup the test cases for category 7 part 2:

	--QC View does not exist (CCD_QC_CRUISE_TEMP_V):
	UPDATE DVM_QC_OBJECTS SET OBJECT_NAME = 'CCD_QC_CRUISE_TEMP_V' WHERE OBJECT_NAME = 'CCD_QC_CRUISE_V';



CREATE OR REPLACE View
CCD_QC_LEG_V
AS
SELECT
CCD_CRUISES.CRUISE_ID,
CCD_CRUISES.CRUISE_NAME,
CCD_CRUISES.CRUISE_URL,
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

	--invalidate dependent views (CCD_QC_LEG_OVERLAP_V, CCD_QC_LEG_V, CCD_QC_LEG_ALIAS_V):
	ALTER TABLE CCD_CRUISES RENAME COLUMN CRUISE_URL TO CRUISE_URL2;
