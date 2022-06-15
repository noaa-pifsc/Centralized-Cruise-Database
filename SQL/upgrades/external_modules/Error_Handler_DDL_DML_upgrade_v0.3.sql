--------------------------------------------------------
--------------------------------------------------------
--Database Name: Error Handler
--Database Description: This database was originally developed to provide a method to address security control SI-11 and provide all PIFSC APEX developers the ability to secure their applications using a simple function that will remove potentially sensitive security information from database error messages that could be used to launch directed attacks on the underlying systems
--------------------------------------------------------
--------------------------------------------------------

--------------------------------------------------------
--version 0.3 updates:
--------------------------------------------------------

--increase the character limit for the CUST_ERR_CONSTR_MSG.CONSTR_NAME field based on maximum length of constraint names (128 characters)
ALTER TABLE CUST_ERR_CONSTR_MSG
MODIFY (CONSTR_NAME VARCHAR2(128 BYTE) );


ALTER PACKAGE CUST_ERR_PKG COMPILE;


--define the upgrade version in the database:
INSERT INTO DB_UPGRADE_LOGS (UPGRADE_APP_NAME, UPGRADE_VERSION, UPGRADE_DATE, UPGRADE_DESC) VALUES ('Error Handler', '0.3', TO_DATE('21-JUN-21', 'DD-MON-YY'), 'Increased the character limit for the CUST_ERR_CONSTR_MSG.CONSTR_NAME field based on maximum length of constraint names (128 characters)');

COMMIT;
