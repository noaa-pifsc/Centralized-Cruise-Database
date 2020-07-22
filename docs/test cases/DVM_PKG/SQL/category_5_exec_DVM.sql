
set serveroutput on;

--execute for test data stream (HA1007 (copy)):
DECLARE
	P_DATA_STREAM_CODE DVM_PKG.VARCHAR_ARRAY_NUM;
	P_PK_ID NUMBER;
	V_SP_RET_CODE PLS_INTEGER;
	V_CRUISE_NAME VARCHAR2(2000) := 'HA1007 (copy)';
BEGIN
	-- Modify the code to initialize the variable
	P_DATA_STREAM_CODE(1) := 'CCD';

	--retrieve the PK ID of the specified cruise:
	SELECT CRUISE_ID INTO P_PK_ID FROM CCD_CRUISES WHERE UPPER(CRUISE_NAME) = UPPER(V_CRUISE_NAME);

	CCD_DVM_PKG.EXEC_DVM_CRUISE_OVERLAP_SP(P_PK_ID, V_SP_RET_CODE);

	IF (V_SP_RET_CODE = 1) then
		DBMS_output.put_line('The parent record (and any overlapping parent records) was evaluated successfully');

		--commit the successful validation records
		COMMIT;
	ELSE
		DBMS_output.put_line('The parent record (and any overlapping parent records) was not evaluated successfully');

	END IF;

	--rollback;
END;
/



--execute for test data stream (HI1101):
DECLARE
	P_DATA_STREAM_CODE DVM_PKG.VARCHAR_ARRAY_NUM;
	P_PK_ID NUMBER;
	V_SP_RET_CODE PLS_INTEGER;
	V_CRUISE_NAME VARCHAR2(2000) := 'HI1101';
BEGIN
	-- Modify the code to initialize the variable
	P_DATA_STREAM_CODE(1) := 'CCD';

	--retrieve the PK ID of the specified cruise:
	SELECT CRUISE_ID INTO P_PK_ID FROM CCD_CRUISES WHERE UPPER(CRUISE_NAME) = UPPER(V_CRUISE_NAME);

	CCD_DVM_PKG.EXEC_DVM_CRUISE_OVERLAP_SP(P_PK_ID, V_SP_RET_CODE);

	IF (V_SP_RET_CODE = 1) then
		DBMS_output.put_line('The parent record (and any overlapping parent records) was evaluated successfully');

		--commit the successful validation records
		COMMIT;
	ELSE
		DBMS_output.put_line('The parent record (and any overlapping parent records) was not evaluated successfully');

	END IF;

	--rollback;
END;
/



--execute for test data stream (SE-15-01):
DECLARE
	P_DATA_STREAM_CODE DVM_PKG.VARCHAR_ARRAY_NUM;
	P_PK_ID NUMBER;
	V_SP_RET_CODE PLS_INTEGER;
	V_CRUISE_NAME VARCHAR2(2000) := 'SE-15-01';
BEGIN
	-- Modify the code to initialize the variable
	P_DATA_STREAM_CODE(1) := 'CCD';

	--retrieve the PK ID of the specified cruise:
	SELECT CRUISE_ID INTO P_PK_ID FROM CCD_CRUISES WHERE UPPER(CRUISE_NAME) = UPPER(V_CRUISE_NAME);

	CCD_DVM_PKG.EXEC_DVM_CRUISE_OVERLAP_SP(P_PK_ID, V_SP_RET_CODE);

	IF (V_SP_RET_CODE = 1) then
		DBMS_output.put_line('The parent record (and any overlapping parent records) was evaluated successfully');

		--commit the successful validation records
		COMMIT;
	ELSE
		DBMS_output.put_line('The parent record (and any overlapping parent records) was not evaluated successfully');

	END IF;

	--rollback;
END;
/
