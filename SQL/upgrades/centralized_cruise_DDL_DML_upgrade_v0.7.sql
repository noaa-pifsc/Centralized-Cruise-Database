--------------------------------------------------------
--------------------------------------------------------
--Database Name: Centralized Cruise Database
--Database Description: Centralized Cruise Database to track information about each PIFSC research cruise including activities, chief scientists, regions, etc. to remove the need for each division/program to manage this information
--------------------------------------------------------
--------------------------------------------------------


--------------------------------------------------------
--Centralized Cruise Database - version 0.7 updates:
--------------------------------------------------------


--update the unique constraint to include the PRIMARY_YN field:
ALTER TABLE CCD_CRUISE_SVY_CATS
DROP CONSTRAINT CCD_CRUISE_SVY_CATS_U1;

ALTER TABLE CCD_CRUISE_SVY_CATS
ADD CONSTRAINT CCD_CRUISE_SVY_CATS_U1 UNIQUE
(
  CRUISE_ID
, SVY_CAT_ID
, PRIMARY_YN
)
ENABLE;


--table to define the different gear presets
--Gear Presets
--CCD_GEAR_PRE


CREATE TABLE CCD_GEAR_PRE
(
  GEAR_PRE_ID NUMBER NOT NULL
, GEAR_PRE_NAME VARCHAR2(200) NOT NULL
, GEAR_PRE_DESC VARCHAR2(500)
, CONSTRAINT CCD_GEAR_PRE_PK PRIMARY KEY
  (
    GEAR_PRE_ID
  )
  ENABLE
);

COMMENT ON COLUMN CCD_GEAR_PRE.GEAR_PRE_ID IS 'Primary key for the Gear Preset table';

COMMENT ON COLUMN CCD_GEAR_PRE.GEAR_PRE_NAME IS 'Name of the given Gear Preset';

COMMENT ON COLUMN CCD_GEAR_PRE.GEAR_PRE_DESC IS 'Description for the given Gear Preset';

COMMENT ON TABLE CCD_GEAR_PRE IS 'Gear Presets

This table defines gear presets for implementation in the data management application';

ALTER TABLE CCD_GEAR_PRE ADD CONSTRAINT CCD_GEAR_PRE_U1 UNIQUE
(
  GEAR_PRE_NAME
)
ENABLE;


CREATE SEQUENCE CCD_GEAR_PRE_SEQ INCREMENT BY 1 START WITH 1;	ALTER TABLE CCD_GEAR_PRE ADD (CREATE_DATE DATE );	ALTER TABLE CCD_GEAR_PRE ADD (CREATED_BY VARCHAR2(30) );	ALTER TABLE CCD_GEAR_PRE ADD (LAST_MOD_DATE DATE );	ALTER TABLE CCD_GEAR_PRE ADD (LAST_MOD_BY VARCHAR2(30) );

COMMENT ON COLUMN CCD_GEAR_PRE.CREATE_DATE IS 'The date on which this record was created in the database';	COMMENT ON COLUMN CCD_GEAR_PRE.CREATED_BY IS 'The Oracle username of the person creating this record in the database';	COMMENT ON COLUMN CCD_GEAR_PRE.LAST_MOD_DATE IS 'The last date on which any of the data in this record was changed';	COMMENT ON COLUMN CCD_GEAR_PRE.LAST_MOD_BY IS 'The Oracle username of the person making the most recent change to this record';


create or replace TRIGGER CCD_GEAR_PRE_AUTO_BRI
before insert on CCD_GEAR_PRE
for each row
begin
  select CCD_GEAR_PRE_SEQ.nextval into :new.GEAR_PRE_ID from dual;
  :NEW.CREATE_DATE := SYSDATE;
  :NEW.CREATED_BY := nvl(v('APP_USER'),user);
end;
/

CREATE OR REPLACE TRIGGER CCD_GEAR_PRE_AUTO_BRU BEFORE
  UPDATE
    ON CCD_GEAR_PRE FOR EACH ROW
    BEGIN
      :NEW.LAST_MOD_DATE := SYSDATE;
      :NEW.LAST_MOD_BY := nvl(v('APP_USER'),user);
END;
/






--table for defining many-to-many relationship for different types of situations
--Gear Preset Options
--CCD_GEAR_PRE_OPTS
CREATE TABLE CCD_GEAR_PRE_OPTS
(
  GEAR_PRE_OPT_ID NUMBER NOT NULL
, GEAR_PRE_ID NUMBER NOT NULL
, GEAR_ID NUMBER NOT NULL
, GEAR_PRE_OPT_NOTES VARCHAR2(500)
, CONSTRAINT CCD_GEAR_PRE_OPTS_PK PRIMARY KEY
  (
    GEAR_PRE_OPT_ID
  )
  ENABLE
);

CREATE INDEX CCD_GEAR_PRE_OPTS_I1 ON CCD_GEAR_PRE_OPTS (GEAR_PRE_ID);

CREATE INDEX CCD_GEAR_PRE_OPTS_I2 ON CCD_GEAR_PRE_OPTS (GEAR_ID);

ALTER TABLE CCD_GEAR_PRE_OPTS
ADD CONSTRAINT CCD_GEAR_PRE_OPTS_U1 UNIQUE
(
  GEAR_PRE_ID
, GEAR_ID
)
ENABLE;

ALTER TABLE CCD_GEAR_PRE_OPTS
ADD CONSTRAINT CCD_GEAR_PRE_OPTS_FK1 FOREIGN KEY
(
  GEAR_ID
)
REFERENCES CCD_GEAR
(
  GEAR_ID
)
ENABLE;

ALTER TABLE CCD_GEAR_PRE_OPTS
ADD CONSTRAINT CCD_GEAR_PRE_OPTS_FK2 FOREIGN KEY
(
  GEAR_PRE_ID
)
REFERENCES CCD_GEAR_PRE
(
  GEAR_PRE_ID
)
ENABLE;

COMMENT ON TABLE CCD_GEAR_PRE_OPTS IS 'Gear Preset Options

This intersection table defines the many-to-many relationship between gear presets and specific gear to allow groups of gear to be defined to make it easier for authorized application users to choose and define groups of gear for a given cruise leg';

COMMENT ON COLUMN CCD_GEAR_PRE_OPTS.GEAR_PRE_OPT_ID IS 'Primary key for the CCD_GEAR_PRE_OPTS table';

COMMENT ON COLUMN CCD_GEAR_PRE_OPTS.GEAR_PRE_ID IS 'The Gear preset that the given gear is associated with';

COMMENT ON COLUMN CCD_GEAR_PRE_OPTS.GEAR_ID IS 'The Gear that the given gear preset is associated with';

COMMENT ON COLUMN CCD_GEAR_PRE_OPTS.GEAR_PRE_OPT_NOTES IS 'Notes associated with the given gear preset option';



CREATE SEQUENCE CCD_GEAR_PRE_OPTS_SEQ INCREMENT BY 1 START WITH 1;



create or replace TRIGGER
CCD_GEAR_PRE_OPTS_AUTO_BRI
before insert on CCD_GEAR_PRE_OPTS
for each row
begin
  select CCD_GEAR_PRE_OPTS_SEQ.nextval into :new.GEAR_PRE_OPT_ID from dual;
end;
/









CREATE OR REPLACE VIEW
CCD_GEAR_PRE_V

AS

SELECT
CCD_GEAR_PRE_OPTS.GEAR_PRE_OPT_ID,
CCD_GEAR_PRE.GEAR_PRE_ID,
CCD_GEAR_PRE.GEAR_PRE_NAME,
CCD_GEAR_PRE.GEAR_PRE_DESC,
CCD_GEAR_PRE_OPTS.GEAR_ID,
CCD_GEAR.GEAR_NAME,
CCD_GEAR.GEAR_DESC,
CCD_GEAR.FINSS_ID,
CCD_GEAR_PRE_OPTS.GEAR_PRE_OPT_NOTES


FROM CCD_GEAR_PRE
LEFT JOIN
CCD_GEAR_PRE_OPTS ON CCD_GEAR_PRE_OPTS.GEAR_PRE_ID = CCD_GEAR_PRE.GEAR_PRE_ID
LEFT JOIN
CCD_GEAR ON CCD_GEAR.GEAR_ID = CCD_GEAR_PRE_OPTS.GEAR_ID
order by
UPPER(CCD_GEAR_PRE.GEAR_PRE_NAME),
UPPER(CCD_GEAR.GEAR_NAME)

;


COMMENT ON COLUMN CCD_GEAR_PRE_V.GEAR_PRE_OPT_ID IS 'Primary key for the CCD_GEAR_PRE_OPTS table';
COMMENT ON COLUMN CCD_GEAR_PRE_V.GEAR_PRE_ID IS 'Primary key for the Gear Preset table';
COMMENT ON COLUMN CCD_GEAR_PRE_V.GEAR_PRE_NAME IS 'Name of the given Gear Preset';
COMMENT ON COLUMN CCD_GEAR_PRE_V.GEAR_PRE_DESC IS 'Description for the given Gear Preset';
COMMENT ON COLUMN CCD_GEAR_PRE_V.GEAR_ID IS 'Primary key for the Gear table';
COMMENT ON COLUMN CCD_GEAR_PRE_V.GEAR_NAME IS 'Name of the given Gear';
COMMENT ON COLUMN CCD_GEAR_PRE_V.GEAR_DESC IS 'Description for the given Gear';
COMMENT ON COLUMN CCD_GEAR_PRE_V.FINSS_ID IS 'The ID value from the FINSS system';
COMMENT ON COLUMN CCD_GEAR_PRE_V.GEAR_PRE_OPT_NOTES IS 'Notes associated with the given gear preset option';

COMMENT ON TABLE CCD_GEAR_PRE_V IS 'Gear Presets (View)

This view returns all gear presets and the associated gear information';





--table to define the different regional ecosystem presets
--Regional Ecosystem Presets
--CCD_REG_ECO_PRE


CREATE TABLE CCD_REG_ECO_PRE
(
  REG_ECO_PRE_ID NUMBER NOT NULL
, REG_ECO_PRE_NAME VARCHAR2(200) NOT NULL
, REG_ECO_PRE_DESC VARCHAR2(500)
, CONSTRAINT CCD_REG_ECO_PRE_PK PRIMARY KEY
  (
    REG_ECO_PRE_ID
  )
  ENABLE
);

COMMENT ON COLUMN CCD_REG_ECO_PRE.REG_ECO_PRE_ID IS 'Primary key for the Regional Ecosystem Preset table';

COMMENT ON COLUMN CCD_REG_ECO_PRE.REG_ECO_PRE_NAME IS 'Name of the given Regional Ecosystem Preset';

COMMENT ON COLUMN CCD_REG_ECO_PRE.REG_ECO_PRE_DESC IS 'Description for the given Regional Ecosystem Preset';

COMMENT ON TABLE CCD_REG_ECO_PRE IS 'Regional Ecosystem Presets

This table defines regional ecosystem presets for implementation in the data management application';

ALTER TABLE CCD_REG_ECO_PRE ADD CONSTRAINT CCD_REG_ECO_PRE_U1 UNIQUE
(
  REG_ECO_PRE_NAME
)
ENABLE;


CREATE SEQUENCE CCD_REG_ECO_PRE_SEQ INCREMENT BY 1 START WITH 1;	ALTER TABLE CCD_REG_ECO_PRE ADD (CREATE_DATE DATE );	ALTER TABLE CCD_REG_ECO_PRE ADD (CREATED_BY VARCHAR2(30) );	ALTER TABLE CCD_REG_ECO_PRE ADD (LAST_MOD_DATE DATE );	ALTER TABLE CCD_REG_ECO_PRE ADD (LAST_MOD_BY VARCHAR2(30) );

COMMENT ON COLUMN CCD_REG_ECO_PRE.CREATE_DATE IS 'The date on which this record was created in the database';	COMMENT ON COLUMN CCD_REG_ECO_PRE.CREATED_BY IS 'The Oracle username of the person creating this record in the database';	COMMENT ON COLUMN CCD_REG_ECO_PRE.LAST_MOD_DATE IS 'The last date on which any of the data in this record was changed';	COMMENT ON COLUMN CCD_REG_ECO_PRE.LAST_MOD_BY IS 'The Oracle username of the person making the most recent change to this record';


create or replace TRIGGER CCD_REG_ECO_PRE_AUTO_BRI
before insert on CCD_REG_ECO_PRE
for each row
begin
  select CCD_REG_ECO_PRE_SEQ.nextval into :new.REG_ECO_PRE_ID from dual;
  :NEW.CREATE_DATE := SYSDATE;
  :NEW.CREATED_BY := nvl(v('APP_USER'),user);
end;
/

CREATE OR REPLACE TRIGGER CCD_REG_ECO_PRE_AUTO_BRU BEFORE
  UPDATE
    ON CCD_REG_ECO_PRE FOR EACH ROW
    BEGIN
      :NEW.LAST_MOD_DATE := SYSDATE;
      :NEW.LAST_MOD_BY := nvl(v('APP_USER'),user);
END;
/






--table for defining many-to-many relationship for different types of situations
--Regional Ecosystem Preset Options
--CCD_REG_ECO_PRE_OPTS
CREATE TABLE CCD_REG_ECO_PRE_OPTS
(
  REG_ECO_PRE_OPT_ID NUMBER NOT NULL
, REG_ECO_PRE_ID NUMBER NOT NULL
, REG_ECOSYSTEM_ID NUMBER NOT NULL
, REG_ECO_PRE_OPT_NOTES VARCHAR2(500)
, CONSTRAINT CCD_REG_ECO_PRE_OPTS_PK PRIMARY KEY
  (
    REG_ECO_PRE_OPT_ID
  )
  ENABLE
);

CREATE INDEX CCD_REG_ECO_PRE_OPTS_I1 ON CCD_REG_ECO_PRE_OPTS (REG_ECO_PRE_ID);

CREATE INDEX CCD_REG_ECO_PRE_OPTS_I2 ON CCD_REG_ECO_PRE_OPTS (REG_ECOSYSTEM_ID);

ALTER TABLE CCD_REG_ECO_PRE_OPTS
ADD CONSTRAINT CCD_REG_ECO_PRE_OPTS_U1 UNIQUE
(
  REG_ECO_PRE_ID
, REG_ECOSYSTEM_ID
)
ENABLE;

ALTER TABLE CCD_REG_ECO_PRE_OPTS
ADD CONSTRAINT CCD_REG_ECO_PRE_OPTS_FK1 FOREIGN KEY
(
  REG_ECOSYSTEM_ID
)
REFERENCES CCD_REG_ECOSYSTEMS
(
  REG_ECOSYSTEM_ID
)
ENABLE;

ALTER TABLE CCD_REG_ECO_PRE_OPTS
ADD CONSTRAINT CCD_REG_ECO_PRE_OPTS_FK2 FOREIGN KEY
(
  REG_ECO_PRE_ID
)
REFERENCES CCD_REG_ECO_PRE
(
  REG_ECO_PRE_ID
)
ENABLE;

COMMENT ON TABLE CCD_REG_ECO_PRE_OPTS IS 'Regional Ecosystem Preset Options

This intersection table defines the many-to-many relationship between regional ecosystem presets and specific regional ecosystems to allow groups of regional ecosystems to be defined to make it easier for authorized application users to choose and define groups of regional ecosystems for a given cruise leg';

COMMENT ON COLUMN CCD_REG_ECO_PRE_OPTS.REG_ECO_PRE_OPT_ID IS 'Primary key for the CCD_REG_ECO_PRE_OPTS table';

COMMENT ON COLUMN CCD_REG_ECO_PRE_OPTS.REG_ECO_PRE_ID IS 'The Regional Ecosystem preset that the given regional ecosystem is associated with';

COMMENT ON COLUMN CCD_REG_ECO_PRE_OPTS.REG_ECOSYSTEM_ID IS 'The Regional Ecosystem that the given regional ecosystem preset is associated with';

COMMENT ON COLUMN CCD_REG_ECO_PRE_OPTS.REG_ECO_PRE_OPT_NOTES IS 'Notes associated with the given Regional Ecosystem preset option';



CREATE SEQUENCE CCD_REG_ECO_PRE_OPTS_SEQ INCREMENT BY 1 START WITH 1;



create or replace TRIGGER
CCD_REG_ECO_PRE_OPTS_AUTO_BRI
before insert on CCD_REG_ECO_PRE_OPTS
for each row
begin
  select CCD_REG_ECO_PRE_OPTS_SEQ.nextval into :new.REG_ECO_PRE_OPT_ID from dual;
end;
/









CREATE OR REPLACE VIEW
CCD_REG_ECO_PRE_V

AS

SELECT
CCD_REG_ECO_PRE_OPTS.REG_ECO_PRE_OPT_ID,
CCD_REG_ECO_PRE.REG_ECO_PRE_ID,
CCD_REG_ECO_PRE.REG_ECO_PRE_NAME,
CCD_REG_ECO_PRE.REG_ECO_PRE_DESC,
CCD_REG_ECO_PRE_OPTS.REG_ECOSYSTEM_ID,
CCD_REG_ECOSYSTEMS.REG_ECOSYSTEM_NAME,
CCD_REG_ECOSYSTEMS.REG_ECOSYSTEM_DESC,
CCD_REG_ECOSYSTEMS.FINSS_ID,
CCD_REG_ECO_PRE_OPTS.REG_ECO_PRE_OPT_NOTES


FROM CCD_REG_ECO_PRE
LEFT JOIN
CCD_REG_ECO_PRE_OPTS ON CCD_REG_ECO_PRE_OPTS.REG_ECO_PRE_ID = CCD_REG_ECO_PRE.REG_ECO_PRE_ID
LEFT JOIN
CCD_REG_ECOSYSTEMS ON CCD_REG_ECOSYSTEMS.REG_ECOSYSTEM_ID = CCD_REG_ECO_PRE_OPTS.REG_ECOSYSTEM_ID
order by
UPPER(CCD_REG_ECO_PRE.REG_ECO_PRE_NAME),
UPPER(CCD_REG_ECOSYSTEMS.REG_ECOSYSTEM_NAME)

;


