--------------------------------------------------------
--------------------------------------------------------
--Database Name: Centralized Cruise Database
--Database Description: Centralized Cruise Database to track information about each PIFSC research cruise including activities, chief scientists, regions, etc. to remove the need for each division/program to manage this information
--------------------------------------------------------
--------------------------------------------------------


--------------------------------------------------------
--Centralized Cruise Database - version 0.6 updates:
--------------------------------------------------------





--Installed Version 0.1 of the Database Logging Module Database (Git URL: git@gitlab.pifsc.gov:centralized-data-tools/database-logging-module.git)


@@"./upgrades/external_modules/DB_log_DDL_DML_upgrade_v0.1.sql"


--Installed Version 0.2 of the Error Handler Module (Git URL: git@gitlab.pifsc.gov:centralized-data-tools/apex_tools.git in the "Error Handling" folder)


@@"./upgrades/external_modules/Error_Handler_DDL_DML_upgrade_v0.1.sql"


@@"./upgrades/external_modules/Error_Handler_DDL_DML_upgrade_v0.2.sql"





ALTER TABLE CCD_LEG_REGIONS RENAME COLUMN LEG_REGION_DESC TO LEG_REGION_NOTES;

COMMENT ON COLUMN CCD_LEG_REGIONS.LEG_REGION_NOTES IS 'Notes about the region that was surveyed during the given cruise leg';


ALTER TABLE CCD_VESSELS
ADD CONSTRAINT CCD_VESSELS_U1 UNIQUE
(
  VESSEL_NAME
)
ENABLE;



--define reference tables:
CREATE TABLE CCD_PLAT_TYPES
(
  PLAT_TYPE_ID NUMBER NOT NULL
, PLAT_TYPE_NAME VARCHAR2(200) NOT NULL
, PLAT_TYPE_DESC VARCHAR2(500)
, FINSS_ID NUMBER
, CONSTRAINT CCD_PLAT_TYPES_PK PRIMARY KEY
  (
    PLAT_TYPE_ID
  )
  ENABLE
);

COMMENT ON COLUMN CCD_PLAT_TYPES.PLAT_TYPE_ID IS 'Primary key for the Platform Type table';

COMMENT ON COLUMN CCD_PLAT_TYPES.PLAT_TYPE_NAME IS 'Name of the given Platform Type';

COMMENT ON COLUMN CCD_PLAT_TYPES.PLAT_TYPE_DESC IS 'Description for the given Platform Type';

COMMENT ON COLUMN CCD_PLAT_TYPES.FINSS_ID IS 'The ID value from the FINSS system';


COMMENT ON TABLE CCD_PLAT_TYPES IS 'Reference Table for storing Platform Type information';

ALTER TABLE CCD_PLAT_TYPES ADD CONSTRAINT CCD_PLAT_TYPES_U1 UNIQUE
(
  PLAT_TYPE_NAME
)
ENABLE;

CREATE TABLE CCD_REG_ECOSYSTEMS
(
  REG_ECOSYSTEM_ID NUMBER NOT NULL
, REG_ECOSYSTEM_NAME VARCHAR2(200) NOT NULL
, REG_ECOSYSTEM_DESC VARCHAR2(500)
, FINSS_ID NUMBER
, CONSTRAINT CCD_REG_ECOSYSTEMS_PK PRIMARY KEY
  (
    REG_ECOSYSTEM_ID
  )
  ENABLE
);

COMMENT ON COLUMN CCD_REG_ECOSYSTEMS.REG_ECOSYSTEM_ID IS 'Primary key for the Regional Ecosystem table';

COMMENT ON COLUMN CCD_REG_ECOSYSTEMS.REG_ECOSYSTEM_NAME IS 'Name of the given Regional Ecosystem';

COMMENT ON COLUMN CCD_REG_ECOSYSTEMS.REG_ECOSYSTEM_DESC IS 'Description for the given Regional Ecosystem';

COMMENT ON COLUMN CCD_REG_ECOSYSTEMS.FINSS_ID IS 'The ID value from the FINSS system';


COMMENT ON TABLE CCD_REG_ECOSYSTEMS IS 'Reference Table for storing Regional Ecosystem information';

ALTER TABLE CCD_REG_ECOSYSTEMS ADD CONSTRAINT CCD_REG_ECOSYSTEMS_U1 UNIQUE
(
  REG_ECOSYSTEM_NAME
)
ENABLE;


CREATE TABLE CCD_GEAR
(
  GEAR_ID NUMBER NOT NULL
, GEAR_NAME VARCHAR2(200) NOT NULL
, GEAR_DESC VARCHAR2(500)
, FINSS_ID NUMBER
, CONSTRAINT CCD_GEAR_PK PRIMARY KEY
  (
    GEAR_ID
  )
  ENABLE
);

COMMENT ON COLUMN CCD_GEAR.GEAR_ID IS 'Primary key for the Gear table';

COMMENT ON COLUMN CCD_GEAR.GEAR_NAME IS 'Name of the given Gear';

COMMENT ON COLUMN CCD_GEAR.GEAR_DESC IS 'Description for the given Gear';

COMMENT ON COLUMN CCD_GEAR.FINSS_ID IS 'The ID value from the FINSS system';

COMMENT ON TABLE CCD_GEAR IS 'Reference Table for storing Gear information';

ALTER TABLE CCD_GEAR ADD CONSTRAINT CCD_GEAR_U1 UNIQUE
(
  GEAR_NAME
)
ENABLE;

CREATE TABLE CCD_STD_SVY_NAMES
(
  STD_SVY_NAME_ID NUMBER NOT NULL
, STD_SVY_NAME VARCHAR2(200) NOT NULL
, STD_SVY_DESC VARCHAR2(2000)
, FINSS_ID NUMBER
, CONSTRAINT CCD_STD_SVY_NAMES_PK PRIMARY KEY
  (
    STD_SVY_NAME_ID
  )
  ENABLE
);

COMMENT ON COLUMN CCD_STD_SVY_NAMES.STD_SVY_NAME_ID IS 'Primary key for the Standard Survey Name table';

COMMENT ON COLUMN CCD_STD_SVY_NAMES.STD_SVY_NAME IS 'Name of the given Standard Survey Name';

COMMENT ON COLUMN CCD_STD_SVY_NAMES.STD_SVY_DESC IS 'Description for the given Standard Survey Name';

COMMENT ON COLUMN CCD_STD_SVY_NAMES.FINSS_ID IS 'The ID value from the FINSS system';

COMMENT ON TABLE CCD_STD_SVY_NAMES IS 'Reference Table for storing Standard Survey Name information';

ALTER TABLE CCD_STD_SVY_NAMES ADD CONSTRAINT CCD_STD_SVY_NAMES_U1 UNIQUE
(
  STD_SVY_NAME
)
ENABLE;

CREATE TABLE CCD_SVY_FREQ
(
  SVY_FREQ_ID NUMBER NOT NULL
, SVY_FREQ_NAME VARCHAR2(200) NOT NULL
, SVY_FREQ_DESC VARCHAR2(500)
, CONSTRAINT CCD_SVY_FREQ_PK PRIMARY KEY
  (
    SVY_FREQ_ID
  )
  ENABLE
);

COMMENT ON COLUMN CCD_SVY_FREQ.SVY_FREQ_ID IS 'Primary key for the Survey Frequency table';

COMMENT ON COLUMN CCD_SVY_FREQ.SVY_FREQ_NAME IS 'Name of the given Survey Frequency';

COMMENT ON COLUMN CCD_SVY_FREQ.SVY_FREQ_DESC IS 'Description for the given Survey Frequency';

COMMENT ON TABLE CCD_SVY_FREQ IS 'Reference Table for storing Survey Frequency information';

ALTER TABLE CCD_SVY_FREQ ADD CONSTRAINT CCD_SVY_FREQ_U1 UNIQUE
(
  SVY_FREQ_NAME
)
ENABLE;



CREATE TABLE CCD_SVY_CATS
(
  SVY_CAT_ID NUMBER NOT NULL
, SVY_CAT_NAME VARCHAR2(200) NOT NULL
, SVY_CAT_DESC VARCHAR2(2000)
, FINSS_ID NUMBER
, CONSTRAINT CCD_SVY_CATS_PK PRIMARY KEY
  (
    SVY_CAT_ID
  )
  ENABLE
);

COMMENT ON COLUMN CCD_SVY_CATS.SVY_CAT_ID IS 'Primary key for the Survey Category table';

COMMENT ON COLUMN CCD_SVY_CATS.SVY_CAT_NAME IS 'Name of the given Survey Category';

COMMENT ON COLUMN CCD_SVY_CATS.SVY_CAT_DESC IS 'Description for the given Survey Category';

COMMENT ON TABLE CCD_SVY_CATS IS 'Reference Table for storing Survey Category information';

COMMENT ON COLUMN CCD_SVY_CATS.FINSS_ID IS 'The ID value from the FINSS system';


ALTER TABLE CCD_SVY_CATS ADD CONSTRAINT CCD_SVY_CATS_U1 UNIQUE
(
  SVY_CAT_NAME
)
ENABLE;





CREATE TABLE CCD_TGT_SPP_ESA
(
  TGT_SPP_ESA_ID NUMBER NOT NULL
, TGT_SPP_ESA_NAME VARCHAR2(200) NOT NULL
, TGT_SPP_ESA_DESC VARCHAR2(500)
, FINSS_ID NUMBER
, CONSTRAINT CCD_TGT_SPP_ESA_PK PRIMARY KEY
  (
    TGT_SPP_ESA_ID
  )
  ENABLE
);

COMMENT ON COLUMN CCD_TGT_SPP_ESA.TGT_SPP_ESA_ID IS 'Primary key for the Target Species - ESA table';

COMMENT ON COLUMN CCD_TGT_SPP_ESA.TGT_SPP_ESA_NAME IS 'Name of the given Target Species - ESA';

COMMENT ON COLUMN CCD_TGT_SPP_ESA.TGT_SPP_ESA_DESC IS 'Description for the given Target Species - ESA';

COMMENT ON COLUMN CCD_TGT_SPP_ESA.FINSS_ID IS 'The ID value from the FINSS system';

COMMENT ON TABLE CCD_TGT_SPP_ESA IS 'Reference Table for storing Target Species - ESA information';

ALTER TABLE CCD_TGT_SPP_ESA ADD CONSTRAINT CCD_TGT_SPP_ESA_U1 UNIQUE
(
  TGT_SPP_ESA_NAME
)
ENABLE;

CREATE TABLE CCD_TGT_SPP_MMPA
(
  TGT_SPP_MMPA_ID NUMBER NOT NULL
, TGT_SPP_MMPA_NAME VARCHAR2(200) NOT NULL
, TGT_SPP_MMPA_DESC VARCHAR2(500)
, FINSS_ID NUMBER
, CONSTRAINT CCD_TGT_SPP_MMPA_PK PRIMARY KEY
  (
    TGT_SPP_MMPA_ID
  )
  ENABLE
);

COMMENT ON COLUMN CCD_TGT_SPP_MMPA.TGT_SPP_MMPA_ID IS 'Primary key for the Target Species - MMPA table';

COMMENT ON COLUMN CCD_TGT_SPP_MMPA.TGT_SPP_MMPA_NAME IS 'Name of the given Target Species - MMPA';

COMMENT ON COLUMN CCD_TGT_SPP_MMPA.TGT_SPP_MMPA_DESC IS 'Description for the given Target Species - MMPA';

COMMENT ON COLUMN CCD_TGT_SPP_MMPA.FINSS_ID IS 'The ID value from the FINSS system';

COMMENT ON TABLE CCD_TGT_SPP_MMPA IS 'Reference Table for storing Target Species - MMPA information';

ALTER TABLE CCD_TGT_SPP_MMPA ADD CONSTRAINT CCD_TGT_SPP_MMPA_U1 UNIQUE
(
  TGT_SPP_MMPA_NAME
)
ENABLE;

CREATE TABLE CCD_TGT_SPP_FSSI
(
  TGT_SPP_FSSI_ID NUMBER NOT NULL
, TGT_SPP_FSSI_NAME VARCHAR2(200) NOT NULL
, TGT_SPP_FSSI_DESC VARCHAR2(500)
, FINSS_ID NUMBER
, CONSTRAINT CCD_TGT_SPP_FSSI_PK PRIMARY KEY
  (
    TGT_SPP_FSSI_ID
  )
  ENABLE
);

COMMENT ON COLUMN CCD_TGT_SPP_FSSI.TGT_SPP_FSSI_ID IS 'Primary key for the Target Species - FSSI table';

COMMENT ON COLUMN CCD_TGT_SPP_FSSI.TGT_SPP_FSSI_NAME IS 'Name of the given Target Species - FSSI';

COMMENT ON COLUMN CCD_TGT_SPP_FSSI.TGT_SPP_FSSI_DESC IS 'Description for the given Target Species - FSSI';

COMMENT ON COLUMN CCD_TGT_SPP_FSSI.FINSS_ID IS 'The ID value from the FINSS system';

COMMENT ON TABLE CCD_TGT_SPP_FSSI IS 'Reference Table for storing Target Species - FSSI information';

ALTER TABLE CCD_TGT_SPP_FSSI ADD CONSTRAINT CCD_TGT_SPP_FSSI_U1 UNIQUE
(
  TGT_SPP_FSSI_NAME
)
ENABLE;

CREATE TABLE CCD_TGT_SPP_OTHER
(
  TGT_SPP_OTHER_ID NUMBER NOT NULL
, TGT_SPP_OTHER_CNAME VARCHAR2 (200) NOT NULL
, TGT_SPP_OTHER_SNAME VARCHAR2 (200) NOT NULL
, TGT_SPP_OTHER_NOTES VARCHAR2 (500)
, CRUISE_ID NUMBER NOT NULL
, CONSTRAINT CCD_TGT_SPP_OTHER_PK PRIMARY KEY
  (
    TGT_SPP_OTHER_ID
  )
  ENABLE
);

COMMENT ON COLUMN CCD_TGT_SPP_OTHER.TGT_SPP_OTHER_ID IS 'Primary key for the Target Species - Other table';

COMMENT ON COLUMN CCD_TGT_SPP_OTHER.TGT_SPP_OTHER_CNAME IS 'Common name for the given Target Species - Other';

COMMENT ON COLUMN CCD_TGT_SPP_OTHER.TGT_SPP_OTHER_SNAME IS 'Scientific name for the given Target Species - Other';

COMMENT ON COLUMN CCD_TGT_SPP_OTHER.TGT_SPP_OTHER_NOTES IS 'Notes associated with the given Target Species - Other';


COMMENT ON COLUMN CCD_TGT_SPP_OTHER.CRUISE_ID IS 'Foreign key reference to the CCD_CRUISES table';

COMMENT ON TABLE CCD_TGT_SPP_OTHER IS 'Reference Table for storing Target Species - Other information';

ALTER TABLE CCD_TGT_SPP_OTHER ADD CONSTRAINT CCD_TGT_SPP_OTHER_U1 UNIQUE
(
  TGT_SPP_OTHER_CNAME
  , CRUISE_ID
)
ENABLE;


