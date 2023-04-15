--WHENEVER SQLERROR EXIT 1
--WHENEVER OSERROR  EXIT 1

DEFINE apps_credentials =&1

CONNECT &apps_credentials


COL spool_fname NEW_VALUE spoolname NOPRINT
SELECT 'CEN_CRUISE_APP_deploy_apex_qa_'||TO_CHAR(SYSDATE, 'yyyymmdd') spool_fname FROM DUAL;

SPOOL logs/&spoolname APPEND

SHOW USER;

PROMPT select CEN_CRUISE_APP workspace

declare
  v_workspace_id NUMBER;
begin
  select workspace_id into v_workspace_id
  from apex_workspaces where workspace = 'CEN_CRUISE_APP';
  apex_application_install.set_workspace_id (v_workspace_id);
  apex_application_install.generate_offset;
end;
 /

PROMPT load synonyms for the application
@@../CRDMA/SQL/create_CRDMA_synonyms.sql

PROMPT load the application code
@@../CRDMA/application_code/f287.sql

Disconnect;

SPOOL OFF;
