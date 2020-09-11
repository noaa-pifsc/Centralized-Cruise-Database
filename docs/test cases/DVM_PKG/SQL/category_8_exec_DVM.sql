set serveroutput on;




--custom CCD DVM Test Cases:






--execute for a blank cruise leg ID (ORA-20501)
DECLARE
	P_PK_ID NUMBER;
	V_LEG_ID PLS_INTEGER := NULL;
	V_EXC_CODE VARCHAR2(30) :=  'ORA-20501';

BEGIN
	DBMS_OUTPUT.PUT_LINE ('executing test case for '||V_EXC_CODE);


	CCD_DVM_PKG.DELETE_LEG_OVERLAP_SP (V_LEG_ID);
	DBMS_output.put_line('The cruise leg was deleted and the associated cruise (and any previously overlapping cruises) was evaluated using the DVM successfully');

	EXCEPTION
		WHEN OTHERS THEN
			DBMS_output.put_line('The cruise leg was NOT deleted or the associated cruise (and any previously overlapping cruises) was NOT evaluated using the DVM successfully');

			DBMS_output.put_line(SQLERRM);

			DBMS_OUTPUT.PUT_LINE ('completed test case for '||V_EXC_CODE);

	--rollback;
END;
/



--execute for an invalid cruise leg ID (ORA-20502)
DECLARE
	P_PK_ID NUMBER;
	V_LEG_ID PLS_INTEGER := -1;
	V_EXC_CODE VARCHAR2(30) :=  'ORA-20502';

BEGIN
	DBMS_OUTPUT.PUT_LINE ('executing test case for '||V_EXC_CODE);


	CCD_DVM_PKG.DELETE_LEG_OVERLAP_SP (V_LEG_ID);
	DBMS_output.put_line('The cruise leg was deleted and the associated cruise (and any previously overlapping cruises) was evaluated using the DVM successfully');

	EXCEPTION
		WHEN OTHERS THEN
			DBMS_output.put_line('The cruise leg was NOT deleted or the associated cruise (and any previously overlapping cruises) was NOT evaluated using the DVM successfully');

			DBMS_output.put_line(SQLERRM);

			DBMS_OUTPUT.PUT_LINE ('completed test case for '||V_EXC_CODE);

	--rollback;
END;
/



--execute for a blank cruise leg name (ORA-20501)
DECLARE
	P_PK_ID NUMBER;
	V_LEG_NAME VARCHAR2(1000) := NULL;
	V_EXC_CODE VARCHAR2(30) :=  'ORA-20501';

BEGIN
	DBMS_OUTPUT.PUT_LINE ('executing test case for '||V_EXC_CODE);


	CCD_DVM_PKG.DELETE_LEG_OVERLAP_SP (V_LEG_NAME);
	DBMS_output.put_line('The cruise leg was deleted and the associated cruise (and any previously overlapping cruises) was evaluated using the DVM successfully');

	EXCEPTION
		WHEN OTHERS THEN
			DBMS_output.put_line('The cruise leg was NOT deleted or the associated cruise (and any previously overlapping cruises) was NOT evaluated using the DVM successfully');

			DBMS_output.put_line(SQLERRM);

			DBMS_OUTPUT.PUT_LINE ('completed test case for '||V_EXC_CODE);

	--rollback;
END;
/

--execute for an invalid cruise leg name (ORA-20502)
DECLARE
	P_PK_ID NUMBER;
	V_LEG_NAME VARCHAR2(1000) := 'AB-12-21 Leg 1';
	V_EXC_CODE VARCHAR2(30) :=  'ORA-20502';

BEGIN
	DBMS_OUTPUT.PUT_LINE ('executing test case for '||V_EXC_CODE);


	CCD_DVM_PKG.DELETE_LEG_OVERLAP_SP (V_LEG_NAME);
	DBMS_output.put_line('The cruise leg was deleted and the associated cruise (and any previously overlapping cruises) was evaluated using the DVM successfully');

	EXCEPTION
		WHEN OTHERS THEN
			DBMS_output.put_line('The cruise leg was NOT deleted or the associated cruise (and any previously overlapping cruises) was NOT evaluated using the DVM successfully');

			DBMS_output.put_line(SQLERRM);

			DBMS_OUTPUT.PUT_LINE ('completed test case for '||V_EXC_CODE);

	--rollback;
