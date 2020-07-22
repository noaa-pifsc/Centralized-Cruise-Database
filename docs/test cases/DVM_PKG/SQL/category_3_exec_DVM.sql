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


set serveroutput on;

--execute for test data stream (HI1102):
DECLARE
	P_DATA_STREAM_CODE DVM_PKG.VARCHAR_ARRAY_NUM;
	P_PK_ID NUMBER;
	V_SP_RET_CODE PLS_INTEGER;
	V_CRUISE_NAME VARCHAR2(2000) := 'HI1102';
BEGIN
	-- Modify the code to initialize the variable
	P_DATA_STREAM_CODE(1) := 'CCD_TEST';

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

--execute for test 2 data stream (SE-15-01):
DECLARE
	P_DATA_STREAM_CODE DVM_PKG.VARCHAR_ARRAY_NUM;
	P_PK_ID NUMBER;
	V_SP_RET_CODE PLS_INTEGER;
	V_CRUISE_NAME VARCHAR2(2000) := 'SE-15-01';
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


--execute for test 2 data stream (OES0607):
DECLARE
	P_DATA_STREAM_CODE DVM_PKG.VARCHAR_ARRAY_NUM;
	P_PK_ID NUMBER;
	V_SP_RET_CODE PLS_INTEGER;
	V_CRUISE_NAME VARCHAR2(2000) := 'OES0607';
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


--execute for test 2 data stream (OES0706):
DECLARE
	P_DATA_STREAM_CODE DVM_PKG.VARCHAR_ARRAY_NUM;
	P_PK_ID NUMBER;
	V_SP_RET_CODE PLS_INTEGER;
	V_CRUISE_NAME VARCHAR2(2000) := 'OES0706';
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




--execute for test data stream (OES0411):
DECLARE
	P_DATA_STREAM_CODE DVM_PKG.VARCHAR_ARRAY_NUM;
	P_PK_ID NUMBER;
	V_SP_RET_CODE PLS_INTEGER;
	V_CRUISE_NAME VARCHAR2(2000) := 'OES0411';
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


--execute for test 2 data stream (RL-17-05):
DECLARE
	P_DATA_STREAM_CODE DVM_PKG.VARCHAR_ARRAY_NUM;
	P_PK_ID NUMBER;
	V_SP_RET_CODE PLS_INTEGER;
	V_CRUISE_NAME VARCHAR2(2000) := 'RL-17-05';
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


set serveroutput on;

--execute for test data stream (HI0610):
DECLARE
	P_DATA_STREAM_CODE DVM_PKG.VARCHAR_ARRAY_NUM;
	P_PK_ID NUMBER;
	V_SP_RET_CODE PLS_INTEGER;
	V_CRUISE_NAME VARCHAR2(2000) := 'HI0610';
BEGIN
	-- Modify the code to initialize the variable
	P_DATA_STREAM_CODE(1) := 'CCD_TEST';

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




--execute for test data stream (HA1007):
DECLARE
	P_DATA_STREAM_CODE DVM_PKG.VARCHAR_ARRAY_NUM;
	P_PK_ID NUMBER;
	V_SP_RET_CODE PLS_INTEGER;
	V_CRUISE_NAME VARCHAR2(2000) := 'HA1007';
BEGIN
	-- Modify the code to initialize the variable
	P_DATA_STREAM_CODE(1) := 'CCD_TEST';

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



--execute for both test data streams (HI1001):
DECLARE
	P_DATA_STREAM_CODE DVM_PKG.VARCHAR_ARRAY_NUM;
	P_PK_ID NUMBER;
	V_SP_RET_CODE PLS_INTEGER;
	V_CRUISE_NAME VARCHAR2(2000) := 'HI1001';
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


--execute for both test data streams (HI1001):
DECLARE
	P_DATA_STREAM_CODE DVM_PKG.VARCHAR_ARRAY_NUM;
	P_PK_ID NUMBER;
	V_SP_RET_CODE PLS_INTEGER;
	V_CRUISE_NAME VARCHAR2(2000) := 'TC0201';
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

--execute for test 2 data stream (HA1007 (copy)):
DECLARE
	P_DATA_STREAM_CODE DVM_PKG.VARCHAR_ARRAY_NUM;
	P_PK_ID NUMBER;
	V_SP_RET_CODE PLS_INTEGER;
	V_CRUISE_NAME VARCHAR2(2000) := 'HA1007 (copy)';
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
