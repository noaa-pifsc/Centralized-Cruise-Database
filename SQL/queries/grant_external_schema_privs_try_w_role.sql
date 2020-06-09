--(one time setup) run this after the CCD_REF role is created to define the privileges for the role:
grant select on CCD_CRUISES_V to CCD_REF;
grant select on CCD_CRUISE_LEGS to CCD_REF;
grant select on CCD_LEG_ALIASES to CCD_REF;
grant execute on CRUISE_PKG to CCD_REF;


--run this from the CEN_CRUISE schema to grant the privileges to a given referring schema for integration:
grant references on CCD_CRUISE_LEGS to [EXTERNAL SCHEMA];				--allow the schema to refer to the CCD_CRUISE_LEGS table for the integration
grant CCD_REF to [EXTERNAL SCHEMA];						--grant the role to the schema
grant select on CCD_CRUISE_LEG_ALIASES_V to [EXTERNAL SCHEMA] with grant option;	--necessary to allow any views that depend on the CCD_CRUISE_LEG_ALIASES_V to be shared with other schemas