END;
/




--execute for an invalid cruise leg name (ORA-20505)
DECLARE
	P_PK_ID NUMBER;
	V_LEG_NAME VARCHAR2(1000) := 'HI1001_LEGIII';
	V_EXC_CODE VARCHAR2(30) :=  'ORA-20505';

BEGIN
	DBMS_OUTPUT.PUT_LINE ('executing test case for '||V_EXC_CODE);


	CCD_DVM_PKG.DELETE_LEG_OVERLAP_SP (V_LEG_NAME);
	DBMS_output.put_line('The cruise leg was deleted and the associated cruise (and any previously overlapping cruises) was evaluated using the DVM successfully');

	EXCEPTION
		WHEN OTHERS THEN
			DBMS_output.put_line('The cruise leg was NOT deleted or the associated cruise (and any previously overlapping cruises) was NOT evaluated using the DVM successfully');

			DBMS_output.put_line(SQLERRM);

			DBMS_OUTPUT.PUT_LINE ('completed test case for '||V_EXC_CODE);

	--rollback;
END;
/



--execute for a blank cruise ID (ORA-20507)
DECLARE
	P_PK_ID NUMBER;
	V_CRUISE_ID PLS_INTEGER := NULL;
	V_EXC_CODE VARCHAR2(30) :=  'ORA-20507';

BEGIN
	DBMS_OUTPUT.PUT_LINE ('executing test case for '||V_EXC_CODE);


	CCD_DVM_PKG.EXEC_DVM_CRUISE_SP (V_CRUISE_ID);
	DBMS_output.put_line('The cruise record was evaluated successfully');

	EXCEPTION
		WHEN OTHERS THEN
			DBMS_output.put_line('The cruise record was NOT evaluated successfully');

			DBMS_output.put_line(SQLERRM);

			DBMS_OUTPUT.PUT_LINE ('completed test case for '||V_EXC_CODE);

	--rollback;
END;
/





--execute for invalid cruise ID - DVM Processing Error (ORA-20508)
DECLARE
	P_PK_ID NUMBER;
	V_CRUISE_ID PLS_INTEGER := -1;
	V_EXC_CODE VARCHAR2(30) :=  'ORA-20508';

BEGIN
	DBMS_OUTPUT.PUT_LINE ('executing test case for '||V_EXC_CODE);


	CCD_DVM_PKG.EXEC_DVM_CRUISE_SP (V_CRUISE_ID);
	DBMS_output.put_line('The cruise record was evaluated successfully');

	EXCEPTION
		WHEN OTHERS THEN
			DBMS_output.put_line('The cruise record was NOT evaluated successfully');

			DBMS_output.put_line(SQLERRM);

			DBMS_OUTPUT.PUT_LINE ('completed test case for '||V_EXC_CODE);

	--rollback;
END;
/


--execute for a blank cruise name (ORA-20507)
DECLARE
	P_PK_ID NUMBER;
	V_CRUISE_NAME VARCHAR2(1000) := NULL;
	V_EXC_CODE VARCHAR2(30) :=  'ORA-20507';

BEGIN
	DBMS_OUTPUT.PUT_LINE ('executing test case for '||V_EXC_CODE);


	CCD_DVM_PKG.EXEC_DVM_CRUISE_SP (V_CRUISE_NAME);
	DBMS_output.put_line('The cruise record was evaluated successfully');

	EXCEPTION
		WHEN OTHERS THEN
			DBMS_output.put_line('The cruise record was NOT evaluated successfully');

			DBMS_output.put_line(SQLERRM);

			DBMS_OUTPUT.PUT_LINE ('completed test case for '||V_EXC_CODE);

	--rollback;
END;
/


--execute for invalid cruise name (ORA-20509)
DECLARE
	P_PK_ID NUMBER;
	V_CRUISE_NAME VARCHAR2(1000) := 'ABC-123';
	V_EXC_CODE VARCHAR2(30) :=  'ORA-20509';

