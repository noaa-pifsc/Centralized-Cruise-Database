/*
 delete from ccd_data_sets;
 delete from ccd_data_set_types;
 delete from ccd_data_set_status;




 **/



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



insert into ccd_data_set_status (STATUS_CODE, STATUS_NAME, STATUS_DESC, STATUS_COLOR) values ('COL', 'Data Collection', 'Data is being collected', '#e76e3c');
insert into ccd_data_set_status (STATUS_CODE, STATUS_NAME, STATUS_DESC, STATUS_COLOR) values ('PR', 'Data Processing', 'Data has been collected and the data is currently being processed', '#4b6a88');
insert into ccd_data_set_status (STATUS_CODE, STATUS_NAME, STATUS_DESC, STATUS_COLOR) values ('QC', 'Quality Control', 'Data has been processed and data quality control is currently being evaluated and issues are being resolved and/or annotated', '#0000e0');
insert into ccd_data_set_status (STATUS_CODE, STATUS_NAME, STATUS_DESC, STATUS_COLOR) values ('IA', 'Internally Accessible', 'Data has been quality controlled and it is currently internally accessible', '#1e90ff');
insert into ccd_data_set_status (STATUS_CODE, STATUS_NAME, STATUS_DESC, STATUS_COLOR) values ('PA', 'Publicly Accessible', 'Data has been quality controlled and it is currently publicly accessible', '#005555');
insert into ccd_data_set_status (STATUS_CODE, STATUS_NAME, STATUS_DESC, STATUS_COLOR) values ('ARCH', 'Archived', 'Data has been quality controlled and it is currently archived', '#00aa00');


insert into ccd_data_sets (DATA_SET_DESC, DATA_SET_TYPE_ID, DATA_SET_INPORT_CAT_ID, DATA_SET_STATUS_ID) values ('2017 Spring MOUSS Data Set', (SELECT DATA_SET_TYPE_ID FROM CCD_DATA_SET_TYPES WHERE DATA_SET_TYPE_NAME = 'MOUSS Video'), '51818', (SELECT DATA_SET_STATUS_ID FROM CCD_DATA_SET_STATUS where status_code = 'QC'));
insert into ccd_data_sets (DATA_SET_DESC, DATA_SET_TYPE_ID, DATA_SET_INPORT_CAT_ID, DATA_SET_STATUS_ID) values ('2017 Fall MOUSS Data Set', (SELECT DATA_SET_TYPE_ID FROM CCD_DATA_SET_TYPES WHERE DATA_SET_TYPE_NAME = 'MOUSS Video'), '65049', (SELECT DATA_SET_STATUS_ID FROM CCD_DATA_SET_STATUS where status_code = 'IA'));
insert into ccd_data_sets (DATA_SET_DESC, DATA_SET_TYPE_ID, DATA_SET_INPORT_CAT_ID, DATA_SET_STATUS_ID) values ('', (SELECT DATA_SET_TYPE_ID FROM CCD_DATA_SET_TYPES WHERE DATA_SET_TYPE_NAME = 'CTD'), '7602', (SELECT DATA_SET_STATUS_ID FROM CCD_DATA_SET_STATUS where status_code = 'PA'));
insert into ccd_data_sets (DATA_SET_DESC, DATA_SET_TYPE_ID, DATA_SET_INPORT_CAT_ID, DATA_SET_STATUS_ID) values ('', (SELECT DATA_SET_TYPE_ID FROM CCD_DATA_SET_TYPES WHERE DATA_SET_TYPE_NAME = 'Water Samples'), '25860', (SELECT DATA_SET_STATUS_ID FROM CCD_DATA_SET_STATUS where status_code = 'QC'));
insert into ccd_data_sets (DATA_SET_DESC, DATA_SET_TYPE_ID, DATA_SET_INPORT_CAT_ID, DATA_SET_STATUS_ID) values ('', (SELECT DATA_SET_TYPE_ID FROM CCD_DATA_SET_TYPES WHERE DATA_SET_TYPE_NAME = 'Midwater Trawling'), '', (SELECT DATA_SET_STATUS_ID FROM CCD_DATA_SET_STATUS where status_code = 'IA'));
insert into ccd_data_sets (DATA_SET_DESC, DATA_SET_TYPE_ID, DATA_SET_INPORT_CAT_ID, DATA_SET_STATUS_ID) values ('', (SELECT DATA_SET_TYPE_ID FROM CCD_DATA_SET_TYPES WHERE DATA_SET_TYPE_NAME = 'Active Acoustics'), '2711', (SELECT DATA_SET_STATUS_ID FROM CCD_DATA_SET_STATUS where status_code = 'PA'));
insert into ccd_data_sets (DATA_SET_DESC, DATA_SET_TYPE_ID, DATA_SET_INPORT_CAT_ID, DATA_SET_STATUS_ID) values ('2018 MOUSS Data Set', (SELECT DATA_SET_TYPE_ID FROM CCD_DATA_SET_TYPES WHERE DATA_SET_TYPE_NAME = 'MOUSS Video'), '', (SELECT DATA_SET_STATUS_ID FROM CCD_DATA_SET_STATUS where status_code = 'COL'));
insert into ccd_data_sets (DATA_SET_DESC, DATA_SET_TYPE_ID, DATA_SET_INPORT_CAT_ID, DATA_SET_STATUS_ID) values ('2019 MOUSS Data Set, using the parent project folder CAT_ID temporarily until the InPort metadata record is created', (SELECT DATA_SET_TYPE_ID FROM CCD_DATA_SET_TYPES WHERE DATA_SET_TYPE_NAME = 'MOUSS Video'), '65046', (SELECT DATA_SET_STATUS_ID FROM CCD_DATA_SET_STATUS where status_code = 'QC'));

