--------------------------------------------------------
--------------------------------------------------------
--Database Name: Centralized Cruise Database
--Database Description: Centralized Cruise Database to track information about each PIFSC research cruise including activities, chief scientists, regions, etc. to remove the need for each division/program to manage this information
--------------------------------------------------------
--------------------------------------------------------


--------------------------------------------------------
--Centralized Cruise Database - version 0.8 updates:
--------------------------------------------------------

--removed cruise leg tally from the charts/reports


ALTER TABLE CCD_TGT_SPP_ESA
ADD (APP_SHOW_OPT_YN CHAR(1) default 'Y' NOT NULL );

COMMENT ON COLUMN CCD_TGT_SPP_ESA.APP_SHOW_OPT_YN IS 'Flag to indicate whether or not to include this record in the data management application option lists by default (Y) or not (N)';



ALTER TABLE CCD_TGT_SPP_MMPA
ADD (APP_SHOW_OPT_YN CHAR(1) default 'Y' NOT NULL );

COMMENT ON COLUMN CCD_TGT_SPP_MMPA.APP_SHOW_OPT_YN IS 'Flag to indicate whether or not to include this record in the data management application option lists by default (Y) or not (N)';


ALTER TABLE CCD_TGT_SPP_FSSI
ADD (APP_SHOW_OPT_YN CHAR(1) default 'Y' NOT NULL );

COMMENT ON COLUMN CCD_TGT_SPP_FSSI.APP_SHOW_OPT_YN IS 'Flag to indicate whether or not to include this record in the data management application option lists by default (Y) or not (N)';


ALTER TABLE CCD_GEAR
ADD (APP_SHOW_OPT_YN CHAR(1) default 'Y' NOT NULL );

COMMENT ON COLUMN CCD_GEAR.APP_SHOW_OPT_YN IS 'Flag to indicate whether or not to include this record in the data management application option lists by default (Y) or not (N)';

ALTER TABLE CCD_REG_ECOSYSTEMS
ADD (APP_SHOW_OPT_YN CHAR(1) default 'Y' NOT NULL );

COMMENT ON COLUMN CCD_REG_ECOSYSTEMS.APP_SHOW_OPT_YN IS 'Flag to indicate whether or not to include this record in the data management application option lists by default (Y) or not (N)';


ALTER TABLE CCD_EXP_SPP_CATS
ADD (APP_SHOW_OPT_YN CHAR(1) default 'Y' NOT NULL );

COMMENT ON COLUMN CCD_EXP_SPP_CATS.APP_SHOW_OPT_YN IS 'Flag to indicate whether or not to include this record in the data management application option lists by default (Y) or not (N)';



ALTER TABLE CCD_VESSELS
ADD (APP_SHOW_OPT_YN CHAR(1) default 'Y' NOT NULL );

COMMENT ON COLUMN CCD_VESSELS.APP_SHOW_OPT_YN IS 'Flag to indicate whether or not to include this record in the data management application option lists by default (Y) or not (N)';

ALTER TABLE CCD_STD_SVY_NAMES
ADD (APP_SHOW_OPT_YN CHAR(1) default 'Y' NOT NULL );

COMMENT ON COLUMN CCD_STD_SVY_NAMES.APP_SHOW_OPT_YN IS 'Flag to indicate whether or not to include this record in the data management application option lists by default (Y) or not (N)';



--recompiled dependent views:
begin
         FOR cur IN (SELECT OBJECT_NAME, OBJECT_TYPE, owner
         			 FROM sys.all_objects
         			 WHERE object_type = 'VIEW'
         			 and owner = sys_context( 'userenv', 'current_schema' )
         			 AND status = 'INVALID' ) LOOP
         	BEGIN
		         if cur.OBJECT_TYPE = 'PACKAGE BODY' then
		         	EXECUTE IMMEDIATE 'alter ' || cur.OBJECT_TYPE || ' "' ||  cur.owner || '"."' || cur.OBJECT_NAME || '" compile body';
		         else
		         	EXECUTE IMMEDIATE 'alter ' || cur.OBJECT_TYPE || ' "' ||  cur.owner || '"."' || cur.OBJECT_NAME || '" compile';
		         end if;
			EXCEPTION
  				WHEN OTHERS THEN NULL;
			END;
         end loop;
         end;
/

--define the upgrade version in the database upgrade log table:
INSERT INTO DB_UPGRADE_LOGS (UPGRADE_APP_NAME, UPGRADE_VERSION, UPGRADE_DATE, UPGRADE_DESC) VALUES ('Centralized Cruise Database', '0.8', TO_DATE('07-APR-20', 'DD-MON-YY'), 'Updated specific reference tables to add in APP_SHOW_OPT_YN fields to allow them to be filtered in the data management application.  Recompiled all invalid views due to the reference table updates, the new field is not included in the views since they are only relevant to the application');

--commit the DB_UPGRADE_LOGS record insertion
COMMIT;
