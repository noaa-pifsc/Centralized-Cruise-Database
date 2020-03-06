--run this from the DSC schema:

grant execute on DSC_CRE_HIST_OBJS_PKG to CEN_CRUISE;
grant execute on DSC_UTILITIES_PKG to CEN_CRUISE;

--run this from the CEN_UTILS schema:
grant execute on CEN_UTIL_PKG to CEN_CRUISE with grant option;


