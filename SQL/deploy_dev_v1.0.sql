/************************************************************************************
 Filename   : deploy_dev.sql
 Author     :
 Purpose    : Automated deployment script for the Centralized Cruise database, this is intended for use on the development environment
 Description: The release included: data model deployment on a blank schema
 Usage: Using Windows X open a command line window and change the directory to the SQL directory in the working copy of the repository and execute the script using the "@" syntax.  When prompted enter the server credentials in the format defined in the corresponding code comments
************************************************************************************/
SET FEEDBACK ON
SET TRIMSPOOL ON
SET VERIFY OFF
SET SQLBLANKLINES ON
SET AUTOCOMMIT OFF
SET EXITCOMMIT OFF
SET ECHO ON

WHENEVER SQLERROR EXIT 1
WHENEVER OSERROR  EXIT 1

SET DEFINE ON
-- Provide credentials in the form: USER@TNS/PASSWORD when using a TNS Name
-- Provide credentials in the form: USER/PASSWORD@HOSTNAME/SID when specifying hostname and SID values
DEFINE apps_credentials=&1
CONNECT &apps_credentials


COL spool_fname NEW_VALUE spoolname NOPRINT
SELECT 'centralized_cruise_deploy_dev_' || TO_CHAR( SYSDATE, 'yyyymmdd' ) spool_fname FROM DUAL;
SPOOL logs/&spoolname APPEND


SET DEFINE OFF
SHOW USER;

PROMPT running DDL scripts
@@upgrades/centralized_cruise_DDL_DML_upgrade_v0.14.sql
@@upgrades/centralized_cruise_DDL_DML_upgrade_v0.15.sql
@@upgrades/centralized_cruise_DDL_DML_upgrade_v0.16.sql
@@upgrades/centralized_cruise_DDL_DML_upgrade_v0.17.sql
@@upgrades/centralized_cruise_DDL_DML_upgrade_v0.18.sql
@@upgrades/centralized_cruise_DDL_DML_upgrade_v0.19.sql
@@upgrades/centralized_cruise_DDL_DML_upgrade_v0.20.sql
@@upgrades/centralized_cruise_DDL_DML_upgrade_v0.21.sql
@@upgrades/centralized_cruise_DDL_DML_upgrade_v0.22.sql
@@upgrades/centralized_cruise_DDL_DML_upgrade_v0.23.sql
@@upgrades/centralized_cruise_DDL_DML_upgrade_v0.24.sql
@@upgrades/centralized_cruise_DDL_DML_upgrade_v0.25.sql
@@upgrades/centralized_cruise_DDL_DML_upgrade_v0.26.sql
@@upgrades/centralized_cruise_DDL_DML_upgrade_v0.27.sql
@@upgrades/centralized_cruise_DDL_DML_upgrade_v0.28.sql
@@upgrades/centralized_cruise_DDL_DML_upgrade_v1.0.sql

PROMPT granting privileges to CCD roles:
@@queries/grant_CCD_role_permissions.sql

PROMPT granting privileges to CTD data schema
grant select on CEN_CRUISE.CCD_CRUISE_DELIM_V to CEN_CTD with grant option;
grant select on CEN_CRUISE.CCD_CRUISE_LEG_DELIM_V to CEN_CTD with grant option;
grant select on CEN_CRUISE.CCD_CRUISE_LEG_V to CEN_CTD with grant option;
grant select on CEN_CRUISE.CCD_CRUISE_SUMM_V to CEN_CTD with grant option;
grant select on CEN_CRUISE.CCD_CRUISE_V to CEN_CTD with grant option;
grant select on CEN_CRUISE.CCD_LEG_DELIM_V to CEN_CTD with grant option;
grant select on CEN_CRUISE.CCD_LEG_V to CEN_CTD with grant option;
grant references on CEN_CRUISE.CCD_CRUISES to CEN_CTD;
grant references on CEN_CRUISE.CCD_CRUISE_LEGS to CEN_CTD;

PROMPT loading data
@@queries/load_dev_test_ref_data.sql
@@queries/load_DVM_rules.sql
@@../CRDMA/SQL/load_config_values.sql



DISCONNECT;

SET DEFINE ON

SPOOL OFF
EXIT
