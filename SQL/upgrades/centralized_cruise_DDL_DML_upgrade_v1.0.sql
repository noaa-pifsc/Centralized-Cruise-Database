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
ADD (TZ_NAME VARCHAR2(40) NOT NULL);

COMMENT ON COLUMN CCD_CRUISE_LEGS.TZ_NAME IS 'The numeric offset for UTC or Time Zone Name (V$TIMEZONE_NAMES.TZNAME) for the local timezone where the cruise leg occurred (e.g. US/Hawaii, US/Samoa, -09:00)';


COMMENT ON COLUMN CCD_CRUISE_LEGS.LEG_START_DATE IS 'The start date in the corresponding time zone for the given research cruise leg';

COMMENT ON COLUMN CCD_CRUISE_LEGS.LEG_END_DATE IS 'The end date in the corresponding time zone for the given research cruise leg';


--replace the one-to-many relationship between cruise legs and data sets to a many-to-many relationship


ALTER TABLE CCD_DATA_SETS 
DROP CONSTRAINT CCD_DATA_SETS_FK2;

ALTER TABLE CCD_DATA_SETS 
DROP CONSTRAINT CCD_DATA_SETS_U1;

DROP INDEX CCD_DATA_SETS_I2;

ALTER TABLE CCD_DATA_SETS 
DROP COLUMN CRUISE_LEG_ID;


ALTER TABLE CCD_DATA_SETS 
DROP COLUMN DATA_SET_DOI;

ALTER TABLE CCD_DATA_SETS 
DROP COLUMN DATA_SET_ACCESS_URL;

ALTER TABLE CCD_DATA_SETS 
DROP COLUMN DATA_SET_ARCHIVE_URL;


ALTER INDEX CCD_DATA_SETS_I3 
RENAME TO CCD_DATA_SETS_I2;

ALTER TABLE CCD_DATA_SETS 
RENAME CONSTRAINT CCD_DATA_SETS_FK3 TO CCD_DATA_SETS_FK2;

ALTER TABLE CCD_DATA_SETS 
ADD (DATA_SET_NAME VARCHAR2(500) NOT NULL);

COMMENT ON COLUMN CCD_DATA_SETS.DATA_SET_NAME IS 'The Name of the data set';


--rename INPORT_URL column to numeric data type for InPort CAT_ID
ALTER TABLE CCD_DATA_SETS  
MODIFY (DATA_SET_INPORT_URL NUMBER );

ALTER TABLE CCD_DATA_SETS RENAME COLUMN DATA_SET_INPORT_URL TO DATA_SET_INPORT_CAT_ID;

COMMENT ON COLUMN CCD_DATA_SETS.DATA_SET_INPORT_CAT_ID IS 'InPort Catalog ID for the data set';

ALTER TABLE CCD_DATA_SETS
ADD CONSTRAINT CCD_DATA_SETS_U1 UNIQUE 
(
  DATA_SET_INPORT_CAT_ID 
)
ENABLE;

CREATE INDEX CCD_DATA_SETS_I3 ON CCD_DATA_SETS (DATA_SET_NAME);


ALTER TABLE CCD_DATA_SETS
ADD CONSTRAINT CCD_DATA_SETS_U2 UNIQUE 
(
  DATA_SET_NAME 
)
ENABLE;


ALTER TRIGGER CCD_DATA_SETS_AUTO_BRI COMPILE;
ALTER TRIGGER CCD_DATA_SETS_AUTO_BRU COMPILE;



CREATE OR REPLACE VIEW

CCD_DATA_SETS_V

AS
SELECT

CCD_DATA_SETS.DATA_SET_ID,
CCD_DATA_SETS.DATA_SET_NAME,
CCD_DATA_SETS.DATA_SET_DESC,
CCD_DATA_SETS.DATA_SET_INPORT_CAT_ID,
(CASE WHEN CCD_DATA_SETS.DATA_SET_INPORT_CAT_ID IS NOT NULL THEN 'https://www.fisheries.noaa.gov/inport/item/'||CCD_DATA_SETS.DATA_SET_INPORT_CAT_ID||'/' ELSE NULL END) DATA_SET_INPORT_URL,
CCD_DATA_SET_TYPES.DATA_SET_TYPE_ID,
CCD_DATA_SET_TYPES.DATA_SET_TYPE_NAME,
CCD_DATA_SET_TYPES.DATA_SET_TYPE_DESC,
CCD_DATA_SET_TYPES.DATA_SET_TYPE_DOC_URL,
CCD_DATA_SET_STATUS.DATA_SET_STATUS_ID,
CCD_DATA_SET_STATUS.STATUS_CODE,
CCD_DATA_SET_STATUS.STATUS_NAME,
CCD_DATA_SET_STATUS.STATUS_DESC,
CCD_DATA_SET_STATUS.STATUS_COLOR

from ccd_data_sets
inner join CCD_DATA_SET_STATUS on
ccd_data_sets.DATA_SET_STATUS_ID = CCD_DATA_SET_STATUS.DATA_SET_STATUS_ID
inner join CCD_DATA_SET_TYPES on
CCD_DATA_SET_TYPES.DATA_SET_TYPE_ID = ccd_data_sets.DATA_SET_TYPE_ID

;

COMMENT ON COLUMN CCD_DATA_SETS_V.DATA_SET_ID IS 'Primary key for the CCD_DATA_SETS table';
COMMENT ON COLUMN CCD_DATA_SETS_V.DATA_SET_NAME IS 'The Name of the data set';

COMMENT ON COLUMN CCD_DATA_SETS_V.DATA_SET_DESC IS 'Description for the data set';
COMMENT ON COLUMN CCD_DATA_SETS_V.DATA_SET_INPORT_CAT_ID IS 'InPort Catalog ID for the data set';
COMMENT ON COLUMN CCD_DATA_SETS_V.DATA_SET_INPORT_URL IS 'InPort metadata URL for the data set';

COMMENT ON COLUMN CCD_DATA_SETS_V.DATA_SET_TYPE_ID IS 'Primary key for the CCD_DATA_SET_TYPES table';
COMMENT ON COLUMN CCD_DATA_SETS_V.DATA_SET_TYPE_NAME IS 'Name for the data set type';
COMMENT ON COLUMN CCD_DATA_SETS_V.DATA_SET_TYPE_DESC IS 'Description for the data set type';
COMMENT ON COLUMN CCD_DATA_SETS_V.DATA_SET_TYPE_DOC_URL IS 'Documentation URL for the data type, this can be an InPort URL for the parent Project record of the individual data sets or a documentation package that provides information about this data set type';
COMMENT ON COLUMN CCD_DATA_SETS_V.DATA_SET_STATUS_ID IS 'Primary key for the CCD_DATA_SET_STATUS table';
COMMENT ON COLUMN CCD_DATA_SETS_V.STATUS_CODE IS 'The alpha-numeric code for the data status';
COMMENT ON COLUMN CCD_DATA_SETS_V.STATUS_NAME IS 'The name of the data status';
COMMENT ON COLUMN CCD_DATA_SETS_V.STATUS_DESC IS 'The description for the data status';
COMMENT ON COLUMN CCD_DATA_SETS_V.STATUS_COLOR IS 'The hex value for the color that the data set status has in the application interface';

comment on table CCD_DATA_SETS_V is 'Research Cruise Data Sets (View)';




