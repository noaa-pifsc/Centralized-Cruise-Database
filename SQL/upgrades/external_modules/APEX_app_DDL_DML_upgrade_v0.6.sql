--------------------------------------------------------
--------------------------------------------------------
--Database Name: DB Module Packager - APEX Application
--Database Description: DB Module Packager - APEX Application: This collection of custom modules is intended to provide functionality for PIFSC APEX applications
--------------------------------------------------------
--------------------------------------------------------


--------------------------------------------------------
--DB Module Packager - APEX Application - version 0.6 updates:
--------------------------------------------------------
@@upgrades/external_modules/apex_feedback_form_DDL_DML_upgrade_v0.1.sql


--define the upgrade version in the database upgrade log table:
INSERT INTO DB_UPGRADE_LOGS (UPGRADE_APP_NAME, UPGRADE_VERSION, UPGRADE_DATE, UPGRADE_DESC) VALUES ('DB Module Packager - APEX Application', '0.6', TO_DATE('23-JUL-21', 'DD-MON-YY'), 'Installed version 0.1 of the APEX Feedback Form database');

--commit the DB_UPGRADE_LOGS record insertion
COMMIT;
