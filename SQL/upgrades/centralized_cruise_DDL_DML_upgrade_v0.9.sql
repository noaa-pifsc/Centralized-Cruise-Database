--------------------------------------------------------
--------------------------------------------------------
--Database Name: Centralized Cruise Database
--Database Description: Centralized Cruise Database to track information about each PIFSC research cruise including activities, chief scientists, regions, etc. to remove the need for each division/program to manage this information
--------------------------------------------------------
--------------------------------------------------------


--------------------------------------------------------
--Centralized Cruise Database - version 0.9 updates:
--------------------------------------------------------


ALTER TABLE CCD_CRUISES
ADD (CRUISE_DESC CLOB NOT NULL);

ALTER TABLE CCD_CRUISES
ADD (OBJ_BASED_METRICS VARCHAR2(2000) NOT NULL);

COMMENT ON COLUMN CCD_CRUISES.CRUISE_DESC IS 'Description for the given research cruise';

COMMENT ON COLUMN CCD_CRUISES.OBJ_BASED_METRICS IS 'Objective Based Metrics for the given research cruise';






CREATE TABLE CCD_SCI_CENTER_DIVS
(
  SCI_CENTER_DIV_ID NUMBER NOT NULL
, SCI_CENTER_DIV_CODE VARCHAR2(20) NOT NULL
, SCI_CENTER_DIV_NAME VARCHAR2(200) NOT NULL
, SCI_CENTER_DIV_DESC VARCHAR2(500)
, CONSTRAINT CCD_SCI_CENTER_DIVS_PK PRIMARY KEY
  (
    SCI_CENTER_DIV_ID
  )
  ENABLE
);

COMMENT ON COLUMN CCD_SCI_CENTER_DIVS.SCI_CENTER_DIV_ID IS 'Primary key for the Science Center Division table';
COMMENT ON COLUMN CCD_SCI_CENTER_DIVS.SCI_CENTER_DIV_CODE IS 'Abbreviated code for the given Science Center Division';

COMMENT ON COLUMN CCD_SCI_CENTER_DIVS.SCI_CENTER_DIV_NAME IS 'Name of the given Science Center Division';

COMMENT ON COLUMN CCD_SCI_CENTER_DIVS.SCI_CENTER_DIV_DESC IS 'Description for the given Science Center Division';

COMMENT ON TABLE CCD_SCI_CENTER_DIVS IS 'Reference Table for storing Science Center Division information';





CREATE SEQUENCE CCD_SCI_CENTER_DIVS_SEQ INCREMENT BY 1 START WITH 1;
ALTER TABLE CCD_SCI_CENTER_DIVS ADD (CREATE_DATE DATE );
ALTER TABLE CCD_SCI_CENTER_DIVS ADD (CREATED_BY VARCHAR2(30) );
ALTER TABLE CCD_SCI_CENTER_DIVS ADD (LAST_MOD_DATE DATE );
ALTER TABLE CCD_SCI_CENTER_DIVS ADD (LAST_MOD_BY VARCHAR2(30) );

COMMENT ON COLUMN CCD_SCI_CENTER_DIVS.CREATE_DATE IS 'The date on which this record was created in the database';
COMMENT ON COLUMN CCD_SCI_CENTER_DIVS.CREATED_BY IS 'The Oracle username of the person creating this record in the database';
COMMENT ON COLUMN CCD_SCI_CENTER_DIVS.LAST_MOD_DATE IS 'The last date on which any of the data in this record was changed';
COMMENT ON COLUMN CCD_SCI_CENTER_DIVS.LAST_MOD_BY IS 'The Oracle username of the person making the most recent change to this record';



create or replace TRIGGER CCD_SCI_CENTER_DIVS_AUTO_BRI
before insert on CCD_SCI_CENTER_DIVS
for each row
begin
  select CCD_SCI_CENTER_DIVS_SEQ.nextval into :new.SCI_CENTER_DIV_ID from dual;
  :NEW.CREATE_DATE := SYSDATE;
  :NEW.CREATED_BY := nvl(v('APP_USER'),user);
