--run this from the DSC schema:

grant execute on DSC_CRE_HIST_OBJS_PKG to CEN_CRUISE;


--run this from the CEN_CRUISE schema:
grant select on CCD_CRUISES_V to CEN_CTD;
grant select on CCD_CRUISE_LEG_ALIASES_V to CEN_CTD with grant option;
grant select, references on CCD_CRUISE_LEGS to CEN_CTD;
grant select on CCD_LEG_ALIASES to CEN_CTD;


