/************************************************************************************
 Filename   : deploy_qa_v1.0.sql
 Author     : Jesse Abdul
 Purpose    : PIFSC Personnel Tracking System db changes for version 1.0

 Description: The release included: initial data model deployment for version 1.0 of the DB

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
SELECT 'CCD_DB_deploy_qa_v1.0_' || TO_CHAR( SYSDATE, 'yyyymmdd' ) spool_fname FROM DUAL;
SPOOL logs/&spoolname APPEND


SET DEFINE OFF
SHOW USER;

PROMPT define data schema synonyms
@@"../docs/releases/1.0/Deployment_Scripts/db/define_data_schema_synonyms.sql"

PROMPT running DDL scripts
@@"./upgrades/centralized_cruise_DDL_DML_upgrade_v0.1.sql"
@@"./upgrades/centralized_cruise_DDL_DML_upgrade_v0.2.sql"
@@"./upgrades/centralized_cruise_DDL_DML_upgrade_v0.3.sql"
@@"./upgrades/centralized_cruise_DDL_DML_upgrade_v0.4.sql"
@@"./upgrades/centralized_cruise_DDL_DML_upgrade_v0.5.sql"
@@"./upgrades/centralized_cruise_DDL_DML_upgrade_v0.6.sql"
@@"./upgrades/centralized_cruise_DDL_DML_upgrade_v0.7.sql"
@@"./upgrades/centralized_cruise_DDL_DML_upgrade_v0.8.sql"
@@"./upgrades/centralized_cruise_DDL_DML_upgrade_v0.9.sql"
@@"./upgrades/centralized_cruise_DDL_DML_upgrade_v0.10.sql"
@@"./upgrades/centralized_cruise_DDL_DML_upgrade_v0.11.sql"
@@"./upgrades/centralized_cruise_DDL_DML_upgrade_v0.12.sql"
@@"./upgrades/centralized_cruise_DDL_DML_upgrade_v0.13.sql"
@@"./upgrades/centralized_cruise_DDL_DML_upgrade_v0.14.sql"
@@"./upgrades/centralized_cruise_DDL_DML_upgrade_v0.15.sql"
@@"./upgrades/centralized_cruise_DDL_DML_upgrade_v0.16.sql"
@@"./upgrades/centralized_cruise_DDL_DML_upgrade_v0.17.sql"
@@"./upgrades/centralized_cruise_DDL_DML_upgrade_v0.18.sql"
@@"./upgrades/centralized_cruise_DDL_DML_upgrade_v0.19.sql"
@@"./upgrades/centralized_cruise_DDL_DML_upgrade_v0.20.sql"
@@"./upgrades/centralized_cruise_DDL_DML_upgrade_v0.21.sql"
@@"./upgrades/centralized_cruise_DDL_DML_upgrade_v0.22.sql"
@@"./upgrades/centralized_cruise_DDL_DML_upgrade_v0.23.sql"
@@"./upgrades/centralized_cruise_DDL_DML_upgrade_v0.24.sql"
@@"./upgrades/centralized_cruise_DDL_DML_upgrade_v0.25.sql"
@@"./upgrades/centralized_cruise_DDL_DML_upgrade_v0.26.sql"
@@"./upgrades/centralized_cruise_DDL_DML_upgrade_v0.27.sql"
@@"./upgrades/centralized_cruise_DDL_DML_upgrade_v0.28.sql"
@@"./upgrades/centralized_cruise_DDL_DML_upgrade_v1.0.sql"

PROMPT granting privileges to CCD roles:
@@"../docs/releases/1.0/Deployment_Scripts/db/grant_CCD_role_permissions.sql"

PROMPT loading data
@@"../docs/releases/1.0/Deployment_Scripts/db/load_dev_test_ref_data.sql"
@@"../docs/releases/1.0/Deployment_Scripts/db/load_config_values.sql"

PROMPT load DVM rules
@@"../docs/releases/1.0/Deployment_Scripts/db/load_DVM_rules.sql"

DISCONNECT;

SET DEFINE ON

SPOOL OFF
EXIT