BEGIN
	DBMS_OUTPUT.PUT_LINE ('executing test case for '||V_EXC_CODE);


	CCD_DVM_PKG.EXEC_DVM_CRUISE_SP (V_CRUISE_NAME);
	DBMS_output.put_line('The cruise record was evaluated successfully');

	EXCEPTION
		WHEN OTHERS THEN
			DBMS_output.put_line('The cruise record was NOT evaluated successfully');

			DBMS_output.put_line(SQLERRM);

			DBMS_OUTPUT.PUT_LINE ('completed test case for '||V_EXC_CODE);

	--rollback;
END;
/



--execute for blank cruise ID (ORA-20510)
DECLARE
	P_PK_ID NUMBER;
	V_CRUISE_ID PLS_INTEGER := NULL;
	V_EXC_CODE VARCHAR2(30) :=  'ORA-20510';

BEGIN
	DBMS_OUTPUT.PUT_LINE ('executing test case for '||V_EXC_CODE);


	CCD_DVM_PKG.EXEC_DVM_CRUISE_OVERLAP_SP (V_CRUISE_ID);
	DBMS_output.put_line('The cruise record (and any overlapping records) were evaluated successfully');

	EXCEPTION
		WHEN OTHERS THEN
			DBMS_output.put_line('The cruise record (and any overlapping records) were NOT evaluated successfully');

			DBMS_output.put_line(SQLERRM);

			DBMS_OUTPUT.PUT_LINE ('completed test case for '||V_EXC_CODE);

	--rollback;
END;
/





--execute for invalid cruise ID (ORA-20511)
DECLARE
	P_PK_ID NUMBER;
	V_CRUISE_ID PLS_INTEGER := -1;
	V_EXC_CODE VARCHAR2(30) :=  'ORA-20511';

BEGIN
	DBMS_OUTPUT.PUT_LINE ('executing test case for '||V_EXC_CODE);


	CCD_DVM_PKG.EXEC_DVM_CRUISE_OVERLAP_SP (V_CRUISE_ID);
	DBMS_output.put_line('The cruise record (and any overlapping records) were evaluated successfully');

	EXCEPTION
		WHEN OTHERS THEN
			DBMS_output.put_line('The cruise record (and any overlapping records) were NOT evaluated successfully');

			DBMS_output.put_line(SQLERRM);

			DBMS_OUTPUT.PUT_LINE ('completed test case for '||V_EXC_CODE);

	--rollback;
END;
/


--execute for blank cruise name (ORA-20510)
DECLARE
	P_PK_ID NUMBER;
	V_CRUISE_NAME VARCHAR2(1000) := NULL;
	V_EXC_CODE VARCHAR2(30) :=  'ORA-20510';

BEGIN
	DBMS_OUTPUT.PUT_LINE ('executing test case for '||V_EXC_CODE);


	CCD_DVM_PKG.EXEC_DVM_CRUISE_OVERLAP_SP (V_CRUISE_NAME);
	DBMS_output.put_line('The cruise record (and any overlapping records) were evaluated successfully');

	EXCEPTION
		WHEN OTHERS THEN
			DBMS_output.put_line('The cruise record (and any overlapping records) were NOT evaluated successfully');

			DBMS_output.put_line(SQLERRM);

			DBMS_OUTPUT.PUT_LINE ('completed test case for '||V_EXC_CODE);

	--rollback;
END;
/



--execute for invalid cruise name (ORA-20512)
DECLARE
	P_PK_ID NUMBER;
	V_CRUISE_NAME VARCHAR2(1000) := 'ABC-123';
	V_EXC_CODE VARCHAR2(30) :=  'ORA-20512';

BEGIN
	DBMS_OUTPUT.PUT_LINE ('executing test case for '||V_EXC_CODE);


	CCD_DVM_PKG.EXEC_DVM_CRUISE_OVERLAP_SP (V_CRUISE_NAME);
	DBMS_output.put_line('The cruise record (and any overlapping records) were evaluated successfully');

	EXCEPTION
		WHEN OTHERS THEN
			DBMS_output.put_line('The cruise record (and any overlapping records) were NOT evaluated successfully');

			DBMS_output.put_line(SQLERRM);

			DBMS_OUTPUT.PUT_LINE ('completed test case for '||V_EXC_CODE);

	--rollback;
END;
/
