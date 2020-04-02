--------------------------------------------------------
--------------------------------------------------------
--Database Name: Authorization Application Database
--Database Description: This database was originally designed to manage application access and permissions within the application.  This is a flexible method that allows users and permission groups to be defined that will determine if a user has enabled access to the application and what permission(s) they have in the application.
--------------------------------------------------------
--------------------------------------------------------


-------------------------------------------------------------------
--version 0.4 updates:
-------------------------------------------------------------------


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
COMMENT ON COLUMN AUTH_APP_USERS_V.APP_USER_NAME IS 'The LDAP username used to login to the APEX applications';
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




--define the upgrade version in the database:
INSERT INTO DB_UPGRADE_LOGS (UPGRADE_APP_NAME, UPGRADE_VERSION, UPGRADE_DATE, UPGRADE_DESC) VALUES ('Authorization Application Database', '0.4', TO_DATE('21-AUG-17', 'DD-MON-YY'), 'Updated the AUTH_APP_USERS_V view to return both semicolon and comma delimited lists of application groups');


