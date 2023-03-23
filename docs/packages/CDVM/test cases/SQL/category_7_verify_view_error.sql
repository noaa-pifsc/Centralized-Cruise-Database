/********************************************/
--Verify the ORA-20220 error is reported and indicates that CCD_QC_CRUISE_TEMP_V does not exist
/********************************************/


set serveroutput on;

--execute for invalid data stream (ORA-20220)
DECLARE
	
	V_ERR_SOURCE VARCHAR2;
	V_ERR_MSG CLOB;
	
BEGIN
	-- Modify the code to initialize the variable



	DBMS_OUTPUT.PUT_LINE ('executing test case for ORA-20201');


	Select ERR_SOURCE, ERR_MSG INTO V_ERR_SOURCE, V_ERR_MSG FROM DVM_STD_QC_ALL_RPT_V ORDER BY ERR_SOURCE, ERR_MSG;
	

	EXCEPTION
		WHEN OTHERS THEN
			DBMS_output.put_line(SQLERRM);

			IF (SQLCODE = -20220) THEN
		
				DBMS_OUTPUT.PUT_LINE ('test case for ORA-20220 was successful');
			
			ELSE
				DBMS_OUTPUT.PUT_LINE ('test case for ORA-20220 was NOT successful');
			
			END IF;
			


END;
/