ALTER TABLE CCD_LEG_DATA_SETS
ADD CONSTRAINT CCD_LEG_DATA_SETS_U1 UNIQUE 
(
  CRUISE_LEG_ID 
, DATA_SET_ID 
)
ENABLE;



CREATE TABLE CCD_LEG_DATA_SETS
(
  LEG_DATA_SET_ID NUMBER NOT NULL
, CRUISE_LEG_ID NUMBER NOT NULL
, DATA_SET_ID NUMBER NOT NULL
, LEG_DATA_SET_NOTES VARCHAR2(500)
, CONSTRAINT CCD_LEG_DATA_SET_PK PRIMARY KEY
  (
    LEG_DATA_SET_ID
  )
  ENABLE
);

CREATE INDEX CCD_LEG_DATA_SETS_I1 ON CCD_LEG_DATA_SETS (CRUISE_LEG_ID);

CREATE INDEX CCD_LEG_DATA_SETS_I2 ON CCD_LEG_DATA_SETS (DATA_SET_ID);

ALTER TABLE CCD_LEG_DATA_SETS
ADD CONSTRAINT CCD_LEG_DATA_SETS_FK1 FOREIGN KEY
(
  CRUISE_LEG_ID
)
REFERENCES CCD_CRUISE_LEGS
(
  CRUISE_LEG_ID
)
ENABLE;

ALTER TABLE CCD_LEG_DATA_SETS
ADD CONSTRAINT CCD_LEG_DATA_SETS_FK2 FOREIGN KEY
(
  DATA_SET_ID
)
REFERENCES CCD_DATA_SETS
(
  DATA_SET_ID
)
ENABLE;

COMMENT ON COLUMN CCD_LEG_DATA_SETS.LEG_DATA_SET_ID IS 'Primary key for the CCD_LEG_DATA_SETS table';

COMMENT ON COLUMN CCD_LEG_DATA_SETS.CRUISE_LEG_ID IS 'The cruise leg the Data Set is associated with';

COMMENT ON COLUMN CCD_LEG_DATA_SETS.DATA_SET_ID IS 'The Data Set the given cruise leg is associated with';

COMMENT ON COLUMN CCD_LEG_DATA_SETS.LEG_DATA_SET_NOTES IS 'Notes associated with the given Cruise Leg''s Data Set';

COMMENT ON TABLE CCD_LEG_DATA_SETS IS 'Cruise Leg Data Sets

This intersection table defines the many-to-many relationship between a given cruise leg and the associated Data Sets used during the cruise leg.';



CREATE SEQUENCE CCD_LEG_DATA_SETS_SEQ INCREMENT BY 1 START WITH 1;

ALTER TABLE CCD_LEG_DATA_SETS ADD (CREATE_DATE DATE );
ALTER TABLE CCD_LEG_DATA_SETS
ADD (CREATED_BY VARCHAR2(30) );

COMMENT ON COLUMN CCD_LEG_DATA_SETS.CREATE_DATE IS 'The date on which this record was created in the database';
COMMENT ON COLUMN CCD_LEG_DATA_SETS.CREATED_BY IS 'The Oracle username of the person creating this record in the database';


create or replace TRIGGER CCD_LEG_DATA_SETS_AUTO_BRI
before insert on CCD_LEG_DATA_SETS
for each row
begin
  select CCD_LEG_DATA_SETS_SEQ.nextval into :new.LEG_DATA_SET_ID from dual;
  :NEW.CREATE_DATE := SYSDATE;
  :NEW.CREATED_BY := nvl(v('APP_USER'),user);
end;
/
















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

CCD_CRUISE_LEGS.TZ_NAME,
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
COMMENT ON COLUMN CCD_LEG_V.TZ_NAME IS 'The numeric offset for UTC or Time Zone Name (V$TIMEZONE_NAMES.TZNAME) for the local timezone where the cruise leg occurred (e.g. US/Hawaii, US/Samoa, -09:00)';

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
CCD_LEG_V.TZ_NAME,
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
COMMENT ON COLUMN CCD_CRUISE_LEGS_V.TZ_NAME IS 'The numeric offset for UTC or Time Zone Name (V$TIMEZONE_NAMES.TZNAME) for the local timezone where the cruise leg occurred (e.g. US/Hawaii, US/Samoa, -09:00)';

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
CCD_LEG_V.TZ_NAME,
CCD_LEG_V.CRUISE_ID,
CCD_LEG_V.VESSEL_ID,
CCD_LEG_V.VESSEL_NAME,
CCD_LEG_V.VESSEL_DESC,
CCD_LEG_V.PLAT_TYPE_ID,
CCD_LEG_V.PLAT_TYPE_NAME,
CCD_LEG_V.PLAT_TYPE_DESC,
NVL(LEG_ECOSYSTEMS_DELIM.NUM_REG_ECOSYSTEMS, 0) NUM_REG_ECOSYSTEMS,
LEG_ECOSYSTEMS_DELIM.REG_ECOSYSTEM_CD_LIST,
LEG_ECOSYSTEMS_DELIM.REG_ECOSYSTEM_SCD_LIST,
LEG_ECOSYSTEMS_DELIM.REG_ECOSYSTEM_RC_LIST,
LEG_ECOSYSTEMS_DELIM.REG_ECOSYSTEM_BR_LIST,
NVL (LEG_GEAR_DELIM.NUM_GEAR, 0) NUM_GEAR,
LEG_GEAR_DELIM.GEAR_NAME_CD_LIST,
LEG_GEAR_DELIM.GEAR_NAME_SCD_LIST,
LEG_GEAR_DELIM.GEAR_NAME_RC_LIST,
LEG_GEAR_DELIM.GEAR_NAME_BR_LIST,
NVL (LEG_REGION_DELIM.NUM_REGIONS, 0) NUM_REGIONS,
LEG_REGION_DELIM.REGION_CODE_CD_LIST,
LEG_REGION_DELIM.REGION_CODE_SCD_LIST,
LEG_REGION_DELIM.REGION_CODE_RC_LIST,
LEG_REGION_DELIM.REGION_CODE_BR_LIST,
LEG_REGION_DELIM.REGION_NAME_CD_LIST,
LEG_REGION_DELIM.REGION_NAME_SCD_LIST,
LEG_REGION_DELIM.REGION_NAME_RC_LIST,
LEG_REGION_DELIM.REGION_NAME_BR_LIST,
NVL (LEG_ALIAS_DELIM.NUM_LEG_ALIASES, 0) NUM_LEG_ALIASES,
LEG_ALIAS_DELIM.LEG_ALIAS_CD_LIST,
LEG_ALIAS_DELIM.LEG_ALIAS_SCD_LIST,
LEG_ALIAS_DELIM.LEG_ALIAS_RC_LIST,
LEG_ALIAS_DELIM.LEG_ALIAS_BR_LIST,
NVL (LEG_DATA_SET_DELIM.NUM_DATA_SETS, 0) NUM_DATA_SETS,
LEG_DATA_SET_DELIM.DATA_SET_NAME_CD_LIST,
LEG_DATA_SET_DELIM.DATA_SET_NAME_SCD_LIST,
LEG_DATA_SET_DELIM.DATA_SET_NAME_RC_LIST,
LEG_DATA_SET_DELIM.DATA_SET_NAME_BR_LIST

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


