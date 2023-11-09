--run this from the DSC schema:
grant execute on DSC.DSC_CRE_HIST_OBJS_PKG to CEN_CRUISE;
grant execute on DSC.DSC_UTILITIES_PKG to CEN_CRUISE;


--run this for the CEN_UTILS schema:
grant CEN_UTILS_ROLE TO CEN_CRUISE;
grant CEN_UTILS_ROLE TO CEN_CRUISE_APP;
grant execute on CEN_UTILS.CEN_UTIL_PKG to CEN_CRUISE with grant option;
grant execute on CEN_UTILS.CEN_UTIL_ARRAY_PKG to CEN_CRUISE with grant option;


--centralized authorization system package:


--create cruise roles
@@create_CRUISE_roles.sql

--grant cruise roles to app
@@../../CRDMA/SQL/cen_cruise_app_grant_privs.sql