set define off;

/*

delete from ccd_leg_regions;
delete from ccd_leg_aliases;
delete from ccd_cruise_legs;
delete from ccd_regions;


delete from ccd_cruises;
delete from ccd_vessels;



*/

--data set statuses
insert into ccd_data_set_status (STATUS_CODE, STATUS_NAME, STATUS_DESC, STATUS_COLOR) values ('COL', 'Data Collection', 'Data is being collected', '#e76e3c');
insert into ccd_data_set_status (STATUS_CODE, STATUS_NAME, STATUS_DESC, STATUS_COLOR) values ('PR', 'Data Processing', 'Data has been collected and the data is currently being processed', '#4b6a88');
insert into ccd_data_set_status (STATUS_CODE, STATUS_NAME, STATUS_DESC, STATUS_COLOR) values ('QC', 'Quality Control', 'Data has been processed and data quality control is currently being evaluated and issues are being resolved and/or annotated', '#0000e0');
insert into ccd_data_set_status (STATUS_CODE, STATUS_NAME, STATUS_DESC, STATUS_COLOR) values ('IA', 'Internally Accessible', 'Data has been quality controlled and it is currently internally accessible', '#1e90ff');
insert into ccd_data_set_status (STATUS_CODE, STATUS_NAME, STATUS_DESC, STATUS_COLOR) values ('PA', 'Publicly Accessible', 'Data has been quality controlled and it is currently publicly accessible', '#005555');
insert into ccd_data_set_status (STATUS_CODE, STATUS_NAME, STATUS_DESC, STATUS_COLOR) values ('ARCH', 'Archived', 'Data has been quality controlled and it is currently archived', '#00aa00');


--data set types
INSERT INTO CCD_data_set_types (data_set_type_name, data_set_type_desc, data_set_type_doc_url) values ('MOUSS Video', 'Modular Optical Underwater Survey System', 'https://inport.nmfs.noaa.gov/inport/item/51818');
INSERT INTO CCD_data_set_types (data_set_type_name, data_set_type_desc, data_set_type_doc_url) values ('CTD', 'Conductivity, Temperature, and Depth', 'https://inport.nmfs.noaa.gov/inport/item/7602');
INSERT INTO CCD_data_set_types (data_set_type_name, data_set_type_desc, data_set_type_doc_url) values ('Water Samples', 'Discrete Water Samples', '');
INSERT INTO CCD_data_set_types (data_set_type_name, data_set_type_desc, data_set_type_doc_url) values ('Coral Belt', 'Belt Transect Survey', '');
INSERT INTO CCD_data_set_types (data_set_type_name, data_set_type_desc, data_set_type_doc_url) values ('Fish REA', 'Fish Rapid Ecological Assessment Survey', 'https://inport.nmfs.noaa.gov/inport/item/5565');
INSERT INTO CCD_data_set_types (data_set_type_name, data_set_type_desc, data_set_type_doc_url) values ('ARMS', 'Autonomous Reef Monitoring System', 'https://inport.nmfs.noaa.gov/inport/item/36038');
INSERT INTO CCD_data_set_types (data_set_type_name, data_set_type_desc, data_set_type_doc_url) values ('Fish Towed Diver', 'Fish Towed Diver Survey', 'https://inport.nmfs.noaa.gov/inport/item/34521');
INSERT INTO CCD_data_set_types (data_set_type_name, data_set_type_desc, data_set_type_doc_url) values ('Benthic Towed Diver', 'Benthic Towed Diver Survey', 'https://inport.nmfs.noaa.gov/inport/item/35618');
INSERT INTO CCD_data_set_types (data_set_type_name, data_set_type_desc, data_set_type_doc_url) values ('CAU', 'Calcification Accretion Units', 'https://inport.nmfs.noaa.gov/inport/item/26945');
INSERT INTO CCD_data_set_types (data_set_type_name, data_set_type_desc, data_set_type_doc_url) values ('Midwater Trawling', 'Midwater Trawling Survey', '');
INSERT INTO CCD_data_set_types (data_set_type_name, data_set_type_desc, data_set_type_doc_url) values ('Active Acoustics', 'Active Acoustics Survey', '');




--data sets
insert into ccd_data_sets (DATA_SET_NAME, DATA_SET_DESC, DATA_SET_TYPE_ID, DATA_SET_INPORT_CAT_ID, DATA_SET_STATUS_ID) values ('1999 CTD Data', '', (SELECT DATA_SET_TYPE_ID FROM CCD_DATA_SET_TYPES WHERE DATA_SET_TYPE_NAME = 'CTD'), '', (SELECT DATA_SET_STATUS_ID FROM CCD_DATA_SET_STATUS where status_code = 'ARCH'));
insert into ccd_data_sets (DATA_SET_NAME, DATA_SET_DESC, DATA_SET_TYPE_ID, DATA_SET_INPORT_CAT_ID, DATA_SET_STATUS_ID) values ('2009 CTD Data', '', (SELECT DATA_SET_TYPE_ID FROM CCD_DATA_SET_TYPES WHERE DATA_SET_TYPE_NAME = 'CTD'), '', (SELECT DATA_SET_STATUS_ID FROM CCD_DATA_SET_STATUS where status_code = 'QC'));
insert into ccd_data_sets (DATA_SET_NAME, DATA_SET_DESC, DATA_SET_TYPE_ID, DATA_SET_INPORT_CAT_ID, DATA_SET_STATUS_ID) values ('2017 CTD Data', '', (SELECT DATA_SET_TYPE_ID FROM CCD_DATA_SET_TYPES WHERE DATA_SET_TYPE_NAME = 'CTD'), '', (SELECT DATA_SET_STATUS_ID FROM CCD_DATA_SET_STATUS where status_code = 'ARCH'));






insert into ccd_regions (REGION_CODE, REGION_NAME, REGION_DESC) values ('PRIA', 'Pacific Remote Island Areas', '');
insert into ccd_regions (REGION_CODE, REGION_NAME, REGION_DESC) values ('AMSM', 'American Samoa', '');
insert into ccd_regions (REGION_CODE, REGION_NAME, REGION_DESC) values ('MHI', 'Main Hawaiian Islands', '');
insert into ccd_regions (REGION_CODE, REGION_NAME, REGION_DESC) values ('CNMI', 'Commonwealth of the Northern Mariana Islands', '');
insert into ccd_regions (REGION_CODE, REGION_NAME, REGION_DESC) values ('NWHI', 'Northwest Hawaiian Islands', '');
insert into ccd_regions (REGION_CODE, REGION_NAME, REGION_DESC) values ('NPSF', 'North Pacific Subtropical Front', '');





INSERT INTO CCD_PLAT_TYPES (PLAT_TYPE_NAME, FINSS_ID) VALUES ('Chartered Vessel', 3);
INSERT INTO CCD_PLAT_TYPES (PLAT_TYPE_NAME, FINSS_ID) VALUES ('Fishery Survey Vessel (FSV)', 5);
INSERT INTO CCD_PLAT_TYPES (PLAT_TYPE_NAME, FINSS_ID) VALUES ('Hydrographic RV', 2);
INSERT INTO CCD_PLAT_TYPES (PLAT_TYPE_NAME, FINSS_ID) VALUES ('Oceanographic RV', 4);
INSERT INTO CCD_PLAT_TYPES (PLAT_TYPE_NAME, FINSS_ID) VALUES ('Program Small Boat (i.e. NMFS science center owned small boat)', 7);
INSERT INTO CCD_PLAT_TYPES (PLAT_TYPE_NAME, FINSS_ID) VALUES ('State Owned Boat', 1);
INSERT INTO CCD_PLAT_TYPES (PLAT_TYPE_NAME, FINSS_ID) VALUES ('UNOLS (University National Oceanographic Laboratory System) Fleet', 6);


--regional ecosystems:
INSERT INTO CCD_REG_ECOSYSTEMS (REG_ECOSYSTEM_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('Alaska Ecosystem Complex', 1, 'N');
INSERT INTO CCD_REG_ECOSYSTEMS (REG_ECOSYSTEM_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('Antarctica', 2, 'N');
INSERT INTO CCD_REG_ECOSYSTEMS (REG_ECOSYSTEM_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('California Current', 8, 'N');
INSERT INTO CCD_REG_ECOSYSTEMS (REG_ECOSYSTEM_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('Caribbean Sea', 9, 'N');
INSERT INTO CCD_REG_ECOSYSTEMS (REG_ECOSYSTEM_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('Eastern Tropical Pacific', 10, 'Y');
INSERT INTO CCD_REG_ECOSYSTEMS (REG_ECOSYSTEM_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('Great Lakes', 5, 'N');
INSERT INTO CCD_REG_ECOSYSTEMS (REG_ECOSYSTEM_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('Gulf of California', 11, 'N');
INSERT INTO CCD_REG_ECOSYSTEMS (REG_ECOSYSTEM_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('Gulf of Mexico', 6, 'N');
INSERT INTO CCD_REG_ECOSYSTEMS (REG_ECOSYSTEM_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('Northeast Shelf', 3, 'Y');
INSERT INTO CCD_REG_ECOSYSTEMS (REG_ECOSYSTEM_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('Pacific Islands Ecosystem Complex', 4, 'Y');
INSERT INTO CCD_REG_ECOSYSTEMS (REG_ECOSYSTEM_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('Southeast Shelf', 7, 'N');










--gear:
INSERT INTO CCD_GEAR (GEAR_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('3 Bridle 4 Seam', 140, 'N');
INSERT INTO CCD_GEAR (GEAR_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('3 Bridle 4 Seam: Flat Sweep', 142, 'N');
INSERT INTO CCD_GEAR (GEAR_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('3 Bridle 4 Seam: Rockhopper Sweep', 141, 'N');
INSERT INTO CCD_GEAR (GEAR_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('36 Yankee Trawl', 47, 'N');
INSERT INTO CCD_GEAR (GEAR_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('Acoustic Backscatter', 1, 'N');
INSERT INTO CCD_GEAR (GEAR_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('Acoustic Recorders', 105, 'N');
INSERT INTO CCD_GEAR (GEAR_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('ADCP', 48, 'N');
INSERT INTO CCD_GEAR (GEAR_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('Aluetian Wing Trawl', 204, 'N');
INSERT INTO CCD_GEAR (GEAR_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('Autonomous Reef Monitoring Structure (ARMS)', 49, 'Y');
INSERT INTO CCD_GEAR (GEAR_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('AUV', 2, 'Y');
INSERT INTO CCD_GEAR (GEAR_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('Bag Seine', 182, 'N');
INSERT INTO CCD_GEAR (GEAR_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('Beach Seine', 51, 'N');
INSERT INTO CCD_GEAR (GEAR_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('Binoculars', 52, 'Y');
INSERT INTO CCD_GEAR (GEAR_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('Bioacoustics', 53, 'N');
INSERT INTO CCD_GEAR (GEAR_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('Biopsy', 54, 'Y');
INSERT INTO CCD_GEAR (GEAR_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('BONGO', 3, 'N');
INSERT INTO CCD_GEAR (GEAR_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('BotCam (baited camera stations)', 55, 'Y');
INSERT INTO CCD_GEAR (GEAR_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('Bottom Longline', 186, 'N');
INSERT INTO CCD_GEAR (GEAR_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('Bottom Trawl', 4, 'N');
INSERT INTO CCD_GEAR (GEAR_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('BRUVs (baited camera stations)', 50, 'N');
INSERT INTO CCD_GEAR (GEAR_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('Chevron Fish Trap', 56, 'N');
INSERT INTO CCD_GEAR (GEAR_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('Clam Dredge', 25, 'N');
INSERT INTO CCD_GEAR (GEAR_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('Commercial Shrimp Trawl', 57, 'N');
INSERT INTO CCD_GEAR (GEAR_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('Continuous Underwater Fish Egg Sampler (CUFES)', 101, 'N');
INSERT INTO CCD_GEAR (GEAR_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('CTD', 5, 'Y');
INSERT INTO CCD_GEAR (GEAR_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('DCIP', 207, 'Y');
INSERT INTO CCD_GEAR (GEAR_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('Digital Camera', 58, 'N');
INSERT INTO CCD_GEAR (GEAR_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('Drift Net', 103, 'N');
INSERT INTO CCD_GEAR (GEAR_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('Ecological Acoustic Recorder (EAR)', 60, 'N');
INSERT INTO CCD_GEAR (GEAR_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('eDNA', 208, 'N');
INSERT INTO CCD_GEAR (GEAR_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('EK-60 Echosounder', 59, 'N');
INSERT INTO CCD_GEAR (GEAR_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('Expendable Bathythermograph (XBT)', 120, 'N');
INSERT INTO CCD_GEAR (GEAR_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('Fish Traps', 61, 'N');
INSERT INTO CCD_GEAR (GEAR_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('Flat Sweep Trawl', 62, 'N');
INSERT INTO CCD_GEAR (GEAR_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('Fyke Net', 121, 'N');
INSERT INTO CCD_GEAR (GEAR_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('Gillnet', 63, 'N');
INSERT INTO CCD_GEAR (GEAR_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('Grab Sampler', 6, 'N');
INSERT INTO CCD_GEAR (GEAR_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('Haddock Gear Selectivity Net', 64, 'N');
INSERT INTO CCD_GEAR (GEAR_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('Handline', 65, 'Y');
INSERT INTO CCD_GEAR (GEAR_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('High-frequency Autonomous Acoustic Recording Package (HARP)', 66, 'Y');
INSERT INTO CCD_GEAR (GEAR_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('Hook and Line', 67, 'Y');
INSERT INTO CCD_GEAR (GEAR_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('Human Observation', 7, 'Y');
INSERT INTO CCD_GEAR (GEAR_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('Hydroacoustics', 68, 'N');
INSERT INTO CCD_GEAR (GEAR_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('IBS COD Trawl', 69, 'N');
INSERT INTO CCD_GEAR (GEAR_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('International Young Gadoid Pelagic Trawl', 70, 'N');
INSERT INTO CCD_GEAR (GEAR_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('Issacs-Kidd Trawl', 71, 'N');
INSERT INTO CCD_GEAR (GEAR_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('LADCP', 72, 'N');
INSERT INTO CCD_GEAR (GEAR_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('Laser Line Scan', 8, 'N');
INSERT INTO CCD_GEAR (GEAR_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('LIDAR', 9, 'N');
INSERT INTO CCD_GEAR (GEAR_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('Light', 73, 'N');
INSERT INTO CCD_GEAR (GEAR_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('Lobster Trap', 74, 'N');
INSERT INTO CCD_GEAR (GEAR_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('Lobster Trap (Fathoms Plus Style)', 75, 'N');
INSERT INTO CCD_GEAR (GEAR_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('Long bottom longline', 160, 'N');
INSERT INTO CCD_GEAR (GEAR_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('Longline', 10, 'N');
INSERT INTO CCD_GEAR (GEAR_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('MANTA', 11, 'N');
INSERT INTO CCD_GEAR (GEAR_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('Methot Trawl', 77, 'N');
INSERT INTO CCD_GEAR (GEAR_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('Mid-water Trawl', 12, 'N');
INSERT INTO CCD_GEAR (GEAR_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('MOCNES', 76, 'N');
INSERT INTO CCD_GEAR (GEAR_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('MOCNESS', 26, 'N');
INSERT INTO CCD_GEAR (GEAR_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('Modified Cobb', 203, 'N');
INSERT INTO CCD_GEAR (GEAR_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('Monkfish Net', 78, 'N');
INSERT INTO CCD_GEAR (GEAR_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('Moored Buoy', 13, 'N');
INSERT INTO CCD_GEAR (GEAR_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('MOUSS', 206, 'N');
INSERT INTO CCD_GEAR (GEAR_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('Multibeam', 14, 'N');
INSERT INTO CCD_GEAR (GEAR_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('NEUSTON', 79, 'N');
INSERT INTO CCD_GEAR (GEAR_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('Nordic 264 Trawl', 205, 'N');
INSERT INTO CCD_GEAR (GEAR_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('North Atlantic Type 2 Seam Whiting Trawl', 80, 'N');
INSERT INTO CCD_GEAR (GEAR_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('Oyster Dredge', 183, 'N');
INSERT INTO CCD_GEAR (GEAR_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('Pelagic Longline', 187, 'N');
INSERT INTO CCD_GEAR (GEAR_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('Photo-identification', 82, 'N');
INSERT INTO CCD_GEAR (GEAR_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('PIT Tags', 81, 'Y');
INSERT INTO CCD_GEAR (GEAR_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('Plankton Gear', 15, 'N');
INSERT INTO CCD_GEAR (GEAR_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('Purse Seine', 122, 'N');
INSERT INTO CCD_GEAR (GEAR_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('Rod and Reel', 83, 'N');
INSERT INTO CCD_GEAR (GEAR_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('ROV', 16, 'N');
INSERT INTO CCD_GEAR (GEAR_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('Satellite-tracked Drifters', 84, 'N');
INSERT INTO CCD_GEAR (GEAR_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('Scallop Dredge', 24, 'N');
INSERT INTO CCD_GEAR (GEAR_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('SCUBA', 17, 'Y');
INSERT INTO CCD_GEAR (GEAR_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('Seine', 85, 'N');
INSERT INTO CCD_GEAR (GEAR_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('Set Net', 104, 'N');
INSERT INTO CCD_GEAR (GEAR_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('Settlement Traps', 86, 'N');
INSERT INTO CCD_GEAR (GEAR_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('Short bottom longline', 161, 'N');
INSERT INTO CCD_GEAR (GEAR_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('Side Scan', 19, 'N');
INSERT INTO CCD_GEAR (GEAR_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('Single Beam', 18, 'N');
INSERT INTO CCD_GEAR (GEAR_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('Skimmer Trawl', 184, 'N');
INSERT INTO CCD_GEAR (GEAR_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('Snorkel/Free Dive', 209, 'Y');
INSERT INTO CCD_GEAR (GEAR_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('Sonar', 20, 'N');
INSERT INTO CCD_GEAR (GEAR_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('Surface Longline', 102, 'N');
INSERT INTO CCD_GEAR (GEAR_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('Surface Trawl', 21, 'N');
INSERT INTO CCD_GEAR (GEAR_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('Tags (satellite, acoustic and others)', 22, 'Y');
INSERT INTO CCD_GEAR (GEAR_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('Temp Logger', 87, 'N');
INSERT INTO CCD_GEAR (GEAR_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('Temperature Depth Recorders (TDRs)', 88, 'Y');
INSERT INTO CCD_GEAR (GEAR_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('Throw Trap', 188, 'N');
INSERT INTO CCD_GEAR (GEAR_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('Towboards', 89, 'N');
INSERT INTO CCD_GEAR (GEAR_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('Towed Hydrophone Array', 90, 'Y');
INSERT INTO CCD_GEAR (GEAR_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('Towed Optical Assessent Device (TOAD)', 91, 'N');
INSERT INTO CCD_GEAR (GEAR_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('Trammel Net', 181, 'N');
INSERT INTO CCD_GEAR (GEAR_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('Trawl', 92, 'Y');
INSERT INTO CCD_GEAR (GEAR_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('Troll', 202, 'N');
INSERT INTO CCD_GEAR (GEAR_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('Video Arrays', 23, 'N');
INSERT INTO CCD_GEAR (GEAR_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('Visual Census', 100, 'Y');
INSERT INTO CCD_GEAR (GEAR_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('Witham Collector', 185, 'N');
INSERT INTO CCD_GEAR (GEAR_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('Others', 27, 'Y');


--standard survey names:
INSERT INTO CCD_STD_SVY_NAMES (STD_SVY_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('Acoustical Environment of Three Stations at Riley''s Hump', 601, 'N');
INSERT INTO CCD_STD_SVY_NAMES (STD_SVY_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('Alaska Harbor Seal Ecology', 1773, 'N');
INSERT INTO CCD_STD_SVY_NAMES (STD_SVY_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('Alaska Integrated Seafloor Habitat Mapping', 1774, 'N');
INSERT INTO CCD_STD_SVY_NAMES (STD_SVY_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('Aleutian Island Groundfish Bottom Trawl', 11, 'N');
INSERT INTO CCD_STD_SVY_NAMES (STD_SVY_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('Aleutian Island Harbor Seal Ecology', 1416, 'N');
INSERT INTO CCD_STD_SVY_NAMES (STD_SVY_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('Aleutian Islands Deep Coral and Sponge Communities Mapping', 1401, 'N');
INSERT INTO CCD_STD_SVY_NAMES (STD_SVY_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('Aleutian Islands Steller Sea Lion Vital Rates Studies', 2122, 'N');
INSERT INTO CCD_STD_SVY_NAMES (STD_SVY_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('Aleutian Islands/Bering Sea Killer Whale', 12, 'N');
INSERT INTO CCD_STD_SVY_NAMES (STD_SVY_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('American Eel Fyke Net Survey (GADNR)', 949, 'N');
INSERT INTO CCD_STD_SVY_NAMES (STD_SVY_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('American Eel Fyke Net Survey (SCDNR)', 950, 'N');
INSERT INTO CCD_STD_SVY_NAMES (STD_SVY_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('American Samoa Cetacean and Ecosystem Assessment Survey', 1431, 'N');
INSERT INTO CCD_STD_SVY_NAMES (STD_SVY_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('American Samoa Insular Bottomfish Survey', 1425, 'N');
INSERT INTO CCD_STD_SVY_NAMES (STD_SVY_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('American Samoa Insular Reef Fish Survey', 769, 'N');
INSERT INTO CCD_STD_SVY_NAMES (STD_SVY_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('American Samoa Life History Bio-sampling', 2043, 'N');
INSERT INTO CCD_STD_SVY_NAMES (STD_SVY_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('American Samoa Ocean Acidification Process Cruise - National Coral Reef Conservation Program', 1984, 'N');
INSERT INTO CCD_STD_SVY_NAMES (STD_SVY_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('American Samoa Reef Assessment and Monitoring Program (ASRAMP) - National Coral Reef Monitoring Program (NCRMP)', 1422, 'N');
INSERT INTO CCD_STD_SVY_NAMES (STD_SVY_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('American Shad Drift Gillnet Survey (SCDRN)', 951, 'N');
INSERT INTO CCD_STD_SVY_NAMES (STD_SVY_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('Arctic Integrated Ecosystem Survey', 1088, 'N');
INSERT INTO CCD_STD_SVY_NAMES (STD_SVY_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('Arctic Whale Ecology Study (ARCWEST)', 2118, 'N');
INSERT INTO CCD_STD_SVY_NAMES (STD_SVY_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('Atlantic Herring Acoustic Survey', 1128, 'N');
INSERT INTO CCD_STD_SVY_NAMES (STD_SVY_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('Atlantic Herring Hydroacoustic_Fall', 1362, 'N');
INSERT INTO CCD_STD_SVY_NAMES (STD_SVY_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('Atlantic Marine Assessment Program for Protected Species (AMAPPS) Cetacean and Turtle Abundance', 745, 'N');
INSERT INTO CCD_STD_SVY_NAMES (STD_SVY_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('Atlantic Striped Bass Tagging Bottom Trawl Survey (USFWS)', 127, 'N');
INSERT INTO CCD_STD_SVY_NAMES (STD_SVY_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('Atlantic Surf Clam &amp; Ocean Quahog Dredge', 83, 'N');
INSERT INTO CCD_STD_SVY_NAMES (STD_SVY_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('BASIS Northern Bering Sea', 1407, 'N');
INSERT INTO CCD_STD_SVY_NAMES (STD_SVY_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('BASIS/FOCI Southeastern  Bering Sea', 2120, 'N');
INSERT INTO CCD_STD_SVY_NAMES (STD_SVY_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('BASIS_Fall', 15, 'N');
INSERT INTO CCD_STD_SVY_NAMES (STD_SVY_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('BFISH', 2971, 'N');
INSERT INTO CCD_STD_SVY_NAMES (STD_SVY_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('BRD Testing', 2607, 'N');
INSERT INTO CCD_STD_SVY_NAMES (STD_SVY_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('Beaufort Bridgenet Plankton Survey', 954, 'N');
INSERT INTO CCD_STD_SVY_NAMES (STD_SVY_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('Benthic Habitat characterization and mapping', 1764, 'N');
INSERT INTO CCD_STD_SVY_NAMES (STD_SVY_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('Bering Sea Biennial Walleye Pollock Accoustic_Summer', 45, 'N');
INSERT INTO CCD_STD_SVY_NAMES (STD_SVY_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('Bering Sea Eco-FOCI  Ichthyoplankton_Spring', 347, 'N');
INSERT INTO CCD_STD_SVY_NAMES (STD_SVY_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('Bering Sea Moorings and Zooplankton Survey_Spring (PMEL)', 2189, 'N');
INSERT INTO CCD_STD_SVY_NAMES (STD_SVY_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('Bering Sea Shelf FISHPAC Essential Fish Habitat Mapping', 1402, 'N');
INSERT INTO CCD_STD_SVY_NAMES (STD_SVY_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('Bering-Chukchi CAEP Sea Large Whale', 1403, 'N');
INSERT INTO CCD_STD_SVY_NAMES (STD_SVY_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('Biloxi Bay Beam Trawl Survey (MDMR)', 965, 'N');
INSERT INTO CCD_STD_SVY_NAMES (STD_SVY_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('Biloxi Bay Seine Survey (MDMR)', 966, 'N');
INSERT INTO CCD_STD_SVY_NAMES (STD_SVY_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('Bluefin Tuna Slope Sea Longline Survey', 1744, 'N');
INSERT INTO CCD_STD_SVY_NAMES (STD_SVY_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('Bluefin Tuna Slope Sea Survey', 1745, 'N');
INSERT INTO CCD_STD_SVY_NAMES (STD_SVY_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('Bogoslof Island Northern fur Seal (AEPNFS) Population', 1404, 'N');
INSERT INTO CCD_STD_SVY_NAMES (STD_SVY_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('Bottom Trawl Survey_Fall', 81, 'N');
INSERT INTO CCD_STD_SVY_NAMES (STD_SVY_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('Bottom Trawl Survey_Spring', 82, 'N');
INSERT INTO CCD_STD_SVY_NAMES (STD_SVY_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('Bottom Trawl Survey_Winter', 520, 'N');
INSERT INTO CCD_STD_SVY_NAMES (STD_SVY_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('COASTSPAN (state)', 782, 'N');
INSERT INTO CCD_STD_SVY_NAMES (STD_SVY_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('COOPERATIVE RESEARCH SURVEY - GEAR SELECTIVITY STUDY', 63, 'N');
INSERT INTO CCD_STD_SVY_NAMES (STD_SVY_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('COOPERATIVE RESEARCH SURVEY - GOOSEFISH', 64, 'N');
INSERT INTO CCD_STD_SVY_NAMES (STD_SVY_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('COOPERATIVE RESEARCH SURVEY - IBS COD', 65, 'N');
INSERT INTO CCD_STD_SVY_NAMES (STD_SVY_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('COOPERATIVE RESEARCH SURVEY - IBS YELLOWTAIL', 66, 'N');
INSERT INTO CCD_STD_SVY_NAMES (STD_SVY_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('COOPERATIVE RESEARCH SURVEY - PAIR TRAWL', 548, 'N');
INSERT INTO CCD_STD_SVY_NAMES (STD_SVY_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('COOPERATIVE RESEARCH SURVEY - SURFCLAM/QUAHOG', 67, 'N');
INSERT INTO CCD_STD_SVY_NAMES (STD_SVY_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('COOPERATIVE RESEARCH SURVEY - TWIN TRAWL', 549, 'N');
INSERT INTO CCD_STD_SVY_NAMES (STD_SVY_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('CalCOFI/Sardine (Southern Portion)_Spring', 157, 'N');
INSERT INTO CCD_STD_SVY_NAMES (STD_SVY_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('CalCOFI_Fall', 158, 'N');
INSERT INTO CCD_STD_SVY_NAMES (STD_SVY_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('CalCOFI_Spring', 159, 'N');
INSERT INTO CCD_STD_SVY_NAMES (STD_SVY_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('CalCOFI_Summer', 160, 'N');
INSERT INTO CCD_STD_SVY_NAMES (STD_SVY_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('CalCOFI_Winter', 156, 'N');
INSERT INTO CCD_STD_SVY_NAMES (STD_SVY_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('California Current ecosystem hake ecology and survey methods', 1793, 'N');
INSERT INTO CCD_STD_SVY_NAMES (STD_SVY_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('Caribbean Coral Reef Benthic Survey', 955, 'N');
INSERT INTO CCD_STD_SVY_NAMES (STD_SVY_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('Caribbean Plankton Recruitment Experiment Survey', 956, 'N');
INSERT INTO CCD_STD_SVY_NAMES (STD_SVY_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('Caribbean Reef Fish Assessment', 957, 'N');
INSERT INTO CCD_STD_SVY_NAMES (STD_SVY_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('Caribbean Reef Fish Video Survey', 1575, 'N');
INSERT INTO CCD_STD_SVY_NAMES (STD_SVY_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('Caribbean Southeast Deep Coral Program', 1772, 'N');
INSERT INTO CCD_STD_SVY_NAMES (STD_SVY_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('Central CA Rockfish', 161, 'N');
INSERT INTO CCD_STD_SVY_NAMES (STD_SVY_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('Central CA Shark', 292, 'N');
INSERT INTO CCD_STD_SVY_NAMES (STD_SVY_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('Cetaceans of Southeastern Alaska', 2119, 'N');
INSERT INTO CCD_STD_SVY_NAMES (STD_SVY_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('Characterization of the mesopelagic ecosystem', 1707, 'N');
INSERT INTO CCD_STD_SVY_NAMES (STD_SVY_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('Chesapeake Bay and Coastal Virginia Bottom Longline Shark Survey (VIMS)', 964, 'N');
INSERT INTO CCD_STD_SVY_NAMES (STD_SVY_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('Climate Impacts of Bluefin Tuna', 1249, 'N');
INSERT INTO CCD_STD_SVY_NAMES (STD_SVY_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('Coastal Finfish Gillnet Survey (MDMR)', 967, 'N');
INSERT INTO CCD_STD_SVY_NAMES (STD_SVY_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('Coastal Pelagic Shark Longline', 1129, 'N');
INSERT INTO CCD_STD_SVY_NAMES (STD_SVY_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('Coastal Pelagic Species (CPS)_Spring', 641, 'N');
INSERT INTO CCD_STD_SVY_NAMES (STD_SVY_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('Coastal Pelagic Species (CPS)_Summer', 646, 'N');
INSERT INTO CCD_STD_SVY_NAMES (STD_SVY_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('Collaborative Large Whale Survey (CLAWS)', 1228, 'N');
INSERT INTO CCD_STD_SVY_NAMES (STD_SVY_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('Cooperative Atlantic States Shark Pupping and Nursery (COASTSPAN) Survey (DELBAY)', 1049, 'N');
INSERT INTO CCD_STD_SVY_NAMES (STD_SVY_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('Cooperative Atlantic States Shark Pupping and Nursery (COASTSPAN) survey (GADNR)', 1032, 'N');
INSERT INTO CCD_STD_SVY_NAMES (STD_SVY_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('Cooperative Atlantic States Shark Pupping and Nursery (COASTSPAN) survey (SCDNR)', 1031, 'N');
INSERT INTO CCD_STD_SVY_NAMES (STD_SVY_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('Cooperative Research Survey - Longline', 2165, 'N');
INSERT INTO CCD_STD_SVY_NAMES (STD_SVY_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('Cowcod', 164, 'N');
INSERT INTO CCD_STD_SVY_NAMES (STD_SVY_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('Deep Sea Coral AUV', 1230, 'N');
INSERT INTO CCD_STD_SVY_NAMES (STD_SVY_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('Deep Set Longline', 1229, 'N');
INSERT INTO CCD_STD_SVY_NAMES (STD_SVY_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('Deep Water Horizon Oil Spill/Loop Current Survey', 521, 'N');
INSERT INTO CCD_STD_SVY_NAMES (STD_SVY_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('Deepwater Horizon Seafood Safety Sampling', 722, 'N');
INSERT INTO CCD_STD_SVY_NAMES (STD_SVY_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('Deepwater Red Crab Assessment (NRDA)', 1248, 'N');
INSERT INTO CCD_STD_SVY_NAMES (STD_SVY_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('Deepwater Rockfish Tagging', 2125, 'N');
INSERT INTO CCD_STD_SVY_NAMES (STD_SVY_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('Deepwater Systematics', 887, 'N');
INSERT INTO CCD_STD_SVY_NAMES (STD_SVY_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('Dry Tortugas Reef Fish Visual Census (RVC)', 140, 'N');
INSERT INTO CCD_STD_SVY_NAMES (STD_SVY_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('EMA-FOCI Age-0 Groundfish and Salmon Recruitment Process', 2123, 'N');
INSERT INTO CCD_STD_SVY_NAMES (STD_SVY_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('EMA-FOCI Larval Groundfish Assessment', 1410, 'N');
INSERT INTO CCD_STD_SVY_NAMES (STD_SVY_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('East Tropic Pacific (ETP) Marine Mammal', 645, 'N');
INSERT INTO CCD_STD_SVY_NAMES (STD_SVY_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('East Tropic Pacific (ETP) Sharks', 293, 'N');
INSERT INTO CCD_STD_SVY_NAMES (STD_SVY_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('Eastern Bering Sea Crab Mortality Reduction Conservation Engineering (CE) Study', 684, 'N');
INSERT INTO CCD_STD_SVY_NAMES (STD_SVY_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('Eastern Bering Sea Groundfish Bottom Trawl', 13, 'N');
INSERT INTO CCD_STD_SVY_NAMES (STD_SVY_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('Eastern Bering Sea Twin Trawl Conservation Engineering (CE) Study', 683, 'N');
INSERT INTO CCD_STD_SVY_NAMES (STD_SVY_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('Eastern Bering Sea Upper Continenal Slope Groundfish Bottom Trawl', 21, 'N');
INSERT INTO CCD_STD_SVY_NAMES (STD_SVY_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('Eastern Gulf of Alaska BASIS_GOA Assessment', 1406, 'N');
INSERT INTO CCD_STD_SVY_NAMES (STD_SVY_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('Eastern Gulf of Alaska spring sablefish', 1730, 'N');
INSERT INTO CCD_STD_SVY_NAMES (STD_SVY_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('Eco-FOCI Early Life_Winter', 1409, 'N');
INSERT INTO CCD_STD_SVY_NAMES (STD_SVY_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('Eco-FOCI Ecosystem Observations, Larval &amp; Juvenile Groundfish and Forage Fish Survey_Fall', 22, 'N');
INSERT INTO CCD_STD_SVY_NAMES (STD_SVY_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('Ecological Monitoring Trawl Survey (GADNR)', 953, 'N');
INSERT INTO CCD_STD_SVY_NAMES (STD_SVY_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('Ensential Fish Habitat (EFH) Juvenile Rockvish', 166, 'N');
INSERT INTO CCD_STD_SVY_NAMES (STD_SVY_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('Environmental Influences on Pink Shrimp', 958, 'N');
INSERT INTO CCD_STD_SVY_NAMES (STD_SVY_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('Epifaunal (small fish and macro-invertebrates) Sampling', 927, 'N');
INSERT INTO CCD_STD_SVY_NAMES (STD_SVY_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('Evaluating Optical and Acoustic Advanced Technologies to Survey Pacific Coast Rockfishes', 1732, 'N');
INSERT INTO CCD_STD_SVY_NAMES (STD_SVY_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('Evaluation of a multi-gear approach to conducting ecosystem focused fishery-independent surveys.', 2525, 'N');
INSERT INTO CCD_STD_SVY_NAMES (STD_SVY_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('Experimental Bottom Longline Survey', 1168, 'N');
INSERT INTO CCD_STD_SVY_NAMES (STD_SVY_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('Experimental Longline Survey', 1271, 'N');
INSERT INTO CCD_STD_SVY_NAMES (STD_SVY_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('Field Evaluation of an Unmanned Aircraft System (UAS) for Studying Cetacean Distribution, Density, and Habitat Use in the Arctic', 2126, 'N');
INSERT INTO CCD_STD_SVY_NAMES (STD_SVY_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('Fish assemblages of western and southwestern Puerto Rico', 230, 'N');
INSERT INTO CCD_STD_SVY_NAMES (STD_SVY_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('Fisheries Observer Program Training', 783, 'N');
INSERT INTO CCD_STD_SVY_NAMES (STD_SVY_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('Fisheries Oceanography - Climate Change', 1469, 'N');
INSERT INTO CCD_STD_SVY_NAMES (STD_SVY_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('Fisheries Oceanography - Leeward Oahu Pelagic Ecosystem Characterization', 1468, 'N');
INSERT INTO CCD_STD_SVY_NAMES (STD_SVY_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('Fisheries Oceanography - North Pacific Subtropical Front Survey', 779, 'Y');
INSERT INTO CCD_STD_SVY_NAMES (STD_SVY_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('Fisheries Oceanography - West Hawaii Integrated Ecosystem Assessment (IEA)', 546, 'Y');
INSERT INTO CCD_STD_SVY_NAMES (STD_SVY_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('Fishing Technology Studies to Reduce Bycatch and Habitat Effects of Fishing', 1405, 'N');
INSERT INTO CCD_STD_SVY_NAMES (STD_SVY_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('Florida Keys/Southeast Reef Fish Visual Census (RVC)', 141, 'N');
INSERT INTO CCD_STD_SVY_NAMES (STD_SVY_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('Florida/Dry Tortugas Coral Reef Benthic Survey', 959, 'N');
INSERT INTO CCD_STD_SVY_NAMES (STD_SVY_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('Foraging Ecology and Health of Adult Female Steller Sea Lions (AEPSSL)', 1418, 'N');
INSERT INTO CCD_STD_SVY_NAMES (STD_SVY_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('GOA/EBS/AI Longline Stock Assessment Survey', 8, 'N');
INSERT INTO CCD_STD_SVY_NAMES (STD_SVY_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('Guam and CNMI Ocean Acidification Process Cruise - National Coral Reef Conservation Program/National Ocean Acification Program', 1893, 'N');
INSERT INTO CCD_STD_SVY_NAMES (STD_SVY_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('Guam and the Commonwealth of the Northern Mariana Islands (CNMI) Cetacean Survey', 1462, 'N');
INSERT INTO CCD_STD_SVY_NAMES (STD_SVY_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('Gulf Watch Alaska Program', 2186, 'N');
INSERT INTO CCD_STD_SVY_NAMES (STD_SVY_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('Gulf of Alaska - Southeast Coastal Monitoring Age-0 Groundfish and Salmon Recruitment Processes', 2121, 'N');
INSERT INTO CCD_STD_SVY_NAMES (STD_SVY_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('Gulf of Alaska Biennial Walleye Pollock Accoustic_Summer', 46, 'N');
INSERT INTO CCD_STD_SVY_NAMES (STD_SVY_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('Gulf of Alaska Eco-FOCI_Late Larval Fish', 23, 'N');
INSERT INTO CCD_STD_SVY_NAMES (STD_SVY_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('Gulf of Alaska Habitat Areas of Particular Concern (HAPC)', 1411, 'N');
INSERT INTO CCD_STD_SVY_NAMES (STD_SVY_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('Gulf of Alaska Integrated Ecosystem Research Program (IERP)', 565, 'N');
INSERT INTO CCD_STD_SVY_NAMES (STD_SVY_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('Gulf of Alaska Shelf and Slope Groundfish Bottom Trawl ', 30, 'N');
INSERT INTO CCD_STD_SVY_NAMES (STD_SVY_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('Gulf of Alaska Steller Sea Lion (AEPSSL) Resight', 1417, 'N');
INSERT INTO CCD_STD_SVY_NAMES (STD_SVY_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('Gulf of Alaska Steller sea lion vital rates studies', 2127, 'N');
INSERT INTO CCD_STD_SVY_NAMES (STD_SVY_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('Gulf of California Vaquita Expedition', 542, 'N');
INSERT INTO CCD_STD_SVY_NAMES (STD_SVY_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('Gulf of Maine Bottom Longline Survey_Fall', 1568, 'N');
INSERT INTO CCD_STD_SVY_NAMES (STD_SVY_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('Gulf of Maine Bottom Longline Survey_Spring', 1604, 'N');
INSERT INTO CCD_STD_SVY_NAMES (STD_SVY_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('Gulf of Mexico Bryde''s Whale Trophic Ecology Study_Fall', 2162, 'N');
INSERT INTO CCD_STD_SVY_NAMES (STD_SVY_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('Gulf of Mexico Bryde''s Whale Trophic Ecology Study_Summer', 2931, 'N');
INSERT INTO CCD_STD_SVY_NAMES (STD_SVY_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('Gulf of Mexico Highly Migratory Species (HMS) Pelagic Longline_Winter', 1381, 'N');
INSERT INTO CCD_STD_SVY_NAMES (STD_SVY_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('Gulf of Mexico Pelagic Longline', 138, 'N');
INSERT INTO CCD_STD_SVY_NAMES (STD_SVY_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('Gulf of Mexico Shark Pupping and Nursery (GULFSPAN)', 231, 'N');
INSERT INTO CCD_STD_SVY_NAMES (STD_SVY_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('Gulf of Mexico Shark Pupping and Nursery (GULFSPAN) (FSU/CML)', 960, 'N');
INSERT INTO CCD_STD_SVY_NAMES (STD_SVY_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('Gulf of Mexico Shark Pupping and Nursery (GULFSPAN) (UHCL)', 961, 'N');
INSERT INTO CCD_STD_SVY_NAMES (STD_SVY_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('Gulf of Mexico Shark Pupping and Nursery (GULFSPAN) (USA/DISL)', 962, 'N');
INSERT INTO CCD_STD_SVY_NAMES (STD_SVY_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('Gulf of Mexico Shark Pupping and Nursery (GULFSPAN) (USM/GCRL)', 963, 'N');
INSERT INTO CCD_STD_SVY_NAMES (STD_SVY_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('Habitat Sea Bass', 744, 'N');
INSERT INTO CCD_STD_SVY_NAMES (STD_SVY_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('Hake Acoustic_Summer', 92, 'N');
INSERT INTO CCD_STD_SVY_NAMES (STD_SVY_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('Hawaiian Archipelago Insular', 768, 'N');
INSERT INTO CCD_STD_SVY_NAMES (STD_SVY_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('Hawaiian Archipelago Insular Bottomfish Survey', 1427, 'Y');
INSERT INTO CCD_STD_SVY_NAMES (STD_SVY_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('Hawaiian Archipelago Insular Bottomfish Survey (Cooperative Research)', 2037, 'N');
INSERT INTO CCD_STD_SVY_NAMES (STD_SVY_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('Hawaiian Archipelago Insular Reef Fish Survey', 2038, 'N');
INSERT INTO CCD_STD_SVY_NAMES (STD_SVY_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('Hawaiian Archipelago Life History Bio-sampling', 2041, 'N');
INSERT INTO CCD_STD_SVY_NAMES (STD_SVY_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('Hawaiian Archipelago Reef Assessment and Monitoring Program (HARAMP) - National Coral Reef Monitoring Program (NCRMP)', 1423, 'N');
INSERT INTO CCD_STD_SVY_NAMES (STD_SVY_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('Hawaiian Islands: Technology for the Ecology of Cetaceans (HI-TEC)', 1442, 'N');
INSERT INTO CCD_STD_SVY_NAMES (STD_SVY_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('Hawaiian Monk Seal Enhancement and Survey Cruise (HMSEAS)', 1463, 'N');
INSERT INTO CCD_STD_SVY_NAMES (STD_SVY_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('Hawaiian Monk Seal Population Assessment and Recovery Activities - Deployment', 1432, 'N');
INSERT INTO CCD_STD_SVY_NAMES (STD_SVY_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('Hawaiian Monk Seal Population Assessment and Recovery Activities - Recovery', 209, 'Y');
INSERT INTO CCD_STD_SVY_NAMES (STD_SVY_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('Herring Energetics', 348, 'N');
INSERT INTO CCD_STD_SVY_NAMES (STD_SVY_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('Humpback Whale Prey', 349, 'N');
INSERT INTO CCD_STD_SVY_NAMES (STD_SVY_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('Ice Seal Ecology', 1413, 'N');
INSERT INTO CCD_STD_SVY_NAMES (STD_SVY_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('In-Water Sea Turtle Research (SCDNR)', 1310, 'N');
INSERT INTO CCD_STD_SVY_NAMES (STD_SVY_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('InShore Shark Longline', 232, 'N');
INSERT INTO CCD_STD_SVY_NAMES (STD_SVY_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('Inshore Finfish Trawl Survey (MDMR)', 968, 'N');
INSERT INTO CCD_STD_SVY_NAMES (STD_SVY_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('Integrated Biscayne Bay Ecological Assessment and Monitoring Project (IBBEAM)', 909, 'N');
INSERT INTO CCD_STD_SVY_NAMES (STD_SVY_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('Intraspecific Diversity in Pink Shrimp Survey', 973, 'N');
INSERT INTO CCD_STD_SVY_NAMES (STD_SVY_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('Johnston Cetacean and Ecosystem Assessment Survey', 2040, 'N');
INSERT INTO CCD_STD_SVY_NAMES (STD_SVY_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('Juvenile Forage Fish Energetics', 352, 'N');
INSERT INTO CCD_STD_SVY_NAMES (STD_SVY_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('Juvenile Rockfish Survey', 168, 'N');
INSERT INTO CCD_STD_SVY_NAMES (STD_SVY_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('Juvenile Salmon PNW Coastal_Fall', 1347, 'N');
INSERT INTO CCD_STD_SVY_NAMES (STD_SVY_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('Juvenile Salmon PNW Coastal_Spring', 1345, 'N');
INSERT INTO CCD_STD_SVY_NAMES (STD_SVY_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('Juvenile Salmon PNW Coastal_Summer', 1346, 'N');
INSERT INTO CCD_STD_SVY_NAMES (STD_SVY_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('Juvenile Salmon_Fall', 643, 'N');
INSERT INTO CCD_STD_SVY_NAMES (STD_SVY_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('Juvenile Salmon_Summer', 642, 'N');
INSERT INTO CCD_STD_SVY_NAMES (STD_SVY_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('Juvenile Sport Fish Trawl Monitoring Florida Bay', 907, 'N');
INSERT INTO CCD_STD_SVY_NAMES (STD_SVY_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('Juvenile Stage Trawl Survey (GADNR)', 952, 'N');
INSERT INTO CCD_STD_SVY_NAMES (STD_SVY_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('Juvenile sablefish tagging_Summer', 34, 'N');
INSERT INTO CCD_STD_SVY_NAMES (STD_SVY_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('Kodiak Island Monitoring Line', 1414, 'N');
INSERT INTO CCD_STD_SVY_NAMES (STD_SVY_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('Leatherback Turtle/Swordfish Use of Temperate Habitat (LUTH)', 172, 'N');
INSERT INTO CCD_STD_SVY_NAMES (STD_SVY_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('Living Marine Resources Coastal Science Center (LMRCSC)', 742, 'N');
INSERT INTO CCD_STD_SVY_NAMES (STD_SVY_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('Lobster Community', 772, 'N');
INSERT INTO CCD_STD_SVY_NAMES (STD_SVY_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('MARMAP Reef Fish Long Bottom Longline Survey (SCDNR)', 701, 'N');
INSERT INTO CCD_STD_SVY_NAMES (STD_SVY_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('MARMAP/SEAMAP South Atlantic Reef Fish (SCDNR)', 702, 'N');
INSERT INTO CCD_STD_SVY_NAMES (STD_SVY_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('MSLABS Gulf of Mexico EASA Survey', 661, 'N');
INSERT INTO CCD_STD_SVY_NAMES (STD_SVY_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('Main Hawaiian Island (MHI) Insular Bottomfish Survey (Cooperative Research)', 1430, 'N');
INSERT INTO CCD_STD_SVY_NAMES (STD_SVY_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('Main Hawaiian Island (MHI) Insular Bottomfish Survey_Fall', 1429, 'Y');
INSERT INTO CCD_STD_SVY_NAMES (STD_SVY_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('Main Hawaiian Island (MHI) Insular Bottomfish Survey_Spring', 1428, 'N');
INSERT INTO CCD_STD_SVY_NAMES (STD_SVY_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('Mangrove Studies', 233, 'N');
INSERT INTO CCD_STD_SVY_NAMES (STD_SVY_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('Mariana Archipelago Cetacean Survey (MACS)', 1461, 'Y');
INSERT INTO CCD_STD_SVY_NAMES (STD_SVY_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('Mariana Archipelago Life History Bio-sampling', 2042, 'N');
INSERT INTO CCD_STD_SVY_NAMES (STD_SVY_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('Mariana Islands Cetacean and Ecosystem Assessment Survey', 767, 'N');
INSERT INTO CCD_STD_SVY_NAMES (STD_SVY_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('Marianas Archipelago Insular Bottomfish Survey', 1426, 'N');
INSERT INTO CCD_STD_SVY_NAMES (STD_SVY_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('Marianas Archipelago Insular Reef Fish Survey', 770, 'N');
INSERT INTO CCD_STD_SVY_NAMES (STD_SVY_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('Marianas Reef Assessment and Monitoring Program (MARAMP) - National Coral Reef Monitoring Program (NCRMP)', 1421, 'Y');
INSERT INTO CCD_STD_SVY_NAMES (STD_SVY_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('Marine Debris Research and Removal - Northwestern hawaiian Islands', 775, 'Y');
INSERT INTO CCD_STD_SVY_NAMES (STD_SVY_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('Marine Mammal and Ecosystem Assessment-Caribbean', 974, 'N');
INSERT INTO CCD_STD_SVY_NAMES (STD_SVY_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('Marine Mammal and Ecosystem Assessment-Gulf of Mexico', 975, 'N');
INSERT INTO CCD_STD_SVY_NAMES (STD_SVY_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('Marine Mammals Survey_Summer', 133, 'N');
INSERT INTO CCD_STD_SVY_NAMES (STD_SVY_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('Marine Mammals Survey_Winter', 134, 'N');
INSERT INTO CCD_STD_SVY_NAMES (STD_SVY_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('Marine National Monuments Research', 1466, 'N');
INSERT INTO CCD_STD_SVY_NAMES (STD_SVY_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('Massachusetts DMF Bottom Trawl_Fall', 550, 'N');
INSERT INTO CCD_STD_SVY_NAMES (STD_SVY_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('Massachusetts DMF Bottom Trawl_Spring', 551, 'N');
INSERT INTO CCD_STD_SVY_NAMES (STD_SVY_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('Mesoamerican coral reef project', 234, 'N');
INSERT INTO CCD_STD_SVY_NAMES (STD_SVY_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('Mid-Atlantic Habitat Mapping', 743, 'N');
INSERT INTO CCD_STD_SVY_NAMES (STD_SVY_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('Mid-Water Trawl - Gulf of Mexico', 977, 'N');
INSERT INTO CCD_STD_SVY_NAMES (STD_SVY_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('Mid-Water Trawl - South Atlantic', 978, 'N');
INSERT INTO CCD_STD_SVY_NAMES (STD_SVY_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('Miscellaneous Bottom Trawl Survey', 85, 'N');
INSERT INTO CCD_STD_SVY_NAMES (STD_SVY_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('Movement and Migration of Key Alaska Fishes', 1415, 'N');
INSERT INTO CCD_STD_SVY_NAMES (STD_SVY_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('NERACOOS Mooring Maintenance', 1364, 'N');
INSERT INTO CCD_STD_SVY_NAMES (STD_SVY_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('NMFS Acoustics Survey_Fall', 79, 'N');
INSERT INTO CCD_STD_SVY_NAMES (STD_SVY_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('NWFSC - Pacific Coast Ocean Observing System (PacCOOS) Survey', 99, 'N');
INSERT INTO CCD_STD_SVY_NAMES (STD_SVY_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('NWHI Marine Turtle Population Assessment Survey - Deploy', 1108, 'Y');
INSERT INTO CCD_STD_SVY_NAMES (STD_SVY_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('NWHI Marine Turtle Population Assessment Survey - Recovery', 1811, 'N');
INSERT INTO CCD_STD_SVY_NAMES (STD_SVY_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('Navassa Island Survey', 135, 'N');
INSERT INTO CCD_STD_SVY_NAMES (STD_SVY_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('Nearshore Ichthyoplankton', 174, 'N');
INSERT INTO CCD_STD_SVY_NAMES (STD_SVY_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('Newport Line', 95, 'N');
INSERT INTO CCD_STD_SVY_NAMES (STD_SVY_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('North Atlantic Seafloor Partnership for Integrated Research &amp; Exploration (ASPIRE)', 1768, 'N');
INSERT INTO CCD_STD_SVY_NAMES (STD_SVY_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('North Carolina Pamlico Sound Survey', 547, 'N');
INSERT INTO CCD_STD_SVY_NAMES (STD_SVY_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('Northeast Area Monitoring and Assessment Program (NEAMAP) (MDMR/VIMS)', 1048, 'N');
INSERT INTO CCD_STD_SVY_NAMES (STD_SVY_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('Northeast Atlantic Benthic Habitat_Fall', 59, 'N');
INSERT INTO CCD_STD_SVY_NAMES (STD_SVY_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('Northeast Atlantic Benthic Habitat_Spring', 60, 'N');
INSERT INTO CCD_STD_SVY_NAMES (STD_SVY_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('Northeast Atlantic Benthic Habitat_Summer', 61, 'N');
INSERT INTO CCD_STD_SVY_NAMES (STD_SVY_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('Northeast Atlantic Benthic Habitat_Winter', 62, 'N');
INSERT INTO CCD_STD_SVY_NAMES (STD_SVY_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('Northeast Atlantic Seafloor Partnership for Integrated Research &amp; Exploration (ASPIRE)', 1770, 'N');
INSERT INTO CCD_STD_SVY_NAMES (STD_SVY_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('Northeast Cetacean and Turtle Biology Survey', 1208, 'N');
INSERT INTO CCD_STD_SVY_NAMES (STD_SVY_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('Northeast Cooperative Flatfish Survey', 928, 'N');
INSERT INTO CCD_STD_SVY_NAMES (STD_SVY_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('Northeast Deep Water Coral Habitats', 886, 'N');
INSERT INTO CCD_STD_SVY_NAMES (STD_SVY_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('Northeast Ecosystem Monitoring (EcoMon)_Fall', 70, 'N');
INSERT INTO CCD_STD_SVY_NAMES (STD_SVY_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('Northeast Ecosystem Monitoring (EcoMon)_Spring', 2668, 'N');
INSERT INTO CCD_STD_SVY_NAMES (STD_SVY_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('Northeast Ecosystem Monitoring (EcoMon)_Summer', 71, 'N');
INSERT INTO CCD_STD_SVY_NAMES (STD_SVY_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('Northeast Ecosystem Monitoring (EcoMon)_Winter', 72, 'N');
INSERT INTO CCD_STD_SVY_NAMES (STD_SVY_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('Northeast Gulf of Mexico MPA', 136, 'N');
INSERT INTO CCD_STD_SVY_NAMES (STD_SVY_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('Northeast Marine Mammal_Fall', 74, 'N');
INSERT INTO CCD_STD_SVY_NAMES (STD_SVY_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('Northeast Marine Mammal_Spring', 75, 'N');
INSERT INTO CCD_STD_SVY_NAMES (STD_SVY_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('Northeast Marine Mammal_Summer', 76, 'N');
INSERT INTO CCD_STD_SVY_NAMES (STD_SVY_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('Northeast Sea Scallop_Summer', 86, 'N');
INSERT INTO CCD_STD_SVY_NAMES (STD_SVY_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('Northeast Turtle biology survey', 1831, 'N');
INSERT INTO CCD_STD_SVY_NAMES (STD_SVY_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('Northeastern Continental Slope Deepwater Biodiversity', 1365, 'N');
INSERT INTO CCD_STD_SVY_NAMES (STD_SVY_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('Northern California Current (NCC) Ecosystem Forecasting_Fall', 1348, 'N');
INSERT INTO CCD_STD_SVY_NAMES (STD_SVY_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('Northern California Current (NCC) Ecosystem Forecasting_Summer', 1349, 'N');
INSERT INTO CCD_STD_SVY_NAMES (STD_SVY_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('Northern California Current (NCC) Ecosystem Forecasting_Winter', 1350, 'N');
INSERT INTO CCD_STD_SVY_NAMES (STD_SVY_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('Northern Channel Islands Seafloor Mapping of Coral Habitats', 1731, 'N');
INSERT INTO CCD_STD_SVY_NAMES (STD_SVY_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('Northern Gulf Institute Cross-Shelf Hardbottom Study', 1188, 'N');
INSERT INTO CCD_STD_SVY_NAMES (STD_SVY_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('Northern Juvenile Fish', 96, 'N');
INSERT INTO CCD_STD_SVY_NAMES (STD_SVY_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('Oculina HAPC_Spring', 137, 'N');
INSERT INTO CCD_STD_SVY_NAMES (STD_SVY_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('Open Bay Shellfish Trawl Survey (TPWD)', 969, 'N');
INSERT INTO CCD_STD_SVY_NAMES (STD_SVY_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('Oyster Dredge Monitoring Survey (MDMR)', 970, 'N');
INSERT INTO CCD_STD_SVY_NAMES (STD_SVY_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('Oyster Visual Monitoring Survey (MDMR)', 971, 'N');
INSERT INTO CCD_STD_SVY_NAMES (STD_SVY_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('PIFSC - Hawaiian Islands Cetacean and Ecosystem Assessment Survey (HICEAS)', 764, 'Y');
INSERT INTO CCD_STD_SVY_NAMES (STD_SVY_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('Pacific Coast Ocean Observing System (PacCOOS) Central CA (MBARI)', 176, 'N');
INSERT INTO CCD_STD_SVY_NAMES (STD_SVY_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('Pacific Coast Ocean Observing System (PacCOOS) North CA (Bodega Line)', 177, 'N');
INSERT INTO CCD_STD_SVY_NAMES (STD_SVY_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('Pacific Hake Spawning Biomass Acoustic Survey', 1576, 'N');
INSERT INTO CCD_STD_SVY_NAMES (STD_SVY_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('Pacific Islands Cetacean Ecosystem Survey (PICES)', 295, 'Y');
INSERT INTO CCD_STD_SVY_NAMES (STD_SVY_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('Pacific Islands Cetacean and Ecosystem Assessment Survey (PICEAS)', 2039, 'N');
INSERT INTO CCD_STD_SVY_NAMES (STD_SVY_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('Pacific Northwest (PNW) Ichthyoplankton', 100, 'N');
INSERT INTO CCD_STD_SVY_NAMES (STD_SVY_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('Pacific Northwest (PNW) Piscine Predator and Forage Fish', 101, 'N');
INSERT INTO CCD_STD_SVY_NAMES (STD_SVY_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('Pacific Northwest Harmful Algal Bloom (HAB)', 250, 'N');
INSERT INTO CCD_STD_SVY_NAMES (STD_SVY_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('Pacific Reef Assessment and Monitoring Program (Pacific RAMP) - National Coral Reef Monitoring Program (NCRMP)', 1441, 'Y');
INSERT INTO CCD_STD_SVY_NAMES (STD_SVY_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('Pacific Remote Islands Insular Reef Fish Survey', 1424, 'Y');
INSERT INTO CCD_STD_SVY_NAMES (STD_SVY_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('Panama City Laboratory Reef Fish ROV', 979, 'N');
INSERT INTO CCD_STD_SVY_NAMES (STD_SVY_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('Panama City Laboratory Reef Fish Trap/Video', 235, 'N');
INSERT INTO CCD_STD_SVY_NAMES (STD_SVY_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('Pre-recruit Survey to Aid Stock Assessment', 1351, 'N');
INSERT INTO CCD_STD_SVY_NAMES (STD_SVY_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('Pulley Ridge HAPC Fish and Coral Survey_Spring', 139, 'N');
INSERT INTO CCD_STD_SVY_NAMES (STD_SVY_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('RecFIN Red Drum Trammel Net Survey (SCDNR)', 805, 'N');
INSERT INTO CCD_STD_SVY_NAMES (STD_SVY_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('Reef Fish Visual Census Survey - U.S. Caribbean', 980, 'N');
INSERT INTO CCD_STD_SVY_NAMES (STD_SVY_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('Rockfish Habitat and Production Studies', 1412, 'N');
INSERT INTO CCD_STD_SVY_NAMES (STD_SVY_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('SEAMAP Gulf of Mexico Reef Fish', 146, 'N');
INSERT INTO CCD_STD_SVY_NAMES (STD_SVY_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('SEAMAP Gulf of Mexico Reef Fish Monitoring (FFWCC)', 998, 'N');
INSERT INTO CCD_STD_SVY_NAMES (STD_SVY_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('SEAMAP Plankton_Fall', 236, 'N');
INSERT INTO CCD_STD_SVY_NAMES (STD_SVY_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('SEAMAP Plankton_Spring', 144, 'N');
INSERT INTO CCD_STD_SVY_NAMES (STD_SVY_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('SEAMAP Plankton_Winter', 145, 'N');
INSERT INTO CCD_STD_SVY_NAMES (STD_SVY_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('SEAMAP Reef Fish Camera/Trap', 1250, 'N');
INSERT INTO CCD_STD_SVY_NAMES (STD_SVY_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('SEAMAP Shark/Red Snapper Bottom Longline', 131, 'N');
INSERT INTO CCD_STD_SVY_NAMES (STD_SVY_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('SEAMAP South Atlantic Coastal Trawl_Fall (SCDNR)', 149, 'N');
INSERT INTO CCD_STD_SVY_NAMES (STD_SVY_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('SEAMAP South Atlantic Coastal Trawl_Spring (SCDNR)', 624, 'N');
INSERT INTO CCD_STD_SVY_NAMES (STD_SVY_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('SEAMAP South Atlantic Coastal Trawl_Summer (SCDNR)', 150, 'N');
INSERT INTO CCD_STD_SVY_NAMES (STD_SVY_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('SEAMAP South Atlantic NC Red Drum Longline', 626, 'N');
INSERT INTO CCD_STD_SVY_NAMES (STD_SVY_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('SEAMAP South Atlantic NC Red Drum Longline (NCDENR)', 3071, 'N');
INSERT INTO CCD_STD_SVY_NAMES (STD_SVY_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('SEAMAP South Atlantic North Carolina Pamlico Sound Trawl (NCDENR)', 1010, 'N');
INSERT INTO CCD_STD_SVY_NAMES (STD_SVY_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('SEAMAP South Atlantic Reef Fish', 627, 'N');
INSERT INTO CCD_STD_SVY_NAMES (STD_SVY_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('SEAMAP South Atlantic Trawl_Fall', 1383, 'N');
INSERT INTO CCD_STD_SVY_NAMES (STD_SVY_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('SEAMAP South Atlantic Trawl_Summer', 1384, 'N');
INSERT INTO CCD_STD_SVY_NAMES (STD_SVY_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('SEAMAP South Atlantic Trawl_Winter', 1385, 'N');
INSERT INTO CCD_STD_SVY_NAMES (STD_SVY_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('SEAMAP-C Finfish Rod-and-Reel Survey (PR-DNER)', 981, 'N');
INSERT INTO CCD_STD_SVY_NAMES (STD_SVY_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('SEAMAP-C Lane Snapper Bottom Longline (DNER)', 982, 'N');
INSERT INTO CCD_STD_SVY_NAMES (STD_SVY_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('SEAMAP-C Queen Conch Visual Surveys (PR-DNER,USVI-DFW)', 988, 'N');
INSERT INTO CCD_STD_SVY_NAMES (STD_SVY_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('SEAMAP-C Spiny Lobster Artificial Habitat Surveys (PR-DNER,USVI-DFW)', 989, 'N');
INSERT INTO CCD_STD_SVY_NAMES (STD_SVY_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('SEAMAP-C Yellowtail Snapper Rod-and-Reel (DNER)', 990, 'N');
INSERT INTO CCD_STD_SVY_NAMES (STD_SVY_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('SEAMAP-GOM Bottom Longline Survey (ADCNR)', 991, 'N');
INSERT INTO CCD_STD_SVY_NAMES (STD_SVY_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('SEAMAP-GOM Bottom Longline Survey (LDWF)', 992, 'N');
INSERT INTO CCD_STD_SVY_NAMES (STD_SVY_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('SEAMAP-GOM Bottom Longline Survey (TPWD)', 993, 'N');
INSERT INTO CCD_STD_SVY_NAMES (STD_SVY_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('SEAMAP-GOM Bottom Longline Survey (USM/GCRL)', 994, 'N');
INSERT INTO CCD_STD_SVY_NAMES (STD_SVY_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('SEAMAP-GOM Offshore Plankton (LDWF)', 995, 'N');
INSERT INTO CCD_STD_SVY_NAMES (STD_SVY_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('SEAMAP-GOM Plankton (ADCNR)', 996, 'N');
INSERT INTO CCD_STD_SVY_NAMES (STD_SVY_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('SEAMAP-GOM Plankton (GCRL)', 997, 'N');
INSERT INTO CCD_STD_SVY_NAMES (STD_SVY_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('SEAMAP-GOM Shrimp/Groundfish Trawl_Fall', 147, 'N');
INSERT INTO CCD_STD_SVY_NAMES (STD_SVY_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('SEAMAP-GOM Shrimp/Groundfish Trawl_Fall (ADCNR)', 1000, 'N');
INSERT INTO CCD_STD_SVY_NAMES (STD_SVY_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('SEAMAP-GOM Shrimp/Groundfish Trawl_Fall (FFWCC)', 948, 'N');
INSERT INTO CCD_STD_SVY_NAMES (STD_SVY_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('SEAMAP-GOM Shrimp/Groundfish Trawl_Fall (GCRL)', 1006, 'N');
INSERT INTO CCD_STD_SVY_NAMES (STD_SVY_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('SEAMAP-GOM Shrimp/Groundfish Trawl_Fall (LDWF)', 1004, 'N');
INSERT INTO CCD_STD_SVY_NAMES (STD_SVY_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('SEAMAP-GOM Shrimp/Groundfish Trawl_Fall (TPWD)', 1002, 'N');
INSERT INTO CCD_STD_SVY_NAMES (STD_SVY_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('SEAMAP-GOM Shrimp/Groundfish Trawl_Spring', 238, 'N');
INSERT INTO CCD_STD_SVY_NAMES (STD_SVY_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('SEAMAP-GOM Shrimp/Groundfish Trawl_Summer', 148, 'N');
INSERT INTO CCD_STD_SVY_NAMES (STD_SVY_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('SEAMAP-GOM Shrimp/Groundfish Trawl_Summer (ADCNR)', 999, 'N');
INSERT INTO CCD_STD_SVY_NAMES (STD_SVY_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('SEAMAP-GOM Shrimp/Groundfish Trawl_Summer (FFWCC)', 846, 'N');
INSERT INTO CCD_STD_SVY_NAMES (STD_SVY_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('SEAMAP-GOM Shrimp/Groundfish Trawl_Summer (GCRL)', 1005, 'N');
INSERT INTO CCD_STD_SVY_NAMES (STD_SVY_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('SEAMAP-GOM Shrimp/Groundfish Trawl_Summer (LDWF)', 1003, 'N');
INSERT INTO CCD_STD_SVY_NAMES (STD_SVY_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('SEAMAP-GOM Shrimp/Groundfish Trawl_Summer (TPWD)', 1001, 'N');
INSERT INTO CCD_STD_SVY_NAMES (STD_SVY_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('SEAMAP-GOM Shrimp/Groundfish Trawl_Winter', 239, 'N');
INSERT INTO CCD_STD_SVY_NAMES (STD_SVY_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('SEAMAP-GOM Vertical Line Survey (ADCNR)', 1007, 'N');
INSERT INTO CCD_STD_SVY_NAMES (STD_SVY_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('SEAMAP-GOM Vertical Line Survey (LDWF)', 1008, 'N');
INSERT INTO CCD_STD_SVY_NAMES (STD_SVY_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('SEAMAP-GOM Vertical Line Survey (USM/GCRL)', 1009, 'N');
INSERT INTO CCD_STD_SVY_NAMES (STD_SVY_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('SEAMAP-SA Juvenile Grouper (Gag) Ingress Study (SCDNR)', 628, 'N');
INSERT INTO CCD_STD_SVY_NAMES (STD_SVY_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('SEAMAP-SA Red Drum Bottom Longline Survey (GADNR)', 625, 'N');
INSERT INTO CCD_STD_SVY_NAMES (STD_SVY_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('SEAMAP-SA Red Drum Bottom Longline Survey (NCDENR)', 1011, 'N');
INSERT INTO CCD_STD_SVY_NAMES (STD_SVY_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('SEAMAP-SA Red Drum Bottom Longline Survey (SCDNR)', 1012, 'N');
INSERT INTO CCD_STD_SVY_NAMES (STD_SVY_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('SWFSC - Hawaiian Islands Cetacean and Ecosystem Assessment Survey (HICEAS)', 543, 'N');
INSERT INTO CCD_STD_SVY_NAMES (STD_SVY_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('Sablefish and Deepwater Rockfish Maturity', 2124, 'N');
INSERT INTO CCD_STD_SVY_NAMES (STD_SVY_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('Saint Andrew Bay Juvenile Reef Fish Trawl', 142, 'N');
INSERT INTO CCD_STD_SVY_NAMES (STD_SVY_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('Sardine - Hake Acoustic Trawl Survey (SaKe)', 785, 'N');
INSERT INTO CCD_STD_SVY_NAMES (STD_SVY_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('Shoreline Shellfish Bag Seine Survey (TPWD)', 972, 'N');
INSERT INTO CCD_STD_SVY_NAMES (STD_SVY_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('Shrimp Survey (ASMFC) Northern Shrimp', 87, 'N');
INSERT INTO CCD_STD_SVY_NAMES (STD_SVY_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('Skagit Bay Juvenile Salmon', 228, 'N');
INSERT INTO CCD_STD_SVY_NAMES (STD_SVY_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('Skimmer Trawl TED Testing', 888, 'N');
INSERT INTO CCD_STD_SVY_NAMES (STD_SVY_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('Small Pelagics Survey_Fall', 151, 'N');
INSERT INTO CCD_STD_SVY_NAMES (STD_SVY_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('Snow Crab Growth Collection', 2185, 'N');
INSERT INTO CCD_STD_SVY_NAMES (STD_SVY_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('South Atlantic Bight MPA', 153, 'N');
INSERT INTO CCD_STD_SVY_NAMES (STD_SVY_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('South Atlantic Pilot Whale_Fall', 721, 'N');
INSERT INTO CCD_STD_SVY_NAMES (STD_SVY_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('Southeast Atlantic Marine Assessment Program for Protected Species (AMAPPS) Marine Mammal Assessment_Summer', 976, 'N');
INSERT INTO CCD_STD_SVY_NAMES (STD_SVY_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('Southeast Atlantic Seafloor Partnership for Integrated Research &amp; Exploration (ASPIRE)', 1646, 'N');
INSERT INTO CCD_STD_SVY_NAMES (STD_SVY_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('Southeast Coastal Monitoring (SECM)', 55, 'N');
INSERT INTO CCD_STD_SVY_NAMES (STD_SVY_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('Southeast Fishery-Independent Survey (SEFIS)', 602, 'N');
INSERT INTO CCD_STD_SVY_NAMES (STD_SVY_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('Southeast Sawfish Abundance', 500, 'N');
INSERT INTO CCD_STD_SVY_NAMES (STD_SVY_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('Southeast/Northeast Ecosystem Monitoring', 69, 'N');
INSERT INTO CCD_STD_SVY_NAMES (STD_SVY_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('Southern Resident Killer Whales (SRKW)_Spring', 105, 'N');
INSERT INTO CCD_STD_SVY_NAMES (STD_SVY_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('Southern Resident Killer Whales (SRKW)_Winter', 106, 'N');
INSERT INTO CCD_STD_SVY_NAMES (STD_SVY_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('Southwest Highly Migratory Species (HMS) Longline', 173, 'N');
INSERT INTO CCD_STD_SVY_NAMES (STD_SVY_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('St. Lucie Rod-and-Reel Fish Health Study', 908, 'N');
INSERT INTO CCD_STD_SVY_NAMES (STD_SVY_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('Standardized Bottom Trawl Gear Research', 1725, 'N');
INSERT INTO CCD_STD_SVY_NAMES (STD_SVY_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('Steller Sea Lion Vital Rate and Pup Health Studies', 2097, 'N');
INSERT INTO CCD_STD_SVY_NAMES (STD_SVY_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('Steller sea lion brand resights/food habits_Summer', 56, 'N');
INSERT INTO CCD_STD_SVY_NAMES (STD_SVY_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('Steller sea lion pup condition/branding_Spring', 57, 'N');
INSERT INTO CCD_STD_SVY_NAMES (STD_SVY_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('Swordfish Tagging Using Deep-set Buoy Gear', 746, 'N');
INSERT INTO CCD_STD_SVY_NAMES (STD_SVY_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('Tortugas Ecological Reserve Study', 152, 'N');
INSERT INTO CCD_STD_SVY_NAMES (STD_SVY_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('U.S. Antarctic Marine Living Resources (AMLR) Program', 186, 'N');
INSERT INTO CCD_STD_SVY_NAMES (STD_SVY_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('US South Atlantic Southeast Deep Coral Program', 1644, 'N');
INSERT INTO CCD_STD_SVY_NAMES (STD_SVY_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('USVI Larval Fish Cruise Surveys_Spring', 154, 'N');
INSERT INTO CCD_STD_SVY_NAMES (STD_SVY_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('Untrawlable Habitat Adult Rockfish/Deepsea Corals (COAST)_Acoustics', 290, 'N');
INSERT INTO CCD_STD_SVY_NAMES (STD_SVY_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('Untrawlable Habitat Adult Rockfish/Deepsea Corals (COAST)_ROV', 289, 'N');
INSERT INTO CCD_STD_SVY_NAMES (STD_SVY_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('UxS Project to Support Innovative ASV Technology for Fisheries Surveys', 2128, 'N');
INSERT INTO CCD_STD_SVY_NAMES (STD_SVY_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('Walleye Pollock Bering Sea (Bogoslof) Pre-spawning Survey', 2, 'N');
INSERT INTO CCD_STD_SVY_NAMES (STD_SVY_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('Walleye Pollock Bering Sea (Bogoslof)/Shelikof/Chirikof Shelf-break (GOA) Pre-spawning Survey', 3, 'N');
INSERT INTO CCD_STD_SVY_NAMES (STD_SVY_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('Walleye Pollock Kenai/PWS (GOA) Pre-spawning survey', 1751, 'N');
INSERT INTO CCD_STD_SVY_NAMES (STD_SVY_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('Walleye Pollock Shumagin/Sanak (GOA) Pre-spawning Survey', 4, 'N');
INSERT INTO CCD_STD_SVY_NAMES (STD_SVY_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('West Coast Groundfish Bottom Trawl', 89, 'N');
INSERT INTO CCD_STD_SVY_NAMES (STD_SVY_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('West Coast Marine Mammal_Fall', 1625, 'N');
INSERT INTO CCD_STD_SVY_NAMES (STD_SVY_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('West Coast Marine Mammal_Winter', 644, 'N');
INSERT INTO CCD_STD_SVY_NAMES (STD_SVY_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('West Coast Pelagic Fish Survey', 2245, 'N');
INSERT INTO CCD_STD_SVY_NAMES (STD_SVY_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('West Coast Rockfish Hook and Line', 93, 'N');
INSERT INTO CCD_STD_SVY_NAMES (STD_SVY_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('West Coast Thresher Shark Longline', 185, 'N');
INSERT INTO CCD_STD_SVY_NAMES (STD_SVY_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('White Abalone Survey', 187, 'N');
INSERT INTO CCD_STD_SVY_NAMES (STD_SVY_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('Yukon Juvenile Chinook', 2117, 'N');
INSERT INTO CCD_STD_SVY_NAMES (STD_SVY_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('test', 2164, 'N');


INSERT INTO CCD_SVY_FREQ (SVY_FREQ_NAME) VALUES ('ANNUAL');
INSERT INTO CCD_SVY_FREQ (SVY_FREQ_NAME) VALUES ('BI-WEEKLY');
INSERT INTO CCD_SVY_FREQ (SVY_FREQ_NAME) VALUES ('BIENNIAL');
INSERT INTO CCD_SVY_FREQ (SVY_FREQ_NAME) VALUES ('DAILY');
INSERT INTO CCD_SVY_FREQ (SVY_FREQ_NAME) VALUES ('INTERMITTENT');
INSERT INTO CCD_SVY_FREQ (SVY_FREQ_NAME) VALUES ('MONTHLY');
INSERT INTO CCD_SVY_FREQ (SVY_FREQ_NAME) VALUES ('QUARTERLY');
INSERT INTO CCD_SVY_FREQ (SVY_FREQ_NAME) VALUES ('SEMI-ANNUAL');
INSERT INTO CCD_SVY_FREQ (SVY_FREQ_NAME) VALUES ('TRIENNIAL');
INSERT INTO CCD_SVY_FREQ (SVY_FREQ_NAME) VALUES ('WEEKLY');

INSERT INTO CCD_SVY_TYPES (SVY_TYPE_NAME) VALUES ('NMFS Survey');
INSERT INTO CCD_SVY_TYPES (SVY_TYPE_NAME) VALUES ('NMFS Partner Survey');



--vessels:
INSERT INTO CCD_VESSELS (VESSEL_NAME, FINSS_ID, VESSEL_DESC, APP_SHOW_OPT_YN) VALUES ('A. E. Verrill', 2137, '', 'N');
INSERT INTO CCD_VESSELS (VESSEL_NAME, FINSS_ID, VESSEL_DESC, APP_SHOW_OPT_YN) VALUES ('Acadiana', 2001, '', 'N');
INSERT INTO CCD_VESSELS (VESSEL_NAME, FINSS_ID, VESSEL_DESC, APP_SHOW_OPT_YN) VALUES ('Achilles inflatable (F1821)', 2110, '', 'N');
INSERT INTO CCD_VESSELS (VESSEL_NAME, FINSS_ID, VESSEL_DESC, APP_SHOW_OPT_YN) VALUES ('Aggressor', 2081, '', 'N');
INSERT INTO CCD_VESSELS (VESSEL_NAME, FINSS_ID, VESSEL_DESC, APP_SHOW_OPT_YN) VALUES ('Ahi', 2200, '', 'N');
INSERT INTO CCD_VESSELS (VESSEL_NAME, FINSS_ID, VESSEL_DESC, APP_SHOW_OPT_YN) VALUES ('Alabama Discovery', 2002, '', 'N');
INSERT INTO CCD_VESSELS (VESSEL_NAME, FINSS_ID, VESSEL_DESC, APP_SHOW_OPT_YN) VALUES ('Alaska Adventurer', 2035, '', 'N');
INSERT INTO CCD_VESSELS (VESSEL_NAME, FINSS_ID, VESSEL_DESC, APP_SHOW_OPT_YN) VALUES ('Alaska Endeavor', 2285, '', 'N');
INSERT INTO CCD_VESSELS (VESSEL_NAME, FINSS_ID, VESSEL_DESC, APP_SHOW_OPT_YN) VALUES ('Alaska Knight', 2036, '', 'N');
INSERT INTO CCD_VESSELS (VESSEL_NAME, FINSS_ID, VESSEL_DESC, APP_SHOW_OPT_YN) VALUES ('Alaska Provider', 2037, '', 'N');
INSERT INTO CCD_VESSELS (VESSEL_NAME, FINSS_ID, VESSEL_DESC, APP_SHOW_OPT_YN) VALUES ('Alaskan', 2038, '', 'N');
INSERT INTO CCD_VESSELS (VESSEL_NAME, FINSS_ID, VESSEL_DESC, APP_SHOW_OPT_YN) VALUES ('Alaskan Enterprise', 2039, '', 'N');
INSERT INTO CCD_VESSELS (VESSEL_NAME, FINSS_ID, VESSEL_DESC, APP_SHOW_OPT_YN) VALUES ('Alaskan Leader', 2040, '', 'N');
INSERT INTO CCD_VESSELS (VESSEL_NAME, FINSS_ID, VESSEL_DESC, APP_SHOW_OPT_YN) VALUES ('Alaskan Legend', 2041, '', 'N');
INSERT INTO CCD_VESSELS (VESSEL_NAME, FINSS_ID, VESSEL_DESC, APP_SHOW_OPT_YN) VALUES ('Albatross IV', 2172, '', 'N');
INSERT INTO CCD_VESSELS (VESSEL_NAME, FINSS_ID, VESSEL_DESC, APP_SHOW_OPT_YN) VALUES ('Aldebaran', 2042, '', 'N');
INSERT INTO CCD_VESSELS (VESSEL_NAME, FINSS_ID, VESSEL_DESC, APP_SHOW_OPT_YN) VALUES ('Aldo Leopold', 2201, '', 'N');
INSERT INTO CCD_VESSELS (VESSEL_NAME, FINSS_ID, VESSEL_DESC, APP_SHOW_OPT_YN) VALUES ('Aleutian Mariner', 2043, '', 'N');
INSERT INTO CCD_VESSELS (VESSEL_NAME, FINSS_ID, VESSEL_DESC, APP_SHOW_OPT_YN) VALUES ('Alexis M', 2138, '', 'N');
INSERT INTO CCD_VESSELS (VESSEL_NAME, FINSS_ID, VESSEL_DESC, APP_SHOW_OPT_YN) VALUES ('Alykrie', 2044, '', 'N');
INSERT INTO CCD_VESSELS (VESSEL_NAME, FINSS_ID, VESSEL_DESC, APP_SHOW_OPT_YN) VALUES ('Anchor Point', 2281, '', 'N');
INSERT INTO CCD_VESSELS (VESSEL_NAME, FINSS_ID, VESSEL_DESC, APP_SHOW_OPT_YN) VALUES ('Anna Maria', 2202, '', 'N');
INSERT INTO CCD_VESSELS (VESSEL_NAME, FINSS_ID, VESSEL_DESC, APP_SHOW_OPT_YN) VALUES ('Annika Marie', 2280, '', 'N');
INSERT INTO CCD_VESSELS (VESSEL_NAME, FINSS_ID, VESSEL_DESC, APP_SHOW_OPT_YN) VALUES ('Antares', 2045, '', 'N');
INSERT INTO CCD_VESSELS (VESSEL_NAME, FINSS_ID, VESSEL_DESC, APP_SHOW_OPT_YN) VALUES ('Apalachee', 2003, '', 'N');
INSERT INTO CCD_VESSELS (VESSEL_NAME, FINSS_ID, VESSEL_DESC, APP_SHOW_OPT_YN) VALUES ('Aquila', 2046, '', 'N');
INSERT INTO CCD_VESSELS (VESSEL_NAME, FINSS_ID, VESSEL_DESC, APP_SHOW_OPT_YN) VALUES ('Arcturus', 2047, '', 'N');
INSERT INTO CCD_VESSELS (VESSEL_NAME, FINSS_ID, VESSEL_DESC, APP_SHOW_OPT_YN) VALUES ('Artemus', 2048, '', 'N');
INSERT INTO CCD_VESSELS (VESSEL_NAME, FINSS_ID, VESSEL_DESC, APP_SHOW_OPT_YN) VALUES ('Atlantis', 2187, '', 'N');
INSERT INTO CCD_VESSELS (VESSEL_NAME, FINSS_ID, VESSEL_DESC, APP_SHOW_OPT_YN) VALUES ('Auklet', 2049, '', 'N');
INSERT INTO CCD_VESSELS (VESSEL_NAME, FINSS_ID, VESSEL_DESC, APP_SHOW_OPT_YN) VALUES ('Avon (F1728)', 2203, '', 'N');
INSERT INTO CCD_VESSELS (VESSEL_NAME, FINSS_ID, VESSEL_DESC, APP_SHOW_OPT_YN) VALUES ('Avon (F1740)', 2204, '', 'N');
INSERT INTO CCD_VESSELS (VESSEL_NAME, FINSS_ID, VESSEL_DESC, APP_SHOW_OPT_YN) VALUES ('Avon (F1753)', 2205, '', 'N');
INSERT INTO CCD_VESSELS (VESSEL_NAME, FINSS_ID, VESSEL_DESC, APP_SHOW_OPT_YN) VALUES ('Avon (F1754)', 2206, '', 'N');
INSERT INTO CCD_VESSELS (VESSEL_NAME, FINSS_ID, VESSEL_DESC, APP_SHOW_OPT_YN) VALUES ('Avon (F1755)', 2207, '', 'N');
INSERT INTO CCD_VESSELS (VESSEL_NAME, FINSS_ID, VESSEL_DESC, APP_SHOW_OPT_YN) VALUES ('BJ Thomas', 2096, '', 'N');
INSERT INTO CCD_VESSELS (VESSEL_NAME, FINSS_ID, VESSEL_DESC, APP_SHOW_OPT_YN) VALUES ('Bat98467', 2111, '', 'N');
INSERT INTO CCD_VESSELS (VESSEL_NAME, FINSS_ID, VESSEL_DESC, APP_SHOW_OPT_YN) VALUES ('Bay Shark 21''', 2139, '', 'N');
INSERT INTO CCD_VESSELS (VESSEL_NAME, FINSS_ID, VESSEL_DESC, APP_SHOW_OPT_YN) VALUES ('Beau Rivage', 2140, '', 'N');
INSERT INTO CCD_VESSELS (VESSEL_NAME, FINSS_ID, VESSEL_DESC, APP_SHOW_OPT_YN) VALUES ('Bell M. Shimada', 2173, '', 'N');
INSERT INTO CCD_VESSELS (VESSEL_NAME, FINSS_ID, VESSEL_DESC, APP_SHOW_OPT_YN) VALUES ('Big Mel', 2050, '', 'N');
INSERT INTO CCD_VESSELS (VESSEL_NAME, FINSS_ID, VESSEL_DESC, APP_SHOW_OPT_YN) VALUES ('Big Valley', 2051, '', 'N');
INSERT INTO CCD_VESSELS (VESSEL_NAME, FINSS_ID, VESSEL_DESC, APP_SHOW_OPT_YN) VALUES ('BlackJack IV', 2141, '', 'N');
INSERT INTO CCD_VESSELS (VESSEL_NAME, FINSS_ID, VESSEL_DESC, APP_SHOW_OPT_YN) VALUES ('Blazing Seven', 2004, '', 'N');
INSERT INTO CCD_VESSELS (VESSEL_NAME, FINSS_ID, VESSEL_DESC, APP_SHOW_OPT_YN) VALUES ('Bold Horizon', 2153, '', 'N');
INSERT INTO CCD_VESSELS (VESSEL_NAME, FINSS_ID, VESSEL_DESC, APP_SHOW_OPT_YN) VALUES ('Bonavista II', 2112, '', 'N');
INSERT INTO CCD_VESSELS (VESSEL_NAME, FINSS_ID, VESSEL_DESC, APP_SHOW_OPT_YN) VALUES ('Boston Whaler', 2005, '', 'N');
INSERT INTO CCD_VESSELS (VESSEL_NAME, FINSS_ID, VESSEL_DESC, APP_SHOW_OPT_YN) VALUES ('Bristol Explorer', 2052, '', 'N');
INSERT INTO CCD_VESSELS (VESSEL_NAME, FINSS_ID, VESSEL_DESC, APP_SHOW_OPT_YN) VALUES ('Bristol Mariner', 2053, '', 'N');
INSERT INTO CCD_VESSELS (VESSEL_NAME, FINSS_ID, VESSEL_DESC, APP_SHOW_OPT_YN) VALUES ('CTS', 2154, '', 'N');
INSERT INTO CCD_VESSELS (VESSEL_NAME, FINSS_ID, VESSEL_DESC, APP_SHOW_OPT_YN) VALUES ('Cape Flattery', 2054, '', 'N');
INSERT INTO CCD_VESSELS (VESSEL_NAME, FINSS_ID, VESSEL_DESC, APP_SHOW_OPT_YN) VALUES ('Cape Horn', 2055, '', 'N');
INSERT INTO CCD_VESSELS (VESSEL_NAME, FINSS_ID, VESSEL_DESC, APP_SHOW_OPT_YN) VALUES ('Caretta', 2208, '', 'N');
INSERT INTO CCD_VESSELS (VESSEL_NAME, FINSS_ID, VESSEL_DESC, APP_SHOW_OPT_YN) VALUES ('Carolina Coast', 2006, '', 'N');
INSERT INTO CCD_VESSELS (VESSEL_NAME, FINSS_ID, VESSEL_DESC, APP_SHOW_OPT_YN) VALUES ('Cassandra Ann', 2155, '', 'N');
INSERT INTO CCD_VESSELS (VESSEL_NAME, FINSS_ID, VESSEL_DESC, APP_SHOW_OPT_YN) VALUES ('Copono Bay', 2007, '', 'N');
INSERT INTO CCD_VESSELS (VESSEL_NAME, FINSS_ID, VESSEL_DESC, APP_SHOW_OPT_YN) VALUES ('Coral Reef II', 2142, '', 'N');
INSERT INTO CCD_VESSELS (VESSEL_NAME, FINSS_ID, VESSEL_DESC, APP_SHOW_OPT_YN) VALUES ('Coral Sea', 2156, '', 'N');
INSERT INTO CCD_VESSELS (VESSEL_NAME, FINSS_ID, VESSEL_DESC, APP_SHOW_OPT_YN) VALUES ('Curlew', 2056, '', 'N');
INSERT INTO CCD_VESSELS (VESSEL_NAME, FINSS_ID, VESSEL_DESC, APP_SHOW_OPT_YN) VALUES ('DAWR 13''', 2008, '', 'N');
INSERT INTO CCD_VESSELS (VESSEL_NAME, FINSS_ID, VESSEL_DESC, APP_SHOW_OPT_YN) VALUES ('DAWR 15'' ', 2009, '', 'N');
INSERT INTO CCD_VESSELS (VESSEL_NAME, FINSS_ID, VESSEL_DESC, APP_SHOW_OPT_YN) VALUES ('DAWR 21''', 2010, '', 'N');
INSERT INTO CCD_VESSELS (VESSEL_NAME, FINSS_ID, VESSEL_DESC, APP_SHOW_OPT_YN) VALUES ('DFW 13''', 2011, '', 'N');
INSERT INTO CCD_VESSELS (VESSEL_NAME, FINSS_ID, VESSEL_DESC, APP_SHOW_OPT_YN) VALUES ('David Starr Jordan', 2174, '', 'N');
INSERT INTO CCD_VESSELS (VESSEL_NAME, FINSS_ID, VESSEL_DESC, APP_SHOW_OPT_YN) VALUES ('Daytona', 2143, '', 'N');
INSERT INTO CCD_VESSELS (VESSEL_NAME, FINSS_ID, VESSEL_DESC, APP_SHOW_OPT_YN) VALUES ('Defender', 2209, '', 'N');
INSERT INTO CCD_VESSELS (VESSEL_NAME, FINSS_ID, VESSEL_DESC, APP_SHOW_OPT_YN) VALUES ('Delaware II', 2175, '', 'N');
INSERT INTO CCD_VESSELS (VESSEL_NAME, FINSS_ID, VESSEL_DESC, APP_SHOW_OPT_YN) VALUES ('Don Christopher', 2157, '', 'N');
INSERT INTO CCD_VESSELS (VESSEL_NAME, FINSS_ID, VESSEL_DESC, APP_SHOW_OPT_YN) VALUES ('Double Barrel', 2113, '', 'N');
INSERT INTO CCD_VESSELS (VESSEL_NAME, FINSS_ID, VESSEL_DESC, APP_SHOW_OPT_YN) VALUES ('E.O.Wilson', 2012, '', 'N');
INSERT INTO CCD_VESSELS (VESSEL_NAME, FINSS_ID, VESSEL_DESC, APP_SHOW_OPT_YN) VALUES ('ESS Pursuit ', 2082, '', 'N');
INSERT INTO CCD_VESSELS (VESSEL_NAME, FINSS_ID, VESSEL_DESC, APP_SHOW_OPT_YN) VALUES ('Eagle Eye II', 2083, '', 'N');
INSERT INTO CCD_VESSELS (VESSEL_NAME, FINSS_ID, VESSEL_DESC, APP_SHOW_OPT_YN) VALUES ('Elakha ', 2013, '', 'N');
INSERT INTO CCD_VESSELS (VESSEL_NAME, FINSS_ID, VESSEL_DESC, APP_SHOW_OPT_YN) VALUES ('Endeavor', 2084, '', 'N');
INSERT INTO CCD_VESSELS (VESSEL_NAME, FINSS_ID, VESSEL_DESC, APP_SHOW_OPT_YN) VALUES ('Endurance', 2085, '', 'N');
INSERT INTO CCD_VESSELS (VESSEL_NAME, FINSS_ID, VESSEL_DESC, APP_SHOW_OPT_YN) VALUES ('Excalibur', 2097, '', 'N');
INSERT INTO CCD_VESSELS (VESSEL_NAME, FINSS_ID, VESSEL_DESC, APP_SHOW_OPT_YN) VALUES ('Fairweather', 2032, '', 'N');
INSERT INTO CCD_VESSELS (VESSEL_NAME, FINSS_ID, VESSEL_DESC, APP_SHOW_OPT_YN) VALUES ('Falkor', 2114, '', 'N');
INSERT INTO CCD_VESSELS (VESSEL_NAME, FINSS_ID, VESSEL_DESC, APP_SHOW_OPT_YN) VALUES ('Ferdinand R. Hassler', 2033, '', 'N');
INSERT INTO CCD_VESSELS (VESSEL_NAME, FINSS_ID, VESSEL_DESC, APP_SHOW_OPT_YN) VALUES ('Freedom Star', 2144, '', 'N');
INSERT INTO CCD_VESSELS (VESSEL_NAME, FINSS_ID, VESSEL_DESC, APP_SHOW_OPT_YN) VALUES ('Frosti', 2098, '', 'N');
INSERT INTO CCD_VESSELS (VESSEL_NAME, FINSS_ID, VESSEL_DESC, APP_SHOW_OPT_YN) VALUES ('Gandy', 2210, '', 'N');
INSERT INTO CCD_VESSELS (VESSEL_NAME, FINSS_ID, VESSEL_DESC, APP_SHOW_OPT_YN) VALUES ('Gladiator', 2057, '', 'N');
INSERT INTO CCD_VESSELS (VESSEL_NAME, FINSS_ID, VESSEL_DESC, APP_SHOW_OPT_YN) VALUES ('Gloria Michelle', 2176, '', 'N');
INSERT INTO CCD_VESSELS (VESSEL_NAME, FINSS_ID, VESSEL_DESC, APP_SHOW_OPT_YN) VALUES ('Gold Rush', 2282, '', 'N');
INSERT INTO CCD_VESSELS (VESSEL_NAME, FINSS_ID, VESSEL_DESC, APP_SHOW_OPT_YN) VALUES ('Gordon Gunter', 2177, '', 'N');
INSERT INTO CCD_VESSELS (VESSEL_NAME, FINSS_ID, VESSEL_DESC, APP_SHOW_OPT_YN) VALUES ('Gordon Sproul', 2188, '', 'N');
INSERT INTO CCD_VESSELS (VESSEL_NAME, FINSS_ID, VESSEL_DESC, APP_SHOW_OPT_YN) VALUES ('Great Pacific', 2284, '', 'N');
INSERT INTO CCD_VESSELS (VESSEL_NAME, FINSS_ID, VESSEL_DESC, APP_SHOW_OPT_YN) VALUES ('Gulf Search', 2145, '', 'N');
INSERT INTO CCD_VESSELS (VESSEL_NAME, FINSS_ID, VESSEL_DESC, APP_SHOW_OPT_YN) VALUES ('Gulfstream III', 2146, '', 'N');
INSERT INTO CCD_VESSELS (VESSEL_NAME, FINSS_ID, VESSEL_DESC, APP_SHOW_OPT_YN) VALUES ('HST', 2211, '', 'N');
INSERT INTO CCD_VESSELS (VESSEL_NAME, FINSS_ID, VESSEL_DESC, APP_SHOW_OPT_YN) VALUES ('Harold B.', 2212, '', 'N');
INSERT INTO CCD_VESSELS (VESSEL_NAME, FINSS_ID, VESSEL_DESC, APP_SHOW_OPT_YN) VALUES ('Harold Streeter', 2213, '', 'N');
INSERT INTO CCD_VESSELS (VESSEL_NAME, FINSS_ID, VESSEL_DESC, APP_SHOW_OPT_YN) VALUES ('Heather Lynn', 2086, '', 'N');
INSERT INTO CCD_VESSELS (VESSEL_NAME, FINSS_ID, VESSEL_DESC, APP_SHOW_OPT_YN) VALUES ('Henry B. Bigelow', 2178, '', 'N');
INSERT INTO CCD_VESSELS (VESSEL_NAME, FINSS_ID, VESSEL_DESC, APP_SHOW_OPT_YN) VALUES ('Hera', 2087, '', 'N');
INSERT INTO CCD_VESSELS (VESSEL_NAME, FINSS_ID, VESSEL_DESC, APP_SHOW_OPT_YN) VALUES ('Hi''ialakai', 2179, '', 'Y');
INSERT INTO CCD_VESSELS (VESSEL_NAME, FINSS_ID, VESSEL_DESC, APP_SHOW_OPT_YN) VALUES ('Hihimanu', 2115, '', 'N');
INSERT INTO CCD_VESSELS (VESSEL_NAME, FINSS_ID, VESSEL_DESC, APP_SHOW_OPT_YN) VALUES ('Honua', 2116, '', 'N');
INSERT INTO CCD_VESSELS (VESSEL_NAME, FINSS_ID, VESSEL_DESC, APP_SHOW_OPT_YN) VALUES ('Hugh R. Sharp', 2189, '', 'N');
INSERT INTO CCD_VESSELS (VESSEL_NAME, FINSS_ID, VESSEL_DESC, APP_SHOW_OPT_YN) VALUES ('Huki Pono', 2014, '', 'N');
INSERT INTO CCD_VESSELS (VESSEL_NAME, FINSS_ID, VESSEL_DESC, APP_SHOW_OPT_YN) VALUES ('Ighty Max', 2117, '', 'N');
INSERT INTO CCD_VESSELS (VESSEL_NAME, FINSS_ID, VESSEL_DESC, APP_SHOW_OPT_YN) VALUES ('Imua', 2380, '', 'N');
INSERT INTO CCD_VESSELS (VESSEL_NAME, FINSS_ID, VESSEL_DESC, APP_SHOW_OPT_YN) VALUES ('Ipuk', 2058, '', 'N');
INSERT INTO CCD_VESSELS (VESSEL_NAME, FINSS_ID, VESSEL_DESC, APP_SHOW_OPT_YN) VALUES ('Iron House ', 2088, '', 'N');
INSERT INTO CCD_VESSELS (VESSEL_NAME, FINSS_ID, VESSEL_DESC, APP_SHOW_OPT_YN) VALUES ('Island C', 2059, '', 'N');
INSERT INTO CCD_VESSELS (VESSEL_NAME, FINSS_ID, VESSEL_DESC, APP_SHOW_OPT_YN) VALUES ('John N. Cobb', 2180, '', 'N');
INSERT INTO CCD_VESSELS (VESSEL_NAME, FINSS_ID, VESSEL_DESC, APP_SHOW_OPT_YN) VALUES ('Kahana', 2118, '', 'N');
INSERT INTO CCD_VESSELS (VESSEL_NAME, FINSS_ID, VESSEL_DESC, APP_SHOW_OPT_YN) VALUES ('Karen Elizabeth ', 2089, '', 'N');
INSERT INTO CCD_VESSELS (VESSEL_NAME, FINSS_ID, VESSEL_DESC, APP_SHOW_OPT_YN) VALUES ('Katy Mary', 2119, '', 'N');
INSERT INTO CCD_VESSELS (VESSEL_NAME, FINSS_ID, VESSEL_DESC, APP_SHOW_OPT_YN) VALUES ('Kilo Moana', 2190, '', 'N');
INSERT INTO CCD_VESSELS (VESSEL_NAME, FINSS_ID, VESSEL_DESC, APP_SHOW_OPT_YN) VALUES ('Kohola R 3606/11m Ambar', 2120, '', 'N');
INSERT INTO CCD_VESSELS (VESSEL_NAME, FINSS_ID, VESSEL_DESC, APP_SHOW_OPT_YN) VALUES ('Kokua Kai', 2121, '', 'N');
INSERT INTO CCD_VESSELS (VESSEL_NAME, FINSS_ID, VESSEL_DESC, APP_SHOW_OPT_YN) VALUES ('Kumu', 2214, '', 'N');
INSERT INTO CCD_VESSELS (VESSEL_NAME, FINSS_ID, VESSEL_DESC, APP_SHOW_OPT_YN) VALUES ('Kuna', 2158, '', 'N');
INSERT INTO CCD_VESSELS (VESSEL_NAME, FINSS_ID, VESSEL_DESC, APP_SHOW_OPT_YN) VALUES ('La Mer', 2159, '', 'N');
INSERT INTO CCD_VESSELS (VESSEL_NAME, FINSS_ID, VESSEL_DESC, APP_SHOW_OPT_YN) VALUES ('Lady Gundy', 2283, '', 'N');
INSERT INTO CCD_VESSELS (VESSEL_NAME, FINSS_ID, VESSEL_DESC, APP_SHOW_OPT_YN) VALUES ('Lady Law', 2099, '', 'N');
INSERT INTO CCD_VESSELS (VESSEL_NAME, FINSS_ID, VESSEL_DESC, APP_SHOW_OPT_YN) VALUES ('Lady Lisa', 2015, '', 'N');
INSERT INTO CCD_VESSELS (VESSEL_NAME, FINSS_ID, VESSEL_DESC, APP_SHOW_OPT_YN) VALUES ('Last Straw', 2100, '', 'N');
INSERT INTO CCD_VESSELS (VESSEL_NAME, FINSS_ID, VESSEL_DESC, APP_SHOW_OPT_YN) VALUES ('Liberty Star', 2147, '', 'N');
INSERT INTO CCD_VESSELS (VESSEL_NAME, FINSS_ID, VESSEL_DESC, APP_SHOW_OPT_YN) VALUES ('Lucky Strike', 2122, '', 'N');
INSERT INTO CCD_VESSELS (VESSEL_NAME, FINSS_ID, VESSEL_DESC, APP_SHOW_OPT_YN) VALUES ('Lumcon Pelican', 2016, '', 'N');
INSERT INTO CCD_VESSELS (VESSEL_NAME, FINSS_ID, VESSEL_DESC, APP_SHOW_OPT_YN) VALUES ('Manuma', 2017, '', 'N');
INSERT INTO CCD_VESSELS (VESSEL_NAME, FINSS_ID, VESSEL_DESC, APP_SHOW_OPT_YN) VALUES ('Marguerite', 2018, '', 'N');
INSERT INTO CCD_VESSELS (VESSEL_NAME, FINSS_ID, VESSEL_DESC, APP_SHOW_OPT_YN) VALUES ('Marie M', 2123, '', 'N');
INSERT INTO CCD_VESSELS (VESSEL_NAME, FINSS_ID, VESSEL_DESC, APP_SHOW_OPT_YN) VALUES ('Mary Elena', 2090, '', 'N');
INSERT INTO CCD_VESSELS (VESSEL_NAME, FINSS_ID, VESSEL_DESC, APP_SHOW_OPT_YN) VALUES ('Mary Elizabeth', 2259, '', 'N');
INSERT INTO CCD_VESSELS (VESSEL_NAME, FINSS_ID, VESSEL_DESC, APP_SHOW_OPT_YN) VALUES ('Mary K', 2091, '', 'N');
INSERT INTO CCD_VESSELS (VESSEL_NAME, FINSS_ID, VESSEL_DESC, APP_SHOW_OPT_YN) VALUES ('McArthur II', 2170, '', 'N');
INSERT INTO CCD_VESSELS (VESSEL_NAME, FINSS_ID, VESSEL_DESC, APP_SHOW_OPT_YN) VALUES ('Medeia', 2019, '', 'N');
INSERT INTO CCD_VESSELS (VESSEL_NAME, FINSS_ID, VESSEL_DESC, APP_SHOW_OPT_YN) VALUES ('Melville', 2191, '', 'N');
INSERT INTO CCD_VESSELS (VESSEL_NAME, FINSS_ID, VESSEL_DESC, APP_SHOW_OPT_YN) VALUES ('Metacomet', 2092, '', 'N');
INSERT INTO CCD_VESSELS (VESSEL_NAME, FINSS_ID, VESSEL_DESC, APP_SHOW_OPT_YN) VALUES ('Miller', 2215, '', 'N');
INSERT INTO CCD_VESSELS (VESSEL_NAME, FINSS_ID, VESSEL_DESC, APP_SHOW_OPT_YN) VALUES ('Miller Freeman', 2181, '', 'N');
INSERT INTO CCD_VESSELS (VESSEL_NAME, FINSS_ID, VESSEL_DESC, APP_SHOW_OPT_YN) VALUES ('Mini Max', 2124, '', 'N');
INSERT INTO CCD_VESSELS (VESSEL_NAME, FINSS_ID, VESSEL_DESC, APP_SHOW_OPT_YN) VALUES ('Mirage', 2101, '', 'N');
INSERT INTO CCD_VESSELS (VESSEL_NAME, FINSS_ID, VESSEL_DESC, APP_SHOW_OPT_YN) VALUES ('Miriam', 2216, '', 'N');
INSERT INTO CCD_VESSELS (VESSEL_NAME, FINSS_ID, VESSEL_DESC, APP_SHOW_OPT_YN) VALUES ('Miss Alyssa', 2279, '', 'N');
INSERT INTO CCD_VESSELS (VESSEL_NAME, FINSS_ID, VESSEL_DESC, APP_SHOW_OPT_YN) VALUES ('Miss Linda', 2102, '', 'N');
INSERT INTO CCD_VESSELS (VESSEL_NAME, FINSS_ID, VESSEL_DESC, APP_SHOW_OPT_YN) VALUES ('Miss Sue', 2103, '', 'N');
INSERT INTO CCD_VESSELS (VESSEL_NAME, FINSS_ID, VESSEL_DESC, APP_SHOW_OPT_YN) VALUES ('Moana Wave', 2160, '', 'N');
INSERT INTO CCD_VESSELS (VESSEL_NAME, FINSS_ID, VESSEL_DESC, APP_SHOW_OPT_YN) VALUES ('Mokarran (F2504)', 2217, '', 'N');
INSERT INTO CCD_VESSELS (VESSEL_NAME, FINSS_ID, VESSEL_DESC, APP_SHOW_OPT_YN) VALUES ('Moragh K', 2093, '', 'N');
INSERT INTO CCD_VESSELS (VESSEL_NAME, FINSS_ID, VESSEL_DESC, APP_SHOW_OPT_YN) VALUES ('Ms. Julie', 2104, '', 'N');
INSERT INTO CCD_VESSELS (VESSEL_NAME, FINSS_ID, VESSEL_DESC, APP_SHOW_OPT_YN) VALUES ('Muir Milach', 2060, '', 'N');
INSERT INTO CCD_VESSELS (VESSEL_NAME, FINSS_ID, VESSEL_DESC, APP_SHOW_OPT_YN) VALUES ('Mythos', 2061, '', 'N');
INSERT INTO CCD_VESSELS (VESSEL_NAME, FINSS_ID, VESSEL_DESC, APP_SHOW_OPT_YN) VALUES ('Nancy Foster', 2171, '', 'N');
INSERT INTO CCD_VESSELS (VESSEL_NAME, FINSS_ID, VESSEL_DESC, APP_SHOW_OPT_YN) VALUES ('Nathaniel Palmer', 2161, '', 'N');
INSERT INTO CCD_VESSELS (VESSEL_NAME, FINSS_ID, VESSEL_DESC, APP_SHOW_OPT_YN) VALUES ('New Horizon', 2192, '', 'N');
INSERT INTO CCD_VESSELS (VESSEL_NAME, FINSS_ID, VESSEL_DESC, APP_SHOW_OPT_YN) VALUES ('Noahs Ark', 2105, '', 'N');
INSERT INTO CCD_VESSELS (VESSEL_NAME, FINSS_ID, VESSEL_DESC, APP_SHOW_OPT_YN) VALUES ('Norseman', 2062, '', 'N');
INSERT INTO CCD_VESSELS (VESSEL_NAME, FINSS_ID, VESSEL_DESC, APP_SHOW_OPT_YN) VALUES ('Norseman II', 2063, '', 'N');
INSERT INTO CCD_VESSELS (VESSEL_NAME, FINSS_ID, VESSEL_DESC, APP_SHOW_OPT_YN) VALUES ('Northwest Explorer', 2064, '', 'N');
INSERT INTO CCD_VESSELS (VESSEL_NAME, FINSS_ID, VESSEL_DESC, APP_SHOW_OPT_YN) VALUES ('Nueces', 2020, '', 'N');
INSERT INTO CCD_VESSELS (VESSEL_NAME, FINSS_ID, VESSEL_DESC, APP_SHOW_OPT_YN) VALUES ('OLE 23''', 2021, '', 'N');
INSERT INTO CCD_VESSELS (VESSEL_NAME, FINSS_ID, VESSEL_DESC, APP_SHOW_OPT_YN) VALUES ('Ocean Explorer', 2065, '', 'N');
INSERT INTO CCD_VESSELS (VESSEL_NAME, FINSS_ID, VESSEL_DESC, APP_SHOW_OPT_YN) VALUES ('Ocean Masta', 2125, '', 'N');
INSERT INTO CCD_VESSELS (VESSEL_NAME, FINSS_ID, VESSEL_DESC, APP_SHOW_OPT_YN) VALUES ('Ocean Olympic', 2066, '', 'N');
INSERT INTO CCD_VESSELS (VESSEL_NAME, FINSS_ID, VESSEL_DESC, APP_SHOW_OPT_YN) VALUES ('Ocean Prowler', 2067, '', 'N');
INSERT INTO CCD_VESSELS (VESSEL_NAME, FINSS_ID, VESSEL_DESC, APP_SHOW_OPT_YN) VALUES ('Ocean Starr', 2162, '', 'N');
INSERT INTO CCD_VESSELS (VESSEL_NAME, FINSS_ID, VESSEL_DESC, APP_SHOW_OPT_YN) VALUES ('Okeanos Explorer', 2319, '', 'N');
INSERT INTO CCD_VESSELS (VESSEL_NAME, FINSS_ID, VESSEL_DESC, APP_SHOW_OPT_YN) VALUES ('Ono', 2218, '', 'N');
INSERT INTO CCD_VESSELS (VESSEL_NAME, FINSS_ID, VESSEL_DESC, APP_SHOW_OPT_YN) VALUES ('Orca Too', 2148, '', 'N');
INSERT INTO CCD_VESSELS (VESSEL_NAME, FINSS_ID, VESSEL_DESC, APP_SHOW_OPT_YN) VALUES ('Oregon II', 2182, '', 'N');
INSERT INTO CCD_VESSELS (VESSEL_NAME, FINSS_ID, VESSEL_DESC, APP_SHOW_OPT_YN) VALUES ('Oscar Dyson', 2183, '', 'N');
INSERT INTO CCD_VESSELS (VESSEL_NAME, FINSS_ID, VESSEL_DESC, APP_SHOW_OPT_YN) VALUES ('Oscar Elton Sette', 2184, '', 'Y');
INSERT INTO CCD_VESSELS (VESSEL_NAME, FINSS_ID, VESSEL_DESC, APP_SHOW_OPT_YN) VALUES ('Outer Banks', 2163, '', 'N');
INSERT INTO CCD_VESSELS (VESSEL_NAME, FINSS_ID, VESSEL_DESC, APP_SHOW_OPT_YN) VALUES ('Outer Limits', 2164, '', 'N');
INSERT INTO CCD_VESSELS (VESSEL_NAME, FINSS_ID, VESSEL_DESC, APP_SHOW_OPT_YN) VALUES ('PIFG fishing boats', 2399, '', 'N');
INSERT INTO CCD_VESSELS (VESSEL_NAME, FINSS_ID, VESSEL_DESC, APP_SHOW_OPT_YN) VALUES ('PISCES', 2185, '', 'N');
INSERT INTO CCD_VESSELS (VESSEL_NAME, FINSS_ID, VESSEL_DESC, APP_SHOW_OPT_YN) VALUES ('Pacific Explorer', 2068, '', 'N');
INSERT INTO CCD_VESSELS (VESSEL_NAME, FINSS_ID, VESSEL_DESC, APP_SHOW_OPT_YN) VALUES ('Pacific Fisher', 2069, '', 'N');
INSERT INTO CCD_VESSELS (VESSEL_NAME, FINSS_ID, VESSEL_DESC, APP_SHOW_OPT_YN) VALUES ('Pacific Storm', 2106, '', 'N');
INSERT INTO CCD_VESSELS (VESSEL_NAME, FINSS_ID, VESSEL_DESC, APP_SHOW_OPT_YN) VALUES ('Palmetto', 2022, '', 'N');
INSERT INTO CCD_VESSELS (VESSEL_NAME, FINSS_ID, VESSEL_DESC, APP_SHOW_OPT_YN) VALUES ('Panga', 2126, '', 'N');
INSERT INTO CCD_VESSELS (VESSEL_NAME, FINSS_ID, VESSEL_DESC, APP_SHOW_OPT_YN) VALUES ('Pelican', 2193, '', 'N');
INSERT INTO CCD_VESSELS (VESSEL_NAME, FINSS_ID, VESSEL_DESC, APP_SHOW_OPT_YN) VALUES ('Piky', 2107, '', 'N');
INSERT INTO CCD_VESSELS (VESSEL_NAME, FINSS_ID, VESSEL_DESC, APP_SHOW_OPT_YN) VALUES ('Planet Dive 2', 2127, '', 'N');
INSERT INTO CCD_VESSELS (VESSEL_NAME, FINSS_ID, VESSEL_DESC, APP_SHOW_OPT_YN) VALUES ('Point Sur', 2194, '', 'N');
INSERT INTO CCD_VESSELS (VESSEL_NAME, FINSS_ID, VESSEL_DESC, APP_SHOW_OPT_YN) VALUES ('Polar 20''', 2219, '', 'N');
INSERT INTO CCD_VESSELS (VESSEL_NAME, FINSS_ID, VESSEL_DESC, APP_SHOW_OPT_YN) VALUES ('Pristis (F2116)', 2220, '', 'N');
INSERT INTO CCD_VESSELS (VESSEL_NAME, FINSS_ID, VESSEL_DESC, APP_SHOW_OPT_YN) VALUES ('Proline', 2128, '', 'N');
INSERT INTO CCD_VESSELS (VESSEL_NAME, FINSS_ID, VESSEL_DESC, APP_SHOW_OPT_YN) VALUES ('PropheSea', 2070, '', 'N');
INSERT INTO CCD_VESSELS (VESSEL_NAME, FINSS_ID, VESSEL_DESC, APP_SHOW_OPT_YN) VALUES ('Quest', 2195, '', 'N');
INSERT INTO CCD_VESSELS (VESSEL_NAME, FINSS_ID, VESSEL_DESC, APP_SHOW_OPT_YN) VALUES ('R/V Gloria Michelle', 2359, '', 'N');
INSERT INTO CCD_VESSELS (VESSEL_NAME, FINSS_ID, VESSEL_DESC, APP_SHOW_OPT_YN) VALUES ('R/V Ocean Starr', 2339, '', 'N');
INSERT INTO CCD_VESSELS (VESSEL_NAME, FINSS_ID, VESSEL_DESC, APP_SHOW_OPT_YN) VALUES ('RJ Kemp', 2023, '', 'N');
INSERT INTO CCD_VESSELS (VESSEL_NAME, FINSS_ID, VESSEL_DESC, APP_SHOW_OPT_YN) VALUES ('Radon 34''', 2129, '', 'N');
INSERT INTO CCD_VESSELS (VESSEL_NAME, FINSS_ID, VESSEL_DESC, APP_SHOW_OPT_YN) VALUES ('Rainier', 2379, '', 'N');
INSERT INTO CCD_VESSELS (VESSEL_NAME, FINSS_ID, VESSEL_DESC, APP_SHOW_OPT_YN) VALUES ('Raven', 2108, '', 'N');
INSERT INTO CCD_VESSELS (VESSEL_NAME, FINSS_ID, VESSEL_DESC, APP_SHOW_OPT_YN) VALUES ('Regulator', 2130, '', 'N');
INSERT INTO CCD_VESSELS (VESSEL_NAME, FINSS_ID, VESSEL_DESC, APP_SHOW_OPT_YN) VALUES ('Resolution', 2024, '', 'N');
INSERT INTO CCD_VESSELS (VESSEL_NAME, FINSS_ID, VESSEL_DESC, APP_SHOW_OPT_YN) VALUES ('Reuben Lasker', 2186, '', 'Y');
INSERT INTO CCD_VESSELS (VESSEL_NAME, FINSS_ID, VESSEL_DESC, APP_SHOW_OPT_YN) VALUES ('Roger Revelle', 2196, '', 'N');
INSERT INTO CCD_VESSELS (VESSEL_NAME, FINSS_ID, VESSEL_DESC, APP_SHOW_OPT_YN) VALUES ('Rubber Duck', 2221, '', 'N');
INSERT INTO CCD_VESSELS (VESSEL_NAME, FINSS_ID, VESSEL_DESC, APP_SHOW_OPT_YN) VALUES ('Sabine Lake', 2025, '', 'N');
INSERT INTO CCD_VESSELS (VESSEL_NAME, FINSS_ID, VESSEL_DESC, APP_SHOW_OPT_YN) VALUES ('Safe Boat (F1907)', 2222, '', 'N');
INSERT INTO CCD_VESSELS (VESSEL_NAME, FINSS_ID, VESSEL_DESC, APP_SHOW_OPT_YN) VALUES ('Sally Ride', 2239, '', 'N');
INSERT INTO CCD_VESSELS (VESSEL_NAME, FINSS_ID, VESSEL_DESC, APP_SHOW_OPT_YN) VALUES ('Samson', 2165, '', 'N');
INSERT INTO CCD_VESSELS (VESSEL_NAME, FINSS_ID, VESSEL_DESC, APP_SHOW_OPT_YN) VALUES ('San Antonio Bay', 2026, '', 'N');
INSERT INTO CCD_VESSELS (VESSEL_NAME, FINSS_ID, VESSEL_DESC, APP_SHOW_OPT_YN) VALUES ('San Jacinto', 2027, '', 'N');
INSERT INTO CCD_VESSELS (VESSEL_NAME, FINSS_ID, VESSEL_DESC, APP_SHOW_OPT_YN) VALUES ('Savage', 2071, '', 'N');
INSERT INTO CCD_VESSELS (VESSEL_NAME, FINSS_ID, VESSEL_DESC, APP_SHOW_OPT_YN) VALUES ('Savannah', 2197, '', 'N');
INSERT INTO CCD_VESSELS (VESSEL_NAME, FINSS_ID, VESSEL_DESC, APP_SHOW_OPT_YN) VALUES ('Sea Hunt', 2131, '', 'N');
INSERT INTO CCD_VESSELS (VESSEL_NAME, FINSS_ID, VESSEL_DESC, APP_SHOW_OPT_YN) VALUES ('Sea Spinner', 2132, '', 'N');
INSERT INTO CCD_VESSELS (VESSEL_NAME, FINSS_ID, VESSEL_DESC, APP_SHOW_OPT_YN) VALUES ('Sea Storm', 2072, '', 'N');
INSERT INTO CCD_VESSELS (VESSEL_NAME, FINSS_ID, VESSEL_DESC, APP_SHOW_OPT_YN) VALUES ('Sea Wolf', 2073, '', 'N');
INSERT INTO CCD_VESSELS (VESSEL_NAME, FINSS_ID, VESSEL_DESC, APP_SHOW_OPT_YN) VALUES ('Sea dragon', 2133, '', 'N');
INSERT INTO CCD_VESSELS (VESSEL_NAME, FINSS_ID, VESSEL_DESC, APP_SHOW_OPT_YN) VALUES ('Seafisher', 2074, '', 'N');
INSERT INTO CCD_VESSELS (VESSEL_NAME, FINSS_ID, VESSEL_DESC, APP_SHOW_OPT_YN) VALUES ('Searcher', 2134, '', 'N');
INSERT INTO CCD_VESSELS (VESSEL_NAME, FINSS_ID, VESSEL_DESC, APP_SHOW_OPT_YN) VALUES ('Seaview', 2075, '', 'N');
INSERT INTO CCD_VESSELS (VESSEL_NAME, FINSS_ID, VESSEL_DESC, APP_SHOW_OPT_YN) VALUES ('Sedna', 2223, '', 'N');
INSERT INTO CCD_VESSELS (VESSEL_NAME, FINSS_ID, VESSEL_DESC, APP_SHOW_OPT_YN) VALUES ('Senior Dung', 2224, '', 'N');
INSERT INTO CCD_VESSELS (VESSEL_NAME, FINSS_ID, VESSEL_DESC, APP_SHOW_OPT_YN) VALUES ('Silver Bay', 2094, '', 'N');
INSERT INTO CCD_VESSELS (VESSEL_NAME, FINSS_ID, VESSEL_DESC, APP_SHOW_OPT_YN) VALUES ('Simple Man', 2149, '', 'N');
INSERT INTO CCD_VESSELS (VESSEL_NAME, FINSS_ID, VESSEL_DESC, APP_SHOW_OPT_YN) VALUES ('Snoopy', 2225, '', 'N');
INSERT INTO CCD_VESSELS (VESSEL_NAME, FINSS_ID, VESSEL_DESC, APP_SHOW_OPT_YN) VALUES ('Southern Horizon', 2166, '', 'N');
INSERT INTO CCD_VESSELS (VESSEL_NAME, FINSS_ID, VESSEL_DESC, APP_SHOW_OPT_YN) VALUES ('Southern Journey', 2226, '', 'N');
INSERT INTO CCD_VESSELS (VESSEL_NAME, FINSS_ID, VESSEL_DESC, APP_SHOW_OPT_YN) VALUES ('Spree', 2150, '', 'N');
INSERT INTO CCD_VESSELS (VESSEL_NAME, FINSS_ID, VESSEL_DESC, APP_SHOW_OPT_YN) VALUES ('Suncoaster', 2151, '', 'N');
INSERT INTO CCD_VESSELS (VESSEL_NAME, FINSS_ID, VESSEL_DESC, APP_SHOW_OPT_YN) VALUES ('Sundance', 2076, '', 'N');
INSERT INTO CCD_VESSELS (VESSEL_NAME, FINSS_ID, VESSEL_DESC, APP_SHOW_OPT_YN) VALUES ('Sunset Bay', 2299, '', 'N');
INSERT INTO CCD_VESSELS (VESSEL_NAME, FINSS_ID, VESSEL_DESC, APP_SHOW_OPT_YN) VALUES ('Tagata (F189)', 2135, '', 'N');
INSERT INTO CCD_VESSELS (VESSEL_NAME, FINSS_ID, VESSEL_DESC, APP_SHOW_OPT_YN) VALUES ('Temptation', 2077, '', 'N');
INSERT INTO CCD_VESSELS (VESSEL_NAME, FINSS_ID, VESSEL_DESC, APP_SHOW_OPT_YN) VALUES ('Ten27', 2136, '', 'N');
INSERT INTO CCD_VESSELS (VESSEL_NAME, FINSS_ID, VESSEL_DESC, APP_SHOW_OPT_YN) VALUES ('Tenacious II', 2095, '', 'N');
INSERT INTO CCD_VESSELS (VESSEL_NAME, FINSS_ID, VESSEL_DESC, APP_SHOW_OPT_YN) VALUES ('Thomas Jefferson', 2034, '', 'N');
INSERT INTO CCD_VESSELS (VESSEL_NAME, FINSS_ID, VESSEL_DESC, APP_SHOW_OPT_YN) VALUES ('Tiglax', 2028, '', 'N');
INSERT INTO CCD_VESSELS (VESSEL_NAME, FINSS_ID, VESSEL_DESC, APP_SHOW_OPT_YN) VALUES ('Tommy G. Thompson', 2198, '', 'N');
INSERT INTO CCD_VESSELS (VESSEL_NAME, FINSS_ID, VESSEL_DESC, APP_SHOW_OPT_YN) VALUES ('Tommy Munro', 2029, '', 'N');
INSERT INTO CCD_VESSELS (VESSEL_NAME, FINSS_ID, VESSEL_DESC, APP_SHOW_OPT_YN) VALUES ('Toronado', 2109, '', 'N');
INSERT INTO CCD_VESSELS (VESSEL_NAME, FINSS_ID, VESSEL_DESC, APP_SHOW_OPT_YN) VALUES ('Trinity Bay', 2030, '', 'N');
INSERT INTO CCD_VESSELS (VESSEL_NAME, FINSS_ID, VESSEL_DESC, APP_SHOW_OPT_YN) VALUES ('Tytan', 2167, '', 'N');
INSERT INTO CCD_VESSELS (VESSEL_NAME, FINSS_ID, VESSEL_DESC, APP_SHOW_OPT_YN) VALUES ('Ventura II', 2168, '', 'N');
INSERT INTO CCD_VESSELS (VESSEL_NAME, FINSS_ID, VESSEL_DESC, APP_SHOW_OPT_YN) VALUES ('Vesteraalen', 2078, '', 'N');
INSERT INTO CCD_VESSELS (VESSEL_NAME, FINSS_ID, VESSEL_DESC, APP_SHOW_OPT_YN) VALUES ('Wake Atoll Kayak', 2031, '', 'N');
INSERT INTO CCD_VESSELS (VESSEL_NAME, FINSS_ID, VESSEL_DESC, APP_SHOW_OPT_YN) VALUES ('Waters', 2079, '', 'N');
INSERT INTO CCD_VESSELS (VESSEL_NAME, FINSS_ID, VESSEL_DESC, APP_SHOW_OPT_YN) VALUES ('Wecoma', 2199, '', 'N');
INSERT INTO CCD_VESSELS (VESSEL_NAME, FINSS_ID, VESSEL_DESC, APP_SHOW_OPT_YN) VALUES ('Whaler 17''', 2227, '', 'N');
INSERT INTO CCD_VESSELS (VESSEL_NAME, FINSS_ID, VESSEL_DESC, APP_SHOW_OPT_YN) VALUES ('Williwaw', 2080, '', 'N');
INSERT INTO CCD_VESSELS (VESSEL_NAME, FINSS_ID, VESSEL_DESC, APP_SHOW_OPT_YN) VALUES ('YellowFin', 2152, '', 'N');
INSERT INTO CCD_VESSELS (VESSEL_NAME, FINSS_ID, VESSEL_DESC, APP_SHOW_OPT_YN) VALUES ('Yuzhmorgelogiya', 2169, '', 'N');
INSERT INTO CCD_VESSELS (VESSEL_NAME, FINSS_ID, VESSEL_DESC, APP_SHOW_OPT_YN) VALUES ('no name (F1761)', 2228, '', 'N');
INSERT INTO CCD_VESSELS (VESSEL_NAME, FINSS_ID, VESSEL_DESC, APP_SHOW_OPT_YN) VALUES ('no name (F1762)', 2229, '', 'N');
INSERT INTO CCD_VESSELS (VESSEL_NAME, FINSS_ID, VESSEL_DESC, APP_SHOW_OPT_YN) VALUES ('no name (F1763)', 2230, '', 'N');
INSERT INTO CCD_VESSELS (VESSEL_NAME, FINSS_ID, VESSEL_DESC, APP_SHOW_OPT_YN) VALUES ('no name (R3302)', 2231, '', 'N');
INSERT INTO CCD_VESSELS (VESSEL_NAME, FINSS_ID, VESSEL_DESC, APP_SHOW_OPT_YN) VALUES ('Townsend Cromwell', NULL, 'This was added manually, it was not retrieved from FINSS', 'Y');


--load survey category data:
INSERT INTO CCD_SVY_CATS (SVY_CAT_NAME, SVY_CAT_DESC, FINSS_ID) VALUES ('Ecosystem Monitoring and Assessment', 'Surveys that principally collect oceanographic and lower trophic level (phytoplankton, zooplankton, and ichthyoplankton) data to monitor the health and status of the ecosystems, with the ultimate goal of characterizing the changing states of ecosystems, supporting protected resources and sustainable fisheries, and forecasting the subsequent impact on fisheries productivity. Examples include ecosystem monitoring and assessment, oceanography, climate observation, IEA, HAB, MPA, etc.', 63);
INSERT INTO CCD_SVY_CATS (SVY_CAT_NAME, SVY_CAT_DESC, FINSS_ID) VALUES ('Fisheries Monitoring and Assessment', 'Surveys that principally collect data of temporal distribution and abundance of commercially-targeted and ecologically-important species; examine the changes in the species composition and size and age compositions of species over time and space; examine reproductive biology and food habits of the community; and describe the physical habitat. Examples include stock assessment, life history, recruitement, reef fisheries, etc.', 62);
INSERT INTO CCD_SVY_CATS (SVY_CAT_NAME, SVY_CAT_DESC, FINSS_ID) VALUES ('Habitat Monitoring and Assessment', 'Surveys that principally collect data to characterize the status, quantity, and changing states of habitat, the ecological relationships among species and their habitats/environments, and work toward developing the best available information on habitat characteristics relative to the population dynamics of fishery species or other living marine resources. Examples include benthic surveys and mapping, quantifying habitat-specific vital rates per life stage, habitat restoration assessments, defining and refining EFH, etc.', 64);
INSERT INTO CCD_SVY_CATS (SVY_CAT_NAME, SVY_CAT_DESC, FINSS_ID) VALUES ('Protected Species Monitoring and Assessment', 'Surveys that pricinpally collect information for the protection and recovery of protected species. Examples include protected species population monitoring and assessment, animal movement, camp support, ESA coral assessment, tagging, ecosystem data collection to support PR, etc.', 61);
INSERT INTO CCD_SVY_CATS (SVY_CAT_NAME, SVY_CAT_DESC, FINSS_ID) VALUES ('Science, Services and Stewardship', 'Other survey types that support NOAA missions, including research, education and outreach, marine debris removal, advancing technology research and development, etc.', 65);
INSERT INTO CCD_SVY_CATS (SVY_CAT_NAME, SVY_CAT_DESC, FINSS_ID) VALUES ('Debris Cleanup', '', NULL);

--ESA target species

INSERT INTO CCD_TGT_SPP_ESA (TGT_SPP_ESA_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('Atlantic salmon - Gulf of Maine', 798, 'N');
INSERT INTO CCD_TGT_SPP_ESA (TGT_SPP_ESA_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('Atlantic sturgeon', 824, 'N');
INSERT INTO CCD_TGT_SPP_ESA (TGT_SPP_ESA_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('Beluga Whale - Cook Inlet', 670, 'N');
INSERT INTO CCD_TGT_SPP_ESA (TGT_SPP_ESA_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('black abalone', 735, 'N');
INSERT INTO CCD_TGT_SPP_ESA (TGT_SPP_ESA_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('Blue whale', 529, 'Y');
INSERT INTO CCD_TGT_SPP_ESA (TGT_SPP_ESA_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('Bowhead Whale', 549, 'N');
INSERT INTO CCD_TGT_SPP_ESA (TGT_SPP_ESA_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('Chinese River dolphin / baiji', 750, 'N');
INSERT INTO CCD_TGT_SPP_ESA (TGT_SPP_ESA_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('Chinook salmon - California coastal', 767, 'N');
INSERT INTO CCD_TGT_SPP_ESA (TGT_SPP_ESA_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('Chinook salmon - Central Valley spring-run', 768, 'N');
INSERT INTO CCD_TGT_SPP_ESA (TGT_SPP_ESA_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('Chinook salmon - Lower Columbia River', 769, 'N');
INSERT INTO CCD_TGT_SPP_ESA (TGT_SPP_ESA_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('Chinook salmon - Puget Sound', 770, 'N');
INSERT INTO CCD_TGT_SPP_ESA (TGT_SPP_ESA_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('Chinook salmon - Sacramento River winter-run', 771, 'N');
INSERT INTO CCD_TGT_SPP_ESA (TGT_SPP_ESA_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('Chinook salmon - Snake River fall-run', 787, 'N');
INSERT INTO CCD_TGT_SPP_ESA (TGT_SPP_ESA_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('Chinook salmon - Snake River spring/ summer-run', 772, 'N');
INSERT INTO CCD_TGT_SPP_ESA (TGT_SPP_ESA_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('Chinook salmon - Upper Columbia River spring-run', 773, 'N');
INSERT INTO CCD_TGT_SPP_ESA (TGT_SPP_ESA_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('Chinook salmon - Upper Willamette River', 788, 'N');
INSERT INTO CCD_TGT_SPP_ESA (TGT_SPP_ESA_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('chum salmon - Columbia River', 774, 'N');
INSERT INTO CCD_TGT_SPP_ESA (TGT_SPP_ESA_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('chum salmon - Hood Canal summer-run', 789, 'N');
INSERT INTO CCD_TGT_SPP_ESA (TGT_SPP_ESA_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('coho salmon - Central California coast', 775, 'N');
INSERT INTO CCD_TGT_SPP_ESA (TGT_SPP_ESA_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('coho salmon - Lower Columbia River', 776, 'N');
INSERT INTO CCD_TGT_SPP_ESA (TGT_SPP_ESA_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('coho salmon - Oregon coast', 790, 'Y');
INSERT INTO CCD_TGT_SPP_ESA (TGT_SPP_ESA_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('coho salmon - original listing', 777, 'N');
INSERT INTO CCD_TGT_SPP_ESA (TGT_SPP_ESA_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('coho salmon - Southern Oregon &amp; Northern California coasts', 791, 'N');
INSERT INTO CCD_TGT_SPP_ESA (TGT_SPP_ESA_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('elkhorn coral', 738, 'N');
INSERT INTO CCD_TGT_SPP_ESA (TGT_SPP_ESA_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('Fin Whale', 523, 'Y');
INSERT INTO CCD_TGT_SPP_ESA (TGT_SPP_ESA_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('Gray Whale - Eastern North Pacific', 691, 'N');
INSERT INTO CCD_TGT_SPP_ESA (TGT_SPP_ESA_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('green sturgeon - southern DPS', 778, 'N');
INSERT INTO CCD_TGT_SPP_ESA (TGT_SPP_ESA_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('green turtle - all other areas except Florida &amp; Mexico''s Pacific coast breeding colonies', 747, 'N');
INSERT INTO CCD_TGT_SPP_ESA (TGT_SPP_ESA_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('green turtle - Florida &amp; Mexico''s Pacific coast breeding colonies', 746, 'N');
INSERT INTO CCD_TGT_SPP_ESA (TGT_SPP_ESA_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('Guadalupe Fur Seal', 518, 'N');
INSERT INTO CCD_TGT_SPP_ESA (TGT_SPP_ESA_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('Gulf of California harbor porpoise / vaquita', 751, 'N');
INSERT INTO CCD_TGT_SPP_ESA (TGT_SPP_ESA_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('Gulf sturgeon', 765, 'N');
INSERT INTO CCD_TGT_SPP_ESA (TGT_SPP_ESA_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('Hawaiian Monk Seal', 565, 'Y');
INSERT INTO CCD_TGT_SPP_ESA (TGT_SPP_ESA_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('hawksbill turtle', 741, 'Y');
INSERT INTO CCD_TGT_SPP_ESA (TGT_SPP_ESA_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('Humpback Whale', 540, 'Y');
INSERT INTO CCD_TGT_SPP_ESA (TGT_SPP_ESA_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('Indus River dolphin', 752, 'N');
INSERT INTO CCD_TGT_SPP_ESA (TGT_SPP_ESA_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('Johnson''s seagrass', 739, 'N');
INSERT INTO CCD_TGT_SPP_ESA (TGT_SPP_ESA_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('Kemp''s ridley turtle', 740, 'Y');
INSERT INTO CCD_TGT_SPP_ESA (TGT_SPP_ESA_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('Killer Whale', 552, 'N');
INSERT INTO CCD_TGT_SPP_ESA (TGT_SPP_ESA_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('leatherback turtle', 742, 'Y');
INSERT INTO CCD_TGT_SPP_ESA (TGT_SPP_ESA_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('loggerhead turtle', 744, 'Y');
INSERT INTO CCD_TGT_SPP_ESA (TGT_SPP_ESA_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('Mediterranean monk seal', 753, 'N');
INSERT INTO CCD_TGT_SPP_ESA (TGT_SPP_ESA_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('North Atlantic Right Whale', 567, 'N');
INSERT INTO CCD_TGT_SPP_ESA (TGT_SPP_ESA_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('North Pacific Right Whale', 560, 'N');
INSERT INTO CCD_TGT_SPP_ESA (TGT_SPP_ESA_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('Northern sea otter', 819, 'N');
INSERT INTO CCD_TGT_SPP_ESA (TGT_SPP_ESA_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('olive ridley turtle - all other areas except Mexico''s Pacific coast breeding colonies', 749, 'N');
INSERT INTO CCD_TGT_SPP_ESA (TGT_SPP_ESA_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('olive ridley turtle - Mexico''s Pacific coast breeding colonies', 748, 'N');
INSERT INTO CCD_TGT_SPP_ESA (TGT_SPP_ESA_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('Saimaa seal', 754, 'N');
INSERT INTO CCD_TGT_SPP_ESA (TGT_SPP_ESA_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('Sei Whale', 544, 'Y');
INSERT INTO CCD_TGT_SPP_ESA (TGT_SPP_ESA_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('shortnose sturgeon', 759, 'N');
INSERT INTO CCD_TGT_SPP_ESA (TGT_SPP_ESA_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('smalltooth sawfish - U.S. portion of range', 779, 'N');
INSERT INTO CCD_TGT_SPP_ESA (TGT_SPP_ESA_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('sockeye salmon - Ozette Lake', 792, 'N');
INSERT INTO CCD_TGT_SPP_ESA (TGT_SPP_ESA_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('sockeye salmon - Snake River', 780, 'N');
INSERT INTO CCD_TGT_SPP_ESA (TGT_SPP_ESA_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('Southern right whale', 755, 'N');
INSERT INTO CCD_TGT_SPP_ESA (TGT_SPP_ESA_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('Sperm Whale', 561, 'Y');
INSERT INTO CCD_TGT_SPP_ESA (TGT_SPP_ESA_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('staghorn coral', 736, 'Y');
INSERT INTO CCD_TGT_SPP_ESA (TGT_SPP_ESA_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('steelhead trout - California Central Valley', 793, 'N');
INSERT INTO CCD_TGT_SPP_ESA (TGT_SPP_ESA_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('steelhead trout - Central California coast', 781, 'N');
INSERT INTO CCD_TGT_SPP_ESA (TGT_SPP_ESA_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('steelhead trout - Lower Columbia River', 794, 'N');
INSERT INTO CCD_TGT_SPP_ESA (TGT_SPP_ESA_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('steelhead trout - Middle Columbia River', 782, 'N');
INSERT INTO CCD_TGT_SPP_ESA (TGT_SPP_ESA_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('steelhead trout - Northern California', 783, 'N');
INSERT INTO CCD_TGT_SPP_ESA (TGT_SPP_ESA_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('steelhead trout - Puget Sound', 795, 'N');
INSERT INTO CCD_TGT_SPP_ESA (TGT_SPP_ESA_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('steelhead trout - Snake River Basin', 784, 'N');
INSERT INTO CCD_TGT_SPP_ESA (TGT_SPP_ESA_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('steelhead trout - South-Central California coast', 796, 'N');
INSERT INTO CCD_TGT_SPP_ESA (TGT_SPP_ESA_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('steelhead trout - Southern California', 785, 'N');
INSERT INTO CCD_TGT_SPP_ESA (TGT_SPP_ESA_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('steelhead trout - Upper Columbia River', 797, 'N');
INSERT INTO CCD_TGT_SPP_ESA (TGT_SPP_ESA_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('steelhead trout - Upper Willamette River', 786, 'N');
INSERT INTO CCD_TGT_SPP_ESA (TGT_SPP_ESA_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('Steller Sea Lion', 563, 'N');
INSERT INTO CCD_TGT_SPP_ESA (TGT_SPP_ESA_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('Steller Sea Lion - Eastern', 730, 'N');
INSERT INTO CCD_TGT_SPP_ESA (TGT_SPP_ESA_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('Steller Sea Lion - Western', 655, 'Y');
INSERT INTO CCD_TGT_SPP_ESA (TGT_SPP_ESA_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('totoaba', 761, 'Y');
INSERT INTO CCD_TGT_SPP_ESA (TGT_SPP_ESA_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('white abalone', 737, 'Y');
INSERT INTO CCD_TGT_SPP_ESA (TGT_SPP_ESA_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('green turtle - all other areas except Florida & Mexico''s Pacific coast breeding colonies', NULL, 'Y');


--MMPA target species
INSERT INTO CCD_TGT_SPP_MMPA (TGT_SPP_MMPA_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('Atlantic Spotted Dolphin - Northern Gulf of Mexico', 727, 'N');
INSERT INTO CCD_TGT_SPP_MMPA (TGT_SPP_MMPA_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('Atlantic Spotted Dolphin - Western North Atlantic', 652, 'N');
INSERT INTO CCD_TGT_SPP_MMPA (TGT_SPP_MMPA_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('Atlantic White-Sided Dolphin - Western North Atlantic', 658, 'N');
INSERT INTO CCD_TGT_SPP_MMPA (TGT_SPP_MMPA_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('Baird''s Beaked Whale - Alaska', 572, 'Y');
INSERT INTO CCD_TGT_SPP_MMPA (TGT_SPP_MMPA_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('Baird''s Beaked Whale - California-Oregon-Washington', 660, 'Y');
INSERT INTO CCD_TGT_SPP_MMPA (TGT_SPP_MMPA_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('Bearded Seal - Alaska', 581, 'N');
INSERT INTO CCD_TGT_SPP_MMPA (TGT_SPP_MMPA_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('Beluga Whale - Beaufort Sea', 669, 'N');
INSERT INTO CCD_TGT_SPP_MMPA (TGT_SPP_MMPA_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('Beluga Whale - Bristol Bay', 582, 'Y');
INSERT INTO CCD_TGT_SPP_MMPA (TGT_SPP_MMPA_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('Beluga Whale - Cook Inlet', 670, 'N');
INSERT INTO CCD_TGT_SPP_MMPA (TGT_SPP_MMPA_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('Beluga Whale - Eastern Bering Sea', 583, 'N');
INSERT INTO CCD_TGT_SPP_MMPA (TGT_SPP_MMPA_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('Beluga Whale - Eastern Chukchi Sea', 671, 'N');
INSERT INTO CCD_TGT_SPP_MMPA (TGT_SPP_MMPA_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('Blainville''s Beaked Whale - Hawaii', 573, 'Y');
INSERT INTO CCD_TGT_SPP_MMPA (TGT_SPP_MMPA_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('Blainville''s Beaked Whale - Northern Gulf of Mexico', 661, 'N');
INSERT INTO CCD_TGT_SPP_MMPA (TGT_SPP_MMPA_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('Blainville''s Beaked Whale - Western North Atlantic', 574, 'Y');
INSERT INTO CCD_TGT_SPP_MMPA (TGT_SPP_MMPA_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('Blue whale - Eastern North Pacific, formerly California/Mexico', 584, 'N');
INSERT INTO CCD_TGT_SPP_MMPA (TGT_SPP_MMPA_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('Blue whale - Western North Pacific, formerly Hawaii', 672, 'Y');
INSERT INTO CCD_TGT_SPP_MMPA (TGT_SPP_MMPA_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('Bottlenose Dolphin - California Coastal', 585, 'N');
INSERT INTO CCD_TGT_SPP_MMPA (TGT_SPP_MMPA_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('Bottlenose Dolphin - California-Oregon-Washington Offshore', 673, 'N');
INSERT INTO CCD_TGT_SPP_MMPA (TGT_SPP_MMPA_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('Bottlenose Dolphin - Eastern Gulf of Mexico Coastal', 586, 'N');
INSERT INTO CCD_TGT_SPP_MMPA (TGT_SPP_MMPA_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('Bottlenose Dolphin - Gulf of Mexico Bay Sound and Estuarine', 674, 'N');
INSERT INTO CCD_TGT_SPP_MMPA (TGT_SPP_MMPA_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('Bottlenose Dolphin - Gulf of Mexico Continental Shelf and Slope', 587, 'N');
INSERT INTO CCD_TGT_SPP_MMPA (TGT_SPP_MMPA_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('Bottlenose Dolphin - Hawaii', 588, 'Y');
INSERT INTO CCD_TGT_SPP_MMPA (TGT_SPP_MMPA_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('Bottlenose Dolphin - Northern Gulf of Mexico Coastal', 675, 'N');
INSERT INTO CCD_TGT_SPP_MMPA (TGT_SPP_MMPA_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('Bottlenose Dolphin - Northern Gulf of Mexico Oceanic Stock, formerly Outer Continental Shelf', 589, 'N');
INSERT INTO CCD_TGT_SPP_MMPA (TGT_SPP_MMPA_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('Bottlenose Dolphin - Western Gulf of Mexico Coastal', 676, 'N');
INSERT INTO CCD_TGT_SPP_MMPA (TGT_SPP_MMPA_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('Bottlenose Dolphin - Western North Atlantic Coastal', 590, 'N');
INSERT INTO CCD_TGT_SPP_MMPA (TGT_SPP_MMPA_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('Bottlenose Dolphin - Western North Atlantic Offshore', 677, 'N');
INSERT INTO CCD_TGT_SPP_MMPA (TGT_SPP_MMPA_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('Bowhead Whale - Western Arctic', 591, 'N');
INSERT INTO CCD_TGT_SPP_MMPA (TGT_SPP_MMPA_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('Bryde''s Whale - Eastern Tropical Pacific', 678, 'Y');
INSERT INTO CCD_TGT_SPP_MMPA (TGT_SPP_MMPA_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('Bryde''s Whale - Hawaii', 592, 'Y');
INSERT INTO CCD_TGT_SPP_MMPA (TGT_SPP_MMPA_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('Bryde''s Whale - Northern Gulf of Mexico', 679, 'N');
INSERT INTO CCD_TGT_SPP_MMPA (TGT_SPP_MMPA_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('California Sea Lion - U.S.', 593, 'N');
INSERT INTO CCD_TGT_SPP_MMPA (TGT_SPP_MMPA_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('Clymene Dolphin - Northern Gulf of Mexico', 680, 'N');
INSERT INTO CCD_TGT_SPP_MMPA (TGT_SPP_MMPA_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('Clymene Dolphin - Western North Atlantic', 594, 'N');
INSERT INTO CCD_TGT_SPP_MMPA (TGT_SPP_MMPA_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('Common Dolphin - Western North Atlantic', 681, 'N');
INSERT INTO CCD_TGT_SPP_MMPA (TGT_SPP_MMPA_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('Cuvier''s Beaked Whale - Alaska', 662, 'N');
INSERT INTO CCD_TGT_SPP_MMPA (TGT_SPP_MMPA_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('Cuvier''s Beaked Whale - California-Oregon-Washington', 575, 'N');
INSERT INTO CCD_TGT_SPP_MMPA (TGT_SPP_MMPA_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('Cuvier''s Beaked Whale - Hawaii', 663, 'Y');
INSERT INTO CCD_TGT_SPP_MMPA (TGT_SPP_MMPA_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('Cuvier''s Beaked Whale - Northern Gulf of Mexico', 576, 'N');
INSERT INTO CCD_TGT_SPP_MMPA (TGT_SPP_MMPA_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('Cuvier''s Beaked Whale - Western North Atlantic', 664, 'Y');
INSERT INTO CCD_TGT_SPP_MMPA (TGT_SPP_MMPA_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('Dall''s Porpoise - Alaska', 596, 'N');
INSERT INTO CCD_TGT_SPP_MMPA (TGT_SPP_MMPA_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('Dall''s Porpoise - California-Oregon-Washington', 683, 'N');
INSERT INTO CCD_TGT_SPP_MMPA (TGT_SPP_MMPA_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('Dwarf Sperm Whale - California-Oregon-Washington', 597, 'N');
INSERT INTO CCD_TGT_SPP_MMPA (TGT_SPP_MMPA_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('Dwarf Sperm Whale - Hawaii', 684, 'Y');
INSERT INTO CCD_TGT_SPP_MMPA (TGT_SPP_MMPA_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('Dwarf Sperm Whale - Northern Gulf of Mexico', 598, 'N');
INSERT INTO CCD_TGT_SPP_MMPA (TGT_SPP_MMPA_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('Dwarf Sperm Whale - Western North Atlantic', 685, 'N');
INSERT INTO CCD_TGT_SPP_MMPA (TGT_SPP_MMPA_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('False Killer Whale - Hawaii', 599, 'Y');
INSERT INTO CCD_TGT_SPP_MMPA (TGT_SPP_MMPA_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('False Killer Whale - Northern Gulf of Mexico', 686, 'N');
INSERT INTO CCD_TGT_SPP_MMPA (TGT_SPP_MMPA_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('Fin Whale - California-Oregon-Washington', 600, 'N');
INSERT INTO CCD_TGT_SPP_MMPA (TGT_SPP_MMPA_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('Fin Whale - Hawaii', 687, 'Y');
INSERT INTO CCD_TGT_SPP_MMPA (TGT_SPP_MMPA_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('Fin Whale - Northeast Pacific', 688, 'N');
INSERT INTO CCD_TGT_SPP_MMPA (TGT_SPP_MMPA_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('Fin Whale - Western North Atlantic', 601, 'N');
INSERT INTO CCD_TGT_SPP_MMPA (TGT_SPP_MMPA_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('Fraser''s Dolphin - Hawaii', 689, 'Y');
INSERT INTO CCD_TGT_SPP_MMPA (TGT_SPP_MMPA_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('Fraser''s Dolphin - Northern Gulf of Mexico', 602, 'N');
INSERT INTO CCD_TGT_SPP_MMPA (TGT_SPP_MMPA_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('Fraser''s Dolphin - Western North Atlantic', 690, 'N');
INSERT INTO CCD_TGT_SPP_MMPA (TGT_SPP_MMPA_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('Gervais'' Beaked Whale - Northern Gulf of Mexico', 577, 'N');
INSERT INTO CCD_TGT_SPP_MMPA (TGT_SPP_MMPA_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('Gervais'' Beaked Whale - Western North Atlantic', 665, 'N');
INSERT INTO CCD_TGT_SPP_MMPA (TGT_SPP_MMPA_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('Gray Seal - Western North Atlantic', 603, 'N');
INSERT INTO CCD_TGT_SPP_MMPA (TGT_SPP_MMPA_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('Gray Whale - Eastern North Pacific', 691, 'N');
INSERT INTO CCD_TGT_SPP_MMPA (TGT_SPP_MMPA_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('Guadalupe Fur Seal - Mexico', 604, 'N');
INSERT INTO CCD_TGT_SPP_MMPA (TGT_SPP_MMPA_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('Harbor Porpoise - Bering Sea', 692, 'N');
INSERT INTO CCD_TGT_SPP_MMPA (TGT_SPP_MMPA_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('Harbor Porpoise - Central California (split into Monterey Bay stock and Morro Bay stock in 2002)', 605, 'N');
INSERT INTO CCD_TGT_SPP_MMPA (TGT_SPP_MMPA_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('Harbor Porpoise - Gulf of Alaska', 693, 'N');
INSERT INTO CCD_TGT_SPP_MMPA (TGT_SPP_MMPA_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('Harbor Porpoise - Gulf of Maine-Bay of Fundy', 606, 'N');
INSERT INTO CCD_TGT_SPP_MMPA (TGT_SPP_MMPA_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('Harbor Porpoise - Inland WA', 694, 'N');
INSERT INTO CCD_TGT_SPP_MMPA (TGT_SPP_MMPA_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('Harbor Porpoise - Monterey Bay', 695, 'N');
INSERT INTO CCD_TGT_SPP_MMPA (TGT_SPP_MMPA_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('Harbor Porpoise - Morro Bay', 607, 'N');
INSERT INTO CCD_TGT_SPP_MMPA (TGT_SPP_MMPA_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('Harbor Porpoise - Northern California-Southern Oregon, formerly Northern California', 696, 'N');
INSERT INTO CCD_TGT_SPP_MMPA (TGT_SPP_MMPA_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('Harbor Porpoise - Oregon-Washington Coastal', 608, 'N');
INSERT INTO CCD_TGT_SPP_MMPA (TGT_SPP_MMPA_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('Harbor Porpoise - San Francisco-Russian River', 609, 'N');
INSERT INTO CCD_TGT_SPP_MMPA (TGT_SPP_MMPA_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('Harbor Porpoise - Southeast Alaska', 697, 'N');
INSERT INTO CCD_TGT_SPP_MMPA (TGT_SPP_MMPA_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('Harbor Seal - Bering Sea', 610, 'N');
INSERT INTO CCD_TGT_SPP_MMPA (TGT_SPP_MMPA_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('Harbor Seal - California', 698, 'N');
INSERT INTO CCD_TGT_SPP_MMPA (TGT_SPP_MMPA_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('Harbor Seal - Gulf of Alaska', 699, 'N');
INSERT INTO CCD_TGT_SPP_MMPA (TGT_SPP_MMPA_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('Harbor Seal - Oregon-Washington Coastal', 611, 'N');
INSERT INTO CCD_TGT_SPP_MMPA (TGT_SPP_MMPA_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('Harbor Seal - Southeast Alaska', 700, 'N');
INSERT INTO CCD_TGT_SPP_MMPA (TGT_SPP_MMPA_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('Harbor Seal - Washington Inland', 612, 'N');
INSERT INTO CCD_TGT_SPP_MMPA (TGT_SPP_MMPA_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('Harbor Seal - Western North Atlantic', 701, 'N');
INSERT INTO CCD_TGT_SPP_MMPA (TGT_SPP_MMPA_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('Harp Seal - Western North Atlantic', 613, 'N');
INSERT INTO CCD_TGT_SPP_MMPA (TGT_SPP_MMPA_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('Hawaiian Monk Seal - Hawaii', 702, 'Y');
INSERT INTO CCD_TGT_SPP_MMPA (TGT_SPP_MMPA_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('Hooded Seal - Western North Atlantic', 614, 'N');
INSERT INTO CCD_TGT_SPP_MMPA (TGT_SPP_MMPA_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('Humpback Whale - Central North Pacific', 703, 'Y');
INSERT INTO CCD_TGT_SPP_MMPA (TGT_SPP_MMPA_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('Humpback Whale - Eastern North Pacific, formerly California-Oregon-Washington-Mexico', 615, 'N');
INSERT INTO CCD_TGT_SPP_MMPA (TGT_SPP_MMPA_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('Humpback Whale - Gulf of Maine, formerly Western North Atlantic', 704, 'N');
INSERT INTO CCD_TGT_SPP_MMPA (TGT_SPP_MMPA_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('Humpback Whale - Western North Pacific', 616, 'N');
INSERT INTO CCD_TGT_SPP_MMPA (TGT_SPP_MMPA_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('Killer Whale - AT1 Transient', 705, 'N');
INSERT INTO CCD_TGT_SPP_MMPA (TGT_SPP_MMPA_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('Killer Whale - Eastern North Pacific Alaska Resident', 617, 'N');
INSERT INTO CCD_TGT_SPP_MMPA (TGT_SPP_MMPA_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('Killer Whale - Eastern North Pacific Northern Resident', 706, 'N');
INSERT INTO CCD_TGT_SPP_MMPA (TGT_SPP_MMPA_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('Killer Whale - Eastern North Pacific Offshore', 618, 'N');
INSERT INTO CCD_TGT_SPP_MMPA (TGT_SPP_MMPA_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('Killer Whale - Eastern North Pacific Southern Resident', 707, 'N');
INSERT INTO CCD_TGT_SPP_MMPA (TGT_SPP_MMPA_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('Killer Whale - Eastern North Pacific Transient', 619, 'N');
INSERT INTO CCD_TGT_SPP_MMPA (TGT_SPP_MMPA_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('Killer Whale - Gulf of Alaska, Aleutian Islands, and Bering Sea Transient', 620, 'N');
INSERT INTO CCD_TGT_SPP_MMPA (TGT_SPP_MMPA_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('Killer Whale - Hawaii', 621, 'Y');
INSERT INTO CCD_TGT_SPP_MMPA (TGT_SPP_MMPA_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('Killer Whale - Northern Gulf of Mexico', 622, 'N');
INSERT INTO CCD_TGT_SPP_MMPA (TGT_SPP_MMPA_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('Killer Whale - West Coast Transient', 623, 'N');
INSERT INTO CCD_TGT_SPP_MMPA (TGT_SPP_MMPA_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('Killer Whale - Western North Atlantic', 624, 'N');
INSERT INTO CCD_TGT_SPP_MMPA (TGT_SPP_MMPA_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('Long-Beaked Common Dolphin - California', 595, 'N');
INSERT INTO CCD_TGT_SPP_MMPA (TGT_SPP_MMPA_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('Long-Finned Pilot Whale - Western North Atlantic', 634, 'Y');
INSERT INTO CCD_TGT_SPP_MMPA (TGT_SPP_MMPA_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('Longman''s Beaked Whale - Hawaii', 578, 'Y');
INSERT INTO CCD_TGT_SPP_MMPA (TGT_SPP_MMPA_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('Melon-Headed Whale - Hawaii', 625, 'Y');
INSERT INTO CCD_TGT_SPP_MMPA (TGT_SPP_MMPA_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('Melon-Headed Whale - Northern Gulf of Mexico', 626, 'N');
INSERT INTO CCD_TGT_SPP_MMPA (TGT_SPP_MMPA_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('Melon-Headed Whale - Western North Atlantic', 627, 'N');
INSERT INTO CCD_TGT_SPP_MMPA (TGT_SPP_MMPA_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('Mesoplodont Beaked Whale - California-Oregon-Washington', 666, 'N');
INSERT INTO CCD_TGT_SPP_MMPA (TGT_SPP_MMPA_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('Mesoplodont Beaked Whale - Western North Atlantic', 579, 'N');
INSERT INTO CCD_TGT_SPP_MMPA (TGT_SPP_MMPA_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('Minke Whale - Alaska', 628, 'N');
INSERT INTO CCD_TGT_SPP_MMPA (TGT_SPP_MMPA_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('Minke Whale - California-Oregon-Washington', 629, 'N');
INSERT INTO CCD_TGT_SPP_MMPA (TGT_SPP_MMPA_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('Minke Whale - Canadian Eastern Coastal', 630, 'N');
INSERT INTO CCD_TGT_SPP_MMPA (TGT_SPP_MMPA_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('Minke Whale - Hawaii', 631, 'Y');
INSERT INTO CCD_TGT_SPP_MMPA (TGT_SPP_MMPA_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('North Atlantic Right Whale - Western Stock, formerly Western North Atlantic', 717, 'N');
INSERT INTO CCD_TGT_SPP_MMPA (TGT_SPP_MMPA_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('North Pacific Right Whale - Eastern North Pacific, formerly North Pacific', 641, 'N');
INSERT INTO CCD_TGT_SPP_MMPA (TGT_SPP_MMPA_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('Northern Bottlenose Whale - Western North Atlantic', 708, 'N');
INSERT INTO CCD_TGT_SPP_MMPA (TGT_SPP_MMPA_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('Northern Elephant Seal - California Breeding', 632, 'N');
INSERT INTO CCD_TGT_SPP_MMPA (TGT_SPP_MMPA_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('Northern Fur Seal - Eastern Pacific', 709, 'N');
INSERT INTO CCD_TGT_SPP_MMPA (TGT_SPP_MMPA_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('Northern Fur Seal - San Miguel Island', 633, 'N');
INSERT INTO CCD_TGT_SPP_MMPA (TGT_SPP_MMPA_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('Northern Right Whale Dolphin - California-Oregon-Washington', 710, 'N');
INSERT INTO CCD_TGT_SPP_MMPA (TGT_SPP_MMPA_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('Pacific White-Sided Dolphin - California-Oregon-Washington, North and South', 734, 'N');
INSERT INTO CCD_TGT_SPP_MMPA (TGT_SPP_MMPA_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('Pacific White-Sided Dolphin - North Pacific, formerly Central North Pacific', 659, 'Y');
INSERT INTO CCD_TGT_SPP_MMPA (TGT_SPP_MMPA_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('Pantropical Spotted Dolphin - Hawaii', 728, 'Y');
INSERT INTO CCD_TGT_SPP_MMPA (TGT_SPP_MMPA_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('Pantropical Spotted Dolphin - Northern Gulf of Mexico', 653, 'N');
INSERT INTO CCD_TGT_SPP_MMPA (TGT_SPP_MMPA_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('Pantropical Spotted Dolphin - Western North Atlantic', 729, 'N');
INSERT INTO CCD_TGT_SPP_MMPA (TGT_SPP_MMPA_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('Pygmy Killer Whale - Hawaii', 637, 'Y');
INSERT INTO CCD_TGT_SPP_MMPA (TGT_SPP_MMPA_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('Pygmy Killer Whale - Northern Gulf of Mexico', 713, 'N');
INSERT INTO CCD_TGT_SPP_MMPA (TGT_SPP_MMPA_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('Pygmy Killer Whale - Western North Atlantic', 638, 'N');
INSERT INTO CCD_TGT_SPP_MMPA (TGT_SPP_MMPA_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('Pygmy Sperm Whale - California-Oregon-Washington', 714, 'N');
INSERT INTO CCD_TGT_SPP_MMPA (TGT_SPP_MMPA_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('Pygmy Sperm Whale - Hawaii', 639, 'Y');
INSERT INTO CCD_TGT_SPP_MMPA (TGT_SPP_MMPA_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('Pygmy Sperm Whale - Northern Gulf of Mexico', 715, 'N');
INSERT INTO CCD_TGT_SPP_MMPA (TGT_SPP_MMPA_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('Pygmy Sperm Whale - Western North Atlantic', 640, 'N');
INSERT INTO CCD_TGT_SPP_MMPA (TGT_SPP_MMPA_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('Ribbon Seal - Alaska', 716, 'N');
INSERT INTO CCD_TGT_SPP_MMPA (TGT_SPP_MMPA_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('Ringed Seal - Alaska', 642, 'N');
INSERT INTO CCD_TGT_SPP_MMPA (TGT_SPP_MMPA_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('Risso''s Dolphin - California-Oregon-Washington', 718, 'N');
INSERT INTO CCD_TGT_SPP_MMPA (TGT_SPP_MMPA_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('Risso''s Dolphin - Hawaii', 643, 'Y');
INSERT INTO CCD_TGT_SPP_MMPA (TGT_SPP_MMPA_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('Risso''s Dolphin - Northern Gulf of Mexico', 719, 'N');
INSERT INTO CCD_TGT_SPP_MMPA (TGT_SPP_MMPA_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('Risso''s Dolphin - Western North Atlantic', 644, 'N');
INSERT INTO CCD_TGT_SPP_MMPA (TGT_SPP_MMPA_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('Rough-Toothed Dolphin - Hawaii', 720, 'Y');
INSERT INTO CCD_TGT_SPP_MMPA (TGT_SPP_MMPA_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('Rough-Toothed Dolphin - Northern Gulf of Mexico', 645, 'N');
INSERT INTO CCD_TGT_SPP_MMPA (TGT_SPP_MMPA_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('Sei Whale - Eastern North Pacific', 721, 'N');
INSERT INTO CCD_TGT_SPP_MMPA (TGT_SPP_MMPA_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('Sei Whale - Hawaii', 646, 'Y');
INSERT INTO CCD_TGT_SPP_MMPA (TGT_SPP_MMPA_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('Sei Whale - Nova Scotia, formerly Western North Atlantic', 722, 'N');
INSERT INTO CCD_TGT_SPP_MMPA (TGT_SPP_MMPA_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('Sei Whale - Western North Atlantic', 647, 'N');
INSERT INTO CCD_TGT_SPP_MMPA (TGT_SPP_MMPA_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('Short-Beaked Common Dolphin - California-Oregon-Washington', 682, 'N');
INSERT INTO CCD_TGT_SPP_MMPA (TGT_SPP_MMPA_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('Short-Finned Pilot Whale - California-Oregon-Washington', 711, 'N');
INSERT INTO CCD_TGT_SPP_MMPA (TGT_SPP_MMPA_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('Short-Finned Pilot Whale - Hawaii', 635, 'Y');
INSERT INTO CCD_TGT_SPP_MMPA (TGT_SPP_MMPA_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('Short-Finned Pilot Whale - Northern Gulf of Mexico', 712, 'N');
INSERT INTO CCD_TGT_SPP_MMPA (TGT_SPP_MMPA_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('Short-Finned Pilot Whale - Western North Atlantic', 636, 'Y');
INSERT INTO CCD_TGT_SPP_MMPA (TGT_SPP_MMPA_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('Sowerby''s Beaked Whale - Western North Atlantic', 667, 'N');
INSERT INTO CCD_TGT_SPP_MMPA (TGT_SPP_MMPA_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('Sperm Whale - California-Oregon-Washington', 723, 'N');
INSERT INTO CCD_TGT_SPP_MMPA (TGT_SPP_MMPA_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('Sperm Whale - Hawaii', 648, 'Y');
INSERT INTO CCD_TGT_SPP_MMPA (TGT_SPP_MMPA_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('Sperm Whale - North Atlantic', 724, 'N');
INSERT INTO CCD_TGT_SPP_MMPA (TGT_SPP_MMPA_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('Sperm Whale - North Pacific', 649, 'N');
INSERT INTO CCD_TGT_SPP_MMPA (TGT_SPP_MMPA_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('Sperm Whale - Northern Gulf of Mexico', 725, 'N');
INSERT INTO CCD_TGT_SPP_MMPA (TGT_SPP_MMPA_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('Spinner Dolphin - Hawaii', 650, 'Y');
INSERT INTO CCD_TGT_SPP_MMPA (TGT_SPP_MMPA_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('Spinner Dolphin - Northern Gulf of Mexico', 726, 'N');
INSERT INTO CCD_TGT_SPP_MMPA (TGT_SPP_MMPA_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('Spinner Dolphin - Western North Atlantic', 651, 'N');
INSERT INTO CCD_TGT_SPP_MMPA (TGT_SPP_MMPA_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('Spotted Seal - Alaska', 654, 'N');
INSERT INTO CCD_TGT_SPP_MMPA (TGT_SPP_MMPA_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('Stejneger''s Beaked Whale - Alaska', 580, 'N');
INSERT INTO CCD_TGT_SPP_MMPA (TGT_SPP_MMPA_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('Steller Sea Lion - Eastern', 730, 'N');
INSERT INTO CCD_TGT_SPP_MMPA (TGT_SPP_MMPA_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('Steller Sea Lion - Western', 655, 'N');
INSERT INTO CCD_TGT_SPP_MMPA (TGT_SPP_MMPA_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('Striped Dolphin - California-Oregon-Washington', 731, 'N');
INSERT INTO CCD_TGT_SPP_MMPA (TGT_SPP_MMPA_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('Striped Dolphin - Hawaii', 656, 'Y');
INSERT INTO CCD_TGT_SPP_MMPA (TGT_SPP_MMPA_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('Striped Dolphin - Northern Gulf of Mexico', 732, 'N');
INSERT INTO CCD_TGT_SPP_MMPA (TGT_SPP_MMPA_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('Striped Dolphin - Western North Atlantic', 657, 'N');
INSERT INTO CCD_TGT_SPP_MMPA (TGT_SPP_MMPA_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('True''s Beaked Whale - Western North Atlantic', 668, 'N');
INSERT INTO CCD_TGT_SPP_MMPA (TGT_SPP_MMPA_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('White-Beaked Dolphin - Western North Atlantic', 733, 'N');


--FSSI target species:
INSERT INTO CCD_TGT_SPP_FSSI (TGT_SPP_FSSI_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('Acadian redfish - Gulf of Maine / Georges Bank', 55, 'N');
INSERT INTO CCD_TGT_SPP_FSSI (TGT_SPP_FSSI_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('Alaska plaice - Bering Sea / Aleutian Islands', 149, 'N');
INSERT INTO CCD_TGT_SPP_FSSI (TGT_SPP_FSSI_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('Albacore - North Atlantic', 86, 'N');
INSERT INTO CCD_TGT_SPP_FSSI (TGT_SPP_FSSI_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('Albacore - North Pacific', 87, 'N');
INSERT INTO CCD_TGT_SPP_FSSI (TGT_SPP_FSSI_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('Albacore - South Pacific', 88, 'Y');
INSERT INTO CCD_TGT_SPP_FSSI (TGT_SPP_FSSI_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('American plaice - Gulf of Maine / Georges Bank', 184, 'N');
INSERT INTO CCD_TGT_SPP_FSSI (TGT_SPP_FSSI_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('American Samoa Bottomfish Multi-species Complex', 1, 'Y');
INSERT INTO CCD_TGT_SPP_FSSI (TGT_SPP_FSSI_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('Arrowtooth flounder - Gulf of Alaska', 29, 'Y');
INSERT INTO CCD_TGT_SPP_FSSI (TGT_SPP_FSSI_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('Arrowtooth flounder - Pacific Coast', 30, 'Y');
INSERT INTO CCD_TGT_SPP_FSSI (TGT_SPP_FSSI_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('Atka mackerel - Aleutian Islands', 148, 'Y');
INSERT INTO CCD_TGT_SPP_FSSI (TGT_SPP_FSSI_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('Atlantic cod - Georges Bank', 176, 'N');
INSERT INTO CCD_TGT_SPP_FSSI (TGT_SPP_FSSI_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('Atlantic cod - Gulf of Maine', 177, 'N');
INSERT INTO CCD_TGT_SPP_FSSI (TGT_SPP_FSSI_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('Atlantic halibut - Northwestern Atlantic Coast', 185, 'N');
INSERT INTO CCD_TGT_SPP_FSSI (TGT_SPP_FSSI_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('Atlantic herring - Northwestern Atlantic Coast', 217, 'N');
INSERT INTO CCD_TGT_SPP_FSSI (TGT_SPP_FSSI_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('Atlantic Large Coastal Shark Complex', 2, 'N');
INSERT INTO CCD_TGT_SPP_FSSI (TGT_SPP_FSSI_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('Atlantic mackerel - Gulf of Maine / Cape Hatteras', 37, 'N');
INSERT INTO CCD_TGT_SPP_FSSI (TGT_SPP_FSSI_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('Atlantic sharpnose shark - Atlantic', 31, 'N');
INSERT INTO CCD_TGT_SPP_FSSI (TGT_SPP_FSSI_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('Atlantic Small Coastal Shark Complex', 3, 'N');
INSERT INTO CCD_TGT_SPP_FSSI (TGT_SPP_FSSI_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('Atlantic surfclam - Mid-Atlantic Coast', 77, 'N');
INSERT INTO CCD_TGT_SPP_FSSI (TGT_SPP_FSSI_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('Bank rockfish - California', 69, 'N');
INSERT INTO CCD_TGT_SPP_FSSI (TGT_SPP_FSSI_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('Barndoor skate - Georges Bank / Southern New England', 222, 'N');
INSERT INTO CCD_TGT_SPP_FSSI (TGT_SPP_FSSI_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('Bering Sea / Aleutian Islands Arrowtooth Flounder Complex', 4, 'N');
INSERT INTO CCD_TGT_SPP_FSSI (TGT_SPP_FSSI_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('Bering Sea / Aleutian Islands Blackspotted and Rougheye Rockfish Complex', 5, 'N');
INSERT INTO CCD_TGT_SPP_FSSI (TGT_SPP_FSSI_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('Bering Sea / Aleutian Islands Flathead Sole Complex', 6, 'N');
INSERT INTO CCD_TGT_SPP_FSSI (TGT_SPP_FSSI_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('Bering Sea / Aleutian Islands Rock Sole Complex', 7, 'N');
INSERT INTO CCD_TGT_SPP_FSSI (TGT_SPP_FSSI_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('Bigeye scad - Hawaiian Archipelago', 72, 'N');
INSERT INTO CCD_TGT_SPP_FSSI (TGT_SPP_FSSI_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('Bigeye tuna - Atlantic', 92, 'N');
INSERT INTO CCD_TGT_SPP_FSSI (TGT_SPP_FSSI_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('Bigeye tuna - Pacific', 93, 'N');
INSERT INTO CCD_TGT_SPP_FSSI (TGT_SPP_FSSI_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('Black grouper - Gulf of Mexico', 126, 'N');
INSERT INTO CCD_TGT_SPP_FSSI (TGT_SPP_FSSI_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('Black grouper - Southern Atlantic Coast', 127, 'N');
INSERT INTO CCD_TGT_SPP_FSSI (TGT_SPP_FSSI_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('Black rockfish - Northern Pacific Coast', 60, 'N');
INSERT INTO CCD_TGT_SPP_FSSI (TGT_SPP_FSSI_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('Black sea bass - Mid-Atlantic Coast', 211, 'N');
INSERT INTO CCD_TGT_SPP_FSSI (TGT_SPP_FSSI_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('Black sea bass - Southern Atlantic Coast', 212, 'N');
INSERT INTO CCD_TGT_SPP_FSSI (TGT_SPP_FSSI_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('Blackgill rockfish - Southern California', 61, 'N');
INSERT INTO CCD_TGT_SPP_FSSI (TGT_SPP_FSSI_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('Blacknose shark - Atlantic', 205, 'N');
INSERT INTO CCD_TGT_SPP_FSSI (TGT_SPP_FSSI_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('Blacktip shark - Gulf of Mexico', 207, 'N');
INSERT INTO CCD_TGT_SPP_FSSI (TGT_SPP_FSSI_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('Blacktip shark - South Atlantic', 208, 'N');
INSERT INTO CCD_TGT_SPP_FSSI (TGT_SPP_FSSI_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('Blue king crab - Pribilof Islands', 141, 'N');
INSERT INTO CCD_TGT_SPP_FSSI (TGT_SPP_FSSI_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('Blue king crab - Saint Matthews Island', 142, 'N');
INSERT INTO CCD_TGT_SPP_FSSI (TGT_SPP_FSSI_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('Blue marlin - North Atlantic', 115, 'N');
INSERT INTO CCD_TGT_SPP_FSSI (TGT_SPP_FSSI_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('Blue marlin - Pacific', 116, 'Y');
INSERT INTO CCD_TGT_SPP_FSSI (TGT_SPP_FSSI_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('Blue rockfish - California', 63, 'N');
INSERT INTO CCD_TGT_SPP_FSSI (TGT_SPP_FSSI_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('Blue shark - Atlantic', 153, 'N');
INSERT INTO CCD_TGT_SPP_FSSI (TGT_SPP_FSSI_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('Blue shark - Pacific', 154, 'Y');
INSERT INTO CCD_TGT_SPP_FSSI (TGT_SPP_FSSI_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('Bluefin tuna - Western Atlantic', 95, 'N');
INSERT INTO CCD_TGT_SPP_FSSI (TGT_SPP_FSSI_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('Bluefish - Atlantic Coast', 152, 'N');
INSERT INTO CCD_TGT_SPP_FSSI (TGT_SPP_FSSI_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('Bocaccio - Southern Pacific Coast', 64, 'N');
INSERT INTO CCD_TGT_SPP_FSSI (TGT_SPP_FSSI_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('Bonnethead - Atlantic', 76, 'N');
INSERT INTO CCD_TGT_SPP_FSSI (TGT_SPP_FSSI_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('Brown rock shrimp - Southern Atlantic Coast', 75, 'N');
INSERT INTO CCD_TGT_SPP_FSSI (TGT_SPP_FSSI_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('Brown rockfish - Pacific Coast', 50, 'N');
INSERT INTO CCD_TGT_SPP_FSSI (TGT_SPP_FSSI_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('Brown shrimp - Gulf of Mexico', 169, 'N');
INSERT INTO CCD_TGT_SPP_FSSI (TGT_SPP_FSSI_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('Brown shrimp - Southern Atlantic Coast', 170, 'N');
INSERT INTO CCD_TGT_SPP_FSSI (TGT_SPP_FSSI_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('Butterfish - Gulf of Maine / Cape Hatteras', 144, 'N');
INSERT INTO CCD_TGT_SPP_FSSI (TGT_SPP_FSSI_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('Cabezon - California', 45, 'N');
INSERT INTO CCD_TGT_SPP_FSSI (TGT_SPP_FSSI_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('California scorpionfish - Southern California', 44, 'N');
INSERT INTO CCD_TGT_SPP_FSSI (TGT_SPP_FSSI_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('Canary rockfish - Pacific Coast', 65, 'N');
INSERT INTO CCD_TGT_SPP_FSSI (TGT_SPP_FSSI_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('Caribbean Grouper Unit 1', 8, 'N');
INSERT INTO CCD_TGT_SPP_FSSI (TGT_SPP_FSSI_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('Caribbean Grouper Unit 2', 9, 'N');
INSERT INTO CCD_TGT_SPP_FSSI (TGT_SPP_FSSI_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('Caribbean Grouper Unit 4', 10, 'N');
INSERT INTO CCD_TGT_SPP_FSSI (TGT_SPP_FSSI_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('Caribbean Snapper Unit 1', 11, 'N');
INSERT INTO CCD_TGT_SPP_FSSI (TGT_SPP_FSSI_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('Caribbean Snapper Unit 3', 12, 'N');
INSERT INTO CCD_TGT_SPP_FSSI (TGT_SPP_FSSI_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('Caribbean Snapper Unit 4', 13, 'N');
INSERT INTO CCD_TGT_SPP_FSSI (TGT_SPP_FSSI_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('Caribbean spiny lobster - Caribbean', 134, 'N');
INSERT INTO CCD_TGT_SPP_FSSI (TGT_SPP_FSSI_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('Caribbean spiny lobster - Southern Atlantic Coast / Gulf of Mexico', 135, 'N');
INSERT INTO CCD_TGT_SPP_FSSI (TGT_SPP_FSSI_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('Chilipepper - Southern Pacific Coast', 57, 'N');
INSERT INTO CCD_TGT_SPP_FSSI (TGT_SPP_FSSI_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('Clearnose skate - Southern New England / Mid-Atlantic', 160, 'N');
INSERT INTO CCD_TGT_SPP_FSSI (TGT_SPP_FSSI_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('Cobia - Gulf of Mexico', 159, 'N');
INSERT INTO CCD_TGT_SPP_FSSI (TGT_SPP_FSSI_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('Cowcod - Southern California', 59, 'N');
INSERT INTO CCD_TGT_SPP_FSSI (TGT_SPP_FSSI_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('Darkblotched rockfish - Pacific Coast', 52, 'N');
INSERT INTO CCD_TGT_SPP_FSSI (TGT_SPP_FSSI_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('Dolphinfish - Pacific', 218, 'Y');
INSERT INTO CCD_TGT_SPP_FSSI (TGT_SPP_FSSI_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('Dolphinfish - Southern Atlantic Coast / Gulf of Mexico', 219, 'N');
INSERT INTO CCD_TGT_SPP_FSSI (TGT_SPP_FSSI_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('Dover sole - Pacific Coast', 125, 'N');
INSERT INTO CCD_TGT_SPP_FSSI (TGT_SPP_FSSI_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('Dusky shark - Atlantic', 209, 'N');
INSERT INTO CCD_TGT_SPP_FSSI (TGT_SPP_FSSI_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('English sole - Pacific Coast', 143, 'N');
INSERT INTO CCD_TGT_SPP_FSSI (TGT_SPP_FSSI_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('Finetooth shark - Atlantic', 206, 'N');
INSERT INTO CCD_TGT_SPP_FSSI (TGT_SPP_FSSI_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('Flathead sole - Gulf of Alaska', 183, 'N');
INSERT INTO CCD_TGT_SPP_FSSI (TGT_SPP_FSSI_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('Gag - Gulf of Mexico', 128, 'N');
INSERT INTO CCD_TGT_SPP_FSSI (TGT_SPP_FSSI_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('Gag - Southern Atlantic Coast', 129, 'N');
INSERT INTO CCD_TGT_SPP_FSSI (TGT_SPP_FSSI_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('Golden king crab - Aleutian Islands', 104, 'N');
INSERT INTO CCD_TGT_SPP_FSSI (TGT_SPP_FSSI_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('Goliath grouper - Southern Atlantic Coast / Gulf of Mexico', 228, 'N');
INSERT INTO CCD_TGT_SPP_FSSI (TGT_SPP_FSSI_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('Goosefish - Gulf of Maine / Northern Georges Bank', 109, 'N');
INSERT INTO CCD_TGT_SPP_FSSI (TGT_SPP_FSSI_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('Goosefish - Southern Georges Bank / Mid-Atlantic', 110, 'N');
INSERT INTO CCD_TGT_SPP_FSSI (TGT_SPP_FSSI_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('Gopher rockfish - Northern California', 51, 'N');
INSERT INTO CCD_TGT_SPP_FSSI (TGT_SPP_FSSI_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('Gray triggerfish - Gulf of Mexico', 203, 'N');
INSERT INTO CCD_TGT_SPP_FSSI (TGT_SPP_FSSI_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('Gray triggerfish - Southern Atlantic Coast', 204, 'N');
INSERT INTO CCD_TGT_SPP_FSSI (TGT_SPP_FSSI_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('Greater amberjack - Gulf of Mexico', 73, 'N');
INSERT INTO CCD_TGT_SPP_FSSI (TGT_SPP_FSSI_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('Greater amberjack - Southern Atlantic Coast', 74, 'N');
INSERT INTO CCD_TGT_SPP_FSSI (TGT_SPP_FSSI_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('Greenland halibut - Bering Sea / Aleutian Islands', 162, 'N');
INSERT INTO CCD_TGT_SPP_FSSI (TGT_SPP_FSSI_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('Guam Bottomfish Multi-species Complex', 14, 'N');
INSERT INTO CCD_TGT_SPP_FSSI (TGT_SPP_FSSI_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('Gulf of Alaska Blackspotted and Rougheye Rockfish Complex', 15, 'N');
INSERT INTO CCD_TGT_SPP_FSSI (TGT_SPP_FSSI_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('Gulf of Alaska Deepwater Flatfish Complex', 16, 'N');
INSERT INTO CCD_TGT_SPP_FSSI (TGT_SPP_FSSI_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('Gulf of Alaska Demersal Shelf Rockfish Complex', 17, 'N');
INSERT INTO CCD_TGT_SPP_FSSI (TGT_SPP_FSSI_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('Gulf of Alaska Pelagic Shelf Rockfish Complex', 18, 'N');
INSERT INTO CCD_TGT_SPP_FSSI (TGT_SPP_FSSI_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('Gulf of Alaska Thornyhead Rockfish Complex', 19, 'N');
INSERT INTO CCD_TGT_SPP_FSSI (TGT_SPP_FSSI_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('Haddock - Georges Bank', 118, 'N');
INSERT INTO CCD_TGT_SPP_FSSI (TGT_SPP_FSSI_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('Haddock - Gulf of Maine', 119, 'N');
INSERT INTO CCD_TGT_SPP_FSSI (TGT_SPP_FSSI_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('Hancock Seamount Groundfish Complex', 20, 'N');
INSERT INTO CCD_TGT_SPP_FSSI (TGT_SPP_FSSI_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('Hawaiian Archipelago Bottomfish Multi-species Complex', 21, 'Y');
INSERT INTO CCD_TGT_SPP_FSSI (TGT_SPP_FSSI_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('Hawaiian Archipelago Coral Reef Ecosystem Multi-species Complex', 22, 'Y');
INSERT INTO CCD_TGT_SPP_FSSI (TGT_SPP_FSSI_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('Hogfish - Gulf of Mexico', 194, 'N');
INSERT INTO CCD_TGT_SPP_FSSI (TGT_SPP_FSSI_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('Hogfish - Southern Atlantic Coast', 195, 'N');
INSERT INTO CCD_TGT_SPP_FSSI (TGT_SPP_FSSI_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('Jack mackerel - Pacific Coast', 96, 'N');
INSERT INTO CCD_TGT_SPP_FSSI (TGT_SPP_FSSI_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('Kawakawa - Tropical Pacific', 167, 'Y');
INSERT INTO CCD_TGT_SPP_FSSI (TGT_SPP_FSSI_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('Kelp greenling - Oregon', 182, 'N');
INSERT INTO CCD_TGT_SPP_FSSI (TGT_SPP_FSSI_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('King mackerel - Gulf of Mexico', 38, 'N');
INSERT INTO CCD_TGT_SPP_FSSI (TGT_SPP_FSSI_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('King mackerel - Southern Atlantic Coast', 39, 'N');
INSERT INTO CCD_TGT_SPP_FSSI (TGT_SPP_FSSI_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('Lingcod - Pacific Coast', 132, 'N');
INSERT INTO CCD_TGT_SPP_FSSI (TGT_SPP_FSSI_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('Little skate - Georges Bank / Southern New England', 97, 'N');
INSERT INTO CCD_TGT_SPP_FSSI (TGT_SPP_FSSI_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('Little tunny - Gulf of Mexico', 168, 'N');
INSERT INTO CCD_TGT_SPP_FSSI (TGT_SPP_FSSI_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('Longfin inshore squid - Georges Bank / Cape Hatteras', 108, 'N');
INSERT INTO CCD_TGT_SPP_FSSI (TGT_SPP_FSSI_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('Longnose skate - Pacific Coast', 161, 'N');
INSERT INTO CCD_TGT_SPP_FSSI (TGT_SPP_FSSI_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('Longspine thornyhead - Pacific Coast', 71, 'N');
INSERT INTO CCD_TGT_SPP_FSSI (TGT_SPP_FSSI_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('Mackerel scad - Hawaiian Archipelago', 221, 'N');
INSERT INTO CCD_TGT_SPP_FSSI (TGT_SPP_FSSI_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('Nassau grouper - Gulf of Mexico', 166, 'N');
INSERT INTO CCD_TGT_SPP_FSSI (TGT_SPP_FSSI_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('Northern anchovy - Northern Pacific Coast', 223, 'N');
INSERT INTO CCD_TGT_SPP_FSSI (TGT_SPP_FSSI_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('Northern anchovy - Southern Pacific Coast', 224, 'N');
INSERT INTO CCD_TGT_SPP_FSSI (TGT_SPP_FSSI_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('Northern rockfish - Bering Sea / Aleutian Islands', 66, 'N');
INSERT INTO CCD_TGT_SPP_FSSI (TGT_SPP_FSSI_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('Northern rockfish - Western / Central Gulf of Alaska', 67, 'N');
INSERT INTO CCD_TGT_SPP_FSSI (TGT_SPP_FSSI_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('Northern shortfin squid - Northwestern Atlantic Coast', 186, 'N');
INSERT INTO CCD_TGT_SPP_FSSI (TGT_SPP_FSSI_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('Ocean pout - Northwestern Atlantic Coast', 28, 'N');
INSERT INTO CCD_TGT_SPP_FSSI (TGT_SPP_FSSI_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('Ocean quahog - Atlantic Coast', 202, 'N');
INSERT INTO CCD_TGT_SPP_FSSI (TGT_SPP_FSSI_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('Offshore hake - Northwestern Atlantic Coast', 121, 'N');
INSERT INTO CCD_TGT_SPP_FSSI (TGT_SPP_FSSI_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('Opah - Pacific', 197, 'Y');
INSERT INTO CCD_TGT_SPP_FSSI (TGT_SPP_FSSI_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('Opalescent inshore squid - Pacific Coast', 107, 'N');
INSERT INTO CCD_TGT_SPP_FSSI (TGT_SPP_FSSI_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('Pacific bluefin tuna - Pacific', 94, 'N');
INSERT INTO CCD_TGT_SPP_FSSI (TGT_SPP_FSSI_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('Pacific chub mackerel - Pacific Coast', 36, 'N');
INSERT INTO CCD_TGT_SPP_FSSI (TGT_SPP_FSSI_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('Pacific cod - Bering Sea / Aleutian Islands', 173, 'N');
INSERT INTO CCD_TGT_SPP_FSSI (TGT_SPP_FSSI_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('Pacific cod - Gulf of Alaska', 174, 'N');
INSERT INTO CCD_TGT_SPP_FSSI (TGT_SPP_FSSI_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('Pacific cod - Pacific Coast', 175, 'N');
INSERT INTO CCD_TGT_SPP_FSSI (TGT_SPP_FSSI_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('Pacific grenadier - Pacific Coast', 220, 'N');
INSERT INTO CCD_TGT_SPP_FSSI (TGT_SPP_FSSI_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('Pacific hake - Pacific Coast', 124, 'N');
INSERT INTO CCD_TGT_SPP_FSSI (TGT_SPP_FSSI_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('Pacific ocean perch - Bering Sea / Aleutian Islands', 47, 'N');
INSERT INTO CCD_TGT_SPP_FSSI (TGT_SPP_FSSI_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('Pacific ocean perch - Gulf of Alaska', 48, 'N');
INSERT INTO CCD_TGT_SPP_FSSI (TGT_SPP_FSSI_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('Pacific ocean perch - Pacific Coast', 49, 'N');
INSERT INTO CCD_TGT_SPP_FSSI (TGT_SPP_FSSI_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('Pacific sanddab - Pacific Coast', 216, 'N');
INSERT INTO CCD_TGT_SPP_FSSI (TGT_SPP_FSSI_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('Pacific sardine - Pacific Coast', 34, 'N');
INSERT INTO CCD_TGT_SPP_FSSI (TGT_SPP_FSSI_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('Petrale sole - Pacific Coast', 225, 'N');
INSERT INTO CCD_TGT_SPP_FSSI (TGT_SPP_FSSI_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('Pink shrimp - Gulf of Mexico', 171, 'N');
INSERT INTO CCD_TGT_SPP_FSSI (TGT_SPP_FSSI_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('Pink shrimp - Southern Atlantic Coast', 172, 'N');
INSERT INTO CCD_TGT_SPP_FSSI (TGT_SPP_FSSI_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('Pollock - Gulf of Maine / Georges Bank', 150, 'N');
INSERT INTO CCD_TGT_SPP_FSSI (TGT_SPP_FSSI_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('Porbeagle - Atlantic', 196, 'N');
INSERT INTO CCD_TGT_SPP_FSSI (TGT_SPP_FSSI_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('Queen conch - Caribbean', 81, 'N');
INSERT INTO CCD_TGT_SPP_FSSI (TGT_SPP_FSSI_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('Red deepsea crab - Northwestern Atlantic', 213, 'N');
INSERT INTO CCD_TGT_SPP_FSSI (TGT_SPP_FSSI_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('Red drum - Gulf of Mexico', 35, 'N');
INSERT INTO CCD_TGT_SPP_FSSI (TGT_SPP_FSSI_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('Red grouper - Gulf of Mexico', 229, 'N');
INSERT INTO CCD_TGT_SPP_FSSI (TGT_SPP_FSSI_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('Red grouper - Southern Atlantic Coast', 230, 'N');
INSERT INTO CCD_TGT_SPP_FSSI (TGT_SPP_FSSI_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('Red hake - Gulf of Maine / Northern Georges Bank', 23, 'N');
INSERT INTO CCD_TGT_SPP_FSSI (TGT_SPP_FSSI_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('Red hake - Southern Georges Bank / Mid-Atlantic', 24, 'N');
INSERT INTO CCD_TGT_SPP_FSSI (TGT_SPP_FSSI_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('Red king crab - Bristol Bay', 137, 'N');
INSERT INTO CCD_TGT_SPP_FSSI (TGT_SPP_FSSI_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('Red king crab - Norton Sound', 138, 'N');
INSERT INTO CCD_TGT_SPP_FSSI (TGT_SPP_FSSI_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('Red king crab - Pribilof Islands', 139, 'N');
INSERT INTO CCD_TGT_SPP_FSSI (TGT_SPP_FSSI_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('Red king crab - Western Aleutian Islands', 140, 'N');
INSERT INTO CCD_TGT_SPP_FSSI (TGT_SPP_FSSI_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('Red porgy - Southern Atlantic Coast', 133, 'N');
INSERT INTO CCD_TGT_SPP_FSSI (TGT_SPP_FSSI_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('Red snapper - Gulf of Mexico', 113, 'N');
INSERT INTO CCD_TGT_SPP_FSSI (TGT_SPP_FSSI_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('Red snapper - Southern Atlantic Coast', 114, 'N');
INSERT INTO CCD_TGT_SPP_FSSI (TGT_SPP_FSSI_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('Rex sole - Gulf of Alaska', 179, 'N');
INSERT INTO CCD_TGT_SPP_FSSI (TGT_SPP_FSSI_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('Rex sole - Pacific Coast', 180, 'N');
INSERT INTO CCD_TGT_SPP_FSSI (TGT_SPP_FSSI_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('Rosette skate - Southern New England / Mid-Atlantic', 98, 'N');
INSERT INTO CCD_TGT_SPP_FSSI (TGT_SPP_FSSI_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('Rougheye rockfish - Pacific Coast', 46, 'N');
INSERT INTO CCD_TGT_SPP_FSSI (TGT_SPP_FSSI_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('Royal red shrimp - Gulf of Mexico', 147, 'N');
INSERT INTO CCD_TGT_SPP_FSSI (TGT_SPP_FSSI_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('Sablefish - Eastern Bering Sea / Aleutian Islands / Gulf of Alaska', 200, 'N');
INSERT INTO CCD_TGT_SPP_FSSI (TGT_SPP_FSSI_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('Sablefish - Pacific Coast', 201, 'N');
INSERT INTO CCD_TGT_SPP_FSSI (TGT_SPP_FSSI_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('Sailfish - Western Atlantic', 187, 'N');
INSERT INTO CCD_TGT_SPP_FSSI (TGT_SPP_FSSI_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('Sand sole - Pacific Coast', 155, 'N');
INSERT INTO CCD_TGT_SPP_FSSI (TGT_SPP_FSSI_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('Sandbar shark - Atlantic', 210, 'N');
INSERT INTO CCD_TGT_SPP_FSSI (TGT_SPP_FSSI_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('Scamp - Southern Atlantic Coast', 130, 'N');
INSERT INTO CCD_TGT_SPP_FSSI (TGT_SPP_FSSI_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('Scup - Atlantic Coast', 80, 'N');
INSERT INTO CCD_TGT_SPP_FSSI (TGT_SPP_FSSI_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('Sea scallop - Northwestern Atlantic Coast', 145, 'N');
INSERT INTO CCD_TGT_SPP_FSSI (TGT_SPP_FSSI_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('Shortbelly rockfish - Pacific Coast', 58, 'N');
INSERT INTO CCD_TGT_SPP_FSSI (TGT_SPP_FSSI_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('Shortbill spearfish - Pacific', 82, 'Y');
INSERT INTO CCD_TGT_SPP_FSSI (TGT_SPP_FSSI_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('Shortfin mako - Atlantic', 188, 'N');
INSERT INTO CCD_TGT_SPP_FSSI (TGT_SPP_FSSI_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('Shortspine thornyhead - Pacific Coast', 70, 'N');
INSERT INTO CCD_TGT_SPP_FSSI (TGT_SPP_FSSI_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('Silver hake - Gulf of Maine / Northern Georges Bank', 122, 'N');
INSERT INTO CCD_TGT_SPP_FSSI (TGT_SPP_FSSI_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('Silver hake - Southern Georges Bank / Mid-Atlantic', 123, 'N');
INSERT INTO CCD_TGT_SPP_FSSI (TGT_SPP_FSSI_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('Skipjack tuna - Central Western Pacific', 192, 'N');
INSERT INTO CCD_TGT_SPP_FSSI (TGT_SPP_FSSI_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('Skipjack tuna - Eastern Tropical Pacific', 193, 'N');
INSERT INTO CCD_TGT_SPP_FSSI (TGT_SPP_FSSI_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('Smooth skate - Gulf of Maine', 117, 'N');
INSERT INTO CCD_TGT_SPP_FSSI (TGT_SPP_FSSI_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('Snow crab - Bering Sea', 215, 'N');
INSERT INTO CCD_TGT_SPP_FSSI (TGT_SPP_FSSI_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('Snowy grouper - Gulf of Mexico', 164, 'N');
INSERT INTO CCD_TGT_SPP_FSSI (TGT_SPP_FSSI_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('Snowy grouper - Southern Atlantic Coast', 165, 'N');
INSERT INTO CCD_TGT_SPP_FSSI (TGT_SPP_FSSI_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('Southern Tanner crab - Bering Sea', 214, 'N');
INSERT INTO CCD_TGT_SPP_FSSI (TGT_SPP_FSSI_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('Spanish mackerel - Gulf of Mexico', 40, 'N');
INSERT INTO CCD_TGT_SPP_FSSI (TGT_SPP_FSSI_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('Spanish mackerel - Southern Atlantic Coast', 41, 'N');
INSERT INTO CCD_TGT_SPP_FSSI (TGT_SPP_FSSI_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('Speckled hind - Southern Atlantic Coast', 226, 'N');
INSERT INTO CCD_TGT_SPP_FSSI (TGT_SPP_FSSI_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('Spiny dogfish - Atlantic Coast', 78, 'N');
INSERT INTO CCD_TGT_SPP_FSSI (TGT_SPP_FSSI_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('Spiny dogfish - Pacific Coast', 79, 'N');
INSERT INTO CCD_TGT_SPP_FSSI (TGT_SPP_FSSI_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('Splitnose rockfish - Pacific Coast', 53, 'N');
INSERT INTO CCD_TGT_SPP_FSSI (TGT_SPP_FSSI_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('Starry flounder - Pacific Coast', 146, 'N');
INSERT INTO CCD_TGT_SPP_FSSI (TGT_SPP_FSSI_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('Stone crabs (Menippe spp.) - Gulf of Mexico', 120, 'N');
INSERT INTO CCD_TGT_SPP_FSSI (TGT_SPP_FSSI_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('Striped marlin - Central Western Pacific', 190, 'N');
INSERT INTO CCD_TGT_SPP_FSSI (TGT_SPP_FSSI_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('Striped marlin - Eastern Tropical Pacific', 191, 'N');
INSERT INTO CCD_TGT_SPP_FSSI (TGT_SPP_FSSI_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('Summer flounder - Mid-Atlantic Coast', 136, 'N');
INSERT INTO CCD_TGT_SPP_FSSI (TGT_SPP_FSSI_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('Swordfish - North Atlantic', 26, 'N');
INSERT INTO CCD_TGT_SPP_FSSI (TGT_SPP_FSSI_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('Swordfish - North Pacific', 27, 'N');
INSERT INTO CCD_TGT_SPP_FSSI (TGT_SPP_FSSI_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('Thorny skate - Gulf of Maine', 199, 'N');
INSERT INTO CCD_TGT_SPP_FSSI (TGT_SPP_FSSI_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('Tilefish - Mid-Atlantic Coast', 111, 'N');
INSERT INTO CCD_TGT_SPP_FSSI (TGT_SPP_FSSI_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('Tilefish - Southern Atlantic Coast', 112, 'N');
INSERT INTO CCD_TGT_SPP_FSSI (TGT_SPP_FSSI_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('Vermilion rockfish - California', 62, 'N');
INSERT INTO CCD_TGT_SPP_FSSI (TGT_SPP_FSSI_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('Vermilion snapper - Gulf of Mexico', 32, 'N');
INSERT INTO CCD_TGT_SPP_FSSI (TGT_SPP_FSSI_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('Vermilion snapper - Southern Atlantic Coast', 33, 'N');
INSERT INTO CCD_TGT_SPP_FSSI (TGT_SPP_FSSI_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('Wahoo - Pacific', 198, 'Y');
INSERT INTO CCD_TGT_SPP_FSSI (TGT_SPP_FSSI_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('Walleye pollock - Aleutian Islands', 83, 'N');
INSERT INTO CCD_TGT_SPP_FSSI (TGT_SPP_FSSI_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('Walleye pollock - Eastern Bering Sea', 84, 'N');
INSERT INTO CCD_TGT_SPP_FSSI (TGT_SPP_FSSI_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('Walleye pollock - Western / Central Gulf of Alaska', 85, 'N');
INSERT INTO CCD_TGT_SPP_FSSI (TGT_SPP_FSSI_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('Warsaw grouper - Southern Atlantic Coast', 163, 'N');
INSERT INTO CCD_TGT_SPP_FSSI (TGT_SPP_FSSI_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('White grunt - Southern Atlantic Coast', 181, 'N');
INSERT INTO CCD_TGT_SPP_FSSI (TGT_SPP_FSSI_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('White hake - Gulf of Maine / Georges Bank', 25, 'N');
INSERT INTO CCD_TGT_SPP_FSSI (TGT_SPP_FSSI_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('White marlin - North Atlantic', 189, 'N');
INSERT INTO CCD_TGT_SPP_FSSI (TGT_SPP_FSSI_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('White shrimp - Gulf of Mexico', 105, 'N');
INSERT INTO CCD_TGT_SPP_FSSI (TGT_SPP_FSSI_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('White shrimp - Southern Atlantic Coast', 106, 'N');
INSERT INTO CCD_TGT_SPP_FSSI (TGT_SPP_FSSI_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('Widow rockfish - Pacific Coast', 54, 'N');
INSERT INTO CCD_TGT_SPP_FSSI (TGT_SPP_FSSI_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('Windowpane - Gulf of Maine / Georges Bank', 42, 'N');
INSERT INTO CCD_TGT_SPP_FSSI (TGT_SPP_FSSI_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('Windowpane - Southern New England / Mid-Atlantic', 43, 'N');
INSERT INTO CCD_TGT_SPP_FSSI (TGT_SPP_FSSI_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('Winter flounder - Georges Bank', 156, 'N');
INSERT INTO CCD_TGT_SPP_FSSI (TGT_SPP_FSSI_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('Winter flounder - Gulf of Maine', 157, 'N');
INSERT INTO CCD_TGT_SPP_FSSI (TGT_SPP_FSSI_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('Winter flounder - Southern New England / Mid-Atlantic', 158, 'N');
INSERT INTO CCD_TGT_SPP_FSSI (TGT_SPP_FSSI_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('Winter skate - Georges Bank / Southern New England', 99, 'N');
INSERT INTO CCD_TGT_SPP_FSSI (TGT_SPP_FSSI_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('Witch flounder - Northwestern Atlantic Coast', 178, 'N');
INSERT INTO CCD_TGT_SPP_FSSI (TGT_SPP_FSSI_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('Wreckfish - Southern Atlantic Coast', 151, 'N');
INSERT INTO CCD_TGT_SPP_FSSI (TGT_SPP_FSSI_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('Yellowedge grouper - Gulf of Mexico', 227, 'N');
INSERT INTO CCD_TGT_SPP_FSSI (TGT_SPP_FSSI_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('Yelloweye rockfish - Pacific Coast', 68, 'N');
INSERT INTO CCD_TGT_SPP_FSSI (TGT_SPP_FSSI_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('Yellowfin sole - Bering Sea / Aleutian Islands', 100, 'N');
INSERT INTO CCD_TGT_SPP_FSSI (TGT_SPP_FSSI_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('Yellowfin tuna - Central Western Pacific', 89, 'Y');
INSERT INTO CCD_TGT_SPP_FSSI (TGT_SPP_FSSI_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('Yellowfin tuna - Eastern Tropical Pacific', 90, 'N');
INSERT INTO CCD_TGT_SPP_FSSI (TGT_SPP_FSSI_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('Yellowfin tuna - Western Atlantic', 91, 'N');
INSERT INTO CCD_TGT_SPP_FSSI (TGT_SPP_FSSI_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('Yellowtail flounder - Cape Cod / Gulf of Maine', 101, 'N');
INSERT INTO CCD_TGT_SPP_FSSI (TGT_SPP_FSSI_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('Yellowtail flounder - Georges Bank', 102, 'N');
INSERT INTO CCD_TGT_SPP_FSSI (TGT_SPP_FSSI_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('Yellowtail flounder - Southern New England / Mid-Atlantic', 103, 'N');
INSERT INTO CCD_TGT_SPP_FSSI (TGT_SPP_FSSI_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('Yellowtail rockfish - Northern Pacific Coast', 56, 'N');
INSERT INTO CCD_TGT_SPP_FSSI (TGT_SPP_FSSI_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('Yellowtail snapper - Southern Atlantic Coast / Gulf of Mexico', 131, 'N');






--expected species categories:
INSERT INTO CCD_EXP_SPP_CATS (EXP_SPP_CAT_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('Algae', 24, 'Y' );
INSERT INTO CCD_EXP_SPP_CATS (EXP_SPP_CAT_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('Coral-Deep Water Coral', 18, 'N' );
INSERT INTO CCD_EXP_SPP_CATS (EXP_SPP_CAT_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('Coral-Hermatypic Stony Coral', 7, 'Y' );
INSERT INTO CCD_EXP_SPP_CATS (EXP_SPP_CAT_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('Coral-Hydrocoral', 14, 'N' );
INSERT INTO CCD_EXP_SPP_CATS (EXP_SPP_CAT_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('Coral-Mesophotic Hermatypic Coral', 8, 'Y' );
INSERT INTO CCD_EXP_SPP_CATS (EXP_SPP_CAT_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('Coral-Octocoral', 1, 'Y' );
INSERT INTO CCD_EXP_SPP_CATS (EXP_SPP_CAT_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('Coral-Shallow Water Coral', 9, 'Y' );
INSERT INTO CCD_EXP_SPP_CATS (EXP_SPP_CAT_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('Crustaceans', 19, 'Y' );
INSERT INTO CCD_EXP_SPP_CATS (EXP_SPP_CAT_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('Fish-General', 21, 'Y' );
INSERT INTO CCD_EXP_SPP_CATS (EXP_SPP_CAT_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('Fishes-Benthic Fish', 15, 'Y' );
INSERT INTO CCD_EXP_SPP_CATS (EXP_SPP_CAT_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('Fishes-Larval Reef Fish', 5, 'N' );
INSERT INTO CCD_EXP_SPP_CATS (EXP_SPP_CAT_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('Fishes-Pelagic Fish', 16, 'Y' );
INSERT INTO CCD_EXP_SPP_CATS (EXP_SPP_CAT_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('Fishes-Reef Fish', 20, 'Y' );
INSERT INTO CCD_EXP_SPP_CATS (EXP_SPP_CAT_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('Fishes-Shark', 23, 'Y' );
INSERT INTO CCD_EXP_SPP_CATS (EXP_SPP_CAT_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('Ichthyoplankton', 2, 'N' );
INSERT INTO CCD_EXP_SPP_CATS (EXP_SPP_CAT_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('Invertebrate-Benthic', 10, 'Y' );
INSERT INTO CCD_EXP_SPP_CATS (EXP_SPP_CAT_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('Invertebrate-General', 3, 'Y' );
INSERT INTO CCD_EXP_SPP_CATS (EXP_SPP_CAT_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('Invertebrate-Pelagic', 11, 'N' );
INSERT INTO CCD_EXP_SPP_CATS (EXP_SPP_CAT_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('Marine Mammal', 22, 'N' );
INSERT INTO CCD_EXP_SPP_CATS (EXP_SPP_CAT_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('Microbes', 17, 'N' );
INSERT INTO CCD_EXP_SPP_CATS (EXP_SPP_CAT_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('Phytoplankton', 12, 'N' );
INSERT INTO CCD_EXP_SPP_CATS (EXP_SPP_CAT_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('Sea Bird', 13, 'N' );
INSERT INTO CCD_EXP_SPP_CATS (EXP_SPP_CAT_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('Sea Grass', 4, 'N' );
INSERT INTO CCD_EXP_SPP_CATS (EXP_SPP_CAT_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('Sea Turtle', 25, 'Y' );
INSERT INTO CCD_EXP_SPP_CATS (EXP_SPP_CAT_NAME, FINSS_ID, APP_SHOW_OPT_YN) VALUES ('Zooplankton', 6, 'N' );



--science centers:
INSERT INTO CCD_SCI_CENTERS (SCI_CENTER_NAME) VALUES ('AFSC');
INSERT INTO CCD_SCI_CENTERS (SCI_CENTER_NAME) VALUES ('NEFSC');
INSERT INTO CCD_SCI_CENTERS (SCI_CENTER_NAME) VALUES ('NWFSC');
INSERT INTO CCD_SCI_CENTERS (SCI_CENTER_NAME) VALUES ('PIFSC');
INSERT INTO CCD_SCI_CENTERS (SCI_CENTER_NAME) VALUES ('SEFSC');
INSERT INTO CCD_SCI_CENTERS (SCI_CENTER_NAME) VALUES ('ST');
INSERT INTO CCD_SCI_CENTERS (SCI_CENTER_NAME) VALUES ('SWFSC');


--science center divisions
INSERT INTO CCD_SCI_CENTER_DIVS (SCI_CENTER_DIV_CODE, SCI_CENTER_DIV_NAME, SCI_CENTER_DIV_DESC, SCI_CENTER_ID) VALUES ('FRMD', 'Fisheries Research and Monitoring Division', '', (SELECT SCI_CENTER_ID FROM CCD_SCI_CENTERS WHERE SCI_CENTER_NAME = 'PIFSC'));
INSERT INTO CCD_SCI_CENTER_DIVS (SCI_CENTER_DIV_CODE, SCI_CENTER_DIV_NAME, SCI_CENTER_DIV_DESC, SCI_CENTER_ID) VALUES ('ESD', 'Ecosystem Sciences Division', '', (SELECT SCI_CENTER_ID FROM CCD_SCI_CENTERS WHERE SCI_CENTER_NAME = 'PIFSC'));
INSERT INTO CCD_SCI_CENTER_DIVS (SCI_CENTER_DIV_CODE, SCI_CENTER_DIV_NAME, SCI_CENTER_DIV_DESC, SCI_CENTER_ID) VALUES ('PSD', 'Protected Species Division', '', (SELECT SCI_CENTER_ID FROM CCD_SCI_CENTERS WHERE SCI_CENTER_NAME = 'PIFSC'));










--load the gear presets
insert into CCD_GEAR_PRE (GEAR_PRE_NAME, GEAR_PRE_DESC) VALUES ('Hawaii Bottomfish', 'Main Hawaiian Island (MHI) Insular Bottomfish');
insert into CCD_GEAR_PRE (GEAR_PRE_NAME, GEAR_PRE_DESC) VALUES ('Hawaii Life History', 'Hawaiian Archipelago Life History Bio-sampling');
insert into CCD_GEAR_PRE (GEAR_PRE_NAME, GEAR_PRE_DESC) VALUES ('Marine Debris', 'Marine Debris Research and Removal');
insert into CCD_GEAR_PRE (GEAR_PRE_NAME, GEAR_PRE_DESC) VALUES ('HICEAS', 'Hawaiian Islands Cetacean and Ecosystem Assessment Survey (HICEAS)');
insert into CCD_GEAR_PRE (GEAR_PRE_NAME, GEAR_PRE_DESC) VALUES ('HMSEAS Leg 1', 'Hawaiian Monk Seal Enhancement and Survey Cruise (HMSEAS) Leg 1 (pulled info from FINSS for SE-19-03)');
insert into CCD_GEAR_PRE (GEAR_PRE_NAME, GEAR_PRE_DESC) VALUES ('HMSEAS Leg 2', 'Hawaiian Monk Seal Enhancement and Survey Cruise (HMSEAS) Leg 2 (pulled info from FINSS for SE-19-05)');


--load the gear preset options
insert into CCD_GEAR_PRE_OPTS (GEAR_PRE_ID, GEAR_ID, GEAR_PRE_OPT_NOTES) VALUES ((SELECT GEAR_PRE_ID FROM CCD_GEAR_PRE WHERE GEAR_PRE_NAME = 'Hawaii Life History'), (SELECT GEAR_ID FROM CCD_GEAR WHERE GEAR_NAME = 'BotCam (baited camera stations)'), '');
insert into CCD_GEAR_PRE_OPTS (GEAR_PRE_ID, GEAR_ID, GEAR_PRE_OPT_NOTES) VALUES ((SELECT GEAR_PRE_ID FROM CCD_GEAR_PRE WHERE GEAR_PRE_NAME = 'Hawaii Life History'), (SELECT GEAR_ID FROM CCD_GEAR WHERE GEAR_NAME = 'CTD'), '');
insert into CCD_GEAR_PRE_OPTS (GEAR_PRE_ID, GEAR_ID, GEAR_PRE_OPT_NOTES) VALUES ((SELECT GEAR_PRE_ID FROM CCD_GEAR_PRE WHERE GEAR_PRE_NAME = 'Hawaii Life History'), (SELECT GEAR_ID FROM CCD_GEAR WHERE GEAR_NAME = 'Handline'), '');
insert into CCD_GEAR_PRE_OPTS (GEAR_PRE_ID, GEAR_ID, GEAR_PRE_OPT_NOTES) VALUES ((SELECT GEAR_PRE_ID FROM CCD_GEAR_PRE WHERE GEAR_PRE_NAME = 'Hawaii Life History'), (SELECT GEAR_ID FROM CCD_GEAR WHERE GEAR_NAME = 'Hook and Line'), '');
insert into CCD_GEAR_PRE_OPTS (GEAR_PRE_ID, GEAR_ID, GEAR_PRE_OPT_NOTES) VALUES ((SELECT GEAR_PRE_ID FROM CCD_GEAR_PRE WHERE GEAR_PRE_NAME = 'Hawaii Bottomfish'), (SELECT GEAR_ID FROM CCD_GEAR WHERE GEAR_NAME = 'BotCam (baited camera stations)'), '');
insert into CCD_GEAR_PRE_OPTS (GEAR_PRE_ID, GEAR_ID, GEAR_PRE_OPT_NOTES) VALUES ((SELECT GEAR_PRE_ID FROM CCD_GEAR_PRE WHERE GEAR_PRE_NAME = 'Hawaii Bottomfish'), (SELECT GEAR_ID FROM CCD_GEAR WHERE GEAR_NAME = 'CTD'), '');
insert into CCD_GEAR_PRE_OPTS (GEAR_PRE_ID, GEAR_ID, GEAR_PRE_OPT_NOTES) VALUES ((SELECT GEAR_PRE_ID FROM CCD_GEAR_PRE WHERE GEAR_PRE_NAME = 'Hawaii Bottomfish'), (SELECT GEAR_ID FROM CCD_GEAR WHERE GEAR_NAME = 'Handline'), '');
insert into CCD_GEAR_PRE_OPTS (GEAR_PRE_ID, GEAR_ID, GEAR_PRE_OPT_NOTES) VALUES ((SELECT GEAR_PRE_ID FROM CCD_GEAR_PRE WHERE GEAR_PRE_NAME = 'Hawaii Bottomfish'), (SELECT GEAR_ID FROM CCD_GEAR WHERE GEAR_NAME = 'Temperature Depth Recorders (TDRs)'), '');
insert into CCD_GEAR_PRE_OPTS (GEAR_PRE_ID, GEAR_ID, GEAR_PRE_OPT_NOTES) VALUES ((SELECT GEAR_PRE_ID FROM CCD_GEAR_PRE WHERE GEAR_PRE_NAME = 'Marine Debris'), (SELECT GEAR_ID FROM CCD_GEAR WHERE GEAR_NAME = 'Others'), '');
insert into CCD_GEAR_PRE_OPTS (GEAR_PRE_ID, GEAR_ID, GEAR_PRE_OPT_NOTES) VALUES ((SELECT GEAR_PRE_ID FROM CCD_GEAR_PRE WHERE GEAR_PRE_NAME = 'Marine Debris'), (SELECT GEAR_ID FROM CCD_GEAR WHERE GEAR_NAME = 'SCUBA'), '');
insert into CCD_GEAR_PRE_OPTS (GEAR_PRE_ID, GEAR_ID, GEAR_PRE_OPT_NOTES) VALUES ((SELECT GEAR_PRE_ID FROM CCD_GEAR_PRE WHERE GEAR_PRE_NAME = 'HICEAS'), (SELECT GEAR_ID FROM CCD_GEAR WHERE GEAR_NAME = 'Binoculars'), '');
insert into CCD_GEAR_PRE_OPTS (GEAR_PRE_ID, GEAR_ID, GEAR_PRE_OPT_NOTES) VALUES ((SELECT GEAR_PRE_ID FROM CCD_GEAR_PRE WHERE GEAR_PRE_NAME = 'HICEAS'), (SELECT GEAR_ID FROM CCD_GEAR WHERE GEAR_NAME = 'Biopsy'), '');
insert into CCD_GEAR_PRE_OPTS (GEAR_PRE_ID, GEAR_ID, GEAR_PRE_OPT_NOTES) VALUES ((SELECT GEAR_PRE_ID FROM CCD_GEAR_PRE WHERE GEAR_PRE_NAME = 'HICEAS'), (SELECT GEAR_ID FROM CCD_GEAR WHERE GEAR_NAME = 'High-frequency Autonomous Acoustic Recording Package (HARP)'), '');
insert into CCD_GEAR_PRE_OPTS (GEAR_PRE_ID, GEAR_ID, GEAR_PRE_OPT_NOTES) VALUES ((SELECT GEAR_PRE_ID FROM CCD_GEAR_PRE WHERE GEAR_PRE_NAME = 'HICEAS'), (SELECT GEAR_ID FROM CCD_GEAR WHERE GEAR_NAME = 'Human Observation'), '');
insert into CCD_GEAR_PRE_OPTS (GEAR_PRE_ID, GEAR_ID, GEAR_PRE_OPT_NOTES) VALUES ((SELECT GEAR_PRE_ID FROM CCD_GEAR_PRE WHERE GEAR_PRE_NAME = 'HICEAS'), (SELECT GEAR_ID FROM CCD_GEAR WHERE GEAR_NAME = 'Others'), '');
insert into CCD_GEAR_PRE_OPTS (GEAR_PRE_ID, GEAR_ID, GEAR_PRE_OPT_NOTES) VALUES ((SELECT GEAR_PRE_ID FROM CCD_GEAR_PRE WHERE GEAR_PRE_NAME = 'HICEAS'), (SELECT GEAR_ID FROM CCD_GEAR WHERE GEAR_NAME = 'Towed Hydrophone Array'), '');
insert into CCD_GEAR_PRE_OPTS (GEAR_PRE_ID, GEAR_ID, GEAR_PRE_OPT_NOTES) VALUES ((SELECT GEAR_PRE_ID FROM CCD_GEAR_PRE WHERE GEAR_PRE_NAME = 'HICEAS'), (SELECT GEAR_ID FROM CCD_GEAR WHERE GEAR_NAME = 'Visual Census'), '');
insert into CCD_GEAR_PRE_OPTS (GEAR_PRE_ID, GEAR_ID, GEAR_PRE_OPT_NOTES) VALUES ((SELECT GEAR_PRE_ID FROM CCD_GEAR_PRE WHERE GEAR_PRE_NAME = 'HMSEAS Leg 1'), (SELECT GEAR_ID FROM CCD_GEAR WHERE GEAR_NAME = 'Binoculars'), '');
insert into CCD_GEAR_PRE_OPTS (GEAR_PRE_ID, GEAR_ID, GEAR_PRE_OPT_NOTES) VALUES ((SELECT GEAR_PRE_ID FROM CCD_GEAR_PRE WHERE GEAR_PRE_NAME = 'HMSEAS Leg 1'), (SELECT GEAR_ID FROM CCD_GEAR WHERE GEAR_NAME = 'Biopsy'), '');
insert into CCD_GEAR_PRE_OPTS (GEAR_PRE_ID, GEAR_ID, GEAR_PRE_OPT_NOTES) VALUES ((SELECT GEAR_PRE_ID FROM CCD_GEAR_PRE WHERE GEAR_PRE_NAME = 'HMSEAS Leg 1'), (SELECT GEAR_ID FROM CCD_GEAR WHERE GEAR_NAME = 'CTD'), '');
insert into CCD_GEAR_PRE_OPTS (GEAR_PRE_ID, GEAR_ID, GEAR_PRE_OPT_NOTES) VALUES ((SELECT GEAR_PRE_ID FROM CCD_GEAR_PRE WHERE GEAR_PRE_NAME = 'HMSEAS Leg 1'), (SELECT GEAR_ID FROM CCD_GEAR WHERE GEAR_NAME = 'High-frequency Autonomous Acoustic Recording Package (HARP)'), '');
insert into CCD_GEAR_PRE_OPTS (GEAR_PRE_ID, GEAR_ID, GEAR_PRE_OPT_NOTES) VALUES ((SELECT GEAR_PRE_ID FROM CCD_GEAR_PRE WHERE GEAR_PRE_NAME = 'HMSEAS Leg 1'), (SELECT GEAR_ID FROM CCD_GEAR WHERE GEAR_NAME = 'Human Observation'), '');
insert into CCD_GEAR_PRE_OPTS (GEAR_PRE_ID, GEAR_ID, GEAR_PRE_OPT_NOTES) VALUES ((SELECT GEAR_PRE_ID FROM CCD_GEAR_PRE WHERE GEAR_PRE_NAME = 'HMSEAS Leg 1'), (SELECT GEAR_ID FROM CCD_GEAR WHERE GEAR_NAME = 'Tags (satellite, acoustic and others)'), '');
insert into CCD_GEAR_PRE_OPTS (GEAR_PRE_ID, GEAR_ID, GEAR_PRE_OPT_NOTES) VALUES ((SELECT GEAR_PRE_ID FROM CCD_GEAR_PRE WHERE GEAR_PRE_NAME = 'HMSEAS Leg 1'), (SELECT GEAR_ID FROM CCD_GEAR WHERE GEAR_NAME = 'Visual Census'), '');
insert into CCD_GEAR_PRE_OPTS (GEAR_PRE_ID, GEAR_ID, GEAR_PRE_OPT_NOTES) VALUES ((SELECT GEAR_PRE_ID FROM CCD_GEAR_PRE WHERE GEAR_PRE_NAME = 'HMSEAS Leg 2'), (SELECT GEAR_ID FROM CCD_GEAR WHERE GEAR_NAME = 'Binoculars'), '');
insert into CCD_GEAR_PRE_OPTS (GEAR_PRE_ID, GEAR_ID, GEAR_PRE_OPT_NOTES) VALUES ((SELECT GEAR_PRE_ID FROM CCD_GEAR_PRE WHERE GEAR_PRE_NAME = 'HMSEAS Leg 2'), (SELECT GEAR_ID FROM CCD_GEAR WHERE GEAR_NAME = 'Biopsy'), '');
insert into CCD_GEAR_PRE_OPTS (GEAR_PRE_ID, GEAR_ID, GEAR_PRE_OPT_NOTES) VALUES ((SELECT GEAR_PRE_ID FROM CCD_GEAR_PRE WHERE GEAR_PRE_NAME = 'HMSEAS Leg 2'), (SELECT GEAR_ID FROM CCD_GEAR WHERE GEAR_NAME = 'CTD'), '');
insert into CCD_GEAR_PRE_OPTS (GEAR_PRE_ID, GEAR_ID, GEAR_PRE_OPT_NOTES) VALUES ((SELECT GEAR_PRE_ID FROM CCD_GEAR_PRE WHERE GEAR_PRE_NAME = 'HMSEAS Leg 2'), (SELECT GEAR_ID FROM CCD_GEAR WHERE GEAR_NAME = 'Human Observation'), '');
insert into CCD_GEAR_PRE_OPTS (GEAR_PRE_ID, GEAR_ID, GEAR_PRE_OPT_NOTES) VALUES ((SELECT GEAR_PRE_ID FROM CCD_GEAR_PRE WHERE GEAR_PRE_NAME = 'HMSEAS Leg 2'), (SELECT GEAR_ID FROM CCD_GEAR WHERE GEAR_NAME = 'PIT Tags'), '');
insert into CCD_GEAR_PRE_OPTS (GEAR_PRE_ID, GEAR_ID, GEAR_PRE_OPT_NOTES) VALUES ((SELECT GEAR_PRE_ID FROM CCD_GEAR_PRE WHERE GEAR_PRE_NAME = 'HMSEAS Leg 2'), (SELECT GEAR_ID FROM CCD_GEAR WHERE GEAR_NAME = 'Tags (satellite, acoustic and others)'), '');
insert into CCD_GEAR_PRE_OPTS (GEAR_PRE_ID, GEAR_ID, GEAR_PRE_OPT_NOTES) VALUES ((SELECT GEAR_PRE_ID FROM CCD_GEAR_PRE WHERE GEAR_PRE_NAME = 'HMSEAS Leg 2'), (SELECT GEAR_ID FROM CCD_GEAR WHERE GEAR_NAME = 'Visual Census'), '');


--load regional ecosystem presets:
insert into CCD_REG_ECO_PRE (REG_ECO_PRE_NAME, REG_ECO_PRE_DESC) VALUES ('Pacific Islands', 'Pacific Islands Ecosystem');

--load regional ecosystem preset options:
insert into CCD_REG_ECO_PRE_OPTS (REG_ECO_PRE_ID, REG_ECOSYSTEM_ID, REG_ECO_PRE_OPT_NOTES) VALUES ((SELECT REG_ECO_PRE_ID FROM CCD_REG_ECO_PRE WHERE REG_ECO_PRE_NAME = 'Pacific Islands'), (SELECT REG_ECOSYSTEM_ID FROM CCD_REG_ECOSYSTEMS WHERE REG_ECOSYSTEM_NAME = 'Pacific Islands Ecosystem Complex'), '');



--load region presets:
insert into CCD_REGION_PRE (REGION_PRE_NAME, REGION_PRE_DESC) VALUES ('AMSM and PRIA', 'Transit to America Samoa including PRIA surveys');
insert into CCD_REGION_PRE (REGION_PRE_NAME, REGION_PRE_DESC) VALUES ('MHI and PRIA', 'Surveys of the Main Hawaiian Islands and PRIA');
insert into CCD_REGION_PRE (REGION_PRE_NAME, REGION_PRE_DESC) VALUES ('CNMI and PRIA', 'Transit to Marianas with survey of Wake Island');
insert into CCD_REGION_PRE (REGION_PRE_NAME, REGION_PRE_DESC) VALUES ('NWHI and PRIA', 'Surveys of the Northwestern Hawaiian Islands and PRIA');
insert into CCD_REGION_PRE (REGION_PRE_NAME, REGION_PRE_DESC) VALUES ('MHI and NWHI', 'Surveys of the Main Hawaiian Islands and Northwestern Hawaiian Islands');



--load region preset options:
insert into CCD_REGION_PRE_OPTS (REGION_PRE_ID, REGION_ID, REGION_PRE_OPT_NOTES) VALUES ((SELECT REGION_PRE_ID FROM CCD_REGION_PRE WHERE REGION_PRE_NAME = 'AMSM and PRIA'), (SELECT REGION_ID FROM CCD_REGIONS WHERE REGION_NAME = 'American Samoa'), '');
insert into CCD_REGION_PRE_OPTS (REGION_PRE_ID, REGION_ID, REGION_PRE_OPT_NOTES) VALUES ((SELECT REGION_PRE_ID FROM CCD_REGION_PRE WHERE REGION_PRE_NAME = 'AMSM and PRIA'), (SELECT REGION_ID FROM CCD_REGIONS WHERE REGION_NAME = 'Pacific Remote Island Areas'), '');
insert into CCD_REGION_PRE_OPTS (REGION_PRE_ID, REGION_ID, REGION_PRE_OPT_NOTES) VALUES ((SELECT REGION_PRE_ID FROM CCD_REGION_PRE WHERE REGION_PRE_NAME = 'MHI and PRIA'), (SELECT REGION_ID FROM CCD_REGIONS WHERE REGION_NAME = 'Main Hawaiian Islands'), '');
insert into CCD_REGION_PRE_OPTS (REGION_PRE_ID, REGION_ID, REGION_PRE_OPT_NOTES) VALUES ((SELECT REGION_PRE_ID FROM CCD_REGION_PRE WHERE REGION_PRE_NAME = 'MHI and PRIA'), (SELECT REGION_ID FROM CCD_REGIONS WHERE REGION_NAME = 'Pacific Remote Island Areas'), '');
insert into CCD_REGION_PRE_OPTS (REGION_PRE_ID, REGION_ID, REGION_PRE_OPT_NOTES) VALUES ((SELECT REGION_PRE_ID FROM CCD_REGION_PRE WHERE REGION_PRE_NAME = 'CNMI and PRIA'), (SELECT REGION_ID FROM CCD_REGIONS WHERE REGION_NAME = 'Commonwealth of the Northern Mariana Islands'), '');
insert into CCD_REGION_PRE_OPTS (REGION_PRE_ID, REGION_ID, REGION_PRE_OPT_NOTES) VALUES ((SELECT REGION_PRE_ID FROM CCD_REGION_PRE WHERE REGION_PRE_NAME = 'CNMI and PRIA'), (SELECT REGION_ID FROM CCD_REGIONS WHERE REGION_NAME = 'Pacific Remote Island Areas'), '');
insert into CCD_REGION_PRE_OPTS (REGION_PRE_ID, REGION_ID, REGION_PRE_OPT_NOTES) VALUES ((SELECT REGION_PRE_ID FROM CCD_REGION_PRE WHERE REGION_PRE_NAME = 'NWHI and PRIA'), (SELECT REGION_ID FROM CCD_REGIONS WHERE REGION_NAME = 'Northwest Hawaiian Islands'), '');
insert into CCD_REGION_PRE_OPTS (REGION_PRE_ID, REGION_ID, REGION_PRE_OPT_NOTES) VALUES ((SELECT REGION_PRE_ID FROM CCD_REGION_PRE WHERE REGION_PRE_NAME = 'NWHI and PRIA'), (SELECT REGION_ID FROM CCD_REGIONS WHERE REGION_NAME = 'Pacific Remote Island Areas'), '');
insert into CCD_REGION_PRE_OPTS (REGION_PRE_ID, REGION_ID, REGION_PRE_OPT_NOTES) VALUES ((SELECT REGION_PRE_ID FROM CCD_REGION_PRE WHERE REGION_PRE_NAME = 'MHI and NWHI'), (SELECT REGION_ID FROM CCD_REGIONS WHERE REGION_NAME = 'Northwest Hawaiian Islands'), '');
insert into CCD_REGION_PRE_OPTS (REGION_PRE_ID, REGION_ID, REGION_PRE_OPT_NOTES) VALUES ((SELECT REGION_PRE_ID FROM CCD_REGION_PRE WHERE REGION_PRE_NAME = 'MHI and NWHI'), (SELECT REGION_ID FROM CCD_REGIONS WHERE REGION_NAME = 'Main Hawaiian Islands'), '');


--load survey category presets:
insert into CCD_SVY_CAT_PRE (SVY_CAT_PRE_NAME, SVY_CAT_PRE_DESC, SVY_CAT_PRIMARY_YN) VALUES ('PSD', 'PSD Primary Survey Category', 'Y');
insert into CCD_SVY_CAT_PRE (SVY_CAT_PRE_NAME, SVY_CAT_PRE_DESC, SVY_CAT_PRIMARY_YN) VALUES ('BFISH', 'Bottomfish Primary Survey Category', 'Y');
insert into CCD_SVY_CAT_PRE (SVY_CAT_PRE_NAME, SVY_CAT_PRE_DESC, SVY_CAT_PRIMARY_YN) VALUES ('RAMP', 'Reef Assessment and Monitoring Program ', 'Y');
insert into CCD_SVY_CAT_PRE (SVY_CAT_PRE_NAME, SVY_CAT_PRE_DESC, SVY_CAT_PRIMARY_YN) VALUES ('Fisheries Oceanography', 'Fisheries Oceanography - Pelagic Ecosystem Characterization', 'Y');
insert into CCD_SVY_CAT_PRE (SVY_CAT_PRE_NAME, SVY_CAT_PRE_DESC, SVY_CAT_PRIMARY_YN) VALUES ('Science, Services and Stewardship', 'PIFSC Secondary Survey Category', 'N');
insert into CCD_SVY_CAT_PRE (SVY_CAT_PRE_NAME, SVY_CAT_PRE_DESC, SVY_CAT_PRIMARY_YN) VALUES ('Fisheries Research', 'Fisheries Research Primary Survey Category', 'Y');
insert into CCD_SVY_CAT_PRE (SVY_CAT_PRE_NAME, SVY_CAT_PRE_DESC, SVY_CAT_PRIMARY_YN) VALUES ('HI-TEC', 'Hawaiian Islands: Technology for the Ecology of Cetacean', 'Y');
insert into CCD_SVY_CAT_PRE (SVY_CAT_PRE_NAME, SVY_CAT_PRE_DESC, SVY_CAT_PRIMARY_YN) VALUES ('Life History', 'Life History Bio-Sampling', 'Y');
insert into CCD_SVY_CAT_PRE (SVY_CAT_PRE_NAME, SVY_CAT_PRE_DESC, SVY_CAT_PRIMARY_YN) VALUES ('Marine Debris', 'Marine Debris Research and Removal', 'Y');

--load survey category preset options:
insert into CCD_SVY_CAT_PRE_OPTS (SVY_CAT_PRE_ID, SVY_CAT_ID, SVY_CAT_PRE_OPT_NOTES) VALUES ((SELECT SVY_CAT_PRE_ID FROM CCD_SVY_CAT_PRE WHERE SVY_CAT_PRE_NAME = 'PSD'), (SELECT SVY_CAT_ID FROM CCD_SVY_CATS WHERE SVY_CAT_NAME = 'Protected Species Monitoring and Assessment'), '');
insert into CCD_SVY_CAT_PRE_OPTS (SVY_CAT_PRE_ID, SVY_CAT_ID, SVY_CAT_PRE_OPT_NOTES) VALUES ((SELECT SVY_CAT_PRE_ID FROM CCD_SVY_CAT_PRE WHERE SVY_CAT_PRE_NAME = 'PSD'), (SELECT SVY_CAT_ID FROM CCD_SVY_CATS WHERE SVY_CAT_NAME = 'Science, Services and Stewardship'), '');
insert into CCD_SVY_CAT_PRE_OPTS (SVY_CAT_PRE_ID, SVY_CAT_ID, SVY_CAT_PRE_OPT_NOTES) VALUES ((SELECT SVY_CAT_PRE_ID FROM CCD_SVY_CAT_PRE WHERE SVY_CAT_PRE_NAME = 'BFISH'), (SELECT SVY_CAT_ID FROM CCD_SVY_CATS WHERE SVY_CAT_NAME = 'Fisheries Monitoring and Assessment'), '');
insert into CCD_SVY_CAT_PRE_OPTS (SVY_CAT_PRE_ID, SVY_CAT_ID, SVY_CAT_PRE_OPT_NOTES) VALUES ((SELECT SVY_CAT_PRE_ID FROM CCD_SVY_CAT_PRE WHERE SVY_CAT_PRE_NAME = 'BFISH'), (SELECT SVY_CAT_ID FROM CCD_SVY_CATS WHERE SVY_CAT_NAME = 'Science, Services and Stewardship'), '');
insert into CCD_SVY_CAT_PRE_OPTS (SVY_CAT_PRE_ID, SVY_CAT_ID, SVY_CAT_PRE_OPT_NOTES) VALUES ((SELECT SVY_CAT_PRE_ID FROM CCD_SVY_CAT_PRE WHERE SVY_CAT_PRE_NAME = 'RAMP'), (SELECT SVY_CAT_ID FROM CCD_SVY_CATS WHERE SVY_CAT_NAME = 'Ecosystem Monitoring and Assessment'), '');
insert into CCD_SVY_CAT_PRE_OPTS (SVY_CAT_PRE_ID, SVY_CAT_ID, SVY_CAT_PRE_OPT_NOTES) VALUES ((SELECT SVY_CAT_PRE_ID FROM CCD_SVY_CAT_PRE WHERE SVY_CAT_PRE_NAME = 'RAMP'), (SELECT SVY_CAT_ID FROM CCD_SVY_CATS WHERE SVY_CAT_NAME = 'Fisheries Monitoring and Assessment'), '');
insert into CCD_SVY_CAT_PRE_OPTS (SVY_CAT_PRE_ID, SVY_CAT_ID, SVY_CAT_PRE_OPT_NOTES) VALUES ((SELECT SVY_CAT_PRE_ID FROM CCD_SVY_CAT_PRE WHERE SVY_CAT_PRE_NAME = 'RAMP'), (SELECT SVY_CAT_ID FROM CCD_SVY_CATS WHERE SVY_CAT_NAME = 'Habitat Monitoring and Assessment'), '');
insert into CCD_SVY_CAT_PRE_OPTS (SVY_CAT_PRE_ID, SVY_CAT_ID, SVY_CAT_PRE_OPT_NOTES) VALUES ((SELECT SVY_CAT_PRE_ID FROM CCD_SVY_CAT_PRE WHERE SVY_CAT_PRE_NAME = 'Fisheries Oceanography'), (SELECT SVY_CAT_ID FROM CCD_SVY_CATS WHERE SVY_CAT_NAME = 'Ecosystem Monitoring and Assessment'), '');
insert into CCD_SVY_CAT_PRE_OPTS (SVY_CAT_PRE_ID, SVY_CAT_ID, SVY_CAT_PRE_OPT_NOTES) VALUES ((SELECT SVY_CAT_PRE_ID FROM CCD_SVY_CAT_PRE WHERE SVY_CAT_PRE_NAME = 'Fisheries Oceanography'), (SELECT SVY_CAT_ID FROM CCD_SVY_CATS WHERE SVY_CAT_NAME = 'Fisheries Monitoring and Assessment'), '');
insert into CCD_SVY_CAT_PRE_OPTS (SVY_CAT_PRE_ID, SVY_CAT_ID, SVY_CAT_PRE_OPT_NOTES) VALUES ((SELECT SVY_CAT_PRE_ID FROM CCD_SVY_CAT_PRE WHERE SVY_CAT_PRE_NAME = 'Fisheries Oceanography'), (SELECT SVY_CAT_ID FROM CCD_SVY_CATS WHERE SVY_CAT_NAME = 'Science, Services and Stewardship'), '');
insert into CCD_SVY_CAT_PRE_OPTS (SVY_CAT_PRE_ID, SVY_CAT_ID, SVY_CAT_PRE_OPT_NOTES) VALUES ((SELECT SVY_CAT_PRE_ID FROM CCD_SVY_CAT_PRE WHERE SVY_CAT_PRE_NAME = 'Fisheries Research'), (SELECT SVY_CAT_ID FROM CCD_SVY_CATS WHERE SVY_CAT_NAME = 'Ecosystem Monitoring and Assessment'), '');
insert into CCD_SVY_CAT_PRE_OPTS (SVY_CAT_PRE_ID, SVY_CAT_ID, SVY_CAT_PRE_OPT_NOTES) VALUES ((SELECT SVY_CAT_PRE_ID FROM CCD_SVY_CAT_PRE WHERE SVY_CAT_PRE_NAME = 'Fisheries Research'), (SELECT SVY_CAT_ID FROM CCD_SVY_CATS WHERE SVY_CAT_NAME = 'Fisheries Monitoring and Assessment'), '');
insert into CCD_SVY_CAT_PRE_OPTS (SVY_CAT_PRE_ID, SVY_CAT_ID, SVY_CAT_PRE_OPT_NOTES) VALUES ((SELECT SVY_CAT_PRE_ID FROM CCD_SVY_CAT_PRE WHERE SVY_CAT_PRE_NAME = 'Fisheries Research'), (SELECT SVY_CAT_ID FROM CCD_SVY_CATS WHERE SVY_CAT_NAME = 'Habitat Monitoring and Assessment'), '');
insert into CCD_SVY_CAT_PRE_OPTS (SVY_CAT_PRE_ID, SVY_CAT_ID, SVY_CAT_PRE_OPT_NOTES) VALUES ((SELECT SVY_CAT_PRE_ID FROM CCD_SVY_CAT_PRE WHERE SVY_CAT_PRE_NAME = 'Fisheries Research'), (SELECT SVY_CAT_ID FROM CCD_SVY_CATS WHERE SVY_CAT_NAME = 'Protected Species Monitoring and Assessment'), '');
insert into CCD_SVY_CAT_PRE_OPTS (SVY_CAT_PRE_ID, SVY_CAT_ID, SVY_CAT_PRE_OPT_NOTES) VALUES ((SELECT SVY_CAT_PRE_ID FROM CCD_SVY_CAT_PRE WHERE SVY_CAT_PRE_NAME = 'Fisheries Research'), (SELECT SVY_CAT_ID FROM CCD_SVY_CATS WHERE SVY_CAT_NAME = 'Science, Services and Stewardship'), '');
insert into CCD_SVY_CAT_PRE_OPTS (SVY_CAT_PRE_ID, SVY_CAT_ID, SVY_CAT_PRE_OPT_NOTES) VALUES ((SELECT SVY_CAT_PRE_ID FROM CCD_SVY_CAT_PRE WHERE SVY_CAT_PRE_NAME = 'Science, Services and Stewardship'), (SELECT SVY_CAT_ID FROM CCD_SVY_CATS WHERE SVY_CAT_NAME = 'Science, Services and Stewardship'), '');
insert into CCD_SVY_CAT_PRE_OPTS (SVY_CAT_PRE_ID, SVY_CAT_ID, SVY_CAT_PRE_OPT_NOTES) VALUES ((SELECT SVY_CAT_PRE_ID FROM CCD_SVY_CAT_PRE WHERE SVY_CAT_PRE_NAME = 'HI-TEC'), (SELECT SVY_CAT_ID FROM CCD_SVY_CATS WHERE SVY_CAT_NAME = 'Habitat Monitoring and Assessment'), '');
insert into CCD_SVY_CAT_PRE_OPTS (SVY_CAT_PRE_ID, SVY_CAT_ID, SVY_CAT_PRE_OPT_NOTES) VALUES ((SELECT SVY_CAT_PRE_ID FROM CCD_SVY_CAT_PRE WHERE SVY_CAT_PRE_NAME = 'HI-TEC'), (SELECT SVY_CAT_ID FROM CCD_SVY_CATS WHERE SVY_CAT_NAME = 'Protected Species Monitoring and Assessment'), '');
insert into CCD_SVY_CAT_PRE_OPTS (SVY_CAT_PRE_ID, SVY_CAT_ID, SVY_CAT_PRE_OPT_NOTES) VALUES ((SELECT SVY_CAT_PRE_ID FROM CCD_SVY_CAT_PRE WHERE SVY_CAT_PRE_NAME = 'HI-TEC'), (SELECT SVY_CAT_ID FROM CCD_SVY_CATS WHERE SVY_CAT_NAME = 'Science, Services and Stewardship'), '');
insert into CCD_SVY_CAT_PRE_OPTS (SVY_CAT_PRE_ID, SVY_CAT_ID, SVY_CAT_PRE_OPT_NOTES) VALUES ((SELECT SVY_CAT_PRE_ID FROM CCD_SVY_CAT_PRE WHERE SVY_CAT_PRE_NAME = 'Life History'), (SELECT SVY_CAT_ID FROM CCD_SVY_CATS WHERE SVY_CAT_NAME = 'Fisheries Monitoring and Assessment'), '');
insert into CCD_SVY_CAT_PRE_OPTS (SVY_CAT_PRE_ID, SVY_CAT_ID, SVY_CAT_PRE_OPT_NOTES) VALUES ((SELECT SVY_CAT_PRE_ID FROM CCD_SVY_CAT_PRE WHERE SVY_CAT_PRE_NAME = 'Life History'), (SELECT SVY_CAT_ID FROM CCD_SVY_CATS WHERE SVY_CAT_NAME = 'Habitat Monitoring and Assessment'), '');
insert into CCD_SVY_CAT_PRE_OPTS (SVY_CAT_PRE_ID, SVY_CAT_ID, SVY_CAT_PRE_OPT_NOTES) VALUES ((SELECT SVY_CAT_PRE_ID FROM CCD_SVY_CAT_PRE WHERE SVY_CAT_PRE_NAME = 'Marine Debris'), (SELECT SVY_CAT_ID FROM CCD_SVY_CATS WHERE SVY_CAT_NAME = 'Debris Cleanup'), '');


--load MMPA target species presets:
insert into CCD_SPP_MMPA_PRE (MMPA_PRE_NAME, MMPA_PRE_DESC) VALUES ('IEA', 'Integrated Ecosystem Assessment');
insert into CCD_SPP_MMPA_PRE (MMPA_PRE_NAME, MMPA_PRE_DESC) VALUES ('HMSEAS', 'Hawaiian Monk Seal Enhancement and Survey Cruise');
insert into CCD_SPP_MMPA_PRE (MMPA_PRE_NAME, MMPA_PRE_DESC) VALUES ('HICEAS', 'PIFSC - Hawaiian Islands Cetacean and Ecosystem Assessment Survey');
insert into CCD_SPP_MMPA_PRE (MMPA_PRE_NAME, MMPA_PRE_DESC) VALUES ('MACS', 'Mariana Archipelago Cetacean Survey (MACS)');


--load MMPA target species preset options:
insert into CCD_SPP_MMPA_PRE_OPTS (MMPA_PRE_ID, TGT_SPP_MMPA_ID, MMPA_PRE_OPT_NOTES) VALUES ((SELECT MMPA_PRE_ID FROM CCD_SPP_MMPA_PRE WHERE MMPA_PRE_NAME = 'IEA'), (SELECT TGT_SPP_MMPA_ID FROM CCD_TGT_SPP_MMPA WHERE TGT_SPP_MMPA_NAME = 'Baird''s Beaked Whale - California-Oregon-Washington'), '');
insert into CCD_SPP_MMPA_PRE_OPTS (MMPA_PRE_ID, TGT_SPP_MMPA_ID, MMPA_PRE_OPT_NOTES) VALUES ((SELECT MMPA_PRE_ID FROM CCD_SPP_MMPA_PRE WHERE MMPA_PRE_NAME = 'IEA'), (SELECT TGT_SPP_MMPA_ID FROM CCD_TGT_SPP_MMPA WHERE TGT_SPP_MMPA_NAME = 'Blainville''s Beaked Whale - Western North Atlantic'), '');
insert into CCD_SPP_MMPA_PRE_OPTS (MMPA_PRE_ID, TGT_SPP_MMPA_ID, MMPA_PRE_OPT_NOTES) VALUES ((SELECT MMPA_PRE_ID FROM CCD_SPP_MMPA_PRE WHERE MMPA_PRE_NAME = 'IEA'), (SELECT TGT_SPP_MMPA_ID FROM CCD_TGT_SPP_MMPA WHERE TGT_SPP_MMPA_NAME = 'Bottlenose Dolphin - Hawaii'), '');
insert into CCD_SPP_MMPA_PRE_OPTS (MMPA_PRE_ID, TGT_SPP_MMPA_ID, MMPA_PRE_OPT_NOTES) VALUES ((SELECT MMPA_PRE_ID FROM CCD_SPP_MMPA_PRE WHERE MMPA_PRE_NAME = 'IEA'), (SELECT TGT_SPP_MMPA_ID FROM CCD_TGT_SPP_MMPA WHERE TGT_SPP_MMPA_NAME = 'Cuvier''s Beaked Whale - Western North Atlantic'), '');
insert into CCD_SPP_MMPA_PRE_OPTS (MMPA_PRE_ID, TGT_SPP_MMPA_ID, MMPA_PRE_OPT_NOTES) VALUES ((SELECT MMPA_PRE_ID FROM CCD_SPP_MMPA_PRE WHERE MMPA_PRE_NAME = 'IEA'), (SELECT TGT_SPP_MMPA_ID FROM CCD_TGT_SPP_MMPA WHERE TGT_SPP_MMPA_NAME = 'Dwarf Sperm Whale - Hawaii'), '');
insert into CCD_SPP_MMPA_PRE_OPTS (MMPA_PRE_ID, TGT_SPP_MMPA_ID, MMPA_PRE_OPT_NOTES) VALUES ((SELECT MMPA_PRE_ID FROM CCD_SPP_MMPA_PRE WHERE MMPA_PRE_NAME = 'IEA'), (SELECT TGT_SPP_MMPA_ID FROM CCD_TGT_SPP_MMPA WHERE TGT_SPP_MMPA_NAME = 'False Killer Whale - Hawaii'), '');
insert into CCD_SPP_MMPA_PRE_OPTS (MMPA_PRE_ID, TGT_SPP_MMPA_ID, MMPA_PRE_OPT_NOTES) VALUES ((SELECT MMPA_PRE_ID FROM CCD_SPP_MMPA_PRE WHERE MMPA_PRE_NAME = 'IEA'), (SELECT TGT_SPP_MMPA_ID FROM CCD_TGT_SPP_MMPA WHERE TGT_SPP_MMPA_NAME = 'Fraser''s Dolphin - Hawaii'), '');
insert into CCD_SPP_MMPA_PRE_OPTS (MMPA_PRE_ID, TGT_SPP_MMPA_ID, MMPA_PRE_OPT_NOTES) VALUES ((SELECT MMPA_PRE_ID FROM CCD_SPP_MMPA_PRE WHERE MMPA_PRE_NAME = 'IEA'), (SELECT TGT_SPP_MMPA_ID FROM CCD_TGT_SPP_MMPA WHERE TGT_SPP_MMPA_NAME = 'Long-Finned Pilot Whale - Western North Atlantic'), '');
insert into CCD_SPP_MMPA_PRE_OPTS (MMPA_PRE_ID, TGT_SPP_MMPA_ID, MMPA_PRE_OPT_NOTES) VALUES ((SELECT MMPA_PRE_ID FROM CCD_SPP_MMPA_PRE WHERE MMPA_PRE_NAME = 'IEA'), (SELECT TGT_SPP_MMPA_ID FROM CCD_TGT_SPP_MMPA WHERE TGT_SPP_MMPA_NAME = 'Melon-Headed Whale - Hawaii'), '');
insert into CCD_SPP_MMPA_PRE_OPTS (MMPA_PRE_ID, TGT_SPP_MMPA_ID, MMPA_PRE_OPT_NOTES) VALUES ((SELECT MMPA_PRE_ID FROM CCD_SPP_MMPA_PRE WHERE MMPA_PRE_NAME = 'IEA'), (SELECT TGT_SPP_MMPA_ID FROM CCD_TGT_SPP_MMPA WHERE TGT_SPP_MMPA_NAME = 'Pacific White-Sided Dolphin - North Pacific, formerly Central North Pacific'), '');
insert into CCD_SPP_MMPA_PRE_OPTS (MMPA_PRE_ID, TGT_SPP_MMPA_ID, MMPA_PRE_OPT_NOTES) VALUES ((SELECT MMPA_PRE_ID FROM CCD_SPP_MMPA_PRE WHERE MMPA_PRE_NAME = 'IEA'), (SELECT TGT_SPP_MMPA_ID FROM CCD_TGT_SPP_MMPA WHERE TGT_SPP_MMPA_NAME = 'Pygmy Killer Whale - Hawaii'), '');
insert into CCD_SPP_MMPA_PRE_OPTS (MMPA_PRE_ID, TGT_SPP_MMPA_ID, MMPA_PRE_OPT_NOTES) VALUES ((SELECT MMPA_PRE_ID FROM CCD_SPP_MMPA_PRE WHERE MMPA_PRE_NAME = 'IEA'), (SELECT TGT_SPP_MMPA_ID FROM CCD_TGT_SPP_MMPA WHERE TGT_SPP_MMPA_NAME = 'Pygmy Sperm Whale - Hawaii'), '');
insert into CCD_SPP_MMPA_PRE_OPTS (MMPA_PRE_ID, TGT_SPP_MMPA_ID, MMPA_PRE_OPT_NOTES) VALUES ((SELECT MMPA_PRE_ID FROM CCD_SPP_MMPA_PRE WHERE MMPA_PRE_NAME = 'IEA'), (SELECT TGT_SPP_MMPA_ID FROM CCD_TGT_SPP_MMPA WHERE TGT_SPP_MMPA_NAME = 'Risso''s Dolphin - Hawaii'), '');
insert into CCD_SPP_MMPA_PRE_OPTS (MMPA_PRE_ID, TGT_SPP_MMPA_ID, MMPA_PRE_OPT_NOTES) VALUES ((SELECT MMPA_PRE_ID FROM CCD_SPP_MMPA_PRE WHERE MMPA_PRE_NAME = 'IEA'), (SELECT TGT_SPP_MMPA_ID FROM CCD_TGT_SPP_MMPA WHERE TGT_SPP_MMPA_NAME = 'Short-Finned Pilot Whale - Western North Atlantic'), '');
insert into CCD_SPP_MMPA_PRE_OPTS (MMPA_PRE_ID, TGT_SPP_MMPA_ID, MMPA_PRE_OPT_NOTES) VALUES ((SELECT MMPA_PRE_ID FROM CCD_SPP_MMPA_PRE WHERE MMPA_PRE_NAME = 'IEA'), (SELECT TGT_SPP_MMPA_ID FROM CCD_TGT_SPP_MMPA WHERE TGT_SPP_MMPA_NAME = 'Sperm Whale - Hawaii'), '');
insert into CCD_SPP_MMPA_PRE_OPTS (MMPA_PRE_ID, TGT_SPP_MMPA_ID, MMPA_PRE_OPT_NOTES) VALUES ((SELECT MMPA_PRE_ID FROM CCD_SPP_MMPA_PRE WHERE MMPA_PRE_NAME = 'IEA'), (SELECT TGT_SPP_MMPA_ID FROM CCD_TGT_SPP_MMPA WHERE TGT_SPP_MMPA_NAME = 'Spinner Dolphin - Hawaii'), '');
insert into CCD_SPP_MMPA_PRE_OPTS (MMPA_PRE_ID, TGT_SPP_MMPA_ID, MMPA_PRE_OPT_NOTES) VALUES ((SELECT MMPA_PRE_ID FROM CCD_SPP_MMPA_PRE WHERE MMPA_PRE_NAME = 'IEA'), (SELECT TGT_SPP_MMPA_ID FROM CCD_TGT_SPP_MMPA WHERE TGT_SPP_MMPA_NAME = 'Striped Dolphin - Hawaii'), '');
insert into CCD_SPP_MMPA_PRE_OPTS (MMPA_PRE_ID, TGT_SPP_MMPA_ID, MMPA_PRE_OPT_NOTES) VALUES ((SELECT MMPA_PRE_ID FROM CCD_SPP_MMPA_PRE WHERE MMPA_PRE_NAME = 'HMSEAS'), (SELECT TGT_SPP_MMPA_ID FROM CCD_TGT_SPP_MMPA WHERE TGT_SPP_MMPA_NAME = 'Hawaiian Monk Seal - Hawaii'), '');
insert into CCD_SPP_MMPA_PRE_OPTS (MMPA_PRE_ID, TGT_SPP_MMPA_ID, MMPA_PRE_OPT_NOTES) VALUES ((SELECT MMPA_PRE_ID FROM CCD_SPP_MMPA_PRE WHERE MMPA_PRE_NAME = 'HICEAS'), (SELECT TGT_SPP_MMPA_ID FROM CCD_TGT_SPP_MMPA WHERE TGT_SPP_MMPA_NAME = 'Blainville''s Beaked Whale - Hawaii'), '');
insert into CCD_SPP_MMPA_PRE_OPTS (MMPA_PRE_ID, TGT_SPP_MMPA_ID, MMPA_PRE_OPT_NOTES) VALUES ((SELECT MMPA_PRE_ID FROM CCD_SPP_MMPA_PRE WHERE MMPA_PRE_NAME = 'HICEAS'), (SELECT TGT_SPP_MMPA_ID FROM CCD_TGT_SPP_MMPA WHERE TGT_SPP_MMPA_NAME = 'Blue whale - Western North Pacific, formerly Hawaii'), '');
insert into CCD_SPP_MMPA_PRE_OPTS (MMPA_PRE_ID, TGT_SPP_MMPA_ID, MMPA_PRE_OPT_NOTES) VALUES ((SELECT MMPA_PRE_ID FROM CCD_SPP_MMPA_PRE WHERE MMPA_PRE_NAME = 'HICEAS'), (SELECT TGT_SPP_MMPA_ID FROM CCD_TGT_SPP_MMPA WHERE TGT_SPP_MMPA_NAME = 'Bottlenose Dolphin - Hawaii'), '');
insert into CCD_SPP_MMPA_PRE_OPTS (MMPA_PRE_ID, TGT_SPP_MMPA_ID, MMPA_PRE_OPT_NOTES) VALUES ((SELECT MMPA_PRE_ID FROM CCD_SPP_MMPA_PRE WHERE MMPA_PRE_NAME = 'HICEAS'), (SELECT TGT_SPP_MMPA_ID FROM CCD_TGT_SPP_MMPA WHERE TGT_SPP_MMPA_NAME = 'Bryde''s Whale - Eastern Tropical Pacific'), '');
insert into CCD_SPP_MMPA_PRE_OPTS (MMPA_PRE_ID, TGT_SPP_MMPA_ID, MMPA_PRE_OPT_NOTES) VALUES ((SELECT MMPA_PRE_ID FROM CCD_SPP_MMPA_PRE WHERE MMPA_PRE_NAME = 'HICEAS'), (SELECT TGT_SPP_MMPA_ID FROM CCD_TGT_SPP_MMPA WHERE TGT_SPP_MMPA_NAME = 'Bryde''s Whale - Hawaii'), '');
insert into CCD_SPP_MMPA_PRE_OPTS (MMPA_PRE_ID, TGT_SPP_MMPA_ID, MMPA_PRE_OPT_NOTES) VALUES ((SELECT MMPA_PRE_ID FROM CCD_SPP_MMPA_PRE WHERE MMPA_PRE_NAME = 'HICEAS'), (SELECT TGT_SPP_MMPA_ID FROM CCD_TGT_SPP_MMPA WHERE TGT_SPP_MMPA_NAME = 'Cuvier''s Beaked Whale - Hawaii'), '');
insert into CCD_SPP_MMPA_PRE_OPTS (MMPA_PRE_ID, TGT_SPP_MMPA_ID, MMPA_PRE_OPT_NOTES) VALUES ((SELECT MMPA_PRE_ID FROM CCD_SPP_MMPA_PRE WHERE MMPA_PRE_NAME = 'HICEAS'), (SELECT TGT_SPP_MMPA_ID FROM CCD_TGT_SPP_MMPA WHERE TGT_SPP_MMPA_NAME = 'Dwarf Sperm Whale - Hawaii'), '');
insert into CCD_SPP_MMPA_PRE_OPTS (MMPA_PRE_ID, TGT_SPP_MMPA_ID, MMPA_PRE_OPT_NOTES) VALUES ((SELECT MMPA_PRE_ID FROM CCD_SPP_MMPA_PRE WHERE MMPA_PRE_NAME = 'HICEAS'), (SELECT TGT_SPP_MMPA_ID FROM CCD_TGT_SPP_MMPA WHERE TGT_SPP_MMPA_NAME = 'False Killer Whale - Hawaii'), '');
insert into CCD_SPP_MMPA_PRE_OPTS (MMPA_PRE_ID, TGT_SPP_MMPA_ID, MMPA_PRE_OPT_NOTES) VALUES ((SELECT MMPA_PRE_ID FROM CCD_SPP_MMPA_PRE WHERE MMPA_PRE_NAME = 'HICEAS'), (SELECT TGT_SPP_MMPA_ID FROM CCD_TGT_SPP_MMPA WHERE TGT_SPP_MMPA_NAME = 'Fin Whale - Hawaii'), '');
insert into CCD_SPP_MMPA_PRE_OPTS (MMPA_PRE_ID, TGT_SPP_MMPA_ID, MMPA_PRE_OPT_NOTES) VALUES ((SELECT MMPA_PRE_ID FROM CCD_SPP_MMPA_PRE WHERE MMPA_PRE_NAME = 'HICEAS'), (SELECT TGT_SPP_MMPA_ID FROM CCD_TGT_SPP_MMPA WHERE TGT_SPP_MMPA_NAME = 'Fraser''s Dolphin - Hawaii'), '');
insert into CCD_SPP_MMPA_PRE_OPTS (MMPA_PRE_ID, TGT_SPP_MMPA_ID, MMPA_PRE_OPT_NOTES) VALUES ((SELECT MMPA_PRE_ID FROM CCD_SPP_MMPA_PRE WHERE MMPA_PRE_NAME = 'HICEAS'), (SELECT TGT_SPP_MMPA_ID FROM CCD_TGT_SPP_MMPA WHERE TGT_SPP_MMPA_NAME = 'Humpback Whale - Central North Pacific'), '');
insert into CCD_SPP_MMPA_PRE_OPTS (MMPA_PRE_ID, TGT_SPP_MMPA_ID, MMPA_PRE_OPT_NOTES) VALUES ((SELECT MMPA_PRE_ID FROM CCD_SPP_MMPA_PRE WHERE MMPA_PRE_NAME = 'HICEAS'), (SELECT TGT_SPP_MMPA_ID FROM CCD_TGT_SPP_MMPA WHERE TGT_SPP_MMPA_NAME = 'Killer Whale - Hawaii'), '');
insert into CCD_SPP_MMPA_PRE_OPTS (MMPA_PRE_ID, TGT_SPP_MMPA_ID, MMPA_PRE_OPT_NOTES) VALUES ((SELECT MMPA_PRE_ID FROM CCD_SPP_MMPA_PRE WHERE MMPA_PRE_NAME = 'HICEAS'), (SELECT TGT_SPP_MMPA_ID FROM CCD_TGT_SPP_MMPA WHERE TGT_SPP_MMPA_NAME = 'Longman''s Beaked Whale - Hawaii'), '');
insert into CCD_SPP_MMPA_PRE_OPTS (MMPA_PRE_ID, TGT_SPP_MMPA_ID, MMPA_PRE_OPT_NOTES) VALUES ((SELECT MMPA_PRE_ID FROM CCD_SPP_MMPA_PRE WHERE MMPA_PRE_NAME = 'HICEAS'), (SELECT TGT_SPP_MMPA_ID FROM CCD_TGT_SPP_MMPA WHERE TGT_SPP_MMPA_NAME = 'Melon-Headed Whale - Hawaii'), '');
insert into CCD_SPP_MMPA_PRE_OPTS (MMPA_PRE_ID, TGT_SPP_MMPA_ID, MMPA_PRE_OPT_NOTES) VALUES ((SELECT MMPA_PRE_ID FROM CCD_SPP_MMPA_PRE WHERE MMPA_PRE_NAME = 'HICEAS'), (SELECT TGT_SPP_MMPA_ID FROM CCD_TGT_SPP_MMPA WHERE TGT_SPP_MMPA_NAME = 'Minke Whale - Hawaii'), '');
insert into CCD_SPP_MMPA_PRE_OPTS (MMPA_PRE_ID, TGT_SPP_MMPA_ID, MMPA_PRE_OPT_NOTES) VALUES ((SELECT MMPA_PRE_ID FROM CCD_SPP_MMPA_PRE WHERE MMPA_PRE_NAME = 'HICEAS'), (SELECT TGT_SPP_MMPA_ID FROM CCD_TGT_SPP_MMPA WHERE TGT_SPP_MMPA_NAME = 'Pantropical Spotted Dolphin - Hawaii'), '');
insert into CCD_SPP_MMPA_PRE_OPTS (MMPA_PRE_ID, TGT_SPP_MMPA_ID, MMPA_PRE_OPT_NOTES) VALUES ((SELECT MMPA_PRE_ID FROM CCD_SPP_MMPA_PRE WHERE MMPA_PRE_NAME = 'HICEAS'), (SELECT TGT_SPP_MMPA_ID FROM CCD_TGT_SPP_MMPA WHERE TGT_SPP_MMPA_NAME = 'Pygmy Killer Whale - Hawaii'), '');
insert into CCD_SPP_MMPA_PRE_OPTS (MMPA_PRE_ID, TGT_SPP_MMPA_ID, MMPA_PRE_OPT_NOTES) VALUES ((SELECT MMPA_PRE_ID FROM CCD_SPP_MMPA_PRE WHERE MMPA_PRE_NAME = 'HICEAS'), (SELECT TGT_SPP_MMPA_ID FROM CCD_TGT_SPP_MMPA WHERE TGT_SPP_MMPA_NAME = 'Pygmy Sperm Whale - Hawaii'), '');
insert into CCD_SPP_MMPA_PRE_OPTS (MMPA_PRE_ID, TGT_SPP_MMPA_ID, MMPA_PRE_OPT_NOTES) VALUES ((SELECT MMPA_PRE_ID FROM CCD_SPP_MMPA_PRE WHERE MMPA_PRE_NAME = 'HICEAS'), (SELECT TGT_SPP_MMPA_ID FROM CCD_TGT_SPP_MMPA WHERE TGT_SPP_MMPA_NAME = 'Risso''s Dolphin - Hawaii'), '');
insert into CCD_SPP_MMPA_PRE_OPTS (MMPA_PRE_ID, TGT_SPP_MMPA_ID, MMPA_PRE_OPT_NOTES) VALUES ((SELECT MMPA_PRE_ID FROM CCD_SPP_MMPA_PRE WHERE MMPA_PRE_NAME = 'HICEAS'), (SELECT TGT_SPP_MMPA_ID FROM CCD_TGT_SPP_MMPA WHERE TGT_SPP_MMPA_NAME = 'Rough-Toothed Dolphin - Hawaii'), '');
insert into CCD_SPP_MMPA_PRE_OPTS (MMPA_PRE_ID, TGT_SPP_MMPA_ID, MMPA_PRE_OPT_NOTES) VALUES ((SELECT MMPA_PRE_ID FROM CCD_SPP_MMPA_PRE WHERE MMPA_PRE_NAME = 'HICEAS'), (SELECT TGT_SPP_MMPA_ID FROM CCD_TGT_SPP_MMPA WHERE TGT_SPP_MMPA_NAME = 'Sei Whale - Hawaii'), '');
insert into CCD_SPP_MMPA_PRE_OPTS (MMPA_PRE_ID, TGT_SPP_MMPA_ID, MMPA_PRE_OPT_NOTES) VALUES ((SELECT MMPA_PRE_ID FROM CCD_SPP_MMPA_PRE WHERE MMPA_PRE_NAME = 'HICEAS'), (SELECT TGT_SPP_MMPA_ID FROM CCD_TGT_SPP_MMPA WHERE TGT_SPP_MMPA_NAME = 'Short-Finned Pilot Whale - Hawaii'), '');
insert into CCD_SPP_MMPA_PRE_OPTS (MMPA_PRE_ID, TGT_SPP_MMPA_ID, MMPA_PRE_OPT_NOTES) VALUES ((SELECT MMPA_PRE_ID FROM CCD_SPP_MMPA_PRE WHERE MMPA_PRE_NAME = 'HICEAS'), (SELECT TGT_SPP_MMPA_ID FROM CCD_TGT_SPP_MMPA WHERE TGT_SPP_MMPA_NAME = 'Sperm Whale - Hawaii'), '');
insert into CCD_SPP_MMPA_PRE_OPTS (MMPA_PRE_ID, TGT_SPP_MMPA_ID, MMPA_PRE_OPT_NOTES) VALUES ((SELECT MMPA_PRE_ID FROM CCD_SPP_MMPA_PRE WHERE MMPA_PRE_NAME = 'HICEAS'), (SELECT TGT_SPP_MMPA_ID FROM CCD_TGT_SPP_MMPA WHERE TGT_SPP_MMPA_NAME = 'Spinner Dolphin - Hawaii'), '');
insert into CCD_SPP_MMPA_PRE_OPTS (MMPA_PRE_ID, TGT_SPP_MMPA_ID, MMPA_PRE_OPT_NOTES) VALUES ((SELECT MMPA_PRE_ID FROM CCD_SPP_MMPA_PRE WHERE MMPA_PRE_NAME = 'HICEAS'), (SELECT TGT_SPP_MMPA_ID FROM CCD_TGT_SPP_MMPA WHERE TGT_SPP_MMPA_NAME = 'Striped Dolphin - Hawaii'), '');
insert into CCD_SPP_MMPA_PRE_OPTS (MMPA_PRE_ID, TGT_SPP_MMPA_ID, MMPA_PRE_OPT_NOTES) VALUES ((SELECT MMPA_PRE_ID FROM CCD_SPP_MMPA_PRE WHERE MMPA_PRE_NAME = 'MACS'), (SELECT TGT_SPP_MMPA_ID FROM CCD_TGT_SPP_MMPA WHERE TGT_SPP_MMPA_NAME = 'Blainville''s Beaked Whale - Hawaii'), '');
insert into CCD_SPP_MMPA_PRE_OPTS (MMPA_PRE_ID, TGT_SPP_MMPA_ID, MMPA_PRE_OPT_NOTES) VALUES ((SELECT MMPA_PRE_ID FROM CCD_SPP_MMPA_PRE WHERE MMPA_PRE_NAME = 'MACS'), (SELECT TGT_SPP_MMPA_ID FROM CCD_TGT_SPP_MMPA WHERE TGT_SPP_MMPA_NAME = 'Blue whale - Western North Pacific, formerly Hawaii'), '');
insert into CCD_SPP_MMPA_PRE_OPTS (MMPA_PRE_ID, TGT_SPP_MMPA_ID, MMPA_PRE_OPT_NOTES) VALUES ((SELECT MMPA_PRE_ID FROM CCD_SPP_MMPA_PRE WHERE MMPA_PRE_NAME = 'MACS'), (SELECT TGT_SPP_MMPA_ID FROM CCD_TGT_SPP_MMPA WHERE TGT_SPP_MMPA_NAME = 'Bottlenose Dolphin - Hawaii'), '');
insert into CCD_SPP_MMPA_PRE_OPTS (MMPA_PRE_ID, TGT_SPP_MMPA_ID, MMPA_PRE_OPT_NOTES) VALUES ((SELECT MMPA_PRE_ID FROM CCD_SPP_MMPA_PRE WHERE MMPA_PRE_NAME = 'MACS'), (SELECT TGT_SPP_MMPA_ID FROM CCD_TGT_SPP_MMPA WHERE TGT_SPP_MMPA_NAME = 'Bryde''s Whale - Hawaii'), '');
insert into CCD_SPP_MMPA_PRE_OPTS (MMPA_PRE_ID, TGT_SPP_MMPA_ID, MMPA_PRE_OPT_NOTES) VALUES ((SELECT MMPA_PRE_ID FROM CCD_SPP_MMPA_PRE WHERE MMPA_PRE_NAME = 'MACS'), (SELECT TGT_SPP_MMPA_ID FROM CCD_TGT_SPP_MMPA WHERE TGT_SPP_MMPA_NAME = 'Cuvier''s Beaked Whale - Hawaii'), '');
insert into CCD_SPP_MMPA_PRE_OPTS (MMPA_PRE_ID, TGT_SPP_MMPA_ID, MMPA_PRE_OPT_NOTES) VALUES ((SELECT MMPA_PRE_ID FROM CCD_SPP_MMPA_PRE WHERE MMPA_PRE_NAME = 'MACS'), (SELECT TGT_SPP_MMPA_ID FROM CCD_TGT_SPP_MMPA WHERE TGT_SPP_MMPA_NAME = 'Dwarf Sperm Whale - Hawaii'), '');
insert into CCD_SPP_MMPA_PRE_OPTS (MMPA_PRE_ID, TGT_SPP_MMPA_ID, MMPA_PRE_OPT_NOTES) VALUES ((SELECT MMPA_PRE_ID FROM CCD_SPP_MMPA_PRE WHERE MMPA_PRE_NAME = 'MACS'), (SELECT TGT_SPP_MMPA_ID FROM CCD_TGT_SPP_MMPA WHERE TGT_SPP_MMPA_NAME = 'False Killer Whale - Hawaii'), '');
insert into CCD_SPP_MMPA_PRE_OPTS (MMPA_PRE_ID, TGT_SPP_MMPA_ID, MMPA_PRE_OPT_NOTES) VALUES ((SELECT MMPA_PRE_ID FROM CCD_SPP_MMPA_PRE WHERE MMPA_PRE_NAME = 'MACS'), (SELECT TGT_SPP_MMPA_ID FROM CCD_TGT_SPP_MMPA WHERE TGT_SPP_MMPA_NAME = 'Fin Whale - Hawaii'), '');
insert into CCD_SPP_MMPA_PRE_OPTS (MMPA_PRE_ID, TGT_SPP_MMPA_ID, MMPA_PRE_OPT_NOTES) VALUES ((SELECT MMPA_PRE_ID FROM CCD_SPP_MMPA_PRE WHERE MMPA_PRE_NAME = 'MACS'), (SELECT TGT_SPP_MMPA_ID FROM CCD_TGT_SPP_MMPA WHERE TGT_SPP_MMPA_NAME = 'Fraser''s Dolphin - Hawaii'), '');
insert into CCD_SPP_MMPA_PRE_OPTS (MMPA_PRE_ID, TGT_SPP_MMPA_ID, MMPA_PRE_OPT_NOTES) VALUES ((SELECT MMPA_PRE_ID FROM CCD_SPP_MMPA_PRE WHERE MMPA_PRE_NAME = 'MACS'), (SELECT TGT_SPP_MMPA_ID FROM CCD_TGT_SPP_MMPA WHERE TGT_SPP_MMPA_NAME = 'Humpback Whale - Central North Pacific'), '');
insert into CCD_SPP_MMPA_PRE_OPTS (MMPA_PRE_ID, TGT_SPP_MMPA_ID, MMPA_PRE_OPT_NOTES) VALUES ((SELECT MMPA_PRE_ID FROM CCD_SPP_MMPA_PRE WHERE MMPA_PRE_NAME = 'MACS'), (SELECT TGT_SPP_MMPA_ID FROM CCD_TGT_SPP_MMPA WHERE TGT_SPP_MMPA_NAME = 'Killer Whale - Hawaii'), '');
insert into CCD_SPP_MMPA_PRE_OPTS (MMPA_PRE_ID, TGT_SPP_MMPA_ID, MMPA_PRE_OPT_NOTES) VALUES ((SELECT MMPA_PRE_ID FROM CCD_SPP_MMPA_PRE WHERE MMPA_PRE_NAME = 'MACS'), (SELECT TGT_SPP_MMPA_ID FROM CCD_TGT_SPP_MMPA WHERE TGT_SPP_MMPA_NAME = 'Longman''s Beaked Whale - Hawaii'), '');
insert into CCD_SPP_MMPA_PRE_OPTS (MMPA_PRE_ID, TGT_SPP_MMPA_ID, MMPA_PRE_OPT_NOTES) VALUES ((SELECT MMPA_PRE_ID FROM CCD_SPP_MMPA_PRE WHERE MMPA_PRE_NAME = 'MACS'), (SELECT TGT_SPP_MMPA_ID FROM CCD_TGT_SPP_MMPA WHERE TGT_SPP_MMPA_NAME = 'Melon-Headed Whale - Hawaii'), '');
insert into CCD_SPP_MMPA_PRE_OPTS (MMPA_PRE_ID, TGT_SPP_MMPA_ID, MMPA_PRE_OPT_NOTES) VALUES ((SELECT MMPA_PRE_ID FROM CCD_SPP_MMPA_PRE WHERE MMPA_PRE_NAME = 'MACS'), (SELECT TGT_SPP_MMPA_ID FROM CCD_TGT_SPP_MMPA WHERE TGT_SPP_MMPA_NAME = 'Minke Whale - Hawaii'), '');
insert into CCD_SPP_MMPA_PRE_OPTS (MMPA_PRE_ID, TGT_SPP_MMPA_ID, MMPA_PRE_OPT_NOTES) VALUES ((SELECT MMPA_PRE_ID FROM CCD_SPP_MMPA_PRE WHERE MMPA_PRE_NAME = 'MACS'), (SELECT TGT_SPP_MMPA_ID FROM CCD_TGT_SPP_MMPA WHERE TGT_SPP_MMPA_NAME = 'Pantropical Spotted Dolphin - Hawaii'), '');
insert into CCD_SPP_MMPA_PRE_OPTS (MMPA_PRE_ID, TGT_SPP_MMPA_ID, MMPA_PRE_OPT_NOTES) VALUES ((SELECT MMPA_PRE_ID FROM CCD_SPP_MMPA_PRE WHERE MMPA_PRE_NAME = 'MACS'), (SELECT TGT_SPP_MMPA_ID FROM CCD_TGT_SPP_MMPA WHERE TGT_SPP_MMPA_NAME = 'Pygmy Killer Whale - Hawaii'), '');
insert into CCD_SPP_MMPA_PRE_OPTS (MMPA_PRE_ID, TGT_SPP_MMPA_ID, MMPA_PRE_OPT_NOTES) VALUES ((SELECT MMPA_PRE_ID FROM CCD_SPP_MMPA_PRE WHERE MMPA_PRE_NAME = 'MACS'), (SELECT TGT_SPP_MMPA_ID FROM CCD_TGT_SPP_MMPA WHERE TGT_SPP_MMPA_NAME = 'Pygmy Sperm Whale - Hawaii'), '');
insert into CCD_SPP_MMPA_PRE_OPTS (MMPA_PRE_ID, TGT_SPP_MMPA_ID, MMPA_PRE_OPT_NOTES) VALUES ((SELECT MMPA_PRE_ID FROM CCD_SPP_MMPA_PRE WHERE MMPA_PRE_NAME = 'MACS'), (SELECT TGT_SPP_MMPA_ID FROM CCD_TGT_SPP_MMPA WHERE TGT_SPP_MMPA_NAME = 'Risso''s Dolphin - Hawaii'), '');
insert into CCD_SPP_MMPA_PRE_OPTS (MMPA_PRE_ID, TGT_SPP_MMPA_ID, MMPA_PRE_OPT_NOTES) VALUES ((SELECT MMPA_PRE_ID FROM CCD_SPP_MMPA_PRE WHERE MMPA_PRE_NAME = 'MACS'), (SELECT TGT_SPP_MMPA_ID FROM CCD_TGT_SPP_MMPA WHERE TGT_SPP_MMPA_NAME = 'Rough-Toothed Dolphin - Hawaii'), '');
insert into CCD_SPP_MMPA_PRE_OPTS (MMPA_PRE_ID, TGT_SPP_MMPA_ID, MMPA_PRE_OPT_NOTES) VALUES ((SELECT MMPA_PRE_ID FROM CCD_SPP_MMPA_PRE WHERE MMPA_PRE_NAME = 'MACS'), (SELECT TGT_SPP_MMPA_ID FROM CCD_TGT_SPP_MMPA WHERE TGT_SPP_MMPA_NAME = 'Sei Whale - Hawaii'), '');
insert into CCD_SPP_MMPA_PRE_OPTS (MMPA_PRE_ID, TGT_SPP_MMPA_ID, MMPA_PRE_OPT_NOTES) VALUES ((SELECT MMPA_PRE_ID FROM CCD_SPP_MMPA_PRE WHERE MMPA_PRE_NAME = 'MACS'), (SELECT TGT_SPP_MMPA_ID FROM CCD_TGT_SPP_MMPA WHERE TGT_SPP_MMPA_NAME = 'Short-Finned Pilot Whale - Hawaii'), '');
insert into CCD_SPP_MMPA_PRE_OPTS (MMPA_PRE_ID, TGT_SPP_MMPA_ID, MMPA_PRE_OPT_NOTES) VALUES ((SELECT MMPA_PRE_ID FROM CCD_SPP_MMPA_PRE WHERE MMPA_PRE_NAME = 'MACS'), (SELECT TGT_SPP_MMPA_ID FROM CCD_TGT_SPP_MMPA WHERE TGT_SPP_MMPA_NAME = 'Sperm Whale - Hawaii'), '');
insert into CCD_SPP_MMPA_PRE_OPTS (MMPA_PRE_ID, TGT_SPP_MMPA_ID, MMPA_PRE_OPT_NOTES) VALUES ((SELECT MMPA_PRE_ID FROM CCD_SPP_MMPA_PRE WHERE MMPA_PRE_NAME = 'MACS'), (SELECT TGT_SPP_MMPA_ID FROM CCD_TGT_SPP_MMPA WHERE TGT_SPP_MMPA_NAME = 'Spinner Dolphin - Hawaii'), '');
insert into CCD_SPP_MMPA_PRE_OPTS (MMPA_PRE_ID, TGT_SPP_MMPA_ID, MMPA_PRE_OPT_NOTES) VALUES ((SELECT MMPA_PRE_ID FROM CCD_SPP_MMPA_PRE WHERE MMPA_PRE_NAME = 'MACS'), (SELECT TGT_SPP_MMPA_ID FROM CCD_TGT_SPP_MMPA WHERE TGT_SPP_MMPA_NAME = 'Striped Dolphin - Hawaii'), '');






--load ESA target species presets:
insert into CCD_SPP_ESA_PRE (ESA_PRE_NAME, ESA_PRE_DESC) VALUES ('HMSEAS', 'Hawaiian Monk Seal Enhancement and Survey Cruise');
insert into CCD_SPP_ESA_PRE (ESA_PRE_NAME, ESA_PRE_DESC) VALUES ('Marine Turtles', 'Marine Turtle Population Assessment Survey');
insert into CCD_SPP_ESA_PRE (ESA_PRE_NAME, ESA_PRE_DESC) VALUES ('HICEAS', 'PIFSC - Hawaiian Islands Cetacean and Ecosystem Assessment Survey');


--load ESA target species preset options:
insert into CCD_SPP_ESA_PRE_OPTS (ESA_PRE_ID, TGT_SPP_ESA_ID, ESA_PRE_OPT_NOTES) VALUES ((SELECT ESA_PRE_ID FROM CCD_SPP_ESA_PRE WHERE ESA_PRE_NAME = 'HMSEAS'), (SELECT TGT_SPP_ESA_ID FROM CCD_TGT_SPP_ESA WHERE TGT_SPP_ESA_NAME = 'Hawaiian Monk Seal'), '');
insert into CCD_SPP_ESA_PRE_OPTS (ESA_PRE_ID, TGT_SPP_ESA_ID, ESA_PRE_OPT_NOTES) VALUES ((SELECT ESA_PRE_ID FROM CCD_SPP_ESA_PRE WHERE ESA_PRE_NAME = 'Marine Turtles'), (SELECT TGT_SPP_ESA_ID FROM CCD_TGT_SPP_ESA WHERE TGT_SPP_ESA_NAME = 'green turtle - all other areas except Florida & Mexico''s Pacific coast breeding colonies'), '');
insert into CCD_SPP_ESA_PRE_OPTS (ESA_PRE_ID, TGT_SPP_ESA_ID, ESA_PRE_OPT_NOTES) VALUES ((SELECT ESA_PRE_ID FROM CCD_SPP_ESA_PRE WHERE ESA_PRE_NAME = 'Marine Turtles'), (SELECT TGT_SPP_ESA_ID FROM CCD_TGT_SPP_ESA WHERE TGT_SPP_ESA_NAME = 'hawksbill turtle'), '');
insert into CCD_SPP_ESA_PRE_OPTS (ESA_PRE_ID, TGT_SPP_ESA_ID, ESA_PRE_OPT_NOTES) VALUES ((SELECT ESA_PRE_ID FROM CCD_SPP_ESA_PRE WHERE ESA_PRE_NAME = 'HICEAS'), (SELECT TGT_SPP_ESA_ID FROM CCD_TGT_SPP_ESA WHERE TGT_SPP_ESA_NAME = 'Blue whale'), '');
insert into CCD_SPP_ESA_PRE_OPTS (ESA_PRE_ID, TGT_SPP_ESA_ID, ESA_PRE_OPT_NOTES) VALUES ((SELECT ESA_PRE_ID FROM CCD_SPP_ESA_PRE WHERE ESA_PRE_NAME = 'HICEAS'), (SELECT TGT_SPP_ESA_ID FROM CCD_TGT_SPP_ESA WHERE TGT_SPP_ESA_NAME = 'Fin Whale'), '');
insert into CCD_SPP_ESA_PRE_OPTS (ESA_PRE_ID, TGT_SPP_ESA_ID, ESA_PRE_OPT_NOTES) VALUES ((SELECT ESA_PRE_ID FROM CCD_SPP_ESA_PRE WHERE ESA_PRE_NAME = 'HICEAS'), (SELECT TGT_SPP_ESA_ID FROM CCD_TGT_SPP_ESA WHERE TGT_SPP_ESA_NAME = 'Humpback Whale'), '');
insert into CCD_SPP_ESA_PRE_OPTS (ESA_PRE_ID, TGT_SPP_ESA_ID, ESA_PRE_OPT_NOTES) VALUES ((SELECT ESA_PRE_ID FROM CCD_SPP_ESA_PRE WHERE ESA_PRE_NAME = 'HICEAS'), (SELECT TGT_SPP_ESA_ID FROM CCD_TGT_SPP_ESA WHERE TGT_SPP_ESA_NAME = 'Sei Whale'), '');
insert into CCD_SPP_ESA_PRE_OPTS (ESA_PRE_ID, TGT_SPP_ESA_ID, ESA_PRE_OPT_NOTES) VALUES ((SELECT ESA_PRE_ID FROM CCD_SPP_ESA_PRE WHERE ESA_PRE_NAME = 'HICEAS'), (SELECT TGT_SPP_ESA_ID FROM CCD_TGT_SPP_ESA WHERE TGT_SPP_ESA_NAME = 'Sperm Whale'), '');


--load FSSI target species presets:
insert into CCD_SPP_FSSI_PRE (FSSI_PRE_NAME, FSSI_PRE_DESC) VALUES ('IEA', 'Integrated Ecosystem Assessment');
insert into CCD_SPP_FSSI_PRE (FSSI_PRE_NAME, FSSI_PRE_DESC) VALUES ('BFISH', 'Hawaiian Archipelago Bottomfish Multi-species Complex');


--load FSSI target species preset options:
insert into CCD_SPP_FSSI_PRE_OPTS (FSSI_PRE_ID, TGT_SPP_FSSI_ID, FSSI_PRE_OPT_NOTES) VALUES ((SELECT FSSI_PRE_ID FROM CCD_SPP_FSSI_PRE WHERE FSSI_PRE_NAME = 'IEA'), (SELECT TGT_SPP_FSSI_ID FROM CCD_TGT_SPP_FSSI WHERE TGT_SPP_FSSI_NAME = 'Hawaiian Archipelago Coral Reef Ecosystem Multi-species Complex'), '');
insert into CCD_SPP_FSSI_PRE_OPTS (FSSI_PRE_ID, TGT_SPP_FSSI_ID, FSSI_PRE_OPT_NOTES) VALUES ((SELECT FSSI_PRE_ID FROM CCD_SPP_FSSI_PRE WHERE FSSI_PRE_NAME = 'BFISH'), (SELECT TGT_SPP_FSSI_ID FROM CCD_TGT_SPP_FSSI WHERE TGT_SPP_FSSI_NAME = 'Hawaiian Archipelago Bottomfish Multi-species Complex'), '');


--load expected species categories presets:
insert into CCD_SPP_CAT_PRE (SPP_CAT_PRE_NAME, SPP_CAT_PRE_DESC) VALUES ('BFISH', 'Insular Bottomfish Survey');
insert into CCD_SPP_CAT_PRE (SPP_CAT_PRE_NAME, SPP_CAT_PRE_DESC) VALUES ('MARAMP', 'Marianas Reef Assessment and Monitoring Program (MARAMP)');

--load expected species categories preset options:
insert into CCD_SPP_CAT_PRE_OPTS (SPP_CAT_PRE_ID, EXP_SPP_CAT_ID, SPP_CAT_PRE_OPT_NOTES) VALUES ((SELECT SPP_CAT_PRE_ID FROM CCD_SPP_CAT_PRE WHERE SPP_CAT_PRE_NAME = 'BFISH'), (SELECT EXP_SPP_CAT_ID FROM CCD_EXP_SPP_CATS WHERE EXP_SPP_CAT_NAME = 'Fish-General'), '');
insert into CCD_SPP_CAT_PRE_OPTS (SPP_CAT_PRE_ID, EXP_SPP_CAT_ID, SPP_CAT_PRE_OPT_NOTES) VALUES ((SELECT SPP_CAT_PRE_ID FROM CCD_SPP_CAT_PRE WHERE SPP_CAT_PRE_NAME = 'BFISH'), (SELECT EXP_SPP_CAT_ID FROM CCD_EXP_SPP_CATS WHERE EXP_SPP_CAT_NAME = 'Fishes-Benthic Fish'), '');
insert into CCD_SPP_CAT_PRE_OPTS (SPP_CAT_PRE_ID, EXP_SPP_CAT_ID, SPP_CAT_PRE_OPT_NOTES) VALUES ((SELECT SPP_CAT_PRE_ID FROM CCD_SPP_CAT_PRE WHERE SPP_CAT_PRE_NAME = 'BFISH'), (SELECT EXP_SPP_CAT_ID FROM CCD_EXP_SPP_CATS WHERE EXP_SPP_CAT_NAME = 'Fishes-Reef Fish'), '');
insert into CCD_SPP_CAT_PRE_OPTS (SPP_CAT_PRE_ID, EXP_SPP_CAT_ID, SPP_CAT_PRE_OPT_NOTES) VALUES ((SELECT SPP_CAT_PRE_ID FROM CCD_SPP_CAT_PRE WHERE SPP_CAT_PRE_NAME = 'MARAMP'), (SELECT EXP_SPP_CAT_ID FROM CCD_EXP_SPP_CATS WHERE EXP_SPP_CAT_NAME = 'Algae'), '');
insert into CCD_SPP_CAT_PRE_OPTS (SPP_CAT_PRE_ID, EXP_SPP_CAT_ID, SPP_CAT_PRE_OPT_NOTES) VALUES ((SELECT SPP_CAT_PRE_ID FROM CCD_SPP_CAT_PRE WHERE SPP_CAT_PRE_NAME = 'MARAMP'), (SELECT EXP_SPP_CAT_ID FROM CCD_EXP_SPP_CATS WHERE EXP_SPP_CAT_NAME = 'Coral-Hermatypic Stony Coral'), '');
insert into CCD_SPP_CAT_PRE_OPTS (SPP_CAT_PRE_ID, EXP_SPP_CAT_ID, SPP_CAT_PRE_OPT_NOTES) VALUES ((SELECT SPP_CAT_PRE_ID FROM CCD_SPP_CAT_PRE WHERE SPP_CAT_PRE_NAME = 'MARAMP'), (SELECT EXP_SPP_CAT_ID FROM CCD_EXP_SPP_CATS WHERE EXP_SPP_CAT_NAME = 'Coral-Shallow Water Coral'), '');
insert into CCD_SPP_CAT_PRE_OPTS (SPP_CAT_PRE_ID, EXP_SPP_CAT_ID, SPP_CAT_PRE_OPT_NOTES) VALUES ((SELECT SPP_CAT_PRE_ID FROM CCD_SPP_CAT_PRE WHERE SPP_CAT_PRE_NAME = 'MARAMP'), (SELECT EXP_SPP_CAT_ID FROM CCD_EXP_SPP_CATS WHERE EXP_SPP_CAT_NAME = 'Crustaceans'), '');
insert into CCD_SPP_CAT_PRE_OPTS (SPP_CAT_PRE_ID, EXP_SPP_CAT_ID, SPP_CAT_PRE_OPT_NOTES) VALUES ((SELECT SPP_CAT_PRE_ID FROM CCD_SPP_CAT_PRE WHERE SPP_CAT_PRE_NAME = 'MARAMP'), (SELECT EXP_SPP_CAT_ID FROM CCD_EXP_SPP_CATS WHERE EXP_SPP_CAT_NAME = 'Fishes-Reef Fish'), '');
insert into CCD_SPP_CAT_PRE_OPTS (SPP_CAT_PRE_ID, EXP_SPP_CAT_ID, SPP_CAT_PRE_OPT_NOTES) VALUES ((SELECT SPP_CAT_PRE_ID FROM CCD_SPP_CAT_PRE WHERE SPP_CAT_PRE_NAME = 'MARAMP'), (SELECT EXP_SPP_CAT_ID FROM CCD_EXP_SPP_CATS WHERE EXP_SPP_CAT_NAME = 'Fishes-Shark'), '');
insert into CCD_SPP_CAT_PRE_OPTS (SPP_CAT_PRE_ID, EXP_SPP_CAT_ID, SPP_CAT_PRE_OPT_NOTES) VALUES ((SELECT SPP_CAT_PRE_ID FROM CCD_SPP_CAT_PRE WHERE SPP_CAT_PRE_NAME = 'MARAMP'), (SELECT EXP_SPP_CAT_ID FROM CCD_EXP_SPP_CATS WHERE EXP_SPP_CAT_NAME = 'Invertebrate-General'), '');










--insert cruises:
insert into ccd_cruises (cruise_name, cruise_notes, sci_center_div_id, std_svy_name_id, svy_freq_id, std_svy_name_oth, CRUISE_URL, CRUISE_CONT_EMAIL, svy_type_id, CRUISE_DESC, OBJ_BASED_METRICS) values ('SE-17-07', 'Retrieved this information manually from FINSS on 1/16/20 for testing purposes', (select sci_center_div_id from ccd_sci_center_divs where sci_center_div_code = 'FRMD'), (select STD_SVY_NAME_ID from ccd_std_svy_names where std_svy_name = 'Hawaiian Archipelago Insular Bottomfish Survey'), (select SVY_FREQ_ID from ccd_svy_freq where SVY_FREQ_name = 'SEMI-ANNUAL'), (CASE WHEN (select STD_SVY_NAME_ID from ccd_std_svy_names where std_svy_name = 'Hawaiian Archipelago Insular Bottomfish Survey') IS NULL THEN 'Hawaiian Archipelago Insular Bottomfish Survey' ELSE NULL END), 'http://www.noaa.gov/testURL', 'test@test.com', (SELECT svy_type_id from ccd_svy_types where svy_type_name = 'NMFS Survey'), 'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.', 'test content');
insert into ccd_cruises (cruise_name, cruise_notes, sci_center_div_id, std_svy_name_id, svy_freq_id, std_svy_name_oth, CRUISE_URL, CRUISE_CONT_EMAIL, svy_type_id, CRUISE_DESC, OBJ_BASED_METRICS) values ('OES0407', 'Retrieved this information manually from FINSS on 1/16/20 for testing purposes', (select sci_center_div_id from ccd_sci_center_divs where sci_center_div_code = 'PSD'), (select STD_SVY_NAME_ID from ccd_std_svy_names where std_svy_name = 'Hawaiian Monk Seal Population Assessment and Recovery Activities - Recovery'), (select SVY_FREQ_ID from ccd_svy_freq where SVY_FREQ_name = 'SEMI-ANNUAL'), (CASE WHEN (select STD_SVY_NAME_ID from ccd_std_svy_names where std_svy_name = 'Hawaiian Monk Seal Population Assessment and Recovery Activities - Recovery') IS NULL THEN 'Hawaiian Monk Seal Population Assessment and Recovery Activities - Recovery' ELSE NULL END), 'http://www.noaa.gov/testURL', 'test@test.com', (SELECT svy_type_id from ccd_svy_types where svy_type_name = 'NMFS Survey'), 'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.', 'test content');
insert into ccd_cruises (cruise_name, cruise_notes, sci_center_div_id, std_svy_name_id, svy_freq_id, std_svy_name_oth, CRUISE_URL, CRUISE_CONT_EMAIL, svy_type_id, CRUISE_DESC, OBJ_BASED_METRICS) values ('OES0410', 'Retrieved this information manually from FINSS on 1/16/20 for testing purposes', (select sci_center_div_id from ccd_sci_center_divs where sci_center_div_code = 'PSD'), (select STD_SVY_NAME_ID from ccd_std_svy_names where std_svy_name = 'Hawaiian Monk Seal Population Assessment and Recovery Activities - Recovery'), (select SVY_FREQ_ID from ccd_svy_freq where SVY_FREQ_name = 'SEMI-ANNUAL'), (CASE WHEN (select STD_SVY_NAME_ID from ccd_std_svy_names where std_svy_name = 'Hawaiian Monk Seal Population Assessment and Recovery Activities - Recovery') IS NULL THEN 'Hawaiian Monk Seal Population Assessment and Recovery Activities - Recovery' ELSE NULL END), 'http://www.noaa.gov/testURL', 'test@test.com', (SELECT svy_type_id from ccd_svy_types where svy_type_name = 'NMFS Survey'), 'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.', 'test content');
insert into ccd_cruises (cruise_name, cruise_notes, sci_center_div_id, std_svy_name_id, svy_freq_id, std_svy_name_oth, CRUISE_URL, CRUISE_CONT_EMAIL, svy_type_id, CRUISE_DESC, OBJ_BASED_METRICS) values ('TC0109', 'Could not retrieve this information from FINSS since data is only available for 2014 and later, these values were made up for testing purposes', (select sci_center_div_id from ccd_sci_center_divs where sci_center_div_code = 'PSD'), (select STD_SVY_NAME_ID from ccd_std_svy_names where std_svy_name = 'NWHI Marine Turtle Population Assessment Survey - Deploy'), (select SVY_FREQ_ID from ccd_svy_freq where SVY_FREQ_name = ''), (CASE WHEN (select STD_SVY_NAME_ID from ccd_std_svy_names where std_svy_name = 'NWHI Marine Turtle Population Assessment Survey - Deploy') IS NULL THEN 'NWHI Marine Turtle Population Assessment Survey - Deploy' ELSE NULL END), 'http://www.noaa.gov/testURL', 'test@test.com', (SELECT svy_type_id from ccd_svy_types where svy_type_name = 'NMFS Survey'), 'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.', 'test content');
insert into ccd_cruises (cruise_name, cruise_notes, sci_center_div_id, std_svy_name_id, svy_freq_id, std_svy_name_oth, CRUISE_URL, CRUISE_CONT_EMAIL, svy_type_id, CRUISE_DESC, OBJ_BASED_METRICS) values ('TC9909', 'Could not retrieve this information from FINSS since data is only available for 2014 and later, these values were made up for testing purposes', (select sci_center_div_id from ccd_sci_center_divs where sci_center_div_code = 'PSD'), (select STD_SVY_NAME_ID from ccd_std_svy_names where std_svy_name = 'NWHI Marine Turtle Population Assessment Survey - Deploy'), (select SVY_FREQ_ID from ccd_svy_freq where SVY_FREQ_name = ''), (CASE WHEN (select STD_SVY_NAME_ID from ccd_std_svy_names where std_svy_name = 'NWHI Marine Turtle Population Assessment Survey - Deploy') IS NULL THEN 'NWHI Marine Turtle Population Assessment Survey - Deploy' ELSE NULL END), 'http://www.noaa.gov/testURL', 'test@test.com', (SELECT svy_type_id from ccd_svy_types where svy_type_name = 'NMFS Survey'), 'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.', 'test content');
insert into ccd_cruises (cruise_name, cruise_notes, sci_center_div_id, std_svy_name_id, svy_freq_id, std_svy_name_oth, CRUISE_URL, CRUISE_CONT_EMAIL, svy_type_id, CRUISE_DESC, OBJ_BASED_METRICS) values ('RL-17-05', 'Retrieved this information manually from FINSS on 1/16/20 for testing purposes', (select sci_center_div_id from ccd_sci_center_divs where sci_center_div_code = 'PSD'), (select STD_SVY_NAME_ID from ccd_std_svy_names where std_svy_name = 'PIFSC - Hawaiian Islands Cetacean and Ecosystem Assessment Survey (HICEAS)'), (select SVY_FREQ_ID from ccd_svy_freq where SVY_FREQ_name = 'INTERMITTENT'), (CASE WHEN (select STD_SVY_NAME_ID from ccd_std_svy_names where std_svy_name = 'PIFSC - Hawaiian Islands Cetacean and Ecosystem Assessment Survey (HICEAS)') IS NULL THEN 'PIFSC - Hawaiian Islands Cetacean and Ecosystem Assessment Survey (HICEAS)' ELSE NULL END), 'http://www.noaa.gov/testURL', 'test@test.com', (SELECT svy_type_id from ccd_svy_types where svy_type_name = 'NMFS Survey'), 'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.', 'test content');
insert into ccd_cruises (cruise_name, cruise_notes, sci_center_div_id, std_svy_name_id, svy_freq_id, std_svy_name_oth, CRUISE_URL, CRUISE_CONT_EMAIL, svy_type_id, CRUISE_DESC, OBJ_BASED_METRICS) values ('HA1007', 'Retrieved this information manually from FINSS on 1/16/20 for testing purposes', (select sci_center_div_id from ccd_sci_center_divs where sci_center_div_code = 'ESD'), (select STD_SVY_NAME_ID from ccd_std_svy_names where std_svy_name = ''), (select SVY_FREQ_ID from ccd_svy_freq where SVY_FREQ_name = 'ANNUAL'), (CASE WHEN (select STD_SVY_NAME_ID from ccd_std_svy_names where std_svy_name = '') IS NULL THEN '' ELSE NULL END), 'http://www.noaa.gov/testURL', 'test@test.com', (SELECT svy_type_id from ccd_svy_types where svy_type_name = 'NMFS Survey'), 'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.', 'test content');
insert into ccd_cruises (cruise_name, cruise_notes, sci_center_div_id, std_svy_name_id, svy_freq_id, std_svy_name_oth, CRUISE_URL, CRUISE_CONT_EMAIL, svy_type_id, CRUISE_DESC, OBJ_BASED_METRICS) values ('HA1007 (copy)', 'Retrieved this information manually from FINSS on 1/16/20 for testing purposes', (select sci_center_div_id from ccd_sci_center_divs where sci_center_div_code = 'ESD'), (select STD_SVY_NAME_ID from ccd_std_svy_names where std_svy_name = ''), (select SVY_FREQ_ID from ccd_svy_freq where SVY_FREQ_name = 'ANNUAL'), (CASE WHEN (select STD_SVY_NAME_ID from ccd_std_svy_names where std_svy_name = '') IS NULL THEN '' ELSE NULL END), 'http://www.noaa.gov/testURL', 'test@test.com', (SELECT svy_type_id from ccd_svy_types where svy_type_name = 'NMFS Survey'), 'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.', 'test content');
insert into ccd_cruises (cruise_name, cruise_notes, sci_center_div_id, std_svy_name_id, svy_freq_id, std_svy_name_oth, CRUISE_URL, CRUISE_CONT_EMAIL, svy_type_id, CRUISE_DESC, OBJ_BASED_METRICS) values ('OES0908', 'Retrieved this information manually from FINSS on 1/16/20 for testing purposes', (select sci_center_div_id from ccd_sci_center_divs where sci_center_div_code = 'ESD'), (select STD_SVY_NAME_ID from ccd_std_svy_names where std_svy_name = 'Marine Debris'), (select SVY_FREQ_ID from ccd_svy_freq where SVY_FREQ_name = 'INTERMITTENT'), (CASE WHEN (select STD_SVY_NAME_ID from ccd_std_svy_names where std_svy_name = 'Marine Debris') IS NULL THEN 'Marine Debris' ELSE NULL END), 'http://www.noaa.gov/testURL', 'test@test.com', (SELECT svy_type_id from ccd_svy_types where svy_type_name = 'NMFS Survey'), 'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.', 'test content');

--cruise legs
insert into ccd_cruise_legs (LEG_NAME, LEG_START_DATE, LEG_END_DATE, LEG_DESC, CRUISE_ID, VESSEL_ID, PLAT_TYPE_ID, TZ_NAME) values ('HA1007', TO_DATE('9/4/2010', 'MM/DD/YYYY'), TO_DATE('9/29/2010', 'MM/DD/YYYY'), '', (SELECT CCD_CRUISES.CRUISE_ID FROM CCD_CRUISES where cruise_name = 'HA1007'), (select vessel_id from ccd_vessels where vessel_name = 'Hi''ialakai'), (select PLAT_TYPE_ID from CCD_PLAT_TYPES where PLAT_TYPE_NAME = 'Fishery Survey Vessel (FSV)'), 'US/Hawaii');
insert into ccd_cruise_legs (LEG_NAME, LEG_START_DATE, LEG_END_DATE, LEG_DESC, CRUISE_ID, VESSEL_ID, PLAT_TYPE_ID, TZ_NAME) values ('OES0407', TO_DATE('5/30/2004', 'MM/DD/YYYY'), TO_DATE('6/14/2004', 'MM/DD/YYYY'), '', (SELECT CCD_CRUISES.CRUISE_ID FROM CCD_CRUISES where cruise_name = 'OES0407'), (select vessel_id from ccd_vessels where vessel_name = 'Oscar Elton Sette'), (select PLAT_TYPE_ID from CCD_PLAT_TYPES where PLAT_TYPE_NAME = 'Fishery Survey Vessel (FSV)'), 'US/Hawaii');
insert into ccd_cruise_legs (LEG_NAME, LEG_START_DATE, LEG_END_DATE, LEG_DESC, CRUISE_ID, VESSEL_ID, PLAT_TYPE_ID, TZ_NAME) values ('OES0407 (copy)', TO_DATE('5/30/2004', 'MM/DD/YYYY'), TO_DATE('6/14/2004', 'MM/DD/YYYY'), '', (SELECT CCD_CRUISES.CRUISE_ID FROM CCD_CRUISES where cruise_name = 'OES0407'), (select vessel_id from ccd_vessels where vessel_name = 'Oscar Elton Sette'), (select PLAT_TYPE_ID from CCD_PLAT_TYPES where PLAT_TYPE_NAME = 'Fishery Survey Vessel (FSV)'), 'US/Hawaii');
insert into ccd_cruise_legs (LEG_NAME, LEG_START_DATE, LEG_END_DATE, LEG_DESC, CRUISE_ID, VESSEL_ID, PLAT_TYPE_ID, TZ_NAME) values ('OES0410', TO_DATE('7/30/2004', 'MM/DD/YYYY'), TO_DATE('8/16/2004', 'MM/DD/YYYY'), '', (SELECT CCD_CRUISES.CRUISE_ID FROM CCD_CRUISES where cruise_name = 'OES0410'), (select vessel_id from ccd_vessels where vessel_name = 'Oscar Elton Sette'), (select PLAT_TYPE_ID from CCD_PLAT_TYPES where PLAT_TYPE_NAME = 'Fishery Survey Vessel (FSV)'), 'US/Hawaii');
insert into ccd_cruise_legs (LEG_NAME, LEG_START_DATE, LEG_END_DATE, LEG_DESC, CRUISE_ID, VESSEL_ID, PLAT_TYPE_ID, TZ_NAME) values ('OES0908_LEGI', TO_DATE('9/1/2009', 'MM/DD/YYYY'), TO_DATE('9/30/2009', 'MM/DD/YYYY'), '', (SELECT CCD_CRUISES.CRUISE_ID FROM CCD_CRUISES where cruise_name = 'OES0908'), (select vessel_id from ccd_vessels where vessel_name = 'Oscar Elton Sette'), (select PLAT_TYPE_ID from CCD_PLAT_TYPES where PLAT_TYPE_NAME = 'Fishery Survey Vessel (FSV)'), 'US/Hawaii');
insert into ccd_cruise_legs (LEG_NAME, LEG_START_DATE, LEG_END_DATE, LEG_DESC, CRUISE_ID, VESSEL_ID, PLAT_TYPE_ID, TZ_NAME) values ('OES0908_LEGII', TO_DATE('10/6/2009', 'MM/DD/YYYY'), TO_DATE('10/30/2009', 'MM/DD/YYYY'), '', (SELECT CCD_CRUISES.CRUISE_ID FROM CCD_CRUISES where cruise_name = 'OES0908'), (select vessel_id from ccd_vessels where vessel_name = 'Oscar Elton Sette'), (select PLAT_TYPE_ID from CCD_PLAT_TYPES where PLAT_TYPE_NAME = 'Fishery Survey Vessel (FSV)'), 'US/Hawaii');
insert into ccd_cruise_legs (LEG_NAME, LEG_START_DATE, LEG_END_DATE, LEG_DESC, CRUISE_ID, VESSEL_ID, PLAT_TYPE_ID, TZ_NAME) values ('RL-17-05 Leg 1', TO_DATE('8/17/2017', 'MM/DD/YYYY'), TO_DATE('9/5/2017', 'MM/DD/YYYY'), 'Leg dates were retrieved via online Ship Schedule (https://sdat.noaa.gov/Account/Login?ReturnUrl=%2FHome%2FSchedule)', (SELECT CCD_CRUISES.CRUISE_ID FROM CCD_CRUISES where cruise_name = 'RL-17-05'), (select vessel_id from ccd_vessels where vessel_name = 'Reuben Lasker'), (select PLAT_TYPE_ID from CCD_PLAT_TYPES where PLAT_TYPE_NAME = 'Fishery Survey Vessel (FSV)'), 'US/Hawaii');
insert into ccd_cruise_legs (LEG_NAME, LEG_START_DATE, LEG_END_DATE, LEG_DESC, CRUISE_ID, VESSEL_ID, PLAT_TYPE_ID, TZ_NAME) values ('RL-17-05 Leg 2', TO_DATE('9/11/2017', 'MM/DD/YYYY'), TO_DATE('9/30/2017', 'MM/DD/YYYY'), 'Leg dates were retrieved via online Ship Schedule (https://sdat.noaa.gov/Account/Login?ReturnUrl=%2FHome%2FSchedule)', (SELECT CCD_CRUISES.CRUISE_ID FROM CCD_CRUISES where cruise_name = 'RL-17-05'), (select vessel_id from ccd_vessels where vessel_name = 'Reuben Lasker'), (select PLAT_TYPE_ID from CCD_PLAT_TYPES where PLAT_TYPE_NAME = 'Fishery Survey Vessel (FSV)'), 'US/Hawaii');
insert into ccd_cruise_legs (LEG_NAME, LEG_START_DATE, LEG_END_DATE, LEG_DESC, CRUISE_ID, VESSEL_ID, PLAT_TYPE_ID, TZ_NAME) values ('TC9909_LEGI', TO_DATE('8/13/1999', 'MM/DD/YYYY'), TO_DATE('8/29/1999', 'MM/DD/YYYY'), '', (SELECT CCD_CRUISES.CRUISE_ID FROM CCD_CRUISES where cruise_name = 'TC9909'), (select vessel_id from ccd_vessels where vessel_name = 'Townsend Cromwell'), (select PLAT_TYPE_ID from CCD_PLAT_TYPES where PLAT_TYPE_NAME = 'Fishery Survey Vessel (FSV)'), 'US/Hawaii');
insert into ccd_cruise_legs (LEG_NAME, LEG_START_DATE, LEG_END_DATE, LEG_DESC, CRUISE_ID, VESSEL_ID, PLAT_TYPE_ID, TZ_NAME) values ('TC9909_LEGII', TO_DATE('8/30/1999', 'MM/DD/YYYY'), TO_DATE('9/7/1999', 'MM/DD/YYYY'), '', (SELECT CCD_CRUISES.CRUISE_ID FROM CCD_CRUISES where cruise_name = 'TC9909'), (select vessel_id from ccd_vessels where vessel_name = 'Townsend Cromwell'), (select PLAT_TYPE_ID from CCD_PLAT_TYPES where PLAT_TYPE_NAME = 'Fishery Survey Vessel (FSV)'), 'US/Hawaii');



--leg aliases:
insert into ccd_leg_aliases (cruise_leg_id, LEG_ALIAS_NAME) values ((select cruise_leg_id from ccd_cruise_legs where leg_name = 'HA1007'), 'HA1007');

insert into ccd_leg_aliases (cruise_leg_id, LEG_ALIAS_NAME) values ((select cruise_leg_id from ccd_cruise_legs where leg_name = 'OES0407'), 'OES0407');
insert into ccd_leg_aliases (cruise_leg_id, LEG_ALIAS_NAME) values ((select cruise_leg_id from ccd_cruise_legs where leg_name = 'OES0407'), 'OS-04-07');


insert into ccd_leg_aliases (cruise_leg_id, LEG_ALIAS_NAME) values ((select cruise_leg_id from ccd_cruise_legs where leg_name = 'OES0410'), 'OES0410');
insert into ccd_leg_aliases (cruise_leg_id, LEG_ALIAS_NAME) values ((select cruise_leg_id from ccd_cruise_legs where leg_name = 'OES0410'), 'OS-04-10');
insert into ccd_leg_aliases (cruise_leg_id, LEG_ALIAS_NAME) values ((select cruise_leg_id from ccd_cruise_legs where leg_name = 'OES0410'), 'OES0410 (copy)');


insert into ccd_leg_aliases (cruise_leg_id, LEG_ALIAS_NAME) values ((select cruise_leg_id from ccd_cruise_legs where leg_name = 'OES0908_LEGI'), 'OES0908_LEGI');
insert into ccd_leg_aliases (cruise_leg_id, LEG_ALIAS_NAME) values ((select cruise_leg_id from ccd_cruise_legs where leg_name = 'OES0908_LEGII'), 'OES0908_LEGII');

insert into ccd_leg_aliases (cruise_leg_id, LEG_ALIAS_NAME) values ((select cruise_leg_id from ccd_cruise_legs where leg_name = 'OES0908_LEGI'), 'OES0908 LEGI');
insert into ccd_leg_aliases (cruise_leg_id, LEG_ALIAS_NAME) values ((select cruise_leg_id from ccd_cruise_legs where leg_name = 'OES0908_LEGII'), 'OES0908 LEGII');

insert into ccd_leg_aliases (cruise_leg_id, LEG_ALIAS_NAME) values ((select cruise_leg_id from ccd_cruise_legs where leg_name = 'OES0908_LEGI'), 'OES0908 LEG 1');
insert into ccd_leg_aliases (cruise_leg_id, LEG_ALIAS_NAME) values ((select cruise_leg_id from ccd_cruise_legs where leg_name = 'OES0908_LEGII'), 'OES0908 LEG 2');


insert into ccd_leg_aliases (cruise_leg_id, LEG_ALIAS_NAME) values ((select cruise_leg_id from ccd_cruise_legs where leg_name = 'RL-17-05 Leg 1'), 'RL-17-05_Leg1');
insert into ccd_leg_aliases (cruise_leg_id, LEG_ALIAS_NAME) values ((select cruise_leg_id from ccd_cruise_legs where leg_name = 'RL-17-05 Leg 2'), 'RL-17-05_Leg2');

insert into ccd_leg_aliases (cruise_leg_id, LEG_ALIAS_NAME) values ((select cruise_leg_id from ccd_cruise_legs where leg_name = 'RL-17-05 Leg 1'), 'RL1705_Leg1');
insert into ccd_leg_aliases (cruise_leg_id, LEG_ALIAS_NAME) values ((select cruise_leg_id from ccd_cruise_legs where leg_name = 'RL-17-05 Leg 2'), 'RL1705_Leg2');



--cruise leg data sets:
insert into ccd_leg_data_sets (cruise_leg_id, DATA_SET_ID) values ((select cruise_leg_id from ccd_cruise_legs where leg_name = 'OES0908_LEGI'), (SELECT DATA_SET_ID FROM CCD_DATA_SETS WHERE DATA_SET_NAME = '2009 CTD Data'));
insert into ccd_leg_data_sets (cruise_leg_id, DATA_SET_ID) values ((select cruise_leg_id from ccd_cruise_legs where leg_name = 'OES0908_LEGII'), (SELECT DATA_SET_ID FROM CCD_DATA_SETS WHERE DATA_SET_NAME = '2009 CTD Data'));
insert into ccd_leg_data_sets (cruise_leg_id, DATA_SET_ID) values ((select cruise_leg_id from ccd_cruise_legs where leg_name = 'RL-17-05 Leg 1'), (SELECT DATA_SET_ID FROM CCD_DATA_SETS WHERE DATA_SET_NAME = '2017 CTD Data'));
insert into ccd_leg_data_sets (cruise_leg_id, DATA_SET_ID) values ((select cruise_leg_id from ccd_cruise_legs where leg_name = 'RL-17-05 Leg 2'), (SELECT DATA_SET_ID FROM CCD_DATA_SETS WHERE DATA_SET_NAME = '2017 CTD Data'));
insert into ccd_leg_data_sets (cruise_leg_id, DATA_SET_ID) values ((select cruise_leg_id from ccd_cruise_legs where leg_name = 'TC9909_LEGI'), (SELECT DATA_SET_ID FROM CCD_DATA_SETS WHERE DATA_SET_NAME = '1999 CTD Data'));
insert into ccd_leg_data_sets (cruise_leg_id, DATA_SET_ID) values ((select cruise_leg_id from ccd_cruise_legs where leg_name = 'TC9909_LEGII'), (SELECT DATA_SET_ID FROM CCD_DATA_SETS WHERE DATA_SET_NAME = '1999 CTD Data'));



--cruise survey Categories
INSERT INTO CCD_CRUISE_SVY_CATS (CRUISE_ID, SVY_CAT_ID, PRIMARY_YN) VALUES ((SELECT CRUISE_ID FROM CCD_CRUISES WHERE CRUISE_NAME = 'SE-17-07'), (SELECT SVY_CAT_ID FROM CCD_SVY_CATS WHERE SVY_CAT_NAME = 'Habitat Monitoring and Assessment'), 'N');
INSERT INTO CCD_CRUISE_SVY_CATS (CRUISE_ID, SVY_CAT_ID, PRIMARY_YN) VALUES ((SELECT CRUISE_ID FROM CCD_CRUISES WHERE CRUISE_NAME = 'SE-17-07'), (SELECT SVY_CAT_ID FROM CCD_SVY_CATS WHERE SVY_CAT_NAME = 'Protected Species Monitoring and Assessment'), 'Y');
INSERT INTO CCD_CRUISE_SVY_CATS (CRUISE_ID, SVY_CAT_ID, PRIMARY_YN) VALUES ((SELECT CRUISE_ID FROM CCD_CRUISES WHERE CRUISE_NAME = 'SE-17-07'), (SELECT SVY_CAT_ID FROM CCD_SVY_CATS WHERE SVY_CAT_NAME = 'Science, Services and Stewardship'), 'N');
INSERT INTO CCD_CRUISE_SVY_CATS (CRUISE_ID, SVY_CAT_ID, PRIMARY_YN) VALUES ((SELECT CRUISE_ID FROM CCD_CRUISES WHERE CRUISE_NAME = 'TC9909'), (SELECT SVY_CAT_ID FROM CCD_SVY_CATS WHERE SVY_CAT_NAME = 'Ecosystem Monitoring and Assessment'), 'Y');
INSERT INTO CCD_CRUISE_SVY_CATS (CRUISE_ID, SVY_CAT_ID, PRIMARY_YN) VALUES ((SELECT CRUISE_ID FROM CCD_CRUISES WHERE CRUISE_NAME = 'TC9909'), (SELECT SVY_CAT_ID FROM CCD_SVY_CATS WHERE SVY_CAT_NAME = 'Protected Species Monitoring and Assessment'), 'Y');
INSERT INTO CCD_CRUISE_SVY_CATS (CRUISE_ID, SVY_CAT_ID, PRIMARY_YN) VALUES ((SELECT CRUISE_ID FROM CCD_CRUISES WHERE CRUISE_NAME = 'TC9909'), (SELECT SVY_CAT_ID FROM CCD_SVY_CATS WHERE SVY_CAT_NAME = 'Science, Services and Stewardship'), 'N');
INSERT INTO CCD_CRUISE_SVY_CATS (CRUISE_ID, SVY_CAT_ID, PRIMARY_YN) VALUES ((SELECT CRUISE_ID FROM CCD_CRUISES WHERE CRUISE_NAME = 'RL-17-05'), (SELECT SVY_CAT_ID FROM CCD_SVY_CATS WHERE SVY_CAT_NAME = 'Protected Species Monitoring and Assessment'), 'Y');
INSERT INTO CCD_CRUISE_SVY_CATS (CRUISE_ID, SVY_CAT_ID, PRIMARY_YN) VALUES ((SELECT CRUISE_ID FROM CCD_CRUISES WHERE CRUISE_NAME = 'RL-17-05'), (SELECT SVY_CAT_ID FROM CCD_SVY_CATS WHERE SVY_CAT_NAME = 'Science, Services and Stewardship'), 'N');



--cruise ESA species
INSERT INTO CCD_CRUISE_SPP_ESA (CRUISE_ID, TGT_SPP_ESA_ID) VALUES ((SELECT CRUISE_ID FROM CCD_CRUISES WHERE CRUISE_NAME = 'SE-17-07'), (SELECT TGT_SPP_ESA_ID FROM CCD_TGT_SPP_ESA WHERE TGT_SPP_ESA_NAME = 'Hawaiian Monk Seal'));
INSERT INTO CCD_CRUISE_SPP_ESA (CRUISE_ID, TGT_SPP_ESA_ID) VALUES ((SELECT CRUISE_ID FROM CCD_CRUISES WHERE CRUISE_NAME = 'SE-17-07'), (SELECT TGT_SPP_ESA_ID FROM CCD_TGT_SPP_ESA WHERE TGT_SPP_ESA_NAME = 'hawksbill turtle'));
INSERT INTO CCD_CRUISE_SPP_ESA (CRUISE_ID, TGT_SPP_ESA_ID) VALUES ((SELECT CRUISE_ID FROM CCD_CRUISES WHERE CRUISE_NAME = 'SE-17-07'), (SELECT TGT_SPP_ESA_ID FROM CCD_TGT_SPP_ESA WHERE TGT_SPP_ESA_NAME = 'Humpback Whale'));
INSERT INTO CCD_CRUISE_SPP_ESA (CRUISE_ID, TGT_SPP_ESA_ID) VALUES ((SELECT CRUISE_ID FROM CCD_CRUISES WHERE CRUISE_NAME = 'SE-17-07'), (SELECT TGT_SPP_ESA_ID FROM CCD_TGT_SPP_ESA WHERE TGT_SPP_ESA_NAME = 'leatherback turtle'));
INSERT INTO CCD_CRUISE_SPP_ESA (CRUISE_ID, TGT_SPP_ESA_ID) VALUES ((SELECT CRUISE_ID FROM CCD_CRUISES WHERE CRUISE_NAME = 'SE-17-07'), (SELECT TGT_SPP_ESA_ID FROM CCD_TGT_SPP_ESA WHERE TGT_SPP_ESA_NAME = 'loggerhead turtle'));
INSERT INTO CCD_CRUISE_SPP_ESA (CRUISE_ID, TGT_SPP_ESA_ID) VALUES ((SELECT CRUISE_ID FROM CCD_CRUISES WHERE CRUISE_NAME = 'SE-17-07'), (SELECT TGT_SPP_ESA_ID FROM CCD_TGT_SPP_ESA WHERE TGT_SPP_ESA_NAME = 'staghorn coral'));
INSERT INTO CCD_CRUISE_SPP_ESA (CRUISE_ID, TGT_SPP_ESA_ID) VALUES ((SELECT CRUISE_ID FROM CCD_CRUISES WHERE CRUISE_NAME = 'SE-17-07'), (SELECT TGT_SPP_ESA_ID FROM CCD_TGT_SPP_ESA WHERE TGT_SPP_ESA_NAME = 'Kemp''s ridley turtle'));
INSERT INTO CCD_CRUISE_SPP_ESA (CRUISE_ID, TGT_SPP_ESA_ID) VALUES ((SELECT CRUISE_ID FROM CCD_CRUISES WHERE CRUISE_NAME = 'SE-17-07'), (SELECT TGT_SPP_ESA_ID FROM CCD_TGT_SPP_ESA WHERE TGT_SPP_ESA_NAME = 'Sei Whale'));
INSERT INTO CCD_CRUISE_SPP_ESA (CRUISE_ID, TGT_SPP_ESA_ID) VALUES ((SELECT CRUISE_ID FROM CCD_CRUISES WHERE CRUISE_NAME = 'SE-17-07'), (SELECT TGT_SPP_ESA_ID FROM CCD_TGT_SPP_ESA WHERE TGT_SPP_ESA_NAME = 'Fin Whale'));
INSERT INTO CCD_CRUISE_SPP_ESA (CRUISE_ID, TGT_SPP_ESA_ID) VALUES ((SELECT CRUISE_ID FROM CCD_CRUISES WHERE CRUISE_NAME = 'TC9909'), (SELECT TGT_SPP_ESA_ID FROM CCD_TGT_SPP_ESA WHERE TGT_SPP_ESA_NAME = 'Hawaiian Monk Seal'));
INSERT INTO CCD_CRUISE_SPP_ESA (CRUISE_ID, TGT_SPP_ESA_ID) VALUES ((SELECT CRUISE_ID FROM CCD_CRUISES WHERE CRUISE_NAME = 'TC9909'), (SELECT TGT_SPP_ESA_ID FROM CCD_TGT_SPP_ESA WHERE TGT_SPP_ESA_NAME = 'hawksbill turtle'));
INSERT INTO CCD_CRUISE_SPP_ESA (CRUISE_ID, TGT_SPP_ESA_ID) VALUES ((SELECT CRUISE_ID FROM CCD_CRUISES WHERE CRUISE_NAME = 'TC9909'), (SELECT TGT_SPP_ESA_ID FROM CCD_TGT_SPP_ESA WHERE TGT_SPP_ESA_NAME = 'Humpback Whale'));


INSERT INTO CCD_CRUISE_SPP_ESA (CRUISE_ID, TGT_SPP_ESA_ID) VALUES ((SELECT CRUISE_ID FROM CCD_CRUISES WHERE CRUISE_NAME = 'RL-17-05'), (SELECT TGT_SPP_ESA_ID FROM CCD_TGT_SPP_ESA WHERE TGT_SPP_ESA_NAME = 'Humpback Whale'));
INSERT INTO CCD_CRUISE_SPP_ESA (CRUISE_ID, TGT_SPP_ESA_ID) VALUES ((SELECT CRUISE_ID FROM CCD_CRUISES WHERE CRUISE_NAME = 'RL-17-05'), (SELECT TGT_SPP_ESA_ID FROM CCD_TGT_SPP_ESA WHERE TGT_SPP_ESA_NAME = 'leatherback turtle'));
INSERT INTO CCD_CRUISE_SPP_ESA (CRUISE_ID, TGT_SPP_ESA_ID) VALUES ((SELECT CRUISE_ID FROM CCD_CRUISES WHERE CRUISE_NAME = 'RL-17-05'), (SELECT TGT_SPP_ESA_ID FROM CCD_TGT_SPP_ESA WHERE TGT_SPP_ESA_NAME = 'loggerhead turtle'));
INSERT INTO CCD_CRUISE_SPP_ESA (CRUISE_ID, TGT_SPP_ESA_ID) VALUES ((SELECT CRUISE_ID FROM CCD_CRUISES WHERE CRUISE_NAME = 'RL-17-05'), (SELECT TGT_SPP_ESA_ID FROM CCD_TGT_SPP_ESA WHERE TGT_SPP_ESA_NAME = 'staghorn coral'));
INSERT INTO CCD_CRUISE_SPP_ESA (CRUISE_ID, TGT_SPP_ESA_ID) VALUES ((SELECT CRUISE_ID FROM CCD_CRUISES WHERE CRUISE_NAME = 'RL-17-05'), (SELECT TGT_SPP_ESA_ID FROM CCD_TGT_SPP_ESA WHERE TGT_SPP_ESA_NAME = 'Kemp''s ridley turtle'));



--cruise FSSI species
INSERT INTO CCD_CRUISE_SPP_FSSI (CRUISE_ID, TGT_SPP_FSSI_ID) VALUES ((SELECT CRUISE_ID FROM CCD_CRUISES WHERE CRUISE_NAME = 'SE-17-07'), (SELECT TGT_SPP_FSSI_ID FROM CCD_TGT_SPP_FSSI WHERE TGT_SPP_FSSI_NAME = 'Blue shark - Pacific'));
INSERT INTO CCD_CRUISE_SPP_FSSI (CRUISE_ID, TGT_SPP_FSSI_ID) VALUES ((SELECT CRUISE_ID FROM CCD_CRUISES WHERE CRUISE_NAME = 'SE-17-07'), (SELECT TGT_SPP_FSSI_ID FROM CCD_TGT_SPP_FSSI WHERE TGT_SPP_FSSI_NAME = 'Dolphinfish - Pacific'));
INSERT INTO CCD_CRUISE_SPP_FSSI (CRUISE_ID, TGT_SPP_FSSI_ID) VALUES ((SELECT CRUISE_ID FROM CCD_CRUISES WHERE CRUISE_NAME = 'SE-17-07'), (SELECT TGT_SPP_FSSI_ID FROM CCD_TGT_SPP_FSSI WHERE TGT_SPP_FSSI_NAME = 'Hawaiian Archipelago Bottomfish Multi-species Complex'));
INSERT INTO CCD_CRUISE_SPP_FSSI (CRUISE_ID, TGT_SPP_FSSI_ID) VALUES ((SELECT CRUISE_ID FROM CCD_CRUISES WHERE CRUISE_NAME = 'SE-17-07'), (SELECT TGT_SPP_FSSI_ID FROM CCD_TGT_SPP_FSSI WHERE TGT_SPP_FSSI_NAME = 'Kawakawa - Tropical Pacific'));
INSERT INTO CCD_CRUISE_SPP_FSSI (CRUISE_ID, TGT_SPP_FSSI_ID) VALUES ((SELECT CRUISE_ID FROM CCD_CRUISES WHERE CRUISE_NAME = 'SE-17-07'), (SELECT TGT_SPP_FSSI_ID FROM CCD_TGT_SPP_FSSI WHERE TGT_SPP_FSSI_NAME = 'Shortbill spearfish - Pacific'));
INSERT INTO CCD_CRUISE_SPP_FSSI (CRUISE_ID, TGT_SPP_FSSI_ID) VALUES ((SELECT CRUISE_ID FROM CCD_CRUISES WHERE CRUISE_NAME = 'SE-17-07'), (SELECT TGT_SPP_FSSI_ID FROM CCD_TGT_SPP_FSSI WHERE TGT_SPP_FSSI_NAME = 'Opah - Pacific'));
INSERT INTO CCD_CRUISE_SPP_FSSI (CRUISE_ID, TGT_SPP_FSSI_ID) VALUES ((SELECT CRUISE_ID FROM CCD_CRUISES WHERE CRUISE_NAME = 'TC9909'), (SELECT TGT_SPP_FSSI_ID FROM CCD_TGT_SPP_FSSI WHERE TGT_SPP_FSSI_NAME = 'Wahoo - Pacific'));
INSERT INTO CCD_CRUISE_SPP_FSSI (CRUISE_ID, TGT_SPP_FSSI_ID) VALUES ((SELECT CRUISE_ID FROM CCD_CRUISES WHERE CRUISE_NAME = 'TC9909'), (SELECT TGT_SPP_FSSI_ID FROM CCD_TGT_SPP_FSSI WHERE TGT_SPP_FSSI_NAME = 'Yellowfin tuna - Central Western Pacific'));
INSERT INTO CCD_CRUISE_SPP_FSSI (CRUISE_ID, TGT_SPP_FSSI_ID) VALUES ((SELECT CRUISE_ID FROM CCD_CRUISES WHERE CRUISE_NAME = 'TC9909'), (SELECT TGT_SPP_FSSI_ID FROM CCD_TGT_SPP_FSSI WHERE TGT_SPP_FSSI_NAME = 'Albacore - South Pacific'));
INSERT INTO CCD_CRUISE_SPP_FSSI (CRUISE_ID, TGT_SPP_FSSI_ID) VALUES ((SELECT CRUISE_ID FROM CCD_CRUISES WHERE CRUISE_NAME = 'TC9909'), (SELECT TGT_SPP_FSSI_ID FROM CCD_TGT_SPP_FSSI WHERE TGT_SPP_FSSI_NAME = 'American Samoa Bottomfish Multi-species Complex'));
INSERT INTO CCD_CRUISE_SPP_FSSI (CRUISE_ID, TGT_SPP_FSSI_ID) VALUES ((SELECT CRUISE_ID FROM CCD_CRUISES WHERE CRUISE_NAME = 'TC9909'), (SELECT TGT_SPP_FSSI_ID FROM CCD_TGT_SPP_FSSI WHERE TGT_SPP_FSSI_NAME = 'Blue marlin - Pacific'));

INSERT INTO CCD_CRUISE_SPP_FSSI (CRUISE_ID, TGT_SPP_FSSI_ID) VALUES ((SELECT CRUISE_ID FROM CCD_CRUISES WHERE CRUISE_NAME = 'RL-17-05'), (SELECT TGT_SPP_FSSI_ID FROM CCD_TGT_SPP_FSSI WHERE TGT_SPP_FSSI_NAME = 'Dolphinfish - Pacific'));
INSERT INTO CCD_CRUISE_SPP_FSSI (CRUISE_ID, TGT_SPP_FSSI_ID) VALUES ((SELECT CRUISE_ID FROM CCD_CRUISES WHERE CRUISE_NAME = 'RL-17-05'), (SELECT TGT_SPP_FSSI_ID FROM CCD_TGT_SPP_FSSI WHERE TGT_SPP_FSSI_NAME = 'Hawaiian Archipelago Bottomfish Multi-species Complex'));
INSERT INTO CCD_CRUISE_SPP_FSSI (CRUISE_ID, TGT_SPP_FSSI_ID) VALUES ((SELECT CRUISE_ID FROM CCD_CRUISES WHERE CRUISE_NAME = 'RL-17-05'), (SELECT TGT_SPP_FSSI_ID FROM CCD_TGT_SPP_FSSI WHERE TGT_SPP_FSSI_NAME = 'Kawakawa - Tropical Pacific'));
INSERT INTO CCD_CRUISE_SPP_FSSI (CRUISE_ID, TGT_SPP_FSSI_ID) VALUES ((SELECT CRUISE_ID FROM CCD_CRUISES WHERE CRUISE_NAME = 'RL-17-05'), (SELECT TGT_SPP_FSSI_ID FROM CCD_TGT_SPP_FSSI WHERE TGT_SPP_FSSI_NAME = 'Shortbill spearfish - Pacific'));
INSERT INTO CCD_CRUISE_SPP_FSSI (CRUISE_ID, TGT_SPP_FSSI_ID) VALUES ((SELECT CRUISE_ID FROM CCD_CRUISES WHERE CRUISE_NAME = 'RL-17-05'), (SELECT TGT_SPP_FSSI_ID FROM CCD_TGT_SPP_FSSI WHERE TGT_SPP_FSSI_NAME = 'Opah - Pacific'));

--MMPA species:
INSERT INTO CCD_CRUISE_SPP_MMPA (CRUISE_ID, TGT_SPP_MMPA_ID) VALUES ((SELECT CRUISE_ID FROM CCD_CRUISES WHERE CRUISE_NAME = 'SE-17-07'), (SELECT TGT_SPP_MMPA_ID FROM CCD_TGT_SPP_MMPA WHERE TGT_SPP_MMPA_NAME = 'Pantropical Spotted Dolphin - Hawaii'));
INSERT INTO CCD_CRUISE_SPP_MMPA (CRUISE_ID, TGT_SPP_MMPA_ID) VALUES ((SELECT CRUISE_ID FROM CCD_CRUISES WHERE CRUISE_NAME = 'SE-17-07'), (SELECT TGT_SPP_MMPA_ID FROM CCD_TGT_SPP_MMPA WHERE TGT_SPP_MMPA_NAME = 'Minke Whale - Hawaii'));
INSERT INTO CCD_CRUISE_SPP_MMPA (CRUISE_ID, TGT_SPP_MMPA_ID) VALUES ((SELECT CRUISE_ID FROM CCD_CRUISES WHERE CRUISE_NAME = 'SE-17-07'), (SELECT TGT_SPP_MMPA_ID FROM CCD_TGT_SPP_MMPA WHERE TGT_SPP_MMPA_NAME = 'Longman''s Beaked Whale - Hawaii'));
INSERT INTO CCD_CRUISE_SPP_MMPA (CRUISE_ID, TGT_SPP_MMPA_ID) VALUES ((SELECT CRUISE_ID FROM CCD_CRUISES WHERE CRUISE_NAME = 'SE-17-07'), (SELECT TGT_SPP_MMPA_ID FROM CCD_TGT_SPP_MMPA WHERE TGT_SPP_MMPA_NAME = 'Pygmy Sperm Whale - Hawaii'));
INSERT INTO CCD_CRUISE_SPP_MMPA (CRUISE_ID, TGT_SPP_MMPA_ID) VALUES ((SELECT CRUISE_ID FROM CCD_CRUISES WHERE CRUISE_NAME = 'SE-17-07'), (SELECT TGT_SPP_MMPA_ID FROM CCD_TGT_SPP_MMPA WHERE TGT_SPP_MMPA_NAME = 'Sei Whale - Hawaii'));
INSERT INTO CCD_CRUISE_SPP_MMPA (CRUISE_ID, TGT_SPP_MMPA_ID) VALUES ((SELECT CRUISE_ID FROM CCD_CRUISES WHERE CRUISE_NAME = 'SE-17-07'), (SELECT TGT_SPP_MMPA_ID FROM CCD_TGT_SPP_MMPA WHERE TGT_SPP_MMPA_NAME = 'Risso''s Dolphin - Hawaii'));
INSERT INTO CCD_CRUISE_SPP_MMPA (CRUISE_ID, TGT_SPP_MMPA_ID) VALUES ((SELECT CRUISE_ID FROM CCD_CRUISES WHERE CRUISE_NAME = 'SE-17-07'), (SELECT TGT_SPP_MMPA_ID FROM CCD_TGT_SPP_MMPA WHERE TGT_SPP_MMPA_NAME = 'Short-Finned Pilot Whale - Hawaii'));
INSERT INTO CCD_CRUISE_SPP_MMPA (CRUISE_ID, TGT_SPP_MMPA_ID) VALUES ((SELECT CRUISE_ID FROM CCD_CRUISES WHERE CRUISE_NAME = 'TC9909'), (SELECT TGT_SPP_MMPA_ID FROM CCD_TGT_SPP_MMPA WHERE TGT_SPP_MMPA_NAME = 'Sei Whale - Hawaii'));
INSERT INTO CCD_CRUISE_SPP_MMPA (CRUISE_ID, TGT_SPP_MMPA_ID) VALUES ((SELECT CRUISE_ID FROM CCD_CRUISES WHERE CRUISE_NAME = 'TC9909'), (SELECT TGT_SPP_MMPA_ID FROM CCD_TGT_SPP_MMPA WHERE TGT_SPP_MMPA_NAME = 'Risso''s Dolphin - Hawaii'));
INSERT INTO CCD_CRUISE_SPP_MMPA (CRUISE_ID, TGT_SPP_MMPA_ID) VALUES ((SELECT CRUISE_ID FROM CCD_CRUISES WHERE CRUISE_NAME = 'TC9909'), (SELECT TGT_SPP_MMPA_ID FROM CCD_TGT_SPP_MMPA WHERE TGT_SPP_MMPA_NAME = 'Short-Finned Pilot Whale - Hawaii'));
INSERT INTO CCD_CRUISE_SPP_MMPA (CRUISE_ID, TGT_SPP_MMPA_ID) VALUES ((SELECT CRUISE_ID FROM CCD_CRUISES WHERE CRUISE_NAME = 'TC9909'), (SELECT TGT_SPP_MMPA_ID FROM CCD_TGT_SPP_MMPA WHERE TGT_SPP_MMPA_NAME = 'Sperm Whale - Hawaii'));
INSERT INTO CCD_CRUISE_SPP_MMPA (CRUISE_ID, TGT_SPP_MMPA_ID) VALUES ((SELECT CRUISE_ID FROM CCD_CRUISES WHERE CRUISE_NAME = 'TC9909'), (SELECT TGT_SPP_MMPA_ID FROM CCD_TGT_SPP_MMPA WHERE TGT_SPP_MMPA_NAME = 'Spinner Dolphin - Hawaii'));
INSERT INTO CCD_CRUISE_SPP_MMPA (CRUISE_ID, TGT_SPP_MMPA_ID) VALUES ((SELECT CRUISE_ID FROM CCD_CRUISES WHERE CRUISE_NAME = 'TC9909'), (SELECT TGT_SPP_MMPA_ID FROM CCD_TGT_SPP_MMPA WHERE TGT_SPP_MMPA_NAME = 'Striped Dolphin - Hawaii'));


INSERT INTO CCD_CRUISE_SPP_MMPA (CRUISE_ID, TGT_SPP_MMPA_ID) VALUES ((SELECT CRUISE_ID FROM CCD_CRUISES WHERE CRUISE_NAME = 'RL-17-05'), (SELECT TGT_SPP_MMPA_ID FROM CCD_TGT_SPP_MMPA WHERE TGT_SPP_MMPA_NAME = 'Pygmy Sperm Whale - Hawaii'));
INSERT INTO CCD_CRUISE_SPP_MMPA (CRUISE_ID, TGT_SPP_MMPA_ID) VALUES ((SELECT CRUISE_ID FROM CCD_CRUISES WHERE CRUISE_NAME = 'RL-17-05'), (SELECT TGT_SPP_MMPA_ID FROM CCD_TGT_SPP_MMPA WHERE TGT_SPP_MMPA_NAME = 'Sei Whale - Hawaii'));
INSERT INTO CCD_CRUISE_SPP_MMPA (CRUISE_ID, TGT_SPP_MMPA_ID) VALUES ((SELECT CRUISE_ID FROM CCD_CRUISES WHERE CRUISE_NAME = 'RL-17-05'), (SELECT TGT_SPP_MMPA_ID FROM CCD_TGT_SPP_MMPA WHERE TGT_SPP_MMPA_NAME = 'Risso''s Dolphin - Hawaii'));
INSERT INTO CCD_CRUISE_SPP_MMPA (CRUISE_ID, TGT_SPP_MMPA_ID) VALUES ((SELECT CRUISE_ID FROM CCD_CRUISES WHERE CRUISE_NAME = 'RL-17-05'), (SELECT TGT_SPP_MMPA_ID FROM CCD_TGT_SPP_MMPA WHERE TGT_SPP_MMPA_NAME = 'Short-Finned Pilot Whale - Hawaii'));


--cruise expected species categories:
INSERT INTO CCD_CRUISE_EXP_SPP (CRUISE_ID, EXP_SPP_CAT_ID) VALUES ((SELECT CRUISE_ID FROM CCD_CRUISES WHERE CRUISE_NAME = 'SE-17-07'), (SELECT EXP_SPP_CAT_ID FROM CCD_EXP_SPP_CATS WHERE EXP_SPP_CAT_NAME = 'Fishes-Benthic Fish'));
INSERT INTO CCD_CRUISE_EXP_SPP (CRUISE_ID, EXP_SPP_CAT_ID) VALUES ((SELECT CRUISE_ID FROM CCD_CRUISES WHERE CRUISE_NAME = 'SE-17-07'), (SELECT EXP_SPP_CAT_ID FROM CCD_EXP_SPP_CATS WHERE EXP_SPP_CAT_NAME = 'Coral-Shallow Water Coral'));
INSERT INTO CCD_CRUISE_EXP_SPP (CRUISE_ID, EXP_SPP_CAT_ID) VALUES ((SELECT CRUISE_ID FROM CCD_CRUISES WHERE CRUISE_NAME = 'SE-17-07'), (SELECT EXP_SPP_CAT_ID FROM CCD_EXP_SPP_CATS WHERE EXP_SPP_CAT_NAME = 'Coral-Octocoral'));
INSERT INTO CCD_CRUISE_EXP_SPP (CRUISE_ID, EXP_SPP_CAT_ID) VALUES ((SELECT CRUISE_ID FROM CCD_CRUISES WHERE CRUISE_NAME = 'SE-17-07'), (SELECT EXP_SPP_CAT_ID FROM CCD_EXP_SPP_CATS WHERE EXP_SPP_CAT_NAME = 'Crustaceans'));
INSERT INTO CCD_CRUISE_EXP_SPP (CRUISE_ID, EXP_SPP_CAT_ID) VALUES ((SELECT CRUISE_ID FROM CCD_CRUISES WHERE CRUISE_NAME = 'SE-17-07'), (SELECT EXP_SPP_CAT_ID FROM CCD_EXP_SPP_CATS WHERE EXP_SPP_CAT_NAME = 'Coral-Mesophotic Hermatypic Coral'));
INSERT INTO CCD_CRUISE_EXP_SPP (CRUISE_ID, EXP_SPP_CAT_ID) VALUES ((SELECT CRUISE_ID FROM CCD_CRUISES WHERE CRUISE_NAME = 'SE-17-07'), (SELECT EXP_SPP_CAT_ID FROM CCD_EXP_SPP_CATS WHERE EXP_SPP_CAT_NAME = 'Invertebrate-Benthic'));
INSERT INTO CCD_CRUISE_EXP_SPP (CRUISE_ID, EXP_SPP_CAT_ID) VALUES ((SELECT CRUISE_ID FROM CCD_CRUISES WHERE CRUISE_NAME = 'SE-17-07'), (SELECT EXP_SPP_CAT_ID FROM CCD_EXP_SPP_CATS WHERE EXP_SPP_CAT_NAME = 'Sea Turtle'));
INSERT INTO CCD_CRUISE_EXP_SPP (CRUISE_ID, EXP_SPP_CAT_ID) VALUES ((SELECT CRUISE_ID FROM CCD_CRUISES WHERE CRUISE_NAME = 'TC9909'), (SELECT EXP_SPP_CAT_ID FROM CCD_EXP_SPP_CATS WHERE EXP_SPP_CAT_NAME = 'Fishes-Reef Fish'));
INSERT INTO CCD_CRUISE_EXP_SPP (CRUISE_ID, EXP_SPP_CAT_ID) VALUES ((SELECT CRUISE_ID FROM CCD_CRUISES WHERE CRUISE_NAME = 'TC9909'), (SELECT EXP_SPP_CAT_ID FROM CCD_EXP_SPP_CATS WHERE EXP_SPP_CAT_NAME = 'Fishes-Pelagic Fish'));
INSERT INTO CCD_CRUISE_EXP_SPP (CRUISE_ID, EXP_SPP_CAT_ID) VALUES ((SELECT CRUISE_ID FROM CCD_CRUISES WHERE CRUISE_NAME = 'TC9909'), (SELECT EXP_SPP_CAT_ID FROM CCD_EXP_SPP_CATS WHERE EXP_SPP_CAT_NAME = 'Fishes-Benthic Fish'));
INSERT INTO CCD_CRUISE_EXP_SPP (CRUISE_ID, EXP_SPP_CAT_ID) VALUES ((SELECT CRUISE_ID FROM CCD_CRUISES WHERE CRUISE_NAME = 'TC9909'), (SELECT EXP_SPP_CAT_ID FROM CCD_EXP_SPP_CATS WHERE EXP_SPP_CAT_NAME = 'Sea Turtle'));

INSERT INTO CCD_CRUISE_EXP_SPP (CRUISE_ID, EXP_SPP_CAT_ID) VALUES ((SELECT CRUISE_ID FROM CCD_CRUISES WHERE CRUISE_NAME = 'RL-17-05'), (SELECT EXP_SPP_CAT_ID FROM CCD_EXP_SPP_CATS WHERE EXP_SPP_CAT_NAME = 'Coral-Mesophotic Hermatypic Coral'));
INSERT INTO CCD_CRUISE_EXP_SPP (CRUISE_ID, EXP_SPP_CAT_ID) VALUES ((SELECT CRUISE_ID FROM CCD_CRUISES WHERE CRUISE_NAME = 'RL-17-05'), (SELECT EXP_SPP_CAT_ID FROM CCD_EXP_SPP_CATS WHERE EXP_SPP_CAT_NAME = 'Coral-Octocoral'));
INSERT INTO CCD_CRUISE_EXP_SPP (CRUISE_ID, EXP_SPP_CAT_ID) VALUES ((SELECT CRUISE_ID FROM CCD_CRUISES WHERE CRUISE_NAME = 'RL-17-05'), (SELECT EXP_SPP_CAT_ID FROM CCD_EXP_SPP_CATS WHERE EXP_SPP_CAT_NAME = 'Fishes-Reef Fish'));
INSERT INTO CCD_CRUISE_EXP_SPP (CRUISE_ID, EXP_SPP_CAT_ID) VALUES ((SELECT CRUISE_ID FROM CCD_CRUISES WHERE CRUISE_NAME = 'RL-17-05'), (SELECT EXP_SPP_CAT_ID FROM CCD_EXP_SPP_CATS WHERE EXP_SPP_CAT_NAME = 'Fishes-Benthic Fish'));


--cruise target species other:
INSERT INTO CCD_TGT_SPP_OTHER (CRUISE_ID, TGT_SPP_OTHER_CNAME, TGT_SPP_OTHER_SNAME) VALUES ((SELECT CRUISE_ID FROM CCD_CRUISES WHERE CRUISE_NAME = 'SE-17-07'), 'Black triggerfish', 'Melichthys niger');
INSERT INTO CCD_TGT_SPP_OTHER (CRUISE_ID, TGT_SPP_OTHER_CNAME, TGT_SPP_OTHER_SNAME) VALUES ((SELECT CRUISE_ID FROM CCD_CRUISES WHERE CRUISE_NAME = 'SE-17-07'), 'Redlip cleaner wrasse', 'Labroides rubrolabiatus');
INSERT INTO CCD_TGT_SPP_OTHER (CRUISE_ID, TGT_SPP_OTHER_CNAME, TGT_SPP_OTHER_SNAME) VALUES ((SELECT CRUISE_ID FROM CCD_CRUISES WHERE CRUISE_NAME = 'SE-17-07'), 'Yellowfin parrotfish', 'Scarus flavipectoralis');
INSERT INTO CCD_TGT_SPP_OTHER (CRUISE_ID, TGT_SPP_OTHER_CNAME, TGT_SPP_OTHER_SNAME) VALUES ((SELECT CRUISE_ID FROM CCD_CRUISES WHERE CRUISE_NAME = 'TC9909'), 'Hawaiian cleaner wrasse', 'Labroides phthirophagus');
INSERT INTO CCD_TGT_SPP_OTHER (CRUISE_ID, TGT_SPP_OTHER_CNAME, TGT_SPP_OTHER_SNAME) VALUES ((SELECT CRUISE_ID FROM CCD_CRUISES WHERE CRUISE_NAME = 'TC9909'), 'Black triggerfish', 'Melichthys niger');
INSERT INTO CCD_TGT_SPP_OTHER (CRUISE_ID, TGT_SPP_OTHER_CNAME, TGT_SPP_OTHER_SNAME) VALUES ((SELECT CRUISE_ID FROM CCD_CRUISES WHERE CRUISE_NAME = 'TC9909'), 'Redlip cleaner wrasse', 'Labroides rubrolabiatus');
INSERT INTO CCD_TGT_SPP_OTHER (CRUISE_ID, TGT_SPP_OTHER_CNAME, TGT_SPP_OTHER_SNAME) VALUES ((SELECT CRUISE_ID FROM CCD_CRUISES WHERE CRUISE_NAME = 'TC9909'), 'Yellowfin parrotfish', 'Scarus flavipectoralis');

INSERT INTO CCD_TGT_SPP_OTHER (CRUISE_ID, TGT_SPP_OTHER_CNAME, TGT_SPP_OTHER_SNAME) VALUES ((SELECT CRUISE_ID FROM CCD_CRUISES WHERE CRUISE_NAME = 'RL-17-05'), 'False moorish idol', 'Heniochus diphreutes');
INSERT INTO CCD_TGT_SPP_OTHER (CRUISE_ID, TGT_SPP_OTHER_CNAME, TGT_SPP_OTHER_SNAME) VALUES ((SELECT CRUISE_ID FROM CCD_CRUISES WHERE CRUISE_NAME = 'RL-17-05'), 'Acanthurus species', 'Acanthurus sp');


--leg regional Ecosystems
INSERT INTO CCD_LEG_ECOSYSTEMS (CRUISE_LEG_ID, REG_ECOSYSTEM_ID) VALUES ((SELECT CRUISE_LEG_ID FROM CCD_CRUISE_LEGS WHERE LEG_NAME = 'OES0908_LEGI'), (SELECT REG_ECOSYSTEM_ID FROM CCD_REG_ECOSYSTEMS WHERE REG_ECOSYSTEM_NAME = 'Pacific Islands Ecosystem Complex'));
INSERT INTO CCD_LEG_ECOSYSTEMS (CRUISE_LEG_ID, REG_ECOSYSTEM_ID) VALUES ((SELECT CRUISE_LEG_ID FROM CCD_CRUISE_LEGS WHERE LEG_NAME = 'OES0908_LEGI'), (SELECT REG_ECOSYSTEM_ID FROM CCD_REG_ECOSYSTEMS WHERE REG_ECOSYSTEM_NAME = 'Eastern Tropical Pacific'));
INSERT INTO CCD_LEG_ECOSYSTEMS (CRUISE_LEG_ID, REG_ECOSYSTEM_ID) VALUES ((SELECT CRUISE_LEG_ID FROM CCD_CRUISE_LEGS WHERE LEG_NAME = 'OES0908_LEGII'), (SELECT REG_ECOSYSTEM_ID FROM CCD_REG_ECOSYSTEMS WHERE REG_ECOSYSTEM_NAME = 'Pacific Islands Ecosystem Complex'));
INSERT INTO CCD_LEG_ECOSYSTEMS (CRUISE_LEG_ID, REG_ECOSYSTEM_ID) VALUES ((SELECT CRUISE_LEG_ID FROM CCD_CRUISE_LEGS WHERE LEG_NAME = 'OES0908_LEGII'), (SELECT REG_ECOSYSTEM_ID FROM CCD_REG_ECOSYSTEMS WHERE REG_ECOSYSTEM_NAME = 'Northeast Shelf'));

INSERT INTO CCD_LEG_ECOSYSTEMS (CRUISE_LEG_ID, REG_ECOSYSTEM_ID) VALUES ((SELECT CRUISE_LEG_ID FROM CCD_CRUISE_LEGS WHERE LEG_NAME = 'RL-17-05 Leg 1'), (SELECT REG_ECOSYSTEM_ID FROM CCD_REG_ECOSYSTEMS WHERE REG_ECOSYSTEM_NAME = 'Pacific Islands Ecosystem Complex'));
INSERT INTO CCD_LEG_ECOSYSTEMS (CRUISE_LEG_ID, REG_ECOSYSTEM_ID) VALUES ((SELECT CRUISE_LEG_ID FROM CCD_CRUISE_LEGS WHERE LEG_NAME = 'RL-17-05 Leg 2'), (SELECT REG_ECOSYSTEM_ID FROM CCD_REG_ECOSYSTEMS WHERE REG_ECOSYSTEM_NAME = 'Eastern Tropical Pacific'));
INSERT INTO CCD_LEG_ECOSYSTEMS (CRUISE_LEG_ID, REG_ECOSYSTEM_ID) VALUES ((SELECT CRUISE_LEG_ID FROM CCD_CRUISE_LEGS WHERE LEG_NAME = 'RL-17-05 Leg 2'), (SELECT REG_ECOSYSTEM_ID FROM CCD_REG_ECOSYSTEMS WHERE REG_ECOSYSTEM_NAME = 'Northeast Shelf'));

INSERT INTO CCD_LEG_ECOSYSTEMS (CRUISE_LEG_ID, REG_ECOSYSTEM_ID) VALUES (CCD_CRUISE_PKG.LEG_ALIAS_TO_CRUISE_LEG_ID_FN('OES0410'), (SELECT REG_ECOSYSTEM_ID FROM CCD_REG_ECOSYSTEMS WHERE UPPER(REG_ECOSYSTEM_NAME) = UPPER('Gulf of California')));

--leg gear:
INSERT INTO CCD_LEG_GEAR (CRUISE_LEG_ID, GEAR_ID) VALUES ((SELECT CRUISE_LEG_ID FROM CCD_CRUISE_LEGS WHERE LEG_NAME = 'OES0908_LEGI'), (SELECT GEAR_ID FROM CCD_GEAR WHERE GEAR_NAME = 'High-frequency Autonomous Acoustic Recording Package (HARP)'));
INSERT INTO CCD_LEG_GEAR (CRUISE_LEG_ID, GEAR_ID) VALUES ((SELECT CRUISE_LEG_ID FROM CCD_CRUISE_LEGS WHERE LEG_NAME = 'OES0908_LEGI'), (SELECT GEAR_ID FROM CCD_GEAR WHERE GEAR_NAME = 'Hook and Line'));
INSERT INTO CCD_LEG_GEAR (CRUISE_LEG_ID, GEAR_ID) VALUES ((SELECT CRUISE_LEG_ID FROM CCD_CRUISE_LEGS WHERE LEG_NAME = 'OES0908_LEGI'), (SELECT GEAR_ID FROM CCD_GEAR WHERE GEAR_NAME = 'Human Observation'));
INSERT INTO CCD_LEG_GEAR (CRUISE_LEG_ID, GEAR_ID) VALUES ((SELECT CRUISE_LEG_ID FROM CCD_CRUISE_LEGS WHERE LEG_NAME = 'OES0908_LEGII'), (SELECT GEAR_ID FROM CCD_GEAR WHERE GEAR_NAME = 'PIT Tags'));
INSERT INTO CCD_LEG_GEAR (CRUISE_LEG_ID, GEAR_ID) VALUES ((SELECT CRUISE_LEG_ID FROM CCD_CRUISE_LEGS WHERE LEG_NAME = 'OES0908_LEGII'), (SELECT GEAR_ID FROM CCD_GEAR WHERE GEAR_NAME = 'SCUBA'));
INSERT INTO CCD_LEG_GEAR (CRUISE_LEG_ID, GEAR_ID) VALUES ((SELECT CRUISE_LEG_ID FROM CCD_CRUISE_LEGS WHERE LEG_NAME = 'OES0908_LEGII'), (SELECT GEAR_ID FROM CCD_GEAR WHERE GEAR_NAME = 'Snorkel/Free Dive'));
INSERT INTO CCD_LEG_GEAR (CRUISE_LEG_ID, GEAR_ID) VALUES ((SELECT CRUISE_LEG_ID FROM CCD_CRUISE_LEGS WHERE LEG_NAME = 'OES0908_LEGII'), (SELECT GEAR_ID FROM CCD_GEAR WHERE GEAR_NAME = 'Tags (satellite, acoustic and others)'));
INSERT INTO CCD_LEG_GEAR (CRUISE_LEG_ID, GEAR_ID) VALUES ((SELECT CRUISE_LEG_ID FROM CCD_CRUISE_LEGS WHERE LEG_NAME = 'OES0908_LEGII'), (SELECT GEAR_ID FROM CCD_GEAR WHERE GEAR_NAME = 'Temperature Depth Recorders (TDRs)'));
INSERT INTO CCD_LEG_GEAR (CRUISE_LEG_ID, GEAR_ID) VALUES ((SELECT CRUISE_LEG_ID FROM CCD_CRUISE_LEGS WHERE LEG_NAME = 'OES0908_LEGII'), (SELECT GEAR_ID FROM CCD_GEAR WHERE GEAR_NAME = 'Towed Hydrophone Array'));
INSERT INTO CCD_LEG_GEAR (CRUISE_LEG_ID, GEAR_ID) VALUES ((SELECT CRUISE_LEG_ID FROM CCD_CRUISE_LEGS WHERE LEG_NAME = 'OES0908_LEGII'), (SELECT GEAR_ID FROM CCD_GEAR WHERE GEAR_NAME = 'Trawl'));
INSERT INTO CCD_LEG_GEAR (CRUISE_LEG_ID, GEAR_ID) VALUES ((SELECT CRUISE_LEG_ID FROM CCD_CRUISE_LEGS WHERE LEG_NAME = 'OES0908_LEGII'), (SELECT GEAR_ID FROM CCD_GEAR WHERE GEAR_NAME = 'Visual Census'));

INSERT INTO CCD_LEG_GEAR (CRUISE_LEG_ID, GEAR_ID) VALUES ((SELECT CRUISE_LEG_ID FROM CCD_CRUISE_LEGS WHERE LEG_NAME = 'RL-17-05 Leg 1'), (SELECT GEAR_ID FROM CCD_GEAR WHERE GEAR_NAME = 'High-frequency Autonomous Acoustic Recording Package (HARP)'));
INSERT INTO CCD_LEG_GEAR (CRUISE_LEG_ID, GEAR_ID) VALUES ((SELECT CRUISE_LEG_ID FROM CCD_CRUISE_LEGS WHERE LEG_NAME = 'RL-17-05 Leg 1'), (SELECT GEAR_ID FROM CCD_GEAR WHERE GEAR_NAME = 'Hook and Line'));
INSERT INTO CCD_LEG_GEAR (CRUISE_LEG_ID, GEAR_ID) VALUES ((SELECT CRUISE_LEG_ID FROM CCD_CRUISE_LEGS WHERE LEG_NAME = 'RL-17-05 Leg 1'), (SELECT GEAR_ID FROM CCD_GEAR WHERE GEAR_NAME = 'Human Observation'));
INSERT INTO CCD_LEG_GEAR (CRUISE_LEG_ID, GEAR_ID) VALUES ((SELECT CRUISE_LEG_ID FROM CCD_CRUISE_LEGS WHERE LEG_NAME = 'RL-17-05 Leg 1'), (SELECT GEAR_ID FROM CCD_GEAR WHERE GEAR_NAME = 'PIT Tags'));
INSERT INTO CCD_LEG_GEAR (CRUISE_LEG_ID, GEAR_ID) VALUES ((SELECT CRUISE_LEG_ID FROM CCD_CRUISE_LEGS WHERE LEG_NAME = 'RL-17-05 Leg 1'), (SELECT GEAR_ID FROM CCD_GEAR WHERE GEAR_NAME = 'SCUBA'));
INSERT INTO CCD_LEG_GEAR (CRUISE_LEG_ID, GEAR_ID) VALUES ((SELECT CRUISE_LEG_ID FROM CCD_CRUISE_LEGS WHERE LEG_NAME = 'RL-17-05 Leg 2'), (SELECT GEAR_ID FROM CCD_GEAR WHERE GEAR_NAME = 'Snorkel/Free Dive'));
INSERT INTO CCD_LEG_GEAR (CRUISE_LEG_ID, GEAR_ID) VALUES ((SELECT CRUISE_LEG_ID FROM CCD_CRUISE_LEGS WHERE LEG_NAME = 'RL-17-05 Leg 2'), (SELECT GEAR_ID FROM CCD_GEAR WHERE GEAR_NAME = 'SCUBA'));

--leg regions:
insert into ccd_leg_regions (REGION_ID, CRUISE_LEG_ID, LEG_REGION_NOTES) values ((SELECT region_id from ccd_regions where region_code = 'NWHI'), (SELECT cruise_leg_id from ccd_cruise_legs where leg_name = 'OES0908_LEGI'), '');
insert into ccd_leg_regions (REGION_ID, CRUISE_LEG_ID, LEG_REGION_NOTES) values ((SELECT region_id from ccd_regions where region_code = 'PRIA'), (SELECT cruise_leg_id from ccd_cruise_legs where leg_name = 'OES0908_LEGI'), '');
insert into ccd_leg_regions (REGION_ID, CRUISE_LEG_ID, LEG_REGION_NOTES) values ((SELECT region_id from ccd_regions where region_code = 'AMSM'), (SELECT cruise_leg_id from ccd_cruise_legs where leg_name = 'OES0908_LEGI'), '');
insert into ccd_leg_regions (REGION_ID, CRUISE_LEG_ID, LEG_REGION_NOTES) values ((SELECT region_id from ccd_regions where region_code = 'CNMI'), (SELECT cruise_leg_id from ccd_cruise_legs where leg_name = 'OES0908_LEGII'), '');
insert into ccd_leg_regions (REGION_ID, CRUISE_LEG_ID, LEG_REGION_NOTES) values ((SELECT region_id from ccd_regions where region_code = 'PRIA'), (SELECT cruise_leg_id from ccd_cruise_legs where leg_name = 'OES0908_LEGII'), '');
insert into ccd_leg_regions (REGION_ID, CRUISE_LEG_ID, LEG_REGION_NOTES) values ((SELECT region_id from ccd_regions where region_code = 'NPSF'), (SELECT cruise_leg_id from ccd_cruise_legs where leg_name = 'RL-17-05 Leg 1'), '');
insert into ccd_leg_regions (REGION_ID, CRUISE_LEG_ID, LEG_REGION_NOTES) values ((SELECT region_id from ccd_regions where region_code = 'PRIA'), (SELECT cruise_leg_id from ccd_cruise_legs where leg_name = 'RL-17-05 Leg 1'), '');
insert into ccd_leg_regions (REGION_ID, CRUISE_LEG_ID, LEG_REGION_NOTES) values ((SELECT region_id from ccd_regions where region_code = 'MHI'), (SELECT cruise_leg_id from ccd_cruise_legs where leg_name = 'RL-17-05 Leg 2'), '');
insert into ccd_leg_regions (REGION_ID, CRUISE_LEG_ID, LEG_REGION_NOTES) values ((SELECT region_id from ccd_regions where region_code = 'NWHI'), (SELECT cruise_leg_id from ccd_cruise_legs where leg_name = 'RL-17-05 Leg 2'), '');
insert into ccd_leg_regions (REGION_ID, CRUISE_LEG_ID, LEG_REGION_NOTES) values ((SELECT region_id from ccd_regions where region_code = 'PRIA'), (SELECT cruise_leg_id from ccd_cruise_legs where leg_name = 'RL-17-05 Leg 2'), '');