COMMENT ON COLUMN CCD_REG_ECO_PRE_V.REG_ECO_PRE_OPT_ID IS 'Primary key for the CCD_REG_ECO_PRE_OPTS table';
COMMENT ON COLUMN CCD_REG_ECO_PRE_V.REG_ECO_PRE_ID IS 'Primary key for the Regional Ecosystem Preset table';
COMMENT ON COLUMN CCD_REG_ECO_PRE_V.REG_ECO_PRE_NAME IS 'Name of the given Regional Ecosystem Preset';
COMMENT ON COLUMN CCD_REG_ECO_PRE_V.REG_ECO_PRE_DESC IS 'Description for the given Regional Ecosystem Preset';
COMMENT ON COLUMN CCD_REG_ECO_PRE_V.REG_ECOSYSTEM_ID IS 'Primary key for the Regional Ecosystem table';
COMMENT ON COLUMN CCD_REG_ECO_PRE_V.REG_ECOSYSTEM_NAME IS 'Name of the given Regional Ecosystem';
COMMENT ON COLUMN CCD_REG_ECO_PRE_V.REG_ECOSYSTEM_DESC IS 'Description for the given Regional Ecosystem';
COMMENT ON COLUMN CCD_REG_ECO_PRE_V.FINSS_ID IS 'The ID value from the FINSS system';
COMMENT ON COLUMN CCD_REG_ECO_PRE_V.REG_ECO_PRE_OPT_NOTES IS 'Notes associated with the given Regional Ecosystem preset option';

COMMENT ON TABLE CCD_REG_ECO_PRE_V IS 'Regional Ecosystem Presets (View)

This view returns all regional ecosystem presets and the associated regional ecosystem information';








--table to define the different region presets
--Region Presets
--CCD_REGION_PRE


CREATE TABLE CCD_REGION_PRE
(
  REGION_PRE_ID NUMBER NOT NULL
, REGION_PRE_NAME VARCHAR2(200) NOT NULL
, REGION_PRE_DESC VARCHAR2(500)
, CONSTRAINT CCD_REGION_PRE_PK PRIMARY KEY
  (
    REGION_PRE_ID
  )
  ENABLE
);

COMMENT ON COLUMN CCD_REGION_PRE.REGION_PRE_ID IS 'Primary key for the Region Preset table';

COMMENT ON COLUMN CCD_REGION_PRE.REGION_PRE_NAME IS 'Name of the given Region Preset';

COMMENT ON COLUMN CCD_REGION_PRE.REGION_PRE_DESC IS 'Description for the given Region Preset';

COMMENT ON TABLE CCD_REGION_PRE IS 'Region Presets

This table defines region presets for implementation in the data management application';

ALTER TABLE CCD_REGION_PRE ADD CONSTRAINT CCD_REGION_PRE_U1 UNIQUE
(
  REGION_PRE_NAME
)
ENABLE;


CREATE SEQUENCE CCD_REGION_PRE_SEQ INCREMENT BY 1 START WITH 1;	ALTER TABLE CCD_REGION_PRE ADD (CREATE_DATE DATE );	ALTER TABLE CCD_REGION_PRE ADD (CREATED_BY VARCHAR2(30) );	ALTER TABLE CCD_REGION_PRE ADD (LAST_MOD_DATE DATE );	ALTER TABLE CCD_REGION_PRE ADD (LAST_MOD_BY VARCHAR2(30) );

COMMENT ON COLUMN CCD_REGION_PRE.CREATE_DATE IS 'The date on which this record was created in the database';	COMMENT ON COLUMN CCD_REGION_PRE.CREATED_BY IS 'The Oracle username of the person creating this record in the database';	COMMENT ON COLUMN CCD_REGION_PRE.LAST_MOD_DATE IS 'The last date on which any of the data in this record was changed';	COMMENT ON COLUMN CCD_REGION_PRE.LAST_MOD_BY IS 'The Oracle username of the person making the most recent change to this record';


create or replace TRIGGER CCD_REGION_PRE_AUTO_BRI
before insert on CCD_REGION_PRE
for each row
begin
  select CCD_REGION_PRE_SEQ.nextval into :new.REGION_PRE_ID from dual;
  :NEW.CREATE_DATE := SYSDATE;
  :NEW.CREATED_BY := nvl(v('APP_USER'),user);
end;
/

CREATE OR REPLACE TRIGGER CCD_REGION_PRE_AUTO_BRU BEFORE
  UPDATE
    ON CCD_REGION_PRE FOR EACH ROW
    BEGIN
      :NEW.LAST_MOD_DATE := SYSDATE;
      :NEW.LAST_MOD_BY := nvl(v('APP_USER'),user);
END;
/






--table for defining many-to-many relationship for different types of situations
--Region Preset Options
--CCD_REGION_PRE_OPTS
CREATE TABLE CCD_REGION_PRE_OPTS
(
  REGION_PRE_OPT_ID NUMBER NOT NULL
, REGION_PRE_ID NUMBER NOT NULL
, REGION_ID NUMBER NOT NULL
, REGION_PRE_OPT_NOTES VARCHAR2(500)
, CONSTRAINT CCD_REGION_PRE_OPTS_PK PRIMARY KEY
  (
    REGION_PRE_OPT_ID
  )
  ENABLE
);

CREATE INDEX CCD_REGION_PRE_OPTS_I1 ON CCD_REGION_PRE_OPTS (REGION_PRE_ID);

CREATE INDEX CCD_REGION_PRE_OPTS_I2 ON CCD_REGION_PRE_OPTS (REGION_ID);

ALTER TABLE CCD_REGION_PRE_OPTS
ADD CONSTRAINT CCD_REGION_PRE_OPTS_U1 UNIQUE
(
  REGION_PRE_ID
, REGION_ID
)
ENABLE;

ALTER TABLE CCD_REGION_PRE_OPTS
ADD CONSTRAINT CCD_REGION_PRE_OPTS_FK1 FOREIGN KEY
(
  REGION_ID
)
REFERENCES CCD_REGIONS
(
  REGION_ID
)
ENABLE;

ALTER TABLE CCD_REGION_PRE_OPTS
ADD CONSTRAINT CCD_REGION_PRE_OPTS_FK2 FOREIGN KEY
(
  REGION_PRE_ID
)
REFERENCES CCD_REGION_PRE
(
  REGION_PRE_ID
)
ENABLE;

COMMENT ON TABLE CCD_REGION_PRE_OPTS IS 'Region Preset Options

This intersection table defines the many-to-many relationship between region presets and specific regions to allow groups of regions to be defined to make it easier for authorized application users to choose and define groups of regions for a given cruise leg';

COMMENT ON COLUMN CCD_REGION_PRE_OPTS.REGION_PRE_OPT_ID IS 'Primary key for the CCD_REGION_PRE_OPTS table';

COMMENT ON COLUMN CCD_REGION_PRE_OPTS.REGION_PRE_ID IS 'The Region preset that the given region is associated with';

COMMENT ON COLUMN CCD_REGION_PRE_OPTS.REGION_ID IS 'The Region that the given region preset is associated with';

COMMENT ON COLUMN CCD_REGION_PRE_OPTS.REGION_PRE_OPT_NOTES IS 'Notes associated with the given region preset option';



CREATE SEQUENCE CCD_REGION_PRE_OPTS_SEQ INCREMENT BY 1 START WITH 1;



create or replace TRIGGER
CCD_REGION_PRE_OPTS_AUTO_BRI
before insert on CCD_REGION_PRE_OPTS
for each row
begin
  select CCD_REGION_PRE_OPTS_SEQ.nextval into :new.REGION_PRE_OPT_ID from dual;
end;
/









CREATE OR REPLACE VIEW
CCD_REGION_PRE_V

AS

SELECT
CCD_REGION_PRE_OPTS.REGION_PRE_OPT_ID,
CCD_REGION_PRE.REGION_PRE_ID,
CCD_REGION_PRE.REGION_PRE_NAME,
CCD_REGION_PRE.REGION_PRE_DESC,
CCD_REGION_PRE_OPTS.REGION_ID,
CCD_REGIONS.REGION_NAME,
CCD_REGIONS.REGION_DESC,
CCD_REGION_PRE_OPTS.REGION_PRE_OPT_NOTES


FROM CCD_REGION_PRE
LEFT JOIN
CCD_REGION_PRE_OPTS ON CCD_REGION_PRE_OPTS.REGION_PRE_ID = CCD_REGION_PRE.REGION_PRE_ID
LEFT JOIN
CCD_REGIONS ON CCD_REGIONS.REGION_ID = CCD_REGION_PRE_OPTS.REGION_ID
order by
UPPER(CCD_REGION_PRE.REGION_PRE_NAME),
UPPER(CCD_REGIONS.REGION_NAME)

;


COMMENT ON COLUMN CCD_REGION_PRE_V.REGION_PRE_OPT_ID IS 'Primary key for the CCD_REGION_PRE_OPTS table';
COMMENT ON COLUMN CCD_REGION_PRE_V.REGION_PRE_ID IS 'Primary key for the Region Preset table';
COMMENT ON COLUMN CCD_REGION_PRE_V.REGION_PRE_NAME IS 'Name of the given Region Preset';
COMMENT ON COLUMN CCD_REGION_PRE_V.REGION_PRE_DESC IS 'Description for the given Region Preset';
COMMENT ON COLUMN CCD_REGION_PRE_V.REGION_ID IS 'Primary key for the Region table';
COMMENT ON COLUMN CCD_REGION_PRE_V.REGION_NAME IS 'Name of the given Region';
COMMENT ON COLUMN CCD_REGION_PRE_V.REGION_DESC IS 'Description for the given Region';
COMMENT ON COLUMN CCD_REGION_PRE_V.REGION_PRE_OPT_NOTES IS 'Notes associated with the given region preset option';


COMMENT ON TABLE CCD_REGION_PRE_V IS 'Region Presets (View)

This view returns all region presets and the associated region information';









--table to define the different survey category presets
--survey category Presets
--CCD_SVY_CAT_PRE


CREATE TABLE CCD_SVY_CAT_PRE
(
  SVY_CAT_PRE_ID NUMBER NOT NULL
, SVY_CAT_PRE_NAME VARCHAR2(200) NOT NULL
, SVY_CAT_PRE_DESC VARCHAR2(500)
, SVY_CAT_PRIMARY_YN CHAR(1) NOT NULL
, CONSTRAINT CCD_SVY_CAT_PRE_PK PRIMARY KEY
  (
    SVY_CAT_PRE_ID
  )
  ENABLE
);

COMMENT ON COLUMN CCD_SVY_CAT_PRE.SVY_CAT_PRE_ID IS 'Primary key for the Survey Category Preset table';

COMMENT ON COLUMN CCD_SVY_CAT_PRE.SVY_CAT_PRE_NAME IS 'Name of the given Survey Category Preset';

COMMENT ON COLUMN CCD_SVY_CAT_PRE.SVY_CAT_PRE_DESC IS 'Description for the given Survey Category Preset';
COMMENT ON COLUMN CCD_SVY_CAT_PRE.SVY_CAT_PRIMARY_YN IS 'Boolean field to indicate if this is a preset for a primary survey category (Y) or a secondary survey category (N)';


COMMENT ON TABLE CCD_SVY_CAT_PRE IS 'Survey Category Presets

This table defines primary and secondary survey category presets for implementation in the data management application';

COMMENT ON TABLE CCD_SVY_CAT_PRE IS 'Reference Table for storing Survey Category Preset information';

ALTER TABLE CCD_SVY_CAT_PRE ADD CONSTRAINT CCD_SVY_CAT_PRE_U1 UNIQUE
(
  SVY_CAT_PRE_NAME,
  SVY_CAT_PRIMARY_YN
)
ENABLE;


CREATE SEQUENCE CCD_SVY_CAT_PRE_SEQ INCREMENT BY 1 START WITH 1;	ALTER TABLE CCD_SVY_CAT_PRE ADD (CREATE_DATE DATE );	ALTER TABLE CCD_SVY_CAT_PRE ADD (CREATED_BY VARCHAR2(30) );	ALTER TABLE CCD_SVY_CAT_PRE ADD (LAST_MOD_DATE DATE );	ALTER TABLE CCD_SVY_CAT_PRE ADD (LAST_MOD_BY VARCHAR2(30) );

COMMENT ON COLUMN CCD_SVY_CAT_PRE.CREATE_DATE IS 'The date on which this record was created in the database';	COMMENT ON COLUMN CCD_SVY_CAT_PRE.CREATED_BY IS 'The Oracle username of the person creating this record in the database';	COMMENT ON COLUMN CCD_SVY_CAT_PRE.LAST_MOD_DATE IS 'The last date on which any of the data in this record was changed';	COMMENT ON COLUMN CCD_SVY_CAT_PRE.LAST_MOD_BY IS 'The Oracle username of the person making the most recent change to this record';


create or replace TRIGGER CCD_SVY_CAT_PRE_AUTO_BRI
before insert on CCD_SVY_CAT_PRE
for each row
begin
  select CCD_SVY_CAT_PRE_SEQ.nextval into :new.SVY_CAT_PRE_ID from dual;
  :NEW.CREATE_DATE := SYSDATE;
  :NEW.CREATED_BY := nvl(v('APP_USER'),user);
end;
/

CREATE OR REPLACE TRIGGER CCD_SVY_CAT_PRE_AUTO_BRU BEFORE
  UPDATE
    ON CCD_SVY_CAT_PRE FOR EACH ROW
    BEGIN
      :NEW.LAST_MOD_DATE := SYSDATE;
      :NEW.LAST_MOD_BY := nvl(v('APP_USER'),user);
END;
/






--table for defining many-to-many relationship for different types of situations
--Survey Category Preset Options
--CCD_SVY_CAT_PRE_OPTS
CREATE TABLE CCD_SVY_CAT_PRE_OPTS
(
  SVY_CAT_PRE_OPT_ID NUMBER NOT NULL
, SVY_CAT_PRE_ID NUMBER NOT NULL
, SVY_CAT_ID NUMBER NOT NULL
, SVY_CAT_PRE_OPT_NOTES VARCHAR2(500)
, CONSTRAINT CCD_SVY_CAT_PRE_OPTS_PK PRIMARY KEY
  (
    SVY_CAT_PRE_OPT_ID
  )
  ENABLE
);

CREATE INDEX CCD_SVY_CAT_PRE_OPTS_I1 ON CCD_SVY_CAT_PRE_OPTS (SVY_CAT_PRE_ID);

CREATE INDEX CCD_SVY_CAT_PRE_OPTS_I2 ON CCD_SVY_CAT_PRE_OPTS (SVY_CAT_ID);

ALTER TABLE CCD_SVY_CAT_PRE_OPTS
ADD CONSTRAINT CCD_SVY_CAT_PRE_OPTS_U1 UNIQUE
(
  SVY_CAT_PRE_ID
, SVY_CAT_ID
)
ENABLE;

ALTER TABLE CCD_SVY_CAT_PRE_OPTS
ADD CONSTRAINT CCD_SVY_CAT_PRE_OPTS_FK1 FOREIGN KEY
(
  SVY_CAT_ID
)
REFERENCES CCD_SVY_CATS
(
  SVY_CAT_ID
)
ENABLE;

ALTER TABLE CCD_SVY_CAT_PRE_OPTS
ADD CONSTRAINT CCD_SVY_CAT_PRE_OPTS_FK2 FOREIGN KEY
(
  SVY_CAT_PRE_ID
)
REFERENCES CCD_SVY_CAT_PRE
(
  SVY_CAT_PRE_ID
)
ENABLE;

COMMENT ON TABLE CCD_SVY_CAT_PRE_OPTS IS 'Survey Category Preset Options

This intersection table defines the many-to-many relationship between survey category presets and specific survey categories to allow groups of survey categories to be defined to make it easier for authorized application users to choose and define groups of survey categories for a given cruise leg';

COMMENT ON COLUMN CCD_SVY_CAT_PRE_OPTS.SVY_CAT_PRE_OPT_ID IS 'Primary key for the CCD_SVY_CAT_PRE_OPTS table';

COMMENT ON COLUMN CCD_SVY_CAT_PRE_OPTS.SVY_CAT_PRE_ID IS 'The Gear preset that the given survey category is associated with';

COMMENT ON COLUMN CCD_SVY_CAT_PRE_OPTS.SVY_CAT_ID IS 'The Gear that the given survey category preset is associated with';

COMMENT ON COLUMN CCD_SVY_CAT_PRE_OPTS.SVY_CAT_PRE_OPT_NOTES IS 'Notes associated with the given survey category preset option';



CREATE SEQUENCE CCD_SVY_CAT_PRE_OPTS_SEQ INCREMENT BY 1 START WITH 1;



create or replace TRIGGER
CCD_SVY_CAT_PRE_OPTS_AUTO_BRI
before insert on CCD_SVY_CAT_PRE_OPTS
for each row
begin
  select CCD_SVY_CAT_PRE_OPTS_SEQ.nextval into :new.SVY_CAT_PRE_OPT_ID from dual;
end;
/









CREATE OR REPLACE VIEW
CCD_SVY_CAT_PRE_V

AS

SELECT
CCD_SVY_CAT_PRE_OPTS.SVY_CAT_PRE_OPT_ID,
CCD_SVY_CAT_PRE.SVY_CAT_PRE_ID,
CCD_SVY_CAT_PRE.SVY_CAT_PRE_NAME,
CCD_SVY_CAT_PRE.SVY_CAT_PRE_DESC,
CCD_SVY_CAT_PRE.SVY_CAT_PRIMARY_YN,
CCD_SVY_CAT_PRE_OPTS.SVY_CAT_ID,
CCD_SVY_CATS.SVY_CAT_NAME,
CCD_SVY_CATS.SVY_CAT_DESC,
CCD_SVY_CATS.FINSS_ID,
CCD_SVY_CAT_PRE_OPTS.SVY_CAT_PRE_OPT_NOTES


FROM
CCD_SVY_CAT_PRE
LEFT JOIN
CCD_SVY_CAT_PRE_OPTS ON CCD_SVY_CAT_PRE_OPTS.SVY_CAT_PRE_ID = CCD_SVY_CAT_PRE.SVY_CAT_PRE_ID
LEFT JOIN
CCD_SVY_CATS ON CCD_SVY_CATS.SVY_CAT_ID = CCD_SVY_CAT_PRE_OPTS.SVY_CAT_ID
order by
UPPER(CCD_SVY_CAT_PRE.SVY_CAT_PRE_NAME),
UPPER(CCD_SVY_CATS.SVY_CAT_NAME)

;

COMMENT ON TABLE CCD_SVY_CAT_PRE_V IS 'Survey Category Presets (View)

This view returns all primary and secondary survey category presets and the associated survey category information';

COMMENT ON COLUMN CCD_SVY_CAT_PRE_V.SVY_CAT_PRE_OPT_ID IS 'Primary key for the CCD_SVY_CAT_PRE_OPTS table';
COMMENT ON COLUMN CCD_SVY_CAT_PRE_V.SVY_CAT_PRE_ID IS 'Primary key for the Survey Category Preset table';
COMMENT ON COLUMN CCD_SVY_CAT_PRE_V.SVY_CAT_PRE_NAME IS 'Name of the given Survey Category Preset';
COMMENT ON COLUMN CCD_SVY_CAT_PRE_V.SVY_CAT_PRE_DESC IS 'Description for the given Survey Category Preset';
COMMENT ON COLUMN CCD_SVY_CAT_PRE_V.SVY_CAT_ID IS 'Primary key for the Survey Category table';
COMMENT ON COLUMN CCD_SVY_CAT_PRE_V.SVY_CAT_NAME IS 'Name of the given Survey Category';
COMMENT ON COLUMN CCD_SVY_CAT_PRE_V.SVY_CAT_DESC IS 'Description for the given Survey Category';
COMMENT ON COLUMN CCD_SVY_CAT_PRE_V.SVY_CAT_PRIMARY_YN IS 'Boolean field to indicate if this is a preset for a primary survey category (Y) or a secondary survey category (N)';