LEFT JOIN
(SELECT CCD_LEG_DATA_SETS.CRUISE_LEG_ID,
 count(*) NUM_DATA_SETS,
LISTAGG(DATA_SET_NAME, ', ') WITHIN GROUP (ORDER BY UPPER(DATA_SET_NAME)) as DATA_SET_NAME_CD_LIST,
LISTAGG(DATA_SET_NAME, '; ') WITHIN GROUP (ORDER BY UPPER(DATA_SET_NAME)) as DATA_SET_NAME_SCD_LIST,
LISTAGG(DATA_SET_NAME, chr(10)) WITHIN GROUP (ORDER BY UPPER(DATA_SET_NAME)) as DATA_SET_NAME_RC_LIST,
LISTAGG(DATA_SET_NAME, '<BR>') WITHIN GROUP (ORDER BY UPPER(DATA_SET_NAME)) as DATA_SET_NAME_BR_LIST

 FROM
 CCD_DATA_SETS
 INNER JOIN
 CCD_LEG_DATA_SETS

 ON CCD_DATA_SETS.DATA_SET_ID = CCD_LEG_DATA_SETS.DATA_SET_ID
 group by CCD_LEG_DATA_SETS.CRUISE_LEG_ID
) LEG_DATA_SET_DELIM
ON CCD_LEG_V.CRUISE_LEG_ID = LEG_DATA_SET_DELIM.CRUISE_LEG_ID


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

COMMENT ON COLUMN CCD_LEG_DELIM_V.TZ_NAME IS 'The numeric offset for UTC or Time Zone Name (V$TIMEZONE_NAMES.TZNAME) for the local timezone where the cruise leg occurred (e.g. US/Hawaii, US/Samoa, -09:00)';

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


COMMENT ON COLUMN CCD_LEG_DELIM_V.NUM_DATA_SETS IS 'The number of associated leg data sets';
COMMENT ON COLUMN CCD_LEG_DELIM_V.DATA_SET_NAME_CD_LIST IS 'Comma-delimited list of leg data sets associated with the given cruise leg';
COMMENT ON COLUMN CCD_LEG_DELIM_V.DATA_SET_NAME_SCD_LIST IS 'Semicolon-delimited list of leg data sets associated with the given cruise leg';
COMMENT ON COLUMN CCD_LEG_DELIM_V.DATA_SET_NAME_RC_LIST IS 'Return carriage/new line delimited list of leg data sets associated with the given cruise leg';
COMMENT ON COLUMN CCD_LEG_DELIM_V.DATA_SET_NAME_BR_LIST IS '<BR> tag (intended for web pages) delimited list of leg data sets associated with the given cruise leg';



COMMENT ON TABLE CCD_LEG_DELIM_V IS 'Research Cruise Legs Delimited Reference Values (View)

This query returns all of the research cruise legs and their associated reference tables (e.g. Vessel, Platform Type, etc.) as well as the comma-/semicolon-delimited list of associated reference values (e.g. regional ecosystems, gear, regions, leg aliases, etc.)';










create or replace view
CCD_CRUISE_LEG_DELIM_V

AS
select
CCD_CRUISE_DELIM_V.CRUISE_ID,
CCD_CRUISE_DELIM_V.CRUISE_NAME,
CCD_CRUISE_DELIM_V.CRUISE_NOTES,

CCD_CRUISE_DELIM_V.CRUISE_DESC,
CCD_CRUISE_DELIM_V.OBJ_BASED_METRICS,
CCD_CRUISE_DELIM_V.SCI_CENTER_DIV_ID,
CCD_CRUISE_DELIM_V.SCI_CENTER_DIV_CODE,
CCD_CRUISE_DELIM_V.SCI_CENTER_DIV_NAME,
CCD_CRUISE_DELIM_V.SCI_CENTER_DIV_DESC,



CCD_CRUISE_DELIM_V.SCI_CENTER_ID,
CCD_CRUISE_DELIM_V.SCI_CENTER_NAME,
CCD_CRUISE_DELIM_V.SCI_CENTER_DESC,
CCD_CRUISE_DELIM_V.STD_SVY_NAME_ID,
CCD_CRUISE_DELIM_V.STD_SVY_NAME,
CCD_CRUISE_DELIM_V.STD_SVY_DESC,
CCD_CRUISE_DELIM_V.SVY_FREQ_ID,
CCD_CRUISE_DELIM_V.SVY_FREQ_NAME,
CCD_CRUISE_DELIM_V.SVY_FREQ_DESC,
CCD_CRUISE_DELIM_V.STD_SVY_NAME_OTH,
CCD_CRUISE_DELIM_V.STD_SVY_NAME_VAL,


CCD_CRUISE_DELIM_V.SVY_TYPE_ID,
CCD_CRUISE_DELIM_V.SVY_TYPE_NAME,
CCD_CRUISE_DELIM_V.SVY_TYPE_DESC,


CCD_CRUISE_DELIM_V.CRUISE_URL,
CCD_CRUISE_DELIM_V.CRUISE_CONT_EMAIL,
CCD_CRUISE_DELIM_V.PTA_ISS_ID,


CCD_CRUISE_DELIM_V.NUM_LEGS,
CCD_CRUISE_DELIM_V.CRUISE_START_DATE,
CCD_CRUISE_DELIM_V.FORMAT_CRUISE_START_DATE,
CCD_CRUISE_DELIM_V.CRUISE_END_DATE,
CCD_CRUISE_DELIM_V.FORMAT_CRUISE_END_DATE,
CCD_CRUISE_DELIM_V.CRUISE_DAS,
CCD_CRUISE_DELIM_V.CRUISE_LEN_DAYS,


CCD_CRUISE_DELIM_V.CRUISE_YEAR,
CCD_CRUISE_DELIM_V.CRUISE_FISC_YEAR,
CCD_CRUISE_DELIM_V.LEG_NAME_CD_LIST,
CCD_CRUISE_DELIM_V.LEG_NAME_SCD_LIST,
CCD_CRUISE_DELIM_V.LEG_NAME_RC_LIST,
CCD_CRUISE_DELIM_V.LEG_NAME_BR_LIST,

CCD_CRUISE_DELIM_V.LEG_NAME_DATES_CD_LIST,
CCD_CRUISE_DELIM_V.LEG_NAME_DATES_SCD_LIST,
CCD_CRUISE_DELIM_V.LEG_NAME_DATES_RC_LIST,
CCD_CRUISE_DELIM_V.LEG_NAME_DATES_BR_LIST,



CCD_CRUISE_DELIM_V.NUM_SPP_ESA,
CCD_CRUISE_DELIM_V.SPP_ESA_NAME_CD_LIST,
CCD_CRUISE_DELIM_V.SPP_ESA_NAME_SCD_LIST,
CCD_CRUISE_DELIM_V.SPP_ESA_NAME_RC_LIST,
CCD_CRUISE_DELIM_V.SPP_ESA_NAME_BR_LIST,


CCD_CRUISE_DELIM_V.NUM_SPP_FSSI,
CCD_CRUISE_DELIM_V.SPP_FSSI_NAME_CD_LIST,
CCD_CRUISE_DELIM_V.SPP_FSSI_NAME_SCD_LIST,
CCD_CRUISE_DELIM_V.SPP_FSSI_NAME_RC_LIST,
CCD_CRUISE_DELIM_V.SPP_FSSI_NAME_BR_LIST,


CCD_CRUISE_DELIM_V.NUM_SPP_MMPA,
CCD_CRUISE_DELIM_V.SPP_MMPA_NAME_CD_LIST,
CCD_CRUISE_DELIM_V.SPP_MMPA_NAME_SCD_LIST,
CCD_CRUISE_DELIM_V.SPP_MMPA_NAME_RC_LIST,
CCD_CRUISE_DELIM_V.SPP_MMPA_NAME_BR_LIST,


