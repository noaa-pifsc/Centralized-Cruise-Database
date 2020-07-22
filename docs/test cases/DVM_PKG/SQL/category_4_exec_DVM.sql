set serveroutput on;

--execute for invalid data stream (ORA-20201)
DECLARE
	P_DATA_STREAM_CODE DVM_PKG.VARCHAR_ARRAY_NUM;
	P_PK_ID NUMBER;
	V_SP_RET_CODE PLS_INTEGER;
	V_CRUISE_NAME VARCHAR2(2000) := 'HI1101';
BEGIN
	-- Modify the code to initialize the variable
	P_DATA_STREAM_CODE(1) := 'TEST';

	DBMS_OUTPUT.PUT_LINE ('executing test case for ORA-20201');

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


	DBMS_OUTPUT.PUT_LINE ('completed test case for ORA-20201');

	--rollback;
END;
/


--ORA-20202 test case:

DECLARE
	P_DATA_STREAM_CODE DVM_PKG.VARCHAR_ARRAY_NUM;
	P_PK_ID NUMBER;
	V_SP_RET_CODE PLS_INTEGER;
	V_CRUISE_NAME VARCHAR2(2000) := 'HI1101';
BEGIN
	-- Modify the code to initialize the variable
	P_DATA_STREAM_CODE(1) := 'CCD';

	DBMS_OUTPUT.PUT_LINE ('executing test case for ORA-20202');

	UPDATE DVM_DATA_STREAMS SET DATA_STREAM_PAR_TABLE = 'CCD_CRUISES_TEMP' WHERE DATA_STREAM_CODE = 'CCD';

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

	UPDATE DVM_DATA_STREAMS SET DATA_STREAM_PAR_TABLE = 'CCD_CRUISES' WHERE DATA_STREAM_CODE = 'CCD';

	DBMS_OUTPUT.PUT_LINE ('completed test case for ORA-20202');


	--rollback;
END;
/


--execute for data stream parent table not enabled in DVM (ORA-20203)


DECLARE
	P_DATA_STREAM_CODE DVM_PKG.VARCHAR_ARRAY_NUM;
	P_PK_ID NUMBER;
	V_SP_RET_CODE PLS_INTEGER;
	V_CRUISE_NAME VARCHAR2(2000) := 'HI1101';
BEGIN
	-- Modify the code to initialize the variable
	P_DATA_STREAM_CODE(1) := 'CCD';

	DBMS_OUTPUT.PUT_LINE ('executing test case for ORA-20203');

	UPDATE DVM_DATA_STREAMS SET data_stream_par_table = 'CCD_CRUISE_LEGS' where data_Stream_code = 'CCD';

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

	UPDATE DVM_DATA_STREAMS SET data_stream_par_table = 'CCD_CRUISES';

	DBMS_OUTPUT.PUT_LINE ('completed test case for ORA-20203');

	--rollback;
END;
/



--execute for data stream parent table not enabled in DVM (ORA-20204)

DECLARE
	P_DATA_STREAM_CODE DVM_PKG.VARCHAR_ARRAY_NUM;
	P_PK_ID NUMBER;
	V_SP_RET_CODE PLS_INTEGER;
	V_CRUISE_NAME VARCHAR2(2000) := 'HI1101';
BEGIN
	-- Modify the code to initialize the variable
	P_DATA_STREAM_CODE(1) := 'CCD';
	P_DATA_STREAM_CODE(2) := 'CCD_TEST';

	DBMS_OUTPUT.PUT_LINE ('executing test case for ORA-20204');

	execute immediate 'ALTER TABLE CCD_CRUISE_LEGS
	ADD (PTA_ISS_ID NUMBER )';


	insert into DVM_DATA_STREAMS (DATA_STREAM_CODE, DATA_STREAM_NAME, DATA_STREAM_PAR_TABLE) VALUES ('CCD_TEST', 'Centralized Cruise Database Data Stream Testing', 'CCD_CRUISE_LEGS');

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

	delete from dvm_data_streams where DATA_STREAM_CODE = 'CCD_TEST';

	execute immediate 'ALTER TABLE CCD_CRUISE_LEGS
	DROP COLUMN PTA_ISS_ID';

	DBMS_OUTPUT.PUT_LINE ('completed test case for ORA-20204');

	--rollback;
END;
/






--execute for parent table not found (ORA-20206)
DECLARE
	P_DATA_STREAM_CODE DVM_PKG.VARCHAR_ARRAY_NUM;
	P_PK_ID NUMBER := -1;	--use a PK value that cannot exist
	V_SP_RET_CODE PLS_INTEGER;