COMMENT ON COLUMN CCD_SVY_CAT_PRE_V.FINSS_ID IS 'The ID value from the FINSS system';
COMMENT ON COLUMN CCD_SVY_CAT_PRE_V.SVY_CAT_PRE_OPT_NOTES IS 'Notes associated with the given survey category preset option';









--table to define the different MMPA Target Species presets
--MMPA Target Species Presets
--CCD_SPP_MMPA_PRE


CREATE TABLE CCD_SPP_MMPA_PRE
(
  MMPA_PRE_ID NUMBER NOT NULL
, MMPA_PRE_NAME VARCHAR2(200) NOT NULL
, MMPA_PRE_DESC VARCHAR2(500)
, CONSTRAINT CCD_SPP_MMPA_PRE_PK PRIMARY KEY
  (
    MMPA_PRE_ID
  )
  ENABLE
);

COMMENT ON COLUMN CCD_SPP_MMPA_PRE.MMPA_PRE_ID IS 'Primary key for the MMPA Target Species Preset table';

COMMENT ON COLUMN CCD_SPP_MMPA_PRE.MMPA_PRE_NAME IS 'Name of the given MMPA Target Species Preset';

COMMENT ON COLUMN CCD_SPP_MMPA_PRE.MMPA_PRE_DESC IS 'Description for the given MMPA Target Species Preset';

COMMENT ON TABLE CCD_SPP_MMPA_PRE IS 'MMPA Target Species Presets

This table defines MMPA Target Species Presets for implementation in the data management application';

ALTER TABLE CCD_SPP_MMPA_PRE ADD CONSTRAINT CCD_SPP_MMPA_PRE_U1 UNIQUE
(
  MMPA_PRE_NAME
)
ENABLE;


CREATE SEQUENCE CCD_SPP_MMPA_PRE_SEQ INCREMENT BY 1 START WITH 1;	ALTER TABLE CCD_SPP_MMPA_PRE ADD (CREATE_DATE DATE );	ALTER TABLE CCD_SPP_MMPA_PRE ADD (CREATED_BY VARCHAR2(30) );	ALTER TABLE CCD_SPP_MMPA_PRE ADD (LAST_MOD_DATE DATE );	ALTER TABLE CCD_SPP_MMPA_PRE ADD (LAST_MOD_BY VARCHAR2(30) );

COMMENT ON COLUMN CCD_SPP_MMPA_PRE.CREATE_DATE IS 'The date on which this record was created in the database';	COMMENT ON COLUMN CCD_SPP_MMPA_PRE.CREATED_BY IS 'The Oracle username of the person creating this record in the database';	COMMENT ON COLUMN CCD_SPP_MMPA_PRE.LAST_MOD_DATE IS 'The last date on which any of the data in this record was changed';	COMMENT ON COLUMN CCD_SPP_MMPA_PRE.LAST_MOD_BY IS 'The Oracle username of the person making the most recent change to this record';


create or replace TRIGGER CCD_SPP_MMPA_PRE_AUTO_BRI
before insert on CCD_SPP_MMPA_PRE
for each row
begin
  select CCD_SPP_MMPA_PRE_SEQ.nextval into :new.MMPA_PRE_ID from dual;
  :NEW.CREATE_DATE := SYSDATE;
  :NEW.CREATED_BY := nvl(v('APP_USER'),user);
end;
/

CREATE OR REPLACE TRIGGER CCD_SPP_MMPA_PRE_AUTO_BRU BEFORE
  UPDATE
    ON CCD_SPP_MMPA_PRE FOR EACH ROW
    BEGIN
      :NEW.LAST_MOD_DATE := SYSDATE;
      :NEW.LAST_MOD_BY := nvl(v('APP_USER'),user);
END;
/






--table for defining many-to-many relationship for different types of situations
--MMPA Target Species Preset Options
--CCD_SPP_MMPA_PRE_OPTS
CREATE TABLE CCD_SPP_MMPA_PRE_OPTS
(
  MMPA_PRE_OPT_ID NUMBER NOT NULL
, MMPA_PRE_ID NUMBER NOT NULL
, TGT_SPP_MMPA_ID NUMBER NOT NULL
, MMPA_PRE_OPT_NOTES VARCHAR2(500)
, CONSTRAINT CCD_SPP_MMPA_PRE_OPTS_PK PRIMARY KEY
  (
    MMPA_PRE_OPT_ID
  )
  ENABLE
);

CREATE INDEX CCD_SPP_MMPA_PRE_OPTS_I1 ON CCD_SPP_MMPA_PRE_OPTS (MMPA_PRE_ID);

CREATE INDEX CCD_SPP_MMPA_PRE_OPTS_I2 ON CCD_SPP_MMPA_PRE_OPTS (TGT_SPP_MMPA_ID);

ALTER TABLE CCD_SPP_MMPA_PRE_OPTS
ADD CONSTRAINT CCD_SPP_MMPA_PRE_OPTS_U1 UNIQUE
(
  MMPA_PRE_ID
, TGT_SPP_MMPA_ID
)
ENABLE;

ALTER TABLE CCD_SPP_MMPA_PRE_OPTS
ADD CONSTRAINT CCD_SPP_MMPA_PRE_OPTS_FK1 FOREIGN KEY
(
  TGT_SPP_MMPA_ID
)
REFERENCES CCD_TGT_SPP_MMPA
(
  TGT_SPP_MMPA_ID
)
ENABLE;

ALTER TABLE CCD_SPP_MMPA_PRE_OPTS
ADD CONSTRAINT CCD_SPP_MMPA_PRE_OPTS_FK2 FOREIGN KEY
(
  MMPA_PRE_ID
)
REFERENCES CCD_SPP_MMPA_PRE
(
  MMPA_PRE_ID
)
ENABLE;

COMMENT ON TABLE CCD_SPP_MMPA_PRE_OPTS IS 'MMPA Target Species Preset Options

This intersection table defines the many-to-many relationship between MMPA Target Species Presets and specific MMPA Target Species to allow groups of MMPA Target Species to be defined to make it easier for authorized application users to choose and define groups of MMPA Target Species for a given cruise';

COMMENT ON COLUMN CCD_SPP_MMPA_PRE_OPTS.MMPA_PRE_OPT_ID IS 'Primary key for the CCD_SPP_MMPA_PRE_OPTS table';

COMMENT ON COLUMN CCD_SPP_MMPA_PRE_OPTS.MMPA_PRE_ID IS 'The MMPA Target Species Preset that the given MMPA Target Species is associated with';

COMMENT ON COLUMN CCD_SPP_MMPA_PRE_OPTS.TGT_SPP_MMPA_ID IS 'The MMPA Target Species that the given MMPA Target Species Preset is associated with';

COMMENT ON COLUMN CCD_SPP_MMPA_PRE_OPTS.MMPA_PRE_OPT_NOTES IS 'Notes associated with the given MMPA Target Species Preset option';



CREATE SEQUENCE CCD_SPP_MMPA_PRE_OPTS_SEQ INCREMENT BY 1 START WITH 1;



create or replace TRIGGER
CCD_SPP_MMPA_PRE_OPTS_AUTO_BRI
before insert on CCD_SPP_MMPA_PRE_OPTS
for each row
begin
  select CCD_SPP_MMPA_PRE_OPTS_SEQ.nextval into :new.MMPA_PRE_OPT_ID from dual;
end;
/









CREATE OR REPLACE VIEW
CCD_SPP_MMPA_PRE_V

AS

SELECT
CCD_SPP_MMPA_PRE_OPTS.MMPA_PRE_OPT_ID,
CCD_SPP_MMPA_PRE.MMPA_PRE_ID,
CCD_SPP_MMPA_PRE.MMPA_PRE_NAME,
CCD_SPP_MMPA_PRE.MMPA_PRE_DESC,
CCD_SPP_MMPA_PRE_OPTS.TGT_SPP_MMPA_ID,
CCD_TGT_SPP_MMPA.TGT_SPP_MMPA_NAME,
CCD_TGT_SPP_MMPA.TGT_SPP_MMPA_DESC,
CCD_TGT_SPP_MMPA.FINSS_ID,
CCD_SPP_MMPA_PRE_OPTS.MMPA_PRE_OPT_NOTES


FROM CCD_SPP_MMPA_PRE
LEFT JOIN
CCD_SPP_MMPA_PRE_OPTS ON CCD_SPP_MMPA_PRE_OPTS.MMPA_PRE_ID = CCD_SPP_MMPA_PRE.MMPA_PRE_ID
LEFT JOIN
CCD_TGT_SPP_MMPA ON CCD_TGT_SPP_MMPA.TGT_SPP_MMPA_ID = CCD_SPP_MMPA_PRE_OPTS.TGT_SPP_MMPA_ID
order by
UPPER(CCD_SPP_MMPA_PRE.MMPA_PRE_NAME),
UPPER(CCD_TGT_SPP_MMPA.TGT_SPP_MMPA_NAME)

;


COMMENT ON COLUMN CCD_SPP_MMPA_PRE_V.MMPA_PRE_OPT_ID IS 'Primary key for the CCD_SPP_MMPA_PRE_OPTS table';
COMMENT ON COLUMN CCD_SPP_MMPA_PRE_V.MMPA_PRE_ID IS 'Primary key for the MMPA Target Species Preset table';
COMMENT ON COLUMN CCD_SPP_MMPA_PRE_V.MMPA_PRE_NAME IS 'Name of the given MMPA Target Species Preset';
COMMENT ON COLUMN CCD_SPP_MMPA_PRE_V.MMPA_PRE_DESC IS 'Description for the given MMPA Target Species Preset';
COMMENT ON COLUMN CCD_SPP_MMPA_PRE_V.TGT_SPP_MMPA_ID IS 'Primary key for the MMPA Target Species table';
COMMENT ON COLUMN CCD_SPP_MMPA_PRE_V.TGT_SPP_MMPA_NAME IS 'Name of the given MMPA Target Species';
COMMENT ON COLUMN CCD_SPP_MMPA_PRE_V.TGT_SPP_MMPA_DESC IS 'Description for the given MMPA Target Species';
COMMENT ON COLUMN CCD_SPP_MMPA_PRE_V.FINSS_ID IS 'The ID value from the FINSS system';
COMMENT ON COLUMN CCD_SPP_MMPA_PRE_V.MMPA_PRE_OPT_NOTES IS 'Notes associated with the given MMPA Target Species Preset option';

COMMENT ON TABLE CCD_SPP_MMPA_PRE_V IS 'MMPA Target Species Presets (View)

This view returns all MMPA Target Species Presets and the associated MMPA Target Species information';









--table to define the different ESA Target Species presets
--ESA Target Species Presets
--CCD_SPP_ESA_PRE


CREATE TABLE CCD_SPP_ESA_PRE
(
  ESA_PRE_ID NUMBER NOT NULL
, ESA_PRE_NAME VARCHAR2(200) NOT NULL
, ESA_PRE_DESC VARCHAR2(500)
, CONSTRAINT CCD_SPP_ESA_PRE_PK PRIMARY KEY
  (
    ESA_PRE_ID
  )
  ENABLE
);

COMMENT ON COLUMN CCD_SPP_ESA_PRE.ESA_PRE_ID IS 'Primary key for the ESA Target Species Preset table';

COMMENT ON COLUMN CCD_SPP_ESA_PRE.ESA_PRE_NAME IS 'Name of the given ESA Target Species Preset';

COMMENT ON COLUMN CCD_SPP_ESA_PRE.ESA_PRE_DESC IS 'Description for the given ESA Target Species Preset';

COMMENT ON TABLE CCD_SPP_ESA_PRE IS 'ESA Target Species Presets

This table defines ESA Target Species Presets for implementation in the data management application';

ALTER TABLE CCD_SPP_ESA_PRE ADD CONSTRAINT CCD_SPP_ESA_PRE_U1 UNIQUE
(
  ESA_PRE_NAME
)
ENABLE;


CREATE SEQUENCE CCD_SPP_ESA_PRE_SEQ INCREMENT BY 1 START WITH 1;	ALTER TABLE CCD_SPP_ESA_PRE ADD (CREATE_DATE DATE );	ALTER TABLE CCD_SPP_ESA_PRE ADD (CREATED_BY VARCHAR2(30) );	ALTER TABLE CCD_SPP_ESA_PRE ADD (LAST_MOD_DATE DATE );	ALTER TABLE CCD_SPP_ESA_PRE ADD (LAST_MOD_BY VARCHAR2(30) );

COMMENT ON COLUMN CCD_SPP_ESA_PRE.CREATE_DATE IS 'The date on which this record was created in the database';	COMMENT ON COLUMN CCD_SPP_ESA_PRE.CREATED_BY IS 'The Oracle username of the person creating this record in the database';	COMMENT ON COLUMN CCD_SPP_ESA_PRE.LAST_MOD_DATE IS 'The last date on which any of the data in this record was changed';	COMMENT ON COLUMN CCD_SPP_ESA_PRE.LAST_MOD_BY IS 'The Oracle username of the person making the most recent change to this record';


create or replace TRIGGER CCD_SPP_ESA_PRE_AUTO_BRI
before insert on CCD_SPP_ESA_PRE
for each row
begin
  select CCD_SPP_ESA_PRE_SEQ.nextval into :new.ESA_PRE_ID from dual;
  :NEW.CREATE_DATE := SYSDATE;
  :NEW.CREATED_BY := nvl(v('APP_USER'),user);
end;
/

CREATE OR REPLACE TRIGGER CCD_SPP_ESA_PRE_AUTO_BRU BEFORE
  UPDATE
    ON CCD_SPP_ESA_PRE FOR EACH ROW
    BEGIN
      :NEW.LAST_MOD_DATE := SYSDATE;
      :NEW.LAST_MOD_BY := nvl(v('APP_USER'),user);
END;
/






--table for defining many-to-many relationship for different types of situations
--ESA Target Species Preset Options
--CCD_SPP_ESA_PRE_OPTS
CREATE TABLE CCD_SPP_ESA_PRE_OPTS
(
  ESA_PRE_OPT_ID NUMBER NOT NULL
, ESA_PRE_ID NUMBER NOT NULL
, TGT_SPP_ESA_ID NUMBER NOT NULL
, ESA_PRE_OPT_NOTES VARCHAR2(500)
, CONSTRAINT CCD_SPP_ESA_PRE_OPTS_PK PRIMARY KEY
  (
    ESA_PRE_OPT_ID
  )
  ENABLE
);

CREATE INDEX CCD_SPP_ESA_PRE_OPTS_I1 ON CCD_SPP_ESA_PRE_OPTS (ESA_PRE_ID);

CREATE INDEX CCD_SPP_ESA_PRE_OPTS_I2 ON CCD_SPP_ESA_PRE_OPTS (TGT_SPP_ESA_ID);

ALTER TABLE CCD_SPP_ESA_PRE_OPTS
ADD CONSTRAINT CCD_SPP_ESA_PRE_OPTS_U1 UNIQUE
(
  ESA_PRE_ID
, TGT_SPP_ESA_ID
)
ENABLE;

ALTER TABLE CCD_SPP_ESA_PRE_OPTS
ADD CONSTRAINT CCD_SPP_ESA_PRE_OPTS_FK1 FOREIGN KEY
(
  TGT_SPP_ESA_ID
)
REFERENCES CCD_TGT_SPP_ESA
(
  TGT_SPP_ESA_ID
)
ENABLE;

ALTER TABLE CCD_SPP_ESA_PRE_OPTS
ADD CONSTRAINT CCD_SPP_ESA_PRE_OPTS_FK2 FOREIGN KEY
(
  ESA_PRE_ID
)
REFERENCES CCD_SPP_ESA_PRE
(
  ESA_PRE_ID
)
ENABLE;

COMMENT ON TABLE CCD_SPP_ESA_PRE_OPTS IS 'ESA Target Species Preset Options

This intersection table defines the many-to-many relationship between ESA Target Species Presets and specific ESA Target Species to allow groups of ESA Target Species to be defined to make it easier for authorized application users to choose and define groups of ESA Target Species for a given cruise';

COMMENT ON COLUMN CCD_SPP_ESA_PRE_OPTS.ESA_PRE_OPT_ID IS 'Primary key for the CCD_SPP_ESA_PRE_OPTS table';

COMMENT ON COLUMN CCD_SPP_ESA_PRE_OPTS.ESA_PRE_ID IS 'The ESA Target Species Preset that the given ESA Target Species is associated with';

COMMENT ON COLUMN CCD_SPP_ESA_PRE_OPTS.TGT_SPP_ESA_ID IS 'The ESA Target Species that the given ESA Target Species Preset is associated with';

COMMENT ON COLUMN CCD_SPP_ESA_PRE_OPTS.ESA_PRE_OPT_NOTES IS 'Notes associated with the given ESA Target Species Preset option';



CREATE SEQUENCE CCD_SPP_ESA_PRE_OPTS_SEQ INCREMENT BY 1 START WITH 1;



create or replace TRIGGER
CCD_SPP_ESA_PRE_OPTS_AUTO_BRI
before insert on CCD_SPP_ESA_PRE_OPTS
for each row
begin
  select CCD_SPP_ESA_PRE_OPTS_SEQ.nextval into :new.ESA_PRE_OPT_ID from dual;
end;
/









CREATE OR REPLACE VIEW
CCD_SPP_ESA_PRE_V

AS

SELECT
CCD_SPP_ESA_PRE_OPTS.ESA_PRE_OPT_ID,
CCD_SPP_ESA_PRE.ESA_PRE_ID,
CCD_SPP_ESA_PRE.ESA_PRE_NAME,
CCD_SPP_ESA_PRE.ESA_PRE_DESC,
CCD_SPP_ESA_PRE_OPTS.TGT_SPP_ESA_ID,
CCD_TGT_SPP_ESA.TGT_SPP_ESA_NAME,
CCD_TGT_SPP_ESA.TGT_SPP_ESA_DESC,
CCD_TGT_SPP_ESA.FINSS_ID,
CCD_SPP_ESA_PRE_OPTS.ESA_PRE_OPT_NOTES


