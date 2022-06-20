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
	P_PK_ID => P_PK_ID
	);

	DBMS_output.put_line('The parent record was evaluated successfully');

	DBMS_OUTPUT.PUT_LINE ('completed test case for ORA-20201');

	EXCEPTION
		WHEN OTHERS THEN
			DBMS_output.put_line(SQLERRM);

			DBMS_output.put_line('The parent record was NOT evaluated successfully');

			DBMS_OUTPUT.PUT_LINE ('completed test case for ORA-20201');

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
	P_PK_ID => P_PK_ID
	);

	DBMS_output.put_line('The parent record was evaluated successfully');


	EXCEPTION
		WHEN OTHERS THEN

			DBMS_output.put_line(SQLERRM);

			DBMS_output.put_line('The parent record was NOT evaluated successfully');

			UPDATE DVM_DATA_STREAMS SET DATA_STREAM_PAR_TABLE = 'CCD_CRUISES' WHERE DATA_STREAM_CODE = 'CCD';

			DBMS_OUTPUT.PUT_LINE ('completed test case for ORA-20202');

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
	P_PK_ID => P_PK_ID
	);

	DBMS_output.put_line('The parent record was evaluated successfully');


	EXCEPTION
		WHEN OTHERS THEN
			DBMS_output.put_line(SQLERRM);

			DBMS_output.put_line('The parent record was NOT evaluated successfully');

			UPDATE DVM_DATA_STREAMS SET data_stream_par_table = 'CCD_CRUISES';

			DBMS_OUTPUT.PUT_LINE ('completed test case for ORA-20203');

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
	P_PK_ID => P_PK_ID
	);

	DBMS_output.put_line('The parent record was evaluated successfully');


	EXCEPTION
		WHEN OTHERS THEN
			DBMS_output.put_line(SQLERRM);

			DBMS_output.put_line('The parent record was NOT evaluated successfully');

			delete from dvm_data_streams where DATA_STREAM_CODE = 'CCD_TEST';

			execute immediate 'ALTER TABLE CCD_CRUISE_LEGS
			DROP COLUMN PTA_ISS_ID';

			DBMS_OUTPUT.PUT_LINE ('completed test case for ORA-20204');

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
	P_PK_ID => P_PK_ID
	);

	DBMS_output.put_line('The parent record was evaluated successfully');

	EXCEPTION
		WHEN OTHERS THEN
			DBMS_output.put_line(SQLERRM);

			DBMS_output.put_line('The parent record was NOT evaluated successfully');

			DBMS_OUTPUT.PUT_LINE ('completed test case for ORA-20206');

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
	P_PK_ID => P_PK_ID
	);

	DBMS_output.put_line('The parent record was evaluated successfully');


	EXCEPTION
		WHEN OTHERS THEN
			DBMS_output.put_line(SQLERRM);

			DBMS_output.put_line('The parent record was NOT evaluated successfully');

			DELETE FROM DVM_RULE_SETS WHERE RULE_SET_CREATE_DATE = (SELECT MAX(RULE_SET_CREATE_DATE) FROM DVM_RULE_SETS WHERE RULE_SET_ACTIVE_YN = 'Y');


			DBMS_OUTPUT.PUT_LINE ('completed test case for ORA-20210');





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
	P_PK_ID => P_PK_ID
	);
	DBMS_output.put_line('The parent record was evaluated successfully');


	EXCEPTION
		WHEN OTHERS THEN
			DBMS_output.put_line(SQLERRM);

			DBMS_output.put_line('The parent record was NOT evaluated successfully');

			--re-enable all QC object validation rules:
			UPDATE DVM_QC_OBJECTS SET QC_OBJ_ACTIVE_YN = 'Y';


			DBMS_OUTPUT.PUT_LINE ('completed test case for ORA-20211');

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
	P_PK_ID => P_PK_ID
	);

	DBMS_output.put_line('The parent record was evaluated successfully');

	EXCEPTION
		WHEN OTHERS THEN
			DBMS_output.put_line(SQLERRM);

			DBMS_output.put_line('The parent record was NOT evaluated successfully');

			--re-enable all QC object validation rules:
			UPDATE DVM_ISS_TYPES SET ISS_TYPE_ACTIVE_YN = 'Y';


			DBMS_OUTPUT.PUT_LINE ('completed test case for ORA-20211');

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
	P_PK_ID => P_PK_ID
	);


	DBMS_output.put_line('The parent record was evaluated successfully');

	EXCEPTION
		WHEN OTHERS THEN
			DBMS_output.put_line(SQLERRM);

			DBMS_output.put_line('The parent record was NOT evaluated successfully');

			UPDATE DVM_QC_OBJECTS SET OBJECT_NAME = 'CCD_QC_CRUISE_V' WHERE OBJECT_NAME = 'CCD_QC_CRUISE_TEMP_V';

			DBMS_OUTPUT.PUT_LINE ('completed test case for ORA-20220');

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
	P_PK_ID => P_PK_ID
	);

	DBMS_output.put_line('The parent record was evaluated successfully');




	EXCEPTION
		WHEN OTHERS THEN
			DBMS_output.put_line(SQLERRM);

			DBMS_output.put_line('The parent record was NOT evaluated successfully');


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
			execute immediate 'ALTER VIEW CCD_CRUISE_DVM_EVAL_RPT_V COMPILE';
			execute immediate 'ALTER VIEW CCD_CRUISE_DVM_RULE_EVAL_V COMPILE';
			execute immediate 'ALTER VIEW CCD_CRUISE_DVM_RULE_EVAL_RPT_V COMPILE';

			execute immediate 'ALTER VIEW CCD_CRUISE_DVM_RULES_V COMPILE';
			execute immediate 'ALTER VIEW CCD_CRUISE_DVM_RULES_RPT_V COMPILE';

			execute immediate 'ALTER PACKAGE CCD_CRUISE_PKG COMPILE';
			execute immediate 'ALTER PACKAGE CCD_DVM_PKG COMPILE';

			DBMS_OUTPUT.PUT_LINE ('completed test case for ORA-20221');

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
	P_PK_ID => P_PK_ID
	);

	DBMS_output.put_line('The parent record was evaluated successfully');

	EXCEPTION
		WHEN OTHERS THEN
			DBMS_output.put_line(SQLERRM);


			DBMS_output.put_line('The parent record was NOT evaluated successfully');

			--revert the issue type's comment template :
			UPDATE DVM_ISS_TYPES SET APP_LINK_TEMPLATE = REPLACE(APP_LINK_TEMPLATE, '[CRUISE_ID][ABC][DEF]', '[CRUISE_ID]') WHERE IND_FIELD_NAME = 'INV_CRUISE_NAME_YN';


			DBMS_OUTPUT.PUT_LINE ('completed test case for ORA-20224');

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
	P_PK_ID => P_PK_ID
	);

	DBMS_output.put_line('The parent record was evaluated successfully');

	EXCEPTION
		WHEN OTHERS THEN
			DBMS_output.put_line(SQLERRM);


			DBMS_output.put_line('The parent record was NOT evaluated successfully');

			--revert the issue type's comment template :
			UPDATE DVM_ISS_TYPES SET APP_LINK_TEMPLATE = REPLACE(APP_LINK_TEMPLATE, '[CRUISE_LEG_ID1][GHI][JKL]', '[CRUISE_LEG_ID1]') WHERE IND_FIELD_NAME = 'VESSEL_OVERLAP_YN';


			DBMS_OUTPUT.PUT_LINE ('completed test case for ORA-20224');







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
	P_PK_ID => P_PK_ID
	);

	DBMS_output.put_line('The parent record was evaluated successfully');



	EXCEPTION
		WHEN OTHERS THEN
			DBMS_output.put_line(SQLERRM);

			DBMS_output.put_line('The parent record was NOT evaluated successfully');

			--revert the issue type's comment template :
			UPDATE DVM_ISS_TYPES SET ISS_TYPE_COMMENT_TEMPLATE = REPLACE(ISS_TYPE_COMMENT_TEMPLATE, '[CRUISE_NAME][ABC][DEF]', '[CRUISE_NAME]') WHERE IND_FIELD_NAME = 'INV_CRUISE_NAME_YN';


			DBMS_OUTPUT.PUT_LINE ('completed test case for ORA-20225');

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
	P_PK_ID => P_PK_ID
	);

	DBMS_output.put_line('The parent record was evaluated successfully');


	EXCEPTION
		WHEN OTHERS THEN
			DBMS_output.put_line(SQLERRM);


			DBMS_output.put_line('The parent record was NOT evaluated successfully');

			--revert the issue type's comment template :
			UPDATE DVM_ISS_TYPES SET ISS_TYPE_COMMENT_TEMPLATE = REPLACE(ISS_TYPE_COMMENT_TEMPLATE, '[CRUISE_NAME1][XYZ]', '[CRUISE_NAME1]') WHERE IND_FIELD_NAME = 'VESSEL_OVERLAP_YN';


			DBMS_OUTPUT.PUT_LINE ('completed test case for ORA-20225');

