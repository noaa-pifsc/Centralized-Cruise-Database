/********************************************/
--Verify the ORA-20220 error is reported and indicates that CCD_QC_CRUISE_TEMP_V does not exist
/********************************************/


set serveroutput on;

--execute for invalid data stream (ORA-20220)
DECLARE
	P_DATA_STREAM_CODE DVM_PKG.VARCHAR_ARRAY_NUM;
BEGIN
	-- Modify the code to initialize the variable



	DBMS_OUTPUT.PUT_LINE ('executing test case for ORA-20201');


	Select ERR_SOURCE, ERR_MSG FROM DVM_STD_QC_ALL_RPT_V ORDER BY ERR_SOURCE, ERR_MSG;
	

	EXCEPTION
		WHEN SQLCODE = -20201 THEN
		
			DBMS_output.put_line(SQLERRM);
		
			DBMS_OUTPUT.PUT_LINE ('completed test case for ORA-20220');
		
		WHEN OTHERS THEN
			DBMS_output.put_line(SQLERRM);

			DBMS_OUTPUT.PUT_LINE ('completed test case for ORA-20220');

END;
/