FROM CCD_SPP_ESA_PRE
LEFT JOIN
CCD_SPP_ESA_PRE_OPTS ON CCD_SPP_ESA_PRE_OPTS.ESA_PRE_ID = CCD_SPP_ESA_PRE.ESA_PRE_ID
LEFT JOIN
CCD_TGT_SPP_ESA ON CCD_TGT_SPP_ESA.TGT_SPP_ESA_ID = CCD_SPP_ESA_PRE_OPTS.TGT_SPP_ESA_ID
order by
UPPER(CCD_SPP_ESA_PRE.ESA_PRE_NAME),
UPPER(CCD_TGT_SPP_ESA.TGT_SPP_ESA_NAME)

;


COMMENT ON COLUMN CCD_SPP_ESA_PRE_V.ESA_PRE_OPT_ID IS 'Primary key for the CCD_SPP_ESA_PRE_OPTS table';
COMMENT ON COLUMN CCD_SPP_ESA_PRE_V.ESA_PRE_ID IS 'Primary key for the ESA Target Species Preset table';
COMMENT ON COLUMN CCD_SPP_ESA_PRE_V.ESA_PRE_NAME IS 'Name of the given ESA Target Species Preset';
COMMENT ON COLUMN CCD_SPP_ESA_PRE_V.ESA_PRE_DESC IS 'Description for the given ESA Target Species Preset';
COMMENT ON COLUMN CCD_SPP_ESA_PRE_V.TGT_SPP_ESA_ID IS 'Primary key for the ESA Target Species table';
COMMENT ON COLUMN CCD_SPP_ESA_PRE_V.TGT_SPP_ESA_NAME IS 'Name of the given ESA Target Species';
COMMENT ON COLUMN CCD_SPP_ESA_PRE_V.TGT_SPP_ESA_DESC IS 'Description for the given ESA Target Species';
COMMENT ON COLUMN CCD_SPP_ESA_PRE_V.FINSS_ID IS 'The ID value from the FINSS system';
COMMENT ON COLUMN CCD_SPP_ESA_PRE_V.ESA_PRE_OPT_NOTES IS 'Notes associated with the given ESA Target Species Preset option';

COMMENT ON TABLE CCD_SPP_ESA_PRE_V IS 'ESA Target Species Presets (View)

This view returns all ESA Target Species Presets and the associated ESA Target Species information';








--table to define the different FSSI Target Species presets
--FSSI Target Species Presets
--CCD_SPP_FSSI_PRE


CREATE TABLE CCD_SPP_FSSI_PRE
(
  FSSI_PRE_ID NUMBER NOT NULL
, FSSI_PRE_NAME VARCHAR2(200) NOT NULL
, FSSI_PRE_DESC VARCHAR2(500)
, CONSTRAINT CCD_SPP_FSSI_PRE_PK PRIMARY KEY
  (
    FSSI_PRE_ID
  )
  ENABLE
);

COMMENT ON COLUMN CCD_SPP_FSSI_PRE.FSSI_PRE_ID IS 'Primary key for the FSSI Target Species Preset table';

COMMENT ON COLUMN CCD_SPP_FSSI_PRE.FSSI_PRE_NAME IS 'Name of the given FSSI Target Species Preset';

COMMENT ON COLUMN CCD_SPP_FSSI_PRE.FSSI_PRE_DESC IS 'Description for the given FSSI Target Species Preset';

COMMENT ON TABLE CCD_SPP_FSSI_PRE IS 'FSSI Target Species Presets

This table defines FSSI Target Species Presets for implementation in the data management application';

ALTER TABLE CCD_SPP_FSSI_PRE ADD CONSTRAINT CCD_SPP_FSSI_PRE_U1 UNIQUE
(
  FSSI_PRE_NAME
)
ENABLE;


CREATE SEQUENCE CCD_SPP_FSSI_PRE_SEQ INCREMENT BY 1 START WITH 1;	ALTER TABLE CCD_SPP_FSSI_PRE ADD (CREATE_DATE DATE );	ALTER TABLE CCD_SPP_FSSI_PRE ADD (CREATED_BY VARCHAR2(30) );	ALTER TABLE CCD_SPP_FSSI_PRE ADD (LAST_MOD_DATE DATE );	ALTER TABLE CCD_SPP_FSSI_PRE ADD (LAST_MOD_BY VARCHAR2(30) );

COMMENT ON COLUMN CCD_SPP_FSSI_PRE.CREATE_DATE IS 'The date on which this record was created in the database';	COMMENT ON COLUMN CCD_SPP_FSSI_PRE.CREATED_BY IS 'The Oracle username of the person creating this record in the database';	COMMENT ON COLUMN CCD_SPP_FSSI_PRE.LAST_MOD_DATE IS 'The last date on which any of the data in this record was changed';	COMMENT ON COLUMN CCD_SPP_FSSI_PRE.LAST_MOD_BY IS 'The Oracle username of the person making the most recent change to this record';


create or replace TRIGGER CCD_SPP_FSSI_PRE_AUTO_BRI
before insert on CCD_SPP_FSSI_PRE
for each row
begin
  select CCD_SPP_FSSI_PRE_SEQ.nextval into :new.FSSI_PRE_ID from dual;
  :NEW.CREATE_DATE := SYSDATE;
  :NEW.CREATED_BY := nvl(v('APP_USER'),user);
end;
/

CREATE OR REPLACE TRIGGER CCD_SPP_FSSI_PRE_AUTO_BRU BEFORE
  UPDATE
    ON CCD_SPP_FSSI_PRE FOR EACH ROW
    BEGIN
      :NEW.LAST_MOD_DATE := SYSDATE;
      :NEW.LAST_MOD_BY := nvl(v('APP_USER'),user);
END;
/






--table for defining many-to-many relationship for different types of situations
--FSSI Target Species Preset Options
--CCD_SPP_FSSI_PRE_OPTS
CREATE TABLE CCD_SPP_FSSI_PRE_OPTS
(
  FSSI_PRE_OPT_ID NUMBER NOT NULL
, FSSI_PRE_ID NUMBER NOT NULL
, TGT_SPP_FSSI_ID NUMBER NOT NULL
, FSSI_PRE_OPT_NOTES VARCHAR2(500)
, CONSTRAINT CCD_SPP_FSSI_PRE_OPTS_PK PRIMARY KEY
  (
    FSSI_PRE_OPT_ID
  )
  ENABLE
);

CREATE INDEX CCD_SPP_FSSI_PRE_OPTS_I1 ON CCD_SPP_FSSI_PRE_OPTS (FSSI_PRE_ID);

CREATE INDEX CCD_SPP_FSSI_PRE_OPTS_I2 ON CCD_SPP_FSSI_PRE_OPTS (TGT_SPP_FSSI_ID);

ALTER TABLE CCD_SPP_FSSI_PRE_OPTS
ADD CONSTRAINT CCD_SPP_FSSI_PRE_OPTS_U1 UNIQUE
(
  FSSI_PRE_ID
, TGT_SPP_FSSI_ID
)
ENABLE;

ALTER TABLE CCD_SPP_FSSI_PRE_OPTS
ADD CONSTRAINT CCD_SPP_FSSI_PRE_OPTS_FK1 FOREIGN KEY
(
  TGT_SPP_FSSI_ID
)
REFERENCES CCD_TGT_SPP_FSSI
(
  TGT_SPP_FSSI_ID
)
ENABLE;

ALTER TABLE CCD_SPP_FSSI_PRE_OPTS
ADD CONSTRAINT CCD_SPP_FSSI_PRE_OPTS_FK2 FOREIGN KEY
(
  FSSI_PRE_ID
)
REFERENCES CCD_SPP_FSSI_PRE
(
  FSSI_PRE_ID
)
ENABLE;

COMMENT ON TABLE CCD_SPP_FSSI_PRE_OPTS IS 'FSSI Target Species Preset Options

This intersection table defines the many-to-many relationship between FSSI Target Species Presets and specific FSSI Target Species to allow groups of FSSI Target Species to be defined to make it easier for authorized application users to choose and define groups of FSSI Target Species for a given cruise';

COMMENT ON COLUMN CCD_SPP_FSSI_PRE_OPTS.FSSI_PRE_OPT_ID IS 'Primary key for the CCD_SPP_FSSI_PRE_OPTS table';

COMMENT ON COLUMN CCD_SPP_FSSI_PRE_OPTS.FSSI_PRE_ID IS 'The FSSI Target Species Preset that the given FSSI Target Species is associated with';

COMMENT ON COLUMN CCD_SPP_FSSI_PRE_OPTS.TGT_SPP_FSSI_ID IS 'The FSSI Target Species that the given FSSI Target Species Preset is associated with';

COMMENT ON COLUMN CCD_SPP_FSSI_PRE_OPTS.FSSI_PRE_OPT_NOTES IS 'Notes associated with the given FSSI Target Species Preset option';



CREATE SEQUENCE CCD_SPP_FSSI_PRE_OPTS_SEQ INCREMENT BY 1 START WITH 1;



create or replace TRIGGER
CCD_SPP_FSSI_PRE_OPTS_AUTO_BRI
before insert on CCD_SPP_FSSI_PRE_OPTS
for each row
begin
  select CCD_SPP_FSSI_PRE_OPTS_SEQ.nextval into :new.FSSI_PRE_OPT_ID from dual;
end;
/









CREATE OR REPLACE VIEW
CCD_SPP_FSSI_PRE_V

AS

SELECT
CCD_SPP_FSSI_PRE_OPTS.FSSI_PRE_OPT_ID,
CCD_SPP_FSSI_PRE.FSSI_PRE_ID,
CCD_SPP_FSSI_PRE.FSSI_PRE_NAME,
CCD_SPP_FSSI_PRE.FSSI_PRE_DESC,
CCD_SPP_FSSI_PRE_OPTS.TGT_SPP_FSSI_ID,
CCD_TGT_SPP_FSSI.TGT_SPP_FSSI_NAME,
CCD_TGT_SPP_FSSI.TGT_SPP_FSSI_DESC,
CCD_TGT_SPP_FSSI.FINSS_ID,
CCD_SPP_FSSI_PRE_OPTS.FSSI_PRE_OPT_NOTES


FROM CCD_SPP_FSSI_PRE
LEFT JOIN
CCD_SPP_FSSI_PRE_OPTS ON CCD_SPP_FSSI_PRE_OPTS.FSSI_PRE_ID = CCD_SPP_FSSI_PRE.FSSI_PRE_ID
LEFT JOIN
CCD_TGT_SPP_FSSI ON CCD_TGT_SPP_FSSI.TGT_SPP_FSSI_ID = CCD_SPP_FSSI_PRE_OPTS.TGT_SPP_FSSI_ID
order by
UPPER(CCD_SPP_FSSI_PRE.FSSI_PRE_NAME),
UPPER(CCD_TGT_SPP_FSSI.TGT_SPP_FSSI_NAME)

;


COMMENT ON COLUMN CCD_SPP_FSSI_PRE_V.FSSI_PRE_OPT_ID IS 'Primary key for the CCD_SPP_FSSI_PRE_OPTS table';
COMMENT ON COLUMN CCD_SPP_FSSI_PRE_V.FSSI_PRE_ID IS 'Primary key for the FSSI Target Species Preset table';
COMMENT ON COLUMN CCD_SPP_FSSI_PRE_V.FSSI_PRE_NAME IS 'Name of the given FSSI Target Species Preset';
COMMENT ON COLUMN CCD_SPP_FSSI_PRE_V.FSSI_PRE_DESC IS 'Description for the given FSSI Target Species Preset';
COMMENT ON COLUMN CCD_SPP_FSSI_PRE_V.TGT_SPP_FSSI_ID IS 'Primary key for the FSSI Target Species table';
COMMENT ON COLUMN CCD_SPP_FSSI_PRE_V.TGT_SPP_FSSI_NAME IS 'Name of the given FSSI Target Species';
COMMENT ON COLUMN CCD_SPP_FSSI_PRE_V.TGT_SPP_FSSI_DESC IS 'Description for the given FSSI Target Species';
COMMENT ON COLUMN CCD_SPP_FSSI_PRE_V.FINSS_ID IS 'The ID value from the FINSS system';
COMMENT ON COLUMN CCD_SPP_FSSI_PRE_V.FSSI_PRE_OPT_NOTES IS 'Notes associated with the given FSSI Target Species Preset option';

COMMENT ON TABLE CCD_SPP_FSSI_PRE_V IS 'FSSI Target Species Presets (View)

This view returns all FSSI Target Species Presets and the associated FSSI Target Species information';
















--table to define the different Expected Species Categories Presets
--Expected Species Categories Presets
--CCD_SPP_CAT_PRE


CREATE TABLE CCD_SPP_CAT_PRE
(
  SPP_CAT_PRE_ID NUMBER NOT NULL
, SPP_CAT_PRE_NAME VARCHAR2(200) NOT NULL
, SPP_CAT_PRE_DESC VARCHAR2(500)
, CONSTRAINT CCD_SPP_CAT_PRE_PK PRIMARY KEY
  (
    SPP_CAT_PRE_ID
  )
  ENABLE
);

COMMENT ON COLUMN CCD_SPP_CAT_PRE.SPP_CAT_PRE_ID IS 'Primary key for the Expected Species Categories Preset table';

COMMENT ON COLUMN CCD_SPP_CAT_PRE.SPP_CAT_PRE_NAME IS 'Name of the given Expected Species Categories Preset';

COMMENT ON COLUMN CCD_SPP_CAT_PRE.SPP_CAT_PRE_DESC IS 'Description for the given Expected Species Categories Preset';

COMMENT ON TABLE CCD_SPP_CAT_PRE IS 'Expected Species Categories Presets

This table defines Expected Species Categories Presets for implementation in the data management application';

ALTER TABLE CCD_SPP_CAT_PRE ADD CONSTRAINT CCD_SPP_CAT_PRE_U1 UNIQUE
(
  SPP_CAT_PRE_NAME
)
ENABLE;


CREATE SEQUENCE CCD_SPP_CAT_PRE_SEQ INCREMENT BY 1 START WITH 1;	ALTER TABLE CCD_SPP_CAT_PRE ADD (CREATE_DATE DATE );	ALTER TABLE CCD_SPP_CAT_PRE ADD (CREATED_BY VARCHAR2(30) );	ALTER TABLE CCD_SPP_CAT_PRE ADD (LAST_MOD_DATE DATE );	ALTER TABLE CCD_SPP_CAT_PRE ADD (LAST_MOD_BY VARCHAR2(30) );

COMMENT ON COLUMN CCD_SPP_CAT_PRE.CREATE_DATE IS 'The date on which this record was created in the database';	COMMENT ON COLUMN CCD_SPP_CAT_PRE.CREATED_BY IS 'The Oracle username of the person creating this record in the database';	COMMENT ON COLUMN CCD_SPP_CAT_PRE.LAST_MOD_DATE IS 'The last date on which any of the data in this record was changed';	COMMENT ON COLUMN CCD_SPP_CAT_PRE.LAST_MOD_BY IS 'The Oracle username of the person making the most recent change to this record';


create or replace TRIGGER CCD_SPP_CAT_PRE_AUTO_BRI
before insert on CCD_SPP_CAT_PRE
for each row
begin
  select CCD_SPP_CAT_PRE_SEQ.nextval into :new.SPP_CAT_PRE_ID from dual;
  :NEW.CREATE_DATE := SYSDATE;
  :NEW.CREATED_BY := nvl(v('APP_USER'),user);
end;
/

CREATE OR REPLACE TRIGGER CCD_SPP_CAT_PRE_AUTO_BRU BEFORE
  UPDATE
    ON CCD_SPP_CAT_PRE FOR EACH ROW
    BEGIN
      :NEW.LAST_MOD_DATE := SYSDATE;
      :NEW.LAST_MOD_BY := nvl(v('APP_USER'),user);
END;
/






--table for defining many-to-many relationship for different types of situations
--Expected Species Categories Preset Options
--CCD_SPP_CAT_PRE_OPTS
CREATE TABLE CCD_SPP_CAT_PRE_OPTS
(
  SPP_CAT_PRE_OPT_ID NUMBER NOT NULL
, SPP_CAT_PRE_ID NUMBER NOT NULL
, EXP_SPP_CAT_ID NUMBER NOT NULL
, SPP_CAT_PRE_OPT_NOTES VARCHAR2(500)
, CONSTRAINT CCD_SPP_CAT_PRE_OPTS_PK PRIMARY KEY
  (
    SPP_CAT_PRE_OPT_ID
  )
  ENABLE
);

CREATE INDEX CCD_SPP_CAT_PRE_OPTS_I1 ON CCD_SPP_CAT_PRE_OPTS (SPP_CAT_PRE_ID);

CREATE INDEX CCD_SPP_CAT_PRE_OPTS_I2 ON CCD_SPP_CAT_PRE_OPTS (EXP_SPP_CAT_ID);

ALTER TABLE CCD_SPP_CAT_PRE_OPTS
ADD CONSTRAINT CCD_SPP_CAT_PRE_OPTS_U1 UNIQUE
(
  SPP_CAT_PRE_ID
, EXP_SPP_CAT_ID
)
ENABLE;

ALTER TABLE CCD_SPP_CAT_PRE_OPTS
ADD CONSTRAINT CCD_SPP_CAT_PRE_OPTS_FK1 FOREIGN KEY
(
  EXP_SPP_CAT_ID
)
REFERENCES CCD_EXP_SPP_CATS
(
  EXP_SPP_CAT_ID
)
ENABLE;

ALTER TABLE CCD_SPP_CAT_PRE_OPTS
ADD CONSTRAINT CCD_SPP_CAT_PRE_OPTS_FK2 FOREIGN KEY
(
  SPP_CAT_PRE_ID
)
REFERENCES CCD_SPP_CAT_PRE
(
  SPP_CAT_PRE_ID
)
ENABLE;

COMMENT ON TABLE CCD_SPP_CAT_PRE_OPTS IS 'Expected Species Categories Preset Options

This intersection table defines the many-to-many relationship between Expected Species Categories Presets and specific Expected Species Categories to allow groups of Expected Species Categories to be defined to make it easier for authorized application users to choose and define groups of Expected Species Categories for a given cruise';

COMMENT ON COLUMN CCD_SPP_CAT_PRE_OPTS.SPP_CAT_PRE_OPT_ID IS 'Primary key for the CCD_SPP_CAT_PRE_OPTS table';

COMMENT ON COLUMN CCD_SPP_CAT_PRE_OPTS.SPP_CAT_PRE_ID IS 'The Expected Species Category Preset that the given Expected Species Categories are associated with';

COMMENT ON COLUMN CCD_SPP_CAT_PRE_OPTS.EXP_SPP_CAT_ID IS 'The Expected Species Category that the given Expected Species Categories Preset are associated with';

COMMENT ON COLUMN CCD_SPP_CAT_PRE_OPTS.SPP_CAT_PRE_OPT_NOTES IS 'Notes associated with the given Expected Species Categories Preset option';



