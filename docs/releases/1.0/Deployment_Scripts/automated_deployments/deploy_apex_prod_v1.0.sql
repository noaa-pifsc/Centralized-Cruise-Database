--WHENEVER SQLERROR EXIT 1
--WHENEVER OSERROR  EXIT 1

DEFINE apps_credentials =&1

CONNECT &apps_credentials


COL spool_fname NEW_VALUE spoolname NOPRINT
SELECT 'CCD_deploy_apex_prod_v1.0_'||TO_CHAR(SYSDATE, 'yyyymmdd') spool_fname FROM DUAL;

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
  apex_application_install.set_application_id(200);
end;
 /

PROMPT load the application code for version 1.0
@@"../docs/releases/1.0/Deployment_Scripts/apex/f287-v1.0.sql"

PROMPT load synonyms for the application
@@"../docs/releases/1.0/Deployment_Scripts/apex/create_CRDMA_synonyms.sql"

Disconnect;

SPOOL OFF;
