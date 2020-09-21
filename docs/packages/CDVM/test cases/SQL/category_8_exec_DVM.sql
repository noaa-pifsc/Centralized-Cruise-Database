set serveroutput on;




--custom CCD DVM Test Cases:






--execute for a blank cruise leg ID (ORA-20501)
DECLARE

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

	V_CRUISE_NAME CCD_CRUISES.CRUISE_NAME%TYPE := NULL;
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

	V_CRUISE_NAME CCD_CRUISES.CRUISE_NAME%TYPE := 'ABC-123';
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

	V_CRUISE_NAME CCD_CRUISES.CRUISE_NAME%TYPE := NULL;
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

	V_CRUISE_NAME CCD_CRUISES.CRUISE_NAME%TYPE := 'ABC-123';
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







/*Delete Cruise Test Cases:*/


--delete cruise - execute for blank cruise ID (ORA-20513)
DECLARE
	V_CRUISE_ID CCD_CRUISES.CRUISE_ID%TYPE := NULL;
	V_EXC_CODE VARCHAR2(30) :=  'ORA-20513';

BEGIN
	DBMS_OUTPUT.PUT_LINE ('executing test case (P_CRUISE_ID) for '||V_EXC_CODE);


	CCD_DVM_PKG.DELETE_CRUISE_SP (V_CRUISE_ID);
	DBMS_output.put_line('The cruise and any associated DVM data were deleted successfully');

	EXCEPTION
		WHEN OTHERS THEN
			DBMS_output.put_line('The cruise and any associated DVM data were NOT deleted successfully');

			DBMS_output.put_line(SQLERRM);

			DBMS_OUTPUT.PUT_LINE ('completed test case for '||V_EXC_CODE);

	--rollback;
END;
/


--delete cruise - execute for blank cruise name (ORA-20513)
DECLARE
	V_CRUISE_NAME CCD_CRUISES.CRUISE_NAME%TYPE := NULL;
	V_EXC_CODE VARCHAR2(30) :=  'ORA-20513';

BEGIN
	DBMS_OUTPUT.PUT_LINE ('executing test case (P_CRUISE_NAME) for '||V_EXC_CODE);


	CCD_DVM_PKG.DELETE_CRUISE_SP (V_CRUISE_NAME);
	DBMS_output.put_line('The cruise and any associated DVM data were deleted successfully');

	EXCEPTION
		WHEN OTHERS THEN
			DBMS_output.put_line('The cruise and any associated DVM data were NOT deleted successfully');

			DBMS_output.put_line(SQLERRM);

			DBMS_OUTPUT.PUT_LINE ('completed test case for '||V_EXC_CODE);

	--rollback;
END;
/





--delete cruise - execute for invalid cruise  (ORA-20515)
DECLARE
	V_CRUISE_ID CCD_CRUISES.CRUISE_ID%TYPE := -1;
	V_EXC_CODE VARCHAR2(30) :=  'ORA-20515';

BEGIN
	DBMS_OUTPUT.PUT_LINE ('executing test case (P_CRUISE_ID) for '||V_EXC_CODE);


	CCD_DVM_PKG.DELETE_CRUISE_SP (V_CRUISE_ID);
	DBMS_output.put_line('The cruise and any associated DVM data were deleted successfully');

	EXCEPTION
		WHEN OTHERS THEN
			DBMS_output.put_line('The cruise and any associated DVM data were NOT deleted successfully');

			DBMS_output.put_line(SQLERRM);

			DBMS_OUTPUT.PUT_LINE ('completed test case for '||V_EXC_CODE);

	--rollback;
END;
/


--delete cruise - execute for invalid cruise  (ORA-20515)
DECLARE
	V_CRUISE_NAME CCD_CRUISES.CRUISE_NAME%TYPE := 'XY-21-23';
	V_EXC_CODE VARCHAR2(30) :=  'ORA-20515';

BEGIN
	DBMS_OUTPUT.PUT_LINE ('executing test case (P_CRUISE_NAME) for '||V_EXC_CODE);


	CCD_DVM_PKG.DELETE_CRUISE_SP (V_CRUISE_NAME);
	DBMS_output.put_line('The cruise and any associated DVM data were deleted successfully');

	EXCEPTION
		WHEN OTHERS THEN
			DBMS_output.put_line('The cruise and any associated DVM data were NOT deleted successfully');

			DBMS_output.put_line(SQLERRM);

			DBMS_OUTPUT.PUT_LINE ('completed test case for '||V_EXC_CODE);

	--rollback;