END;
/




--ORA-20232 test case:

DECLARE
	P_DATA_STREAM_CODE DVM_PKG.VARCHAR_ARRAY_NUM;
	P_PK_ID NUMBER;
	V_SP_RET_CODE PLS_INTEGER;
	V_CRUISE_NAME VARCHAR2(2000) := 'HI1101';
BEGIN
	-- Modify the code to initialize the variable
	P_DATA_STREAM_CODE(1) := 'CCD';

	DBMS_OUTPUT.PUT_LINE ('executing test case for ORA-20232');

 --update the data stream to a parent table with no single numeric primary key defined
	UPDATE DVM_DATA_STREAMS SET DATA_STREAM_PAR_TABLE = 'DVM_ISSUES_HIST' WHERE DATA_STREAM_CODE = 'CCD';


--set a compound primary key for a parent table (NUMBER, VARCHAR2):
--	execute immediate 'ALTER TABLE DVM_ISSUES_HIST MODIFY (H_SEQNUM NOT NULL)';

	execute immediate 'ALTER TABLE DVM_ISSUES_HIST
MODIFY (H_TYPE_OF_CHANGE NOT NULL)';

execute immediate 'ALTER TABLE DVM_ISSUES_HIST
DROP CONSTRAINT DVM_ISSUES_HIST_PK';

	execute immediate 'ALTER TABLE DVM_ISSUES_HIST
