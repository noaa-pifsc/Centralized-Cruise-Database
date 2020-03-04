 delete from ccd_data_sets;
 delete from ccd_data_set_types;
 delete from ccd_data_set_status;
 
 

delete from ccd_leg_regions;
delete from ccd_regions;


delete from ccd_leg_ecosystems;
delete from ccd_reg_ecosystems;

delete from ccd_leg_gear;
delete from ccd_gear;

/*delete from ;
delete from ;
delete from ;
delete from ;
delete from ;
delete from ;
delete from ;
delete from ;
delete from ;
delete from ;
*/

delete from ccd_leg_aliases;








delete from ccd_cruise_legs;


delete from ccd_cruises;
delete from ccd_vessels;



@@"./load_ref_data.sql"


@@"./load_data_set_info.sql"