CREATE SEQUENCE CCD_SPP_CAT_PRE_OPTS_SEQ INCREMENT BY 1 START WITH 1;



create or replace TRIGGER
CCD_SPP_CAT_PRE_OPTS_AUTO_BRI
before insert on CCD_SPP_CAT_PRE_OPTS
for each row
begin
  select CCD_SPP_CAT_PRE_OPTS_SEQ.nextval into :new.SPP_CAT_PRE_OPT_ID from dual;
end;
/









CREATE OR REPLACE VIEW
CCD_SPP_CAT_PRE_V

AS

SELECT
CCD_SPP_CAT_PRE_OPTS.SPP_CAT_PRE_OPT_ID,
CCD_SPP_CAT_PRE.SPP_CAT_PRE_ID,
CCD_SPP_CAT_PRE.SPP_CAT_PRE_NAME,
CCD_SPP_CAT_PRE.SPP_CAT_PRE_DESC,
CCD_SPP_CAT_PRE_OPTS.EXP_SPP_CAT_ID,
CCD_EXP_SPP_CATS.EXP_SPP_CAT_NAME,
CCD_EXP_SPP_CATS.EXP_SPP_CAT_DESC,
CCD_EXP_SPP_CATS.FINSS_ID,
CCD_SPP_CAT_PRE_OPTS.SPP_CAT_PRE_OPT_NOTES


FROM CCD_SPP_CAT_PRE
LEFT JOIN
CCD_SPP_CAT_PRE_OPTS ON CCD_SPP_CAT_PRE_OPTS.SPP_CAT_PRE_ID = CCD_SPP_CAT_PRE.SPP_CAT_PRE_ID
LEFT JOIN
CCD_EXP_SPP_CATS ON CCD_EXP_SPP_CATS.EXP_SPP_CAT_ID = CCD_SPP_CAT_PRE_OPTS.EXP_SPP_CAT_ID
order by
UPPER(CCD_SPP_CAT_PRE.SPP_CAT_PRE_NAME),
UPPER(CCD_EXP_SPP_CATS.EXP_SPP_CAT_NAME)

;


COMMENT ON COLUMN CCD_SPP_CAT_PRE_V.SPP_CAT_PRE_OPT_ID IS 'Primary key for the CCD_SPP_CAT_PRE_OPTS table';
COMMENT ON COLUMN CCD_SPP_CAT_PRE_V.SPP_CAT_PRE_ID IS 'Primary key for the Expected Species Categories Preset table';
COMMENT ON COLUMN CCD_SPP_CAT_PRE_V.SPP_CAT_PRE_NAME IS 'Name of the given Expected Species Categories Preset';
COMMENT ON COLUMN CCD_SPP_CAT_PRE_V.SPP_CAT_PRE_DESC IS 'Description for the given Expected Species Categories Preset';
COMMENT ON COLUMN CCD_SPP_CAT_PRE_V.EXP_SPP_CAT_ID IS 'Primary key for the Expected Species Categories table';
COMMENT ON COLUMN CCD_SPP_CAT_PRE_V.EXP_SPP_CAT_NAME IS 'Name of the given Expected Species Categories';
COMMENT ON COLUMN CCD_SPP_CAT_PRE_V.EXP_SPP_CAT_DESC IS 'Description for the given Expected Species Categories';
COMMENT ON COLUMN CCD_SPP_CAT_PRE_V.FINSS_ID IS 'The ID value from the FINSS system';
COMMENT ON COLUMN CCD_SPP_CAT_PRE_V.SPP_CAT_PRE_OPT_NOTES IS 'Notes associated with the given Expected Species Categories Preset option';

COMMENT ON TABLE CCD_SPP_CAT_PRE_V IS 'Expected Species Categories Presets (View)

This view returns all Expected Species Categories Presets and the associated Expected Species Categories information';










	--CRUISE Package Specification:
	CREATE OR REPLACE PACKAGE CRUISE_PKG
	AUTHID DEFINER
	--this package provides functions and procedures to interact with the Cruise package module

	AS

	--function that accepts a P_LEG_ALIAS value and returns the CRUISE_LEG_ID value for the CCD_CRUISE_LEGS record that has a corresponding CCD_LEG_ALIASES record with a LEG_ALIAS_NAME that matches the P_LEG_ALIAS value.  It returns NULL if no match is found
	FUNCTION LEG_ALIAS_TO_CRUISE_LEG_ID (P_LEG_ALIAS VARCHAR2) RETURN NUMBER;

  --Append Reference Preset Options function
  --function that accepts a list of colon-delimited integers (P_DELIM_VALUES) representing the primary key values of the given reference table preset options.  The P_OPTS_QUERY is the query for the primary key values for the given options query with a primary key parameter that will be used with the defined primary key value (P_PRI_KEY_VAL) when executing the query to return the associated primary key values.  The return value will be the colon-delimited string that contains any additional primary key values that were returned by the P_OPTS_QUERY
  FUNCTION APPEND_REF_PRE_OPTS_FN (P_DELIM_VALUES IN VARCHAR2, P_OPTS_QUERY IN VARCHAR2, P_PRI_KEY_VAL IN NUMBER) RETURN VARCHAR2;


	END CRUISE_PKG;
	/

	--CTD Package Body:
	create or replace PACKAGE BODY CRUISE_PKG
	--this package provides functions and procedures to interact with the CTD package module
	AS





	--function that accepts a P_LEG_ALIAS value and returns the CRUISE_LEG_ID value for the CCD_CRUISE_LEGS record that has a corresponding CCD_LEG_ALIASES record with a LEG_ALIAS_NAME that matches the P_LEG_ALIAS value.  It returns NULL if no match is found
		FUNCTION LEG_ALIAS_TO_CRUISE_LEG_ID (P_LEG_ALIAS VARCHAR2)
			RETURN NUMBER is
						v_cruise_leg_id NUMBER;

						v_return_code PLS_INTEGER;

		BEGIN

        select ccd_cruise_legs_v.cruise_leg_id into v_cruise_leg_id
        from ccd_cruise_legs_v inner join ccd_leg_aliases on ccd_leg_aliases.cruise_leg_id = ccd_cruise_legs_v.cruise_leg_id
        AND UPPER(ccd_leg_aliases.LEG_ALIAS_NAME) = UPPER(P_LEG_ALIAS);


				--return the value of CRUISE_LEG_ID from the query
				RETURN v_cruise_leg_id;

				EXCEPTION

					WHEN NO_DATA_FOUND THEN

          --no results returned by the query, return NULL

					RETURN NULL;

					--catch all PL/SQL database exceptions:
					WHEN OTHERS THEN

					--catch all other errors:

					--return NULL to indicate the error:
					RETURN NULL;

		END LEG_ALIAS_TO_CRUISE_LEG_ID;




    --Append Reference Preset Options function
    --function that accepts a list of colon-delimited integers (P_DELIM_VALUES) representing the primary key values of the given reference table preset options.  The P_OPTS_QUERY is the query for the primary key values for the given options query with a primary key parameter that will be used with the defined primary key value (P_PRI_KEY_VAL) when executing the query to return the associated primary key values.  The return value will be the colon-delimited string that contains any additional primary key values that were returned by the P_OPTS_QUERY
  FUNCTION APPEND_REF_PRE_OPTS_FN (P_DELIM_VALUES IN VARCHAR2, P_OPTS_QUERY IN VARCHAR2, P_PRI_KEY_VAL IN NUMBER) RETURN VARCHAR2

  IS

    --array to store the parsed colon-delimited values from P_DELIM_VALUES
    l_selected apex_application_global.vc_arr2;

    --return code to be used by calls to the DB_LOG_PKG package:
    V_RETURN_CODE PLS_INTEGER;

    --variable to track if the current result set primary key value is already contained in the colon-delimited list of values:
    V_ID_FOUND BOOLEAN := FALSE;

    --variable to store the current primary key value returned by the query:
    V_OPT_PRI_KEY NUMBER;

    --reference cursor to handle dynamic query
    TYPE cur_typ IS REF CURSOR;

    --reference cursor variable:
    c cur_typ;

  BEGIN

    CEN_CRUISE.DB_LOG_PKG.ADD_LOG_ENTRY('DEBUG', 'APPEND_REF_PRE_OPTS', 'executing APPEND_REF_PRE_OPTS_FN('||P_DELIM_VALUES||', '||P_OPTS_QUERY||', '||P_PRI_KEY_VAL||')', V_RETURN_CODE);

    --parse the P_DELIM_VALUES string into an array so they can be processed
   l_selected := apex_util.string_to_table(P_DELIM_VALUES);


    --query for the primary key values using the P_OPTS_QUERY and the primary key value P_PRI_KEY_VAL and loop through the result set
    OPEN c FOR P_OPTS_QUERY USING P_PRI_KEY_VAL;
      LOOP

          --retrieve the primary key values into the V_OPT_PRI_KEY variable:
          FETCH c INTO V_OPT_PRI_KEY;
          EXIT WHEN c%NOTFOUND;

          --initialize the V_ID_FOUND boolean variable to indicate that a matching primary key value has not been found in the l_selected array:
          V_ID_FOUND := FALSE;


        --loop through the l_selected array to check if there is a match for the current result set primary key value
        for i in 1..l_selected.count loop

--            CEN_CRUISE.DB_LOG_PKG.ADD_LOG_ENTRY('DEBUG', 'APPEND_REF_PRE_OPTS', 'The current shuttle option is: '||l_selected(i), V_RETURN_CODE);

            --check if the current l_selected array element matches the current result set primary key value
            IF (l_selected(i) = V_OPT_PRI_KEY) THEN
              --the values match, update V_ID_FOUND to indicate that the match has been found
                V_ID_FOUND := TRUE;
            END IF;
        end loop;

        --check to see if a match has been found for the current result set primary key and the l_selected array elements
        IF NOT V_ID_FOUND THEN
          --a match has not been found, add the result set primary key value to the array:

--            CEN_CRUISE.DB_LOG_PKG.ADD_LOG_ENTRY('DEBUG', 'APPEND_REF_PRE_OPTS', 'None of the shuttle option values match the current option, add it to the l_selected array', V_RETURN_CODE);

            --add the ID to the list of selected values:
            l_selected(l_selected.count + 1) := V_OPT_PRI_KEY;
        END IF;


      END LOOP;
    CLOSE c;



     CEN_CRUISE.DB_LOG_PKG.ADD_LOG_ENTRY('DEBUG', 'APPEND_REF_PRE_OPTS', 'The return value is: '||apex_util.table_to_string(l_selected, ':'), V_RETURN_CODE);

     --convert the array to a colon-delimited string so it can be used directly in a shuttle field
     return apex_util.table_to_string(l_selected, ':');

  END APPEND_REF_PRE_OPTS_FN;



	end CRUISE_PKG;
	/







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
CCD_LEG_V.CRUISE_ID,
CCD_LEG_V.VESSEL_ID,
CCD_LEG_V.VESSEL_NAME,
CCD_LEG_V.VESSEL_DESC,
CCD_LEG_V.PLAT_TYPE_ID,
CCD_LEG_V.PLAT_TYPE_NAME,
CCD_LEG_V.PLAT_TYPE_DESC,
LEG_ECOSYSTEMS_DELIM.NUM_REG_ECOSYSTEMS,
LEG_ECOSYSTEMS_DELIM.REG_ECOSYSTEM_CD_LIST,
LEG_ECOSYSTEMS_DELIM.REG_ECOSYSTEM_SCD_LIST,
LEG_ECOSYSTEMS_DELIM.REG_ECOSYSTEM_RC_LIST,
LEG_ECOSYSTEMS_DELIM.REG_ECOSYSTEM_BR_LIST,
LEG_GEAR_DELIM.NUM_GEAR,
LEG_GEAR_DELIM.GEAR_NAME_CD_LIST,
LEG_GEAR_DELIM.GEAR_NAME_SCD_LIST,
LEG_GEAR_DELIM.GEAR_NAME_RC_LIST,
LEG_GEAR_DELIM.GEAR_NAME_BR_LIST,
LEG_REGION_DELIM.NUM_REGIONS,
LEG_REGION_DELIM.REGION_CODE_CD_LIST,
LEG_REGION_DELIM.REGION_CODE_SCD_LIST,
LEG_REGION_DELIM.REGION_CODE_RC_LIST,
LEG_REGION_DELIM.REGION_CODE_BR_LIST,
LEG_REGION_DELIM.REGION_NAME_CD_LIST,
LEG_REGION_DELIM.REGION_NAME_SCD_LIST,
LEG_REGION_DELIM.REGION_NAME_RC_LIST,
LEG_REGION_DELIM.REGION_NAME_BR_LIST,
LEG_ALIAS_DELIM.NUM_LEG_ALIASES,
LEG_ALIAS_DELIM.LEG_ALIAS_CD_LIST,
LEG_ALIAS_DELIM.LEG_ALIAS_SCD_LIST,
LEG_ALIAS_DELIM.LEG_ALIAS_RC_LIST,
LEG_ALIAS_DELIM.LEG_ALIAS_BR_LIST



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




ORDER BY LEG_START_DATE, LEG_NAME;




COMMENT ON COLUMN CCD_LEG_DELIM_V.CRUISE_LEG_ID IS 'Primary key for the CCD_CRUISE_LEGS table';
COMMENT ON COLUMN CCD_LEG_DELIM_V.LEG_NAME IS 'The name of the given cruise leg';
COMMENT ON COLUMN CCD_LEG_DELIM_V.LEG_START_DATE IS 'The start date for the given research cruise leg';
COMMENT ON COLUMN CCD_LEG_DELIM_V.FORMAT_LEG_START_DATE IS 'The start date for the given research cruise leg in MM/DD/YYYY format';
COMMENT ON COLUMN CCD_LEG_DELIM_V.LEG_END_DATE IS 'The end date for the given research cruise leg';
COMMENT ON COLUMN CCD_LEG_DELIM_V.FORMAT_LEG_END_DATE IS 'The end date for the given research cruise leg in MM/DD/YYYY format';
COMMENT ON COLUMN CCD_LEG_DELIM_V.LEG_DAS IS 'The number of days at sea for the given research cruise leg';

COMMENT ON COLUMN CCD_LEG_DELIM_V.LEG_YEAR IS 'The calendar year for the start date of the given research cruise leg';
COMMENT ON COLUMN CCD_LEG_DELIM_V.LEG_FISC_YEAR IS 'The NOAA fiscal year for the start date of the given research cruise leg';
COMMENT ON COLUMN CCD_LEG_DELIM_V.LEG_DESC IS 'The description for the given research cruise leg';
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



COMMENT ON TABLE CCD_LEG_DELIM_V IS 'Research Cruise Legs Delimited Reference Values (View)

This query returns all of the research cruise legs and their associated reference tables (e.g. Vessel, Platform Type, etc.) as well as the comma-/semicolon-delimited list of associated reference values (e.g. regional ecosystems, gear, regions, leg aliases, etc.)';




--redefine the cruises base view:

CREATE OR REPLACE VIEW CCD_CRUISE_V
AS SELECT CCD_CRUISES.CRUISE_ID,
  CCD_CRUISES.CRUISE_NAME,
  CCD_CRUISES.CRUISE_NOTES,
  CCD_SCI_CENTERS.SCI_CENTER_ID,
  CCD_SCI_CENTERS.SCI_CENTER_NAME,
  CCD_SCI_CENTERS.SCI_CENTER_DESC,
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

  CRUISE_LEG_AGG.NUM_LEGS,
  CRUISE_START_DATE,
  FORMAT_CRUISE_START_DATE,
  CRUISE_END_DATE,
  FORMAT_CRUISE_END_DATE,
  CRUISE_DAS,
  CRUISE_YEAR,
  CRUISE_FISC_YEAR,
  LEG_NAME_CD_LIST,
  LEG_NAME_SCD_LIST,
  LEG_NAME_RC_LIST,
  LEG_NAME_BR_LIST,
  LEG_NAME_DATES_CD_LIST,
  LEG_NAME_DATES_SCD_LIST,
  LEG_NAME_DATES_RC_LIST,
  LEG_NAME_DATES_BR_LIST



FROM CCD_CRUISES
LEFT JOIN CCD_SCI_CENTERS
ON CCD_SCI_CENTERS.SCI_CENTER_ID = CCD_CRUISES.SCI_CENTER_ID

LEFT JOIN CCD_STD_SVY_NAMES
ON CCD_STD_SVY_NAMES.STD_SVY_NAME_ID = CCD_CRUISES.STD_SVY_NAME_ID

LEFT JOIN CCD_SVY_FREQ
ON CCD_SVY_FREQ.SVY_FREQ_ID = CCD_CRUISES.SVY_FREQ_ID

LEFT JOIN CCD_SVY_TYPES
ON CCD_SVY_TYPES.SVY_TYPE_ID = CCD_CRUISES.SVY_TYPE_ID