ALTER TABLE CCD_TGT_SPP_OTHER ADD CONSTRAINT CCD_TGT_SPP_OTHER_U2 UNIQUE
(
  TGT_SPP_OTHER_SNAME
  , CRUISE_ID
)
ENABLE;


ALTER TABLE CCD_TGT_SPP_OTHER
ADD CONSTRAINT CCD_TGT_SPP_OTHER_FK1 FOREIGN KEY
(
  CRUISE_ID
)
REFERENCES CCD_CRUISES
(
  CRUISE_ID
)
ENABLE;




CREATE TABLE CCD_SVY_TYPES
(
  SVY_TYPE_ID NUMBER NOT NULL
, SVY_TYPE_NAME VARCHAR2(200) NOT NULL
, SVY_TYPE_DESC VARCHAR2(500)
, CONSTRAINT CCD_SVY_TYPES_PK PRIMARY KEY
  (
    SVY_TYPE_ID
  )
  ENABLE
);

COMMENT ON COLUMN CCD_SVY_TYPES.SVY_TYPE_ID IS 'Primary key for the Survey Type table';

COMMENT ON COLUMN CCD_SVY_TYPES.SVY_TYPE_NAME IS 'Name of the given Survey Type';

COMMENT ON COLUMN CCD_SVY_TYPES.SVY_TYPE_DESC IS 'Description for the given Survey Type';

COMMENT ON TABLE CCD_SVY_TYPES IS 'Reference Table for storing Survey Type information';

ALTER TABLE CCD_SVY_TYPES ADD CONSTRAINT CCD_SVY_TYPES_U1 UNIQUE
(
  SVY_TYPE_NAME
)
ENABLE;

--associate the survey types with the cruises
ALTER TABLE CCD_CRUISES
ADD (SVY_TYPE_ID NUMBER NOT NULL);

CREATE INDEX CCD_CRUISES_I4 ON CCD_CRUISES (SVY_TYPE_ID);

ALTER TABLE CCD_CRUISES
ADD CONSTRAINT CCD_CRUISES_FK4 FOREIGN KEY
(
  SVY_TYPE_ID
)
REFERENCES CCD_SVY_TYPES
(
  SVY_TYPE_ID
)
ENABLE;

COMMENT ON COLUMN CCD_CRUISES.SVY_TYPE_ID IS 'Survey Type for the given cruise';



CREATE TABLE CCD_SCI_CENTERS
(
  SCI_CENTER_ID NUMBER NOT NULL
, SCI_CENTER_NAME VARCHAR2(200) NOT NULL
, SCI_CENTER_DESC VARCHAR2(500)
, CONSTRAINT CCD_SCI_CENTERS_PK PRIMARY KEY
  (
    SCI_CENTER_ID
  )
  ENABLE
);

COMMENT ON COLUMN CCD_SCI_CENTERS.SCI_CENTER_ID IS 'Primary key for the Science Center table';

COMMENT ON COLUMN CCD_SCI_CENTERS.SCI_CENTER_NAME IS 'Name of the given Science Center';

COMMENT ON COLUMN CCD_SCI_CENTERS.SCI_CENTER_DESC IS 'Description for the given Science Center';

COMMENT ON TABLE CCD_SCI_CENTERS IS 'Reference Table for storing Science Center information';

ALTER TABLE CCD_SCI_CENTERS ADD CONSTRAINT CCD_SCI_CENTERS_U1 UNIQUE
(
  SCI_CENTER_NAME
)
ENABLE;





CREATE TABLE CCD_EXP_SPP_CATS
(
  EXP_SPP_CAT_ID NUMBER NOT NULL
, EXP_SPP_CAT_NAME VARCHAR2(200) NOT NULL
, EXP_SPP_CAT_DESC VARCHAR2(500)
, FINSS_ID NUMBER
, CONSTRAINT CCD_EXP_SPP_CATS_PK PRIMARY KEY
  (
    EXP_SPP_CAT_ID
  )
  ENABLE
);

COMMENT ON COLUMN CCD_EXP_SPP_CATS.EXP_SPP_CAT_ID IS 'Primary key for the Expected Target Species table';

COMMENT ON COLUMN CCD_EXP_SPP_CATS.EXP_SPP_CAT_NAME IS 'Name of the given Expected Target Species';

COMMENT ON COLUMN CCD_EXP_SPP_CATS.EXP_SPP_CAT_DESC IS 'Description for the given Expected Target Species';

COMMENT ON COLUMN CCD_EXP_SPP_CATS.FINSS_ID IS 'The ID value from the FINSS system';

ALTER TABLE CCD_EXP_SPP_CATS ADD CONSTRAINT CCD_EXP_SPP_CATS_U1 UNIQUE
(
  EXP_SPP_CAT_NAME
)
ENABLE;





--redefine table comments:
COMMENT ON TABLE CCD_PLAT_TYPES IS 'Platform Types

This table stores the different types of platforms defined based on the FINSS system to be associated with cruise legs (referred to as Survey Cruise in the FINSS system)';
COMMENT ON TABLE CCD_REG_ECOSYSTEMS IS 'Regional Ecosystems

This table stores the different regional ecosystems defined based on the FINSS system to be associated with cruise legs (referred to as Survey Cruise in the FINSS system)';
COMMENT ON TABLE CCD_GEAR IS 'Cruise Gear

This table stores the different types of Gear used in a given cruise leg (referred to as Survey Cruise in FINSS) based on the FINSS system';
COMMENT ON TABLE CCD_STD_SVY_NAMES IS 'Standard Survey Names

This table stores the different standard survey names defined based on the FINSS system to be associated with cruises (referred to as Survey Instance in the FINSS system)';
COMMENT ON TABLE CCD_SVY_FREQ IS 'Survey Frequency

This table stores the different options for survey frequency for a given cruise  (referred to as Survey Instance in FINSS) based on the FINSS system';


COMMENT ON TABLE CCD_SVY_CATS IS 'Survey Categories

This table stores the survey categories for a given cruise  (referred to as ""Survey Instance"" in FINSS) based on the FINSS system';



COMMENT ON TABLE CCD_TGT_SPP_ESA IS 'Target Species - ESA

This table stores the Target Species - ESA for a given cruise  (referred to as Survey Instance in FINSS) based on the FINSS system';
COMMENT ON TABLE CCD_TGT_SPP_MMPA IS 'Target Species - MMPA

This table stores the Target Species - MMPA for a given cruise  (referred to as Survey Instance in FINSS) based on the FINSS system';
COMMENT ON TABLE CCD_TGT_SPP_FSSI IS 'Target Species - FSSI

This table stores the Target Species - FSSI for a given cruise  (referred to as Survey Instance in FINSS) based on the FINSS system';
COMMENT ON TABLE CCD_TGT_SPP_OTHER IS 'Target Species - Other Species

This table stores the Target Species - Other Species for a given cruise  (referred to as Survey Instance in FINSS) based on the FINSS system';


COMMENT ON TABLE CCD_SCI_CENTERS IS 'Fisheries Science Centers

This table stores the different Fisheries Science Centers for a given cruise  (referred to as ""Survey Instance"" in FINSS) based on the FINSS system';


COMMENT ON TABLE CCD_EXP_SPP_CATS IS 'Expected Species Categories

This table stores the Expected Species Categories for a given cruise  (referred to as Survey Instance in FINSS) based on the FINSS system';





--add auditing fields:

ALTER TABLE CCD_EXP_SPP_CATS ADD (CREATE_DATE DATE );
ALTER TABLE CCD_EXP_SPP_CATS
ADD (CREATED_BY VARCHAR2(30) );
ALTER TABLE CCD_EXP_SPP_CATS
ADD (LAST_MOD_DATE DATE );

ALTER TABLE CCD_EXP_SPP_CATS
ADD (LAST_MOD_BY VARCHAR2(30) );
COMMENT ON COLUMN CCD_EXP_SPP_CATS.CREATE_DATE IS 'The date on which this record was created in the database';
COMMENT ON COLUMN CCD_EXP_SPP_CATS.CREATED_BY IS 'The Oracle username of the person creating this record in the database';
COMMENT ON COLUMN CCD_EXP_SPP_CATS.LAST_MOD_DATE IS 'The last date on which any of the data in this record was changed';
COMMENT ON COLUMN CCD_EXP_SPP_CATS.LAST_MOD_BY IS 'The Oracle username of the person making the most recent change to this record';




ALTER TABLE CCD_PLAT_TYPES ADD (CREATE_DATE DATE );
ALTER TABLE CCD_PLAT_TYPES
ADD (CREATED_BY VARCHAR2(30) );
ALTER TABLE CCD_PLAT_TYPES
ADD (LAST_MOD_DATE DATE );

ALTER TABLE CCD_PLAT_TYPES
ADD (LAST_MOD_BY VARCHAR2(30) );
COMMENT ON COLUMN CCD_PLAT_TYPES.CREATE_DATE IS 'The date on which this record was created in the database';
COMMENT ON COLUMN CCD_PLAT_TYPES.CREATED_BY IS 'The Oracle username of the person creating this record in the database';
COMMENT ON COLUMN CCD_PLAT_TYPES.LAST_MOD_DATE IS 'The last date on which any of the data in this record was changed';
COMMENT ON COLUMN CCD_PLAT_TYPES.LAST_MOD_BY IS 'The Oracle username of the person making the most recent change to this record';
ALTER TABLE CCD_REG_ECOSYSTEMS ADD (CREATE_DATE DATE );
ALTER TABLE CCD_REG_ECOSYSTEMS
ADD (CREATED_BY VARCHAR2(30) );
ALTER TABLE CCD_REG_ECOSYSTEMS
ADD (LAST_MOD_DATE DATE );

ALTER TABLE CCD_REG_ECOSYSTEMS
ADD (LAST_MOD_BY VARCHAR2(30) );
COMMENT ON COLUMN CCD_REG_ECOSYSTEMS.CREATE_DATE IS 'The date on which this record was created in the database';
COMMENT ON COLUMN CCD_REG_ECOSYSTEMS.CREATED_BY IS 'The Oracle username of the person creating this record in the database';
COMMENT ON COLUMN CCD_REG_ECOSYSTEMS.LAST_MOD_DATE IS 'The last date on which any of the data in this record was changed';
COMMENT ON COLUMN CCD_REG_ECOSYSTEMS.LAST_MOD_BY IS 'The Oracle username of the person making the most recent change to this record';

ALTER TABLE CCD_GEAR ADD (CREATE_DATE DATE );
ALTER TABLE CCD_GEAR
ADD (CREATED_BY VARCHAR2(30) );
ALTER TABLE CCD_GEAR
ADD (LAST_MOD_DATE DATE );

ALTER TABLE CCD_GEAR
ADD (LAST_MOD_BY VARCHAR2(30) );
COMMENT ON COLUMN CCD_GEAR.CREATE_DATE IS 'The date on which this record was created in the database';
COMMENT ON COLUMN CCD_GEAR.CREATED_BY IS 'The Oracle username of the person creating this record in the database';
COMMENT ON COLUMN CCD_GEAR.LAST_MOD_DATE IS 'The last date on which any of the data in this record was changed';
COMMENT ON COLUMN CCD_GEAR.LAST_MOD_BY IS 'The Oracle username of the person making the most recent change to this record';
ALTER TABLE CCD_STD_SVY_NAMES ADD (CREATE_DATE DATE );
ALTER TABLE CCD_STD_SVY_NAMES
ADD (CREATED_BY VARCHAR2(30) );
ALTER TABLE CCD_STD_SVY_NAMES
ADD (LAST_MOD_DATE DATE );

ALTER TABLE CCD_STD_SVY_NAMES
ADD (LAST_MOD_BY VARCHAR2(30) );
COMMENT ON COLUMN CCD_STD_SVY_NAMES.CREATE_DATE IS 'The date on which this record was created in the database';
COMMENT ON COLUMN CCD_STD_SVY_NAMES.CREATED_BY IS 'The Oracle username of the person creating this record in the database';
COMMENT ON COLUMN CCD_STD_SVY_NAMES.LAST_MOD_DATE IS 'The last date on which any of the data in this record was changed';
COMMENT ON COLUMN CCD_STD_SVY_NAMES.LAST_MOD_BY IS 'The Oracle username of the person making the most recent change to this record';
ALTER TABLE CCD_SVY_FREQ ADD (CREATE_DATE DATE );
ALTER TABLE CCD_SVY_FREQ
ADD (CREATED_BY VARCHAR2(30) );
ALTER TABLE CCD_SVY_FREQ
ADD (LAST_MOD_DATE DATE );

ALTER TABLE CCD_SVY_FREQ
ADD (LAST_MOD_BY VARCHAR2(30) );
COMMENT ON COLUMN CCD_SVY_FREQ.CREATE_DATE IS 'The date on which this record was created in the database';
COMMENT ON COLUMN CCD_SVY_FREQ.CREATED_BY IS 'The Oracle username of the person creating this record in the database';
COMMENT ON COLUMN CCD_SVY_FREQ.LAST_MOD_DATE IS 'The last date on which any of the data in this record was changed';
COMMENT ON COLUMN CCD_SVY_FREQ.LAST_MOD_BY IS 'The Oracle username of the person making the most recent change to this record';



ALTER TABLE CCD_SVY_CATS ADD (CREATE_DATE DATE );
ALTER TABLE CCD_SVY_CATS
ADD (CREATED_BY VARCHAR2(30) );
ALTER TABLE CCD_SVY_CATS
ADD (LAST_MOD_DATE DATE );

ALTER TABLE CCD_SVY_CATS
ADD (LAST_MOD_BY VARCHAR2(30) );
COMMENT ON COLUMN CCD_SVY_CATS.CREATE_DATE IS 'The date on which this record was created in the database';
COMMENT ON COLUMN CCD_SVY_CATS.CREATED_BY IS 'The Oracle username of the person creating this record in the database';
COMMENT ON COLUMN CCD_SVY_CATS.LAST_MOD_DATE IS 'The last date on which any of the data in this record was changed';
COMMENT ON COLUMN CCD_SVY_CATS.LAST_MOD_BY IS 'The Oracle username of the person making the most recent change to this record';




ALTER TABLE CCD_TGT_SPP_ESA ADD (CREATE_DATE DATE );
ALTER TABLE CCD_TGT_SPP_ESA
ADD (CREATED_BY VARCHAR2(30) );
ALTER TABLE CCD_TGT_SPP_ESA
ADD (LAST_MOD_DATE DATE );

ALTER TABLE CCD_TGT_SPP_ESA
ADD (LAST_MOD_BY VARCHAR2(30) );
COMMENT ON COLUMN CCD_TGT_SPP_ESA.CREATE_DATE IS 'The date on which this record was created in the database';
COMMENT ON COLUMN CCD_TGT_SPP_ESA.CREATED_BY IS 'The Oracle username of the person creating this record in the database';
COMMENT ON COLUMN CCD_TGT_SPP_ESA.LAST_MOD_DATE IS 'The last date on which any of the data in this record was changed';
COMMENT ON COLUMN CCD_TGT_SPP_ESA.LAST_MOD_BY IS 'The Oracle username of the person making the most recent change to this record';
ALTER TABLE CCD_TGT_SPP_MMPA ADD (CREATE_DATE DATE );
ALTER TABLE CCD_TGT_SPP_MMPA
ADD (CREATED_BY VARCHAR2(30) );
ALTER TABLE CCD_TGT_SPP_MMPA
ADD (LAST_MOD_DATE DATE );

