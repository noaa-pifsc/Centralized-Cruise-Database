--Centralized Utilities Package
CREATE OR REPLACE SYNONYM CEN_UTIL_PKG FOR CEN_UTILS.CEN_UTIL_PKG;

--CAS
CREATE OR REPLACE SYNONYM CAS_EXT_AUTH_PKG FOR CAS.CAS_EXT_AUTH_PKG;


--synonyms for CCD data schema objects
CREATE OR REPLACE SYNONYM CCD_STD_SVY_NAMES FOR CEN_CRUISE.CCD_STD_SVY_NAMES;
CREATE OR REPLACE SYNONYM CCD_TGT_SPP_MMPA FOR CEN_CRUISE.CCD_TGT_SPP_MMPA;
CREATE OR REPLACE SYNONYM CCD_EXP_SPP_CATS FOR CEN_CRUISE.CCD_EXP_SPP_CATS;
CREATE OR REPLACE SYNONYM CCD_GEAR_PRE FOR CEN_CRUISE.CCD_GEAR_PRE;
CREATE OR REPLACE SYNONYM CCD_SPP_ESA_PRE_OPTS FOR CEN_CRUISE.CCD_SPP_ESA_PRE_OPTS;
CREATE OR REPLACE SYNONYM CCD_SPP_MMPA_PRE_OPTS FOR CEN_CRUISE.CCD_SPP_MMPA_PRE_OPTS;
CREATE OR REPLACE SYNONYM CCD_SPP_CAT_PRE_OPTS FOR CEN_CRUISE.CCD_SPP_CAT_PRE_OPTS;
CREATE OR REPLACE SYNONYM CCD_GEAR_PRE_V FOR CEN_CRUISE.CCD_GEAR_PRE_V;
CREATE OR REPLACE SYNONYM CCD_SPP_CAT_PRE_DELIM_V FOR CEN_CRUISE.CCD_SPP_CAT_PRE_DELIM_V;
CREATE OR REPLACE SYNONYM DVM_ISS_SEVERITY FOR CEN_CRUISE.DVM_ISS_SEVERITY;
CREATE OR REPLACE SYNONYM CCD_TGT_SPP_OTHER FOR CEN_CRUISE.CCD_TGT_SPP_OTHER;
CREATE OR REPLACE SYNONYM CCD_CRUISE_LEG_DELIM_V FOR CEN_CRUISE.CCD_CRUISE_LEG_DELIM_V;
CREATE OR REPLACE SYNONYM CCD_LEG_V FOR CEN_CRUISE.CCD_LEG_V;
CREATE OR REPLACE SYNONYM CCD_SPP_CAT_PRE_V FOR CEN_CRUISE.CCD_SPP_CAT_PRE_V;
CREATE OR REPLACE SYNONYM CCD_SPP_MMPA_PRE_DELIM_V FOR CEN_CRUISE.CCD_SPP_MMPA_PRE_DELIM_V;
CREATE OR REPLACE SYNONYM CCD_GEAR_PRE_DELIM_V FOR CEN_CRUISE.CCD_GEAR_PRE_DELIM_V;
CREATE OR REPLACE SYNONYM CCD_LEG_ECOSYSTEMS FOR CEN_CRUISE.CCD_LEG_ECOSYSTEMS;
CREATE OR REPLACE SYNONYM CCD_SCI_CENTERS FOR CEN_CRUISE.CCD_SCI_CENTERS;
CREATE OR REPLACE SYNONYM CCD_SVY_FREQ FOR CEN_CRUISE.CCD_SVY_FREQ;
CREATE OR REPLACE SYNONYM CCD_TGT_SPP_ESA FOR CEN_CRUISE.CCD_TGT_SPP_ESA;
CREATE OR REPLACE SYNONYM CCD_REG_ECO_PRE_OPTS FOR CEN_CRUISE.CCD_REG_ECO_PRE_OPTS;
CREATE OR REPLACE SYNONYM CCD_DATA_SETS_V FOR CEN_CRUISE.CCD_DATA_SETS_V;
CREATE OR REPLACE SYNONYM CCD_REGION_PRE_V FOR CEN_CRUISE.CCD_REGION_PRE_V;
CREATE OR REPLACE SYNONYM CCD_SVY_CAT_PRE_DELIM_V FOR CEN_CRUISE.CCD_SVY_CAT_PRE_DELIM_V;
CREATE OR REPLACE SYNONYM DVM_ISS_TYPES FOR CEN_CRUISE.DVM_ISS_TYPES;
CREATE OR REPLACE SYNONYM CCD_VESSELS FOR CEN_CRUISE.CCD_VESSELS;
CREATE OR REPLACE SYNONYM CCD_REG_ECOSYSTEMS FOR CEN_CRUISE.CCD_REG_ECOSYSTEMS;
CREATE OR REPLACE SYNONYM CCD_LEG_ALIASES FOR CEN_CRUISE.CCD_LEG_ALIASES;
CREATE OR REPLACE SYNONYM CCD_LEG_REGIONS FOR CEN_CRUISE.CCD_LEG_REGIONS;
CREATE OR REPLACE SYNONYM CCD_SCI_CENTER_DIVS FOR CEN_CRUISE.CCD_SCI_CENTER_DIVS;
CREATE OR REPLACE SYNONYM CCD_REGION_PRE FOR CEN_CRUISE.CCD_REGION_PRE;
CREATE OR REPLACE SYNONYM DVM_ISSUES FOR CEN_CRUISE.DVM_ISSUES;
CREATE OR REPLACE SYNONYM CCD_CRUISE_LEG_V FOR CEN_CRUISE.CCD_CRUISE_LEG_V;
CREATE OR REPLACE SYNONYM CCD_REGION_PRE_DELIM_V FOR CEN_CRUISE.CCD_REGION_PRE_DELIM_V;
CREATE OR REPLACE SYNONYM CCD_QC_LEG_OVERLAP_V FOR CEN_CRUISE.CCD_QC_LEG_OVERLAP_V;
CREATE OR REPLACE SYNONYM DB_LOG_PKG FOR CEN_CRUISE.DB_LOG_PKG;
CREATE OR REPLACE SYNONYM DVM_PKG FOR CEN_CRUISE.DVM_PKG;
CREATE OR REPLACE SYNONYM CCD_REGIONS FOR CEN_CRUISE.CCD_REGIONS;
CREATE OR REPLACE SYNONYM CCD_CRUISE_SPP_FSSI FOR CEN_CRUISE.CCD_CRUISE_SPP_FSSI;
CREATE OR REPLACE SYNONYM CCD_SVY_CATS FOR CEN_CRUISE.CCD_SVY_CATS;
CREATE OR REPLACE SYNONYM CCD_SPP_FSSI_PRE FOR CEN_CRUISE.CCD_SPP_FSSI_PRE;
CREATE OR REPLACE SYNONYM CCD_SPP_FSSI_PRE_OPTS FOR CEN_CRUISE.CCD_SPP_FSSI_PRE_OPTS;
CREATE OR REPLACE SYNONYM AUTH_APP_USER_GROUPS_V FOR CEN_CRUISE.AUTH_APP_USER_GROUPS_V;
CREATE OR REPLACE SYNONYM CCD_REG_ECO_PRE_V FOR CEN_CRUISE.CCD_REG_ECO_PRE_V;
CREATE OR REPLACE SYNONYM CCD_SVY_CAT_PRE_V FOR CEN_CRUISE.CCD_SVY_CAT_PRE_V;
CREATE OR REPLACE SYNONYM CCD_CRUISE_ISS_SUMM_V FOR CEN_CRUISE.CCD_CRUISE_ISS_SUMM_V;
CREATE OR REPLACE SYNONYM CCD_CRUISES FOR CEN_CRUISE.CCD_CRUISES;
CREATE OR REPLACE SYNONYM CCD_CRUISE_LEGS FOR CEN_CRUISE.CCD_CRUISE_LEGS;
CREATE OR REPLACE SYNONYM CCD_LEG_GEAR FOR CEN_CRUISE.CCD_LEG_GEAR;
CREATE OR REPLACE SYNONYM CCD_CRUISE_EXP_SPP FOR CEN_CRUISE.CCD_CRUISE_EXP_SPP;
CREATE OR REPLACE SYNONYM CCD_CRUISE_SPP_MMPA FOR CEN_CRUISE.CCD_CRUISE_SPP_MMPA;
CREATE OR REPLACE SYNONYM CCD_GEAR_PRE_OPTS FOR CEN_CRUISE.CCD_GEAR_PRE_OPTS;
CREATE OR REPLACE SYNONYM CCD_SVY_CAT_PRE FOR CEN_CRUISE.CCD_SVY_CAT_PRE;
CREATE OR REPLACE SYNONYM DVM_ISS_TYP_ASSOC FOR CEN_CRUISE.DVM_ISS_TYP_ASSOC;
CREATE OR REPLACE SYNONYM DVM_PTA_ISSUES FOR CEN_CRUISE.DVM_PTA_ISSUES;
CREATE OR REPLACE SYNONYM AUTH_APP_USERS_V FOR CEN_CRUISE.AUTH_APP_USERS_V;
CREATE OR REPLACE SYNONYM CCD_CRUISE_SUMM_V FOR CEN_CRUISE.CCD_CRUISE_SUMM_V;
CREATE OR REPLACE SYNONYM CCD_CRUISE_V FOR CEN_CRUISE.CCD_CRUISE_V;
CREATE OR REPLACE SYNONYM CCD_CRUISE_AGG_V FOR CEN_CRUISE.CCD_CRUISE_AGG_V;
CREATE OR REPLACE SYNONYM CCD_SPP_ESA_PRE_V FOR CEN_CRUISE.CCD_SPP_ESA_PRE_V;
CREATE OR REPLACE SYNONYM CCD_SPP_MMPA_PRE_V FOR CEN_CRUISE.CCD_SPP_MMPA_PRE_V;
CREATE OR REPLACE SYNONYM CCD_SPP_ESA_PRE_DELIM_V FOR CEN_CRUISE.CCD_SPP_ESA_PRE_DELIM_V;
CREATE OR REPLACE SYNONYM DVM_ISS_RES_TYPES FOR CEN_CRUISE.DVM_ISS_RES_TYPES;
CREATE OR REPLACE SYNONYM CCD_CRUISE_PKG FOR CEN_CRUISE.CCD_CRUISE_PKG;
CREATE OR REPLACE SYNONYM CCD_DVM_PKG FOR CEN_CRUISE.CCD_DVM_PKG;
CREATE OR REPLACE SYNONYM CCD_PLAT_TYPES FOR CEN_CRUISE.CCD_PLAT_TYPES;
CREATE OR REPLACE SYNONYM CCD_SVY_TYPES FOR CEN_CRUISE.CCD_SVY_TYPES;
CREATE OR REPLACE SYNONYM CCD_REG_ECO_PRE FOR CEN_CRUISE.CCD_REG_ECO_PRE;
CREATE OR REPLACE SYNONYM CCD_SVY_CAT_PRE_OPTS FOR CEN_CRUISE.CCD_SVY_CAT_PRE_OPTS;
CREATE OR REPLACE SYNONYM CCD_SPP_ESA_PRE FOR CEN_CRUISE.CCD_SPP_ESA_PRE;
CREATE OR REPLACE SYNONYM CCD_SPP_CAT_PRE FOR CEN_CRUISE.CCD_SPP_CAT_PRE;
CREATE OR REPLACE SYNONYM CCD_LEG_DELIM_V FOR CEN_CRUISE.CCD_LEG_DELIM_V;
CREATE OR REPLACE SYNONYM CCD_SPP_FSSI_PRE_V FOR CEN_CRUISE.CCD_SPP_FSSI_PRE_V;
CREATE OR REPLACE SYNONYM CCD_REG_ECO_PRE_DELIM_V FOR CEN_CRUISE.CCD_REG_ECO_PRE_DELIM_V;
CREATE OR REPLACE SYNONYM CCD_SCI_CENTER_DIV_V FOR CEN_CRUISE.CCD_SCI_CENTER_DIV_V;
CREATE OR REPLACE SYNONYM CCD_CRUISE_SUMM_ISS_V FOR CEN_CRUISE.CCD_CRUISE_SUMM_ISS_V;
CREATE OR REPLACE SYNONYM CCD_GEAR FOR CEN_CRUISE.CCD_GEAR;
CREATE OR REPLACE SYNONYM CCD_CRUISE_SPP_ESA FOR CEN_CRUISE.CCD_CRUISE_SPP_ESA;
CREATE OR REPLACE SYNONYM CCD_CRUISE_SVY_CATS FOR CEN_CRUISE.CCD_CRUISE_SVY_CATS;
CREATE OR REPLACE SYNONYM CCD_TGT_SPP_FSSI FOR CEN_CRUISE.CCD_TGT_SPP_FSSI;
CREATE OR REPLACE SYNONYM CCD_REGION_PRE_OPTS FOR CEN_CRUISE.CCD_REGION_PRE_OPTS;
CREATE OR REPLACE SYNONYM CCD_SPP_MMPA_PRE FOR CEN_CRUISE.CCD_SPP_MMPA_PRE;
CREATE OR REPLACE SYNONYM CCD_CRUISE_DELIM_V FOR CEN_CRUISE.CCD_CRUISE_DELIM_V;
CREATE OR REPLACE SYNONYM CCD_SPP_FSSI_PRE_DELIM_V FOR CEN_CRUISE.CCD_SPP_FSSI_PRE_DELIM_V;
CREATE OR REPLACE SYNONYM CCD_SCI_CENTER_DELIM_V FOR CEN_CRUISE.CCD_SCI_CENTER_DELIM_V;
CREATE OR REPLACE SYNONYM DVM_PTA_ISSUES_V FOR CEN_CRUISE.DVM_PTA_ISSUES_V;
CREATE OR REPLACE SYNONYM CUST_ERR_PKG FOR CEN_CRUISE.CUST_ERR_PKG;
CREATE OR REPLACE SYNONYM AUTH_APP_PKG FOR CEN_CRUISE.AUTH_APP_PKG;





