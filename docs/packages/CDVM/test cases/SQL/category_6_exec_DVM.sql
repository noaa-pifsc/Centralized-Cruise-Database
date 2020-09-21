set serveroutput on;

--execute for both data streams (HI1101):
DECLARE
	P_DATA_STREAM_CODE DVM_PKG.VARCHAR_ARRAY_NUM;
	P_PK_ID NUMBER;
	V_SP_RET_CODE PLS_INTEGER;
	V_CRUISE_NAME VARCHAR2(2000) := 'HI1101';

	--variable to store the exception message for VALIDATE_PARENT_RECORD_RC_SP procedure calls:
	V_EXC_MSG VARCHAR2(4000);

BEGIN
	-- Modify the code to initialize the variable
	P_DATA_STREAM_CODE(1) := 'CCD_TEST';
	P_DATA_STREAM_CODE(2) := 'CCD_TEST2';

	--retrieve the PK ID of the specified cruise:
	SELECT CRUISE_ID INTO P_PK_ID FROM CCD_CRUISES WHERE UPPER(CRUISE_NAME) = UPPER(V_CRUISE_NAME);

	DVM_PKG.VALIDATE_PARENT_RECORD_RC_SP(
	P_DATA_STREAM_CODES => P_DATA_STREAM_CODE,
	P_PK_ID => P_PK_ID,
	P_SP_RET_CODE => V_SP_RET_CODE,
	P_EXC_MSG => V_EXC_MSG
	);
	IF (V_SP_RET_CODE = 1) then
		DBMS_output.put_line('The parent record was evaluated successfully');
	ELSE
		DBMS_output.put_line(V_EXC_MSG);

		DBMS_output.put_line('The parent record was NOT evaluated successfully');

	END IF;

	--rollback;
END;
/


--disable two issue types:
UPDATE DVM_ISS_TYPES SET ISS_TYPE_ACTIVE_YN = 'N' WHERE IND_FIELD_NAME IN ('INV_CRUISE_NAME_YN', 'MISS_GEAR_YN');


--execute for both data streams (RL-17-05):
DECLARE
	P_DATA_STREAM_CODE DVM_PKG.VARCHAR_ARRAY_NUM;
	P_PK_ID NUMBER;
	V_SP_RET_CODE PLS_INTEGER;
	V_CRUISE_NAME VARCHAR2(2000) := 'RL-17-05';

	--variable to store the exception message for VALIDATE_PARENT_RECORD_RC_SP procedure calls:
	V_EXC_MSG VARCHAR2(4000);

BEGIN
	-- Modify the code to initialize the variable
	P_DATA_STREAM_CODE(1) := 'CCD_TEST';
	P_DATA_STREAM_CODE(2) := 'CCD_TEST2';

	--retrieve the PK ID of the specified cruise:
	SELECT CRUISE_ID INTO P_PK_ID FROM CCD_CRUISES WHERE UPPER(CRUISE_NAME) = UPPER(V_CRUISE_NAME);

	DVM_PKG.VALIDATE_PARENT_RECORD_RC_SP(
	P_DATA_STREAM_CODES => P_DATA_STREAM_CODE,
	P_PK_ID => P_PK_ID,
	P_SP_RET_CODE => V_SP_RET_CODE,
	P_EXC_MSG => V_EXC_MSG
	);
	IF (V_SP_RET_CODE = 1) then
		DBMS_output.put_line('The parent record was evaluated successfully');
	ELSE
		DBMS_output.put_line(V_EXC_MSG);

		DBMS_output.put_line('The parent record was NOT evaluated successfully');

	END IF;

	--rollback;
END;
/



--disable two issue types:
UPDATE DVM_ISS_TYPES SET ISS_TYPE_ACTIVE_YN = 'N' WHERE IND_FIELD_NAME IN ('VESSEL_OVERLAP_YN', 'ERR_CRUISE_DATE_RNG_YN');



--execute for one data stream (HI1102):
DECLARE
	P_DATA_STREAM_CODE DVM_PKG.VARCHAR_ARRAY_NUM;
	P_PK_ID NUMBER;
	V_SP_RET_CODE PLS_INTEGER;
	V_CRUISE_NAME VARCHAR2(2000) := 'HI1102';

	--variable to store the exception message for VALIDATE_PARENT_RECORD_RC_SP procedure calls:
	V_EXC_MSG VARCHAR2(4000);