CCD_CRUISE_DELIM_V.NUM_PRIM_SVY_CATS,
CCD_CRUISE_DELIM_V.PRIM_SVY_CAT_NAME_CD_LIST,
CCD_CRUISE_DELIM_V.PRIM_SVY_CAT_NAME_SCD_LIST,
CCD_CRUISE_DELIM_V.PRIM_SVY_CAT_NAME_RC_LIST,
CCD_CRUISE_DELIM_V.PRIM_SVY_CAT_NAME_BR_LIST,


CCD_CRUISE_DELIM_V.NUM_SEC_SVY_CATS,
CCD_CRUISE_DELIM_V.SEC_SVY_CAT_NAME_CD_LIST,
CCD_CRUISE_DELIM_V.SEC_SVY_CAT_NAME_SCD_LIST,
CCD_CRUISE_DELIM_V.SEC_SVY_CAT_NAME_RC_LIST,
CCD_CRUISE_DELIM_V.SEC_SVY_CAT_NAME_BR_LIST,

CCD_CRUISE_DELIM_V.NUM_EXP_SPP,
CCD_CRUISE_DELIM_V.EXP_SPP_NAME_CD_LIST,
CCD_CRUISE_DELIM_V.EXP_SPP_NAME_SCD_LIST,
CCD_CRUISE_DELIM_V.EXP_SPP_NAME_RC_LIST,
CCD_CRUISE_DELIM_V.EXP_SPP_NAME_BR_LIST,


CCD_CRUISE_DELIM_V.NUM_SPP_OTH,
CCD_CRUISE_DELIM_V.OTH_SPP_CNAME_CD_LIST,
CCD_CRUISE_DELIM_V.OTH_SPP_CNAME_SCD_LIST,
CCD_CRUISE_DELIM_V.OTH_SPP_CNAME_RC_LIST,
CCD_CRUISE_DELIM_V.OTH_SPP_CNAME_BR_LIST,

CCD_CRUISE_DELIM_V.OTH_SPP_SNAME_CD_LIST,
CCD_CRUISE_DELIM_V.OTH_SPP_SNAME_SCD_LIST,
CCD_CRUISE_DELIM_V.OTH_SPP_SNAME_RC_LIST,
CCD_CRUISE_DELIM_V.OTH_SPP_SNAME_BR_LIST,





CCD_LEG_DELIM_V.CRUISE_LEG_ID,
CCD_LEG_DELIM_V.LEG_NAME,
CCD_LEG_DELIM_V.LEG_START_DATE,
CCD_LEG_DELIM_V.FORMAT_LEG_START_DATE,
CCD_LEG_DELIM_V.LEG_END_DATE,
CCD_LEG_DELIM_V.FORMAT_LEG_END_DATE,
CCD_LEG_DELIM_V.LEG_DAS,

CCD_LEG_DELIM_V.LEG_YEAR,
CCD_LEG_DELIM_V.LEG_FISC_YEAR,
CCD_LEG_DELIM_V.LEG_DESC,
CCD_LEG_DELIM_V.VESSEL_ID,
CCD_LEG_DELIM_V.VESSEL_NAME,
CCD_LEG_DELIM_V.VESSEL_DESC,
CCD_LEG_DELIM_V.PLAT_TYPE_ID,
CCD_LEG_DELIM_V.PLAT_TYPE_NAME,
CCD_LEG_DELIM_V.PLAT_TYPE_DESC,
CCD_LEG_DELIM_V.NUM_REG_ECOSYSTEMS,
CCD_LEG_DELIM_V.REG_ECOSYSTEM_CD_LIST,
CCD_LEG_DELIM_V.REG_ECOSYSTEM_SCD_LIST,
CCD_LEG_DELIM_V.REG_ECOSYSTEM_RC_LIST,
CCD_LEG_DELIM_V.REG_ECOSYSTEM_BR_LIST,

CCD_LEG_DELIM_V.NUM_GEAR,
CCD_LEG_DELIM_V.GEAR_NAME_CD_LIST,
CCD_LEG_DELIM_V.GEAR_NAME_SCD_LIST,
CCD_LEG_DELIM_V.GEAR_NAME_RC_LIST,
CCD_LEG_DELIM_V.GEAR_NAME_BR_LIST,

CCD_LEG_DELIM_V.NUM_REGIONS,
CCD_LEG_DELIM_V.REGION_CODE_CD_LIST,
CCD_LEG_DELIM_V.REGION_CODE_SCD_LIST,
CCD_LEG_DELIM_V.REGION_CODE_RC_LIST,
CCD_LEG_DELIM_V.REGION_CODE_BR_LIST,

CCD_LEG_DELIM_V.REGION_NAME_CD_LIST,
CCD_LEG_DELIM_V.REGION_NAME_SCD_LIST,
CCD_LEG_DELIM_V.REGION_NAME_RC_LIST,
CCD_LEG_DELIM_V.REGION_NAME_BR_LIST,

CCD_LEG_DELIM_V.NUM_LEG_ALIASES,
CCD_LEG_DELIM_V.LEG_ALIAS_CD_LIST,
CCD_LEG_DELIM_V.LEG_ALIAS_SCD_LIST,
CCD_LEG_DELIM_V.LEG_ALIAS_RC_LIST,
CCD_LEG_DELIM_V.LEG_ALIAS_BR_LIST,


CCD_LEG_DELIM_V.NUM_DATA_SETS,
CCD_LEG_DELIM_V.DATA_SET_NAME_CD_LIST,
CCD_LEG_DELIM_V.DATA_SET_NAME_SCD_LIST,
CCD_LEG_DELIM_V.DATA_SET_NAME_RC_LIST,
CCD_LEG_DELIM_V.DATA_SET_NAME_BR_LIST


FROM
CCD_CRUISE_DELIM_V left join
CCD_LEG_DELIM_V
ON
CCD_CRUISE_DELIM_V.CRUISE_ID = CCD_LEG_DELIM_V.CRUISE_ID
order by
CCD_LEG_DELIM_V.LEG_START_DATE,
CCD_LEG_DELIM_V.LEG_NAME,
CCD_LEG_DELIM_V.VESSEL_NAME
;


COMMENT ON COLUMN CCD_CRUISE_LEG_DELIM_V.CRUISE_ID IS 'Primary key for the CCD_CRUISES table';
COMMENT ON COLUMN CCD_CRUISE_LEG_DELIM_V.CRUISE_NAME IS 'The name of the given cruise designated by NOAA (e.g. SE-15-01)';
COMMENT ON COLUMN CCD_CRUISE_LEG_DELIM_V.CRUISE_NOTES IS 'Any notes for the given research cruise';

COMMENT ON COLUMN CCD_CRUISE_LEG_DELIM_V.CRUISE_DESC IS 'Description for the given research cruise';
COMMENT ON COLUMN CCD_CRUISE_LEG_DELIM_V.OBJ_BASED_METRICS IS 'Objective Based Metrics for the given research cruise';
COMMENT ON COLUMN CCD_CRUISE_LEG_DELIM_V.SCI_CENTER_DIV_ID IS 'Primary key for the Science Center Division table';
COMMENT ON COLUMN CCD_CRUISE_LEG_DELIM_V.SCI_CENTER_DIV_CODE IS 'Abbreviated code for the given Science Center Division';

