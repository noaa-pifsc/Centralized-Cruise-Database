select CRUISE_FISC_YEAR, STD_SVY_NAME_VAL, count(*) num_cruises, sum(num_legs) num_legs, sum(CRUISE_DAS) total_das
from
CEN_CRUISE.CCD_CRUISE_V
WHERE CRUISE_FISC_YEAR IS NOT NULL
group by 
CRUISE_FISC_YEAR,
STD_SVY_NAME_VAL
order by CRUISE_FISC_YEAR, STD_SVY_NAME_VAL;


select CRUISE_FISC_YEAR, count(*) num_cruises, sum(num_legs) num_legs, sum(CRUISE_DAS) total_das
from
CEN_CRUISE.CCD_CRUISE_V
WHERE CRUISE_FISC_YEAR IS NOT NULL
group by 
CRUISE_FISC_YEAR
order by CRUISE_FISC_YEAR;




select STD_SVY_NAME_VAL, count(*) num_cruises, sum(num_legs) num_legs, sum(CRUISE_DAS) total_das
from
CEN_CRUISE.CCD_CRUISE_V
WHERE CRUISE_FISC_YEAR IS NOT NULL
group by 
STD_SVY_NAME_VAL
order by UPPER(STD_SVY_NAME_VAL);








