--------------------------------------------------------
--------------------------------------------------------
--Database Name: Centralized Cruise Database
--Database Description: Centralized Cruise Database to track information about each PIFSC research cruise including activities, chief scientists, regions, etc. to remove the need for each division/program to manage this information
--------------------------------------------------------
--------------------------------------------------------


--------------------------------------------------------
--Centralized Cruise Database - version 0.1 updates:
--------------------------------------------------------



--Installing version 0.2 of Database Version Control  (Git URL: git@gitlab.pifsc.gov:centralized-data-tools/centralized-tools.git in the DB_version_control folder)--
@@"./external_modules/DB_version_control_DDL_DML_upgrade_v0.1.sql";

@@"./external_modules/DB_version_control_DDL_DML_upgrade_v0.2.sql";






--Installing version 0.6 of Application Authorization Database  (Git URL: git@gitlab.pifsc.gov:centralized-data-tools/centralized-tools.git in the auth_app folder)--

@@"./external_modules/auth_app_DB_DDL_DML_update_v0.1.sql";
@@"./external_modules/auth_app_DB_DDL_DML_update_v0.2.sql";
@@"./external_modules/auth_app_DB_DDL_DML_update_v0.3.sql";
@@"./external_modules/auth_app_DB_DDL_DML_update_v0.4.sql";
@@"./external_modules/auth_app_DB_DDL_DML_update_v0.5.sql";
@@"./external_modules/auth_app_DB_DDL_DML_update_v0.6.sql";



--Installing version 0.3 of Data Validation Module  (Git URL: Git URL: git@gitlab.pifsc.gov:centralized-data-tools/data-validation-module.git)--
@@"./external_modules/DVM_DDL_DML_upgrade_v0.1.sql";
@@"./external_modules/DVM_DDL_DML_upgrade_v0.2.sql";
@@"./external_modules/DVM_DDL_DML_upgrade_v0.3.sql";



--pulling the core cruise database tables from the CENTRAL_CTD



CREATE TABLE CCD_VESSELS
(
  VESSEL_ID NUMBER NOT NULL
, VESSEL_NAME VARCHAR2(200 BYTE) NOT NULL
, VESSEL_DESC VARCHAR2(1000 BYTE)
, CONSTRAINT CCD_VESSELS_PK PRIMARY KEY
(VESSEL_ID)

)
;

COMMENT ON TABLE CCD_VESSELS IS 'Research Vessels

This table defines the information associated with a given research vessel that was used for a given NMFS research cruise';

COMMENT ON COLUMN CCD_VESSELS.VESSEL_ID IS 'Primary key for the CCD_VESSELS table';

COMMENT ON COLUMN CCD_VESSELS.VESSEL_NAME IS 'Name of the given research vessel';

COMMENT ON COLUMN CCD_VESSELS.VESSEL_DESC IS 'Description for the given research vessel';


CREATE TABLE CCD_CRUISES
(
  CRUISE_ID NUMBER NOT NULL
, CRUISE_NAME VARCHAR2(30 BYTE) NOT NULL
, CRUISE_START_DATE DATE
, CRUISE_END_DATE DATE
, CRUISE_NOTES VARCHAR2(500 BYTE)
, VESSEL_ID NUMBER NOT NULL
, CONSTRAINT CCD_CRUISES_PK PRIMARY KEY
  (
    CRUISE_ID
  )
)
;

CREATE INDEX CCD_CRUISES_I1 ON CCD_CRUISES (VESSEL_ID ASC)
;

ALTER TABLE CCD_CRUISES
ADD CONSTRAINT CCD_CRUISES_U1 UNIQUE
(
  CRUISE_NAME
)
 ENABLE;

ALTER TABLE CCD_CRUISES
ADD CONSTRAINT CCD_CRUISES_FK1 FOREIGN KEY
(
  VESSEL_ID
)
REFERENCES CCD_VESSELS
(
  VESSEL_ID
)
ENABLE;

COMMENT ON TABLE CCD_CRUISES IS 'CTD Cruises

This table defines the different PIFSC research cruises where CTD data was collected';

COMMENT ON COLUMN CCD_CRUISES.CRUISE_ID IS 'Primary key for the CCD_CRUISES table';

COMMENT ON COLUMN CCD_CRUISES.CRUISE_NAME IS 'The name of the given cruise designated by NOAA (e.g. SE-15-01)';

COMMENT ON COLUMN CCD_CRUISES.CRUISE_START_DATE IS 'The start date of the given research cruise';

COMMENT ON COLUMN CCD_CRUISES.CRUISE_END_DATE IS 'The end date of the given research cruise';

COMMENT ON COLUMN CCD_CRUISES.CRUISE_NOTES IS 'Any notes for the given research cruise';

