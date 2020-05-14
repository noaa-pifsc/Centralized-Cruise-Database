--execute this grant from the CEN_UTILS schema:
grant execute on CEN_UTIL_PKG to cen_cruise_app;


--run this from the CEN_CRUISE data schema
grant execute on CCD_CRUISE_PKG to CEN_CRUISE_APP;
grant execute on DB_LOG_PKG to CEN_CRUISE_APP;
grant execute on CUST_ERR_PKG to CEN_CRUISE_APP;
grant execute on AUTH_APP_PKG to CEN_CRUISE_APP;
grant select on AUTH_APP_USERS_V to CEN_CRUISE_APP;
grant select on AUTH_APP_USER_GROUPS_V to CEN_CRUISE_APP;


grant select on CCD_CRUISE_SUMM_V to CEN_CRUISE_APP;
grant select on CCD_CRUISE_DELIM_V to CEN_CRUISE_APP;
grant select on CCD_CRUISE_LEG_DELIM_V to CEN_CRUISE_APP;
grant select on CCD_CRUISE_LEGS_V to CEN_CRUISE_APP;
grant select on CCD_CRUISE_V to CEN_CRUISE_APP;
grant select on CCD_DATA_SETS_V to CEN_CRUISE_APP;
grant select on CCD_LEG_DELIM_V to CEN_CRUISE_APP;
grant select on CCD_LEG_V to CEN_CRUISE_APP;



grant insert, delete, update, select on CCD_CRUISES to CEN_CRUISE_APP;
grant insert, delete, update, select on CCD_CRUISE_LEGS to CEN_CRUISE_APP;
grant insert, delete, update, select on CCD_VESSELS to CEN_CRUISE_APP;
grant insert, delete, update, select on CCD_PLAT_TYPES to CEN_CRUISE_APP;
grant insert, delete, update, select on CCD_LEG_GEAR to CEN_CRUISE_APP;
grant insert, delete, update, select on CCD_GEAR to CEN_CRUISE_APP;
grant insert, delete, update, select on CCD_LEG_ECOSYSTEMS to CEN_CRUISE_APP;
grant insert, delete, update, select on CCD_REG_ECOSYSTEMS to CEN_CRUISE_APP;
grant insert, delete, update, select on CCD_LEG_ALIASES to CEN_CRUISE_APP;


grant insert, delete, update, select on CCD_REGIONS to CEN_CRUISE_APP;
grant insert, delete, update, select on CCD_LEG_REGIONS to CEN_CRUISE_APP;



grant insert, delete, update, select on CCD_SCI_CENTERS to CEN_CRUISE_APP;
grant insert, delete, update, select on CCD_SCI_CENTER_DIVS to CEN_CRUISE_APP;
grant insert, delete, update, select on CCD_STD_SVY_NAMES to CEN_CRUISE_APP;
grant insert, delete, update, select on CCD_SVY_FREQ to CEN_CRUISE_APP;

grant insert, delete, update, select on CCD_CRUISE_EXP_SPP to CEN_CRUISE_APP;
grant insert, delete, update, select on CCD_CRUISE_LEGS to CEN_CRUISE_APP;
grant insert, delete, update, select on CCD_CRUISE_SPP_ESA to CEN_CRUISE_APP;
grant insert, delete, update, select on CCD_CRUISE_SPP_FSSI to CEN_CRUISE_APP;

grant insert, delete, update, select on CCD_CRUISE_SPP_MMPA to CEN_CRUISE_APP;
grant insert, delete, update, select on CCD_CRUISE_SVY_CATS to CEN_CRUISE_APP;



grant insert, delete, update, select on CCD_TGT_SPP_ESA to CEN_CRUISE_APP;
grant insert, delete, update, select on CCD_TGT_SPP_FSSI to CEN_CRUISE_APP;
grant insert, delete, update, select on CCD_TGT_SPP_MMPA to CEN_CRUISE_APP;
grant insert, delete, update, select on CCD_TGT_SPP_OTHER to CEN_CRUISE_APP;
grant insert, delete, update, select on CCD_EXP_SPP_CATS to CEN_CRUISE_APP;
grant insert, delete, update, select on CCD_SVY_CATS to CEN_CRUISE_APP;
grant insert, delete, update, select on CCD_SVY_TYPES to CEN_CRUISE_APP;


