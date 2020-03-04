--run this from the CEN_CRUISE schema to grant the standard Cruise DB privileges to a given [EXTERNAL SCHEMA]:
grant select on CCD_CRUISE_DELIM_V to [EXTERNAL SCHEMA] with grant option;
grant select on CCD_CRUISE_LEG_DELIM_V to [EXTERNAL SCHEMA] with grant option;
grant select on CCD_CRUISE_LEGS_V to [EXTERNAL SCHEMA] with grant option;
grant select on CCD_CRUISE_SUMM_V to [EXTERNAL SCHEMA] with grant option;
grant select on CCD_CRUISE_V to [EXTERNAL SCHEMA] with grant option;
grant select on CCD_LEG_DELIM_V to [EXTERNAL SCHEMA] with grant option;
grant select on CCD_LEG_V to [EXTERNAL SCHEMA] with grant option;


grant select, references on CCD_CRUISE_LEGS to [EXTERNAL SCHEMA];
grant select on CCD_LEG_ALIASES to [EXTERNAL SCHEMA];
grant execute on CRUISE_PKG to [EXTERNAL SCHEMA];