BEGIN
	-- Modify the code to initialize the variable
	P_DATA_STREAM_CODE(1) := 'CCD_TEST';

	--retrieve the PK ID of the specified cruise:
	SELECT CRUISE_ID INTO P_PK_ID FROM CCD_CRUISES WHERE UPPER(CRUISE_NAME) = UPPER(V_CRUISE_NAME);

	DVM_PKG.VALIDATE_PARENT_RECORD_RC_SP(
	P_DATA_STREAM_CODES => P_DATA_STREAM_CODE,
	P_PK_ID => P_PK_ID,
	P_SP_RET_CODE => V_SP_RET_CODE,
	P_EXC_MSG => V_EXC_MSG
	);
	IF (V_SP_RET_CODE = 1) then
		DBMS_output.put_line('The parent record was evaluated successfully');
	ELSE
		DBMS_output.put_line(V_EXC_MSG);

		DBMS_output.put_line('The parent record was NOT evaluated successfully');

	END IF;

	--rollback;
END;
/




--execute for one data stream (HA1007 (copy)):
DECLARE
	P_DATA_STREAM_CODE DVM_PKG.VARCHAR_ARRAY_NUM;
	P_PK_ID NUMBER;
	V_SP_RET_CODE PLS_INTEGER;
	V_CRUISE_NAME VARCHAR2(2000) := 'HA1007 (copy)';

	--variable to store the exception message for VALIDATE_PARENT_RECORD_RC_SP procedure calls:
	V_EXC_MSG VARCHAR2(4000);

BEGIN
	-- Modify the code to initialize the variable
	P_DATA_STREAM_CODE(1) := 'CCD_TEST';
	P_DATA_STREAM_CODE(2) := 'CCD_TEST2';

	--retrieve the PK ID of the specified cruise:
	SELECT CRUISE_ID INTO P_PK_ID FROM CCD_CRUISES WHERE UPPER(CRUISE_NAME) = UPPER(V_CRUISE_NAME);

	DVM_PKG.VALIDATE_PARENT_RECORD_RC_SP(
	P_DATA_STREAM_CODES => P_DATA_STREAM_CODE,
	P_PK_ID => P_PK_ID,
	P_SP_RET_CODE => V_SP_RET_CODE,
	P_EXC_MSG => V_EXC_MSG
	);
	IF (V_SP_RET_CODE = 1) then
		DBMS_output.put_line('The parent record was evaluated successfully');
	ELSE
		DBMS_output.put_line(V_EXC_MSG);

		DBMS_output.put_line('The parent record was NOT evaluated successfully');

	END IF;

	--rollback;
END;
/


--execute for one data stream (OES0411):
DECLARE
	P_DATA_STREAM_CODE DVM_PKG.VARCHAR_ARRAY_NUM;
	P_PK_ID NUMBER;
	V_SP_RET_CODE PLS_INTEGER;
	V_CRUISE_NAME VARCHAR2(2000) := 'OES0411';

	--variable to store the exception message for VALIDATE_PARENT_RECORD_RC_SP procedure calls:
	V_EXC_MSG VARCHAR2(4000);

BEGIN
	-- Modify the code to initialize the variable
	P_DATA_STREAM_CODE(1) := 'CCD_TEST2';

	--retrieve the PK ID of the specified cruise:
	SELECT CRUISE_ID INTO P_PK_ID FROM CCD_CRUISES WHERE UPPER(CRUISE_NAME) = UPPER(V_CRUISE_NAME);

	DVM_PKG.VALIDATE_PARENT_RECORD_RC_SP(
	P_DATA_STREAM_CODES => P_DATA_STREAM_CODE,
	P_PK_ID => P_PK_ID,
	P_SP_RET_CODE => V_SP_RET_CODE,
	P_EXC_MSG => V_EXC_MSG
	);
	IF (V_SP_RET_CODE = 1) then
		DBMS_output.put_line('The parent record was evaluated successfully');
	ELSE
		DBMS_output.put_line(V_EXC_MSG);

		DBMS_output.put_line('The parent record was NOT evaluated successfully');

	END IF;

	--rollback;
END;
/




--disable two issue types:
UPDATE DVM_ISS_TYPES SET ISS_TYPE_ACTIVE_YN = 'N' WHERE IND_FIELD_NAME IN ('WARN_LEG_DAS_YN', 'CRUISE_OVERLAP_YN');


--execute for one data stream (HI1001):
DECLARE
	P_DATA_STREAM_CODE DVM_PKG.VARCHAR_ARRAY_NUM;
	P_PK_ID NUMBER;
	V_SP_RET_CODE PLS_INTEGER;
	V_CRUISE_NAME VARCHAR2(2000) := 'HI1001';

	--variable to store the exception message for VALIDATE_PARENT_RECORD_RC_SP procedure calls:
	V_EXC_MSG VARCHAR2(4000);