end;
/

CREATE OR REPLACE TRIGGER CCD_SCI_CENTER_DIVS_AUTO_BRU BEFORE
  UPDATE
    ON CCD_SCI_CENTER_DIVS FOR EACH ROW
    BEGIN
      :NEW.LAST_MOD_DATE := SYSDATE;
      :NEW.LAST_MOD_BY := nvl(v('APP_USER'),user);
END;
/

--link the divisions to the science centers
ALTER TABLE CCD_SCI_CENTER_DIVS
ADD (SCI_CENTER_ID NUMBER NOT NULL);

CREATE INDEX CCD_SCI_CENTER_DIVS_I1 ON CCD_SCI_CENTER_DIVS (SCI_CENTER_ID);

ALTER TABLE CCD_SCI_CENTER_DIVS
ADD CONSTRAINT CCD_SCI_CENTER_DIVS_FK1 FOREIGN KEY
(
  SCI_CENTER_ID
)
REFERENCES CCD_SCI_CENTERS
(
  SCI_CENTER_ID
)
ENABLE;

COMMENT ON COLUMN CCD_SCI_CENTER_DIVS.SCI_CENTER_ID IS 'Science Center for the given division';



ALTER TABLE CCD_SCI_CENTER_DIVS
ADD CONSTRAINT CCD_SCI_CENTER_DIVS_U2 UNIQUE
(
  SCI_CENTER_DIV_CODE
, SCI_CENTER_ID
)
ENABLE;

ALTER TABLE CCD_SCI_CENTER_DIVS
ADD CONSTRAINT CCD_SCI_CENTER_DIVS_U1 UNIQUE
(
  SCI_CENTER_DIV_NAME
, SCI_CENTER_ID
)
ENABLE;



--relink the cruises table to the divisions instead of science centers
ALTER TABLE CCD_CRUISES
DROP CONSTRAINT CCD_CRUISES_FK1;

ALTER TABLE CCD_CRUISES RENAME COLUMN SCI_CENTER_ID TO SCI_CENTER_DIV_ID;

ALTER TABLE CCD_CRUISES
ADD CONSTRAINT CCD_CRUISES_FK1 FOREIGN KEY
(
  SCI_CENTER_DIV_ID
)
REFERENCES CCD_SCI_CENTER_DIVS
(
  SCI_CENTER_DIV_ID
)
ENABLE;

COMMENT ON COLUMN CCD_CRUISES.SCI_CENTER_DIV_ID IS 'The Science Center Division Responsible for the given Cruise';


CREATE OR REPLACE VIEW CCD_SCI_CENTER_DIV_V
AS
SELECT
CCD_SCI_CENTERS.SCI_CENTER_ID,
CCD_SCI_CENTERS.SCI_CENTER_NAME,
CCD_SCI_CENTERS.SCI_CENTER_DESC,
CCD_SCI_CENTER_DIVS.SCI_CENTER_DIV_ID,
CCD_SCI_CENTER_DIVS.SCI_CENTER_DIV_CODE,
CCD_SCI_CENTER_DIVS.SCI_CENTER_DIV_NAME,
CCD_SCI_CENTER_DIVS.SCI_CENTER_DIV_DESC
FROM
CCD_SCI_CENTERS
LEFT join
CCD_SCI_CENTER_DIVS on CCD_SCI_CENTERS.sci_center_id = CCD_SCI_CENTER_DIVS.sci_center_id
order by sci_center_name, sci_center_div_name;

COMMENT ON TABLE CCD_SCI_CENTER_DIV_V IS 'Science Center Divisions (View)

