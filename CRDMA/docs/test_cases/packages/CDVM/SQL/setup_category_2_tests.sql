/************************************************************************************
 Filename   : setup_category_2_tests.sql
 Purpose    : Automated script for executing test cases for the Centralized Cruise DB
************************************************************************************/
SET FEEDBACK OFF
SET TRIMSPOOL ON
SET VERIFY OFF
SET SQLBLANKLINES ON
SET AUTOCOMMIT OFF
SET EXITCOMMIT OFF
SET TERMOUT ON
--SET ECHO ON

WHENEVER SQLERROR EXIT 1
WHENEVER OSERROR  EXIT 1

PROMPT Please provide credentials in the form: USER@TNS/PASSWORD when using a TNS Name:
SET DEFINE ON
-- Provide credentials in the form: USER@TNS/PASSWORD when using a TNS Name
-- Provide credentials in the form: USER/PASSWORD@HOSTNAME/SID when specifying hostname and SID values
DEFINE apps_credentials=&1
CONNECT &apps_credentials

--SET DEFINE OFF

--DEFINE V_EXPORT_FILE_PREFIX = 'Dev_ODS_PIR_datasets_export_';
--DEFINE V_LOG_FILE_NAME = 'ODS_dev_processing';

--DEFINE V_EXPORT_FILE_NAME = &1;
--DEFINE V_LOG_FILE_NAME = &2;

--PROMPT the value of V_LOG_FILE_NAME is: &V_LOG_FILE_NAME.
--PROMPT the value of V_EXPORT_FILE_NAME is: &V_EXPORT_FILE_NAME.


-- Provide credentials in the form: USER@TNS/PASSWORD when using a TNS Name
-- Provide credentials in the form: USER/PASSWORD@HOSTNAME/SID when specifying hostname and SID values
--DEFINE apps_credentials=&1
--SET ECHO OFF
--@@credentials/dev_ODS_credentials.sql
--CONNECT &apps_credentials
--SET ECHO ON

SET TERMOUT OFF;


--retrieve the current timestamp
COLUMN START_DATE_TIME_VALUE new_value V_START_DATE_TIME_VALUE
SELECT to_char(SYSDATE, 'YYYYMMDD HH:MI:SS AM') AS START_DATE_TIME_VALUE from dual;

--PROMPT V_START_DATE_TIME_VALUE IS: &V_START_DATE_TIME_VALUE.

--COLUMN DATE_VALUE new_value V_DATE_VALUE
--SELECT to_char(SYSDATE, 'YYYYMMDD') AS DATE_VALUE from dual;

COLUMN DATE_TIME_VALUE new_value V_CURR_DATE_TIME_VALUE
SELECT to_char(SYSDATE, 'YYYYMMDD HH:MI:SS AM') AS DATE_TIME_VALUE from dual;

--DEFINE V_LOG_FILE_NAME = &V_EXPORT_FILE_NAME.


SET TERMOUT ON;
--SET FEEDBACK OFF;
--SET ECHO OFF;
--SPOOL ./logs/&V_LOG_FILE_NAME. append;
PROMPT &V_CURR_DATE_TIME_VALUE. - Running automated DVM test cases: setup_category_2_tests.sql
PROMPT &V_CURR_DATE_TIME_VALUE. - Connected as &_USER
--SPOOL OFF;
--SET ECHO ON;





--SET DEFINE OFF;

--category 1 scripts:
PROMPT &V_CURR_DATE_TIME_VALUE. - Run category 2 test setup scripts

SET TERMOUT OFF;
SET FEEDBACK OFF;
SET ECHO OFF;

--@@ODS_export.sql "&V_LOG_FILE_NAME" "&V_EXPORT_FILE_PREFIX" "&V_CURR_DATE_TIME_VALUE"
@@category_2_exec_all_scripts.sql



SET ECHO OFF;




--get the current date/time
SELECT to_char(SYSDATE, 'YYYYMMDD HH:MI:SS AM') AS END_DATE_TIME_VALUE from dual;

SET TERMOUT ON;
SET DEFINE ON;

PROMPT &V_CURR_DATE_TIME_VALUE. - The Category 2 setup has completed


SET TERMOUT OFF;

--retrieve the current timestamp
COLUMN END_DATE_TIME_VALUE new_value V_END_DATE_TIME_VALUE
SELECT to_char(SYSDATE, 'YYYYMMDD HH:MI:SS AM') AS END_DATE_TIME_VALUE from dual;

--SET DEFINE OFF;

COLUMN ELAPSED_TIME_MIN new_value V_ELAPSED_TIME_MIN
SELECT TRIM(ROUND((to_date('&&V_END_DATE_TIME_VALUE', 'YYYYMMDD HH:MI:SS AM') - to_date('&&V_START_DATE_TIME_VALUE', 'YYYYMMDD HH:MI:SS AM')) * 24 * 60, 2)) AS ELAPSED_TIME_MIN from dual;

--add a logging message:
--SPOOL ./logs/&V_LOG_FILE_NAME append;

SET TERMOUT ON;


PROMPT &V_END_DATE_TIME_VALUE. - category 2 test case setup has completed, the entire process took &V_ELAPSED_TIME_MIN. minutes


DISCONNECT;

EXIT;
