--------------------------------------------------------
--------------------------------------------------------
--Database Name: Centralized Cruise Database
--Database Description: Centralized Cruise Database to track information about each PIFSC research cruise including activities, chief scientists, regions, etc. to remove the need for each division/program to manage this information
--------------------------------------------------------
--------------------------------------------------------


--------------------------------------------------------
--Centralized Cruise Database - version 0.2 updates:
--------------------------------------------------------

CREATE TABLE CCD_DATA_SET_TYPES
(
  DATA_SET_TYPE_ID NUMBER NOT NULL
, DATA_SET_TYPE_NAME VARCHAR2(200) NOT NULL
, DATA_SET_TYPE_DESC VARCHAR2(2000)
, CONSTRAINT CCD_DATA_SET_TYPES_PK PRIMARY KEY
  (
    DATA_SET_TYPE_ID
  )
  ENABLE
);

COMMENT ON TABLE CCD_DATA_SET_TYPES IS 'Research Cruise Data Set Types

This table defines the different data set types that are collected by PIFSC';

COMMENT ON COLUMN CCD_DATA_SET_TYPES.DATA_SET_TYPE_ID IS 'Primary key for the CCD_DATA_SET_TYPES table';

COMMENT ON COLUMN CCD_DATA_SET_TYPES.DATA_SET_TYPE_NAME IS 'Name for the data set type';

COMMENT ON COLUMN CCD_DATA_SET_TYPES.DATA_SET_TYPE_DESC IS 'Description for the data set type';



ALTER TABLE CCD_DATA_SET_TYPES
ADD (DATA_SET_TYPE_DOC_URL VARCHAR2(500) );

COMMENT ON COLUMN CCD_DATA_SET_TYPES.DATA_SET_TYPE_DOC_URL IS 'Documentation URL for the data type, this can be an InPort URL for the parent Project record of the individual data sets or a documentation package that provides information about this data set type';


CREATE SEQUENCE CCD_DATA_SET_TYPES_SEQ INCREMENT BY 1 START WITH 1;
ALTER TABLE CCD_DATA_SET_TYPES ADD (CREATE_DATE DATE );

ALTER TABLE CCD_DATA_SET_TYPES ADD (CREATED_BY VARCHAR2(30) );
ALTER TABLE CCD_DATA_SET_TYPES ADD (LAST_MOD_DATE DATE );


ALTER TABLE CCD_DATA_SET_TYPES ADD (LAST_MOD_BY VARCHAR2(30) );
COMMENT ON COLUMN CCD_DATA_SET_TYPES.CREATE_DATE IS 'The date on which this record was created in the database';
COMMENT ON COLUMN CCD_DATA_SET_TYPES.CREATED_BY IS 'The Oracle username of the person creating this record in the database';
COMMENT ON COLUMN CCD_DATA_SET_TYPES.LAST_MOD_DATE IS 'The last date on which any of the data in this record was changed';
COMMENT ON COLUMN CCD_DATA_SET_TYPES.LAST_MOD_BY IS 'The Oracle username of the person making the most recent change to this record';


create or replace TRIGGER CCD_DATA_SET_TYPES_AUTO_BRI
before insert on CCD_DATA_SET_TYPES
for each row
begin
  select CCD_DATA_SET_TYPES_SEQ.nextval into :new.DATA_SET_TYPE_ID from dual;
  :NEW.CREATE_DATE := SYSDATE;
  :NEW.CREATED_BY := nvl(v('APP_USER'),user);
end;
/

CREATE OR REPLACE TRIGGER CCD_DATA_SET_TYPES_AUTO_BRU BEFORE
  UPDATE
    ON CCD_DATA_SET_TYPES FOR EACH ROW
    BEGIN
      :NEW.LAST_MOD_DATE := SYSDATE;
      :NEW.LAST_MOD_BY := nvl(v('APP_USER'),user);
END;
/



CREATE TABLE CCD_CRUISE_LEGS
(
  CRUISE_LEG_ID NUMBER NOT NULL
, LEG_NAME VARCHAR2(100) NOT NULL
, LEG_START_DATE DATE NOT NULL
, LEG_END_DATE DATE NOT NULL
, LEG_DESC VARCHAR2(2000)
, CRUISE_ID NUMBER NOT NULL
, CONSTRAINT CCD_CRUISE_LEGS_PK PRIMARY KEY
  (
    CRUISE_LEG_ID
  )
  ENABLE
);

CREATE INDEX CCD_CRUISE_LEGS_I1 ON CCD_CRUISE_LEGS (CRUISE_ID);

ALTER TABLE CCD_CRUISE_LEGS
ADD CONSTRAINT CCD_CRUISE_LEGS_U1 UNIQUE
(
  LEG_NAME
)
ENABLE;

ALTER TABLE CCD_CRUISE_LEGS
ADD CONSTRAINT CCD_CRUISE_LEGS_FK1 FOREIGN KEY
(
  CRUISE_ID
)
REFERENCES CCD_CRUISES
(
  CRUISE_ID
)
ENABLE;

COMMENT ON COLUMN CCD_CRUISE_LEGS.CRUISE_LEG_ID IS 'Primary key for the CCD_CRUISE_LEGS table';

COMMENT ON COLUMN CCD_CRUISE_LEGS.LEG_NAME IS 'The name of the given cruise leg';

COMMENT ON COLUMN CCD_CRUISE_LEGS.LEG_START_DATE IS 'The start date for the given research cruise leg';

COMMENT ON COLUMN CCD_CRUISE_LEGS.LEG_END_DATE IS 'The end date for the given research cruise leg';

COMMENT ON COLUMN CCD_CRUISE_LEGS.LEG_DESC IS 'The description for the given research cruise leg';

COMMENT ON COLUMN CCD_CRUISE_LEGS.CRUISE_ID IS 'The cruise for the given research cruise leg';

COMMENT ON TABLE CCD_CRUISE_LEGS IS 'Research Cruise Legs

This table defines the different legs for a given research cruise, there can be one or more legs per cruise each with a start and end date';

CREATE TABLE CCD_DATA_SETS
(
  DATA_SET_ID NUMBER NOT NULL
, DATA_SET_DESC VARCHAR2(2000)
, DATA_SET_TYPE_ID NUMBER NOT NULL
, DATA_SET_DOI VARCHAR2(50)
, DATA_SET_INPORT_URL VARCHAR2(300)
, DATA_SET_ACCESS_URL VARCHAR2(300)
, DATA_SET_ARCHIVE_URL VARCHAR2(300)
, CONSTRAINT CCD_DATA_SETS_PK PRIMARY KEY
  (
    DATA_SET_ID
  )
  ENABLE
);