BEGIN
	-- Modify the code to initialize the variable
	P_DATA_STREAM_CODE(1) := 'CCD_TEST2';

	--retrieve the PK ID of the specified cruise:
	SELECT CRUISE_ID INTO P_PK_ID FROM CCD_CRUISES WHERE UPPER(CRUISE_NAME) = UPPER(V_CRUISE_NAME);

	DVM_PKG.VALIDATE_PARENT_RECORD_RC_SP(
	P_DATA_STREAM_CODES => P_DATA_STREAM_CODE,
	P_PK_ID => P_PK_ID,
	P_SP_RET_CODE => V_SP_RET_CODE,
	P_EXC_MSG => V_EXC_MSG
	);
	IF (V_SP_RET_CODE = 1) then
		DBMS_output.put_line('The parent record was evaluated successfully');
	ELSE
		DBMS_output.put_line(V_EXC_MSG);

		DBMS_output.put_line('The parent record was NOT evaluated successfully');

	END IF;

	--rollback;
END;
/




--execute for one data stream (SE-15-01):
DECLARE
	P_DATA_STREAM_CODE DVM_PKG.VARCHAR_ARRAY_NUM;
	P_PK_ID NUMBER;
	V_SP_RET_CODE PLS_INTEGER;
	V_CRUISE_NAME VARCHAR2(2000) := 'SE-15-01';

	--variable to store the exception message for VALIDATE_PARENT_RECORD_RC_SP procedure calls:
	V_EXC_MSG VARCHAR2(4000);

BEGIN
	-- Modify the code to initialize the variable
	P_DATA_STREAM_CODE(1) := 'CCD_TEST2';
	P_DATA_STREAM_CODE(2) := 'CCD_TEST';

	--retrieve the PK ID of the specified cruise:
	SELECT CRUISE_ID INTO P_PK_ID FROM CCD_CRUISES WHERE UPPER(CRUISE_NAME) = UPPER(V_CRUISE_NAME);

	DVM_PKG.VALIDATE_PARENT_RECORD_RC_SP(
	P_DATA_STREAM_CODES => P_DATA_STREAM_CODE,
	P_PK_ID => P_PK_ID,
	P_SP_RET_CODE => V_SP_RET_CODE,
	P_EXC_MSG => V_EXC_MSG
	);
	IF (V_SP_RET_CODE = 1) then
		DBMS_output.put_line('The parent record was evaluated successfully');
	ELSE
		DBMS_output.put_line(V_EXC_MSG);

		DBMS_output.put_line('The parent record was NOT evaluated successfully');

	END IF;

	--rollback;
END;
/











--re-execute the DVM on the same records with the original data streams to confirm that the same evaluation has been reused regardless of which validation rules are now active/inactive

--execute for both data streams (HI1101):
DECLARE
	P_DATA_STREAM_CODE DVM_PKG.VARCHAR_ARRAY_NUM;
	P_PK_ID NUMBER;
	V_SP_RET_CODE PLS_INTEGER;
	V_CRUISE_NAME VARCHAR2(2000) := 'HI1101';

	--variable to store the exception message for VALIDATE_PARENT_RECORD_RC_SP procedure calls:
	V_EXC_MSG VARCHAR2(4000);

BEGIN
	-- Modify the code to initialize the variable
	P_DATA_STREAM_CODE(1) := 'CCD_TEST';
	P_DATA_STREAM_CODE(2) := 'CCD_TEST2';

	--retrieve the PK ID of the specified cruise:
	SELECT CRUISE_ID INTO P_PK_ID FROM CCD_CRUISES WHERE UPPER(CRUISE_NAME) = UPPER(V_CRUISE_NAME);

	DVM_PKG.VALIDATE_PARENT_RECORD_RC_SP(
	P_DATA_STREAM_CODES => P_DATA_STREAM_CODE,
	P_PK_ID => P_PK_ID,
	P_SP_RET_CODE => V_SP_RET_CODE,
	P_EXC_MSG => V_EXC_MSG
	);
	IF (V_SP_RET_CODE = 1) then
		DBMS_output.put_line(V_EXC_MSG);

		DBMS_output.put_line('The parent record was evaluated successfully');
	ELSE
		DBMS_output.put_line('The parent record was NOT evaluated successfully');

	END IF;

	--rollback;
END;
/