COMMENT ON COLUMN CCD_CRUISE_LEG_DELIM_V.SCI_CENTER_DIV_NAME IS 'Name of the given Science Center Division';

COMMENT ON COLUMN CCD_CRUISE_LEG_DELIM_V.SCI_CENTER_DIV_DESC IS 'Description for the given Science Center Division';



COMMENT ON COLUMN CCD_CRUISE_LEG_DELIM_V.SCI_CENTER_ID IS 'Primary key for the Science Center table';
COMMENT ON COLUMN CCD_CRUISE_LEG_DELIM_V.SCI_CENTER_NAME IS 'Name of the given Science Center';
COMMENT ON COLUMN CCD_CRUISE_LEG_DELIM_V.SCI_CENTER_DESC IS 'Description for the given Science Center';
COMMENT ON COLUMN CCD_CRUISE_LEG_DELIM_V.STD_SVY_NAME_ID IS 'Primary key for the Standard Survey Name table';
COMMENT ON COLUMN CCD_CRUISE_LEG_DELIM_V.STD_SVY_NAME IS 'Name of the given Standard Survey Name';
COMMENT ON COLUMN CCD_CRUISE_LEG_DELIM_V.STD_SVY_DESC IS 'Description for the given Standard Survey Name';
COMMENT ON COLUMN CCD_CRUISE_LEG_DELIM_V.SVY_FREQ_ID IS 'Primary key for the Survey Frequency table';
COMMENT ON COLUMN CCD_CRUISE_LEG_DELIM_V.SVY_FREQ_NAME IS 'Name of the given Survey Frequency';
COMMENT ON COLUMN CCD_CRUISE_LEG_DELIM_V.SVY_FREQ_DESC IS 'Description for the given Survey Frequency';
COMMENT ON COLUMN CCD_CRUISE_LEG_DELIM_V.STD_SVY_NAME_OTH IS 'Field defines a Standard Survey Name that is not included in the Standard Survey Name table';
COMMENT ON COLUMN CCD_CRUISE_LEG_DELIM_V.STD_SVY_NAME_VAL IS 'This field contains the Standard Survey Name defined for the given cruise.  If the STD_SVY_NAME_ID field is defined then the associated CCD_STD_SVY_NAMES.STD_SVY_NAME is used because the foreign key is given precedence, otherwise the STD_SVY_NAME_OTH field value is used';

COMMENT ON COLUMN CCD_CRUISE_LEG_DELIM_V.SVY_TYPE_ID IS 'Primary key for the Survey Type table';
COMMENT ON COLUMN CCD_CRUISE_LEG_DELIM_V.SVY_TYPE_NAME IS 'Name of the given Survey Type';
COMMENT ON COLUMN CCD_CRUISE_LEG_DELIM_V.SVY_TYPE_DESC IS 'Description for the given Survey Type';



COMMENT ON COLUMN CCD_CRUISE_LEG_DELIM_V.CRUISE_URL IS 'The Cruise URL (Referred to as "Survey URL" in FINSS System) for the given Cruise';
COMMENT ON COLUMN CCD_CRUISE_LEG_DELIM_V.CRUISE_CONT_EMAIL IS 'The Cruise Contact Email (Referred to as "Survey Contact Email" in FINSS System) for the given Cruise';

COMMENT ON COLUMN CCD_CRUISE_LEG_DELIM_V.PTA_ISS_ID IS 'Foreign key reference to the Validation Issues (PTA) intersection table';


COMMENT ON COLUMN CCD_CRUISE_LEG_DELIM_V.NUM_SPP_ESA IS 'The number of associated ESA Species';
COMMENT ON COLUMN CCD_CRUISE_LEG_DELIM_V.SPP_ESA_NAME_CD_LIST IS 'Comma-delimited list of ESA Species associated with the given cruise';
COMMENT ON COLUMN CCD_CRUISE_LEG_DELIM_V.SPP_ESA_NAME_SCD_LIST IS 'Semicolon-delimited list of ESA Species associated with the given cruise';
COMMENT ON COLUMN CCD_CRUISE_LEG_DELIM_V.SPP_ESA_NAME_RC_LIST IS 'Return carriage/new line delimited list of ESA Species associated with the given cruise';
COMMENT ON COLUMN CCD_CRUISE_LEG_DELIM_V.SPP_ESA_NAME_BR_LIST IS '<BR> tag (intended for web pages) delimited list of ESA Species associated with the given cruise';



COMMENT ON COLUMN CCD_CRUISE_LEG_DELIM_V.NUM_SPP_FSSI IS 'The number of associated FSSI Species';
COMMENT ON COLUMN CCD_CRUISE_LEG_DELIM_V.SPP_FSSI_NAME_CD_LIST IS 'Comma-delimited list of FSSI Species associated with the given cruise';
COMMENT ON COLUMN CCD_CRUISE_LEG_DELIM_V.SPP_FSSI_NAME_SCD_LIST IS 'Semicolon-delimited list of FSSI Species associated with the given cruise';
COMMENT ON COLUMN CCD_CRUISE_LEG_DELIM_V.SPP_FSSI_NAME_RC_LIST IS 'Return carriage/new line delimited list of FSSI Species associated with the given cruise';
COMMENT ON COLUMN CCD_CRUISE_LEG_DELIM_V.SPP_FSSI_NAME_BR_LIST IS '<BR> tag (intended for web pages) delimited list of FSSI Species associated with the given cruise';


COMMENT ON COLUMN CCD_CRUISE_LEG_DELIM_V.NUM_SPP_MMPA IS 'The number of associated MMPA Species';
COMMENT ON COLUMN CCD_CRUISE_LEG_DELIM_V.SPP_MMPA_NAME_CD_LIST IS 'Comma-delimited list of MMPA Species associated with the given cruise';
COMMENT ON COLUMN CCD_CRUISE_LEG_DELIM_V.SPP_MMPA_NAME_SCD_LIST IS 'Semicolon-delimited list of MMPA Species associated with the given cruise';
COMMENT ON COLUMN CCD_CRUISE_LEG_DELIM_V.SPP_MMPA_NAME_RC_LIST IS 'Return carriage/new line delimited list of MMPA Species associated with the given cruise';
COMMENT ON COLUMN CCD_CRUISE_LEG_DELIM_V.SPP_MMPA_NAME_BR_LIST IS '<BR> tag (intended for web pages) delimited list of MMPA Species associated with the given cruise';

COMMENT ON COLUMN CCD_CRUISE_LEG_DELIM_V.NUM_PRIM_SVY_CATS IS 'The number of associated primary survey categories';
COMMENT ON COLUMN CCD_CRUISE_LEG_DELIM_V.PRIM_SVY_CAT_NAME_CD_LIST IS 'Comma-delimited list of primary survey categories associated with the given cruise';
COMMENT ON COLUMN CCD_CRUISE_LEG_DELIM_V.PRIM_SVY_CAT_NAME_SCD_LIST IS 'Semicolon-delimited list of primary survey categories associated with the given cruise';
COMMENT ON COLUMN CCD_CRUISE_LEG_DELIM_V.PRIM_SVY_CAT_NAME_RC_LIST IS 'Return carriage/new line delimited list of primary survey categories associated with the given cruise';
COMMENT ON COLUMN CCD_CRUISE_LEG_DELIM_V.PRIM_SVY_CAT_NAME_BR_LIST IS '<BR> tag (intended for web pages) delimited list of primary survey categories associated with the given cruise';

