--------------------------------------------------------
--------------------------------------------------------
--Database Name: Authorization Application Database
--Database Description: This database was originally designed to manage application access and permissions within the application.  This is a flexible method that allows users and permission groups to be defined that will determine if a user has enabled access to the application and what permission(s) they have in the application.
--------------------------------------------------------
--------------------------------------------------------


-------------------------------------------------------------------
--version 0.8 updates:
-------------------------------------------------------------------


ALTER TABLE AUTH_APP_GROUPS_HIST ADD CONSTRAINT AUTH_APP_GROUPS_HIST_PK PRIMARY KEY (H_SEQNUM) ENABLE;
ALTER TABLE AUTH_APP_USERS_HIST ADD CONSTRAINT AUTH_APP_USERS_HIST_PK PRIMARY KEY (H_SEQNUM) ENABLE;
ALTER TABLE AUTH_APP_USER_GROUPS_HIST ADD CONSTRAINT AUTH_APP_USER_GROUPS_HIST_PK PRIMARY KEY (H_SEQNUM) ENABLE;



--define the upgrade version in the database:
INSERT INTO DB_UPGRADE_LOGS (UPGRADE_APP_NAME, UPGRADE_VERSION, UPGRADE_DATE, UPGRADE_DESC) VALUES ('Authorization Application Database', '0.8', TO_DATE('30-NOV-20', 'DD-MON-YY'), 'Updated the data model to define primary key constraints for the history tracking tables, this will allow the Centralized Utilities Package (git@gitlab.pifsc.gov:centralized-data-tools/centralized-utilities.git) to verify data using the file based verification method.');