This view returns all science centers and associated divisions';
COMMENT ON COLUMN CCD_SCI_CENTER_DIV_V.SCI_CENTER_ID IS 'Primary key for the Science Center table';
COMMENT ON COLUMN CCD_SCI_CENTER_DIV_V.SCI_CENTER_NAME IS 'Name of the given Science Center';
COMMENT ON COLUMN CCD_SCI_CENTER_DIV_V.SCI_CENTER_DESC IS 'Description for the given Science Center';
COMMENT ON COLUMN CCD_SCI_CENTER_DIV_V.SCI_CENTER_DIV_ID IS 'Primary key for the Science Center Division table';
COMMENT ON COLUMN CCD_SCI_CENTER_DIV_V.SCI_CENTER_DIV_CODE IS 'Abbreviated code for the given Science Center Division';
COMMENT ON COLUMN CCD_SCI_CENTER_DIV_V.SCI_CENTER_DIV_NAME IS 'Name of the given Science Center Division';
COMMENT ON COLUMN CCD_SCI_CENTER_DIV_V.SCI_CENTER_DIV_DESC IS 'Description for the given Science Center Division';







create or replace view
CCD_SCI_CENTER_DELIM_V
AS
select

SCI_CENTER_ID,
SCI_CENTER_NAME,
SCI_CENTER_DESC,
LISTAGG(SCI_CENTER_DIV_NAME, ', ') WITHIN GROUP (ORDER BY UPPER(SCI_CENTER_DIV_NAME)) as DIV_NAME_CD_LIST,
LISTAGG(SCI_CENTER_DIV_NAME, '; ') WITHIN GROUP (ORDER BY UPPER(SCI_CENTER_DIV_NAME)) as DIV_NAME_SCD_LIST,
LISTAGG(SCI_CENTER_DIV_NAME, chr(10)) WITHIN GROUP (ORDER BY UPPER(SCI_CENTER_DIV_NAME)) as DIV_NAME_RC_LIST,
LISTAGG(SCI_CENTER_DIV_NAME, '<BR>') WITHIN GROUP (ORDER BY UPPER(SCI_CENTER_DIV_NAME)) as DIV_NAME_BR_LIST,
LISTAGG(SCI_CENTER_DIV_CODE, ', ') WITHIN GROUP (ORDER BY UPPER(SCI_CENTER_DIV_CODE)) as DIV_CODE_CD_LIST,
LISTAGG(SCI_CENTER_DIV_CODE, '; ') WITHIN GROUP (ORDER BY UPPER(SCI_CENTER_DIV_CODE)) as DIV_CODE_SCD_LIST,
LISTAGG(SCI_CENTER_DIV_CODE, chr(10)) WITHIN GROUP (ORDER BY UPPER(SCI_CENTER_DIV_CODE)) as DIV_CODE_RC_LIST,
LISTAGG(SCI_CENTER_DIV_CODE, '<BR>') WITHIN GROUP (ORDER BY UPPER(SCI_CENTER_DIV_CODE)) as DIV_CODE_BR_LIST


from

CCD_SCI_CENTER_DIV_V
group by
SCI_CENTER_ID,
SCI_CENTER_NAME,
SCI_CENTER_DESC

order by
UPPER(SCI_CENTER_NAME);


comment on table CCD_SCI_CENTER_DELIM_V IS 'Science Center Delimited Divisions (View)

This view returns all Science Centers and delimited lists of associated divisions';

COMMENT ON COLUMN CCD_SCI_CENTER_DELIM_V.SCI_CENTER_ID IS 'Primary key for the Science Center table';
COMMENT ON COLUMN CCD_SCI_CENTER_DELIM_V.SCI_CENTER_NAME IS 'Name of the given Science Center';
COMMENT ON COLUMN CCD_SCI_CENTER_DELIM_V.SCI_CENTER_DESC IS 'Description for the given Science Center';