COMMENT ON COLUMN CCD_CRUISE_LEG_DELIM_V.NUM_SEC_SVY_CATS IS 'The number of associated secondary survey categories';
COMMENT ON COLUMN CCD_CRUISE_LEG_DELIM_V.SEC_SVY_CAT_NAME_CD_LIST IS 'Comma-delimited list of secondary survey categories associated with the given cruise';
COMMENT ON COLUMN CCD_CRUISE_LEG_DELIM_V.SEC_SVY_CAT_NAME_SCD_LIST IS 'Semicolon-delimited list of secondary survey categories associated with the given cruise';
COMMENT ON COLUMN CCD_CRUISE_LEG_DELIM_V.SEC_SVY_CAT_NAME_RC_LIST IS 'Return carriage/new line delimited list of secondary survey categories associated with the given cruise';
COMMENT ON COLUMN CCD_CRUISE_LEG_DELIM_V.SEC_SVY_CAT_NAME_BR_LIST IS '<BR> tag (intended for web pages) delimited list of secondary survey categories associated with the given cruise';

COMMENT ON COLUMN CCD_CRUISE_LEG_DELIM_V.NUM_EXP_SPP IS 'The number of associated expected species categories';
COMMENT ON COLUMN CCD_CRUISE_LEG_DELIM_V.EXP_SPP_NAME_CD_LIST IS 'Comma-delimited list of expected species categories associated with the given cruise';
COMMENT ON COLUMN CCD_CRUISE_LEG_DELIM_V.EXP_SPP_NAME_SCD_LIST IS 'Semicolon-delimited list of expected species categories associated with the given cruise';
COMMENT ON COLUMN CCD_CRUISE_LEG_DELIM_V.EXP_SPP_NAME_RC_LIST IS 'Return carriage/new line delimited list of expected species categories associated with the given cruise';
COMMENT ON COLUMN CCD_CRUISE_LEG_DELIM_V.EXP_SPP_NAME_BR_LIST IS '<BR> tag (intended for web pages) delimited list of expected species categories associated with the given cruise';

COMMENT ON COLUMN CCD_CRUISE_LEG_DELIM_V.NUM_SPP_OTH IS 'The number of associated target species - other';
COMMENT ON COLUMN CCD_CRUISE_LEG_DELIM_V.OTH_SPP_CNAME_CD_LIST IS 'Comma-delimited list of common names for target species - other associated with the given cruise';
COMMENT ON COLUMN CCD_CRUISE_LEG_DELIM_V.OTH_SPP_CNAME_SCD_LIST IS 'Semicolon-delimited list of common names for target species - other associated with the given cruise';
COMMENT ON COLUMN CCD_CRUISE_LEG_DELIM_V.OTH_SPP_CNAME_RC_LIST IS 'Return carriage/new line delimited list of common names for target species - other associated with the given cruise';
COMMENT ON COLUMN CCD_CRUISE_LEG_DELIM_V.OTH_SPP_CNAME_BR_LIST IS '<BR> tag (intended for web pages) delimited list of common names for target species - other associated with the given cruise';


COMMENT ON COLUMN CCD_CRUISE_LEG_DELIM_V.OTH_SPP_SNAME_CD_LIST IS 'Comma-delimited list of scientific names for target species - other associated with the given cruise';
COMMENT ON COLUMN CCD_CRUISE_LEG_DELIM_V.OTH_SPP_SNAME_SCD_LIST IS 'Semicolon-delimited list of scientific names for target species - other associated with the given cruise';
COMMENT ON COLUMN CCD_CRUISE_LEG_DELIM_V.OTH_SPP_SNAME_RC_LIST IS 'Return carriage/new line delimited list of scientific names for target species - other associated with the given cruise';
COMMENT ON COLUMN CCD_CRUISE_LEG_DELIM_V.OTH_SPP_SNAME_BR_LIST IS '<BR> tag (intended for web pages) delimited list of scientific names for target species - other associated with the given cruise';



COMMENT ON COLUMN CCD_CRUISE_LEG_DELIM_V.CRUISE_START_DATE IS 'The start date for the given cruise (based on the earliest associated cruise leg''s start date)';
COMMENT ON COLUMN CCD_CRUISE_LEG_DELIM_V.FORMAT_CRUISE_START_DATE IS 'The formatted start date for the given cruise (based on the earliest associated cruise leg''s start date) in MM/DD/YYYY HH24:MI:SS format';
COMMENT ON COLUMN CCD_CRUISE_LEG_DELIM_V.CRUISE_END_DATE IS 'The end date for the given cruise (based on the latest associated cruise leg''s end date)';
COMMENT ON COLUMN CCD_CRUISE_LEG_DELIM_V.FORMAT_CRUISE_END_DATE IS 'The formatted end date for the given cruise (based on the latest associated cruise leg''s end date) in MM/DD/YYYY HH24:MI:SS format';

COMMENT ON COLUMN CCD_CRUISE_LEG_DELIM_V.CRUISE_DAS IS 'The total number of days at sea for each of the legs associated with the given cruise';
COMMENT ON COLUMN CCD_CRUISE_LEG_DELIM_V.CRUISE_LEN_DAYS IS 'The total number of days between the Cruise Start and End Dates for the given cruise';

COMMENT ON COLUMN CCD_CRUISE_LEG_DELIM_V.CRUISE_YEAR IS 'The calendar year for the given cruise (based on the earliest associated cruise leg''s start date)';
COMMENT ON COLUMN CCD_CRUISE_LEG_DELIM_V.CRUISE_FISC_YEAR IS 'The calendar year for the given cruise (based on the earliest associated cruise leg''s start date)';
COMMENT ON COLUMN CCD_CRUISE_LEG_DELIM_V.NUM_LEGS IS 'The number of cruise legs associated with the given cruise';
COMMENT ON COLUMN CCD_CRUISE_LEG_DELIM_V.LEG_NAME_CD_LIST IS 'Comma-delimited list of leg names associated with the given cruise';
COMMENT ON COLUMN CCD_CRUISE_LEG_DELIM_V.LEG_NAME_SCD_LIST IS 'Semicolon-delimited list of leg names associated with the given cruise';

COMMENT ON COLUMN CCD_CRUISE_LEG_DELIM_V.LEG_NAME_RC_LIST IS 'Return carriage/new line delimited list of leg names associated with the given cruise';
COMMENT ON COLUMN CCD_CRUISE_LEG_DELIM_V.LEG_NAME_BR_LIST IS '<BR> tag (intended for web pages) delimited list of leg names associated with the given cruise';


COMMENT ON COLUMN CCD_CRUISE_LEG_DELIM_V.LEG_NAME_DATES_CD_LIST IS 'Comma-delimited list of leg names, the associated leg dates and vessel name associated with the given cruise';
COMMENT ON COLUMN CCD_CRUISE_LEG_DELIM_V.LEG_NAME_DATES_SCD_LIST IS 'Semicolon-delimited list of leg names, the associated leg dates and vessel name associated with the given cruise';
COMMENT ON COLUMN CCD_CRUISE_LEG_DELIM_V.LEG_NAME_DATES_RC_LIST IS 'Return carriage/new line delimited list of leg names, the associated leg dates and vessel name associated with the given cruise';
COMMENT ON COLUMN CCD_CRUISE_LEG_DELIM_V.LEG_NAME_DATES_BR_LIST IS '<BR> tag (intended for web pages) delimited list of leg names, the associated leg dates and vessel name associated with the given cruise';


