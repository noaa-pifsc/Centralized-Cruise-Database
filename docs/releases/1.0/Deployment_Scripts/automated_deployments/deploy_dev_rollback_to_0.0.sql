/************************************************************************************
 Filename   : deploy_dev_rollback_to_0.0.sql
 Author     : Jesse Abdul
 Purpose    : Centralized Authorization System db changes to rollback version 1.0 to 0.0

 Description: The release included reverting changes from the version 0.0 to 1.0 upgrade process

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
-- CCD
DEFINE apps_credentials=&1
CONNECT &apps_credentials


COL spool_fname NEW_VALUE spoolname NOPRINT
SELECT 'CCD_DB_deploy_rollback_v1.0_to_v0.0_dev_' || TO_CHAR( SYSDATE, 'yyyymmdd' ) spool_fname FROM DUAL;
SPOOL logs/&spoolname APPEND


SET DEFINE OFF
SHOW USER;

PROMPT rollback the database changes
@@"../docs/releases/1.0/Deployment_Scripts/rollback/db_downgrade_1.0_to_0.0.sql"

DISCONNECT;

SET DEFINE ON

SPOOL OFF
EXIT