COMMENT ON COLUMN CCD_SCI_CENTER_DELIM_V.DIV_NAME_CD_LIST IS 'Comma-delimited list of Division names associated with the given Science Center';
COMMENT ON COLUMN CCD_SCI_CENTER_DELIM_V.DIV_NAME_SCD_LIST IS 'Semicolon-delimited list of Division names associated with the given Science Center';
COMMENT ON COLUMN CCD_SCI_CENTER_DELIM_V.DIV_NAME_RC_LIST IS 'Return carriage/new line delimited list of Division names associated with the given Science Center';
COMMENT ON COLUMN CCD_SCI_CENTER_DELIM_V.DIV_NAME_BR_LIST IS '<BR> tag (intended for web pages) delimited list of Division names associated with the given Science Center';


COMMENT ON COLUMN CCD_SCI_CENTER_DELIM_V.DIV_CODE_CD_LIST IS 'Comma-delimited list of Division codes associated with the given Science Center';
COMMENT ON COLUMN CCD_SCI_CENTER_DELIM_V.DIV_CODE_SCD_LIST IS 'Semicolon-delimited list of Division codes associated with the given Science Center';
COMMENT ON COLUMN CCD_SCI_CENTER_DELIM_V.DIV_CODE_RC_LIST IS 'Return carriage/new line delimited list of Division codes associated with the given Science Center';
COMMENT ON COLUMN CCD_SCI_CENTER_DELIM_V.DIV_CODE_BR_LIST IS '<BR> tag (intended for web pages) delimited list of Division codes associated with the given Science Center';








--redefine all views that return information about cruises:
CREATE OR REPLACE VIEW CCD_CRUISE_V
AS SELECT CCD_CRUISES.CRUISE_ID,
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
LEFT JOIN CCD_SCI_CENTER_DIV_V
ON CCD_CRUISES.SCI_CENTER_DIV_ID = CCD_SCI_CENTER_DIV_V.SCI_CENTER_DIV_ID

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

ORDER BY CCD_SCI_CENTER_DIV_V.SCI_CENTER_NAME,
CCD_STD_SVY_NAMES.STD_SVY_NAME,
CCD_CRUISES.CRUISE_NAME
;

COMMENT ON TABLE CCD_CRUISE_V IS 'Research Cruises (View)

This query returns all of the research cruises and their associated reference tables (e.g. Science Center, standard survey name, survey frequency, etc.) as well as aggregate information from the associated cruise legs';


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










--cruises and associated comma/semicolon delimited list of values
CREATE OR REPLACE VIEW

CCD_CRUISE_DELIM_V
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
AS
SELECT



CCD_CRUISE_DELIM_V.CRUISE_ID,
CCD_CRUISE_DELIM_V.CRUISE_NAME,
CCD_CRUISE_DELIM_V.CRUISE_NOTES,
dbms_lob.substr(CCD_CRUISE_DELIM_V.CRUISE_DESC, 4000, 1) CRUISE_DESC,
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
dbms_lob.substr(CCD_CRUISE_DELIM_V.CRUISE_DESC, 4000, 1),
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










CREATE OR REPLACE VIEW
CCD_CRUISE_LEGS_V
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



COMMENT ON COLUMN CCD_CRUISE_LEGS_V.CRUISE_DESC IS 'Description for the given research cruise';
COMMENT ON COLUMN CCD_CRUISE_LEGS_V.OBJ_BASED_METRICS IS 'Objective Based Metrics for the given research cruise';
COMMENT ON COLUMN CCD_CRUISE_LEGS_V.SCI_CENTER_DIV_ID IS 'Primary key for the Science Center Division table';
COMMENT ON COLUMN CCD_CRUISE_LEGS_V.SCI_CENTER_DIV_CODE IS 'Abbreviated code for the given Science Center Division';

COMMENT ON COLUMN CCD_CRUISE_LEGS_V.SCI_CENTER_DIV_NAME IS 'Name of the given Science Center Division';

COMMENT ON COLUMN CCD_CRUISE_LEGS_V.SCI_CENTER_DIV_DESC IS 'Description for the given Science Center Division';


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





