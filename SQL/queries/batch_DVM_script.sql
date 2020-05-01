--set the DBMS_OUTPUT buffer limit:
SET SERVEROUTPUT ON size 1000000;

exec DBMS_OUTPUT.ENABLE(NULL);


--this code snippet will run the data validation module to validate SPTT RPL data for the results of the SELECT query.  This can be used to batch process vessel trips

DECLARE

	V_PROC_RETURN_CODE PLS_INTEGER;

BEGIN
    -- Modify the code to initialize the variable


		CCD_DVM_PKG.BATCH_EXEC_DVM_CRUISE_SP (V_PROC_RETURN_CODE);

		IF (V_PROC_RETURN_CODE = 1) then
			dbms_output.put_line('The DVM batch execution was successful');
		else
			dbms_output.put_line('The DVM batch execution was NOT successful');
		END IF;

EXCEPTION
	when others THEN

		dbms_output.put_line('The DVM batch execution was NOT successful: '|| SQLCODE || '- ' || SQLERRM);



END;
