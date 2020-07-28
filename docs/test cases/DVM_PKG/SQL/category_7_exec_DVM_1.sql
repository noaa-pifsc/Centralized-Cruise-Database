
--execute the DVM on a couple records to create the validation rule sets:
set serveroutput on;

--execute for both data streams (HI1101):
DECLARE
	P_DATA_STREAM_CODE DVM_PKG.VARCHAR_ARRAY_NUM;
	P_PK_ID NUMBER;
	V_SP_RET_CODE PLS_INTEGER;
	V_CRUISE_NAME VARCHAR2(2000) := 'HI1101';
BEGIN
	-- Modify the code to initialize the variable
	P_DATA_STREAM_CODE(1) := 'CCD_TEST';
	P_DATA_STREAM_CODE(2) := 'CCD_TEST2';

	--retrieve the PK ID of the specified cruise:
	SELECT CRUISE_ID INTO P_PK_ID FROM CCD_CRUISES WHERE UPPER(CRUISE_NAME) = UPPER(V_CRUISE_NAME);

	DVM_PKG.VALIDATE_PARENT_RECORD_SP(
	P_DATA_STREAM_CODES => P_DATA_STREAM_CODE,
	P_PK_ID => P_PK_ID,
	P_SP_RET_CODE => V_SP_RET_CODE
	);
	IF (V_SP_RET_CODE = 1) then
		DBMS_output.put_line('The parent record was evaluated successfully');
	ELSE
		DBMS_output.put_line('The parent record was NOT evaluated successfully');

	END IF;

	--rollback;
END;
/


set serveroutput on;

--execute for test 2 data stream (HI0401) - no errors reported:
DECLARE
	P_DATA_STREAM_CODE DVM_PKG.VARCHAR_ARRAY_NUM;
	P_PK_ID NUMBER;
	V_SP_RET_CODE PLS_INTEGER;
	V_CRUISE_NAME VARCHAR2(2000) := 'HI0401';
BEGIN
	-- Modify the code to initialize the variable
	P_DATA_STREAM_CODE(1) := 'CCD_TEST2';

	--retrieve the PK ID of the specified cruise:
	SELECT CRUISE_ID INTO P_PK_ID FROM CCD_CRUISES WHERE UPPER(CRUISE_NAME) = UPPER(V_CRUISE_NAME);

	DVM_PKG.VALIDATE_PARENT_RECORD_SP(
	P_DATA_STREAM_CODES => P_DATA_STREAM_CODE,
	P_PK_ID => P_PK_ID,
	P_SP_RET_CODE => V_SP_RET_CODE
	);
	IF (V_SP_RET_CODE = 1) then
		DBMS_output.put_line('The parent record was evaluated successfully');
	ELSE
		DBMS_output.put_line('The parent record was NOT evaluated successfully');

	END IF;

	--rollback;
END;
/












--setup DVM configuration error conditions:



--drop the primary key
ALTER TABLE DVM_ISS_TYP_ASSOC
DROP CONSTRAINT DVM_ISS_TYP_ASSOC_PK;



	--recompile invalid views:
	ALTER VIEW CCD_CRUISE_V COMPILE;
	ALTER VIEW CCD_QC_CRUISE_V COMPILE;
	ALTER VIEW CCD_QC_LEG_ALIAS_V COMPILE;
	ALTER VIEW CCD_QC_LEG_OVERLAP_V COMPILE;
	ALTER VIEW CCD_QC_LEG_V COMPILE;
	ALTER VIEW CCD_CRUISE_DELIM_V COMPILE;
	ALTER VIEW CCD_CRUISE_ISS_SUMM_V COMPILE;
	ALTER VIEW CCD_CRUISE_LEG_DELIM_V COMPILE;
	ALTER VIEW CCD_CRUISE_LEGS_V COMPILE;
	ALTER VIEW CCD_CRUISE_SUMM_ISS_V COMPILE;
	ALTER VIEW CCD_CRUISE_SUMM_V COMPILE;
	ALTER VIEW CCD_CRUISE_DVM_EVAL_RPT_V COMPILE;
	ALTER VIEW CCD_CRUISE_DVM_RULE_EVAL_V COMPILE;
	ALTER VIEW CCD_CRUISE_DVM_RULE_EVAL_RPT_V COMPILE;


	ALTER VIEW CCD_CRUISE_DVM_RULES_V COMPILE;

	ALTER VIEW CCD_CRUISE_DVM_RULES_RPT_V COMPILE;

	ALTER VIEW DVM_RULE_SETS_RPT_V COMPILE;

	ALTER VIEW DVM_PTA_ISS_TYPES_V COMPILE;

	ALTER PACKAGE CCD_CRUISE_PKG COMPILE;
	ALTER PACKAGE CCD_DVM_PKG COMPILE;
	ALTER PACKAGE DVM_PKG COMPILE;

