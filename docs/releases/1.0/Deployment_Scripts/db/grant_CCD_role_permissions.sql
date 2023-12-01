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
grant select on CCD_CRUISE_AGG_V to CCD_APP_ROLE;
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


--initial page is view all cruises (including info about assoc legs)

--apex feedback form:
grant select on AFF_RESP_TYPES to CCD_APP_ROLE;
grant select, insert on AFF_RESPONSES to CCD_APP_ROLE;
grant select on AFF_RESPONSES_V to CCD_APP_ROLE;



grant select on CC_CONFIG_OPTIONS TO CCD_APP_ROLE;





--CCD_READ_ROLE:
GRANT SELECT ON AFF_RESPONSES TO CCD_READ_ROLE;
GRANT SELECT ON AFF_RESPONSES_V TO CCD_READ_ROLE;
GRANT SELECT ON AFF_RESP_TYPES TO CCD_READ_ROLE;
GRANT SELECT ON CCD_CCDP_DEEP_COPY_CMP_V TO CCD_READ_ROLE;
GRANT SELECT ON CCD_CRUISES TO CCD_READ_ROLE;
GRANT SELECT ON CCD_CRUISE_AGG_V TO CCD_READ_ROLE;
GRANT SELECT ON CCD_CRUISE_DELIM_V TO CCD_READ_ROLE;
GRANT SELECT ON CCD_CRUISE_DVM_EVAL_RPT_V TO CCD_READ_ROLE;
GRANT SELECT ON CCD_CRUISE_DVM_EVAL_V TO CCD_READ_ROLE;
GRANT SELECT ON CCD_CRUISE_DVM_RULES_RPT_V TO CCD_READ_ROLE;
GRANT SELECT ON CCD_CRUISE_DVM_RULES_V TO CCD_READ_ROLE;
GRANT SELECT ON CCD_CRUISE_DVM_RULE_EVAL_RPT_V TO CCD_READ_ROLE;
GRANT SELECT ON CCD_CRUISE_DVM_RULE_EVAL_V TO CCD_READ_ROLE;
GRANT SELECT ON CCD_CRUISE_EXP_SPP TO CCD_READ_ROLE;
GRANT SELECT ON CCD_CRUISE_ISS_SUMM_V TO CCD_READ_ROLE;
GRANT SELECT ON CCD_CRUISE_LEGS TO CCD_READ_ROLE;
GRANT SELECT ON CCD_CRUISE_LEG_AGG_V TO CCD_READ_ROLE;
GRANT SELECT ON CCD_CRUISE_LEG_DATA_SETS_MIN_V TO CCD_READ_ROLE;
GRANT SELECT ON CCD_CRUISE_LEG_DATA_SETS_V TO CCD_READ_ROLE;
GRANT SELECT ON CCD_CRUISE_LEG_DELIM_V TO CCD_READ_ROLE;
GRANT SELECT ON CCD_CRUISE_LEG_V TO CCD_READ_ROLE;
GRANT SELECT ON CCD_CRUISE_SPP_ESA TO CCD_READ_ROLE;
GRANT SELECT ON CCD_CRUISE_SPP_FSSI TO CCD_READ_ROLE;
GRANT SELECT ON CCD_CRUISE_SPP_MMPA TO CCD_READ_ROLE;
GRANT SELECT ON CCD_CRUISE_SUMM_ISS_V TO CCD_READ_ROLE;
GRANT SELECT ON CCD_CRUISE_SUMM_V TO CCD_READ_ROLE;
GRANT SELECT ON CCD_CRUISE_SVY_CATS TO CCD_READ_ROLE;
GRANT SELECT ON CCD_CRUISE_V TO CCD_READ_ROLE;
GRANT SELECT ON CCD_DATA_SETS TO CCD_READ_ROLE;
GRANT SELECT ON CCD_DATA_SETS_V TO CCD_READ_ROLE;
GRANT SELECT ON CCD_DATA_SET_STATUS TO CCD_READ_ROLE;
GRANT SELECT ON CCD_DATA_SET_TYPES TO CCD_READ_ROLE;
GRANT SELECT ON CCD_EXP_SPP_CATS TO CCD_READ_ROLE;
GRANT SELECT ON CCD_GEAR TO CCD_READ_ROLE;
GRANT SELECT ON CCD_GEAR_PRE TO CCD_READ_ROLE;
GRANT SELECT ON CCD_GEAR_PRE_DELIM_V TO CCD_READ_ROLE;
GRANT SELECT ON CCD_GEAR_PRE_OPTS TO CCD_READ_ROLE;
GRANT SELECT ON CCD_GEAR_PRE_V TO CCD_READ_ROLE;
GRANT SELECT ON CCD_LEG_AGG_V TO CCD_READ_ROLE;
GRANT SELECT ON CCD_LEG_ALIASES TO CCD_READ_ROLE;
GRANT SELECT ON CCD_LEG_DATA_SETS TO CCD_READ_ROLE;
GRANT SELECT ON CCD_LEG_DATA_SETS_MIN_V TO CCD_READ_ROLE;
GRANT SELECT ON CCD_LEG_DATA_SETS_V TO CCD_READ_ROLE;
GRANT SELECT ON CCD_LEG_DELIM_V TO CCD_READ_ROLE;
GRANT SELECT ON CCD_LEG_ECOSYSTEMS TO CCD_READ_ROLE;
GRANT SELECT ON CCD_LEG_ECOSYSTEMS_V TO CCD_READ_ROLE;
GRANT SELECT ON CCD_LEG_GEAR TO CCD_READ_ROLE;
GRANT SELECT ON CCD_LEG_GEAR_V TO CCD_READ_ROLE;
GRANT SELECT ON CCD_LEG_REGIONS TO CCD_READ_ROLE;
GRANT SELECT ON CCD_LEG_REGIONS_V TO CCD_READ_ROLE;
GRANT SELECT ON CCD_LEG_V TO CCD_READ_ROLE;
GRANT SELECT ON CCD_PLAT_TYPES TO CCD_READ_ROLE;
GRANT SELECT ON CCD_QC_CRUISE_V TO CCD_READ_ROLE;
GRANT SELECT ON CCD_QC_LEG_ALIAS_V TO CCD_READ_ROLE;
GRANT SELECT ON CCD_QC_LEG_OVERLAP_V TO CCD_READ_ROLE;
GRANT SELECT ON CCD_QC_LEG_V TO CCD_READ_ROLE;
GRANT SELECT ON CCD_REGIONS TO CCD_READ_ROLE;
GRANT SELECT ON CCD_REGION_PRE TO CCD_READ_ROLE;
GRANT SELECT ON CCD_REGION_PRE_DELIM_V TO CCD_READ_ROLE;
GRANT SELECT ON CCD_REGION_PRE_OPTS TO CCD_READ_ROLE;
GRANT SELECT ON CCD_REGION_PRE_V TO CCD_READ_ROLE;
GRANT SELECT ON CCD_REG_ECOSYSTEMS TO CCD_READ_ROLE;
GRANT SELECT ON CCD_REG_ECO_PRE TO CCD_READ_ROLE;
GRANT SELECT ON CCD_REG_ECO_PRE_DELIM_V TO CCD_READ_ROLE;
GRANT SELECT ON CCD_REG_ECO_PRE_OPTS TO CCD_READ_ROLE;
GRANT SELECT ON CCD_REG_ECO_PRE_V TO CCD_READ_ROLE;
GRANT SELECT ON CCD_SCI_CENTERS TO CCD_READ_ROLE;
GRANT SELECT ON CCD_SCI_CENTER_DELIM_V TO CCD_READ_ROLE;
GRANT SELECT ON CCD_SCI_CENTER_DIVS TO CCD_READ_ROLE;
GRANT SELECT ON CCD_SCI_CENTER_DIV_V TO CCD_READ_ROLE;
GRANT SELECT ON CCD_SPP_CAT_PRE TO CCD_READ_ROLE;
GRANT SELECT ON CCD_SPP_CAT_PRE_DELIM_V TO CCD_READ_ROLE;
GRANT SELECT ON CCD_SPP_CAT_PRE_OPTS TO CCD_READ_ROLE;
GRANT SELECT ON CCD_SPP_CAT_PRE_V TO CCD_READ_ROLE;
GRANT SELECT ON CCD_SPP_ESA_PRE TO CCD_READ_ROLE;
GRANT SELECT ON CCD_SPP_ESA_PRE_DELIM_V TO CCD_READ_ROLE;
GRANT SELECT ON CCD_SPP_ESA_PRE_OPTS TO CCD_READ_ROLE;
GRANT SELECT ON CCD_SPP_ESA_PRE_V TO CCD_READ_ROLE;
GRANT SELECT ON CCD_SPP_FSSI_PRE TO CCD_READ_ROLE;
GRANT SELECT ON CCD_SPP_FSSI_PRE_DELIM_V TO CCD_READ_ROLE;
GRANT SELECT ON CCD_SPP_FSSI_PRE_OPTS TO CCD_READ_ROLE;
GRANT SELECT ON CCD_SPP_FSSI_PRE_V TO CCD_READ_ROLE;
GRANT SELECT ON CCD_SPP_MMPA_PRE TO CCD_READ_ROLE;
GRANT SELECT ON CCD_SPP_MMPA_PRE_DELIM_V TO CCD_READ_ROLE;
GRANT SELECT ON CCD_SPP_MMPA_PRE_OPTS TO CCD_READ_ROLE;
GRANT SELECT ON CCD_SPP_MMPA_PRE_V TO CCD_READ_ROLE;
GRANT SELECT ON CCD_STD_SVY_NAMES TO CCD_READ_ROLE;
GRANT SELECT ON CCD_SVY_CATS TO CCD_READ_ROLE;
GRANT SELECT ON CCD_SVY_CAT_PRE TO CCD_READ_ROLE;
GRANT SELECT ON CCD_SVY_CAT_PRE_DELIM_V TO CCD_READ_ROLE;
GRANT SELECT ON CCD_SVY_CAT_PRE_OPTS TO CCD_READ_ROLE;
GRANT SELECT ON CCD_SVY_CAT_PRE_V TO CCD_READ_ROLE;
GRANT SELECT ON CCD_SVY_FREQ TO CCD_READ_ROLE;
GRANT SELECT ON CCD_SVY_TYPES TO CCD_READ_ROLE;
GRANT SELECT ON CCD_TGT_SPP_ESA TO CCD_READ_ROLE;
GRANT SELECT ON CCD_TGT_SPP_FSSI TO CCD_READ_ROLE;
GRANT SELECT ON CCD_TGT_SPP_MMPA TO CCD_READ_ROLE;
GRANT SELECT ON CCD_TGT_SPP_OTHER TO CCD_READ_ROLE;
GRANT SELECT ON CCD_VESSELS TO CCD_READ_ROLE;
GRANT SELECT ON CC_CONFIG_OPTIONS TO CCD_READ_ROLE;
GRANT SELECT ON CC_CONFIG_OPTIONS_HIST TO CCD_READ_ROLE;
GRANT SELECT ON CUST_ERR_CONSTR_MSG TO CCD_READ_ROLE;
GRANT SELECT ON DB_LOG_ENTRIES TO CCD_READ_ROLE;
GRANT SELECT ON DB_LOG_ENTRIES_V TO CCD_READ_ROLE;
GRANT SELECT ON DB_LOG_ENTRY_TYPES TO CCD_READ_ROLE;
GRANT SELECT ON DB_UPGRADE_LOGS TO CCD_READ_ROLE;
GRANT SELECT ON DB_UPGRADE_LOGS_V TO CCD_READ_ROLE;
GRANT SELECT ON DVM_CRITERIA_V TO CCD_READ_ROLE;
GRANT SELECT ON DVM_DATA_STREAMS TO CCD_READ_ROLE;
GRANT SELECT ON DVM_DATA_STREAMS_HIST TO CCD_READ_ROLE;
GRANT SELECT ON DVM_DATA_STREAMS_V TO CCD_READ_ROLE;
GRANT SELECT ON DVM_DS_PTA_RULE_SETS_HIST_V TO CCD_READ_ROLE;
GRANT SELECT ON DVM_DS_PTA_RULE_SETS_V TO CCD_READ_ROLE;
GRANT SELECT ON DVM_ISSUES TO CCD_READ_ROLE;
GRANT SELECT ON DVM_ISSUES_HIST TO CCD_READ_ROLE;
GRANT SELECT ON DVM_ISS_RES_TYPES TO CCD_READ_ROLE;
GRANT SELECT ON DVM_ISS_RES_TYPES_HIST TO CCD_READ_ROLE;
GRANT SELECT ON DVM_ISS_SEVERITY TO CCD_READ_ROLE;
GRANT SELECT ON DVM_ISS_SEVERITY_HIST TO CCD_READ_ROLE;
GRANT SELECT ON DVM_ISS_TYPES TO CCD_READ_ROLE;
GRANT SELECT ON DVM_ISS_TYPES_HIST TO CCD_READ_ROLE;
GRANT SELECT ON DVM_ISS_TYP_ASSOC TO CCD_READ_ROLE;
GRANT SELECT ON DVM_PTA_ISSUES TO CCD_READ_ROLE;
GRANT SELECT ON DVM_PTA_ISSUES_V TO CCD_READ_ROLE;
GRANT SELECT ON DVM_PTA_ISSUE_SUMM_V TO CCD_READ_ROLE;
GRANT SELECT ON DVM_PTA_ISS_TYPES_V TO CCD_READ_ROLE;
GRANT SELECT ON DVM_PTA_RULE_SETS TO CCD_READ_ROLE;
GRANT SELECT ON DVM_PTA_RULE_SETS_HIST TO CCD_READ_ROLE;
GRANT SELECT ON DVM_PTA_RULE_SETS_HIST_RPT_V TO CCD_READ_ROLE;
GRANT SELECT ON DVM_PTA_RULE_SETS_HIST_V TO CCD_READ_ROLE;
GRANT SELECT ON DVM_PTA_RULE_SETS_RPT_V TO CCD_READ_ROLE;
GRANT SELECT ON DVM_PTA_RULE_SETS_V TO CCD_READ_ROLE;
GRANT SELECT ON DVM_QC_MSG_MISS_FIELDS_V TO CCD_READ_ROLE;
GRANT SELECT ON DVM_QC_OBJECTS TO CCD_READ_ROLE;
GRANT SELECT ON DVM_QC_OBJECTS_HIST TO CCD_READ_ROLE;
GRANT SELECT ON DVM_RULE_SETS TO CCD_READ_ROLE;
GRANT SELECT ON DVM_RULE_SETS_RPT_V TO CCD_READ_ROLE;
GRANT SELECT ON DVM_RULE_SETS_V TO CCD_READ_ROLE;
GRANT SELECT ON DVM_STD_QC_ACT_RULE_SETS_V TO CCD_READ_ROLE;
GRANT SELECT ON DVM_STD_QC_DS_V TO CCD_READ_ROLE;
GRANT SELECT ON DVM_STD_QC_DS_VIEWS_V TO CCD_READ_ROLE;
GRANT SELECT ON DVM_STD_QC_IND_FIELDS_V TO CCD_READ_ROLE;
GRANT SELECT ON DVM_STD_QC_ISS_TEMPL_V TO CCD_READ_ROLE;
GRANT SELECT ON DVM_STD_QC_MISS_CONFIG_V TO CCD_READ_ROLE;