--execute for both data streams (RL-17-05):
DECLARE
	P_DATA_STREAM_CODE DVM_PKG.VARCHAR_ARRAY_NUM;
	P_PK_ID NUMBER;
	V_SP_RET_CODE PLS_INTEGER;
	V_CRUISE_NAME VARCHAR2(2000) := 'RL-17-05';

	--variable to store the exception message for VALIDATE_PARENT_RECORD_RC_SP procedure calls:
	V_EXC_MSG VARCHAR2(4000);

BEGIN
	-- Modify the code to initialize the variable
	P_DATA_STREAM_CODE(1) := 'CCD_TEST';
	P_DATA_STREAM_CODE(2) := 'CCD_TEST2';

	--retrieve the PK ID of the specified cruise:
	SELECT CRUISE_ID INTO P_PK_ID FROM CCD_CRUISES WHERE UPPER(CRUISE_NAME) = UPPER(V_CRUISE_NAME);

	DVM_PKG.VALIDATE_PARENT_RECORD_RC_SP(
	P_DATA_STREAM_CODES => P_DATA_STREAM_CODE,
	P_PK_ID => P_PK_ID,
	P_SP_RET_CODE => V_SP_RET_CODE,
	P_EXC_MSG => V_EXC_MSG
	);
	IF (V_SP_RET_CODE = 1) then
		DBMS_output.put_line(V_EXC_MSG);

		DBMS_output.put_line('The parent record was evaluated successfully');
	ELSE
		DBMS_output.put_line('The parent record was NOT evaluated successfully');

	END IF;

	--rollback;
END;
/



--execute for one data stream (HI1102):
DECLARE
	P_DATA_STREAM_CODE DVM_PKG.VARCHAR_ARRAY_NUM;
	P_PK_ID NUMBER;
	V_SP_RET_CODE PLS_INTEGER;
	V_CRUISE_NAME VARCHAR2(2000) := 'HI1102';

	--variable to store the exception message for VALIDATE_PARENT_RECORD_RC_SP procedure calls:
	V_EXC_MSG VARCHAR2(4000);

BEGIN
	-- Modify the code to initialize the variable
	P_DATA_STREAM_CODE(1) := 'CCD_TEST';

	--retrieve the PK ID of the specified cruise:
	SELECT CRUISE_ID INTO P_PK_ID FROM CCD_CRUISES WHERE UPPER(CRUISE_NAME) = UPPER(V_CRUISE_NAME);

	DVM_PKG.VALIDATE_PARENT_RECORD_RC_SP(
	P_DATA_STREAM_CODES => P_DATA_STREAM_CODE,
	P_PK_ID => P_PK_ID,
	P_SP_RET_CODE => V_SP_RET_CODE,
	P_EXC_MSG => V_EXC_MSG
	);
	IF (V_SP_RET_CODE = 1) then
		DBMS_output.put_line(V_EXC_MSG);

		DBMS_output.put_line('The parent record was evaluated successfully');
	ELSE
		DBMS_output.put_line('The parent record was NOT evaluated successfully');

	END IF;

	--rollback;
END;
/



--execute for one data stream (HA1007 (copy)):
DECLARE
	P_DATA_STREAM_CODE DVM_PKG.VARCHAR_ARRAY_NUM;
	P_PK_ID NUMBER;
	V_SP_RET_CODE PLS_INTEGER;
	V_CRUISE_NAME VARCHAR2(2000) := 'HA1007 (copy)';

	--variable to store the exception message for VALIDATE_PARENT_RECORD_RC_SP procedure calls:
	V_EXC_MSG VARCHAR2(4000);

BEGIN
	-- Modify the code to initialize the variable
	P_DATA_STREAM_CODE(1) := 'CCD_TEST';
	P_DATA_STREAM_CODE(2) := 'CCD_TEST2';

	--retrieve the PK ID of the specified cruise:
	SELECT CRUISE_ID INTO P_PK_ID FROM CCD_CRUISES WHERE UPPER(CRUISE_NAME) = UPPER(V_CRUISE_NAME);

	DVM_PKG.VALIDATE_PARENT_RECORD_RC_SP(
	P_DATA_STREAM_CODES => P_DATA_STREAM_CODE,
	P_PK_ID => P_PK_ID,
	P_SP_RET_CODE => V_SP_RET_CODE,
	P_EXC_MSG => V_EXC_MSG
	);
	IF (V_SP_RET_CODE = 1) then
		DBMS_output.put_line(V_EXC_MSG);

		DBMS_output.put_line('The parent record was evaluated successfully');
	ELSE
		DBMS_output.put_line('The parent record was NOT evaluated successfully');

	END IF;

	--rollback;
END;
/



