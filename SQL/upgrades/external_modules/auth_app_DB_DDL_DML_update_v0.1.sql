--------------------------------------------------------
--------------------------------------------------------
--Database Name: Application Authorization Database
--Database Description: This database was originally designed to manage application access and permissions within the application.  This is a flexible method that allows users and permission groups to be defined that will determine if a user has enabled access to the application and what permission(s) they have in the application.
--------------------------------------------------------
--------------------------------------------------------


-------------------------------------------------------------------
--version 0.1 updates:
-------------------------------------------------------------------


--------------------------------------------------------
--  DDL for Table AUTH_APP_USERS
--------------------------------------------------------

  CREATE TABLE "AUTH_APP_USERS" 
   (	"APP_USER_ID" NUMBER, 
	"APP_USER_NAME" VARCHAR2(100), 
	"APP_USER_COMMENTS" VARCHAR2(1000), 
	"APP_USER_ACTIVE_YN" CHAR(1) DEFAULT 'Y', 
	"CREATE_DATE" DATE, 
	"CREATED_BY" VARCHAR2(30), 
	"LAST_MOD_DATE" DATE, 
	"LAST_MOD_BY" VARCHAR2(30)
   ) ;

   COMMENT ON COLUMN "AUTH_APP_USERS"."APP_USER_ID" IS 'Primary Key for the AUTH_APP_USERS table';
   COMMENT ON COLUMN "AUTH_APP_USERS"."APP_USER_NAME" IS 'The LDAP username used to login to the APEX applications';
   COMMENT ON COLUMN "AUTH_APP_USERS"."APP_USER_COMMENTS" IS 'Comments about the given user';
   COMMENT ON COLUMN "AUTH_APP_USERS"."APP_USER_ACTIVE_YN" IS 'Flag to indicate if the given user''s APEX application account is active (Y) or inactive (N)';
   COMMENT ON COLUMN "AUTH_APP_USERS"."CREATE_DATE" IS 'The date on which this record was created in the database';
   COMMENT ON COLUMN "AUTH_APP_USERS"."CREATED_BY" IS 'The Oracle username of the person creating this record in the database';
   COMMENT ON COLUMN "AUTH_APP_USERS"."LAST_MOD_DATE" IS 'The last date on which any of the data in this record was changed';
   COMMENT ON COLUMN "AUTH_APP_USERS"."LAST_MOD_BY" IS 'The Oracle username of the person making the most recent change to this record';
   COMMENT ON TABLE "AUTH_APP_USERS"  IS 'Application Users

This table contains all application users that are authorized to access a given application.  The actual authentication is handled via LDAP queries but the given LDAP user needs a corresponding AUTH_APP_USERS record (based on APP_USER_NAME) with APP_USER_ACTIVE_YN = Y in order to successfully authenticate.  User privileges within the application are determined by the associated User Group(s)';
--------------------------------------------------------
--  DDL for Table AUTH_APP_USER_GROUPS
--------------------------------------------------------

  CREATE TABLE "AUTH_APP_USER_GROUPS" 
   (	"APP_USER_GROUP_ID" NUMBER, 
	"APP_USER_ID" NUMBER, 
	"APP_GROUP_ID" NUMBER, 
	"CREATE_DATE" DATE, 
	"CREATED_BY" VARCHAR2(30)
   ) ;

   COMMENT ON COLUMN "AUTH_APP_USER_GROUPS"."APP_USER_GROUP_ID" IS 'Primary Key for the AUTH_APP_USER_GROUPS table';
   COMMENT ON COLUMN "AUTH_APP_USER_GROUPS"."APP_USER_ID" IS 'The Application User assigned to the given Application Permission Group';
   COMMENT ON COLUMN "AUTH_APP_USER_GROUPS"."APP_GROUP_ID" IS 'The Application Permission Group assigned to the given Application User';
   COMMENT ON COLUMN "AUTH_APP_USER_GROUPS"."CREATE_DATE" IS 'The date on which this record was created in the database';
   COMMENT ON COLUMN "AUTH_APP_USER_GROUPS"."CREATED_BY" IS 'The Oracle username of the person creating this record in the database';
   COMMENT ON TABLE "AUTH_APP_USER_GROUPS"  IS 'Application User Permission Groups