CREATE INDEX CCD_DATA_SETS_I1 ON CCD_DATA_SETS (DATA_SET_TYPE_ID);

ALTER TABLE CCD_DATA_SETS
ADD CONSTRAINT CCD_DATA_SETS_FK1 FOREIGN KEY
(
  DATA_SET_TYPE_ID
)
REFERENCES CCD_DATA_SET_TYPES
(
  DATA_SET_TYPE_ID
)
ENABLE;

COMMENT ON TABLE CCD_DATA_SETS IS 'Research Cruise Data Sets

This table defines the specifics data sets that were collected during PIFSC research cruises';

COMMENT ON COLUMN CCD_DATA_SETS.DATA_SET_ID IS 'Primary key for the CCD_DATA_SETS table';

COMMENT ON COLUMN CCD_DATA_SETS.DATA_SET_DESC IS 'Description for the data set';

COMMENT ON COLUMN CCD_DATA_SETS.DATA_SET_TYPE_ID IS 'Data set type for the data set';

COMMENT ON COLUMN CCD_DATA_SETS.DATA_SET_DOI IS 'DOI (digital object identifier) for the data set';

COMMENT ON COLUMN CCD_DATA_SETS.DATA_SET_INPORT_URL IS 'InPort metadata URL for the data set, data accessibility and archival information (if any) is defined in InPort';

COMMENT ON COLUMN CCD_DATA_SETS.DATA_SET_ACCESS_URL IS 'Publicly accessible URL for the data set, where the data can be accessed';

COMMENT ON COLUMN CCD_DATA_SETS.DATA_SET_ARCHIVE_URL IS 'Archive URL for the data set, where the data can be accessed as a bulk download';

ALTER TABLE CCD_DATA_SETS
ADD (CRUISE_LEG_ID NUMBER NOT NULL);

CREATE INDEX CCD_DATA_SETS_I2 ON CCD_DATA_SETS (CRUISE_LEG_ID);


ALTER TABLE CCD_DATA_SETS
ADD CONSTRAINT CCD_DATA_SETS_FK2 FOREIGN KEY
(
  CRUISE_LEG_ID
)
REFERENCES CCD_CRUISE_LEGS
(
  CRUISE_LEG_ID
)
ENABLE;

COMMENT ON COLUMN CCD_DATA_SETS.CRUISE_LEG_ID IS 'The research cruise leg that the data set was collected during';



CREATE SEQUENCE CCD_DATA_SETS_SEQ INCREMENT BY 1 START WITH 1;
ALTER TABLE CCD_DATA_SETS ADD (CREATE_DATE DATE );
ALTER TABLE CCD_DATA_SETS
ADD (CREATED_BY VARCHAR2(30) );
ALTER TABLE CCD_DATA_SETS
ADD (LAST_MOD_DATE DATE );

ALTER TABLE CCD_DATA_SETS
ADD (LAST_MOD_BY VARCHAR2(30) );
COMMENT ON COLUMN CCD_DATA_SETS.CREATE_DATE IS 'The date on which this record was created in the database';
COMMENT ON COLUMN CCD_DATA_SETS.CREATED_BY IS 'The Oracle username of the person creating this record in the database';
COMMENT ON COLUMN CCD_DATA_SETS.LAST_MOD_DATE IS 'The last date on which any of the data in this record was changed';
COMMENT ON COLUMN CCD_DATA_SETS.LAST_MOD_BY IS 'The Oracle username of the person making the most recent change to this record';

create or replace TRIGGER CCD_DATA_SETS_AUTO_BRI
before insert on CCD_DATA_SETS
for each row
begin
  select CCD_DATA_SETS_SEQ.nextval into :new.DATA_SET_ID from dual;
  :NEW.CREATE_DATE := SYSDATE;
  :NEW.CREATED_BY := nvl(v('APP_USER'),user);
end;
/
	CREATE OR REPLACE TRIGGER CCD_DATA_SETS_AUTO_BRU BEFORE
  UPDATE
    ON CCD_DATA_SETS FOR EACH ROW
    BEGIN
      :NEW.LAST_MOD_DATE := SYSDATE;
      :NEW.LAST_MOD_BY := nvl(v('APP_USER'),user);
END;
/


CREATE TABLE CCD_DATA_SET_STATUS
(
  DATA_SET_STATUS_ID NUMBER NOT NULL
, STATUS_CODE VARCHAR2(10) NOT NULL
, STATUS_NAME VARCHAR2(100) NOT NULL
, STATUS_DESC VARCHAR2(2000)
, STATUS_COLOR VARCHAR2(20)
, CONSTRAINT CCD_DATA_STATUS_PK PRIMARY KEY
  (
    DATA_SET_STATUS_ID
  )
  ENABLE
);

ALTER TABLE CCD_DATA_SET_STATUS
ADD CONSTRAINT CCD_DATA_SET_STATUS_U1 UNIQUE
(
  STATUS_CODE
)
ENABLE;

ALTER TABLE CCD_DATA_SET_STATUS
ADD CONSTRAINT CCD_DATA_SET_STATUS_U2 UNIQUE
(
  STATUS_NAME
)
ENABLE;

COMMENT ON TABLE CCD_DATA_SET_STATUS IS 'Research Cruise Data Set Status

This table stores the different statuses for data sets that are collected during PIFSC research cruises';

COMMENT ON COLUMN CCD_DATA_SET_STATUS.DATA_SET_STATUS_ID IS 'Primary key for the CCD_DATA_SET_STATUS table';

COMMENT ON COLUMN CCD_DATA_SET_STATUS.STATUS_CODE IS 'The alpha-numeric code for the data status';

COMMENT ON COLUMN CCD_DATA_SET_STATUS.STATUS_NAME IS 'The name of the data status';

COMMENT ON COLUMN CCD_DATA_SET_STATUS.STATUS_DESC IS 'The description for the data status';

COMMENT ON COLUMN CCD_DATA_SET_STATUS.STATUS_COLOR IS 'The hex value for the color that the data set status has in the application interface';


ALTER TABLE CCD_DATA_SETS
ADD (DATA_SET_STATUS_ID NUMBER NOT NULL);

CREATE INDEX CCD_DATA_SETS_I3 ON CCD_DATA_SETS (DATA_SET_STATUS_ID);