LEFT JOIN
(
    SELECT
    CCD_LEG_V.cruise_id,
    count(*) NUM_LEGS,
    MIN (CCD_LEG_V.LEG_START_DATE) CRUISE_START_DATE,
    TO_CHAR(MIN (CCD_LEG_V.LEG_START_DATE), 'MM/DD/YYYY') FORMAT_CRUISE_START_DATE,
    MAX (CCD_LEG_V.LEG_END_DATE) CRUISE_END_DATE,
    TO_CHAR(MAX (CCD_LEG_V.LEG_END_DATE), 'MM/DD/YYYY') FORMAT_CRUISE_END_DATE,
    SUM(CCD_LEG_V.LEG_DAS) CRUISE_DAS,
    TO_CHAR(MIN (CCD_LEG_V.LEG_START_DATE), 'YYYY') CRUISE_YEAR,
    CEN_UTILS.CEN_UTIL_PKG.CALC_FISCAL_YEAR_FN(MIN (CCD_LEG_V.LEG_START_DATE)) CRUISE_FISC_YEAR,
    LISTAGG(CCD_LEG_V.LEG_NAME, ', ') WITHIN GROUP (ORDER BY CCD_LEG_V.LEG_START_DATE) as LEG_NAME_CD_LIST,
    LISTAGG(CCD_LEG_V.LEG_NAME, '; ') WITHIN GROUP (ORDER BY CCD_LEG_V.LEG_START_DATE) as LEG_NAME_SCD_LIST,
    LISTAGG(CCD_LEG_V.LEG_NAME, chr(10)) WITHIN GROUP (ORDER BY CCD_LEG_V.LEG_START_DATE) as LEG_NAME_RC_LIST,
    LISTAGG(CCD_LEG_V.LEG_NAME, '<BR>') WITHIN GROUP (ORDER BY CCD_LEG_V.LEG_START_DATE) as LEG_NAME_BR_LIST,
    LISTAGG(CCD_LEG_V.LEG_NAME || ' ('||TO_CHAR(CCD_LEG_V.LEG_START_DATE, 'MM/DD/YYYY')||' - '||TO_CHAR(CCD_LEG_V.LEG_END_DATE, 'MM/DD/YYYY')||' on '||CCD_LEG_V.VESSEL_NAME||')', ', ') WITHIN GROUP (ORDER BY CCD_LEG_V.LEG_START_DATE) as LEG_NAME_DATES_CD_LIST,
    LISTAGG(CCD_LEG_V.LEG_NAME || ' ('||TO_CHAR(CCD_LEG_V.LEG_START_DATE, 'MM/DD/YYYY')||' - '||TO_CHAR(CCD_LEG_V.LEG_END_DATE, 'MM/DD/YYYY')||' on '||CCD_LEG_V.VESSEL_NAME||')', ', ') WITHIN GROUP (ORDER BY CCD_LEG_V.LEG_START_DATE) as LEG_NAME_DATES_SCD_LIST,
    LISTAGG(CCD_LEG_V.LEG_NAME || ' ('||TO_CHAR(CCD_LEG_V.LEG_START_DATE, 'MM/DD/YYYY')||' - '||TO_CHAR(CCD_LEG_V.LEG_END_DATE, 'MM/DD/YYYY')||' on '||CCD_LEG_V.VESSEL_NAME||')', chr(10)) WITHIN GROUP (ORDER BY CCD_LEG_V.LEG_START_DATE) as LEG_NAME_DATES_RC_LIST,
    LISTAGG(CCD_LEG_V.LEG_NAME || ' ('||TO_CHAR(CCD_LEG_V.LEG_START_DATE, 'MM/DD/YYYY')||' - '||TO_CHAR(CCD_LEG_V.LEG_END_DATE, 'MM/DD/YYYY')||' on '||CCD_LEG_V.VESSEL_NAME||')', '<BR>') WITHIN GROUP (ORDER BY CCD_LEG_V.LEG_START_DATE) as LEG_NAME_DATES_BR_LIST

    FROM
    CCD_LEG_V
    group by
    CCD_LEG_V.cruise_id
)
CRUISE_LEG_AGG
ON CRUISE_LEG_AGG.CRUISE_ID = CCD_CRUISES.CRUISE_ID

ORDER BY CCD_SCI_CENTERS.SCI_CENTER_NAME,
CCD_STD_SVY_NAMES.STD_SVY_NAME,
CCD_CRUISES.CRUISE_NAME
;

COMMENT ON TABLE CCD_CRUISE_V IS 'Research Cruises (View)

This query returns all of the research cruises and their associated reference tables (e.g. Science Center, standard survey name, survey frequency, etc.) as well as aggregate information from the associated cruise legs';


COMMENT ON COLUMN CCD_CRUISE_V.CRUISE_ID IS 'Primary key for the CCD_CRUISES table';
COMMENT ON COLUMN CCD_CRUISE_V.CRUISE_NAME IS 'The name of the given cruise designated by NOAA (e.g. SE-15-01)';
COMMENT ON COLUMN CCD_CRUISE_V.CRUISE_NOTES IS 'Any notes for the given research cruise';
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
COMMENT ON COLUMN CCD_CRUISE_V.STD_SVY_NAME_VAL IS 'This field contains the Standard Survey Name defined for the given cruise.  If the STD_SVY_NAME_ID field is defined then the associated CCD_STD_SVY_NAMES.STD_SVY_NAME is used because the foreign key is given precedence, otherwise the STD_SVY_NAME_OTH field value is used';


COMMENT ON COLUMN CCD_CRUISE_V.SVY_TYPE_ID IS 'Primary key for the Survey Type table';
COMMENT ON COLUMN CCD_CRUISE_V.SVY_TYPE_NAME IS 'Name of the given Survey Type';
COMMENT ON COLUMN CCD_CRUISE_V.SVY_TYPE_DESC IS 'Description for the given Survey Type';


COMMENT ON COLUMN CCD_CRUISE_V.CRUISE_URL IS 'The Cruise URL (Referred to as "Survey URL" in FINSS System) for the given Cruise';
COMMENT ON COLUMN CCD_CRUISE_V.CRUISE_CONT_EMAIL IS 'The Cruise Contact Email (Referred to as "Survey Contact Email" in FINSS System) for the given Cruise';



COMMENT ON COLUMN CCD_CRUISE_V.CRUISE_START_DATE IS 'The start date for the given cruise (based on the earliest associated cruise leg''s start date)';
COMMENT ON COLUMN CCD_CRUISE_V.FORMAT_CRUISE_START_DATE IS 'The formatted start date for the given cruise (based on the earliest associated cruise leg''s start date) in MM/DD/YYYY format';
COMMENT ON COLUMN CCD_CRUISE_V.CRUISE_END_DATE IS 'The end date for the given cruise (based on the latest associated cruise leg''s end date)';
COMMENT ON COLUMN CCD_CRUISE_V.FORMAT_CRUISE_END_DATE IS 'The formatted end date for the given cruise (based on the latest associated cruise leg''s end date) in MM/DD/YYYY format';
COMMENT ON COLUMN CCD_CRUISE_V.CRUISE_DAS IS 'The total number of days at sea for each of the legs associated with the given cruise';


COMMENT ON COLUMN CCD_CRUISE_V.CRUISE_YEAR IS 'The calendar year for the given cruise (based on the earliest associated cruise leg''s start date)';
COMMENT ON COLUMN CCD_CRUISE_V.CRUISE_FISC_YEAR IS 'The calendar year for the given cruise (based on the earliest associated cruise leg''s start date)';
COMMENT ON COLUMN CCD_CRUISE_V.NUM_LEGS IS 'The number of cruise legs associated with the given cruise';
COMMENT ON COLUMN CCD_CRUISE_V.LEG_NAME_CD_LIST IS 'Comma-delimited list of leg names associated with the given cruise';
COMMENT ON COLUMN CCD_CRUISE_V.LEG_NAME_SCD_LIST IS 'Semicolon-delimited list of leg names associated with the given cruise';
COMMENT ON COLUMN CCD_CRUISE_V.LEG_NAME_RC_LIST IS 'Return carriage/new line delimited list of leg names associated with the given cruise';
COMMENT ON COLUMN CCD_CRUISE_V.LEG_NAME_BR_LIST IS '<BR> tag (intended for web pages) delimited list of leg names associated with the given cruise';


COMMENT ON COLUMN CCD_CRUISE_V.LEG_NAME_DATES_CD_LIST IS 'Comma-delimited list of leg names, the associated leg dates and vessel name associated with the given cruise';
COMMENT ON COLUMN CCD_CRUISE_V.LEG_NAME_DATES_SCD_LIST IS 'Semicolon-delimited list of leg names, the associated leg dates and vessel name associated with the given cruise';
COMMENT ON COLUMN CCD_CRUISE_V.LEG_NAME_DATES_RC_LIST IS 'Return carriage/new line delimited list of leg names, the associated leg dates and vessel name associated with the given cruise';
COMMENT ON COLUMN CCD_CRUISE_V.LEG_NAME_DATES_BR_LIST IS '<BR> tag (intended for web pages) delimited list of leg names, the associated leg dates and vessel name associated with the given cruise';






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
COMMENT ON COLUMN CCD_CRUISE_LEGS_V.LEG_START_DATE IS 'The start date for the given research cruise leg';
COMMENT ON COLUMN CCD_CRUISE_LEGS_V.FORMAT_LEG_START_DATE IS 'The start date for the given research cruise leg in MM/DD/YYYY format';
COMMENT ON COLUMN CCD_CRUISE_LEGS_V.LEG_END_DATE IS 'The end date for the given research cruise leg';
COMMENT ON COLUMN CCD_CRUISE_LEGS_V.FORMAT_LEG_END_DATE IS 'The end date for the given research cruise leg in MM/DD/YYYY format';

COMMENT ON COLUMN CCD_CRUISE_LEGS_V.LEG_DAS IS 'The number of days at sea for the given research cruise leg';
COMMENT ON COLUMN CCD_CRUISE_LEGS_V.LEG_YEAR IS 'The calendar year for the start date of the given research cruise leg';
COMMENT ON COLUMN CCD_CRUISE_LEGS_V.LEG_FISC_YEAR IS 'The NOAA fiscal year for the start date of the given research cruise leg';
COMMENT ON COLUMN CCD_CRUISE_LEGS_V.LEG_DESC IS 'The description for the given research cruise leg';
COMMENT ON COLUMN CCD_CRUISE_LEGS_V.VESSEL_ID IS 'Foreign key reference to the CCD_VESSELS table for the cruise leg''s vessel';
COMMENT ON COLUMN CCD_CRUISE_LEGS_V.VESSEL_NAME IS 'Name of the given research vessel';
COMMENT ON COLUMN CCD_CRUISE_LEGS_V.VESSEL_DESC IS 'Description for the given research vessel';
COMMENT ON COLUMN CCD_CRUISE_LEGS_V.PLAT_TYPE_ID IS 'Platform Type for the given research cruise leg';
COMMENT ON COLUMN CCD_CRUISE_LEGS_V.PLAT_TYPE_NAME IS 'Name of the given Platform Type';
COMMENT ON COLUMN CCD_CRUISE_LEGS_V.PLAT_TYPE_DESC IS 'Description for the given Platform Type';


COMMENT ON COLUMN CCD_CRUISE_LEGS_V.CRUISE_START_DATE IS 'The start date for the given cruise (based on the earliest associated cruise leg''s start date)';
COMMENT ON COLUMN CCD_CRUISE_LEGS_V.FORMAT_CRUISE_START_DATE IS 'The formatted start date for the given cruise (based on the earliest associated cruise leg''s start date) in MM/DD/YYYY HH24:MI:SS format';
COMMENT ON COLUMN CCD_CRUISE_LEGS_V.CRUISE_END_DATE IS 'The end date for the given cruise (based on the latest associated cruise leg''s end date)';
COMMENT ON COLUMN CCD_CRUISE_LEGS_V.FORMAT_CRUISE_END_DATE IS 'The formatted end date for the given cruise (based on the latest associated cruise leg''s end date) in MM/DD/YYYY HH24:MI:SS format';
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






--cruises and associated comma/semicolon delimited list of values
CREATE OR REPLACE VIEW

CCD_CRUISE_DELIM_V
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



ESA_SPECIES_DELIM.NUM_SPP_ESA,
ESA_SPECIES_DELIM.SPP_ESA_NAME_CD_LIST,
ESA_SPECIES_DELIM.SPP_ESA_NAME_SCD_LIST,
ESA_SPECIES_DELIM.SPP_ESA_NAME_RC_LIST,
ESA_SPECIES_DELIM.SPP_ESA_NAME_BR_LIST,


FSSI_SPECIES_DELIM.NUM_SPP_FSSI,
FSSI_SPECIES_DELIM.SPP_FSSI_NAME_CD_LIST,
FSSI_SPECIES_DELIM.SPP_FSSI_NAME_SCD_LIST,
FSSI_SPECIES_DELIM.SPP_FSSI_NAME_RC_LIST,
FSSI_SPECIES_DELIM.SPP_FSSI_NAME_BR_LIST,

MMPA_SPECIES_DELIM.NUM_SPP_MMPA,
MMPA_SPECIES_DELIM.SPP_MMPA_NAME_CD_LIST,
MMPA_SPECIES_DELIM.SPP_MMPA_NAME_SCD_LIST,
MMPA_SPECIES_DELIM.SPP_MMPA_NAME_RC_LIST,
MMPA_SPECIES_DELIM.SPP_MMPA_NAME_BR_LIST,

SVY_PRIM_CATS_DELIM.NUM_PRIM_SVY_CATS,
SVY_PRIM_CATS_DELIM.SVY_CAT_NAME_CD_LIST PRIM_SVY_CAT_NAME_CD_LIST,
SVY_PRIM_CATS_DELIM.SVY_CAT_NAME_SCD_LIST PRIM_SVY_CAT_NAME_SCD_LIST,
SVY_PRIM_CATS_DELIM.SVY_CAT_NAME_RC_LIST PRIM_SVY_CAT_NAME_RC_LIST,
SVY_PRIM_CATS_DELIM.SVY_CAT_NAME_BR_LIST PRIM_SVY_CAT_NAME_BR_LIST,

SVY_SEC_CATS_DELIM.NUM_SEC_SVY_CATS,
SVY_SEC_CATS_DELIM.SVY_CAT_NAME_CD_LIST SEC_SVY_CAT_NAME_CD_LIST,
SVY_SEC_CATS_DELIM.SVY_CAT_NAME_SCD_LIST SEC_SVY_CAT_NAME_SCD_LIST,
SVY_SEC_CATS_DELIM.SVY_CAT_NAME_RC_LIST SEC_SVY_CAT_NAME_RC_LIST,
SVY_SEC_CATS_DELIM.SVY_CAT_NAME_BR_LIST SEC_SVY_CAT_NAME_BR_LIST,

EXP_SPECIES_DELIM.NUM_EXP_SPP,
EXP_SPECIES_DELIM.EXP_SPP_NAME_CD_LIST,
EXP_SPECIES_DELIM.EXP_SPP_NAME_SCD_LIST,
EXP_SPECIES_DELIM.EXP_SPP_NAME_RC_LIST,
EXP_SPECIES_DELIM.EXP_SPP_NAME_BR_LIST,

OTH_SPECIES_DELIM.NUM_SPP_OTH,
OTH_SPECIES_DELIM.OTH_SPP_CNAME_CD_LIST,
OTH_SPECIES_DELIM.OTH_SPP_CNAME_SCD_LIST,
OTH_SPECIES_DELIM.OTH_SPP_CNAME_RC_LIST,
OTH_SPECIES_DELIM.OTH_SPP_CNAME_BR_LIST,

OTH_SPECIES_DELIM.OTH_SPP_SNAME_CD_LIST,
OTH_SPECIES_DELIM.OTH_SPP_SNAME_SCD_LIST,
OTH_SPECIES_DELIM.OTH_SPP_SNAME_RC_LIST,
OTH_SPECIES_DELIM.OTH_SPP_SNAME_BR_LIST

FROM
CCD_CRUISE_V
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
ON CCD_CRUISE_V.CRUISE_ID = ESA_SPECIES_DELIM.CRUISE_ID

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
ON CCD_CRUISE_V.CRUISE_ID = FSSI_SPECIES_DELIM.CRUISE_ID


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
ON CCD_CRUISE_V.CRUISE_ID = MMPA_SPECIES_DELIM.CRUISE_ID


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
ON CCD_CRUISE_V.CRUISE_ID = SVY_PRIM_CATS_DELIM.CRUISE_ID


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
ON CCD_CRUISE_V.CRUISE_ID = SVY_SEC_CATS_DELIM.CRUISE_ID


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
ON CCD_CRUISE_V.CRUISE_ID = EXP_SPECIES_DELIM.CRUISE_ID



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
ON CCD_CRUISE_V.CRUISE_ID = OTH_SPECIES_DELIM.CRUISE_ID



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
COMMENT ON COLUMN CCD_CRUISE_DELIM_V.STD_SVY_NAME_VAL IS 'This field contains the Standard Survey Name defined for the given cruise.  If the STD_SVY_NAME_ID field is defined then the associated CCD_STD_SVY_NAMES.STD_SVY_NAME is used because the foreign key is given precedence, otherwise the STD_SVY_NAME_OTH field value is used';

COMMENT ON COLUMN CCD_CRUISE_DELIM_V.SVY_TYPE_ID IS 'Primary key for the Survey Type table';
COMMENT ON COLUMN CCD_CRUISE_DELIM_V.SVY_TYPE_NAME IS 'Name of the given Survey Type';
COMMENT ON COLUMN CCD_CRUISE_DELIM_V.SVY_TYPE_DESC IS 'Description for the given Survey Type';


COMMENT ON COLUMN CCD_CRUISE_DELIM_V.CRUISE_URL IS 'The Cruise URL (Referred to as "Survey URL" in FINSS System) for the given Cruise';
COMMENT ON COLUMN CCD_CRUISE_DELIM_V.CRUISE_CONT_EMAIL IS 'The Cruise Contact Email (Referred to as "Survey Contact Email" in FINSS System) for the given Cruise';


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



COMMENT ON COLUMN CCD_CRUISE_DELIM_V.CRUISE_START_DATE IS 'The start date for the given cruise (based on the earliest associated cruise leg''s start date)';
COMMENT ON COLUMN CCD_CRUISE_DELIM_V.FORMAT_CRUISE_START_DATE IS 'The formatted start date for the given cruise (based on the earliest associated cruise leg''s start date) in MM/DD/YYYY HH24:MI:SS format';
COMMENT ON COLUMN CCD_CRUISE_DELIM_V.CRUISE_END_DATE IS 'The end date for the given cruise (based on the latest associated cruise leg''s end date)';
COMMENT ON COLUMN CCD_CRUISE_DELIM_V.FORMAT_CRUISE_END_DATE IS 'The formatted end date for the given cruise (based on the latest associated cruise leg''s end date) in MM/DD/YYYY HH24:MI:SS format';
COMMENT ON COLUMN CCD_CRUISE_DELIM_V.CRUISE_DAS IS 'The total number of days at sea for each of the legs associated with the given cruise';


COMMENT ON COLUMN CCD_CRUISE_DELIM_V.CRUISE_YEAR IS 'The calendar year for the given cruise (based on the earliest associated cruise leg''s start date)';
COMMENT ON COLUMN CCD_CRUISE_DELIM_V.CRUISE_FISC_YEAR IS 'The calendar year for the given cruise (based on the earliest associated cruise leg''s start date)';
COMMENT ON COLUMN CCD_CRUISE_DELIM_V.NUM_LEGS IS 'The number of cruise legs associated with the given cruise';
COMMENT ON COLUMN CCD_CRUISE_DELIM_V.LEG_NAME_CD_LIST IS 'Comma-delimited list of leg names associated with the given cruise';
COMMENT ON COLUMN CCD_CRUISE_DELIM_V.LEG_NAME_SCD_LIST IS 'Semicolon-delimited list of leg names associated with the given cruise';
COMMENT ON COLUMN CCD_CRUISE_DELIM_V.LEG_NAME_RC_LIST IS 'Return carriage/new line delimited list of leg names associated with the given cruise';
COMMENT ON COLUMN CCD_CRUISE_DELIM_V.LEG_NAME_BR_LIST IS '<BR> tag (intended for web pages) delimited list of leg names associated with the given cruise';


