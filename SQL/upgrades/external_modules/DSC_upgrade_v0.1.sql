-- Unable to render PACKAGE DDL for object DSC.DSC_UTILITIES_PKG with DBMS_METADATA attempting internal generator.
CREATE OR REPLACE
PACKAGE     DSC.DSC_UTILITIES_PKG
AUTHID DEFINER
IS

--===========================================================================
--   Application:   COMMON
--   Script Name:   dsc_utilities_pkg.pks
--   Author:        Pauli Salmu
--   Purpose:
--      Creates a package of utility functions and procedures.
--
--    Modifications:
--      Date:       Person:    Reason:
--      26-OCT-2004 psalmu     Created.
--      22-NOV-2004 psalmu     Added function authenticate_user.
--      24-NOV-2004 psalmu     Added empty_vc_arr.
--      26-NOV-2004 psalmu     Added function initcapsent.
--      05-OCT-2005 psalmu     Added function pk_columns.
--      08-DEC-2005 psalmu     Added function valid_email_yn.
--      29-DEC-2005 psalmu     Added procedure send_mail.
--      18-JUL-2006 psalmu     Added function authenticate_user_ldap.
--      08-SEP-2006 psalmu     Added function ldap_search_simple.
--      14-SEP-2006 psalmu     Added function constraint_columns.
--      09-JUL-2007 psalmu     Added functions authenticate_user_pipe,
--                             password_pipe and password_from_pipe.
--      16-OCT-2007 psalmu     Added function noaa_locator_url.
--      12-DEC-2007 psalmu     Added function user_has_role_yn.
--      10-MAR-2008 psalmu     Added function password_grace_days.
--                             Requires granting select on dba_profiles to dsc.
--      08-APR-2008 jpappas    Put objects in alpha order; added standalone dsc
--                             functions and procedures: charrep, dflt_rolelist,
--                             ins_col_comment, mod_dflt_roles, longprint, putln,
--                             rcvmsg, sendmsg, sess_rolelist, set_the_role
--      17-APR-2008 jpappas    Added procedure do_dml (was in newobs)
--      18-APR-2008 jpappas    Added pad_objname (was in hlmodel)
--      22-APR-2008 jpappas    Added chk_for_role (was standalone function in
--                             newobs and dsc)
--      11-SEP-2019 psalmu     Added functions noaa_icam_auth and noaa_icam_auth_char.
--
--  Dependencies:
--   DBA_CONSTRAINTS (Synonym)
--   DBA_CONS_COLUMNS (Synonym)
--   DBA_ROLE_PRIVS (Synonym)
--   DBMS_SESSION (Synonym)
--   DBMS_LDAP (Synonym)
--   DBMS_OUTPUT(Synonym)
--   DBMS_PIPE (Synonym)
--   DBMS_SQL (Synonym)
--   DSC (Tablespace)
--   DSC_SYS_PARAMS (Table)
--   DUAL (Synonym)
--   OWA (Synonym)
--   SESSION_ROLES (Synonym)
--   SYS_CONTEXT (Synonym)
--   UTL_SMTP (Synonym)
--   UTL_TCP (Synonym)
--   V$SESSION (Synonym)
--   V$MYSTAT (Synonym)
--   STANDARD (Package)
--
--===========================================================================

  FUNCTION noaa_icam_auth_char (p_email IN VARCHAR2, p_password IN VARCHAR2) RETURN VARCHAR2;


  FUNCTION os_user RETURN VARCHAR2;

END;
/

create or replace PACKAGE BODY     dsc_utilities_pkg IS
--===========================================================================
--   Application:   COMMON
--   Script Name:   dsc_utilities_pkg.pkb
--   Author:        Pauli Salmu
--   Purpose:
--      Creates a package of utility functions and procedures.
--
--    Modifications:
--      Date:       Person:    Reason:
--      26-OCT-2004 psalmu     Created.
--      22-NOV-2004 psalmu     Added function authenticate_user.
--      05-OCT-2005 psalmu     Added function pk_columns.
--      08-DEC-2005 psalmu     Added function valid_email_yn.
--      29-DEC-2005 psalmu     Added procedure send_mail.
--      18-JAN-2006 psalmu     Changed authenticate_user: added '"'s around p_password
--                             in CREATE DATABASE LINK statement to make it tolerate
--                             special characters in password.
--      18-JUL-2006 psalmu     Added function authenticate_user_ldap.
--      08-SEP-2006 psalmu     Added function ldap_search_simple.
--      14-SEP-2006 psalmu     Added function constraint_columns.
--      09-JUL-2007 psalmu     Added functions authenticate_user_pipe,
--                             password_pipe and password_from_pipe.
--      16-OCT-2007 psalmu     Added function noaa_locator_url.
--      12-DEC-2007 psalmu     Added function user_has_role_yn.
--      10-MAR-2008 psalmu     Added function password_grace_days.
--                             Requires granting select on dba_profiles to dsc.
--      10-JUN-2008 psalmu     Changed authenticate_user to handle "ORA-28002:
--                             the password will expire..." exception.
--                             Requires granting select on dba_profiles to dsc.
--      09-MAY-2011 psalmu     Changed authenticate_user to handle "ORA-28001:
--                             the password has expired" and return "EXPIRED".
--      10-MAY-2011 psalmu     Added double quotes and UPPER around the username based
--                             strings to authenticate_user. This assumes now that all
--                             usernames are still created in uppercase.
--      11-SEP-2019 psalmu     Added functions noaa_icam_auth and noaa_icam_auth_char.
--
--    Programs Called:
--
--    Functions/Procedures Called:
--    Scripts Called:
--    Tables/Views Used:
--
--===========================================================================

FUNCTION noaa_icam_auth_char (p_email IN VARCHAR2, p_password IN VARCHAR2) RETURN VARCHAR2 IS
BEGIN

  --used only for debugging purposes on a different server where DSC_UTILITIES_PKG could not be instantiated with ICAM implementation (requires server setup)
  RETURN 'TRUE';
END;


FUNCTION os_user RETURN VARCHAR2 IS
    os_user VARCHAR2(30) := NULL;
  BEGIN
    BEGIN
      SELECT s.osuser
        INTO os_user
        FROM v$session s, (SELECT DISTINCT sid FROM v$mystat) mysid
       WHERE s.sid = mysid.sid;
    EXCEPTION WHEN NO_DATA_FOUND THEN
      os_user := 'SessionID:  ' || USERENV('SESSIONID');
    END;

    RETURN os_user;
  END;

END;
/