ALTER TABLE CCD_DATA_SETS
ADD CONSTRAINT CCD_DATA_SETS_FK3 FOREIGN KEY
(
  DATA_SET_STATUS_ID
)
REFERENCES CCD_DATA_SET_STATUS
(
  DATA_SET_STATUS_ID
)
ENABLE;

COMMENT ON COLUMN CCD_DATA_SETS.DATA_SET_STATUS_ID IS 'The status for the data set';



CREATE TABLE CCD_REGIONS
(
  REGION_ID NUMBER NOT NULL
, REGION_CODE VARCHAR2(20) NOT NULL
, REGION_NAME VARCHAR2(200) NOT NULL
, REGION_DESC VARCHAR2(2000)
, CONSTRAINT CCD_REGIONS_PK PRIMARY KEY
  (
    REGION_ID
  )
  ENABLE
);

ALTER TABLE CCD_REGIONS
ADD CONSTRAINT CCD_REGIONS_U1 UNIQUE
(
  REGION_CODE
)
ENABLE;

ALTER TABLE CCD_REGIONS
ADD CONSTRAINT CCD_REGIONS_U2 UNIQUE
(
  REGION_NAME
)
ENABLE;

COMMENT ON TABLE CCD_REGIONS IS 'Reearch Cruise Regions

This table defines the different geographical regions where PIFSC conducts cruise operations';

COMMENT ON COLUMN CCD_REGIONS.REGION_ID IS 'Primary key for the CCD_REGIONS table';

COMMENT ON COLUMN CCD_REGIONS.REGION_CODE IS 'The alphabetic code for the given region';

COMMENT ON COLUMN CCD_REGIONS.REGION_NAME IS 'The name of the given region';

COMMENT ON COLUMN CCD_REGIONS.REGION_DESC IS 'The description of the given region';




CREATE TABLE ccd_leg_regions
(
  LEG_REGION_ID NUMBER NOT NULL
, REGION_ID NUMBER NOT NULL
, CRUISE_LEG_ID NUMBER NOT NULL
, LEG_REGION_DESC VARCHAR2(2000)
, CONSTRAINT ccd_leg_regions_PK PRIMARY KEY
  (
    LEG_REGION_ID
  )
  ENABLE
);

CREATE INDEX ccd_leg_regions_I1 ON ccd_leg_regions (REGION_ID);

CREATE INDEX ccd_leg_regions_I2 ON ccd_leg_regions (CRUISE_LEG_ID);

ALTER TABLE ccd_leg_regions
ADD CONSTRAINT ccd_leg_regions_U1 UNIQUE
(
  REGION_ID
, CRUISE_LEG_ID
)
ENABLE;

ALTER TABLE ccd_leg_regions
ADD CONSTRAINT ccd_leg_regions_FK1 FOREIGN KEY
(
  REGION_ID
)
REFERENCES CCD_REGIONS
(
  REGION_ID
)
ENABLE;

ALTER TABLE ccd_leg_regions
ADD CONSTRAINT ccd_leg_regions_FK2 FOREIGN KEY
(
  CRUISE_LEG_ID
)
REFERENCES CCD_CRUISE_LEGS
(
  CRUISE_LEG_ID
)
ENABLE;

COMMENT ON TABLE ccd_leg_regions IS 'Research Cruise Leg Regions

This table defines the many-to-many relationship between research cruise legs and regions.  Each record defines a region was surveyed during a given cruise leg';

COMMENT ON COLUMN ccd_leg_regions.LEG_REGION_ID IS 'Primary key for the ccd_leg_regions table';

COMMENT ON COLUMN ccd_leg_regions.REGION_ID IS 'The region that was surveyed during the given cruise leg';

COMMENT ON COLUMN ccd_leg_regions.CRUISE_LEG_ID IS 'The cruise leg that the given region was surveyed during';

COMMENT ON COLUMN ccd_leg_regions.LEG_REGION_DESC IS 'Description of the region that was surveyed during the given cruise leg';





CREATE SEQUENCE CCD_REGIONS_SEQ INCREMENT BY 1 START WITH 1;
ALTER TABLE CCD_REGIONS ADD (CREATE_DATE DATE );
ALTER TABLE CCD_REGIONS
ADD (CREATED_BY VARCHAR2(30) );
ALTER TABLE CCD_REGIONS
ADD (LAST_MOD_DATE DATE );

ALTER TABLE CCD_REGIONS
ADD (LAST_MOD_BY VARCHAR2(30) );
COMMENT ON COLUMN CCD_REGIONS.CREATE_DATE IS 'The date on which this record was created in the database';
COMMENT ON COLUMN CCD_REGIONS.CREATED_BY IS 'The Oracle username of the person creating this record in the database';
COMMENT ON COLUMN CCD_REGIONS.LAST_MOD_DATE IS 'The last date on which any of the data in this record was changed';
COMMENT ON COLUMN CCD_REGIONS.LAST_MOD_BY IS 'The Oracle username of the person making the most recent change to this record';
CREATE SEQUENCE ccd_leg_regions_SEQ INCREMENT BY 1 START WITH 1;
ALTER TABLE ccd_leg_regions ADD (CREATE_DATE DATE );
ALTER TABLE ccd_leg_regions
ADD (CREATED_BY VARCHAR2(30) );
ALTER TABLE ccd_leg_regions
ADD (LAST_MOD_DATE DATE );

ALTER TABLE ccd_leg_regions
ADD (LAST_MOD_BY VARCHAR2(30) );
COMMENT ON COLUMN ccd_leg_regions.CREATE_DATE IS 'The date on which this record was created in the database';
COMMENT ON COLUMN ccd_leg_regions.CREATED_BY IS 'The Oracle username of the person creating this record in the database';
COMMENT ON COLUMN ccd_leg_regions.LAST_MOD_DATE IS 'The last date on which any of the data in this record was changed';
COMMENT ON COLUMN ccd_leg_regions.LAST_MOD_BY IS 'The Oracle username of the person making the most recent change to this record';
CREATE SEQUENCE ccd_cruise_legs_SEQ INCREMENT BY 1 START WITH 1;
ALTER TABLE ccd_cruise_legs ADD (CREATE_DATE DATE );
ALTER TABLE ccd_cruise_legs
ADD (CREATED_BY VARCHAR2(30) );
ALTER TABLE ccd_cruise_legs
ADD (LAST_MOD_DATE DATE );

