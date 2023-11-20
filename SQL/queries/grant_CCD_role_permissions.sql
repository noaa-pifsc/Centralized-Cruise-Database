--CCD_INTEG_ROLE
grant select on CCD_CRUISE_DELIM_V to CCD_INTEG_ROLE;
grant select on CCD_CRUISE_LEG_DELIM_V to CCD_INTEG_ROLE;
grant select on CCD_CRUISE_LEG_V to CCD_INTEG_ROLE;
grant select on CCD_CRUISE_SUMM_V to CCD_INTEG_ROLE;
grant select on CCD_CRUISE_V to CCD_INTEG_ROLE;
grant select on CCD_LEG_DELIM_V to CCD_INTEG_ROLE;
grant select on CCD_LEG_V to CCD_INTEG_ROLE;
grant select on CCD_LEG_AGG_V to CCD_INTEG_ROLE;
grant select on CCD_DATA_SETS_V to CCD_INTEG_ROLE;
grant select on CCD_LEG_DATA_SETS_V to CCD_INTEG_ROLE;
grant select on CCD_CRUISE_LEGS to CCD_INTEG_ROLE;
grant select on CCD_CRUISES to CCD_INTEG_ROLE;
grant select on CCD_LEG_ALIASES to CCD_INTEG_ROLE;
grant execute on CCD_CRUISE_PKG to CCD_INTEG_ROLE;
grant select on CCD_CRUISE_LEG_DATA_SETS_V TO CCD_INTEG_ROLE;
grant select on CCD_CRUISE_LEG_DATA_SETS_MIN_V TO CCD_INTEG_ROLE;

--CCD_APP_ROLE
grant execute on CCD_CRUISE_PKG to CCD_APP_ROLE;
grant execute on DB_LOG_PKG to CCD_APP_ROLE;
grant execute on CUST_ERR_PKG to CCD_APP_ROLE;


grant select on CCD_CRUISE_SUMM_V to CCD_APP_ROLE;
grant select on CCD_CRUISE_DELIM_V to CCD_APP_ROLE;
grant select on CCD_CRUISE_LEG_DELIM_V to CCD_APP_ROLE;
grant select on CCD_CRUISE_LEG_V to CCD_APP_ROLE;
grant select on CCD_CRUISE_V to CCD_APP_ROLE;
grant select on CCD_DATA_SETS_V to CCD_APP_ROLE;
grant select on CCD_LEG_DELIM_V to CCD_APP_ROLE;
grant select on CCD_LEG_V to CCD_APP_ROLE;



grant insert, delete, update, select on CCD_CRUISES to CCD_APP_ROLE;
grant insert, delete, update, select on CCD_CRUISE_LEGS to CCD_APP_ROLE;
grant insert, delete, update, select on CCD_VESSELS to CCD_APP_ROLE;
grant insert, delete, update, select on CCD_PLAT_TYPES to CCD_APP_ROLE;
grant insert, delete, update, select on CCD_LEG_GEAR to CCD_APP_ROLE;
grant insert, delete, update, select on CCD_GEAR to CCD_APP_ROLE;
grant insert, delete, update, select on CCD_LEG_ECOSYSTEMS to CCD_APP_ROLE;
grant insert, delete, update, select on CCD_REG_ECOSYSTEMS to CCD_APP_ROLE;
grant insert, delete, update, select on CCD_LEG_ALIASES to CCD_APP_ROLE;


grant insert, delete, update, select on CCD_REGIONS to CCD_APP_ROLE;
grant insert, delete, update, select on CCD_LEG_REGIONS to CCD_APP_ROLE;



grant insert, delete, update, select on CCD_SCI_CENTERS to CCD_APP_ROLE;
grant insert, delete, update, select on CCD_SCI_CENTER_DIVS to CCD_APP_ROLE;
grant insert, delete, update, select on CCD_STD_SVY_NAMES to CCD_APP_ROLE;
grant insert, delete, update, select on CCD_SVY_FREQ to CCD_APP_ROLE;

grant insert, delete, update, select on CCD_CRUISE_EXP_SPP to CCD_APP_ROLE;
grant insert, delete, update, select on CCD_CRUISE_LEGS to CCD_APP_ROLE;
grant insert, delete, update, select on CCD_CRUISE_SPP_ESA to CCD_APP_ROLE;
grant insert, delete, update, select on CCD_CRUISE_SPP_FSSI to CCD_APP_ROLE;

grant insert, delete, update, select on CCD_CRUISE_SPP_MMPA to CCD_APP_ROLE;
grant insert, delete, update, select on CCD_CRUISE_SVY_CATS to CCD_APP_ROLE;



grant insert, delete, update, select on CCD_TGT_SPP_ESA to CCD_APP_ROLE;
grant insert, delete, update, select on CCD_TGT_SPP_FSSI to CCD_APP_ROLE;
grant insert, delete, update, select on CCD_TGT_SPP_MMPA to CCD_APP_ROLE;
grant insert, delete, update, select on CCD_TGT_SPP_OTHER to CCD_APP_ROLE;
grant insert, delete, update, select on CCD_EXP_SPP_CATS to CCD_APP_ROLE;
grant insert, delete, update, select on CCD_SVY_CATS to CCD_APP_ROLE;
grant insert, delete, update, select on CCD_SVY_TYPES to CCD_APP_ROLE;


