--run this from the DSC schema:
grant execute on DSC.DSC_CRE_HIST_OBJS_PKG to CEN_CRUISE;
grant execute on DSC.DSC_UTILITIES_PKG to CEN_CRUISE;


--run this for the CEN_UTILS schema:
grant CEN_UTILS_ROLE TO CEN_CRUISE;
grant execute on CEN_UTILS.CEN_UTIL_PKG to CEN_CRUISE with grant option;
grant execute on CEN_UTILS.CEN_UTIL_ARRAY_PKG to CEN_CRUISE with grant option;


--run this for the PICDM schema
grant PICDM_INTEG_ROLE TO CEN_CRUISE;
grant references on ODS_INP_DATASET_SCORING to CEN_CRUISE;
