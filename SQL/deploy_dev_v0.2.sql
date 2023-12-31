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
--@@upgrades/centralized_cruise_DDL_DML_upgrade_v0.1.sql
@@upgrades/centralized_cruise_DDL_DML_upgrade_v0.2.sql

PROMPT granting privileges to CTD data schema
GRANT REFERENCES ON CCD_CRUISE_LEGS TO CEN_CTD;
GRANT REFERENCES ON CCD_CRUISES TO CEN_CTD;
GRANT SELECT ON CCD_CRUISE_LEG_ALIASES_V TO CEN_CTD with grant option;
GRANT SELECT ON CCD_CRUISE_LEGS TO CEN_CTD WITH GRANT OPTION;


GRANT SELECT ON CCD_CRUISE_LEGS TO CCD_INTEG_ROLE;
GRANT SELECT ON CCD_CRUISES TO CCD_INTEG_ROLE;
GRANT SELECT ON CCD_CRUISE_LEG_ALIASES_V TO CCD_INTEG_ROLE;
GRANT SELECT ON CCD_LEG_ALIASES TO CCD_INTEG_ROLE;


--@@../CRDMA/SQL/cen_cruise_app_grant_privs.sql

PROMPT loading data
--@@queries/load_ref_data.sql
--@@queries/load_DVM_rules.sql
--@@../CRDMA/SQL/load_config_values.sql



DISCONNECT;

SET DEFINE ON

SPOOL OFF
EXIT
