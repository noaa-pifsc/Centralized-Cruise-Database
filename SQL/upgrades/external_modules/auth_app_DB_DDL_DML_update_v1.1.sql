--------------------------------------------------------
--------------------------------------------------------
--Database Name: Authorization Application Database
--Database Description: This database was originally designed to manage application access and permissions within the application.  This is a flexible method that allows users and permission groups to be defined that will determine if a user has enabled access to the application and what permission(s) they have in the application.
--------------------------------------------------------
--------------------------------------------------------


-------------------------------------------------------------------
--version 1.1 updates:
-------------------------------------------------------------------

--add auditing fields for the AUTH_APP_USER_GROUPS table
ALTER TABLE AUTH_APP_USER_GROUPS ADD (LAST_MOD_DATE DATE );
ALTER TABLE AUTH_APP_USER_GROUPS ADD (LAST_MOD_BY VARCHAR2(30) );

COMMENT ON COLUMN AUTH_APP_USER_GROUPS.LAST_MOD_DATE IS 'The last date on which any of the data in this record was changed';
COMMENT ON COLUMN AUTH_APP_USER_GROUPS.LAST_MOD_BY IS 'The Oracle username of the person making the most recent change to this record';

--add additional informational fields for the users table
ALTER TABLE AUTH_APP_USERS
ADD (APP_USER_FIRST_NAME VARCHAR2(100) );

ALTER TABLE AUTH_APP_USERS
ADD (APP_USER_LAST_NAME VARCHAR2(100) );

COMMENT ON COLUMN AUTH_APP_USERS.APP_USER_NAME IS 'The username used to login to the application';

COMMENT ON COLUMN AUTH_APP_USERS.APP_USER_FIRST_NAME IS 'The first name of the given user ';

COMMENT ON COLUMN AUTH_APP_USERS.APP_USER_LAST_NAME IS 'The last name of the given user';

--make the APP_GROUP_CODE not null since it is used in queries to determine the user's associated group(s)
ALTER TABLE AUTH_APP_GROUPS
MODIFY (APP_GROUP_CODE NOT NULL);


CREATE OR REPLACE VIEW
AUTH_APP_USERS_V
AS
SELECT

AUTH_APP_USERS.APP_USER_ID,
AUTH_APP_USERS.APP_USER_NAME,
AUTH_APP_USERS.APP_USER_COMMENTS,
AUTH_APP_USERS.APP_USER_ACTIVE_YN,
AUTH_APP_USERS.APP_USER_FIRST_NAME,
AUTH_APP_USERS.APP_USER_LAST_NAME,
AUTH_APP_USERS.CREATE_DATE,
AUTH_APP_USERS.CREATED_BY,
AUTH_APP_USERS.LAST_MOD_DATE,
AUTH_APP_USERS.LAST_MOD_BY,
GROUP_INFO.GROUP_NAME_SCD_LIST,
GROUP_INFO.GROUP_CODE_SCD_LIST,
GROUP_INFO.GROUP_NAME_CD_LIST,
GROUP_INFO.GROUP_CODE_CD_LIST,
NVL(GROUP_INFO.NUM_GROUPS, 0) NUM_GROUPS



FROM
  AUTH_APP_USERS
LEFT OUTER JOIN
(SELECT

APP_USER_ID,
LISTAGG(APP_GROUP_NAME, '; ') WITHIN GROUP (ORDER BY UPPER(APP_GROUP_NAME)) as GROUP_NAME_SCD_LIST,
LISTAGG(APP_GROUP_CODE, '; ') WITHIN GROUP (ORDER BY UPPER(APP_GROUP_CODE)) as GROUP_CODE_SCD_LIST,
LISTAGG(APP_GROUP_NAME, ', ') WITHIN GROUP (ORDER BY UPPER(APP_GROUP_NAME)) as GROUP_NAME_CD_LIST,
LISTAGG(APP_GROUP_CODE, ', ') WITHIN GROUP (ORDER BY UPPER(APP_GROUP_CODE)) as GROUP_CODE_CD_LIST,
COUNT(*) NUM_GROUPS

FROM AUTH_APP_USER_GROUPS

INNER JOIN AUTH_APP_GROUPS
ON
  AUTH_APP_USER_GROUPS.APP_GROUP_ID = AUTH_APP_GROUPS.APP_GROUP_ID
GROUP BY APP_USER_ID) GROUP_INFO
ON
  AUTH_APP_USERS.APP_USER_ID = GROUP_INFO.APP_USER_ID
ORDER BY APP_USER_NAME;