BEGIN
	-- Modify the code to initialize the variable
	P_DATA_STREAM_CODE(1) := 'CCD';

	DBMS_OUTPUT.PUT_LINE ('executing test case for ORA-20206');

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

	DBMS_OUTPUT.PUT_LINE ('completed test case for ORA-20206');

	--rollback;
END;
/



--ORA-20210 test case:

DECLARE
	P_DATA_STREAM_CODE DVM_PKG.VARCHAR_ARRAY_NUM;
	P_PK_ID NUMBER;
	V_SP_RET_CODE PLS_INTEGER;
	V_CRUISE_NAME VARCHAR2(2000) := 'HI1101';

	V_PTA_ISS_ID PLS_INTEGER;
BEGIN
	-- Modify the code to initialize the variable
	P_DATA_STREAM_CODE(1) := 'CCD';

	DBMS_OUTPUT.PUT_LINE ('executing test case for ORA-20210');

	--insert the new rule set:
	INSERT INTO DVM_RULE_SETS (RULE_SET_ACTIVE_YN, RULE_SET_CREATE_DATE, DATA_STREAM_ID) VALUES ('Y', SYSDATE, (SELECT DATA_STREAM_ID FROM DVM_DATA_STREAMS WHERE DATA_STREAM_CODE = 'CCD'));

	--remove the DVM records from the specified cruise
	SELECT PTA_ISS_ID INTO V_PTA_ISS_ID FROM CCD_CRUISES WHERE CRUISE_NAME = V_CRUISE_NAME;

	update ccd_cruises set pta_iss_id = NULL WHERE CRUISE_NAME = V_CRUISE_NAME;

	delete from dvm_issues where pta_iss_id = V_PTA_ISS_ID;
	delete from dvm_pta_rule_sets where pta_iss_id = V_PTA_ISS_ID;
	delete from dvm_pta_issues where pta_iss_id = V_PTA_ISS_ID;



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

	DELETE FROM DVM_RULE_SETS WHERE RULE_SET_CREATE_DATE = (SELECT MAX(RULE_SET_CREATE_DATE) FROM DVM_RULE_SETS WHERE RULE_SET_ACTIVE_YN = 'Y');


	DBMS_OUTPUT.PUT_LINE ('completed test case for ORA-20210');


	--rollback;
END;
/




--ORA-20211 test case:

DECLARE
	P_DATA_STREAM_CODE DVM_PKG.VARCHAR_ARRAY_NUM;
	P_PK_ID NUMBER;
	V_SP_RET_CODE PLS_INTEGER;
	V_CRUISE_NAME VARCHAR2(2000) := 'HI1101';

	V_PTA_ISS_ID PLS_INTEGER;
BEGIN
	-- Modify the code to initialize the variable
	P_DATA_STREAM_CODE(1) := 'CCD';

	DBMS_OUTPUT.PUT_LINE ('executing test case for ORA-20211');

	--disable all QC object validation rules:
	UPDATE DVM_QC_OBJECTS SET QC_OBJ_ACTIVE_YN = 'N';


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


	--re-enable all QC object validation rules:
	UPDATE DVM_QC_OBJECTS SET QC_OBJ_ACTIVE_YN = 'Y';


	DBMS_OUTPUT.PUT_LINE ('completed test case for ORA-20211');


	--rollback;
END;
/




--ORA-20211 test case:

DECLARE
	P_DATA_STREAM_CODE DVM_PKG.VARCHAR_ARRAY_NUM;
	P_PK_ID NUMBER;
	V_SP_RET_CODE PLS_INTEGER;
	V_CRUISE_NAME VARCHAR2(2000) := 'HI1101';

	V_PTA_ISS_ID PLS_INTEGER;
BEGIN
	-- Modify the code to initialize the variable
	P_DATA_STREAM_CODE(1) := 'CCD';

	DBMS_OUTPUT.PUT_LINE ('executing test case for ORA-20211');

	--disable all QC object validation rules:
	UPDATE DVM_ISS_TYPES SET ISS_TYPE_ACTIVE_YN = 'N';


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


	--re-enable all QC object validation rules:
	UPDATE DVM_ISS_TYPES SET ISS_TYPE_ACTIVE_YN = 'Y';


	DBMS_OUTPUT.PUT_LINE ('completed test case for ORA-20211');


	--rollback;
END;
/








--ORA-20220 test case:

DECLARE
	P_DATA_STREAM_CODE DVM_PKG.VARCHAR_ARRAY_NUM;
	P_PK_ID NUMBER;
	V_SP_RET_CODE PLS_INTEGER;
	V_CRUISE_NAME VARCHAR2(2000) := 'HI1101';
BEGIN
	-- Modify the code to initialize the variable
	P_DATA_STREAM_CODE(1) := 'CCD';

	DBMS_OUTPUT.PUT_LINE ('executing test case for ORA-20220');

	UPDATE DVM_QC_OBJECTS SET OBJECT_NAME = 'CCD_QC_CRUISE_TEMP_V' WHERE OBJECT_NAME = 'CCD_QC_CRUISE_V';

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

	UPDATE DVM_QC_OBJECTS SET OBJECT_NAME = 'CCD_QC_CRUISE_V' WHERE OBJECT_NAME = 'CCD_QC_CRUISE_TEMP_V';

	DBMS_OUTPUT.PUT_LINE ('completed test case for ORA-20220');


	--rollback;
END;
/


--ORA-20221 test case:

DECLARE
	P_DATA_STREAM_CODE DVM_PKG.VARCHAR_ARRAY_NUM;
	P_PK_ID NUMBER;
	V_SP_RET_CODE PLS_INTEGER;
	V_CRUISE_NAME VARCHAR2(2000) := 'HI1101';
BEGIN
	-- Modify the code to initialize the variable
	P_DATA_STREAM_CODE(1) := 'CCD';

	DBMS_OUTPUT.PUT_LINE ('executing test case for ORA-20221');

	--invalidate dependent views:
	execute immediate 'ALTER TABLE CCD_CRUISES RENAME COLUMN CRUISE_URL TO CRUISE_URL2';


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


	--restore the table to its former state:
	execute immediate 'ALTER TABLE CCD_CRUISES RENAME COLUMN CRUISE_URL2 TO CRUISE_URL';


	--recompile invalid views:
	execute immediate 'ALTER VIEW CCD_CRUISE_V COMPILE';
	execute immediate 'ALTER VIEW CCD_QC_CRUISE_V COMPILE';
	execute immediate 'ALTER VIEW CCD_QC_LEG_ALIAS_V COMPILE';
	execute immediate 'ALTER VIEW CCD_QC_LEG_OVERLAP_V COMPILE';
	execute immediate 'ALTER VIEW CCD_QC_LEG_V COMPILE';
	execute immediate 'ALTER VIEW CCD_CRUISE_DELIM_V COMPILE';
	execute immediate 'ALTER VIEW CCD_CRUISE_ISS_SUMM_V COMPILE';
	execute immediate 'ALTER VIEW CCD_CRUISE_LEG_DELIM_V COMPILE';
	execute immediate 'ALTER VIEW CCD_CRUISE_LEGS_V COMPILE';
	execute immediate 'ALTER VIEW CCD_CRUISE_SUMM_ISS_V COMPILE';
	execute immediate 'ALTER VIEW CCD_CRUISE_SUMM_V COMPILE';

	DBMS_OUTPUT.PUT_LINE ('completed test case for ORA-20221');

	--rollback;
END;
/




--ORA-20224 test case:

DECLARE
	P_DATA_STREAM_CODE DVM_PKG.VARCHAR_ARRAY_NUM;
	P_PK_ID NUMBER;
	V_SP_RET_CODE PLS_INTEGER;
	V_CRUISE_NAME VARCHAR2(2000) := 'HI1101';

	V_PTA_ISS_ID PLS_INTEGER;
BEGIN
	-- Modify the code to initialize the variable
	P_DATA_STREAM_CODE(1) := 'CCD';

	DBMS_OUTPUT.PUT_LINE ('executing test case for ORA-20224');

	--update an issue type's comment template to add additional placeholders not in the QC query:
	UPDATE DVM_ISS_TYPES SET APP_LINK_TEMPLATE = REPLACE(APP_LINK_TEMPLATE, '[CRUISE_ID]', '[CRUISE_ID][ABC][DEF]') WHERE IND_FIELD_NAME = 'INV_CRUISE_NAME_YN';



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


	--revert the issue type's comment template :
	UPDATE DVM_ISS_TYPES SET APP_LINK_TEMPLATE = REPLACE(APP_LINK_TEMPLATE, '[CRUISE_ID][ABC][DEF]', '[CRUISE_ID]') WHERE IND_FIELD_NAME = 'INV_CRUISE_NAME_YN';


	DBMS_OUTPUT.PUT_LINE ('completed test case for ORA-20224');


	--rollback;
END;
/



--ORA-20224 test case:

DECLARE
	P_DATA_STREAM_CODE DVM_PKG.VARCHAR_ARRAY_NUM;
	P_PK_ID NUMBER;
	V_SP_RET_CODE PLS_INTEGER;
	V_CRUISE_NAME VARCHAR2(2000) := 'HI1102';

	V_PTA_ISS_ID PLS_INTEGER;
BEGIN
	-- Modify the code to initialize the variable
	P_DATA_STREAM_CODE(1) := 'CCD';

	DBMS_OUTPUT.PUT_LINE ('executing test case for ORA-20224');

	--update an issue type's comment template to add additional placeholders not in the QC query:
	UPDATE DVM_ISS_TYPES SET APP_LINK_TEMPLATE = REPLACE(APP_LINK_TEMPLATE, '[CRUISE_LEG_ID1]', '[CRUISE_LEG_ID1][GHI][JKL]') WHERE IND_FIELD_NAME = 'VESSEL_OVERLAP_YN';



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


	--revert the issue type's comment template :
	UPDATE DVM_ISS_TYPES SET APP_LINK_TEMPLATE = REPLACE(APP_LINK_TEMPLATE, '[CRUISE_LEG_ID1][GHI][JKL]', '[CRUISE_LEG_ID1]') WHERE IND_FIELD_NAME = 'VESSEL_OVERLAP_YN';


	DBMS_OUTPUT.PUT_LINE ('completed test case for ORA-20224');


	--rollback;
END;
/


--ORA-20225 test case:

DECLARE
	P_DATA_STREAM_CODE DVM_PKG.VARCHAR_ARRAY_NUM;
	P_PK_ID NUMBER;
	V_SP_RET_CODE PLS_INTEGER;
	V_CRUISE_NAME VARCHAR2(2000) := 'HI1101';

	V_PTA_ISS_ID PLS_INTEGER;
BEGIN
	-- Modify the code to initialize the variable
	P_DATA_STREAM_CODE(1) := 'CCD';

	DBMS_OUTPUT.PUT_LINE ('executing test case for ORA-20225');

	--update an issue type's comment template to add additional placeholders not in the QC query:
	UPDATE DVM_ISS_TYPES SET ISS_TYPE_COMMENT_TEMPLATE = REPLACE(ISS_TYPE_COMMENT_TEMPLATE, '[CRUISE_NAME]', '[CRUISE_NAME][ABC][DEF]') WHERE IND_FIELD_NAME = 'INV_CRUISE_NAME_YN';



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


	--revert the issue type's comment template :
	UPDATE DVM_ISS_TYPES SET ISS_TYPE_COMMENT_TEMPLATE = REPLACE(ISS_TYPE_COMMENT_TEMPLATE, '[CRUISE_NAME][ABC][DEF]', '[CRUISE_NAME]') WHERE IND_FIELD_NAME = 'INV_CRUISE_NAME_YN';


	DBMS_OUTPUT.PUT_LINE ('completed test case for ORA-20225');


	--rollback;
END;
/




--ORA-20225 test case:

DECLARE
	P_DATA_STREAM_CODE DVM_PKG.VARCHAR_ARRAY_NUM;
	P_PK_ID NUMBER;
	V_SP_RET_CODE PLS_INTEGER;
	V_CRUISE_NAME VARCHAR2(2000) := 'HI1102';

	V_PTA_ISS_ID PLS_INTEGER;
BEGIN
	-- Modify the code to initialize the variable
	P_DATA_STREAM_CODE(1) := 'CCD';

	DBMS_OUTPUT.PUT_LINE ('executing test case for ORA-20225');

	--update an issue type's comment template to add additional placeholders not in the QC query:
	UPDATE DVM_ISS_TYPES SET ISS_TYPE_COMMENT_TEMPLATE = REPLACE(ISS_TYPE_COMMENT_TEMPLATE, '[CRUISE_NAME1]', '[CRUISE_NAME1][XYZ]') WHERE IND_FIELD_NAME = 'VESSEL_OVERLAP_YN';



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


	--revert the issue type's comment template :
	UPDATE DVM_ISS_TYPES SET ISS_TYPE_COMMENT_TEMPLATE = REPLACE(ISS_TYPE_COMMENT_TEMPLATE, '[CRUISE_NAME1][XYZ]', '[CRUISE_NAME1]') WHERE IND_FIELD_NAME = 'VESSEL_OVERLAP_YN';


	DBMS_OUTPUT.PUT_LINE ('completed test case for ORA-20225');


	--rollback;
END;
/