ALTER TABLE ccd_cruise_legs
ADD (LAST_MOD_BY VARCHAR2(30) );
COMMENT ON COLUMN ccd_cruise_legs.CREATE_DATE IS 'The date on which this record was created in the database';
COMMENT ON COLUMN ccd_cruise_legs.CREATED_BY IS 'The Oracle username of the person creating this record in the database';
COMMENT ON COLUMN ccd_cruise_legs.LAST_MOD_DATE IS 'The last date on which any of the data in this record was changed';
COMMENT ON COLUMN ccd_cruise_legs.LAST_MOD_BY IS 'The Oracle username of the person making the most recent change to this record';
CREATE SEQUENCE ccd_data_set_status_SEQ INCREMENT BY 1 START WITH 1;
ALTER TABLE ccd_data_set_status ADD (CREATE_DATE DATE );
ALTER TABLE ccd_data_set_status
ADD (CREATED_BY VARCHAR2(30) );
ALTER TABLE ccd_data_set_status
ADD (LAST_MOD_DATE DATE );

ALTER TABLE ccd_data_set_status
ADD (LAST_MOD_BY VARCHAR2(30) );
COMMENT ON COLUMN ccd_data_set_status.CREATE_DATE IS 'The date on which this record was created in the database';
COMMENT ON COLUMN ccd_data_set_status.CREATED_BY IS 'The Oracle username of the person creating this record in the database';
COMMENT ON COLUMN ccd_data_set_status.LAST_MOD_DATE IS 'The last date on which any of the data in this record was changed';
COMMENT ON COLUMN ccd_data_set_status.LAST_MOD_BY IS 'The Oracle username of the person making the most recent change to this record';

create or replace TRIGGER CCD_REGIONS_AUTO_BRI
before insert on CCD_REGIONS
for each row
begin
  select CCD_REGIONS_SEQ.nextval into :new.region_id from dual;
  :NEW.CREATE_DATE := SYSDATE;
  :NEW.CREATED_BY := nvl(v('APP_USER'),user);
end;
/
	CREATE OR REPLACE TRIGGER CCD_REGIONS_AUTO_BRU BEFORE
  UPDATE
    ON CCD_REGIONS FOR EACH ROW
    BEGIN
      :NEW.LAST_MOD_DATE := SYSDATE;
      :NEW.LAST_MOD_BY := nvl(v('APP_USER'),user);
END;
/

create or replace TRIGGER ccd_leg_regions_AUTO_BRI
before insert on ccd_leg_regions
for each row
begin
  select ccd_leg_regions_SEQ.nextval into :new.LEG_REGION_ID from dual;
  :NEW.CREATE_DATE := SYSDATE;
  :NEW.CREATED_BY := nvl(v('APP_USER'),user);
end;
/
	CREATE OR REPLACE TRIGGER ccd_leg_regions_AUTO_BRU BEFORE
  UPDATE
    ON ccd_leg_regions FOR EACH ROW
    BEGIN
      :NEW.LAST_MOD_DATE := SYSDATE;
      :NEW.LAST_MOD_BY := nvl(v('APP_USER'),user);
END;
/

create or replace TRIGGER ccd_cruise_legs_AUTO_BRI
before insert on ccd_cruise_legs
for each row
begin
  select ccd_cruise_legs_SEQ.nextval into :new.CRUISE_LEG_ID from dual;
  :NEW.CREATE_DATE := SYSDATE;
  :NEW.CREATED_BY := nvl(v('APP_USER'),user);
end;
/
	CREATE OR REPLACE TRIGGER ccd_cruise_legs_AUTO_BRU BEFORE
  UPDATE
    ON ccd_cruise_legs FOR EACH ROW
    BEGIN
      :NEW.LAST_MOD_DATE := SYSDATE;
      :NEW.LAST_MOD_BY := nvl(v('APP_USER'),user);
END;
/

create or replace TRIGGER ccd_data_set_status_AUTO_BRI
before insert on ccd_data_set_status
for each row
begin
  select ccd_data_set_status_SEQ.nextval into :new.DATA_SET_STATUS_ID from dual;
  :NEW.CREATE_DATE := SYSDATE;
  :NEW.CREATED_BY := nvl(v('APP_USER'),user);
end;
/
	CREATE OR REPLACE TRIGGER ccd_data_set_status_AUTO_BRU BEFORE
  UPDATE
    ON ccd_data_set_status FOR EACH ROW
    BEGIN
      :NEW.LAST_MOD_DATE := SYSDATE;
      :NEW.LAST_MOD_BY := nvl(v('APP_USER'),user);
END;
/


ALTER TABLE CCD_DATA_SETS
ADD CONSTRAINT CCD_DATA_SETS_U1 UNIQUE
(
  DATA_SET_TYPE_ID
, CRUISE_LEG_ID
)
ENABLE;





ALTER TABLE CCD_CRUISES
DROP COLUMN CRUISE_START_DATE;

ALTER TABLE CCD_CRUISES
DROP COLUMN CRUISE_END_DATE;








CREATE OR REPLACE VIEW

CCD_CRUISES_V
AS

SELECT CCD_CRUISES.CRUISE_ID,
  CCD_CRUISES.CRUISE_NAME,
  CCD_CRUISES.CRUISE_NOTES,
  CCD_VESSELS.VESSEL_NAME,
  CCD_VESSELS.VESSEL_DESC,
  CCD_VESSELS.VESSEL_ID
FROM CCD_CRUISES
INNER JOIN CCD_VESSELS
ON CCD_VESSELS.VESSEL_ID = CCD_CRUISES.VESSEL_ID;

COMMENT ON COLUMN CCD_CRUISES_V.CRUISE_ID IS 'Primary key for the CCD_CRUISES table';
COMMENT ON COLUMN CCD_CRUISES_V.CRUISE_NAME IS 'The name of the given cruise designated by NOAA (e.g. SE-15-01)';
COMMENT ON COLUMN CCD_CRUISES_V.CRUISE_NOTES IS 'Any notes for the given research cruise';
COMMENT ON COLUMN CCD_CRUISES_V.VESSEL_NAME IS 'Primary key for the CCD_VESSELS table';
COMMENT ON COLUMN CCD_CRUISES_V.VESSEL_DESC IS 'Name of the given research vessel';
COMMENT ON COLUMN CCD_CRUISES_V.VESSEL_ID IS 'Description for the given research vessel';

COMMENT ON TABLE CCD_CRUISES_V IS 'Research Cruises (View)

This query returns all of the research cruises and their associated research vessels';






CREATE OR REPLACE VIEW
CCD_CRUISE_LEGS_V