ALTER TABLE CCD_TGT_SPP_MMPA
ADD (LAST_MOD_BY VARCHAR2(30) );
COMMENT ON COLUMN CCD_TGT_SPP_MMPA.CREATE_DATE IS 'The date on which this record was created in the database';
COMMENT ON COLUMN CCD_TGT_SPP_MMPA.CREATED_BY IS 'The Oracle username of the person creating this record in the database';
COMMENT ON COLUMN CCD_TGT_SPP_MMPA.LAST_MOD_DATE IS 'The last date on which any of the data in this record was changed';
COMMENT ON COLUMN CCD_TGT_SPP_MMPA.LAST_MOD_BY IS 'The Oracle username of the person making the most recent change to this record';
ALTER TABLE CCD_TGT_SPP_FSSI ADD (CREATE_DATE DATE );
ALTER TABLE CCD_TGT_SPP_FSSI
ADD (CREATED_BY VARCHAR2(30) );
ALTER TABLE CCD_TGT_SPP_FSSI
ADD (LAST_MOD_DATE DATE );

ALTER TABLE CCD_TGT_SPP_FSSI
ADD (LAST_MOD_BY VARCHAR2(30) );
COMMENT ON COLUMN CCD_TGT_SPP_FSSI.CREATE_DATE IS 'The date on which this record was created in the database';
COMMENT ON COLUMN CCD_TGT_SPP_FSSI.CREATED_BY IS 'The Oracle username of the person creating this record in the database';
COMMENT ON COLUMN CCD_TGT_SPP_FSSI.LAST_MOD_DATE IS 'The last date on which any of the data in this record was changed';
COMMENT ON COLUMN CCD_TGT_SPP_FSSI.LAST_MOD_BY IS 'The Oracle username of the person making the most recent change to this record';
ALTER TABLE CCD_TGT_SPP_OTHER ADD (CREATE_DATE DATE );
ALTER TABLE CCD_TGT_SPP_OTHER
ADD (CREATED_BY VARCHAR2(30) );
ALTER TABLE CCD_TGT_SPP_OTHER
ADD (LAST_MOD_DATE DATE );

ALTER TABLE CCD_TGT_SPP_OTHER
ADD (LAST_MOD_BY VARCHAR2(30) );
COMMENT ON COLUMN CCD_TGT_SPP_OTHER.CREATE_DATE IS 'The date on which this record was created in the database';
COMMENT ON COLUMN CCD_TGT_SPP_OTHER.CREATED_BY IS 'The Oracle username of the person creating this record in the database';	
COMMENT ON COLUMN CCD_TGT_SPP_OTHER.LAST_MOD_DATE IS 'The last date on which any of the data in this record was changed';
COMMENT ON COLUMN CCD_TGT_SPP_OTHER.LAST_MOD_BY IS 'The Oracle username of the person making the most recent change to this record';




ALTER TABLE CCD_SVY_TYPES ADD (CREATE_DATE DATE );
ALTER TABLE CCD_SVY_TYPES
ADD (CREATED_BY VARCHAR2(30) );
ALTER TABLE CCD_SVY_TYPES
ADD (LAST_MOD_DATE DATE );

ALTER TABLE CCD_SVY_TYPES
ADD (LAST_MOD_BY VARCHAR2(30) );
COMMENT ON COLUMN CCD_SVY_TYPES.CREATE_DATE IS 'The date on which this record was created in the database';
COMMENT ON COLUMN CCD_SVY_TYPES.CREATED_BY IS 'The Oracle username of the person creating this record in the database';
COMMENT ON COLUMN CCD_SVY_TYPES.LAST_MOD_DATE IS 'The last date on which any of the data in this record was changed';
COMMENT ON COLUMN CCD_SVY_TYPES.LAST_MOD_BY IS 'The Oracle username of the person making the most recent change to this record';
COMMENT ON TABLE CCD_SVY_TYPES IS 'Survey Types

This table stores the different survey types for a given cruise  (referred to as Survey Instance in FINSS) based on the FINSS system';




ALTER TABLE CCD_SCI_CENTERS ADD (CREATE_DATE DATE );
ALTER TABLE CCD_SCI_CENTERS
ADD (CREATED_BY VARCHAR2(30) );
ALTER TABLE CCD_SCI_CENTERS
ADD (LAST_MOD_DATE DATE );

ALTER TABLE CCD_SCI_CENTERS
ADD (LAST_MOD_BY VARCHAR2(30) );
COMMENT ON COLUMN CCD_SCI_CENTERS.CREATE_DATE IS 'The date on which this record was created in the database';
COMMENT ON COLUMN CCD_SCI_CENTERS.CREATED_BY IS 'The Oracle username of the person creating this record in the database';
COMMENT ON COLUMN CCD_SCI_CENTERS.LAST_MOD_DATE IS 'The last date on which any of the data in this record was changed';
COMMENT ON COLUMN CCD_SCI_CENTERS.LAST_MOD_BY IS 'The Oracle username of the person making the most recent change to this record';


--define sequences:
CREATE SEQUENCE CCD_PLAT_TYPES_SEQ INCREMENT BY 1 START WITH 1;
CREATE SEQUENCE CCD_REG_ECOSYSTEMS_SEQ INCREMENT BY 1 START WITH 1;
CREATE SEQUENCE CCD_GEAR_SEQ INCREMENT BY 1 START WITH 1;
CREATE SEQUENCE CCD_STD_SVY_NAMES_SEQ INCREMENT BY 1 START WITH 1;
CREATE SEQUENCE CCD_SVY_FREQ_SEQ INCREMENT BY 1 START WITH 1;
CREATE SEQUENCE CCD_SVY_CATS_SEQ INCREMENT BY 1 START WITH 1;


CREATE SEQUENCE CCD_TGT_SPP_ESA_SEQ INCREMENT BY 1 START WITH 1;
CREATE SEQUENCE CCD_TGT_SPP_MMPA_SEQ INCREMENT BY 1 START WITH 1;
CREATE SEQUENCE CCD_TGT_SPP_FSSI_SEQ INCREMENT BY 1 START WITH 1;
CREATE SEQUENCE CCD_TGT_SPP_OTHER_SEQ INCREMENT BY 1 START WITH 1;
CREATE SEQUENCE CCD_SVY_TYPES_SEQ INCREMENT BY 1 START WITH 1;
CREATE SEQUENCE CCD_SCI_CENTERS_SEQ INCREMENT BY 1 START WITH 1;

CREATE SEQUENCE CCD_EXP_SPP_CATS_SEQ INCREMENT BY 1 START WITH 1;



create or replace TRIGGER CCD_PLAT_TYPES_AUTO_BRI
before insert on CCD_PLAT_TYPES
for each row
begin
  select CCD_PLAT_TYPES_SEQ.nextval into :new.PLAT_TYPE_ID from dual;
  :NEW.CREATE_DATE := SYSDATE;
  :NEW.CREATED_BY := nvl(v('APP_USER'),user);
end;
/
	CREATE OR REPLACE TRIGGER CCD_PLAT_TYPES_AUTO_BRU BEFORE
  UPDATE
    ON CCD_PLAT_TYPES FOR EACH ROW
    BEGIN
      :NEW.LAST_MOD_DATE := SYSDATE;
      :NEW.LAST_MOD_BY := nvl(v('APP_USER'),user);
END;
/

create or replace TRIGGER CCD_REG_ECOSYSTEMS_AUTO_BRI
before insert on CCD_REG_ECOSYSTEMS
for each row
begin
  select CCD_REG_ECOSYSTEMS_SEQ.nextval into :new.REG_ECOSYSTEM_ID from dual;
  :NEW.CREATE_DATE := SYSDATE;
  :NEW.CREATED_BY := nvl(v('APP_USER'),user);
end;
/
	CREATE OR REPLACE TRIGGER CCD_REG_ECOSYSTEMS_AUTO_BRU BEFORE
  UPDATE
    ON CCD_REG_ECOSYSTEMS FOR EACH ROW
    BEGIN
      :NEW.LAST_MOD_DATE := SYSDATE;
      :NEW.LAST_MOD_BY := nvl(v('APP_USER'),user);
END;
/


create or replace TRIGGER CCD_GEAR_AUTO_BRI
before insert on CCD_GEAR
for each row
begin
  select CCD_GEAR_SEQ.nextval into :new.GEAR_ID from dual;
  :NEW.CREATE_DATE := SYSDATE;
  :NEW.CREATED_BY := nvl(v('APP_USER'),user);
end;
/
	CREATE OR REPLACE TRIGGER CCD_GEAR_AUTO_BRU BEFORE
  UPDATE
    ON CCD_GEAR FOR EACH ROW
    BEGIN
      :NEW.LAST_MOD_DATE := SYSDATE;
      :NEW.LAST_MOD_BY := nvl(v('APP_USER'),user);
END;
/

create or replace TRIGGER CCD_STD_SVY_NAMES_AUTO_BRI
before insert on CCD_STD_SVY_NAMES
for each row
begin
  select CCD_STD_SVY_NAMES_SEQ.nextval into :new.STD_SVY_NAME_ID from dual;
  :NEW.CREATE_DATE := SYSDATE;
  :NEW.CREATED_BY := nvl(v('APP_USER'),user);
end;
/
	CREATE OR REPLACE TRIGGER CCD_STD_SVY_NAMES_AUTO_BRU BEFORE
  UPDATE
    ON CCD_STD_SVY_NAMES FOR EACH ROW
    BEGIN
      :NEW.LAST_MOD_DATE := SYSDATE;
      :NEW.LAST_MOD_BY := nvl(v('APP_USER'),user);
END;
/

create or replace TRIGGER CCD_SVY_FREQ_AUTO_BRI
before insert on CCD_SVY_FREQ
for each row
begin
  select CCD_SVY_FREQ_SEQ.nextval into :new.SVY_FREQ_ID from dual;
  :NEW.CREATE_DATE := SYSDATE;
  :NEW.CREATED_BY := nvl(v('APP_USER'),user);
end;
/
	CREATE OR REPLACE TRIGGER CCD_SVY_FREQ_AUTO_BRU BEFORE
  UPDATE
    ON CCD_SVY_FREQ FOR EACH ROW
    BEGIN
      :NEW.LAST_MOD_DATE := SYSDATE;
      :NEW.LAST_MOD_BY := nvl(v('APP_USER'),user);
END;
/


create or replace TRIGGER CCD_SVY_CATS_AUTO_BRI
before insert on CCD_SVY_CATS
for each row
begin
  select CCD_SVY_CATS_SEQ.nextval into :new.SVY_CAT_ID from dual;
  :NEW.CREATE_DATE := SYSDATE;
  :NEW.CREATED_BY := nvl(v('APP_USER'),user);
end;
/
CREATE OR REPLACE TRIGGER CCD_SVY_CATS_AUTO_BRU BEFORE
  UPDATE
    ON CCD_SVY_CATS FOR EACH ROW
    BEGIN
      :NEW.LAST_MOD_DATE := SYSDATE;
      :NEW.LAST_MOD_BY := nvl(v('APP_USER'),user);
END;
/



create or replace TRIGGER CCD_TGT_SPP_ESA_AUTO_BRI
before insert on CCD_TGT_SPP_ESA
for each row
begin
  select CCD_TGT_SPP_ESA_SEQ.nextval into :new.TGT_SPP_ESA_ID from dual;
  :NEW.CREATE_DATE := SYSDATE;
  :NEW.CREATED_BY := nvl(v('APP_USER'),user);
end;
/
	CREATE OR REPLACE TRIGGER CCD_TGT_SPP_ESA_AUTO_BRU BEFORE
  UPDATE
    ON CCD_TGT_SPP_ESA FOR EACH ROW
    BEGIN
      :NEW.LAST_MOD_DATE := SYSDATE;
      :NEW.LAST_MOD_BY := nvl(v('APP_USER'),user);
END;
/

create or replace TRIGGER CCD_TGT_SPP_MMPA_AUTO_BRI
before insert on CCD_TGT_SPP_MMPA
for each row
begin
  select CCD_TGT_SPP_MMPA_SEQ.nextval into :new.TGT_SPP_MMPA_ID from dual;
  :NEW.CREATE_DATE := SYSDATE;
  :NEW.CREATED_BY := nvl(v('APP_USER'),user);
end;
/
	CREATE OR REPLACE TRIGGER CCD_TGT_SPP_MMPA_AUTO_BRU BEFORE
  UPDATE
    ON CCD_TGT_SPP_MMPA FOR EACH ROW
    BEGIN
      :NEW.LAST_MOD_DATE := SYSDATE;
      :NEW.LAST_MOD_BY := nvl(v('APP_USER'),user);
END;
/

create or replace TRIGGER CCD_TGT_SPP_FSSI_AUTO_BRI
before insert on CCD_TGT_SPP_FSSI
for each row
begin
  select CCD_TGT_SPP_FSSI_SEQ.nextval into :new.TGT_SPP_FSSI_ID from dual;
  :NEW.CREATE_DATE := SYSDATE;
  :NEW.CREATED_BY := nvl(v('APP_USER'),user);
end;
/
	CREATE OR REPLACE TRIGGER CCD_TGT_SPP_FSSI_AUTO_BRU BEFORE
  UPDATE
    ON CCD_TGT_SPP_FSSI FOR EACH ROW
    BEGIN
      :NEW.LAST_MOD_DATE := SYSDATE;
      :NEW.LAST_MOD_BY := nvl(v('APP_USER'),user);
END;
/

create or replace TRIGGER CCD_TGT_SPP_OTHER_AUTO_BRI
before insert on CCD_TGT_SPP_OTHER
for each row
begin
  select CCD_TGT_SPP_OTHER_SEQ.nextval into :new.TGT_SPP_OTHER_ID from dual;
  :NEW.CREATE_DATE := SYSDATE;
  :NEW.CREATED_BY := nvl(v('APP_USER'),user);
end;
/
	CREATE OR REPLACE TRIGGER CCD_TGT_SPP_OTHER_AUTO_BRU BEFORE
  UPDATE
    ON CCD_TGT_SPP_OTHER FOR EACH ROW
    BEGIN
      :NEW.LAST_MOD_DATE := SYSDATE;
      :NEW.LAST_MOD_BY := nvl(v('APP_USER'),user);
END;
/




create or replace TRIGGER CCD_SVY_TYPES_AUTO_BRI
before insert on CCD_SVY_TYPES
for each row
begin
  select CCD_SVY_TYPES_SEQ.nextval into :new.SVY_TYPE_ID from dual;
  :NEW.CREATE_DATE := SYSDATE;
  :NEW.CREATED_BY := nvl(v('APP_USER'),user);
