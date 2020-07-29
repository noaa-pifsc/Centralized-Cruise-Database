/********************************************/
--Revert queries from category 7 part 1:
/********************************************/

--revert the primary key query:
ALTER TABLE DVM_ISS_TYP_ASSOC
ADD CONSTRAINT DVM_ISS_TYP_ASSOC_PK PRIMARY KEY
(
  ISS_TYP_ASSOC_ID
)
ENABLE;


--remove the compound primary key from DVM_ISSUES_HIST:
ALTER TABLE DVM_ISSUES_HIST
DROP CONSTRAINT DVM_ISSUES_HIST_PK;

ALTER TABLE DVM_ISSUES_HIST
MODIFY (H_SEQNUM NULL);

ALTER TABLE DVM_ISSUES_HIST
MODIFY (H_TYPE_OF_CHANGE NULL);



--remove the compound primary key from DVM_ISS_SEVERITY_HIST:

ALTER TABLE DVM_ISS_SEVERITY_HIST
DROP CONSTRAINT DVM_ISS_SEVERITY_HIST_PK;

ALTER TABLE DVM_ISS_SEVERITY_HIST
MODIFY (H_SEQNUM NULL);

ALTER TABLE DVM_ISS_SEVERITY_HIST
MODIFY (ISS_SEVERITY_ID NULL);



--update the data stream to the original parent table
UPDATE DVM_DATA_STREAMS SET DATA_STREAM_PAR_TABLE = 'CCD_CRUISES' WHERE DATA_STREAM_CODE = 'CCD_TEST2';

--update the data stream to the original parent table
UPDATE DVM_DATA_STREAMS SET DATA_STREAM_PAR_TABLE = 'CCD_CRUISES' WHERE DATA_STREAM_CODE = 'CCD_TEST';

	--remove the test data stream
	DELETE FROM DVM_DATA_STREAMS WHERE DATA_STREAM_CODE = 'CCD_TEST3';

	--remove the test data stream
	DELETE FROM DVM_DATA_STREAMS WHERE DATA_STREAM_CODE = 'CCD_TEST4';


	--remove the test data stream
	DELETE FROM DVM_DATA_STREAMS WHERE DATA_STREAM_CODE = 'CCD_TEST5';

	--revert the issue type's comment template :
	UPDATE DVM_ISS_TYPES SET APP_LINK_TEMPLATE = REPLACE(APP_LINK_TEMPLATE, '[CRUISE_ID][ABC][DEF]', '[CRUISE_ID]') WHERE IND_FIELD_NAME = 'INV_CRUISE_NAME_YN';



	--revert the issue type's comment template :
	UPDATE DVM_ISS_TYPES SET APP_LINK_TEMPLATE = REPLACE(APP_LINK_TEMPLATE, '[CRUISE_LEG_ID1][GHI][JKL]', '[CRUISE_LEG_ID1]') WHERE IND_FIELD_NAME = 'VESSEL_OVERLAP_YN';

	--revert the issue type's comment template :
	UPDATE DVM_ISS_TYPES SET ISS_TYPE_COMMENT_TEMPLATE = REPLACE(ISS_TYPE_COMMENT_TEMPLATE, '[CRUISE_NAME][ABC][DEF]', '[CRUISE_NAME]') WHERE IND_FIELD_NAME = 'INV_CRUISE_NAME_YN';


	--revert the issue type's comment template :
	UPDATE DVM_ISS_TYPES SET ISS_TYPE_COMMENT_TEMPLATE = REPLACE(ISS_TYPE_COMMENT_TEMPLATE, '[CRUISE_NAME1][XYZ]', '[CRUISE_NAME1]') WHERE IND_FIELD_NAME = 'VESSEL_OVERLAP_YN';

	--remove the duplicate active rule set:
	DELETE FROM DVM_RULE_SETS WHERE RULE_SET_CREATE_DATE = (SELECT MAX(RULE_SET_CREATE_DATE) FROM DVM_RULE_SETS WHERE RULE_SET_ACTIVE_YN = 'Y');

	--re-enable all QC object validation rules:
	UPDATE DVM_QC_OBJECTS SET QC_OBJ_ACTIVE_YN = 'Y' WHERE OBJECT_NAME IN ('CCD_QC_LEG_ALIAS_V', 'CCD_QC_LEG_OVERLAP_V', 'CCD_QC_CRUISE_V');

	UPDATE DVM_ISS_TYPES SET ISS_TYPE_ACTIVE_YN = 'Y' WHERE IND_FIELD_NAME IN ('ERR_LEG_DAS_YN', 'MISS_GEAR_YN', 'WARN_LEG_DAS_YN');





--setup the test cases for category 7 part 2:

	--QC View does not exist (CCD_QC_CRUISE_TEMP_V):
	UPDATE DVM_QC_OBJECTS SET OBJECT_NAME = 'CCD_QC_CRUISE_TEMP_V' WHERE OBJECT_NAME = 'CCD_QC_CRUISE_V';


	--invalidate dependent views (CCD_QC_LEG_OVERLAP_V, CCD_QC_LEG_V, CCD_QC_LEG_ALIAS_V):
	ALTER TABLE CCD_CRUISES RENAME COLUMN CRUISE_URL TO CRUISE_URL2;
