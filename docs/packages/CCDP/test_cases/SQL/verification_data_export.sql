/************************************************************************************
 Filename   : verification_data_export.sql
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
PROMPT &V_CURR_DATE_TIME_VALUE. - Running automated CCD_CRUISE_PKG test cases: verification_data_export.sql
PROMPT &V_CURR_DATE_TIME_VALUE. - Connected as &_USER
--SPOOL OFF;
--SET ECHO ON;



--SET DEFINE OFF;

--category 1 scripts:
PROMPT &V_CURR_DATE_TIME_VALUE. - Run category 1 test case scripts

SET TERMOUT OFF;
SET FEEDBACK OFF;
SET ECHO OFF;

--@@ODS_export.sql "&V_LOG_FILE_NAME" "&V_EXPORT_FILE_PREFIX" "&V_CURR_DATE_TIME_VALUE"
@@category_1_exec_all_scripts.sql



SET ECHO OFF;





--SET DEFINE ON;
--add a logging message:

SELECT to_char(SYSDATE, 'YYYYMMDD HH:MI:SS AM') AS DATE_TIME_VALUE from dual;


SET DEFINE ON;

SET TERMOUT ON;


PROMPT &V_CURR_DATE_TIME_VALUE. - Export the verification data to a .txt file
--SPOOL OFF;
--SET ECHO ON;





set markup csv off;
SET TERMOUT OFF;
--SET NEWPAGE 0;
--SET PAGESIZE 0;
SET ECHO OFF;
--SET longchunksize 2000;
--SET LONG 2000;
SET FEEDBACK ON;
--SET longchunksize 2000;
--SET LONG 2000;
SET LINESIZE 2000;

spool ../verification_templates/automated/category_1_script_output_verification-2.txt

@@category_1_exec_test_cases.sql

spool off;

--get the current date/time
SELECT to_char(SYSDATE, 'YYYYMMDD HH:MI:SS AM') AS END_DATE_TIME_VALUE from dual;

SET TERMOUT ON;

PROMPT &V_CURR_DATE_TIME_VALUE. - The Category 1 tests have completed



SET TERMOUT OFF;


SELECT to_char(SYSDATE, 'YYYYMMDD HH:MI:SS AM') AS DATE_TIME_VALUE from dual;


SET TERMOUT ON;

--category 2 scripts:
PROMPT &V_CURR_DATE_TIME_VALUE. - Run category 2 test case scripts

SET TERMOUT OFF;
SET FEEDBACK OFF;
SET ECHO OFF;

--@@ODS_export.sql "&V_LOG_FILE_NAME" "&V_EXPORT_FILE_PREFIX" "&V_CURR_DATE_TIME_VALUE"
@@category_2_exec_all_scripts.sql



SET ECHO OFF;





--SET DEFINE ON;
--add a logging message:
SELECT to_char(SYSDATE, 'YYYYMMDD HH:MI:SS AM') AS DATE_TIME_VALUE from dual;

SET DEFINE ON;

SET TERMOUT ON;

PROMPT &V_CURR_DATE_TIME_VALUE. - Export the verification data to a .csv file
--SPOOL OFF;
--SET ECHO ON;





SET FEEDBACK OFF;
set markup csv on;
SET TERMOUT OFF;
SET NEWPAGE 0;
SET PAGESIZE 0;
SET ECHO OFF;
SET longchunksize 2000;
SET LONG 2000;

--export the CCDP verification data
spool ../verification_templates/automated/category_2_CCDP_verification-2.csv

Select * from CCD_CCDP_DEEP_COPY_CMP_V order by 1, 3;

spool off;



--export the DVM verification data
spool ../verification_templates/automated/category_2_DVM_verification-2.csv

select cruise_name, LEG_NAME_CD_LIST, iss_severity_code, iss_type_name, iss_type_desc, ISS_DESC, IND_FIELD_NAME from CCD_CRUISE_SUMM_ISS_V order by cruise_name, iss_severity_code, iss_type_name, TO_CHAR(iss_desc);

spool off;



--get the current date/time
SELECT to_char(SYSDATE, 'YYYYMMDD HH:MI:SS AM') AS END_DATE_TIME_VALUE from dual;

SET TERMOUT ON;

PROMPT &V_CURR_DATE_TIME_VALUE. - The Category 2 tests have completed



SET TERMOUT OFF;



--SET DEFINE OFF;
--SET ECHO ON;



--SET ECHO OFF;
--SET DEFINE ON;
--SET TERMOUT ON;
--SET FEEDBACK ON;

--retrieve the current timestamp
COLUMN END_DATE_TIME_VALUE new_value V_END_DATE_TIME_VALUE
SELECT to_char(SYSDATE, 'YYYYMMDD HH:MI:SS AM') AS END_DATE_TIME_VALUE from dual;

--SET DEFINE OFF;

COLUMN ELAPSED_TIME_MIN new_value V_ELAPSED_TIME_MIN
SELECT TRIM(ROUND((to_date('&&V_END_DATE_TIME_VALUE', 'YYYYMMDD HH:MI:SS AM') - to_date('&&V_START_DATE_TIME_VALUE', 'YYYYMMDD HH:MI:SS AM')) * 24 * 60, 2)) AS ELAPSED_TIME_MIN from dual;

--add a logging message:
--SPOOL ./logs/&V_LOG_FILE_NAME append;

SET TERMOUT ON;


PROMPT &V_END_DATE_TIME_VALUE. - CCDP automated test cases script has completed, the entire process took &V_ELAPSED_TIME_MIN. minutes
--SPOOL OFF;
--SET ECHO ON;

DISCONNECT;

EXIT;