AS
SELECT
CCD_CRUISES_V.CRUISE_ID,
CCD_CRUISES_V.CRUISE_NAME,
CCD_CRUISES_V.CRUISE_NOTES,
CCD_CRUISES_V.VESSEL_NAME,
CCD_CRUISES_V.VESSEL_DESC,
CCD_CRUISES_V.VESSEL_ID,
CCD_CRUISE_LEGS.CRUISE_LEG_ID,
CCD_CRUISE_LEGS.LEG_NAME,
CCD_CRUISE_LEGS.LEG_START_DATE,
TO_CHAR(LEG_START_DATE, 'MM/DD/YYYY') FORMAT_LEG_START_DATE,
CCD_CRUISE_LEGS.LEG_END_DATE,
TO_CHAR(LEG_END_DATE, 'MM/DD/YYYY') FORMAT_LEG_END_DATE,
CCD_CRUISE_LEGS.LEG_DESC,
REGION_CODE_DELIM,
REGION_NAME_DELIM,
NUM_REGIONS

FROM

CCD_CRUISES_V left join CCD_CRUISE_LEGS
ON CCD_CRUISE_LEGS.CRUISE_ID = CCD_CRUISES_V.CRUISE_ID
LEFT JOIN
(SELECT

cruise_leg_id,
LISTAGG(REGION_CODE, ', ') WITHIN GROUP (ORDER BY UPPER(REGION_CODE)) as REGION_CODE_DELIM,
LISTAGG(REGION_NAME, ', ') WITHIN GROUP (ORDER BY UPPER(REGION_NAME)) as REGION_NAME_DELIM,
count(*) NUM_REGIONS
from CCD_LEG_REGIONS INNER JOIN CCD_REGIONS ON CCD_REGIONS.REGION_ID = CCD_LEG_REGIONS.REGION_ID
group by cruise_leg_id) LEG_REGIONS
ON LEG_REGIONS.CRUISE_LEG_ID = CCD_CRUISE_LEGS.CRUISE_LEG_ID
;


COMMENT ON COLUMN CCD_CRUISE_LEGS_V.CRUISE_ID IS 'Primary key for the CCD_CRUISES table';
COMMENT ON COLUMN CCD_CRUISE_LEGS_V.CRUISE_NAME IS 'The name of the given cruise designated by NOAA (e.g. SE-15-01)';
COMMENT ON COLUMN CCD_CRUISE_LEGS_V.CRUISE_NOTES IS 'Any notes for the given research cruise';
COMMENT ON COLUMN CCD_CRUISE_LEGS_V.VESSEL_NAME IS 'Primary key for the CCD_VESSELS table';
COMMENT ON COLUMN CCD_CRUISE_LEGS_V.VESSEL_DESC IS 'Name of the given research vessel';
COMMENT ON COLUMN CCD_CRUISE_LEGS_V.VESSEL_ID IS 'Description for the given research vessel';
COMMENT ON COLUMN CCD_CRUISE_LEGS_V.CRUISE_LEG_ID IS 'Primary key for the CCD_CRUISE_LEGS table';
COMMENT ON COLUMN CCD_CRUISE_LEGS_V.LEG_NAME IS 'The name of the given cruise leg';
COMMENT ON COLUMN CCD_CRUISE_LEGS_V.LEG_START_DATE IS 'The start date for the given research cruise leg';
COMMENT ON COLUMN CCD_CRUISE_LEGS_V.FORMAT_LEG_START_DATE IS 'The start date for the given research cruise leg in MM/DD/YYYY format';

COMMENT ON COLUMN CCD_CRUISE_LEGS_V.LEG_END_DATE IS 'The end date for the given research cruise leg';
COMMENT ON COLUMN CCD_CRUISE_LEGS_V.FORMAT_LEG_END_DATE IS 'The end date for the given research cruise leg in MM/DD/YYYY format';

COMMENT ON COLUMN CCD_CRUISE_LEGS_V.LEG_DESC IS 'The description for the given research cruise leg';

COMMENT ON COLUMN CCD_CRUISE_LEGS_V.REGION_CODE_DELIM IS 'Comma-delimited list of region codes for the given research cruise leg';
COMMENT ON COLUMN CCD_CRUISE_LEGS_V.REGION_NAME_DELIM IS 'Comma-delimited list of region names for the given research cruise leg';
COMMENT ON COLUMN CCD_CRUISE_LEGS_V.NUM_REGIONS IS 'The number of distinct regions associated with the given research cruise leg';


COMMENT ON TABLE CCD_CRUISE_LEGS_V IS 'Research Cruise Legs (View)

This query returns all research cruise legs including a comma-delimited list of associated regions for each leg';


CREATE OR REPLACE VIEW

CCD_CRUISES_SUMM_V
AS

SELECT

  CCD_CRUISES_V.CRUISE_ID,
  CCD_CRUISES_V.CRUISE_NAME,
  CCD_CRUISES_V.CRUISE_NOTES,
  CCD_CRUISES_V.VESSEL_NAME,
  CCD_CRUISES_V.VESSEL_DESC,
  CCD_CRUISES_V.VESSEL_ID,
  MIN (LEG_START_DATE) CRUISE_START_DATE,
  TO_CHAR(MIN (LEG_START_DATE), 'MM/DD/YYYY') format_cruise_start_date,
  MAX (LEG_END_DATE) CRUISE_END_DATE,
  TO_CHAR(MAX (LEG_END_DATE), 'MM/DD/YYYY') format_cruise_end_date,
  SUM (case when ccd_cruise_legs.cruise_leg_id is not null then 1 else 0 end) NUM_LEGS,
  LISTAGG(ccd_cruise_legs.LEG_NAME, ', ') WITHIN GROUP (ORDER BY UPPER(ccd_cruise_legs.LEG_NAME)) as LEG_NAME_DELIM,
  REGION_CODE_DELIM,
  REGION_NAME_DELIM,
  NUM_REGIONS

FROM CCD_CRUISES_V
left join ccd_cruise_legs
on ccd_cruise_legs.cruise_id = CCD_CRUISES_V.CRUISE_ID
left join
(SELECT
CRUISE_ID,
LISTAGG(DIST_CRUISE_REGIONS.REGION_CODE, ', ') WITHIN GROUP (ORDER BY UPPER(DIST_CRUISE_REGIONS.REGION_CODE)) as REGION_CODE_DELIM,
LISTAGG(DIST_CRUISE_REGIONS.REGION_NAME, ', ') WITHIN GROUP (ORDER BY UPPER(DIST_CRUISE_REGIONS.REGION_NAME)) as REGION_NAME_DELIM,
count(*) NUM_REGIONS

FROM

(SELECT
DISTINCT
cruise_id,
REGION_NAME,
REGION_CODE
from
CCD_CRUISE_LEGS
INNER JOIN CCD_LEG_REGIONS
ON CCD_CRUISE_LEGS.CRUISE_LEG_ID = CCD_LEG_REGIONS.CRUISE_LEG_ID
INNER JOIN CCD_REGIONS
ON CCD_REGIONS.REGION_ID = CCD_LEG_REGIONS.REGION_ID) DIST_CRUISE_REGIONS
group by DIST_CRUISE_REGIONS.cruise_id) CRUISE_REGIONS
on CRUISE_REGIONS.cruise_id = CCD_CRUISES_V.cruise_id