This intersection table defines which Application Users belong to which Application Permissions Groups.  Each user can have one or more assigned Application Permission Groups.';
--------------------------------------------------------
--  DDL for Table AUTH_APP_GROUPS
--------------------------------------------------------

  CREATE TABLE "AUTH_APP_GROUPS" 
   (	"APP_GROUP_ID" NUMBER, 
	"APP_GROUP_NAME" VARCHAR2(100), 
	"APP_GROUP_CODE" VARCHAR2(30), 
	"APP_GROUP_DESC" VARCHAR2(1000), 
	"CREATE_DATE" DATE, 
	"CREATED_BY" VARCHAR2(30), 
	"LAST_MOD_DATE" DATE, 
	"LAST_MOD_BY" VARCHAR2(30)
   ) ;

   COMMENT ON COLUMN "AUTH_APP_GROUPS"."APP_GROUP_ID" IS 'Primary Key for the AUTH_APP_GROUPS table';
   COMMENT ON COLUMN "AUTH_APP_GROUPS"."APP_GROUP_NAME" IS 'The name of the given Application Permission Group';
   COMMENT ON COLUMN "AUTH_APP_GROUPS"."APP_GROUP_CODE" IS 'The code of the given Application Permission Group';
   COMMENT ON COLUMN "AUTH_APP_GROUPS"."APP_GROUP_DESC" IS 'The description of the given Application Permission Group';
   COMMENT ON COLUMN "AUTH_APP_GROUPS"."CREATE_DATE" IS 'The date on which this record was created in the database';
   COMMENT ON COLUMN "AUTH_APP_GROUPS"."CREATED_BY" IS 'The Oracle username of the person creating this record in the database';
   COMMENT ON COLUMN "AUTH_APP_GROUPS"."LAST_MOD_DATE" IS 'The last date on which any of the data in this record was changed';
   COMMENT ON COLUMN "AUTH_APP_GROUPS"."LAST_MOD_BY" IS 'The Oracle username of the person making the most recent change to this record';
   COMMENT ON TABLE "AUTH_APP_GROUPS"  IS 'Application Permission Groups

This table contains all permission groups for the given application that are used to determine what each user is able to do within the application.  Based on the logged in Application Users role they are allowed to perform certain functions.';



ALTER TABLE AUTH_APP_GROUPS  
MODIFY (APP_GROUP_ID NOT NULL);

ALTER TABLE AUTH_APP_GROUPS
ADD CONSTRAINT AUTH_APP_GROUPS_PK PRIMARY KEY 
(
  APP_GROUP_ID 
)
ENABLE;

ALTER TABLE AUTH_APP_GROUPS
ADD CONSTRAINT AUTH_APP_GROUPS_U1 UNIQUE 
(
  APP_GROUP_NAME 
)
ENABLE;

ALTER TABLE AUTH_APP_GROUPS
ADD CONSTRAINT AUTH_APP_GROUPS_U2 UNIQUE 
(
  APP_GROUP_CODE 
)
ENABLE;


ALTER TABLE AUTH_APP_USERS  
MODIFY (APP_USER_ID NOT NULL);

ALTER TABLE AUTH_APP_USERS  
MODIFY (APP_USER_NAME NOT NULL);

ALTER TABLE AUTH_APP_USERS  
MODIFY (APP_USER_ACTIVE_YN NOT NULL);

ALTER TABLE AUTH_APP_USERS
ADD CONSTRAINT AUTH_APP_USERS_PK PRIMARY KEY 
(
  APP_USER_ID 
)
ENABLE;

ALTER TABLE AUTH_APP_USERS
ADD CONSTRAINT AUTH_APP_USERS_U1 UNIQUE 
(
  APP_USER_NAME 
)
ENABLE;

ALTER TABLE AUTH_APP_USER_GROUPS  
MODIFY (APP_USER_GROUP_ID NOT NULL);

ALTER TABLE AUTH_APP_USER_GROUPS  
MODIFY (APP_USER_ID NOT NULL);

ALTER TABLE AUTH_APP_USER_GROUPS  
MODIFY (APP_GROUP_ID NOT NULL);

CREATE INDEX AUTH_APP_USER_GROUPS_I1 ON AUTH_APP_USER_GROUPS (APP_USER_ID);

CREATE INDEX AUTH_APP_USER_GROUPS_I2 ON AUTH_APP_USER_GROUPS (APP_GROUP_ID);


ALTER TABLE AUTH_APP_GROUPS  
MODIFY (APP_GROUP_NAME NOT NULL);


ALTER TABLE AUTH_APP_USER_GROUPS
ADD CONSTRAINT AUTH_APP_USER_GROUPS_PK PRIMARY KEY 
(
  APP_USER_GROUP_ID 
)
ENABLE;