COMMENT ON COLUMN AUTH_APP_USERS_V.APP_USER_ID IS 'Primary Key for the AUTH_APP_USERS table';
COMMENT ON COLUMN AUTH_APP_USERS_V.APP_USER_NAME IS 'The username used to login to the application';

COMMENT ON COLUMN AUTH_APP_USERS_V.APP_USER_FIRST_NAME IS 'The first name of the given user ';

COMMENT ON COLUMN AUTH_APP_USERS_V.APP_USER_LAST_NAME IS 'The last name of the given user';

COMMENT ON COLUMN AUTH_APP_USERS_V.APP_USER_COMMENTS IS 'Comments about the given user';
COMMENT ON COLUMN AUTH_APP_USERS_V.APP_USER_ACTIVE_YN IS 'Flag to indicate if the given user''s APEX application account is active (Y) or inactive (N)';
COMMENT ON COLUMN AUTH_APP_USERS_V.CREATE_DATE IS 'The date on which the user record was created in the database';
COMMENT ON COLUMN AUTH_APP_USERS_V.CREATED_BY IS 'The Oracle username of the person creating the user record in the database';
COMMENT ON COLUMN AUTH_APP_USERS_V.LAST_MOD_DATE IS 'The last date on which any of the data in the user record was changed';
COMMENT ON COLUMN AUTH_APP_USERS_V.LAST_MOD_BY IS 'The Oracle username of the person making the most recent change to the user record';
COMMENT ON COLUMN AUTH_APP_USERS_V.GROUP_NAME_SCD_LIST IS 'Semicolon delimited list of associated application group names';
COMMENT ON COLUMN AUTH_APP_USERS_V.GROUP_CODE_SCD_LIST IS 'Semicolon delimited list of associated application group codes';
COMMENT ON COLUMN AUTH_APP_USERS_V.GROUP_NAME_CD_LIST IS 'Comma delimited list of associated application group names';
COMMENT ON COLUMN AUTH_APP_USERS_V.GROUP_CODE_CD_LIST IS 'Comma delimited list of associated application group codes';
COMMENT ON COLUMN AUTH_APP_USERS_V.NUM_GROUPS IS 'The total number of application groups the user belongs to';

COMMENT ON TABLE AUTH_APP_USERS_V IS 'Application Users (View)

This view is used to retrieve the group permissions for a given user.  It returns all of the application users defined in the user authentication and authorization module including delimited lists of the groups that they are assigned to.  ';




--query to retrieve all of the users and groups
CREATE OR REPLACE VIEW
AUTH_APP_USER_GROUPS_V
AS
SELECT

AUTH_APP_USERS.APP_USER_ID,
AUTH_APP_USERS.APP_USER_NAME,
AUTH_APP_USERS.APP_USER_COMMENTS,
AUTH_APP_USERS.APP_USER_ACTIVE_YN,
AUTH_APP_USER_GROUPS.APP_USER_GROUP_ID,
AUTH_APP_GROUPS.APP_GROUP_ID,
AUTH_APP_GROUPS.APP_GROUP_NAME,
AUTH_APP_GROUPS.APP_GROUP_CODE,
AUTH_APP_GROUPS.APP_GROUP_DESC






FROM
  AUTH_APP_USERS
LEFT OUTER JOIN
AUTH_APP_USER_GROUPS ON (AUTH_APP_USERS.APP_USER_ID = AUTH_APP_USER_GROUPS.APP_USER_ID)
LEFT OUTER JOIN AUTH_APP_GROUPS ON (AUTH_APP_USER_GROUPS.APP_GROUP_ID = AUTH_APP_GROUPS.APP_GROUP_ID)
ORDER BY APP_USER_NAME, AUTH_APP_GROUPS.APP_GROUP_CODE;

COMMENT ON COLUMN AUTH_APP_USER_GROUPS_V.APP_USER_ID IS 'Primary Key for the AUTH_APP_USERS table';
COMMENT ON COLUMN AUTH_APP_USER_GROUPS_V.APP_USER_NAME IS 'The LDAP username used to login to the APEX applications';
COMMENT ON COLUMN AUTH_APP_USER_GROUPS_V.APP_USER_COMMENTS IS 'Comments about the given user';
COMMENT ON COLUMN AUTH_APP_USER_GROUPS_V.APP_USER_ACTIVE_YN IS 'Flag to indicate if the given user''s APEX application account is active (Y) or inactive (N)';