ADD CONSTRAINT DVM_ISSUES_HIST_PK PRIMARY KEY
(
  H_SEQNUM
, H_TYPE_OF_CHANGE
)
ENABLE';

execute immediate 'ALTER TABLE DVM_ISSUES_HIST
ADD (PTA_ISS_ID NUMBER )';


	--retrieve the PK ID of the specified cruise:
	SELECT CRUISE_ID INTO P_PK_ID FROM CCD_CRUISES WHERE UPPER(CRUISE_NAME) = UPPER(V_CRUISE_NAME);

	DVM_PKG.VALIDATE_PARENT_RECORD_SP(
	P_DATA_STREAM_CODES => P_DATA_STREAM_CODE,
	P_PK_ID => P_PK_ID
	);

	DBMS_output.put_line('The parent record was evaluated successfully');


	EXCEPTION
		WHEN OTHERS THEN
			DBMS_output.put_line(SQLERRM);

			DBMS_output.put_line('The parent record was NOT evaluated successfully');

			--restore the data stream record to its former state:
			UPDATE DVM_DATA_STREAMS SET DATA_STREAM_PAR_TABLE = 'CCD_CRUISES' WHERE DATA_STREAM_CODE = 'CCD';


			DBMS_OUTPUT.PUT_LINE ('completed test case for ORA-20232');

END;
/




--remove the compound primary key from DVM_ISSUES_HIST:
ALTER TABLE DVM_ISSUES_HIST
DROP CONSTRAINT DVM_ISSUES_HIST_PK;

ALTER TABLE DVM_ISSUES_HIST
ADD CONSTRAINT DVM_ISSUES_HIST_PK PRIMARY KEY
(
  H_SEQNUM
)
ENABLE;


ALTER TABLE DVM_ISSUES_HIST  
MODIFY (H_TYPE_OF_CHANGE NULL);

