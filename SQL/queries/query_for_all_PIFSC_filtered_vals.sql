--query to retrieve all of the ESA target species associated with a preset or a cruise
select CCD_TGT_SPP_ESA.TGT_SPP_ESA_ID, TGT_SPP_ESA_NAME, FINSS_ID
FROM
CCD_TGT_SPP_ESA inner join
(select distinct TGT_SPP_ESA_ID from CCD_CRUISE_SPP_ESA
UNION select distinct TGT_SPP_ESA_ID from CCD_SPP_ESA_PRE_OPTS)
DIST_IDS
on CCD_TGT_SPP_ESA.TGT_SPP_ESA_ID = DIST_IDS.TGT_SPP_ESA_ID

order by TGT_SPP_ESA_ID;


--query to retrieve all of the MMPA target species associated with a preset or a cruise
select CCD_TGT_SPP_MMPA.TGT_SPP_MMPA_ID, TGT_SPP_MMPA_NAME, FINSS_ID
FROM
CCD_TGT_SPP_MMPA inner join
(select distinct TGT_SPP_MMPA_ID from CCD_CRUISE_SPP_MMPA
UNION select distinct TGT_SPP_MMPA_ID from CCD_SPP_MMPA_PRE_OPTS)
DIST_IDS
on CCD_TGT_SPP_MMPA.TGT_SPP_MMPA_ID = DIST_IDS.TGT_SPP_MMPA_ID

order by TGT_SPP_MMPA_ID;


--query to retrieve all of the FSSI target species associated with a preset or a cruise
select CCD_TGT_SPP_FSSI.TGT_SPP_FSSI_ID, TGT_SPP_FSSI_NAME, FINSS_ID
FROM
CCD_TGT_SPP_FSSI inner join
(select distinct TGT_SPP_FSSI_ID from CCD_CRUISE_SPP_FSSI
UNION select distinct TGT_SPP_FSSI_ID from CCD_SPP_FSSI_PRE_OPTS)
DIST_IDS
on CCD_TGT_SPP_FSSI.TGT_SPP_FSSI_ID = DIST_IDS.TGT_SPP_FSSI_ID

order by TGT_SPP_FSSI_ID;



--query to retrieve all of the expected species categories associated with a preset or a cruise
select CCD_EXP_SPP_CATS.EXP_SPP_CAT_ID, EXP_SPP_CAT_NAME, FINSS_ID
FROM
CCD_EXP_SPP_CATS inner join
(select distinct EXP_SPP_CAT_ID from CCD_CRUISE_EXP_SPP
UNION select distinct EXP_SPP_CAT_ID from CCD_SPP_CAT_PRE_OPTS)
DIST_IDS
on CCD_EXP_SPP_CATS.EXP_SPP_CAT_ID = DIST_IDS.EXP_SPP_CAT_ID

order by EXP_SPP_CAT_ID;





--query to retrieve all of the gear associated with a preset or a cruise leg
select CCD_GEAR.GEAR_ID, GEAR_NAME, FINSS_ID
FROM
CCD_GEAR inner join
(select distinct GEAR_ID from CCD_LEG_GEAR
UNION select distinct GEAR_ID from CCD_GEAR_PRE_OPTS)
DIST_IDS
on CCD_GEAR.GEAR_ID = DIST_IDS.GEAR_ID

order by GEAR_ID;



--query to retrieve all of the regional ecosystems associated with a preset or a cruise leg
select CCD_REG_ECOSYSTEMS.REG_ECOSYSTEM_ID, REG_ECOSYSTEM_NAME, FINSS_ID
FROM
CCD_REG_ECOSYSTEMS inner join
(select distinct REG_ECOSYSTEM_ID from CCD_LEG_ECOSYSTEMS
UNION select distinct REG_ECOSYSTEM_ID from CCD_REG_ECO_PRE_OPTS)
DIST_IDS
on CCD_REG_ECOSYSTEMS.REG_ECOSYSTEM_ID = DIST_IDS.REG_ECOSYSTEM_ID

order by CCD_REG_ECOSYSTEMS.REG_ECOSYSTEM_ID;





--query to retrieve all of the expected species categories associated with a preset or a cruise
select CCD_SVY_CATS.SVY_CAT_ID, SVY_CAT_NAME, FINSS_ID
FROM
CCD_SVY_CATS inner join
(select distinct SVY_CAT_ID from CCD_CRUISE_SVY_CATS
UNION select distinct SVY_CAT_ID from CCD_SVY_CAT_PRE_OPTS)
DIST_IDS
on CCD_SVY_CATS.SVY_CAT_ID = DIST_IDS.SVY_CAT_ID

order by SVY_CAT_ID;



--query for all standard survey names:
select
STD_SVY_NAME_ID,
STD_SVY_NAME,
FINSS_ID
from
ccd_std_svy_names
where std_svy_name_id in (select distinct std_svy_name_id from ccd_cruises)
order by upper(STD_SVY_NAME);

--query for all vessels:
select vessel_id, vessel_name, finss_id from ccd_vessels
where vessel_id in (select distinct vessel_id from ccd_cruise_legs)
order by UPPER(vessel_name);