COMMENT ON COLUMN AUTH_APP_USER_GROUPS_V.APP_USER_GROUP_ID IS 'Primary Key for the AUTH_APP_USER_GROUPS table';
COMMENT ON COLUMN AUTH_APP_USER_GROUPS_V.APP_GROUP_ID IS 'Primary Key for the AUTH_APP_GROUPS table';
COMMENT ON COLUMN AUTH_APP_USER_GROUPS_V.APP_GROUP_NAME IS 'The name of the given Application Permission Group';
COMMENT ON COLUMN AUTH_APP_USER_GROUPS_V.APP_GROUP_CODE IS 'The code of the given Application Permission Group';
COMMENT ON COLUMN AUTH_APP_USER_GROUPS_V.APP_GROUP_DESC IS 'The description of the given Application Permission Group';


COMMENT ON TABLE AUTH_APP_USER_GROUPS_V IS 'Application User Groups (View)

This view is used to retrieve the group permissions for each user.  It returns all of the application users defined in the user authentication and authorization module and all associated groups they are assigned to.';




  CREATE OR REPLACE TRIGGER "TRG_AUTH_APP_GROUPS_HIST"
AFTER DELETE OR INSERT OR UPDATE
ON AUTH_APP_GROUPS
REFERENCING OLD AS old NEW AS new
FOR EACH ROW
DECLARE
  os_user VARCHAR2(30) := nvl(v('APP_USER'),user);

  PROCEDURE insert_data(
    p_type_of_change IN VARCHAR2,
    p_changed_column IN VARCHAR2 DEFAULT NULL,
    p_old_data       IN VARCHAR2 DEFAULT NULL,
    p_new_data       IN VARCHAR2 DEFAULT NULL ) IS
  BEGIN
    INSERT INTO AUTH_APP_GROUPS_hist (
      h_seqnum, APP_GROUP_ID, h_type_of_change, h_user_making_change, h_os_user,
      h_date_of_change, h_changed_column, h_old_data, h_new_data)
    VALUES(
      AUTH_APP_GROUPS_hist_seq.NEXTVAL, :old.APP_GROUP_ID, p_type_of_change, user, os_user,      SYSDATE, p_changed_column, p_old_data, p_new_data);
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
    INSERT INTO AUTH_APP_GROUPS_hist (
      h_seqnum, APP_GROUP_ID, h_type_of_change, h_user_making_change, h_os_user, h_date_of_change)
    VALUES (
      AUTH_APP_GROUPS_hist_seq.NEXTVAL, :new.APP_GROUP_ID,
      'INSERT', user, os_user, SYSDATE);
  ELSIF DELETING THEN
    insert_data('DELETE');
    insert_data('DELETE', 'app_group_name', :old.app_group_name);
    insert_data('DELETE', 'app_group_code', :old.app_group_code);
    insert_data('DELETE', 'app_group_desc', :old.app_group_desc);
  ELSE
    NULL;
    check_update('APP_GROUP_NAME', :old.app_group_name, :new.app_group_name);
    check_update('APP_GROUP_CODE', :old.app_group_code, :new.app_group_code);
    check_update('APP_GROUP_DESC', :old.app_group_desc, :new.app_group_desc);
  END IF;
END;

/
ALTER TRIGGER "TRG_AUTH_APP_GROUPS_HIST" ENABLE;
--------------------------------------------------------
--  DDL for Trigger TRG_AUTH_APP_USER_GROUPS_HIST
--------------------------------------------------------

  CREATE OR REPLACE TRIGGER "TRG_AUTH_APP_USER_GROUPS_HIST"
AFTER DELETE OR INSERT OR UPDATE
ON AUTH_APP_USER_GROUPS
REFERENCING OLD AS old NEW AS new
FOR EACH ROW
DECLARE
  os_user VARCHAR2(30) := nvl(v('APP_USER'),user);

  PROCEDURE insert_data(
    p_type_of_change IN VARCHAR2,
    p_changed_column IN VARCHAR2 DEFAULT NULL,
    p_old_data       IN VARCHAR2 DEFAULT NULL,
    p_new_data       IN VARCHAR2 DEFAULT NULL ) IS
  BEGIN
    INSERT INTO AUTH_APP_USER_GROUPS_hist (
      h_seqnum, APP_USER_GROUP_ID, h_type_of_change, h_user_making_change, h_os_user,
      h_date_of_change, h_changed_column, h_old_data, h_new_data)
    VALUES(
      AUTH_APP_USER_GROUPS_hist_seq.NEXTVAL, :old.APP_USER_GROUP_ID, p_type_of_change, user, os_user,      SYSDATE, p_changed_column, p_old_data, p_new_data);
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
    INSERT INTO AUTH_APP_USER_GROUPS_hist (
      h_seqnum, APP_USER_GROUP_ID, h_type_of_change, h_user_making_change, h_os_user, h_date_of_change)
    VALUES (
      AUTH_APP_USER_GROUPS_hist_seq.NEXTVAL, :new.APP_USER_GROUP_ID,
      'INSERT', user, os_user, SYSDATE);
  ELSIF DELETING THEN
    insert_data('DELETE');
    insert_data('DELETE', 'app_user_id', :old.app_user_id);
    insert_data('DELETE', 'app_group_id', :old.app_group_id);
  ELSE
    NULL;
    check_update('APP_USER_ID', :old.app_user_id, :new.app_user_id);
    check_update('APP_GROUP_ID', :old.app_group_id, :new.app_group_id);
  END IF;