ALTER TABLE AUTH_APP_USER_GROUPS
ADD CONSTRAINT AUTH_APP_USER_GROUPS_U1 UNIQUE 
(
  APP_USER_ID 
, APP_GROUP_ID 
)
ENABLE;



ALTER TABLE AUTH_APP_USER_GROUPS
ADD CONSTRAINT AUTH_APP_USER_GROUPS_FK1 FOREIGN KEY
(
  APP_USER_ID 
)
REFERENCES AUTH_APP_USERS
(
  APP_USER_ID 
)
ENABLE;

ALTER TABLE AUTH_APP_USER_GROUPS
ADD CONSTRAINT AUTH_APP_USER_GROUPS_FK2 FOREIGN KEY
(
  APP_GROUP_ID 
)
REFERENCES AUTH_APP_GROUPS
(
  APP_GROUP_ID 
)
ENABLE;


CREATE SEQUENCE AUTH_APP_GROUPS_SEQ INCREMENT BY 1 START WITH 1;
CREATE SEQUENCE AUTH_APP_USER_GROUPS_SEQ INCREMENT BY 1 START WITH 1;
CREATE SEQUENCE AUTH_APP_USERS_SEQ INCREMENT BY 1 START WITH 1;


CREATE OR REPLACE TRIGGER AUTH_APP_GROUPS_AUTO_BRU BEFORE
  UPDATE
    ON AUTH_APP_GROUPS FOR EACH ROW 
    BEGIN 
      :NEW.LAST_MOD_DATE := SYSDATE;
      :NEW.LAST_MOD_BY := nvl(v('APP_USER'),user);
END;
/



	CREATE OR REPLACE TRIGGER AUTH_APP_USERS_AUTO_BRU BEFORE
  UPDATE
    ON AUTH_APP_USERS FOR EACH ROW 
    BEGIN 
      :NEW.LAST_MOD_DATE := SYSDATE;
      :NEW.LAST_MOD_BY := nvl(v('APP_USER'),user);
END;
/



create or replace TRIGGER AUTH_APP_GROUPS_AUTO_BRI
before insert on AUTH_APP_GROUPS
for each row
begin
  select AUTH_APP_GROUPS_SEQ.nextval into :new.APP_GROUP_ID from dual;
  :NEW.CREATE_DATE := SYSDATE;
  :NEW.CREATED_BY := nvl(v('APP_USER'),user);
end;
/

create or replace TRIGGER AUTH_APP_USER_GROUPS_AUTO_BRI
before insert on AUTH_APP_USER_GROUPS
for each row
begin
  select AUTH_APP_USER_GROUPS_SEQ.nextval into :new.APP_USER_GROUP_ID from dual;
  :NEW.CREATE_DATE := SYSDATE;
  :NEW.CREATED_BY := nvl(v('APP_USER'),user);
end;
/

create or replace TRIGGER AUTH_APP_USERS_AUTO_BRI
before insert on AUTH_APP_USERS
for each row
begin
  select AUTH_APP_USERS_SEQ.nextval into :new.APP_USER_ID from dual;
  :NEW.CREATE_DATE := SYSDATE;
  :NEW.CREATED_BY := nvl(v('APP_USER'),user);
end;
/





--create views to return all of the user's permissions in a semicolon-delimited list:
CREATE OR REPLACE VIEW
AUTH_APP_USERS_V
AS
SELECT

AUTH_APP_USERS.APP_USER_ID,
AUTH_APP_USERS.APP_USER_NAME,
AUTH_APP_USERS.APP_USER_COMMENTS,
AUTH_APP_USERS.APP_USER_ACTIVE_YN,
AUTH_APP_USERS.CREATE_DATE,
AUTH_APP_USERS.CREATED_BY,
AUTH_APP_USERS.LAST_MOD_DATE,
AUTH_APP_USERS.LAST_MOD_BY,
GROUP_INFO.GROUP_NAME_LIST,
GROUP_INFO.GROUP_CODE_LIST,
NVL(GROUP_INFO.NUM_GROUPS, 0) NUM_GROUPS


  
FROM
  AUTH_APP_USERS