end;
/
CREATE OR REPLACE TRIGGER CCD_SVY_TYPES_AUTO_BRU BEFORE
  UPDATE
    ON CCD_SVY_TYPES FOR EACH ROW
    BEGIN
      :NEW.LAST_MOD_DATE := SYSDATE;
      :NEW.LAST_MOD_BY := nvl(v('APP_USER'),user);
END;
/

create or replace TRIGGER CCD_SCI_CENTERS_AUTO_BRI
before insert on CCD_SCI_CENTERS
for each row
begin
  select CCD_SCI_CENTERS_SEQ.nextval into :new.SCI_CENTER_ID from dual;
  :NEW.CREATE_DATE := SYSDATE;
  :NEW.CREATED_BY := nvl(v('APP_USER'),user);
end;
/
CREATE OR REPLACE TRIGGER CCD_SCI_CENTERS_AUTO_BRU BEFORE
  UPDATE
    ON CCD_SCI_CENTERS FOR EACH ROW
    BEGIN
      :NEW.LAST_MOD_DATE := SYSDATE;
      :NEW.LAST_MOD_BY := nvl(v('APP_USER'),user);
END;
/






create or replace TRIGGER CCD_EXP_SPP_CATS_AUTO_BRI
before insert on CCD_EXP_SPP_CATS
for each row
begin
  select CCD_EXP_SPP_CATS_SEQ.nextval into :new.EXP_SPP_CAT_ID from dual;
  :NEW.CREATE_DATE := SYSDATE;
  :NEW.CREATED_BY := nvl(v('APP_USER'),user);
end;
/
	CREATE OR REPLACE TRIGGER CCD_EXP_SPP_CATS_AUTO_BRU BEFORE
  UPDATE
    ON CCD_EXP_SPP_CATS FOR EACH ROW
    BEGIN
      :NEW.LAST_MOD_DATE := SYSDATE;
      :NEW.LAST_MOD_BY := nvl(v('APP_USER'),user);
END;
/



--modify the core cruise data model based on FINSS relationships:

ALTER TABLE CCD_CRUISES
DROP CONSTRAINT CCD_CRUISES_FK1;

ALTER TABLE CCD_CRUISES
DROP COLUMN VESSEL_ID;





ALTER TABLE CCD_CRUISE_LEGS
ADD (VESSEL_ID NUMBER NOT NULL);

CREATE INDEX CCD_CRUISE_LEGS_I2 ON CCD_CRUISE_LEGS (VESSEL_ID);

ALTER TABLE CCD_CRUISE_LEGS
ADD CONSTRAINT CCD_CRUISE_LEGS_FK2 FOREIGN KEY
(
  VESSEL_ID
)
REFERENCES CCD_VESSELS
(
  VESSEL_ID
)
ENABLE;

COMMENT ON COLUMN CCD_CRUISE_LEGS.VESSEL_ID IS 'Foreign key reference to the CCD_VESSELS table for the cruise leg''s vessel';




ALTER TABLE CCD_CRUISES
ADD (SCI_CENTER_ID NUMBER NOT NULL);

ALTER TABLE CCD_CRUISES
ADD (STD_SVY_NAME_ID NUMBER);

ALTER TABLE CCD_CRUISES
ADD (SVY_FREQ_ID NUMBER);

CREATE INDEX CCD_CRUISES_I1 ON CCD_CRUISES (SCI_CENTER_ID);

CREATE INDEX CCD_CRUISES_I2 ON CCD_CRUISES (STD_SVY_NAME_ID);

CREATE INDEX CCD_CRUISES_I3 ON CCD_CRUISES (SVY_FREQ_ID);

COMMENT ON COLUMN CCD_CRUISES.SCI_CENTER_ID IS 'The Science Center Responsible for the given Cruise';

COMMENT ON COLUMN CCD_CRUISES.STD_SVY_NAME_ID IS 'Standard Survey Name defined by NMFS';

COMMENT ON COLUMN CCD_CRUISES.SVY_FREQ_ID IS 'Frequency of the given cruise';



ALTER TABLE CCD_CRUISES
ADD (CRUISE_URL VARCHAR2(500) NOT NULL);

COMMENT ON COLUMN CCD_CRUISES.CRUISE_URL IS 'The Cruise URL (Referred to as "Survey URL" in FINSS System) for the given Cruise';

ALTER TABLE CCD_CRUISES
ADD (CRUISE_CONT_EMAIL VARCHAR2(200) NOT NULL);

COMMENT ON COLUMN CCD_CRUISES.CRUISE_CONT_EMAIL IS 'The Cruise Contact Email (Referred to as "Survey Contact Email" in FINSS System) for the given Cruise';





ALTER TABLE CCD_CRUISES
ADD (STD_SVY_NAME_OTH VARCHAR2(500) );

COMMENT ON COLUMN CCD_CRUISES.STD_SVY_NAME_OTH IS 'Field defines a Standard Survey Name that is not included in the Standard Survey Name table';


ALTER TABLE CCD_CRUISES
ADD CONSTRAINT CCD_CRUISES_FK1 FOREIGN KEY
(
  SCI_CENTER_ID
)
REFERENCES CCD_SCI_CENTERS
(
  SCI_CENTER_ID
)
ENABLE;

ALTER TABLE CCD_CRUISES
ADD CONSTRAINT CCD_CRUISES_FK2 FOREIGN KEY
(
  STD_SVY_NAME_ID
)
REFERENCES CCD_STD_SVY_NAMES
(
  STD_SVY_NAME_ID
)
ENABLE;

ALTER TABLE CCD_CRUISES
ADD CONSTRAINT CCD_CRUISES_FK3 FOREIGN KEY
(
  SVY_FREQ_ID
)
REFERENCES CCD_SVY_FREQ
(
  SVY_FREQ_ID
)
ENABLE;


ALTER TABLE CCD_VESSELS
ADD (FINSS_ID NUMBER);


COMMENT ON COLUMN CCD_VESSELS.FINSS_ID IS 'The ID value from the FINSS system';




ALTER TABLE CCD_CRUISE_LEGS
ADD (PLAT_TYPE_ID NUMBER NOT NULL);

CREATE INDEX CCD_CRUISE_LEGS_I3 ON CCD_CRUISE_LEGS (PLAT_TYPE_ID);

ALTER TABLE CCD_CRUISE_LEGS
ADD CONSTRAINT CCD_CRUISE_LEGS_FK3 FOREIGN KEY
(
  PLAT_TYPE_ID
)
REFERENCES CCD_PLAT_TYPES
(
  PLAT_TYPE_ID
)
ENABLE;

COMMENT ON COLUMN CCD_CRUISE_LEGS.PLAT_TYPE_ID IS 'Platform Type for the given research cruise leg';


--define the many-to-many relationships (intersection tables)

CREATE TABLE CCD_CRUISE_SVY_CATS
(
  CRUISE_SVY_CAT_ID NUMBER NOT NULL
, CRUISE_ID NUMBER NOT NULL
, SVY_CAT_ID NUMBER NOT NULL
, PRIMARY_YN CHAR(1) NOT NULL
, CRUISE_SVY_CAT_NOTES VARCHAR2(500)
, CONSTRAINT CCD_CRUISE_SVY_CATS_PK PRIMARY KEY
  (
    CRUISE_SVY_CAT_ID
  )
  ENABLE
);

CREATE INDEX CCD_CRUISE_SVY_CATS_I1 ON CCD_CRUISE_SVY_CATS (CRUISE_ID);

CREATE INDEX CCD_CRUISE_SVY_CATS_I2 ON CCD_CRUISE_SVY_CATS (SVY_CAT_ID);

ALTER TABLE CCD_CRUISE_SVY_CATS
ADD CONSTRAINT CCD_CRUISE_SVY_CATS_FK1 FOREIGN KEY
(
  CRUISE_ID
)
REFERENCES CCD_CRUISES
(
  CRUISE_ID
)
ENABLE;

ALTER TABLE CCD_CRUISE_SVY_CATS
ADD CONSTRAINT CCD_CRUISE_SVY_CATS_FK2 FOREIGN KEY
(
  SVY_CAT_ID
)
REFERENCES CCD_SVY_CATS
(
  SVY_CAT_ID
)
ENABLE;

COMMENT ON COLUMN CCD_CRUISE_SVY_CATS.CRUISE_SVY_CAT_ID IS 'Primary key for the CCD_CRUISE_SVY_CATS table';

COMMENT ON COLUMN CCD_CRUISE_SVY_CATS.CRUISE_ID IS 'The cruise the given survey category is associated with';

COMMENT ON COLUMN CCD_CRUISE_SVY_CATS.SVY_CAT_ID IS 'The survey category the given cruise is associated with';

COMMENT ON COLUMN CCD_CRUISE_SVY_CATS.PRIMARY_YN IS 'Boolean field to indicate if this is a primary survey category (Y) or a secondary survey category (N)';

COMMENT ON COLUMN CCD_CRUISE_SVY_CATS.CRUISE_SVY_CAT_NOTES IS 'Notes associated with the given Cruise Survey Category';

COMMENT ON TABLE CCD_CRUISE_SVY_CATS IS 'Cruise Survey Categories

This intersection table defines the many-to-many relationship between a given cruise and the associated survey categories.  If a given record has a PRIMARY_YN value of "Y" it is a primary survey category and if it has a value of "N" it is a secondary survey category';















CREATE TABLE CCD_CRUISE_SPP_ESA
(
  CRUISE_SPP_ESA_ID NUMBER NOT NULL
, CRUISE_ID NUMBER NOT NULL
, TGT_SPP_ESA_ID NUMBER NOT NULL
, CRUISE_SPP_ESA_NOTES VARCHAR2(500)
, CONSTRAINT CCD_CRUISE_SPP_ESA_PK PRIMARY KEY
  (
    CRUISE_SPP_ESA_ID
  )
  ENABLE
);

CREATE INDEX CCD_CRUISE_SPP_ESA_I1 ON CCD_CRUISE_SPP_ESA (CRUISE_ID);

CREATE INDEX CCD_CRUISE_SPP_ESA_I2 ON CCD_CRUISE_SPP_ESA (TGT_SPP_ESA_ID);

ALTER TABLE CCD_CRUISE_SPP_ESA
ADD CONSTRAINT CCD_CRUISE_SPP_ESA_FK1 FOREIGN KEY
(
  CRUISE_ID
)
REFERENCES CCD_CRUISES
(
  CRUISE_ID
)
ENABLE;

ALTER TABLE CCD_CRUISE_SPP_ESA
ADD CONSTRAINT CCD_CRUISE_SPP_ESA_FK2 FOREIGN KEY
(
  TGT_SPP_ESA_ID
)
REFERENCES CCD_TGT_SPP_ESA
(
  TGT_SPP_ESA_ID
)
ENABLE;

COMMENT ON COLUMN CCD_CRUISE_SPP_ESA.CRUISE_SPP_ESA_ID IS 'Primary key for the CCD_CRUISE_SPP_ESA table';

COMMENT ON COLUMN CCD_CRUISE_SPP_ESA.CRUISE_ID IS 'The cruise the given ESA Target Species is associated with';

COMMENT ON COLUMN CCD_CRUISE_SPP_ESA.TGT_SPP_ESA_ID IS 'The ESA Target Species the given cruise is associated with';

COMMENT ON COLUMN CCD_CRUISE_SPP_ESA.CRUISE_SPP_ESA_NOTES IS 'Notes associated with the given Cruise ESA Target Species';

COMMENT ON TABLE CCD_CRUISE_SPP_ESA IS 'Cruise Target Species - ESA

This intersection table defines the many-to-many relationship between a given cruise and the associated ESA Target Species.';








CREATE TABLE CCD_CRUISE_SPP_MMPA
(
  CRUISE_SPP_MMPA_ID NUMBER NOT NULL
, CRUISE_ID NUMBER NOT NULL
, TGT_SPP_MMPA_ID NUMBER NOT NULL
, CRUISE_SPP_MMPA_NOTES VARCHAR2(500)
, CONSTRAINT CCD_CRUISE_SPP_MMPA_PK PRIMARY KEY
  (
    CRUISE_SPP_MMPA_ID
  )
  ENABLE
);

CREATE INDEX CCD_CRUISE_SPP_MMPA_I1 ON CCD_CRUISE_SPP_MMPA (CRUISE_ID);

CREATE INDEX CCD_CRUISE_SPP_MMPA_I2 ON CCD_CRUISE_SPP_MMPA (TGT_SPP_MMPA_ID);

ALTER TABLE CCD_CRUISE_SPP_MMPA
ADD CONSTRAINT CCD_CRUISE_SPP_MMPA_FK1 FOREIGN KEY
(
  CRUISE_ID
)
REFERENCES CCD_CRUISES
(
  CRUISE_ID
)
ENABLE;

ALTER TABLE CCD_CRUISE_SPP_MMPA
ADD CONSTRAINT CCD_CRUISE_SPP_MMPA_FK2 FOREIGN KEY
(
  TGT_SPP_MMPA_ID
)
REFERENCES CCD_TGT_SPP_MMPA
(
  TGT_SPP_MMPA_ID
)
ENABLE;

COMMENT ON COLUMN CCD_CRUISE_SPP_MMPA.CRUISE_SPP_MMPA_ID IS 'Primary key for the CCD_CRUISE_SPP_MMPA table';

COMMENT ON COLUMN CCD_CRUISE_SPP_MMPA.CRUISE_ID IS 'The cruise the given MMPA Target Species is associated with';

COMMENT ON COLUMN CCD_CRUISE_SPP_MMPA.TGT_SPP_MMPA_ID IS 'The MMPA Target Species the given cruise is associated with';

COMMENT ON COLUMN CCD_CRUISE_SPP_MMPA.CRUISE_SPP_MMPA_NOTES IS 'Notes associated with the given Cruise MMPA Target Species';

COMMENT ON TABLE CCD_CRUISE_SPP_MMPA IS 'Cruise Target Species - MMPA

This intersection table defines the many-to-many relationship between a given cruise and the associated MMPA Target Species.';






CREATE TABLE CCD_CRUISE_SPP_FSSI
(
  CRUISE_SPP_FSSI_ID NUMBER NOT NULL
, CRUISE_ID NUMBER NOT NULL
, TGT_SPP_FSSI_ID NUMBER NOT NULL
, CRUISE_SPP_FSSI_NOTES VARCHAR2(500)
, CONSTRAINT CCD_CRUISE_SPP_FSSI_PK PRIMARY KEY
  (
    CRUISE_SPP_FSSI_ID
  )
  ENABLE
);

CREATE INDEX CCD_CRUISE_SPP_FSSI_I1 ON CCD_CRUISE_SPP_FSSI (CRUISE_ID);

CREATE INDEX CCD_CRUISE_SPP_FSSI_I2 ON CCD_CRUISE_SPP_FSSI (TGT_SPP_FSSI_ID);

ALTER TABLE CCD_CRUISE_SPP_FSSI
ADD CONSTRAINT CCD_CRUISE_SPP_FSSI_FK1 FOREIGN KEY
(
  CRUISE_ID
)
REFERENCES CCD_CRUISES
(
  CRUISE_ID
)
ENABLE;