CREATE OR REPLACE SYNONYM CCD_LEG_DATA_SETS FOR CEN_CRUISE.CCD_LEG_DATA_SETS;
CREATE OR REPLACE SYNONYM CCD_DATA_SETS FOR CEN_CRUISE.CCD_DATA_SETS;
CREATE OR REPLACE SYNONYM CCD_DATA_SET_STATUS FOR CEN_CRUISE.CCD_DATA_SET_STATUS;
CREATE OR REPLACE SYNONYM CCD_DATA_SET_TYPES FOR CEN_CRUISE.CCD_DATA_SET_TYPES;












CREATE OR REPLACE SYNONYM AFF_RESP_TYPES FOR CEN_CRUISE.AFF_RESP_TYPES;
CREATE OR REPLACE SYNONYM AFF_RESPONSES FOR CEN_CRUISE.AFF_RESPONSES;
CREATE OR REPLACE SYNONYM AFF_RESPONSES_V FOR CEN_CRUISE.AFF_RESPONSES_V;




--authorization application module pages:
CREATE OR REPLACE SYNONYM AUTH_APP_USERS_V FOR CEN_CRUISE.AUTH_APP_USERS_V;
CREATE OR REPLACE SYNONYM AUTH_APP_USER_GROUPS_V FOR CEN_CRUISE.AUTH_APP_USER_GROUPS_V;


CREATE OR REPLACE SYNONYM AUTH_APP_USERS FOR CEN_CRUISE.AUTH_APP_USERS;
CREATE OR REPLACE SYNONYM AUTH_APP_USER_GROUPS FOR CEN_CRUISE.AUTH_APP_USER_GROUPS;
CREATE OR REPLACE SYNONYM AUTH_APP_GROUPS FOR CEN_CRUISE.AUTH_APP_GROUPS;


CREATE OR REPLACE SYNONYM CC_CONFIG_OPTIONS FOR CEN_CRUISE.CC_CONFIG_OPTIONS;