END;
/



--delete cruise - execute for cruise child records exist (ORA-20516)
DECLARE
	V_CRUISE_NAME CCD_CRUISES.CRUISE_NAME%TYPE := 'HI1001';
	V_EXC_CODE VARCHAR2(30) :=  'ORA-20516';

BEGIN
	DBMS_OUTPUT.PUT_LINE ('executing test case (P_CRUISE_NAME) for '||V_EXC_CODE);


	CCD_DVM_PKG.DELETE_CRUISE_SP (V_CRUISE_NAME);
	DBMS_output.put_line('The cruise and any associated DVM data were deleted successfully');

	EXCEPTION
		WHEN OTHERS THEN
			DBMS_output.put_line('The cruise and any associated DVM data were NOT deleted successfully');

			DBMS_output.put_line(SQLERRM);

			DBMS_OUTPUT.PUT_LINE ('completed test case for '||V_EXC_CODE);

	--rollback;
END;
/





/*Pre Update Leg Test Cases:*/


--Pre Update Cruise Leg - execute for blank cruise ID (ORA-20517)
DECLARE
	V_CRUISE_ID CCD_CRUISES.CRUISE_ID%TYPE := NULL;
	V_EXC_CODE VARCHAR2(30) :=  'ORA-20517';

BEGIN
	DBMS_OUTPUT.PUT_LINE ('executing test case (P_CRUISE_ID) for '||V_EXC_CODE);


	CCD_DVM_PKG.PRE_UPDATE_LEG_SP (V_CRUISE_ID);
	DBMS_output.put_line('The cruise leg was queried to identify any overlapping cruises and they were saved successfully');

	EXCEPTION
		WHEN OTHERS THEN
			DBMS_output.put_line('The cruise leg was queried to identify any overlapping cruises and they were NOT saved successfully');

			DBMS_output.put_line(SQLERRM);

			DBMS_OUTPUT.PUT_LINE ('completed test case for '||V_EXC_CODE);

	--rollback;
END;
/


--Pre Update Cruise Leg - execute for blank cruise name (ORA-20517)
DECLARE
	V_CRUISE_NAME CCD_CRUISES.CRUISE_NAME%TYPE := NULL;
	V_EXC_CODE VARCHAR2(30) :=  'ORA-20517';

BEGIN
	DBMS_OUTPUT.PUT_LINE ('executing test case (P_CRUISE_NAME) for '||V_EXC_CODE);


	CCD_DVM_PKG.PRE_UPDATE_LEG_SP (V_CRUISE_NAME);
	DBMS_output.put_line('The cruise leg was queried to identify any overlapping cruises and they were saved successfully');

	EXCEPTION
		WHEN OTHERS THEN
			DBMS_output.put_line('The cruise leg was queried to identify any overlapping cruises and they were NOT saved successfully');

			DBMS_output.put_line(SQLERRM);

			DBMS_OUTPUT.PUT_LINE ('completed test case for '||V_EXC_CODE);

	--rollback;
END;
/



--Pre Update Cruise Leg - execute for invalid cruise ID (ORA-20519)
DECLARE
	V_CRUISE_ID CCD_CRUISES.CRUISE_ID%TYPE := -1;
	V_EXC_CODE VARCHAR2(30) :=  'ORA-20519';

BEGIN
	DBMS_OUTPUT.PUT_LINE ('executing test case (P_CRUISE_ID) for '||V_EXC_CODE);


	CCD_DVM_PKG.PRE_UPDATE_LEG_SP (V_CRUISE_ID);
	DBMS_output.put_line('The cruise leg was queried to identify any overlapping cruises and they were saved successfully');

	EXCEPTION
		WHEN OTHERS THEN
			DBMS_output.put_line('The cruise leg was queried to identify any overlapping cruises and they were NOT saved successfully');

			DBMS_output.put_line(SQLERRM);

			DBMS_OUTPUT.PUT_LINE ('completed test case for '||V_EXC_CODE);

	--rollback;
END;
/


--Pre Update Cruise Leg - execute for invalid  cruise name (ORA-20519)
DECLARE
	V_CRUISE_NAME CCD_CRUISES.CRUISE_NAME%TYPE := 'FY-90-00';
	V_EXC_CODE VARCHAR2(30) :=  'ORA-20519';

