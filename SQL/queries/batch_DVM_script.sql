--set the DBMS_OUTPUT buffer limit:
SET SERVEROUTPUT ON size 1000000;

exec DBMS_OUTPUT.ENABLE(NULL);


--this code snippet will run the data validation module to validate all cruises returned by the SELECT query.  This can be used to batch process cruises

DECLARE

	V_PROC_RETURN_CODE PLS_INTEGER;

BEGIN

	--execute the DVM for each cruise in the database
	CCD_DVM_PKG.BATCH_EXEC_DVM_CRUISE_SP;

EXCEPTION
	when others THEN

		dbms_output.put_line('The DVM batch execution was NOT successful: '|| SQLCODE || '- ' || SQLERRM);

END;
/