ALTER TABLE DVM_ISSUES_HIST
DROP COLUMN PTA_ISS_ID;

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

	ALTER PACKAGE CCD_CRUISE_PKG COMPILE;
	ALTER PACKAGE DVM_PKG COMPILE;
	ALTER PACKAGE CCD_DVM_PKG COMPILE;






--ORA-20232 test case:

DECLARE
	P_DATA_STREAM_CODE DVM_PKG.VARCHAR_ARRAY_NUM;
	P_PK_ID NUMBER;
	V_SP_RET_CODE PLS_INTEGER;
	V_CRUISE_NAME VARCHAR2(2000) := 'HI1101';
BEGIN
	-- Modify the code to initialize the variable
	P_DATA_STREAM_CODE(1) := 'CCD';

	DBMS_OUTPUT.PUT_LINE ('executing test case for ORA-20232');

 --update the data stream to a parent table with no single numeric primary key defined
	UPDATE DVM_DATA_STREAMS SET DATA_STREAM_PAR_TABLE = 'DVM_ISS_SEVERITY_HIST' WHERE DATA_STREAM_CODE = 'CCD';


--set a compoung primary key for a parent table (NUMBER, NUMBER):
--	execute immediate 'ALTER TABLE DVM_ISS_SEVERITY_HIST MODIFY (H_SEQNUM NOT NULL)';

	execute immediate 'ALTER TABLE DVM_ISS_SEVERITY_HIST
	MODIFY (ISS_SEVERITY_ID NOT NULL)';

	execute immediate 'ALTER TABLE DVM_ISS_SEVERITY_HIST
	DROP CONSTRAINT DVM_ISS_SEVERITY_HIST_PK';


		execute immediate 'ALTER TABLE DVM_ISS_SEVERITY_HIST
	ADD CONSTRAINT DVM_ISS_SEVERITY_HIST_PK PRIMARY KEY
	(
	  ISS_SEVERITY_ID
	, H_SEQNUM
	)
	ENABLE';

execute immediate 'ALTER TABLE DVM_ISS_SEVERITY_HIST
ADD (PTA_ISS_ID NUMBER )';


	--retrieve the PK ID of the specified cruise:
	SELECT CRUISE_ID INTO P_PK_ID FROM CCD_CRUISES WHERE UPPER(CRUISE_NAME) = UPPER(V_CRUISE_NAME);

	DVM_PKG.VALIDATE_PARENT_RECORD_SP(
	P_DATA_STREAM_CODES => P_DATA_STREAM_CODE,
	P_PK_ID => P_PK_ID
	);

	DBMS_output.put_line('The parent record was evaluated successfully');

	EXCEPTION
		WHEN OTHERS THEN
			DBMS_output.put_line(SQLERRM);


			DBMS_output.put_line('The parent record was NOT evaluated successfully');

			--restore the data stream record to its former state:
			UPDATE DVM_DATA_STREAMS SET DATA_STREAM_PAR_TABLE = 'CCD_CRUISES' WHERE DATA_STREAM_CODE = 'CCD';


			DBMS_OUTPUT.PUT_LINE ('completed test case for ORA-20232');

END;
/




--remove the compound primary key from DVM_ISS_SEVERITY_HIST:

ALTER TABLE DVM_ISS_SEVERITY_HIST
DROP CONSTRAINT DVM_ISS_SEVERITY_HIST_PK;


ALTER TABLE DVM_ISS_SEVERITY_HIST
MODIFY (ISS_SEVERITY_ID NULL);

ALTER TABLE DVM_ISS_SEVERITY_HIST
DROP COLUMN PTA_ISS_ID;


ALTER TABLE DVM_ISS_SEVERITY_HIST
ADD CONSTRAINT DVM_ISS_SEVERITY_HIST_PK PRIMARY KEY
(
  H_SEQNUM
)
ENABLE;

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

	ALTER PACKAGE CCD_CRUISE_PKG COMPILE;
	ALTER PACKAGE DVM_PKG COMPILE;
	ALTER PACKAGE CCD_DVM_PKG COMPILE;





--ORA-20234 test case:

DECLARE
	P_DATA_STREAM_CODE DVM_PKG.VARCHAR_ARRAY_NUM;
	P_PK_ID NUMBER;
	V_SP_RET_CODE PLS_INTEGER;
	V_CRUISE_NAME VARCHAR2(2000) := 'HI1101';
