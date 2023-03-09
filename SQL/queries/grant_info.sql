--run this from the DSC schema:

grant execute on DSC.DSC_CRE_HIST_OBJS_PKG to CEN_CRUISE;
grant execute on DSC.DSC_UTILITIES_PKG to CEN_CRUISE;

--run this from the CEN_UTILS schema:
grant execute on CEN_UTILS.CEN_UTIL_PKG to CEN_CRUISE with grant option;
grant execute on CEN_UTILS.CEN_UTIL_ARRAY_PKG to CEN_CRUISE with grant option;

grant execute on CEN_UTILS.CEN_UTIL_PKG to CEN_CRUISE_APP;