ALTER TABLE CCD_CRUISE_SPP_FSSI
ADD CONSTRAINT CCD_CRUISE_SPP_FSSI_FK2 FOREIGN KEY
(
  TGT_SPP_FSSI_ID
)
REFERENCES CCD_TGT_SPP_FSSI
(
  TGT_SPP_FSSI_ID
)
ENABLE;

COMMENT ON COLUMN CCD_CRUISE_SPP_FSSI.CRUISE_SPP_FSSI_ID IS 'Primary key for the CCD_CRUISE_SPP_FSSI table';

COMMENT ON COLUMN CCD_CRUISE_SPP_FSSI.CRUISE_ID IS 'The cruise the given FSSI Target Species is associated with';

COMMENT ON COLUMN CCD_CRUISE_SPP_FSSI.TGT_SPP_FSSI_ID IS 'The FSSI Target Species the given cruise is associated with';

COMMENT ON COLUMN CCD_CRUISE_SPP_FSSI.CRUISE_SPP_FSSI_NOTES IS 'Notes associated with the given Cruise FSSI Target Species';

COMMENT ON TABLE CCD_CRUISE_SPP_FSSI IS 'Cruise Target Species - FSSI

This intersection table defines the many-to-many relationship between a given cruise and the associated FSSI Target Species.';






CREATE TABLE CCD_CRUISE_EXP_SPP
(
  CRUISE_EXP_SPP_ID NUMBER NOT NULL
, CRUISE_ID NUMBER NOT NULL
, EXP_SPP_CAT_ID NUMBER NOT NULL
, CRUISE_EXP_SPP_NOTES VARCHAR2(500)
, CONSTRAINT CCD_CRUISE_EXP_SPP_PK PRIMARY KEY
  (
    CRUISE_EXP_SPP_ID
  )
  ENABLE
);

CREATE INDEX CCD_CRUISE_EXP_SPP_I1 ON CCD_CRUISE_EXP_SPP (CRUISE_ID);

CREATE INDEX CCD_CRUISE_EXP_SPP_I2 ON CCD_CRUISE_EXP_SPP (EXP_SPP_CAT_ID);

ALTER TABLE CCD_CRUISE_EXP_SPP
ADD CONSTRAINT CCD_CRUISE_EXP_SPP_FK1 FOREIGN KEY
(
  CRUISE_ID
)
REFERENCES CCD_CRUISES
(
  CRUISE_ID
)
ENABLE;

ALTER TABLE CCD_CRUISE_EXP_SPP
ADD CONSTRAINT CCD_CRUISE_EXP_SPP_FK2 FOREIGN KEY
(
  EXP_SPP_CAT_ID
)
REFERENCES CCD_EXP_SPP_CATS
(
  EXP_SPP_CAT_ID
)
ENABLE;

COMMENT ON COLUMN CCD_CRUISE_EXP_SPP.CRUISE_EXP_SPP_ID IS 'Primary key for the CCD_CRS_EXP_SPP_CATS table';

COMMENT ON COLUMN CCD_CRUISE_EXP_SPP.CRUISE_ID IS 'The cruise the given Expected Species Categories is associated with';

COMMENT ON COLUMN CCD_CRUISE_EXP_SPP.EXP_SPP_CAT_ID IS 'The Expected Species Categories the given cruise is associated with';

COMMENT ON COLUMN CCD_CRUISE_EXP_SPP.CRUISE_EXP_SPP_NOTES IS 'Notes associated with the given Cruise''s Expected Species Categories';

COMMENT ON TABLE CCD_CRUISE_EXP_SPP IS 'Cruise Expected Species Categories

This intersection table defines the many-to-many relationship between a given cruise and the associated Expected Species Categories.';


--define intersection table sequences:
CREATE SEQUENCE CCD_CRUISE_SVY_CATS_SEQ INCREMENT BY 1 START WITH 1;
CREATE SEQUENCE CCD_CRUISE_SPP_ESA_SEQ INCREMENT BY 1 START WITH 1;
CREATE SEQUENCE CCD_CRUISE_SPP_MMPA_SEQ INCREMENT BY 1 START WITH 1;
CREATE SEQUENCE CCD_CRUISE_SPP_FSSI_SEQ INCREMENT BY 1 START WITH 1;
CREATE SEQUENCE CCD_CRUISE_EXP_SPP_SEQ INCREMENT BY 1 START WITH 1;



--add created by auditing fields for cruise intersection tables:
ALTER TABLE CCD_CRUISE_SVY_CATS ADD (CREATE_DATE DATE );
ALTER TABLE CCD_CRUISE_SVY_CATS
ADD (CREATED_BY VARCHAR2(30) );
ALTER TABLE CCD_CRUISE_SPP_ESA ADD (CREATE_DATE DATE );
ALTER TABLE CCD_CRUISE_SPP_ESA
ADD (CREATED_BY VARCHAR2(30) );
ALTER TABLE CCD_CRUISE_SPP_MMPA ADD (CREATE_DATE DATE );
ALTER TABLE CCD_CRUISE_SPP_MMPA
ADD (CREATED_BY VARCHAR2(30) );
ALTER TABLE CCD_CRUISE_SPP_FSSI ADD (CREATE_DATE DATE );
ALTER TABLE CCD_CRUISE_SPP_FSSI
ADD (CREATED_BY VARCHAR2(30) );
ALTER TABLE CCD_CRUISE_EXP_SPP ADD (CREATE_DATE DATE );
ALTER TABLE CCD_CRUISE_EXP_SPP
ADD (CREATED_BY VARCHAR2(30) );


COMMENT ON COLUMN CCD_CRUISE_SVY_CATS.CREATE_DATE IS 'The date on which this record was created in the database';
COMMENT ON COLUMN CCD_CRUISE_SVY_CATS.CREATED_BY IS 'The Oracle username of the person creating this record in the database';
COMMENT ON COLUMN CCD_CRUISE_SPP_ESA.CREATE_DATE IS 'The date on which this record was created in the database';
COMMENT ON COLUMN CCD_CRUISE_SPP_ESA.CREATED_BY IS 'The Oracle username of the person creating this record in the database';
COMMENT ON COLUMN CCD_CRUISE_SPP_MMPA.CREATE_DATE IS 'The date on which this record was created in the database';
COMMENT ON COLUMN CCD_CRUISE_SPP_MMPA.CREATED_BY IS 'The Oracle username of the person creating this record in the database';
COMMENT ON COLUMN CCD_CRUISE_SPP_FSSI.CREATE_DATE IS 'The date on which this record was created in the database';
COMMENT ON COLUMN CCD_CRUISE_SPP_FSSI.CREATED_BY IS 'The Oracle username of the person creating this record in the database';
COMMENT ON COLUMN CCD_CRUISE_EXP_SPP.CREATE_DATE IS 'The date on which this record was created in the database';
COMMENT ON COLUMN CCD_CRUISE_EXP_SPP.CREATED_BY IS 'The Oracle username of the person creating this record in the database';



--add insert triggers for the intersection tables with "created" auditing fields
create or replace TRIGGER CCD_CRUISE_SVY_CATS_AUTO_BRI
before insert on CCD_CRUISE_SVY_CATS
for each row
begin
  select CCD_CRUISE_SVY_CATS_SEQ.nextval into :new.CRUISE_SVY_CAT_ID from dual;
  :NEW.CREATE_DATE := SYSDATE;
  :NEW.CREATED_BY := nvl(v('APP_USER'),user);
end;
/

create or replace TRIGGER CCD_CRUISE_SPP_ESA_AUTO_BRI
before insert on CCD_CRUISE_SPP_ESA
for each row
begin
  select CCD_CRUISE_SPP_ESA_SEQ.nextval into :new.CRUISE_SPP_ESA_ID from dual;
  :NEW.CREATE_DATE := SYSDATE;
  :NEW.CREATED_BY := nvl(v('APP_USER'),user);
end;
/

create or replace TRIGGER CCD_CRUISE_SPP_MMPA_AUTO_BRI
before insert on CCD_CRUISE_SPP_MMPA
for each row
begin
  select CCD_CRUISE_SPP_MMPA_SEQ.nextval into :new.CRUISE_SPP_MMPA_ID from dual;
  :NEW.CREATE_DATE := SYSDATE;
  :NEW.CREATED_BY := nvl(v('APP_USER'),user);
end;
/

create or replace TRIGGER CCD_CRUISE_SPP_FSSI_AUTO_BRI
before insert on CCD_CRUISE_SPP_FSSI
for each row
begin
  select CCD_CRUISE_SPP_FSSI_SEQ.nextval into :new.CRUISE_SPP_FSSI_ID from dual;
  :NEW.CREATE_DATE := SYSDATE;
  :NEW.CREATED_BY := nvl(v('APP_USER'),user);
end;
/

create or replace TRIGGER CCD_CRUISE_EXP_SPP_AUTO_BRI
before insert on CCD_CRUISE_EXP_SPP
for each row
begin
  select CCD_CRUISE_EXP_SPP_SEQ.nextval into :new.CRUISE_EXP_SPP_ID from dual;
  :NEW.CREATE_DATE := SYSDATE;
  :NEW.CREATED_BY := nvl(v('APP_USER'),user);
end;
/







CREATE TABLE CCD_LEG_ECOSYSTEMS
(
  LEG_ECOSYSTEM_ID NUMBER NOT NULL
, CRUISE_LEG_ID NUMBER NOT NULL
, REG_ECOSYSTEM_ID NUMBER NOT NULL
, LEG_ECOSYSTEM_NOTES VARCHAR2(500)
, CONSTRAINT CCD_LEG_ECOSYSTEMS_PK PRIMARY KEY
  (
    LEG_ECOSYSTEM_ID
  )
  ENABLE
);

CREATE INDEX CCD_LEG_ECOSYSTEMS_I1 ON CCD_LEG_ECOSYSTEMS (CRUISE_LEG_ID);

CREATE INDEX CCD_LEG_ECOSYSTEMS_I2 ON CCD_LEG_ECOSYSTEMS (REG_ECOSYSTEM_ID);

ALTER TABLE CCD_LEG_ECOSYSTEMS
ADD CONSTRAINT CCD_LEG_ECOSYSTEMS_FK1 FOREIGN KEY
(
  CRUISE_LEG_ID
)
REFERENCES CCD_CRUISE_LEGS
(
  CRUISE_LEG_ID
)
ENABLE;

ALTER TABLE CCD_LEG_ECOSYSTEMS
ADD CONSTRAINT CCD_LEG_ECOSYSTEMS_FK2 FOREIGN KEY
(
  REG_ECOSYSTEM_ID
)
REFERENCES CCD_REG_ECOSYSTEMS
(
  REG_ECOSYSTEM_ID
)
ENABLE;

COMMENT ON COLUMN CCD_LEG_ECOSYSTEMS.LEG_ECOSYSTEM_ID IS 'Primary key for the CCD_LEG_ECOSYSTEMS table';

COMMENT ON COLUMN CCD_LEG_ECOSYSTEMS.CRUISE_LEG_ID IS 'The cruise leg the regional ecosystem is associated with';

COMMENT ON COLUMN CCD_LEG_ECOSYSTEMS.REG_ECOSYSTEM_ID IS 'The regional ecosystem the given cruise leg is associated with';

COMMENT ON COLUMN CCD_LEG_ECOSYSTEMS.LEG_ECOSYSTEM_NOTES IS 'Notes associated with the given Cruise Leg''s regional ecosystems';

COMMENT ON TABLE CCD_LEG_ECOSYSTEMS IS 'Cruise Leg Regional Ecosystems

This intersection table defines the many-to-many relationship between a given cruise leg and the associated regional ecosystems.';













CREATE TABLE CCD_LEG_GEAR
(
  LEG_GEAR_ID NUMBER NOT NULL
, CRUISE_LEG_ID NUMBER NOT NULL
, GEAR_ID NUMBER NOT NULL
, LEG_GEAR_NOTES VARCHAR2(500)
, CONSTRAINT CCD_LEG_GEAR_PK PRIMARY KEY
  (
    LEG_GEAR_ID
  )
  ENABLE
);

CREATE INDEX CCD_LEG_GEAR_I1 ON CCD_LEG_GEAR (CRUISE_LEG_ID);

CREATE INDEX CCD_LEG_GEAR_I2 ON CCD_LEG_GEAR (GEAR_ID);

ALTER TABLE CCD_LEG_GEAR
ADD CONSTRAINT CCD_LEG_GEAR_FK1 FOREIGN KEY
(
  CRUISE_LEG_ID
)
REFERENCES CCD_CRUISE_LEGS
(
  CRUISE_LEG_ID
)
ENABLE;

ALTER TABLE CCD_LEG_GEAR
ADD CONSTRAINT CCD_LEG_GEAR_FK2 FOREIGN KEY
(
  GEAR_ID
)
REFERENCES CCD_GEAR
(
  GEAR_ID
)
ENABLE;

COMMENT ON COLUMN CCD_LEG_GEAR.LEG_GEAR_ID IS 'Primary key for the CCD_LEG_GEAR table';

COMMENT ON COLUMN CCD_LEG_GEAR.CRUISE_LEG_ID IS 'The cruise leg the gear is associated with';

COMMENT ON COLUMN CCD_LEG_GEAR.GEAR_ID IS 'The gear the given cruise leg is associated with';

COMMENT ON COLUMN CCD_LEG_GEAR.LEG_GEAR_NOTES IS 'Notes associated with the given Cruise Leg''s gear';

COMMENT ON TABLE CCD_LEG_GEAR IS 'Cruise Leg Gear

This intersection table defines the many-to-many relationship between a given cruise leg and the associated gear used during the cruise leg.';



CREATE SEQUENCE CCD_LEG_GEAR_SEQ INCREMENT BY 1 START WITH 1;
CREATE SEQUENCE CCD_LEG_ECOSYSTEMS_SEQ INCREMENT BY 1 START WITH 1;

ALTER TABLE CCD_LEG_GEAR ADD (CREATE_DATE DATE );
ALTER TABLE CCD_LEG_GEAR
ADD (CREATED_BY VARCHAR2(30) );
ALTER TABLE CCD_LEG_ECOSYSTEMS ADD (CREATE_DATE DATE );
ALTER TABLE CCD_LEG_ECOSYSTEMS
ADD (CREATED_BY VARCHAR2(30) );

COMMENT ON COLUMN CCD_LEG_GEAR.CREATE_DATE IS 'The date on which this record was created in the database';
COMMENT ON COLUMN CCD_LEG_GEAR.CREATED_BY IS 'The Oracle username of the person creating this record in the database';
COMMENT ON COLUMN CCD_LEG_ECOSYSTEMS.CREATE_DATE IS 'The date on which this record was created in the database';
COMMENT ON COLUMN CCD_LEG_ECOSYSTEMS.CREATED_BY IS 'The Oracle username of the person creating this record in the database';


