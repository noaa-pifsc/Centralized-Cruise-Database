--------------------------------------------------------
--------------------------------------------------------
--Database Name: Authorization Application Database
--Database Description: This database was originally designed to manage application access and permissions within the application.  This is a flexible method that allows users and permission groups to be defined that will determine if a user has enabled access to the application and what permission(s) they have in the application.
--------------------------------------------------------
--------------------------------------------------------


-------------------------------------------------------------------
--version 0.6 updates:
-------------------------------------------------------------------


comment on table AUTH_APP_GROUPS_HIST is 'Application Permission Groups (history table)

This history table was implemented using the data history tracking package (svn://badfish.pifsc.gov/Oracle/DSC/trunk/apps/db/dsc/dsc_pkgs) to track changes to the Application Permission Groups (AUTH_APP_GROUPS) table';

comment on table AUTH_APP_USERS_HIST is 'Application Users (history table)

This history table was implemented using the data history tracking package (svn://badfish.pifsc.gov/Oracle/DSC/trunk/apps/db/dsc/dsc_pkgs) to track changes to the Application Users (AUTH_APP_USERS) table';


comment on table AUTH_APP_USER_GROUPS_HIST is 'Application User Permission Groups (history table)

This history table was implemented using the data history tracking package (svn://badfish.pifsc.gov/Oracle/DSC/trunk/apps/db/dsc/dsc_pkgs) to track changes to the Application User Permission Groups (AUTH_APP_USER_GROUPS) table';



--define the upgrade version in the database:
INSERT INTO DB_UPGRADE_LOGS (UPGRADE_APP_NAME, UPGRADE_VERSION, UPGRADE_DATE, UPGRADE_DESC) VALUES ('Authorization Application Database', '0.6', TO_DATE('24-MAY-18', 'DD-MON-YY'), 'Defined table comments for the history tables');


