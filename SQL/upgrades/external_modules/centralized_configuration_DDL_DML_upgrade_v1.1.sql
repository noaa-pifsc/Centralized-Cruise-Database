--------------------------------------------------------
--------------------------------------------------------
--Database Name: Centralized Configuration
--Database Description: This database was developed to provide a database module to define configuration options that can be used by any Oracle database modules
--------------------------------------------------------
--------------------------------------------------------


--------------------------------------------------------
--Centralized Configuration - version 1.1 updates:
--------------------------------------------------------


ALTER TABLE CC_CONFIG_OPTIONS
DROP CONSTRAINT CC_CONFIG_OPTIONS_U1;

CREATE UNIQUE INDEX CC_CONFIG_OPTIONS_U1 ON CC_CONFIG_OPTIONS (UPPER(OPTION_NAME) ASC) ;


--define the upgrade version in the database upgrade log table:
INSERT INTO DB_UPGRADE_LOGS (UPGRADE_APP_NAME, UPGRADE_VERSION, UPGRADE_DATE, UPGRADE_DESC) VALUES ('Centralized Configuration', '1.1', TO_DATE('24-NOV-23', 'DD-MON-YY'), 'Changed the unique OPTION_NAME index to be case-insensitive (UPPER)');

--commit the DB_UPGRADE_LOGS record insertion
COMMIT;