group by
CCD_CRUISES_V.CRUISE_ID,
  CCD_CRUISES_V.CRUISE_NAME,
  CCD_CRUISES_V.CRUISE_NOTES,
  CCD_CRUISES_V.VESSEL_NAME,
  CCD_CRUISES_V.VESSEL_DESC,
  CCD_CRUISES_V.VESSEL_ID,
  REGION_CODE_DELIM,
  REGION_NAME_DELIM,
  NUM_REGIONS
;

COMMENT ON COLUMN CCD_CRUISES_SUMM_V.CRUISE_ID IS 'Primary key for the CCD_CRUISES table';
COMMENT ON COLUMN CCD_CRUISES_SUMM_V.CRUISE_NAME IS 'The name of the given cruise designated by NOAA (e.g. SE-15-01)';
COMMENT ON COLUMN CCD_CRUISES_SUMM_V.CRUISE_START_DATE IS 'The start date of the given research cruise';
COMMENT ON COLUMN CCD_CRUISES_SUMM_V.FORMAT_CRUISE_START_DATE IS 'The start date of the given research cruise in MM/DD/YYYY format';
COMMENT ON COLUMN CCD_CRUISES_SUMM_V.CRUISE_END_DATE IS 'The end date of the given research cruise';
COMMENT ON COLUMN CCD_CRUISES_SUMM_V.FORMAT_CRUISE_END_DATE IS 'The end date of the given research cruise in MM/DD/YYYY format';
COMMENT ON COLUMN CCD_CRUISES_SUMM_V.CRUISE_NOTES IS 'Any notes for the given research cruise';
COMMENT ON COLUMN CCD_CRUISES_SUMM_V.VESSEL_NAME IS 'Primary key for the CCD_VESSELS table';
COMMENT ON COLUMN CCD_CRUISES_SUMM_V.VESSEL_DESC IS 'Name of the given research vessel';
COMMENT ON COLUMN CCD_CRUISES_SUMM_V.VESSEL_ID IS 'Description for the given research vessel';
COMMENT ON COLUMN CCD_CRUISES_SUMM_V.NUM_REGIONS IS 'The number of distinct regions associated with the given research cruise';
COMMENT ON COLUMN CCD_CRUISES_SUMM_V.REGION_CODE_DELIM IS 'Comma-delimited list of region codes for the given research cruise';
COMMENT ON COLUMN CCD_CRUISES_SUMM_V.REGION_NAME_DELIM IS 'Comma-delimited list of region names for the given research cruise';
COMMENT ON COLUMN CCD_CRUISES_SUMM_V.NUM_LEGS is 'The number of cruise legs defined for the given research cruise';
COMMENT ON COLUMN CCD_CRUISES_SUMM_V.LEG_NAME_DELIM is 'Comma-delimited list of cruise leg names for the given research cruise';

COMMENT ON TABLE CCD_CRUISES_SUMM_V IS 'Research Cruise Leg Summary (View)

This query returns all of the research cruises and their associated research vessels.  The aggregate cruise leg information is included as start and end dates and the number of legs defined for the given cruise (if any)';









COMMENT ON TABLE CCD_CRUISES IS 'Research Cruises

This table defines the different PIFSC research cruises where data was collected';






CREATE OR REPLACE VIEW

CCD_DATA_SETS_V

AS
SELECT

CCD_DATA_SETS.DATA_SET_ID,
CCD_DATA_SETS.DATA_SET_DESC,
CCD_DATA_SETS.DATA_SET_DOI,
CCD_DATA_SETS.DATA_SET_INPORT_URL,
CCD_DATA_SETS.DATA_SET_ACCESS_URL,
CCD_DATA_SETS.DATA_SET_ARCHIVE_URL,
CCD_DATA_SETS.CRUISE_LEG_ID,
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
COMMENT ON COLUMN CCD_DATA_SETS_V.DATA_SET_DESC IS 'Description for the data set';
COMMENT ON COLUMN CCD_DATA_SETS_V.DATA_SET_DOI IS 'DOI (digital object identifier) for the data set';
COMMENT ON COLUMN CCD_DATA_SETS_V.DATA_SET_INPORT_URL IS 'InPort metadata URL for the data set, data accessibility and archival information (if any) is defined in InPort';
COMMENT ON COLUMN CCD_DATA_SETS_V.DATA_SET_ACCESS_URL IS 'Publicly accessible URL for the data set, where the data can be accessed';
COMMENT ON COLUMN CCD_DATA_SETS_V.DATA_SET_ARCHIVE_URL IS 'Archive URL for the data set, where the data can be accessed as a bulk download';
COMMENT ON COLUMN CCD_DATA_SETS_V.CRUISE_LEG_ID IS 'The research cruise leg that the data set was collected during';
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




ALTER TABLE CCD_CRUISE_ALIASES
DROP CONSTRAINT CCD_CRUISE_ALIASES_FK1;

ALTER TABLE CCD_CRUISE_ALIASES
RENAME TO CCD_LEG_ALIASES;

ALTER TABLE CCD_LEG_ALIASES RENAME COLUMN CRUISE_ALIAS_ID TO LEG_ALIAS_ID;

ALTER TABLE CCD_LEG_ALIASES RENAME COLUMN CRUISE_ALIAS_NAME TO LEG_ALIAS_NAME;

ALTER TABLE CCD_LEG_ALIASES RENAME COLUMN CRUISE_ALIAS_DESC TO LEG_ALIAS_DESC;

ALTER TABLE CCD_LEG_ALIASES RENAME COLUMN CRUISE_ID TO CRUISE_LEG_ID;

ALTER INDEX CCD_CRUISE_ALIASES_I1
RENAME TO CCD_LEG_ALIASES_I1;

ALTER INDEX CCD_CRUISE_ALIASES_PK
RENAME TO CCD_LEG_ALIASES_PK;

ALTER INDEX CCD_CRUISE_ALIASES_U1
RENAME TO CCD_LEG_ALIASES_U1;