COMMENT ON COLUMN CCD_CRUISE_DELIM_V.LEG_NAME_DATES_CD_LIST IS 'Comma-delimited list of leg names, the associated leg dates and vessel name associated with the given cruise';
COMMENT ON COLUMN CCD_CRUISE_DELIM_V.LEG_NAME_DATES_SCD_LIST IS 'Semicolon-delimited list of leg names, the associated leg dates and vessel name associated with the given cruise';
COMMENT ON COLUMN CCD_CRUISE_DELIM_V.LEG_NAME_DATES_RC_LIST IS 'Return carriage/new line delimited list of leg names, the associated leg dates and vessel name associated with the given cruise';
COMMENT ON COLUMN CCD_CRUISE_DELIM_V.LEG_NAME_DATES_BR_LIST IS '<BR> tag (intended for web pages) delimited list of leg names, the associated leg dates and vessel name associated with the given cruise';













CREATE OR REPLACE VIEW CCD_CRUISE_SUMM_V
AS SELECT



CCD_CRUISE_DELIM_V.CRUISE_ID,
CCD_CRUISE_DELIM_V.CRUISE_NAME,
CCD_CRUISE_DELIM_V.CRUISE_NOTES,
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


CCD_CRUISE_DELIM_V.CRUISE_START_DATE,
CCD_CRUISE_DELIM_V.FORMAT_CRUISE_START_DATE,
CCD_CRUISE_DELIM_V.CRUISE_END_DATE,
CCD_CRUISE_DELIM_V.FORMAT_CRUISE_END_DATE,

CCD_CRUISE_DELIM_V.CRUISE_DAS,

CCD_CRUISE_DELIM_V.CRUISE_YEAR,
CCD_CRUISE_DELIM_V.CRUISE_FISC_YEAR,
CCD_CRUISE_DELIM_V.NUM_LEGS,
CCD_CRUISE_DELIM_V.LEG_NAME_CD_LIST,
CCD_CRUISE_DELIM_V.LEG_NAME_SCD_LIST,
CCD_CRUISE_DELIM_V.LEG_NAME_RC_LIST,
CCD_CRUISE_DELIM_V.LEG_NAME_BR_LIST,

CCD_CRUISE_DELIM_V.LEG_NAME_DATES_CD_LIST,
CCD_CRUISE_DELIM_V.LEG_NAME_DATES_SCD_LIST,
CCD_CRUISE_DELIM_V.LEG_NAME_DATES_RC_LIST,
CCD_CRUISE_DELIM_V.LEG_NAME_DATES_BR_LIST,





CRUISE_REGIONS.NUM_REGIONS,
CRUISE_REGIONS.REGION_CODE_CD_LIST,
CRUISE_REGIONS.REGION_CODE_SCD_LIST,
CRUISE_REGIONS.REGION_CODE_RC_LIST,
CRUISE_REGIONS.REGION_CODE_BR_LIST,

CRUISE_REGIONS.REGION_NAME_CD_LIST,
CRUISE_REGIONS.REGION_NAME_SCD_LIST,
CRUISE_REGIONS.REGION_NAME_RC_LIST,
CRUISE_REGIONS.REGION_NAME_BR_LIST,

CRUISE_ECOSYSTEMS.NUM_ECOSYSTEMS,
CRUISE_ECOSYSTEMS.ECOSYSTEM_CD_LIST,
CRUISE_ECOSYSTEMS.ECOSYSTEM_SCD_LIST,
CRUISE_ECOSYSTEMS.ECOSYSTEM_RC_LIST,
CRUISE_ECOSYSTEMS.ECOSYSTEM_BR_LIST,

CRUISE_GEARS.NUM_GEAR,
CRUISE_GEARS.GEAR_CD_LIST,
CRUISE_GEARS.GEAR_SCD_LIST,
CRUISE_GEARS.GEAR_RC_LIST,
CRUISE_GEARS.GEAR_BR_LIST

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
on CRUISE_REGIONS.cruise_id = CCD_CRUISE_DELIM_V.cruise_id



--retrieve the unique regional ecosystems for all associated cruise legs:
left join
(SELECT
CRUISE_ID,
LISTAGG(DIST_REG_ECOSYSTEMS.REG_ECOSYSTEM_NAME, ', ') WITHIN GROUP (ORDER BY UPPER(DIST_REG_ECOSYSTEMS.REG_ECOSYSTEM_NAME)) as ECOSYSTEM_CD_LIST,
LISTAGG(DIST_REG_ECOSYSTEMS.REG_ECOSYSTEM_NAME, '; ') WITHIN GROUP (ORDER BY UPPER(DIST_REG_ECOSYSTEMS.REG_ECOSYSTEM_NAME)) as ECOSYSTEM_SCD_LIST,
LISTAGG(DIST_REG_ECOSYSTEMS.REG_ECOSYSTEM_NAME, chr(10)) WITHIN GROUP (ORDER BY UPPER(DIST_REG_ECOSYSTEMS.REG_ECOSYSTEM_NAME)) as ECOSYSTEM_RC_LIST,
LISTAGG(DIST_REG_ECOSYSTEMS.REG_ECOSYSTEM_NAME, '<BR>') WITHIN GROUP (ORDER BY UPPER(DIST_REG_ECOSYSTEMS.REG_ECOSYSTEM_NAME)) as ECOSYSTEM_BR_LIST,
count(*) NUM_ECOSYSTEMS

FROM

(SELECT
DISTINCT
cruise_id,
REG_ECOSYSTEM_NAME
from
CCD_CRUISE_LEGS
INNER JOIN CCD_LEG_ECOSYSTEMS
ON CCD_CRUISE_LEGS.CRUISE_LEG_ID = CCD_LEG_ECOSYSTEMS.CRUISE_LEG_ID
INNER JOIN CCD_REG_ECOSYSTEMS
ON CCD_REG_ECOSYSTEMS.REG_ECOSYSTEM_ID = CCD_LEG_ECOSYSTEMS.REG_ECOSYSTEM_ID) DIST_REG_ECOSYSTEMS
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
count(*) NUM_GEAR

FROM

(SELECT
DISTINCT
cruise_id,
GEAR_NAME
from
CCD_CRUISE_LEGS
INNER JOIN CCD_LEG_GEAR
ON CCD_CRUISE_LEGS.CRUISE_LEG_ID = CCD_LEG_GEAR.CRUISE_LEG_ID
INNER JOIN CCD_GEAR
ON CCD_GEAR.GEAR_ID = CCD_LEG_GEAR.GEAR_ID) DIST_LEG_GEARS
group by DIST_LEG_GEARS.cruise_id) CRUISE_GEARS
on CRUISE_GEARS.cruise_id = CCD_CRUISE_DELIM_V.cruise_id

group by
CCD_CRUISE_DELIM_V.CRUISE_ID,
CCD_CRUISE_DELIM_V.CRUISE_NAME,
CCD_CRUISE_DELIM_V.CRUISE_NOTES,
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


CCD_CRUISE_DELIM_V.CRUISE_START_DATE,
CCD_CRUISE_DELIM_V.FORMAT_CRUISE_START_DATE,
CCD_CRUISE_DELIM_V.CRUISE_END_DATE,
CCD_CRUISE_DELIM_V.FORMAT_CRUISE_END_DATE,

CCD_CRUISE_DELIM_V.CRUISE_DAS,

CCD_CRUISE_DELIM_V.CRUISE_YEAR,
CCD_CRUISE_DELIM_V.CRUISE_FISC_YEAR,
CCD_CRUISE_DELIM_V.NUM_LEGS,
CCD_CRUISE_DELIM_V.LEG_NAME_CD_LIST,
CCD_CRUISE_DELIM_V.LEG_NAME_SCD_LIST,
CCD_CRUISE_DELIM_V.LEG_NAME_RC_LIST,
CCD_CRUISE_DELIM_V.LEG_NAME_BR_LIST,

CCD_CRUISE_DELIM_V.LEG_NAME_DATES_CD_LIST,
CCD_CRUISE_DELIM_V.LEG_NAME_DATES_SCD_LIST,
CCD_CRUISE_DELIM_V.LEG_NAME_DATES_RC_LIST,
CCD_CRUISE_DELIM_V.LEG_NAME_DATES_BR_LIST,





CRUISE_REGIONS.NUM_REGIONS,
CRUISE_REGIONS.REGION_CODE_CD_LIST,
CRUISE_REGIONS.REGION_CODE_SCD_LIST,
CRUISE_REGIONS.REGION_CODE_RC_LIST,
CRUISE_REGIONS.REGION_CODE_BR_LIST,

CRUISE_REGIONS.REGION_NAME_CD_LIST,
CRUISE_REGIONS.REGION_NAME_SCD_LIST,
CRUISE_REGIONS.REGION_NAME_RC_LIST,
CRUISE_REGIONS.REGION_NAME_BR_LIST,

CRUISE_ECOSYSTEMS.NUM_ECOSYSTEMS,
CRUISE_ECOSYSTEMS.ECOSYSTEM_CD_LIST,
CRUISE_ECOSYSTEMS.ECOSYSTEM_SCD_LIST,
CRUISE_ECOSYSTEMS.ECOSYSTEM_RC_LIST,
CRUISE_ECOSYSTEMS.ECOSYSTEM_BR_LIST,

CRUISE_GEARS.NUM_GEAR,
CRUISE_GEARS.GEAR_CD_LIST,
CRUISE_GEARS.GEAR_SCD_LIST,
CRUISE_GEARS.GEAR_RC_LIST,
CRUISE_GEARS.GEAR_BR_LIST

order by
CCD_CRUISE_DELIM_V.CRUISE_START_DATE,
CCD_CRUISE_DELIM_V.CRUISE_NAME
;





COMMENT ON TABLE CCD_CRUISE_SUMM_V IS 'Research Cruise Leg Summary (View)

This query returns all of the research cruises and all associated comma-/semicolon-delimited list of associated reference values.  The aggregate cruise leg information is included as start and end dates and the number of legs defined for the given cruise (if any) as well as all associated comma-/semicolon-delimited unique list of associated reference values (regional ecosystems, gear, regions)';


COMMENT ON COLUMN CCD_CRUISE_SUMM_V.CRUISE_ID IS 'Primary key for the CCD_CRUISES table';
COMMENT ON COLUMN CCD_CRUISE_SUMM_V.CRUISE_NAME IS 'The name of the given cruise designated by NOAA (e.g. SE-15-01)';
COMMENT ON COLUMN CCD_CRUISE_SUMM_V.CRUISE_NOTES IS 'Any notes for the given research cruise';
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
COMMENT ON COLUMN CCD_CRUISE_SUMM_V.STD_SVY_NAME_VAL IS 'This field contains the Standard Survey Name defined for the given cruise.  If the STD_SVY_NAME_ID field is defined then the associated CCD_STD_SVY_NAMES.STD_SVY_NAME is used because the foreign key is given precedence, otherwise the STD_SVY_NAME_OTH field value is used';


COMMENT ON COLUMN CCD_CRUISE_SUMM_V.SVY_TYPE_ID IS 'Primary key for the Survey Type table';
COMMENT ON COLUMN CCD_CRUISE_SUMM_V.SVY_TYPE_NAME IS 'Name of the given Survey Type';
COMMENT ON COLUMN CCD_CRUISE_SUMM_V.SVY_TYPE_DESC IS 'Description for the given Survey Type';


COMMENT ON COLUMN CCD_CRUISE_SUMM_V.CRUISE_URL IS 'The Cruise URL (Referred to as "Survey URL" in FINSS System) for the given Cruise';
COMMENT ON COLUMN CCD_CRUISE_SUMM_V.CRUISE_CONT_EMAIL IS 'The Cruise Contact Email (Referred to as "Survey Contact Email" in FINSS System) for the given Cruise';



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



COMMENT ON COLUMN CCD_CRUISE_SUMM_V.CRUISE_START_DATE IS 'The start date for the given cruise (based on the earliest associated cruise leg''s start date)';
COMMENT ON COLUMN CCD_CRUISE_SUMM_V.FORMAT_CRUISE_START_DATE IS 'The formatted start date for the given cruise (based on the earliest associated cruise leg''s start date) in MM/DD/YYYY HH24:MI:SS format';
COMMENT ON COLUMN CCD_CRUISE_SUMM_V.CRUISE_END_DATE IS 'The end date for the given cruise (based on the latest associated cruise leg''s end date)';
COMMENT ON COLUMN CCD_CRUISE_SUMM_V.FORMAT_CRUISE_END_DATE IS 'The formatted end date for the given cruise (based on the latest associated cruise leg''s end date) in MM/DD/YYYY HH24:MI:SS format';

COMMENT ON COLUMN CCD_CRUISE_SUMM_V.CRUISE_DAS IS 'The total number of days at sea for each of the legs associated with the given cruise';

COMMENT ON COLUMN CCD_CRUISE_SUMM_V.CRUISE_YEAR IS 'The calendar year for the given cruise (based on the earliest associated cruise leg''s start date)';
COMMENT ON COLUMN CCD_CRUISE_SUMM_V.CRUISE_FISC_YEAR IS 'The calendar year for the given cruise (based on the earliest associated cruise leg''s start date)';
COMMENT ON COLUMN CCD_CRUISE_SUMM_V.NUM_LEGS IS 'The number of cruise legs associated with the given cruise';
COMMENT ON COLUMN CCD_CRUISE_SUMM_V.LEG_NAME_CD_LIST IS 'Comma-delimited list of leg names associated with the given cruise';
COMMENT ON COLUMN CCD_CRUISE_SUMM_V.LEG_NAME_SCD_LIST IS 'Semicolon-delimited list of leg names associated with the given cruise';
COMMENT ON COLUMN CCD_CRUISE_SUMM_V.LEG_NAME_RC_LIST IS 'Return carriage/new line delimited list of leg names associated with the given cruise';
COMMENT ON COLUMN CCD_CRUISE_SUMM_V.LEG_NAME_BR_LIST IS '<BR> tag (intended for web pages) delimited list of leg names associated with the given cruise';

COMMENT ON COLUMN CCD_CRUISE_SUMM_V.LEG_NAME_DATES_CD_LIST IS 'Comma-delimited list of leg names, the associated leg dates and vessel name associated with the given cruise';
COMMENT ON COLUMN CCD_CRUISE_SUMM_V.LEG_NAME_DATES_SCD_LIST IS 'Semicolon-delimited list of leg names, the associated leg dates and vessel name associated with the given cruise';
COMMENT ON COLUMN CCD_CRUISE_SUMM_V.LEG_NAME_DATES_RC_LIST IS 'Return carriage/new line delimited list of leg names, the associated leg dates and vessel name associated with the given cruise';
COMMENT ON COLUMN CCD_CRUISE_SUMM_V.LEG_NAME_DATES_BR_LIST IS '<BR> tag (intended for web pages) delimited list of leg names, the associated leg dates and vessel name associated with the given cruise';



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












create or replace view
CCD_CRUISE_LEG_DELIM_V

AS
select
CCD_CRUISE_DELIM_V.CRUISE_ID,
CCD_CRUISE_DELIM_V.CRUISE_NAME,
CCD_CRUISE_DELIM_V.CRUISE_NOTES,
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


CCD_CRUISE_DELIM_V.NUM_LEGS,
CCD_CRUISE_DELIM_V.CRUISE_START_DATE,
CCD_CRUISE_DELIM_V.FORMAT_CRUISE_START_DATE,
CCD_CRUISE_DELIM_V.CRUISE_END_DATE,
CCD_CRUISE_DELIM_V.FORMAT_CRUISE_END_DATE,
CCD_CRUISE_DELIM_V.CRUISE_DAS,


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
CCD_LEG_DELIM_V.LEG_ALIAS_BR_LIST
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


COMMENT ON TABLE CCD_CRUISE_LEG_DELIM_V IS 'Research Cruises and Associated Legs with Delimited Reference Values (View)

This query returns all of the research cruises and their associated reference tables (e.g. Science Center, standard survey name, survey frequency, etc.) as well as the comma-/semicolon-delimited list of associated reference values (e.g. ESA species, primary survey categories, etc.) as well as all associated research cruise legs and their associated reference tables (e.g. Vessel, Platform Type, etc.) as well as the comma-/semicolon-delimited list of associated reference values (e.g. regional ecosystems, gear, regions, leg aliases, etc.)';



--create the view to return the delimited values for each of the preset tables:

--regional ecosystem preset delimited view
create or replace view
CCD_REG_ECO_PRE_DELIM_V
AS
select
REG_ECO_PRE_ID,
REG_ECO_PRE_NAME,
REG_ECO_PRE_DESC,
LISTAGG(REG_ECOSYSTEM_NAME, ', ') WITHIN GROUP (ORDER BY UPPER(REG_ECOSYSTEM_NAME)) as REG_ECOSYSTEM_CD_LIST,
LISTAGG(REG_ECOSYSTEM_NAME, '; ') WITHIN GROUP (ORDER BY UPPER(REG_ECOSYSTEM_NAME)) as REG_ECOSYSTEM_SCD_LIST,
LISTAGG(REG_ECOSYSTEM_NAME, chr(10)) WITHIN GROUP (ORDER BY UPPER(REG_ECOSYSTEM_NAME)) as REG_ECOSYSTEM_RC_LIST,
LISTAGG(REG_ECOSYSTEM_NAME, '<BR>') WITHIN GROUP (ORDER BY UPPER(REG_ECOSYSTEM_NAME)) as REG_ECOSYSTEM_BR_LIST

from

CCD_REG_ECO_PRE_V
group by
REG_ECO_PRE_ID,
REG_ECO_PRE_NAME,
REG_ECO_PRE_DESC

order by
REG_ECO_PRE_NAME,
REG_ECO_PRE_DESC;


comment on table CCD_REG_ECO_PRE_DELIM_V IS 'Regional Ecosystem Preset Delimited Options (View)

This view returns all regional ecosystem presets and delimited lists of associated regional ecosystem names';

COMMENT ON COLUMN CCD_REG_ECO_PRE_DELIM_V.REG_ECO_PRE_ID IS 'Primary key for the Regional Ecosystem Preset table';
COMMENT ON COLUMN CCD_REG_ECO_PRE_DELIM_V.REG_ECO_PRE_NAME IS 'Name of the given Regional Ecosystem Preset';
COMMENT ON COLUMN CCD_REG_ECO_PRE_DELIM_V.REG_ECO_PRE_DESC IS 'Description for the given Regional Ecosystem Preset';
COMMENT ON COLUMN CCD_REG_ECO_PRE_DELIM_V.REG_ECOSYSTEM_CD_LIST IS 'Comma-delimited list of regional ecosystems associated with the given preset';
COMMENT ON COLUMN CCD_REG_ECO_PRE_DELIM_V.REG_ECOSYSTEM_SCD_LIST IS 'Semicolon-delimited list of regional ecosystems associated with the given preset';
COMMENT ON COLUMN CCD_REG_ECO_PRE_DELIM_V.REG_ECOSYSTEM_RC_LIST IS 'Return carriage/new line delimited list of regional ecosystems associated with the given preset';
COMMENT ON COLUMN CCD_REG_ECO_PRE_DELIM_V.REG_ECOSYSTEM_BR_LIST IS '<BR> tag (intended for web pages) delimited list of regional ecosystems associated with the given preset';




