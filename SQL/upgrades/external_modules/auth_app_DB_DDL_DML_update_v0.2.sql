--------------------------------------------------------
--------------------------------------------------------
--Database Name: Authorization Application Database
--Database Description: This database was originally designed to manage application access and permissions within the application.  This is a flexible method that allows users and permission groups to be defined that will determine if a user has enabled access to the application and what permission(s) they have in the application.
--------------------------------------------------------
--------------------------------------------------------


-------------------------------------------------------------------
--version 0.2 updates:
-------------------------------------------------------------------


COMMENT ON TABLE "AUTH_APP_USERS"  IS 'Application Users

This table contains all application users that are authorized to access a given application.  The actual authentication is handled via LDAP queries but the given LDAP user needs a corresponding AUTH_APP_USERS record (based on APP_USER_NAME) with APP_USER_ACTIVE_YN = Y in order to be authorized to access the given application.  User privileges within the application are determined by the associated User Group(s)';

COMMENT ON TABLE AUTH_APP_USERS_V IS 'Application Users (View)

This view is used to retrieve the group permissions for a given user.  It returns all of the application users defined in the user authorization module including delimited lists of the groups that they are assigned to.  ';


COMMENT ON TABLE AUTH_APP_USER_GROUPS_V IS 'Application User Groups (View)

This view is used to retrieve the group permissions for each user.  It returns all of the application users defined in the user authorization module and all associated groups they are assigned to.';


--update the application name in the upgrade logs:
UPDATE DB_UPGRADE_LOGS SET UPGRADE_APP_NAME = 'Authorization Application Database', UPGRADE_DESC = 'Initial version of the authorization application module and support objects' where UPGRADE_APP_NAME = 'Application Authorization Database' and upgrade_version = '0.1';


--define the upgrade version in the database:
INSERT INTO DB_UPGRADE_LOGS (UPGRADE_APP_NAME, UPGRADE_VERSION, UPGRADE_DATE, UPGRADE_DESC) VALUES ('Authorization Application Database', '0.2', TO_DATE('16-AUG-17', 'DD-MON-YY'), 'Updated comments on the tables/views and updated the app name/upgrade description of the upgrade in the DB upgrade logs');


