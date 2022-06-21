--------------------------------------------------------
--------------------------------------------------------
--Database Name: Centralized Configuration
--Database Description: This database was developed to provide a database module to define configuration options that can be used by any Oracle database modules
--------------------------------------------------------
--------------------------------------------------------


--------------------------------------------------------
--Centralized Configuration - version 1.0 updates:
--------------------------------------------------------


CREATE TABLE CC_CONFIG_OPTIONS
(
  OPTION_ID NUMBER NOT NULL
, OPTION_NAME VARCHAR2(200) NOT NULL
, OPTION_VALUE VARCHAR2(200) NOT NULL
, OPTION_DESC VARCHAR2(500)
, CONSTRAINT CC_CONFIG_OPTIONS_PK PRIMARY KEY
  (
    OPTION_ID
  )
  ENABLE
);

COMMENT ON TABLE CC_CONFIG_OPTIONS IS 'Configuration Options

This table stores the database/application configuration option values for the corresponding instance(s)';

COMMENT ON COLUMN CC_CONFIG_OPTIONS.OPTION_ID IS 'Primary key for the Configuration Options table';

COMMENT ON COLUMN CC_CONFIG_OPTIONS.OPTION_NAME IS 'The name of the configuration option variable, this is the field that is filtered to retrieve specific configuration variables (e.g. "Application URL")';

COMMENT ON COLUMN CC_CONFIG_OPTIONS.OPTION_VALUE IS 'The value of the configuration option variable, this is the value used by other modules (e.g. "https://picmidd.nmfs.local/picd/f?p=PTS")';

COMMENT ON COLUMN CC_CONFIG_OPTIONS.OPTION_DESC IS 'The description of the given configuration option variable';

ALTER TABLE CC_CONFIG_OPTIONS ADD CONSTRAINT CC_CONFIG_OPTIONS_U1 UNIQUE
(
  OPTION_NAME
)
ENABLE;

ALTER TABLE CC_CONFIG_OPTIONS ADD (CREATE_DATE DATE );
ALTER TABLE CC_CONFIG_OPTIONS ADD (CREATED_BY VARCHAR2(30) );
ALTER TABLE CC_CONFIG_OPTIONS ADD (LAST_MOD_DATE DATE );
ALTER TABLE CC_CONFIG_OPTIONS ADD (LAST_MOD_BY VARCHAR2(30) );
COMMENT ON COLUMN CC_CONFIG_OPTIONS.CREATE_DATE IS 'The date on which this record was created in the database';
COMMENT ON COLUMN CC_CONFIG_OPTIONS.CREATED_BY IS 'The Oracle username of the person creating this record in the database';
COMMENT ON COLUMN CC_CONFIG_OPTIONS.LAST_MOD_DATE IS 'The last date on which any of the data in this record was changed';
COMMENT ON COLUMN CC_CONFIG_OPTIONS.LAST_MOD_BY IS 'The Oracle username of the person making the most recent change to this record';


CREATE SEQUENCE CC_CONFIG_OPTIONS_SEQ INCREMENT BY 1 START WITH 1;



create or replace TRIGGER CC_CONFIG_OPTIONS_AUTO_BRI
before insert on CC_CONFIG_OPTIONS
for each row
begin
  select CC_CONFIG_OPTIONS_SEQ.nextval into :new.OPTION_ID from dual;
  :NEW.CREATE_DATE := SYSDATE;
  :NEW.CREATED_BY := nvl(v('APP_USER'),user);
end;
/
	CREATE OR REPLACE TRIGGER CC_CONFIG_OPTIONS_AUTO_BRU BEFORE
  UPDATE
    ON CC_CONFIG_OPTIONS FOR EACH ROW
    BEGIN
      :NEW.LAST_MOD_DATE := SYSDATE;
      :NEW.LAST_MOD_BY := nvl(v('APP_USER'),user);
END;
/

--create the data history table:

CREATE TABLE CC_CONFIG_OPTIONS_HIST
(
  H_SEQNUM NUMBER(10, 0) NOT NULL
, OPTION_ID NUMBER NOT NULL
, H_TYPE_OF_CHANGE VARCHAR2(10 BYTE) NOT NULL
, H_DATE_OF_CHANGE DATE NOT NULL
, H_USER_MAKING_CHANGE VARCHAR2(30 BYTE) NOT NULL
, H_OS_USER VARCHAR2(30 BYTE) NOT NULL
, H_CHANGED_COLUMN VARCHAR2(30 BYTE)
, H_OLD_DATA VARCHAR2(4000 BYTE)
, H_NEW_DATA VARCHAR2(4000 BYTE)
, CONSTRAINT CC_CONFIG_OPTIONS_HIST_PK PRIMARY Key
(
    H_SEQNUM
)
ENABLE
);
COMMENT ON COLUMN CC_CONFIG_OPTIONS_HIST.H_SEQNUM IS 'A unique number for this record in the history table';
 COMMENT ON COLUMN CC_CONFIG_OPTIONS_HIST.OPTION_ID IS 'Primary key column of the data table';
