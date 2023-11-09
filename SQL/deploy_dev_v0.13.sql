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
@@upgrades/centralized_cruise_DDL_DML_upgrade_v0.10.sql
@@upgrades/centralized_cruise_DDL_DML_upgrade_v0.11.sql
@@upgrades/centralized_cruise_DDL_DML_upgrade_v0.12.sql
@@upgrades/centralized_cruise_DDL_DML_upgrade_v0.13.sql

GRANT EXECUTE ON CEN_CRUISE.CCD_CRUISE_PKG TO CCD_INTEG_ROLE;

GRANT EXECUTE ON CEN_CRUISE.CCD_CRUISE_PKG TO CEN_CTD WITH GRANT OPTION;

/*ALTER PACKAGE CRUISE_PKG COMPILE;
ALTER TRIGGER CCD_CRUISES_AUTO_BRI COMPILE;

PROMPT granting privileges to CEN_CTD data schema
grant select on CEN_CRUISE.CCD_CRUISE_DELIM_V to CEN_CTD with grant option;
grant select on CEN_CRUISE.CCD_CRUISE_LEG_DELIM_V to CEN_CTD with grant option;
grant select on CEN_CRUISE.CCD_CRUISE_LEGS_V to CEN_CTD with grant option;
grant select on CEN_CRUISE.CCD_CRUISE_SUMM_V to CEN_CTD with grant option;
grant select on CEN_CRUISE.CCD_CRUISE_V to CEN_CTD with grant option;
grant select on CEN_CRUISE.CCD_LEG_DELIM_V to CEN_CTD with grant option;
grant select on CEN_CRUISE.CCD_LEG_V to CEN_CTD with grant option;


grant select, references on CEN_CRUISE.CCD_CRUISES to CEN_CTD;
grant select, references on CEN_CRUISE.CCD_CRUISE_LEGS to CEN_CTD;
grant select on CEN_CRUISE.CCD_LEG_ALIASES to CEN_CTD;
*/
PROMPT loading data
--@@queries/load_ref_data.sql
--@@queries/load_DVM_rules.sql
--@@../CRDMA/SQL/load_config_values.sql



DISCONNECT;

SET DEFINE ON

SPOOL OFF
EXIT