END;

/
ALTER TRIGGER "TRG_AUTH_APP_USER_GROUPS_HIST" ENABLE;
--------------------------------------------------------
--  DDL for Trigger TRG_AUTH_APP_USERS_HIST
--------------------------------------------------------

  CREATE OR REPLACE TRIGGER "TRG_AUTH_APP_USERS_HIST"
AFTER DELETE OR INSERT OR UPDATE
ON AUTH_APP_USERS
REFERENCING OLD AS old NEW AS new
FOR EACH ROW
DECLARE
  os_user VARCHAR2(30) := nvl(v('APP_USER'),user);

  PROCEDURE insert_data(
    p_type_of_change IN VARCHAR2,
    p_changed_column IN VARCHAR2 DEFAULT NULL,
    p_old_data       IN VARCHAR2 DEFAULT NULL,
    p_new_data       IN VARCHAR2 DEFAULT NULL ) IS
  BEGIN
    INSERT INTO AUTH_APP_USERS_hist (
      h_seqnum, APP_USER_ID, h_type_of_change, h_user_making_change, h_os_user,
      h_date_of_change, h_changed_column, h_old_data, h_new_data)
    VALUES(
      AUTH_APP_USERS_hist_seq.NEXTVAL, :old.APP_USER_ID, p_type_of_change, user, os_user,      SYSDATE, p_changed_column, p_old_data, p_new_data);
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
    INSERT INTO AUTH_APP_USERS_hist (
      h_seqnum, APP_USER_ID, h_type_of_change, h_user_making_change, h_os_user, h_date_of_change)
    VALUES (
      AUTH_APP_USERS_hist_seq.NEXTVAL, :new.APP_USER_ID,
      'INSERT', user, os_user, SYSDATE);
  ELSIF DELETING THEN
    insert_data('DELETE');
    insert_data('DELETE', 'app_user_name', :old.app_user_name);
    insert_data('DELETE', 'app_user_first_name', :old.app_user_first_name);
    insert_data('DELETE', 'app_user_last_name', :old.app_user_last_name);
    insert_data('DELETE', 'app_user_comments', :old.app_user_comments);
    insert_data('DELETE', 'app_user_active_yn', :old.app_user_active_yn);
  ELSE
    NULL;
    check_update('APP_USER_NAME', :old.app_user_name, :new.app_user_name);
    check_update('APP_USER_FIRST_NAME', :old.app_user_first_name, :new.app_user_first_name);
    check_update('APP_USER_LAST_NAME', :old.app_user_last_name, :new.app_user_last_name);
    check_update('APP_USER_COMMENTS', :old.app_user_comments, :new.app_user_comments);
    check_update('APP_USER_ACTIVE_YN', :old.app_user_active_yn, :new.app_user_active_yn);
  END IF;
END;

/
ALTER TRIGGER "TRG_AUTH_APP_USERS_HIST" ENABLE;

ALTER PACKAGE AUTH_APP_PKG COMPILE;

--define the upgrade version in the database:
INSERT INTO DB_UPGRADE_LOGS (UPGRADE_APP_NAME, UPGRADE_VERSION, UPGRADE_DATE, UPGRADE_DESC) VALUES ('Authorization Application Database', '1.1', TO_DATE('14-APR-22', 'DD-MON-YY'), 'Added modified auditing fields to the AUTH_APP_USER_GROUPS table.  Added first/last name fields tothe AUTH_APP_USERS table.  Updated the AUTH_APP_GROUPS.APP_GROUP_CODE not null since it is used in queries to determine the user''s associated group(s).  Updated AUTH_APP_USERS_V and AUTH_APP_USER_GROUPS_V views to include the new AUTH_APP_USERS fields.  Updated all history triggers to capture the application user that makes changes to records since all APEX updates will be logged as "tomcat" using the dsc.dsc_utilities_pkg.os_user function method.');
