--------------------------------------------------------
--------------------------------------------------------
--Database Name: Database Log
--Database Description: This module was created to log information in the database for various backend operations.  This is preferable to a file-based log since it can be easily queried, filtered, searched, and used for reporting purposes
--------------------------------------------------------
--------------------------------------------------------


--------------------------------------------------------
--Database Log - version 0.2 updates:
--------------------------------------------------------

ALTER TABLE DB_LOG_ENTRIES
MODIFY (LOG_SOURCE VARCHAR2(2000 BYTE) );

ALTER VIEW DB_LOG_ENTRIES_V COMPILE;

--define the upgrade version in the database upgrade log table:
INSERT INTO DB_UPGRADE_LOGS (UPGRADE_APP_NAME, UPGRADE_VERSION, UPGRADE_DATE, UPGRADE_DESC) VALUES ('Database Log', '0.2', TO_DATE('08-JUL-20', 'DD-MON-YY'), 'Increased the size of DB_LOG_ENTRIES.LOG_SOURCE to accommodate additional use cases.  Recompiled the dependent view DB_LOG_ENTRIES_V');
