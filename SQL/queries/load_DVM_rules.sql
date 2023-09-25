INSERT INTO DVM_DATA_STREAMS (DATA_STREAM_CODE, DATA_STREAM_NAME, DATA_STREAM_DESC, DATA_STREAM_PAR_TABLE)
VALUES ('CCD', 'CCD Data', 'Cruise data', 'CCD_CRUISES');



insert into DVM_QC_OBJECTS (OBJECT_NAME, QC_OBJ_ACTIVE_YN, QC_SORT_ORDER) VALUES ('CCD_QC_LEG_OVERLAP_V', 'Y', 20);

insert into DVM_QC_OBJECTS (OBJECT_NAME, QC_OBJ_ACTIVE_YN, QC_SORT_ORDER) VALUES ('CCD_QC_CRUISE_V', 'Y', 5);

insert into DVM_QC_OBJECTS (OBJECT_NAME, QC_OBJ_ACTIVE_YN, QC_SORT_ORDER) VALUES ('CCD_QC_LEG_V', 'Y', 10);

insert into DVM_QC_OBJECTS (OBJECT_NAME, QC_OBJ_ACTIVE_YN, QC_SORT_ORDER) VALUES ('CCD_QC_LEG_ALIAS_V', 'Y', 15);


INSERT INTO DVM_ISS_TYPES (ISS_TYPE_NAME, ISS_TYPE_COMMENT_TEMPLATE, QC_OBJECT_ID, IND_FIELD_NAME, ISS_SEVERITY_ID, DATA_STREAM_ID, ISS_TYPE_ACTIVE_YN, ISS_TYPE_DESC, APP_LINK_TEMPLATE) VALUES ('Invalid Copied Cruise Name', 'The Cruise ([CRUISE_NAME]) with Start Date ([FORMAT_CRUISE_START_DATE]) and End Date ([FORMAT_CRUISE_END_DATE]) has "(copy)" in the Cruise Name, this should be renamed', (SELECT QC_OBJECT_ID FROM DVM_QC_OBJECTS WHERE OBJECT_NAME = 'CCD_QC_CRUISE_V'), 'INV_CRUISE_NAME_COPY_YN', (SELECT ISS_SEVERITY_ID FROM DVM_ISS_SEVERITY WHERE ISS_SEVERITY_CODE = 'ERROR'), (SELECT data_stream_id from DVM_data_streams where data_stream_code = 'CCD'), 'Y', 'The Cruise Name contains "(copy)" which indicates it was created using the "Deep Copy" feature and should be renamed', 'f?p=[APP_ID]:220:[APP_SESSION]::NO::P220_CRUISE_ID,P220_CRUISE_ID_COPY:[CRUISE_ID],');
INSERT INTO DVM_ISS_TYPES (ISS_TYPE_NAME, ISS_TYPE_COMMENT_TEMPLATE, QC_OBJECT_ID, IND_FIELD_NAME, ISS_SEVERITY_ID, DATA_STREAM_ID, ISS_TYPE_ACTIVE_YN, ISS_TYPE_DESC, APP_LINK_TEMPLATE) VALUES ('Invalid Cruise Days at Sea', 'The Cruise ([CRUISE_NAME]) with Start Date ([FORMAT_CRUISE_START_DATE]) and End Date ([FORMAT_CRUISE_END_DATE]) and number of Legs ([NUM_LEGS]) has an invalid number ( > 240) of Days at Sea ([CRUISE_DAS])', (SELECT QC_OBJECT_ID FROM DVM_QC_OBJECTS WHERE OBJECT_NAME = 'CCD_QC_CRUISE_V'), 'ERR_CRUISE_DAS_YN', (SELECT ISS_SEVERITY_ID FROM DVM_ISS_SEVERITY WHERE ISS_SEVERITY_CODE = 'ERROR'), (SELECT data_stream_id from DVM_data_streams where data_stream_code = 'CCD'), 'Y', 'Cruise is too long (DAS based on start and end dates) > 240 days', 'f?p=[APP_ID]:220:[APP_SESSION]::NO::P220_CRUISE_ID,P220_CRUISE_ID_COPY:[CRUISE_ID],');
INSERT INTO DVM_ISS_TYPES (ISS_TYPE_NAME, ISS_TYPE_COMMENT_TEMPLATE, QC_OBJECT_ID, IND_FIELD_NAME, ISS_SEVERITY_ID, DATA_STREAM_ID, ISS_TYPE_ACTIVE_YN, ISS_TYPE_DESC, APP_LINK_TEMPLATE) VALUES ('Invalid Cruise Length', 'The Cruise ([CRUISE_NAME]) with Start Date ([FORMAT_CRUISE_START_DATE]) and End Date ([FORMAT_CRUISE_END_DATE]) and number of Legs ([NUM_LEGS]) has an invalid length ( > 280) days based on the date range ([CRUISE_LEN_DAYS] days) ', (SELECT QC_OBJECT_ID FROM DVM_QC_OBJECTS WHERE OBJECT_NAME = 'CCD_QC_CRUISE_V'), 'ERR_CRUISE_DATE_RNG_YN', (SELECT ISS_SEVERITY_ID FROM DVM_ISS_SEVERITY WHERE ISS_SEVERITY_CODE = 'ERROR'), (SELECT data_stream_id from DVM_data_streams where data_stream_code = 'CCD'), 'Y', 'Cruise is too long (based on the cruise start and end dates even if the leg DAS is not over the threshold) > 280 days', 'f?p=[APP_ID]:220:[APP_SESSION]::NO::P220_CRUISE_ID,P220_CRUISE_ID_COPY:[CRUISE_ID],');
INSERT INTO DVM_ISS_TYPES (ISS_TYPE_NAME, ISS_TYPE_COMMENT_TEMPLATE, QC_OBJECT_ID, IND_FIELD_NAME, ISS_SEVERITY_ID, DATA_STREAM_ID, ISS_TYPE_ACTIVE_YN, ISS_TYPE_DESC, APP_LINK_TEMPLATE) VALUES ('Invalid Cruise Name', 'The Cruise ([CRUISE_NAME]) with Start Date ([FORMAT_CRUISE_START_DATE]) and End Date ([FORMAT_CRUISE_END_DATE]) has an invalid Cruise Name based on the required naming convention: {SN}-{YR}-{##} where {SN} is a valid abbreviation for a NOAA ship name, {YR} is a two digit year with a leading zero, and {##} is a sequential number with a leading zero', (SELECT QC_OBJECT_ID FROM DVM_QC_OBJECTS WHERE OBJECT_NAME = 'CCD_QC_CRUISE_V'), 'INV_CRUISE_NAME_YN', (SELECT ISS_SEVERITY_ID FROM DVM_ISS_SEVERITY WHERE ISS_SEVERITY_CODE = 'ERROR'), (SELECT data_stream_id from DVM_data_streams where data_stream_code = 'CCD'), 'Y', 'The cruise name does not follow the naming convention {SN}-{YR}-{##} where {SN} is a valid abbreviation for a NOAA ship name, {YR} is a two digit year with a leading zero, and {##} is a sequential number with a leading zero', 'f?p=[APP_ID]:220:[APP_SESSION]::NO::P220_CRUISE_ID,P220_CRUISE_ID_COPY:[CRUISE_ID],');
INSERT INTO DVM_ISS_TYPES (ISS_TYPE_NAME, ISS_TYPE_COMMENT_TEMPLATE, QC_OBJECT_ID, IND_FIELD_NAME, ISS_SEVERITY_ID, DATA_STREAM_ID, ISS_TYPE_ACTIVE_YN, ISS_TYPE_DESC, APP_LINK_TEMPLATE) VALUES ('Mismatched Cruise Name and Fiscal Year', 'The Cruise ([CRUISE_NAME]) with Start Date ([FORMAT_CRUISE_START_DATE]) and End Date ([FORMAT_CRUISE_END_DATE]) has a valid Cruise Name based on the required naming convention ({SN}-{YR}-{##}) but the extracted {YR} value ([CRUISE_NAME_FY]) does not match the truncated Cruise''s Fiscal Year value ([CRUISE_FISC_YEAR_TRUNC])', (SELECT QC_OBJECT_ID FROM DVM_QC_OBJECTS WHERE OBJECT_NAME = 'CCD_QC_CRUISE_V'), 'INV_CRUISE_NAME_FY_YN', (SELECT ISS_SEVERITY_ID FROM DVM_ISS_SEVERITY WHERE ISS_SEVERITY_CODE = 'ERROR'), (SELECT data_stream_id from DVM_data_streams where data_stream_code = 'CCD'), 'Y', 'The cruise name follows the naming convention {SN}-{YR}-{##} but {YR} does not match the Cruise Fiscal Year based on the first leg''s start date', 'f?p=[APP_ID]:220:[APP_SESSION]::NO::P220_CRUISE_ID,P220_CRUISE_ID_COPY:[CRUISE_ID],');
INSERT INTO DVM_ISS_TYPES (ISS_TYPE_NAME, ISS_TYPE_COMMENT_TEMPLATE, QC_OBJECT_ID, IND_FIELD_NAME, ISS_SEVERITY_ID, DATA_STREAM_ID, ISS_TYPE_ACTIVE_YN, ISS_TYPE_DESC, APP_LINK_TEMPLATE) VALUES ('Missing Cruise Primary Survey Category', 'The Cruise ([CRUISE_NAME]) with Start Date ([FORMAT_CRUISE_START_DATE]) and End Date ([FORMAT_CRUISE_END_DATE]) and number of Legs ([NUM_LEGS]) does not have at least one Primary Survey Category defined for it', (SELECT QC_OBJECT_ID FROM DVM_QC_OBJECTS WHERE OBJECT_NAME = 'CCD_QC_CRUISE_V'), 'MISS_PRIM_SVY_CAT_YN', (SELECT ISS_SEVERITY_ID FROM DVM_ISS_SEVERITY WHERE ISS_SEVERITY_CODE = 'WARN'), (SELECT data_stream_id from DVM_data_streams where data_stream_code = 'CCD'), 'Y', 'The Cruise does not have a Primary Survey Category defined for it', 'f?p=[APP_ID]:220:[APP_SESSION]::NO::P220_CRUISE_ID,P220_CRUISE_ID_COPY:[CRUISE_ID],');
INSERT INTO DVM_ISS_TYPES (ISS_TYPE_NAME, ISS_TYPE_COMMENT_TEMPLATE, QC_OBJECT_ID, IND_FIELD_NAME, ISS_SEVERITY_ID, DATA_STREAM_ID, ISS_TYPE_ACTIVE_YN, ISS_TYPE_DESC, APP_LINK_TEMPLATE) VALUES ('Missing Standard Survey Name', 'The Cruise ([CRUISE_NAME]) with Start Date ([FORMAT_CRUISE_START_DATE]) and End Date ([FORMAT_CRUISE_END_DATE]) does not have a Standard Survey Name defined for it', (SELECT QC_OBJECT_ID FROM DVM_QC_OBJECTS WHERE OBJECT_NAME = 'CCD_QC_CRUISE_V'), 'MISS_STD_SVY_NAME_YN', (SELECT ISS_SEVERITY_ID FROM DVM_ISS_SEVERITY WHERE ISS_SEVERITY_CODE = 'ERROR'), (SELECT data_stream_id from DVM_data_streams where data_stream_code = 'CCD'), 'Y', 'Both the Cruise Standard Survey Name fields were not populated, one or the other must be specified', 'f?p=[APP_ID]:220:[APP_SESSION]::NO::P220_CRUISE_ID,P220_CRUISE_ID_COPY:[CRUISE_ID],');
INSERT INTO DVM_ISS_TYPES (ISS_TYPE_NAME, ISS_TYPE_COMMENT_TEMPLATE, QC_OBJECT_ID, IND_FIELD_NAME, ISS_SEVERITY_ID, DATA_STREAM_ID, ISS_TYPE_ACTIVE_YN, ISS_TYPE_DESC, APP_LINK_TEMPLATE) VALUES ('Unusually High Cruise Days at Sea', 'The Cruise ([CRUISE_NAME]) with Start Date ([FORMAT_CRUISE_START_DATE]) and End Date ([FORMAT_CRUISE_END_DATE]) and number of Legs ([NUM_LEGS]) has an unusually high number ( > 120) of Days at Sea ([CRUISE_DAS])', (SELECT QC_OBJECT_ID FROM DVM_QC_OBJECTS WHERE OBJECT_NAME = 'CCD_QC_CRUISE_V'), 'WARN_CRUISE_DAS_YN', (SELECT ISS_SEVERITY_ID FROM DVM_ISS_SEVERITY WHERE ISS_SEVERITY_CODE = 'WARN'), (SELECT data_stream_id from DVM_data_streams where data_stream_code = 'CCD'), 'Y', 'Cruise is too long (DAS based on start and end dates) > 120 days', 'f?p=[APP_ID]:220:[APP_SESSION]::NO::P220_CRUISE_ID,P220_CRUISE_ID_COPY:[CRUISE_ID],');
INSERT INTO DVM_ISS_TYPES (ISS_TYPE_NAME, ISS_TYPE_COMMENT_TEMPLATE, QC_OBJECT_ID, IND_FIELD_NAME, ISS_SEVERITY_ID, DATA_STREAM_ID, ISS_TYPE_ACTIVE_YN, ISS_TYPE_DESC, APP_LINK_TEMPLATE) VALUES ('Unusually High Cruise Length', 'The Cruise ([CRUISE_NAME]) with Start Date ([FORMAT_CRUISE_START_DATE]) and End Date ([FORMAT_CRUISE_END_DATE]) and number of Legs ([NUM_LEGS]) is unusually long ( > 160) days based on the date range ([CRUISE_LEN_DAYS] days) ', (SELECT QC_OBJECT_ID FROM DVM_QC_OBJECTS WHERE OBJECT_NAME = 'CCD_QC_CRUISE_V'), 'WARN_CRUISE_DATE_RNG_YN', (SELECT ISS_SEVERITY_ID FROM DVM_ISS_SEVERITY WHERE ISS_SEVERITY_CODE = 'WARN'), (SELECT data_stream_id from DVM_data_streams where data_stream_code = 'CCD'), 'Y', 'Cruise is too long (based on the cruise start and end dates even if the leg DAS is not over the threshold) > 160 days', 'f?p=[APP_ID]:220:[APP_SESSION]::NO::P220_CRUISE_ID,P220_CRUISE_ID_COPY:[CRUISE_ID],');
INSERT INTO DVM_ISS_TYPES (ISS_TYPE_NAME, ISS_TYPE_COMMENT_TEMPLATE, QC_OBJECT_ID, IND_FIELD_NAME, ISS_SEVERITY_ID, DATA_STREAM_ID, ISS_TYPE_ACTIVE_YN, ISS_TYPE_DESC, APP_LINK_TEMPLATE) VALUES ('Invalid Copied Leg Alias Name', 'The Cruise ([CRUISE_NAME]) has a Cruise Leg ([LEG_NAME]) on the Vessel ([VESSEL_NAME]) with Start Date ([FORMAT_LEG_START_DATE]) and End Date ([FORMAT_LEG_END_DATE]) that has a Leg alias name ([LEG_ALIAS_NAME]) that contains "(copy)", this should be renamed', (SELECT QC_OBJECT_ID FROM DVM_QC_OBJECTS WHERE OBJECT_NAME = 'CCD_QC_LEG_ALIAS_V'), 'INV_LEG_ALIAS_COPY_YN', (SELECT ISS_SEVERITY_ID FROM DVM_ISS_SEVERITY WHERE ISS_SEVERITY_CODE = 'ERROR'), (SELECT data_stream_id from DVM_data_streams where data_stream_code = 'CCD'), 'Y', 'The Leg Alias Name contains "(copy)" which indicates it was created using the "Deep Copy" feature and should be renamed', 'f?p=[APP_ID]:230:[APP_SESSION]::NO::P230_CRUISE_LEG_ID,P230_CRUISE_LEG_ID_COPY,P230_CRUISE_ID:[CRUISE_LEG_ID],,[CRUISE_ID]');
INSERT INTO DVM_ISS_TYPES (ISS_TYPE_NAME, ISS_TYPE_COMMENT_TEMPLATE, QC_OBJECT_ID, IND_FIELD_NAME, ISS_SEVERITY_ID, DATA_STREAM_ID, ISS_TYPE_ACTIVE_YN, ISS_TYPE_DESC, APP_LINK_TEMPLATE) VALUES ('Cruise Leg Overlap', 'There are two legs for the same Cruise ([CRUISE_NAME1]) whose leg dates overlap; Cruise Leg 1: (Leg Name: [LEG_NAME1], Vessel: [VESSEL_NAME1], Start Date: [FORMAT_LEG_START_DATE1], End Date: [FORMAT_LEG_END_DATE1]), Leg 2: (Leg Name: [LEG_NAME2], Vessel: [VESSEL_NAME2], Start Date: [FORMAT_LEG_START_DATE2], End Date: [FORMAT_LEG_END_DATE2])', (SELECT QC_OBJECT_ID FROM DVM_QC_OBJECTS WHERE OBJECT_NAME = 'CCD_QC_LEG_OVERLAP_V'), 'CRUISE_OVERLAP_YN', (SELECT ISS_SEVERITY_ID FROM DVM_ISS_SEVERITY WHERE ISS_SEVERITY_CODE = 'ERROR'), (SELECT data_stream_id from DVM_data_streams where data_stream_code = 'CCD'), 'Y', 'Two cruise legs that are associated with the same cruise have overlapping start/end dates, two legs for the same cruise cannot occur concurrently', 'f?p=[APP_ID]:230:[APP_SESSION]::NO::P230_CRUISE_LEG_ID,P230_CRUISE_LEG_ID_COPY,P230_CRUISE_ID:[CRUISE_LEG_ID1],,[CRUISE_ID]');
INSERT INTO DVM_ISS_TYPES (ISS_TYPE_NAME, ISS_TYPE_COMMENT_TEMPLATE, QC_OBJECT_ID, IND_FIELD_NAME, ISS_SEVERITY_ID, DATA_STREAM_ID, ISS_TYPE_ACTIVE_YN, ISS_TYPE_DESC, APP_LINK_TEMPLATE) VALUES ('Vessel Leg Overlap', 'There are two legs for the same Vessel ([VESSEL_NAME1]) whose leg dates overlap; Leg 1: (Cruise: [CRUISE_NAME1], Leg Name: [LEG_NAME1], Start Date: [FORMAT_LEG_START_DATE1], End Date: [FORMAT_LEG_END_DATE1]), Leg 2: (Cruise: [CRUISE_NAME2], Leg Name: [LEG_NAME2], Start Date: [FORMAT_LEG_START_DATE2], End Date: [FORMAT_LEG_END_DATE2])', (SELECT QC_OBJECT_ID FROM DVM_QC_OBJECTS WHERE OBJECT_NAME = 'CCD_QC_LEG_OVERLAP_V'), 'VESSEL_OVERLAP_YN', (SELECT ISS_SEVERITY_ID FROM DVM_ISS_SEVERITY WHERE ISS_SEVERITY_CODE = 'ERROR'), (SELECT data_stream_id from DVM_data_streams where data_stream_code = 'CCD'), 'Y', 'Two cruise legs that are associated with the same vessel have overlapping start/end dates, two legs for the same vessel cannot occur concurrently', 'f?p=[APP_ID]:230:[APP_SESSION]::NO::P230_CRUISE_LEG_ID,P230_CRUISE_LEG_ID_COPY,P230_CRUISE_ID:[CRUISE_LEG_ID1],,[CRUISE_ID]');
INSERT INTO DVM_ISS_TYPES (ISS_TYPE_NAME, ISS_TYPE_COMMENT_TEMPLATE, QC_OBJECT_ID, IND_FIELD_NAME, ISS_SEVERITY_ID, DATA_STREAM_ID, ISS_TYPE_ACTIVE_YN, ISS_TYPE_DESC, APP_LINK_TEMPLATE) VALUES ('Invalid Copied Leg Name', 'The Cruise ([CRUISE_NAME]) has a Cruise Leg ([LEG_NAME]) on the Vessel ([VESSEL_NAME]) with Start Date ([FORMAT_LEG_START_DATE]) and End Date ([FORMAT_LEG_END_DATE]) that has "(copy)" in the Leg Name, this should be renamed', (SELECT QC_OBJECT_ID FROM DVM_QC_OBJECTS WHERE OBJECT_NAME = 'CCD_QC_LEG_V'), 'INV_LEG_NAME_COPY_YN', (SELECT ISS_SEVERITY_ID FROM DVM_ISS_SEVERITY WHERE ISS_SEVERITY_CODE = 'ERROR'), (SELECT data_stream_id from DVM_data_streams where data_stream_code = 'CCD'), 'Y', 'The Leg Name contains "(copy)" which indicates it was created using the "Deep Copy" feature and should be renamed', 'f?p=[APP_ID]:230:[APP_SESSION]::NO::P230_CRUISE_LEG_ID,P230_CRUISE_LEG_ID_COPY,P230_CRUISE_ID:[CRUISE_LEG_ID],,[CRUISE_ID]');
INSERT INTO DVM_ISS_TYPES (ISS_TYPE_NAME, ISS_TYPE_COMMENT_TEMPLATE, QC_OBJECT_ID, IND_FIELD_NAME, ISS_SEVERITY_ID, DATA_STREAM_ID, ISS_TYPE_ACTIVE_YN, ISS_TYPE_DESC, APP_LINK_TEMPLATE) VALUES ('Invalid Leg Dates', 'The Cruise ([CRUISE_NAME]) has a Cruise Leg ([LEG_NAME]) on the Vessel ([VESSEL_NAME]) with a Start Date ([FORMAT_LEG_START_DATE]) and End Date ([FORMAT_LEG_END_DATE]) that are invalid, the Start Date occurs after the End Date', (SELECT QC_OBJECT_ID FROM DVM_QC_OBJECTS WHERE OBJECT_NAME = 'CCD_QC_LEG_V'), 'INV_LEG_DATES_YN', (SELECT ISS_SEVERITY_ID FROM DVM_ISS_SEVERITY WHERE ISS_SEVERITY_CODE = 'ERROR'), (SELECT data_stream_id from DVM_data_streams where data_stream_code = 'CCD'), 'Y', 'The Leg''s Start Date occurs after the End Date', 'f?p=[APP_ID]:230:[APP_SESSION]::NO::P230_CRUISE_LEG_ID,P230_CRUISE_LEG_ID_COPY,P230_CRUISE_ID:[CRUISE_LEG_ID],,[CRUISE_ID]');
INSERT INTO DVM_ISS_TYPES (ISS_TYPE_NAME, ISS_TYPE_COMMENT_TEMPLATE, QC_OBJECT_ID, IND_FIELD_NAME, ISS_SEVERITY_ID, DATA_STREAM_ID, ISS_TYPE_ACTIVE_YN, ISS_TYPE_DESC, APP_LINK_TEMPLATE) VALUES ('Invalid Leg Days at Sea', 'The Cruise ([CRUISE_NAME]) has a Cruise Leg ([LEG_NAME]) on the Vessel ([VESSEL_NAME]) with a Start Date ([FORMAT_LEG_START_DATE]) and End Date ([FORMAT_LEG_END_DATE]) that has an invalid number ( > 90) of Days at Sea ([LEG_DAS])', (SELECT QC_OBJECT_ID FROM DVM_QC_OBJECTS WHERE OBJECT_NAME = 'CCD_QC_LEG_V'), 'ERR_LEG_DAS_YN', (SELECT ISS_SEVERITY_ID FROM DVM_ISS_SEVERITY WHERE ISS_SEVERITY_CODE = 'ERROR'), (SELECT data_stream_id from DVM_data_streams where data_stream_code = 'CCD'), 'Y', 'Leg is too long (DAS based on start and end dates) > 90 days', 'f?p=[APP_ID]:230:[APP_SESSION]::NO::P230_CRUISE_LEG_ID,P230_CRUISE_LEG_ID_COPY,P230_CRUISE_ID:[CRUISE_LEG_ID],,[CRUISE_ID]');
INSERT INTO DVM_ISS_TYPES (ISS_TYPE_NAME, ISS_TYPE_COMMENT_TEMPLATE, QC_OBJECT_ID, IND_FIELD_NAME, ISS_SEVERITY_ID, DATA_STREAM_ID, ISS_TYPE_ACTIVE_YN, ISS_TYPE_DESC, APP_LINK_TEMPLATE) VALUES ('Missing Leg Gear', 'The Cruise ([CRUISE_NAME]) has a Cruise Leg ([LEG_NAME]) on the Vessel ([VESSEL_NAME]) with a Start Date ([FORMAT_LEG_START_DATE]) and End Date ([FORMAT_LEG_END_DATE]) that does not have at least one type of Gear defined for it', (SELECT QC_OBJECT_ID FROM DVM_QC_OBJECTS WHERE OBJECT_NAME = 'CCD_QC_LEG_V'), 'MISS_GEAR_YN', (SELECT ISS_SEVERITY_ID FROM DVM_ISS_SEVERITY WHERE ISS_SEVERITY_CODE = 'WARN'), (SELECT data_stream_id from DVM_data_streams where data_stream_code = 'CCD'), 'Y', 'The Leg does not have any gear defined for it', 'f?p=[APP_ID]:230:[APP_SESSION]::NO::P230_CRUISE_LEG_ID,P230_CRUISE_LEG_ID_COPY,P230_CRUISE_ID:[CRUISE_LEG_ID],,[CRUISE_ID]');
INSERT INTO DVM_ISS_TYPES (ISS_TYPE_NAME, ISS_TYPE_COMMENT_TEMPLATE, QC_OBJECT_ID, IND_FIELD_NAME, ISS_SEVERITY_ID, DATA_STREAM_ID, ISS_TYPE_ACTIVE_YN, ISS_TYPE_DESC, APP_LINK_TEMPLATE) VALUES ('Unusually High Leg Days at Sea', 'The Cruise ([CRUISE_NAME]) has a Cruise Leg ([LEG_NAME]) on the Vessel ([VESSEL_NAME]) with a Start Date ([FORMAT_LEG_START_DATE]) and End Date ([FORMAT_LEG_END_DATE]) that has an unusually high number ( > 30) of Days at Sea ([LEG_DAS])', (SELECT QC_OBJECT_ID FROM DVM_QC_OBJECTS WHERE OBJECT_NAME = 'CCD_QC_LEG_V'), 'WARN_LEG_DAS_YN', (SELECT ISS_SEVERITY_ID FROM DVM_ISS_SEVERITY WHERE ISS_SEVERITY_CODE = 'WARN'), (SELECT data_stream_id from DVM_data_streams where data_stream_code = 'CCD'), 'Y', 'Leg is too long (DAS based on start and end dates) > 30 days', 'f?p=[APP_ID]:230:[APP_SESSION]::NO::P230_CRUISE_LEG_ID,P230_CRUISE_LEG_ID_COPY,P230_CRUISE_ID:[CRUISE_LEG_ID],,[CRUISE_ID]');
INSERT INTO DVM_ISS_TYPES (ISS_TYPE_NAME, ISS_TYPE_COMMENT_TEMPLATE, QC_OBJECT_ID, IND_FIELD_NAME, ISS_SEVERITY_ID, DATA_STREAM_ID, ISS_TYPE_ACTIVE_YN, ISS_TYPE_DESC, APP_LINK_TEMPLATE) VALUES ('Missing Leg Data Set', 'The Cruise ([CRUISE_NAME]) has a Cruise Leg ([LEG_NAME]) on the Vessel ([VESSEL_NAME]) with a Start Date ([FORMAT_LEG_START_DATE]) and End Date ([FORMAT_LEG_END_DATE]) that does not have at least one data set associated with it', (SELECT QC_OBJECT_ID FROM DVM_QC_OBJECTS WHERE OBJECT_NAME = 'CCD_QC_LEG_V'), 'MISS_DATA_SET_YN', (SELECT ISS_SEVERITY_ID FROM DVM_ISS_SEVERITY WHERE ISS_SEVERITY_CODE = 'WARN'), (SELECT data_stream_id from DVM_data_streams where data_stream_code = 'CCD'), 'Y', 'The Leg does not have any data sets defined for it', 'f?p=[APP_ID]:230:[APP_SESSION]::NO::P230_CRUISE_LEG_ID,P230_CRUISE_LEG_ID_COPY,P230_CRUISE_ID:[CRUISE_LEG_ID],,[CRUISE_ID]');

/*
delete from dvm_error_types;
delete from dvm_qc_objects;
delete from DVM_data_streams;
*/