create or replace TRIGGER CCD_LEG_GEAR_AUTO_BRI
before insert on CCD_LEG_GEAR
for each row
begin
  select CCD_LEG_GEAR_SEQ.nextval into :new.LEG_GEAR_ID from dual;
  :NEW.CREATE_DATE := SYSDATE;
  :NEW.CREATED_BY := nvl(v('APP_USER'),user);
end;
/

create or replace TRIGGER CCD_LEG_ECOSYSTEMS_AUTO_BRI
before insert on CCD_LEG_ECOSYSTEMS
for each row
begin
  select CCD_LEG_ECOSYSTEMS_SEQ.nextval into :new.LEG_ECOSYSTEM_ID from dual;
  :NEW.CREATE_DATE := SYSDATE;
  :NEW.CREATED_BY := nvl(v('APP_USER'),user);
end;
/



--add unique constraints to all intersection tables:

ALTER TABLE CCD_CRUISE_SPP_ESA
ADD CONSTRAINT CCD_CRUISE_SPP_ESA_U1 UNIQUE
(
  CRUISE_ID
, TGT_SPP_ESA_ID
)
ENABLE;

ALTER TABLE CCD_CRUISE_SPP_FSSI
ADD CONSTRAINT CCD_CRUISE_SPP_FSSI_U1 UNIQUE
(
  CRUISE_ID
, TGT_SPP_FSSI_ID
)
ENABLE;



ALTER TABLE CCD_CRUISE_SPP_MMPA
ADD CONSTRAINT CCD_CRUISE_SPP_MMPA_U1 UNIQUE
(
  CRUISE_ID
, TGT_SPP_MMPA_ID
)
ENABLE;



ALTER TABLE CCD_CRUISE_SVY_CATS
ADD CONSTRAINT CCD_CRUISE_SVY_CATS_U1 UNIQUE
(
  CRUISE_ID
, SVY_CAT_ID
)
ENABLE;



ALTER TABLE CCD_CRUISE_EXP_SPP
ADD CONSTRAINT CCD_CRUISE_EXP_SPP_U1 UNIQUE
(
  CRUISE_ID
, EXP_SPP_CAT_ID
)
ENABLE;


ALTER TABLE CCD_LEG_ECOSYSTEMS
ADD CONSTRAINT CCD_LEG_ECOSYSTEMS_U1 UNIQUE
(
  CRUISE_LEG_ID
, REG_ECOSYSTEM_ID
)
ENABLE;


ALTER TABLE CCD_LEG_GEAR
ADD CONSTRAINT CCD_LEG_GEAR_U1 UNIQUE
(
  CRUISE_LEG_ID
, GEAR_ID
)
ENABLE;






CREATE OR REPLACE VIEW CCD_LEG_V
AS SELECT
CCD_CRUISE_LEGS.CRUISE_LEG_ID,
CCD_CRUISE_LEGS.LEG_NAME,
CCD_CRUISE_LEGS.LEG_START_DATE,
TO_CHAR(LEG_START_DATE, 'MM/DD/YYYY') FORMAT_LEG_START_DATE,
CCD_CRUISE_LEGS.LEG_END_DATE,
TO_CHAR(LEG_END_DATE, 'MM/DD/YYYY') FORMAT_LEG_END_DATE,
(LEG_END_DATE - LEG_START_DATE + 1) LEG_DAS,

TO_CHAR(LEG_START_DATE, 'YYYY') LEG_YEAR,
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
COMMENT ON COLUMN CCD_LEG_V.LEG_START_DATE IS 'The start date for the given research cruise leg';
COMMENT ON COLUMN CCD_LEG_V.FORMAT_LEG_START_DATE IS 'The start date for the given research cruise leg in MM/DD/YYYY format';
COMMENT ON COLUMN CCD_LEG_V.LEG_END_DATE IS 'The end date for the given research cruise leg';
COMMENT ON COLUMN CCD_LEG_V.FORMAT_LEG_END_DATE IS 'The end date for the given research cruise leg in MM/DD/YYYY format';

COMMENT ON COLUMN CCD_LEG_V.LEG_DAS IS 'The number of days at sea for the given research cruise leg';

COMMENT ON COLUMN CCD_LEG_V.LEG_YEAR IS 'The calendar year for the start date of the given research cruise leg';
COMMENT ON COLUMN CCD_LEG_V.LEG_FISC_YEAR IS 'The NOAA fiscal year for the start date of the given research cruise leg';
COMMENT ON COLUMN CCD_LEG_V.LEG_DESC IS 'The description for the given research cruise leg';
COMMENT ON COLUMN CCD_LEG_V.CRUISE_ID IS 'The cruise for the given research cruise leg';


COMMENT ON COLUMN CCD_LEG_V.VESSEL_ID IS 'Foreign key reference to the CCD_VESSELS table for the cruise leg''s vessel';
COMMENT ON COLUMN CCD_LEG_V.VESSEL_NAME IS 'Name of the given research vessel';
COMMENT ON COLUMN CCD_LEG_V.VESSEL_DESC IS 'Description for the given research vessel';
COMMENT ON COLUMN CCD_LEG_V.PLAT_TYPE_ID IS 'Platform Type for the given research cruise leg';
COMMENT ON COLUMN CCD_LEG_V.PLAT_TYPE_NAME IS 'Name of the given Platform Type';
COMMENT ON COLUMN CCD_LEG_V.PLAT_TYPE_DESC IS 'Description for the given Platform Type';




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
LEG_GEAR_DELIM.NUM_GEAR,
LEG_GEAR_DELIM.GEAR_NAME_CD_LIST,
LEG_GEAR_DELIM.GEAR_NAME_SCD_LIST,
LEG_REGION_DELIM.NUM_REGIONS,
LEG_REGION_DELIM.REGION_CODE_CD_LIST,
LEG_REGION_DELIM.REGION_CODE_SCD_LIST,
LEG_REGION_DELIM.REGION_NAME_CD_LIST,
LEG_REGION_DELIM.REGION_NAME_SCD_LIST,
LEG_ALIAS_DELIM.NUM_LEG_ALIASES,
LEG_ALIAS_DELIM.LEG_ALIAS_CD_LIST,
LEG_ALIAS_DELIM.LEG_ALIAS_SCD_LIST



FROM CCD_LEG_V

