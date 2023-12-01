/************************************************************************************
 Filename   : deploy_apex_dev_rollback_to_0.0.sql
 Author     : Jesse Abdul
 Purpose    : Centralized Authorization System apex changes to rollback version 1.1 to 0.0

 Description: The release included reverting changes from the version 0.0 to 1.1 upgrade process

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
-- CAS
DEFINE apps_credentials=&1
CONNECT &apps_credentials


COL spool_fname NEW_VALUE spoolname NOPRINT
SELECT 'CAS_DB_deploy_rollback_v1.2_to_v0.0_dev_' || TO_CHAR( SYSDATE, 'yyyymmdd' ) spool_fname FROM DUAL;
SPOOL logs/&spoolname APPEND


SET DEFINE OFF
SHOW USER;

PROMPT rollback the database changes
@@"../docs/releases/1.1/Deployment_Scripts/rollback/remove_apex_app.sql"

PROMPT remove synonyms
@@"../docs/releases/1.1/Deployment_Scripts/rollback/drop_app_synonyms.sql"

DISCONNECT;

SET DEFINE ON

SPOOL OFF
EXIT