COMMENT ON COLUMN CCD_CRUISES.VESSEL_ID IS 'Foreign key reference to the CCD_VESSELS record for the vessel used for the given research cruise';




CREATE TABLE CCD_CRUISE_ALIASES
(
  CRUISE_ALIAS_ID NUMBER NOT NULL
, CRUISE_ALIAS_NAME VARCHAR2(50 BYTE) NOT NULL
, CRUISE_ALIAS_DESC VARCHAR2(1000 BYTE)
, CRUISE_ID NUMBER NOT NULL
, CONSTRAINT CCD_CRUISE_ALIASES_PK PRIMARY KEY
  (
    CRUISE_ALIAS_ID
  )
)
;

CREATE INDEX CCD_CRUISE_ALIASES_I1 ON CCD_CRUISE_ALIASES (CRUISE_ID ASC)
;

ALTER TABLE CCD_CRUISE_ALIASES
ADD CONSTRAINT CCD_CRUISE_ALIASES_U1 UNIQUE
(
  CRUISE_ALIAS_NAME
)
;

ALTER TABLE CCD_CRUISE_ALIASES
ADD CONSTRAINT CCD_CRUISE_ALIASES_FK1 FOREIGN KEY
(
  CRUISE_ID
)
REFERENCES CCD_CRUISES
(
  CRUISE_ID
)
ENABLE;

COMMENT ON TABLE CCD_CRUISE_ALIASES IS 'CTD Cruise Alias Names

This table defines one or more cruise alias names for a given research cruise so that multiple notations for the same cruise can be resolved to the cruise during which the given data streams were collected

';

COMMENT ON COLUMN CCD_CRUISE_ALIASES.CRUISE_ALIAS_ID IS 'Primary key of the CCD_CRUISE_ALIASES table';

COMMENT ON COLUMN CCD_CRUISE_ALIASES.CRUISE_ALIAS_NAME IS 'The cruise alias name for the given cruise';

COMMENT ON COLUMN CCD_CRUISE_ALIASES.CRUISE_ALIAS_DESC IS 'The cruise alias description for the given cruise';

COMMENT ON COLUMN CCD_CRUISE_ALIASES.CRUISE_ID IS 'Foreign key reference to the CCD_CRUISES table that the given cruise name alias is associated with';


ALTER TABLE CCD_VESSELS ADD (CREATE_DATE DATE );	ALTER TABLE CCD_VESSELS
ADD (CREATED_BY VARCHAR2(30) );	ALTER TABLE CCD_VESSELS
ADD (LAST_MOD_DATE DATE );	ALTER TABLE CCD_VESSELS
ADD (LAST_MOD_BY VARCHAR2(30) );	COMMENT ON COLUMN CCD_VESSELS.CREATE_DATE IS 'The date on which this record was created in the database';	COMMENT ON COLUMN CCD_VESSELS.CREATED_BY IS 'The Oracle username of the person creating this record in the database';	COMMENT ON COLUMN CCD_VESSELS.LAST_MOD_DATE IS 'The last date on which any of the data in this record was changed';	COMMENT ON COLUMN CCD_VESSELS.LAST_MOD_BY IS 'The Oracle username of the person making the most recent change to this record';
ALTER TABLE CCD_CRUISES ADD (CREATE_DATE DATE );	ALTER TABLE CCD_CRUISES
ADD (CREATED_BY VARCHAR2(30) );	ALTER TABLE CCD_CRUISES
ADD (LAST_MOD_DATE DATE );	ALTER TABLE CCD_CRUISES
ADD (LAST_MOD_BY VARCHAR2(30) );	COMMENT ON COLUMN CCD_CRUISES.CREATE_DATE IS 'The date on which this record was created in the database';	COMMENT ON COLUMN CCD_CRUISES.CREATED_BY IS 'The Oracle username of the person creating this record in the database';	COMMENT ON COLUMN CCD_CRUISES.LAST_MOD_DATE IS 'The last date on which any of the data in this record was changed';	COMMENT ON COLUMN CCD_CRUISES.LAST_MOD_BY IS 'The Oracle username of the person making the most recent change to this record';
ALTER TABLE CCD_CRUISE_ALIASES ADD (CREATE_DATE DATE );	ALTER TABLE CCD_CRUISE_ALIASES
ADD (CREATED_BY VARCHAR2(30) );	ALTER TABLE CCD_CRUISE_ALIASES
ADD (LAST_MOD_DATE DATE );	ALTER TABLE CCD_CRUISE_ALIASES
ADD (LAST_MOD_BY VARCHAR2(30) );	COMMENT ON COLUMN CCD_CRUISE_ALIASES.CREATE_DATE IS 'The date on which this record was created in the database';	COMMENT ON COLUMN CCD_CRUISE_ALIASES.CREATED_BY IS 'The Oracle username of the person creating this record in the database';	COMMENT ON COLUMN CCD_CRUISE_ALIASES.LAST_MOD_DATE IS 'The last date on which any of the data in this record was changed';	COMMENT ON COLUMN CCD_CRUISE_ALIASES.LAST_MOD_BY IS 'The Oracle username of the person making the most recent change to this record';