--region preset delimited view
create or replace view
CCD_REGION_PRE_DELIM_V
AS
select
REGION_PRE_ID,
REGION_PRE_NAME,
REGION_PRE_DESC,
LISTAGG(REGION_NAME, ', ') WITHIN GROUP (ORDER BY UPPER(REGION_NAME)) as REGION_NAME_CD_LIST,
LISTAGG(REGION_NAME, '; ') WITHIN GROUP (ORDER BY UPPER(REGION_NAME)) as REGION_NAME_SCD_LIST,
LISTAGG(REGION_NAME, chr(10)) WITHIN GROUP (ORDER BY UPPER(REGION_NAME)) as REGION_NAME_RC_LIST,
LISTAGG(REGION_NAME, '<BR>') WITHIN GROUP (ORDER BY UPPER(REGION_NAME)) as REGION_NAME_BR_LIST

from

CCD_REGION_PRE_V
group by
REGION_PRE_ID,
REGION_PRE_NAME,
REGION_PRE_DESC

order by
REGION_PRE_NAME,
REGION_PRE_DESC;


comment on table CCD_REGION_PRE_DELIM_V IS 'Region Preset Delimited Options (View)

This view returns all region presets and delimited lists of associated region names';

COMMENT ON COLUMN CCD_REGION_PRE_DELIM_V.REGION_PRE_ID IS 'Primary key for the Region Preset table';
COMMENT ON COLUMN CCD_REGION_PRE_DELIM_V.REGION_PRE_NAME IS 'Name of the given Region Preset';
COMMENT ON COLUMN CCD_REGION_PRE_DELIM_V.REGION_PRE_DESC IS 'Description for the given Region Preset';
COMMENT ON COLUMN CCD_REGION_PRE_DELIM_V.REGION_NAME_CD_LIST IS 'Comma-delimited list of regions associated with the given preset';
COMMENT ON COLUMN CCD_REGION_PRE_DELIM_V.REGION_NAME_SCD_LIST IS 'Semicolon-delimited list of regions associated with the given preset';
COMMENT ON COLUMN CCD_REGION_PRE_DELIM_V.REGION_NAME_RC_LIST IS 'Return carriage/new line delimited list of regions associated with the given preset';
COMMENT ON COLUMN CCD_REGION_PRE_DELIM_V.REGION_NAME_BR_LIST IS '<BR> tag (intended for web pages) delimited list of regions associated with the given preset';




--expected species categories preset delimited view
create or replace view
CCD_SPP_CAT_PRE_DELIM_V
AS
select
SPP_CAT_PRE_ID,
SPP_CAT_PRE_NAME,
SPP_CAT_PRE_DESC,
LISTAGG(EXP_SPP_CAT_NAME, ', ') WITHIN GROUP (ORDER BY UPPER(EXP_SPP_CAT_NAME)) as SPP_CAT_NAME_CD_LIST,
LISTAGG(EXP_SPP_CAT_NAME, '; ') WITHIN GROUP (ORDER BY UPPER(EXP_SPP_CAT_NAME)) as SPP_CAT_NAME_SCD_LIST,
LISTAGG(EXP_SPP_CAT_NAME, chr(10)) WITHIN GROUP (ORDER BY UPPER(EXP_SPP_CAT_NAME)) as SPP_CAT_NAME_RC_LIST,
LISTAGG(EXP_SPP_CAT_NAME, '<BR>') WITHIN GROUP (ORDER BY UPPER(EXP_SPP_CAT_NAME)) as SPP_CAT_NAME_BR_LIST

from

CCD_SPP_CAT_PRE_V
group by
SPP_CAT_PRE_ID,
SPP_CAT_PRE_NAME,
SPP_CAT_PRE_DESC

order by
SPP_CAT_PRE_NAME,
SPP_CAT_PRE_DESC;


comment on table CCD_SPP_CAT_PRE_DELIM_V IS 'Expected Species Categories Preset Delimited Options (View)

This view returns all expected species category presets and delimited lists of associated expected species category names';

COMMENT ON COLUMN CCD_SPP_CAT_PRE_DELIM_V.SPP_CAT_PRE_ID IS 'Primary key for the Expected Species Category Preset table';
COMMENT ON COLUMN CCD_SPP_CAT_PRE_DELIM_V.SPP_CAT_PRE_NAME IS 'Name of the given Expected Species Category Preset';
COMMENT ON COLUMN CCD_SPP_CAT_PRE_DELIM_V.SPP_CAT_PRE_DESC IS 'Description for the given Expected Species Category Preset';
COMMENT ON COLUMN CCD_SPP_CAT_PRE_DELIM_V.SPP_CAT_NAME_CD_LIST IS 'Comma-delimited list of expected species categories associated with the given preset';
COMMENT ON COLUMN CCD_SPP_CAT_PRE_DELIM_V.SPP_CAT_NAME_SCD_LIST IS 'Semicolon-delimited list of expected species categories associated with the given preset';
COMMENT ON COLUMN CCD_SPP_CAT_PRE_DELIM_V.SPP_CAT_NAME_RC_LIST IS 'Return carriage/new line delimited list of expected species categories associated with the given preset';
COMMENT ON COLUMN CCD_SPP_CAT_PRE_DELIM_V.SPP_CAT_NAME_BR_LIST IS '<BR> tag (intended for web pages) delimited list of expected species categories associated with the given preset';





--expected ESA target species preset delimited view
create or replace view
CCD_SPP_ESA_PRE_DELIM_V
AS
select
ESA_PRE_ID,
ESA_PRE_NAME,
ESA_PRE_DESC,
LISTAGG(TGT_SPP_ESA_NAME, ', ') WITHIN GROUP (ORDER BY UPPER(TGT_SPP_ESA_NAME)) as SPP_ESA_NAME_CD_LIST,
LISTAGG(TGT_SPP_ESA_NAME, '; ') WITHIN GROUP (ORDER BY UPPER(TGT_SPP_ESA_NAME)) as SPP_ESA_NAME_SCD_LIST,
LISTAGG(TGT_SPP_ESA_NAME, chr(10)) WITHIN GROUP (ORDER BY UPPER(TGT_SPP_ESA_NAME)) as SPP_ESA_NAME_RC_LIST,
LISTAGG(TGT_SPP_ESA_NAME, '<BR>') WITHIN GROUP (ORDER BY UPPER(TGT_SPP_ESA_NAME)) as SPP_ESA_NAME_BR_LIST

from

CCD_SPP_ESA_PRE_V
group by
ESA_PRE_ID,
ESA_PRE_NAME,
ESA_PRE_DESC

order by
ESA_PRE_NAME,
ESA_PRE_DESC;


comment on table CCD_SPP_ESA_PRE_DELIM_V IS 'ESA Target Species Preset Delimited Options (View)

This view returns all ESA Target Species presets and delimited lists of associated ESA Target Species names';

COMMENT ON COLUMN CCD_SPP_ESA_PRE_DELIM_V.ESA_PRE_ID IS 'Primary key for the ESA Target Species Preset table';
COMMENT ON COLUMN CCD_SPP_ESA_PRE_DELIM_V.ESA_PRE_NAME IS 'Name of the given ESA Target Species Preset';
COMMENT ON COLUMN CCD_SPP_ESA_PRE_DELIM_V.ESA_PRE_DESC IS 'Description for the given ESA Target Species Preset';
COMMENT ON COLUMN CCD_SPP_ESA_PRE_DELIM_V.SPP_ESA_NAME_CD_LIST IS 'Comma-delimited list of ESA Target Species associated with the given preset';
COMMENT ON COLUMN CCD_SPP_ESA_PRE_DELIM_V.SPP_ESA_NAME_SCD_LIST IS 'Semicolon-delimited list of ESA Target Species associated with the given preset';
COMMENT ON COLUMN CCD_SPP_ESA_PRE_DELIM_V.SPP_ESA_NAME_RC_LIST IS 'Return carriage/new line delimited list of ESA Target Species associated with the given preset';
COMMENT ON COLUMN CCD_SPP_ESA_PRE_DELIM_V.SPP_ESA_NAME_BR_LIST IS '<BR> tag (intended for web pages) delimited list of ESA Target Species associated with the given preset';




--expected MMPA target species preset delimited view
create or replace view
CCD_SPP_MMPA_PRE_DELIM_V
AS
select
MMPA_PRE_ID,
MMPA_PRE_NAME,
MMPA_PRE_DESC,
LISTAGG(TGT_SPP_MMPA_NAME, ', ') WITHIN GROUP (ORDER BY UPPER(TGT_SPP_MMPA_NAME)) as SPP_MMPA_NAME_CD_LIST,
LISTAGG(TGT_SPP_MMPA_NAME, '; ') WITHIN GROUP (ORDER BY UPPER(TGT_SPP_MMPA_NAME)) as SPP_MMPA_NAME_SCD_LIST,
LISTAGG(TGT_SPP_MMPA_NAME, chr(10)) WITHIN GROUP (ORDER BY UPPER(TGT_SPP_MMPA_NAME)) as SPP_MMPA_NAME_RC_LIST,
LISTAGG(TGT_SPP_MMPA_NAME, '<BR>') WITHIN GROUP (ORDER BY UPPER(TGT_SPP_MMPA_NAME)) as SPP_MMPA_NAME_BR_LIST

from

CCD_SPP_MMPA_PRE_V
group by
MMPA_PRE_ID,
MMPA_PRE_NAME,
MMPA_PRE_DESC

order by
MMPA_PRE_NAME,
MMPA_PRE_DESC;


comment on table CCD_SPP_MMPA_PRE_DELIM_V IS 'MMPA Target Species Preset Delimited Options (View)

This view returns all MMPA Target Species presets and delimited lists of associated MMPA Target Species names';

COMMENT ON COLUMN CCD_SPP_MMPA_PRE_DELIM_V.MMPA_PRE_ID IS 'Primary key for the MMPA Target Species Preset table';
COMMENT ON COLUMN CCD_SPP_MMPA_PRE_DELIM_V.MMPA_PRE_NAME IS 'Name of the given MMPA Target Species Preset';
COMMENT ON COLUMN CCD_SPP_MMPA_PRE_DELIM_V.MMPA_PRE_DESC IS 'Description for the given MMPA Target Species Preset';
COMMENT ON COLUMN CCD_SPP_MMPA_PRE_DELIM_V.SPP_MMPA_NAME_CD_LIST IS 'Comma-delimited list of MMPA Target Species associated with the given preset';
COMMENT ON COLUMN CCD_SPP_MMPA_PRE_DELIM_V.SPP_MMPA_NAME_SCD_LIST IS 'Semicolon-delimited list of MMPA Target Species associated with the given preset';
COMMENT ON COLUMN CCD_SPP_MMPA_PRE_DELIM_V.SPP_MMPA_NAME_RC_LIST IS 'Return carriage/new line delimited list of MMPA Target Species associated with the given preset';
COMMENT ON COLUMN CCD_SPP_MMPA_PRE_DELIM_V.SPP_MMPA_NAME_BR_LIST IS '<BR> tag (intended for web pages) delimited list of MMPA Target Species associated with the given preset';




--expected FSSI target species preset delimited view
create or replace view
CCD_SPP_FSSI_PRE_DELIM_V
AS
select
FSSI_PRE_ID,
FSSI_PRE_NAME,
FSSI_PRE_DESC,
LISTAGG(TGT_SPP_FSSI_NAME, ', ') WITHIN GROUP (ORDER BY UPPER(TGT_SPP_FSSI_NAME)) as SPP_FSSI_NAME_CD_LIST,
LISTAGG(TGT_SPP_FSSI_NAME, '; ') WITHIN GROUP (ORDER BY UPPER(TGT_SPP_FSSI_NAME)) as SPP_FSSI_NAME_SCD_LIST,
LISTAGG(TGT_SPP_FSSI_NAME, chr(10)) WITHIN GROUP (ORDER BY UPPER(TGT_SPP_FSSI_NAME)) as SPP_FSSI_NAME_RC_LIST,
LISTAGG(TGT_SPP_FSSI_NAME, '<BR>') WITHIN GROUP (ORDER BY UPPER(TGT_SPP_FSSI_NAME)) as SPP_FSSI_NAME_BR_LIST

from

CCD_SPP_FSSI_PRE_V
group by
FSSI_PRE_ID,
FSSI_PRE_NAME,
FSSI_PRE_DESC

order by
FSSI_PRE_NAME,
FSSI_PRE_DESC;


comment on table CCD_SPP_FSSI_PRE_DELIM_V IS 'FSSI Target Species Preset Delimited Options (View)

This view returns all FSSI Target Species presets and delimited lists of associated FSSI Target Species names';

COMMENT ON COLUMN CCD_SPP_FSSI_PRE_DELIM_V.FSSI_PRE_ID IS 'Primary key for the FSSI Target Species Preset table';
COMMENT ON COLUMN CCD_SPP_FSSI_PRE_DELIM_V.FSSI_PRE_NAME IS 'Name of the given FSSI Target Species Preset';
COMMENT ON COLUMN CCD_SPP_FSSI_PRE_DELIM_V.FSSI_PRE_DESC IS 'Description for the given FSSI Target Species Preset';
COMMENT ON COLUMN CCD_SPP_FSSI_PRE_DELIM_V.SPP_FSSI_NAME_CD_LIST IS 'Comma-delimited list of FSSI Target Species associated with the given preset';
COMMENT ON COLUMN CCD_SPP_FSSI_PRE_DELIM_V.SPP_FSSI_NAME_SCD_LIST IS 'Semicolon-delimited list of FSSI Target Species associated with the given preset';
COMMENT ON COLUMN CCD_SPP_FSSI_PRE_DELIM_V.SPP_FSSI_NAME_RC_LIST IS 'Return carriage/new line delimited list of FSSI Target Species associated with the given preset';
COMMENT ON COLUMN CCD_SPP_FSSI_PRE_DELIM_V.SPP_FSSI_NAME_BR_LIST IS '<BR> tag (intended for web pages) delimited list of FSSI Target Species associated with the given preset';




--expected Survey Categories preset delimited view
create or replace view
CCD_SVY_CAT_PRE_DELIM_V
AS
select
SVY_CAT_PRE_ID,
SVY_CAT_PRE_NAME,
SVY_CAT_PRE_DESC,
SVY_CAT_PRIMARY_YN,
LISTAGG(SVY_CAT_NAME, ', ') WITHIN GROUP (ORDER BY UPPER(SVY_CAT_NAME)) as SVY_CAT_NAME_CD_LIST,
LISTAGG(SVY_CAT_NAME, '; ') WITHIN GROUP (ORDER BY UPPER(SVY_CAT_NAME)) as SVY_CAT_NAME_SCD_LIST,
LISTAGG(SVY_CAT_NAME, chr(10)) WITHIN GROUP (ORDER BY UPPER(SVY_CAT_NAME)) as SVY_CAT_NAME_RC_LIST,
LISTAGG(SVY_CAT_NAME, '<BR>') WITHIN GROUP (ORDER BY UPPER(SVY_CAT_NAME)) as SVY_CAT_NAME_BR_LIST

from

CCD_SVY_CAT_PRE_V
group by
SVY_CAT_PRE_ID,
SVY_CAT_PRE_NAME,
SVY_CAT_PRE_DESC,
SVY_CAT_PRIMARY_YN

order by
SVY_CAT_PRIMARY_YN,
SVY_CAT_PRE_NAME,
SVY_CAT_PRE_DESC;


comment on table CCD_SVY_CAT_PRE_DELIM_V IS 'Survey Category Preset Delimited Options (View)

This view returns all Survey Category presets and delimited lists of associated Survey Category names';

COMMENT ON COLUMN CCD_SVY_CAT_PRE_DELIM_V.SVY_CAT_PRE_ID IS 'Primary key for the Survey Category Preset table';
COMMENT ON COLUMN CCD_SVY_CAT_PRE_DELIM_V.SVY_CAT_PRE_NAME IS 'Name of the given Survey Category Preset';
COMMENT ON COLUMN CCD_SVY_CAT_PRE_DELIM_V.SVY_CAT_PRE_DESC IS 'Description for the given Survey Category Preset';
COMMENT ON COLUMN CCD_SVY_CAT_PRE_DELIM_V.SVY_CAT_PRIMARY_YN IS 'Boolean field to indicate if this is a preset for a primary survey category (Y) or a secondary survey category (N)';

COMMENT ON COLUMN CCD_SVY_CAT_PRE_DELIM_V.SVY_CAT_NAME_CD_LIST IS 'Comma-delimited list of Survey Category associated with the given preset';
COMMENT ON COLUMN CCD_SVY_CAT_PRE_DELIM_V.SVY_CAT_NAME_SCD_LIST IS 'Semicolon-delimited list of Survey Category associated with the given preset';
COMMENT ON COLUMN CCD_SVY_CAT_PRE_DELIM_V.SVY_CAT_NAME_RC_LIST IS 'Return carriage/new line delimited list of Survey Category associated with the given preset';
COMMENT ON COLUMN CCD_SVY_CAT_PRE_DELIM_V.SVY_CAT_NAME_BR_LIST IS '<BR> tag (intended for web pages) delimited list of Survey Category associated with the given preset';








--define the upgrade version in the database upgrade log table:
INSERT INTO DB_UPGRADE_LOGS (UPGRADE_APP_NAME, UPGRADE_VERSION, UPGRADE_DATE, UPGRADE_DESC) VALUES ('Centralized Cruise Database', '0.7', TO_DATE('05-APR-20', 'DD-MON-YY'), 'Updated the survey categories reference table (CCD_CRUISE_SVY_CATS) to include the PRIMARY_YN field in the unique key constraint.  Implemented reference preset tables, preset option tables, and preset option views for the Primary Survey Category, Secondary Survey Category, Target Species - ESA, Target Species - MMPA, Target Species - FSSI, Expected Species Categories, Regional Ecosystems, Gear, and Regions.  Updated the CRUISE_PKG Oracle package to define a new function APPEND_REF_PRE_OPTS_FN that is used in the APEX reference table preset functionality to return a delimited list of values based on the given shuttle field values and selected preset option''s associated values.  Views were updated to include additional delimited lists of associated values (return carriage and <BR>) for different display mediums from both the cruise and cruise leg perspectives: CCD_LEG_DELIM_V, CCD_CRUISE_V, CCD_CRUISE_LEGS_V, CCD_CRUISE_DELIM_V, CCD_CRUISE_SUMM_V, CCD_CRUISE_LEG_DELIM_V');

--commit the DB_UPGRADE_LOGS record insertion
COMMIT;