--update the data stream to a parent table with no single numeric primary key defined
UPDATE DVM_DATA_STREAMS SET DATA_STREAM_PAR_TABLE = 'DVM_ISS_TYP_ASSOC' WHERE DATA_STREAM_CODE = 'CCD_TEST';

--update the data stream to a parent table that is not enabled in the DVM (no PTA_ISS_ID field)
UPDATE DVM_DATA_STREAMS SET DATA_STREAM_PAR_TABLE = 'CCD_CRUISE_LEGS' WHERE DATA_STREAM_CODE = 'CCD_TEST2';


INSERT INTO DVM_DATA_STREAMS (DATA_STREAM_CODE, DATA_STREAM_NAME, DATA_STREAM_DESC, DATA_STREAM_PAR_TABLE) VALUES ('CCD_TEST3', 'CCD Test Data Stream #3', 'test', 'CCD_ABC');


	--update an issue type's comment template to add additional placeholders not in the QC query:
	UPDATE DVM_ISS_TYPES SET APP_LINK_TEMPLATE = REPLACE(APP_LINK_TEMPLATE, '[CRUISE_ID]', '[CRUISE_ID][ABC][DEF]') WHERE IND_FIELD_NAME = 'INV_CRUISE_NAME_YN';







	--update an issue type's comment template to add additional placeholders not in the QC query:
	UPDATE DVM_ISS_TYPES SET APP_LINK_TEMPLATE = REPLACE(APP_LINK_TEMPLATE, '[CRUISE_LEG_ID1]', '[CRUISE_LEG_ID1][GHI][JKL]') WHERE IND_FIELD_NAME = 'VESSEL_OVERLAP_YN';





	--update an issue type's comment template to add additional placeholders not in the QC query:
	UPDATE DVM_ISS_TYPES SET ISS_TYPE_COMMENT_TEMPLATE = REPLACE(ISS_TYPE_COMMENT_TEMPLATE, '[CRUISE_NAME]', '[CRUISE_NAME][ABC][DEF]') WHERE IND_FIELD_NAME = 'INV_CRUISE_NAME_YN';



	--update an issue type's comment template to add additional placeholders not in the QC query:
	UPDATE DVM_ISS_TYPES SET ISS_TYPE_COMMENT_TEMPLATE = REPLACE(ISS_TYPE_COMMENT_TEMPLATE, '[CRUISE_NAME1]', '[CRUISE_NAME1][XYZ]') WHERE IND_FIELD_NAME = 'VESSEL_OVERLAP_YN';






	--insert the new duplicate active rule set:
	INSERT INTO DVM_RULE_SETS (RULE_SET_ACTIVE_YN, RULE_SET_CREATE_DATE, DATA_STREAM_ID) VALUES ('Y', SYSDATE, (SELECT DATA_STREAM_ID FROM DVM_DATA_STREAMS WHERE DATA_STREAM_CODE = 'CCD_TEST'));

	--disable all QC object validation rules for data stream CCD_TEST2:
	UPDATE DVM_QC_OBJECTS SET QC_OBJ_ACTIVE_YN = 'N' WHERE OBJECT_NAME IN ('CCD_QC_LEG_ALIAS_V', 'CCD_QC_LEG_OVERLAP_V', 'CCD_QC_CRUISE_V');

	UPDATE DVM_ISS_TYPES SET ISS_TYPE_ACTIVE_YN = 'N' WHERE IND_FIELD_NAME IN ('ERR_LEG_DAS_YN', 'MISS_GEAR_YN', 'WARN_LEG_DAS_YN');