--expected ESA target species preset delimited view
create or replace view
CCD_GEAR_PRE_DELIM_V
AS
select
GEAR_PRE_ID,
GEAR_PRE_NAME,
GEAR_PRE_DESC,
LISTAGG(GEAR_NAME, ', ') WITHIN GROUP (ORDER BY UPPER(GEAR_NAME)) as GEAR_NAME_CD_LIST,
LISTAGG(GEAR_NAME, '; ') WITHIN GROUP (ORDER BY UPPER(GEAR_NAME)) as GEAR_NAME_SCD_LIST,
LISTAGG(GEAR_NAME, chr(10)) WITHIN GROUP (ORDER BY UPPER(GEAR_NAME)) as GEAR_NAME_RC_LIST,
LISTAGG(GEAR_NAME, '<BR>') WITHIN GROUP (ORDER BY UPPER(GEAR_NAME)) as GEAR_NAME_BR_LIST

from

CCD_GEAR_PRE_V
group by
GEAR_PRE_ID,
GEAR_PRE_NAME,
GEAR_PRE_DESC

order by
GEAR_PRE_NAME,
GEAR_PRE_DESC;


comment on table CCD_GEAR_PRE_DELIM_V IS 'Gear Preset Delimited Options (View)

This view returns all Gear presets and delimited lists of associated Gear names';

COMMENT ON COLUMN CCD_GEAR_PRE_DELIM_V.GEAR_PRE_ID IS 'Primary key for the Gear Preset table';
COMMENT ON COLUMN CCD_GEAR_PRE_DELIM_V.GEAR_PRE_NAME IS 'Name of the given Gear Preset';
COMMENT ON COLUMN CCD_GEAR_PRE_DELIM_V.GEAR_PRE_DESC IS 'Description for the given Gear Preset';
COMMENT ON COLUMN CCD_GEAR_PRE_DELIM_V.GEAR_NAME_CD_LIST IS 'Comma-delimited list of Gear associated with the given preset';
COMMENT ON COLUMN CCD_GEAR_PRE_DELIM_V.GEAR_NAME_SCD_LIST IS 'Semicolon-delimited list of Gear associated with the given preset';
COMMENT ON COLUMN CCD_GEAR_PRE_DELIM_V.GEAR_NAME_RC_LIST IS 'Return carriage/new line delimited list of Gear associated with the given preset';
COMMENT ON COLUMN CCD_GEAR_PRE_DELIM_V.GEAR_NAME_BR_LIST IS '<BR> tag (intended for web pages) delimited list of Gear associated with the given preset';


ALTER PACKAGE CRUISE_PKG COMPILE;
ALTER TRIGGER CCD_CRUISES_AUTO_BRI COMPILE;


--define the upgrade version in the database upgrade log table:
INSERT INTO DB_UPGRADE_LOGS (UPGRADE_APP_NAME, UPGRADE_VERSION, UPGRADE_DATE, UPGRADE_DESC) VALUES ('Centralized Cruise Database', '0.9', TO_DATE('16-APR-20', 'DD-MON-YY'), 'Added two new fields, CRUISE_DESC and OBJ_BASED_METRICS, to CCD_CRUISES table.  Created a new CCD_SCI_CENTER_DIVS table to define science center divisions that references the CCD_SCI_CENTERS table, updated the CCD_CRUISES table''s SCI_CENTER_ID foreign key to SCI_CENTER_DIV_ID to associated cruises with a given division.  Defined two new views CCD_SCI_CENTER_DIV_V and CCD_SCI_CENTER_DELIM_V to return the science centers/associated divisions and science centers/delimited list of divisions respectively.  Updated the following views to add the new CCD_CRUISES fields as well as the associated division/science center: CCD_CRUISE_V, CCD_CRUISE_DELIM_V, CCD_CRUISE_SUMM_V, CCD_CRUISE_LEGS_V, CCD_CRUISE_LEG_DELIM_V.  Defined a new view CCD_GEAR_PRE_DELIM_V to implement the Gear preset management page');

--commit the DB_UPGRADE_LOGS record insertion
COMMIT;