grant insert, delete, update, select on CCD_GEAR_PRE to CEN_CRUISE_APP;
grant insert, delete, update, select on CCD_GEAR_PRE_OPTS to CEN_CRUISE_APP;
grant select on CCD_GEAR_PRE_V to CEN_CRUISE_APP;

grant insert, delete, update, select on CCD_REG_ECO_PRE to CEN_CRUISE_APP;
grant insert, delete, update, select on CCD_REG_ECO_PRE_OPTS to CEN_CRUISE_APP;
grant select on CCD_REG_ECO_PRE_V to CEN_CRUISE_APP;

grant insert, delete, update, select on CCD_REGION_PRE to CEN_CRUISE_APP;
grant insert, delete, update, select on CCD_REGION_PRE_OPTS to CEN_CRUISE_APP;
grant select on CCD_REGION_PRE_V to CEN_CRUISE_APP;






grant insert, delete, update, select on CCD_SVY_CAT_PRE to CEN_CRUISE_APP;
grant insert, delete, update, select on CCD_SVY_CAT_PRE_OPTS to CEN_CRUISE_APP;
grant select on CCD_SVY_CAT_PRE_V to CEN_CRUISE_APP;


grant insert, delete, update, select on CCD_SPP_ESA_PRE to CEN_CRUISE_APP;
grant insert, delete, update, select on CCD_SPP_ESA_PRE_OPTS to CEN_CRUISE_APP;
grant select on CCD_SPP_ESA_PRE_V to CEN_CRUISE_APP;




grant insert, delete, update, select on CCD_SPP_FSSI_PRE to CEN_CRUISE_APP;
grant insert, delete, update, select on CCD_SPP_FSSI_PRE_OPTS to CEN_CRUISE_APP;
grant select on CCD_SPP_FSSI_PRE_V to CEN_CRUISE_APP;


grant insert, delete, update, select on CCD_SPP_MMPA_PRE to CEN_CRUISE_APP;
grant insert, delete, update, select on CCD_SPP_MMPA_PRE_OPTS to CEN_CRUISE_APP;
grant select on CCD_SPP_MMPA_PRE_V to CEN_CRUISE_APP;


grant insert, delete, update, select on CCD_SPP_CAT_PRE to CEN_CRUISE_APP;
grant insert, delete, update, select on CCD_SPP_CAT_PRE_OPTS to CEN_CRUISE_APP;
grant select on CCD_SPP_CAT_PRE_V to CEN_CRUISE_APP;



grant select on CCD_REG_ECO_PRE_DELIM_V to CEN_CRUISE_APP;
grant select on CCD_REGION_PRE_DELIM_V to CEN_CRUISE_APP;

grant select on CCD_SPP_CAT_PRE_DELIM_V to CEN_CRUISE_APP;
grant select on CCD_SPP_ESA_PRE_DELIM_V to CEN_CRUISE_APP;
grant select on CCD_SPP_FSSI_PRE_DELIM_V to CEN_CRUISE_APP;
grant select on CCD_SPP_MMPA_PRE_DELIM_V to CEN_CRUISE_APP;
grant select on CCD_SVY_CAT_PRE_DELIM_V to CEN_CRUISE_APP;

grant select on CCD_GEAR_PRE_DELIM_V to CEN_CRUISE_APP;


grant select on CCD_SCI_CENTER_DIV_V to CEN_CRUISE_APP;

grant select on CCD_SCI_CENTER_DELIM_V to CEN_CRUISE_APP;



grant select, update, delete on DVM_ERRORS to CEN_CRUISE_APP;
grant select, delete on DVM_PTA_ERR_TYP_ASSOC to CEN_CRUISE_APP;
grant select, delete on DVM_PTA_ERRORS to CEN_CRUISE_APP;


grant select on dvm_err_severity to CEN_CRUISE_APP;
grant select on dvm_error_types to CEN_CRUISE_APP;
grant select on dvm_err_res_types to CEN_CRUISE_APP;

grant execute on CCD_DVM_PKG to CEN_CRUISE_APP;
grant select on DVM_PTA_ERRORS_V to CEN_CRUISE_APP;


grant select on CCD_CRUISE_SUMM_ERR_V to CEN_CRUISE_APP;
grant select on CCD_CRUISE_ERR_SUMM_V to CEN_CRUISE_APP;


/*
grant insert, delete, update, select on  to CEN_CRUISE_APP;


*/


--initial page is view all cruises (including info about assoc legs)