--CCD_WRITE_ROLE:
GRANT SELECT, INSERT, UPDATE, DELETE ON AFF_RESPONSES TO CCD_WRITE_ROLE;
GRANT SELECT ON AFF_RESPONSES_V TO CCD_WRITE_ROLE;
GRANT SELECT, INSERT, UPDATE, DELETE ON AFF_RESP_TYPES TO CCD_WRITE_ROLE;
GRANT SELECT ON CCD_CCDP_DEEP_COPY_CMP_V TO CCD_WRITE_ROLE;
GRANT SELECT, INSERT, UPDATE, DELETE ON CCD_CRUISES TO CCD_WRITE_ROLE;
GRANT SELECT ON CCD_CRUISE_AGG_V TO CCD_WRITE_ROLE;
GRANT SELECT ON CCD_CRUISE_DELIM_V TO CCD_WRITE_ROLE;
GRANT SELECT ON CCD_CRUISE_DVM_EVAL_RPT_V TO CCD_WRITE_ROLE;
GRANT SELECT ON CCD_CRUISE_DVM_EVAL_V TO CCD_WRITE_ROLE;
GRANT SELECT ON CCD_CRUISE_DVM_RULES_RPT_V TO CCD_WRITE_ROLE;
GRANT SELECT ON CCD_CRUISE_DVM_RULES_V TO CCD_WRITE_ROLE;
GRANT SELECT ON CCD_CRUISE_DVM_RULE_EVAL_RPT_V TO CCD_WRITE_ROLE;
GRANT SELECT ON CCD_CRUISE_DVM_RULE_EVAL_V TO CCD_WRITE_ROLE;
GRANT SELECT, INSERT, UPDATE, DELETE ON CCD_CRUISE_EXP_SPP TO CCD_WRITE_ROLE;
GRANT SELECT ON CCD_CRUISE_ISS_SUMM_V TO CCD_WRITE_ROLE;
GRANT SELECT, INSERT, UPDATE, DELETE ON CCD_CRUISE_LEGS TO CCD_WRITE_ROLE;
GRANT SELECT ON CCD_CRUISE_LEG_AGG_V TO CCD_WRITE_ROLE;
GRANT SELECT ON CCD_CRUISE_LEG_DATA_SETS_MIN_V TO CCD_WRITE_ROLE;
GRANT SELECT ON CCD_CRUISE_LEG_DATA_SETS_V TO CCD_WRITE_ROLE;
GRANT SELECT ON CCD_CRUISE_LEG_DELIM_V TO CCD_WRITE_ROLE;
GRANT SELECT ON CCD_CRUISE_LEG_V TO CCD_WRITE_ROLE;
GRANT SELECT, INSERT, UPDATE, DELETE ON CCD_CRUISE_SPP_ESA TO CCD_WRITE_ROLE;
GRANT SELECT, INSERT, UPDATE, DELETE ON CCD_CRUISE_SPP_FSSI TO CCD_WRITE_ROLE;
GRANT SELECT, INSERT, UPDATE, DELETE ON CCD_CRUISE_SPP_MMPA TO CCD_WRITE_ROLE;
GRANT SELECT ON CCD_CRUISE_SUMM_ISS_V TO CCD_WRITE_ROLE;
GRANT SELECT ON CCD_CRUISE_SUMM_V TO CCD_WRITE_ROLE;
GRANT SELECT, INSERT, UPDATE, DELETE ON CCD_CRUISE_SVY_CATS TO CCD_WRITE_ROLE;
GRANT SELECT ON CCD_CRUISE_V TO CCD_WRITE_ROLE;
GRANT SELECT, INSERT, UPDATE, DELETE ON CCD_DATA_SETS TO CCD_WRITE_ROLE;
GRANT SELECT ON CCD_DATA_SETS_V TO CCD_WRITE_ROLE;
GRANT SELECT, INSERT, UPDATE, DELETE ON CCD_DATA_SET_STATUS TO CCD_WRITE_ROLE;
GRANT SELECT, INSERT, UPDATE, DELETE ON CCD_DATA_SET_TYPES TO CCD_WRITE_ROLE;
GRANT SELECT, INSERT, UPDATE, DELETE ON CCD_EXP_SPP_CATS TO CCD_WRITE_ROLE;
GRANT SELECT, INSERT, UPDATE, DELETE ON CCD_GEAR TO CCD_WRITE_ROLE;
GRANT SELECT, INSERT, UPDATE, DELETE ON CCD_GEAR_PRE TO CCD_WRITE_ROLE;
GRANT SELECT ON CCD_GEAR_PRE_DELIM_V TO CCD_WRITE_ROLE;
GRANT SELECT, INSERT, UPDATE, DELETE ON CCD_GEAR_PRE_OPTS TO CCD_WRITE_ROLE;
GRANT SELECT ON CCD_GEAR_PRE_V TO CCD_WRITE_ROLE;
GRANT SELECT ON CCD_LEG_AGG_V TO CCD_WRITE_ROLE;
GRANT SELECT, INSERT, UPDATE, DELETE ON CCD_LEG_ALIASES TO CCD_WRITE_ROLE;
GRANT SELECT, INSERT, UPDATE, DELETE ON CCD_LEG_DATA_SETS TO CCD_WRITE_ROLE;
GRANT SELECT ON CCD_LEG_DATA_SETS_MIN_V TO CCD_WRITE_ROLE;
GRANT SELECT ON CCD_LEG_DATA_SETS_V TO CCD_WRITE_ROLE;
GRANT SELECT ON CCD_LEG_DELIM_V TO CCD_WRITE_ROLE;
GRANT SELECT, INSERT, UPDATE, DELETE ON CCD_LEG_ECOSYSTEMS TO CCD_WRITE_ROLE;
GRANT SELECT ON CCD_LEG_ECOSYSTEMS_V TO CCD_WRITE_ROLE;
GRANT SELECT, INSERT, UPDATE, DELETE ON CCD_LEG_GEAR TO CCD_WRITE_ROLE;
GRANT SELECT ON CCD_LEG_GEAR_V TO CCD_WRITE_ROLE;
GRANT SELECT, INSERT, UPDATE, DELETE ON CCD_LEG_REGIONS TO CCD_WRITE_ROLE;
GRANT SELECT ON CCD_LEG_REGIONS_V TO CCD_WRITE_ROLE;
GRANT SELECT ON CCD_LEG_V TO CCD_WRITE_ROLE;
GRANT SELECT, INSERT, UPDATE, DELETE ON CCD_PLAT_TYPES TO CCD_WRITE_ROLE;
GRANT SELECT ON CCD_QC_CRUISE_V TO CCD_WRITE_ROLE;
GRANT SELECT ON CCD_QC_LEG_ALIAS_V TO CCD_WRITE_ROLE;
GRANT SELECT ON CCD_QC_LEG_OVERLAP_V TO CCD_WRITE_ROLE;
GRANT SELECT ON CCD_QC_LEG_V TO CCD_WRITE_ROLE;
GRANT SELECT, INSERT, UPDATE, DELETE ON CCD_REGIONS TO CCD_WRITE_ROLE;
GRANT SELECT, INSERT, UPDATE, DELETE ON CCD_REGION_PRE TO CCD_WRITE_ROLE;
GRANT SELECT ON CCD_REGION_PRE_DELIM_V TO CCD_WRITE_ROLE;
GRANT SELECT, INSERT, UPDATE, DELETE ON CCD_REGION_PRE_OPTS TO CCD_WRITE_ROLE;
GRANT SELECT ON CCD_REGION_PRE_V TO CCD_WRITE_ROLE;
GRANT SELECT, INSERT, UPDATE, DELETE ON CCD_REG_ECOSYSTEMS TO CCD_WRITE_ROLE;
GRANT SELECT, INSERT, UPDATE, DELETE ON CCD_REG_ECO_PRE TO CCD_WRITE_ROLE;
GRANT SELECT ON CCD_REG_ECO_PRE_DELIM_V TO CCD_WRITE_ROLE;
GRANT SELECT, INSERT, UPDATE, DELETE ON CCD_REG_ECO_PRE_OPTS TO CCD_WRITE_ROLE;
GRANT SELECT ON CCD_REG_ECO_PRE_V TO CCD_WRITE_ROLE;
GRANT SELECT, INSERT, UPDATE, DELETE ON CCD_SCI_CENTERS TO CCD_WRITE_ROLE;
GRANT SELECT ON CCD_SCI_CENTER_DELIM_V TO CCD_WRITE_ROLE;
GRANT SELECT, INSERT, UPDATE, DELETE ON CCD_SCI_CENTER_DIVS TO CCD_WRITE_ROLE;
GRANT SELECT ON CCD_SCI_CENTER_DIV_V TO CCD_WRITE_ROLE;
GRANT SELECT, INSERT, UPDATE, DELETE ON CCD_SPP_CAT_PRE TO CCD_WRITE_ROLE;
GRANT SELECT ON CCD_SPP_CAT_PRE_DELIM_V TO CCD_WRITE_ROLE;
GRANT SELECT, INSERT, UPDATE, DELETE ON CCD_SPP_CAT_PRE_OPTS TO CCD_WRITE_ROLE;
GRANT SELECT ON CCD_SPP_CAT_PRE_V TO CCD_WRITE_ROLE;
GRANT SELECT, INSERT, UPDATE, DELETE ON CCD_SPP_ESA_PRE TO CCD_WRITE_ROLE;
GRANT SELECT ON CCD_SPP_ESA_PRE_DELIM_V TO CCD_WRITE_ROLE;
GRANT SELECT, INSERT, UPDATE, DELETE ON CCD_SPP_ESA_PRE_OPTS TO CCD_WRITE_ROLE;
GRANT SELECT ON CCD_SPP_ESA_PRE_V TO CCD_WRITE_ROLE;
GRANT SELECT, INSERT, UPDATE, DELETE ON CCD_SPP_FSSI_PRE TO CCD_WRITE_ROLE;
GRANT SELECT ON CCD_SPP_FSSI_PRE_DELIM_V TO CCD_WRITE_ROLE;
GRANT SELECT, INSERT, UPDATE, DELETE ON CCD_SPP_FSSI_PRE_OPTS TO CCD_WRITE_ROLE;
GRANT SELECT ON CCD_SPP_FSSI_PRE_V TO CCD_WRITE_ROLE;
GRANT SELECT, INSERT, UPDATE, DELETE ON CCD_SPP_MMPA_PRE TO CCD_WRITE_ROLE;
GRANT SELECT ON CCD_SPP_MMPA_PRE_DELIM_V TO CCD_WRITE_ROLE;
GRANT SELECT, INSERT, UPDATE, DELETE ON CCD_SPP_MMPA_PRE_OPTS TO CCD_WRITE_ROLE;
GRANT SELECT ON CCD_SPP_MMPA_PRE_V TO CCD_WRITE_ROLE;
GRANT SELECT, INSERT, UPDATE, DELETE ON CCD_STD_SVY_NAMES TO CCD_WRITE_ROLE;
GRANT SELECT, INSERT, UPDATE, DELETE ON CCD_SVY_CATS TO CCD_WRITE_ROLE;
GRANT SELECT, INSERT, UPDATE, DELETE ON CCD_SVY_CAT_PRE TO CCD_WRITE_ROLE;
GRANT SELECT ON CCD_SVY_CAT_PRE_DELIM_V TO CCD_WRITE_ROLE;
GRANT SELECT, INSERT, UPDATE, DELETE ON CCD_SVY_CAT_PRE_OPTS TO CCD_WRITE_ROLE;
GRANT SELECT ON CCD_SVY_CAT_PRE_V TO CCD_WRITE_ROLE;
GRANT SELECT, INSERT, UPDATE, DELETE ON CCD_SVY_FREQ TO CCD_WRITE_ROLE;
GRANT SELECT, INSERT, UPDATE, DELETE ON CCD_SVY_TYPES TO CCD_WRITE_ROLE;
GRANT SELECT, INSERT, UPDATE, DELETE ON CCD_TGT_SPP_ESA TO CCD_WRITE_ROLE;
GRANT SELECT, INSERT, UPDATE, DELETE ON CCD_TGT_SPP_FSSI TO CCD_WRITE_ROLE;
GRANT SELECT, INSERT, UPDATE, DELETE ON CCD_TGT_SPP_MMPA TO CCD_WRITE_ROLE;
GRANT SELECT, INSERT, UPDATE, DELETE ON CCD_TGT_SPP_OTHER TO CCD_WRITE_ROLE;
GRANT SELECT, INSERT, UPDATE, DELETE ON CCD_VESSELS TO CCD_WRITE_ROLE;
GRANT SELECT, INSERT, UPDATE, DELETE ON CC_CONFIG_OPTIONS TO CCD_WRITE_ROLE;
GRANT SELECT, INSERT, UPDATE, DELETE ON CC_CONFIG_OPTIONS_HIST TO CCD_WRITE_ROLE;
GRANT SELECT, INSERT, UPDATE, DELETE ON CUST_ERR_CONSTR_MSG TO CCD_WRITE_ROLE;
GRANT SELECT, INSERT, UPDATE, DELETE ON DB_LOG_ENTRIES TO CCD_WRITE_ROLE;
GRANT SELECT ON DB_LOG_ENTRIES_V TO CCD_WRITE_ROLE;
GRANT SELECT, INSERT, UPDATE, DELETE ON DB_LOG_ENTRY_TYPES TO CCD_WRITE_ROLE;
GRANT SELECT, INSERT, UPDATE, DELETE ON DB_UPGRADE_LOGS TO CCD_WRITE_ROLE;
GRANT SELECT ON DB_UPGRADE_LOGS_V TO CCD_WRITE_ROLE;
GRANT SELECT ON DVM_CRITERIA_V TO CCD_WRITE_ROLE;
GRANT SELECT, INSERT, UPDATE, DELETE ON DVM_DATA_STREAMS TO CCD_WRITE_ROLE;
GRANT SELECT, INSERT, UPDATE, DELETE ON DVM_DATA_STREAMS_HIST TO CCD_WRITE_ROLE;
GRANT SELECT ON DVM_DATA_STREAMS_V TO CCD_WRITE_ROLE;
GRANT SELECT ON DVM_DS_PTA_RULE_SETS_HIST_V TO CCD_WRITE_ROLE;
GRANT SELECT ON DVM_DS_PTA_RULE_SETS_V TO CCD_WRITE_ROLE;
GRANT SELECT, INSERT, UPDATE, DELETE ON DVM_ISSUES TO CCD_WRITE_ROLE;
GRANT SELECT, INSERT, UPDATE, DELETE ON DVM_ISSUES_HIST TO CCD_WRITE_ROLE;
GRANT SELECT, INSERT, UPDATE, DELETE ON DVM_ISS_RES_TYPES TO CCD_WRITE_ROLE;
GRANT SELECT, INSERT, UPDATE, DELETE ON DVM_ISS_RES_TYPES_HIST TO CCD_WRITE_ROLE;
GRANT SELECT, INSERT, UPDATE, DELETE ON DVM_ISS_SEVERITY TO CCD_WRITE_ROLE;
GRANT SELECT, INSERT, UPDATE, DELETE ON DVM_ISS_SEVERITY_HIST TO CCD_WRITE_ROLE;
GRANT SELECT, INSERT, UPDATE, DELETE ON DVM_ISS_TYPES TO CCD_WRITE_ROLE;
GRANT SELECT, INSERT, UPDATE, DELETE ON DVM_ISS_TYPES_HIST TO CCD_WRITE_ROLE;
GRANT SELECT, INSERT, UPDATE, DELETE ON DVM_ISS_TYP_ASSOC TO CCD_WRITE_ROLE;
GRANT SELECT, INSERT, UPDATE, DELETE ON DVM_PTA_ISSUES TO CCD_WRITE_ROLE;
GRANT SELECT ON DVM_PTA_ISSUES_V TO CCD_WRITE_ROLE;
GRANT SELECT ON DVM_PTA_ISSUE_SUMM_V TO CCD_WRITE_ROLE;
GRANT SELECT ON DVM_PTA_ISS_TYPES_V TO CCD_WRITE_ROLE;
GRANT SELECT, INSERT, UPDATE, DELETE ON DVM_PTA_RULE_SETS TO CCD_WRITE_ROLE;
GRANT SELECT, INSERT, UPDATE, DELETE ON DVM_PTA_RULE_SETS_HIST TO CCD_WRITE_ROLE;
GRANT SELECT ON DVM_PTA_RULE_SETS_HIST_RPT_V TO CCD_WRITE_ROLE;
GRANT SELECT ON DVM_PTA_RULE_SETS_HIST_V TO CCD_WRITE_ROLE;
GRANT SELECT ON DVM_PTA_RULE_SETS_RPT_V TO CCD_WRITE_ROLE;
GRANT SELECT ON DVM_PTA_RULE_SETS_V TO CCD_WRITE_ROLE;
GRANT SELECT ON DVM_QC_MSG_MISS_FIELDS_V TO CCD_WRITE_ROLE;
GRANT SELECT, INSERT, UPDATE, DELETE ON DVM_QC_OBJECTS TO CCD_WRITE_ROLE;
GRANT SELECT, INSERT, UPDATE, DELETE ON DVM_QC_OBJECTS_HIST TO CCD_WRITE_ROLE;
GRANT SELECT, INSERT, UPDATE, DELETE ON DVM_RULE_SETS TO CCD_WRITE_ROLE;
GRANT SELECT ON DVM_RULE_SETS_RPT_V TO CCD_WRITE_ROLE;
GRANT SELECT ON DVM_RULE_SETS_V TO CCD_WRITE_ROLE;
GRANT SELECT ON DVM_STD_QC_ACT_RULE_SETS_V TO CCD_WRITE_ROLE;
GRANT SELECT ON DVM_STD_QC_DS_V TO CCD_WRITE_ROLE;
GRANT SELECT ON DVM_STD_QC_DS_VIEWS_V TO CCD_WRITE_ROLE;
GRANT SELECT ON DVM_STD_QC_IND_FIELDS_V TO CCD_WRITE_ROLE;
GRANT SELECT ON DVM_STD_QC_ISS_TEMPL_V TO CCD_WRITE_ROLE;
GRANT SELECT ON DVM_STD_QC_MISS_CONFIG_V TO CCD_WRITE_ROLE;