BEGIN
	DBMS_OUTPUT.PUT_LINE ('executing test case (P_CRUISE_NAME) for '||V_EXC_CODE);


	CCD_DVM_PKG.PRE_UPDATE_LEG_SP (V_CRUISE_NAME);
	DBMS_output.put_line('The cruise leg was queried to identify any overlapping cruises and they were saved successfully');

	EXCEPTION
		WHEN OTHERS THEN
			DBMS_output.put_line('The cruise leg was queried to identify any overlapping cruises and they were NOT saved successfully');

			DBMS_output.put_line(SQLERRM);

			DBMS_OUTPUT.PUT_LINE ('completed test case for '||V_EXC_CODE);

	--rollback;
END;
/




/*Post Update Leg Test Cases:*/


--Post Update Cruise Leg - execute for blank cruise ID (ORA-20520)
DECLARE
	V_CRUISE_ID CCD_CRUISES.CRUISE_ID%TYPE := NULL;
	V_EXC_CODE VARCHAR2(30) :=  'ORA-20520';

BEGIN
	DBMS_OUTPUT.PUT_LINE ('executing test case (P_CRUISE_ID) for '||V_EXC_CODE);


	CCD_DVM_PKG.POST_UPDATE_LEG_SP (V_CRUISE_ID);
	DBMS_output.put_line('The updated cruise and overlapping cruises were validated using the DVM successfully');

	EXCEPTION
		WHEN OTHERS THEN
			DBMS_output.put_line('The updated cruise and overlapping cruises were NOT validated using the DVM successfully');

			DBMS_output.put_line(SQLERRM);

			DBMS_OUTPUT.PUT_LINE ('completed test case for '||V_EXC_CODE);

	--rollback;
END;
/


--Post Update Cruise Leg - execute for blank cruise name (ORA-20520)
DECLARE
	V_CRUISE_NAME CCD_CRUISES.CRUISE_NAME%TYPE := NULL;
	V_EXC_CODE VARCHAR2(30) :=  'ORA-20520';

BEGIN
	DBMS_OUTPUT.PUT_LINE ('executing test case (P_CRUISE_NAME) for '||V_EXC_CODE);


	CCD_DVM_PKG.POST_UPDATE_LEG_SP (V_CRUISE_NAME);
	DBMS_output.put_line('The updated cruise and overlapping cruises were validated using the DVM successfully');

	EXCEPTION
		WHEN OTHERS THEN
			DBMS_output.put_line('The updated cruise and overlapping cruises were NOT validated using the DVM successfully');

			DBMS_output.put_line(SQLERRM);

			DBMS_OUTPUT.PUT_LINE ('completed test case for '||V_EXC_CODE);

	--rollback;
END;
/



--Post Update Cruise Leg - execute for invalid cruise ID (ORA-20522)
DECLARE
	V_CRUISE_ID CCD_CRUISES.CRUISE_ID%TYPE := -1;
	V_EXC_CODE VARCHAR2(30) :=  'ORA-20522';

BEGIN
	DBMS_OUTPUT.PUT_LINE ('executing test case (P_CRUISE_ID) for '||V_EXC_CODE);


	CCD_DVM_PKG.POST_UPDATE_LEG_SP (V_CRUISE_ID);
	DBMS_output.put_line('The updated cruise and overlapping cruises were validated using the DVM successfully');

	EXCEPTION
		WHEN OTHERS THEN
			DBMS_output.put_line('The updated cruise and overlapping cruises were NOT validated using the DVM successfully');

			DBMS_output.put_line(SQLERRM);

			DBMS_OUTPUT.PUT_LINE ('completed test case for '||V_EXC_CODE);

	--rollback;
END;
/


--Post Update Cruise Leg - execute for invalid  cruise name (ORA-20522)
DECLARE
	V_CRUISE_NAME CCD_CRUISES.CRUISE_NAME%TYPE := 'NO-AA-21';
	V_EXC_CODE VARCHAR2(30) :=  'ORA-20522';

BEGIN
	DBMS_OUTPUT.PUT_LINE ('executing test case (P_CRUISE_NAME) for '||V_EXC_CODE);


	CCD_DVM_PKG.POST_UPDATE_LEG_SP (V_CRUISE_NAME);
	DBMS_output.put_line('The updated cruise and overlapping cruises were validated using the DVM successfully');

	EXCEPTION
		WHEN OTHERS THEN
			DBMS_output.put_line('The updated cruise and overlapping cruises were NOT validated using the DVM successfully');

			DBMS_output.put_line(SQLERRM);

			DBMS_OUTPUT.PUT_LINE ('completed test case for '||V_EXC_CODE);

	--rollback;
END;
/