ALTER TABLE CCD_LEG_ALIASES
RENAME CONSTRAINT CCD_CRUISE_ALIASES_PK TO CCD_LEG_ALIASES_PK;

ALTER TABLE CCD_LEG_ALIASES
RENAME CONSTRAINT CCD_CRUISE_ALIASES_U1 TO CCD_LEG_ALIASES_U1;

ALTER TABLE CCD_LEG_ALIASES
ADD CONSTRAINT CCD_LEG_ALIASES_FK1 FOREIGN KEY
(
  CRUISE_LEG_ID
)
REFERENCES CCD_CRUISE_LEGS
(
  CRUISE_LEG_ID
)
ENABLE;

COMMENT ON TABLE CCD_LEG_ALIASES IS 'Research Cruise Leg Alias Names

This table defines one or more cruise leg alias names for a given research cruise so that multiple notations for the same cruise leg can be resolved to the cruise leg during which the given data streams were collected';

COMMENT ON COLUMN CCD_LEG_ALIASES.LEG_ALIAS_ID IS 'Primary key of the CCD_LEG_ALIASES table';

COMMENT ON COLUMN CCD_LEG_ALIASES.LEG_ALIAS_NAME IS 'The cruise leg alias name for the given cruise leg';

COMMENT ON COLUMN CCD_LEG_ALIASES.LEG_ALIAS_DESC IS 'The cruise leg alias description for the given cruise leg';

COMMENT ON COLUMN CCD_LEG_ALIASES.CRUISE_LEG_ID IS 'Foreign key reference to the CCD_CRUISE_LEGS table that the given cruise leg name alias is associated with';



--drop the cruise alias triggers
DROP TRIGGER CCD_CRUISE_ALIASES_AUTO_BRU;
DROP TRIGGER CCD_CRUISE_ALIASES_AUTO_BRI;

drop sequence CCD_CRUISE_ALIASES_SEQ;

CREATE SEQUENCE CCD_LEG_ALIASES_SEQ INCREMENT BY 1 START WITH 1;

create or replace TRIGGER CCD_LEG_ALIASES_AUTO_BRI
before insert on CCD_LEG_ALIASES
for each row
begin
  select CCD_LEG_ALIASES_SEQ.nextval into :new.LEG_ALIAS_ID from dual;
  :NEW.CREATE_DATE := SYSDATE;
  :NEW.CREATED_BY := nvl(v('APP_USER'),user);
end;
/

CREATE OR REPLACE TRIGGER CCD_LEG_ALIASES_AUTO_BRU BEFORE
  UPDATE
    ON CCD_LEG_ALIASES FOR EACH ROW
    BEGIN
      :NEW.LAST_MOD_DATE := SYSDATE;
      :NEW.LAST_MOD_BY := nvl(v('APP_USER'),user);
END;
/



alter trigger CCD_CRUISES_AUTO_BRU COMPILE;





create or replace view
CCD_CRUISE_LEG_ALIASES_V

as

SELECT CCD_CRUISES_SUMM_V.CRUISE_ID,
  CCD_CRUISES_SUMM_V.CRUISE_NAME,
  CCD_CRUISES_SUMM_V.CRUISE_START_DATE,
  CCD_CRUISES_SUMM_V.FORMAT_CRUISE_START_DATE,
  CCD_CRUISES_SUMM_V.CRUISE_END_DATE,
  CCD_CRUISES_SUMM_V.FORMAT_CRUISE_END_DATE,
  CCD_CRUISES_SUMM_V.CRUISE_NOTES,
  CCD_CRUISES_SUMM_V.VESSEL_NAME,
  CCD_CRUISES_SUMM_V.VESSEL_DESC,
  CCD_CRUISES_SUMM_V.VESSEL_ID,
  CCD_CRUISES_SUMM_V.NUM_LEGS,
  CCD_CRUISES_SUMM_V.LEG_NAME_DELIM,
  CCD_CRUISES_SUMM_V.REGION_CODE_DELIM,
  CCD_CRUISES_SUMM_V.REGION_NAME_DELIM,
  CCD_CRUISES_SUMM_V.NUM_REGIONS,
  CCD_CRUISE_LEGS.CRUISE_LEG_ID,
  CCD_CRUISE_LEGS.LEG_NAME,
  CCD_CRUISE_LEGS.LEG_START_DATE,
  TO_CHAR(CCD_CRUISE_LEGS.LEG_START_DATE, 'MM/DD/YYYY') FORMAT_LEG_START_DATE,
  CCD_CRUISE_LEGS.LEG_END_DATE,
  TO_CHAR(CCD_CRUISE_LEGS.LEG_END_DATE, 'MM/DD/YYYY') FORMAT_LEG_END_DATE,
  CCD_CRUISE_LEGS.LEG_DESC,
  LEG_ALIASES.leg_aliases_delim

FROM CCD_CRUISES_SUMM_V
inner join CCD_CRUISE_LEGS ON
CCD_CRUISES_SUMM_V.CRUISE_ID = CCD_CRUISE_LEGS.CRUISE_ID
left join
(SELECT

cruise_leg_id,
LISTAGG(LEG_ALIAS_NAME, ', ') WITHIN GROUP (ORDER BY UPPER(LEG_ALIAS_NAME)) as leg_aliases_delim
from CCD_leg_aliases
group by cruise_leg_id) LEG_ALIASES
on CCD_CRUISE_LEGS.CRUISE_LEG_ID = LEG_ALIASES.CRUISE_LEG_ID
GROUP BY
CCD_CRUISES_SUMM_V.CRUISE_ID,
  CCD_CRUISES_SUMM_V.CRUISE_NAME,
  CCD_CRUISES_SUMM_V.CRUISE_START_DATE,
  CCD_CRUISES_SUMM_V.FORMAT_CRUISE_START_DATE,
  CCD_CRUISES_SUMM_V.CRUISE_END_DATE,
  CCD_CRUISES_SUMM_V.FORMAT_CRUISE_END_DATE,
  CCD_CRUISES_SUMM_V.CRUISE_NOTES,
  CCD_CRUISES_SUMM_V.VESSEL_NAME,
  CCD_CRUISES_SUMM_V.VESSEL_DESC,
  CCD_CRUISES_SUMM_V.VESSEL_ID,
  CCD_CRUISES_SUMM_V.NUM_LEGS,
  CCD_CRUISES_SUMM_V.LEG_NAME_DELIM,
  CCD_CRUISES_SUMM_V.REGION_CODE_DELIM,
  CCD_CRUISES_SUMM_V.REGION_NAME_DELIM,
  CCD_CRUISES_SUMM_V.NUM_REGIONS,
  CCD_CRUISE_LEGS.CRUISE_LEG_ID,
  CCD_CRUISE_LEGS.LEG_NAME,
  CCD_CRUISE_LEGS.LEG_START_DATE,
  TO_CHAR(CCD_CRUISE_LEGS.LEG_START_DATE, 'MM/DD/YYYY'),
  CCD_CRUISE_LEGS.LEG_END_DATE,
  TO_CHAR(CCD_CRUISE_LEGS.LEG_END_DATE, 'MM/DD/YYYY'),
  CCD_CRUISE_LEGS.LEG_DESC,
  LEG_ALIASES.leg_aliases_delim