CREATE SEQUENCE CCD_CRUISES_SEQ INCREMENT BY 1 START WITH 1;

CREATE SEQUENCE CCD_CRUISE_ALIASES_SEQ INCREMENT BY 1 START WITH 1;

CREATE SEQUENCE CCD_VESSELS_SEQ INCREMENT BY 1 START WITH 1;



create or replace TRIGGER CCD_VESSELS_AUTO_BRI
before insert on CCD_VESSELS
for each row
begin
  select CCD_VESSELS_SEQ.nextval into :new.vessel_id from dual;
  :NEW.CREATE_DATE := SYSDATE;
  :NEW.CREATED_BY := nvl(v('APP_USER'),user);
end;
/

CREATE OR REPLACE TRIGGER CCD_VESSELS_AUTO_BRU BEFORE
  UPDATE
    ON CCD_VESSELS FOR EACH ROW
    BEGIN
      :NEW.LAST_MOD_DATE := SYSDATE;
      :NEW.LAST_MOD_BY := nvl(v('APP_USER'),user);
END;
/

create or replace TRIGGER CCD_CRUISES_AUTO_BRI
before insert on CCD_CRUISES
for each row
begin
  select CCD_CRUISES_SEQ.nextval into :new.cruise_id from dual;
  :NEW.CREATE_DATE := SYSDATE;
  :NEW.CREATED_BY := nvl(v('APP_USER'),user);
end;
/

CREATE OR REPLACE TRIGGER CCD_CRUISES_AUTO_BRU BEFORE
  UPDATE
    ON CCD_CRUISES FOR EACH ROW
    BEGIN
      :NEW.LAST_MOD_DATE := SYSDATE;
      :NEW.LAST_MOD_BY := nvl(v('APP_USER'),user);
END;
/

create or replace TRIGGER CCD_CRUISE_ALIASES_AUTO_BRI
before insert on CCD_CRUISE_ALIASES
for each row
begin
  select CCD_CRUISE_ALIASES_SEQ.nextval into :new.CRUISE_ALIAS_ID from dual;
  :NEW.CREATE_DATE := SYSDATE;
  :NEW.CREATED_BY := nvl(v('APP_USER'),user);
end;
/

CREATE OR REPLACE TRIGGER CCD_CRUISE_ALIASES_AUTO_BRU BEFORE
  UPDATE
    ON CCD_CRUISE_ALIASES FOR EACH ROW
    BEGIN
      :NEW.LAST_MOD_DATE := SYSDATE;
      :NEW.LAST_MOD_BY := nvl(v('APP_USER'),user);
END;
/




CREATE OR REPLACE VIEW

CCD_CRUISES_V
AS

SELECT CCD_CRUISES.CRUISE_ID,
  CCD_CRUISES.CRUISE_NAME,
  CCD_CRUISES.CRUISE_START_DATE,
  TO_CHAR(CCD_CRUISES.CRUISE_START_DATE, 'MM/DD/YYYY HH24:MI:SS') format_cruise_start_date,
  CCD_CRUISES.CRUISE_END_DATE,
  TO_CHAR(CCD_CRUISES.CRUISE_END_DATE, 'MM/DD/YYYY HH24:MI:SS') format_cruise_end_date,
  CCD_CRUISES.CRUISE_NOTES,
  CCD_VESSELS.VESSEL_NAME,
  CCD_VESSELS.VESSEL_DESC,
  CCD_VESSELS.VESSEL_ID
FROM CCD_CRUISES
INNER JOIN CCD_VESSELS
ON CCD_VESSELS.VESSEL_ID = CCD_CRUISES.VESSEL_ID;

COMMENT ON COLUMN CCD_CRUISES_V.CRUISE_ID IS 'Primary key for the CCD_CRUISES table';
COMMENT ON COLUMN CCD_CRUISES_V.CRUISE_NAME IS 'The name of the given cruise designated by NOAA (e.g. SE-15-01)';
COMMENT ON COLUMN CCD_CRUISES_V.CRUISE_START_DATE IS 'The start date of the given research cruise';
COMMENT ON COLUMN CCD_CRUISES_V.FORMAT_CRUISE_START_DATE IS 'The start date of the given research cruise in MM/DD/YYYY HH24:MI:SS format';
COMMENT ON COLUMN CCD_CRUISES_V.CRUISE_END_DATE IS 'The end date of the given research cruise';
COMMENT ON COLUMN CCD_CRUISES_V.FORMAT_CRUISE_END_DATE IS 'The end date of the given research cruise in MM/DD/YYYY HH24:MI:SS format';
COMMENT ON COLUMN CCD_CRUISES_V.CRUISE_NOTES IS 'Any notes for the given research cruise';
COMMENT ON COLUMN CCD_CRUISES_V.VESSEL_NAME IS 'Primary key for the CCD_VESSELS table';
COMMENT ON COLUMN CCD_CRUISES_V.VESSEL_DESC IS 'Name of the given research vessel';
COMMENT ON COLUMN CCD_CRUISES_V.VESSEL_ID IS 'Description for the given research vessel';