LEFT JOIN
(SELECT CRUISE_LEG_ID,
 count(*) NUM_REG_ECOSYSTEMS,
LISTAGG(REG_ECOSYSTEM_NAME, ', ') WITHIN GROUP (ORDER BY UPPER(REG_ECOSYSTEM_NAME)) as REG_ECOSYSTEM_CD_LIST,
LISTAGG(REG_ECOSYSTEM_NAME, '; ') WITHIN GROUP (ORDER BY UPPER(REG_ECOSYSTEM_NAME)) as REG_ECOSYSTEM_SCD_LIST

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
LISTAGG(GEAR_NAME, '; ') WITHIN GROUP (ORDER BY UPPER(GEAR_NAME)) as GEAR_NAME_SCD_LIST

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
LISTAGG(REGION_NAME, ', ') WITHIN GROUP (ORDER BY UPPER(REGION_NAME)) as REGION_NAME_CD_LIST,
LISTAGG(REGION_NAME, '; ') WITHIN GROUP (ORDER BY UPPER(REGION_NAME)) as REGION_NAME_SCD_LIST

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
LISTAGG(LEG_ALIAS_NAME, '; ') WITHIN GROUP (ORDER BY UPPER(LEG_ALIAS_NAME)) as LEG_ALIAS_SCD_LIST

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

COMMENT ON COLUMN CCD_LEG_DELIM_V.NUM_GEAR IS 'The number of associated gear';
COMMENT ON COLUMN CCD_LEG_DELIM_V.GEAR_NAME_CD_LIST IS 'Comma-delimited list of gear associated with the given cruise leg';
COMMENT ON COLUMN CCD_LEG_DELIM_V.GEAR_NAME_SCD_LIST IS 'Semicolon-delimited list of gear associated with the given cruise leg';

COMMENT ON COLUMN CCD_LEG_DELIM_V.NUM_REGIONS IS 'The number of associated regions';
COMMENT ON COLUMN CCD_LEG_DELIM_V.REGION_CODE_CD_LIST IS 'Comma-delimited list of region codes associated with the given cruise leg';
COMMENT ON COLUMN CCD_LEG_DELIM_V.REGION_CODE_SCD_LIST IS 'Semicolon-delimited list of region codes associated with the given cruise leg';
COMMENT ON COLUMN CCD_LEG_DELIM_V.REGION_NAME_CD_LIST IS 'Comma-delimited list of region names associated with the given cruise leg';
COMMENT ON COLUMN CCD_LEG_DELIM_V.REGION_NAME_SCD_LIST IS 'Semicolon-delimited list of region names associated with the given cruise leg';

COMMENT ON COLUMN CCD_LEG_DELIM_V.NUM_LEG_ALIASES IS 'The number of associated leg aliases';
COMMENT ON COLUMN CCD_LEG_DELIM_V.LEG_ALIAS_CD_LIST IS 'Comma-delimited list of leg aliases associated with the given cruise leg';
COMMENT ON COLUMN CCD_LEG_DELIM_V.LEG_ALIAS_SCD_LIST IS 'Semicolon-delimited list of leg aliases associated with the given cruise leg';



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


COMMENT ON COLUMN CCD_CRUISE_V.LEG_NAME_DATES_CD_LIST IS 'Comma-delimited list of leg names, the associated leg dates and vessel name associated with the given cruise';
COMMENT ON COLUMN CCD_CRUISE_V.LEG_NAME_DATES_SCD_LIST IS 'Semicolon-delimited list of leg names, the associated leg dates and vessel name associated with the given cruise';
COMMENT ON COLUMN CCD_CRUISE_V.LEG_NAME_DATES_RC_LIST IS 'Return carriage/new line delimited list of leg names, the associated leg dates and vessel name associated with the given cruise';
COMMENT ON COLUMN CCD_CRUISE_V.LEG_NAME_DATES_BR_LIST IS '<BR> tag (intended for web pages) delimited list of leg names, the associated leg dates and vessel name associated with the given cruise';


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
CCD_CRUISE_V.LEG_NAME_DATES_CD_LIST,
CCD_CRUISE_V.LEG_NAME_DATES_SCD_LIST,
CCD_CRUISE_V.LEG_NAME_DATES_RC_LIST,
CCD_CRUISE_V.LEG_NAME_DATES_BR_LIST,



ESA_SPECIES_DELIM.NUM_SPP_ESA,
ESA_SPECIES_DELIM.SPP_ESA_NAME_CD_LIST,
ESA_SPECIES_DELIM.SPP_ESA_NAME_SCD_LIST,
FSSI_SPECIES_DELIM.NUM_SPP_FSSI,
FSSI_SPECIES_DELIM.SPP_FSSI_NAME_CD_LIST,
FSSI_SPECIES_DELIM.SPP_FSSI_NAME_SCD_LIST,
MMPA_SPECIES_DELIM.NUM_SPP_MMPA,
MMPA_SPECIES_DELIM.SPP_MMPA_NAME_CD_LIST,
MMPA_SPECIES_DELIM.SPP_MMPA_NAME_SCD_LIST,
SVY_PRIM_CATS_DELIM.NUM_PRIM_SVY_CATS,
SVY_PRIM_CATS_DELIM.SVY_CAT_NAME_CD_LIST PRIM_SVY_CAT_NAME_CD_LIST,
SVY_PRIM_CATS_DELIM.SVY_CAT_NAME_SCD_LIST PRIM_SVY_CAT_NAME_SCD_LIST,
SVY_SEC_CATS_DELIM.NUM_SEC_SVY_CATS,
SVY_SEC_CATS_DELIM.SVY_CAT_NAME_CD_LIST SEC_SVY_CAT_NAME_CD_LIST,
SVY_SEC_CATS_DELIM.SVY_CAT_NAME_SCD_LIST SEC_SVY_CAT_NAME_SCD_LIST,
EXP_SPECIES_DELIM.NUM_EXP_SPP,
EXP_SPECIES_DELIM.EXP_SPP_NAME_CD_LIST,
EXP_SPECIES_DELIM.EXP_SPP_NAME_SCD_LIST,
OTH_SPECIES_DELIM.NUM_SPP_OTH,
OTH_SPECIES_DELIM.OTH_SPP_CNAME_CD_LIST,
OTH_SPECIES_DELIM.OTH_SPP_CNAME_SCD_LIST,
OTH_SPECIES_DELIM.OTH_SPP_SNAME_CD_LIST,
OTH_SPECIES_DELIM.OTH_SPP_SNAME_SCD_LIST

FROM
CCD_CRUISE_V
LEFT JOIN
(SELECT CRUISE_ID,
count(*) NUM_SPP_ESA,
LISTAGG(TGT_SPP_ESA_NAME, ', ') WITHIN GROUP (ORDER BY UPPER(TGT_SPP_ESA_NAME)) as SPP_ESA_NAME_CD_LIST,
LISTAGG(TGT_SPP_ESA_NAME, '; ') WITHIN GROUP (ORDER BY UPPER(TGT_SPP_ESA_NAME)) as SPP_ESA_NAME_SCD_LIST

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
LISTAGG(TGT_SPP_FSSI_NAME, '; ') WITHIN GROUP (ORDER BY UPPER(TGT_SPP_FSSI_NAME)) as SPP_FSSI_NAME_SCD_LIST

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
LISTAGG(TGT_SPP_MMPA_NAME, '; ') WITHIN GROUP (ORDER BY UPPER(TGT_SPP_MMPA_NAME)) as SPP_MMPA_NAME_SCD_LIST

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
 LISTAGG(SVY_CAT_NAME, '; ') WITHIN GROUP (ORDER BY UPPER(SVY_CAT_NAME)) as SVY_CAT_NAME_SCD_LIST

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
 LISTAGG(SVY_CAT_NAME, '; ') WITHIN GROUP (ORDER BY UPPER(SVY_CAT_NAME)) as SVY_CAT_NAME_SCD_LIST

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
LISTAGG(EXP_SPP_CAT_NAME, '; ') WITHIN GROUP (ORDER BY UPPER(EXP_SPP_CAT_NAME)) as EXP_SPP_NAME_SCD_LIST

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
LISTAGG(TGT_SPP_OTHER_SNAME, ', ') WITHIN GROUP (ORDER BY UPPER(TGT_SPP_OTHER_SNAME)) as OTH_SPP_SNAME_CD_LIST,
LISTAGG(TGT_SPP_OTHER_SNAME, '; ') WITHIN GROUP (ORDER BY UPPER(TGT_SPP_OTHER_SNAME)) as OTH_SPP_SNAME_SCD_LIST


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
COMMENT ON COLUMN CCD_CRUISE_DELIM_V.NUM_SPP_FSSI IS 'The number of associated FSSI Species';

COMMENT ON COLUMN CCD_CRUISE_DELIM_V.SPP_FSSI_NAME_CD_LIST IS 'Comma-delimited list of FSSI Species associated with the given cruise';
COMMENT ON COLUMN CCD_CRUISE_DELIM_V.SPP_FSSI_NAME_SCD_LIST IS 'Semicolon-delimited list of FSSI Species associated with the given cruise';
COMMENT ON COLUMN CCD_CRUISE_DELIM_V.NUM_SPP_MMPA IS 'The number of associated MMPA Species';
COMMENT ON COLUMN CCD_CRUISE_DELIM_V.SPP_MMPA_NAME_CD_LIST IS 'Comma-delimited list of MMPA Species associated with the given cruise';
COMMENT ON COLUMN CCD_CRUISE_DELIM_V.SPP_MMPA_NAME_SCD_LIST IS 'Semicolon-delimited list of MMPA Species associated with the given cruise';
COMMENT ON COLUMN CCD_CRUISE_DELIM_V.NUM_PRIM_SVY_CATS IS 'The number of associated primary survey categories';
COMMENT ON COLUMN CCD_CRUISE_DELIM_V.PRIM_SVY_CAT_NAME_CD_LIST IS 'Comma-delimited list of primary survey categories associated with the given cruise';
COMMENT ON COLUMN CCD_CRUISE_DELIM_V.PRIM_SVY_CAT_NAME_SCD_LIST IS 'Semicolon-delimited list of primary survey categories associated with the given cruise';
COMMENT ON COLUMN CCD_CRUISE_DELIM_V.NUM_SEC_SVY_CATS IS 'The number of associated secondary survey categories';
COMMENT ON COLUMN CCD_CRUISE_DELIM_V.SEC_SVY_CAT_NAME_CD_LIST IS 'Comma-delimited list of secondary survey categories associated with the given cruise';
COMMENT ON COLUMN CCD_CRUISE_DELIM_V.SEC_SVY_CAT_NAME_SCD_LIST IS 'Semicolon-delimited list of secondary survey categories associated with the given cruise';
COMMENT ON COLUMN CCD_CRUISE_DELIM_V.NUM_EXP_SPP IS 'The number of associated expected species categories';
COMMENT ON COLUMN CCD_CRUISE_DELIM_V.EXP_SPP_NAME_CD_LIST IS 'Comma-delimited list of expected species categories associated with the given cruise';
COMMENT ON COLUMN CCD_CRUISE_DELIM_V.EXP_SPP_NAME_SCD_LIST IS 'Semicolon-delimited list of expected species categories associated with the given cruise';
COMMENT ON COLUMN CCD_CRUISE_DELIM_V.NUM_SPP_OTH IS 'The number of associated target species - other';
COMMENT ON COLUMN CCD_CRUISE_DELIM_V.OTH_SPP_CNAME_CD_LIST IS 'Comma-delimited list of common names for target species - other associated with the given cruise';
COMMENT ON COLUMN CCD_CRUISE_DELIM_V.OTH_SPP_CNAME_SCD_LIST IS 'Semicolon-delimited list of common names for target species - other associated with the given cruise';
COMMENT ON COLUMN CCD_CRUISE_DELIM_V.OTH_SPP_SNAME_CD_LIST IS 'Comma-delimited list of scientific names for target species - other associated with the given cruise';
COMMENT ON COLUMN CCD_CRUISE_DELIM_V.OTH_SPP_SNAME_SCD_LIST IS 'Semicolon-delimited list of scientific names for target species - other associated with the given cruise';


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


COMMENT ON COLUMN CCD_CRUISE_DELIM_V.LEG_NAME_DATES_CD_LIST IS 'Comma-delimited list of leg names, the associated leg dates and vessel name associated with the given cruise';
COMMENT ON COLUMN CCD_CRUISE_DELIM_V.LEG_NAME_DATES_SCD_LIST IS 'Semicolon-delimited list of leg names, the associated leg dates and vessel name associated with the given cruise';
COMMENT ON COLUMN CCD_CRUISE_DELIM_V.LEG_NAME_DATES_RC_LIST IS 'Return carriage/new line delimited list of leg names, the associated leg dates and vessel name associated with the given cruise';
COMMENT ON COLUMN CCD_CRUISE_DELIM_V.LEG_NAME_DATES_BR_LIST IS '<BR> tag (intended for web pages) delimited list of leg names, the associated leg dates and vessel name associated with the given cruise';






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


COMMENT ON COLUMN CCD_CRUISE_LEGS_V.LEG_NAME_DATES_CD_LIST IS 'Comma-delimited list of leg names, the associated leg dates and vessel name associated with the given cruise';
COMMENT ON COLUMN CCD_CRUISE_LEGS_V.LEG_NAME_DATES_SCD_LIST IS 'Semicolon-delimited list of leg names, the associated leg dates and vessel name associated with the given cruise';
COMMENT ON COLUMN CCD_CRUISE_LEGS_V.LEG_NAME_DATES_RC_LIST IS 'Return carriage/new line delimited list of leg names, the associated leg dates and vessel name associated with the given cruise';
COMMENT ON COLUMN CCD_CRUISE_LEGS_V.LEG_NAME_DATES_BR_LIST IS '<BR> tag (intended for web pages) delimited list of leg names, the associated leg dates and vessel name associated with the given cruise';



COMMENT ON TABLE CCD_CRUISE_LEGS_V IS 'Research Cruises and Associated Cruise Legs (View)

This query returns all research cruise legs and their associated reference tables as well as all associated cruise legs with their associated reference tables';





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
CCD_CRUISE_DELIM_V.NUM_SPP_FSSI,
CCD_CRUISE_DELIM_V.SPP_FSSI_NAME_CD_LIST,
CCD_CRUISE_DELIM_V.SPP_FSSI_NAME_SCD_LIST,
CCD_CRUISE_DELIM_V.NUM_SPP_MMPA,
CCD_CRUISE_DELIM_V.SPP_MMPA_NAME_CD_LIST,
CCD_CRUISE_DELIM_V.SPP_MMPA_NAME_SCD_LIST,
CCD_CRUISE_DELIM_V.NUM_PRIM_SVY_CATS,
CCD_CRUISE_DELIM_V.PRIM_SVY_CAT_NAME_CD_LIST,
CCD_CRUISE_DELIM_V.PRIM_SVY_CAT_NAME_SCD_LIST,
CCD_CRUISE_DELIM_V.NUM_SEC_SVY_CATS,
CCD_CRUISE_DELIM_V.SEC_SVY_CAT_NAME_CD_LIST,
CCD_CRUISE_DELIM_V.SEC_SVY_CAT_NAME_SCD_LIST,
CCD_CRUISE_DELIM_V.NUM_EXP_SPP,
CCD_CRUISE_DELIM_V.EXP_SPP_NAME_CD_LIST,
CCD_CRUISE_DELIM_V.EXP_SPP_NAME_SCD_LIST,
CCD_CRUISE_DELIM_V.NUM_SPP_OTH,
CCD_CRUISE_DELIM_V.OTH_SPP_CNAME_CD_LIST,
CCD_CRUISE_DELIM_V.OTH_SPP_CNAME_SCD_LIST,
CCD_CRUISE_DELIM_V.OTH_SPP_SNAME_CD_LIST,
CCD_CRUISE_DELIM_V.OTH_SPP_SNAME_SCD_LIST,


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

CCD_CRUISE_DELIM_V.LEG_NAME_DATES_CD_LIST,
CCD_CRUISE_DELIM_V.LEG_NAME_DATES_SCD_LIST,
CCD_CRUISE_DELIM_V.LEG_NAME_DATES_RC_LIST,
CCD_CRUISE_DELIM_V.LEG_NAME_DATES_BR_LIST,





CRUISE_REGIONS.NUM_REGIONS,
CRUISE_REGIONS.REGION_CODE_CD_LIST,
CRUISE_REGIONS.REGION_CODE_SCD_LIST,
CRUISE_REGIONS.REGION_NAME_CD_LIST,
CRUISE_REGIONS.REGION_NAME_SCD_LIST,
CRUISE_ECOSYSTEMS.NUM_ECOSYSTEMS,
CRUISE_ECOSYSTEMS.ECOSYSTEM_CD_LIST,
CRUISE_ECOSYSTEMS.ECOSYSTEM_SCD_LIST,
CRUISE_GEARS.NUM_GEAR,
CRUISE_GEARS.GEAR_CD_LIST,
CRUISE_GEARS.GEAR_SCD_LIST

FROM
CCD_CRUISE_DELIM_V



--retrieve the unique region codes/names for all associated cruise legs:
left join
(SELECT
CRUISE_ID,
LISTAGG(DIST_CRUISE_REGIONS.REGION_CODE, ', ') WITHIN GROUP (ORDER BY UPPER(DIST_CRUISE_REGIONS.REGION_CODE)) as REGION_CODE_CD_LIST,
LISTAGG(DIST_CRUISE_REGIONS.REGION_CODE, '; ') WITHIN GROUP (ORDER BY UPPER(DIST_CRUISE_REGIONS.REGION_CODE)) as REGION_CODE_SCD_LIST,
LISTAGG(DIST_CRUISE_REGIONS.REGION_NAME, ', ') WITHIN GROUP (ORDER BY UPPER(DIST_CRUISE_REGIONS.REGION_NAME)) as REGION_NAME_CD_LIST,
LISTAGG(DIST_CRUISE_REGIONS.REGION_NAME, '; ') WITHIN GROUP (ORDER BY UPPER(DIST_CRUISE_REGIONS.REGION_NAME)) as REGION_NAME_SCD_LIST,
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
CCD_CRUISE_DELIM_V.NUM_SPP_FSSI,
CCD_CRUISE_DELIM_V.SPP_FSSI_NAME_CD_LIST,
CCD_CRUISE_DELIM_V.SPP_FSSI_NAME_SCD_LIST,
CCD_CRUISE_DELIM_V.NUM_SPP_MMPA,
CCD_CRUISE_DELIM_V.SPP_MMPA_NAME_CD_LIST,
CCD_CRUISE_DELIM_V.SPP_MMPA_NAME_SCD_LIST,
CCD_CRUISE_DELIM_V.NUM_PRIM_SVY_CATS,
CCD_CRUISE_DELIM_V.PRIM_SVY_CAT_NAME_CD_LIST,
CCD_CRUISE_DELIM_V.PRIM_SVY_CAT_NAME_SCD_LIST,
CCD_CRUISE_DELIM_V.NUM_SEC_SVY_CATS,
CCD_CRUISE_DELIM_V.SEC_SVY_CAT_NAME_CD_LIST,
CCD_CRUISE_DELIM_V.SEC_SVY_CAT_NAME_SCD_LIST,
CCD_CRUISE_DELIM_V.NUM_EXP_SPP,
CCD_CRUISE_DELIM_V.EXP_SPP_NAME_CD_LIST,
CCD_CRUISE_DELIM_V.EXP_SPP_NAME_SCD_LIST,
CCD_CRUISE_DELIM_V.NUM_SPP_OTH,
CCD_CRUISE_DELIM_V.OTH_SPP_CNAME_CD_LIST,
CCD_CRUISE_DELIM_V.OTH_SPP_CNAME_SCD_LIST,
CCD_CRUISE_DELIM_V.OTH_SPP_SNAME_CD_LIST,
CCD_CRUISE_DELIM_V.OTH_SPP_SNAME_SCD_LIST,
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
CCD_CRUISE_DELIM_V.LEG_NAME_DATES_CD_LIST,
CCD_CRUISE_DELIM_V.LEG_NAME_DATES_SCD_LIST,
CCD_CRUISE_DELIM_V.LEG_NAME_DATES_RC_LIST,
CCD_CRUISE_DELIM_V.LEG_NAME_DATES_BR_LIST,




CRUISE_REGIONS.NUM_REGIONS,
CRUISE_REGIONS.REGION_CODE_CD_LIST,
CRUISE_REGIONS.REGION_CODE_SCD_LIST,
CRUISE_REGIONS.REGION_NAME_CD_LIST,
CRUISE_REGIONS.REGION_NAME_SCD_LIST,
CRUISE_ECOSYSTEMS.NUM_ECOSYSTEMS,
CRUISE_ECOSYSTEMS.ECOSYSTEM_CD_LIST,
CRUISE_ECOSYSTEMS.ECOSYSTEM_SCD_LIST,
CRUISE_GEARS.NUM_GEAR,
CRUISE_GEARS.GEAR_CD_LIST,
CRUISE_GEARS.GEAR_SCD_LIST

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

COMMENT ON COLUMN CCD_CRUISE_SUMM_V.NUM_SPP_FSSI IS 'The number of associated FSSI Species';
COMMENT ON COLUMN CCD_CRUISE_SUMM_V.SPP_FSSI_NAME_CD_LIST IS 'Comma-delimited list of FSSI Species associated with the given cruise';
COMMENT ON COLUMN CCD_CRUISE_SUMM_V.SPP_FSSI_NAME_SCD_LIST IS 'Semicolon-delimited list of FSSI Species associated with the given cruise';

COMMENT ON COLUMN CCD_CRUISE_SUMM_V.NUM_SPP_MMPA IS 'The number of associated MMPA Species';
COMMENT ON COLUMN CCD_CRUISE_SUMM_V.SPP_MMPA_NAME_CD_LIST IS 'Comma-delimited list of MMPA Species associated with the given cruise';
COMMENT ON COLUMN CCD_CRUISE_SUMM_V.SPP_MMPA_NAME_SCD_LIST IS 'Semicolon-delimited list of MMPA Species associated with the given cruise';

COMMENT ON COLUMN CCD_CRUISE_SUMM_V.NUM_PRIM_SVY_CATS IS 'The number of associated primary survey categories';
COMMENT ON COLUMN CCD_CRUISE_SUMM_V.PRIM_SVY_CAT_NAME_CD_LIST IS 'Comma-delimited list of primary survey categories associated with the given cruise';
COMMENT ON COLUMN CCD_CRUISE_SUMM_V.PRIM_SVY_CAT_NAME_SCD_LIST IS 'Semicolon-delimited list of primary survey categories associated with the given cruise';

COMMENT ON COLUMN CCD_CRUISE_SUMM_V.NUM_SEC_SVY_CATS IS 'The number of associated secondary survey categories';
COMMENT ON COLUMN CCD_CRUISE_SUMM_V.SEC_SVY_CAT_NAME_CD_LIST IS 'Comma-delimited list of secondary survey categories associated with the given cruise';
COMMENT ON COLUMN CCD_CRUISE_SUMM_V.SEC_SVY_CAT_NAME_SCD_LIST IS 'Semicolon-delimited list of secondary survey categories associated with the given cruise';

COMMENT ON COLUMN CCD_CRUISE_SUMM_V.NUM_EXP_SPP IS 'The number of associated expected species categories';
COMMENT ON COLUMN CCD_CRUISE_SUMM_V.EXP_SPP_NAME_CD_LIST IS 'Comma-delimited list of expected species categories associated with the given cruise';
COMMENT ON COLUMN CCD_CRUISE_SUMM_V.EXP_SPP_NAME_SCD_LIST IS 'Semicolon-delimited list of expected species categories associated with the given cruise';

COMMENT ON COLUMN CCD_CRUISE_SUMM_V.NUM_SPP_OTH IS 'The number of associated target species - other';
COMMENT ON COLUMN CCD_CRUISE_SUMM_V.OTH_SPP_CNAME_CD_LIST IS 'Comma-delimited list of common names for target species - other associated with the given cruise';
COMMENT ON COLUMN CCD_CRUISE_SUMM_V.OTH_SPP_CNAME_SCD_LIST IS 'Semicolon-delimited list of common names for target species - other associated with the given cruise';
COMMENT ON COLUMN CCD_CRUISE_SUMM_V.OTH_SPP_SNAME_CD_LIST IS 'Comma-delimited list of scientific names for target species - other associated with the given cruise';
COMMENT ON COLUMN CCD_CRUISE_SUMM_V.OTH_SPP_SNAME_SCD_LIST IS 'Semicolon-delimited list of scientific names for target species - other associated with the given cruise';

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

COMMENT ON COLUMN CCD_CRUISE_SUMM_V.LEG_NAME_DATES_CD_LIST IS 'Comma-delimited list of leg names, the associated leg dates and vessel name associated with the given cruise';
COMMENT ON COLUMN CCD_CRUISE_SUMM_V.LEG_NAME_DATES_SCD_LIST IS 'Semicolon-delimited list of leg names, the associated leg dates and vessel name associated with the given cruise';
COMMENT ON COLUMN CCD_CRUISE_SUMM_V.LEG_NAME_DATES_RC_LIST IS 'Return carriage/new line delimited list of leg names, the associated leg dates and vessel name associated with the given cruise';
COMMENT ON COLUMN CCD_CRUISE_SUMM_V.LEG_NAME_DATES_BR_LIST IS '<BR> tag (intended for web pages) delimited list of leg names, the associated leg dates and vessel name associated with the given cruise';



COMMENT ON COLUMN CCD_CRUISE_SUMM_V.NUM_REGIONS IS 'The number of unique regions associated with the associated cruise legs';
COMMENT ON COLUMN CCD_CRUISE_SUMM_V.REGION_CODE_CD_LIST IS 'Comma-delimited list of unique region codes associated with the given cruise leg';
COMMENT ON COLUMN CCD_CRUISE_SUMM_V.REGION_CODE_SCD_LIST IS 'Semicolon-delimited list of unique region codes associated with the given cruise leg';
COMMENT ON COLUMN CCD_CRUISE_SUMM_V.REGION_NAME_CD_LIST IS 'Comma-delimited list of unique region names associated with the given cruise leg';
COMMENT ON COLUMN CCD_CRUISE_SUMM_V.REGION_NAME_SCD_LIST IS 'Semicolon-delimited list of unique region names associated with the given cruise leg';
COMMENT ON COLUMN CCD_CRUISE_SUMM_V.NUM_ECOSYSTEMS IS 'The number of unique regional ecosystems associated with the associated cruise legs';
COMMENT ON COLUMN CCD_CRUISE_SUMM_V.ECOSYSTEM_CD_LIST IS 'Comma-delimited list of unique regional ecosystems associated with the given cruise leg';
COMMENT ON COLUMN CCD_CRUISE_SUMM_V.ECOSYSTEM_SCD_LIST IS 'Semicolon-delimited list of unique regional ecosystems associated with the given cruise leg';
COMMENT ON COLUMN CCD_CRUISE_SUMM_V.NUM_GEAR IS 'The number of unique gear associated with the associated cruise legs';
COMMENT ON COLUMN CCD_CRUISE_SUMM_V.GEAR_CD_LIST IS 'Comma-delimited list of unique gear associated with the associated cruise legs';
COMMENT ON COLUMN CCD_CRUISE_SUMM_V.GEAR_SCD_LIST IS 'Semicolon-delimited list of unique gear associated with the associated cruise legs';



DROP VIEW CCD_CRUISES_SUMM_V;
DROP VIEW CCD_CRUISES_V;


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

CCD_CRUISE_DELIM_V.LEG_NAME_DATES_CD_LIST,
CCD_CRUISE_DELIM_V.LEG_NAME_DATES_SCD_LIST,
CCD_CRUISE_DELIM_V.LEG_NAME_DATES_RC_LIST,
CCD_CRUISE_DELIM_V.LEG_NAME_DATES_BR_LIST,



CCD_CRUISE_DELIM_V.NUM_SPP_ESA,
CCD_CRUISE_DELIM_V.SPP_ESA_NAME_CD_LIST,
CCD_CRUISE_DELIM_V.SPP_ESA_NAME_SCD_LIST,
CCD_CRUISE_DELIM_V.NUM_SPP_FSSI,
CCD_CRUISE_DELIM_V.SPP_FSSI_NAME_CD_LIST,
CCD_CRUISE_DELIM_V.SPP_FSSI_NAME_SCD_LIST,
CCD_CRUISE_DELIM_V.NUM_SPP_MMPA,
CCD_CRUISE_DELIM_V.SPP_MMPA_NAME_CD_LIST,
CCD_CRUISE_DELIM_V.SPP_MMPA_NAME_SCD_LIST,
CCD_CRUISE_DELIM_V.NUM_PRIM_SVY_CATS,
CCD_CRUISE_DELIM_V.PRIM_SVY_CAT_NAME_CD_LIST,
CCD_CRUISE_DELIM_V.PRIM_SVY_CAT_NAME_SCD_LIST,
CCD_CRUISE_DELIM_V.NUM_SEC_SVY_CATS,
CCD_CRUISE_DELIM_V.SEC_SVY_CAT_NAME_CD_LIST,
CCD_CRUISE_DELIM_V.SEC_SVY_CAT_NAME_SCD_LIST,
CCD_CRUISE_DELIM_V.NUM_EXP_SPP,
CCD_CRUISE_DELIM_V.EXP_SPP_NAME_CD_LIST,
CCD_CRUISE_DELIM_V.EXP_SPP_NAME_SCD_LIST,
CCD_CRUISE_DELIM_V.NUM_SPP_OTH,
CCD_CRUISE_DELIM_V.OTH_SPP_CNAME_CD_LIST,
CCD_CRUISE_DELIM_V.OTH_SPP_CNAME_SCD_LIST,
CCD_CRUISE_DELIM_V.OTH_SPP_SNAME_CD_LIST,
CCD_CRUISE_DELIM_V.OTH_SPP_SNAME_SCD_LIST,





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
CCD_LEG_DELIM_V.NUM_GEAR,
CCD_LEG_DELIM_V.GEAR_NAME_CD_LIST,
CCD_LEG_DELIM_V.GEAR_NAME_SCD_LIST,
CCD_LEG_DELIM_V.NUM_REGIONS,
CCD_LEG_DELIM_V.REGION_CODE_CD_LIST,
CCD_LEG_DELIM_V.REGION_CODE_SCD_LIST,
CCD_LEG_DELIM_V.REGION_NAME_CD_LIST,
CCD_LEG_DELIM_V.REGION_NAME_SCD_LIST,
CCD_LEG_DELIM_V.NUM_LEG_ALIASES,
CCD_LEG_DELIM_V.LEG_ALIAS_CD_LIST,
CCD_LEG_DELIM_V.LEG_ALIAS_SCD_LIST
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
COMMENT ON COLUMN CCD_CRUISE_LEG_DELIM_V.NUM_SPP_FSSI IS 'The number of associated FSSI Species';
COMMENT ON COLUMN CCD_CRUISE_LEG_DELIM_V.SPP_FSSI_NAME_CD_LIST IS 'Comma-delimited list of FSSI Species associated with the given cruise';
COMMENT ON COLUMN CCD_CRUISE_LEG_DELIM_V.SPP_FSSI_NAME_SCD_LIST IS 'Semicolon-delimited list of FSSI Species associated with the given cruise';
COMMENT ON COLUMN CCD_CRUISE_LEG_DELIM_V.NUM_SPP_MMPA IS 'The number of associated MMPA Species';
COMMENT ON COLUMN CCD_CRUISE_LEG_DELIM_V.SPP_MMPA_NAME_CD_LIST IS 'Comma-delimited list of MMPA Species associated with the given cruise';
COMMENT ON COLUMN CCD_CRUISE_LEG_DELIM_V.SPP_MMPA_NAME_SCD_LIST IS 'Semicolon-delimited list of MMPA Species associated with the given cruise';
COMMENT ON COLUMN CCD_CRUISE_LEG_DELIM_V.NUM_PRIM_SVY_CATS IS 'The number of associated primary survey categories';
COMMENT ON COLUMN CCD_CRUISE_LEG_DELIM_V.PRIM_SVY_CAT_NAME_CD_LIST IS 'Comma-delimited list of primary survey categories associated with the given cruise';
COMMENT ON COLUMN CCD_CRUISE_LEG_DELIM_V.PRIM_SVY_CAT_NAME_SCD_LIST IS 'Semicolon-delimited list of primary survey categories associated with the given cruise';
COMMENT ON COLUMN CCD_CRUISE_LEG_DELIM_V.NUM_SEC_SVY_CATS IS 'The number of associated secondary survey categories';
COMMENT ON COLUMN CCD_CRUISE_LEG_DELIM_V.SEC_SVY_CAT_NAME_CD_LIST IS 'Comma-delimited list of secondary survey categories associated with the given cruise';
COMMENT ON COLUMN CCD_CRUISE_LEG_DELIM_V.SEC_SVY_CAT_NAME_SCD_LIST IS 'Semicolon-delimited list of secondary survey categories associated with the given cruise';
COMMENT ON COLUMN CCD_CRUISE_LEG_DELIM_V.NUM_EXP_SPP IS 'The number of associated expected species categories';
COMMENT ON COLUMN CCD_CRUISE_LEG_DELIM_V.EXP_SPP_NAME_CD_LIST IS 'Comma-delimited list of expected species categories associated with the given cruise';
COMMENT ON COLUMN CCD_CRUISE_LEG_DELIM_V.EXP_SPP_NAME_SCD_LIST IS 'Semicolon-delimited list of expected species categories associated with the given cruise';
COMMENT ON COLUMN CCD_CRUISE_LEG_DELIM_V.NUM_SPP_OTH IS 'The number of associated target species - other';
COMMENT ON COLUMN CCD_CRUISE_LEG_DELIM_V.OTH_SPP_CNAME_CD_LIST IS 'Comma-delimited list of common names for target species - other associated with the given cruise';
COMMENT ON COLUMN CCD_CRUISE_LEG_DELIM_V.OTH_SPP_CNAME_SCD_LIST IS 'Semicolon-delimited list of common names for target species - other associated with the given cruise';
COMMENT ON COLUMN CCD_CRUISE_LEG_DELIM_V.OTH_SPP_SNAME_CD_LIST IS 'Comma-delimited list of scientific names for target species - other associated with the given cruise';
COMMENT ON COLUMN CCD_CRUISE_LEG_DELIM_V.OTH_SPP_SNAME_SCD_LIST IS 'Semicolon-delimited list of scientific names for target species - other associated with the given cruise';



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
COMMENT ON COLUMN CCD_CRUISE_LEG_DELIM_V.NUM_GEAR IS 'The number of associated gear';
COMMENT ON COLUMN CCD_CRUISE_LEG_DELIM_V.GEAR_NAME_CD_LIST IS 'Comma-delimited list of gear associated with the given cruise leg';
COMMENT ON COLUMN CCD_CRUISE_LEG_DELIM_V.GEAR_NAME_SCD_LIST IS 'Semicolon-delimited list of gear associated with the given cruise leg';
COMMENT ON COLUMN CCD_CRUISE_LEG_DELIM_V.NUM_REGIONS IS 'The number of associated regions';
COMMENT ON COLUMN CCD_CRUISE_LEG_DELIM_V.REGION_CODE_CD_LIST IS 'Comma-delimited list of region codes associated with the given cruise leg';
COMMENT ON COLUMN CCD_CRUISE_LEG_DELIM_V.REGION_CODE_SCD_LIST IS 'Semicolon-delimited list of region codes associated with the given cruise leg';
COMMENT ON COLUMN CCD_CRUISE_LEG_DELIM_V.REGION_NAME_CD_LIST IS 'Comma-delimited list of region names associated with the given cruise leg';
COMMENT ON COLUMN CCD_CRUISE_LEG_DELIM_V.REGION_NAME_SCD_LIST IS 'Semicolon-delimited list of region names associated with the given cruise leg';
COMMENT ON COLUMN CCD_CRUISE_LEG_DELIM_V.NUM_LEG_ALIASES IS 'The number of associated leg aliases';
COMMENT ON COLUMN CCD_CRUISE_LEG_DELIM_V.LEG_ALIAS_CD_LIST IS 'Comma-delimited list of leg aliases associated with the given cruise leg';
COMMENT ON COLUMN CCD_CRUISE_LEG_DELIM_V.LEG_ALIAS_SCD_LIST IS 'Semicolon-delimited list of leg aliases associated with the given cruise leg';


COMMENT ON TABLE CCD_CRUISE_LEG_DELIM_V IS 'Research Cruises and Associated Legs with Delimited Reference Values (View)

This query returns all of the research cruises and their associated reference tables (e.g. Science Center, standard survey name, survey frequency, etc.) as well as the comma-/semicolon-delimited list of associated reference values (e.g. ESA species, primary survey categories, etc.) as well as all associated research cruise legs and their associated reference tables (e.g. Vessel, Platform Type, etc.) as well as the comma-/semicolon-delimited list of associated reference values (e.g. regional ecosystems, gear, regions, leg aliases, etc.)';


drop view CCD_CRUISE_LEG_ALIASES_V;

ALTER TRIGGER CCD_CRUISES_AUTO_BRU compile;

--define the upgrade version in the database upgrade log table:
INSERT INTO DB_UPGRADE_LOGS (UPGRADE_APP_NAME, UPGRADE_VERSION, UPGRADE_DATE, UPGRADE_DESC) VALUES ('Centralized Cruise Database', '0.6', TO_DATE('04-MAR-20', 'DD-MON-YY'), 'This version requires version 0.7 of the Centralized Utilities Database (URL: git@gitlab.pifsc.gov:centralized-data-tools/centralized-utilities.git, git tag: cen_utils_db_v0.7) to be installed on the CEN_UTILS schema with the appropriate permissions.  Installed Version 0.1 of the Database Logging Module Database (Git URL: git@gitlab.pifsc.gov:centralized-data-tools/database-logging-module.git).  Installed Version 0.2 of the Error Handler Module (Git URL: git@gitlab.pifsc.gov:centralized-data-tools/apex_tools.git in the "Error Handling" folder).  Updated data model based on the FINSS system (https://www.st.nmfs.noaa.gov/finss/si/siMain.jsp), added multiple reference tables and defined the one-to-many and many-to-many relationships for the CCD_CRUISES and CCD_CRUISE_LEGS tables.  Replaced the cruise-vessel foreign key to a leg-vessel relationship.  Updated the main CCD_CRUISES and CCD_CRUISE_LEGS tables to add in FINSS fields.  Redefined the database views based on the data model updates and organized them so they can be used in different cases (delimited reference values at the cruise and cruise leg levels) as well as summary information used in the APEX application.');

--commit the DB_UPGRADE_LOGS record insertion
COMMIT;