BEGIN
	-- Modify the code to initialize the variable
	P_DATA_STREAM_CODE(1) := 'CCD';

	DBMS_OUTPUT.PUT_LINE ('executing test case for ORA-20234');

 --update the issue type to an indicator field that does not exist
	UPDATE DVM_ISS_TYPES SET IND_FIELD_NAME = 'MISSING_IND_FIELD_YN' WHERE ISS_TYPE_NAME = 'Cruise Leg Overlap';


	--retrieve the PK ID of the specified cruise:
	SELECT CRUISE_ID INTO P_PK_ID FROM CCD_CRUISES WHERE UPPER(CRUISE_NAME) = UPPER(V_CRUISE_NAME);

	DVM_PKG.VALIDATE_PARENT_RECORD_SP(
	P_DATA_STREAM_CODES => P_DATA_STREAM_CODE,
	P_PK_ID => P_PK_ID
	);

	DBMS_output.put_line('The parent record was evaluated successfully');


	EXCEPTION
		WHEN OTHERS THEN
			DBMS_output.put_line(SQLERRM);

			DBMS_output.put_line('The parent record was NOT evaluated successfully');

			--restore the issue type record to its former state:
			UPDATE DVM_ISS_TYPES SET IND_FIELD_NAME = 'CRUISE_OVERLAP_YN' WHERE ISS_TYPE_NAME = 'Cruise Leg Overlap';


			DBMS_OUTPUT.PUT_LINE ('completed test case for ORA-20234');

END;
/



--ORA-20234 test case:

DECLARE
	P_DATA_STREAM_CODE DVM_PKG.VARCHAR_ARRAY_NUM;
	P_PK_ID NUMBER;
	V_SP_RET_CODE PLS_INTEGER;
	V_CRUISE_NAME VARCHAR2(2000) := 'HI1101';
BEGIN
	-- Modify the code to initialize the variable
	P_DATA_STREAM_CODE(1) := 'CCD';

	DBMS_OUTPUT.PUT_LINE ('executing test case for ORA-20234');

 --update the issue type to an indicator field that does not exist
	UPDATE DVM_ISS_TYPES SET IND_FIELD_NAME = 'MISSING_IND_FIELD2_YN' WHERE ISS_TYPE_NAME = 'Missing Leg Gear';


	--retrieve the PK ID of the specified cruise:
	SELECT CRUISE_ID INTO P_PK_ID FROM CCD_CRUISES WHERE UPPER(CRUISE_NAME) = UPPER(V_CRUISE_NAME);

	DVM_PKG.VALIDATE_PARENT_RECORD_SP(
	P_DATA_STREAM_CODES => P_DATA_STREAM_CODE,
	P_PK_ID => P_PK_ID
	);

	DBMS_output.put_line('The parent record was evaluated successfully');


	EXCEPTION
		WHEN OTHERS THEN
			DBMS_output.put_line(SQLERRM);

			DBMS_output.put_line('The parent record was NOT evaluated successfully');

			--restore the issue type record to its former state:
			UPDATE DVM_ISS_TYPES SET IND_FIELD_NAME = 'MISS_GEAR_YN' WHERE ISS_TYPE_NAME = 'Missing Leg Gear';


			DBMS_OUTPUT.PUT_LINE ('completed test case for ORA-20234');

END;
/


--ORA-20235 test case:

DECLARE
	P_DATA_STREAM_CODE DVM_PKG.VARCHAR_ARRAY_NUM;
	P_PK_ID NUMBER;
	V_SP_RET_CODE PLS_INTEGER;
	V_CRUISE_NAME VARCHAR2(2000) := 'HI1101';
BEGIN
	-- Modify the code to initialize the variable
	P_DATA_STREAM_CODE(1) := 'CCD';

	DBMS_OUTPUT.PUT_LINE ('executing test case for ORA-20235');

