--drop all objects to restore schema to a blank schema:

DROP VIEW CCD_CRUISE_DVM_RULES_V;
DROP VIEW DVM_RULE_SETS_RPT_V;
DROP VIEW DVM_PTA_RULE_SETS_RPT_V;
DROP VIEW DVM_DS_PTA_RULE_SETS_V;
DROP VIEW CCD_CRUISE_DVM_RULES_RPT_V;
DROP TABLE DVM_PTA_RULE_SETS_HIST cascade constraints PURGE;
DROP SEQUENCE DVM_PTA_RULE_SETS_HIST_SEQ;
DROP VIEW DVM_DS_PTA_RULE_SETS_HIST_V;
DROP VIEW DVM_PTA_RULE_SETS_HIST_V;
DROP VIEW DVM_PTA_RULE_SETS_HIST_RPT_V;
DROP VIEW CCD_CRUISE_DVM_EVAL_RPT_V;
DROP VIEW CCD_CRUISE_DVM_RULE_EVAL_V;
DROP VIEW CCD_CRUISE_DVM_RULE_EVAL_RPT_V;
DROP VIEW DVM_STD_QC_DS_V;
DROP VIEW DVM_STD_QC_ISS_TEMPL_V;
DROP VIEW DVM_STD_QC_VIEW_V;
DROP VIEW DVM_STD_QC_ACT_RULE_SETS_V;
DROP VIEW DVM_STD_QC_MISS_CONFIG_V;
DROP VIEW DVM_STD_QC_ALL_RPT_V;
DROP VIEW DVM_STD_QC_IND_FIELDS_V;
DROP VIEW DVM_STD_QC_DS_VIEWS_V;
DROP VIEW CCD_CCDP_DEEP_COPY_CMP_V;
DROP TABLE AFF_RESP_TYPES cascade constraints PURGE;
DROP SEQUENCE DB_LOG_ENTRIES_SEQ;
DROP TABLE DB_LOG_ENTRY_TYPES cascade constraints PURGE;
DROP SEQUENCE DB_LOG_ENTRY_TYPES_SEQ;
DROP PACKAGE DB_LOG_PKG;
DROP VIEW DB_LOG_ENTRIES_V;
DROP SEQUENCE CUST_ERR_CONSTR_MSG_SEQ;
DROP TABLE CUST_ERR_CONSTR_MSG cascade constraints PURGE;
DROP PACKAGE CUST_ERR_PKG;
DROP TABLE CCD_PLAT_TYPES cascade constraints PURGE;
DROP TABLE CCD_REG_ECOSYSTEMS cascade constraints PURGE;
DROP TABLE CCD_GEAR cascade constraints PURGE;
DROP TABLE CCD_STD_SVY_NAMES cascade constraints PURGE;
DROP TABLE CCD_SVY_FREQ cascade constraints PURGE;
DROP TABLE CCD_SVY_CATS cascade constraints PURGE;
DROP TABLE CCD_TGT_SPP_ESA cascade constraints PURGE;
DROP TABLE CCD_TGT_SPP_MMPA cascade constraints PURGE;
DROP TABLE CCD_TGT_SPP_FSSI cascade constraints PURGE;
DROP TABLE CCD_TGT_SPP_OTHER cascade constraints PURGE;
DROP TABLE CCD_SVY_TYPES cascade constraints PURGE;
DROP TABLE CCD_SCI_CENTERS cascade constraints PURGE;
DROP TABLE CCD_EXP_SPP_CATS cascade constraints PURGE;
DROP SEQUENCE CCD_PLAT_TYPES_SEQ;
DROP SEQUENCE CCD_REG_ECOSYSTEMS_SEQ;
DROP SEQUENCE CCD_SPP_CAT_PRE_OPTS_HIST_SEQ;
DROP SEQUENCE CCD_SPP_ESA_PRE_HIST_SEQ;
DROP SEQUENCE CCD_SPP_ESA_PRE_OPTS_HIST_SEQ;
DROP SEQUENCE CCD_SPP_FSSI_PRE_HIST_SEQ;
DROP SEQUENCE CCD_SPP_FSSI_PRE_OPTS_HIST_SEQ;
DROP SEQUENCE CCD_SPP_MMPA_PRE_HIST_SEQ;
DROP SEQUENCE CCD_SPP_MMPA_PRE_OPTS_HIST_SEQ;
DROP SEQUENCE CCD_STD_SVY_NAMES_HIST_SEQ;
DROP SEQUENCE CCD_SVY_CATS_HIST_SEQ;
DROP SEQUENCE CCD_SVY_CAT_PRE_HIST_SEQ;
DROP SEQUENCE CCD_SVY_CAT_PRE_OPTS_HIST_SEQ;
DROP SEQUENCE CCD_SVY_FREQ_HIST_SEQ;
DROP SEQUENCE CCD_SVY_TYPES_HIST_SEQ;
DROP SEQUENCE CCD_TGT_SPP_ESA_HIST_SEQ;
DROP SEQUENCE CCD_TGT_SPP_FSSI_HIST_SEQ;
DROP SEQUENCE CCD_TGT_SPP_MMPA_HIST_SEQ;
DROP SEQUENCE CCD_TGT_SPP_OTHER_HIST_SEQ;
DROP SEQUENCE CCD_VESSELS_HIST_SEQ;
DROP SEQUENCE CCD_CRUISE_EXP_SPP_SEQ;
DROP TABLE CCD_LEG_ECOSYSTEMS cascade constraints PURGE;
DROP TABLE CCD_LEG_GEAR cascade constraints PURGE;
DROP SEQUENCE CCD_LEG_GEAR_SEQ;
DROP SEQUENCE CCD_LEG_ECOSYSTEMS_SEQ;
DROP TABLE CCD_GEAR_PRE cascade constraints PURGE;
DROP VIEW CCD_LEG_V;
DROP VIEW CCD_LEG_DELIM_V;
DROP VIEW CCD_CRUISE_V;
DROP VIEW CCD_CRUISE_DELIM_V;
DROP VIEW CCD_CRUISE_SUMM_V;
DROP VIEW CCD_CRUISE_LEG_DELIM_V;
DROP SEQUENCE CCD_GEAR_PRE_SEQ;
DROP TABLE CCD_GEAR_PRE_OPTS cascade constraints PURGE;
DROP SEQUENCE CCD_GEAR_PRE_OPTS_SEQ;
DROP VIEW CCD_GEAR_PRE_V;
DROP TABLE CCD_REG_ECO_PRE cascade constraints PURGE;
DROP SEQUENCE CCD_REG_ECO_PRE_SEQ;
DROP TABLE CCD_REG_ECO_PRE_OPTS cascade constraints PURGE;
DROP SEQUENCE CCD_REG_ECO_PRE_OPTS_SEQ;
DROP VIEW CCD_REG_ECO_PRE_V;
DROP TABLE CCD_REGION_PRE cascade constraints PURGE;
DROP SEQUENCE CCD_REGION_PRE_SEQ;
DROP TABLE CCD_DATA_SET_TYPES cascade constraints PURGE;
DROP SEQUENCE CCD_DATA_SET_TYPES_SEQ;
DROP TABLE CCD_CRUISE_LEGS cascade constraints PURGE;
DROP TABLE CCD_DATA_SETS cascade constraints PURGE;
DROP TABLE CCD_REGION_PRE_OPTS cascade constraints PURGE;
DROP SEQUENCE CCD_REGION_PRE_OPTS_SEQ;
DROP VIEW CCD_REGION_PRE_V;
DROP TABLE CCD_SVY_CAT_PRE cascade constraints PURGE;
DROP SEQUENCE CCD_SVY_CAT_PRE_SEQ;
DROP TABLE CCD_SVY_CAT_PRE_OPTS cascade constraints PURGE;
DROP SEQUENCE CCD_SVY_CAT_PRE_OPTS_SEQ;
DROP VIEW CCD_SVY_CAT_PRE_V;
DROP TABLE CCD_SPP_MMPA_PRE cascade constraints PURGE;
DROP SEQUENCE CCD_SPP_MMPA_PRE_SEQ;
DROP TABLE CCD_SPP_MMPA_PRE_OPTS cascade constraints PURGE;
DROP SEQUENCE CCD_SPP_MMPA_PRE_OPTS_SEQ;
DROP VIEW CCD_SPP_MMPA_PRE_V;
DROP TABLE CCD_SPP_ESA_PRE cascade constraints PURGE;
DROP SEQUENCE CCD_SPP_ESA_PRE_SEQ;
DROP TABLE CCD_SPP_ESA_PRE_OPTS cascade constraints PURGE;
DROP SEQUENCE CCD_SPP_ESA_PRE_OPTS_SEQ;
DROP VIEW CCD_SPP_ESA_PRE_V;
DROP TABLE CCD_SPP_FSSI_PRE cascade constraints PURGE;
DROP SEQUENCE CCD_SPP_FSSI_PRE_SEQ;
DROP TABLE CCD_SPP_FSSI_PRE_OPTS cascade constraints PURGE;
DROP SEQUENCE CCD_SPP_FSSI_PRE_OPTS_SEQ;
DROP VIEW DVM_DATA_STREAMS_V;
DROP PACKAGE DVM_PKG;
DROP VIEW DVM_QC_MSG_MISS_FIELDS_V;
DROP TABLE DVM_DATA_STREAMS_HIST cascade constraints PURGE;
DROP TABLE DVM_QC_OBJECTS_HIST cascade constraints PURGE;
DROP SEQUENCE DVM_DATA_STREAMS_HIST_SEQ;
DROP SEQUENCE DVM_QC_OBJECTS_HIST_SEQ;
DROP TABLE CCD_VESSELS cascade constraints PURGE;
DROP TABLE CCD_CRUISES cascade constraints PURGE;
DROP SEQUENCE CCD_CRUISES_SEQ;
DROP SEQUENCE CCD_VESSELS_SEQ;
DROP TABLE DVM_QC_OBJECTS cascade constraints PURGE;
DROP SEQUENCE DVM_QC_OBJECTS_SEQ;
DROP SEQUENCE DVM_DATA_STREAMS_SEQ;
DROP TABLE CCD_SPP_CAT_PRE_OPTS_HIST cascade constraints PURGE;
DROP TABLE CCD_SPP_ESA_PRE_HIST cascade constraints PURGE;
DROP TABLE CCD_SPP_ESA_PRE_OPTS_HIST cascade constraints PURGE;
DROP TABLE CCD_SPP_FSSI_PRE_HIST cascade constraints PURGE;
DROP TABLE CCD_SPP_FSSI_PRE_OPTS_HIST cascade constraints PURGE;
DROP TABLE CCD_SPP_MMPA_PRE_HIST cascade constraints PURGE;
DROP TABLE CCD_SPP_MMPA_PRE_OPTS_HIST cascade constraints PURGE;
DROP TABLE CCD_STD_SVY_NAMES_HIST cascade constraints PURGE;
DROP TABLE CCD_SVY_CATS_HIST cascade constraints PURGE;
DROP TABLE CCD_SVY_CAT_PRE_HIST cascade constraints PURGE;
DROP TABLE CCD_SVY_CAT_PRE_OPTS_HIST cascade constraints PURGE;
DROP TABLE CCD_SVY_FREQ_HIST cascade constraints PURGE;
DROP TABLE CCD_SVY_TYPES_HIST cascade constraints PURGE;
DROP TABLE CCD_TGT_SPP_ESA_HIST cascade constraints PURGE;
DROP TABLE CCD_TGT_SPP_FSSI_HIST cascade constraints PURGE;
DROP TABLE CCD_TGT_SPP_MMPA_HIST cascade constraints PURGE;
DROP TABLE CCD_TGT_SPP_OTHER_HIST cascade constraints PURGE;
DROP TABLE CCD_VESSELS_HIST cascade constraints PURGE;
DROP SEQUENCE CCD_CRUISES_HIST_SEQ;
DROP SEQUENCE CCD_CRUISE_EXP_SPP_HIST_SEQ;
DROP SEQUENCE CCD_CRUISE_LEGS_HIST_SEQ;
DROP SEQUENCE CCD_CRUISE_SPP_ESA_HIST_SEQ;
DROP SEQUENCE CCD_CRUISE_SPP_FSSI_HIST_SEQ;
DROP SEQUENCE CCD_CRUISE_SPP_MMPA_HIST_SEQ;
DROP SEQUENCE CCD_CRUISE_SVY_CATS_HIST_SEQ;
DROP SEQUENCE CCD_DATA_SETS_HIST_SEQ;
DROP SEQUENCE CCD_DATA_SET_STATUS_HIST_SEQ;
DROP SEQUENCE CCD_DATA_SET_TYPES_HIST_SEQ;
DROP SEQUENCE CCD_EXP_SPP_CATS_HIST_SEQ;
DROP SEQUENCE CCD_GEAR_HIST_SEQ;
DROP SEQUENCE CCD_GEAR_PRE_HIST_SEQ;
DROP SEQUENCE CCD_GEAR_PRE_OPTS_HIST_SEQ;
DROP SEQUENCE CCD_LEG_ALIASES_HIST_SEQ;
DROP SEQUENCE CCD_LEG_DATA_SETS_HIST_SEQ;
DROP SEQUENCE CCD_LEG_ECOSYSTEMS_HIST_SEQ;
DROP SEQUENCE CCD_LEG_GEAR_HIST_SEQ;
DROP SEQUENCE CCD_LEG_REGIONS_HIST_SEQ;
DROP SEQUENCE CCD_PLAT_TYPES_HIST_SEQ;
DROP SEQUENCE CCD_REGIONS_HIST_SEQ;
DROP SEQUENCE CCD_REGION_PRE_HIST_SEQ;
DROP SEQUENCE CCD_REGION_PRE_OPTS_HIST_SEQ;
DROP SEQUENCE CCD_REG_ECOSYSTEMS_HIST_SEQ;
DROP SEQUENCE CCD_REG_ECO_PRE_HIST_SEQ;
DROP SEQUENCE CCD_REG_ECO_PRE_OPTS_HIST_SEQ;
DROP SEQUENCE CCD_SCI_CENTERS_HIST_SEQ;
DROP SEQUENCE CCD_SCI_CENTER_DIVS_HIST_SEQ;
DROP SEQUENCE CCD_SPP_CAT_PRE_HIST_SEQ;
DROP SEQUENCE CCD_DATA_SETS_SEQ;
DROP TABLE CCD_DATA_SET_STATUS cascade constraints PURGE;
DROP TABLE CCD_REGIONS cascade constraints PURGE;
DROP TABLE CCD_LEG_REGIONS cascade constraints PURGE;
DROP SEQUENCE CCD_REGIONS_SEQ;
DROP SEQUENCE CCD_LEG_REGIONS_SEQ;
DROP SEQUENCE CCD_CRUISE_LEGS_SEQ;
DROP SEQUENCE CCD_DATA_SET_STATUS_SEQ;
DROP VIEW CCD_DATA_SETS_V;
DROP TABLE CCD_LEG_ALIASES cascade constraints PURGE;
DROP SEQUENCE CCD_LEG_ALIASES_SEQ;
DROP TABLE DB_LOG_ENTRIES cascade constraints PURGE;
DROP VIEW DVM_PTA_RULE_SETS_V;
DROP VIEW DVM_CRITERIA_V;
DROP VIEW DVM_RULE_SETS_V;
DROP TABLE DVM_ISS_RES_TYPES cascade constraints PURGE;
DROP TABLE DVM_ISS_SEVERITY cascade constraints PURGE;
DROP TABLE DVM_ISS_TYPES cascade constraints PURGE;
DROP TABLE DVM_ISSUES cascade constraints PURGE;
DROP TABLE DVM_PTA_ISSUES cascade constraints PURGE;
DROP SEQUENCE DVM_ISSUES_SEQ;
DROP SEQUENCE DVM_ISS_TYPES_SEQ;
DROP SEQUENCE DVM_ISS_RES_TYPES_SEQ;
DROP SEQUENCE DVM_ISS_SEVERITY_SEQ;
DROP SEQUENCE DVM_PTA_ISSUES_SEQ;
DROP TABLE DVM_ISS_RES_TYPES_HIST cascade constraints PURGE;
DROP TABLE DVM_ISS_SEVERITY_HIST cascade constraints PURGE;
DROP TABLE DVM_ISS_TYPES_HIST cascade constraints PURGE;
DROP TABLE DVM_ISSUES_HIST cascade constraints PURGE;
DROP SEQUENCE DVM_ISS_RES_TYPES_HIST_SEQ;
DROP SEQUENCE DVM_ISS_SEVERITY_HIST_SEQ;
DROP SEQUENCE DVM_ISS_TYPES_HIST_SEQ;
DROP SEQUENCE DVM_ISSUES_HIST_SEQ;
DROP VIEW DVM_PTA_ISS_TYPES_V;
DROP VIEW DVM_PTA_ISSUES_V;
DROP VIEW CCD_CRUISE_ISS_SUMM_V;
DROP VIEW CCD_CRUISE_SUMM_ISS_V;
DROP VIEW CCD_SPP_FSSI_PRE_V;
DROP TABLE CCD_SPP_CAT_PRE cascade constraints PURGE;
DROP SEQUENCE CCD_SPP_CAT_PRE_SEQ;
DROP TABLE CCD_SPP_CAT_PRE_OPTS cascade constraints PURGE;
DROP SEQUENCE CCD_SPP_CAT_PRE_OPTS_SEQ;
DROP VIEW CCD_SPP_CAT_PRE_V;
DROP VIEW CCD_REG_ECO_PRE_DELIM_V;
DROP VIEW CCD_REGION_PRE_DELIM_V;
DROP VIEW CCD_SPP_CAT_PRE_DELIM_V;
DROP VIEW CCD_SPP_ESA_PRE_DELIM_V;
DROP VIEW CCD_SPP_MMPA_PRE_DELIM_V;
DROP VIEW CCD_SPP_FSSI_PRE_DELIM_V;
DROP VIEW CCD_SVY_CAT_PRE_DELIM_V;
DROP TABLE CCD_SCI_CENTER_DIVS cascade constraints PURGE;
DROP SEQUENCE CCD_SCI_CENTER_DIVS_SEQ;
DROP VIEW CCD_SCI_CENTER_DIV_V;
DROP VIEW CCD_SCI_CENTER_DELIM_V;
DROP VIEW CCD_GEAR_PRE_DELIM_V;
DROP PACKAGE CCD_CRUISE_PKG;
DROP VIEW CCD_QC_LEG_OVERLAP_V;
DROP VIEW CCD_QC_LEG_V;
DROP VIEW CCD_QC_CRUISE_V;
DROP VIEW CCD_QC_LEG_ALIAS_V;
DROP PACKAGE CCD_DVM_PKG;
DROP TABLE DVM_RULE_SETS cascade constraints PURGE;
DROP SEQUENCE DVM_RULE_SETS_SEQ;
DROP TABLE DVM_ISS_TYP_ASSOC cascade constraints PURGE;
DROP SEQUENCE DVM_ISS_TYP_ASSOC_SEQ;
DROP TABLE DVM_PTA_RULE_SETS cascade constraints PURGE;
DROP SEQUENCE DVM_PTA_RULE_SETS_SEQ;
DROP VIEW CCD_CRUISE_LEG_AGG_V;
DROP VIEW CCD_LEG_DATA_SETS_V;
DROP VIEW CCD_CRUISE_DVM_EVAL_V;
DROP VIEW CCD_CRUISE_LEG_DATA_SETS_V;
DROP VIEW CCD_CRUISE_LEG_DATA_SETS_MIN_V;
DROP VIEW CCD_DATA_SETS_INP_V;
DROP TABLE CCD_CRUISES_HIST cascade constraints PURGE;
DROP TABLE CCD_CRUISE_EXP_SPP_HIST cascade constraints PURGE;
DROP TABLE CCD_CRUISE_LEGS_HIST cascade constraints PURGE;
DROP TABLE CCD_CRUISE_SPP_ESA_HIST cascade constraints PURGE;
DROP TABLE CCD_CRUISE_SPP_FSSI_HIST cascade constraints PURGE;
DROP TABLE CCD_CRUISE_SPP_MMPA_HIST cascade constraints PURGE;
DROP TABLE CCD_CRUISE_SVY_CATS_HIST cascade constraints PURGE;
DROP TABLE CCD_DATA_SETS_HIST cascade constraints PURGE;
DROP TABLE CCD_DATA_SET_STATUS_HIST cascade constraints PURGE;
DROP TABLE CCD_DATA_SET_TYPES_HIST cascade constraints PURGE;
DROP TABLE CCD_EXP_SPP_CATS_HIST cascade constraints PURGE;
DROP TABLE CCD_GEAR_HIST cascade constraints PURGE;
DROP TABLE CCD_GEAR_PRE_HIST cascade constraints PURGE;
DROP TABLE CCD_GEAR_PRE_OPTS_HIST cascade constraints PURGE;
DROP TABLE CCD_LEG_ALIASES_HIST cascade constraints PURGE;
DROP TABLE CCD_LEG_DATA_SETS_HIST cascade constraints PURGE;
DROP TABLE CCD_LEG_ECOSYSTEMS_HIST cascade constraints PURGE;
DROP TABLE CCD_LEG_GEAR_HIST cascade constraints PURGE;
DROP TABLE CCD_LEG_REGIONS_HIST cascade constraints PURGE;
DROP TABLE CCD_PLAT_TYPES_HIST cascade constraints PURGE;
DROP TABLE CCD_REGIONS_HIST cascade constraints PURGE;
DROP TABLE CCD_REGION_PRE_HIST cascade constraints PURGE;
DROP TABLE CCD_REGION_PRE_OPTS_HIST cascade constraints PURGE;
DROP TABLE CCD_REG_ECOSYSTEMS_HIST cascade constraints PURGE;
DROP TABLE CCD_REG_ECO_PRE_HIST cascade constraints PURGE;
DROP TABLE CCD_REG_ECO_PRE_OPTS_HIST cascade constraints PURGE;
DROP TABLE CCD_SCI_CENTERS_HIST cascade constraints PURGE;
DROP TABLE CCD_SCI_CENTER_DIVS_HIST cascade constraints PURGE;
DROP TABLE CCD_SPP_CAT_PRE_HIST cascade constraints PURGE;
DROP SEQUENCE AFF_RESP_TYPES_SEQ;
DROP TABLE AFF_RESPONSES cascade constraints PURGE;
DROP SEQUENCE AFF_RESPONSES_SEQ;
DROP VIEW AFF_RESPONSES_V;
DROP TABLE CC_CONFIG_OPTIONS cascade constraints PURGE;
DROP SEQUENCE CC_CONFIG_OPTIONS_SEQ;
DROP TABLE CC_CONFIG_OPTIONS_HIST cascade constraints PURGE;
DROP SEQUENCE CC_CONFIG_OPTIONS_HIST_SEQ;
DROP VIEW DVM_PTA_ISSUE_SUMM_V;
DROP TABLE CCD_LEG_DATA_SETS cascade constraints PURGE;
DROP SEQUENCE CCD_LEG_DATA_SETS_SEQ;
DROP VIEW CCD_LEG_DATA_SETS_MIN_V;
DROP VIEW CCD_LEG_ECOSYSTEMS_V;
DROP VIEW CCD_LEG_GEAR_V;
DROP VIEW CCD_LEG_REGIONS_V;
DROP VIEW CCD_LEG_AGG_V;
DROP VIEW CCD_CRUISE_AGG_V;
DROP VIEW CCD_CRUISE_LEG_V;
DROP SEQUENCE CCD_GEAR_SEQ;
DROP SEQUENCE CCD_STD_SVY_NAMES_SEQ;
DROP SEQUENCE CCD_SVY_FREQ_SEQ;
DROP SEQUENCE CCD_SVY_CATS_SEQ;
DROP SEQUENCE CCD_TGT_SPP_ESA_SEQ;
DROP SEQUENCE CCD_TGT_SPP_MMPA_SEQ;
DROP SEQUENCE CCD_TGT_SPP_FSSI_SEQ;
DROP SEQUENCE CCD_TGT_SPP_OTHER_SEQ;
DROP SEQUENCE CCD_SVY_TYPES_SEQ;
DROP SEQUENCE CCD_SCI_CENTERS_SEQ;
DROP SEQUENCE CCD_EXP_SPP_CATS_SEQ;
DROP TABLE CCD_CRUISE_SVY_CATS cascade constraints PURGE;
DROP TABLE CCD_CRUISE_SPP_ESA cascade constraints PURGE;
DROP TABLE CCD_CRUISE_SPP_MMPA cascade constraints PURGE;
DROP TABLE CCD_CRUISE_SPP_FSSI cascade constraints PURGE;
DROP TABLE CCD_CRUISE_EXP_SPP cascade constraints PURGE;
DROP SEQUENCE CCD_CRUISE_SVY_CATS_SEQ;
DROP SEQUENCE CCD_CRUISE_SPP_ESA_SEQ;
DROP SEQUENCE CCD_CRUISE_SPP_MMPA_SEQ;
DROP SEQUENCE CCD_CRUISE_SPP_FSSI_SEQ;
DROP SYNONYM CEN_UTIL_PKG;
DROP SYNONYM CEN_UTIL_ARRAY_PKG;
DROP SYNONYM ODS_INP_DATASET_SCORING;
DROP SYNONYM DS_CUST_FLD_PKG_LOG_FILES_V;
DROP SYNONYM DS_PIR_SCOR_V;
DROP TABLE DB_UPGRADE_LOGS cascade constraints PURGE;
DROP SEQUENCE DB_UPGRADE_LOGS_SEQ;
DROP VIEW DB_UPGRADE_LOGS_V;
DROP TABLE DVM_DATA_STREAMS cascade constraints PURGE;