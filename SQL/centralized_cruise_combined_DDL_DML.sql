--------------------------------------------------------
--------------------------------------------------------
--Database Name: Centralized Cruise Database
--Database Description: Centralized Cruise Database to track information about each PIFSC research cruise including activities, chief scientists, regions, etc. to remove the need for each division/program to manage this information 
--------------------------------------------------------
--------------------------------------------------------


--------------------------------------------------------
--Centralized Cruise Database - Combined DDL/DML file:
--------------------------------------------------------

--add each database upgrade file in sequential order here:
@@"./upgrades/centralized_cruise_DDL_DML_upgrade_v0.1.sql"
@@"./upgrades/centralized_cruise_DDL_DML_upgrade_v0.2.sql"