LEFT OUTER JOIN
(SELECT

APP_USER_ID,
LISTAGG(APP_GROUP_NAME, '; ') WITHIN GROUP (ORDER BY UPPER(APP_GROUP_NAME)) as GROUP_NAME_LIST,
LISTAGG(APP_GROUP_CODE, '; ') WITHIN GROUP (ORDER BY UPPER(APP_GROUP_CODE)) as GROUP_CODE_LIST,
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
COMMENT ON COLUMN AUTH_APP_USERS_V.APP_USER_NAME IS 'The LDAP username used to login to the APEX applications';
COMMENT ON COLUMN AUTH_APP_USERS_V.APP_USER_COMMENTS IS 'Comments about the given user';
COMMENT ON COLUMN AUTH_APP_USERS_V.APP_USER_ACTIVE_YN IS 'Flag to indicate if the given user''s APEX application account is active (Y) or inactive (N)';
COMMENT ON COLUMN AUTH_APP_USERS_V.CREATE_DATE IS 'The date on which the user record was created in the database';
COMMENT ON COLUMN AUTH_APP_USERS_V.CREATED_BY IS 'The Oracle username of the person creating the user record in the database';
COMMENT ON COLUMN AUTH_APP_USERS_V.LAST_MOD_DATE IS 'The last date on which any of the data in the user record was changed';
COMMENT ON COLUMN AUTH_APP_USERS_V.LAST_MOD_BY IS 'The Oracle username of the person making the most recent change to the user record';
COMMENT ON COLUMN AUTH_APP_USERS_V.GROUP_NAME_LIST IS 'Semicolon delimited list of associated application group names';
COMMENT ON COLUMN AUTH_APP_USERS_V.GROUP_CODE_LIST IS 'Semicolon delimited list of associated application group codes';
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










--authentication/authorization module package:
CREATE OR REPLACE PACKAGE AUTH_APP_PKG
AS

--Custom authorization function that integrates the Application Authentication and Authorization Module
FUNCTION CUST_AUTH_USER(p_username VARCHAR2, p_password VARCHAR2) RETURN BOOLEAN;


END AUTH_APP_PKG;
/

create or replace PACKAGE BODY AUTH_APP_PKG
AS


FUNCTION CUST_AUTH_USER(p_username IN VARCHAR2, p_password IN VARCHAR2) RETURN BOOLEAN IS
--Custom authorization function that integrates the Application Authorization Module:
--this function will use the default APEX workspace authentication and the dsc.dsc_utilities_pkg.authenticate_user_ldap() function to validate the user credentials.  If either of those methods are successful the function will check the auth_app module to confirm if this user is an active user, if so the user will be considered authenticated and authorized to access the application, if not the user will not be allowed to login.
--the function will return FALSE if the user is not authenticated and TRUE if the user was successfully authenticated



--variable to store the return value of the active user query:
temp_active_yn char(1);

BEGIN

    --Use the default APEX workspace authentication to authenticate the user
    IF apex_util.is_login_password_valid(p_username=>p_username, p_password=>p_password) THEN
    
        --the APEX workspace login was successful, query to see if there is a matching active user record:
        select app_user_active_yn into temp_active_yn from auth_app_users_v where upper(app_user_name) = upper(p_username) and app_user_active_yn = 'Y';
    
        --if there is one row returned then the user account exists in the database so the user is authenticated:
        RETURN TRUE;
    ELSE

        --Use the custom LDAP authentication function to authenticate the user:
        IF dsc.dsc_utilities_pkg.authenticate_user_ldap(p_username, p_password) = 'TRUE' THEN
    
            --the user was authenticated via LDAP, query to see if there is a matching active user record:
            select app_user_active_yn into temp_active_yn from auth_app_users_v where upper(app_user_name) = upper(p_username) and app_user_active_yn = 'Y';
    
            --if there is one row returned then the user account exists in the database so the user is authenticated:
            RETURN TRUE;
    
        ELSE
            --the user was not authenticated via LDAP, this is not a valid application user:
            RETURN FALSE;
        
        END IF;
    END IF;
  
    EXCEPTION
        
        --Check if the active user query returned no rows
        WHEN NO_DATA_FOUND THEN
            RETURN FALSE;
    
        --Check if the active user query returned more than one row
        WHEN TOO_MANY_ROWS THEN
            RETURN FALSE;
 
END CUST_AUTH_USER;

END AUTH_APP_PKG;
/


--implement the user history tables for the authorization module:

CREATE TABLE AUTH_APP_GROUPS_HIST 
(
  H_SEQNUM NUMBER(10, 0) NOT NULL 
, APP_GROUP_ID NUMBER NOT NULL 
, H_TYPE_OF_CHANGE VARCHAR2(10 BYTE) NOT NULL 
, H_DATE_OF_CHANGE DATE NOT NULL 
, H_USER_MAKING_CHANGE VARCHAR2(30 BYTE) NOT NULL 
, H_OS_USER VARCHAR2(30 BYTE) NOT NULL 
, H_CHANGED_COLUMN VARCHAR2(30 BYTE) 
, H_OLD_DATA VARCHAR2(4000 BYTE) 
, H_NEW_DATA VARCHAR2(4000 BYTE) 
) 
;
COMMENT ON COLUMN AUTH_APP_GROUPS_HIST.H_SEQNUM IS 'A unique number for this record in the history table';
 COMMENT ON COLUMN AUTH_APP_GROUPS_HIST.APP_GROUP_ID IS 'Primary key column of the data table';
COMMENT ON COLUMN AUTH_APP_GROUPS_HIST.H_TYPE_OF_CHANGE IS 'The type of change is INSERT, UPDATE or DELETE';
COMMENT ON COLUMN AUTH_APP_GROUPS_HIST.H_DATE_OF_CHANGE IS 'The date and time the change was made to the data';
COMMENT ON COLUMN AUTH_APP_GROUPS_HIST.H_USER_MAKING_CHANGE IS 'The person (Oracle username) making the change to the record';
COMMENT ON COLUMN AUTH_APP_GROUPS_HIST.H_OS_USER IS 'The OS username of the person making the change to the record';
COMMENT ON COLUMN AUTH_APP_GROUPS_HIST.H_CHANGED_COLUMN IS 'If the type of change is INSERT or UPDATE, the name of the column being changed';
COMMENT ON COLUMN AUTH_APP_GROUPS_HIST.H_OLD_DATA IS 'The data that has been updated';
COMMENT ON COLUMN AUTH_APP_GROUPS_HIST.H_NEW_DATA IS 'The updated column data';
CREATE TABLE AUTH_APP_USERS_HIST 
(
  H_SEQNUM NUMBER(10, 0) NOT NULL 
, APP_USER_ID NUMBER NOT NULL 
, H_TYPE_OF_CHANGE VARCHAR2(10 BYTE) NOT NULL 
, H_DATE_OF_CHANGE DATE NOT NULL 
, H_USER_MAKING_CHANGE VARCHAR2(30 BYTE) NOT NULL 
, H_OS_USER VARCHAR2(30 BYTE) NOT NULL 
, H_CHANGED_COLUMN VARCHAR2(30 BYTE) 
, H_OLD_DATA VARCHAR2(4000 BYTE) 
, H_NEW_DATA VARCHAR2(4000 BYTE) 
) 
;
COMMENT ON COLUMN AUTH_APP_USERS_HIST.H_SEQNUM IS 'A unique number for this record in the history table';
 COMMENT ON COLUMN AUTH_APP_USERS_HIST.APP_USER_ID IS 'Primary key column of the data table';
COMMENT ON COLUMN AUTH_APP_USERS_HIST.H_TYPE_OF_CHANGE IS 'The type of change is INSERT, UPDATE or DELETE';
COMMENT ON COLUMN AUTH_APP_USERS_HIST.H_DATE_OF_CHANGE IS 'The date and time the change was made to the data';
COMMENT ON COLUMN AUTH_APP_USERS_HIST.H_USER_MAKING_CHANGE IS 'The person (Oracle username) making the change to the record';
COMMENT ON COLUMN AUTH_APP_USERS_HIST.H_OS_USER IS 'The OS username of the person making the change to the record';
COMMENT ON COLUMN AUTH_APP_USERS_HIST.H_CHANGED_COLUMN IS 'If the type of change is INSERT or UPDATE, the name of the column being changed';
COMMENT ON COLUMN AUTH_APP_USERS_HIST.H_OLD_DATA IS 'The data that has been updated';
COMMENT ON COLUMN AUTH_APP_USERS_HIST.H_NEW_DATA IS 'The updated column data';
CREATE TABLE AUTH_APP_USER_GROUPS_HIST 
(
  H_SEQNUM NUMBER(10, 0) NOT NULL 
, APP_USER_GROUP_ID NUMBER NOT NULL 
, H_TYPE_OF_CHANGE VARCHAR2(10 BYTE) NOT NULL 
, H_DATE_OF_CHANGE DATE NOT NULL 
, H_USER_MAKING_CHANGE VARCHAR2(30 BYTE) NOT NULL 
, H_OS_USER VARCHAR2(30 BYTE) NOT NULL 
, H_CHANGED_COLUMN VARCHAR2(30 BYTE) 
, H_OLD_DATA VARCHAR2(4000 BYTE) 
, H_NEW_DATA VARCHAR2(4000 BYTE) 
) 
;
COMMENT ON COLUMN AUTH_APP_USER_GROUPS_HIST.H_SEQNUM IS 'A unique number for this record in the history table';
 COMMENT ON COLUMN AUTH_APP_USER_GROUPS_HIST.APP_USER_GROUP_ID IS 'Primary key column of the data table';
COMMENT ON COLUMN AUTH_APP_USER_GROUPS_HIST.H_TYPE_OF_CHANGE IS 'The type of change is INSERT, UPDATE or DELETE';
COMMENT ON COLUMN AUTH_APP_USER_GROUPS_HIST.H_DATE_OF_CHANGE IS 'The date and time the change was made to the data';
COMMENT ON COLUMN AUTH_APP_USER_GROUPS_HIST.H_USER_MAKING_CHANGE IS 'The person (Oracle username) making the change to the record';
COMMENT ON COLUMN AUTH_APP_USER_GROUPS_HIST.H_OS_USER IS 'The OS username of the person making the change to the record';
COMMENT ON COLUMN AUTH_APP_USER_GROUPS_HIST.H_CHANGED_COLUMN IS 'If the type of change is INSERT or UPDATE, the name of the column being changed';
COMMENT ON COLUMN AUTH_APP_USER_GROUPS_HIST.H_OLD_DATA IS 'The data that has been updated';
COMMENT ON COLUMN AUTH_APP_USER_GROUPS_HIST.H_NEW_DATA IS 'The updated column data';

--create the history table sequences and triggers


--------------------------------------------------------
--  DDL for Sequence AUTH_APP_GROUPS_HIST_SEQ
--------------------------------------------------------

   CREATE SEQUENCE  "AUTH_APP_GROUPS_HIST_SEQ"  MINVALUE 1 MAXVALUE 9999999999999999999999999999 INCREMENT BY 1 START WITH 1 NOCACHE  NOORDER  NOCYCLE ;
--------------------------------------------------------
--  DDL for Sequence AUTH_APP_USER_GROUPS_HIST_SEQ
--------------------------------------------------------

   CREATE SEQUENCE  "AUTH_APP_USER_GROUPS_HIST_SEQ"  MINVALUE 1 MAXVALUE 9999999999999999999999999999 INCREMENT BY 1 START WITH 1 NOCACHE  NOORDER  NOCYCLE ;
--------------------------------------------------------
--  DDL for Sequence AUTH_APP_USERS_HIST_SEQ
--------------------------------------------------------

   CREATE SEQUENCE  "AUTH_APP_USERS_HIST_SEQ"  MINVALUE 1 MAXVALUE 9999999999999999999999999999 INCREMENT BY 1 START WITH 1 NOCACHE  NOORDER  NOCYCLE ;

--------------------------------------------------------
--  DDL for Trigger TRG_AUTH_APP_GROUPS_HIST
--------------------------------------------------------

  CREATE OR REPLACE TRIGGER "TRG_AUTH_APP_GROUPS_HIST" 
AFTER DELETE OR INSERT OR UPDATE
ON AUTH_APP_GROUPS
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
  os_user VARCHAR2(30) := dsc.dsc_utilities_pkg.os_user;

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
  os_user VARCHAR2(30) := dsc.dsc_utilities_pkg.os_user;

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
    insert_data('DELETE', 'app_user_comments', :old.app_user_comments);
    insert_data('DELETE', 'app_user_active_yn', :old.app_user_active_yn);
  ELSE
    NULL;
    check_update('APP_USER_NAME', :old.app_user_name, :new.app_user_name);
    check_update('APP_USER_COMMENTS', :old.app_user_comments, :new.app_user_comments);
    check_update('APP_USER_ACTIVE_YN', :old.app_user_active_yn, :new.app_user_active_yn);
  END IF;
END;

/
ALTER TRIGGER "TRG_AUTH_APP_USERS_HIST" ENABLE;



--define the upgrade version in the database:
INSERT INTO DB_UPGRADE_LOGS (UPGRADE_APP_NAME, UPGRADE_VERSION, UPGRADE_DATE, UPGRADE_DESC) VALUES ('Application Authorization Database', '0.1', TO_DATE('15-AUG-17', 'DD-MON-YY'), 'Initial version of the application authentication/authorization module and support objects');


