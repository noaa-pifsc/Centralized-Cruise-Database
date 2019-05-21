--------------------------------------------------------
--------------------------------------------------------
--Database Name: Centralized Cruise Database
--Database Description: Centralized Cruise Database to track information about each PIFSC research cruise including activities, chief scientists, regions, etc. to remove the need for each division/program to manage this information 
--------------------------------------------------------
--------------------------------------------------------


--------------------------------------------------------
--Centralized Cruise Database - version 0.3 updates:
--------------------------------------------------------





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
TO_CHAR(LEG_START_DATE, 'YYYY') LEG_YEAR,

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
COMMENT ON COLUMN CCD_CRUISE_LEGS_V.LEG_YEAR IS 'The calendar year for the start date of the given research cruise leg';

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
  TO_CHAR(MIN (LEG_START_DATE), 'YYYY') CRUISE_YEAR,
	
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
COMMENT ON COLUMN CCD_CRUISES_SUMM_V.CRUISE_YEAR IS 'The calendar year for the start date of the given research cruise';
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



create or replace view
CCD_CRUISE_LEG_ALIASES_V

as

SELECT CCD_CRUISES_SUMM_V.CRUISE_ID,
  CCD_CRUISES_SUMM_V.CRUISE_NAME,
  CCD_CRUISES_SUMM_V.CRUISE_START_DATE,
  CCD_CRUISES_SUMM_V.FORMAT_CRUISE_START_DATE,
  CCD_CRUISES_SUMM_V.CRUISE_END_DATE,
  CCD_CRUISES_SUMM_V.FORMAT_CRUISE_END_DATE,
  CCD_CRUISES_SUMM_V.CRUISE_YEAR,
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
  TO_CHAR(LEG_START_DATE, 'YYYY') LEG_YEAR,
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
  CCD_CRUISES_SUMM_V.CRUISE_YEAR,
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
  TO_CHAR(LEG_START_DATE, 'YYYY'),
  CCD_CRUISE_LEGS.LEG_DESC,
  LEG_ALIASES.leg_aliases_delim
  

order by VESSEL_NAME, cruise_start_date;


COMMENT ON COLUMN CCD_CRUISE_LEG_ALIASES_V.CRUISE_ID IS 'Primary key for the CCD_CRUISES table';
COMMENT ON COLUMN CCD_CRUISE_LEG_ALIASES_V.CRUISE_NAME IS 'The name of the given cruise designated by NOAA (e.g. SE-15-01)';
COMMENT ON COLUMN CCD_CRUISE_LEG_ALIASES_V.CRUISE_START_DATE IS 'The start date of the given research cruise';
COMMENT ON COLUMN CCD_CRUISE_LEG_ALIASES_V.FORMAT_CRUISE_START_DATE IS 'The start date of the given research cruise in MM/DD/YYYY format';
COMMENT ON COLUMN CCD_CRUISE_LEG_ALIASES_V.CRUISE_END_DATE IS 'The end date of the given research cruise';
COMMENT ON COLUMN CCD_CRUISE_LEG_ALIASES_V.FORMAT_CRUISE_END_DATE IS 'The end date of the given research cruise in MM/DD/YYYY format';
COMMENT ON COLUMN CCD_CRUISE_LEG_ALIASES_V.CRUISE_YEAR IS 'The calendar year for the start date of the given research cruise';
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
COMMENT ON COLUMN CCD_CRUISE_LEG_ALIASES_V.LEG_YEAR IS 'The calendar year for the start date of the given research cruise leg';
COMMENT ON COLUMN CCD_CRUISE_LEG_ALIASES_V.LEG_DESC IS 'The description for the given research cruise leg';
COMMENT ON COLUMN CCD_CRUISE_LEG_ALIASES_V.CRUISE_LEG_ID IS 'Primary key for the CCD_CRUISE_LEGS table';

COMMENT ON TABLE CCD_CRUISE_LEG_ALIASES_V IS 'Research Cruise Leg Aliases (View)

This query returns all of the CTD cruises, associated research vessels where CTD data was collected including the formatted start and end dates.  This query also returns the comma-delimited list of cruise leg name aliases for each cruise in alphabetical order';



ALTER TRIGGER CCD_CRUISES_AUTO_BRI COMPILE;





--define the upgrade version in the database upgrade log table:
INSERT INTO DB_UPGRADE_LOGS (UPGRADE_APP_NAME, UPGRADE_VERSION, UPGRADE_DATE, UPGRADE_DESC) VALUES ('Centralized Cruise Database', '0.3', TO_DATE('11-DEC-18', 'DD-MON-YY'), 'Defined Cruise Years and Cruise Leg Years in the applicable database Views based on business rule updates.');

--commit the DB_UPGRADE_LOGS record insertion
COMMIT;