COMMENT ON COLUMN CCD_CRUISE_LEG_DELIM_V.CRUISE_LEG_ID IS 'Primary key for the CCD_CRUISE_LEGS table';
COMMENT ON COLUMN CCD_CRUISE_LEG_DELIM_V.LEG_NAME IS 'The name of the given cruise leg';
COMMENT ON COLUMN CCD_CRUISE_LEG_DELIM_V.LEG_START_DATE IS 'The start date for the given research cruise leg';
COMMENT ON COLUMN CCD_CRUISE_LEG_DELIM_V.FORMAT_LEG_START_DATE IS 'The start date for the given research cruise leg in MM/DD/YYYY format';
COMMENT ON COLUMN CCD_CRUISE_LEG_DELIM_V.LEG_END_DATE IS 'The end date for the given research cruise leg';
COMMENT ON COLUMN CCD_CRUISE_LEG_DELIM_V.FORMAT_LEG_END_DATE IS 'The end date for the given research cruise leg in MM/DD/YYYY format';

COMMENT ON COLUMN CCD_CRUISE_LEG_DELIM_V.LEG_DAS IS 'The number of days at sea for the given research cruise leg';


COMMENT ON COLUMN CCD_CRUISE_LEG_DELIM_V.LEG_YEAR IS 'The calendar year for the start date of the given research cruise leg';
COMMENT ON COLUMN CCD_CRUISE_LEG_DELIM_V.LEG_FISC_YEAR IS 'The NOAA fiscal year for the start date of the given research cruise leg';
COMMENT ON COLUMN CCD_CRUISE_LEG_DELIM_V.LEG_DESC IS 'The description for the given research cruise leg';
COMMENT ON COLUMN CCD_CRUISE_LEG_DELIM_V.VESSEL_ID IS 'Foreign key reference to the CCD_VESSELS table for the cruise leg''s vessel';
COMMENT ON COLUMN CCD_CRUISE_LEG_DELIM_V.VESSEL_NAME IS 'Name of the given research vessel';
COMMENT ON COLUMN CCD_CRUISE_LEG_DELIM_V.VESSEL_DESC IS 'Description for the given research vessel';
COMMENT ON COLUMN CCD_CRUISE_LEG_DELIM_V.PLAT_TYPE_ID IS 'Platform Type for the given research cruise leg';
COMMENT ON COLUMN CCD_CRUISE_LEG_DELIM_V.PLAT_TYPE_NAME IS 'Name of the given Platform Type';
COMMENT ON COLUMN CCD_CRUISE_LEG_DELIM_V.PLAT_TYPE_DESC IS 'Description for the given Platform Type';
COMMENT ON COLUMN CCD_CRUISE_LEG_DELIM_V.NUM_REG_ECOSYSTEMS IS 'The number of associated Regional Ecosystems';

COMMENT ON COLUMN CCD_CRUISE_LEG_DELIM_V.REG_ECOSYSTEM_CD_LIST IS 'Comma-delimited list of Regional Ecosystems associated with the given cruise leg';
COMMENT ON COLUMN CCD_CRUISE_LEG_DELIM_V.REG_ECOSYSTEM_SCD_LIST IS 'Semicolon-delimited list of Regional Ecosystems associated with the given cruise leg';

COMMENT ON COLUMN CCD_CRUISE_LEG_DELIM_V.REG_ECOSYSTEM_RC_LIST IS 'Return carriage/new line delimited list of Regional Ecosystems associated with the given cruise leg';
COMMENT ON COLUMN CCD_CRUISE_LEG_DELIM_V.REG_ECOSYSTEM_BR_LIST IS '<BR> tag (intended for web pages) delimited list of Regional Ecosystems associated with the given cruise leg';



COMMENT ON COLUMN CCD_CRUISE_LEG_DELIM_V.NUM_GEAR IS 'The number of associated gear';
COMMENT ON COLUMN CCD_CRUISE_LEG_DELIM_V.GEAR_NAME_CD_LIST IS 'Comma-delimited list of gear associated with the given cruise leg';
COMMENT ON COLUMN CCD_CRUISE_LEG_DELIM_V.GEAR_NAME_SCD_LIST IS 'Semicolon-delimited list of gear associated with the given cruise leg';
COMMENT ON COLUMN CCD_CRUISE_LEG_DELIM_V.GEAR_NAME_RC_LIST IS 'Return carriage/new line delimited list of gear associated with the given cruise leg';
COMMENT ON COLUMN CCD_CRUISE_LEG_DELIM_V.GEAR_NAME_BR_LIST IS '<BR> tag (intended for web pages) delimited list of gear associated with the given cruise leg';


COMMENT ON COLUMN CCD_CRUISE_LEG_DELIM_V.NUM_REGIONS IS 'The number of associated regions';
COMMENT ON COLUMN CCD_CRUISE_LEG_DELIM_V.REGION_CODE_CD_LIST IS 'Comma-delimited list of region codes associated with the given cruise leg';
COMMENT ON COLUMN CCD_CRUISE_LEG_DELIM_V.REGION_CODE_SCD_LIST IS 'Semicolon-delimited list of region codes associated with the given cruise leg';
COMMENT ON COLUMN CCD_CRUISE_LEG_DELIM_V.REGION_CODE_RC_LIST IS 'Return carriage/new line delimited list of region codes associated with the given cruise leg';
COMMENT ON COLUMN CCD_CRUISE_LEG_DELIM_V.REGION_CODE_BR_LIST IS '<BR> tag (intended for web pages) delimited list of region codes associated with the given cruise leg';



COMMENT ON COLUMN CCD_CRUISE_LEG_DELIM_V.REGION_NAME_CD_LIST IS 'Comma-delimited list of region names associated with the given cruise leg';
COMMENT ON COLUMN CCD_CRUISE_LEG_DELIM_V.REGION_NAME_SCD_LIST IS 'Semicolon-delimited list of region names associated with the given cruise leg';
COMMENT ON COLUMN CCD_CRUISE_LEG_DELIM_V.REGION_NAME_RC_LIST IS 'Return carriage/new line delimited list of region names associated with the given cruise leg';
COMMENT ON COLUMN CCD_CRUISE_LEG_DELIM_V.REGION_NAME_BR_LIST IS '<BR> tag (intended for web pages) delimited list of region names associated with the given cruise leg';


COMMENT ON COLUMN CCD_CRUISE_LEG_DELIM_V.NUM_LEG_ALIASES IS 'The number of associated leg aliases';
COMMENT ON COLUMN CCD_CRUISE_LEG_DELIM_V.LEG_ALIAS_CD_LIST IS 'Comma-delimited list of leg aliases associated with the given cruise leg';
COMMENT ON COLUMN CCD_CRUISE_LEG_DELIM_V.LEG_ALIAS_SCD_LIST IS 'Semicolon-delimited list of leg aliases associated with the given cruise leg';
COMMENT ON COLUMN CCD_CRUISE_LEG_DELIM_V.LEG_ALIAS_RC_LIST IS 'Return carriage/new line delimited list of leg aliases associated with the given cruise leg';
COMMENT ON COLUMN CCD_CRUISE_LEG_DELIM_V.LEG_ALIAS_BR_LIST IS '<BR> tag (intended for web pages) delimited list of leg aliases associated with the given cruise leg';





