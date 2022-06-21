--------------------------------------------------------
--------------------------------------------------------
--Database Name: Authorization Application Database
--Database Description: This database was originally designed to manage application access and permissions within the application.  This is a flexible method that allows users and permission groups to be defined that will determine if a user has enabled access to the application and what permission(s) they have in the application.
--------------------------------------------------------
--------------------------------------------------------


-------------------------------------------------------------------
--version 1.2 updates:
-------------------------------------------------------------------


CREATE OR REPLACE TRIGGER AUTH_APP_USER_GROUPS_AUTO_BRU BEFORE
  UPDATE
    ON AUTH_APP_USER_GROUPS FOR EACH ROW
    BEGIN
      :NEW.LAST_MOD_DATE := SYSDATE;
      :NEW.LAST_MOD_BY := nvl(v('APP_USER'),user);
END;
/




--define the upgrade version in the database:
INSERT INTO DB_UPGRADE_LOGS (UPGRADE_APP_NAME, UPGRADE_VERSION, UPGRADE_DATE, UPGRADE_DESC) VALUES ('Authorization Application Database', '1.2', TO_DATE('28-APR-22', 'DD-MON-YY'), 'Defined update trigger AUTH_APP_USER_GROUPS_AUTO_BRU for the AUTH_APP_USER_GROUPS table');
