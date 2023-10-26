--------------------------------------------------------
--------------------------------------------------------
--Database Name: Centralized Cruise Database
--Database Description: Centralized Cruise Database to track information about each PIFSC research cruise including activities, chief scientists, regions, etc. to remove the need for each division/program to manage this information
--------------------------------------------------------
--------------------------------------------------------

--------------------------------------------------------
--Centralized Cruise Database - version 1.0 updates:
--------------------------------------------------------

--Upgraded from Version 0.4 (Git tag: APX_Cust_Err_Handler_db_v0.4) to	Version 1.0 (Git tag: APX_Cust_Err_Handler_db_v1.0) of the APEX custom error handler module database (Git URL: git@picgitlab.nmfs.local:centralized-data-tools/apex_tools.git in the "Error Handling" folder)
@@"./upgrades/external_modules/Error_Handler_DDL_DML_upgrade_v1.0.sql"


--Upgraded from Version 1.4 (Git tag: DVM_db_v1.4) to	Version 1.5 (Git tag: DVM_db_v1.5) of the Data Validation Module Database (Git URL: git@github.com:PIFSC-NMFS-NOAA/PIFSC-DataValidationModule.git)
@@"./upgrades/external_modules/DVM_DDL_DML_upgrade_v1.5.sql"


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

COMMENT ON COLUMN CCD_CRUISE_LEGS.TZ_NAME IS 'The numeric offset for UTC or Time Zone Name (V$TIMEZONE_NAMES.TZNAME) for the local timezone where the cruise leg occurred (e.g. US/Hawaii, US/Samoa, Etc/GMT+9)';


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



ALTER TABLE CCD_LEG_DATA_SETS
ADD CONSTRAINT CCD_LEG_DATA_SETS_U1 UNIQUE
(
	CRUISE_LEG_ID
, DATA_SET_ID
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

comment on table CCD_DATA_SETS_V is 'Research Cruise Leg Data Sets (View)

This view returns all data set information and associated reference table values';








CREATE OR REPLACE VIEW
CCD_LEG_DATA_SETS_V
as
SELECT
CCD_LEG_DATA_SETS.LEG_DATA_SET_ID,
CCD_LEG_DATA_SETS.CRUISE_LEG_ID,
CCD_LEG_DATA_SETS.DATA_SET_ID,
CCD_LEG_DATA_SETS.LEG_DATA_SET_NOTES,
CCD_DATA_SETS_V.DATA_SET_NAME,
CCD_DATA_SETS_V.DATA_SET_DESC,
CCD_DATA_SETS_V.DATA_SET_INPORT_CAT_ID,
CCD_DATA_SETS_V.DATA_SET_INPORT_URL,
CCD_DATA_SETS_V.DATA_SET_TYPE_ID,
CCD_DATA_SETS_V.DATA_SET_TYPE_NAME,
CCD_DATA_SETS_V.DATA_SET_TYPE_DESC,
CCD_DATA_SETS_V.DATA_SET_TYPE_DOC_URL,
CCD_DATA_SETS_V.DATA_SET_STATUS_ID,
CCD_DATA_SETS_V.STATUS_CODE,
CCD_DATA_SETS_V.STATUS_NAME,
CCD_DATA_SETS_V.STATUS_DESC,
CCD_DATA_SETS_V.STATUS_COLOR
FROM
CCD_LEG_DATA_SETS
INNER JOIN CCD_DATA_SETS_V
ON CCD_LEG_DATA_SETS.DATA_SET_ID = CCD_DATA_SETS_V.DATA_SET_ID
order by CCD_DATA_SETS_V.DATA_SET_NAME;

COMMENT ON TABLE CCD_LEG_DATA_SETS_V IS 'Research Cruise Leg Data Sets (View)

This query returns all research cruise legs and their associated data sets';

COMMENT ON COLUMN CCD_LEG_DATA_SETS_V.LEG_DATA_SET_ID IS 'Primary key for the CCD_LEG_DATA_SETS table';
COMMENT ON COLUMN CCD_LEG_DATA_SETS_V.CRUISE_LEG_ID IS 'The cruise leg the Data Set is associated with';
COMMENT ON COLUMN CCD_LEG_DATA_SETS_V.DATA_SET_ID IS 'Primary key for the CCD_DATA_SETS table';
COMMENT ON COLUMN CCD_LEG_DATA_SETS_V.LEG_DATA_SET_NOTES IS 'Notes associated with the given Cruise Leg''s Data Set';
COMMENT ON COLUMN CCD_LEG_DATA_SETS_V.DATA_SET_NAME IS 'The Name of the data set';
COMMENT ON COLUMN CCD_LEG_DATA_SETS_V.DATA_SET_DESC IS 'Description for the data set';
COMMENT ON COLUMN CCD_LEG_DATA_SETS_V.DATA_SET_INPORT_CAT_ID IS 'InPort Catalog ID for the data set';
COMMENT ON COLUMN CCD_LEG_DATA_SETS_V.DATA_SET_INPORT_URL IS 'InPort metadata URL for the data set';
COMMENT ON COLUMN CCD_LEG_DATA_SETS_V.DATA_SET_TYPE_ID IS 'Primary key for the CCD_DATA_SET_TYPES table';
COMMENT ON COLUMN CCD_LEG_DATA_SETS_V.DATA_SET_TYPE_NAME IS 'Name for the data set type';
COMMENT ON COLUMN CCD_LEG_DATA_SETS_V.DATA_SET_TYPE_DESC IS 'Description for the data set type';
COMMENT ON COLUMN CCD_LEG_DATA_SETS_V.DATA_SET_TYPE_DOC_URL IS 'Documentation URL for the data type, this can be an InPort URL for the parent Project record of the individual data sets or a documentation package that provides information about this data set type';
COMMENT ON COLUMN CCD_LEG_DATA_SETS_V.DATA_SET_STATUS_ID IS 'Primary key for the CCD_DATA_SET_STATUS table';
COMMENT ON COLUMN CCD_LEG_DATA_SETS_V.STATUS_CODE IS 'The alpha-numeric code for the data status';
COMMENT ON COLUMN CCD_LEG_DATA_SETS_V.STATUS_NAME IS 'The name of the data status';
COMMENT ON COLUMN CCD_LEG_DATA_SETS_V.STATUS_DESC IS 'The description for the data status';
COMMENT ON COLUMN CCD_LEG_DATA_SETS_V.STATUS_COLOR IS 'The hex value for the color that the data set status has in the application interface';





CREATE OR REPLACE VIEW
CCD_LEG_ECOSYSTEMS_V

AS
SELECT
CCD_LEG_ECOSYSTEMS.LEG_ECOSYSTEM_ID,
CCD_LEG_ECOSYSTEMS.CRUISE_LEG_ID,
CCD_LEG_ECOSYSTEMS.REG_ECOSYSTEM_ID,
CCD_LEG_ECOSYSTEMS.LEG_ECOSYSTEM_NOTES,
CCD_REG_ECOSYSTEMS.REG_ECOSYSTEM_NAME,
CCD_REG_ECOSYSTEMS.REG_ECOSYSTEM_DESC,
CCD_REG_ECOSYSTEMS.FINSS_ID,
CCD_REG_ECOSYSTEMS.APP_SHOW_OPT_YN

FROM
CCD_LEG_ECOSYSTEMS INNER JOIN
CCD_REG_ECOSYSTEMS ON CCD_LEG_ECOSYSTEMS.REG_ECOSYSTEM_ID = CCD_REG_ECOSYSTEMS.REG_ECOSYSTEM_ID
order by CCD_REG_ECOSYSTEMS.REG_ECOSYSTEM_NAME
;

COMMENT ON TABLE CCD_LEG_ECOSYSTEMS_V IS 'Research Cruise Leg Regional Ecosystems (View)

This query returns all research cruise legs and their associated regional ecosystems';

COMMENT ON COLUMN CCD_LEG_ECOSYSTEMS_V.LEG_ECOSYSTEM_ID IS 'Primary key for the CCD_LEG_ECOSYSTEMS table';
COMMENT ON COLUMN CCD_LEG_ECOSYSTEMS_V.CRUISE_LEG_ID IS 'The cruise leg the regional ecosystem is associated with';
COMMENT ON COLUMN CCD_LEG_ECOSYSTEMS_V.REG_ECOSYSTEM_ID IS 'Primary key for the Regional Ecosystem table';
COMMENT ON COLUMN CCD_LEG_ECOSYSTEMS_V.LEG_ECOSYSTEM_NOTES IS 'Notes associated with the given Cruise Leg''s regional ecosystems';
COMMENT ON COLUMN CCD_LEG_ECOSYSTEMS_V.REG_ECOSYSTEM_NAME IS 'Name of the given Regional Ecosystem';
COMMENT ON COLUMN CCD_LEG_ECOSYSTEMS_V.REG_ECOSYSTEM_DESC IS 'Description for the given Regional Ecosystem';
COMMENT ON COLUMN CCD_LEG_ECOSYSTEMS_V.FINSS_ID IS 'The ID value from the FINSS system';
COMMENT ON COLUMN CCD_LEG_ECOSYSTEMS_V.APP_SHOW_OPT_YN IS 'Flag to indicate whether or not to include this record in the data management application option lists by default (Y) or not (N)';







CREATE OR REPLACE VIEW
CCD_LEG_GEAR_V

AS
SELECT

CCD_LEG_GEAR.LEG_GEAR_ID,
CCD_LEG_GEAR.CRUISE_LEG_ID,
CCD_LEG_GEAR.GEAR_ID,
CCD_LEG_GEAR.LEG_GEAR_NOTES,
CCD_GEAR.GEAR_NAME,
CCD_GEAR.GEAR_DESC,
CCD_GEAR.FINSS_ID,
CCD_GEAR.APP_SHOW_OPT_YN
FROM
CCD_LEG_GEAR
INNER JOIN CCD_GEAR
ON CCD_LEG_GEAR.GEAR_ID = CCD_GEAR.GEAR_ID
ORDER BY CCD_GEAR.GEAR_NAME
;

COMMENT ON TABLE CCD_LEG_GEAR_V IS 'Research Cruise Leg Gear (View)

This query returns all research cruise legs and their associated gear';

COMMENT ON COLUMN CCD_LEG_GEAR_V.LEG_GEAR_ID IS 'Primary key for the CCD_LEG_GEAR table';
COMMENT ON COLUMN CCD_LEG_GEAR_V.CRUISE_LEG_ID IS 'The cruise leg the gear is associated with';
COMMENT ON COLUMN CCD_LEG_GEAR_V.GEAR_ID IS 'Primary key for the Gear table';
COMMENT ON COLUMN CCD_LEG_GEAR_V.LEG_GEAR_NOTES IS 'Notes associated with the given Cruise Leg''s gear';
COMMENT ON COLUMN CCD_LEG_GEAR_V.GEAR_NAME IS 'Name of the given Gear';
COMMENT ON COLUMN CCD_LEG_GEAR_V.GEAR_DESC IS 'Description for the given Gear';
COMMENT ON COLUMN CCD_LEG_GEAR_V.FINSS_ID IS 'The ID value from the FINSS system';
COMMENT ON COLUMN CCD_LEG_GEAR_V.APP_SHOW_OPT_YN IS 'Flag to indicate whether or not to include this record in the data management application option lists by default (Y) or not (N)';


CREATE OR REPLACE VIEW

CCD_LEG_REGIONS_V
AS
SELECT
CCD_LEG_REGIONS.LEG_REGION_ID,
CCD_LEG_REGIONS.REGION_ID,
CCD_LEG_REGIONS.CRUISE_LEG_ID,
CCD_LEG_REGIONS.LEG_REGION_NOTES,
CCD_REGIONS.REGION_CODE,
CCD_REGIONS.REGION_NAME,
CCD_REGIONS.REGION_DESC
FROM
CCD_LEG_REGIONS
INNER JOIN CCD_REGIONS
ON CCD_LEG_REGIONS.REGION_ID = CCD_REGIONS.REGION_ID
ORDER BY CCD_REGIONS.REGION_NAME
;


COMMENT ON TABLE CCD_LEG_REGIONS_V IS 'Research Cruise Leg Regions (View)

This query returns all research cruise legs and their associated gear';

COMMENT ON COLUMN CCD_LEG_REGIONS_V.LEG_REGION_ID IS 'Primary key for the ccd_leg_regions table';
COMMENT ON COLUMN CCD_LEG_REGIONS_V.REGION_ID IS 'Primary key for the CCD_REGIONS table';
COMMENT ON COLUMN CCD_LEG_REGIONS_V.CRUISE_LEG_ID IS 'The cruise leg that the given region was surveyed during';
COMMENT ON COLUMN CCD_LEG_REGIONS_V.LEG_REGION_NOTES IS 'Notes about the region that was surveyed during the given cruise leg';
COMMENT ON COLUMN CCD_LEG_REGIONS_V.REGION_CODE IS 'The alphabetic code for the given region';
COMMENT ON COLUMN CCD_LEG_REGIONS_V.REGION_NAME IS 'The name of the given region';
COMMENT ON COLUMN CCD_LEG_REGIONS_V.REGION_DESC IS 'The description of the given region';






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
INNER JOIN CCD_VESSELS ON
CCD_CRUISE_LEGS.VESSEL_ID = CCD_VESSELS.VESSEL_ID

INNER JOIN CCD_PLAT_TYPES ON
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
COMMENT ON COLUMN CCD_LEG_V.TZ_NAME IS 'The numeric offset for UTC or Time Zone Name (V$TIMEZONE_NAMES.TZNAME) for the local timezone where the cruise leg occurred (e.g. US/Hawaii, US/Samoa, Etc/GMT+9)';

COMMENT ON COLUMN CCD_LEG_V.CRUISE_ID IS 'The cruise for the given research cruise leg';


COMMENT ON COLUMN CCD_LEG_V.VESSEL_ID IS 'Foreign key reference to the CCD_VESSELS table for the cruise leg''s vessel';
COMMENT ON COLUMN CCD_LEG_V.VESSEL_NAME IS 'Name of the given research vessel';
COMMENT ON COLUMN CCD_LEG_V.VESSEL_DESC IS 'Description for the given research vessel';
COMMENT ON COLUMN CCD_LEG_V.PLAT_TYPE_ID IS 'Platform Type for the given research cruise leg';
COMMENT ON COLUMN CCD_LEG_V.PLAT_TYPE_NAME IS 'Name of the given Platform Type';
COMMENT ON COLUMN CCD_LEG_V.PLAT_TYPE_DESC IS 'Description for the given Platform Type';






CREATE OR REPLACE VIEW
CCD_LEG_AGG_V

AS

SELECT
		CCD_LEG_V.cruise_id,
		count(*) NUM_LEGS,
		MIN (CCD_LEG_V.LEG_START_DATE) CRUISE_START_DATE,
		TO_CHAR(MIN (CCD_LEG_V.LEG_START_DATE), 'MM/DD/YYYY') FORMAT_CRUISE_START_DATE,
		MAX (CCD_LEG_V.LEG_END_DATE) CRUISE_END_DATE,
		TO_CHAR(MAX (CCD_LEG_V.LEG_END_DATE), 'MM/DD/YYYY') FORMAT_CRUISE_END_DATE,
		SUM(CCD_LEG_V.LEG_DAS) CRUISE_DAS,
	(MAX (CCD_LEG_V.LEG_END_DATE) - MIN (CCD_LEG_V.LEG_START_DATE) + 1) CRUISE_LEN_DAYS,
		TO_CHAR(MIN (CCD_LEG_V.LEG_START_DATE), 'YYYY') CRUISE_YEAR,
		CEN_UTILS.CEN_UTIL_PKG.CALC_FISCAL_YEAR_FN(MIN (CCD_LEG_V.LEG_START_DATE)) CRUISE_FISC_YEAR,
		LISTAGG(CCD_LEG_V.LEG_NAME, ', ') WITHIN GROUP (ORDER BY CCD_LEG_V.LEG_START_DATE) as LEG_NAME_CD_LIST,
		LISTAGG(CCD_LEG_V.LEG_NAME, '; ') WITHIN GROUP (ORDER BY CCD_LEG_V.LEG_START_DATE) as LEG_NAME_SCD_LIST,
		LISTAGG(CCD_LEG_V.LEG_NAME, chr(10)) WITHIN GROUP (ORDER BY CCD_LEG_V.LEG_START_DATE) as LEG_NAME_RC_LIST,
		LISTAGG(CCD_LEG_V.LEG_NAME, '<BR>') WITHIN GROUP (ORDER BY CCD_LEG_V.LEG_START_DATE) as LEG_NAME_BR_LIST,
		LISTAGG(CCD_LEG_V.LEG_NAME || ' ('||TO_CHAR(CCD_LEG_V.LEG_START_DATE, 'MM/DD/YYYY')||' - '||TO_CHAR(CCD_LEG_V.LEG_END_DATE, 'MM/DD/YYYY')||')', ', ') WITHIN GROUP (ORDER BY CCD_LEG_V.LEG_START_DATE) as LEG_NAME_DATES_CD_LIST,
		LISTAGG(CCD_LEG_V.LEG_NAME || ' ('||TO_CHAR(CCD_LEG_V.LEG_START_DATE, 'MM/DD/YYYY')||' - '||TO_CHAR(CCD_LEG_V.LEG_END_DATE, 'MM/DD/YYYY')||')', ', ') WITHIN GROUP (ORDER BY CCD_LEG_V.LEG_START_DATE) as LEG_NAME_DATES_SCD_LIST,
		LISTAGG(CCD_LEG_V.LEG_NAME || ' ('||TO_CHAR(CCD_LEG_V.LEG_START_DATE, 'MM/DD/YYYY')||' - '||TO_CHAR(CCD_LEG_V.LEG_END_DATE, 'MM/DD/YYYY')||')', chr(10)) WITHIN GROUP (ORDER BY CCD_LEG_V.LEG_START_DATE) as LEG_NAME_DATES_RC_LIST,
		LISTAGG(CCD_LEG_V.LEG_NAME || ' ('||TO_CHAR(CCD_LEG_V.LEG_START_DATE, 'MM/DD/YYYY')||' - '||TO_CHAR(CCD_LEG_V.LEG_END_DATE, 'MM/DD/YYYY')||')', '<BR>') WITHIN GROUP (ORDER BY CCD_LEG_V.LEG_START_DATE) as LEG_NAME_DATES_BR_LIST,
		LISTAGG(CCD_LEG_V.LEG_NAME || ' ('||TO_CHAR(CCD_LEG_V.LEG_START_DATE, 'MM/DD/YYYY')||' - '||TO_CHAR(CCD_LEG_V.LEG_END_DATE, 'MM/DD/YYYY')||' on '||CCD_LEG_V.VESSEL_NAME||')', ', ') WITHIN GROUP (ORDER BY CCD_LEG_V.LEG_START_DATE) as LEG_VESS_NAME_DATES_CD_LIST,
		LISTAGG(CCD_LEG_V.LEG_NAME || ' ('||TO_CHAR(CCD_LEG_V.LEG_START_DATE, 'MM/DD/YYYY')||' - '||TO_CHAR(CCD_LEG_V.LEG_END_DATE, 'MM/DD/YYYY')||' on '||CCD_LEG_V.VESSEL_NAME||')', ', ') WITHIN GROUP (ORDER BY CCD_LEG_V.LEG_START_DATE) as LEG_VESS_NAME_DATES_SCD_LIST,
		LISTAGG(CCD_LEG_V.LEG_NAME || ' ('||TO_CHAR(CCD_LEG_V.LEG_START_DATE, 'MM/DD/YYYY')||' - '||TO_CHAR(CCD_LEG_V.LEG_END_DATE, 'MM/DD/YYYY')||' on '||CCD_LEG_V.VESSEL_NAME||')', chr(10)) WITHIN GROUP (ORDER BY CCD_LEG_V.LEG_START_DATE) as LEG_VESS_NAME_DATES_RC_LIST,
		LISTAGG(CCD_LEG_V.LEG_NAME || ' ('||TO_CHAR(CCD_LEG_V.LEG_START_DATE, 'MM/DD/YYYY')||' - '||TO_CHAR(CCD_LEG_V.LEG_END_DATE, 'MM/DD/YYYY')||' on '||CCD_LEG_V.VESSEL_NAME||')', '<BR>') WITHIN GROUP (ORDER BY CCD_LEG_V.LEG_START_DATE) as LEG_VESS_NAME_DATES_BR_LIST

		FROM
		CCD_LEG_V
		group by
		CCD_LEG_V.cruise_id
;


COMMENT ON TABLE CCD_LEG_AGG_V IS 'Research Cruise Leg Aggregated Values (View)

This view returns all cruise leg information aggregated for each cruise to calculate the cruise-level information based on the cruise legs (e.g. DAS, cruise start date, cruise fiscal year, etc.)';


COMMENT ON COLUMN CCD_LEG_AGG_V.CRUISE_ID IS 'Primary key for the CCD_CRUISES table';



COMMENT ON COLUMN CCD_LEG_AGG_V.CRUISE_DAS IS 'The total number of days at sea for each of the legs associated with the given cruise';
COMMENT ON COLUMN CCD_LEG_AGG_V.CRUISE_LEN_DAYS IS 'The total number of days between the Cruise Start and End Dates for the given cruise';


COMMENT ON COLUMN CCD_LEG_AGG_V.CRUISE_YEAR IS 'The calendar year for the given cruise (based on the earliest associated cruise leg''s start date)';
COMMENT ON COLUMN CCD_LEG_AGG_V.CRUISE_FISC_YEAR IS 'The calendar year for the given cruise (based on the earliest associated cruise leg''s start date)';
COMMENT ON COLUMN CCD_LEG_AGG_V.NUM_LEGS IS 'The number of cruise legs associated with the given cruise';
COMMENT ON COLUMN CCD_LEG_AGG_V.LEG_NAME_CD_LIST IS 'Comma-delimited list of leg names associated with the given cruise';
COMMENT ON COLUMN CCD_LEG_AGG_V.LEG_NAME_SCD_LIST IS 'Semicolon-delimited list of leg names associated with the given cruise';
COMMENT ON COLUMN CCD_LEG_AGG_V.LEG_NAME_RC_LIST IS 'Return carriage/new line delimited list of leg names associated with the given cruise';
COMMENT ON COLUMN CCD_LEG_AGG_V.LEG_NAME_BR_LIST IS '<BR> tag (intended for web pages) delimited list of leg names associated with the given cruise';


COMMENT ON COLUMN CCD_LEG_AGG_V.LEG_VESS_NAME_DATES_CD_LIST IS 'Comma-delimited list of leg names, the associated leg dates and vessel name associated with the given cruise';
COMMENT ON COLUMN CCD_LEG_AGG_V.LEG_VESS_NAME_DATES_SCD_LIST IS 'Semicolon-delimited list of leg names, the associated leg dates and vessel name associated with the given cruise';
COMMENT ON COLUMN CCD_LEG_AGG_V.LEG_VESS_NAME_DATES_RC_LIST IS 'Return carriage/new line delimited list of leg names, the associated leg dates and vessel name associated with the given cruise';
COMMENT ON COLUMN CCD_LEG_AGG_V.LEG_VESS_NAME_DATES_BR_LIST IS '<BR> tag (intended for web pages) delimited list of leg names, the associated leg dates and vessel name associated with the given cruise';


COMMENT ON COLUMN CCD_LEG_AGG_V.LEG_NAME_DATES_CD_LIST IS 'Comma-delimited list of leg names, the associated leg dates for the given cruise';
COMMENT ON COLUMN CCD_LEG_AGG_V.LEG_NAME_DATES_SCD_LIST IS 'Semicolon-delimited list of leg names, the associated leg dates for the given cruise';
COMMENT ON COLUMN CCD_LEG_AGG_V.LEG_NAME_DATES_RC_LIST IS 'Return carriage/new line delimited list of leg names, the associated leg dates for the given cruise';
COMMENT ON COLUMN CCD_LEG_AGG_V.LEG_NAME_DATES_BR_LIST IS '<BR> tag (intended for web pages) delimited list of leg names, the associated leg dates for the given cruise';



COMMENT ON COLUMN CCD_LEG_AGG_V.CRUISE_START_DATE IS 'The start date in the corresponding time zone for the given cruise (based on the earliest associated cruise leg''s start date)';
COMMENT ON COLUMN CCD_LEG_AGG_V.FORMAT_CRUISE_START_DATE IS 'The formatted start date in the corresponding time zone for the given cruise (based on the earliest associated cruise leg''s start date) in MM/DD/YYYY HH24:MI:SS format';
COMMENT ON COLUMN CCD_LEG_AGG_V.CRUISE_END_DATE IS 'The end date in the corresponding time zone for the given cruise (based on the latest associated cruise leg''s end date)';
COMMENT ON COLUMN CCD_LEG_AGG_V.FORMAT_CRUISE_END_DATE IS 'The formatted end date in the corresponding time zone for the given cruise (based on the latest associated cruise leg''s end date) in MM/DD/YYYY HH24:MI:SS format';



--redefine all views that return information about cruises:
CREATE OR REPLACE VIEW CCD_CRUISE_V

AS
SELECT CCD_CRUISES.CRUISE_ID,
	CCD_CRUISES.CRUISE_NAME,
	CCD_CRUISES.CRUISE_NOTES,
	CCD_CRUISES.CRUISE_DESC,
	CCD_CRUISES.OBJ_BASED_METRICS,
	CCD_SCI_CENTER_DIV_V.SCI_CENTER_DIV_ID,
	CCD_SCI_CENTER_DIV_V.SCI_CENTER_DIV_CODE,
	CCD_SCI_CENTER_DIV_V.SCI_CENTER_DIV_NAME,
	CCD_SCI_CENTER_DIV_V.SCI_CENTER_DIV_DESC,

	CCD_SCI_CENTER_DIV_V.SCI_CENTER_ID,
	CCD_SCI_CENTER_DIV_V.SCI_CENTER_NAME,
	CCD_SCI_CENTER_DIV_V.SCI_CENTER_DESC,
	CCD_STD_SVY_NAMES.STD_SVY_NAME_ID,
	CCD_STD_SVY_NAMES.STD_SVY_NAME,
	CCD_STD_SVY_NAMES.STD_SVY_DESC,
	CCD_SVY_FREQ.SVY_FREQ_ID,
	CCD_SVY_FREQ.SVY_FREQ_NAME,
	CCD_SVY_FREQ.SVY_FREQ_DESC,
	CCD_CRUISES.STD_SVY_NAME_OTH,
	(CASE WHEN CCD_STD_SVY_NAMES.STD_SVY_NAME IS NOT NULL THEN CCD_STD_SVY_NAMES.STD_SVY_NAME ELSE STD_SVY_NAME_OTH END) STD_SVY_NAME_VAL,


	CCD_SVY_TYPES.SVY_TYPE_ID,
	CCD_SVY_TYPES.SVY_TYPE_NAME,
	CCD_SVY_TYPES.SVY_TYPE_DESC,

	CRUISE_URL,
	CRUISE_CONT_EMAIL,
	PTA_ISS_ID


FROM CCD_CRUISES
INNER JOIN CCD_SVY_TYPES
ON CCD_SVY_TYPES.SVY_TYPE_ID = CCD_CRUISES.SVY_TYPE_ID

INNER JOIN CCD_SCI_CENTER_DIV_V
ON CCD_CRUISES.SCI_CENTER_DIV_ID = CCD_SCI_CENTER_DIV_V.SCI_CENTER_DIV_ID

LEFT JOIN CCD_STD_SVY_NAMES
ON CCD_STD_SVY_NAMES.STD_SVY_NAME_ID = CCD_CRUISES.STD_SVY_NAME_ID

LEFT JOIN CCD_SVY_FREQ
ON CCD_SVY_FREQ.SVY_FREQ_ID = CCD_CRUISES.SVY_FREQ_ID

ORDER BY CCD_SCI_CENTER_DIV_V.SCI_CENTER_NAME,
CCD_STD_SVY_NAMES.STD_SVY_NAME,
CCD_CRUISES.CRUISE_NAME
;




COMMENT ON TABLE CCD_CRUISE_V IS 'Research Cruises (View)

This query returns all of the research cruises and their associated reference tables (e.g. Science Center, standard survey name, survey frequency, etc.)';



COMMENT ON COLUMN CCD_CRUISE_V.CRUISE_ID IS 'Primary key for the CCD_CRUISES table';
COMMENT ON COLUMN CCD_CRUISE_V.CRUISE_NAME IS 'The name of the given cruise designated by NOAA (e.g. SE-15-01)';
COMMENT ON COLUMN CCD_CRUISE_V.CRUISE_NOTES IS 'Any notes for the given research cruise';



COMMENT ON COLUMN CCD_CRUISE_V.CRUISE_DESC IS 'Description for the given research cruise';
COMMENT ON COLUMN CCD_CRUISE_V.OBJ_BASED_METRICS IS 'Objective Based Metrics for the given research cruise';
COMMENT ON COLUMN CCD_CRUISE_V.SCI_CENTER_DIV_ID IS 'Primary key for the Science Center Division table';
COMMENT ON COLUMN CCD_CRUISE_V.SCI_CENTER_DIV_CODE IS 'Abbreviated code for the given Science Center Division';

COMMENT ON COLUMN CCD_CRUISE_V.SCI_CENTER_DIV_NAME IS 'Name of the given Science Center Division';

COMMENT ON COLUMN CCD_CRUISE_V.SCI_CENTER_DIV_DESC IS 'Description for the given Science Center Division';




COMMENT ON COLUMN CCD_CRUISE_V.SCI_CENTER_ID IS 'Primary key for the Science Center table';
COMMENT ON COLUMN CCD_CRUISE_V.SCI_CENTER_NAME IS 'Name of the given Science Center';
COMMENT ON COLUMN CCD_CRUISE_V.SCI_CENTER_DESC IS 'Description for the given Science Center';
COMMENT ON COLUMN CCD_CRUISE_V.STD_SVY_NAME_ID IS 'Primary key for the Standard Survey Name table';
COMMENT ON COLUMN CCD_CRUISE_V.STD_SVY_NAME IS 'Name of the given Standard Survey Name';
COMMENT ON COLUMN CCD_CRUISE_V.STD_SVY_DESC IS 'Description for the given Standard Survey Name';
COMMENT ON COLUMN CCD_CRUISE_V.SVY_FREQ_ID IS 'Primary key for the Survey Frequency table';
COMMENT ON COLUMN CCD_CRUISE_V.SVY_FREQ_NAME IS 'Name of the given Survey Frequency';
COMMENT ON COLUMN CCD_CRUISE_V.SVY_FREQ_DESC IS 'Description for the given Survey Frequency';
COMMENT ON COLUMN CCD_CRUISE_V.STD_SVY_NAME_OTH IS 'Field defines a Standard Survey Name that is not included in the Standard Survey Name table';
COMMENT ON COLUMN CCD_CRUISE_V.STD_SVY_NAME_VAL IS 'This field contains the Standard Survey Name defined for the given cruise.	If the STD_SVY_NAME_ID field is defined then the associated CCD_STD_SVY_NAMES.STD_SVY_NAME is used because the foreign key is given precedence, otherwise the STD_SVY_NAME_OTH field value is used';


COMMENT ON COLUMN CCD_CRUISE_V.SVY_TYPE_ID IS 'Primary key for the Survey Type table';
COMMENT ON COLUMN CCD_CRUISE_V.SVY_TYPE_NAME IS 'Name of the given Survey Type';
COMMENT ON COLUMN CCD_CRUISE_V.SVY_TYPE_DESC IS 'Description for the given Survey Type';


COMMENT ON COLUMN CCD_CRUISE_V.CRUISE_URL IS 'The Cruise URL (Referred to as "Survey URL" in FINSS System) for the given Cruise';
COMMENT ON COLUMN CCD_CRUISE_V.CRUISE_CONT_EMAIL IS 'The Cruise Contact Email (Referred to as "Survey Contact Email" in FINSS System) for the given Cruise';


COMMENT ON COLUMN CCD_CRUISE_V.PTA_ISS_ID IS 'Foreign key reference to the Issues (PTA) intersection table';





CREATE OR REPLACE VIEW
CCD_CRUISE_AGG_V


AS
select

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
CCD_CRUISE_V.PTA_ISS_ID,

CCD_LEG_AGG_V.NUM_LEGS,
CCD_LEG_AGG_V.CRUISE_START_DATE,
CCD_LEG_AGG_V.FORMAT_CRUISE_START_DATE,
CCD_LEG_AGG_V.CRUISE_END_DATE,
CCD_LEG_AGG_V.FORMAT_CRUISE_END_DATE,
CCD_LEG_AGG_V.CRUISE_DAS,
CCD_LEG_AGG_V.CRUISE_LEN_DAYS,
CCD_LEG_AGG_V.CRUISE_YEAR,
CCD_LEG_AGG_V.CRUISE_FISC_YEAR,
CCD_LEG_AGG_V.LEG_NAME_CD_LIST,
CCD_LEG_AGG_V.LEG_NAME_SCD_LIST,
CCD_LEG_AGG_V.LEG_NAME_RC_LIST,
CCD_LEG_AGG_V.LEG_NAME_BR_LIST,
CCD_LEG_AGG_V.LEG_NAME_DATES_CD_LIST,
CCD_LEG_AGG_V.LEG_NAME_DATES_SCD_LIST,
CCD_LEG_AGG_V.LEG_NAME_DATES_RC_LIST,
CCD_LEG_AGG_V.LEG_NAME_DATES_BR_LIST,
CCD_LEG_AGG_V.LEG_VESS_NAME_DATES_CD_LIST,
CCD_LEG_AGG_V.LEG_VESS_NAME_DATES_SCD_LIST,
CCD_LEG_AGG_V.LEG_VESS_NAME_DATES_RC_LIST,
CCD_LEG_AGG_V.LEG_VESS_NAME_DATES_BR_LIST

FROM CCD_CRUISE_V LEFT JOIN
CCD_LEG_AGG_V ON
CCD_LEG_AGG_V.CRUISE_ID = CCD_CRUISE_V.CRUISE_ID
ORDER BY
CCD_CRUISE_V.SCI_CENTER_NAME,
CCD_CRUISE_V.STD_SVY_NAME,
CCD_CRUISE_V.CRUISE_NAME
;




COMMENT ON TABLE CCD_CRUISE_AGG_V IS 'Research Cruises Aggregated Information (View)

This query returns all of the research cruises and their associated reference tables (e.g. Science Center, standard survey name, survey frequency, etc.) as well as the aggregated leg information (e.g. DAS, cruise start date, cruise fiscal year, etc.)';







COMMENT ON COLUMN CCD_CRUISE_AGG_V.CRUISE_ID IS 'Primary key for the CCD_CRUISES table';
COMMENT ON COLUMN CCD_CRUISE_AGG_V.CRUISE_NAME IS 'The name of the given cruise designated by NOAA (e.g. SE-15-01)';
COMMENT ON COLUMN CCD_CRUISE_AGG_V.CRUISE_NOTES IS 'Any notes for the given research cruise';



COMMENT ON COLUMN CCD_CRUISE_AGG_V.CRUISE_DESC IS 'Description for the given research cruise';
COMMENT ON COLUMN CCD_CRUISE_AGG_V.OBJ_BASED_METRICS IS 'Objective Based Metrics for the given research cruise';
COMMENT ON COLUMN CCD_CRUISE_AGG_V.SCI_CENTER_DIV_ID IS 'Primary key for the Science Center Division table';
COMMENT ON COLUMN CCD_CRUISE_AGG_V.SCI_CENTER_DIV_CODE IS 'Abbreviated code for the given Science Center Division';

COMMENT ON COLUMN CCD_CRUISE_AGG_V.SCI_CENTER_DIV_NAME IS 'Name of the given Science Center Division';

COMMENT ON COLUMN CCD_CRUISE_AGG_V.SCI_CENTER_DIV_DESC IS 'Description for the given Science Center Division';




COMMENT ON COLUMN CCD_CRUISE_AGG_V.SCI_CENTER_ID IS 'Primary key for the Science Center table';
COMMENT ON COLUMN CCD_CRUISE_AGG_V.SCI_CENTER_NAME IS 'Name of the given Science Center';
COMMENT ON COLUMN CCD_CRUISE_AGG_V.SCI_CENTER_DESC IS 'Description for the given Science Center';
COMMENT ON COLUMN CCD_CRUISE_AGG_V.STD_SVY_NAME_ID IS 'Primary key for the Standard Survey Name table';
COMMENT ON COLUMN CCD_CRUISE_AGG_V.STD_SVY_NAME IS 'Name of the given Standard Survey Name';
COMMENT ON COLUMN CCD_CRUISE_AGG_V.STD_SVY_DESC IS 'Description for the given Standard Survey Name';
COMMENT ON COLUMN CCD_CRUISE_AGG_V.SVY_FREQ_ID IS 'Primary key for the Survey Frequency table';
COMMENT ON COLUMN CCD_CRUISE_AGG_V.SVY_FREQ_NAME IS 'Name of the given Survey Frequency';
COMMENT ON COLUMN CCD_CRUISE_AGG_V.SVY_FREQ_DESC IS 'Description for the given Survey Frequency';
COMMENT ON COLUMN CCD_CRUISE_AGG_V.STD_SVY_NAME_OTH IS 'Field defines a Standard Survey Name that is not included in the Standard Survey Name table';
COMMENT ON COLUMN CCD_CRUISE_AGG_V.STD_SVY_NAME_VAL IS 'This field contains the Standard Survey Name defined for the given cruise.	If the STD_SVY_NAME_ID field is defined then the associated CCD_STD_SVY_NAMES.STD_SVY_NAME is used because the foreign key is given precedence, otherwise the STD_SVY_NAME_OTH field value is used';


COMMENT ON COLUMN CCD_CRUISE_AGG_V.SVY_TYPE_ID IS 'Primary key for the Survey Type table';
COMMENT ON COLUMN CCD_CRUISE_AGG_V.SVY_TYPE_NAME IS 'Name of the given Survey Type';
COMMENT ON COLUMN CCD_CRUISE_AGG_V.SVY_TYPE_DESC IS 'Description for the given Survey Type';


COMMENT ON COLUMN CCD_CRUISE_AGG_V.CRUISE_URL IS 'The Cruise URL (Referred to as "Survey URL" in FINSS System) for the given Cruise';
COMMENT ON COLUMN CCD_CRUISE_AGG_V.CRUISE_CONT_EMAIL IS 'The Cruise Contact Email (Referred to as "Survey Contact Email" in FINSS System) for the given Cruise';


COMMENT ON COLUMN CCD_CRUISE_AGG_V.CRUISE_DAS IS 'The total number of days at sea for each of the legs associated with the given cruise';
COMMENT ON COLUMN CCD_CRUISE_AGG_V.CRUISE_LEN_DAYS IS 'The total number of days between the Cruise Start and End Dates for the given cruise';


COMMENT ON COLUMN CCD_CRUISE_AGG_V.CRUISE_YEAR IS 'The calendar year for the given cruise (based on the earliest associated cruise leg''s start date)';
COMMENT ON COLUMN CCD_CRUISE_AGG_V.CRUISE_FISC_YEAR IS 'The calendar year for the given cruise (based on the earliest associated cruise leg''s start date)';
COMMENT ON COLUMN CCD_CRUISE_AGG_V.NUM_LEGS IS 'The number of cruise legs associated with the given cruise';
COMMENT ON COLUMN CCD_CRUISE_AGG_V.LEG_NAME_CD_LIST IS 'Comma-delimited list of leg names associated with the given cruise';
COMMENT ON COLUMN CCD_CRUISE_AGG_V.LEG_NAME_SCD_LIST IS 'Semicolon-delimited list of leg names associated with the given cruise';
COMMENT ON COLUMN CCD_CRUISE_AGG_V.LEG_NAME_RC_LIST IS 'Return carriage/new line delimited list of leg names associated with the given cruise';
COMMENT ON COLUMN CCD_CRUISE_AGG_V.LEG_NAME_BR_LIST IS '<BR> tag (intended for web pages) delimited list of leg names associated with the given cruise';


COMMENT ON COLUMN CCD_CRUISE_AGG_V.LEG_VESS_NAME_DATES_CD_LIST IS 'Comma-delimited list of leg names, the associated leg dates and vessel name associated with the given cruise';
COMMENT ON COLUMN CCD_CRUISE_AGG_V.LEG_VESS_NAME_DATES_SCD_LIST IS 'Semicolon-delimited list of leg names, the associated leg dates and vessel name associated with the given cruise';
COMMENT ON COLUMN CCD_CRUISE_AGG_V.LEG_VESS_NAME_DATES_RC_LIST IS 'Return carriage/new line delimited list of leg names, the associated leg dates and vessel name associated with the given cruise';
COMMENT ON COLUMN CCD_CRUISE_AGG_V.LEG_VESS_NAME_DATES_BR_LIST IS '<BR> tag (intended for web pages) delimited list of leg names, the associated leg dates and vessel name associated with the given cruise';


COMMENT ON COLUMN CCD_CRUISE_AGG_V.LEG_NAME_DATES_CD_LIST IS 'Comma-delimited list of leg names, the associated leg dates for the given cruise';
COMMENT ON COLUMN CCD_CRUISE_AGG_V.LEG_NAME_DATES_SCD_LIST IS 'Semicolon-delimited list of leg names, the associated leg dates for the given cruise';
COMMENT ON COLUMN CCD_CRUISE_AGG_V.LEG_NAME_DATES_RC_LIST IS 'Return carriage/new line delimited list of leg names, the associated leg dates for the given cruise';
COMMENT ON COLUMN CCD_CRUISE_AGG_V.LEG_NAME_DATES_BR_LIST IS '<BR> tag (intended for web pages) delimited list of leg names, the associated leg dates for the given cruise';
COMMENT ON COLUMN CCD_CRUISE_AGG_V.PTA_ISS_ID IS 'Foreign key reference to the Issues (PTA) intersection table';



COMMENT ON COLUMN CCD_CRUISE_AGG_V.CRUISE_START_DATE IS 'The start date in the corresponding time zone for the given cruise (based on the earliest associated cruise leg''s start date)';
COMMENT ON COLUMN CCD_CRUISE_AGG_V.FORMAT_CRUISE_START_DATE IS 'The formatted start date in the corresponding time zone for the given cruise (based on the earliest associated cruise leg''s start date) in MM/DD/YYYY HH24:MI:SS format';
COMMENT ON COLUMN CCD_CRUISE_AGG_V.CRUISE_END_DATE IS 'The end date in the corresponding time zone for the given cruise (based on the latest associated cruise leg''s end date)';
COMMENT ON COLUMN CCD_CRUISE_AGG_V.FORMAT_CRUISE_END_DATE IS 'The formatted end date in the corresponding time zone for the given cruise (based on the latest associated cruise leg''s end date) in MM/DD/YYYY HH24:MI:SS format';










--cruises and associated comma/semicolon delimited list of values
CREATE OR REPLACE VIEW

CCD_CRUISE_DELIM_V
AS

SELECT

CCD_CRUISE_AGG_V.CRUISE_ID,
CCD_CRUISE_AGG_V.CRUISE_NAME,
CCD_CRUISE_AGG_V.CRUISE_NOTES,
CCD_CRUISE_AGG_V.CRUISE_DESC,
CCD_CRUISE_AGG_V.OBJ_BASED_METRICS,
CCD_CRUISE_AGG_V.SCI_CENTER_DIV_ID,
CCD_CRUISE_AGG_V.SCI_CENTER_DIV_CODE,
CCD_CRUISE_AGG_V.SCI_CENTER_DIV_NAME,
CCD_CRUISE_AGG_V.SCI_CENTER_DIV_DESC,
CCD_CRUISE_AGG_V.SCI_CENTER_ID,
CCD_CRUISE_AGG_V.SCI_CENTER_NAME,
CCD_CRUISE_AGG_V.SCI_CENTER_DESC,
CCD_CRUISE_AGG_V.STD_SVY_NAME_ID,
CCD_CRUISE_AGG_V.STD_SVY_NAME,
CCD_CRUISE_AGG_V.STD_SVY_DESC,
CCD_CRUISE_AGG_V.SVY_FREQ_ID,
CCD_CRUISE_AGG_V.SVY_FREQ_NAME,
CCD_CRUISE_AGG_V.SVY_FREQ_DESC,
CCD_CRUISE_AGG_V.STD_SVY_NAME_OTH,
CCD_CRUISE_AGG_V.STD_SVY_NAME_VAL,
CCD_CRUISE_AGG_V.SVY_TYPE_ID,
CCD_CRUISE_AGG_V.SVY_TYPE_NAME,
CCD_CRUISE_AGG_V.SVY_TYPE_DESC,
CCD_CRUISE_AGG_V.CRUISE_URL,
CCD_CRUISE_AGG_V.CRUISE_CONT_EMAIL,
CCD_CRUISE_AGG_V.PTA_ISS_ID,
CCD_CRUISE_AGG_V.NUM_LEGS,
CCD_CRUISE_AGG_V.CRUISE_START_DATE,
CCD_CRUISE_AGG_V.FORMAT_CRUISE_START_DATE,
CCD_CRUISE_AGG_V.CRUISE_END_DATE,
CCD_CRUISE_AGG_V.FORMAT_CRUISE_END_DATE,
CCD_CRUISE_AGG_V.CRUISE_DAS,
CCD_CRUISE_AGG_V.CRUISE_LEN_DAYS,
CCD_CRUISE_AGG_V.CRUISE_YEAR,
CCD_CRUISE_AGG_V.CRUISE_FISC_YEAR,
CCD_CRUISE_AGG_V.LEG_NAME_CD_LIST,
CCD_CRUISE_AGG_V.LEG_NAME_SCD_LIST,
CCD_CRUISE_AGG_V.LEG_NAME_RC_LIST,
CCD_CRUISE_AGG_V.LEG_NAME_BR_LIST,
CCD_CRUISE_AGG_V.LEG_NAME_DATES_CD_LIST,
CCD_CRUISE_AGG_V.LEG_NAME_DATES_SCD_LIST,
CCD_CRUISE_AGG_V.LEG_NAME_DATES_RC_LIST,
CCD_CRUISE_AGG_V.LEG_NAME_DATES_BR_LIST,
CCD_CRUISE_AGG_V.LEG_VESS_NAME_DATES_CD_LIST,
CCD_CRUISE_AGG_V.LEG_VESS_NAME_DATES_SCD_LIST,
CCD_CRUISE_AGG_V.LEG_VESS_NAME_DATES_RC_LIST,
CCD_CRUISE_AGG_V.LEG_VESS_NAME_DATES_BR_LIST,




NVL(ESA_SPECIES_DELIM.NUM_SPP_ESA, 0) NUM_SPP_ESA,
ESA_SPECIES_DELIM.SPP_ESA_NAME_CD_LIST,
ESA_SPECIES_DELIM.SPP_ESA_NAME_SCD_LIST,
ESA_SPECIES_DELIM.SPP_ESA_NAME_RC_LIST,
ESA_SPECIES_DELIM.SPP_ESA_NAME_BR_LIST,


NVL(FSSI_SPECIES_DELIM.NUM_SPP_FSSI, 0) NUM_SPP_FSSI,
FSSI_SPECIES_DELIM.SPP_FSSI_NAME_CD_LIST,
FSSI_SPECIES_DELIM.SPP_FSSI_NAME_SCD_LIST,
FSSI_SPECIES_DELIM.SPP_FSSI_NAME_RC_LIST,
FSSI_SPECIES_DELIM.SPP_FSSI_NAME_BR_LIST,

NVL(MMPA_SPECIES_DELIM.NUM_SPP_MMPA, 0) NUM_SPP_MMPA,
MMPA_SPECIES_DELIM.SPP_MMPA_NAME_CD_LIST,
MMPA_SPECIES_DELIM.SPP_MMPA_NAME_SCD_LIST,
MMPA_SPECIES_DELIM.SPP_MMPA_NAME_RC_LIST,
MMPA_SPECIES_DELIM.SPP_MMPA_NAME_BR_LIST,

NVL(SVY_PRIM_CATS_DELIM.NUM_PRIM_SVY_CATS, 0) NUM_PRIM_SVY_CATS,
SVY_PRIM_CATS_DELIM.SVY_CAT_NAME_CD_LIST PRIM_SVY_CAT_NAME_CD_LIST,
SVY_PRIM_CATS_DELIM.SVY_CAT_NAME_SCD_LIST PRIM_SVY_CAT_NAME_SCD_LIST,
SVY_PRIM_CATS_DELIM.SVY_CAT_NAME_RC_LIST PRIM_SVY_CAT_NAME_RC_LIST,
SVY_PRIM_CATS_DELIM.SVY_CAT_NAME_BR_LIST PRIM_SVY_CAT_NAME_BR_LIST,

NVL(SVY_SEC_CATS_DELIM.NUM_SEC_SVY_CATS, 0) NUM_SEC_SVY_CATS,
SVY_SEC_CATS_DELIM.SVY_CAT_NAME_CD_LIST SEC_SVY_CAT_NAME_CD_LIST,
SVY_SEC_CATS_DELIM.SVY_CAT_NAME_SCD_LIST SEC_SVY_CAT_NAME_SCD_LIST,
SVY_SEC_CATS_DELIM.SVY_CAT_NAME_RC_LIST SEC_SVY_CAT_NAME_RC_LIST,
SVY_SEC_CATS_DELIM.SVY_CAT_NAME_BR_LIST SEC_SVY_CAT_NAME_BR_LIST,

NVL(EXP_SPECIES_DELIM.NUM_EXP_SPP, 0) NUM_EXP_SPP,
EXP_SPECIES_DELIM.EXP_SPP_NAME_CD_LIST,
EXP_SPECIES_DELIM.EXP_SPP_NAME_SCD_LIST,
EXP_SPECIES_DELIM.EXP_SPP_NAME_RC_LIST,
EXP_SPECIES_DELIM.EXP_SPP_NAME_BR_LIST,

NVL(OTH_SPECIES_DELIM.NUM_SPP_OTH, 0) NUM_SPP_OTH,
OTH_SPECIES_DELIM.OTH_SPP_CNAME_CD_LIST,
OTH_SPECIES_DELIM.OTH_SPP_CNAME_SCD_LIST,
OTH_SPECIES_DELIM.OTH_SPP_CNAME_RC_LIST,
OTH_SPECIES_DELIM.OTH_SPP_CNAME_BR_LIST,

OTH_SPECIES_DELIM.OTH_SPP_SNAME_CD_LIST,
OTH_SPECIES_DELIM.OTH_SPP_SNAME_SCD_LIST,
OTH_SPECIES_DELIM.OTH_SPP_SNAME_RC_LIST,
OTH_SPECIES_DELIM.OTH_SPP_SNAME_BR_LIST

FROM
CCD_CRUISE_AGG_V
LEFT JOIN
(SELECT CRUISE_ID,
count(*) NUM_SPP_ESA,
LISTAGG(TGT_SPP_ESA_NAME, ', ') WITHIN GROUP (ORDER BY UPPER(TGT_SPP_ESA_NAME)) as SPP_ESA_NAME_CD_LIST,
LISTAGG(TGT_SPP_ESA_NAME, '; ') WITHIN GROUP (ORDER BY UPPER(TGT_SPP_ESA_NAME)) as SPP_ESA_NAME_SCD_LIST,
LISTAGG(TGT_SPP_ESA_NAME, chr(10)) WITHIN GROUP (ORDER BY UPPER(TGT_SPP_ESA_NAME)) as SPP_ESA_NAME_RC_LIST,
LISTAGG(TGT_SPP_ESA_NAME, '<BR>') WITHIN GROUP (ORDER BY UPPER(TGT_SPP_ESA_NAME)) as SPP_ESA_NAME_BR_LIST

 FROM
 CCD_CRUISE_SPP_ESA
 INNER JOIN
 CCD_TGT_SPP_ESA
 ON CCD_CRUISE_SPP_ESA.TGT_SPP_ESA_ID = CCD_TGT_SPP_ESA.TGT_SPP_ESA_ID
 group by CCD_CRUISE_SPP_ESA.CRUISE_ID
) ESA_SPECIES_DELIM
ON CCD_CRUISE_AGG_V.CRUISE_ID = ESA_SPECIES_DELIM.CRUISE_ID

LEFT JOIN
(SELECT CRUISE_ID,
count(*) NUM_SPP_FSSI,
LISTAGG(TGT_SPP_FSSI_NAME, ', ') WITHIN GROUP (ORDER BY UPPER(TGT_SPP_FSSI_NAME)) as SPP_FSSI_NAME_CD_LIST,
LISTAGG(TGT_SPP_FSSI_NAME, '; ') WITHIN GROUP (ORDER BY UPPER(TGT_SPP_FSSI_NAME)) as SPP_FSSI_NAME_SCD_LIST,
LISTAGG(TGT_SPP_FSSI_NAME, chr(10)) WITHIN GROUP (ORDER BY UPPER(TGT_SPP_FSSI_NAME)) as SPP_FSSI_NAME_RC_LIST,
LISTAGG(TGT_SPP_FSSI_NAME, '<BR>') WITHIN GROUP (ORDER BY UPPER(TGT_SPP_FSSI_NAME)) as SPP_FSSI_NAME_BR_LIST


 FROM
 CCD_CRUISE_SPP_FSSI
 INNER JOIN
 CCD_TGT_SPP_FSSI
 ON CCD_CRUISE_SPP_FSSI.TGT_SPP_FSSI_ID = CCD_TGT_SPP_FSSI.TGT_SPP_FSSI_ID
 group by CCD_CRUISE_SPP_FSSI.CRUISE_ID
) FSSI_SPECIES_DELIM
ON CCD_CRUISE_AGG_V.CRUISE_ID = FSSI_SPECIES_DELIM.CRUISE_ID


LEFT JOIN
(SELECT CRUISE_ID,
count(*) NUM_SPP_MMPA,
LISTAGG(TGT_SPP_MMPA_NAME, ', ') WITHIN GROUP (ORDER BY UPPER(TGT_SPP_MMPA_NAME)) as SPP_MMPA_NAME_CD_LIST,
LISTAGG(TGT_SPP_MMPA_NAME, '; ') WITHIN GROUP (ORDER BY UPPER(TGT_SPP_MMPA_NAME)) as SPP_MMPA_NAME_SCD_LIST,
LISTAGG(TGT_SPP_MMPA_NAME, chr(10)) WITHIN GROUP (ORDER BY UPPER(TGT_SPP_MMPA_NAME)) as SPP_MMPA_NAME_RC_LIST,
LISTAGG(TGT_SPP_MMPA_NAME, '<BR>') WITHIN GROUP (ORDER BY UPPER(TGT_SPP_MMPA_NAME)) as SPP_MMPA_NAME_BR_LIST

 FROM
 CCD_CRUISE_SPP_MMPA
 INNER JOIN
 CCD_TGT_SPP_MMPA
 ON CCD_CRUISE_SPP_MMPA.TGT_SPP_MMPA_ID = CCD_TGT_SPP_MMPA.TGT_SPP_MMPA_ID
 group by CCD_CRUISE_SPP_MMPA.CRUISE_ID
) MMPA_SPECIES_DELIM
ON CCD_CRUISE_AGG_V.CRUISE_ID = MMPA_SPECIES_DELIM.CRUISE_ID


LEFT JOIN
(SELECT CRUISE_ID,
 count(*) NUM_PRIM_SVY_CATS,
 LISTAGG(SVY_CAT_NAME, ', ') WITHIN GROUP (ORDER BY UPPER(SVY_CAT_NAME)) as SVY_CAT_NAME_CD_LIST,
 LISTAGG(SVY_CAT_NAME, '; ') WITHIN GROUP (ORDER BY UPPER(SVY_CAT_NAME)) as SVY_CAT_NAME_SCD_LIST,
 LISTAGG(SVY_CAT_NAME, chr(10)) WITHIN GROUP (ORDER BY UPPER(SVY_CAT_NAME)) as SVY_CAT_NAME_RC_LIST,
 LISTAGG(SVY_CAT_NAME, '<BR>') WITHIN GROUP (ORDER BY UPPER(SVY_CAT_NAME)) as SVY_CAT_NAME_BR_LIST

 FROM
 CCD_CRUISE_SVY_CATS
 INNER JOIN
 CCD_SVY_CATS
 ON CCD_CRUISE_SVY_CATS.SVY_CAT_ID = CCD_SVY_CATS.SVY_CAT_ID
 WHERE CCD_CRUISE_SVY_CATS.PRIMARY_YN = 'Y'

 group by CCD_CRUISE_SVY_CATS.CRUISE_ID
) SVY_PRIM_CATS_DELIM
ON CCD_CRUISE_AGG_V.CRUISE_ID = SVY_PRIM_CATS_DELIM.CRUISE_ID


LEFT JOIN
(SELECT CRUISE_ID,
 count(*) NUM_SEC_SVY_CATS,
 LISTAGG(SVY_CAT_NAME, ', ') WITHIN GROUP (ORDER BY UPPER(SVY_CAT_NAME)) as SVY_CAT_NAME_CD_LIST,
 LISTAGG(SVY_CAT_NAME, '; ') WITHIN GROUP (ORDER BY UPPER(SVY_CAT_NAME)) as SVY_CAT_NAME_SCD_LIST,
 LISTAGG(SVY_CAT_NAME, chr(10)) WITHIN GROUP (ORDER BY UPPER(SVY_CAT_NAME)) as SVY_CAT_NAME_RC_LIST,
 LISTAGG(SVY_CAT_NAME, '<BR>') WITHIN GROUP (ORDER BY UPPER(SVY_CAT_NAME)) as SVY_CAT_NAME_BR_LIST

 FROM
 CCD_CRUISE_SVY_CATS
 INNER JOIN
 CCD_SVY_CATS
 ON CCD_CRUISE_SVY_CATS.SVY_CAT_ID = CCD_SVY_CATS.SVY_CAT_ID
 WHERE CCD_CRUISE_SVY_CATS.PRIMARY_YN = 'N'

 group by CCD_CRUISE_SVY_CATS.CRUISE_ID
) SVY_SEC_CATS_DELIM
ON CCD_CRUISE_AGG_V.CRUISE_ID = SVY_SEC_CATS_DELIM.CRUISE_ID


LEFT JOIN
(SELECT CRUISE_ID,
count(*) NUM_EXP_SPP,
LISTAGG(EXP_SPP_CAT_NAME, ', ') WITHIN GROUP (ORDER BY UPPER(EXP_SPP_CAT_NAME)) as EXP_SPP_NAME_CD_LIST,
LISTAGG(EXP_SPP_CAT_NAME, '; ') WITHIN GROUP (ORDER BY UPPER(EXP_SPP_CAT_NAME)) as EXP_SPP_NAME_SCD_LIST,
LISTAGG(EXP_SPP_CAT_NAME, chr(10)) WITHIN GROUP (ORDER BY UPPER(EXP_SPP_CAT_NAME)) as EXP_SPP_NAME_RC_LIST,
LISTAGG(EXP_SPP_CAT_NAME, '<BR>') WITHIN GROUP (ORDER BY UPPER(EXP_SPP_CAT_NAME)) as EXP_SPP_NAME_BR_LIST

 FROM
 CCD_CRUISE_EXP_SPP
 INNER JOIN
 CCD_EXP_SPP_CATS
 ON CCD_CRUISE_EXP_SPP.EXP_SPP_CAT_ID = CCD_EXP_SPP_CATS.EXP_SPP_CAT_ID
 group by CCD_CRUISE_EXP_SPP.CRUISE_ID
) EXP_SPECIES_DELIM
ON CCD_CRUISE_AGG_V.CRUISE_ID = EXP_SPECIES_DELIM.CRUISE_ID



LEFT JOIN
(SELECT CRUISE_ID,
count(*) NUM_SPP_OTH,
LISTAGG(TGT_SPP_OTHER_CNAME, ', ') WITHIN GROUP (ORDER BY UPPER(TGT_SPP_OTHER_CNAME)) as OTH_SPP_CNAME_CD_LIST,
LISTAGG(TGT_SPP_OTHER_CNAME, '; ') WITHIN GROUP (ORDER BY UPPER(TGT_SPP_OTHER_CNAME)) as OTH_SPP_CNAME_SCD_LIST,
LISTAGG(TGT_SPP_OTHER_CNAME, chr(10)) WITHIN GROUP (ORDER BY UPPER(TGT_SPP_OTHER_CNAME)) as OTH_SPP_CNAME_RC_LIST,
LISTAGG(TGT_SPP_OTHER_CNAME, '<BR>') WITHIN GROUP (ORDER BY UPPER(TGT_SPP_OTHER_CNAME)) as OTH_SPP_CNAME_BR_LIST,
LISTAGG(TGT_SPP_OTHER_SNAME, ', ') WITHIN GROUP (ORDER BY UPPER(TGT_SPP_OTHER_SNAME)) as OTH_SPP_SNAME_CD_LIST,
LISTAGG(TGT_SPP_OTHER_SNAME, '; ') WITHIN GROUP (ORDER BY UPPER(TGT_SPP_OTHER_SNAME)) as OTH_SPP_SNAME_SCD_LIST,
LISTAGG(TGT_SPP_OTHER_SNAME, chr(10)) WITHIN GROUP (ORDER BY UPPER(TGT_SPP_OTHER_SNAME)) as OTH_SPP_SNAME_RC_LIST,
LISTAGG(TGT_SPP_OTHER_SNAME, '<BR>') WITHIN GROUP (ORDER BY UPPER(TGT_SPP_OTHER_SNAME)) as OTH_SPP_SNAME_BR_LIST


 FROM
 CCD_TGT_SPP_OTHER
 group by CCD_TGT_SPP_OTHER.CRUISE_ID
) OTH_SPECIES_DELIM
ON CCD_CRUISE_AGG_V.CRUISE_ID = OTH_SPECIES_DELIM.CRUISE_ID



ORDER BY
SCI_CENTER_NAME,
STD_SVY_NAME,
CRUISE_NAME
;

COMMENT ON TABLE CCD_CRUISE_DELIM_V IS 'Research Cruises Delimited Reference Values (View)

This query returns all of the research cruises and their associated reference tables (e.g. Science Center, standard survey name, survey frequency, etc.) as well as the comma-/semicolon-delimited list of associated reference values (e.g. ESA species, primary survey categories, etc.)';








COMMENT ON COLUMN CCD_CRUISE_DELIM_V.CRUISE_ID IS 'Primary key for the CCD_CRUISES table';
COMMENT ON COLUMN CCD_CRUISE_DELIM_V.CRUISE_NAME IS 'The name of the given cruise designated by NOAA (e.g. SE-15-01)';
COMMENT ON COLUMN CCD_CRUISE_DELIM_V.CRUISE_NOTES IS 'Any notes for the given research cruise';



COMMENT ON COLUMN CCD_CRUISE_DELIM_V.CRUISE_DESC IS 'Description for the given research cruise';
COMMENT ON COLUMN CCD_CRUISE_DELIM_V.OBJ_BASED_METRICS IS 'Objective Based Metrics for the given research cruise';
COMMENT ON COLUMN CCD_CRUISE_DELIM_V.SCI_CENTER_DIV_ID IS 'Primary key for the Science Center Division table';
COMMENT ON COLUMN CCD_CRUISE_DELIM_V.SCI_CENTER_DIV_CODE IS 'Abbreviated code for the given Science Center Division';

COMMENT ON COLUMN CCD_CRUISE_DELIM_V.SCI_CENTER_DIV_NAME IS 'Name of the given Science Center Division';

COMMENT ON COLUMN CCD_CRUISE_DELIM_V.SCI_CENTER_DIV_DESC IS 'Description for the given Science Center Division';




COMMENT ON COLUMN CCD_CRUISE_DELIM_V.SCI_CENTER_ID IS 'Primary key for the Science Center table';
COMMENT ON COLUMN CCD_CRUISE_DELIM_V.SCI_CENTER_NAME IS 'Name of the given Science Center';
COMMENT ON COLUMN CCD_CRUISE_DELIM_V.SCI_CENTER_DESC IS 'Description for the given Science Center';
COMMENT ON COLUMN CCD_CRUISE_DELIM_V.STD_SVY_NAME_ID IS 'Primary key for the Standard Survey Name table';
COMMENT ON COLUMN CCD_CRUISE_DELIM_V.STD_SVY_NAME IS 'Name of the given Standard Survey Name';
COMMENT ON COLUMN CCD_CRUISE_DELIM_V.STD_SVY_DESC IS 'Description for the given Standard Survey Name';
COMMENT ON COLUMN CCD_CRUISE_DELIM_V.SVY_FREQ_ID IS 'Primary key for the Survey Frequency table';
COMMENT ON COLUMN CCD_CRUISE_DELIM_V.SVY_FREQ_NAME IS 'Name of the given Survey Frequency';
COMMENT ON COLUMN CCD_CRUISE_DELIM_V.SVY_FREQ_DESC IS 'Description for the given Survey Frequency';
COMMENT ON COLUMN CCD_CRUISE_DELIM_V.STD_SVY_NAME_OTH IS 'Field defines a Standard Survey Name that is not included in the Standard Survey Name table';
COMMENT ON COLUMN CCD_CRUISE_DELIM_V.STD_SVY_NAME_VAL IS 'This field contains the Standard Survey Name defined for the given cruise.	If the STD_SVY_NAME_ID field is defined then the associated CCD_STD_SVY_NAMES.STD_SVY_NAME is used because the foreign key is given precedence, otherwise the STD_SVY_NAME_OTH field value is used';


COMMENT ON COLUMN CCD_CRUISE_DELIM_V.SVY_TYPE_ID IS 'Primary key for the Survey Type table';
COMMENT ON COLUMN CCD_CRUISE_DELIM_V.SVY_TYPE_NAME IS 'Name of the given Survey Type';
COMMENT ON COLUMN CCD_CRUISE_DELIM_V.SVY_TYPE_DESC IS 'Description for the given Survey Type';


COMMENT ON COLUMN CCD_CRUISE_DELIM_V.CRUISE_URL IS 'The Cruise URL (Referred to as "Survey URL" in FINSS System) for the given Cruise';
COMMENT ON COLUMN CCD_CRUISE_DELIM_V.CRUISE_CONT_EMAIL IS 'The Cruise Contact Email (Referred to as "Survey Contact Email" in FINSS System) for the given Cruise';


COMMENT ON COLUMN CCD_CRUISE_DELIM_V.CRUISE_DAS IS 'The total number of days at sea for each of the legs associated with the given cruise';
COMMENT ON COLUMN CCD_CRUISE_DELIM_V.CRUISE_LEN_DAYS IS 'The total number of days between the Cruise Start and End Dates for the given cruise';


COMMENT ON COLUMN CCD_CRUISE_DELIM_V.CRUISE_YEAR IS 'The calendar year for the given cruise (based on the earliest associated cruise leg''s start date)';
COMMENT ON COLUMN CCD_CRUISE_DELIM_V.CRUISE_FISC_YEAR IS 'The calendar year for the given cruise (based on the earliest associated cruise leg''s start date)';
COMMENT ON COLUMN CCD_CRUISE_DELIM_V.NUM_LEGS IS 'The number of cruise legs associated with the given cruise';
COMMENT ON COLUMN CCD_CRUISE_DELIM_V.LEG_NAME_CD_LIST IS 'Comma-delimited list of leg names associated with the given cruise';
COMMENT ON COLUMN CCD_CRUISE_DELIM_V.LEG_NAME_SCD_LIST IS 'Semicolon-delimited list of leg names associated with the given cruise';
COMMENT ON COLUMN CCD_CRUISE_DELIM_V.LEG_NAME_RC_LIST IS 'Return carriage/new line delimited list of leg names associated with the given cruise';
COMMENT ON COLUMN CCD_CRUISE_DELIM_V.LEG_NAME_BR_LIST IS '<BR> tag (intended for web pages) delimited list of leg names associated with the given cruise';


COMMENT ON COLUMN CCD_CRUISE_DELIM_V.LEG_VESS_NAME_DATES_CD_LIST IS 'Comma-delimited list of leg names, the associated leg dates and vessel name associated with the given cruise';
COMMENT ON COLUMN CCD_CRUISE_DELIM_V.LEG_VESS_NAME_DATES_SCD_LIST IS 'Semicolon-delimited list of leg names, the associated leg dates and vessel name associated with the given cruise';
COMMENT ON COLUMN CCD_CRUISE_DELIM_V.LEG_VESS_NAME_DATES_RC_LIST IS 'Return carriage/new line delimited list of leg names, the associated leg dates and vessel name associated with the given cruise';
COMMENT ON COLUMN CCD_CRUISE_DELIM_V.LEG_VESS_NAME_DATES_BR_LIST IS '<BR> tag (intended for web pages) delimited list of leg names, the associated leg dates and vessel name associated with the given cruise';


COMMENT ON COLUMN CCD_CRUISE_DELIM_V.LEG_NAME_DATES_CD_LIST IS 'Comma-delimited list of leg names, the associated leg dates for the given cruise';
COMMENT ON COLUMN CCD_CRUISE_DELIM_V.LEG_NAME_DATES_SCD_LIST IS 'Semicolon-delimited list of leg names, the associated leg dates for the given cruise';
COMMENT ON COLUMN CCD_CRUISE_DELIM_V.LEG_NAME_DATES_RC_LIST IS 'Return carriage/new line delimited list of leg names, the associated leg dates for the given cruise';
COMMENT ON COLUMN CCD_CRUISE_DELIM_V.LEG_NAME_DATES_BR_LIST IS '<BR> tag (intended for web pages) delimited list of leg names, the associated leg dates for the given cruise';
COMMENT ON COLUMN CCD_CRUISE_DELIM_V.PTA_ISS_ID IS 'Foreign key reference to the Issues (PTA) intersection table';



COMMENT ON COLUMN CCD_CRUISE_DELIM_V.CRUISE_START_DATE IS 'The start date in the corresponding time zone for the given cruise (based on the earliest associated cruise leg''s start date)';
COMMENT ON COLUMN CCD_CRUISE_DELIM_V.FORMAT_CRUISE_START_DATE IS 'The formatted start date in the corresponding time zone for the given cruise (based on the earliest associated cruise leg''s start date) in MM/DD/YYYY HH24:MI:SS format';
COMMENT ON COLUMN CCD_CRUISE_DELIM_V.CRUISE_END_DATE IS 'The end date in the corresponding time zone for the given cruise (based on the latest associated cruise leg''s end date)';
COMMENT ON COLUMN CCD_CRUISE_DELIM_V.FORMAT_CRUISE_END_DATE IS 'The formatted end date in the corresponding time zone for the given cruise (based on the latest associated cruise leg''s end date) in MM/DD/YYYY HH24:MI:SS format';

















COMMENT ON COLUMN CCD_CRUISE_DELIM_V.NUM_SPP_ESA IS 'The number of associated ESA Species';

COMMENT ON COLUMN CCD_CRUISE_DELIM_V.SPP_ESA_NAME_CD_LIST IS 'Comma-delimited list of ESA Species associated with the given cruise';
COMMENT ON COLUMN CCD_CRUISE_DELIM_V.SPP_ESA_NAME_SCD_LIST IS 'Semicolon-delimited list of ESA Species associated with the given cruise';

COMMENT ON COLUMN CCD_CRUISE_DELIM_V.SPP_ESA_NAME_RC_LIST IS 'Return carriage/new line delimited list of ESA Species associated with the given cruise';
COMMENT ON COLUMN CCD_CRUISE_DELIM_V.SPP_ESA_NAME_BR_LIST IS '<BR> tag (intended for web pages) delimited list of ESA Species associated with the given cruise';


COMMENT ON COLUMN CCD_CRUISE_DELIM_V.NUM_SPP_FSSI IS 'The number of associated FSSI Species';

COMMENT ON COLUMN CCD_CRUISE_DELIM_V.SPP_FSSI_NAME_CD_LIST IS 'Comma-delimited list of FSSI Species associated with the given cruise';
COMMENT ON COLUMN CCD_CRUISE_DELIM_V.SPP_FSSI_NAME_SCD_LIST IS 'Semicolon-delimited list of FSSI Species associated with the given cruise';

COMMENT ON COLUMN CCD_CRUISE_DELIM_V.SPP_FSSI_NAME_RC_LIST IS 'Return carriage/new line delimited list of FSSI Species associated with the given cruise';
COMMENT ON COLUMN CCD_CRUISE_DELIM_V.SPP_FSSI_NAME_BR_LIST IS '<BR> tag (intended for web pages) delimited list of FSSI Species associated with the given cruise';



COMMENT ON COLUMN CCD_CRUISE_DELIM_V.NUM_SPP_MMPA IS 'The number of associated MMPA Species';
COMMENT ON COLUMN CCD_CRUISE_DELIM_V.SPP_MMPA_NAME_CD_LIST IS 'Comma-delimited list of MMPA Species associated with the given cruise';
COMMENT ON COLUMN CCD_CRUISE_DELIM_V.SPP_MMPA_NAME_SCD_LIST IS 'Semicolon-delimited list of MMPA Species associated with the given cruise';
COMMENT ON COLUMN CCD_CRUISE_DELIM_V.SPP_MMPA_NAME_RC_LIST IS 'Return carriage/new line delimited list of MMPA Species associated with the given cruise';
COMMENT ON COLUMN CCD_CRUISE_DELIM_V.SPP_MMPA_NAME_BR_LIST IS '<BR> tag (intended for web pages) delimited list of MMPA Species associated with the given cruise';



COMMENT ON COLUMN CCD_CRUISE_DELIM_V.NUM_PRIM_SVY_CATS IS 'The number of associated primary survey categories';
COMMENT ON COLUMN CCD_CRUISE_DELIM_V.PRIM_SVY_CAT_NAME_CD_LIST IS 'Comma-delimited list of primary survey categories associated with the given cruise';
COMMENT ON COLUMN CCD_CRUISE_DELIM_V.PRIM_SVY_CAT_NAME_SCD_LIST IS 'Semicolon-delimited list of primary survey categories associated with the given cruise';

COMMENT ON COLUMN CCD_CRUISE_DELIM_V.PRIM_SVY_CAT_NAME_RC_LIST IS 'Return carriage/new line delimited list of primary survey categories associated with the given cruise';
COMMENT ON COLUMN CCD_CRUISE_DELIM_V.PRIM_SVY_CAT_NAME_BR_LIST IS '<BR> tag (intended for web pages) delimited list of primary survey categories associated with the given cruise';


COMMENT ON COLUMN CCD_CRUISE_DELIM_V.NUM_SEC_SVY_CATS IS 'The number of associated secondary survey categories';
COMMENT ON COLUMN CCD_CRUISE_DELIM_V.SEC_SVY_CAT_NAME_CD_LIST IS 'Comma-delimited list of secondary survey categories associated with the given cruise';
COMMENT ON COLUMN CCD_CRUISE_DELIM_V.SEC_SVY_CAT_NAME_SCD_LIST IS 'Semicolon-delimited list of secondary survey categories associated with the given cruise';

COMMENT ON COLUMN CCD_CRUISE_DELIM_V.SEC_SVY_CAT_NAME_RC_LIST IS 'Return carriage/new line delimited list of secondary survey categories associated with the given cruise';
COMMENT ON COLUMN CCD_CRUISE_DELIM_V.SEC_SVY_CAT_NAME_BR_LIST IS '<BR> tag (intended for web pages) delimited list of secondary survey categories associated with the given cruise';



COMMENT ON COLUMN CCD_CRUISE_DELIM_V.NUM_EXP_SPP IS 'The number of associated expected species categories';
COMMENT ON COLUMN CCD_CRUISE_DELIM_V.EXP_SPP_NAME_CD_LIST IS 'Comma-delimited list of expected species categories associated with the given cruise';
COMMENT ON COLUMN CCD_CRUISE_DELIM_V.EXP_SPP_NAME_SCD_LIST IS 'Semicolon-delimited list of expected species categories associated with the given cruise';

COMMENT ON COLUMN CCD_CRUISE_DELIM_V.EXP_SPP_NAME_RC_LIST IS 'Return carriage/new line delimited list of expected species categories associated with the given cruise';
COMMENT ON COLUMN CCD_CRUISE_DELIM_V.EXP_SPP_NAME_BR_LIST IS '<BR> tag (intended for web pages) delimited list of expected species categories associated with the given cruise';



COMMENT ON COLUMN CCD_CRUISE_DELIM_V.NUM_SPP_OTH IS 'The number of associated target species - other';
COMMENT ON COLUMN CCD_CRUISE_DELIM_V.OTH_SPP_CNAME_CD_LIST IS 'Comma-delimited list of common names for target species - other associated with the given cruise';
COMMENT ON COLUMN CCD_CRUISE_DELIM_V.OTH_SPP_CNAME_SCD_LIST IS 'Semicolon-delimited list of common names for target species - other associated with the given cruise';

COMMENT ON COLUMN CCD_CRUISE_DELIM_V.OTH_SPP_CNAME_RC_LIST IS 'Return carriage/new line delimited list of common names for target species - other associated with the given cruise';
COMMENT ON COLUMN CCD_CRUISE_DELIM_V.OTH_SPP_CNAME_BR_LIST IS '<BR> tag (intended for web pages) delimited list of common names for target species - other associated with the given cruise';



COMMENT ON COLUMN CCD_CRUISE_DELIM_V.OTH_SPP_SNAME_CD_LIST IS 'Comma-delimited list of scientific names for target species - other associated with the given cruise';
COMMENT ON COLUMN CCD_CRUISE_DELIM_V.OTH_SPP_SNAME_SCD_LIST IS 'Semicolon-delimited list of scientific names for target species - other associated with the given cruise';


COMMENT ON COLUMN CCD_CRUISE_DELIM_V.OTH_SPP_SNAME_RC_LIST IS 'Return carriage/new line delimited list of scientific names for target species - other associated with the given cruise';
COMMENT ON COLUMN CCD_CRUISE_DELIM_V.OTH_SPP_SNAME_BR_LIST IS '<BR> tag (intended for web pages) delimited list of scientific names for target species - other associated with the given cruise';







DROP VIEW CCD_CRUISE_LEGS_V;



CREATE OR REPLACE VIEW
CCD_CRUISE_LEG_V
AS
SELECT
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
CCD_CRUISE_V.PTA_ISS_ID,
CCD_LEG_V.CRUISE_LEG_ID,
CCD_LEG_V.LEG_NAME,
CCD_LEG_V.LEG_START_DATE,
CCD_LEG_V.FORMAT_LEG_START_DATE,
CCD_LEG_V.LEG_END_DATE,
CCD_LEG_V.FORMAT_LEG_END_DATE,
CCD_LEG_V.LEG_DAS,
CCD_LEG_V.LEG_YEAR,
CCD_LEG_V.TZ_NAME,
CCD_LEG_V.LEG_FISC_YEAR,
CCD_LEG_V.LEG_DESC,
CCD_LEG_V.VESSEL_ID,
CCD_LEG_V.VESSEL_NAME,
CCD_LEG_V.VESSEL_DESC,
CCD_LEG_V.PLAT_TYPE_ID,
CCD_LEG_V.PLAT_TYPE_NAME,
CCD_LEG_V.PLAT_TYPE_DESC


FROM CCD_CRUISE_V
INNER JOIN
CCD_LEG_V ON
CCD_CRUISE_V.CRUISE_ID = CCD_LEG_V.CRUISE_ID
order by
CCD_LEG_V.LEG_START_DATE,
CCD_LEG_V.LEG_NAME,
CCD_LEG_V.VESSEL_NAME;


COMMENT ON TABLE CCD_CRUISE_LEG_V IS 'Research Cruises and Associated Cruise Legs (View)

This query returns all research cruise legs and their associated reference tables as well as all associated cruise legs with their associated reference tables';




COMMENT ON COLUMN CCD_CRUISE_LEG_V.CRUISE_ID IS 'Primary key for the CCD_CRUISES table';
COMMENT ON COLUMN CCD_CRUISE_LEG_V.CRUISE_NAME IS 'The name of the given cruise designated by NOAA (e.g. SE-15-01)';
COMMENT ON COLUMN CCD_CRUISE_LEG_V.CRUISE_NOTES IS 'Any notes for the given research cruise';
COMMENT ON COLUMN CCD_CRUISE_LEG_V.SCI_CENTER_ID IS 'Primary key for the Science Center table';
COMMENT ON COLUMN CCD_CRUISE_LEG_V.SCI_CENTER_NAME IS 'Name of the given Science Center';
COMMENT ON COLUMN CCD_CRUISE_LEG_V.SCI_CENTER_DESC IS 'Description for the given Science Center';
COMMENT ON COLUMN CCD_CRUISE_LEG_V.STD_SVY_NAME_ID IS 'Primary key for the Standard Survey Name table';
COMMENT ON COLUMN CCD_CRUISE_LEG_V.STD_SVY_NAME IS 'Name of the given Standard Survey Name';
COMMENT ON COLUMN CCD_CRUISE_LEG_V.STD_SVY_DESC IS 'Description for the given Standard Survey Name';
COMMENT ON COLUMN CCD_CRUISE_LEG_V.SVY_FREQ_ID IS 'Primary key for the Survey Frequency table';
COMMENT ON COLUMN CCD_CRUISE_LEG_V.SVY_FREQ_NAME IS 'Name of the given Survey Frequency';
COMMENT ON COLUMN CCD_CRUISE_LEG_V.SVY_FREQ_DESC IS 'Description for the given Survey Frequency';
COMMENT ON COLUMN CCD_CRUISE_LEG_V.STD_SVY_NAME_OTH IS 'Field defines a Standard Survey Name that is not included in the Standard Survey Name table';
COMMENT ON COLUMN CCD_CRUISE_LEG_V.STD_SVY_NAME_VAL IS 'This field contains the Standard Survey Name defined for the given cruise.	If the STD_SVY_NAME_ID field is defined then the associated CCD_STD_SVY_NAMES.STD_SVY_NAME is used because the foreign key is given precedence, otherwise the STD_SVY_NAME_OTH field value is used';


COMMENT ON COLUMN CCD_CRUISE_LEG_V.SVY_TYPE_ID IS 'Primary key for the Survey Type table';
COMMENT ON COLUMN CCD_CRUISE_LEG_V.SVY_TYPE_NAME IS 'Name of the given Survey Type';
COMMENT ON COLUMN CCD_CRUISE_LEG_V.SVY_TYPE_DESC IS 'Description for the given Survey Type';


COMMENT ON COLUMN CCD_CRUISE_LEG_V.CRUISE_URL IS 'The Cruise URL (Referred to as "Survey URL" in FINSS System) for the given Cruise';
COMMENT ON COLUMN CCD_CRUISE_LEG_V.CRUISE_CONT_EMAIL IS 'The Cruise Contact Email (Referred to as "Survey Contact Email" in FINSS System) for the given Cruise';


COMMENT ON COLUMN CCD_CRUISE_LEG_V.CRUISE_LEG_ID IS 'Primary key for the CCD_CRUISE_LEGS table';
COMMENT ON COLUMN CCD_CRUISE_LEG_V.LEG_NAME IS 'The name of the given cruise leg';

COMMENT ON COLUMN CCD_CRUISE_LEG_V.LEG_START_DATE IS 'The start date in the corresponding time zone for the given research cruise leg';
COMMENT ON COLUMN CCD_CRUISE_LEG_V.FORMAT_LEG_START_DATE IS 'The start date in the corresponding time zone for the given research cruise leg in MM/DD/YYYY format';

COMMENT ON COLUMN CCD_CRUISE_LEG_V.LEG_END_DATE IS 'The end date in the corresponding time zone for the given research cruise leg';

COMMENT ON COLUMN CCD_CRUISE_LEG_V.FORMAT_LEG_END_DATE IS 'The end date in the corresponding time zone for the given research cruise leg in MM/DD/YYYY format';

COMMENT ON COLUMN CCD_CRUISE_LEG_V.LEG_DAS IS 'The number of days at sea for the given research cruise leg';
COMMENT ON COLUMN CCD_CRUISE_LEG_V.LEG_YEAR IS 'The calendar year for the start date of the given research cruise leg';
COMMENT ON COLUMN CCD_CRUISE_LEG_V.LEG_FISC_YEAR IS 'The NOAA fiscal year for the start date of the given research cruise leg';
COMMENT ON COLUMN CCD_CRUISE_LEG_V.LEG_DESC IS 'The description for the given research cruise leg';
COMMENT ON COLUMN CCD_CRUISE_LEG_V.TZ_NAME IS 'The numeric offset for UTC or Time Zone Name (V$TIMEZONE_NAMES.TZNAME) for the local timezone where the cruise leg occurred (e.g. US/Hawaii, US/Samoa, Etc/GMT+9)';

COMMENT ON COLUMN CCD_CRUISE_LEG_V.VESSEL_ID IS 'Foreign key reference to the CCD_VESSELS table for the cruise leg''s vessel';
COMMENT ON COLUMN CCD_CRUISE_LEG_V.VESSEL_NAME IS 'Name of the given research vessel';
COMMENT ON COLUMN CCD_CRUISE_LEG_V.VESSEL_DESC IS 'Description for the given research vessel';
COMMENT ON COLUMN CCD_CRUISE_LEG_V.PLAT_TYPE_ID IS 'Platform Type for the given research cruise leg';
COMMENT ON COLUMN CCD_CRUISE_LEG_V.PLAT_TYPE_NAME IS 'Name of the given Platform Type';
COMMENT ON COLUMN CCD_CRUISE_LEG_V.PLAT_TYPE_DESC IS 'Description for the given Platform Type';

COMMENT ON COLUMN CCD_CRUISE_LEG_V.CRUISE_DESC IS 'Description for the given research cruise';
COMMENT ON COLUMN CCD_CRUISE_LEG_V.OBJ_BASED_METRICS IS 'Objective Based Metrics for the given research cruise';
COMMENT ON COLUMN CCD_CRUISE_LEG_V.SCI_CENTER_DIV_ID IS 'Primary key for the Science Center Division table';
COMMENT ON COLUMN CCD_CRUISE_LEG_V.SCI_CENTER_DIV_CODE IS 'Abbreviated code for the given Science Center Division';

COMMENT ON COLUMN CCD_CRUISE_LEG_V.SCI_CENTER_DIV_NAME IS 'Name of the given Science Center Division';

COMMENT ON COLUMN CCD_CRUISE_LEG_V.SCI_CENTER_DIV_DESC IS 'Description for the given Science Center Division';
COMMENT ON COLUMN CCD_CRUISE_LEG_V.PTA_ISS_ID IS 'Foreign key reference to the Issues (PTA) intersection table';



--this view includes the aggregated leg information at the cruise level
CREATE OR REPLACE VIEW
CCD_CRUISE_LEG_AGG_V
AS
SELECT
CCD_CRUISE_LEG_V.CRUISE_ID,
CCD_CRUISE_LEG_V.CRUISE_NAME,
CCD_CRUISE_LEG_V.CRUISE_NOTES,
CCD_CRUISE_LEG_V.CRUISE_DESC,
CCD_CRUISE_LEG_V.OBJ_BASED_METRICS,
CCD_CRUISE_LEG_V.SCI_CENTER_DIV_ID,
CCD_CRUISE_LEG_V.SCI_CENTER_DIV_CODE,
CCD_CRUISE_LEG_V.SCI_CENTER_DIV_NAME,
CCD_CRUISE_LEG_V.SCI_CENTER_DIV_DESC,
CCD_CRUISE_LEG_V.SCI_CENTER_ID,
CCD_CRUISE_LEG_V.SCI_CENTER_NAME,
CCD_CRUISE_LEG_V.SCI_CENTER_DESC,
CCD_CRUISE_LEG_V.STD_SVY_NAME_ID,
CCD_CRUISE_LEG_V.STD_SVY_NAME,
CCD_CRUISE_LEG_V.STD_SVY_DESC,
CCD_CRUISE_LEG_V.SVY_FREQ_ID,
CCD_CRUISE_LEG_V.SVY_FREQ_NAME,
CCD_CRUISE_LEG_V.SVY_FREQ_DESC,
CCD_CRUISE_LEG_V.STD_SVY_NAME_OTH,
CCD_CRUISE_LEG_V.STD_SVY_NAME_VAL,
CCD_CRUISE_LEG_V.SVY_TYPE_ID,
CCD_CRUISE_LEG_V.SVY_TYPE_NAME,
CCD_CRUISE_LEG_V.SVY_TYPE_DESC,
CCD_CRUISE_LEG_V.CRUISE_URL,
CCD_CRUISE_LEG_V.CRUISE_CONT_EMAIL,
CCD_CRUISE_LEG_V.PTA_ISS_ID,
CCD_CRUISE_LEG_V.CRUISE_LEG_ID,
CCD_CRUISE_LEG_V.LEG_NAME,
CCD_CRUISE_LEG_V.LEG_START_DATE,
CCD_CRUISE_LEG_V.FORMAT_LEG_START_DATE,
CCD_CRUISE_LEG_V.LEG_END_DATE,
CCD_CRUISE_LEG_V.FORMAT_LEG_END_DATE,
CCD_CRUISE_LEG_V.LEG_DAS,
CCD_CRUISE_LEG_V.LEG_YEAR,
CCD_CRUISE_LEG_V.TZ_NAME,
CCD_CRUISE_LEG_V.LEG_FISC_YEAR,
CCD_CRUISE_LEG_V.LEG_DESC,
CCD_CRUISE_LEG_V.VESSEL_ID,
CCD_CRUISE_LEG_V.VESSEL_NAME,
CCD_CRUISE_LEG_V.VESSEL_DESC,
CCD_CRUISE_LEG_V.PLAT_TYPE_ID,
CCD_CRUISE_LEG_V.PLAT_TYPE_NAME,
CCD_CRUISE_LEG_V.PLAT_TYPE_DESC,
CCD_LEG_AGG_V.NUM_LEGS,
CCD_LEG_AGG_V.CRUISE_START_DATE,
CCD_LEG_AGG_V.FORMAT_CRUISE_START_DATE,
CCD_LEG_AGG_V.CRUISE_END_DATE,
CCD_LEG_AGG_V.FORMAT_CRUISE_END_DATE,
CCD_LEG_AGG_V.CRUISE_DAS,
CCD_LEG_AGG_V.CRUISE_LEN_DAYS,
CCD_LEG_AGG_V.CRUISE_YEAR,
CCD_LEG_AGG_V.CRUISE_FISC_YEAR,
CCD_LEG_AGG_V.LEG_NAME_CD_LIST,
CCD_LEG_AGG_V.LEG_NAME_SCD_LIST,
CCD_LEG_AGG_V.LEG_NAME_RC_LIST,
CCD_LEG_AGG_V.LEG_NAME_BR_LIST,
CCD_LEG_AGG_V.LEG_NAME_DATES_CD_LIST,
CCD_LEG_AGG_V.LEG_NAME_DATES_SCD_LIST,
CCD_LEG_AGG_V.LEG_NAME_DATES_RC_LIST,
CCD_LEG_AGG_V.LEG_NAME_DATES_BR_LIST,
CCD_LEG_AGG_V.LEG_VESS_NAME_DATES_CD_LIST,
CCD_LEG_AGG_V.LEG_VESS_NAME_DATES_SCD_LIST,
CCD_LEG_AGG_V.LEG_VESS_NAME_DATES_RC_LIST,
CCD_LEG_AGG_V.LEG_VESS_NAME_DATES_BR_LIST


FROM CCD_CRUISE_LEG_V
INNER JOIN
CCD_LEG_AGG_V ON
CCD_CRUISE_LEG_V.CRUISE_ID = CCD_LEG_AGG_V.CRUISE_ID
order by
CCD_CRUISE_LEG_V.LEG_START_DATE,
CCD_CRUISE_LEG_V.LEG_NAME,
CCD_CRUISE_LEG_V.VESSEL_NAME;



COMMENT ON COLUMN CCD_CRUISE_LEG_AGG_V.CRUISE_ID IS 'Primary key for the CCD_CRUISES table';
COMMENT ON COLUMN CCD_CRUISE_LEG_AGG_V.CRUISE_NAME IS 'The name of the given cruise designated by NOAA (e.g. SE-15-01)';
COMMENT ON COLUMN CCD_CRUISE_LEG_AGG_V.CRUISE_NOTES IS 'Any notes for the given research cruise';
COMMENT ON COLUMN CCD_CRUISE_LEG_AGG_V.SCI_CENTER_ID IS 'Primary key for the Science Center table';
COMMENT ON COLUMN CCD_CRUISE_LEG_AGG_V.SCI_CENTER_NAME IS 'Name of the given Science Center';
COMMENT ON COLUMN CCD_CRUISE_LEG_AGG_V.SCI_CENTER_DESC IS 'Description for the given Science Center';
COMMENT ON COLUMN CCD_CRUISE_LEG_AGG_V.STD_SVY_NAME_ID IS 'Primary key for the Standard Survey Name table';
COMMENT ON COLUMN CCD_CRUISE_LEG_AGG_V.STD_SVY_NAME IS 'Name of the given Standard Survey Name';
COMMENT ON COLUMN CCD_CRUISE_LEG_AGG_V.STD_SVY_DESC IS 'Description for the given Standard Survey Name';
COMMENT ON COLUMN CCD_CRUISE_LEG_AGG_V.SVY_FREQ_ID IS 'Primary key for the Survey Frequency table';
COMMENT ON COLUMN CCD_CRUISE_LEG_AGG_V.SVY_FREQ_NAME IS 'Name of the given Survey Frequency';
COMMENT ON COLUMN CCD_CRUISE_LEG_AGG_V.SVY_FREQ_DESC IS 'Description for the given Survey Frequency';
COMMENT ON COLUMN CCD_CRUISE_LEG_AGG_V.STD_SVY_NAME_OTH IS 'Field defines a Standard Survey Name that is not included in the Standard Survey Name table';
COMMENT ON COLUMN CCD_CRUISE_LEG_AGG_V.STD_SVY_NAME_VAL IS 'This field contains the Standard Survey Name defined for the given cruise.	If the STD_SVY_NAME_ID field is defined then the associated CCD_STD_SVY_NAMES.STD_SVY_NAME is used because the foreign key is given precedence, otherwise the STD_SVY_NAME_OTH field value is used';


COMMENT ON COLUMN CCD_CRUISE_LEG_AGG_V.SVY_TYPE_ID IS 'Primary key for the Survey Type table';
COMMENT ON COLUMN CCD_CRUISE_LEG_AGG_V.SVY_TYPE_NAME IS 'Name of the given Survey Type';
COMMENT ON COLUMN CCD_CRUISE_LEG_AGG_V.SVY_TYPE_DESC IS 'Description for the given Survey Type';


COMMENT ON COLUMN CCD_CRUISE_LEG_AGG_V.CRUISE_URL IS 'The Cruise URL (Referred to as "Survey URL" in FINSS System) for the given Cruise';
COMMENT ON COLUMN CCD_CRUISE_LEG_AGG_V.CRUISE_CONT_EMAIL IS 'The Cruise Contact Email (Referred to as "Survey Contact Email" in FINSS System) for the given Cruise';


COMMENT ON COLUMN CCD_CRUISE_LEG_AGG_V.CRUISE_LEG_ID IS 'Primary key for the CCD_CRUISE_LEGS table';
COMMENT ON COLUMN CCD_CRUISE_LEG_AGG_V.LEG_NAME IS 'The name of the given cruise leg';

COMMENT ON COLUMN CCD_CRUISE_LEG_AGG_V.LEG_START_DATE IS 'The start date in the corresponding time zone for the given research cruise leg';
COMMENT ON COLUMN CCD_CRUISE_LEG_AGG_V.FORMAT_LEG_START_DATE IS 'The start date in the corresponding time zone for the given research cruise leg in MM/DD/YYYY format';

COMMENT ON COLUMN CCD_CRUISE_LEG_AGG_V.LEG_END_DATE IS 'The end date in the corresponding time zone for the given research cruise leg';

COMMENT ON COLUMN CCD_CRUISE_LEG_AGG_V.FORMAT_LEG_END_DATE IS 'The end date in the corresponding time zone for the given research cruise leg in MM/DD/YYYY format';

COMMENT ON COLUMN CCD_CRUISE_LEG_AGG_V.LEG_DAS IS 'The number of days at sea for the given research cruise leg';
COMMENT ON COLUMN CCD_CRUISE_LEG_AGG_V.LEG_YEAR IS 'The calendar year for the start date of the given research cruise leg';
COMMENT ON COLUMN CCD_CRUISE_LEG_AGG_V.LEG_FISC_YEAR IS 'The NOAA fiscal year for the start date of the given research cruise leg';
COMMENT ON COLUMN CCD_CRUISE_LEG_AGG_V.LEG_DESC IS 'The description for the given research cruise leg';
COMMENT ON COLUMN CCD_CRUISE_LEG_AGG_V.TZ_NAME IS 'The numeric offset for UTC or Time Zone Name (V$TIMEZONE_NAMES.TZNAME) for the local timezone where the cruise leg occurred (e.g. US/Hawaii, US/Samoa, Etc/GMT+9)';

COMMENT ON COLUMN CCD_CRUISE_LEG_AGG_V.VESSEL_ID IS 'Foreign key reference to the CCD_VESSELS table for the cruise leg''s vessel';
COMMENT ON COLUMN CCD_CRUISE_LEG_AGG_V.VESSEL_NAME IS 'Name of the given research vessel';
COMMENT ON COLUMN CCD_CRUISE_LEG_AGG_V.VESSEL_DESC IS 'Description for the given research vessel';
COMMENT ON COLUMN CCD_CRUISE_LEG_AGG_V.PLAT_TYPE_ID IS 'Platform Type for the given research cruise leg';
COMMENT ON COLUMN CCD_CRUISE_LEG_AGG_V.PLAT_TYPE_NAME IS 'Name of the given Platform Type';
COMMENT ON COLUMN CCD_CRUISE_LEG_AGG_V.PLAT_TYPE_DESC IS 'Description for the given Platform Type';


COMMENT ON COLUMN CCD_CRUISE_LEG_AGG_V.CRUISE_START_DATE IS 'The start date in the corresponding time zone for the given cruise (based on the earliest associated cruise leg''s start date)';
COMMENT ON COLUMN CCD_CRUISE_LEG_AGG_V.FORMAT_CRUISE_START_DATE IS 'The formatted start date in the corresponding time zone for the given cruise (based on the earliest associated cruise leg''s start date) in MM/DD/YYYY HH24:MI:SS format';
COMMENT ON COLUMN CCD_CRUISE_LEG_AGG_V.CRUISE_END_DATE IS 'The end date in the corresponding time zone for the given cruise (based on the latest associated cruise leg''s end date)';
COMMENT ON COLUMN CCD_CRUISE_LEG_AGG_V.FORMAT_CRUISE_END_DATE IS 'The formatted end date in the corresponding time zone for the given cruise (based on the latest associated cruise leg''s end date) in MM/DD/YYYY HH24:MI:SS format';
COMMENT ON COLUMN CCD_CRUISE_LEG_AGG_V.CRUISE_DAS IS 'The total number of days at sea for each of the legs associated with the given cruise';


COMMENT ON COLUMN CCD_CRUISE_LEG_AGG_V.CRUISE_YEAR IS 'The calendar year for the given cruise (based on the earliest associated cruise leg''s start date)';
COMMENT ON COLUMN CCD_CRUISE_LEG_AGG_V.CRUISE_FISC_YEAR IS 'The calendar year for the given cruise (based on the earliest associated cruise leg''s start date)';
COMMENT ON COLUMN CCD_CRUISE_LEG_AGG_V.NUM_LEGS IS 'The number of cruise legs associated with the given cruise';
COMMENT ON COLUMN CCD_CRUISE_LEG_AGG_V.LEG_NAME_CD_LIST IS 'Comma-delimited list of leg names associated with the given cruise';
COMMENT ON COLUMN CCD_CRUISE_LEG_AGG_V.LEG_NAME_SCD_LIST IS 'Semicolon-delimited list of leg names associated with the given cruise';
COMMENT ON COLUMN CCD_CRUISE_LEG_AGG_V.LEG_NAME_RC_LIST IS 'Return carriage/new line delimited list of leg names associated with the given cruise';
COMMENT ON COLUMN CCD_CRUISE_LEG_AGG_V.LEG_NAME_BR_LIST IS '<BR> tag (intended for web pages) delimited list of leg names associated with the given cruise';


COMMENT ON COLUMN CCD_CRUISE_LEG_AGG_V.LEG_VESS_NAME_DATES_CD_LIST IS 'Comma-delimited list of leg names, the associated leg dates and vessel name associated with the given cruise';
COMMENT ON COLUMN CCD_CRUISE_LEG_AGG_V.LEG_VESS_NAME_DATES_SCD_LIST IS 'Semicolon-delimited list of leg names, the associated leg dates and vessel name associated with the given cruise';
COMMENT ON COLUMN CCD_CRUISE_LEG_AGG_V.LEG_VESS_NAME_DATES_RC_LIST IS 'Return carriage/new line delimited list of leg names, the associated leg dates and vessel name associated with the given cruise';
COMMENT ON COLUMN CCD_CRUISE_LEG_AGG_V.LEG_VESS_NAME_DATES_BR_LIST IS '<BR> tag (intended for web pages) delimited list of leg names, the associated leg dates and vessel name associated with the given cruise';


COMMENT ON COLUMN CCD_CRUISE_LEG_AGG_V.LEG_NAME_DATES_CD_LIST IS 'Comma-delimited list of leg names, the associated leg dates for the given cruise';
COMMENT ON COLUMN CCD_CRUISE_LEG_AGG_V.LEG_NAME_DATES_SCD_LIST IS 'Semicolon-delimited list of leg names, the associated leg dates for the given cruise';
COMMENT ON COLUMN CCD_CRUISE_LEG_AGG_V.LEG_NAME_DATES_RC_LIST IS 'Return carriage/new line delimited list of leg names, the associated leg dates for the given cruise';
COMMENT ON COLUMN CCD_CRUISE_LEG_AGG_V.LEG_NAME_DATES_BR_LIST IS '<BR> tag (intended for web pages) delimited list of leg names, the associated leg dates for the given cruise';
COMMENT ON COLUMN CCD_CRUISE_LEG_AGG_V.PTA_ISS_ID IS 'Foreign key reference to the Issues (PTA) intersection table';
COMMENT ON COLUMN CCD_CRUISE_LEG_AGG_V.CRUISE_LEN_DAYS IS 'The total number of days between the Cruise Start and End Dates for the given cruise';

COMMENT ON COLUMN CCD_CRUISE_LEG_AGG_V.CRUISE_DESC IS 'Description for the given research cruise';
COMMENT ON COLUMN CCD_CRUISE_LEG_AGG_V.OBJ_BASED_METRICS IS 'Objective Based Metrics for the given research cruise';
COMMENT ON COLUMN CCD_CRUISE_LEG_AGG_V.SCI_CENTER_DIV_ID IS 'Primary key for the Science Center Division table';
COMMENT ON COLUMN CCD_CRUISE_LEG_AGG_V.SCI_CENTER_DIV_CODE IS 'Abbreviated code for the given Science Center Division';

COMMENT ON COLUMN CCD_CRUISE_LEG_AGG_V.SCI_CENTER_DIV_NAME IS 'Name of the given Science Center Division';

COMMENT ON COLUMN CCD_CRUISE_LEG_AGG_V.SCI_CENTER_DIV_DESC IS 'Description for the given Science Center Division';



COMMENT ON TABLE CCD_CRUISE_LEG_AGG_V IS 'Research Cruises and Associated Cruise Legs Aggregate Information (View)

This query returns all research cruise legs and their associated reference tables as well as all associated cruise legs with their associated reference tables and aggregate information from cruise legs';









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

COMMENT ON COLUMN CCD_LEG_DELIM_V.TZ_NAME IS 'The numeric offset for UTC or Time Zone Name (V$TIMEZONE_NAMES.TZNAME) for the local timezone where the cruise leg occurred (e.g. US/Hawaii, US/Samoa, Etc/GMT+9)';

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










CREATE OR REPLACE VIEW
CCD_CRUISE_LEG_DELIM_V
AS
SELECT
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
CCD_CRUISE_DELIM_V.LEG_VESS_NAME_DATES_CD_LIST,
CCD_CRUISE_DELIM_V.LEG_VESS_NAME_DATES_SCD_LIST,
CCD_CRUISE_DELIM_V.LEG_VESS_NAME_DATES_RC_LIST,
CCD_CRUISE_DELIM_V.LEG_VESS_NAME_DATES_BR_LIST,
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
CCD_LEG_DELIM_V.TZ_NAME,
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


FROM CCD_CRUISE_DELIM_V
INNER JOIN CCD_LEG_DELIM_V
ON
CCD_CRUISE_DELIM_V.CRUISE_ID = CCD_LEG_DELIM_V.CRUISE_ID

ORDER BY
CCD_CRUISE_DELIM_V.CRUISE_START_DATE,
CCD_LEG_DELIM_V.LEG_START_DATE,
CCD_LEG_DELIM_V.LEG_NAME,
CCD_LEG_DELIM_V.VESSEL_NAME
;



COMMENT ON TABLE CCD_CRUISE_LEG_DELIM_V IS 'Research Cruise and Cruise Legs Delimited Reference Values (View)

This query returns all of the research cruise and associated cruise legs and their associated reference tables (e.g. Vessel, Platform Type, etc.) as well as the comma-/semicolon-delimited list of associated reference values (e.g. regional ecosystems, gear, regions, leg aliases, ESA target species, etc.)';



















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
COMMENT ON COLUMN CCD_CRUISE_LEG_DELIM_V.STD_SVY_NAME_VAL IS 'This field contains the Standard Survey Name defined for the given cruise.	If the STD_SVY_NAME_ID field is defined then the associated CCD_STD_SVY_NAMES.STD_SVY_NAME is used because the foreign key is given precedence, otherwise the STD_SVY_NAME_OTH field value is used';


COMMENT ON COLUMN CCD_CRUISE_LEG_DELIM_V.SVY_TYPE_ID IS 'Primary key for the Survey Type table';
COMMENT ON COLUMN CCD_CRUISE_LEG_DELIM_V.SVY_TYPE_NAME IS 'Name of the given Survey Type';
COMMENT ON COLUMN CCD_CRUISE_LEG_DELIM_V.SVY_TYPE_DESC IS 'Description for the given Survey Type';


COMMENT ON COLUMN CCD_CRUISE_LEG_DELIM_V.CRUISE_URL IS 'The Cruise URL (Referred to as "Survey URL" in FINSS System) for the given Cruise';
COMMENT ON COLUMN CCD_CRUISE_LEG_DELIM_V.CRUISE_CONT_EMAIL IS 'The Cruise Contact Email (Referred to as "Survey Contact Email" in FINSS System) for the given Cruise';


COMMENT ON COLUMN CCD_CRUISE_LEG_DELIM_V.CRUISE_DAS IS 'The total number of days at sea for each of the legs associated with the given cruise';
COMMENT ON COLUMN CCD_CRUISE_LEG_DELIM_V.CRUISE_LEN_DAYS IS 'The total number of days between the Cruise Start and End Dates for the given cruise';


COMMENT ON COLUMN CCD_CRUISE_LEG_DELIM_V.CRUISE_YEAR IS 'The calendar year for the given cruise (based on the earliest associated cruise leg''s start date)';
COMMENT ON COLUMN CCD_CRUISE_LEG_DELIM_V.CRUISE_FISC_YEAR IS 'The calendar year for the given cruise (based on the earliest associated cruise leg''s start date)';
COMMENT ON COLUMN CCD_CRUISE_LEG_DELIM_V.NUM_LEGS IS 'The number of cruise legs associated with the given cruise';
COMMENT ON COLUMN CCD_CRUISE_LEG_DELIM_V.LEG_NAME_CD_LIST IS 'Comma-delimited list of leg names associated with the given cruise';
COMMENT ON COLUMN CCD_CRUISE_LEG_DELIM_V.LEG_NAME_SCD_LIST IS 'Semicolon-delimited list of leg names associated with the given cruise';
COMMENT ON COLUMN CCD_CRUISE_LEG_DELIM_V.LEG_NAME_RC_LIST IS 'Return carriage/new line delimited list of leg names associated with the given cruise';
COMMENT ON COLUMN CCD_CRUISE_LEG_DELIM_V.LEG_NAME_BR_LIST IS '<BR> tag (intended for web pages) delimited list of leg names associated with the given cruise';


COMMENT ON COLUMN CCD_CRUISE_LEG_DELIM_V.LEG_VESS_NAME_DATES_CD_LIST IS 'Comma-delimited list of leg names, the associated leg dates and vessel name associated with the given cruise';
COMMENT ON COLUMN CCD_CRUISE_LEG_DELIM_V.LEG_VESS_NAME_DATES_SCD_LIST IS 'Semicolon-delimited list of leg names, the associated leg dates and vessel name associated with the given cruise';
COMMENT ON COLUMN CCD_CRUISE_LEG_DELIM_V.LEG_VESS_NAME_DATES_RC_LIST IS 'Return carriage/new line delimited list of leg names, the associated leg dates and vessel name associated with the given cruise';
COMMENT ON COLUMN CCD_CRUISE_LEG_DELIM_V.LEG_VESS_NAME_DATES_BR_LIST IS '<BR> tag (intended for web pages) delimited list of leg names, the associated leg dates and vessel name associated with the given cruise';


COMMENT ON COLUMN CCD_CRUISE_LEG_DELIM_V.LEG_NAME_DATES_CD_LIST IS 'Comma-delimited list of leg names, the associated leg dates for the given cruise';
COMMENT ON COLUMN CCD_CRUISE_LEG_DELIM_V.LEG_NAME_DATES_SCD_LIST IS 'Semicolon-delimited list of leg names, the associated leg dates for the given cruise';
COMMENT ON COLUMN CCD_CRUISE_LEG_DELIM_V.LEG_NAME_DATES_RC_LIST IS 'Return carriage/new line delimited list of leg names, the associated leg dates for the given cruise';
COMMENT ON COLUMN CCD_CRUISE_LEG_DELIM_V.LEG_NAME_DATES_BR_LIST IS '<BR> tag (intended for web pages) delimited list of leg names, the associated leg dates for the given cruise';
COMMENT ON COLUMN CCD_CRUISE_LEG_DELIM_V.PTA_ISS_ID IS 'Foreign key reference to the Issues (PTA) intersection table';



COMMENT ON COLUMN CCD_CRUISE_LEG_DELIM_V.CRUISE_START_DATE IS 'The start date in the corresponding time zone for the given cruise (based on the earliest associated cruise leg''s start date)';
COMMENT ON COLUMN CCD_CRUISE_LEG_DELIM_V.FORMAT_CRUISE_START_DATE IS 'The formatted start date in the corresponding time zone for the given cruise (based on the earliest associated cruise leg''s start date) in MM/DD/YYYY HH24:MI:SS format';
COMMENT ON COLUMN CCD_CRUISE_LEG_DELIM_V.CRUISE_END_DATE IS 'The end date in the corresponding time zone for the given cruise (based on the latest associated cruise leg''s end date)';
COMMENT ON COLUMN CCD_CRUISE_LEG_DELIM_V.FORMAT_CRUISE_END_DATE IS 'The formatted end date in the corresponding time zone for the given cruise (based on the latest associated cruise leg''s end date) in MM/DD/YYYY HH24:MI:SS format';

















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
















COMMENT ON COLUMN CCD_CRUISE_LEG_DELIM_V.CRUISE_LEG_ID IS 'Primary key for the CCD_CRUISE_LEGS table';
COMMENT ON COLUMN CCD_CRUISE_LEG_DELIM_V.LEG_NAME IS 'The name of the given cruise leg';



COMMENT ON COLUMN CCD_CRUISE_LEG_DELIM_V.LEG_START_DATE IS 'The start date in the corresponding time zone for the given research cruise leg';
COMMENT ON COLUMN CCD_CRUISE_LEG_DELIM_V.FORMAT_LEG_START_DATE IS 'The start date in the corresponding time zone for the given research cruise leg in MM/DD/YYYY format';

COMMENT ON COLUMN CCD_CRUISE_LEG_DELIM_V.LEG_END_DATE IS 'The end date in the corresponding time zone for the given research cruise leg';

COMMENT ON COLUMN CCD_CRUISE_LEG_DELIM_V.FORMAT_LEG_END_DATE IS 'The end date in the corresponding time zone for the given research cruise leg in MM/DD/YYYY format';

COMMENT ON COLUMN CCD_CRUISE_LEG_DELIM_V.LEG_DAS IS 'The number of days at sea for the given research cruise leg';

COMMENT ON COLUMN CCD_CRUISE_LEG_DELIM_V.LEG_YEAR IS 'The calendar year for the start date of the given research cruise leg';
COMMENT ON COLUMN CCD_CRUISE_LEG_DELIM_V.LEG_FISC_YEAR IS 'The NOAA fiscal year for the start date of the given research cruise leg';
COMMENT ON COLUMN CCD_CRUISE_LEG_DELIM_V.LEG_DESC IS 'The description for the given research cruise leg';

COMMENT ON COLUMN CCD_CRUISE_LEG_DELIM_V.TZ_NAME IS 'The numeric offset for UTC or Time Zone Name (V$TIMEZONE_NAMES.TZNAME) for the local timezone where the cruise leg occurred (e.g. US/Hawaii, US/Samoa, Etc/GMT+9)';

COMMENT ON COLUMN CCD_CRUISE_LEG_DELIM_V.CRUISE_ID IS 'The cruise for the given research cruise leg';


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
































CREATE OR REPLACE VIEW CCD_CRUISE_SUMM_V
AS
SELECT


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
CCD_CRUISE_DELIM_V.LEG_VESS_NAME_DATES_CD_LIST,
CCD_CRUISE_DELIM_V.LEG_VESS_NAME_DATES_SCD_LIST,
CCD_CRUISE_DELIM_V.LEG_VESS_NAME_DATES_RC_LIST,
CCD_CRUISE_DELIM_V.LEG_VESS_NAME_DATES_BR_LIST,
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






NVL(CRUISE_REGIONS.NUM_REGIONS, 0) NUM_REGIONS,
CRUISE_REGIONS.REGION_CODE_CD_LIST,
CRUISE_REGIONS.REGION_CODE_SCD_LIST,
CRUISE_REGIONS.REGION_CODE_RC_LIST,
CRUISE_REGIONS.REGION_CODE_BR_LIST,

CRUISE_REGIONS.REGION_NAME_CD_LIST,
CRUISE_REGIONS.REGION_NAME_SCD_LIST,
CRUISE_REGIONS.REGION_NAME_RC_LIST,
CRUISE_REGIONS.REGION_NAME_BR_LIST,


NVL(CRUISE_ECOSYSTEMS.NUM_ECOSYSTEMS, 0) NUM_ECOSYSTEMS,
CRUISE_ECOSYSTEMS.ECOSYSTEM_CD_LIST,
CRUISE_ECOSYSTEMS.ECOSYSTEM_SCD_LIST,
CRUISE_ECOSYSTEMS.ECOSYSTEM_RC_LIST,
CRUISE_ECOSYSTEMS.ECOSYSTEM_BR_LIST,

NVL(CRUISE_GEARS.NUM_GEAR, 0) NUM_GEAR,
CRUISE_GEARS.GEAR_CD_LIST,
CRUISE_GEARS.GEAR_SCD_LIST,
CRUISE_GEARS.GEAR_RC_LIST,
CRUISE_GEARS.GEAR_BR_LIST,


NVL(CRUISE_DATA_SETS.NUM_DATA_SETS, 0) NUM_DATA_SETS,
CRUISE_DATA_SETS.DATA_SET_CD_LIST,
CRUISE_DATA_SETS.DATA_SET_SCD_LIST,
CRUISE_DATA_SETS.DATA_SET_RC_LIST,
CRUISE_DATA_SETS.DATA_SET_BR_LIST


FROM
CCD_CRUISE_DELIM_V



--retrieve the unique region codes/names for all associated cruise legs:
left join
(SELECT
CRUISE_ID,
LISTAGG(DIST_CRUISE_REGIONS.REGION_CODE, ', ') WITHIN GROUP (ORDER BY UPPER(DIST_CRUISE_REGIONS.REGION_CODE)) as REGION_CODE_CD_LIST,
LISTAGG(DIST_CRUISE_REGIONS.REGION_CODE, '; ') WITHIN GROUP (ORDER BY UPPER(DIST_CRUISE_REGIONS.REGION_CODE)) as REGION_CODE_SCD_LIST,
LISTAGG(DIST_CRUISE_REGIONS.REGION_CODE, chr(10)) WITHIN GROUP (ORDER BY UPPER(DIST_CRUISE_REGIONS.REGION_CODE)) as REGION_CODE_RC_LIST,
LISTAGG(DIST_CRUISE_REGIONS.REGION_CODE, '<BR>') WITHIN GROUP (ORDER BY UPPER(DIST_CRUISE_REGIONS.REGION_CODE)) as REGION_CODE_BR_LIST,
LISTAGG(DIST_CRUISE_REGIONS.REGION_NAME, ', ') WITHIN GROUP (ORDER BY UPPER(DIST_CRUISE_REGIONS.REGION_NAME)) as REGION_NAME_CD_LIST,
LISTAGG(DIST_CRUISE_REGIONS.REGION_NAME, '; ') WITHIN GROUP (ORDER BY UPPER(DIST_CRUISE_REGIONS.REGION_NAME)) as REGION_NAME_SCD_LIST,
LISTAGG(DIST_CRUISE_REGIONS.REGION_NAME, chr(10)) WITHIN GROUP (ORDER BY UPPER(DIST_CRUISE_REGIONS.REGION_NAME)) as REGION_NAME_RC_LIST,
LISTAGG(DIST_CRUISE_REGIONS.REGION_NAME, '<BR>') WITHIN GROUP (ORDER BY UPPER(DIST_CRUISE_REGIONS.REGION_NAME)) as REGION_NAME_BR_LIST,
NVL(count(*), 0) NUM_REGIONS

FROM

(SELECT
DISTINCT
CCD_CRUISE_LEGS.cruise_id,
CCD_LEG_REGIONS_V.REGION_NAME,
CCD_LEG_REGIONS_V.REGION_CODE
from
CCD_CRUISE_LEGS
INNER JOIN
CCD_LEG_REGIONS_V
ON CCD_CRUISE_LEGS.CRUISE_LEG_ID = CCD_LEG_REGIONS_V.CRUISE_LEG_ID) DIST_CRUISE_REGIONS
group by DIST_CRUISE_REGIONS.cruise_id) CRUISE_REGIONS
on CRUISE_REGIONS.cruise_id = CCD_CRUISE_DELIM_V.cruise_id



--retrieve the unique regional ecosystems for all associated cruise legs:
left join
(SELECT
CRUISE_ID,
LISTAGG(DIST_REG_ECOSYSTEMS.REG_ECOSYSTEM_NAME, ', ') WITHIN GROUP (ORDER BY UPPER(DIST_REG_ECOSYSTEMS.REG_ECOSYSTEM_NAME)) as ECOSYSTEM_CD_LIST,
LISTAGG(DIST_REG_ECOSYSTEMS.REG_ECOSYSTEM_NAME, '; ') WITHIN GROUP (ORDER BY UPPER(DIST_REG_ECOSYSTEMS.REG_ECOSYSTEM_NAME)) as ECOSYSTEM_SCD_LIST,
LISTAGG(DIST_REG_ECOSYSTEMS.REG_ECOSYSTEM_NAME, chr(10)) WITHIN GROUP (ORDER BY UPPER(DIST_REG_ECOSYSTEMS.REG_ECOSYSTEM_NAME)) as ECOSYSTEM_RC_LIST,
LISTAGG(DIST_REG_ECOSYSTEMS.REG_ECOSYSTEM_NAME, '<BR>') WITHIN GROUP (ORDER BY UPPER(DIST_REG_ECOSYSTEMS.REG_ECOSYSTEM_NAME)) as ECOSYSTEM_BR_LIST,
NVL(count(*), 0) NUM_ECOSYSTEMS

FROM

(SELECT
DISTINCT
CCD_CRUISE_LEGS.cruise_id,
CCD_LEG_ECOSYSTEMS_V.REG_ECOSYSTEM_NAME
from
CCD_CRUISE_LEGS
INNER JOIN CCD_LEG_ECOSYSTEMS_V

ON CCD_CRUISE_LEGS.CRUISE_LEG_ID = CCD_LEG_ECOSYSTEMS_V.CRUISE_LEG_ID
) DIST_REG_ECOSYSTEMS
group by DIST_REG_ECOSYSTEMS.cruise_id) CRUISE_ECOSYSTEMS
on CRUISE_ECOSYSTEMS.cruise_id = CCD_CRUISE_DELIM_V.cruise_id


--retrieve the unique regional ecosystems for all associated cruise legs:
left join
(SELECT
CRUISE_ID,
LISTAGG(DIST_LEG_GEARS.GEAR_NAME, ', ') WITHIN GROUP (ORDER BY UPPER(DIST_LEG_GEARS.GEAR_NAME)) as GEAR_CD_LIST,
LISTAGG(DIST_LEG_GEARS.GEAR_NAME, '; ') WITHIN GROUP (ORDER BY UPPER(DIST_LEG_GEARS.GEAR_NAME)) as GEAR_SCD_LIST,
LISTAGG(DIST_LEG_GEARS.GEAR_NAME, chr(10)) WITHIN GROUP (ORDER BY UPPER(DIST_LEG_GEARS.GEAR_NAME)) as GEAR_RC_LIST,
LISTAGG(DIST_LEG_GEARS.GEAR_NAME, '<BR>') WITHIN GROUP (ORDER BY UPPER(DIST_LEG_GEARS.GEAR_NAME)) as GEAR_BR_LIST,
NVL(count(*), 0) NUM_GEAR

FROM

(SELECT
DISTINCT
CCD_CRUISE_LEGS.cruise_id,
CCD_LEG_GEAR_V.GEAR_NAME
from
CCD_CRUISE_LEGS
INNER JOIN CCD_LEG_GEAR_V
ON CCD_CRUISE_LEGS.CRUISE_LEG_ID = CCD_LEG_GEAR_V.CRUISE_LEG_ID) DIST_LEG_GEARS
group by DIST_LEG_GEARS.cruise_id) CRUISE_GEARS
on CRUISE_GEARS.cruise_id = CCD_CRUISE_DELIM_V.cruise_id

left join
(SELECT
CRUISE_ID,
LISTAGG(DIST_LEG_DATA_SETS.DATA_SET_NAME, ', ') WITHIN GROUP (ORDER BY UPPER(DIST_LEG_DATA_SETS.DATA_SET_NAME)) as DATA_SET_CD_LIST,
LISTAGG(DIST_LEG_DATA_SETS.DATA_SET_NAME, '; ') WITHIN GROUP (ORDER BY UPPER(DIST_LEG_DATA_SETS.DATA_SET_NAME)) as DATA_SET_SCD_LIST,
LISTAGG(DIST_LEG_DATA_SETS.DATA_SET_NAME, chr(10)) WITHIN GROUP (ORDER BY UPPER(DIST_LEG_DATA_SETS.DATA_SET_NAME)) as DATA_SET_RC_LIST,
LISTAGG(DIST_LEG_DATA_SETS.DATA_SET_NAME, '<BR>') WITHIN GROUP (ORDER BY UPPER(DIST_LEG_DATA_SETS.DATA_SET_NAME)) as DATA_SET_BR_LIST,
NVL(count(*), 0) NUM_DATA_SETS

FROM

(SELECT
DISTINCT
CCD_CRUISE_LEGS.cruise_id,
CCD_LEG_DATA_SETS_V.DATA_SET_NAME
from
CCD_CRUISE_LEGS
INNER JOIN CCD_LEG_DATA_SETS_V
ON CCD_CRUISE_LEGS.CRUISE_LEG_ID = CCD_LEG_DATA_SETS_V.CRUISE_LEG_ID) DIST_LEG_DATA_SETS
group by DIST_LEG_DATA_SETS.cruise_id) CRUISE_DATA_SETS
on CRUISE_DATA_SETS.cruise_id = CCD_CRUISE_DELIM_V.cruise_id
order by
CCD_CRUISE_DELIM_V.CRUISE_START_DATE,
CCD_CRUISE_DELIM_V.CRUISE_NAME
;




COMMENT ON TABLE CCD_CRUISE_SUMM_V IS 'Research Cruise Leg Summary (View)

This query returns all of the research cruises and all associated delimited lists of associated reference values.	The aggregate cruise leg information is included as start and end dates and the number of legs defined for the given cruise (if any) as well as all associated delimited unique list of associated reference values for all related cruise legs (regional ecosystems, gear, regions, data sets, etc.)';


COMMENT ON COLUMN CCD_CRUISE_SUMM_V.CRUISE_ID IS 'Primary key for the CCD_CRUISES table';
COMMENT ON COLUMN CCD_CRUISE_SUMM_V.CRUISE_NAME IS 'The name of the given cruise designated by NOAA (e.g. SE-15-01)';
COMMENT ON COLUMN CCD_CRUISE_SUMM_V.CRUISE_NOTES IS 'Any notes for the given research cruise';



COMMENT ON COLUMN CCD_CRUISE_SUMM_V.CRUISE_DESC IS 'Description for the given research cruise';
COMMENT ON COLUMN CCD_CRUISE_SUMM_V.OBJ_BASED_METRICS IS 'Objective Based Metrics for the given research cruise';
COMMENT ON COLUMN CCD_CRUISE_SUMM_V.SCI_CENTER_DIV_ID IS 'Primary key for the Science Center Division table';
COMMENT ON COLUMN CCD_CRUISE_SUMM_V.SCI_CENTER_DIV_CODE IS 'Abbreviated code for the given Science Center Division';

COMMENT ON COLUMN CCD_CRUISE_SUMM_V.SCI_CENTER_DIV_NAME IS 'Name of the given Science Center Division';

COMMENT ON COLUMN CCD_CRUISE_SUMM_V.SCI_CENTER_DIV_DESC IS 'Description for the given Science Center Division';


COMMENT ON COLUMN CCD_CRUISE_SUMM_V.SCI_CENTER_ID IS 'Primary key for the Science Center table';
COMMENT ON COLUMN CCD_CRUISE_SUMM_V.SCI_CENTER_NAME IS 'Name of the given Science Center';
COMMENT ON COLUMN CCD_CRUISE_SUMM_V.SCI_CENTER_DESC IS 'Description for the given Science Center';
COMMENT ON COLUMN CCD_CRUISE_SUMM_V.STD_SVY_NAME_ID IS 'Primary key for the Standard Survey Name table';
COMMENT ON COLUMN CCD_CRUISE_SUMM_V.STD_SVY_NAME IS 'Name of the given Standard Survey Name';
COMMENT ON COLUMN CCD_CRUISE_SUMM_V.STD_SVY_DESC IS 'Description for the given Standard Survey Name';
COMMENT ON COLUMN CCD_CRUISE_SUMM_V.SVY_FREQ_ID IS 'Primary key for the Survey Frequency table';
COMMENT ON COLUMN CCD_CRUISE_SUMM_V.SVY_FREQ_NAME IS 'Name of the given Survey Frequency';
COMMENT ON COLUMN CCD_CRUISE_SUMM_V.SVY_FREQ_DESC IS 'Description for the given Survey Frequency';
COMMENT ON COLUMN CCD_CRUISE_SUMM_V.STD_SVY_NAME_OTH IS 'Field defines a Standard Survey Name that is not included in the Standard Survey Name table';
COMMENT ON COLUMN CCD_CRUISE_SUMM_V.STD_SVY_NAME_VAL IS 'This field contains the Standard Survey Name defined for the given cruise.	If the STD_SVY_NAME_ID field is defined then the associated CCD_STD_SVY_NAMES.STD_SVY_NAME is used because the foreign key is given precedence, otherwise the STD_SVY_NAME_OTH field value is used';


COMMENT ON COLUMN CCD_CRUISE_SUMM_V.SVY_TYPE_ID IS 'Primary key for the Survey Type table';
COMMENT ON COLUMN CCD_CRUISE_SUMM_V.SVY_TYPE_NAME IS 'Name of the given Survey Type';
COMMENT ON COLUMN CCD_CRUISE_SUMM_V.SVY_TYPE_DESC IS 'Description for the given Survey Type';


COMMENT ON COLUMN CCD_CRUISE_SUMM_V.CRUISE_URL IS 'The Cruise URL (Referred to as "Survey URL" in FINSS System) for the given Cruise';
COMMENT ON COLUMN CCD_CRUISE_SUMM_V.CRUISE_CONT_EMAIL IS 'The Cruise Contact Email (Referred to as "Survey Contact Email" in FINSS System) for the given Cruise';
COMMENT ON COLUMN CCD_CRUISE_SUMM_V.PTA_ISS_ID IS 'Foreign key reference to the Validation Issues (PTA) intersection table';



COMMENT ON COLUMN CCD_CRUISE_SUMM_V.NUM_SPP_ESA IS 'The number of associated ESA Species';
COMMENT ON COLUMN CCD_CRUISE_SUMM_V.SPP_ESA_NAME_CD_LIST IS 'Comma-delimited list of ESA Species associated with the given cruise';
COMMENT ON COLUMN CCD_CRUISE_SUMM_V.SPP_ESA_NAME_SCD_LIST IS 'Semicolon-delimited list of ESA Species associated with the given cruise';
COMMENT ON COLUMN CCD_CRUISE_SUMM_V.SPP_ESA_NAME_RC_LIST IS 'Return carriage/new line delimited list of ESA Species associated with the given cruise';
COMMENT ON COLUMN CCD_CRUISE_SUMM_V.SPP_ESA_NAME_BR_LIST IS '<BR> tag (intended for web pages) delimited list of ESA Species associated with the given cruise';



COMMENT ON COLUMN CCD_CRUISE_SUMM_V.NUM_SPP_FSSI IS 'The number of associated FSSI Species';
COMMENT ON COLUMN CCD_CRUISE_SUMM_V.SPP_FSSI_NAME_CD_LIST IS 'Comma-delimited list of FSSI Species associated with the given cruise';
COMMENT ON COLUMN CCD_CRUISE_SUMM_V.SPP_FSSI_NAME_SCD_LIST IS 'Semicolon-delimited list of FSSI Species associated with the given cruise';
COMMENT ON COLUMN CCD_CRUISE_SUMM_V.SPP_FSSI_NAME_RC_LIST IS 'Return carriage/new line delimited list of FSSI Species associated with the given cruise';
COMMENT ON COLUMN CCD_CRUISE_SUMM_V.SPP_FSSI_NAME_BR_LIST IS '<BR> tag (intended for web pages) delimited list of FSSI Species associated with the given cruise';


COMMENT ON COLUMN CCD_CRUISE_SUMM_V.NUM_SPP_MMPA IS 'The number of associated MMPA Species';
COMMENT ON COLUMN CCD_CRUISE_SUMM_V.SPP_MMPA_NAME_CD_LIST IS 'Comma-delimited list of MMPA Species associated with the given cruise';
COMMENT ON COLUMN CCD_CRUISE_SUMM_V.SPP_MMPA_NAME_SCD_LIST IS 'Semicolon-delimited list of MMPA Species associated with the given cruise';
COMMENT ON COLUMN CCD_CRUISE_SUMM_V.SPP_MMPA_NAME_RC_LIST IS 'Return carriage/new line delimited list of MMPA Species associated with the given cruise';
COMMENT ON COLUMN CCD_CRUISE_SUMM_V.SPP_MMPA_NAME_BR_LIST IS '<BR> tag (intended for web pages) delimited list of MMPA Species associated with the given cruise';

COMMENT ON COLUMN CCD_CRUISE_SUMM_V.NUM_PRIM_SVY_CATS IS 'The number of associated primary survey categories';
COMMENT ON COLUMN CCD_CRUISE_SUMM_V.PRIM_SVY_CAT_NAME_CD_LIST IS 'Comma-delimited list of primary survey categories associated with the given cruise';
COMMENT ON COLUMN CCD_CRUISE_SUMM_V.PRIM_SVY_CAT_NAME_SCD_LIST IS 'Semicolon-delimited list of primary survey categories associated with the given cruise';
COMMENT ON COLUMN CCD_CRUISE_SUMM_V.PRIM_SVY_CAT_NAME_RC_LIST IS 'Return carriage/new line delimited list of primary survey categories associated with the given cruise';
COMMENT ON COLUMN CCD_CRUISE_SUMM_V.PRIM_SVY_CAT_NAME_BR_LIST IS '<BR> tag (intended for web pages) delimited list of primary survey categories associated with the given cruise';

COMMENT ON COLUMN CCD_CRUISE_SUMM_V.NUM_SEC_SVY_CATS IS 'The number of associated secondary survey categories';
COMMENT ON COLUMN CCD_CRUISE_SUMM_V.SEC_SVY_CAT_NAME_CD_LIST IS 'Comma-delimited list of secondary survey categories associated with the given cruise';
COMMENT ON COLUMN CCD_CRUISE_SUMM_V.SEC_SVY_CAT_NAME_SCD_LIST IS 'Semicolon-delimited list of secondary survey categories associated with the given cruise';
COMMENT ON COLUMN CCD_CRUISE_SUMM_V.SEC_SVY_CAT_NAME_RC_LIST IS 'Return carriage/new line delimited list of secondary survey categories associated with the given cruise';
COMMENT ON COLUMN CCD_CRUISE_SUMM_V.SEC_SVY_CAT_NAME_BR_LIST IS '<BR> tag (intended for web pages) delimited list of secondary survey categories associated with the given cruise';

COMMENT ON COLUMN CCD_CRUISE_SUMM_V.NUM_EXP_SPP IS 'The number of associated expected species categories';
COMMENT ON COLUMN CCD_CRUISE_SUMM_V.EXP_SPP_NAME_CD_LIST IS 'Comma-delimited list of expected species categories associated with the given cruise';
COMMENT ON COLUMN CCD_CRUISE_SUMM_V.EXP_SPP_NAME_SCD_LIST IS 'Semicolon-delimited list of expected species categories associated with the given cruise';
COMMENT ON COLUMN CCD_CRUISE_SUMM_V.EXP_SPP_NAME_RC_LIST IS 'Return carriage/new line delimited list of expected species categories associated with the given cruise';
COMMENT ON COLUMN CCD_CRUISE_SUMM_V.EXP_SPP_NAME_BR_LIST IS '<BR> tag (intended for web pages) delimited list of expected species categories associated with the given cruise';

COMMENT ON COLUMN CCD_CRUISE_SUMM_V.NUM_SPP_OTH IS 'The number of associated target species - other';
COMMENT ON COLUMN CCD_CRUISE_SUMM_V.OTH_SPP_CNAME_CD_LIST IS 'Comma-delimited list of common names for target species - other associated with the given cruise';
COMMENT ON COLUMN CCD_CRUISE_SUMM_V.OTH_SPP_CNAME_SCD_LIST IS 'Semicolon-delimited list of common names for target species - other associated with the given cruise';
COMMENT ON COLUMN CCD_CRUISE_SUMM_V.OTH_SPP_CNAME_RC_LIST IS 'Return carriage/new line delimited list of common names for target species - other associated with the given cruise';
COMMENT ON COLUMN CCD_CRUISE_SUMM_V.OTH_SPP_CNAME_BR_LIST IS '<BR> tag (intended for web pages) delimited list of common names for target species - other associated with the given cruise';


COMMENT ON COLUMN CCD_CRUISE_SUMM_V.OTH_SPP_SNAME_CD_LIST IS 'Comma-delimited list of scientific names for target species - other associated with the given cruise';
COMMENT ON COLUMN CCD_CRUISE_SUMM_V.OTH_SPP_SNAME_SCD_LIST IS 'Semicolon-delimited list of scientific names for target species - other associated with the given cruise';
COMMENT ON COLUMN CCD_CRUISE_SUMM_V.OTH_SPP_SNAME_RC_LIST IS 'Return carriage/new line delimited list of scientific names for target species - other associated with the given cruise';
COMMENT ON COLUMN CCD_CRUISE_SUMM_V.OTH_SPP_SNAME_BR_LIST IS '<BR> tag (intended for web pages) delimited list of scientific names for target species - other associated with the given cruise';




COMMENT ON COLUMN CCD_CRUISE_SUMM_V.CRUISE_DAS IS 'The total number of days at sea for each of the legs associated with the given cruise';
COMMENT ON COLUMN CCD_CRUISE_SUMM_V.CRUISE_LEN_DAYS IS 'The total number of days between the Cruise Start and End Dates for the given cruise';

COMMENT ON COLUMN CCD_CRUISE_SUMM_V.CRUISE_YEAR IS 'The calendar year for the given cruise (based on the earliest associated cruise leg''s start date)';
COMMENT ON COLUMN CCD_CRUISE_SUMM_V.CRUISE_FISC_YEAR IS 'The calendar year for the given cruise (based on the earliest associated cruise leg''s start date)';
COMMENT ON COLUMN CCD_CRUISE_SUMM_V.NUM_LEGS IS 'The number of cruise legs associated with the given cruise';
COMMENT ON COLUMN CCD_CRUISE_SUMM_V.LEG_NAME_CD_LIST IS 'Comma-delimited list of leg names associated with the given cruise';
COMMENT ON COLUMN CCD_CRUISE_SUMM_V.LEG_NAME_SCD_LIST IS 'Semicolon-delimited list of leg names associated with the given cruise';
COMMENT ON COLUMN CCD_CRUISE_SUMM_V.LEG_NAME_RC_LIST IS 'Return carriage/new line delimited list of leg names associated with the given cruise';
COMMENT ON COLUMN CCD_CRUISE_SUMM_V.LEG_NAME_BR_LIST IS '<BR> tag (intended for web pages) delimited list of leg names associated with the given cruise';


COMMENT ON COLUMN CCD_CRUISE_SUMM_V.LEG_VESS_NAME_DATES_CD_LIST IS 'Comma-delimited list of leg names, the associated leg dates and vessel name associated with the given cruise';
COMMENT ON COLUMN CCD_CRUISE_SUMM_V.LEG_VESS_NAME_DATES_SCD_LIST IS 'Semicolon-delimited list of leg names, the associated leg dates and vessel name associated with the given cruise';
COMMENT ON COLUMN CCD_CRUISE_SUMM_V.LEG_VESS_NAME_DATES_RC_LIST IS 'Return carriage/new line delimited list of leg names, the associated leg dates and vessel name associated with the given cruise';
COMMENT ON COLUMN CCD_CRUISE_SUMM_V.LEG_VESS_NAME_DATES_BR_LIST IS '<BR> tag (intended for web pages) delimited list of leg names, the associated leg dates and vessel name associated with the given cruise';


COMMENT ON COLUMN CCD_CRUISE_SUMM_V.LEG_NAME_DATES_CD_LIST IS 'Comma-delimited list of leg names, the associated leg dates for the given cruise';
COMMENT ON COLUMN CCD_CRUISE_SUMM_V.LEG_NAME_DATES_SCD_LIST IS 'Semicolon-delimited list of leg names, the associated leg dates for the given cruise';
COMMENT ON COLUMN CCD_CRUISE_SUMM_V.LEG_NAME_DATES_RC_LIST IS 'Return carriage/new line delimited list of leg names, the associated leg dates for the given cruise';
COMMENT ON COLUMN CCD_CRUISE_SUMM_V.LEG_NAME_DATES_BR_LIST IS '<BR> tag (intended for web pages) delimited list of leg names, the associated leg dates for the given cruise';


COMMENT ON COLUMN CCD_CRUISE_SUMM_V.NUM_REGIONS IS 'The number of unique regions associated with the associated cruise legs';
COMMENT ON COLUMN CCD_CRUISE_SUMM_V.REGION_CODE_CD_LIST IS 'Comma-delimited list of unique region codes associated with the given cruise leg';
COMMENT ON COLUMN CCD_CRUISE_SUMM_V.REGION_CODE_SCD_LIST IS 'Semicolon-delimited list of unique region codes associated with the given cruise leg';
COMMENT ON COLUMN CCD_CRUISE_SUMM_V.REGION_CODE_RC_LIST IS 'Return carriage/new line delimited list of unique region codes associated with the given cruise leg';
COMMENT ON COLUMN CCD_CRUISE_SUMM_V.REGION_CODE_BR_LIST IS '<BR> tag (intended for web pages) delimited list of unique region codes associated with the given cruise leg';


COMMENT ON COLUMN CCD_CRUISE_SUMM_V.REGION_NAME_CD_LIST IS 'Comma-delimited list of unique region names associated with the given cruise leg';
COMMENT ON COLUMN CCD_CRUISE_SUMM_V.REGION_NAME_SCD_LIST IS 'Semicolon-delimited list of unique region names associated with the given cruise leg';
COMMENT ON COLUMN CCD_CRUISE_SUMM_V.REGION_NAME_RC_LIST IS 'Return carriage/new line delimited list of unique region names associated with the given cruise leg';
COMMENT ON COLUMN CCD_CRUISE_SUMM_V.REGION_NAME_BR_LIST IS '<BR> tag (intended for web pages) delimited list of unique region names associated with the given cruise leg';


COMMENT ON COLUMN CCD_CRUISE_SUMM_V.NUM_ECOSYSTEMS IS 'The number of unique regional ecosystems associated with the associated cruise legs';
COMMENT ON COLUMN CCD_CRUISE_SUMM_V.ECOSYSTEM_CD_LIST IS 'Comma-delimited list of unique regional ecosystems associated with the given cruise leg';
COMMENT ON COLUMN CCD_CRUISE_SUMM_V.ECOSYSTEM_SCD_LIST IS 'Semicolon-delimited list of unique regional ecosystems associated with the given cruise leg';
COMMENT ON COLUMN CCD_CRUISE_SUMM_V.ECOSYSTEM_RC_LIST IS 'Return carriage/new line delimited list of unique regional ecosystems associated with the given cruise leg';
COMMENT ON COLUMN CCD_CRUISE_SUMM_V.ECOSYSTEM_BR_LIST IS '<BR> tag (intended for web pages) delimited list of unique regional ecosystems associated with the given cruise leg';


COMMENT ON COLUMN CCD_CRUISE_SUMM_V.NUM_GEAR IS 'The number of unique gear associated with the associated cruise legs';
COMMENT ON COLUMN CCD_CRUISE_SUMM_V.GEAR_CD_LIST IS 'Comma-delimited list of unique gear associated with the associated cruise legs';
COMMENT ON COLUMN CCD_CRUISE_SUMM_V.GEAR_SCD_LIST IS 'Semicolon-delimited list of unique gear associated with the associated cruise legs';
COMMENT ON COLUMN CCD_CRUISE_SUMM_V.GEAR_RC_LIST IS 'Return carriage/new line delimited list of unique gear associated with the associated cruise legs';
COMMENT ON COLUMN CCD_CRUISE_SUMM_V.GEAR_BR_LIST IS '<BR> tag (intended for web pages) delimited list of unique gear associated with the associated cruise legs';



COMMENT ON COLUMN CCD_CRUISE_SUMM_V.NUM_DATA_SETS IS 'The number of unique data sets associated with the associated cruise legs';
COMMENT ON COLUMN CCD_CRUISE_SUMM_V.DATA_SET_CD_LIST IS 'Comma-delimited list of unique data sets associated with the associated cruise legs';
COMMENT ON COLUMN CCD_CRUISE_SUMM_V.DATA_SET_SCD_LIST IS 'Semicolon-delimited list of unique data sets associated with the associated cruise legs';
COMMENT ON COLUMN CCD_CRUISE_SUMM_V.DATA_SET_RC_LIST IS 'Return carriage/new line delimited list of unique data sets associated with the associated cruise legs';
COMMENT ON COLUMN CCD_CRUISE_SUMM_V.DATA_SET_BR_LIST IS '<BR> tag (intended for web pages) delimited list of unique data sets associated with the associated cruise legs';




COMMENT ON COLUMN CCD_CRUISE_SUMM_V.CRUISE_START_DATE IS 'The start date in the corresponding time zone for the given cruise (based on the earliest associated cruise leg''s start date)';
COMMENT ON COLUMN CCD_CRUISE_SUMM_V.FORMAT_CRUISE_START_DATE IS 'The formatted start date in the corresponding time zone for the given cruise (based on the earliest associated cruise leg''s start date) in MM/DD/YYYY HH24:MI:SS format';
COMMENT ON COLUMN CCD_CRUISE_SUMM_V.CRUISE_END_DATE IS 'The end date in the corresponding time zone for the given cruise (based on the latest associated cruise leg''s end date)';
COMMENT ON COLUMN CCD_CRUISE_SUMM_V.FORMAT_CRUISE_END_DATE IS 'The formatted end date in the corresponding time zone for the given cruise (based on the latest associated cruise leg''s end date) in MM/DD/YYYY HH24:MI:SS format';







CREATE OR REPLACE VIEW
CCD_CRUISE_SUMM_ISS_V
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
CCD_CRUISE_SUMM_V.NUM_LEGS,
CCD_CRUISE_SUMM_V.CRUISE_START_DATE,
CCD_CRUISE_SUMM_V.FORMAT_CRUISE_START_DATE,
CCD_CRUISE_SUMM_V.CRUISE_END_DATE,
CCD_CRUISE_SUMM_V.FORMAT_CRUISE_END_DATE,
CCD_CRUISE_SUMM_V.CRUISE_DAS,
CCD_CRUISE_SUMM_V.CRUISE_LEN_DAYS,
CCD_CRUISE_SUMM_V.CRUISE_YEAR,
CCD_CRUISE_SUMM_V.CRUISE_FISC_YEAR,
CCD_CRUISE_SUMM_V.LEG_NAME_CD_LIST,
CCD_CRUISE_SUMM_V.LEG_NAME_SCD_LIST,
CCD_CRUISE_SUMM_V.LEG_NAME_RC_LIST,
CCD_CRUISE_SUMM_V.LEG_NAME_BR_LIST,
CCD_CRUISE_SUMM_V.LEG_NAME_DATES_CD_LIST,
CCD_CRUISE_SUMM_V.LEG_NAME_DATES_SCD_LIST,
CCD_CRUISE_SUMM_V.LEG_NAME_DATES_RC_LIST,
CCD_CRUISE_SUMM_V.LEG_NAME_DATES_BR_LIST,
CCD_CRUISE_SUMM_V.LEG_VESS_NAME_DATES_CD_LIST,
CCD_CRUISE_SUMM_V.LEG_VESS_NAME_DATES_SCD_LIST,
CCD_CRUISE_SUMM_V.LEG_VESS_NAME_DATES_RC_LIST,
CCD_CRUISE_SUMM_V.LEG_VESS_NAME_DATES_BR_LIST,
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
CCD_CRUISE_SUMM_V.NUM_DATA_SETS,
CCD_CRUISE_SUMM_V.DATA_SET_CD_LIST,
CCD_CRUISE_SUMM_V.DATA_SET_SCD_LIST,
CCD_CRUISE_SUMM_V.DATA_SET_RC_LIST,
CCD_CRUISE_SUMM_V.DATA_SET_BR_LIST,




DVM_PTA_ISSUES_V.PTA_ISS_ID,
DVM_PTA_ISSUES_V.CREATE_DATE,
DVM_PTA_ISSUES_V.FORMATTED_CREATE_DATE,
DVM_PTA_ISSUES_V.ISS_ID,
DVM_PTA_ISSUES_V.ISS_DESC,
DVM_PTA_ISSUES_V.ISS_NOTES,
DVM_PTA_ISSUES_V.ISS_RES_TYPE_ID,
DVM_PTA_ISSUES_V.ISS_RES_TYPE_CODE,
DVM_PTA_ISSUES_V.ISS_RES_TYPE_NAME,
DVM_PTA_ISSUES_V.ISS_RES_TYPE_DESC,
DVM_PTA_ISSUES_V.APP_LINK_URL,
DVM_PTA_ISSUES_V.ISS_TYPE_ID,
DVM_PTA_ISSUES_V.QC_OBJECT_ID,
DVM_PTA_ISSUES_V.OBJECT_NAME,
DVM_PTA_ISSUES_V.QC_OBJ_ACTIVE_YN,
DVM_PTA_ISSUES_V.QC_SORT_ORDER,
DVM_PTA_ISSUES_V.ISS_TYPE_NAME,
DVM_PTA_ISSUES_V.ISS_TYPE_COMMENT_TEMPLATE,
DVM_PTA_ISSUES_V.ISS_TYPE_DESC,
DVM_PTA_ISSUES_V.IND_FIELD_NAME,
DVM_PTA_ISSUES_V.APP_LINK_TEMPLATE,
DVM_PTA_ISSUES_V.ISS_SEVERITY_ID,
DVM_PTA_ISSUES_V.ISS_SEVERITY_CODE,
DVM_PTA_ISSUES_V.ISS_SEVERITY_NAME,
DVM_PTA_ISSUES_V.ISS_SEVERITY_DESC,
DVM_PTA_ISSUES_V.DATA_STREAM_ID,
DVM_PTA_ISSUES_V.DATA_STREAM_CODE,
DVM_PTA_ISSUES_V.DATA_STREAM_NAME,
DVM_PTA_ISSUES_V.DATA_STREAM_DESC,
DVM_PTA_ISSUES_V.DATA_STREAM_PAR_TABLE,
DVM_PTA_ISSUES_V.ISS_TYPE_ACTIVE_YN,
DVM_PTA_ISSUES_V.FIRST_EVAL_DATE,
DVM_PTA_ISSUES_V.FORMAT_FIRST_EVAL_DATE,
DVM_PTA_ISSUES_V.LAST_EVAL_DATE,
DVM_PTA_ISSUES_V.FORMAT_LAST_EVAL_DATE,
DVM_PTA_ISSUES_V.ISS_TYP_ASSOC_ID,
DVM_PTA_ISSUES_V.RULE_SET_ID,
DVM_PTA_ISSUES_V.RULE_SET_ACTIVE_YN,
DVM_PTA_ISSUES_V.RULE_SET_CREATE_DATE,
DVM_PTA_ISSUES_V.FORMAT_RULE_SET_CREATE_DATE,
DVM_PTA_ISSUES_V.RULE_SET_INACTIVE_DATE,
DVM_PTA_ISSUES_V.FORMAT_RULE_SET_INACTIVE_DATE,
DVM_PTA_ISSUES_V.RULE_DATA_STREAM_ID,
DVM_PTA_ISSUES_V.RULE_DATA_STREAM_CODE,
DVM_PTA_ISSUES_V.RULE_DATA_STREAM_NAME,
DVM_PTA_ISSUES_V.RULE_DATA_STREAM_DESC,
DVM_PTA_ISSUES_V.RULE_DATA_STREAM_PAR_TABLE

FROM CCD_CRUISE_SUMM_V
INNER JOIN
DVM_PTA_ISSUES_V
ON CCD_CRUISE_SUMM_V.PTA_ISS_ID = DVM_PTA_ISSUES_V.PTA_ISS_ID
order by CRUISE_START_DATE,
CRUISE_NAME,
ISS_TYPE_NAME;

COMMENT ON TABLE CCD_CRUISE_SUMM_ISS_V IS 'Cruise Summary and Associated Validation Issues (View)

This view returns the Cruise summary data and associated validation issues from the DVM that have one or more validation errors/warnings';

COMMENT ON COLUMN CCD_CRUISE_SUMM_ISS_V.CRUISE_ID IS 'Primary key for the CCD_CRUISES table';
COMMENT ON COLUMN CCD_CRUISE_SUMM_ISS_V.CRUISE_NAME IS 'The name of the given cruise designated by NOAA (e.g. SE-15-01)';
COMMENT ON COLUMN CCD_CRUISE_SUMM_ISS_V.CRUISE_NOTES IS 'Any notes for the given research cruise';
COMMENT ON COLUMN CCD_CRUISE_SUMM_ISS_V.CRUISE_DESC IS 'Description for the given research cruise';
COMMENT ON COLUMN CCD_CRUISE_SUMM_ISS_V.OBJ_BASED_METRICS IS 'Objective Based Metrics for the given research cruise';
COMMENT ON COLUMN CCD_CRUISE_SUMM_ISS_V.SCI_CENTER_DIV_ID IS 'Primary key for the Science Center Division table';
COMMENT ON COLUMN CCD_CRUISE_SUMM_ISS_V.SCI_CENTER_DIV_CODE IS 'Abbreviated code for the given Science Center Division';
COMMENT ON COLUMN CCD_CRUISE_SUMM_ISS_V.SCI_CENTER_DIV_NAME IS 'Name of the given Science Center Division';
COMMENT ON COLUMN CCD_CRUISE_SUMM_ISS_V.SCI_CENTER_DIV_DESC IS 'Description for the given Science Center Division';
COMMENT ON COLUMN CCD_CRUISE_SUMM_ISS_V.SCI_CENTER_ID IS 'Primary key for the Science Center table';
COMMENT ON COLUMN CCD_CRUISE_SUMM_ISS_V.SCI_CENTER_NAME IS 'Name of the given Science Center';
COMMENT ON COLUMN CCD_CRUISE_SUMM_ISS_V.SCI_CENTER_DESC IS 'Description for the given Science Center';
COMMENT ON COLUMN CCD_CRUISE_SUMM_ISS_V.STD_SVY_NAME_ID IS 'Primary key for the Standard Survey Name table';
COMMENT ON COLUMN CCD_CRUISE_SUMM_ISS_V.STD_SVY_NAME IS 'Name of the given Standard Survey Name';
COMMENT ON COLUMN CCD_CRUISE_SUMM_ISS_V.STD_SVY_DESC IS 'Description for the given Standard Survey Name';
COMMENT ON COLUMN CCD_CRUISE_SUMM_ISS_V.SVY_FREQ_ID IS 'Primary key for the Survey Frequency table';
COMMENT ON COLUMN CCD_CRUISE_SUMM_ISS_V.SVY_FREQ_NAME IS 'Name of the given Survey Frequency';
COMMENT ON COLUMN CCD_CRUISE_SUMM_ISS_V.SVY_FREQ_DESC IS 'Description for the given Survey Frequency';
COMMENT ON COLUMN CCD_CRUISE_SUMM_ISS_V.STD_SVY_NAME_OTH IS 'Field defines a Standard Survey Name that is not included in the Standard Survey Name table';
COMMENT ON COLUMN CCD_CRUISE_SUMM_ISS_V.STD_SVY_NAME_VAL IS 'This field contains the Standard Survey Name defined for the given cruise.	If the STD_SVY_NAME_ID field is defined then the associated CCD_STD_SVY_NAMES.STD_SVY_NAME is used because the foreign key is given precedence, otherwise the STD_SVY_NAME_OTH field value is used';
COMMENT ON COLUMN CCD_CRUISE_SUMM_ISS_V.SVY_TYPE_ID IS 'Primary key for the Survey Type table';
COMMENT ON COLUMN CCD_CRUISE_SUMM_ISS_V.SVY_TYPE_NAME IS 'Name of the given Survey Type';
COMMENT ON COLUMN CCD_CRUISE_SUMM_ISS_V.SVY_TYPE_DESC IS 'Description for the given Survey Type';
COMMENT ON COLUMN CCD_CRUISE_SUMM_ISS_V.CRUISE_URL IS 'The Cruise URL (Referred to as "Survey URL" in FINSS System) for the given Cruise';
COMMENT ON COLUMN CCD_CRUISE_SUMM_ISS_V.CRUISE_CONT_EMAIL IS 'The Cruise Contact Email (Referred to as "Survey Contact Email" in FINSS System) for the given Cruise';
COMMENT ON COLUMN CCD_CRUISE_SUMM_ISS_V.NUM_SPP_ESA IS 'The number of associated ESA Species';
COMMENT ON COLUMN CCD_CRUISE_SUMM_ISS_V.SPP_ESA_NAME_CD_LIST IS 'Comma-delimited list of ESA Species associated with the given cruise';
COMMENT ON COLUMN CCD_CRUISE_SUMM_ISS_V.SPP_ESA_NAME_SCD_LIST IS 'Semicolon-delimited list of ESA Species associated with the given cruise';
COMMENT ON COLUMN CCD_CRUISE_SUMM_ISS_V.SPP_ESA_NAME_RC_LIST IS 'Return carriage/new line delimited list of ESA Species associated with the given cruise';
COMMENT ON COLUMN CCD_CRUISE_SUMM_ISS_V.SPP_ESA_NAME_BR_LIST IS '<BR> tag (intended for web pages) delimited list of ESA Species associated with the given cruise';
COMMENT ON COLUMN CCD_CRUISE_SUMM_ISS_V.NUM_SPP_FSSI IS 'The number of associated FSSI Species';
COMMENT ON COLUMN CCD_CRUISE_SUMM_ISS_V.SPP_FSSI_NAME_CD_LIST IS 'Comma-delimited list of FSSI Species associated with the given cruise';
COMMENT ON COLUMN CCD_CRUISE_SUMM_ISS_V.SPP_FSSI_NAME_SCD_LIST IS 'Semicolon-delimited list of FSSI Species associated with the given cruise';
COMMENT ON COLUMN CCD_CRUISE_SUMM_ISS_V.SPP_FSSI_NAME_RC_LIST IS 'Return carriage/new line delimited list of FSSI Species associated with the given cruise';
COMMENT ON COLUMN CCD_CRUISE_SUMM_ISS_V.SPP_FSSI_NAME_BR_LIST IS '<BR> tag (intended for web pages) delimited list of FSSI Species associated with the given cruise';
COMMENT ON COLUMN CCD_CRUISE_SUMM_ISS_V.NUM_SPP_MMPA IS 'The number of associated MMPA Species';
COMMENT ON COLUMN CCD_CRUISE_SUMM_ISS_V.SPP_MMPA_NAME_CD_LIST IS 'Comma-delimited list of MMPA Species associated with the given cruise';
COMMENT ON COLUMN CCD_CRUISE_SUMM_ISS_V.SPP_MMPA_NAME_SCD_LIST IS 'Semicolon-delimited list of MMPA Species associated with the given cruise';
COMMENT ON COLUMN CCD_CRUISE_SUMM_ISS_V.SPP_MMPA_NAME_RC_LIST IS 'Return carriage/new line delimited list of MMPA Species associated with the given cruise';
COMMENT ON COLUMN CCD_CRUISE_SUMM_ISS_V.SPP_MMPA_NAME_BR_LIST IS '<BR> tag (intended for web pages) delimited list of MMPA Species associated with the given cruise';
COMMENT ON COLUMN CCD_CRUISE_SUMM_ISS_V.NUM_PRIM_SVY_CATS IS 'The number of associated primary survey categories';
COMMENT ON COLUMN CCD_CRUISE_SUMM_ISS_V.PRIM_SVY_CAT_NAME_CD_LIST IS 'Comma-delimited list of primary survey categories associated with the given cruise';
COMMENT ON COLUMN CCD_CRUISE_SUMM_ISS_V.PRIM_SVY_CAT_NAME_SCD_LIST IS 'Semicolon-delimited list of primary survey categories associated with the given cruise';
COMMENT ON COLUMN CCD_CRUISE_SUMM_ISS_V.PRIM_SVY_CAT_NAME_RC_LIST IS 'Return carriage/new line delimited list of primary survey categories associated with the given cruise';
COMMENT ON COLUMN CCD_CRUISE_SUMM_ISS_V.PRIM_SVY_CAT_NAME_BR_LIST IS '<BR> tag (intended for web pages) delimited list of primary survey categories associated with the given cruise';
COMMENT ON COLUMN CCD_CRUISE_SUMM_ISS_V.NUM_SEC_SVY_CATS IS 'The number of associated secondary survey categories';
COMMENT ON COLUMN CCD_CRUISE_SUMM_ISS_V.SEC_SVY_CAT_NAME_CD_LIST IS 'Comma-delimited list of secondary survey categories associated with the given cruise';
COMMENT ON COLUMN CCD_CRUISE_SUMM_ISS_V.SEC_SVY_CAT_NAME_SCD_LIST IS 'Semicolon-delimited list of secondary survey categories associated with the given cruise';
COMMENT ON COLUMN CCD_CRUISE_SUMM_ISS_V.SEC_SVY_CAT_NAME_RC_LIST IS 'Return carriage/new line delimited list of secondary survey categories associated with the given cruise';
COMMENT ON COLUMN CCD_CRUISE_SUMM_ISS_V.SEC_SVY_CAT_NAME_BR_LIST IS '<BR> tag (intended for web pages) delimited list of secondary survey categories associated with the given cruise';
COMMENT ON COLUMN CCD_CRUISE_SUMM_ISS_V.NUM_EXP_SPP IS 'The number of associated expected species categories';
COMMENT ON COLUMN CCD_CRUISE_SUMM_ISS_V.EXP_SPP_NAME_CD_LIST IS 'Comma-delimited list of expected species categories associated with the given cruise';
COMMENT ON COLUMN CCD_CRUISE_SUMM_ISS_V.EXP_SPP_NAME_SCD_LIST IS 'Semicolon-delimited list of expected species categories associated with the given cruise';
COMMENT ON COLUMN CCD_CRUISE_SUMM_ISS_V.EXP_SPP_NAME_RC_LIST IS 'Return carriage/new line delimited list of expected species categories associated with the given cruise';
COMMENT ON COLUMN CCD_CRUISE_SUMM_ISS_V.EXP_SPP_NAME_BR_LIST IS '<BR> tag (intended for web pages) delimited list of expected species categories associated with the given cruise';
COMMENT ON COLUMN CCD_CRUISE_SUMM_ISS_V.NUM_SPP_OTH IS 'The number of associated target species - other';
COMMENT ON COLUMN CCD_CRUISE_SUMM_ISS_V.OTH_SPP_CNAME_CD_LIST IS 'Comma-delimited list of common names for target species - other associated with the given cruise';
COMMENT ON COLUMN CCD_CRUISE_SUMM_ISS_V.OTH_SPP_CNAME_SCD_LIST IS 'Semicolon-delimited list of common names for target species - other associated with the given cruise';
COMMENT ON COLUMN CCD_CRUISE_SUMM_ISS_V.OTH_SPP_CNAME_RC_LIST IS 'Return carriage/new line delimited list of common names for target species - other associated with the given cruise';
COMMENT ON COLUMN CCD_CRUISE_SUMM_ISS_V.OTH_SPP_CNAME_BR_LIST IS '<BR> tag (intended for web pages) delimited list of common names for target species - other associated with the given cruise';
COMMENT ON COLUMN CCD_CRUISE_SUMM_ISS_V.OTH_SPP_SNAME_CD_LIST IS 'Comma-delimited list of scientific names for target species - other associated with the given cruise';
COMMENT ON COLUMN CCD_CRUISE_SUMM_ISS_V.OTH_SPP_SNAME_SCD_LIST IS 'Semicolon-delimited list of scientific names for target species - other associated with the given cruise';
COMMENT ON COLUMN CCD_CRUISE_SUMM_ISS_V.OTH_SPP_SNAME_RC_LIST IS 'Return carriage/new line delimited list of scientific names for target species - other associated with the given cruise';
COMMENT ON COLUMN CCD_CRUISE_SUMM_ISS_V.OTH_SPP_SNAME_BR_LIST IS '<BR> tag (intended for web pages) delimited list of scientific names for target species - other associated with the given cruise';
COMMENT ON COLUMN CCD_CRUISE_SUMM_ISS_V.CRUISE_DAS IS 'The total number of days at sea for each of the legs associated with the given cruise';
COMMENT ON COLUMN CCD_CRUISE_SUMM_ISS_V.CRUISE_LEN_DAYS IS 'The total number of days between the Cruise Start and End Dates for the given cruise';
COMMENT ON COLUMN CCD_CRUISE_SUMM_ISS_V.CRUISE_YEAR IS 'The calendar year for the given cruise (based on the earliest associated cruise leg''s start date)';
COMMENT ON COLUMN CCD_CRUISE_SUMM_ISS_V.CRUISE_FISC_YEAR IS 'The calendar year for the given cruise (based on the earliest associated cruise leg''s start date)';
COMMENT ON COLUMN CCD_CRUISE_SUMM_ISS_V.NUM_LEGS IS 'The number of cruise legs associated with the given cruise';
COMMENT ON COLUMN CCD_CRUISE_SUMM_ISS_V.LEG_NAME_CD_LIST IS 'Comma-delimited list of leg names associated with the given cruise';
COMMENT ON COLUMN CCD_CRUISE_SUMM_ISS_V.LEG_NAME_SCD_LIST IS 'Semicolon-delimited list of leg names associated with the given cruise';
COMMENT ON COLUMN CCD_CRUISE_SUMM_ISS_V.LEG_NAME_RC_LIST IS 'Return carriage/new line delimited list of leg names associated with the given cruise';
COMMENT ON COLUMN CCD_CRUISE_SUMM_ISS_V.LEG_NAME_BR_LIST IS '<BR> tag (intended for web pages) delimited list of leg names associated with the given cruise';
COMMENT ON COLUMN CCD_CRUISE_SUMM_ISS_V.LEG_NAME_DATES_CD_LIST IS 'Comma-delimited list of leg names, the associated leg dates and vessel name associated with the given cruise';
COMMENT ON COLUMN CCD_CRUISE_SUMM_ISS_V.LEG_NAME_DATES_SCD_LIST IS 'Semicolon-delimited list of leg names, the associated leg dates and vessel name associated with the given cruise';
COMMENT ON COLUMN CCD_CRUISE_SUMM_ISS_V.LEG_NAME_DATES_RC_LIST IS 'Return carriage/new line delimited list of leg names, the associated leg dates and vessel name associated with the given cruise';
COMMENT ON COLUMN CCD_CRUISE_SUMM_ISS_V.LEG_NAME_DATES_BR_LIST IS '<BR> tag (intended for web pages) delimited list of leg names, the associated leg dates and vessel name associated with the given cruise';
COMMENT ON COLUMN CCD_CRUISE_SUMM_ISS_V.NUM_REGIONS IS 'The number of unique regions associated with the associated cruise legs';
COMMENT ON COLUMN CCD_CRUISE_SUMM_ISS_V.REGION_CODE_CD_LIST IS 'Comma-delimited list of unique region codes associated with the given cruise leg';
COMMENT ON COLUMN CCD_CRUISE_SUMM_ISS_V.REGION_CODE_SCD_LIST IS 'Semicolon-delimited list of unique region codes associated with the given cruise leg';
COMMENT ON COLUMN CCD_CRUISE_SUMM_ISS_V.REGION_CODE_RC_LIST IS 'Return carriage/new line delimited list of unique region codes associated with the given cruise leg';
COMMENT ON COLUMN CCD_CRUISE_SUMM_ISS_V.REGION_CODE_BR_LIST IS '<BR> tag (intended for web pages) delimited list of unique region codes associated with the given cruise leg';
COMMENT ON COLUMN CCD_CRUISE_SUMM_ISS_V.REGION_NAME_CD_LIST IS 'Comma-delimited list of unique region names associated with the given cruise leg';
COMMENT ON COLUMN CCD_CRUISE_SUMM_ISS_V.REGION_NAME_SCD_LIST IS 'Semicolon-delimited list of unique region names associated with the given cruise leg';
COMMENT ON COLUMN CCD_CRUISE_SUMM_ISS_V.REGION_NAME_RC_LIST IS 'Return carriage/new line delimited list of unique region names associated with the given cruise leg';
COMMENT ON COLUMN CCD_CRUISE_SUMM_ISS_V.REGION_NAME_BR_LIST IS '<BR> tag (intended for web pages) delimited list of unique region names associated with the given cruise leg';
COMMENT ON COLUMN CCD_CRUISE_SUMM_ISS_V.NUM_ECOSYSTEMS IS 'The number of unique regional ecosystems associated with the associated cruise legs';
COMMENT ON COLUMN CCD_CRUISE_SUMM_ISS_V.ECOSYSTEM_CD_LIST IS 'Comma-delimited list of unique regional ecosystems associated with the given cruise leg';
COMMENT ON COLUMN CCD_CRUISE_SUMM_ISS_V.ECOSYSTEM_SCD_LIST IS 'Semicolon-delimited list of unique regional ecosystems associated with the given cruise leg';
COMMENT ON COLUMN CCD_CRUISE_SUMM_ISS_V.ECOSYSTEM_RC_LIST IS 'Return carriage/new line delimited list of unique regional ecosystems associated with the given cruise leg';
COMMENT ON COLUMN CCD_CRUISE_SUMM_ISS_V.ECOSYSTEM_BR_LIST IS '<BR> tag (intended for web pages) delimited list of unique regional ecosystems associated with the given cruise leg';
COMMENT ON COLUMN CCD_CRUISE_SUMM_ISS_V.NUM_GEAR IS 'The number of unique gear associated with the associated cruise legs';
COMMENT ON COLUMN CCD_CRUISE_SUMM_ISS_V.GEAR_CD_LIST IS 'Comma-delimited list of unique gear associated with the associated cruise legs';
COMMENT ON COLUMN CCD_CRUISE_SUMM_ISS_V.GEAR_SCD_LIST IS 'Semicolon-delimited list of unique gear associated with the associated cruise legs';
COMMENT ON COLUMN CCD_CRUISE_SUMM_ISS_V.GEAR_RC_LIST IS 'Return carriage/new line delimited list of unique gear associated with the associated cruise legs';
COMMENT ON COLUMN CCD_CRUISE_SUMM_ISS_V.GEAR_BR_LIST IS '<BR> tag (intended for web pages) delimited list of unique gear associated with the associated cruise legs';



COMMENT ON COLUMN CCD_CRUISE_SUMM_ISS_V.NUM_DATA_SETS IS 'The number of unique data sets associated with the associated cruise legs';
COMMENT ON COLUMN CCD_CRUISE_SUMM_ISS_V.DATA_SET_CD_LIST IS 'Comma-delimited list of unique data sets associated with the associated cruise legs';
COMMENT ON COLUMN CCD_CRUISE_SUMM_ISS_V.DATA_SET_SCD_LIST IS 'Semicolon-delimited list of unique data sets associated with the associated cruise legs';
COMMENT ON COLUMN CCD_CRUISE_SUMM_ISS_V.DATA_SET_RC_LIST IS 'Return carriage/new line delimited list of unique data sets associated with the associated cruise legs';
COMMENT ON COLUMN CCD_CRUISE_SUMM_ISS_V.DATA_SET_BR_LIST IS '<BR> tag (intended for web pages) delimited list of unique data sets associated with the associated cruise legs';


COMMENT ON COLUMN CCD_CRUISE_SUMM_ISS_V.PTA_ISS_ID IS 'Foreign key reference to the Issues (PTA) intersection table';
COMMENT ON COLUMN CCD_CRUISE_SUMM_ISS_V.CREATE_DATE IS 'The date/time the Validation Issue parent record was created in the database, this indicates the first time the Cruise record was validated using the DVM';
COMMENT ON COLUMN CCD_CRUISE_SUMM_ISS_V.FORMATTED_CREATE_DATE IS 'The formatted date/time the Validation Issue parent record was created in the database, this indicates the first time the Cruise record was validated using the DVM (MM/DD/YYYY HH24:MI)';
COMMENT ON COLUMN CCD_CRUISE_SUMM_ISS_V.ISS_ID IS 'Primary Key for the DVM_ISSUES table';
COMMENT ON COLUMN CCD_CRUISE_SUMM_ISS_V.ISS_DESC IS 'The description of the given Validation Issue';
COMMENT ON COLUMN CCD_CRUISE_SUMM_ISS_V.ISS_NOTES IS 'Manually entered notes for the corresponding data issue';
COMMENT ON COLUMN CCD_CRUISE_SUMM_ISS_V.ISS_RES_TYPE_ID IS 'Primary Key for the DVM_ISS_RES_TYPES table';
COMMENT ON COLUMN CCD_CRUISE_SUMM_ISS_V.ISS_RES_TYPE_CODE IS 'The Issue Resolution Type code';
COMMENT ON COLUMN CCD_CRUISE_SUMM_ISS_V.ISS_RES_TYPE_NAME IS 'The Issue Resolution Type name';
COMMENT ON COLUMN CCD_CRUISE_SUMM_ISS_V.ISS_RES_TYPE_DESC IS 'The Issue Resolution Type description';
COMMENT ON COLUMN CCD_CRUISE_SUMM_ISS_V.APP_LINK_URL IS 'The generated specific application link URL to resolve the given data issue.	This is generated at runtime of the DVM based on the values returned by the corresponding QC query and by the related DVM_ISS_TYPES record''s APP_LINK_TEMPLATE value';
COMMENT ON COLUMN CCD_CRUISE_SUMM_ISS_V.ISS_TYPE_ID IS 'The Issue Type for the given issue';
COMMENT ON COLUMN CCD_CRUISE_SUMM_ISS_V.QC_OBJECT_ID IS 'The Data QC Object that the issue type is determined from.	If this is NULL it is not associated with a QC query validation constraint (e.g. DB error)';
COMMENT ON COLUMN CCD_CRUISE_SUMM_ISS_V.OBJECT_NAME IS 'The name of the object that is used in the given QC validation criteria';
COMMENT ON COLUMN CCD_CRUISE_SUMM_ISS_V.QC_OBJ_ACTIVE_YN IS 'Flag to indicate if the QC object is active (Y) or inactive (N)';
COMMENT ON COLUMN CCD_CRUISE_SUMM_ISS_V.QC_SORT_ORDER IS 'Relative sort order for the QC object to be executed in';
COMMENT ON COLUMN CCD_CRUISE_SUMM_ISS_V.ISS_TYPE_NAME IS 'The name of the given QC validation criteria';
COMMENT ON COLUMN CCD_CRUISE_SUMM_ISS_V.ISS_TYPE_COMMENT_TEMPLATE IS 'The template for the specific issue description that exists in the specific issue condition.	This field should contain placeholders in the form: [PLACEHOLDER] where PLACEHOLDER is the corresponding field name in the result set that will have its placeholder replaced by the corresponding result set field value.	This is NULL only when XML_QC_OBJ_ID is NULL';
COMMENT ON COLUMN CCD_CRUISE_SUMM_ISS_V.ISS_TYPE_DESC IS 'The description for the given QC validation issue type';
COMMENT ON COLUMN CCD_CRUISE_SUMM_ISS_V.IND_FIELD_NAME IS 'The field in the result set that indicates if the current issue type has been identified.	A ''Y'' value indicates that the given issue condition has been identified.	When XML_QC_OBJ_ID is NULL this is the constant name that is used to refer to the current issue type';
COMMENT ON COLUMN CCD_CRUISE_SUMM_ISS_V.APP_LINK_TEMPLATE IS 'The template for the specific application link to resolve the given data issue.	This is intended to provide the necessary parameters in a given URL that can be used to generate the full URL based on the server (e.g. generate the parameters for a given cruise leg and the APEX application will use the [APP_ID] and [APP_SESSION] placeholders at runtime to generate the full URL - f?p=[APP_ID]:220:[APP_SESSION]::NO::CRUISE_ID,CRUISE_ID_COPY:[CRUISE_ID],)';
COMMENT ON COLUMN CCD_CRUISE_SUMM_ISS_V.ISS_SEVERITY_ID IS 'The Severity of the given issue type criteria.	These indicate the status of the given issue (e.g. warnings, data errors, violations of law, etc.)';
COMMENT ON COLUMN CCD_CRUISE_SUMM_ISS_V.ISS_SEVERITY_CODE IS 'The code for the given issue severity';
COMMENT ON COLUMN CCD_CRUISE_SUMM_ISS_V.ISS_SEVERITY_NAME IS 'The name for the given issue severity';
COMMENT ON COLUMN CCD_CRUISE_SUMM_ISS_V.ISS_SEVERITY_DESC IS 'The description for the given issue severity';
COMMENT ON COLUMN CCD_CRUISE_SUMM_ISS_V.DATA_STREAM_ID IS 'Primary Key for the DVM_DATA_STREAMS table';
COMMENT ON COLUMN CCD_CRUISE_SUMM_ISS_V.DATA_STREAM_CODE IS 'The code for the given data stream';
COMMENT ON COLUMN CCD_CRUISE_SUMM_ISS_V.DATA_STREAM_NAME IS 'The name for the given data stream';
COMMENT ON COLUMN CCD_CRUISE_SUMM_ISS_V.DATA_STREAM_DESC IS 'The description for the given data stream';
COMMENT ON COLUMN CCD_CRUISE_SUMM_ISS_V.DATA_STREAM_PAR_TABLE IS 'The Data stream''s parent table name (used when evaluating QC validation criteria to specify a given parent table)';
COMMENT ON COLUMN CCD_CRUISE_SUMM_ISS_V.ISS_TYPE_ACTIVE_YN IS 'Flag to indicate if the given issue type criteria is active';
COMMENT ON COLUMN CCD_CRUISE_SUMM_ISS_V.FIRST_EVAL_DATE IS 'The date/time the rule set was first evaluated for the given parent issue record';
COMMENT ON COLUMN CCD_CRUISE_SUMM_ISS_V.FORMAT_FIRST_EVAL_DATE IS 'The formatted date/time the rule set was first evaluated for the given parent issue record (MM/DD/YYYY HH24:MI format)';
COMMENT ON COLUMN CCD_CRUISE_SUMM_ISS_V.LAST_EVAL_DATE IS 'The date/time the rule set was most recently evaluated for the given parent issue record';
COMMENT ON COLUMN CCD_CRUISE_SUMM_ISS_V.FORMAT_LAST_EVAL_DATE IS 'The formatted date/time the rule set was most recently evaluated for the given parent issue record (MM/DD/YYYY HH24:MI format)';
COMMENT ON COLUMN CCD_CRUISE_SUMM_ISS_V.ISS_TYP_ASSOC_ID IS 'Primary Key for the DVM_ISS_TYP_ASSOC table';
COMMENT ON COLUMN CCD_CRUISE_SUMM_ISS_V.RULE_SET_ID IS 'Primary key for the DVM_RULE_SETS table';
COMMENT ON COLUMN CCD_CRUISE_SUMM_ISS_V.RULE_SET_ACTIVE_YN IS 'Flag to indicate if the given rule set is currently active (Y) or inactive (N).	Only one rule set can be active at any given time';
COMMENT ON COLUMN CCD_CRUISE_SUMM_ISS_V.RULE_SET_CREATE_DATE IS 'The date/time that the given rule set was created';
COMMENT ON COLUMN CCD_CRUISE_SUMM_ISS_V.FORMAT_RULE_SET_CREATE_DATE IS 'The formatted date/time that the given rule set was created (MM/DD/YYYY HH24:MI format)';
COMMENT ON COLUMN CCD_CRUISE_SUMM_ISS_V.RULE_SET_INACTIVE_DATE IS 'The date/time that the given rule set was deactivated (due to a change in active rules)';
COMMENT ON COLUMN CCD_CRUISE_SUMM_ISS_V.FORMAT_RULE_SET_INACTIVE_DATE IS 'The formatted date/time that the given rule set was deactivated (due to a change in active rules) (MM/DD/YYYY HH24:MI format)';
COMMENT ON COLUMN CCD_CRUISE_SUMM_ISS_V.RULE_DATA_STREAM_ID IS 'Foreign key reference to the DVM_DATA_STREAMS table that represents the rule set''s data stream for the given DVM rule set';
COMMENT ON COLUMN CCD_CRUISE_SUMM_ISS_V.RULE_DATA_STREAM_CODE IS 'The code for the given validation rule set''s data stream';
COMMENT ON COLUMN CCD_CRUISE_SUMM_ISS_V.RULE_DATA_STREAM_NAME IS 'The name for the given validation rule set''s data stream';
COMMENT ON COLUMN CCD_CRUISE_SUMM_ISS_V.RULE_DATA_STREAM_DESC IS 'The description for the given validation rule set''s data stream';
COMMENT ON COLUMN CCD_CRUISE_SUMM_ISS_V.RULE_DATA_STREAM_PAR_TABLE IS 'The Data stream''s parent table name for the given validation rule set (used when evaluating QC validation criteria to specify a given parent table)';

COMMENT ON COLUMN CCD_CRUISE_SUMM_ISS_V.APP_LINK_TEMPLATE IS 'The template for the specific application link to resolve the given data issue.	This is intended to provide the necessary parameters in a given URL that can be used to generate the full URL based on the server (e.g. generate the parameters for a given cruise leg and the APEX application will use the [APP_ID] and [APP_SESSION] placeholders at runtime to generate the full URL - f?p=[APP_ID]:220:[APP_SESSION]::NO::CRUISE_ID,CRUISE_ID_COPY:[CRUISE_ID],)';
COMMENT ON COLUMN CCD_CRUISE_SUMM_ISS_V.APP_LINK_URL IS 'The generated specific application link URL to resolve the given data issue.	This is generated at runtime of the DVM based on the values returned by the corresponding QC query and by the related DVM_ISS_TYPES record''s APP_LINK_TEMPLATE value';







COMMENT ON COLUMN CCD_CRUISE_SUMM_ISS_V.CRUISE_START_DATE IS 'The start date in the corresponding time zone for the given cruise (based on the earliest associated cruise leg''s start date)';
COMMENT ON COLUMN CCD_CRUISE_SUMM_ISS_V.FORMAT_CRUISE_START_DATE IS 'The formatted start date in the corresponding time zone for the given cruise (based on the earliest associated cruise leg''s start date) in MM/DD/YYYY HH24:MI:SS format';
COMMENT ON COLUMN CCD_CRUISE_SUMM_ISS_V.CRUISE_END_DATE IS 'The end date in the corresponding time zone for the given cruise (based on the latest associated cruise leg''s end date)';
COMMENT ON COLUMN CCD_CRUISE_SUMM_ISS_V.FORMAT_CRUISE_END_DATE IS 'The formatted end date in the corresponding time zone for the given cruise (based on the latest associated cruise leg''s end date) in MM/DD/YYYY HH24:MI:SS format';





COMMENT ON COLUMN CCD_CRUISE_SUMM_ISS_V.LEG_VESS_NAME_DATES_CD_LIST IS 'Comma-delimited list of leg names, the associated leg dates and vessel name associated with the given cruise';
COMMENT ON COLUMN CCD_CRUISE_SUMM_ISS_V.LEG_VESS_NAME_DATES_SCD_LIST IS 'Semicolon-delimited list of leg names, the associated leg dates and vessel name associated with the given cruise';
COMMENT ON COLUMN CCD_CRUISE_SUMM_ISS_V.LEG_VESS_NAME_DATES_RC_LIST IS 'Return carriage/new line delimited list of leg names, the associated leg dates and vessel name associated with the given cruise';
COMMENT ON COLUMN CCD_CRUISE_SUMM_ISS_V.LEG_VESS_NAME_DATES_BR_LIST IS '<BR> tag (intended for web pages) delimited list of leg names, the associated leg dates and vessel name associated with the given cruise';




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
CCD_CRUISE_SUMM_V.NUM_LEGS,
CCD_CRUISE_SUMM_V.CRUISE_START_DATE,
CCD_CRUISE_SUMM_V.FORMAT_CRUISE_START_DATE,
CCD_CRUISE_SUMM_V.CRUISE_END_DATE,
CCD_CRUISE_SUMM_V.FORMAT_CRUISE_END_DATE,
CCD_CRUISE_SUMM_V.CRUISE_DAS,
CCD_CRUISE_SUMM_V.CRUISE_LEN_DAYS,
CCD_CRUISE_SUMM_V.CRUISE_YEAR,
CCD_CRUISE_SUMM_V.CRUISE_FISC_YEAR,
CCD_CRUISE_SUMM_V.LEG_NAME_CD_LIST,
CCD_CRUISE_SUMM_V.LEG_NAME_SCD_LIST,
CCD_CRUISE_SUMM_V.LEG_NAME_RC_LIST,
CCD_CRUISE_SUMM_V.LEG_NAME_BR_LIST,
CCD_CRUISE_SUMM_V.LEG_NAME_DATES_CD_LIST,
CCD_CRUISE_SUMM_V.LEG_NAME_DATES_SCD_LIST,
CCD_CRUISE_SUMM_V.LEG_NAME_DATES_RC_LIST,
CCD_CRUISE_SUMM_V.LEG_NAME_DATES_BR_LIST,
CCD_CRUISE_SUMM_V.LEG_VESS_NAME_DATES_CD_LIST,
CCD_CRUISE_SUMM_V.LEG_VESS_NAME_DATES_SCD_LIST,
CCD_CRUISE_SUMM_V.LEG_VESS_NAME_DATES_RC_LIST,
CCD_CRUISE_SUMM_V.LEG_VESS_NAME_DATES_BR_LIST,
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
CCD_CRUISE_SUMM_V.NUM_DATA_SETS,
CCD_CRUISE_SUMM_V.DATA_SET_CD_LIST,
CCD_CRUISE_SUMM_V.DATA_SET_SCD_LIST,
CCD_CRUISE_SUMM_V.DATA_SET_RC_LIST,
CCD_CRUISE_SUMM_V.DATA_SET_BR_LIST,



NVL(NUM_ACTIVE_WARNINGS, 0) NUM_ACTIVE_WARNINGS,
NVL(NUM_ANNOT_WARNINGS, 0) NUM_ANNOT_WARNINGS,
NVL(NUM_ACTIVE_ERRORS, 0) NUM_ACTIVE_ERRORS,
NVL(NUM_ANNOT_ERRORS, 0) NUM_ANNOT_ERRORS,
(CASE WHEN NUM_ACTIVE_ERRORS IS NULL OR NUM_ACTIVE_ERRORS = 0 THEN 'Y' ELSE 'N' END) CRUISE_VALID_YN

FROM CCD_CRUISE_SUMM_V
LEFT JOIN
DVM_PTA_ISSUE_SUMM_V ON DVM_PTA_ISSUE_SUMM_V.PTA_ISS_ID = CCD_CRUISE_SUMM_V.PTA_ISS_ID
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
COMMENT ON COLUMN CCD_CRUISE_ISS_SUMM_V.STD_SVY_NAME_VAL IS 'This field contains the Standard Survey Name defined for the given cruise.	If the STD_SVY_NAME_ID field is defined then the associated CCD_STD_SVY_NAMES.STD_SVY_NAME is used because the foreign key is given precedence, otherwise the STD_SVY_NAME_OTH field value is used';
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




COMMENT ON COLUMN CCD_CRUISE_ISS_SUMM_V.NUM_DATA_SETS IS 'The number of unique data sets associated with the associated cruise legs';
COMMENT ON COLUMN CCD_CRUISE_ISS_SUMM_V.DATA_SET_CD_LIST IS 'Comma-delimited list of unique data sets associated with the associated cruise legs';
COMMENT ON COLUMN CCD_CRUISE_ISS_SUMM_V.DATA_SET_SCD_LIST IS 'Semicolon-delimited list of unique data sets associated with the associated cruise legs';
COMMENT ON COLUMN CCD_CRUISE_ISS_SUMM_V.DATA_SET_RC_LIST IS 'Return carriage/new line delimited list of unique data sets associated with the associated cruise legs';
COMMENT ON COLUMN CCD_CRUISE_ISS_SUMM_V.DATA_SET_BR_LIST IS '<BR> tag (intended for web pages) delimited list of unique data sets associated with the associated cruise legs';


COMMENT ON COLUMN CCD_CRUISE_ISS_SUMM_V.NUM_ACTIVE_WARNINGS IS 'Number of QC Validation Active Warnings for the given cruise';
COMMENT ON COLUMN CCD_CRUISE_ISS_SUMM_V.NUM_ANNOT_WARNINGS IS 'Number of QC Validation Annotated Warnings for the given cruise';
COMMENT ON COLUMN CCD_CRUISE_ISS_SUMM_V.NUM_ACTIVE_ERRORS IS 'Number of QC Validation Active Errors (Errors that are not annotated) for the given cruise';
COMMENT ON COLUMN CCD_CRUISE_ISS_SUMM_V.NUM_ANNOT_ERRORS IS 'Number of QC Validation Annotated Errors (Errors that have had an issue resolution specified) for the given cruise';
COMMENT ON COLUMN CCD_CRUISE_ISS_SUMM_V.CRUISE_VALID_YN IS 'Flag to indicate if the given cruise is considered valid (Y) when the only associated QC validation issues are annotated errors and/or warnings or invalid (N) when there are one or more associated active error QC validation issues';


COMMENT ON TABLE CCD_CRUISE_ISS_SUMM_V IS 'Research Cruise Leg Validation Issue Summary (View)

This query returns all of the research cruises and all associated comma-/semicolon-delimited list of associated reference values.	The aggregate cruise leg information is included as start and end dates and the number of legs defined for the given cruise (if any) as well as all associated comma-/semicolon-delimited unique list of associated reference values (regional ecosystems, gear, regions).	This view also contains summary information for any associated QC validation issues in the categories of active warnings, annotated warnings, active errors, and annotated errors';



COMMENT ON COLUMN CCD_CRUISE_ISS_SUMM_V.CRUISE_START_DATE IS 'The start date in the corresponding time zone for the given cruise (based on the earliest associated cruise leg''s start date)';
COMMENT ON COLUMN CCD_CRUISE_ISS_SUMM_V.FORMAT_CRUISE_START_DATE IS 'The formatted start date in the corresponding time zone for the given cruise (based on the earliest associated cruise leg''s start date) in MM/DD/YYYY HH24:MI:SS format';
COMMENT ON COLUMN CCD_CRUISE_ISS_SUMM_V.CRUISE_END_DATE IS 'The end date in the corresponding time zone for the given cruise (based on the latest associated cruise leg''s end date)';
COMMENT ON COLUMN CCD_CRUISE_ISS_SUMM_V.FORMAT_CRUISE_END_DATE IS 'The formatted end date in the corresponding time zone for the given cruise (based on the latest associated cruise leg''s end date) in MM/DD/YYYY HH24:MI:SS format';






COMMENT ON COLUMN CCD_CRUISE_ISS_SUMM_V.LEG_VESS_NAME_DATES_CD_LIST IS 'Comma-delimited list of leg names, the associated leg dates and vessel name associated with the given cruise';
COMMENT ON COLUMN CCD_CRUISE_ISS_SUMM_V.LEG_VESS_NAME_DATES_SCD_LIST IS 'Semicolon-delimited list of leg names, the associated leg dates and vessel name associated with the given cruise';
COMMENT ON COLUMN CCD_CRUISE_ISS_SUMM_V.LEG_VESS_NAME_DATES_RC_LIST IS 'Return carriage/new line delimited list of leg names, the associated leg dates and vessel name associated with the given cruise';
COMMENT ON COLUMN CCD_CRUISE_ISS_SUMM_V.LEG_VESS_NAME_DATES_BR_LIST IS '<BR> tag (intended for web pages) delimited list of leg names, the associated leg dates and vessel name associated with the given cruise';








--define the report for data stream DVM executions (use DVM_DS_PTA_RULE_SETS_HIST_V and CCD_CRUISE_AGG_V)

CREATE OR REPLACE VIEW CCD_CRUISE_DVM_EVAL_V


AS

SELECT
CCD_CRUISE_AGG_V.CRUISE_ID, 
CCD_CRUISE_AGG_V.CRUISE_NAME, 
CCD_CRUISE_AGG_V.CRUISE_NOTES, 
CCD_CRUISE_AGG_V.CRUISE_DESC, 
CCD_CRUISE_AGG_V.OBJ_BASED_METRICS, 
CCD_CRUISE_AGG_V.SCI_CENTER_DIV_ID, 
CCD_CRUISE_AGG_V.SCI_CENTER_DIV_CODE, 
CCD_CRUISE_AGG_V.SCI_CENTER_DIV_NAME, 
CCD_CRUISE_AGG_V.SCI_CENTER_DIV_DESC, 
CCD_CRUISE_AGG_V.SCI_CENTER_ID, 
CCD_CRUISE_AGG_V.SCI_CENTER_NAME, 
CCD_CRUISE_AGG_V.SCI_CENTER_DESC, 
CCD_CRUISE_AGG_V.STD_SVY_NAME_ID, 
CCD_CRUISE_AGG_V.STD_SVY_NAME, 
CCD_CRUISE_AGG_V.STD_SVY_DESC, 
CCD_CRUISE_AGG_V.SVY_FREQ_ID, 
CCD_CRUISE_AGG_V.SVY_FREQ_NAME, 
CCD_CRUISE_AGG_V.SVY_FREQ_DESC, 
CCD_CRUISE_AGG_V.STD_SVY_NAME_OTH, 
CCD_CRUISE_AGG_V.STD_SVY_NAME_VAL, 
CCD_CRUISE_AGG_V.SVY_TYPE_ID, 
CCD_CRUISE_AGG_V.SVY_TYPE_NAME, 
CCD_CRUISE_AGG_V.SVY_TYPE_DESC, 
CCD_CRUISE_AGG_V.CRUISE_URL, 
CCD_CRUISE_AGG_V.CRUISE_CONT_EMAIL, 
CCD_CRUISE_AGG_V.NUM_LEGS, 
CCD_CRUISE_AGG_V.CRUISE_START_DATE, 
CCD_CRUISE_AGG_V.FORMAT_CRUISE_START_DATE, 
CCD_CRUISE_AGG_V.CRUISE_END_DATE, 
CCD_CRUISE_AGG_V.FORMAT_CRUISE_END_DATE, 
CCD_CRUISE_AGG_V.CRUISE_DAS, 
CCD_CRUISE_AGG_V.CRUISE_LEN_DAYS, 
CCD_CRUISE_AGG_V.CRUISE_YEAR, 
CCD_CRUISE_AGG_V.CRUISE_FISC_YEAR, 
CCD_CRUISE_AGG_V.LEG_NAME_CD_LIST, 
CCD_CRUISE_AGG_V.LEG_NAME_SCD_LIST, 
CCD_CRUISE_AGG_V.LEG_NAME_RC_LIST, 
CCD_CRUISE_AGG_V.LEG_NAME_BR_LIST, 
CCD_CRUISE_AGG_V.LEG_NAME_DATES_CD_LIST, 
CCD_CRUISE_AGG_V.LEG_NAME_DATES_SCD_LIST, 
CCD_CRUISE_AGG_V.LEG_NAME_DATES_RC_LIST, 
CCD_CRUISE_AGG_V.LEG_NAME_DATES_BR_LIST, 
CCD_CRUISE_AGG_V.LEG_VESS_NAME_DATES_CD_LIST, 
CCD_CRUISE_AGG_V.LEG_VESS_NAME_DATES_SCD_LIST, 
CCD_CRUISE_AGG_V.LEG_VESS_NAME_DATES_RC_LIST, 
CCD_CRUISE_AGG_V.LEG_VESS_NAME_DATES_BR_LIST, 
DVM_DS_PTA_RULE_SETS_HIST_V.PTA_RULE_SET_ID,
DVM_DS_PTA_RULE_SETS_HIST_V.RULE_SET_ID,
DVM_DS_PTA_RULE_SETS_HIST_V.PTA_ISS_ID,
DVM_DS_PTA_RULE_SETS_HIST_V.DATA_STREAM_ID,

DVM_DS_PTA_RULE_SETS_HIST_V.DATA_STREAM_CODE,
DVM_DS_PTA_RULE_SETS_HIST_V.DATA_STREAM_NAME,
DVM_DS_PTA_RULE_SETS_HIST_V.DATA_STREAM_DESC,
DVM_DS_PTA_RULE_SETS_HIST_V.EVAL_DATE,
DVM_DS_PTA_RULE_SETS_HIST_V.FORMAT_EVAL_DATE

FROM
DVM_DS_PTA_RULE_SETS_HIST_V INNER JOIN
CCD_CRUISE_AGG_V ON
DVM_DS_PTA_RULE_SETS_HIST_V.PTA_ISS_ID = CCD_CRUISE_AGG_V.PTA_ISS_ID
order by
CCD_CRUISE_AGG_V.SCI_CENTER_DIV_NAME,
CCD_CRUISE_AGG_V.CRUISE_NAME,
CCD_CRUISE_AGG_V.CRUISE_START_DATE,
DVM_DS_PTA_RULE_SETS_HIST_V.DATA_STREAM_NAME,
DVM_DS_PTA_RULE_SETS_HIST_V.EVAL_DATE;






COMMENT ON COLUMN CCD_CRUISE_DVM_EVAL_V.CRUISE_ID IS 'Primary key for the CCD_CRUISES table';
COMMENT ON COLUMN CCD_CRUISE_DVM_EVAL_V.CRUISE_NAME IS 'The name of the given cruise designated by NOAA (e.g. SE-15-01)';
COMMENT ON COLUMN CCD_CRUISE_DVM_EVAL_V.CRUISE_NOTES IS 'Any notes for the given research cruise';
COMMENT ON COLUMN CCD_CRUISE_DVM_EVAL_V.CRUISE_DESC IS 'Description for the given research cruise';
COMMENT ON COLUMN CCD_CRUISE_DVM_EVAL_V.OBJ_BASED_METRICS IS 'Objective Based Metrics for the given research cruise';
COMMENT ON COLUMN CCD_CRUISE_DVM_EVAL_V.SCI_CENTER_DIV_ID IS 'Primary key for the Science Center Division table';
COMMENT ON COLUMN CCD_CRUISE_DVM_EVAL_V.SCI_CENTER_DIV_CODE IS 'Abbreviated code for the given Science Center Division';
COMMENT ON COLUMN CCD_CRUISE_DVM_EVAL_V.SCI_CENTER_DIV_NAME IS 'Name of the given Science Center Division';
COMMENT ON COLUMN CCD_CRUISE_DVM_EVAL_V.SCI_CENTER_DIV_DESC IS 'Description for the given Science Center Division';
COMMENT ON COLUMN CCD_CRUISE_DVM_EVAL_V.SCI_CENTER_ID IS 'Primary key for the Science Center table';
COMMENT ON COLUMN CCD_CRUISE_DVM_EVAL_V.SCI_CENTER_NAME IS 'Name of the given Science Center';
COMMENT ON COLUMN CCD_CRUISE_DVM_EVAL_V.SCI_CENTER_DESC IS 'Description for the given Science Center';
COMMENT ON COLUMN CCD_CRUISE_DVM_EVAL_V.STD_SVY_NAME_ID IS 'Primary key for the Standard Survey Name table';
COMMENT ON COLUMN CCD_CRUISE_DVM_EVAL_V.STD_SVY_NAME IS 'Name of the given Standard Survey Name';
COMMENT ON COLUMN CCD_CRUISE_DVM_EVAL_V.STD_SVY_DESC IS 'Description for the given Standard Survey Name';
COMMENT ON COLUMN CCD_CRUISE_DVM_EVAL_V.SVY_FREQ_ID IS 'Primary key for the Survey Frequency table';
COMMENT ON COLUMN CCD_CRUISE_DVM_EVAL_V.SVY_FREQ_NAME IS 'Name of the given Survey Frequency';
COMMENT ON COLUMN CCD_CRUISE_DVM_EVAL_V.SVY_FREQ_DESC IS 'Description for the given Survey Frequency';
COMMENT ON COLUMN CCD_CRUISE_DVM_EVAL_V.STD_SVY_NAME_OTH IS 'Field defines a Standard Survey Name that is not included in the Standard Survey Name table';
COMMENT ON COLUMN CCD_CRUISE_DVM_EVAL_V.STD_SVY_NAME_VAL IS 'This field contains the Standard Survey Name defined for the given cruise.	If the STD_SVY_NAME_ID field is defined then the associated CCD_STD_SVY_NAMES.STD_SVY_NAME is used because the foreign key is given precedence, otherwise the STD_SVY_NAME_OTH field value is used';
COMMENT ON COLUMN CCD_CRUISE_DVM_EVAL_V.SVY_TYPE_ID IS 'Primary key for the Survey Type table';
COMMENT ON COLUMN CCD_CRUISE_DVM_EVAL_V.SVY_TYPE_NAME IS 'Name of the given Survey Type';
COMMENT ON COLUMN CCD_CRUISE_DVM_EVAL_V.SVY_TYPE_DESC IS 'Description for the given Survey Type';
COMMENT ON COLUMN CCD_CRUISE_DVM_EVAL_V.CRUISE_URL IS 'The Cruise URL (Referred to as "Survey URL" in FINSS System) for the given Cruise';
COMMENT ON COLUMN CCD_CRUISE_DVM_EVAL_V.CRUISE_CONT_EMAIL IS 'The Cruise Contact Email (Referred to as "Survey Contact Email" in FINSS System) for the given Cruise';
COMMENT ON COLUMN CCD_CRUISE_DVM_EVAL_V.NUM_LEGS IS 'The number of cruise legs associated with the given cruise';
COMMENT ON COLUMN CCD_CRUISE_DVM_EVAL_V.CRUISE_START_DATE IS 'The start date in the corresponding time zone for the given cruise (based on the earliest associated cruise leg''s start date)';
COMMENT ON COLUMN CCD_CRUISE_DVM_EVAL_V.FORMAT_CRUISE_START_DATE IS 'The formatted start date in the corresponding time zone for the given cruise (based on the earliest associated cruise leg''s start date) in MM/DD/YYYY HH24:MI:SS format';
COMMENT ON COLUMN CCD_CRUISE_DVM_EVAL_V.CRUISE_END_DATE IS 'The end date in the corresponding time zone for the given cruise (based on the latest associated cruise leg''s end date)';
COMMENT ON COLUMN CCD_CRUISE_DVM_EVAL_V.FORMAT_CRUISE_END_DATE IS 'The formatted end date in the corresponding time zone for the given cruise (based on the latest associated cruise leg''s end date) in MM/DD/YYYY HH24:MI:SS format';
COMMENT ON COLUMN CCD_CRUISE_DVM_EVAL_V.CRUISE_DAS IS 'The total number of days at sea for each of the legs associated with the given cruise';
COMMENT ON COLUMN CCD_CRUISE_DVM_EVAL_V.CRUISE_LEN_DAYS IS 'The total number of days between the Cruise Start and End Dates for the given cruise';
COMMENT ON COLUMN CCD_CRUISE_DVM_EVAL_V.CRUISE_YEAR IS 'The calendar year for the given cruise (based on the earliest associated cruise leg''s start date)';
COMMENT ON COLUMN CCD_CRUISE_DVM_EVAL_V.CRUISE_FISC_YEAR IS 'The calendar year for the given cruise (based on the earliest associated cruise leg''s start date)';
COMMENT ON COLUMN CCD_CRUISE_DVM_EVAL_V.LEG_NAME_CD_LIST IS 'Comma-delimited list of leg names associated with the given cruise';
COMMENT ON COLUMN CCD_CRUISE_DVM_EVAL_V.LEG_NAME_SCD_LIST IS 'Semicolon-delimited list of leg names associated with the given cruise';
COMMENT ON COLUMN CCD_CRUISE_DVM_EVAL_V.LEG_NAME_RC_LIST IS 'Return carriage/new line delimited list of leg names associated with the given cruise';
COMMENT ON COLUMN CCD_CRUISE_DVM_EVAL_V.LEG_NAME_BR_LIST IS '<BR> tag (intended for web pages) delimited list of leg names associated with the given cruise';
COMMENT ON COLUMN CCD_CRUISE_DVM_EVAL_V.LEG_NAME_DATES_CD_LIST IS 'Comma-delimited list of leg names, the associated leg dates for the given cruise';
COMMENT ON COLUMN CCD_CRUISE_DVM_EVAL_V.LEG_NAME_DATES_SCD_LIST IS 'Semicolon-delimited list of leg names, the associated leg dates for the given cruise';
COMMENT ON COLUMN CCD_CRUISE_DVM_EVAL_V.LEG_NAME_DATES_RC_LIST IS 'Return carriage/new line delimited list of leg names, the associated leg dates for the given cruise';
COMMENT ON COLUMN CCD_CRUISE_DVM_EVAL_V.LEG_NAME_DATES_BR_LIST IS '<BR> tag (intended for web pages) delimited list of leg names, the associated leg dates for the given cruise';
COMMENT ON COLUMN CCD_CRUISE_DVM_EVAL_V.LEG_VESS_NAME_DATES_CD_LIST IS 'Comma-delimited list of leg names, the associated leg dates and vessel name associated with the given cruise';
COMMENT ON COLUMN CCD_CRUISE_DVM_EVAL_V.LEG_VESS_NAME_DATES_SCD_LIST IS 'Semicolon-delimited list of leg names, the associated leg dates and vessel name associated with the given cruise';
COMMENT ON COLUMN CCD_CRUISE_DVM_EVAL_V.LEG_VESS_NAME_DATES_RC_LIST IS 'Return carriage/new line delimited list of leg names, the associated leg dates and vessel name associated with the given cruise';
COMMENT ON COLUMN CCD_CRUISE_DVM_EVAL_V.LEG_VESS_NAME_DATES_BR_LIST IS '<BR> tag (intended for web pages) delimited list of leg names, the associated leg dates and vessel name associated with the given cruise';




COMMENT ON COLUMN CCD_CRUISE_DVM_EVAL_V.PTA_RULE_SET_ID IS 'The primary key field for the DVM_PTA_RULE_SETS table';
COMMENT ON COLUMN CCD_CRUISE_DVM_EVAL_V.RULE_SET_ID IS 'Primary key for the DVM_RULE_SETS table';
COMMENT ON COLUMN CCD_CRUISE_DVM_EVAL_V.PTA_ISS_ID IS 'Foreign key reference to the PTA Issue record associated validation rule set (DVM_PTA_ISSUES)';
COMMENT ON COLUMN CCD_CRUISE_DVM_EVAL_V.DATA_STREAM_CODE IS 'The code for the given data stream';
COMMENT ON COLUMN CCD_CRUISE_DVM_EVAL_V.DATA_STREAM_NAME IS 'The name for the given data stream';
COMMENT ON COLUMN CCD_CRUISE_DVM_EVAL_V.FORMAT_EVAL_DATE IS 'The formatted date/time the given parent record was evaluated using the DVM for the associated data stream (in SYYYY-MM-DD HH24:MI:SS format)';



COMMENT ON TABLE CCD_CRUISE_DVM_EVAL_V IS 'Cruise DVM Validation Rule Set Evaluation History (View)

This view returns the date/time for each time the DVM was processed (FORMAT_EVAL_DATE) on a given cruise record and associated data stream.';

COMMENT ON COLUMN CCD_CRUISE_DVM_EVAL_V.DATA_STREAM_DESC IS 'The description for the given data stream';
COMMENT ON COLUMN CCD_CRUISE_DVM_EVAL_V.DATA_STREAM_ID IS 'Primary Key for the SPT_DATA_STREAMS table';
COMMENT ON COLUMN CCD_CRUISE_DVM_EVAL_V.EVAL_DATE IS 'The date/time the given parent record was evaluated using the DVM for the associated data stream';









--define the report for data stream DVM executions (use DVM_DS_PTA_RULE_SETS_HIST_V and CCD_CRUISE_V)

CREATE OR REPLACE VIEW CCD_CRUISE_DVM_EVAL_RPT_V


AS

SELECT
CCD_CRUISE_DVM_EVAL_V.SCI_CENTER_DIV_NAME,
CCD_CRUISE_DVM_EVAL_V.CRUISE_ID,
CCD_CRUISE_DVM_EVAL_V.CRUISE_NAME,
CCD_CRUISE_DVM_EVAL_V.STD_SVY_NAME_VAL,
CCD_CRUISE_DVM_EVAL_V.NUM_LEGS,
CCD_CRUISE_DVM_EVAL_V.FORMAT_CRUISE_START_DATE,
CCD_CRUISE_DVM_EVAL_V.FORMAT_CRUISE_END_DATE,
CCD_CRUISE_DVM_EVAL_V.LEG_NAME_CD_LIST,
CCD_CRUISE_DVM_EVAL_V.PTA_RULE_SET_ID,
CCD_CRUISE_DVM_EVAL_V.RULE_SET_ID,
CCD_CRUISE_DVM_EVAL_V.PTA_ISS_ID,
CCD_CRUISE_DVM_EVAL_V.DATA_STREAM_CODE,
CCD_CRUISE_DVM_EVAL_V.DATA_STREAM_NAME,
CCD_CRUISE_DVM_EVAL_V.FORMAT_EVAL_DATE

FROM
CCD_CRUISE_DVM_EVAL_V
order by
CCD_CRUISE_DVM_EVAL_V.SCI_CENTER_DIV_NAME,
CCD_CRUISE_DVM_EVAL_V.CRUISE_NAME,
CCD_CRUISE_DVM_EVAL_V.CRUISE_START_DATE,
CCD_CRUISE_DVM_EVAL_V.DATA_STREAM_NAME,
CCD_CRUISE_DVM_EVAL_V.EVAL_DATE;


COMMENT ON COLUMN CCD_CRUISE_DVM_EVAL_RPT_V.SCI_CENTER_DIV_NAME IS 'Name of the given Science Center Division';
COMMENT ON COLUMN CCD_CRUISE_DVM_EVAL_RPT_V.CRUISE_ID IS 'Primary key for the CCD_CRUISES table';
COMMENT ON COLUMN CCD_CRUISE_DVM_EVAL_RPT_V.CRUISE_NAME IS 'The name of the given cruise designated by NOAA (e.g. SE-15-01)';
COMMENT ON COLUMN CCD_CRUISE_DVM_EVAL_RPT_V.STD_SVY_NAME_VAL IS 'This field contains the Standard Survey Name defined for the given cruise.	If the STD_SVY_NAME_ID field is defined then the associated CCD_STD_SVY_NAMES.STD_SVY_NAME is used because the foreign key is given precedence, otherwise the STD_SVY_NAME_OTH field value is used';
COMMENT ON COLUMN CCD_CRUISE_DVM_EVAL_RPT_V.NUM_LEGS IS 'The number of cruise legs associated with the given cruise';

COMMENT ON COLUMN CCD_CRUISE_DVM_RULE_EVAL_RPT_V.FORMAT_CRUISE_START_DATE IS 'The formatted start date in the corresponding time zone for the given cruise (based on the earliest associated cruise leg''s start date) in MM/DD/YYYY HH24:MI:SS format';
COMMENT ON COLUMN CCD_CRUISE_DVM_RULE_EVAL_RPT_V.FORMAT_CRUISE_END_DATE IS 'The formatted end date in the corresponding time zone for the given cruise (based on the latest associated cruise leg''s end date) in MM/DD/YYYY HH24:MI:SS format';
COMMENT ON COLUMN CCD_CRUISE_DVM_EVAL_RPT_V.LEG_NAME_CD_LIST IS 'Comma-delimited list of leg names associated with the given cruise';



COMMENT ON COLUMN CCD_CRUISE_DVM_EVAL_RPT_V.PTA_RULE_SET_ID IS 'The primary key field for the DVM_PTA_RULE_SETS table';
COMMENT ON COLUMN CCD_CRUISE_DVM_EVAL_RPT_V.RULE_SET_ID IS 'Primary key for the DVM_RULE_SETS table';
COMMENT ON COLUMN CCD_CRUISE_DVM_EVAL_RPT_V.PTA_ISS_ID IS 'Foreign key reference to the PTA Issue record associated validation rule set (DVM_PTA_ISSUES)';
COMMENT ON COLUMN CCD_CRUISE_DVM_EVAL_RPT_V.DATA_STREAM_CODE IS 'The code for the given data stream';
COMMENT ON COLUMN CCD_CRUISE_DVM_EVAL_RPT_V.DATA_STREAM_NAME IS 'The name for the given data stream';
COMMENT ON COLUMN CCD_CRUISE_DVM_EVAL_RPT_V.FORMAT_EVAL_DATE IS 'The formatted date/time the given parent record was evaluated using the DVM for the associated data stream (in SYYYY-MM-DD HH24:MI:SS format)';

COMMENT ON COLUMN CCD_CRUISE_DVM_EVAL_RPT_V.FORMAT_CRUISE_START_DATE IS 'The formatted start date in the corresponding time zone for the given cruise (based on the earliest associated cruise leg''s start date) in MM/DD/YYYY HH24:MI:SS format';
COMMENT ON COLUMN CCD_CRUISE_DVM_EVAL_RPT_V.FORMAT_CRUISE_END_DATE IS 'The formatted end date in the corresponding time zone for the given cruise (based on the latest associated cruise leg''s end date) in MM/DD/YYYY HH24:MI:SS format';


COMMENT ON TABLE CCD_CRUISE_DVM_EVAL_RPT_V IS 'Cruise DVM Validation Rule Set Evaluation History Report (View)

This view returns the date/time for each time the DVM was processed (FORMAT_EVAL_DATE) on a given cruise record and associated data stream.	This query generates a standard validation rule set evaluation report that can be included with the data set metadata or as an internal report to provide the DVM rule set evaluation history for each cruise record if that level of detail is desired';


--define the view for detailed validation rules joined to DVM executions (use DVM_PTA_RULE_SETS_V and CCD_CRUISE_V)
CREATE OR REPLACE VIEW
CCD_CRUISE_DVM_RULE_EVAL_V
AS

SELECT
CCD_CRUISE_AGG_V.CRUISE_ID,
CCD_CRUISE_AGG_V.CRUISE_NAME,
CCD_CRUISE_AGG_V.CRUISE_NOTES,
CCD_CRUISE_AGG_V.CRUISE_DESC,
CCD_CRUISE_AGG_V.OBJ_BASED_METRICS,
CCD_CRUISE_AGG_V.SCI_CENTER_DIV_ID,
CCD_CRUISE_AGG_V.SCI_CENTER_DIV_CODE,
CCD_CRUISE_AGG_V.SCI_CENTER_DIV_NAME,
CCD_CRUISE_AGG_V.SCI_CENTER_DIV_DESC,
CCD_CRUISE_AGG_V.SCI_CENTER_ID,
CCD_CRUISE_AGG_V.SCI_CENTER_NAME,
CCD_CRUISE_AGG_V.SCI_CENTER_DESC,
CCD_CRUISE_AGG_V.STD_SVY_NAME_ID,
CCD_CRUISE_AGG_V.STD_SVY_NAME,
CCD_CRUISE_AGG_V.STD_SVY_DESC,
CCD_CRUISE_AGG_V.SVY_FREQ_ID,
CCD_CRUISE_AGG_V.SVY_FREQ_NAME,
CCD_CRUISE_AGG_V.SVY_FREQ_DESC,
CCD_CRUISE_AGG_V.STD_SVY_NAME_OTH,
CCD_CRUISE_AGG_V.STD_SVY_NAME_VAL,
CCD_CRUISE_AGG_V.SVY_TYPE_ID,
CCD_CRUISE_AGG_V.SVY_TYPE_NAME,
CCD_CRUISE_AGG_V.SVY_TYPE_DESC,
CCD_CRUISE_AGG_V.CRUISE_URL,
CCD_CRUISE_AGG_V.CRUISE_CONT_EMAIL,
CCD_CRUISE_AGG_V.PTA_ISS_ID,
CCD_CRUISE_AGG_V.NUM_LEGS,
CCD_CRUISE_AGG_V.CRUISE_START_DATE,
CCD_CRUISE_AGG_V.FORMAT_CRUISE_START_DATE,
CCD_CRUISE_AGG_V.CRUISE_END_DATE,
CCD_CRUISE_AGG_V.FORMAT_CRUISE_END_DATE,
CCD_CRUISE_AGG_V.CRUISE_DAS,
CCD_CRUISE_AGG_V.CRUISE_LEN_DAYS,
CCD_CRUISE_AGG_V.CRUISE_YEAR,
CCD_CRUISE_AGG_V.CRUISE_FISC_YEAR,
CCD_CRUISE_AGG_V.LEG_NAME_CD_LIST,
CCD_CRUISE_AGG_V.LEG_NAME_SCD_LIST,
CCD_CRUISE_AGG_V.LEG_NAME_RC_LIST,
CCD_CRUISE_AGG_V.LEG_NAME_BR_LIST,
CCD_CRUISE_AGG_V.LEG_NAME_DATES_CD_LIST,
CCD_CRUISE_AGG_V.LEG_NAME_DATES_SCD_LIST,
CCD_CRUISE_AGG_V.LEG_NAME_DATES_RC_LIST,
CCD_CRUISE_AGG_V.LEG_NAME_DATES_BR_LIST,
CCD_CRUISE_AGG_V.LEG_VESS_NAME_DATES_CD_LIST,
CCD_CRUISE_AGG_V.LEG_VESS_NAME_DATES_SCD_LIST,
CCD_CRUISE_AGG_V.LEG_VESS_NAME_DATES_RC_LIST,
CCD_CRUISE_AGG_V.LEG_VESS_NAME_DATES_BR_LIST,





DVM_PTA_RULE_SETS_HIST_V.PTA_RULE_SET_ID,
DVM_PTA_RULE_SETS_HIST_V.RULE_SET_ID,
DVM_PTA_RULE_SETS_HIST_V.RULE_SET_ACTIVE_YN,
DVM_PTA_RULE_SETS_HIST_V.RULE_SET_CREATE_DATE,
DVM_PTA_RULE_SETS_HIST_V.FORMAT_RULE_SET_CREATE_DATE,
DVM_PTA_RULE_SETS_HIST_V.RULE_SET_INACTIVE_DATE,
DVM_PTA_RULE_SETS_HIST_V.FORMAT_RULE_SET_INACTIVE_DATE,
DVM_PTA_RULE_SETS_HIST_V.RULE_DATA_STREAM_ID,
DVM_PTA_RULE_SETS_HIST_V.RULE_DATA_STREAM_CODE,
DVM_PTA_RULE_SETS_HIST_V.RULE_DATA_STREAM_NAME,
DVM_PTA_RULE_SETS_HIST_V.RULE_DATA_STREAM_DESC,
DVM_PTA_RULE_SETS_HIST_V.RULE_DATA_STREAM_PAR_TABLE,
DVM_PTA_RULE_SETS_HIST_V.ISS_TYP_ASSOC_ID,
DVM_PTA_RULE_SETS_HIST_V.QC_OBJECT_ID,
DVM_PTA_RULE_SETS_HIST_V.OBJECT_NAME,
DVM_PTA_RULE_SETS_HIST_V.QC_OBJ_ACTIVE_YN,
DVM_PTA_RULE_SETS_HIST_V.QC_SORT_ORDER,
DVM_PTA_RULE_SETS_HIST_V.ISS_TYPE_ID,
DVM_PTA_RULE_SETS_HIST_V.ISS_TYPE_NAME,
DVM_PTA_RULE_SETS_HIST_V.ISS_TYPE_COMMENT_TEMPLATE,
DVM_PTA_RULE_SETS_HIST_V.ISS_TYPE_DESC,
DVM_PTA_RULE_SETS_HIST_V.IND_FIELD_NAME,
DVM_PTA_RULE_SETS_HIST_V.APP_LINK_TEMPLATE,
DVM_PTA_RULE_SETS_HIST_V.ISS_SEVERITY_ID,
DVM_PTA_RULE_SETS_HIST_V.ISS_SEVERITY_CODE,
DVM_PTA_RULE_SETS_HIST_V.ISS_SEVERITY_NAME,
DVM_PTA_RULE_SETS_HIST_V.ISS_SEVERITY_DESC,
DVM_PTA_RULE_SETS_HIST_V.DATA_STREAM_ID,
DVM_PTA_RULE_SETS_HIST_V.DATA_STREAM_CODE,
DVM_PTA_RULE_SETS_HIST_V.DATA_STREAM_NAME,
DVM_PTA_RULE_SETS_HIST_V.DATA_STREAM_DESC,
DVM_PTA_RULE_SETS_HIST_V.DATA_STREAM_PAR_TABLE,
DVM_PTA_RULE_SETS_HIST_V.ISS_TYPE_ACTIVE_YN,
DVM_PTA_RULE_SETS_HIST_V.FORMAT_EVAL_DATE,
DVM_PTA_RULE_SETS_HIST_V.EVAL_DATE
FROM
CCD_CRUISE_AGG_V
INNER JOIN
DVM_PTA_RULE_SETS_HIST_V
ON CCD_CRUISE_AGG_V.PTA_ISS_ID = DVM_PTA_RULE_SETS_HIST_V.PTA_ISS_ID
order by
CCD_CRUISE_AGG_V.SCI_CENTER_NAME,
CCD_CRUISE_AGG_V.STD_SVY_NAME,
CCD_CRUISE_AGG_V.CRUISE_NAME,
CCD_CRUISE_AGG_V.PTA_ISS_ID,
DVM_PTA_RULE_SETS_HIST_V.DATA_STREAM_CODE,
DVM_PTA_RULE_SETS_HIST_V.EVAL_DATE,
DVM_PTA_RULE_SETS_HIST_V.ISS_SEVERITY_CODE,
DVM_PTA_RULE_SETS_HIST_V.ISS_TYPE_NAME
;


COMMENT ON TABLE CCD_CRUISE_DVM_RULE_EVAL_V IS 'Cruise DVM Validation Rule Evaluation History (View)

This view returns rule sets and associated validation rule sets and corresponding specific validation rules and data stream information for each date/time the DVM was processed (EVAL_DATE) on a given cruise record.';







COMMENT ON COLUMN CCD_CRUISE_DVM_RULE_EVAL_V.CRUISE_ID IS 'Primary key for the CCD_CRUISES table';
COMMENT ON COLUMN CCD_CRUISE_DVM_RULE_EVAL_V.CRUISE_NAME IS 'The name of the given cruise designated by NOAA (e.g. SE-15-01)';
COMMENT ON COLUMN CCD_CRUISE_DVM_RULE_EVAL_V.CRUISE_NOTES IS 'Any notes for the given research cruise';
COMMENT ON COLUMN CCD_CRUISE_DVM_RULE_EVAL_V.CRUISE_DESC IS 'Description for the given research cruise';
COMMENT ON COLUMN CCD_CRUISE_DVM_RULE_EVAL_V.OBJ_BASED_METRICS IS 'Objective Based Metrics for the given research cruise';
COMMENT ON COLUMN CCD_CRUISE_DVM_RULE_EVAL_V.SCI_CENTER_DIV_ID IS 'Primary key for the Science Center Division table';
COMMENT ON COLUMN CCD_CRUISE_DVM_RULE_EVAL_V.SCI_CENTER_DIV_CODE IS 'Abbreviated code for the given Science Center Division';
COMMENT ON COLUMN CCD_CRUISE_DVM_RULE_EVAL_V.SCI_CENTER_DIV_NAME IS 'Name of the given Science Center Division';
COMMENT ON COLUMN CCD_CRUISE_DVM_RULE_EVAL_V.SCI_CENTER_DIV_DESC IS 'Description for the given Science Center Division';
COMMENT ON COLUMN CCD_CRUISE_DVM_RULE_EVAL_V.SCI_CENTER_ID IS 'Primary key for the Science Center table';
COMMENT ON COLUMN CCD_CRUISE_DVM_RULE_EVAL_V.SCI_CENTER_NAME IS 'Name of the given Science Center';
COMMENT ON COLUMN CCD_CRUISE_DVM_RULE_EVAL_V.SCI_CENTER_DESC IS 'Description for the given Science Center';
COMMENT ON COLUMN CCD_CRUISE_DVM_RULE_EVAL_V.STD_SVY_NAME_ID IS 'Primary key for the Standard Survey Name table';
COMMENT ON COLUMN CCD_CRUISE_DVM_RULE_EVAL_V.STD_SVY_NAME IS 'Name of the given Standard Survey Name';
COMMENT ON COLUMN CCD_CRUISE_DVM_RULE_EVAL_V.STD_SVY_DESC IS 'Description for the given Standard Survey Name';
COMMENT ON COLUMN CCD_CRUISE_DVM_RULE_EVAL_V.SVY_FREQ_ID IS 'Primary key for the Survey Frequency table';
COMMENT ON COLUMN CCD_CRUISE_DVM_RULE_EVAL_V.SVY_FREQ_NAME IS 'Name of the given Survey Frequency';
COMMENT ON COLUMN CCD_CRUISE_DVM_RULE_EVAL_V.SVY_FREQ_DESC IS 'Description for the given Survey Frequency';
COMMENT ON COLUMN CCD_CRUISE_DVM_RULE_EVAL_V.STD_SVY_NAME_OTH IS 'Field defines a Standard Survey Name that is not included in the Standard Survey Name table';
COMMENT ON COLUMN CCD_CRUISE_DVM_RULE_EVAL_V.STD_SVY_NAME_VAL IS 'This field contains the Standard Survey Name defined for the given cruise.	If the STD_SVY_NAME_ID field is defined then the associated CCD_STD_SVY_NAMES.STD_SVY_NAME is used because the foreign key is given precedence, otherwise the STD_SVY_NAME_OTH field value is used';
COMMENT ON COLUMN CCD_CRUISE_DVM_RULE_EVAL_V.SVY_TYPE_ID IS 'Primary key for the Survey Type table';
COMMENT ON COLUMN CCD_CRUISE_DVM_RULE_EVAL_V.SVY_TYPE_NAME IS 'Name of the given Survey Type';
COMMENT ON COLUMN CCD_CRUISE_DVM_RULE_EVAL_V.SVY_TYPE_DESC IS 'Description for the given Survey Type';
COMMENT ON COLUMN CCD_CRUISE_DVM_RULE_EVAL_V.CRUISE_URL IS 'The Cruise URL (Referred to as "Survey URL" in FINSS System) for the given Cruise';
COMMENT ON COLUMN CCD_CRUISE_DVM_RULE_EVAL_V.CRUISE_CONT_EMAIL IS 'The Cruise Contact Email (Referred to as "Survey Contact Email" in FINSS System) for the given Cruise';
COMMENT ON COLUMN CCD_CRUISE_DVM_RULE_EVAL_V.PTA_ISS_ID IS 'Foreign key reference to the Issues (PTA) intersection table';
COMMENT ON COLUMN CCD_CRUISE_DVM_RULE_EVAL_V.NUM_LEGS IS 'The number of cruise legs associated with the given cruise';
COMMENT ON COLUMN CCD_CRUISE_DVM_RULE_EVAL_V.CRUISE_START_DATE IS 'The start date in the corresponding time zone for the given cruise (based on the earliest associated cruise leg''s start date)';
COMMENT ON COLUMN CCD_CRUISE_DVM_RULE_EVAL_V.FORMAT_CRUISE_START_DATE IS 'The formatted start date in the corresponding time zone for the given cruise (based on the earliest associated cruise leg''s start date) in MM/DD/YYYY HH24:MI:SS format';
COMMENT ON COLUMN CCD_CRUISE_DVM_RULE_EVAL_V.CRUISE_END_DATE IS 'The end date in the corresponding time zone for the given cruise (based on the latest associated cruise leg''s end date)';
COMMENT ON COLUMN CCD_CRUISE_DVM_RULE_EVAL_V.FORMAT_CRUISE_END_DATE IS 'The formatted end date in the corresponding time zone for the given cruise (based on the latest associated cruise leg''s end date) in MM/DD/YYYY HH24:MI:SS format';
COMMENT ON COLUMN CCD_CRUISE_DVM_RULE_EVAL_V.CRUISE_DAS IS 'The total number of days at sea for each of the legs associated with the given cruise';
COMMENT ON COLUMN CCD_CRUISE_DVM_RULE_EVAL_V.CRUISE_LEN_DAYS IS 'The total number of days between the Cruise Start and End Dates for the given cruise';
COMMENT ON COLUMN CCD_CRUISE_DVM_RULE_EVAL_V.CRUISE_YEAR IS 'The calendar year for the given cruise (based on the earliest associated cruise leg''s start date)';
COMMENT ON COLUMN CCD_CRUISE_DVM_RULE_EVAL_V.CRUISE_FISC_YEAR IS 'The calendar year for the given cruise (based on the earliest associated cruise leg''s start date)';
COMMENT ON COLUMN CCD_CRUISE_DVM_RULE_EVAL_V.LEG_NAME_CD_LIST IS 'Comma-delimited list of leg names associated with the given cruise';
COMMENT ON COLUMN CCD_CRUISE_DVM_RULE_EVAL_V.LEG_NAME_SCD_LIST IS 'Semicolon-delimited list of leg names associated with the given cruise';
COMMENT ON COLUMN CCD_CRUISE_DVM_RULE_EVAL_V.LEG_NAME_RC_LIST IS 'Return carriage/new line delimited list of leg names associated with the given cruise';
COMMENT ON COLUMN CCD_CRUISE_DVM_RULE_EVAL_V.LEG_NAME_BR_LIST IS '<BR> tag (intended for web pages) delimited list of leg names associated with the given cruise';
COMMENT ON COLUMN CCD_CRUISE_DVM_RULE_EVAL_V.LEG_NAME_DATES_CD_LIST IS 'Comma-delimited list of leg names, the associated leg dates for the given cruise';
COMMENT ON COLUMN CCD_CRUISE_DVM_RULE_EVAL_V.LEG_NAME_DATES_SCD_LIST IS 'Semicolon-delimited list of leg names, the associated leg dates for the given cruise';
COMMENT ON COLUMN CCD_CRUISE_DVM_RULE_EVAL_V.LEG_NAME_DATES_RC_LIST IS 'Return carriage/new line delimited list of leg names, the associated leg dates for the given cruise';
COMMENT ON COLUMN CCD_CRUISE_DVM_RULE_EVAL_V.LEG_NAME_DATES_BR_LIST IS '<BR> tag (intended for web pages) delimited list of leg names, the associated leg dates for the given cruise';
COMMENT ON COLUMN CCD_CRUISE_DVM_RULE_EVAL_V.LEG_VESS_NAME_DATES_CD_LIST IS 'Comma-delimited list of leg names, the associated leg dates and vessel name associated with the given cruise';
COMMENT ON COLUMN CCD_CRUISE_DVM_RULE_EVAL_V.LEG_VESS_NAME_DATES_SCD_LIST IS 'Semicolon-delimited list of leg names, the associated leg dates and vessel name associated with the given cruise';
COMMENT ON COLUMN CCD_CRUISE_DVM_RULE_EVAL_V.LEG_VESS_NAME_DATES_RC_LIST IS 'Return carriage/new line delimited list of leg names, the associated leg dates and vessel name associated with the given cruise';
COMMENT ON COLUMN CCD_CRUISE_DVM_RULE_EVAL_V.LEG_VESS_NAME_DATES_BR_LIST IS '<BR> tag (intended for web pages) delimited list of leg names, the associated leg dates and vessel name associated with the given cruise';















COMMENT ON COLUMN CCD_CRUISE_DVM_RULE_EVAL_V.PTA_RULE_SET_ID IS 'The primary key field for the DVM_PTA_RULE_SETS table';
COMMENT ON COLUMN CCD_CRUISE_DVM_RULE_EVAL_V.RULE_SET_ID IS 'Primary key for the DVM_RULE_SETS table';
COMMENT ON COLUMN CCD_CRUISE_DVM_RULE_EVAL_V.RULE_SET_ACTIVE_YN IS 'Flag to indicate if the given rule set is currently active (Y) or inactive (N).	Only one rule set can be active at any given time';
COMMENT ON COLUMN CCD_CRUISE_DVM_RULE_EVAL_V.RULE_SET_CREATE_DATE IS 'The date/time that the given rule set was created';
COMMENT ON COLUMN CCD_CRUISE_DVM_RULE_EVAL_V.FORMAT_RULE_SET_CREATE_DATE IS 'The formatted date/time that the given rule set was created (MM/DD/YYYY HH24:MI:SS format)';
COMMENT ON COLUMN CCD_CRUISE_DVM_RULE_EVAL_V.RULE_SET_INACTIVE_DATE IS 'The date/time that the given rule set was deactivated (due to a change in active rules)';
COMMENT ON COLUMN CCD_CRUISE_DVM_RULE_EVAL_V.FORMAT_RULE_SET_INACTIVE_DATE IS 'The formatted date/time that the given rule set was deactivated (due to a change in active rules) (MM/DD/YYYY HH24:MI:SS format)';
COMMENT ON COLUMN CCD_CRUISE_DVM_RULE_EVAL_V.RULE_DATA_STREAM_ID IS 'Foreign key reference to the DVM_DATA_STREAMS table that represents the rule set''s data stream for the given DVM rule set';
COMMENT ON COLUMN CCD_CRUISE_DVM_RULE_EVAL_V.RULE_DATA_STREAM_CODE IS 'The code for the given validation rule set''s data stream';
COMMENT ON COLUMN CCD_CRUISE_DVM_RULE_EVAL_V.RULE_DATA_STREAM_NAME IS 'The name for the given validation rule set''s data stream';
COMMENT ON COLUMN CCD_CRUISE_DVM_RULE_EVAL_V.RULE_DATA_STREAM_DESC IS 'The description for the given validation rule set''s data stream';
COMMENT ON COLUMN CCD_CRUISE_DVM_RULE_EVAL_V.RULE_DATA_STREAM_PAR_TABLE IS 'The Data stream''s parent table name for the given validation rule set (used when evaluating QC validation criteria to specify a given parent table)';
COMMENT ON COLUMN CCD_CRUISE_DVM_RULE_EVAL_V.ISS_TYP_ASSOC_ID IS 'Primary Key for the DVM_ISS_TYP_ASSOC table';
COMMENT ON COLUMN CCD_CRUISE_DVM_RULE_EVAL_V.QC_OBJECT_ID IS 'The Data QC Object that the issue type is determined from.	If this is NULL it is not associated with a QC query validation constraint (e.g. DB issue)';
COMMENT ON COLUMN CCD_CRUISE_DVM_RULE_EVAL_V.OBJECT_NAME IS 'The name of the object that is used in the given QC validation criteria';
COMMENT ON COLUMN CCD_CRUISE_DVM_RULE_EVAL_V.QC_OBJ_ACTIVE_YN IS 'Flag to indicate if the QC object is active (Y) or inactive (N)';
COMMENT ON COLUMN CCD_CRUISE_DVM_RULE_EVAL_V.QC_SORT_ORDER IS 'Relative sort order for the QC object to be executed in';
COMMENT ON COLUMN CCD_CRUISE_DVM_RULE_EVAL_V.ISS_TYPE_ID IS 'The issue type for the given issue';
COMMENT ON COLUMN CCD_CRUISE_DVM_RULE_EVAL_V.ISS_TYPE_NAME IS 'The name of the given QC validation criteria';
COMMENT ON COLUMN CCD_CRUISE_DVM_RULE_EVAL_V.ISS_TYPE_COMMENT_TEMPLATE IS 'The template for the specific issue description that exists in the specific issue condition.	This field should contain placeholders in the form: [PLACEHOLDER] where PLACEHOLDER is the corresponding field name in the result set that will have its placeholder replaced by the corresponding result set field value.	This is NULL only when XML_QC_OBJ_ID is NULL';
COMMENT ON COLUMN CCD_CRUISE_DVM_RULE_EVAL_V.ISS_TYPE_DESC IS 'The description for the given QC validation issue type';
COMMENT ON COLUMN CCD_CRUISE_DVM_RULE_EVAL_V.IND_FIELD_NAME IS 'The field in the result set that indicates if the current issue type has been identified.	A ''Y'' value indicates that the given issue condition has been identified.	When XML_QC_OBJ_ID is NULL this is the constant name that is used to refer to the current issue type';
COMMENT ON COLUMN CCD_CRUISE_DVM_RULE_EVAL_V.APP_LINK_TEMPLATE IS 'The template for the specific application link to resolve the given data issue.	This is intended to provide the necessary parameters in a given URL that can be used to generate the full URL based on the server (e.g. generate the parameters for a given cruise leg and the APEX application will use the APP_ID and APP_SESSION at runtime to generate the full URL - f?p=[APP_ID]:220:[APP_SESSION]::NO::CRUISE_ID,CRUISE_ID_COPY:[CRUISE_ID],)';
COMMENT ON COLUMN CCD_CRUISE_DVM_RULE_EVAL_V.ISS_SEVERITY_ID IS 'The Severity of the given issue type criteria.	These indicate the status of the given issue (e.g. warnings, data issues, violations of law, etc.)';
COMMENT ON COLUMN CCD_CRUISE_DVM_RULE_EVAL_V.ISS_SEVERITY_CODE IS 'The code for the given issue severity';
COMMENT ON COLUMN CCD_CRUISE_DVM_RULE_EVAL_V.ISS_SEVERITY_NAME IS 'The name for the given issue severity';
COMMENT ON COLUMN CCD_CRUISE_DVM_RULE_EVAL_V.ISS_SEVERITY_DESC IS 'The description for the given issue severity';
COMMENT ON COLUMN CCD_CRUISE_DVM_RULE_EVAL_V.DATA_STREAM_ID IS 'Foreign key reference to the DVM_DATA_STREAMS table that represents the issue type''s data stream for the given DVM rule set';
COMMENT ON COLUMN CCD_CRUISE_DVM_RULE_EVAL_V.DATA_STREAM_CODE IS 'The code for the given issue type''s data stream';
COMMENT ON COLUMN CCD_CRUISE_DVM_RULE_EVAL_V.DATA_STREAM_NAME IS 'The name for the given issue type''s data stream';
COMMENT ON COLUMN CCD_CRUISE_DVM_RULE_EVAL_V.DATA_STREAM_DESC IS 'The description for the given issue type''s data stream';
COMMENT ON COLUMN CCD_CRUISE_DVM_RULE_EVAL_V.DATA_STREAM_PAR_TABLE IS 'The Data stream''s parent table name (used when evaluating QC validation criteria to specify a given parent table)';
COMMENT ON COLUMN CCD_CRUISE_DVM_RULE_EVAL_V.ISS_TYPE_ACTIVE_YN IS 'Flag to indicate if the given issue type criteria is active';
COMMENT ON COLUMN CCD_CRUISE_DVM_RULE_EVAL_V.FORMAT_EVAL_DATE IS 'The formatted date/time the given parent record was evaluated using the DVM for the associated data stream (in MM/DD/YYYY HH24:MI:SS format)';
COMMENT ON COLUMN CCD_CRUISE_DVM_RULE_EVAL_V.EVAL_DATE IS 'The date/time the given parent record was evaluated using the DVM for the associated data stream';



--define the report for detailed validation rules joined to DVM executions (use DVM_DS_PTA_RULE_SETS_HIST_V and CCD_CRUISE_V)
CREATE OR REPLACE VIEW
CCD_CRUISE_DVM_RULE_EVAL_RPT_V
AS

SELECT
CCD_CRUISE_DVM_RULE_EVAL_V.SCI_CENTER_DIV_NAME,
CCD_CRUISE_DVM_RULE_EVAL_V.CRUISE_ID,
CCD_CRUISE_DVM_RULE_EVAL_V.CRUISE_NAME,
CCD_CRUISE_DVM_RULE_EVAL_V.STD_SVY_NAME_VAL,
CCD_CRUISE_DVM_RULE_EVAL_V.NUM_LEGS,
CCD_CRUISE_DVM_RULE_EVAL_V.FORMAT_CRUISE_START_DATE,
CCD_CRUISE_DVM_RULE_EVAL_V.FORMAT_CRUISE_END_DATE,
CCD_CRUISE_DVM_RULE_EVAL_V.LEG_NAME_CD_LIST,
CCD_CRUISE_DVM_RULE_EVAL_V.RULE_SET_ACTIVE_YN,
CCD_CRUISE_DVM_RULE_EVAL_V.FORMAT_RULE_SET_CREATE_DATE,
CCD_CRUISE_DVM_RULE_EVAL_V.FORMAT_RULE_SET_INACTIVE_DATE,
CCD_CRUISE_DVM_RULE_EVAL_V.RULE_DATA_STREAM_CODE,
CCD_CRUISE_DVM_RULE_EVAL_V.RULE_DATA_STREAM_NAME,
CCD_CRUISE_DVM_RULE_EVAL_V.ISS_TYPE_NAME,
CCD_CRUISE_DVM_RULE_EVAL_V.ISS_TYPE_DESC,
CCD_CRUISE_DVM_RULE_EVAL_V.ISS_SEVERITY_CODE,
CCD_CRUISE_DVM_RULE_EVAL_V.ISS_SEVERITY_NAME,
CCD_CRUISE_DVM_RULE_EVAL_V.FORMAT_EVAL_DATE

FROM
CCD_CRUISE_DVM_RULE_EVAL_V
order by
CCD_CRUISE_DVM_RULE_EVAL_V.SCI_CENTER_DIV_NAME,
CCD_CRUISE_DVM_RULE_EVAL_V.CRUISE_NAME,
CCD_CRUISE_DVM_RULE_EVAL_V.CRUISE_START_DATE,
CCD_CRUISE_DVM_RULE_EVAL_V.RULE_DATA_STREAM_NAME,
CCD_CRUISE_DVM_RULE_EVAL_V.EVAL_DATE;


COMMENT ON TABLE CCD_CRUISE_DVM_RULE_EVAL_RPT_V IS 'Cruise DVM Validation Rule Evaluation History Report (View)

This view returns a subset of the fields in the rule sets and associated validation rule sets and corresponding specific validation rules and data stream information for each date/time the DVM was processed (EVAL_DATE) on a given cruise record.	This standard detailed report query can be included with the data set metadata or as an internal report to provide information about each time the DVM was evaluated for which specific validation rules on a given cruise for each data stream if that level of detail is desired';




--define missing view columns from previous update:
COMMENT ON COLUMN CCD_CRUISE_DVM_RULE_EVAL_RPT_V.SCI_CENTER_DIV_NAME IS 'Name of the given Science Center Division';
COMMENT ON COLUMN CCD_CRUISE_DVM_RULE_EVAL_RPT_V.CRUISE_ID IS 'Primary key for the CCD_CRUISES table';
COMMENT ON COLUMN CCD_CRUISE_DVM_RULE_EVAL_RPT_V.CRUISE_NAME IS 'The name of the given cruise designated by NOAA (e.g. SE-15-01)';
COMMENT ON COLUMN CCD_CRUISE_DVM_RULE_EVAL_RPT_V.STD_SVY_NAME_VAL IS 'This field contains the Standard Survey Name defined for the given cruise.	If the STD_SVY_NAME_ID field is defined then the associated CCD_STD_SVY_NAMES.STD_SVY_NAME is used because the foreign key is given precedence, otherwise the STD_SVY_NAME_OTH field value is used';
COMMENT ON COLUMN CCD_CRUISE_DVM_RULE_EVAL_RPT_V.NUM_LEGS IS 'The number of cruise legs associated with the given cruise';
COMMENT ON COLUMN CCD_CRUISE_DVM_RULE_EVAL_RPT_V.FORMAT_CRUISE_START_DATE IS 'The formatted start date for the given cruise (based on the earliest associated cruise leg''s start date) in MM/DD/YYYY format';
COMMENT ON COLUMN CCD_CRUISE_DVM_RULE_EVAL_RPT_V.FORMAT_CRUISE_END_DATE IS 'The formatted end date for the given cruise (based on the latest associated cruise leg''s end date) in MM/DD/YYYY format';
COMMENT ON COLUMN CCD_CRUISE_DVM_RULE_EVAL_RPT_V.LEG_NAME_CD_LIST IS 'Comma-delimited list of leg names associated with the given cruise';
COMMENT ON COLUMN CCD_CRUISE_DVM_RULE_EVAL_RPT_V.RULE_SET_ACTIVE_YN IS 'Flag to indicate if the given rule set is currently active (Y) or inactive (N).	Only one rule set can be active at any given time';
COMMENT ON COLUMN CCD_CRUISE_DVM_RULE_EVAL_RPT_V.FORMAT_RULE_SET_CREATE_DATE IS 'The formatted date/time that the given rule set was created (MM/DD/YYYY HH24:MI:SS format)';
COMMENT ON COLUMN CCD_CRUISE_DVM_RULE_EVAL_RPT_V.FORMAT_RULE_SET_INACTIVE_DATE IS 'The formatted date/time that the given rule set was deactivated (due to a change in active rules) (MM/DD/YYYY HH24:MI:SS format)';
COMMENT ON COLUMN CCD_CRUISE_DVM_RULE_EVAL_RPT_V.RULE_DATA_STREAM_CODE IS 'The code for the given validation rule set''s data stream';
COMMENT ON COLUMN CCD_CRUISE_DVM_RULE_EVAL_RPT_V.RULE_DATA_STREAM_NAME IS 'The name for the given validation rule set''s data stream';
COMMENT ON COLUMN CCD_CRUISE_DVM_RULE_EVAL_RPT_V.ISS_TYPE_NAME IS 'The name of the given QC validation criteria';
COMMENT ON COLUMN CCD_CRUISE_DVM_RULE_EVAL_RPT_V.ISS_TYPE_DESC IS 'The description for the given QC validation issue type';
COMMENT ON COLUMN CCD_CRUISE_DVM_RULE_EVAL_RPT_V.ISS_SEVERITY_CODE IS 'The code for the given issue severity';
COMMENT ON COLUMN CCD_CRUISE_DVM_RULE_EVAL_RPT_V.ISS_SEVERITY_NAME IS 'The name for the given issue severity';
COMMENT ON COLUMN CCD_CRUISE_DVM_RULE_EVAL_RPT_V.FORMAT_EVAL_DATE IS 'The formatted date/time the given parent record was evaluated using the DVM for the associated data stream (in MM/DD/YYYY HH24:MI:SS format)';











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


CCD_CRUISE_AGG_V.CRUISE_ID,
CCD_CRUISE_AGG_V.CRUISE_NAME,
CCD_CRUISE_AGG_V.CRUISE_NOTES,
CCD_CRUISE_AGG_V.CRUISE_DESC,
CCD_CRUISE_AGG_V.OBJ_BASED_METRICS,
CCD_CRUISE_AGG_V.SCI_CENTER_DIV_ID,
CCD_CRUISE_AGG_V.SCI_CENTER_DIV_CODE,
CCD_CRUISE_AGG_V.SCI_CENTER_DIV_NAME,
CCD_CRUISE_AGG_V.SCI_CENTER_DIV_DESC,
CCD_CRUISE_AGG_V.SCI_CENTER_ID,
CCD_CRUISE_AGG_V.SCI_CENTER_NAME,
CCD_CRUISE_AGG_V.SCI_CENTER_DESC,
CCD_CRUISE_AGG_V.STD_SVY_NAME_ID,
CCD_CRUISE_AGG_V.STD_SVY_NAME,
CCD_CRUISE_AGG_V.STD_SVY_DESC,
CCD_CRUISE_AGG_V.SVY_FREQ_ID,
CCD_CRUISE_AGG_V.SVY_FREQ_NAME,
CCD_CRUISE_AGG_V.SVY_FREQ_DESC,
CCD_CRUISE_AGG_V.STD_SVY_NAME_OTH,
CCD_CRUISE_AGG_V.STD_SVY_NAME_VAL,
CCD_CRUISE_AGG_V.SVY_TYPE_ID,
CCD_CRUISE_AGG_V.SVY_TYPE_NAME,
CCD_CRUISE_AGG_V.SVY_TYPE_DESC,
CCD_CRUISE_AGG_V.CRUISE_URL,
CCD_CRUISE_AGG_V.CRUISE_CONT_EMAIL,
CCD_CRUISE_AGG_V.NUM_LEGS,
CCD_CRUISE_AGG_V.CRUISE_START_DATE,
CCD_CRUISE_AGG_V.FORMAT_CRUISE_START_DATE,
CCD_CRUISE_AGG_V.CRUISE_END_DATE,
CCD_CRUISE_AGG_V.FORMAT_CRUISE_END_DATE,
CCD_CRUISE_AGG_V.CRUISE_DAS,
CCD_CRUISE_AGG_V.CRUISE_LEN_DAYS,
CCD_CRUISE_AGG_V.CRUISE_YEAR,
CCD_CRUISE_AGG_V.CRUISE_FISC_YEAR,
CCD_CRUISE_AGG_V.LEG_NAME_CD_LIST,
CCD_CRUISE_AGG_V.LEG_NAME_SCD_LIST,
CCD_CRUISE_AGG_V.LEG_NAME_RC_LIST,
CCD_CRUISE_AGG_V.LEG_NAME_BR_LIST,
CCD_CRUISE_AGG_V.LEG_NAME_DATES_CD_LIST,
CCD_CRUISE_AGG_V.LEG_NAME_DATES_SCD_LIST,
CCD_CRUISE_AGG_V.LEG_NAME_DATES_RC_LIST,
CCD_CRUISE_AGG_V.LEG_NAME_DATES_BR_LIST,
CCD_CRUISE_AGG_V.LEG_VESS_NAME_DATES_CD_LIST,
CCD_CRUISE_AGG_V.LEG_VESS_NAME_DATES_SCD_LIST,
CCD_CRUISE_AGG_V.LEG_VESS_NAME_DATES_RC_LIST,
CCD_CRUISE_AGG_V.LEG_VESS_NAME_DATES_BR_LIST


FROM
DVM_PTA_RULE_SETS_V INNER JOIN
CCD_CRUISE_AGG_V ON
DVM_PTA_RULE_SETS_V.PTA_ISS_ID = CCD_CRUISE_AGG_V.PTA_ISS_ID
order by
CCD_CRUISE_AGG_V.SCI_CENTER_NAME,
CCD_CRUISE_AGG_V.STD_SVY_NAME,
CCD_CRUISE_AGG_V.CRUISE_NAME,
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
COMMENT ON COLUMN CCD_CRUISE_DVM_RULES_V.RULE_SET_ACTIVE_YN IS 'Flag to indicate if the given rule set is currently active (Y) or inactive (N).	Only one rule set can be active at any given time';
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
COMMENT ON COLUMN CCD_CRUISE_DVM_RULES_V.QC_OBJECT_ID IS 'The Data QC Object that the issue type is determined from.	If this is NULL it is not associated with a QC query validation constraint (e.g. DB issue)';
COMMENT ON COLUMN CCD_CRUISE_DVM_RULES_V.OBJECT_NAME IS 'The name of the object that is used in the given QC validation criteria';
COMMENT ON COLUMN CCD_CRUISE_DVM_RULES_V.QC_OBJ_ACTIVE_YN IS 'Flag to indicate if the QC object is active (Y) or inactive (N)';
COMMENT ON COLUMN CCD_CRUISE_DVM_RULES_V.QC_SORT_ORDER IS 'Relative sort order for the QC object to be executed in';
COMMENT ON COLUMN CCD_CRUISE_DVM_RULES_V.ISS_TYPE_ID IS 'The issue type for the given issue';
COMMENT ON COLUMN CCD_CRUISE_DVM_RULES_V.ISS_TYPE_NAME IS 'The name of the given QC validation criteria';
COMMENT ON COLUMN CCD_CRUISE_DVM_RULES_V.ISS_TYPE_COMMENT_TEMPLATE IS 'The template for the specific issue description that exists in the specific issue condition.	This field should contain placeholders in the form: [PLACEHOLDER] where PLACEHOLDER is the corresponding field name in the result set that will have its placeholder replaced by the corresponding result set field value.	This is NULL only when XML_QC_OBJ_ID is NULL';
COMMENT ON COLUMN CCD_CRUISE_DVM_RULES_V.ISS_TYPE_DESC IS 'The description for the given QC validation issue type';
COMMENT ON COLUMN CCD_CRUISE_DVM_RULES_V.IND_FIELD_NAME IS 'The field in the result set that indicates if the current issue type has been identified.	A ''Y'' value indicates that the given issue condition has been identified.	When XML_QC_OBJ_ID is NULL this is the constant name that is used to refer to the current issue type';
COMMENT ON COLUMN CCD_CRUISE_DVM_RULES_V.APP_LINK_TEMPLATE IS 'The template for the specific application link to resolve the given data issue.	This is intended to provide the necessary parameters in a given URL that can be used to generate the full URL based on the server (e.g. generate the parameters for a given cruise leg and the APEX application will use the APP_ID and APP_SESSION at runtime to generate the full URL - f?p=[APP_ID]:220:[APP_SESSION]::NO::CRUISE_ID,CRUISE_ID_COPY:[CRUISE_ID],)';
COMMENT ON COLUMN CCD_CRUISE_DVM_RULES_V.ISS_SEVERITY_ID IS 'The Severity of the given issue type criteria.	These indicate the status of the given issue (e.g. warnings, data issues, violations of law, etc.)';
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
COMMENT ON COLUMN CCD_CRUISE_DVM_RULES_V.STD_SVY_NAME_VAL IS 'This field contains the Standard Survey Name defined for the given cruise.	If the STD_SVY_NAME_ID field is defined then the associated CCD_STD_SVY_NAMES.STD_SVY_NAME is used because the foreign key is given precedence, otherwise the STD_SVY_NAME_OTH field value is used';
COMMENT ON COLUMN CCD_CRUISE_DVM_RULES_V.SVY_TYPE_ID IS 'Primary key for the Survey Type table';
COMMENT ON COLUMN CCD_CRUISE_DVM_RULES_V.SVY_TYPE_NAME IS 'Name of the given Survey Type';
COMMENT ON COLUMN CCD_CRUISE_DVM_RULES_V.SVY_TYPE_DESC IS 'Description for the given Survey Type';
COMMENT ON COLUMN CCD_CRUISE_DVM_RULES_V.CRUISE_URL IS 'The Cruise URL (Referred to as "Survey URL" in FINSS System) for the given Cruise';
COMMENT ON COLUMN CCD_CRUISE_DVM_RULES_V.CRUISE_CONT_EMAIL IS 'The Cruise Contact Email (Referred to as "Survey Contact Email" in FINSS System) for the given Cruise';
COMMENT ON COLUMN CCD_CRUISE_DVM_RULES_V.PTA_ISS_ID IS 'Foreign key reference to the Issues (PTA) intersection table';
COMMENT ON COLUMN CCD_CRUISE_DVM_RULES_V.NUM_LEGS IS 'The number of cruise legs associated with the given cruise';
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






COMMENT ON COLUMN CCD_CRUISE_DVM_RULES_V.LEG_VESS_NAME_DATES_CD_LIST IS 'Comma-delimited list of leg names, the associated leg dates and vessel name associated with the given cruise';
COMMENT ON COLUMN CCD_CRUISE_DVM_RULES_V.LEG_VESS_NAME_DATES_SCD_LIST IS 'Semicolon-delimited list of leg names, the associated leg dates and vessel name associated with the given cruise';
COMMENT ON COLUMN CCD_CRUISE_DVM_RULES_V.LEG_VESS_NAME_DATES_RC_LIST IS 'Return carriage/new line delimited list of leg names, the associated leg dates and vessel name associated with the given cruise';
COMMENT ON COLUMN CCD_CRUISE_DVM_RULES_V.LEG_VESS_NAME_DATES_BR_LIST IS '<BR> tag (intended for web pages) delimited list of leg names, the associated leg dates and vessel name associated with the given cruise';

COMMENT ON COLUMN CCD_CRUISE_DVM_RULES_V.LEG_NAME_DATES_CD_LIST IS 'Comma-delimited list of leg names, the associated leg dates and vessel name associated with the given cruise';
COMMENT ON COLUMN CCD_CRUISE_DVM_RULES_V.LEG_NAME_DATES_SCD_LIST IS 'Semicolon-delimited list of leg names, the associated leg dates and vessel name associated with the given cruise';
COMMENT ON COLUMN CCD_CRUISE_DVM_RULES_V.LEG_NAME_DATES_RC_LIST IS 'Return carriage/new line delimited list of leg names, the associated leg dates and vessel name associated with the given cruise';
COMMENT ON COLUMN CCD_CRUISE_DVM_RULES_V.LEG_NAME_DATES_BR_LIST IS '<BR> tag (intended for web pages) delimited list of leg names, the associated leg dates and vessel name associated with the given cruise';




COMMENT ON COLUMN CCD_CRUISE_DVM_RULES_V.CRUISE_START_DATE IS 'The start date in the corresponding time zone for the given cruise (based on the earliest associated cruise leg''s start date)';
COMMENT ON COLUMN CCD_CRUISE_DVM_RULES_V.FORMAT_CRUISE_START_DATE IS 'The formatted start date in the corresponding time zone for the given cruise (based on the earliest associated cruise leg''s start date) in MM/DD/YYYY HH24:MI:SS format';
COMMENT ON COLUMN CCD_CRUISE_DVM_RULES_V.CRUISE_END_DATE IS 'The end date in the corresponding time zone for the given cruise (based on the latest associated cruise leg''s end date)';
COMMENT ON COLUMN CCD_CRUISE_DVM_RULES_V.FORMAT_CRUISE_END_DATE IS 'The formatted end date in the corresponding time zone for the given cruise (based on the latest associated cruise leg''s end date) in MM/DD/YYYY HH24:MI:SS format';






CREATE OR REPLACE VIEW CCD_CRUISE_DVM_RULES_RPT_V


AS

SELECT
CCD_CRUISE_DVM_RULES_V.SCI_CENTER_DIV_NAME,
CCD_CRUISE_DVM_RULES_V.CRUISE_ID,
CCD_CRUISE_DVM_RULES_V.CRUISE_NAME,
CCD_CRUISE_DVM_RULES_V.STD_SVY_NAME_VAL,
CCD_CRUISE_DVM_RULES_V.NUM_LEGS,
CCD_CRUISE_DVM_RULES_V.FORMAT_CRUISE_START_DATE,
CCD_CRUISE_DVM_RULES_V.FORMAT_CRUISE_END_DATE,
CCD_CRUISE_DVM_RULES_V.LEG_NAME_CD_LIST,
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
CCD_CRUISE_DVM_RULES_V.ISS_TYPE_NAME,
CCD_CRUISE_DVM_RULES_V.ISS_TYPE_DESC,
CCD_CRUISE_DVM_RULES_V.ISS_SEVERITY_CODE,
CCD_CRUISE_DVM_RULES_V.ISS_SEVERITY_NAME
FROM
CCD_CRUISE_DVM_RULES_V
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
COMMENT ON COLUMN CCD_CRUISE_DVM_RULES_RPT_V.RULE_SET_ACTIVE_YN IS 'Flag to indicate if the given rule set is currently active (Y) or inactive (N).	Only one rule set can be active at any given time';
COMMENT ON COLUMN CCD_CRUISE_DVM_RULES_RPT_V.FORMAT_RULE_SET_CREATE_DATE IS 'The formatted date/time that the given rule set was created (MM/DD/YYYY HH24:MI:SS format)';
COMMENT ON COLUMN CCD_CRUISE_DVM_RULES_RPT_V.FORMAT_RULE_SET_INACTIVE_DATE IS 'The formatted date/time that the given rule set was deactivated (due to a change in active rules) (MM/DD/YYYY HH24:MI:SS format)';
COMMENT ON COLUMN CCD_CRUISE_DVM_RULES_RPT_V.RULE_DATA_STREAM_CODE IS 'The code for the given validation rule set''s data stream';
COMMENT ON COLUMN CCD_CRUISE_DVM_RULES_RPT_V.RULE_DATA_STREAM_NAME IS 'The name for the given validation rule set''s data stream';
COMMENT ON COLUMN CCD_CRUISE_DVM_RULES_RPT_V.ISS_TYPE_NAME IS 'The name of the given QC validation criteria';
COMMENT ON COLUMN CCD_CRUISE_DVM_RULES_RPT_V.ISS_TYPE_DESC IS 'The description for the given QC validation issue type';
COMMENT ON COLUMN CCD_CRUISE_DVM_RULES_RPT_V.ISS_SEVERITY_CODE IS 'The code for the given issue severity';
COMMENT ON COLUMN CCD_CRUISE_DVM_RULES_RPT_V.ISS_SEVERITY_NAME IS 'The name for the given issue severity';
COMMENT ON COLUMN CCD_CRUISE_DVM_RULES_RPT_V.SCI_CENTER_DIV_NAME IS 'Name of the given Science Center Division';
COMMENT ON COLUMN CCD_CRUISE_DVM_RULES_RPT_V.CRUISE_ID IS 'Primary key for the CCD_CRUISES table';
COMMENT ON COLUMN CCD_CRUISE_DVM_RULES_RPT_V.CRUISE_NAME IS 'The name of the given cruise designated by NOAA (e.g. SE-15-01)';
COMMENT ON COLUMN CCD_CRUISE_DVM_RULES_RPT_V.STD_SVY_NAME_VAL IS 'This field contains the Standard Survey Name defined for the given cruise.	If the STD_SVY_NAME_ID field is defined then the associated CCD_STD_SVY_NAMES.STD_SVY_NAME is used because the foreign key is given precedence, otherwise the STD_SVY_NAME_OTH field value is used';
COMMENT ON COLUMN CCD_CRUISE_DVM_RULES_RPT_V.NUM_LEGS IS 'The number of cruise legs associated with the given cruise';
COMMENT ON COLUMN CCD_CRUISE_DVM_RULES_RPT_V.LEG_NAME_CD_LIST IS 'Comma-delimited list of leg names associated with the given cruise';

COMMENT ON TABLE CCD_CRUISE_DVM_RULES_RPT_V IS 'Cruise DVM Rules Report (View)

This view returns all of the DVM PTA validation rule sets and all related validation rule set information and cruise information.	This query generates a standard validation rule report that can be included with the data set metadata or as an internal report to provide the specific data quality control criteria that was used to validate each cruise record if that level of detail is desired';




COMMENT ON COLUMN CCD_CRUISE_DVM_RULES_RPT_V.FORMAT_CRUISE_START_DATE IS 'The formatted start date in the corresponding time zone for the given cruise (based on the earliest associated cruise leg''s start date) in MM/DD/YYYY HH24:MI:SS format';
COMMENT ON COLUMN CCD_CRUISE_DVM_RULES_RPT_V.FORMAT_CRUISE_END_DATE IS 'The formatted end date in the corresponding time zone for the given cruise (based on the latest associated cruise leg''s end date) in MM/DD/YYYY HH24:MI:SS format';






CREATE OR REPLACE View
CCD_QC_CRUISE_V
AS
SELECT
CCD_CRUISE_DELIM_V.CRUISE_ID,
CCD_CRUISE_DELIM_V.CRUISE_NAME,
CCD_CRUISE_DELIM_V.FORMAT_CRUISE_START_DATE,
CCD_CRUISE_DELIM_V.FORMAT_CRUISE_END_DATE,
CCD_CRUISE_DELIM_V.STD_SVY_NAME_OTH,
CCD_CRUISE_DELIM_V.STD_SVY_NAME,
CCD_CRUISE_DELIM_V.NUM_LEGS,
CCD_CRUISE_DELIM_V.CRUISE_DAS,
CCD_CRUISE_DELIM_V.CRUISE_LEN_DAYS,
REGEXP_SUBSTR(CCD_CRUISE_DELIM_V.CRUISE_NAME, '^[A-Z]{2}\-([0-9]{2})\-[0-9]{2}$', 1, 1, 'i', 1) CRUISE_NAME_FY,
SUBSTR(TO_CHAR(CCD_CRUISE_DELIM_V.CRUISE_FISC_YEAR), 3) CRUISE_FISC_YEAR_TRUNC,
CASE WHEN UPPER(CCD_CRUISE_DELIM_V.CRUISE_NAME) LIKE '% (COPY)%' then 'Y' ELSE 'N' END INV_CRUISE_NAME_COPY_YN,
CASE WHEN CCD_CRUISE_DELIM_V.STD_SVY_NAME_OTH IS NULL AND CCD_CRUISE_DELIM_V.STD_SVY_NAME IS NULL THEN 'Y' ELSE 'N' END MISS_STD_SVY_NAME_YN,
CASE WHEN CCD_CRUISE_DELIM_V.CRUISE_DAS <= 240 AND CCD_CRUISE_DELIM_V.CRUISE_DAS > 120 THEN 'Y' ELSE 'N' END WARN_CRUISE_DAS_YN,
CASE WHEN CCD_CRUISE_DELIM_V.CRUISE_DAS > 240 THEN 'Y' ELSE 'N' END ERR_CRUISE_DAS_YN,
CASE WHEN CCD_CRUISE_DELIM_V.CRUISE_LEN_DAYS <= 280 AND CCD_CRUISE_DELIM_V.CRUISE_LEN_DAYS > 160 THEN 'Y' ELSE 'N' END WARN_CRUISE_DATE_RNG_YN,
CASE WHEN CCD_CRUISE_DELIM_V.CRUISE_LEN_DAYS > 280 THEN 'Y' ELSE 'N' END ERR_CRUISE_DATE_RNG_YN,
CASE WHEN CCD_CRUISE_DELIM_V.NUM_PRIM_SVY_CATS = 0 THEN 'Y' ELSE 'N' END MISS_PRIM_SVY_CAT_YN,
CASE WHEN NOT REGEXP_LIKE(CCD_CRUISE_DELIM_V.CRUISE_NAME, '^[A-Z]{2}\-[0-9]{2}\-[0-9]{2}$', 'i') THEN 'Y' ELSE 'N' END INV_CRUISE_NAME_YN,
--if the CRUISE_FISC_YEAR is not null, and the CRUISE_NAME is valid, then check if the last two digits of the fiscal year don't match the extracted fiscal year
CASE WHEN (CCD_CRUISE_DELIM_V.CRUISE_FISC_YEAR IS NOT NULL AND REGEXP_LIKE(CCD_CRUISE_DELIM_V.CRUISE_NAME, '^[A-Z]{2}\-[0-9]{2}\-[0-9]{2}$', 'i') AND REGEXP_SUBSTR(CCD_CRUISE_DELIM_V.CRUISE_NAME, '^[A-Z]{2}\-([0-9]{2})\-[0-9]{2}$', 1, 1, 'i', 1) <> SUBSTR(TO_CHAR(CCD_CRUISE_DELIM_V.CRUISE_FISC_YEAR), 3)) THEN 'Y' ELSE 'N' END INV_CRUISE_NAME_FY_YN

FROM CCD_CRUISE_DELIM_V
WHERE
UPPER(CCD_CRUISE_DELIM_V.CRUISE_NAME) LIKE '% (COPY)%'
OR (CCD_CRUISE_DELIM_V.STD_SVY_NAME_OTH IS NULL AND STD_SVY_NAME IS NULL)
OR (CCD_CRUISE_DELIM_V.CRUISE_DAS <= 240 AND CCD_CRUISE_DELIM_V.CRUISE_DAS > 120)
OR (CCD_CRUISE_DELIM_V.CRUISE_DAS > 240)
OR (CCD_CRUISE_DELIM_V.CRUISE_LEN_DAYS <= 280 AND CCD_CRUISE_DELIM_V.CRUISE_LEN_DAYS > 160)
OR (CCD_CRUISE_DELIM_V.CRUISE_LEN_DAYS > 280)
OR (CCD_CRUISE_DELIM_V.NUM_PRIM_SVY_CATS = 0)
OR (NOT REGEXP_LIKE(CCD_CRUISE_DELIM_V.CRUISE_NAME, '^[A-Z]{2}\-[0-9]{2}\-[0-9]{2}$', 'i'))
OR (CCD_CRUISE_DELIM_V.CRUISE_FISC_YEAR IS NOT NULL AND REGEXP_LIKE(CCD_CRUISE_DELIM_V.CRUISE_NAME, '^[A-Z]{2}\-[0-9]{2}\-[0-9]{2}$', 'i') AND REGEXP_SUBSTR(CCD_CRUISE_DELIM_V.CRUISE_NAME, '^[A-Z]{2}\-([0-9]{2})\-[0-9]{2}$', 1, 1, 'i', 1) <> SUBSTR(TO_CHAR(CCD_CRUISE_DELIM_V.CRUISE_FISC_YEAR), 3))
ORDER BY CCD_CRUISE_DELIM_V.CRUISE_NAME, CCD_CRUISE_DELIM_V.CRUISE_START_DATE;


COMMENT ON TABLE CCD_QC_CRUISE_V IS 'Cruise (QC View)

This query identifies data validation issues with Cruises (e.g. invalid standard survey name, invalid cruise name, etc.).	This QC View is implemented in the Data Validation Module';

COMMENT ON COLUMN CCD_QC_CRUISE_V.CRUISE_ID IS 'Primary key for the CCD_CRUISES table';
COMMENT ON COLUMN CCD_QC_CRUISE_V.CRUISE_NAME IS 'The name of the given cruise designated by NOAA (e.g. SE-15-01)';
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

COMMENT ON COLUMN CCD_QC_CRUISE_V.MISS_PRIM_SVY_CAT_YN IS 'Field to indicate if there isn''t at least one Primary Survey Category defined for the given cruise (Y) or not (N)';

COMMENT ON COLUMN CCD_QC_CRUISE_V.CRUISE_NAME_FY IS 'The extracted fiscal year value from the Cruise Name based on the naming convention [SN]-[YR]-[##] where [YR] is a two digit year with a leading zero';
COMMENT ON COLUMN CCD_QC_CRUISE_V.CRUISE_FISC_YEAR_TRUNC IS 'The two digit fiscal year value derived from the Cruise''s Fiscal Year';
COMMENT ON COLUMN CCD_QC_CRUISE_V.INV_CRUISE_NAME_YN IS 'Field to indicate if the Cruise Name is valid (Y) or not (N) based on the required naming convention [SN]-[YR]-[##] where [SN] is a valid NOAA ship name, [YR] is a two digit year with a leading zero, and [##] is a sequential number with a leading zero';
COMMENT ON COLUMN CCD_QC_CRUISE_V.INV_CRUISE_NAME_FY_YN IS 'Field to indicate if the Cruise Name''s extracted Fiscal Year value matches the Cruise''s Fiscal Year (Y) or not (N) based on the Cruise Name naming convention [SN]-[YR]-[##] where [YR] is a two digit year with a leading zero';


COMMENT ON COLUMN CCD_QC_CRUISE_V.FORMAT_CRUISE_START_DATE IS 'The formatted start date in the corresponding time zone for the given cruise (based on the earliest associated cruise leg''s start date) in MM/DD/YYYY HH24:MI:SS format';
COMMENT ON COLUMN CCD_QC_CRUISE_V.FORMAT_CRUISE_END_DATE IS 'The formatted end date in the corresponding time zone for the given cruise (based on the latest associated cruise leg''s end date) in MM/DD/YYYY HH24:MI:SS format';





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
CCD_CRUISE_LEG_V V1 INNER JOIN
CCD_CRUISE_LEG_V V2
ON
--join on the same vessel or same cruise:
(V1.VESSEL_ID = V2.VESSEL_ID OR V1.CRUISE_ID = V2.CRUISE_ID)
--don't allow joins on cruise legs to itself
AND V1.CRUISE_LEG_ID <> V2.CRUISE_LEG_ID
WHERE
V1.LEG_START_DATE BETWEEN	V2.LEG_START_DATE AND V2.LEG_END_DATE
OR
V1.LEG_END_DATE BETWEEN	V2.LEG_START_DATE AND V2.LEG_END_DATE
OR
V2.LEG_START_DATE BETWEEN	V1.LEG_START_DATE AND V1.LEG_END_DATE
OR
V2.LEG_END_DATE BETWEEN	V1.LEG_START_DATE AND V1.LEG_END_DATE


ORDER BY V1.CRUISE_NAME, V1.LEG_NAME, V1.LEG_START_DATE, V1.CRUISE_ID, V1.CRUISE_LEG_ID;

COMMENT ON TABLE CCD_QC_LEG_OVERLAP_V IS 'Cruise Leg Overlap (QC View)

This query identifies data validation issues based on the cruise leg dates (e.g. cruise legs overlap, vessel legs overlap).	This QC View is implemented in the Data Validation Module';

COMMENT ON COLUMN CCD_QC_LEG_OVERLAP_V.CRUISE_ID IS 'Primary key for the first CCD_CRUISES record';
COMMENT ON COLUMN CCD_QC_LEG_OVERLAP_V.CRUISE_NAME1 IS 'The name of the first cruise designated by NOAA (e.g. SE-15-01)';
COMMENT ON COLUMN CCD_QC_LEG_OVERLAP_V.CRUISE_LEG_ID1 IS 'Primary key for the first CCD_CRUISE_LEGS record';
COMMENT ON COLUMN CCD_QC_LEG_OVERLAP_V.LEG_NAME1 IS 'The name of the first cruise leg';
COMMENT ON COLUMN CCD_QC_LEG_OVERLAP_V.VESSEL_NAME1 IS 'Name of the given research vessel for the first cruise leg';
COMMENT ON COLUMN CCD_QC_LEG_OVERLAP_V.CRUISE_ID2 IS 'Primary key for the second CCD_CRUISES record';
COMMENT ON COLUMN CCD_QC_LEG_OVERLAP_V.CRUISE_NAME2 IS 'The name of the second cruise designated by NOAA (e.g. SE-15-01)';
COMMENT ON COLUMN CCD_QC_LEG_OVERLAP_V.CRUISE_LEG_ID2 IS 'Primary key for the second CCD_CRUISE_LEGS record';
COMMENT ON COLUMN CCD_QC_LEG_OVERLAP_V.LEG_NAME2 IS 'The name of the second cruise leg';
COMMENT ON COLUMN CCD_QC_LEG_OVERLAP_V.VESSEL_NAME2 IS 'Name of the given research vessel for the second cruise leg';
COMMENT ON COLUMN CCD_QC_LEG_OVERLAP_V.CRUISE_OVERLAP_YN IS 'Field to indicate if there is an Vessel Leg Overlap error (Y) or not (N) based on whether or not two cruise leg dates for the same cruise overlap with each other';
COMMENT ON COLUMN CCD_QC_LEG_OVERLAP_V.VESSEL_OVERLAP_YN IS 'Field to indicate if there is an Vessel Leg Overlap error (Y) or not (N) based on whether or not two cruise leg dates for the same vessel overlap with each other';





COMMENT ON COLUMN CCD_QC_LEG_OVERLAP_V.FORMAT_LEG_START_DATE1 IS 'The start date in the corresponding time zone for the first research cruise leg in MM/DD/YYYY format';
COMMENT ON COLUMN CCD_QC_LEG_OVERLAP_V.FORMAT_LEG_END_DATE1 IS 'The end date in the corresponding time zone for the first research cruise leg in MM/DD/YYYY format';

COMMENT ON COLUMN CCD_QC_LEG_OVERLAP_V.FORMAT_LEG_START_DATE2 IS 'The start date in the corresponding time zone for the second research cruise leg in MM/DD/YYYY format';
COMMENT ON COLUMN CCD_QC_LEG_OVERLAP_V.FORMAT_LEG_END_DATE2 IS 'The end date in the corresponding time zone for the second research cruise leg in MM/DD/YYYY format';







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






--verification query to compare the cruise, cruise legs, and associated attributes to determine if a CCD_CRUISE_PKG.DEEP_COPY_CRUISE_SP procedure call was successful
CREATE OR REPLACE VIEW CCD_CCDP_DEEP_COPY_CMP_V AS
select v_orig.cruise_name orig_cruise_name, v_copy.cruise_name copy_cruise_name, v_orig.leg_name orig_leg_name, v_copy.leg_name copy_leg_name,
(CASE WHEN


 (v_orig.CRUISE_NOTES =	v_copy.CRUISE_NOTES OR (v_orig.CRUISE_NOTES IS NULL AND v_copy.CRUISE_NOTES IS NULL))
 AND (dbms_lob.substr( v_orig.CRUISE_DESC, 4000, 1 ) =	dbms_lob.substr( v_copy.CRUISE_DESC, 4000, 1 ) OR (v_orig.CRUISE_DESC IS NULL AND v_copy.CRUISE_DESC IS NULL))
 AND (v_orig.OBJ_BASED_METRICS =	v_copy.OBJ_BASED_METRICS OR (v_orig.OBJ_BASED_METRICS IS NULL AND v_copy.OBJ_BASED_METRICS IS NULL))
 AND (v_orig.SCI_CENTER_DIV_ID =	v_copy.SCI_CENTER_DIV_ID OR (v_orig.SCI_CENTER_DIV_ID IS NULL AND v_copy.SCI_CENTER_DIV_ID IS NULL))
 AND (v_orig.SCI_CENTER_DIV_CODE =	v_copy.SCI_CENTER_DIV_CODE OR (v_orig.SCI_CENTER_DIV_CODE IS NULL AND v_copy.SCI_CENTER_DIV_CODE IS NULL))
 AND (v_orig.SCI_CENTER_DIV_NAME =	v_copy.SCI_CENTER_DIV_NAME OR (v_orig.SCI_CENTER_DIV_NAME IS NULL AND v_copy.SCI_CENTER_DIV_NAME IS NULL))
 AND (v_orig.SCI_CENTER_DIV_DESC =	v_copy.SCI_CENTER_DIV_DESC OR (v_orig.SCI_CENTER_DIV_DESC IS NULL AND v_copy.SCI_CENTER_DIV_DESC IS NULL))
 AND (v_orig.SCI_CENTER_ID =	v_copy.SCI_CENTER_ID OR (v_orig.SCI_CENTER_ID IS NULL AND v_copy.SCI_CENTER_ID IS NULL))
 AND (v_orig.SCI_CENTER_NAME =	v_copy.SCI_CENTER_NAME OR (v_orig.SCI_CENTER_NAME IS NULL AND v_copy.SCI_CENTER_NAME IS NULL))
 AND (v_orig.SCI_CENTER_DESC =	v_copy.SCI_CENTER_DESC OR (v_orig.SCI_CENTER_DESC IS NULL AND v_copy.SCI_CENTER_DESC IS NULL))
 AND (v_orig.STD_SVY_NAME_ID =	v_copy.STD_SVY_NAME_ID OR (v_orig.STD_SVY_NAME_ID IS NULL AND v_copy.STD_SVY_NAME_ID IS NULL))
 AND (v_orig.STD_SVY_NAME =	v_copy.STD_SVY_NAME OR (v_orig.STD_SVY_NAME IS NULL AND v_copy.STD_SVY_NAME IS NULL))
 AND (v_orig.STD_SVY_DESC =	v_copy.STD_SVY_DESC OR (v_orig.STD_SVY_DESC IS NULL AND v_copy.STD_SVY_DESC IS NULL))
 AND (v_orig.SVY_FREQ_ID =	v_copy.SVY_FREQ_ID OR (v_orig.SVY_FREQ_ID IS NULL AND v_copy.SVY_FREQ_ID IS NULL))
 AND (v_orig.SVY_FREQ_NAME =	v_copy.SVY_FREQ_NAME OR (v_orig.SVY_FREQ_NAME IS NULL AND v_copy.SVY_FREQ_NAME IS NULL))
 AND (v_orig.SVY_FREQ_DESC =	v_copy.SVY_FREQ_DESC OR (v_orig.SVY_FREQ_DESC IS NULL AND v_copy.SVY_FREQ_DESC IS NULL))
 AND (v_orig.STD_SVY_NAME_OTH =	v_copy.STD_SVY_NAME_OTH OR (v_orig.STD_SVY_NAME_OTH IS NULL AND v_copy.STD_SVY_NAME_OTH IS NULL))
 AND (v_orig.STD_SVY_NAME_VAL =	v_copy.STD_SVY_NAME_VAL OR (v_orig.STD_SVY_NAME_VAL IS NULL AND v_copy.STD_SVY_NAME_VAL IS NULL))
 AND (v_orig.SVY_TYPE_ID =	v_copy.SVY_TYPE_ID OR (v_orig.SVY_TYPE_ID IS NULL AND v_copy.SVY_TYPE_ID IS NULL))
 AND (v_orig.SVY_TYPE_NAME =	v_copy.SVY_TYPE_NAME OR (v_orig.SVY_TYPE_NAME IS NULL AND v_copy.SVY_TYPE_NAME IS NULL))
 AND (v_orig.SVY_TYPE_DESC =	v_copy.SVY_TYPE_DESC OR (v_orig.SVY_TYPE_DESC IS NULL AND v_copy.SVY_TYPE_DESC IS NULL))
 AND (v_orig.CRUISE_URL =	v_copy.CRUISE_URL OR (v_orig.CRUISE_URL IS NULL AND v_copy.CRUISE_URL IS NULL))
 AND (v_orig.CRUISE_CONT_EMAIL =	v_copy.CRUISE_CONT_EMAIL OR (v_orig.CRUISE_CONT_EMAIL IS NULL AND v_copy.CRUISE_CONT_EMAIL IS NULL))
 AND (v_orig.NUM_LEGS =	v_copy.NUM_LEGS OR (v_orig.NUM_LEGS IS NULL AND v_copy.NUM_LEGS IS NULL))
 AND (v_orig.CRUISE_START_DATE =	v_copy.CRUISE_START_DATE OR (v_orig.CRUISE_START_DATE IS NULL AND v_copy.CRUISE_START_DATE IS NULL))
 AND (v_orig.FORMAT_CRUISE_START_DATE =	v_copy.FORMAT_CRUISE_START_DATE OR (v_orig.FORMAT_CRUISE_START_DATE IS NULL AND v_copy.FORMAT_CRUISE_START_DATE IS NULL))
 AND (v_orig.CRUISE_END_DATE =	v_copy.CRUISE_END_DATE OR (v_orig.CRUISE_END_DATE IS NULL AND v_copy.CRUISE_END_DATE IS NULL))
 AND (v_orig.FORMAT_CRUISE_END_DATE =	v_copy.FORMAT_CRUISE_END_DATE OR (v_orig.FORMAT_CRUISE_END_DATE IS NULL AND v_copy.FORMAT_CRUISE_END_DATE IS NULL))
 AND (v_orig.CRUISE_DAS =	v_copy.CRUISE_DAS OR (v_orig.CRUISE_DAS IS NULL AND v_copy.CRUISE_DAS IS NULL))
 AND (v_orig.CRUISE_LEN_DAYS =	v_copy.CRUISE_LEN_DAYS OR (v_orig.CRUISE_LEN_DAYS IS NULL AND v_copy.CRUISE_LEN_DAYS IS NULL))
 AND (v_orig.CRUISE_YEAR =	v_copy.CRUISE_YEAR OR (v_orig.CRUISE_YEAR IS NULL AND v_copy.CRUISE_YEAR IS NULL))
 AND (v_orig.CRUISE_FISC_YEAR =	v_copy.CRUISE_FISC_YEAR OR (v_orig.CRUISE_FISC_YEAR IS NULL AND v_copy.CRUISE_FISC_YEAR IS NULL))
-- AND (v_orig.LEG_NAME_RC_LIST =	v_copy.LEG_NAME_RC_LIST OR (v_orig.LEG_NAME_RC_LIST IS NULL AND v_copy.LEG_NAME_RC_LIST IS NULL))
-- AND (v_orig.LEG_NAME_DATES_RC_LIST =	v_copy.LEG_NAME_DATES_RC_LIST OR (v_orig.LEG_NAME_DATES_RC_LIST IS NULL AND v_copy.LEG_NAME_DATES_RC_LIST IS NULL))
 AND (v_orig.NUM_SPP_ESA =	v_copy.NUM_SPP_ESA OR (v_orig.NUM_SPP_ESA IS NULL AND v_copy.NUM_SPP_ESA IS NULL))
 AND (v_orig.SPP_ESA_NAME_RC_LIST =	v_copy.SPP_ESA_NAME_RC_LIST OR (v_orig.SPP_ESA_NAME_RC_LIST IS NULL AND v_copy.SPP_ESA_NAME_RC_LIST IS NULL))
 AND (v_orig.NUM_SPP_FSSI =	v_copy.NUM_SPP_FSSI OR (v_orig.NUM_SPP_FSSI IS NULL AND v_copy.NUM_SPP_FSSI IS NULL))
 AND (v_orig.SPP_FSSI_NAME_RC_LIST =	v_copy.SPP_FSSI_NAME_RC_LIST OR (v_orig.SPP_FSSI_NAME_RC_LIST IS NULL AND v_copy.SPP_FSSI_NAME_RC_LIST IS NULL))
 AND (v_orig.NUM_SPP_MMPA =	v_copy.NUM_SPP_MMPA OR (v_orig.NUM_SPP_MMPA IS NULL AND v_copy.NUM_SPP_MMPA IS NULL))
 AND (v_orig.SPP_MMPA_NAME_RC_LIST =	v_copy.SPP_MMPA_NAME_RC_LIST OR (v_orig.SPP_MMPA_NAME_RC_LIST IS NULL AND v_copy.SPP_MMPA_NAME_RC_LIST IS NULL))
 AND (v_orig.NUM_PRIM_SVY_CATS =	v_copy.NUM_PRIM_SVY_CATS OR (v_orig.NUM_PRIM_SVY_CATS IS NULL AND v_copy.NUM_PRIM_SVY_CATS IS NULL))
 AND (v_orig.PRIM_SVY_CAT_NAME_RC_LIST =	v_copy.PRIM_SVY_CAT_NAME_RC_LIST OR (v_orig.PRIM_SVY_CAT_NAME_RC_LIST IS NULL AND v_copy.PRIM_SVY_CAT_NAME_RC_LIST IS NULL))
 AND (v_orig.NUM_SEC_SVY_CATS =	v_copy.NUM_SEC_SVY_CATS OR (v_orig.NUM_SEC_SVY_CATS IS NULL AND v_copy.NUM_SEC_SVY_CATS IS NULL))
 AND (v_orig.SEC_SVY_CAT_NAME_RC_LIST =	v_copy.SEC_SVY_CAT_NAME_RC_LIST OR (v_orig.SEC_SVY_CAT_NAME_RC_LIST IS NULL AND v_copy.SEC_SVY_CAT_NAME_RC_LIST IS NULL))
 AND (v_orig.NUM_EXP_SPP =	v_copy.NUM_EXP_SPP OR (v_orig.NUM_EXP_SPP IS NULL AND v_copy.NUM_EXP_SPP IS NULL))
 AND (v_orig.EXP_SPP_NAME_RC_LIST =	v_copy.EXP_SPP_NAME_RC_LIST OR (v_orig.EXP_SPP_NAME_RC_LIST IS NULL AND v_copy.EXP_SPP_NAME_RC_LIST IS NULL))
 AND (v_orig.NUM_SPP_OTH =	v_copy.NUM_SPP_OTH OR (v_orig.NUM_SPP_OTH IS NULL AND v_copy.NUM_SPP_OTH IS NULL))
 AND (v_orig.OTH_SPP_CNAME_RC_LIST =	v_copy.OTH_SPP_CNAME_RC_LIST OR (v_orig.OTH_SPP_CNAME_RC_LIST IS NULL AND v_copy.OTH_SPP_CNAME_RC_LIST IS NULL))
 AND (v_orig.OTH_SPP_SNAME_RC_LIST =	v_copy.OTH_SPP_SNAME_RC_LIST OR (v_orig.OTH_SPP_SNAME_RC_LIST IS NULL AND v_copy.OTH_SPP_SNAME_RC_LIST IS NULL))
 --AND (v_orig.CRUISE_LEG_ID =	v_copy.CRUISE_LEG_ID OR (v_orig.CRUISE_LEG_ID IS NULL AND v_copy.CRUISE_LEG_ID IS NULL))
 AND (v_orig.LEG_NAME || ' (copy)' =	v_copy.LEG_NAME OR (v_orig.LEG_NAME IS NULL AND v_copy.LEG_NAME IS NULL))
 AND (v_orig.LEG_START_DATE =	v_copy.LEG_START_DATE OR (v_orig.LEG_START_DATE IS NULL AND v_copy.LEG_START_DATE IS NULL))
 AND (v_orig.FORMAT_LEG_START_DATE =	v_copy.FORMAT_LEG_START_DATE OR (v_orig.FORMAT_LEG_START_DATE IS NULL AND v_copy.FORMAT_LEG_START_DATE IS NULL))
 AND (v_orig.LEG_END_DATE =	v_copy.LEG_END_DATE OR (v_orig.LEG_END_DATE IS NULL AND v_copy.LEG_END_DATE IS NULL))
 AND (v_orig.FORMAT_LEG_END_DATE =	v_copy.FORMAT_LEG_END_DATE OR (v_orig.FORMAT_LEG_END_DATE IS NULL AND v_copy.FORMAT_LEG_END_DATE IS NULL))
 AND (v_orig.LEG_DAS =	v_copy.LEG_DAS OR (v_orig.LEG_DAS IS NULL AND v_copy.LEG_DAS IS NULL))
 AND (v_orig.LEG_YEAR =	v_copy.LEG_YEAR OR (v_orig.LEG_YEAR IS NULL AND v_copy.LEG_YEAR IS NULL))
 AND (v_orig.LEG_FISC_YEAR =	v_copy.LEG_FISC_YEAR OR (v_orig.LEG_FISC_YEAR IS NULL AND v_copy.LEG_FISC_YEAR IS NULL))
 AND (v_orig.LEG_DESC =	v_copy.LEG_DESC OR (v_orig.LEG_DESC IS NULL AND v_copy.LEG_DESC IS NULL))
 AND (v_orig.VESSEL_ID =	v_copy.VESSEL_ID OR (v_orig.VESSEL_ID IS NULL AND v_copy.VESSEL_ID IS NULL))
 AND (v_orig.VESSEL_NAME =	v_copy.VESSEL_NAME OR (v_orig.VESSEL_NAME IS NULL AND v_copy.VESSEL_NAME IS NULL))
 AND (v_orig.VESSEL_DESC =	v_copy.VESSEL_DESC OR (v_orig.VESSEL_DESC IS NULL AND v_copy.VESSEL_DESC IS NULL))
 AND (v_orig.PLAT_TYPE_ID =	v_copy.PLAT_TYPE_ID OR (v_orig.PLAT_TYPE_ID IS NULL AND v_copy.PLAT_TYPE_ID IS NULL))
 AND (v_orig.PLAT_TYPE_NAME =	v_copy.PLAT_TYPE_NAME OR (v_orig.PLAT_TYPE_NAME IS NULL AND v_copy.PLAT_TYPE_NAME IS NULL))
 AND (v_orig.PLAT_TYPE_DESC =	v_copy.PLAT_TYPE_DESC OR (v_orig.PLAT_TYPE_DESC IS NULL AND v_copy.PLAT_TYPE_DESC IS NULL))
 AND (v_orig.NUM_REG_ECOSYSTEMS =	v_copy.NUM_REG_ECOSYSTEMS OR (v_orig.NUM_REG_ECOSYSTEMS IS NULL AND v_copy.NUM_REG_ECOSYSTEMS IS NULL))
 AND (v_orig.REG_ECOSYSTEM_RC_LIST =	v_copy.REG_ECOSYSTEM_RC_LIST OR (v_orig.REG_ECOSYSTEM_RC_LIST IS NULL AND v_copy.REG_ECOSYSTEM_RC_LIST IS NULL))
 AND (v_orig.NUM_GEAR =	v_copy.NUM_GEAR OR (v_orig.NUM_GEAR IS NULL AND v_copy.NUM_GEAR IS NULL))
 AND (v_orig.GEAR_NAME_RC_LIST =	v_copy.GEAR_NAME_RC_LIST OR (v_orig.GEAR_NAME_RC_LIST IS NULL AND v_copy.GEAR_NAME_RC_LIST IS NULL))
 AND (v_orig.NUM_DATA_SETS =	v_copy.NUM_DATA_SETS OR (v_orig.NUM_DATA_SETS IS NULL AND v_copy.NUM_DATA_SETS IS NULL))
 AND (v_orig.DATA_SET_NAME_RC_LIST =	v_copy.DATA_SET_NAME_RC_LIST OR (v_orig.DATA_SET_NAME_RC_LIST IS NULL AND v_copy.DATA_SET_NAME_RC_LIST IS NULL))
 AND (v_orig.NUM_REGIONS =	v_copy.NUM_REGIONS OR (v_orig.NUM_REGIONS IS NULL AND v_copy.NUM_REGIONS IS NULL))
 AND (v_orig.REGION_CODE_RC_LIST =	v_copy.REGION_CODE_RC_LIST OR (v_orig.REGION_CODE_RC_LIST IS NULL AND v_copy.REGION_CODE_RC_LIST IS NULL))
 AND (v_orig.REGION_NAME_RC_LIST =	v_copy.REGION_NAME_RC_LIST OR (v_orig.REGION_NAME_RC_LIST IS NULL AND v_copy.REGION_NAME_RC_LIST IS NULL))
 AND (v_orig.NUM_LEG_ALIASES =	v_copy.NUM_LEG_ALIASES OR (v_orig.NUM_LEG_ALIASES IS NULL AND v_copy.NUM_LEG_ALIASES IS NULL))
 AND (REPLACE(v_orig.LEG_ALIAS_RC_LIST, chr(10), ' (copy)'||chr(10))||' (copy)' =	v_copy.LEG_ALIAS_RC_LIST OR (v_orig.LEG_ALIAS_RC_LIST IS NULL AND v_copy.LEG_ALIAS_RC_LIST IS NULL))
 AND (v_orig.TZ_NAME = v_copy.TZ_NAME)
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

This verification query retrieves all cruise information and associated attributes and associated cruise legs and associated attributes for all deep copies of cruises based on the "(copy)" naming convention for cruise names, leg names, and leg alias names.	This view is utilized to determine if a given CCD_CRUISE_PKG.DEEP_COPY_CRUISE_SP procedure call was successful';

COMMENT ON COLUMN CCD_CCDP_DEEP_COPY_CMP_V.VALUES_EQUAL_YN IS 'Flag to indicate if the cruise attributes, cruise legs, and cruise leg attributes for each cruise that was copied using the Deep Copy functionality all match (Y) or if they do not match (N)';


COMMENT ON COLUMN CCD_CCDP_DEEP_COPY_CMP_V.ORIG_CRUISE_NAME IS 'The Name of the Cruise that was copied by the Deep Copy procedure';
COMMENT ON COLUMN CCD_CCDP_DEEP_COPY_CMP_V.COPY_CRUISE_NAME IS 'The Name of the Cruise that was created by the Deep Copy procedure';
COMMENT ON COLUMN CCD_CCDP_DEEP_COPY_CMP_V.ORIG_LEG_NAME IS 'The Name of the Cruise Leg that was copied by the Deep Copy procedure';
COMMENT ON COLUMN CCD_CCDP_DEEP_COPY_CMP_V.COPY_LEG_NAME IS 'The Name of the Cruise Leg that was created by the Deep Copy procedure';










CREATE OR REPLACE VIEW
CCD_CRUISE_LEG_DATA_SETS_V

AS SELECT

CCD_CRUISE_AGG_V.CRUISE_ID,
CCD_CRUISE_AGG_V.CRUISE_NAME,
CCD_CRUISE_AGG_V.CRUISE_NOTES,
CCD_CRUISE_AGG_V.CRUISE_DESC,
CCD_CRUISE_AGG_V.OBJ_BASED_METRICS,
CCD_CRUISE_AGG_V.SCI_CENTER_DIV_ID,
CCD_CRUISE_AGG_V.SCI_CENTER_DIV_CODE,
CCD_CRUISE_AGG_V.SCI_CENTER_DIV_NAME,
CCD_CRUISE_AGG_V.SCI_CENTER_DIV_DESC,
CCD_CRUISE_AGG_V.SCI_CENTER_ID,
CCD_CRUISE_AGG_V.SCI_CENTER_NAME,
CCD_CRUISE_AGG_V.SCI_CENTER_DESC,
CCD_CRUISE_AGG_V.STD_SVY_NAME_ID,
CCD_CRUISE_AGG_V.STD_SVY_NAME,
CCD_CRUISE_AGG_V.STD_SVY_DESC,
CCD_CRUISE_AGG_V.SVY_FREQ_ID,
CCD_CRUISE_AGG_V.SVY_FREQ_NAME,
CCD_CRUISE_AGG_V.SVY_FREQ_DESC,
CCD_CRUISE_AGG_V.STD_SVY_NAME_OTH,
CCD_CRUISE_AGG_V.STD_SVY_NAME_VAL,
CCD_CRUISE_AGG_V.SVY_TYPE_ID,
CCD_CRUISE_AGG_V.SVY_TYPE_NAME,
CCD_CRUISE_AGG_V.SVY_TYPE_DESC,
CCD_CRUISE_AGG_V.CRUISE_URL,
CCD_CRUISE_AGG_V.CRUISE_CONT_EMAIL,
CCD_CRUISE_AGG_V.PTA_ISS_ID,
CCD_CRUISE_AGG_V.NUM_LEGS,
CCD_CRUISE_AGG_V.CRUISE_START_DATE,
CCD_CRUISE_AGG_V.FORMAT_CRUISE_START_DATE,
CCD_CRUISE_AGG_V.CRUISE_END_DATE,
CCD_CRUISE_AGG_V.FORMAT_CRUISE_END_DATE,
CCD_CRUISE_AGG_V.CRUISE_DAS,
CCD_CRUISE_AGG_V.CRUISE_LEN_DAYS,
CCD_CRUISE_AGG_V.CRUISE_YEAR,
CCD_CRUISE_AGG_V.CRUISE_FISC_YEAR,
CCD_CRUISE_AGG_V.LEG_NAME_CD_LIST,
CCD_CRUISE_AGG_V.LEG_NAME_SCD_LIST,
CCD_CRUISE_AGG_V.LEG_NAME_RC_LIST,
CCD_CRUISE_AGG_V.LEG_NAME_BR_LIST,
CCD_CRUISE_AGG_V.LEG_NAME_DATES_CD_LIST,
CCD_CRUISE_AGG_V.LEG_NAME_DATES_SCD_LIST,
CCD_CRUISE_AGG_V.LEG_NAME_DATES_RC_LIST,
CCD_CRUISE_AGG_V.LEG_NAME_DATES_BR_LIST,
CCD_CRUISE_AGG_V.LEG_VESS_NAME_DATES_CD_LIST,
CCD_CRUISE_AGG_V.LEG_VESS_NAME_DATES_SCD_LIST,
CCD_CRUISE_AGG_V.LEG_VESS_NAME_DATES_RC_LIST,
CCD_CRUISE_AGG_V.LEG_VESS_NAME_DATES_BR_LIST,

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
CCD_LEG_DELIM_V.TZ_NAME,
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
CCD_LEG_DELIM_V.DATA_SET_NAME_BR_LIST,
CCD_LEG_DATA_SETS_V.LEG_DATA_SET_ID,
CCD_LEG_DATA_SETS_V.DATA_SET_ID,
CCD_LEG_DATA_SETS_V.LEG_DATA_SET_NOTES,
CCD_LEG_DATA_SETS_V.DATA_SET_NAME,
CCD_LEG_DATA_SETS_V.DATA_SET_DESC,
CCD_LEG_DATA_SETS_V.DATA_SET_INPORT_CAT_ID,
CCD_LEG_DATA_SETS_V.DATA_SET_INPORT_URL,
CCD_LEG_DATA_SETS_V.DATA_SET_TYPE_ID,
CCD_LEG_DATA_SETS_V.DATA_SET_TYPE_NAME,
CCD_LEG_DATA_SETS_V.DATA_SET_TYPE_DESC,
CCD_LEG_DATA_SETS_V.DATA_SET_TYPE_DOC_URL,
CCD_LEG_DATA_SETS_V.DATA_SET_STATUS_ID,
CCD_LEG_DATA_SETS_V.STATUS_CODE,
CCD_LEG_DATA_SETS_V.STATUS_NAME,
CCD_LEG_DATA_SETS_V.STATUS_DESC,
CCD_LEG_DATA_SETS_V.STATUS_COLOR




FROM
CCD_CRUISE_AGG_V INNER JOIN
CCD_LEG_DELIM_V ON CCD_CRUISE_AGG_V.CRUISE_ID = CCD_LEG_DELIM_V.CRUISE_ID
INNER JOIN CCD_LEG_DATA_SETS_V ON CCD_LEG_DATA_SETS_V.CRUISE_LEG_ID = CCD_LEG_DELIM_V.CRUISE_LEG_ID
ORDER BY
CCD_LEG_DELIM_V.LEG_START_DATE,
CCD_LEG_DELIM_V.LEG_NAME,
CCD_LEG_DELIM_V.VESSEL_NAME,
CCD_LEG_DATA_SETS_V.DATA_SET_NAME
;



COMMENT ON TABLE CCD_CRUISE_LEG_DATA_SETS_V IS 'Cruise Leg Data Sets (View)

This query returns all of the cruise legs and associated delimited values as well as their associated data sets in separate rows including all associated reference table information.	Each data set associated with a given cruise leg is represented by a separate result set row';


COMMENT ON COLUMN CCD_CRUISE_LEG_DATA_SETS_V.CRUISE_ID IS 'Primary key for the CCD_CRUISES table';
COMMENT ON COLUMN CCD_CRUISE_LEG_DATA_SETS_V.CRUISE_NAME IS 'The name of the given cruise designated by NOAA (e.g. SE-15-01)';
COMMENT ON COLUMN CCD_CRUISE_LEG_DATA_SETS_V.CRUISE_NOTES IS 'Any notes for the given research cruise';
COMMENT ON COLUMN CCD_CRUISE_LEG_DATA_SETS_V.CRUISE_DESC IS 'Description for the given research cruise';
COMMENT ON COLUMN CCD_CRUISE_LEG_DATA_SETS_V.OBJ_BASED_METRICS IS 'Objective Based Metrics for the given research cruise';
COMMENT ON COLUMN CCD_CRUISE_LEG_DATA_SETS_V.SCI_CENTER_DIV_ID IS 'Primary key for the Science Center Division table';
COMMENT ON COLUMN CCD_CRUISE_LEG_DATA_SETS_V.SCI_CENTER_DIV_CODE IS 'Abbreviated code for the given Science Center Division';
COMMENT ON COLUMN CCD_CRUISE_LEG_DATA_SETS_V.SCI_CENTER_DIV_NAME IS 'Name of the given Science Center Division';
COMMENT ON COLUMN CCD_CRUISE_LEG_DATA_SETS_V.SCI_CENTER_DIV_DESC IS 'Description for the given Science Center Division';
COMMENT ON COLUMN CCD_CRUISE_LEG_DATA_SETS_V.SCI_CENTER_ID IS 'Primary key for the Science Center table';
COMMENT ON COLUMN CCD_CRUISE_LEG_DATA_SETS_V.SCI_CENTER_NAME IS 'Name of the given Science Center';
COMMENT ON COLUMN CCD_CRUISE_LEG_DATA_SETS_V.SCI_CENTER_DESC IS 'Description for the given Science Center';
COMMENT ON COLUMN CCD_CRUISE_LEG_DATA_SETS_V.STD_SVY_NAME_ID IS 'Primary key for the Standard Survey Name table';
COMMENT ON COLUMN CCD_CRUISE_LEG_DATA_SETS_V.STD_SVY_NAME IS 'Name of the given Standard Survey Name';
COMMENT ON COLUMN CCD_CRUISE_LEG_DATA_SETS_V.STD_SVY_DESC IS 'Description for the given Standard Survey Name';
COMMENT ON COLUMN CCD_CRUISE_LEG_DATA_SETS_V.SVY_FREQ_ID IS 'Primary key for the Survey Frequency table';
COMMENT ON COLUMN CCD_CRUISE_LEG_DATA_SETS_V.SVY_FREQ_NAME IS 'Name of the given Survey Frequency';
COMMENT ON COLUMN CCD_CRUISE_LEG_DATA_SETS_V.SVY_FREQ_DESC IS 'Description for the given Survey Frequency';
COMMENT ON COLUMN CCD_CRUISE_LEG_DATA_SETS_V.STD_SVY_NAME_OTH IS 'Field defines a Standard Survey Name that is not included in the Standard Survey Name table';
COMMENT ON COLUMN CCD_CRUISE_LEG_DATA_SETS_V.STD_SVY_NAME_VAL IS 'This field contains the Standard Survey Name defined for the given cruise.	If the STD_SVY_NAME_ID field is defined then the associated CCD_STD_SVY_NAMES.STD_SVY_NAME is used because the foreign key is given precedence, otherwise the STD_SVY_NAME_OTH field value is used';
COMMENT ON COLUMN CCD_CRUISE_LEG_DATA_SETS_V.SVY_TYPE_ID IS 'Primary key for the Survey Type table';
COMMENT ON COLUMN CCD_CRUISE_LEG_DATA_SETS_V.SVY_TYPE_NAME IS 'Name of the given Survey Type';
COMMENT ON COLUMN CCD_CRUISE_LEG_DATA_SETS_V.SVY_TYPE_DESC IS 'Description for the given Survey Type';
COMMENT ON COLUMN CCD_CRUISE_LEG_DATA_SETS_V.CRUISE_URL IS 'The Cruise URL (Referred to as "Survey URL" in FINSS System) for the given Cruise';
COMMENT ON COLUMN CCD_CRUISE_LEG_DATA_SETS_V.CRUISE_CONT_EMAIL IS 'The Cruise Contact Email (Referred to as "Survey Contact Email" in FINSS System) for the given Cruise';
COMMENT ON COLUMN CCD_CRUISE_LEG_DATA_SETS_V.PTA_ISS_ID IS 'Foreign key reference to the Issues (PTA) intersection table';
COMMENT ON COLUMN CCD_CRUISE_LEG_DATA_SETS_V.NUM_LEGS IS 'The number of cruise legs associated with the given cruise';
COMMENT ON COLUMN CCD_CRUISE_LEG_DATA_SETS_V.CRUISE_START_DATE IS 'The start date in the corresponding time zone for the given cruise (based on the earliest associated cruise leg''s start date)';
COMMENT ON COLUMN CCD_CRUISE_LEG_DATA_SETS_V.FORMAT_CRUISE_START_DATE IS 'The formatted start date in the corresponding time zone for the given cruise (based on the earliest associated cruise leg''s start date) in MM/DD/YYYY HH24:MI:SS format';
COMMENT ON COLUMN CCD_CRUISE_LEG_DATA_SETS_V.CRUISE_END_DATE IS 'The end date in the corresponding time zone for the given cruise (based on the latest associated cruise leg''s end date)';
COMMENT ON COLUMN CCD_CRUISE_LEG_DATA_SETS_V.FORMAT_CRUISE_END_DATE IS 'The formatted end date in the corresponding time zone for the given cruise (based on the latest associated cruise leg''s end date) in MM/DD/YYYY HH24:MI:SS format';
COMMENT ON COLUMN CCD_CRUISE_LEG_DATA_SETS_V.CRUISE_DAS IS 'The total number of days at sea for each of the legs associated with the given cruise';
COMMENT ON COLUMN CCD_CRUISE_LEG_DATA_SETS_V.CRUISE_LEN_DAYS IS 'The total number of days between the Cruise Start and End Dates for the given cruise';
COMMENT ON COLUMN CCD_CRUISE_LEG_DATA_SETS_V.CRUISE_YEAR IS 'The calendar year for the given cruise (based on the earliest associated cruise leg''s start date)';
COMMENT ON COLUMN CCD_CRUISE_LEG_DATA_SETS_V.CRUISE_FISC_YEAR IS 'The calendar year for the given cruise (based on the earliest associated cruise leg''s start date)';
COMMENT ON COLUMN CCD_CRUISE_LEG_DATA_SETS_V.LEG_NAME_CD_LIST IS 'Comma-delimited list of leg names associated with the given cruise';
COMMENT ON COLUMN CCD_CRUISE_LEG_DATA_SETS_V.LEG_NAME_SCD_LIST IS 'Semicolon-delimited list of leg names associated with the given cruise';
COMMENT ON COLUMN CCD_CRUISE_LEG_DATA_SETS_V.LEG_NAME_RC_LIST IS 'Return carriage/new line delimited list of leg names associated with the given cruise';
COMMENT ON COLUMN CCD_CRUISE_LEG_DATA_SETS_V.LEG_NAME_BR_LIST IS '<BR> tag (intended for web pages) delimited list of leg names associated with the given cruise';
COMMENT ON COLUMN CCD_CRUISE_LEG_DATA_SETS_V.LEG_NAME_DATES_CD_LIST IS 'Comma-delimited list of leg names, the associated leg dates and vessel name associated with the given cruise';
COMMENT ON COLUMN CCD_CRUISE_LEG_DATA_SETS_V.LEG_NAME_DATES_SCD_LIST IS 'Semicolon-delimited list of leg names, the associated leg dates and vessel name associated with the given cruise';
COMMENT ON COLUMN CCD_CRUISE_LEG_DATA_SETS_V.LEG_NAME_DATES_RC_LIST IS 'Return carriage/new line delimited list of leg names, the associated leg dates and vessel name associated with the given cruise';
COMMENT ON COLUMN CCD_CRUISE_LEG_DATA_SETS_V.LEG_NAME_DATES_BR_LIST IS '<BR> tag (intended for web pages) delimited list of leg names, the associated leg dates and vessel name associated with the given cruise';
COMMENT ON COLUMN CCD_CRUISE_LEG_DATA_SETS_V.CRUISE_LEG_ID IS 'Primary key for the CCD_CRUISE_LEGS table';
COMMENT ON COLUMN CCD_CRUISE_LEG_DATA_SETS_V.LEG_NAME IS 'The name of the given cruise leg';
COMMENT ON COLUMN CCD_CRUISE_LEG_DATA_SETS_V.LEG_START_DATE IS 'The start date in the corresponding time zone for the given research cruise leg';
COMMENT ON COLUMN CCD_CRUISE_LEG_DATA_SETS_V.FORMAT_LEG_START_DATE IS 'The start date in the corresponding time zone for the given research cruise leg in MM/DD/YYYY format';
COMMENT ON COLUMN CCD_CRUISE_LEG_DATA_SETS_V.LEG_END_DATE IS 'The end date in the corresponding time zone for the given research cruise leg';
COMMENT ON COLUMN CCD_CRUISE_LEG_DATA_SETS_V.FORMAT_LEG_END_DATE IS 'The end date in the corresponding time zone for the given research cruise leg in MM/DD/YYYY format';
COMMENT ON COLUMN CCD_CRUISE_LEG_DATA_SETS_V.LEG_DAS IS 'The number of days at sea for the given research cruise leg';
COMMENT ON COLUMN CCD_CRUISE_LEG_DATA_SETS_V.LEG_YEAR IS 'The calendar year for the start date of the given research cruise leg';
COMMENT ON COLUMN CCD_CRUISE_LEG_DATA_SETS_V.LEG_FISC_YEAR IS 'The NOAA fiscal year for the start date of the given research cruise leg';
COMMENT ON COLUMN CCD_CRUISE_LEG_DATA_SETS_V.LEG_DESC IS 'The description for the given research cruise leg';
COMMENT ON COLUMN CCD_CRUISE_LEG_DATA_SETS_V.TZ_NAME IS 'The numeric offset for UTC or Time Zone Name (V$TIMEZONE_NAMES.TZNAME) for the local timezone where the cruise leg occurred (e.g. US/Hawaii, US/Samoa, Etc/GMT+9)';
COMMENT ON COLUMN CCD_CRUISE_LEG_DATA_SETS_V.VESSEL_ID IS 'Foreign key reference to the CCD_VESSELS table for the cruise leg''s vessel';
COMMENT ON COLUMN CCD_CRUISE_LEG_DATA_SETS_V.VESSEL_NAME IS 'Name of the given research vessel';
COMMENT ON COLUMN CCD_CRUISE_LEG_DATA_SETS_V.VESSEL_DESC IS 'Description for the given research vessel';
COMMENT ON COLUMN CCD_CRUISE_LEG_DATA_SETS_V.PLAT_TYPE_ID IS 'Platform Type for the given research cruise leg';
COMMENT ON COLUMN CCD_CRUISE_LEG_DATA_SETS_V.PLAT_TYPE_NAME IS 'Name of the given Platform Type';
COMMENT ON COLUMN CCD_CRUISE_LEG_DATA_SETS_V.PLAT_TYPE_DESC IS 'Description for the given Platform Type';
COMMENT ON COLUMN CCD_CRUISE_LEG_DATA_SETS_V.NUM_REG_ECOSYSTEMS IS 'The number of associated Regional Ecosystems';
COMMENT ON COLUMN CCD_CRUISE_LEG_DATA_SETS_V.REG_ECOSYSTEM_CD_LIST IS 'Comma-delimited list of Regional Ecosystems associated with the given cruise leg';
COMMENT ON COLUMN CCD_CRUISE_LEG_DATA_SETS_V.REG_ECOSYSTEM_SCD_LIST IS 'Semicolon-delimited list of Regional Ecosystems associated with the given cruise leg';
COMMENT ON COLUMN CCD_CRUISE_LEG_DATA_SETS_V.REG_ECOSYSTEM_RC_LIST IS 'Return carriage/new line delimited list of Regional Ecosystems associated with the given cruise leg';
COMMENT ON COLUMN CCD_CRUISE_LEG_DATA_SETS_V.REG_ECOSYSTEM_BR_LIST IS '<BR> tag (intended for web pages) delimited list of Regional Ecosystems associated with the given cruise leg';
COMMENT ON COLUMN CCD_CRUISE_LEG_DATA_SETS_V.NUM_GEAR IS 'The number of associated gear';
COMMENT ON COLUMN CCD_CRUISE_LEG_DATA_SETS_V.GEAR_NAME_CD_LIST IS 'Comma-delimited list of gear associated with the given cruise leg';
COMMENT ON COLUMN CCD_CRUISE_LEG_DATA_SETS_V.GEAR_NAME_SCD_LIST IS 'Semicolon-delimited list of gear associated with the given cruise leg';
COMMENT ON COLUMN CCD_CRUISE_LEG_DATA_SETS_V.GEAR_NAME_RC_LIST IS 'Return carriage/new line delimited list of gear associated with the given cruise leg';
COMMENT ON COLUMN CCD_CRUISE_LEG_DATA_SETS_V.GEAR_NAME_BR_LIST IS '<BR> tag (intended for web pages) delimited list of gear associated with the given cruise leg';
COMMENT ON COLUMN CCD_CRUISE_LEG_DATA_SETS_V.NUM_REGIONS IS 'The number of associated regions';
COMMENT ON COLUMN CCD_CRUISE_LEG_DATA_SETS_V.REGION_CODE_CD_LIST IS 'Comma-delimited list of region codes associated with the given cruise leg';
COMMENT ON COLUMN CCD_CRUISE_LEG_DATA_SETS_V.REGION_CODE_SCD_LIST IS 'Semicolon-delimited list of region codes associated with the given cruise leg';
COMMENT ON COLUMN CCD_CRUISE_LEG_DATA_SETS_V.REGION_CODE_RC_LIST IS 'Return carriage/new line delimited list of region codes associated with the given cruise leg';
COMMENT ON COLUMN CCD_CRUISE_LEG_DATA_SETS_V.REGION_CODE_BR_LIST IS '<BR> tag (intended for web pages) delimited list of region codes associated with the given cruise leg';
COMMENT ON COLUMN CCD_CRUISE_LEG_DATA_SETS_V.REGION_NAME_CD_LIST IS 'Comma-delimited list of region names associated with the given cruise leg';
COMMENT ON COLUMN CCD_CRUISE_LEG_DATA_SETS_V.REGION_NAME_SCD_LIST IS 'Semicolon-delimited list of region names associated with the given cruise leg';
COMMENT ON COLUMN CCD_CRUISE_LEG_DATA_SETS_V.REGION_NAME_RC_LIST IS 'Return carriage/new line delimited list of region names associated with the given cruise leg';
COMMENT ON COLUMN CCD_CRUISE_LEG_DATA_SETS_V.REGION_NAME_BR_LIST IS '<BR> tag (intended for web pages) delimited list of region names associated with the given cruise leg';
COMMENT ON COLUMN CCD_CRUISE_LEG_DATA_SETS_V.NUM_LEG_ALIASES IS 'The number of associated leg aliases';
COMMENT ON COLUMN CCD_CRUISE_LEG_DATA_SETS_V.LEG_ALIAS_CD_LIST IS 'Comma-delimited list of leg aliases associated with the given cruise leg';
COMMENT ON COLUMN CCD_CRUISE_LEG_DATA_SETS_V.LEG_ALIAS_SCD_LIST IS 'Semicolon-delimited list of leg aliases associated with the given cruise leg';
COMMENT ON COLUMN CCD_CRUISE_LEG_DATA_SETS_V.LEG_ALIAS_RC_LIST IS 'Return carriage/new line delimited list of leg aliases associated with the given cruise leg';
COMMENT ON COLUMN CCD_CRUISE_LEG_DATA_SETS_V.LEG_ALIAS_BR_LIST IS '<BR> tag (intended for web pages) delimited list of leg aliases associated with the given cruise leg';
COMMENT ON COLUMN CCD_CRUISE_LEG_DATA_SETS_V.NUM_DATA_SETS IS 'The number of associated leg data sets';
COMMENT ON COLUMN CCD_CRUISE_LEG_DATA_SETS_V.DATA_SET_NAME_CD_LIST IS 'Comma-delimited list of leg data sets associated with the given cruise leg';
COMMENT ON COLUMN CCD_CRUISE_LEG_DATA_SETS_V.DATA_SET_NAME_SCD_LIST IS 'Semicolon-delimited list of leg data sets associated with the given cruise leg';
COMMENT ON COLUMN CCD_CRUISE_LEG_DATA_SETS_V.DATA_SET_NAME_RC_LIST IS 'Return carriage/new line delimited list of leg data sets associated with the given cruise leg';
COMMENT ON COLUMN CCD_CRUISE_LEG_DATA_SETS_V.DATA_SET_NAME_BR_LIST IS '<BR> tag (intended for web pages) delimited list of leg data sets associated with the given cruise leg';
COMMENT ON COLUMN CCD_CRUISE_LEG_DATA_SETS_V.LEG_DATA_SET_ID IS 'Primary key for the CCD_LEG_DATA_SETS table';
COMMENT ON COLUMN CCD_CRUISE_LEG_DATA_SETS_V.DATA_SET_ID IS 'Primary key for the CCD_DATA_SETS table';
COMMENT ON COLUMN CCD_CRUISE_LEG_DATA_SETS_V.LEG_DATA_SET_NOTES IS 'Notes associated with the given Cruise Leg''s Data Set';
COMMENT ON COLUMN CCD_CRUISE_LEG_DATA_SETS_V.DATA_SET_NAME IS 'The Name of the data set';
COMMENT ON COLUMN CCD_CRUISE_LEG_DATA_SETS_V.DATA_SET_DESC IS 'Description for the data set';
COMMENT ON COLUMN CCD_CRUISE_LEG_DATA_SETS_V.DATA_SET_INPORT_CAT_ID IS 'InPort Catalog ID for the data set';
COMMENT ON COLUMN CCD_CRUISE_LEG_DATA_SETS_V.DATA_SET_INPORT_URL IS 'InPort metadata URL for the data set';
COMMENT ON COLUMN CCD_CRUISE_LEG_DATA_SETS_V.DATA_SET_TYPE_ID IS 'Primary key for the CCD_DATA_SET_TYPES table';
COMMENT ON COLUMN CCD_CRUISE_LEG_DATA_SETS_V.DATA_SET_TYPE_NAME IS 'Name for the data set type';
COMMENT ON COLUMN CCD_CRUISE_LEG_DATA_SETS_V.DATA_SET_TYPE_DESC IS 'Description for the data set type';
COMMENT ON COLUMN CCD_CRUISE_LEG_DATA_SETS_V.DATA_SET_TYPE_DOC_URL IS 'Documentation URL for the data type, this can be an InPort URL for the parent Project record of the individual data sets or a documentation package that provides information about this data set type';
COMMENT ON COLUMN CCD_CRUISE_LEG_DATA_SETS_V.DATA_SET_STATUS_ID IS 'Primary key for the CCD_DATA_SET_STATUS table';
COMMENT ON COLUMN CCD_CRUISE_LEG_DATA_SETS_V.STATUS_CODE IS 'The alpha-numeric code for the data status';
COMMENT ON COLUMN CCD_CRUISE_LEG_DATA_SETS_V.STATUS_NAME IS 'The name of the data status';
COMMENT ON COLUMN CCD_CRUISE_LEG_DATA_SETS_V.STATUS_DESC IS 'The description for the data status';
COMMENT ON COLUMN CCD_CRUISE_LEG_DATA_SETS_V.STATUS_COLOR IS 'The hex value for the color that the data set status has in the application interface';






COMMENT ON COLUMN CCD_CRUISE_LEG_DATA_SETS_V.LEG_VESS_NAME_DATES_CD_LIST IS 'Comma-delimited list of leg names, the associated leg dates and vessel name associated with the given cruise';
COMMENT ON COLUMN CCD_CRUISE_LEG_DATA_SETS_V.LEG_VESS_NAME_DATES_SCD_LIST IS 'Semicolon-delimited list of leg names, the associated leg dates and vessel name associated with the given cruise';
COMMENT ON COLUMN CCD_CRUISE_LEG_DATA_SETS_V.LEG_VESS_NAME_DATES_RC_LIST IS 'Return carriage/new line delimited list of leg names, the associated leg dates and vessel name associated with the given cruise';
COMMENT ON COLUMN CCD_CRUISE_LEG_DATA_SETS_V.LEG_VESS_NAME_DATES_BR_LIST IS '<BR> tag (intended for web pages) delimited list of leg names, the associated leg dates and vessel name associated with the given cruise';
























CREATE OR REPLACE VIEW
CCD_CRUISE_LEG_DATA_SETS_MIN_V

AS SELECT


CCD_CRUISE_LEG_AGG_V.CRUISE_ID,
CCD_CRUISE_LEG_AGG_V.CRUISE_NAME,
CCD_CRUISE_LEG_AGG_V.CRUISE_NOTES,
CCD_CRUISE_LEG_AGG_V.CRUISE_DESC,
CCD_CRUISE_LEG_AGG_V.OBJ_BASED_METRICS,
CCD_CRUISE_LEG_AGG_V.SCI_CENTER_DIV_ID,
CCD_CRUISE_LEG_AGG_V.SCI_CENTER_DIV_CODE,
CCD_CRUISE_LEG_AGG_V.SCI_CENTER_DIV_NAME,
CCD_CRUISE_LEG_AGG_V.SCI_CENTER_DIV_DESC,
CCD_CRUISE_LEG_AGG_V.SCI_CENTER_ID,
CCD_CRUISE_LEG_AGG_V.SCI_CENTER_NAME,
CCD_CRUISE_LEG_AGG_V.SCI_CENTER_DESC,
CCD_CRUISE_LEG_AGG_V.STD_SVY_NAME_ID,
CCD_CRUISE_LEG_AGG_V.STD_SVY_NAME,
CCD_CRUISE_LEG_AGG_V.STD_SVY_DESC,
CCD_CRUISE_LEG_AGG_V.SVY_FREQ_ID,
CCD_CRUISE_LEG_AGG_V.SVY_FREQ_NAME,
CCD_CRUISE_LEG_AGG_V.SVY_FREQ_DESC,
CCD_CRUISE_LEG_AGG_V.STD_SVY_NAME_OTH,
CCD_CRUISE_LEG_AGG_V.STD_SVY_NAME_VAL,
CCD_CRUISE_LEG_AGG_V.SVY_TYPE_ID,
CCD_CRUISE_LEG_AGG_V.SVY_TYPE_NAME,
CCD_CRUISE_LEG_AGG_V.SVY_TYPE_DESC,
CCD_CRUISE_LEG_AGG_V.CRUISE_URL,
CCD_CRUISE_LEG_AGG_V.CRUISE_CONT_EMAIL,
CCD_CRUISE_LEG_AGG_V.PTA_ISS_ID,
CCD_CRUISE_LEG_AGG_V.CRUISE_LEG_ID,
CCD_CRUISE_LEG_AGG_V.LEG_NAME,
CCD_CRUISE_LEG_AGG_V.LEG_START_DATE,
CCD_CRUISE_LEG_AGG_V.FORMAT_LEG_START_DATE,
CCD_CRUISE_LEG_AGG_V.LEG_END_DATE,
CCD_CRUISE_LEG_AGG_V.FORMAT_LEG_END_DATE,
CCD_CRUISE_LEG_AGG_V.LEG_DAS,
CCD_CRUISE_LEG_AGG_V.LEG_YEAR,
CCD_CRUISE_LEG_AGG_V.TZ_NAME,
CCD_CRUISE_LEG_AGG_V.LEG_FISC_YEAR,
CCD_CRUISE_LEG_AGG_V.LEG_DESC,
CCD_CRUISE_LEG_AGG_V.VESSEL_ID,
CCD_CRUISE_LEG_AGG_V.VESSEL_NAME,
CCD_CRUISE_LEG_AGG_V.VESSEL_DESC,
CCD_CRUISE_LEG_AGG_V.PLAT_TYPE_ID,
CCD_CRUISE_LEG_AGG_V.PLAT_TYPE_NAME,
CCD_CRUISE_LEG_AGG_V.PLAT_TYPE_DESC,
CCD_CRUISE_LEG_AGG_V.NUM_LEGS,
CCD_CRUISE_LEG_AGG_V.CRUISE_START_DATE,
CCD_CRUISE_LEG_AGG_V.FORMAT_CRUISE_START_DATE,
CCD_CRUISE_LEG_AGG_V.CRUISE_END_DATE,
CCD_CRUISE_LEG_AGG_V.FORMAT_CRUISE_END_DATE,
CCD_CRUISE_LEG_AGG_V.CRUISE_DAS,
CCD_CRUISE_LEG_AGG_V.CRUISE_LEN_DAYS,
CCD_CRUISE_LEG_AGG_V.CRUISE_YEAR,
CCD_CRUISE_LEG_AGG_V.CRUISE_FISC_YEAR,
CCD_CRUISE_LEG_AGG_V.LEG_NAME_CD_LIST,
CCD_CRUISE_LEG_AGG_V.LEG_NAME_SCD_LIST,
CCD_CRUISE_LEG_AGG_V.LEG_NAME_RC_LIST,
CCD_CRUISE_LEG_AGG_V.LEG_NAME_BR_LIST,
CCD_CRUISE_LEG_AGG_V.LEG_NAME_DATES_CD_LIST,
CCD_CRUISE_LEG_AGG_V.LEG_NAME_DATES_SCD_LIST,
CCD_CRUISE_LEG_AGG_V.LEG_NAME_DATES_RC_LIST,
CCD_CRUISE_LEG_AGG_V.LEG_NAME_DATES_BR_LIST,
CCD_CRUISE_LEG_AGG_V.LEG_VESS_NAME_DATES_CD_LIST,
CCD_CRUISE_LEG_AGG_V.LEG_VESS_NAME_DATES_SCD_LIST,
CCD_CRUISE_LEG_AGG_V.LEG_VESS_NAME_DATES_RC_LIST,
CCD_CRUISE_LEG_AGG_V.LEG_VESS_NAME_DATES_BR_LIST,


CCD_LEG_DATA_SETS_V.LEG_DATA_SET_ID,
CCD_LEG_DATA_SETS_V.DATA_SET_ID,
CCD_LEG_DATA_SETS_V.LEG_DATA_SET_NOTES,
CCD_LEG_DATA_SETS_V.DATA_SET_NAME,
CCD_LEG_DATA_SETS_V.DATA_SET_DESC,
CCD_LEG_DATA_SETS_V.DATA_SET_INPORT_CAT_ID,
CCD_LEG_DATA_SETS_V.DATA_SET_INPORT_URL,
CCD_LEG_DATA_SETS_V.DATA_SET_TYPE_ID,
CCD_LEG_DATA_SETS_V.DATA_SET_TYPE_NAME,
CCD_LEG_DATA_SETS_V.DATA_SET_TYPE_DESC,
CCD_LEG_DATA_SETS_V.DATA_SET_TYPE_DOC_URL,
CCD_LEG_DATA_SETS_V.DATA_SET_STATUS_ID,
CCD_LEG_DATA_SETS_V.STATUS_CODE,
CCD_LEG_DATA_SETS_V.STATUS_NAME,
CCD_LEG_DATA_SETS_V.STATUS_DESC,
CCD_LEG_DATA_SETS_V.STATUS_COLOR




FROM
CCD_CRUISE_LEG_AGG_V INNER JOIN
CCD_LEG_DATA_SETS_V ON CCD_LEG_DATA_SETS_V.CRUISE_LEG_ID = CCD_CRUISE_LEG_AGG_V.CRUISE_LEG_ID
ORDER BY
CCD_CRUISE_LEG_AGG_V.LEG_START_DATE,
CCD_CRUISE_LEG_AGG_V.LEG_NAME,
CCD_CRUISE_LEG_AGG_V.VESSEL_NAME,
CCD_LEG_DATA_SETS_V.DATA_SET_NAME
;



COMMENT ON TABLE ccd_cruise_leg_data_sets_min_v IS 'Cruise Leg Data Sets - (Minimal Delimited Values View)

This query returns all of the cruise legs and their associated data sets in separate rows including all associated reference table information.	Each data set associated with a given cruise leg is represented by a separate result set row';


COMMENT ON COLUMN ccd_cruise_leg_data_sets_min_v.CRUISE_ID IS 'Primary key for the CCD_CRUISES table';
COMMENT ON COLUMN ccd_cruise_leg_data_sets_min_v.CRUISE_NAME IS 'The name of the given cruise designated by NOAA (e.g. SE-15-01)';
COMMENT ON COLUMN ccd_cruise_leg_data_sets_min_v.CRUISE_NOTES IS 'Any notes for the given research cruise';
COMMENT ON COLUMN ccd_cruise_leg_data_sets_min_v.CRUISE_DESC IS 'Description for the given research cruise';
COMMENT ON COLUMN ccd_cruise_leg_data_sets_min_v.OBJ_BASED_METRICS IS 'Objective Based Metrics for the given research cruise';
COMMENT ON COLUMN ccd_cruise_leg_data_sets_min_v.SCI_CENTER_DIV_ID IS 'Primary key for the Science Center Division table';
COMMENT ON COLUMN ccd_cruise_leg_data_sets_min_v.SCI_CENTER_DIV_CODE IS 'Abbreviated code for the given Science Center Division';
COMMENT ON COLUMN ccd_cruise_leg_data_sets_min_v.SCI_CENTER_DIV_NAME IS 'Name of the given Science Center Division';
COMMENT ON COLUMN ccd_cruise_leg_data_sets_min_v.SCI_CENTER_DIV_DESC IS 'Description for the given Science Center Division';
COMMENT ON COLUMN ccd_cruise_leg_data_sets_min_v.SCI_CENTER_ID IS 'Primary key for the Science Center table';
COMMENT ON COLUMN ccd_cruise_leg_data_sets_min_v.SCI_CENTER_NAME IS 'Name of the given Science Center';
COMMENT ON COLUMN ccd_cruise_leg_data_sets_min_v.SCI_CENTER_DESC IS 'Description for the given Science Center';
COMMENT ON COLUMN ccd_cruise_leg_data_sets_min_v.STD_SVY_NAME_ID IS 'Primary key for the Standard Survey Name table';
COMMENT ON COLUMN ccd_cruise_leg_data_sets_min_v.STD_SVY_NAME IS 'Name of the given Standard Survey Name';
COMMENT ON COLUMN ccd_cruise_leg_data_sets_min_v.STD_SVY_DESC IS 'Description for the given Standard Survey Name';
COMMENT ON COLUMN ccd_cruise_leg_data_sets_min_v.SVY_FREQ_ID IS 'Primary key for the Survey Frequency table';
COMMENT ON COLUMN ccd_cruise_leg_data_sets_min_v.SVY_FREQ_NAME IS 'Name of the given Survey Frequency';
COMMENT ON COLUMN ccd_cruise_leg_data_sets_min_v.SVY_FREQ_DESC IS 'Description for the given Survey Frequency';
COMMENT ON COLUMN ccd_cruise_leg_data_sets_min_v.STD_SVY_NAME_OTH IS 'Field defines a Standard Survey Name that is not included in the Standard Survey Name table';
COMMENT ON COLUMN ccd_cruise_leg_data_sets_min_v.STD_SVY_NAME_VAL IS 'This field contains the Standard Survey Name defined for the given cruise.	If the STD_SVY_NAME_ID field is defined then the associated CCD_STD_SVY_NAMES.STD_SVY_NAME is used because the foreign key is given precedence, otherwise the STD_SVY_NAME_OTH field value is used';
COMMENT ON COLUMN ccd_cruise_leg_data_sets_min_v.SVY_TYPE_ID IS 'Primary key for the Survey Type table';
COMMENT ON COLUMN ccd_cruise_leg_data_sets_min_v.SVY_TYPE_NAME IS 'Name of the given Survey Type';
COMMENT ON COLUMN ccd_cruise_leg_data_sets_min_v.SVY_TYPE_DESC IS 'Description for the given Survey Type';
COMMENT ON COLUMN ccd_cruise_leg_data_sets_min_v.CRUISE_URL IS 'The Cruise URL (Referred to as "Survey URL" in FINSS System) for the given Cruise';
COMMENT ON COLUMN ccd_cruise_leg_data_sets_min_v.CRUISE_CONT_EMAIL IS 'The Cruise Contact Email (Referred to as "Survey Contact Email" in FINSS System) for the given Cruise';
COMMENT ON COLUMN ccd_cruise_leg_data_sets_min_v.PTA_ISS_ID IS 'Foreign key reference to the Issues (PTA) intersection table';
COMMENT ON COLUMN ccd_cruise_leg_data_sets_min_v.NUM_LEGS IS 'The number of cruise legs associated with the given cruise';
COMMENT ON COLUMN ccd_cruise_leg_data_sets_min_v.CRUISE_START_DATE IS 'The start date in the corresponding time zone for the given cruise (based on the earliest associated cruise leg''s start date)';
COMMENT ON COLUMN ccd_cruise_leg_data_sets_min_v.FORMAT_CRUISE_START_DATE IS 'The formatted start date in the corresponding time zone for the given cruise (based on the earliest associated cruise leg''s start date) in MM/DD/YYYY HH24:MI:SS format';
COMMENT ON COLUMN ccd_cruise_leg_data_sets_min_v.CRUISE_END_DATE IS 'The end date in the corresponding time zone for the given cruise (based on the latest associated cruise leg''s end date)';
COMMENT ON COLUMN ccd_cruise_leg_data_sets_min_v.FORMAT_CRUISE_END_DATE IS 'The formatted end date in the corresponding time zone for the given cruise (based on the latest associated cruise leg''s end date) in MM/DD/YYYY HH24:MI:SS format';
COMMENT ON COLUMN ccd_cruise_leg_data_sets_min_v.CRUISE_DAS IS 'The total number of days at sea for each of the legs associated with the given cruise';
COMMENT ON COLUMN ccd_cruise_leg_data_sets_min_v.CRUISE_LEN_DAYS IS 'The total number of days between the Cruise Start and End Dates for the given cruise';
COMMENT ON COLUMN ccd_cruise_leg_data_sets_min_v.CRUISE_YEAR IS 'The calendar year for the given cruise (based on the earliest associated cruise leg''s start date)';
COMMENT ON COLUMN ccd_cruise_leg_data_sets_min_v.CRUISE_FISC_YEAR IS 'The calendar year for the given cruise (based on the earliest associated cruise leg''s start date)';
COMMENT ON COLUMN ccd_cruise_leg_data_sets_min_v.LEG_NAME_CD_LIST IS 'Comma-delimited list of leg names associated with the given cruise';
COMMENT ON COLUMN ccd_cruise_leg_data_sets_min_v.LEG_NAME_SCD_LIST IS 'Semicolon-delimited list of leg names associated with the given cruise';
COMMENT ON COLUMN ccd_cruise_leg_data_sets_min_v.LEG_NAME_RC_LIST IS 'Return carriage/new line delimited list of leg names associated with the given cruise';
COMMENT ON COLUMN ccd_cruise_leg_data_sets_min_v.LEG_NAME_BR_LIST IS '<BR> tag (intended for web pages) delimited list of leg names associated with the given cruise';
COMMENT ON COLUMN ccd_cruise_leg_data_sets_min_v.LEG_NAME_DATES_CD_LIST IS 'Comma-delimited list of leg names, the associated leg dates and vessel name associated with the given cruise';
COMMENT ON COLUMN ccd_cruise_leg_data_sets_min_v.LEG_NAME_DATES_SCD_LIST IS 'Semicolon-delimited list of leg names, the associated leg dates and vessel name associated with the given cruise';
COMMENT ON COLUMN ccd_cruise_leg_data_sets_min_v.LEG_NAME_DATES_RC_LIST IS 'Return carriage/new line delimited list of leg names, the associated leg dates and vessel name associated with the given cruise';
COMMENT ON COLUMN ccd_cruise_leg_data_sets_min_v.LEG_NAME_DATES_BR_LIST IS '<BR> tag (intended for web pages) delimited list of leg names, the associated leg dates and vessel name associated with the given cruise';
COMMENT ON COLUMN ccd_cruise_leg_data_sets_min_v.CRUISE_LEG_ID IS 'Primary key for the CCD_CRUISE_LEGS table';
COMMENT ON COLUMN ccd_cruise_leg_data_sets_min_v.LEG_NAME IS 'The name of the given cruise leg';
COMMENT ON COLUMN ccd_cruise_leg_data_sets_min_v.LEG_START_DATE IS 'The start date in the corresponding time zone for the given research cruise leg';
COMMENT ON COLUMN ccd_cruise_leg_data_sets_min_v.FORMAT_LEG_START_DATE IS 'The start date in the corresponding time zone for the given research cruise leg in MM/DD/YYYY format';
COMMENT ON COLUMN ccd_cruise_leg_data_sets_min_v.LEG_END_DATE IS 'The end date in the corresponding time zone for the given research cruise leg';
COMMENT ON COLUMN ccd_cruise_leg_data_sets_min_v.FORMAT_LEG_END_DATE IS 'The end date in the corresponding time zone for the given research cruise leg in MM/DD/YYYY format';
COMMENT ON COLUMN ccd_cruise_leg_data_sets_min_v.LEG_DAS IS 'The number of days at sea for the given research cruise leg';
COMMENT ON COLUMN ccd_cruise_leg_data_sets_min_v.LEG_YEAR IS 'The calendar year for the start date of the given research cruise leg';
COMMENT ON COLUMN ccd_cruise_leg_data_sets_min_v.LEG_FISC_YEAR IS 'The NOAA fiscal year for the start date of the given research cruise leg';
COMMENT ON COLUMN ccd_cruise_leg_data_sets_min_v.LEG_DESC IS 'The description for the given research cruise leg';
COMMENT ON COLUMN ccd_cruise_leg_data_sets_min_v.TZ_NAME IS 'The numeric offset for UTC or Time Zone Name (V$TIMEZONE_NAMES.TZNAME) for the local timezone where the cruise leg occurred (e.g. US/Hawaii, US/Samoa, Etc/GMT+9)';
COMMENT ON COLUMN ccd_cruise_leg_data_sets_min_v.VESSEL_ID IS 'Foreign key reference to the CCD_VESSELS table for the cruise leg''s vessel';
COMMENT ON COLUMN ccd_cruise_leg_data_sets_min_v.VESSEL_NAME IS 'Name of the given research vessel';
COMMENT ON COLUMN ccd_cruise_leg_data_sets_min_v.VESSEL_DESC IS 'Description for the given research vessel';
COMMENT ON COLUMN ccd_cruise_leg_data_sets_min_v.PLAT_TYPE_ID IS 'Platform Type for the given research cruise leg';
COMMENT ON COLUMN ccd_cruise_leg_data_sets_min_v.PLAT_TYPE_NAME IS 'Name of the given Platform Type';
COMMENT ON COLUMN ccd_cruise_leg_data_sets_min_v.PLAT_TYPE_DESC IS 'Description for the given Platform Type';
COMMENT ON COLUMN ccd_cruise_leg_data_sets_min_v.LEG_DATA_SET_ID IS 'Primary key for the CCD_LEG_DATA_SETS table';
COMMENT ON COLUMN ccd_cruise_leg_data_sets_min_v.DATA_SET_ID IS 'Primary key for the CCD_DATA_SETS table';
COMMENT ON COLUMN ccd_cruise_leg_data_sets_min_v.LEG_DATA_SET_NOTES IS 'Notes associated with the given Cruise Leg''s Data Set';
COMMENT ON COLUMN ccd_cruise_leg_data_sets_min_v.DATA_SET_NAME IS 'The Name of the data set';
COMMENT ON COLUMN ccd_cruise_leg_data_sets_min_v.DATA_SET_DESC IS 'Description for the data set';
COMMENT ON COLUMN ccd_cruise_leg_data_sets_min_v.DATA_SET_INPORT_CAT_ID IS 'InPort Catalog ID for the data set';
COMMENT ON COLUMN ccd_cruise_leg_data_sets_min_v.DATA_SET_INPORT_URL IS 'InPort metadata URL for the data set';
COMMENT ON COLUMN ccd_cruise_leg_data_sets_min_v.DATA_SET_TYPE_ID IS 'Primary key for the CCD_DATA_SET_TYPES table';
COMMENT ON COLUMN ccd_cruise_leg_data_sets_min_v.DATA_SET_TYPE_NAME IS 'Name for the data set type';
COMMENT ON COLUMN ccd_cruise_leg_data_sets_min_v.DATA_SET_TYPE_DESC IS 'Description for the data set type';
COMMENT ON COLUMN ccd_cruise_leg_data_sets_min_v.DATA_SET_TYPE_DOC_URL IS 'Documentation URL for the data type, this can be an InPort URL for the parent Project record of the individual data sets or a documentation package that provides information about this data set type';
COMMENT ON COLUMN ccd_cruise_leg_data_sets_min_v.DATA_SET_STATUS_ID IS 'Primary key for the CCD_DATA_SET_STATUS table';
COMMENT ON COLUMN ccd_cruise_leg_data_sets_min_v.STATUS_CODE IS 'The alpha-numeric code for the data status';
COMMENT ON COLUMN ccd_cruise_leg_data_sets_min_v.STATUS_NAME IS 'The name of the data status';
COMMENT ON COLUMN ccd_cruise_leg_data_sets_min_v.STATUS_DESC IS 'The description for the data status';
COMMENT ON COLUMN ccd_cruise_leg_data_sets_min_v.STATUS_COLOR IS 'The hex value for the color that the data set status has in the application interface';




COMMENT ON COLUMN ccd_cruise_leg_data_sets_min_v.LEG_VESS_NAME_DATES_CD_LIST IS 'Comma-delimited list of leg names, the associated leg dates and vessel name associated with the given cruise';
COMMENT ON COLUMN ccd_cruise_leg_data_sets_min_v.LEG_VESS_NAME_DATES_SCD_LIST IS 'Semicolon-delimited list of leg names, the associated leg dates and vessel name associated with the given cruise';
COMMENT ON COLUMN ccd_cruise_leg_data_sets_min_v.LEG_VESS_NAME_DATES_RC_LIST IS 'Return carriage/new line delimited list of leg names, the associated leg dates and vessel name associated with the given cruise';
COMMENT ON COLUMN ccd_cruise_leg_data_sets_min_v.LEG_VESS_NAME_DATES_BR_LIST IS '<BR> tag (intended for web pages) delimited list of leg names, the associated leg dates and vessel name associated with the given cruise';







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

			V_SP_RET_CODE PLS_INTEGER;

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
			V_CRUISE_ID CCD_CRUISES.CRUISE_ID%TYPE := 10;
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
		PROCEDURE EXEC_DVM_CRUISE_SP (P_CRUISE_ID IN CCD_CRUISES.CRUISE_ID%TYPE);

		--procedure that executes the DVM for a given CCD_CRUISES record (based on P_CRUISE_NAME)
		--all error conditions will raise an application exception and will be logged in the database
/*
		--example usage:

		DECLARE
			V_CRUISE_NAME CCD_CRUISES.CRUISE_NAME%TYPE := 'SE-20-04';
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
		PROCEDURE EXEC_DVM_CRUISE_SP (P_CRUISE_NAME IN CCD_CRUISES.CRUISE_NAME%TYPE);


		--procedure that executes the DVM for a given CCD_CRUISES record (based on P_CRUISE_ID) and returns a return code (P_SP_RET_CODE) with a value that indicates if the DVM executed successfully instead of raising an exception.  A P_SP_RET_CODE value of 1 indicates a successful execution and a value of 0 indicates it was not successful.  The P_EXC_MSG parameter will contain the exception message if the P_SP_RET_CODE indicates there was a processing error.  This procedure allows a PL/SQL block to continue even if the DVM has an exception
/*
		--example usage:

		DECLARE
			V_SP_RET_CODE PLS_INTEGER;

			V_EXC_MSG VARCHAR2(4000);

			V_CRUISE_ID CCD_CRUISES.CRUISE_ID%TYPE := 10;
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
		PROCEDURE EXEC_DVM_CRUISE_RC_SP (P_CRUISE_ID IN CCD_CRUISES.CRUISE_ID%TYPE, P_SP_RET_CODE OUT PLS_INTEGER, P_EXC_MSG OUT VARCHAR2);

		--procedure that executes the DVM for a given CCD_CRUISES record (based on P_CRUISE_NAME) and returns a return code (P_SP_RET_CODE) with a value that indicates if the DVM executed successfully instead of raising an exception.  A P_SP_RET_CODE value of 1 indicates a successful execution and a value of 0 indicates it was not successful.  The P_EXC_MSG parameter will contain the exception message if the P_SP_RET_CODE indicates there was a processing error.  This procedure allows a PL/SQL block to continue even if the DVM has an exception
/*
		--example usage:

		DECLARE
			V_SP_RET_CODE PLS_INTEGER;

			V_EXC_MSG VARCHAR2(4000);

			V_CRUISE_NAME CCD_CRUISES.CRUISE_NAME%TYPE := 'SE-20-04';
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
		PROCEDURE EXEC_DVM_CRUISE_RC_SP (P_CRUISE_NAME IN CCD_CRUISES.CRUISE_NAME%TYPE, P_SP_RET_CODE OUT PLS_INTEGER, P_EXC_MSG OUT VARCHAR2);


		--procedure that executes the DVM for a given CCD_CRUISES record (based on P_CRUISE_ID) by calling the EXEC_DVM_CRUISE_SP on the P_CRUISE_ID and then calling EXEC_DVM_CRUISE_SP on each of the records that is related to the P_CRUISE_ID via the CCD_QC_LEG_OVERLAP_V QC view so that the overlapping leg errors can be associated with the matching cruises from the CCD_QC_LEG_OVERLAP_V QC view.
		--all error conditions will raise an application exception and will be logged in the database
/*
		--example usage:

		DECLARE
			V_CRUISE_ID CCD_CRUISES.CRUISE_ID%TYPE := 10;
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
	  PROCEDURE EXEC_DVM_CRUISE_OVERLAP_SP (P_CRUISE_ID IN CCD_CRUISES.CRUISE_ID%TYPE);


		--procedure that executes the DVM for a given CCD_CRUISES record (based on P_CRUISE_NAME) by calling the EXEC_DVM_CRUISE_SP on the corresponding CRUISE_ID and then calling EXEC_DVM_CRUISE_SP on each of the records that is related to the CRUISE_ID via the CCD_QC_LEG_OVERLAP_V QC view so that the overlapping leg errors can be associated with the matching cruises from the CCD_QC_LEG_OVERLAP_V QC view.
		--all error conditions will raise an application exception and will be logged in the database
		/*
			--example usage:

			DECLARE
				V_CRUISE_NAME CCD_CRUISES.CRUISE_NAME%TYPE := 'SE-15-01';
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
	  PROCEDURE EXEC_DVM_CRUISE_OVERLAP_SP (P_CRUISE_NAME IN CCD_CRUISES.CRUISE_NAME%TYPE);

		--this procedure deletes a given cruise leg (identified by P_CRUISE_LEG_ID) and re-evaluates the DVM for all cruises that overlapped (using CCD_QC_LEG_OVERLAP_V) with the deleted cruise leg's cruise to ensure those cruise DVM records are up to date.  If there is a processing error the transaction will be rolled back to the state before the procedure was executed.
		--all error conditions will raise an application exception and will be logged in the database
/*
		--example usage:

		--delete the cruise leg (SE-20-05 Leg 1):
		DECLARE
			V_LEG_ID NUMBER := 10;
		BEGIN

		  CCD_DVM_PKG.DELETE_LEG_OVERLAP_SP (V_LEG_ID);

		 	DBMS_output.put_line('The Cruise Leg (CRUISE_LEG_ID: '||V_LEG_ID||') was deleted successfully');

			--commit the successful validation records
			COMMIT;

			EXCEPTION
				WHEN OTHERS THEN
		       DBMS_output.put_line(SQLERRM);

		 			DBMS_output.put_line('The Cruise Leg (CRUISE_LEG_ID: '||V_LEG_ID||') was NOT deleted successfully');

		END;

*/
		PROCEDURE DELETE_LEG_OVERLAP_SP (P_CRUISE_LEG_ID IN CCD_CRUISE_LEGS.CRUISE_LEG_ID%TYPE);


		--this procedure deletes a given cruise leg (identified by P_LEG_NAME) and re-evaluates the DVM for all cruises that overlapped (using CCD_QC_LEG_OVERLAP_V) with the deleted cruise leg's cruise to ensure those cruise DVM records are up to date.  If there is a processing error the transaction will be rolled back to the state before the procedure was executed.
		--all error conditions will raise an application exception and will be logged in the database
/*
		--example usage:

		--delete the cruise leg (SE-20-05 Leg 1):
		DECLARE
			V_LEG_NAME CCD_CRUISE_LEGS.LEG_NAME%TYPE := 'SE-20-05 Leg 1';
		BEGIN


		  CCD_DVM_PKG.DELETE_LEG_OVERLAP_SP (V_LEG_NAME);

		 	DBMS_output.put_line('The Cruise Leg (LEG_NAME: '||V_LEG_NAME||') was deleted successfully');

			--commit the successful validation records
			COMMIT;

			EXCEPTION
				WHEN OTHERS THEN
		      DBMS_output.put_line(SQLERRM);

				 	DBMS_output.put_line('The Cruise Leg (LEG_NAME: '||V_LEG_NAME||') was NOT deleted successfully');
		END;

*/
		PROCEDURE DELETE_LEG_OVERLAP_SP (P_LEG_NAME IN CCD_CRUISE_LEGS.LEG_NAME%TYPE);

		--procedure to delete a given cruise (identified by P_CRUISE_ID) as well as all DVM records associated with the cruise.  If there is a processing error the transaction will be rolled back to the state before the procedure was executed.
		--all error conditions will raise an application exception and will be logged in the database
/*
		--example usage:

		DECLARE

		    V_RETURN_CODE PLS_INTEGER;

				--set the cruise_ID
				V_CRUISE_ID CCD_CRUISES.CRUISE_ID%TYPE := 10;

		BEGIN

		    DB_LOG_PKG.ADD_LOG_ENTRY('DEBUG', 'Delete Cruise and DVM Records Processing', 'Delete the Cruise (CRUISE_ID: '||V_CRUISE_ID||') and associated DVM records', V_RETURN_CODE);

		    CCD_DVM_PKG.DELETE_CRUISE_SP (V_CRUISE_ID);

		    DB_LOG_PKG.ADD_LOG_ENTRY('SUCCESS', 'Delete Cruise and DVM Records Processing', 'The Cruise and associated DVM records were deleted successfully', V_RETURN_CODE);

		    EXCEPTION
		        WHEN OTHERS THEN
		            DB_LOG_PKG.ADD_LOG_ENTRY('ERROR', 'Remove DVM Records Processing', 'The Cruise and associated DVM records were not deleted successfully: '||chr(10)||SQLERRM, V_RETURN_CODE);

		            --raise the exception
		            RAISE;

		END;
*/
		PROCEDURE DELETE_CRUISE_SP (P_CRUISE_ID IN CCD_CRUISES.CRUISE_ID%TYPE);

		--procedure to delete a given cruise (identified by P_CRUISE_NAME) as well as all DVM records associated with the cruise.  If there is a processing error the transaction will be rolled back to the state before the procedure was executed.
		--all error conditions will raise an application exception and will be logged in the database
/*
		--example usage:

		DECLARE

		    V_RETURN_CODE PLS_INTEGER;

				--set the cruise
				V_CRUISE_NAME VARCHAR2(1000) := 'SE-15-01';

		BEGIN

		    DB_LOG_PKG.ADD_LOG_ENTRY('DEBUG', 'Delete Cruise and DVM Records Processing', 'Delete the Cruise (CRUISE_NAME: '||V_CRUISE_NAME||') and associated DVM records', V_RETURN_CODE);

		    CCD_DVM_PKG.DELETE_CRUISE_SP (V_CRUISE_NAME);

		    DB_LOG_PKG.ADD_LOG_ENTRY('SUCCESS', 'Delete Cruise and DVM Records Processing', 'The Cruise and associated DVM records were deleted successfully', V_RETURN_CODE);

		    EXCEPTION
		        WHEN OTHERS THEN
		            DB_LOG_PKG.ADD_LOG_ENTRY('ERROR', 'Remove DVM Records Processing', 'The Cruise and associated DVM records were not deleted successfully: '||chr(10)||SQLERRM, V_RETURN_CODE);

		            --raise the exception
		            RAISE;

		END;
*/
		PROCEDURE DELETE_CRUISE_SP (P_CRUISE_NAME IN CCD_CRUISES.CRUISE_NAME%TYPE);

		--this procedure will accept a P_CRUISE_ID parameter for the cruise that is going to be updated so that the corresponding overlapping cruise ID values can be added to the package variable PV_OVERLAP_CRUISE_IDS for automatic DVM processing following the update
/*
		DECLARE

		    V_PROC_RETURN_CODE PLS_INTEGER;

				--set the cruise_ID
				V_CRUISE_ID CCD_CRUISES.CRUISE_ID%TYPE := 10;

		BEGIN

		    DB_LOG_PKG.ADD_LOG_ENTRY ('DEBUG', 'Pre Update Leg (CRUISE_ID = '||V_CRUISE_ID||')', 'Save the overlapping cruise IDs for DVM processing after the cruise leg update', V_PROC_RETURN_CODE);

		    --identify all overlapping cruises for the current cruise leg's cruise:
		    CCD_DVM_PKG.PRE_UPDATE_LEG_SP (V_CRUISE_ID);

		    DB_LOG_PKG.ADD_LOG_ENTRY ('SUCCESS', 'Pre Update Leg (CRUISE_ID = '||V_CRUISE_ID||')', 'The CCD_DVM_PKG.PRE_UPDATE_LEG_SP procedure was successful', V_PROC_RETURN_CODE);

		    EXCEPTION
		        WHEN OTHERS THEN
		            DB_LOG_PKG.ADD_LOG_ENTRY ('ERROR', 'Pre Update Leg (CRUISE_ID = '||V_CRUISE_ID||')', 'The CCD_DVM_PKG.PRE_UPDATE_LEG_SP procedure failed', V_PROC_RETURN_CODE);

		            --raise the exception:
		            RAISE;
		END;
*/
		PROCEDURE PRE_UPDATE_LEG_SP (P_CRUISE_ID IN CCD_CRUISES.CRUISE_ID%TYPE);


		--this procedure will accept a P_CRUISE_ID parameter for the cruise that is going to be updated so that the corresponding overlapping cruise ID values can be added to the package variable PV_OVERLAP_CRUISE_IDS for automatic DVM processing following the update
/*
		DECLARE

		    V_PROC_RETURN_CODE PLS_INTEGER;

				--set the cruise name
				V_CRUISE_NAME VARCHAR2(1000) := 'SE-15-01';

		BEGIN

		    DB_LOG_PKG.ADD_LOG_ENTRY ('DEBUG', 'Pre Update Leg (CRUISE_NAME = '||V_CRUISE_NAME||')', 'Save the overlapping cruise IDs for DVM processing after the cruise leg update', V_PROC_RETURN_CODE);

		    --identify all overlapping cruises for the current cruise leg's cruise:
		    CCD_DVM_PKG.PRE_UPDATE_LEG_SP (V_CRUISE_NAME);

		    DB_LOG_PKG.ADD_LOG_ENTRY ('SUCCESS', 'Pre Update Leg (CRUISE_NAME = '||V_CRUISE_NAME||')', 'The CCD_DVM_PKG.PRE_UPDATE_LEG_SP procedure was successful', V_PROC_RETURN_CODE);

		    EXCEPTION
		        WHEN OTHERS THEN
		            DB_LOG_PKG.ADD_LOG_ENTRY ('ERROR', 'Pre Update Leg (CRUISE_NAME = '||V_CRUISE_NAME||')', 'The CCD_DVM_PKG.PRE_UPDATE_LEG_SP procedure failed', V_PROC_RETURN_CODE);

		            --raise the exception:
		            RAISE;
		END;
*/
		PROCEDURE PRE_UPDATE_LEG_SP (P_CRUISE_NAME IN CCD_CRUISES.CRUISE_NAME%TYPE);

		--this procedure will accept a P_CRUISE_ID parameter for the cruise that is going to be updated so that the corresponding overlapping cruise ID values can be added to the package variable PV_OVERLAP_CRUISE_IDS for automatic DVM processing following the update
/*
		DECLARE

		    V_PROC_RETURN_CODE PLS_INTEGER;

				--set the cruise_ID
				V_CRUISE_ID CCD_CRUISES.CRUISE_ID%TYPE := 10;

		BEGIN

		    DB_LOG_PKG.ADD_LOG_ENTRY ('DEBUG', 'Post Update Leg (CRUISE_ID = '||V_CRUISE_ID||')', 'Retrieve the overlapping cruise IDs and execute the DVM on the overlapping and current cruises', V_PROC_RETURN_CODE);

		    --identify all overlapping cruises for the current cruise leg's cruise:
		    CCD_DVM_PKG.POST_UPDATE_LEG_SP (V_CRUISE_ID);

		    DB_LOG_PKG.ADD_LOG_ENTRY ('SUCCESS', 'Post Update Leg (CRUISE_ID = '||V_CRUISE_ID||')', 'The CCD_DVM_PKG.POST_UPDATE_LEG_SP procedure was successful', V_PROC_RETURN_CODE);

		    EXCEPTION
		        WHEN OTHERS THEN
		            DB_LOG_PKG.ADD_LOG_ENTRY ('ERROR', 'Post Update Leg (CRUISE_ID = '||V_CRUISE_ID||')', 'The CCD_DVM_PKG.POST_UPDATE_LEG_SP procedure failed', V_PROC_RETURN_CODE);

		            --raise the exception:
		            RAISE;
		END;
*/
		PROCEDURE POST_UPDATE_LEG_SP (P_CRUISE_ID IN CCD_CRUISES.CRUISE_ID%TYPE);


		--this procedure will accept a P_CRUISE_NAME parameter for the cruise that is going to be updated so that the corresponding overlapping cruise ID values can be added to the package variable PV_OVERLAP_CRUISE_IDS for automatic DVM processing following the update
/*
		DECLARE

		    V_PROC_RETURN_CODE PLS_INTEGER;

				--set the cruise name
				V_CRUISE_NAME VARCHAR2(1000) := 'SE-15-01';

		BEGIN

		    DB_LOG_PKG.ADD_LOG_ENTRY ('DEBUG', 'Post Update Leg (CRUISE_NAME = '||V_CRUISE_NAME||')', 'Retrieve the overlapping cruise IDs and execute the DVM on the overlapping and current cruises', V_PROC_RETURN_CODE);

		    --identify all overlapping cruises for the current cruise leg's cruise:
		    CCD_DVM_PKG.POST_UPDATE_LEG_SP (V_CRUISE_NAME);

		    DB_LOG_PKG.ADD_LOG_ENTRY ('SUCCESS', 'Post Update Leg (CRUISE_NAME = '||V_CRUISE_NAME||')', 'The CCD_DVM_PKG.POST_UPDATE_LEG_SP procedure was successful', V_PROC_RETURN_CODE);

		    EXCEPTION
		        WHEN OTHERS THEN
		            DB_LOG_PKG.ADD_LOG_ENTRY ('ERROR', 'Post Update Leg (CRUISE_NAME = '||V_CRUISE_NAME||')', 'The CCD_DVM_PKG.POST_UPDATE_LEG_SP procedure failed', V_PROC_RETURN_CODE);

		            --raise the exception:
		            RAISE;
		END;
*/
		PROCEDURE POST_UPDATE_LEG_SP (P_CRUISE_NAME IN CCD_CRUISES.CRUISE_NAME%TYPE);

	END CCD_DVM_PKG;
	/


	--CCD DVM Package Body:
	create or replace PACKAGE BODY CCD_DVM_PKG
	--this package provides procedures to validate the cruise database
	AS


		--package array variable to store the CRUISE_ID values for a given cruise so they can be evaluated before and after a cruise leg update to ensure the DVM data is up-to-date
		PV_OVERLAP_CRUISE_IDS apex_application_global.vc_arr2;

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
		PROCEDURE EXEC_DVM_CRUISE_SP (P_CRUISE_ID IN CCD_CRUISES.CRUISE_ID%TYPE) IS

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
		PROCEDURE EXEC_DVM_CRUISE_SP (P_CRUISE_NAME IN CCD_CRUISES.CRUISE_NAME%TYPE) IS

			--procedure variable to store the return codes from each procedure call to determine the results of the procedure execution
			V_SP_RET_CODE PLS_INTEGER;

			--variable to store the CRUISE_ID for the specified P_CRUISE_NAME value
			V_CRUISE_ID CCD_CRUISES.CRUISE_ID%TYPE;

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
		PROCEDURE EXEC_DVM_CRUISE_RC_SP (P_CRUISE_ID IN CCD_CRUISES.CRUISE_ID%TYPE, P_SP_RET_CODE OUT PLS_INTEGER, P_EXC_MSG OUT VARCHAR2) IS

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
		PROCEDURE EXEC_DVM_CRUISE_RC_SP (P_CRUISE_NAME IN CCD_CRUISES.CRUISE_NAME%TYPE, P_SP_RET_CODE OUT PLS_INTEGER, P_EXC_MSG OUT VARCHAR2) IS

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
		PROCEDURE EXEC_DVM_CRUISE_OVERLAP_SP (P_CRUISE_ID IN CCD_CRUISES.CRUISE_ID%TYPE) IS

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
		PROCEDURE EXEC_DVM_CRUISE_OVERLAP_SP (P_CRUISE_NAME IN CCD_CRUISES.CRUISE_NAME%TYPE) IS

			--procedure variable to store the return codes from each procedure call to determine the results of the procedure execution
			V_SP_RET_CODE PLS_INTEGER;

			--variable to store the CRUISE_ID for the specified P_CRUISE_NAME value
			V_CRUISE_ID CCD_CRUISES.CRUISE_ID%TYPE;

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
		PROCEDURE DELETE_LEG_OVERLAP_SP (P_CRUISE_LEG_ID IN CCD_CRUISE_LEGS.CRUISE_LEG_ID%TYPE)

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
			V_CRUISE_ID CCD_CRUISES.CRUISE_ID%TYPE;

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
			SELECT CRUISE_ID, LEG_NAME, CRUISE_NAME INTO V_CRUISE_ID, V_LEG_NAME, V_CRUISE_NAME FROM CCD_CRUISE_LEG_V WHERE CRUISE_LEG_ID = P_CRUISE_LEG_ID;

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
		PROCEDURE DELETE_LEG_OVERLAP_SP (P_LEG_NAME IN CCD_CRUISE_LEGS.LEG_NAME%TYPE) IS

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


		--procedure to delete a given cruise (identified by P_CRUISE_ID) as well as all DVM records associated with the cruise.  If there is a processing error the transaction will be rolled back to the state before the procedure was executed.
		--all error conditions will raise an application exception and will be logged in the database
		PROCEDURE DELETE_CRUISE_SP (P_CRUISE_ID IN CCD_CRUISES.CRUISE_ID%TYPE) IS

			--procedure variable to store the return codes from each procedure call to determine the results of the procedure execution
			V_SP_RET_CODE PLS_INTEGER;

			--variable to store the constructed log source string for the current procedure's log messages:
			V_TEMP_LOG_SOURCE DB_LOG_ENTRIES.LOG_SOURCE%TYPE;

			--variable to store the exception message:
			V_EXCEPTION_MSG VARCHAR2(2000);

			--exception for blank required parameters:
			EXC_BLANK_PARAMS EXCEPTION;

			--variable to store the PTA_ISS_ID for the cruise record:
			V_PTA_ISS_ID NUMBER;

		BEGIN

			--set the rollback save point so that the entire procedure's effects can be rolled back if the procedure can't be successfully executed:
			SAVEPOINT DEL_CRUISE_SAVEPOINT;

			--construct the DB_LOG_ENTRIES.LOG_SOURCE value for all logging messages in this procedure based on the procedure/function name and parameters:
			V_TEMP_LOG_SOURCE := 'DELETE_CRUISE_SP (P_CRUISE_ID: '||P_CRUISE_ID||')';

	    DB_LOG_PKG.ADD_LOG_ENTRY('DEBUG', V_TEMP_LOG_SOURCE, 'running DELETE_CRUISE_SP ()', V_SP_RET_CODE);

			--check if the required parameters are blank:
			IF (P_CRUISE_ID IS NULL) THEN
				--the P_CRUISE_ID parameter is blank, raise an exception:

				--generate the exception message:
				V_EXCEPTION_MSG := 'The Cruise ID parameter was not specified';

				--log the processing error:
				DB_LOG_PKG.ADD_LOG_ENTRY ('ERROR', V_TEMP_LOG_SOURCE, V_EXCEPTION_MSG, V_SP_RET_CODE);

				--raise the blank parameter exception:
				RAISE EXC_BLANK_PARAMS;

			END IF;


	    DB_LOG_PKG.ADD_LOG_ENTRY('DEBUG', V_TEMP_LOG_SOURCE, 'Deleting DVM records for the Cruise ID: '||P_CRUISE_ID, V_SP_RET_CODE);

	    --retrieve the PTA_ISS_ID into the V_PTA_ISS_ID variable so it can be used to remove the
	    SELECT PTA_ISS_ID INTO V_PTA_ISS_ID FROM CCD_CRUISES where cruise_id = P_CRUISE_ID;

	    DB_LOG_PKG.ADD_LOG_ENTRY('DEBUG', V_TEMP_LOG_SOURCE, 'The PTA_ISS_ID is: '||V_PTA_ISS_ID, V_SP_RET_CODE);

			--check to see if there are any DVM records associated with the cruise:
			IF (V_PTA_ISS_ID IS NOT NULL) THEN
				--the specified Cruise record has DVM records associated with it, remove them:

		    --Update the CCD_CRUISES record to clear the PTA_ISS_ID value:
		    UPDATE CCD_CRUISES SET PTA_ISS_ID = NULL WHERE CRUISE_ID = P_CRUISE_ID;

		    DB_LOG_PKG.ADD_LOG_ENTRY('DEBUG', V_TEMP_LOG_SOURCE, 'Cleared the PTA_ISS_ID from the CCD_CRUISES record', V_SP_RET_CODE);


		    --delete the DVM issue records:
		    DELETE FROM DVM_ISSUES WHERE PTA_ISS_ID = V_PTA_ISS_ID;

		    DB_LOG_PKG.ADD_LOG_ENTRY('DEBUG', V_TEMP_LOG_SOURCE, 'Deleted DVM issue records for the Cruise ID: '||P_CRUISE_ID, V_SP_RET_CODE);

		    --delete the DVM PTA Rule Sets:
		    DELETE FROM DVM_PTA_RULE_SETS WHERE PTA_ISS_ID = V_PTA_ISS_ID;

		    DB_LOG_PKG.ADD_LOG_ENTRY('DEBUG', V_TEMP_LOG_SOURCE, 'Deleted DVM PTA Rule Sets for the Cruise ID: '||P_CRUISE_ID, V_SP_RET_CODE);

		    --delete the DVM intersection record
		    DELETE FROM DVM_PTA_ISSUES WHERE PTA_ISS_ID = V_PTA_ISS_ID;

		    DB_LOG_PKG.ADD_LOG_ENTRY('DEBUG', V_TEMP_LOG_SOURCE, 'Deleted DVM PTA Issues Record for the Cruise ID: '||P_CRUISE_ID, V_SP_RET_CODE);

			END IF;

			--delete the cruise:
			DELETE FROM CCD_CRUISES WHERE CRUISE_ID = P_CRUISE_ID;

			EXCEPTION
		    --catch all PL/SQL database exceptions:

				WHEN EXC_BLANK_PARAMS then
					--blank CRUISE_ID parameter:

					--raise a custom application error:
					RAISE_APPLICATION_ERROR (-20513, V_EXCEPTION_MSG);

		    WHEN NO_DATA_FOUND THEN
					--the CCD_CRUISES record does not exist:

					--generate the exception message:
					V_EXCEPTION_MSG := 'The specified Cruise record (CRUISE_ID: '||P_CRUISE_ID||') does not exist';

		    	DB_LOG_PKG.ADD_LOG_ENTRY('ERROR', V_TEMP_LOG_SOURCE, V_EXCEPTION_MSG, V_SP_RET_CODE);

					--raise a custom application error:
					RAISE_APPLICATION_ERROR (-20515, V_EXCEPTION_MSG);

		    WHEN OTHERS THEN


					--check if there was a foreign key constraint violation when the cruise deletion was attempted
					IF (SQLCODE = -2292) THEN
						--this is a foreign key constraint error

						--generate the exception message:
						V_EXCEPTION_MSG := 'One or more child records exist for the cruise record, you must delete them before you can delete the cruise';

						--log the procedure processing error:
						DB_LOG_PKG.ADD_LOG_ENTRY ('ERROR', V_TEMP_LOG_SOURCE, V_EXCEPTION_MSG, V_SP_RET_CODE);

						--rollback all of the DML that was executed in the procedure since the procedure failed:
						ROLLBACK TO SAVEPOINT DEL_CRUISE_SAVEPOINT;

						--raise a custom application error:
						RAISE_APPLICATION_ERROR (-20516, V_EXCEPTION_MSG);
					ELSE
						--this is not a foreign key error:

						--construct the exception message:
						V_EXCEPTION_MSG := 'The Cruise record and associated DVM records could not be successfully deleted from the database: '||chr(10)||SQLERRM;

						--log the processing error
						DB_LOG_PKG.ADD_LOG_ENTRY ('ERROR', V_TEMP_LOG_SOURCE, V_EXCEPTION_MSG, V_SP_RET_CODE);

						--rollback all of the DML that was executed in the procedure since the procedure failed:
						ROLLBACK TO SAVEPOINT DEL_CRUISE_SAVEPOINT;


						--raise a custom application error:
						RAISE_APPLICATION_ERROR (-20514, V_EXCEPTION_MSG);
					END IF;

		END DELETE_CRUISE_SP;



		--procedure to delete a given cruise (identified by P_CRUISE_NAME) as well as all DVM records associated with the cruise.  If there is a processing error the transaction will be rolled back to the state before the procedure was executed.
		--all error conditions will raise an application exception and will be logged in the database
		PROCEDURE DELETE_CRUISE_SP (P_CRUISE_NAME IN CCD_CRUISES.CRUISE_NAME%TYPE) IS

			--procedure variable to store the return codes from each procedure call to determine the results of the procedure execution
			V_SP_RET_CODE PLS_INTEGER;

			--variable to store the CRUISE_ID for the specified P_CRUISE_NAME value
			V_CRUISE_ID CCD_CRUISES.CRUISE_ID%TYPE;

			--variable to store the constructed log source string for the current procedure's log messages:
			V_TEMP_LOG_SOURCE DB_LOG_ENTRIES.LOG_SOURCE%TYPE;

			--variable to store the exception message:
			V_EXCEPTION_MSG VARCHAR2(2000);

			--exception for blank required parameters:
			EXC_BLANK_PARAMS EXCEPTION;

		BEGIN

			--construct the DB_LOG_ENTRIES.LOG_SOURCE value for all logging messages in this procedure based on the procedure/function name and parameters:
			V_TEMP_LOG_SOURCE := 'DELETE_CRUISE_SP (P_CRUISE_NAME: '||P_CRUISE_NAME||')';

	    DB_LOG_PKG.ADD_LOG_ENTRY('DEBUG', V_TEMP_LOG_SOURCE, 'running DELETE_CRUISE_SP ()', V_SP_RET_CODE);


			--check if the P_CRUISE_NAME parameter is blank
			IF (P_CRUISE_NAME IS NULL) THEN
				--the P_CRUISE_NAME parameter is blank

				--generate the exception message:
				V_EXCEPTION_MSG := 'The Cruise Name parameter was not specified';

				--log the processing error:
				DB_LOG_PKG.ADD_LOG_ENTRY ('ERROR', V_TEMP_LOG_SOURCE, V_EXCEPTION_MSG, V_SP_RET_CODE);

				--raise the defined exception:
				RAISE EXC_BLANK_PARAMS;


			END IF;


			--query for the CRUISE_ID for the corresponding P_CRUISE_NAME value
			SELECT CRUISE_ID INTO V_CRUISE_ID FROM CCD_CRUISES WHERE UPPER(CRUISE_NAME) = UPPER(P_CRUISE_NAME);

			--delete the cruise and associated DVM records:
			DELETE_CRUISE_SP(V_CRUISE_ID);


      EXCEPTION
        --catch all PL/SQL database exceptions:

				WHEN EXC_BLANK_PARAMS then
					--blank CRUISE_NAME parameter:

					--raise a custom application error:
					RAISE_APPLICATION_ERROR (-20513, V_EXCEPTION_MSG);


				WHEN NO_DATA_FOUND THEN
					--catch not matching cruise record error:


					--generate the exception message:
					V_EXCEPTION_MSG := 'A Cruise record with a name "'||P_CRUISE_NAME||'" could not be found in the database';

					--log the processing error:
			    DB_LOG_PKG.ADD_LOG_ENTRY('ERROR', V_TEMP_LOG_SOURCE, V_EXCEPTION_MSG, V_SP_RET_CODE);

					--raise a custom application error:
					RAISE_APPLICATION_ERROR (-20515, V_EXCEPTION_MSG);

        WHEN OTHERS THEN
				  --catch all other errors:

					--check if there are any special exceptions for the DELETE_CRUISE_SP (P_CRUISE_ID) procedure
					IF (SQLCODE IN (-20513, -20514, -20515, -20516)) THEN
						--this is a special exception from the DELETE_CRUISE_SP (P_CRUISE_ID) procedure

						--re raise the exception:
						RAISE;

					ELSE
						--this is not a special exception from the DELETE_CRUISE_SP (P_CRUISE_ID) procedure:

						--generate the exception message:
						V_EXCEPTION_MSG := 'The specific Cruise and associated DVM data could not be deleted successfully:'||chr(10)||SQLERRM;

						--log the processing error:
						DB_LOG_PKG.ADD_LOG_ENTRY ('ERROR', V_TEMP_LOG_SOURCE, V_EXCEPTION_MSG, V_SP_RET_CODE);

						--raise a custom application error:
						RAISE_APPLICATION_ERROR (-20514, V_EXCEPTION_MSG);
					END IF;

		END DELETE_CRUISE_SP;


		--this procedure will accept a P_CRUISE_ID parameter for the cruise that is going to be updated so that the corresponding overlapping cruise ID values can be added to the package variable PV_OVERLAP_CRUISE_IDS for automatic DVM processing following the update
		PROCEDURE PRE_UPDATE_LEG_SP (P_CRUISE_ID IN CCD_CRUISES.CRUISE_ID%TYPE) IS

			--procedure variable to store the return codes from each procedure call to determine the results of the procedure execution
			V_SP_RET_CODE PLS_INTEGER;

			--variable to store the constructed log source string for the current procedure's log messages:
			V_TEMP_LOG_SOURCE DB_LOG_ENTRIES.LOG_SOURCE%TYPE;

			--variable to store the exception message:
			V_EXCEPTION_MSG VARCHAR2(2000);

			--exception for blank required parameters:
			EXC_BLANK_PARAMS EXCEPTION;

			--variable to store the cruise name of the specified cruise:
			V_CRUISE_NAME VARCHAR2(1000);

		BEGIN

			--construct the DB_LOG_ENTRIES.LOG_SOURCE value for all logging messages in this procedure based on the procedure/function name and parameters:
			V_TEMP_LOG_SOURCE := 'PRE_UPDATE_LEG_SP (P_CRUISE_ID: '||P_CRUISE_ID||')';

	    DB_LOG_PKG.ADD_LOG_ENTRY('DEBUG', V_TEMP_LOG_SOURCE, 'running PRE_UPDATE_LEG_SP ()', V_SP_RET_CODE);

	    --initialize the package array variable to store the cruise ID values for overlapping cruises:
	    PV_OVERLAP_CRUISE_IDS.DELETE;

			--check if the P_CRUISE_ID parameter is blank
			IF (P_CRUISE_ID IS NULL) THEN
				--the P_CRUISE_ID parameter is blank

				--generate the exception message:
				V_EXCEPTION_MSG := 'The Cruise ID parameter was not specified';

				--log the processing error:
				DB_LOG_PKG.ADD_LOG_ENTRY ('ERROR', V_TEMP_LOG_SOURCE, V_EXCEPTION_MSG, V_SP_RET_CODE);

				--raise the defined exception:
				RAISE EXC_BLANK_PARAMS;

			END IF;

			--query to ensure the cruise exists:
			SELECT CRUISE_NAME INTO V_CRUISE_NAME FROM CCD_CRUISES WHERE CRUISE_ID = P_CRUISE_ID;

	    --query for any leg/vessel overlap for the specified cruise (do not revalidate the same cruise if there is an overlap with another associated cruise leg since the initial execution will identify those validation issues)
	    FOR rec IN (SELECT DISTINCT CRUISE_ID FROM CCD_QC_LEG_OVERLAP_V WHERE CRUISE_ID2 = P_CRUISE_ID AND CRUISE_ID <> P_CRUISE_ID)

	    --loop through each CRUISE_ID returned by the SELECT query so these overlapping cruise IDs can be re-evaluated by the DVM after the cruise leg is updated:
	    LOOP

	        DB_LOG_PKG.ADD_LOG_ENTRY ('DEBUG', V_TEMP_LOG_SOURCE, 'The current value of V_OVERLAP_CRUISE_IDS is: '||rec.CRUISE_ID, V_SP_RET_CODE);

	        PV_OVERLAP_CRUISE_IDS(PV_OVERLAP_CRUISE_IDS.COUNT + 1) :=  rec.CRUISE_ID;

	    END LOOP;



      EXCEPTION
        --catch all PL/SQL database exceptions:

				WHEN EXC_BLANK_PARAMS then
					--blank CRUISE_NAME parameter:

					--raise a custom application error:
					RAISE_APPLICATION_ERROR (-20517, V_EXCEPTION_MSG);

				WHEN NO_DATA_FOUND THEN
					--catch not matching cruise record error:


					--generate the exception message:
					V_EXCEPTION_MSG := 'A Cruise record (CRUISE_ID: '||P_CRUISE_ID||') could not be found in the database';

					--log the processing error:
			    DB_LOG_PKG.ADD_LOG_ENTRY('ERROR', V_TEMP_LOG_SOURCE, V_EXCEPTION_MSG, V_SP_RET_CODE);

					--raise a custom application error:
					RAISE_APPLICATION_ERROR (-20519, V_EXCEPTION_MSG);

				WHEN OTHERS THEN
					--catch other exceptions

					--generate the exception message:
					V_EXCEPTION_MSG := 'The specific Leg''s associated Cruise overlaps could not be retrieved successfully:'||chr(10)||SQLERRM;

					--log the processing error:
					DB_LOG_PKG.ADD_LOG_ENTRY ('ERROR', V_TEMP_LOG_SOURCE, V_EXCEPTION_MSG, V_SP_RET_CODE);

					--raise a custom application error:
					RAISE_APPLICATION_ERROR (-20518, V_EXCEPTION_MSG);

		END PRE_UPDATE_LEG_SP;



		--this procedure will accept a P_CRUISE_NAME parameter for the cruise that is going to be updated so that the corresponding overlapping cruise ID values can be added to the package variable PV_OVERLAP_CRUISE_IDS for automatic DVM processing following the update
		PROCEDURE PRE_UPDATE_LEG_SP (P_CRUISE_NAME IN CCD_CRUISES.CRUISE_NAME%TYPE) IS

			--procedure variable to store the return codes from each procedure call to determine the results of the procedure execution
			V_SP_RET_CODE PLS_INTEGER;

			--variable to store the constructed log source string for the current procedure's log messages:
			V_TEMP_LOG_SOURCE DB_LOG_ENTRIES.LOG_SOURCE%TYPE;

			--variable to store the exception message:
			V_EXCEPTION_MSG VARCHAR2(2000);

			--exception for blank required parameters:
			EXC_BLANK_PARAMS EXCEPTION;

			--variable to store the cruise ID for the specified P_CRUISE_NAME:
			V_CRUISE_ID CCD_CRUISES.CRUISE_ID%TYPE;

		BEGIN

			--construct the DB_LOG_ENTRIES.LOG_SOURCE value for all logging messages in this procedure based on the procedure/function name and parameters:
			V_TEMP_LOG_SOURCE := 'PRE_UPDATE_LEG_SP (P_CRUISE_NAME: '||P_CRUISE_NAME||')';

	    DB_LOG_PKG.ADD_LOG_ENTRY('DEBUG', V_TEMP_LOG_SOURCE, 'running PRE_UPDATE_LEG_SP ()', V_SP_RET_CODE);

			--check if the P_CRUISE_NAME parameter is blank
			IF (P_CRUISE_NAME IS NULL) THEN
				--the P_CRUISE_NAME parameter is blank

				--generate the exception message:
				V_EXCEPTION_MSG := 'The Cruise Name parameter was not specified';

				--log the processing error:
				DB_LOG_PKG.ADD_LOG_ENTRY ('ERROR', V_TEMP_LOG_SOURCE, V_EXCEPTION_MSG, V_SP_RET_CODE);

				--raise the defined exception:
				RAISE EXC_BLANK_PARAMS;

			END IF;


			--query for the CRUISE_ID for the corresponding P_CRUISE_NAME value
			SELECT CRUISE_ID INTO V_CRUISE_ID FROM CCD_CRUISES WHERE UPPER(CRUISE_NAME) = UPPER(P_CRUISE_NAME);

			--delete the cruise and associated DVM records:
			PRE_UPDATE_LEG_SP(V_CRUISE_ID);


      EXCEPTION
        --catch all PL/SQL database exceptions:

				WHEN EXC_BLANK_PARAMS then
					--blank CRUISE_NAME parameter:

					--raise a custom application error:
					RAISE_APPLICATION_ERROR (-20517, V_EXCEPTION_MSG);

				WHEN NO_DATA_FOUND THEN
					--catch not matching cruise record error:


					--generate the exception message:
					V_EXCEPTION_MSG := 'A Cruise record (CRUISE_NAME: '||P_CRUISE_NAME||') could not be found in the database';

					--log the processing error:
			    DB_LOG_PKG.ADD_LOG_ENTRY('ERROR', V_TEMP_LOG_SOURCE, V_EXCEPTION_MSG, V_SP_RET_CODE);

					--raise a custom application error:
					RAISE_APPLICATION_ERROR (-20519, V_EXCEPTION_MSG);

				WHEN OTHERS THEN
					--catch other exceptions

					--check if there are any special exceptions for the PRE_UPDATE_LEG_SP (P_CRUISE_ID) procedure
					IF (SQLCODE IN (-20517, -20518, -20519)) THEN
						--this is a special exception from the PRE_UPDATE_LEG_SP (P_CRUISE_ID) procedure

						--re raise the exception:
						RAISE;

					ELSE
						--this is not a special exception from the PRE_UPDATE_LEG_SP (P_CRUISE_ID) procedure:

						--generate the exception message:
						V_EXCEPTION_MSG := 'The specific Leg''s associated Cruise overlaps could not be retrieved successfully:'||chr(10)||SQLERRM;

						--log the processing error:
						DB_LOG_PKG.ADD_LOG_ENTRY ('ERROR', V_TEMP_LOG_SOURCE, V_EXCEPTION_MSG, V_SP_RET_CODE);

						--raise a custom application error:
						RAISE_APPLICATION_ERROR (-20518, V_EXCEPTION_MSG);
					END IF;

		END PRE_UPDATE_LEG_SP;

		--this procedure will accept a P_CRUISE_ID parameter for the cruise that was updated to validate the updated Cruise and also validate all corresponding overlapping cruise ID values
		PROCEDURE POST_UPDATE_LEG_SP (P_CRUISE_ID IN CCD_CRUISES.CRUISE_ID%TYPE) IS

			--procedure variable to store the return codes from each procedure call to determine the results of the procedure execution
			V_SP_RET_CODE PLS_INTEGER;

			--variable to store the constructed log source string for the current procedure's log messages:
			V_TEMP_LOG_SOURCE DB_LOG_ENTRIES.LOG_SOURCE%TYPE;

			--variable to store the exception message:
			V_EXCEPTION_MSG VARCHAR2(2000);

			--exception for blank required parameters:
			EXC_BLANK_PARAMS EXCEPTION;

			--variable to store the cruise name of the specified cruise:
			V_CRUISE_NAME VARCHAR2(1000);

			--variable to track if the given CRUISE_ID was found in the package array variable PV_OVERLAP_CRUISE_IDS
	    V_FOUND_CODE PLS_INTEGER;

			--exception for the array not being processed successfully:
			EXC_ARRAY_FIND_ERR EXCEPTION;

			--variable to store the current CRUISE_ID that is being processed
			V_CURR_CRUISE_ID NUMBER := NULL;

			--variable to store the exception number for DVM processing errors
			V_EXC_CODE NUMBER;

		BEGIN


			--set the rollback save point so that the entire procedure's effects can be rolled back if the procedure can't be successfully executed:
			SAVEPOINT UPDATE_LEG_SP_SAVEPOINT;

			--construct the DB_LOG_ENTRIES.LOG_SOURCE value for all logging messages in this procedure based on the procedure/function name and parameters:
			V_TEMP_LOG_SOURCE := 'POST_UPDATE_LEG_SP (P_CRUISE_ID: '||P_CRUISE_ID||')';

	    DB_LOG_PKG.ADD_LOG_ENTRY('DEBUG', V_TEMP_LOG_SOURCE, 'running POST_UPDATE_LEG_SP ()', V_SP_RET_CODE);

	    DB_LOG_PKG.ADD_LOG_ENTRY('DEBUG', V_TEMP_LOG_SOURCE, 'The existing value of PV_OVERLAP_CRUISE_IDS is: '||APEX_UTIL.table_to_string(PV_OVERLAP_CRUISE_IDS, ', '), V_SP_RET_CODE);

			--check if the P_CRUISE_ID parameter is blank
			IF (P_CRUISE_ID IS NULL) THEN
				--the P_CRUISE_ID parameter is blank

				--generate the exception message:
				V_EXCEPTION_MSG := 'The Cruise ID parameter was not specified';

				--log the processing error:
				DB_LOG_PKG.ADD_LOG_ENTRY ('ERROR', V_TEMP_LOG_SOURCE, V_EXCEPTION_MSG, V_SP_RET_CODE);

				--raise the defined exception:
				RAISE EXC_BLANK_PARAMS;

			END IF;

			--query to ensure the cruise exists:
			SELECT CRUISE_NAME INTO V_CRUISE_NAME FROM CCD_CRUISES WHERE CRUISE_ID = P_CRUISE_ID;


      --execute the DVM on the updated cruise:
      CCD_DVM_PKG.EXEC_DVM_CRUISE_SP (P_CRUISE_ID);

      DB_LOG_PKG.ADD_LOG_ENTRY ('DEBUG', V_TEMP_LOG_SOURCE, 'The DVM was successfully executed for the updated cruise', V_SP_RET_CODE);


	    --query for any leg/vessel overlap for the specified cruise (do not revalidate the same cruise if there is an overlap with another associated cruise leg since the initial execution will identify those validation issues)
	    FOR rec IN (SELECT DISTINCT CRUISE_ID FROM CCD_QC_LEG_OVERLAP_V WHERE CRUISE_ID2 = P_CRUISE_ID AND CRUISE_ID <> P_CRUISE_ID)

	    --loop through each CRUISE_ID returned by the SELECT query so these overlapping cruise IDs can be re-evaluated by the DVM after the cruise leg is updated:
	    LOOP

	        DB_LOG_PKG.ADD_LOG_ENTRY ('DEBUG', V_TEMP_LOG_SOURCE, 'The current value of overlapping CRUISE_ID is: '||rec.CRUISE_ID, V_SP_RET_CODE);

	        --determine if the current cruise ID has already been identified as overlapping before the update, if so then do not add it to the array:
	        V_FOUND_CODE := CEN_UTILS.CEN_UTIL_ARRAY_PKG.ARRAY_VAL_EXISTS_FN (PV_OVERLAP_CRUISE_IDS, TO_CHAR(rec.CRUISE_ID));

	        --check if the array element was found
	        IF (V_FOUND_CODE = 0) THEN
	            --the current CRUISE_ID value was not found in the array, add it to the array:

	            PV_OVERLAP_CRUISE_IDS(PV_OVERLAP_CRUISE_IDS.COUNT + 1) :=  rec.CRUISE_ID;

	        ELSIF (V_FOUND_CODE IS NULL) THEN
	            --there was a processing error for the array:


							--generate the exception message:
							V_EXCEPTION_MSG := 'The array could not be searched successfully for the current cruise ID value';

							--log the processing error:
							DB_LOG_PKG.ADD_LOG_ENTRY ('ERROR', V_TEMP_LOG_SOURCE, V_EXCEPTION_MSG, V_SP_RET_CODE);

							--raise the defined exception:
							RAISE EXC_ARRAY_FIND_ERR;

	        END IF;

	    END LOOP;

			DB_LOG_PKG.ADD_LOG_ENTRY ('DEBUG', V_TEMP_LOG_SOURCE, 'There were '||PV_OVERLAP_CRUISE_IDS.COUNT||' cruises that will be checked for overlaps', V_SP_RET_CODE);

	    --loop through the overlapping cruise IDs and re-evaluate them:
	    for i in 1..PV_OVERLAP_CRUISE_IDS.count
	    loop

					--set the value of the current cruise ID being processed for error reporting purposes
					V_CURR_CRUISE_ID := PV_OVERLAP_CRUISE_IDS(i);

	        DB_LOG_PKG.ADD_LOG_ENTRY ('DEBUG', V_TEMP_LOG_SOURCE, 'Run the DVM on the overlapping CRUISE_ID: '||PV_OVERLAP_CRUISE_IDS(i), V_SP_RET_CODE);

	        --execute the DVM on the current cruise:
	        CCD_DVM_PKG.EXEC_DVM_CRUISE_SP (TO_NUMBER(PV_OVERLAP_CRUISE_IDS(i)));

          DB_LOG_PKG.ADD_LOG_ENTRY ('DEBUG', V_TEMP_LOG_SOURCE, 'The DVM was successfully executed on the overlapping cruise', V_SP_RET_CODE);

	    end loop;




      EXCEPTION
        --catch all PL/SQL database exceptions:

				WHEN EXC_BLANK_PARAMS then
					--blank CRUISE_NAME parameter:

					--raise a custom application error:
					RAISE_APPLICATION_ERROR (-20520, V_EXCEPTION_MSG);

				WHEN NO_DATA_FOUND THEN
					--catch not matching cruise record error:

					--rollback all of the DML that was executed in the procedure since the procedure failed:
					ROLLBACK TO SAVEPOINT UPDATE_LEG_SP_SAVEPOINT;

					--generate the exception message:
					V_EXCEPTION_MSG := 'A Cruise record (CRUISE_ID: '||P_CRUISE_ID||') could not be found in the database';

					--log the processing error:
			    DB_LOG_PKG.ADD_LOG_ENTRY('ERROR', V_TEMP_LOG_SOURCE, V_EXCEPTION_MSG, V_SP_RET_CODE);

					--raise a custom application error:
					RAISE_APPLICATION_ERROR (-20522, V_EXCEPTION_MSG);
				WHEN EXC_ARRAY_FIND_ERR THEN
					--the PV_OVERLAP_CRUISE_IDS package array variable could not be searched successfully

					--rollback all of the DML that was executed in the procedure since the procedure failed:
					ROLLBACK TO SAVEPOINT UPDATE_LEG_SP_SAVEPOINT;

					--raise a custom application error:
					RAISE_APPLICATION_ERROR (-20521, V_EXCEPTION_MSG);

				WHEN OTHERS THEN
					--catch other exceptions

					--rollback all of the DML that was executed in the procedure since the procedure failed:
					ROLLBACK TO SAVEPOINT UPDATE_LEG_SP_SAVEPOINT;

					--check if this was a DVM processing error
					IF (SQLCODE = -20508) THEN
						--this was a DVM processing error, report the general error:

						--check to see if this is an overlapping cruise or the updated cruise
						IF (V_CURR_CRUISE_ID IS NULL) THEN
							--this is the updated cruise that failed DVM processing

							--generate the exception message:
							V_EXCEPTION_MSG := 'The specific Leg''s associated Cruise (CRUISE_ID: '||P_CRUISE_ID||') could not be processed successfully:'||chr(10)||SQLERRM;

							--set the exception code:
							V_EXC_CODE := -20523;
						ELSE
							--this is an overlapping cruise that failed DVM processing

							--generate the exception message:
							V_EXCEPTION_MSG := 'An overlapping Cruise (CRUISE_ID: '||V_CURR_CRUISE_ID||') could not be processed successfully:'||chr(10)||SQLERRM;

							--set the exception code:
							V_EXC_CODE := -20524;

						END IF;

						--log the processing error:
						DB_LOG_PKG.ADD_LOG_ENTRY ('ERROR', V_TEMP_LOG_SOURCE, V_EXCEPTION_MSG, V_SP_RET_CODE);

						--raise a custom application error:
						RAISE_APPLICATION_ERROR (V_EXC_CODE, V_EXCEPTION_MSG);

					ELSE


						--generate the exception message:
						V_EXCEPTION_MSG := 'The specific Leg''s associated Cruise overlaps could not be retrieved successfully:'||chr(10)||SQLERRM;

						--log the processing error:
						DB_LOG_PKG.ADD_LOG_ENTRY ('ERROR', V_TEMP_LOG_SOURCE, V_EXCEPTION_MSG, V_SP_RET_CODE);

						--raise a custom application error:
						RAISE_APPLICATION_ERROR (-20521, V_EXCEPTION_MSG);
					END IF;

		END POST_UPDATE_LEG_SP;

		--this procedure will accept a P_CRUISE_NAME parameter for the cruise that was updated to validate the updated Cruise and also validate all corresponding overlapping cruise ID values
		PROCEDURE POST_UPDATE_LEG_SP (P_CRUISE_NAME IN CCD_CRUISES.CRUISE_NAME%TYPE) IS

			--procedure variable to store the return codes from each procedure call to determine the results of the procedure execution
			V_SP_RET_CODE PLS_INTEGER;

			--variable to store the CRUISE_ID for the specified P_CRUISE_NAME value
			V_CRUISE_ID CCD_CRUISES.CRUISE_ID%TYPE;

			--variable to store the constructed log source string for the current procedure's log messages:
			V_TEMP_LOG_SOURCE DB_LOG_ENTRIES.LOG_SOURCE%TYPE;

			--variable to store the exception message:
			V_EXCEPTION_MSG VARCHAR2(2000);

			--exception for blank required parameters:
			EXC_BLANK_PARAMS EXCEPTION;

		BEGIN


			--construct the DB_LOG_ENTRIES.LOG_SOURCE value for all logging messages in this procedure based on the procedure/function name and parameters:
			V_TEMP_LOG_SOURCE := 'POST_UPDATE_LEG_SP (P_CRUISE_NAME: '||P_CRUISE_NAME||')';

			DB_LOG_PKG.ADD_LOG_ENTRY('DEBUG', V_TEMP_LOG_SOURCE, 'running POST_UPDATE_LEG_SP ()', V_SP_RET_CODE);

			--check if the P_CRUISE_NAME parameter is blank
			IF (P_CRUISE_NAME IS NULL) THEN
				--the P_CRUISE_NAME parameter is blank

				--generate the exception message:
				V_EXCEPTION_MSG := 'The Cruise Name parameter was not specified';

				--log the processing error:
				DB_LOG_PKG.ADD_LOG_ENTRY ('ERROR', V_TEMP_LOG_SOURCE, V_EXCEPTION_MSG, V_SP_RET_CODE);

				--raise the defined exception:
				RAISE EXC_BLANK_PARAMS;

			END IF;

			--query for the CRUISE_ID for the corresponding P_CRUISE_NAME value
			SELECT CRUISE_ID INTO V_CRUISE_ID FROM CCD_CRUISES WHERE UPPER(CRUISE_NAME) = UPPER(P_CRUISE_NAME);

			--delete the cruise and associated DVM records:
			POST_UPDATE_LEG_SP(V_CRUISE_ID);


      EXCEPTION
        --catch all PL/SQL database exceptions:

				WHEN EXC_BLANK_PARAMS then
					--blank CRUISE_NAME parameter:

					--raise a custom application error:
					RAISE_APPLICATION_ERROR (-20520, V_EXCEPTION_MSG);


				WHEN NO_DATA_FOUND THEN
					--catch not matching cruise record error:


					--generate the exception message:
					V_EXCEPTION_MSG := 'A Cruise record with a name "'||P_CRUISE_NAME||'" could not be found in the database';

					--log the processing error:
			    DB_LOG_PKG.ADD_LOG_ENTRY('ERROR', V_TEMP_LOG_SOURCE, V_EXCEPTION_MSG, V_SP_RET_CODE);

					--raise a custom application error:
					RAISE_APPLICATION_ERROR (-20522, V_EXCEPTION_MSG);

        WHEN OTHERS THEN
				  --catch all other errors:

					--check if there are any special exceptions for the POST_UPDATE_LEG_SP (P_CRUISE_ID) procedure
					IF (SQLCODE IN (-20520, -20521, -20522, -20523, -20524)) THEN
						--this is a special exception from the POST_UPDATE_LEG_SP (P_CRUISE_ID) procedure

						--re raise the exception:
						RAISE;

					ELSE
						--this is not a special exception from the POST_UPDATE_LEG_SP (P_CRUISE_ID) procedure:

						--generate the exception message:
						V_EXCEPTION_MSG := 'The specific updated Leg''s Cruise could not be validated as well as all overlapping cruises:'||chr(10)||SQLERRM;

						--log the processing error:
						DB_LOG_PKG.ADD_LOG_ENTRY ('ERROR', V_TEMP_LOG_SOURCE, V_EXCEPTION_MSG, V_SP_RET_CODE);

						--raise a custom application error:
						RAISE_APPLICATION_ERROR (-20521, V_EXCEPTION_MSG);
					END IF;


		END POST_UPDATE_LEG_SP;

	end CCD_DVM_PKG;
	/






	--CCD_CRUISE_PKG Package Specification:
	CREATE OR REPLACE PACKAGE CCD_CRUISE_PKG
	AUTHID DEFINER
	--this package provides functions and procedures to interact with the Cruise package module

	AS

		--function that accepts a P_LEG_ALIAS value and returns the CRUISE_LEG_ID value for the CCD_CRUISE_LEGS record that has a corresponding CCD_LEG_ALIASES record with a LEG_ALIAS_NAME ar CCD_CRUISE_LEGS.LEG_NAME value that matches the P_LEG_ALIAS value.	It returns NULL if no match is found
		FUNCTION LEG_ALIAS_TO_CRUISE_LEG_ID_FN (P_LEG_ALIAS VARCHAR2) RETURN NUMBER;

		--Append Reference Preset Options function
		--function that accepts a list of colon-delimited integers (P_DELIM_VALUES) representing the primary key values of the given reference table preset options.	The P_OPTS_QUERY is the query for the primary key values for the given options query with a primary key parameter that will be used with the defined primary key value (P_PK_VAL) when executing the query to return the associated primary key values.	The return value will be the colon-delimited string that contains any additional primary key values that were returned by the P_OPTS_QUERY
		FUNCTION APPEND_REF_PRE_OPTS_FN (P_DELIM_VALUES IN VARCHAR2, P_OPTS_QUERY IN VARCHAR2, P_PK_VAL IN NUMBER) RETURN VARCHAR2;


		--Deep copy cruise stored procedure:
		--This procedure accepts a P_CRUISE_ID parameter that contains the CRUISE_ID primary key integer value that will have all of its associated records copied (cruise name, leg names, and leg alias names will be copied with a naming convention but all other associated records will be loaded as-is to the new cruise record).	The value of P_SP_RET_CODE is 1 if the cruise record was successfully processed and the records were copied and 0 if the procedure encountered any errors during execution, if there were errors the SQL transaction will be rolled back.	P_PROC_RETURN_MSG will contain a message to indicate that the procedure was completed successfully or unsuccessfully with information about the results so they can be provided to the user.	P_PROC_RETURN_CRUISE_ID contains the CRUISE_ID for the newly inserted cruise record so it can be provided to the user, in the APEX application it is used to construct a URL to allow an authorized user to view/edit the newly copied cruise record
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
		--This procedure accepts a P_CRUISE_NAME parameter that contains the unique CRUISE_NAME value that will have all of its associated records copied (cruise name, leg names, and leg alias names will be copied with a naming convention but all other associated records will be loaded as-is to the new cruise record).	The value of P_SP_RET_CODE is 1 if the cruise record was successfully processed and the records were copied and 0 if the procedure encountered any errors during execution, if there were errors the SQL transaction will be rolled back.	P_PROC_RETURN_MSG will contain a message to indicate that the procedure was completed successfully or unsuccessfully with information about the results so they can be provided to the user.	P_PROC_RETURN_CRUISE_ID contains the CRUISE_ID for the newly inserted cruise record so it can be provided to the user, in the APEX application it is used to construct a URL to allow an authorized user to view/edit the newly copied cruise record
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

		--this procedure copies all leg aliases from the cruise leg with CRUISE_LEG_ID = P_SOURCE_LEG_ID to a newly inserted cruise leg with CRUISE_LEG_ID = P_NEW_LEG_ID modifying each leg alias to append (copy) to it.	The value of P_SP_RET_CODE will be 1 if the procedure successfully processed the leg aliases from the given source leg to the new leg and 0 if it was not, if it was unsuccessful the SQL transaction will be rolled back.	The procedure checks for unique key constraint violations and reports any error message using the P_PROC_RETURN_MSG parameter
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





		--function that accepts a P_LEG_ALIAS value and returns the CRUISE_LEG_ID value for the CCD_CRUISE_LEGS record that has a corresponding CCD_LEG_ALIASES record with a LEG_ALIAS_NAME ar CCD_CRUISE_LEGS.LEG_NAME value that matches the P_LEG_ALIAS value.	It returns NULL if no match is found
		FUNCTION LEG_ALIAS_TO_CRUISE_LEG_ID_FN (P_LEG_ALIAS VARCHAR2)
			RETURN NUMBER is

						--variable to store the cruise_leg_id associated with the leg alias record with leg_alias_name = P_LEG_ALIAS
						v_cruise_leg_id NUMBER;

						--return code from procedure calls
						V_SP_RET_CODE PLS_INTEGER;

		BEGIN

				--query for the cruise_leg_id primary key value from the cruise leg that matches any associated leg aliases

				--select only distinct cruise_leg_ID values
				select DISTINCT CRUISE_LEG_ID INTO v_cruise_leg_id FROM
				(select
				CRUISE_LEG_ID, LEG_NAME FROM CCD_CRUISE_LEGS
				UNION ALL
				select CRUISE_LEG_ID, LEG_ALIAS_NAME LEG_NAME FROM CCD_LEG_ALIASES
				)
				COMB_LEG_INFO
				WHERE
				UPPER(COMB_LEG_INFO.LEG_NAME) =  UPPER(P_LEG_ALIAS);

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
		--function that accepts a list of colon-delimited integers (P_DELIM_VALUES) representing the primary key values of the given reference table preset options.	The P_OPTS_QUERY is the query for the primary key values for the given options query with a primary key parameter that will be used with the defined primary key value (P_PK_VAL) when executing the query to return the associated primary key values.	The return value will be the colon-delimited string that contains any additional primary key values that were returned by the P_OPTS_QUERY
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

	--						DB_LOG_PKG.ADD_LOG_ENTRY('DEBUG', 'APPEND_REF_PRE_OPTS', 'The current shuttle option is: '||l_selected(i), V_SP_RET_CODE);

							--check if the current l_selected array element matches the current result set primary key value
							IF (l_selected(i) = V_OPT_PK_VAL) THEN
								--the values match, update V_ID_FOUND to indicate that the match has been found
									V_ID_FOUND := TRUE;
							END IF;
					end loop;

					--check to see if a match has been found for the current result set primary key and the l_selected array elements
					IF NOT V_ID_FOUND THEN
						--a match has not been found, add the result set primary key value to the array:

	--						DB_LOG_PKG.ADD_LOG_ENTRY('DEBUG', 'APPEND_REF_PRE_OPTS', 'None of the shuttle option values match the current option, add it to the l_selected array', V_SP_RET_CODE);

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
		--This procedure accepts a P_CRUISE_ID parameter that contains the CRUISE_ID primary key integer value that will have all of its associated records copied (cruise name, leg names, and leg alias names will be copied with a naming convention but all other associated records will be loaded as-is to the new cruise record).	The value of P_SP_RET_CODE is 1 if the cruise record was successfully processed and the records were copied and 0 if the procedure encountered any errors during execution, if there were errors the SQL transaction will be rolled back.	P_PROC_RETURN_MSG will contain a message to indicate that the procedure was completed successfully or unsuccessfully with information about the results so they can be provided to the user.	P_PROC_RETURN_CRUISE_ID contains the CRUISE_ID for the newly inserted cruise record so it can be provided to the user, in the APEX application it is used to construct a URL to allow an authorized user to view/edit the newly copied cruise record
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

					--insert the new cruise leg with the values in the source cruise leg and " (copy)" appended to the leg name and associate it with the new cruise record that was just inserted (identified by V_NEW_CRUISE_ID).	Return the CCD_CRUISE_LEGS.CRUISE_LEG_ID primary key into V_NEW_CRUISE_LEG_ID so it can be used to associate the cruise leg attributes
					INSERT INTO CCD_CRUISE_LEGS (LEG_NAME, LEG_START_DATE, LEG_END_DATE, LEG_DESC, CRUISE_ID, VESSEL_ID, PLAT_TYPE_ID, TZ_NAME)
					VALUES (v_leg_tab(i).LEG_NAME||' (copy)', v_leg_tab(i).LEG_START_DATE, v_leg_tab(i).LEG_END_DATE, v_leg_tab(i).LEG_DESC, V_NEW_CRUISE_ID, v_leg_tab(i).VESSEL_ID, v_leg_tab(i).PLAT_TYPE_ID, v_leg_tab(i).TZ_NAME)
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
			P_PROC_RETURN_MSG := 'The Cruise "'||cruise_tab.CRUISE_NAME||'" was successfully copied as "'||cruise_tab.CRUISE_NAME||' (copy)" and '||V_NUM_LEGS||' legs were copied and associated with the new Cruise.	The DVM was used to validate the new Cruise';

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
		--This procedure accepts a P_CRUISE_NAME parameter that contains the unique CRUISE_NAME value that will have all of its associated records copied (cruise name, leg names, and leg alias names will be copied with a naming convention but all other associated records will be loaded as-is to the new cruise record).	The value of P_SP_RET_CODE is 1 if the cruise record was successfully processed and the records were copied and 0 if the procedure encountered any errors during execution, if there were errors the SQL transaction will be rolled back.	P_PROC_RETURN_MSG will contain a message to indicate that the procedure was completed successfully or unsuccessfully with information about the results so they can be provided to the user.	P_PROC_RETURN_CRUISE_ID contains the CRUISE_ID for the newly inserted cruise record so it can be provided to the user, in the APEX application it is used to construct a URL to allow an authorized user to view/edit the newly copied cruise record
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


		--this procedure copies all leg aliases from the cruise leg with CRUISE_LEG_ID = P_SOURCE_LEG_ID to a newly inserted cruise leg with CRUISE_LEG_ID = P_NEW_LEG_ID modifying each leg alias to append (copy) to it.	The value of P_SP_RET_CODE will be 1 if the procedure successfully processed the leg aliases from the given source leg to the new leg and 0 if it was not, if it was unsuccessful the SQL transaction will be rolled back.	The procedure checks for unique key constraint violations and reports any error message using the P_PROC_RETURN_MSG parameter
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
INSERT INTO DB_UPGRADE_LOGS (UPGRADE_APP_NAME, UPGRADE_VERSION, UPGRADE_DATE, UPGRADE_DESC) VALUES ('Centralized Cruise Database', '1.0', TO_DATE('04-OCT-23', 'DD-MON-YY'), 'Upgraded from Version 0.4 (Git tag: APX_Cust_Err_Handler_db_v0.4) to	Version 1.0 (Git tag: APX_Cust_Err_Handler_db_v1.0) of the APEX custom error handler module database (Git URL: git@picgitlab.nmfs.local:centralized-data-tools/apex_tools.git in the "Error Handling" folder).	Dropped the standalone AAM.	Adding TZ offset to cruise legs table');


--commit the DB_UPGRADE_LOGS record insertion
COMMIT;
