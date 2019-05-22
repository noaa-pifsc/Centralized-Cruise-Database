--run this from the CEN_CRUISE schema:
grant select on CCD_CRUISES_V to [EXTERNAL SCHEMA];
grant select on CCD_CRUISE_LEG_ALIASES_V to [EXTERNAL SCHEMA] with grant option;
grant select, references on CCD_CRUISE_LEGS to [EXTERNAL SCHEMA];
grant select on CCD_LEG_ALIASES to [EXTERNAL SCHEMA];
grant execute on CRUISE_PKG to [EXTERNAL SCHEMA];
