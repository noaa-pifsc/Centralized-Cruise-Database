/************************************************************************************
 Filename   : deploy_qa.sql
 Author     :
 Purpose    : Automated deployment script for the Centralized Cruise database, this is intended for use on the testing environment
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
SELECT 'centralized_cruise_deploy_qa_' || TO_CHAR( SYSDATE, 'yyyymmdd' ) spool_fname FROM DUAL;
SPOOL logs/&spoolname APPEND


SET DEFINE OFF
SHOW USER;


PROMPT define data schema synonyms
@@queries/define_data_schema_synonyms.sql

PROMPT running DDL scripts
@@centralized_cruise_combined_DDL_DML.sql

PROMPT granting privileges to CCD roles:
@@queries/grant_CCD_role_permissions.sql

PROMPT loading data
@@queries/load_dev_test_ref_data.sql
@@queries/load_DVM_rules.sql
@@queries/load_config_values.test.sql



DISCONNECT;

SET DEFINE ON

SPOOL OFF
EXIT