order by VESSEL_NAME, cruise_start_date;


COMMENT ON COLUMN CCD_CRUISE_LEG_ALIASES_V.CRUISE_ID IS 'Primary key for the CCD_CRUISES table';
COMMENT ON COLUMN CCD_CRUISE_LEG_ALIASES_V.CRUISE_NAME IS 'The name of the given cruise designated by NOAA (e.g. SE-15-01)';
COMMENT ON COLUMN CCD_CRUISE_LEG_ALIASES_V.CRUISE_START_DATE IS 'The start date of the given research cruise';
COMMENT ON COLUMN CCD_CRUISE_LEG_ALIASES_V.FORMAT_CRUISE_START_DATE IS 'The start date of the given research cruise in MM/DD/YYYY format';
COMMENT ON COLUMN CCD_CRUISE_LEG_ALIASES_V.CRUISE_END_DATE IS 'The end date of the given research cruise';
COMMENT ON COLUMN CCD_CRUISE_LEG_ALIASES_V.FORMAT_CRUISE_END_DATE IS 'The end date of the given research cruise in MM/DD/YYYY format';
COMMENT ON COLUMN CCD_CRUISE_LEG_ALIASES_V.CRUISE_NOTES IS 'Any notes for the given research cruise';
COMMENT ON COLUMN CCD_CRUISE_LEG_ALIASES_V.VESSEL_NAME IS 'Primary key for the CCD_VESSELS table';
COMMENT ON COLUMN CCD_CRUISE_LEG_ALIASES_V.VESSEL_DESC IS 'Name of the given research vessel';
COMMENT ON COLUMN CCD_CRUISE_LEG_ALIASES_V.VESSEL_ID IS 'Description for the given research vessel';
COMMENT ON COLUMN CCD_CRUISE_LEG_ALIASES_V.LEG_ALIASES_DELIM IS 'Comma delimited list of cruise leg name aliases in alphabetical order for the given research cruise leg';
COMMENT ON COLUMN CCD_CRUISE_LEG_ALIASES_V.NUM_LEGS IS 'The number of cruise legs defined for the given research cruise';
COMMENT ON COLUMN CCD_CRUISE_LEG_ALIASES_V.LEG_NAME_DELIM IS 'Comma-delimited list of cruise leg names for the given research cruise';
COMMENT ON COLUMN CCD_CRUISE_LEG_ALIASES_V.REGION_CODE_DELIM IS 'Comma-delimited list of region codes for the given research cruise leg';
COMMENT ON COLUMN CCD_CRUISE_LEG_ALIASES_V.REGION_NAME_DELIM IS 'Comma-delimited list of region names for the given research cruise leg';
COMMENT ON COLUMN CCD_CRUISE_LEG_ALIASES_V.NUM_REGIONS IS 'The number of distinct regions associated with the given research cruise leg';
COMMENT ON COLUMN CCD_CRUISE_LEG_ALIASES_V.LEG_NAME IS 'The name of the given cruise leg';
COMMENT ON COLUMN CCD_CRUISE_LEG_ALIASES_V.LEG_START_DATE IS 'The start date for the given research cruise leg';

COMMENT ON COLUMN CCD_CRUISE_LEG_ALIASES_V.FORMAT_LEG_START_DATE IS 'The start date for the given research cruise leg in MM/DD/YYYY format';


COMMENT ON COLUMN CCD_CRUISE_LEG_ALIASES_V.LEG_END_DATE IS 'The end date for the given research cruise leg';
COMMENT ON COLUMN CCD_CRUISE_LEG_ALIASES_V.FORMAT_LEG_END_DATE IS 'The end date for the given research cruise leg in MM/DD/YYYY format';
COMMENT ON COLUMN CCD_CRUISE_LEG_ALIASES_V.LEG_DESC IS 'The description for the given research cruise leg';
COMMENT ON COLUMN CCD_CRUISE_LEG_ALIASES_V.CRUISE_LEG_ID IS 'Primary key for the CCD_CRUISE_LEGS table';

COMMENT ON TABLE CCD_CRUISE_LEG_ALIASES_V IS 'Research Cruise Leg Aliases (View)

This query returns all of the CTD cruises, associated research vessels where CTD data was collected including the formatted start and end dates.  This query also returns the comma-delimited list of cruise leg name aliases for each cruise in alphabetical order';

drop view CCD_CRUISE_ALIASES_V;

/*
ALTER TABLE CCD_DATA_SETS
ADD (DIVISION_ID NUMBER NOT NULL);

CREATE INDEX CCD_DATA_SETS_I4 ON CCD_DATA_SETS (DIVISION_ID);

COMMENT ON COLUMN CCD_DATA_SETS.DIVISION_ID IS 'Division that collected the data set';
*/

ALTER TRIGGER CCD_CRUISES_AUTO_BRI COMPILE;


--define the upgrade version in the database upgrade log table:
INSERT INTO DB_UPGRADE_LOGS (UPGRADE_APP_NAME, UPGRADE_VERSION, UPGRADE_DATE, UPGRADE_DESC) VALUES ('Centralized Cruise Database', '0.2', TO_DATE('27-SEP-18', 'DD-MON-YY'), 'Created tables to define data set types, data sets, data set status, cruise legs, regions, cruise leg regions.  Modified CCD_CRUISES table to drop the cruise dates and updated existing dependent views accordingly.  Created CCD_CRUISE_LEGS_V, CCD_CRUISES_SUMM_V, CCD_DATA_SETS_V, CCD_CRUISE_LEG_ALIASES_V.  Modified the CCD_CRUISE_ALIASES table to CCD_CRUISE_LEG_ALIASES to allow cruise legs to have aliases defined for them.  Dropped the CCD_CRUISE_ALIASES_V view');

--commit the DB_UPGRADE_LOGS record insertion
COMMIT;
