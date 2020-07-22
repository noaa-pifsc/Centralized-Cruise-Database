update CCD_CRUISES SET CRUISE_NAME = 'HI-10-07' WHERE CRUISE_NAME = 'HA1007';


update CCD_CRUISES SET CRUISE_NAME = 'HI-10-09' WHERE CRUISE_NAME = 'HA1007 (copy)';

update CCD_CRUISES SET CRUISE_NAME = 'HI-04-01' WHERE CRUISE_NAME = 'HI0401';

update ccd_cruise_legs set leg_name = 'HI0610' where leg_name = 'HI0610 (copy)';

insert into ccd_leg_gear (cruise_leg_id, gear_id) VALUES ((select cruise_leg_id from ccd_cruise_legs where leg_name = 'HI0610'), (select gear_id from ccd_gear where gear_name = 'SCUBA'));


update ccd_cruise_legs set leg_start_date = TO_DATE('01-JUN-10', 'DD-MON-YY'), leg_end_date = TO_DATE('13-JUN-10', 'DD-MON-YY') where leg_name = 'HI1001_LEGI';
update ccd_cruise_legs set leg_start_date = TO_DATE('15-JUN-10', 'DD-MON-YY'), leg_end_date = TO_DATE('03-JUL-10', 'DD-MON-YY') where leg_name = 'HI1001_LEGII';


update ccd_cruise_legs set leg_end_date = TO_DATE('10-JUN-11', 'DD-MON-YY') where leg_name = 'HA1101_LEG_III';


update CCD_CRUISES SET CRUISE_NAME = 'SE-04-11' WHERE CRUISE_NAME = 'OES0411';


update CCD_CRUISES SET CRUISE_NAME = 'SE-05-09' WHERE CRUISE_NAME = 'OES0509';



insert into ccd_leg_gear (cruise_leg_id, gear_id) VALUES ((select cruise_leg_id from ccd_cruise_legs where leg_name = 'RL-17-05 Leg 4'), (select gear_id from ccd_gear where gear_name = 'AUV'));


insert into ccd_cruise_svy_cats (CRUISE_ID, SVY_CAT_ID, PRIMARY_YN) VALUES ((select cruise_id from ccd_cruises where cruise_name = 'RL-17-05'), (SELECT SVY_CAT_ID FROM CCD_SVY_CATS where SVY_CAT_NAME = 'Habitat Monitoring and Assessment'), 'Y');


update ccd_cruise_legs set leg_start_date = TO_DATE('15-APR-15', 'DD-MON-YY') WHERE leg_name = 'SE-15-01 Leg 2';


update ccd_cruise_legs set leg_start_date = TO_DATE('01-OCT-02', 'DD-MON-YY') WHERE leg_name = 'TC-03-07';

update ccd_cruise_legs set leg_start_date = TO_DATE('20-FEB-02', 'DD-MON-YY'), leg_end_date = TO_DATE('10-MAR-02', 'DD-MON-YY') WHERE leg_name = 'TC0201_LEGII';