COMMENT ON TABLE CCD_CRUISES_V IS 'CTD Cruises (View)

This query returns all of the CTD cruises and their associated research vessels where CTD data was collected including the formatted start and end dates';







create or replace view
CCD_CRUISE_ALIASES_V

as

SELECT CCD_CRUISES_V.CRUISE_ID,
  CCD_CRUISES_V.CRUISE_NAME,
  CCD_CRUISES_V.CRUISE_START_DATE,
  CCD_CRUISES_V.FORMAT_CRUISE_START_DATE,
  CCD_CRUISES_V.CRUISE_END_DATE,
  CCD_CRUISES_V.FORMAT_CRUISE_END_DATE,
  CCD_CRUISES_V.CRUISE_NOTES,
  CCD_CRUISES_V.VESSEL_NAME,
  CCD_CRUISES_V.VESSEL_DESC,
  CCD_CRUISES_V.VESSEL_ID,
  CRUISE_ALIASES.cruise_aliases_delim
FROM CCD_CRUISES_V
left join
(SELECT

cruise_id,
LISTAGG(CRUISE_ALIAS_NAME, ', ') WITHIN GROUP (ORDER BY UPPER(CRUISE_ALIAS_NAME)) as cruise_aliases_delim
from CCD_cruise_aliases
group by cruise_id) CRUISE_ALIASES
on CCD_cruises_v.cruise_id = cruise_aliases.cruise_id
order by VESSEL_NAME, cruise_start_date;


COMMENT ON COLUMN CCD_CRUISE_ALIASES_V.CRUISE_ID IS 'Primary key for the CCD_CRUISES table';
COMMENT ON COLUMN CCD_CRUISE_ALIASES_V.CRUISE_NAME IS 'The name of the given cruise designated by NOAA (e.g. SE-15-01)';
COMMENT ON COLUMN CCD_CRUISE_ALIASES_V.CRUISE_START_DATE IS 'The start date of the given research cruise';
COMMENT ON COLUMN CCD_CRUISE_ALIASES_V.FORMAT_CRUISE_START_DATE IS 'The start date of the given research cruise in MM/DD/YYYY HH24:MI:SS format';
COMMENT ON COLUMN CCD_CRUISE_ALIASES_V.CRUISE_END_DATE IS 'The end date of the given research cruise';
COMMENT ON COLUMN CCD_CRUISE_ALIASES_V.FORMAT_CRUISE_END_DATE IS 'The end date of the given research cruise in MM/DD/YYYY HH24:MI:SS format';
COMMENT ON COLUMN CCD_CRUISE_ALIASES_V.CRUISE_NOTES IS 'Any notes for the given research cruise';
COMMENT ON COLUMN CCD_CRUISE_ALIASES_V.VESSEL_NAME IS 'Primary key for the CCD_VESSELS table';
COMMENT ON COLUMN CCD_CRUISE_ALIASES_V.VESSEL_DESC IS 'Name of the given research vessel';
COMMENT ON COLUMN CCD_CRUISE_ALIASES_V.VESSEL_ID IS 'Description for the given research vessel';
COMMENT ON COLUMN CCD_CRUISE_ALIASES_V.CRUISE_ALIASES_DELIM IS 'Comma delimited list of cruise name aliases in alphabetical order';

COMMENT ON TABLE CCD_CRUISE_ALIASES_V IS 'CTD Cruise Aliases (View)

This query returns all of the CTD cruises, associated research vessels where CTD data was collected including the formatted start and end dates.  This query also returns the comma-delimited list of cruise name aliases for each cruise in alphabetical order';







--define the upgrade version in the database upgrade log table:
INSERT INTO DB_UPGRADE_LOGS (UPGRADE_APP_NAME, UPGRADE_VERSION, UPGRADE_DATE, UPGRADE_DESC) VALUES ('Centralized Cruise Database', '0.1', TO_DATE('10-SEP-18', 'DD-MON-YY'), 'Installed version 0.6 of the Application Authorization Database.  Installed version 0.2 of the Database Version Control Database.  Installed version 0.3 of the Data Validation Module Database.  Migrated and renamed the cruise database tables from the centralized CTD database');

--commit the DB_UPGRADE_LOGS record insertion
COMMIT;