--update the indicator field to make it a non-character data type:
	UPDATE DVM_ISS_TYPES SET IND_FIELD_NAME = 'CRUISE_ID' WHERE ISS_TYPE_NAME = 'Mismatched Cruise Name and Fiscal Year';


	--retrieve the PK ID of the specified cruise:
	SELECT CRUISE_ID INTO P_PK_ID FROM CCD_CRUISES WHERE UPPER(CRUISE_NAME) = UPPER(V_CRUISE_NAME);

	DVM_PKG.VALIDATE_PARENT_RECORD_SP(
	P_DATA_STREAM_CODES => P_DATA_STREAM_CODE,
	P_PK_ID => P_PK_ID
	);

	DBMS_output.put_line('The parent record was evaluated successfully');

	EXCEPTION
		WHEN OTHERS THEN
			DBMS_output.put_line(SQLERRM);

			DBMS_output.put_line('The parent record was NOT evaluated successfully');

		--restore the issue type record to its former state:
		UPDATE DVM_ISS_TYPES SET IND_FIELD_NAME = 'INV_CRUISE_NAME_FY_YN' WHERE ISS_TYPE_NAME = 'Mismatched Cruise Name and Fiscal Year';


		DBMS_OUTPUT.PUT_LINE ('completed test case for ORA-20235');

END;
/





--ORA-20235 test case:

DECLARE
	P_DATA_STREAM_CODE DVM_PKG.VARCHAR_ARRAY_NUM;
	P_PK_ID NUMBER;
	V_SP_RET_CODE PLS_INTEGER;
	V_CRUISE_NAME VARCHAR2(2000) := 'HI1101';
BEGIN
	-- Modify the code to initialize the variable
	P_DATA_STREAM_CODE(1) := 'CCD';

	DBMS_OUTPUT.PUT_LINE ('executing test case for ORA-20235');

--update the indicator field to make it a non-character data type:
	UPDATE DVM_ISS_TYPES SET IND_FIELD_NAME = 'CRUISE_LEG_ID' WHERE ISS_TYPE_NAME = 'Invalid Leg Dates';


	--retrieve the PK ID of the specified cruise:
	SELECT CRUISE_ID INTO P_PK_ID FROM CCD_CRUISES WHERE UPPER(CRUISE_NAME) = UPPER(V_CRUISE_NAME);

	DVM_PKG.VALIDATE_PARENT_RECORD_SP(
	P_DATA_STREAM_CODES => P_DATA_STREAM_CODE,
	P_PK_ID => P_PK_ID
	);

	DBMS_output.put_line('The parent record was evaluated successfully');


	EXCEPTION
		WHEN OTHERS THEN
			DBMS_output.put_line(SQLERRM);

			DBMS_output.put_line('The parent record was NOT evaluated successfully');

			--restore the issue type record to its former state:
			UPDATE DVM_ISS_TYPES SET IND_FIELD_NAME = 'INV_LEG_DATES_YN' WHERE ISS_TYPE_NAME = 'Invalid Leg Dates';

			DBMS_OUTPUT.PUT_LINE ('completed test case for ORA-20235');

END;
/



--remove the parent table primary key field from data QC view:
CREATE OR REPLACE View
CCD_QC_LEG_ALIAS_V
AS
SELECT
CCD_CRUISE_LEGS_V.CRUISE_LEG_ID,
CRUISE_NAME,
LEG_NAME,
FORMAT_LEG_START_DATE,
FORMAT_LEG_END_DATE,
VESSEL_NAME,
LEG_ALIAS_NAME,
LEG_ALIAS_DESC,
CASE WHEN UPPER(LEG_ALIAS_NAME) LIKE '% (COPY)%' then 'Y' ELSE 'N' END INV_LEG_ALIAS_COPY_YN

FROM CCD_CRUISE_LEGS_V
INNER JOIN
CCD_LEG_ALIASES
ON CCD_CRUISE_LEGS_V.CRUISE_LEG_ID = CCD_LEG_ALIASES.CRUISE_LEG_ID

WHERE
UPPER(LEG_ALIAS_NAME) LIKE '% (COPY)%'
ORDER BY LEG_NAME
;

--ORA-20236 test case:

DECLARE
	P_DATA_STREAM_CODE DVM_PKG.VARCHAR_ARRAY_NUM;
	P_PK_ID NUMBER;
	V_SP_RET_CODE PLS_INTEGER;
	V_CRUISE_NAME VARCHAR2(2000) := 'HI1101';