grant insert, delete, update, select on CCD_GEAR_PRE to CCD_APP_ROLE;
grant insert, delete, update, select on CCD_GEAR_PRE_OPTS to CCD_APP_ROLE;
grant select on CCD_GEAR_PRE_V to CCD_APP_ROLE;

grant insert, delete, update, select on CCD_REG_ECO_PRE to CCD_APP_ROLE;
grant insert, delete, update, select on CCD_REG_ECO_PRE_OPTS to CCD_APP_ROLE;
grant select on CCD_REG_ECO_PRE_V to CCD_APP_ROLE;

grant insert, delete, update, select on CCD_REGION_PRE to CCD_APP_ROLE;
grant insert, delete, update, select on CCD_REGION_PRE_OPTS to CCD_APP_ROLE;
grant select on CCD_REGION_PRE_V to CCD_APP_ROLE;






grant insert, delete, update, select on CCD_SVY_CAT_PRE to CCD_APP_ROLE;
grant insert, delete, update, select on CCD_SVY_CAT_PRE_OPTS to CCD_APP_ROLE;
grant select on CCD_SVY_CAT_PRE_V to CCD_APP_ROLE;


grant insert, delete, update, select on CCD_SPP_ESA_PRE to CCD_APP_ROLE;
grant insert, delete, update, select on CCD_SPP_ESA_PRE_OPTS to CCD_APP_ROLE;
grant select on CCD_SPP_ESA_PRE_V to CCD_APP_ROLE;




grant insert, delete, update, select on CCD_SPP_FSSI_PRE to CCD_APP_ROLE;
grant insert, delete, update, select on CCD_SPP_FSSI_PRE_OPTS to CCD_APP_ROLE;
grant select on CCD_SPP_FSSI_PRE_V to CCD_APP_ROLE;


grant insert, delete, update, select on CCD_SPP_MMPA_PRE to CCD_APP_ROLE;
grant insert, delete, update, select on CCD_SPP_MMPA_PRE_OPTS to CCD_APP_ROLE;
grant select on CCD_SPP_MMPA_PRE_V to CCD_APP_ROLE;


grant insert, delete, update, select on CCD_SPP_CAT_PRE to CCD_APP_ROLE;
grant insert, delete, update, select on CCD_SPP_CAT_PRE_OPTS to CCD_APP_ROLE;
grant select on CCD_SPP_CAT_PRE_V to CCD_APP_ROLE;



grant select on CCD_REG_ECO_PRE_DELIM_V to CCD_APP_ROLE;
grant select on CCD_REGION_PRE_DELIM_V to CCD_APP_ROLE;

grant select on CCD_SPP_CAT_PRE_DELIM_V to CCD_APP_ROLE;
grant select on CCD_SPP_ESA_PRE_DELIM_V to CCD_APP_ROLE;
grant select on CCD_SPP_FSSI_PRE_DELIM_V to CCD_APP_ROLE;
grant select on CCD_SPP_MMPA_PRE_DELIM_V to CCD_APP_ROLE;
grant select on CCD_SVY_CAT_PRE_DELIM_V to CCD_APP_ROLE;

grant select on CCD_GEAR_PRE_DELIM_V to CCD_APP_ROLE;


grant select on CCD_SCI_CENTER_DIV_V to CCD_APP_ROLE;

grant select on CCD_SCI_CENTER_DELIM_V to CCD_APP_ROLE;



grant select, update, delete on DVM_ISSUES to CCD_APP_ROLE;
grant select, delete on DVM_ISS_TYP_ASSOC to CCD_APP_ROLE;
grant select, delete on DVM_PTA_ISSUES to CCD_APP_ROLE;


grant select on dvm_iss_severity to CCD_APP_ROLE;
grant select on dvm_iss_types to CCD_APP_ROLE;
grant select on dvm_iss_res_types to CCD_APP_ROLE;

grant execute on DVM_PKG to CCD_APP_ROLE;
grant execute on CCD_DVM_PKG to CCD_APP_ROLE;
grant select on DVM_PTA_ISSUES_V to CCD_APP_ROLE;


grant select on CCD_CRUISE_SUMM_ISS_V to CCD_APP_ROLE;
grant select on CCD_CRUISE_ISS_SUMM_V to CCD_APP_ROLE;
grant select on CCD_QC_LEG_OVERLAP_V to CCD_APP_ROLE;


grant select, insert, update, delete on CCD_LEG_DATA_SETS to CCD_APP_ROLE;
grant select, insert, update, delete on CCD_DATA_SETS to CCD_APP_ROLE;
grant select, insert, update, delete on CCD_DATA_SET_STATUS to CCD_APP_ROLE;
grant select, insert, update, delete on CCD_DATA_SET_TYPES to CCD_APP_ROLE;

/*
grant insert, delete, update, select on  to CCD_APP_ROLE;


*/


--initial page is view all cruises (including info about assoc legs)

--apex feedback form:
grant select on AFF_RESP_TYPES to CCD_APP_ROLE;
grant select, insert on AFF_RESPONSES to CCD_APP_ROLE;
grant select on AFF_RESPONSES_V to CCD_APP_ROLE;



grant select on CC_CONFIG_OPTIONS TO CCD_APP_ROLE;