--CCD_ADMIN_ROLE:
GRANT SELECT, INSERT, UPDATE, DELETE ON AFF_RESPONSES TO CCD_ADMIN_ROLE;
GRANT SELECT ON AFF_RESPONSES_V TO CCD_ADMIN_ROLE;
GRANT SELECT, INSERT, UPDATE, DELETE ON AFF_RESP_TYPES TO CCD_ADMIN_ROLE;
GRANT SELECT ON CCD_CCDP_DEEP_COPY_CMP_V TO CCD_ADMIN_ROLE;
GRANT SELECT, INSERT, UPDATE, DELETE ON CCD_CRUISES TO CCD_ADMIN_ROLE;
GRANT SELECT ON CCD_CRUISE_AGG_V TO CCD_ADMIN_ROLE;
GRANT SELECT ON CCD_CRUISE_DELIM_V TO CCD_ADMIN_ROLE;
GRANT SELECT ON CCD_CRUISE_DVM_EVAL_RPT_V TO CCD_ADMIN_ROLE;
GRANT SELECT ON CCD_CRUISE_DVM_EVAL_V TO CCD_ADMIN_ROLE;
GRANT SELECT ON CCD_CRUISE_DVM_RULES_RPT_V TO CCD_ADMIN_ROLE;
GRANT SELECT ON CCD_CRUISE_DVM_RULES_V TO CCD_ADMIN_ROLE;
GRANT SELECT ON CCD_CRUISE_DVM_RULE_EVAL_RPT_V TO CCD_ADMIN_ROLE;
GRANT SELECT ON CCD_CRUISE_DVM_RULE_EVAL_V TO CCD_ADMIN_ROLE;
GRANT SELECT, INSERT, UPDATE, DELETE ON CCD_CRUISE_EXP_SPP TO CCD_ADMIN_ROLE;
GRANT SELECT ON CCD_CRUISE_ISS_SUMM_V TO CCD_ADMIN_ROLE;
GRANT SELECT, INSERT, UPDATE, DELETE ON CCD_CRUISE_LEGS TO CCD_ADMIN_ROLE;
GRANT SELECT ON CCD_CRUISE_LEG_AGG_V TO CCD_ADMIN_ROLE;
GRANT SELECT ON CCD_CRUISE_LEG_DATA_SETS_MIN_V TO CCD_ADMIN_ROLE;
GRANT SELECT ON CCD_CRUISE_LEG_DATA_SETS_V TO CCD_ADMIN_ROLE;
GRANT SELECT ON CCD_CRUISE_LEG_DELIM_V TO CCD_ADMIN_ROLE;
GRANT SELECT ON CCD_CRUISE_LEG_V TO CCD_ADMIN_ROLE;
GRANT EXECUTE ON CCD_CRUISE_PKG TO CCD_ADMIN_ROLE;
GRANT SELECT, INSERT, UPDATE, DELETE ON CCD_CRUISE_SPP_ESA TO CCD_ADMIN_ROLE;
GRANT SELECT, INSERT, UPDATE, DELETE ON CCD_CRUISE_SPP_FSSI TO CCD_ADMIN_ROLE;
GRANT SELECT, INSERT, UPDATE, DELETE ON CCD_CRUISE_SPP_MMPA TO CCD_ADMIN_ROLE;
GRANT SELECT ON CCD_CRUISE_SUMM_ISS_V TO CCD_ADMIN_ROLE;
GRANT SELECT ON CCD_CRUISE_SUMM_V TO CCD_ADMIN_ROLE;
GRANT SELECT, INSERT, UPDATE, DELETE ON CCD_CRUISE_SVY_CATS TO CCD_ADMIN_ROLE;
GRANT SELECT ON CCD_CRUISE_V TO CCD_ADMIN_ROLE;
GRANT SELECT, INSERT, UPDATE, DELETE ON CCD_DATA_SETS TO CCD_ADMIN_ROLE;
GRANT SELECT ON CCD_DATA_SETS_V TO CCD_ADMIN_ROLE;
GRANT SELECT, INSERT, UPDATE, DELETE ON CCD_DATA_SET_STATUS TO CCD_ADMIN_ROLE;
GRANT SELECT, INSERT, UPDATE, DELETE ON CCD_DATA_SET_TYPES TO CCD_ADMIN_ROLE;
GRANT EXECUTE ON CCD_DVM_PKG TO CCD_ADMIN_ROLE;
GRANT SELECT, INSERT, UPDATE, DELETE ON CCD_EXP_SPP_CATS TO CCD_ADMIN_ROLE;
GRANT SELECT, INSERT, UPDATE, DELETE ON CCD_GEAR TO CCD_ADMIN_ROLE;
GRANT SELECT, INSERT, UPDATE, DELETE ON CCD_GEAR_PRE TO CCD_ADMIN_ROLE;
GRANT SELECT ON CCD_GEAR_PRE_DELIM_V TO CCD_ADMIN_ROLE;
GRANT SELECT, INSERT, UPDATE, DELETE ON CCD_GEAR_PRE_OPTS TO CCD_ADMIN_ROLE;
GRANT SELECT ON CCD_GEAR_PRE_V TO CCD_ADMIN_ROLE;
GRANT SELECT ON CCD_LEG_AGG_V TO CCD_ADMIN_ROLE;
GRANT SELECT, INSERT, UPDATE, DELETE ON CCD_LEG_ALIASES TO CCD_ADMIN_ROLE;
GRANT SELECT, INSERT, UPDATE, DELETE ON CCD_LEG_DATA_SETS TO CCD_ADMIN_ROLE;
GRANT SELECT ON CCD_LEG_DATA_SETS_MIN_V TO CCD_ADMIN_ROLE;
GRANT SELECT ON CCD_LEG_DATA_SETS_V TO CCD_ADMIN_ROLE;
GRANT SELECT ON CCD_LEG_DELIM_V TO CCD_ADMIN_ROLE;
GRANT SELECT, INSERT, UPDATE, DELETE ON CCD_LEG_ECOSYSTEMS TO CCD_ADMIN_ROLE;
GRANT SELECT ON CCD_LEG_ECOSYSTEMS_V TO CCD_ADMIN_ROLE;
GRANT SELECT, INSERT, UPDATE, DELETE ON CCD_LEG_GEAR TO CCD_ADMIN_ROLE;
GRANT SELECT ON CCD_LEG_GEAR_V TO CCD_ADMIN_ROLE;
GRANT SELECT, INSERT, UPDATE, DELETE ON CCD_LEG_REGIONS TO CCD_ADMIN_ROLE;
GRANT SELECT ON CCD_LEG_REGIONS_V TO CCD_ADMIN_ROLE;
GRANT SELECT ON CCD_LEG_V TO CCD_ADMIN_ROLE;
GRANT SELECT, INSERT, UPDATE, DELETE ON CCD_PLAT_TYPES TO CCD_ADMIN_ROLE;
GRANT SELECT ON CCD_QC_CRUISE_V TO CCD_ADMIN_ROLE;
GRANT SELECT ON CCD_QC_LEG_ALIAS_V TO CCD_ADMIN_ROLE;
GRANT SELECT ON CCD_QC_LEG_OVERLAP_V TO CCD_ADMIN_ROLE;
GRANT SELECT ON CCD_QC_LEG_V TO CCD_ADMIN_ROLE;
GRANT SELECT, INSERT, UPDATE, DELETE ON CCD_REGIONS TO CCD_ADMIN_ROLE;
GRANT SELECT, INSERT, UPDATE, DELETE ON CCD_REGION_PRE TO CCD_ADMIN_ROLE;
GRANT SELECT ON CCD_REGION_PRE_DELIM_V TO CCD_ADMIN_ROLE;
GRANT SELECT, INSERT, UPDATE, DELETE ON CCD_REGION_PRE_OPTS TO CCD_ADMIN_ROLE;
GRANT SELECT ON CCD_REGION_PRE_V TO CCD_ADMIN_ROLE;
GRANT SELECT, INSERT, UPDATE, DELETE ON CCD_REG_ECOSYSTEMS TO CCD_ADMIN_ROLE;
GRANT SELECT, INSERT, UPDATE, DELETE ON CCD_REG_ECO_PRE TO CCD_ADMIN_ROLE;
GRANT SELECT ON CCD_REG_ECO_PRE_DELIM_V TO CCD_ADMIN_ROLE;
GRANT SELECT, INSERT, UPDATE, DELETE ON CCD_REG_ECO_PRE_OPTS TO CCD_ADMIN_ROLE;
GRANT SELECT ON CCD_REG_ECO_PRE_V TO CCD_ADMIN_ROLE;
GRANT SELECT, INSERT, UPDATE, DELETE ON CCD_SCI_CENTERS TO CCD_ADMIN_ROLE;
GRANT SELECT ON CCD_SCI_CENTER_DELIM_V TO CCD_ADMIN_ROLE;
GRANT SELECT, INSERT, UPDATE, DELETE ON CCD_SCI_CENTER_DIVS TO CCD_ADMIN_ROLE;
GRANT SELECT ON CCD_SCI_CENTER_DIV_V TO CCD_ADMIN_ROLE;
GRANT SELECT, INSERT, UPDATE, DELETE ON CCD_SPP_CAT_PRE TO CCD_ADMIN_ROLE;
GRANT SELECT ON CCD_SPP_CAT_PRE_DELIM_V TO CCD_ADMIN_ROLE;
GRANT SELECT, INSERT, UPDATE, DELETE ON CCD_SPP_CAT_PRE_OPTS TO CCD_ADMIN_ROLE;
GRANT SELECT ON CCD_SPP_CAT_PRE_V TO CCD_ADMIN_ROLE;
GRANT SELECT, INSERT, UPDATE, DELETE ON CCD_SPP_ESA_PRE TO CCD_ADMIN_ROLE;
GRANT SELECT ON CCD_SPP_ESA_PRE_DELIM_V TO CCD_ADMIN_ROLE;
GRANT SELECT, INSERT, UPDATE, DELETE ON CCD_SPP_ESA_PRE_OPTS TO CCD_ADMIN_ROLE;
GRANT SELECT ON CCD_SPP_ESA_PRE_V TO CCD_ADMIN_ROLE;
GRANT SELECT, INSERT, UPDATE, DELETE ON CCD_SPP_FSSI_PRE TO CCD_ADMIN_ROLE;
GRANT SELECT ON CCD_SPP_FSSI_PRE_DELIM_V TO CCD_ADMIN_ROLE;
GRANT SELECT, INSERT, UPDATE, DELETE ON CCD_SPP_FSSI_PRE_OPTS TO CCD_ADMIN_ROLE;
GRANT SELECT ON CCD_SPP_FSSI_PRE_V TO CCD_ADMIN_ROLE;
GRANT SELECT, INSERT, UPDATE, DELETE ON CCD_SPP_MMPA_PRE TO CCD_ADMIN_ROLE;
GRANT SELECT ON CCD_SPP_MMPA_PRE_DELIM_V TO CCD_ADMIN_ROLE;
GRANT SELECT, INSERT, UPDATE, DELETE ON CCD_SPP_MMPA_PRE_OPTS TO CCD_ADMIN_ROLE;
GRANT SELECT ON CCD_SPP_MMPA_PRE_V TO CCD_ADMIN_ROLE;
GRANT SELECT, INSERT, UPDATE, DELETE ON CCD_STD_SVY_NAMES TO CCD_ADMIN_ROLE;
GRANT SELECT, INSERT, UPDATE, DELETE ON CCD_SVY_CATS TO CCD_ADMIN_ROLE;
GRANT SELECT, INSERT, UPDATE, DELETE ON CCD_SVY_CAT_PRE TO CCD_ADMIN_ROLE;
GRANT SELECT ON CCD_SVY_CAT_PRE_DELIM_V TO CCD_ADMIN_ROLE;
GRANT SELECT, INSERT, UPDATE, DELETE ON CCD_SVY_CAT_PRE_OPTS TO CCD_ADMIN_ROLE;
GRANT SELECT ON CCD_SVY_CAT_PRE_V TO CCD_ADMIN_ROLE;
GRANT SELECT, INSERT, UPDATE, DELETE ON CCD_SVY_FREQ TO CCD_ADMIN_ROLE;
GRANT SELECT, INSERT, UPDATE, DELETE ON CCD_SVY_TYPES TO CCD_ADMIN_ROLE;
GRANT SELECT, INSERT, UPDATE, DELETE ON CCD_TGT_SPP_ESA TO CCD_ADMIN_ROLE;
GRANT SELECT, INSERT, UPDATE, DELETE ON CCD_TGT_SPP_FSSI TO CCD_ADMIN_ROLE;
GRANT SELECT, INSERT, UPDATE, DELETE ON CCD_TGT_SPP_MMPA TO CCD_ADMIN_ROLE;
GRANT SELECT, INSERT, UPDATE, DELETE ON CCD_TGT_SPP_OTHER TO CCD_ADMIN_ROLE;
GRANT SELECT, INSERT, UPDATE, DELETE ON CCD_VESSELS TO CCD_ADMIN_ROLE;
GRANT SELECT, INSERT, UPDATE, DELETE ON CC_CONFIG_OPTIONS TO CCD_ADMIN_ROLE;
GRANT SELECT, INSERT, UPDATE, DELETE ON CC_CONFIG_OPTIONS_HIST TO CCD_ADMIN_ROLE;
GRANT SELECT, INSERT, UPDATE, DELETE ON CUST_ERR_CONSTR_MSG TO CCD_ADMIN_ROLE;
GRANT EXECUTE ON CUST_ERR_PKG TO CCD_ADMIN_ROLE;
GRANT SELECT, INSERT, UPDATE, DELETE ON DB_LOG_ENTRIES TO CCD_ADMIN_ROLE;
GRANT SELECT ON DB_LOG_ENTRIES_V TO CCD_ADMIN_ROLE;
GRANT SELECT, INSERT, UPDATE, DELETE ON DB_LOG_ENTRY_TYPES TO CCD_ADMIN_ROLE;
GRANT EXECUTE ON DB_LOG_PKG TO CCD_ADMIN_ROLE;
GRANT SELECT, INSERT, UPDATE, DELETE ON DB_UPGRADE_LOGS TO CCD_ADMIN_ROLE;
GRANT SELECT ON DB_UPGRADE_LOGS_V TO CCD_ADMIN_ROLE;
GRANT SELECT ON DVM_CRITERIA_V TO CCD_ADMIN_ROLE;
GRANT SELECT, INSERT, UPDATE, DELETE ON DVM_DATA_STREAMS TO CCD_ADMIN_ROLE;
GRANT SELECT, INSERT, UPDATE, DELETE ON DVM_DATA_STREAMS_HIST TO CCD_ADMIN_ROLE;
GRANT SELECT ON DVM_DATA_STREAMS_V TO CCD_ADMIN_ROLE;
GRANT SELECT ON DVM_DS_PTA_RULE_SETS_HIST_V TO CCD_ADMIN_ROLE;
GRANT SELECT ON DVM_DS_PTA_RULE_SETS_V TO CCD_ADMIN_ROLE;
GRANT SELECT, INSERT, UPDATE, DELETE ON DVM_ISSUES TO CCD_ADMIN_ROLE;
GRANT SELECT, INSERT, UPDATE, DELETE ON DVM_ISSUES_HIST TO CCD_ADMIN_ROLE;
GRANT SELECT, INSERT, UPDATE, DELETE ON DVM_ISS_RES_TYPES TO CCD_ADMIN_ROLE;
GRANT SELECT, INSERT, UPDATE, DELETE ON DVM_ISS_RES_TYPES_HIST TO CCD_ADMIN_ROLE;
GRANT SELECT, INSERT, UPDATE, DELETE ON DVM_ISS_SEVERITY TO CCD_ADMIN_ROLE;
GRANT SELECT, INSERT, UPDATE, DELETE ON DVM_ISS_SEVERITY_HIST TO CCD_ADMIN_ROLE;
GRANT SELECT, INSERT, UPDATE, DELETE ON DVM_ISS_TYPES TO CCD_ADMIN_ROLE;
GRANT SELECT, INSERT, UPDATE, DELETE ON DVM_ISS_TYPES_HIST TO CCD_ADMIN_ROLE;
GRANT SELECT, INSERT, UPDATE, DELETE ON DVM_ISS_TYP_ASSOC TO CCD_ADMIN_ROLE;
GRANT EXECUTE ON DVM_PKG TO CCD_ADMIN_ROLE;
GRANT SELECT, INSERT, UPDATE, DELETE ON DVM_PTA_ISSUES TO CCD_ADMIN_ROLE;
GRANT SELECT ON DVM_PTA_ISSUES_V TO CCD_ADMIN_ROLE;
GRANT SELECT ON DVM_PTA_ISSUE_SUMM_V TO CCD_ADMIN_ROLE;
GRANT SELECT ON DVM_PTA_ISS_TYPES_V TO CCD_ADMIN_ROLE;
GRANT SELECT, INSERT, UPDATE, DELETE ON DVM_PTA_RULE_SETS TO CCD_ADMIN_ROLE;
GRANT SELECT, INSERT, UPDATE, DELETE ON DVM_PTA_RULE_SETS_HIST TO CCD_ADMIN_ROLE;
GRANT SELECT ON DVM_PTA_RULE_SETS_HIST_RPT_V TO CCD_ADMIN_ROLE;
GRANT SELECT ON DVM_PTA_RULE_SETS_HIST_V TO CCD_ADMIN_ROLE;
GRANT SELECT ON DVM_PTA_RULE_SETS_RPT_V TO CCD_ADMIN_ROLE;
GRANT SELECT ON DVM_PTA_RULE_SETS_V TO CCD_ADMIN_ROLE;
GRANT SELECT ON DVM_QC_MSG_MISS_FIELDS_V TO CCD_ADMIN_ROLE;
GRANT SELECT, INSERT, UPDATE, DELETE ON DVM_QC_OBJECTS TO CCD_ADMIN_ROLE;
GRANT SELECT, INSERT, UPDATE, DELETE ON DVM_QC_OBJECTS_HIST TO CCD_ADMIN_ROLE;
GRANT SELECT, INSERT, UPDATE, DELETE ON DVM_RULE_SETS TO CCD_ADMIN_ROLE;
GRANT SELECT ON DVM_RULE_SETS_RPT_V TO CCD_ADMIN_ROLE;
GRANT SELECT ON DVM_RULE_SETS_V TO CCD_ADMIN_ROLE;
GRANT SELECT ON DVM_STD_QC_ACT_RULE_SETS_V TO CCD_ADMIN_ROLE;
GRANT SELECT ON DVM_STD_QC_DS_V TO CCD_ADMIN_ROLE;
GRANT SELECT ON DVM_STD_QC_DS_VIEWS_V TO CCD_ADMIN_ROLE;
GRANT SELECT ON DVM_STD_QC_IND_FIELDS_V TO CCD_ADMIN_ROLE;
GRANT SELECT ON DVM_STD_QC_ISS_TEMPL_V TO CCD_ADMIN_ROLE;
GRANT SELECT ON DVM_STD_QC_MISS_CONFIG_V TO CCD_ADMIN_ROLE;
