--------------------------------------------------------
--------------------------------------------------------
--Database Name: Authorization Application Database
--Database Description: This database was originally designed to manage application access and permissions within the application.  This is a flexible method that allows users and permission groups to be defined that will determine if a user has enabled access to the application and what permission(s) they have in the application.
--------------------------------------------------------
--------------------------------------------------------


-------------------------------------------------------------------
--version 0.5 updates:
-------------------------------------------------------------------




--recompile all invalid packages:

begin FOR cur IN (SELECT OBJECT_NAME, OBJECT_TYPE, owner FROM all_objects WHERE object_type in ('PACKAGE','PACKAGE BODY') and owner = sys_context( 'userenv', 'current_schema' ) AND status = 'INVALID' ) LOOP 
BEGIN
  if cur.OBJECT_TYPE = 'PACKAGE BODY' then 
    EXECUTE IMMEDIATE 'alter package "' || cur.owner || '"."' || cur.OBJECT_NAME || '" compile body'; 
  else 
    EXECUTE IMMEDIATE 'alter ' || cur.OBJECT_TYPE || ' "' || cur.owner || '"."' || cur.OBJECT_NAME || '" compile'; 
  end if; 
EXCEPTION
  WHEN OTHERS THEN NULL; 
END;
end loop; end;

/

--define the upgrade version in the database:
INSERT INTO DB_UPGRADE_LOGS (UPGRADE_APP_NAME, UPGRADE_VERSION, UPGRADE_DATE, UPGRADE_DESC) VALUES ('Authorization Application Database', '0.5', TO_DATE('23-AUG-17', 'DD-MON-YY'), 'Bug Fix - recompiling invalid package after the AUTH_APP_USERS_V view was updated in version 0.4');


