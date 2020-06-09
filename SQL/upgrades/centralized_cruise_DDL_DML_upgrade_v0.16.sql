--------------------------------------------------------
--------------------------------------------------------
--Database Name: Centralized Cruise Database
--Database Description: Centralized Cruise Database to track information about each PIFSC research cruise including activities, chief scientists, regions, etc. to remove the need for each division/program to manage this information
--------------------------------------------------------
--------------------------------------------------------


--------------------------------------------------------
--Centralized Cruise Database - version 0.16 updates:
--------------------------------------------------------

@@"./external_modules/DVM_DDL_DML_upgrade_v0.5_pt1.sql"

@@"./external_modules/migrate_error_type_assoc_values.sql"

@@"./external_modules/DVM_DDL_DML_upgrade_v0.5_pt2.sql"

@@"./external_modules/DVM_DDL_DML_upgrade_v0.6.sql"

ALTER TABLE CCD_CRUISES RENAME COLUMN PTA_ERROR_ID TO PTA_ISS_ID;

COMMENT ON COLUMN CCD_CRUISES.PTA_ISS_ID IS 'Foreign key reference to the Issues (PTA) intersection table';





--define the upgrade version in the database upgrade log table:
INSERT INTO DB_UPGRADE_LOGS (UPGRADE_APP_NAME, UPGRADE_VERSION, UPGRADE_DATE, UPGRADE_DESC) VALUES ('Centralized Cruise Database', '0.16', TO_DATE('', 'DD-MON-YY'), '');

--commit the DB_UPGRADE_LOGS record insertion
COMMIT;
