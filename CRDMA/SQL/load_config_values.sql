--load the application code into the configuration table for the CCD:
INSERT INTO CC_CONFIG_OPTIONS (OPTION_NAME, OPTION_VALUE, OPTION_DESC) VALUES ('CAS_APP_CODE', 'CCD', 'Centralized Authorization System Application Code used to identify this application (Centralized Cruise Database)');

--load the role codes for the different roles defined in the centralized authorization system
INSERT INTO CC_CONFIG_OPTIONS (OPTION_NAME, OPTION_VALUE, OPTION_DESC) VALUES ('CAS_WRITE_ROLE', 'CCD WRITE', 'The data write role code defined within the Centralized Authorization System for the Centralized Cruise Database application');
INSERT INTO CC_CONFIG_OPTIONS (OPTION_NAME, OPTION_VALUE, OPTION_DESC) VALUES ('CAS_ADMIN_ROLE', 'CCD ADMIN', 'The data administrator role code defined within the Centralized Authorization System for the Centralized Cruise Database application');
INSERT INTO CC_CONFIG_OPTIONS (OPTION_NAME, OPTION_VALUE, OPTION_DESC) VALUES ('CAS_READ_ROLE', 'CCD READ', 'The data read role code defined within the Centralized Authorization System for the Centralized Cruise Database application');