COMMENT ON COLUMN CCD_CRUISE_LEG_DELIM_V.NUM_DATA_SETS IS 'The number of associated leg data sets';
COMMENT ON COLUMN CCD_CRUISE_LEG_DELIM_V.DATA_SET_NAME_CD_LIST IS 'Comma-delimited list of leg data sets associated with the given cruise leg';
COMMENT ON COLUMN CCD_CRUISE_LEG_DELIM_V.DATA_SET_NAME_SCD_LIST IS 'Semicolon-delimited list of leg data sets associated with the given cruise leg';
COMMENT ON COLUMN CCD_CRUISE_LEG_DELIM_V.DATA_SET_NAME_RC_LIST IS 'Return carriage/new line delimited list of leg data sets associated with the given cruise leg';
COMMENT ON COLUMN CCD_CRUISE_LEG_DELIM_V.DATA_SET_NAME_BR_LIST IS '<BR> tag (intended for web pages) delimited list of leg data sets associated with the given cruise leg';

COMMENT ON TABLE CCD_CRUISE_LEG_DELIM_V IS 'Research Cruises and Associated Legs with Delimited Reference Values (View)

This query returns all of the research cruises and their associated reference tables (e.g. Science Center, standard survey name, survey frequency, etc.) as well as the comma-/semicolon-delimited list of associated reference values (e.g. ESA species, primary survey categories, etc.) as well as all associated research cruise legs and their associated reference tables (e.g. Vessel, Platform Type, etc.) as well as the comma-/semicolon-delimited list of associated reference values (e.g. regional ecosystems, gear, regions, leg aliases, etc.)';


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
CASE WHEN NUM_GEAR = 0 THEN 'Y' ELSE 'N' END MISS_GEAR_YN,
CASE WHEN NUM_DATA_SETS = 0 THEN 'Y' ELSE 'N' END MISS_DATA_SET_YN


FROM CCD_CRUISE_LEG_DELIM_V
WHERE
CRUISE_LEG_ID IS NOT NULL AND
((UPPER(LEG_NAME) LIKE '% (COPY)%')
OR (LEG_START_DATE > LEG_END_DATE)
OR (LEG_DAS <= 90 AND LEG_DAS > 30)
OR (LEG_DAS > 90)
OR (NUM_GEAR = 0)
OR (NUM_DATA_SETS = 0))

ORDER BY
LEG_NAME, LEG_START_DATE;

COMMENT ON TABLE CCD_QC_LEG_V IS 'Cruise Leg (QC View)

This query identifies data validation issues with Cruise Legs (e.g. invalid leg dates, invalid leg name, etc.).  This QC View is implemented in the Data Validation Module';

COMMENT ON COLUMN CCD_QC_LEG_V.CRUISE_ID IS 'Primary key for the CCD_CRUISES table';
COMMENT ON COLUMN CCD_QC_LEG_V.CRUISE_NAME IS 'The name of the given cruise designated by NOAA (e.g. SE-15-01)';
COMMENT ON COLUMN CCD_QC_LEG_V.CRUISE_LEG_ID IS 'Primary key for the CCD_CRUISE_LEGS table';
COMMENT ON COLUMN CCD_QC_LEG_V.LEG_NAME IS 'The name of the given cruise leg';
COMMENT ON COLUMN CCD_QC_LEG_V.VESSEL_NAME IS 'Name of the given research vessel';
COMMENT ON COLUMN CCD_QC_LEG_V.INV_LEG_NAME_COPY_YN IS 'Field to indicate if there is an Invalid Copied Leg Name error (Y) or not (N) based on whether or not the value of LEG_NAME contains "(copy)"';
COMMENT ON COLUMN CCD_QC_LEG_V.INV_LEG_DATES_YN IS 'Field to indicate if there is an Invalid Leg Dates error (Y) or not (N) based on whether or not the LEG_START_DATE occurs after the LEG_END_DATE';
COMMENT ON COLUMN CCD_QC_LEG_V.LEG_DAS IS 'The number of days at sea for the given research cruise leg';

COMMENT ON COLUMN CCD_QC_LEG_V.WARN_LEG_DAS_YN IS 'Field to indicate if there is an abnormally high number of days at sea warning (> 30 days) for the given cruise leg (Y) or not (N) based on the leg dates';
COMMENT ON COLUMN CCD_QC_LEG_V.ERR_LEG_DAS_YN IS 'Field to indicate if there is an unacceptably high number of days at sea error (> 90 days) for the given cruise leg (Y) or not (N) based on the leg dates';

COMMENT ON COLUMN CCD_QC_LEG_V.MISS_GEAR_YN IS 'Field to indicate if there isn''t at least one Gear type defined for the given cruise leg (Y) or not (N)';

COMMENT ON COLUMN CCD_QC_LEG_V.MISS_DATA_SET_YN IS 'Field to indicate if there isn''t at least one data set associated with the given cruise leg (Y) or not (N)';





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







ALTER PACKAGE COMPILE CCD_DVM_PKG;







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

					--commit the successful transaction:
					COMMIT;


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

			 --commit the successful transaction:
			 COMMIT;

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

            --there was a PL/SQL error, rollback the SQL transaction:
						--rollback all of the Deep Copy DML since the deep copy was unsuccessful:
						ROLLBACK TO SAVEPOINT DEEP_COPY_SAVEPOINT;

						--check if this is a Cruise DVM Overlap Procesing Error:
						IF (SQLCODE = -20512) THEN
							--this is a Cruise DVM Overlap Procesing Error

							--generate the exception message:
							V_EXCEPTION_MSG := 'The copied Cruise could not be validated using the DVM:'||chr(10)||SQLERRM;

							--there was an error processing the current cruise leg's aliases
							DB_LOG_PKG.ADD_LOG_ENTRY('ERROR', PV_LOG_MSG_HEADER, V_EXCEPTION_MSG, V_SP_RET_CODE);


							--raise a custom application error:
							RAISE_APPLICATION_ERROR (-20610, V_EXCEPTION_MSG);
						ELSIF (SQLCODE = -20608) THEN
							--check if this is a duplicate leg alias name error

							--raise the exception from the COPY_LEG_ALIASES_SP procedure
							RAISE;

						ELSE

							--generate the exception message:
							V_EXCEPTION_MSG := 'The specified Cruise and associated attributes could not be copied successfully'||chr(10)||SQLERRM;

							--there was an error processing the current cruise leg's aliases
							DB_LOG_PKG.ADD_LOG_ENTRY('ERROR', PV_LOG_MSG_HEADER, V_EXCEPTION_MSG, V_SP_RET_CODE);

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
			P_TABLE_LIST(4) := 'CCD_LEG_DATA_SETS';

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

ALTER VIEW CCD_CCDP_DEEP_COPY_CMP_V COMPILE;





--define the upgrade version in the database upgrade log table:
INSERT INTO DB_UPGRADE_LOGS (UPGRADE_APP_NAME, UPGRADE_VERSION, UPGRADE_DATE, UPGRADE_DESC) VALUES ('Centralized Cruise Database', '1.0', TO_DATE('01-MAY-23', 'DD-MON-YY'), 'Upgraded from Version 0.4 (Git tag: APX_Cust_Err_Handler_db_v0.4) to  Version 1.0 (Git tag: APX_Cust_Err_Handler_db_v1.0) of the APEX custom error handler module database (Git URL: git@picgitlab.nmfs.local:centralized-data-tools/apex_tools.git in the "Error Handling" folder).  Dropped the standalone AAM.  Adding TZ offset to cruise legs table');


--commit the DB_UPGRADE_LOGS record insertion
COMMIT;