BEGIN
	-- Modify the code to initialize the variable
	P_DATA_STREAM_CODE(1) := 'CCD';

	DBMS_OUTPUT.PUT_LINE ('executing test case for ORA-20236');



	--retrieve the PK ID of the specified cruise:
	SELECT CRUISE_ID INTO P_PK_ID FROM CCD_CRUISES WHERE UPPER(CRUISE_NAME) = UPPER(V_CRUISE_NAME);

	DVM_PKG.VALIDATE_PARENT_RECORD_SP(
	P_DATA_STREAM_CODES => P_DATA_STREAM_CODE,
	P_PK_ID => P_PK_ID
	);

	DBMS_output.put_line('The parent record was evaluated successfully');


	EXCEPTION
		WHEN OTHERS THEN
			DBMS_output.put_line(SQLERRM);

			DBMS_output.put_line('The parent record was NOT evaluated successfully');

			DBMS_OUTPUT.PUT_LINE ('completed test case for ORA-20236');

END;
/


--restore the CCD_QC_LEG_ALIAS_V data QC view:
CREATE OR REPLACE View
CCD_QC_LEG_ALIAS_V
AS
SELECT
CCD_CRUISE_LEGS_V.CRUISE_LEG_ID,
CRUISE_ID,
CRUISE_NAME,
LEG_NAME,
FORMAT_LEG_START_DATE,
FORMAT_LEG_END_DATE,
VESSEL_NAME,
LEG_ALIAS_NAME,
LEG_ALIAS_DESC,
CASE WHEN UPPER(LEG_ALIAS_NAME) LIKE '% (COPY)%' then 'Y' ELSE 'N' END INV_LEG_ALIAS_COPY_YN

FROM CCD_CRUISE_LEGS_V
INNER JOIN
CCD_LEG_ALIASES
ON CCD_CRUISE_LEGS_V.CRUISE_LEG_ID = CCD_LEG_ALIASES.CRUISE_LEG_ID

WHERE
UPPER(LEG_ALIAS_NAME) LIKE '% (COPY)%'
ORDER BY LEG_NAME
;

COMMENT ON TABLE CCD_QC_LEG_ALIAS_V IS 'Leg Alias (QC View)

This query identifies data validation issues with Cruise Leg Aliases (e.g. invalid alias name).  This QC View is implemented in the Data Validation Module';
COMMENT ON COLUMN CCD_QC_LEG_ALIAS_V.CRUISE_ID IS 'Primary key for the CCD_CRUISES table';
COMMENT ON COLUMN CCD_QC_LEG_ALIAS_V.CRUISE_NAME IS 'The name of the given cruise designated by NOAA (e.g. SE-15-01)';
COMMENT ON COLUMN CCD_QC_LEG_ALIAS_V.CRUISE_LEG_ID IS 'Primary key for the CCD_CRUISE_LEGS table';
COMMENT ON COLUMN CCD_QC_LEG_ALIAS_V.LEG_NAME IS 'The name of the given cruise leg';
COMMENT ON COLUMN CCD_QC_LEG_ALIAS_V.FORMAT_LEG_START_DATE IS 'The start date for the given research cruise leg in MM/DD/YYYY format';
COMMENT ON COLUMN CCD_QC_LEG_ALIAS_V.FORMAT_LEG_END_DATE IS 'The end date for the given research cruise leg in MM/DD/YYYY format';
COMMENT ON COLUMN CCD_QC_LEG_ALIAS_V.VESSEL_NAME IS 'Name of the given research vessel';
COMMENT ON COLUMN CCD_QC_LEG_ALIAS_V.LEG_ALIAS_NAME IS 'The cruise leg alias name for the given cruise leg';
COMMENT ON COLUMN CCD_QC_LEG_ALIAS_V.LEG_ALIAS_DESC IS 'The cruise leg alias description for the given cruise leg';
COMMENT ON COLUMN CCD_QC_LEG_ALIAS_V.INV_LEG_ALIAS_COPY_YN IS 'Field to indicate if there is an Invalid Copied Leg Alias Name error (Y) or not (N) based on whether or not the value of LEG_ALIAS_NAME contains "(copy)"';
