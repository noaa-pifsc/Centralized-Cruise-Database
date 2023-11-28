--run this from a DBA schema to grant the standard Cruise DB privileges to a given :external_schema_name:

DECLARE

	V_SCHEMA_NAME VARCHAR2(200) := :external_schema_name;


BEGIN



--V_SCHEMA_NAME schema permissions:
	--run this on the DSC schema to allow the ICAM authentication to the data schema
	EXECUTE IMMEDIATE 'grant execute on DSC.DSC_UTILITIES_PKG to '||V_SCHEMA_NAME;

	--run this on the CEN_UTILS schema to allow the ICAM authentication to the data schema
	EXECUTE IMMEDIATE 'grant CEN_UTILS_ROLE TO '||V_SCHEMA_NAME;
	EXECUTE IMMEDIATE 'grant execute on CEN_UTILS.CEN_UTIL_PKG to '||V_SCHEMA_NAME ||' with grant option';
	EXECUTE IMMEDIATE 'grant execute on CEN_UTILS.CEN_UTIL_ARRAY_PKG to '||V_SCHEMA_NAME||' with grant option';


	--run this on the PICDM schema or DBA schema to grant privileges on the PICD schema
	EXECUTE IMMEDIATE 'grant PICDM_INTEG_ROLE to '||V_SCHEMA_NAME;
	EXECUTE IMMEDIATE 'grant select on PICDM.ds_cust_fld_pkg_log_files_v to '||V_SCHEMA_NAME||' with grant option';

	--run this from the CEN_CRUISE schema or DBA schema to grant the standard Centralized Cruise DB privileges to a given V_SCHEMA_NAME:
	EXECUTE IMMEDIATE 'grant CCD_INTEG_ROLE to '||V_SCHEMA_NAME;
	EXECUTE IMMEDIATE 'grant references on CEN_CRUISE.CCD_CRUISE_LEGS to '|| V_SCHEMA_NAME;
	EXECUTE IMMEDIATE 'grant references on CEN_CRUISE.CCD_CRUISES to '|| V_SCHEMA_NAME;
	EXECUTE IMMEDIATE 'grant select on CEN_CRUISE.CCD_CRUISES to '|| V_SCHEMA_NAME||' WITH GRANT OPTION';
	EXECUTE IMMEDIATE 'grant select on CEN_CRUISE.CCD_CRUISE_LEG_DATA_SETS_V to '||V_SCHEMA_NAME||' WITH GRANT OPTION';
	EXECUTE IMMEDIATE 'grant select on CEN_CRUISE.CCD_CRUISE_LEG_DATA_SETS_MIN_V to '|| V_SCHEMA_NAME||' WITH GRANT OPTION';
	EXECUTE IMMEDIATE 'grant select on CEN_CRUISE.CCD_LEG_DATA_SETS_V to '||V_SCHEMA_NAME||' WITH GRANT OPTION';
	EXECUTE IMMEDIATE 'grant select on CEN_CRUISE.CCD_CRUISE_V to '||V_SCHEMA_NAME||' WITH GRANT OPTION';
	EXECUTE IMMEDIATE 'grant select on CEN_CRUISE.CCD_LEG_AGG_V to '||V_SCHEMA_NAME ||' WITH GRANT OPTION';


END;
/
