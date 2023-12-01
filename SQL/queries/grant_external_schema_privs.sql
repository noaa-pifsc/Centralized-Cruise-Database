--run this from a DBA schema to grant the standard Cruise DB privileges to a given :external_schema_name:

DECLARE

	V_SCHEMA_NAME VARCHAR2(200) := :external_schema_name;


BEGIN

	--run these statements to allow the data schema to use the Cruise DB views that utilize the Centralized Utilities packages to the specified schema
		EXECUTE IMMEDIATE 'grant CEN_UTILS_ROLE TO '||V_SCHEMA_NAME;
		EXECUTE IMMEDIATE 'grant execute on CEN_UTILS.CEN_UTIL_PKG to '||V_SCHEMA_NAME ||' with grant option';
		EXECUTE IMMEDIATE 'grant execute on CEN_UTILS.CEN_UTIL_ARRAY_PKG to '||V_SCHEMA_NAME||' with grant option';

	--run this to grant the standard Centralized Cruise DB privileges to the specified schema:
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