--execute for one data stream (OES0411):
DECLARE
	P_DATA_STREAM_CODE DVM_PKG.VARCHAR_ARRAY_NUM;
	P_PK_ID NUMBER;
	V_SP_RET_CODE PLS_INTEGER;
	V_CRUISE_NAME VARCHAR2(2000) := 'OES0411';

	--variable to store the exception message for VALIDATE_PARENT_RECORD_RC_SP procedure calls:
	V_EXC_MSG VARCHAR2(4000);

BEGIN
	-- Modify the code to initialize the variable
	P_DATA_STREAM_CODE(1) := 'CCD_TEST2';

	--retrieve the PK ID of the specified cruise:
	SELECT CRUISE_ID INTO P_PK_ID FROM CCD_CRUISES WHERE UPPER(CRUISE_NAME) = UPPER(V_CRUISE_NAME);

	DVM_PKG.VALIDATE_PARENT_RECORD_RC_SP(
	P_DATA_STREAM_CODES => P_DATA_STREAM_CODE,
	P_PK_ID => P_PK_ID,
	P_SP_RET_CODE => V_SP_RET_CODE,
	P_EXC_MSG => V_EXC_MSG
	);
	IF (V_SP_RET_CODE = 1) then
		DBMS_output.put_line(V_EXC_MSG);

		DBMS_output.put_line('The parent record was evaluated successfully');
	ELSE
		DBMS_output.put_line('The parent record was NOT evaluated successfully');

	END IF;

	--rollback;
END;
/


--execute for one data stream (HI1001):
DECLARE
	P_DATA_STREAM_CODE DVM_PKG.VARCHAR_ARRAY_NUM;
	P_PK_ID NUMBER;
	V_SP_RET_CODE PLS_INTEGER;
	V_CRUISE_NAME VARCHAR2(2000) := 'HI1001';

	--variable to store the exception message for VALIDATE_PARENT_RECORD_RC_SP procedure calls:
	V_EXC_MSG VARCHAR2(4000);

BEGIN
	-- Modify the code to initialize the variable
	P_DATA_STREAM_CODE(1) := 'CCD_TEST2';

	--retrieve the PK ID of the specified cruise:
	SELECT CRUISE_ID INTO P_PK_ID FROM CCD_CRUISES WHERE UPPER(CRUISE_NAME) = UPPER(V_CRUISE_NAME);

	DVM_PKG.VALIDATE_PARENT_RECORD_RC_SP(
	P_DATA_STREAM_CODES => P_DATA_STREAM_CODE,
	P_PK_ID => P_PK_ID,
	P_SP_RET_CODE => V_SP_RET_CODE,
	P_EXC_MSG => V_EXC_MSG
	);
	IF (V_SP_RET_CODE = 1) then
		DBMS_output.put_line(V_EXC_MSG);

		DBMS_output.put_line('The parent record was evaluated successfully');
	ELSE
		DBMS_output.put_line('The parent record was NOT evaluated successfully');

	END IF;

	--rollback;
END;
/




--execute for one data stream (SE-15-01):
DECLARE
	P_DATA_STREAM_CODE DVM_PKG.VARCHAR_ARRAY_NUM;
	P_PK_ID NUMBER;
	V_SP_RET_CODE PLS_INTEGER;
	V_CRUISE_NAME VARCHAR2(2000) := 'SE-15-01';

	--variable to store the exception message for VALIDATE_PARENT_RECORD_RC_SP procedure calls:
	V_EXC_MSG VARCHAR2(4000);

BEGIN
	-- Modify the code to initialize the variable
	P_DATA_STREAM_CODE(1) := 'CCD_TEST2';
	P_DATA_STREAM_CODE(2) := 'CCD_TEST';

	--retrieve the PK ID of the specified cruise:
	SELECT CRUISE_ID INTO P_PK_ID FROM CCD_CRUISES WHERE UPPER(CRUISE_NAME) = UPPER(V_CRUISE_NAME);

	DVM_PKG.VALIDATE_PARENT_RECORD_RC_SP(
	P_DATA_STREAM_CODES => P_DATA_STREAM_CODE,
	P_PK_ID => P_PK_ID,
	P_SP_RET_CODE => V_SP_RET_CODE,
	P_EXC_MSG => V_EXC_MSG
	);
	IF (V_SP_RET_CODE = 1) then
		DBMS_output.put_line(V_EXC_MSG);

		DBMS_output.put_line('The parent record was evaluated successfully');
	ELSE
		DBMS_output.put_line('The parent record was NOT evaluated successfully');

	END IF;

	--rollback;
END;
/
