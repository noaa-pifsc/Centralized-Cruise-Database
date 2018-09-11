--run this from the DSC schema:

grant execute on DSC_CRE_HIST_OBJS_PKG to CEN_CRUISE;


--run this from the CEN_CRUISE schema:
grant select on CCD_CRUISES_V to CEN_CTD;
grant select on CCD_CRUISE_ALIASES_V to CEN_CTD;
grant references on CCD_CRUISES to CEN_CTD;
grant select on CCD_CRUISES to CEN_CTD;
grant select on CCD_CRUISE_ALIASES to CEN_CTD;

