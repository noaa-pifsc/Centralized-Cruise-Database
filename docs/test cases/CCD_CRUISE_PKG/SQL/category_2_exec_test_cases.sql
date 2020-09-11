set serveroutput on;



DECLARE
	 V_SP_RET_CODE PLS_INTEGER;
	 V_PROC_RETURN_MSG VARCHAR2(4000);
	 V_PROC_RETURN_CRUISE_ID PLS_INTEGER;

	 V_TEST_CODE VARCHAR2(1000) :=  'deep copy: cruise only (no legs)';
	 V_CRUISE_NAME VARCHAR2 (1000) := 'SE-17-07';

BEGIN

	 DBMS_OUTPUT.PUT_LINE ('executing test case for '||V_TEST_CODE);

		--execute the deep copy procedure:
	 CEN_CRUISE.CCD_CRUISE_PKG.DEEP_COPY_CRUISE_SP(V_CRUISE_NAME, V_SP_RET_CODE, V_PROC_RETURN_MSG, V_PROC_RETURN_CRUISE_ID);


	 DBMS_output.put_line('The deep copy was successful');


	 EXCEPTION

		 WHEN OTHERS THEN


			 DBMS_OUTPUT.PUT_LINE('The deep copy was NOT successful');

			 DBMS_OUTPUT.PUT_LINE(V_PROC_RETURN_MSG);

			 DBMS_OUTPUT.PUT_LINE(SQLERRM);

			 DBMS_OUTPUT.PUT_LINE ('completed test case for '||V_TEST_CODE);

END;
/





DECLARE
	 V_SP_RET_CODE PLS_INTEGER;
	 V_PROC_RETURN_MSG VARCHAR2(4000);
	 V_PROC_RETURN_CRUISE_ID PLS_INTEGER;

	 V_TEST_CODE VARCHAR2(1000) :=  'cruise only (no legs, no attributes)';
	 V_CRUISE_NAME VARCHAR2 (1000) := 'TC0109';

BEGIN

	 DBMS_OUTPUT.PUT_LINE ('executing test case for '||V_TEST_CODE);

		--execute the deep copy procedure:
	 CEN_CRUISE.CCD_CRUISE_PKG.DEEP_COPY_CRUISE_SP(V_CRUISE_NAME, V_SP_RET_CODE, V_PROC_RETURN_MSG, V_PROC_RETURN_CRUISE_ID);


	 DBMS_output.put_line('The deep copy was successful');


	 EXCEPTION

		 WHEN OTHERS THEN


			 DBMS_OUTPUT.PUT_LINE('The deep copy was NOT successful');

			 DBMS_OUTPUT.PUT_LINE(V_PROC_RETURN_MSG);

			 DBMS_OUTPUT.PUT_LINE(SQLERRM);

			 DBMS_OUTPUT.PUT_LINE ('completed test case for '||V_TEST_CODE);

END;
/






DECLARE
	 V_SP_RET_CODE PLS_INTEGER;
	 V_PROC_RETURN_MSG VARCHAR2(4000);
	 V_PROC_RETURN_CRUISE_ID PLS_INTEGER;

	 V_TEST_CODE VARCHAR2(1000) :=  'cruise and legs (no cruise attributes)';
	 V_CRUISE_NAME VARCHAR2 (1000) := 'OES0908';

BEGIN

	 DBMS_OUTPUT.PUT_LINE ('executing test case for '||V_TEST_CODE);

		--execute the deep copy procedure:
	 CEN_CRUISE.CCD_CRUISE_PKG.DEEP_COPY_CRUISE_SP(V_CRUISE_NAME, V_SP_RET_CODE, V_PROC_RETURN_MSG, V_PROC_RETURN_CRUISE_ID);


	 DBMS_output.put_line('The deep copy was successful');


	 EXCEPTION

		 WHEN OTHERS THEN


			 DBMS_OUTPUT.PUT_LINE('The deep copy was NOT successful');

			 DBMS_OUTPUT.PUT_LINE(V_PROC_RETURN_MSG);

			 DBMS_OUTPUT.PUT_LINE(SQLERRM);

			 DBMS_OUTPUT.PUT_LINE ('completed test case for '||V_TEST_CODE);

END;
/








DECLARE
	 V_SP_RET_CODE PLS_INTEGER;
	 V_PROC_RETURN_MSG VARCHAR2(4000);
	 V_PROC_RETURN_CRUISE_ID PLS_INTEGER;

	 V_TEST_CODE VARCHAR2(1000) :=  'cruise and legs (no leg attributes)';
	 V_CRUISE_NAME VARCHAR2 (1000) := 'TC9909';

BEGIN

	 DBMS_OUTPUT.PUT_LINE ('executing test case for '||V_TEST_CODE);

		--execute the deep copy procedure:
	 CEN_CRUISE.CCD_CRUISE_PKG.DEEP_COPY_CRUISE_SP(V_CRUISE_NAME, V_SP_RET_CODE, V_PROC_RETURN_MSG, V_PROC_RETURN_CRUISE_ID);


	 DBMS_output.put_line('The deep copy was successful');


	 EXCEPTION

		 WHEN OTHERS THEN


			 DBMS_OUTPUT.PUT_LINE('The deep copy was NOT successful');

			 DBMS_OUTPUT.PUT_LINE(V_PROC_RETURN_MSG);

			 DBMS_OUTPUT.PUT_LINE(SQLERRM);

			 DBMS_OUTPUT.PUT_LINE ('completed test case for '||V_TEST_CODE);

END;
/



DECLARE
	 V_SP_RET_CODE PLS_INTEGER;
	 V_PROC_RETURN_MSG VARCHAR2(4000);
	 V_PROC_RETURN_CRUISE_ID PLS_INTEGER;

	 V_TEST_CODE VARCHAR2(1000) :=  'cruise and legs (cruise and leg attributes)';
	 V_CRUISE_NAME VARCHAR2 (1000) := 'RL-17-05';

BEGIN

	 DBMS_OUTPUT.PUT_LINE ('executing test case for '||V_TEST_CODE);

		--execute the deep copy procedure:
	 CEN_CRUISE.CCD_CRUISE_PKG.DEEP_COPY_CRUISE_SP(V_CRUISE_NAME, V_SP_RET_CODE, V_PROC_RETURN_MSG, V_PROC_RETURN_CRUISE_ID);


	 DBMS_output.put_line('The deep copy was successful');


	 EXCEPTION

		 WHEN OTHERS THEN


			 DBMS_OUTPUT.PUT_LINE('The deep copy was NOT successful');

			 DBMS_OUTPUT.PUT_LINE(V_PROC_RETURN_MSG);

			 DBMS_OUTPUT.PUT_LINE(SQLERRM);

			 DBMS_OUTPUT.PUT_LINE ('completed test case for '||V_TEST_CODE);

END;
/
