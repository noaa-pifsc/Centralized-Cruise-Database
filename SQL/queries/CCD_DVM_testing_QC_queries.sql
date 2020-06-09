CREATE OR REPLACE VIEW

CCD_QC_CRUISE_SUPP_V

AS

SELECT
CRUISE_ID,
CRUISE_NAME,
FORMAT_CRUISE_START_DATE,
FORMAT_CRUISE_END_DATE,
NUM_LEGS,
(CASE WHEN NUM_LEGS <= 4 AND NUM_LEGS > 2 THEN 'Y' ELSE 'N' END) HIGH_LEG_COUNT_YN,
(CASE WHEN NUM_LEGS > 4 THEN 'Y' ELSE 'N' END) INVALID_LEG_COUNT_YN



FROM CCD_CRUISE_V
WHERE
(NUM_LEGS <= 4 AND NUM_LEGS > 2)
OR (NUM_LEGS > 4)
;


COMMENT ON COLUMN CCD_QC_CRUISE_SUPP_V.CRUISE_ID IS 'Primary key for the CCD_CRUISES table';
COMMENT ON COLUMN CCD_QC_CRUISE_SUPP_V.CRUISE_NAME IS 'The name of the given cruise designated by NOAA (e.g. SE-15-01)';
COMMENT ON COLUMN CCD_QC_CRUISE_SUPP_V.FORMAT_CRUISE_START_DATE IS 'The formatted start date for the given cruise (based on the earliest associated cruise leg''s start date) in MM/DD/YYYY format';
COMMENT ON COLUMN CCD_QC_CRUISE_SUPP_V.FORMAT_CRUISE_END_DATE IS 'The formatted end date for the given cruise (based on the latest associated cruise leg''s end date) in MM/DD/YYYY format';
COMMENT ON COLUMN CCD_QC_CRUISE_SUPP_V.NUM_LEGS IS 'The number of cruise legs associated with the given cruise';
COMMENT ON COLUMN CCD_QC_CRUISE_SUPP_V.HIGH_LEG_COUNT_YN IS 'Field to indicate if there is an unusually high number of cruise legs which is typically less than three (Y) or not (N)';
COMMENT ON COLUMN CCD_QC_CRUISE_SUPP_V.INVALID_LEG_COUNT_YN IS 'Field to indicate if there is an invalid number of cruise legs which should be four at the most (Y) or not (N)';






insert into DVM_DATA_STREAMS (DATA_STREAM_CODE, DATA_STREAM_NAME, DATA_STREAM_PAR_TABLE) VALUES ('CCD2', 'Centralized Cruise Database Data Stream Testing', 'CCD_CRUISES');
insert into DVM_QC_OBJECTS (OBJECT_NAME, QC_OBJ_ACTIVE_YN, QC_SORT_ORDER) VALUES ('CCD_QC_CRUISE_SUPP_V', 'Y', NULL);

INSERT INTO DVM_ISS_TYPES (ISS_TYPE_NAME, ISS_TYPE_COMMENT_TEMPLATE, QC_OBJECT_ID, IND_FIELD_NAME, ISS_SEVERITY_ID, DATA_STREAM_ID, ISS_TYPE_ACTIVE_YN, ISS_TYPE_DESC, APP_LINK_TEMPLATE) VALUES ('Unusually High Number of Cruise Legs', 'The Cruise ([CRUISE_NAME]) with Start Date ([FORMAT_CRUISE_START_DATE]) and End Date ([FORMAT_CRUISE_END_DATE]) has an unusually high number of cruise legs ([NUM_LEGS]), normally there should be less than three legs for a given cruise', (SELECT QC_OBJECT_ID FROM DVM_QC_OBJECTS WHERE OBJECT_NAME = 'CCD_QC_CRUISE_SUPP_V'), 'HIGH_LEG_COUNT_YN', (SELECT ISS_SEVERITY_ID FROM DVM_ISS_SEVERITY WHERE ISS_SEVERITY_CODE = 'WARN'), (SELECT data_stream_id from DVM_data_streams where data_stream_code = 'CCD2'), 'Y', 'The cruise has an unusually high ( > 2) number of associated legs', 'f?p=[APP_ID]:220:[APP_SESSION]::NO::P220_CRUISE_ID,P220_CRUISE_ID_COPY:[CRUISE_ID],');

INSERT INTO DVM_ISS_TYPES (ISS_TYPE_NAME, ISS_TYPE_COMMENT_TEMPLATE, QC_OBJECT_ID, IND_FIELD_NAME, ISS_SEVERITY_ID, DATA_STREAM_ID, ISS_TYPE_ACTIVE_YN, ISS_TYPE_DESC, APP_LINK_TEMPLATE) VALUES ('Invalid Number of Cruise Legs', 'The Cruise ([CRUISE_NAME]) with Start Date ([FORMAT_CRUISE_START_DATE]) and End Date ([FORMAT_CRUISE_END_DATE]) has an invalid number of cruise legs ([NUM_LEGS]), normally there should be no more than four legs', (SELECT QC_OBJECT_ID FROM DVM_QC_OBJECTS WHERE OBJECT_NAME = 'CCD_QC_CRUISE_SUPP_V'), 'INVALID_LEG_COUNT_YN', (SELECT ISS_SEVERITY_ID FROM DVM_ISS_SEVERITY WHERE ISS_SEVERITY_CODE = 'WARN'), (SELECT data_stream_id from DVM_data_streams where data_stream_code = 'CCD2'), 'Y', 'The cruise has an invalid number of associated legs ( > 4) ', 'f?p=[APP_ID]:220:[APP_SESSION]::NO::P220_CRUISE_ID,P220_CRUISE_ID_COPY:[CRUISE_ID],');