COMMENT ON COLUMN CC_CONFIG_OPTIONS_HIST.H_TYPE_OF_CHANGE IS 'The type of change is INSERT, UPDATE or DELETE';
COMMENT ON COLUMN CC_CONFIG_OPTIONS_HIST.H_DATE_OF_CHANGE IS 'The date and time the change was made to the data';
COMMENT ON COLUMN CC_CONFIG_OPTIONS_HIST.H_USER_MAKING_CHANGE IS 'The person (Oracle username) making the change to the record';
COMMENT ON COLUMN CC_CONFIG_OPTIONS_HIST.H_OS_USER IS 'The OS username of the person making the change to the record';
COMMENT ON COLUMN CC_CONFIG_OPTIONS_HIST.H_CHANGED_COLUMN IS 'If the type of change is INSERT or UPDATE, the name of the column being changed';
COMMENT ON COLUMN CC_CONFIG_OPTIONS_HIST.H_OLD_DATA IS 'The data that has been updated';
COMMENT ON COLUMN CC_CONFIG_OPTIONS_HIST.H_NEW_DATA IS 'The updated column data';
COMMENT ON TABLE CC_CONFIG_OPTIONS_HIST IS 'History tracking table for CC_CONFIG_OPTIONS implemented using the DSC.DSC_CRE_HIST_OBJS_PKG package';

CREATE SEQUENCE CC_CONFIG_OPTIONS_HIST_SEQ INCREMENT BY 1 START WITH 1;

--------------------------------------------------------
--  DDL for Trigger TRG_CC_CONFIG_OPTIONS_HIST
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE TRIGGER "TRG_CC_CONFIG_OPTIONS_HIST"
AFTER DELETE OR INSERT OR UPDATE
ON CC_CONFIG_OPTIONS
REFERENCING OLD AS old NEW AS new
FOR EACH ROW
DECLARE
  os_user VARCHAR2(30) := dsc.dsc_utilities_pkg.os_user;

  PROCEDURE insert_data(
    p_type_of_change IN VARCHAR2,
    p_changed_column IN VARCHAR2 DEFAULT NULL,
    p_old_data       IN VARCHAR2 DEFAULT NULL,
    p_new_data       IN VARCHAR2 DEFAULT NULL ) IS
  BEGIN
    INSERT INTO CC_CONFIG_OPTIONS_hist (
      h_seqnum, OPTION_ID, h_type_of_change, h_user_making_change, h_os_user,
      h_date_of_change, h_changed_column, h_old_data, h_new_data)
    VALUES(
      CC_CONFIG_OPTIONS_hist_seq.NEXTVAL, :old.OPTION_ID, p_type_of_change, user, os_user,      SYSDATE, p_changed_column, p_old_data, p_new_data);
  END;

  PROCEDURE check_update(
    p_changed_column IN VARCHAR2,
    p_old_data       IN VARCHAR2,
    p_new_data       IN VARCHAR2 ) IS
  BEGIN
    IF p_old_data <> p_new_data
    OR (p_old_data IS NULL AND p_new_data IS NOT NULL)
    OR (p_new_data IS NULL AND p_old_data IS NOT NULL) THEN
      insert_data('UPDATE', p_changed_column, p_old_data, p_new_data);
    END IF;
  END;
BEGIN
  IF INSERTING THEN
    INSERT INTO CC_CONFIG_OPTIONS_hist (
      h_seqnum, OPTION_ID, h_type_of_change, h_user_making_change, h_os_user, h_date_of_change)
    VALUES (
      CC_CONFIG_OPTIONS_hist_seq.NEXTVAL, :new.OPTION_ID,
      'INSERT', user, os_user, SYSDATE);
  ELSIF DELETING THEN
    insert_data('DELETE');
    insert_data('DELETE', 'option_name', :old.option_name);
    insert_data('DELETE', 'option_value', :old.option_value);
    insert_data('DELETE', 'option_desc', :old.option_desc);
  ELSE
    NULL;
    check_update('OPTION_NAME', :old.option_name, :new.option_name);
    check_update('OPTION_VALUE', :old.option_value, :new.option_value);
    check_update('OPTION_DESC', :old.option_desc, :new.option_desc);
  END IF;
END;
/
ALTER TRIGGER "TRG_CC_CONFIG_OPTIONS_HIST" ENABLE;

--define the upgrade version in the database upgrade log table:
INSERT INTO DB_UPGRADE_LOGS (UPGRADE_APP_NAME, UPGRADE_VERSION, UPGRADE_DATE, UPGRADE_DESC) VALUES ('Centralized Configuration', '1.0', TO_DATE('22-NOV-21', 'DD-MON-YY'), 'Created initial configuration options table (CC_CONFIG_OPTIONS) and supporting objects.  Implemented the April 2009 version of the Data History Tracking Package (svn://badfish.pifsc.gov/Oracle/DSC/trunk/apps/db/dsc/dsc_pkgs) on the CC_CONFIG_OPTIONS table');

--commit the DB_UPGRADE_LOGS record insertion
COMMIT;
