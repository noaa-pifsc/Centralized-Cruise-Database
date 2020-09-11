
set serveroutput on;

--Insert Cruise Leg Case 1 (evaluate one record  - HA1007 (copy) - that has an overlap with another cruise), the overlapping cruise is automatically evaluated using the CCD_DVM_PKG.EXEC_DVM_CRUISE_OVERLAP_SP procedure:


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

	CCD_DVM_PKG.EXEC_DVM_CRUISE_OVERLAP_SP(P_PK_ID);

	DBMS_output.put_line('The parent record (and any overlapping parent records) was evaluated successfully');

	--commit the successful validation records
	COMMIT;

	EXCEPTION
		WHEN OTHERS THEN
			DBMS_output.put_line('The parent record (and any overlapping parent records) was not evaluated successfully');

	--rollback;
END;
/

--Insert Cruise Leg Case 1 (evaluate one record  - HI1101 - that has an overlap with another cruise), the overlapping cruise is automatically evaluated using the CCD_DVM_PKG.EXEC_DVM_CRUISE_OVERLAP_SP procedure:


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

	CCD_DVM_PKG.EXEC_DVM_CRUISE_OVERLAP_SP(P_PK_ID);

	DBMS_output.put_line('The parent record (and any overlapping parent records) was evaluated successfully');

	--commit the successful validation records
	COMMIT;

	EXCEPTION
		WHEN OTHERS THEN

			DBMS_output.put_line('The parent record (and any overlapping parent records) was not evaluated successfully');

	--rollback;
END;
/


--Insert Cruise Leg Case 2 (evaluate one record  - SE-15-01 - that has an overlap with another leg in the same cruise), the overlapping cruise is not automatically evaluated because it's the same cruise:


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

	CCD_DVM_PKG.EXEC_DVM_CRUISE_OVERLAP_SP(P_PK_ID);

	DBMS_output.put_line('The parent record (and any overlapping parent records) was evaluated successfully');

	--commit the successful validation records
	COMMIT;

	EXCEPTION
		WHEN OTHERS THEN

			DBMS_output.put_line('The parent record (and any overlapping parent records) was not evaluated successfully');


	--rollback;
END;
/









--delete cruise leg test cases:

--Delete Cruise Leg Case 1 (Overlap to no overlap) Vessel Leg Overlaps DVM records removed after using CCD_CRUISE_PKG.DELETE_LEG_OVERLAP_SP procedure is executed on SE-20-05 Leg 1 to remove the overlap errors on SE-20-04:


--execute for test data stream (SE-20-04):
DECLARE
	P_PK_ID NUMBER;
	V_SP_RET_CODE PLS_INTEGER;
	V_CRUISE_NAME VARCHAR2(2000) := 'SE-20-04';
BEGIN

	--retrieve the PK ID of the specified cruise:
	SELECT CRUISE_ID INTO P_PK_ID FROM CCD_CRUISES WHERE UPPER(CRUISE_NAME) = UPPER(V_CRUISE_NAME);

	CCD_DVM_PKG.EXEC_DVM_CRUISE_SP(P_PK_ID);

	DBMS_output.put_line('The parent record ('||V_CRUISE_NAME||') was evaluated successfully');

	--commit the successful validation records
	COMMIT;

	EXCEPTION
		WHEN OTHERS THEN
			DBMS_output.put_line('The parent record ('||V_CRUISE_NAME||') was not evaluated successfully');

	--rollback;
END;
/




--execute for test data stream (SE-20-05):
DECLARE
	P_PK_ID NUMBER;
	V_SP_RET_CODE PLS_INTEGER;
	V_CRUISE_NAME VARCHAR2(2000) := 'SE-20-05';
BEGIN

	--retrieve the PK ID of the specified cruise:
	SELECT CRUISE_ID INTO P_PK_ID FROM CCD_CRUISES WHERE UPPER(CRUISE_NAME) = UPPER(V_CRUISE_NAME);

	CCD_DVM_PKG.EXEC_DVM_CRUISE_SP(P_PK_ID);

	DBMS_output.put_line('The parent record ('||V_CRUISE_NAME||') was evaluated successfully');

	--commit the successful validation records
	COMMIT;

	EXCEPTION
		WHEN OTHERS THEN

			DBMS_output.put_line('The parent record ('||V_CRUISE_NAME||') was not evaluated successfully');

	--rollback;
END;
/











--delete the cruise leg (SE-20-05 Leg 1):
DECLARE
	P_PK_ID NUMBER;
	V_SP_RET_CODE PLS_INTEGER;
	V_LEG_NAME VARCHAR2(2000) := 'SE-20-05 Leg 1';
BEGIN


	--retrieve the PK ID of the specified cruise:
	SELECT CRUISE_LEG_ID INTO P_PK_ID FROM CCD_CRUISE_LEGS WHERE UPPER(LEG_NAME) = UPPER(V_LEG_NAME);


  CEN_CRUISE.CCD_DVM_PKG.DELETE_LEG_OVERLAP_SP (P_PK_ID);

 	DBMS_output.put_line('The Cruise Leg was deleted successfully');

	--commit the successful validation records
	COMMIT;

	EXCEPTION
		WHEN OTHERS THEN

       DBMS_output.put_line('The Cruise Leg was NOT deleted successfully');


	--rollback;
END;
/





--Delete Cruise Leg Case 2 (Overlap with two cruises to no overlap) Vessel Leg Overlaps DVM records removed after using CCD_CRUISE_PKG.DELETE_LEG_OVERLAP_SP procedure is executed on SE-21-03 to remove the overlap errors on SE-21-01 and SE-21-04:

--execute for test data stream (SE-21-01):
DECLARE
	P_PK_ID NUMBER;
	V_SP_RET_CODE PLS_INTEGER;
	V_CRUISE_NAME VARCHAR2(2000) := 'SE-21-01';
BEGIN

	--retrieve the PK ID of the specified cruise:
	SELECT CRUISE_ID INTO P_PK_ID FROM CCD_CRUISES WHERE UPPER(CRUISE_NAME) = UPPER(V_CRUISE_NAME);

	CCD_DVM_PKG.EXEC_DVM_CRUISE_SP(P_PK_ID);

	DBMS_output.put_line('The parent record ('||V_CRUISE_NAME||') was evaluated successfully');

	--commit the successful validation records
	COMMIT;

	EXCEPTION
		WHEN OTHERS THEN
			DBMS_output.put_line('The parent record ('||V_CRUISE_NAME||') was not evaluated successfully');

	--rollback;
END;
/





--execute for test data stream (SE-21-03):
DECLARE
	P_PK_ID NUMBER;
	V_SP_RET_CODE PLS_INTEGER;
	V_CRUISE_NAME VARCHAR2(2000) := 'SE-21-03';
BEGIN

	--retrieve the PK ID of the specified cruise:
	SELECT CRUISE_ID INTO P_PK_ID FROM CCD_CRUISES WHERE UPPER(CRUISE_NAME) = UPPER(V_CRUISE_NAME);

	CCD_DVM_PKG.EXEC_DVM_CRUISE_SP(P_PK_ID);

	DBMS_output.put_line('The parent record ('||V_CRUISE_NAME||') was evaluated successfully');


	--commit the successful validation records
	COMMIT;

	EXCEPTION
		WHEN OTHERS THEN
			DBMS_output.put_line('The parent record ('||V_CRUISE_NAME||') was not evaluated successfully');

	--rollback;
END;
/




--execute for test data stream (SE-21-04):
DECLARE
	P_PK_ID NUMBER;
	V_SP_RET_CODE PLS_INTEGER;
	V_CRUISE_NAME VARCHAR2(2000) := 'SE-21-04';
BEGIN

	--retrieve the PK ID of the specified cruise:
	SELECT CRUISE_ID INTO P_PK_ID FROM CCD_CRUISES WHERE UPPER(CRUISE_NAME) = UPPER(V_CRUISE_NAME);

	CCD_DVM_PKG.EXEC_DVM_CRUISE_SP(P_PK_ID);

	DBMS_output.put_line('The parent record ('||V_CRUISE_NAME||') was evaluated successfully');

	--commit the successful validation records
	COMMIT;

	EXCEPTION
		WHEN OTHERS THEN

			DBMS_output.put_line('The parent record ('||V_CRUISE_NAME||') was not evaluated successfully');

	--rollback;
END;
/



--delete the cruise leg (SE-21-03):
DECLARE
	P_PK_ID NUMBER;
	V_SP_RET_CODE PLS_INTEGER;
	V_LEG_NAME VARCHAR2(2000) := 'SE-21-03';
BEGIN


	--retrieve the PK ID of the specified cruise:
	SELECT CRUISE_LEG_ID INTO P_PK_ID FROM CCD_CRUISE_LEGS WHERE UPPER(LEG_NAME) = UPPER(V_LEG_NAME);


  CEN_CRUISE.CCD_DVM_PKG.DELETE_LEG_OVERLAP_SP (P_PK_ID);

  DBMS_output.put_line('The Cruise Leg was deleted successfully');

	--commit the successful validation records
	COMMIT;

	EXCEPTION
		WHEN OTHERS THEN
			DBMS_output.put_line('The Cruise Leg was NOT deleted successfully');


	--rollback;
END;
/





--Delete Cruise Leg Case 3 (One cruise overlaps with two cruises, one overlap is resolved when removing an overlapping cruise leg) Run the CCD_CRUISE_PKG.DELETE_LEG_OVERLAP_SP procedure.  Delete HI-21-08 Leg 1 removing the HI-21-08 Leg 1 overlap errors from HI-21-07 Leg 2:



--execute for test data stream (HI-21-06):
DECLARE
	P_PK_ID NUMBER;
	V_SP_RET_CODE PLS_INTEGER;
	V_CRUISE_NAME VARCHAR2(2000) := 'HI-21-06';
BEGIN

	--retrieve the PK ID of the specified cruise:
	SELECT CRUISE_ID INTO P_PK_ID FROM CCD_CRUISES WHERE UPPER(CRUISE_NAME) = UPPER(V_CRUISE_NAME);

	CCD_DVM_PKG.EXEC_DVM_CRUISE_SP(P_PK_ID);

	DBMS_output.put_line('The parent record ('||V_CRUISE_NAME||') was evaluated successfully');

	--commit the successful validation records
	COMMIT;

	EXCEPTION
		WHEN OTHERS THEN

			DBMS_output.put_line('The parent record ('||V_CRUISE_NAME||') was not evaluated successfully');

	--rollback;
END;
/






--execute for test data stream (HI-21-07):
DECLARE
	P_PK_ID NUMBER;
	V_SP_RET_CODE PLS_INTEGER;
	V_CRUISE_NAME VARCHAR2(2000) := 'HI-21-07';
BEGIN

	--retrieve the PK ID of the specified cruise:
	SELECT CRUISE_ID INTO P_PK_ID FROM CCD_CRUISES WHERE UPPER(CRUISE_NAME) = UPPER(V_CRUISE_NAME);

	CCD_DVM_PKG.EXEC_DVM_CRUISE_SP(P_PK_ID);

	DBMS_output.put_line('The parent record ('||V_CRUISE_NAME||') was evaluated successfully');

	--commit the successful validation records
	COMMIT;

	EXCEPTION
		WHEN OTHERS THEN
			DBMS_output.put_line('The parent record ('||V_CRUISE_NAME||') was not evaluated successfully');

	--rollback;
END;
/




--execute for test data stream (HI-21-08):
DECLARE
	P_PK_ID NUMBER;
	V_SP_RET_CODE PLS_INTEGER;
	V_CRUISE_NAME VARCHAR2(2000) := 'HI-21-08';
BEGIN

	--retrieve the PK ID of the specified cruise:
	SELECT CRUISE_ID INTO P_PK_ID FROM CCD_CRUISES WHERE UPPER(CRUISE_NAME) = UPPER(V_CRUISE_NAME);

	CCD_DVM_PKG.EXEC_DVM_CRUISE_SP(P_PK_ID);

	DBMS_output.put_line('The parent record ('||V_CRUISE_NAME||') was evaluated successfully');

	--commit the successful validation records
	COMMIT;

	EXCEPTION
		WHEN OTHERS THEN
			DBMS_output.put_line('The parent record ('||V_CRUISE_NAME||') was not evaluated successfully');

	--rollback;
END;
/











--delete the cruise leg (HI-21-08 Leg 1):
DECLARE
	P_PK_ID NUMBER;
	V_SP_RET_CODE PLS_INTEGER;
	V_LEG_NAME VARCHAR2(2000) := 'HI-21-08 Leg 1';
BEGIN


	--retrieve the PK ID of the specified cruise:
	SELECT CRUISE_LEG_ID INTO P_PK_ID FROM CCD_CRUISE_LEGS WHERE UPPER(LEG_NAME) = UPPER(V_LEG_NAME);


  CEN_CRUISE.CCD_DVM_PKG.DELETE_LEG_OVERLAP_SP (P_PK_ID);

	DBMS_output.put_line('The Cruise Leg was deleted successfully');

	--commit the successful validation records
	COMMIT;

	EXCEPTION
		WHEN OTHERS THEN
			DBMS_output.put_line('The Cruise Leg was NOT deleted successfully');

	--rollback;
END;
/







--Delete Cruise Leg Case 4 (Three cruises overlap, remove one overlapping cruise leg) Run the CCD_CRUISE_PKG.DELETE_LEG_OVERLAP_SP.  Delete HI-20-10 Leg 1 resolves overlapping errors with HI-20-10 Leg 1 for HI-20-08 Leg 1, HI-20-08 Leg 2, HI-20-09 Leg 1:



--execute for test data stream (HI-20-08):
DECLARE
	P_PK_ID NUMBER;
	V_SP_RET_CODE PLS_INTEGER;
	V_CRUISE_NAME VARCHAR2(2000) := 'HI-20-08';
BEGIN

	--retrieve the PK ID of the specified cruise:
	SELECT CRUISE_ID INTO P_PK_ID FROM CCD_CRUISES WHERE UPPER(CRUISE_NAME) = UPPER(V_CRUISE_NAME);

	CCD_DVM_PKG.EXEC_DVM_CRUISE_SP(P_PK_ID);

	DBMS_output.put_line('The parent record ('||V_CRUISE_NAME||') was evaluated successfully');

	--commit the successful validation records
	COMMIT;

	EXCEPTION
		WHEN OTHERS THEN
			DBMS_output.put_line('The parent record ('||V_CRUISE_NAME||') was not evaluated successfully');

	--rollback;
END;
/






--execute for test data stream (HI-20-09):
DECLARE
	P_PK_ID NUMBER;
	V_SP_RET_CODE PLS_INTEGER;
	V_CRUISE_NAME VARCHAR2(2000) := 'HI-20-09';
BEGIN

	--retrieve the PK ID of the specified cruise:
	SELECT CRUISE_ID INTO P_PK_ID FROM CCD_CRUISES WHERE UPPER(CRUISE_NAME) = UPPER(V_CRUISE_NAME);

	CCD_DVM_PKG.EXEC_DVM_CRUISE_SP(P_PK_ID);

	DBMS_output.put_line('The parent record ('||V_CRUISE_NAME||') was evaluated successfully');

	--commit the successful validation records
	COMMIT;

	EXCEPTION
		WHEN OTHERS THEN
			DBMS_output.put_line('The parent record ('||V_CRUISE_NAME||') was not evaluated successfully');

	--rollback;
END;
/




--execute for test data stream (HI-20-10):
DECLARE
	P_PK_ID NUMBER;
	V_SP_RET_CODE PLS_INTEGER;
	V_CRUISE_NAME VARCHAR2(2000) := 'HI-20-10';
BEGIN

	--retrieve the PK ID of the specified cruise:
	SELECT CRUISE_ID INTO P_PK_ID FROM CCD_CRUISES WHERE UPPER(CRUISE_NAME) = UPPER(V_CRUISE_NAME);

	CCD_DVM_PKG.EXEC_DVM_CRUISE_SP(P_PK_ID);

	DBMS_output.put_line('The parent record ('||V_CRUISE_NAME||') was evaluated successfully');

	--commit the successful validation records
	COMMIT;

	EXCEPTION
		WHEN OTHERS THEN

			DBMS_output.put_line('The parent record ('||V_CRUISE_NAME||') was not evaluated successfully');

	--rollback;
END;
/











--delete the cruise leg (HI-20-10 Leg 1):



DECLARE
	P_PK_ID NUMBER;
	V_SP_RET_CODE PLS_INTEGER;
	V_LEG_NAME VARCHAR2(2000) := 'HI-20-10 Leg 1';
BEGIN


	--retrieve the PK ID of the specified cruise:
	SELECT CRUISE_LEG_ID INTO P_PK_ID FROM CCD_CRUISE_LEGS WHERE UPPER(LEG_NAME) = UPPER(V_LEG_NAME);


  CEN_CRUISE.CCD_DVM_PKG.DELETE_LEG_OVERLAP_SP (P_PK_ID);

	DBMS_output.put_line('The Cruise Leg was deleted successfully');

	--commit the successful validation records
	COMMIT;

	EXCEPTION
		WHEN OTHERS THEN
			DBMS_output.put_line('The Cruise Leg was NOT deleted successfully');

	--rollback;
END;
/










--update the cruise leg date(s):

--Update Cruise Leg Case 1 (Overlap to different Overlap) Update the cruise to introduce a different vessel overlap error, run the custom PL/SQL to update the cruise leg and re-evaluate all overlap with the previous and modified cruise leg values.  Update SE-21-07 to change overlap from SE-21-06, SE-21-08 to SE-21-09:




--execute for test data stream (SE-21-06):
DECLARE
	P_PK_ID NUMBER;
	V_SP_RET_CODE PLS_INTEGER;
	V_CRUISE_NAME VARCHAR2(2000) := 'SE-21-06';
BEGIN

	--retrieve the PK ID of the specified cruise:
	SELECT CRUISE_ID INTO P_PK_ID FROM CCD_CRUISES WHERE UPPER(CRUISE_NAME) = UPPER(V_CRUISE_NAME);

	CCD_DVM_PKG.EXEC_DVM_CRUISE_SP(P_PK_ID);

	DBMS_output.put_line('The parent record ('||V_CRUISE_NAME||') was evaluated successfully');

	--commit the successful validation records
	COMMIT;

	EXCEPTION
		WHEN OTHERS THEN
			DBMS_output.put_line('The parent record ('||V_CRUISE_NAME||') was not evaluated successfully');

	--rollback;
END;
/




--execute for test data stream (SE-21-07):
DECLARE
	P_PK_ID NUMBER;
	V_SP_RET_CODE PLS_INTEGER;
	V_CRUISE_NAME VARCHAR2(2000) := 'SE-21-07';
BEGIN

	--retrieve the PK ID of the specified cruise:
	SELECT CRUISE_ID INTO P_PK_ID FROM CCD_CRUISES WHERE UPPER(CRUISE_NAME) = UPPER(V_CRUISE_NAME);

	CCD_DVM_PKG.EXEC_DVM_CRUISE_SP(P_PK_ID);

	DBMS_output.put_line('The parent record ('||V_CRUISE_NAME||') was evaluated successfully');

	--commit the successful validation records
	COMMIT;

	EXCEPTION
		WHEN OTHERS THEN
			DBMS_output.put_line('The parent record ('||V_CRUISE_NAME||') was not evaluated successfully');

	--rollback;
END;
/




--execute for test data stream (SE-21-08):
DECLARE
	P_PK_ID NUMBER;
	V_SP_RET_CODE PLS_INTEGER;
	V_CRUISE_NAME VARCHAR2(2000) := 'SE-21-08';
BEGIN

	--retrieve the PK ID of the specified cruise:
	SELECT CRUISE_ID INTO P_PK_ID FROM CCD_CRUISES WHERE UPPER(CRUISE_NAME) = UPPER(V_CRUISE_NAME);

	CCD_DVM_PKG.EXEC_DVM_CRUISE_SP(P_PK_ID);

	DBMS_output.put_line('The parent record ('||V_CRUISE_NAME||') was evaluated successfully');

	--commit the successful validation records
	COMMIT;

	EXCEPTION
		WHEN OTHERS THEN
			DBMS_output.put_line('The parent record ('||V_CRUISE_NAME||') was not evaluated successfully');

	--rollback;
END;
/





--execute for test data stream (SE-21-09):
DECLARE
	P_PK_ID NUMBER;
	V_SP_RET_CODE PLS_INTEGER;
	V_CRUISE_NAME VARCHAR2(2000) := 'SE-21-09';
BEGIN

	--retrieve the PK ID of the specified cruise:
	SELECT CRUISE_ID INTO P_PK_ID FROM CCD_CRUISES WHERE UPPER(CRUISE_NAME) = UPPER(V_CRUISE_NAME);

	CCD_DVM_PKG.EXEC_DVM_CRUISE_SP(P_PK_ID);

	DBMS_output.put_line('The parent record ('||V_CRUISE_NAME||') was evaluated successfully');

	--commit the successful validation records
	COMMIT;

	EXCEPTION
		WHEN OTHERS THEN
			DBMS_output.put_line('The parent record ('||V_CRUISE_NAME||') was not evaluated successfully');

	--rollback;
END;
/








--update the existing vessel overlaps to a different set of vessel overlaps
DECLARE

    V_OVERLAP_CRUISE_IDS apex_application_global.vc_arr2;

    V_PROC_RETURN_CODE PLS_INTEGER;

		V_LEG_NAME CCD_CRUISE_LEGS.LEG_NAME%TYPE := 'SE-21-07';

		--variable to store the cruise_leg_id:
		V_CRUISE_LEG_ID CCD_CRUISE_LEGS.CRUISE_LEG_ID%TYPE;

		--variable to store the cruise_leg_id:
		V_CRUISE_ID CCD_CRUISES.CRUISE_ID%TYPE;


		--variable to store the cruise name:
		V_CRUISE_NAME CCD_CRUISES.CRUISE_NAME%TYPE;

		--variable to store the result of the CEN_UTILS.CEN_UTIL_ARRAY_PKG.ARRAY_VAL_EXISTS_FN package function
    V_FOUND_CODE PLS_INTEGER;

		--variable to store the exception message for VALIDATE_PARENT_RECORD_RC_SP procedure calls:
		V_EXC_MSG VARCHAR2(4000);

BEGIN

    dbms_output.put_line ('Update the Cruise Leg ('||V_LEG_NAME||') to one set of overlaps to another one');

		--query for the cruise and cruise leg information based on V_LEG_NAME value:
		SELECT CRUISE_ID, CRUISE_LEG_ID, CRUISE_NAME INTO V_CRUISE_ID, V_CRUISE_LEG_ID, V_CRUISE_NAME  FROM CCD_CRUISE_LEGS_V WHERE LEG_NAME = V_LEG_NAME;

    --query for any leg/vessel overlap for the specified cruise (do not revalidate the same cruise if there is an overlap with another associated cruise leg since the initial execution will identify those validation issues)
    FOR rec IN (SELECT DISTINCT CRUISE_ID FROM CEN_CRUISE.CCD_QC_LEG_OVERLAP_V WHERE CRUISE_ID2 = V_CRUISE_ID AND CRUISE_ID <> V_CRUISE_ID)

    --loop through each CRUISE_ID returned by the SELECT query so these overlapping cruise IDs can be re-evaluated by the DVM after the cruise leg is updated:
    LOOP
        V_OVERLAP_CRUISE_IDS(V_OVERLAP_CRUISE_IDS.COUNT + 1) :=  rec.CRUISE_ID;

    END LOOP;

    dbms_output.put_line ('The current value of V_OVERLAP_CRUISE_IDS is: '||APEX_UTIL.table_to_string(V_OVERLAP_CRUISE_IDS, ','));






		--update the leg dates for the current cruise leg from one set of overlaps to another one:
		UPDATE CCD_CRUISE_LEGS SET LEG_START_DATE = TO_DATE('20-MAY-21', 'DD-MON-YY'), LEG_END_DATE = TO_DATE('16-JUN-21', 'DD-MON-YY') WHERE CRUISE_LEG_ID = V_CRUISE_LEG_ID;




    --query for any leg/vessel overlap for the specified cruise (do not revalidate the same cruise if there is an overlap with another associated cruise leg since the initial execution will identify those validation issues)
    FOR rec IN (SELECT DISTINCT CRUISE_ID FROM CEN_CRUISE.CCD_QC_LEG_OVERLAP_V WHERE CRUISE_ID2 = V_CRUISE_ID AND CRUISE_ID <> V_CRUISE_ID)

    --loop through each CRUISE_ID returned by the SELECT query so these overlapping cruise IDs can be re-evaluated by the DVM after the cruise leg is updated:
    LOOP

        dbms_output.put_line ('The current value of rec.CRUISE_ID is: '||rec.CRUISE_ID);


        --determine if the current cruise ID has already been identified as overlapping before the update, if so then do not add it to the array:
        V_FOUND_CODE := CEN_UTILS.CEN_UTIL_ARRAY_PKG.ARRAY_VAL_EXISTS_FN (V_OVERLAP_CRUISE_IDS, TO_CHAR(rec.CRUISE_ID));

        --check if the array element was found
        IF (V_FOUND_CODE = 0) THEN
            --the current CRUISE_ID value was not found in the array, add it to the array:

            V_OVERLAP_CRUISE_IDS(V_OVERLAP_CRUISE_IDS.COUNT + 1) :=  rec.CRUISE_ID;

        ELSIF (V_FOUND_CODE IS NULL) THEN
            --there was a processing error for the array:
            dbms_output.put_line ('The array could not be searched successfully for the current cruise ID value');

            --raise a custom exception:
            RAISE_APPLICATION_ERROR (-20402, 'The array could not be searched successfully for the current cruise ID value');

        END IF;


    END LOOP;



    --loop through the overlapping cruise IDs and re-evaluate them:
    for i in 1..V_OVERLAP_CRUISE_IDS.count
    loop
        dbms_output.put_line ('Run the DVM on the CRUISE_ID: '||V_OVERLAP_CRUISE_IDS(i));

        --execute the DVM on the current cruise:
        CEN_CRUISE.CCD_DVM_PKG.EXEC_DVM_CRUISE_RC_SP (TO_NUMBER(V_OVERLAP_CRUISE_IDS(i)), V_PROC_RETURN_CODE, V_EXC_MSG);

        IF (V_PROC_RETURN_CODE = 1) THEN
            dbms_output.put_line ('The DVM was successfully executed');

        ELSE
            dbms_output.put_line ('The DVM was NOT successfully executed');

            --raise a custom exception:
            RAISE_APPLICATION_ERROR (-20502, 'The Cruise (CRUISE_ID: '||V_OVERLAP_CRUISE_IDS(i)||') was not processed by the DVM successfully:'||chr(10)||V_EXC_MSG);
        END IF;

    end loop;


    --execute the DVM on the specified cruise:
    CEN_CRUISE.CCD_DVM_PKG.EXEC_DVM_CRUISE_RC_SP (V_CRUISE_ID, V_PROC_RETURN_CODE, V_EXC_MSG);

    IF (V_PROC_RETURN_CODE = 1) THEN
        dbms_output.put_line ('The DVM was successfully executed');

    ELSE
        dbms_output.put_line ('The DVM was NOT successfully executed');

        --raise a custom exception:
        RAISE_APPLICATION_ERROR (-20502, 'The Cruise (CRUISE_ID: '||V_CRUISE_ID||', CRUISE_NAME: '||V_CRUISE_NAME||') was not processed by the DVM successfully:'||chr(10)||V_EXC_MSG);
    END IF;


END;
/





--update the cruise leg date(s):

--Update Cruise Leg Case 2 (non-overlap to overlap) Update the cruise to resolve the vessel overlap error, run the PL/SQL to update the cruise leg and re-evaluate the new overlapping cruise.  Update SE-19-05 Leg 1 to change overlap from none to SE-19-04 Leg 1 and SE-19-04 Leg 2:




--execute for test data stream (SE-19-04):
DECLARE
	P_PK_ID NUMBER;
	V_SP_RET_CODE PLS_INTEGER;
	V_CRUISE_NAME VARCHAR2(2000) := 'SE-19-04';
BEGIN

	--retrieve the PK ID of the specified cruise:
	SELECT CRUISE_ID INTO P_PK_ID FROM CCD_CRUISES WHERE UPPER(CRUISE_NAME) = UPPER(V_CRUISE_NAME);

	CCD_DVM_PKG.EXEC_DVM_CRUISE_SP(P_PK_ID);

	IF (V_SP_RET_CODE = 1) then
		DBMS_output.put_line('The parent record ('||V_CRUISE_NAME||') was evaluated successfully');

		--commit the successful validation records
		COMMIT;
	ELSE
		DBMS_output.put_line('The parent record ('||V_CRUISE_NAME||') was not evaluated successfully');

	END IF;

	--rollback;
END;
/





--execute for test data stream (SE-19-05):
DECLARE
	P_PK_ID NUMBER;
	V_SP_RET_CODE PLS_INTEGER;
	V_CRUISE_NAME VARCHAR2(2000) := 'SE-19-05';
BEGIN

	--retrieve the PK ID of the specified cruise:
	SELECT CRUISE_ID INTO P_PK_ID FROM CCD_CRUISES WHERE UPPER(CRUISE_NAME) = UPPER(V_CRUISE_NAME);

	CCD_DVM_PKG.EXEC_DVM_CRUISE_SP(P_PK_ID);

	IF (V_SP_RET_CODE = 1) then
		DBMS_output.put_line('The parent record ('||V_CRUISE_NAME||') was evaluated successfully');

		--commit the successful validation records
		COMMIT;
	ELSE
		DBMS_output.put_line('The parent record ('||V_CRUISE_NAME||') was not evaluated successfully');

	END IF;

	--rollback;
END;
/


--update the non vessel overlap to a vessel overlap with two cruise legs
DECLARE

    V_OVERLAP_CRUISE_IDS apex_application_global.vc_arr2;

    V_PROC_RETURN_CODE PLS_INTEGER;

		V_LEG_NAME CCD_CRUISE_LEGS.LEG_NAME%TYPE := 'SE-19-05 Leg 1';

		--variable to store the cruise_leg_id:
		V_CRUISE_LEG_ID CCD_CRUISE_LEGS.CRUISE_LEG_ID%TYPE;

		--variable to store the cruise_leg_id:
		V_CRUISE_ID CCD_CRUISES.CRUISE_ID%TYPE;


		--variable to store the cruise name:
		V_CRUISE_NAME CCD_CRUISES.CRUISE_NAME%TYPE;

		--variable to store the result of the CEN_UTILS.CEN_UTIL_ARRAY_PKG.ARRAY_VAL_EXISTS_FN package function
    V_FOUND_CODE PLS_INTEGER;

		--variable to store the exception message for VALIDATE_PARENT_RECORD_RC_SP procedure calls:
		V_EXC_MSG VARCHAR2(4000);

BEGIN

    dbms_output.put_line ('Update the Cruise Leg ('||V_LEG_NAME||') to one set of overlaps to another one');

		--query for the cruise and cruise leg information based on V_LEG_NAME value:
		SELECT CRUISE_ID, CRUISE_LEG_ID, CRUISE_NAME INTO V_CRUISE_ID, V_CRUISE_LEG_ID, V_CRUISE_NAME  FROM CCD_CRUISE_LEGS_V WHERE LEG_NAME = V_LEG_NAME;

    --query for any leg/vessel overlap for the specified cruise (do not revalidate the same cruise if there is an overlap with another associated cruise leg since the initial execution will identify those validation issues)
    FOR rec IN (SELECT DISTINCT CRUISE_ID FROM CEN_CRUISE.CCD_QC_LEG_OVERLAP_V WHERE CRUISE_ID2 = V_CRUISE_ID AND CRUISE_ID <> V_CRUISE_ID)

    --loop through each CRUISE_ID returned by the SELECT query so these overlapping cruise IDs can be re-evaluated by the DVM after the cruise leg is updated:
    LOOP
        V_OVERLAP_CRUISE_IDS(V_OVERLAP_CRUISE_IDS.COUNT + 1) :=  rec.CRUISE_ID;

    END LOOP;

    dbms_output.put_line ('The current value of V_OVERLAP_CRUISE_IDS is: '||APEX_UTIL.table_to_string(V_OVERLAP_CRUISE_IDS, ','));






		--update the leg dates for the current cruise leg from one set of overlaps to another one:
		UPDATE CCD_CRUISE_LEGS SET LEG_START_DATE = TO_DATE('14-JUN-19', 'DD-MON-YY'), LEG_END_DATE = TO_DATE('20-JUL-19', 'DD-MON-YY') WHERE CRUISE_LEG_ID = V_CRUISE_LEG_ID;




    --query for any leg/vessel overlap for the specified cruise (do not revalidate the same cruise if there is an overlap with another associated cruise leg since the initial execution will identify those validation issues)
    FOR rec IN (SELECT DISTINCT CRUISE_ID FROM CEN_CRUISE.CCD_QC_LEG_OVERLAP_V WHERE CRUISE_ID2 = V_CRUISE_ID AND CRUISE_ID <> V_CRUISE_ID)

    --loop through each CRUISE_ID returned by the SELECT query so these overlapping cruise IDs can be re-evaluated by the DVM after the cruise leg is updated:
    LOOP

        dbms_output.put_line ('The current value of rec.CRUISE_ID is: '||rec.CRUISE_ID);


        --determine if the current cruise ID has already been identified as overlapping before the update, if so then do not add it to the array:
        V_FOUND_CODE := CEN_UTILS.CEN_UTIL_ARRAY_PKG.ARRAY_VAL_EXISTS_FN (V_OVERLAP_CRUISE_IDS, TO_CHAR(rec.CRUISE_ID));

        --check if the array element was found
        IF (V_FOUND_CODE = 0) THEN
            --the current CRUISE_ID value was not found in the array, add it to the array:

            V_OVERLAP_CRUISE_IDS(V_OVERLAP_CRUISE_IDS.COUNT + 1) :=  rec.CRUISE_ID;

        ELSIF (V_FOUND_CODE IS NULL) THEN
            --there was a processing error for the array:
            dbms_output.put_line ('The array could not be searched successfully for the current cruise ID value');

            --raise a custom exception:
            RAISE_APPLICATION_ERROR (-20402, 'The array could not be searched successfully for the current cruise ID value');

        END IF;


    END LOOP;



    --loop through the overlapping cruise IDs and re-evaluate them:
    for i in 1..V_OVERLAP_CRUISE_IDS.count
    loop
        dbms_output.put_line ('Run the DVM on the CRUISE_ID: '||V_OVERLAP_CRUISE_IDS(i));

        --execute the DVM on the current cruise:
        CEN_CRUISE.CCD_DVM_PKG.EXEC_DVM_CRUISE_RC_SP (TO_NUMBER(V_OVERLAP_CRUISE_IDS(i)), V_PROC_RETURN_CODE, V_EXC_MSG);

        IF (V_PROC_RETURN_CODE = 1) THEN
            dbms_output.put_line ('The DVM was successfully executed');

        ELSE
            dbms_output.put_line ('The DVM was NOT successfully executed');

            --raise a custom exception:
            RAISE_APPLICATION_ERROR (-20502, 'The Cruise (CRUISE_ID: '||V_OVERLAP_CRUISE_IDS(i)||') was not processed by the DVM successfully:'||chr(10)||V_EXC_MSG);
        END IF;

    end loop;


    --execute the DVM on the specified cruise:
    CEN_CRUISE.CCD_DVM_PKG.EXEC_DVM_CRUISE_RC_SP (V_CRUISE_ID, V_PROC_RETURN_CODE, V_EXC_MSG);

    IF (V_PROC_RETURN_CODE = 1) THEN
        dbms_output.put_line ('The DVM was successfully executed');

    ELSE
        dbms_output.put_line ('The DVM was NOT successfully executed');

        --raise a custom exception:
        RAISE_APPLICATION_ERROR (-20502, 'The Cruise (CRUISE_ID: '||V_CRUISE_ID||', CRUISE_NAME: '||V_CRUISE_NAME||') was not processed by the DVM successfully:'||chr(10)||V_EXC_MSG);
    END IF;


END;
/







--update the cruise leg date(s):

--Update Cruise Leg Case 3 (overlap to no overlap) Update the cruise to resolve the vessel overlap error, run the PL/SQL to update the cruise leg and re-evaluate the previous overlapping cruise.  Update HI-19-02 Leg 1 to change overlap from HI-19-01 Leg 2 to none:



--execute for test data stream (HI-19-01):
DECLARE
	P_PK_ID NUMBER;
	V_SP_RET_CODE PLS_INTEGER;
	V_CRUISE_NAME VARCHAR2(2000) := 'HI-19-01';
BEGIN

	--retrieve the PK ID of the specified cruise:
	SELECT CRUISE_ID INTO P_PK_ID FROM CCD_CRUISES WHERE UPPER(CRUISE_NAME) = UPPER(V_CRUISE_NAME);

	CCD_DVM_PKG.EXEC_DVM_CRUISE_SP(P_PK_ID);

	IF (V_SP_RET_CODE = 1) then
		DBMS_output.put_line('The parent record ('||V_CRUISE_NAME||') was evaluated successfully');

		--commit the successful validation records
		COMMIT;
	ELSE
		DBMS_output.put_line('The parent record ('||V_CRUISE_NAME||') was not evaluated successfully');

	END IF;

	--rollback;
END;
/





--execute for test data stream (HI-19-02):
DECLARE
	P_PK_ID NUMBER;
	V_SP_RET_CODE PLS_INTEGER;
	V_CRUISE_NAME VARCHAR2(2000) := 'HI-19-02';
BEGIN

	--retrieve the PK ID of the specified cruise:
	SELECT CRUISE_ID INTO P_PK_ID FROM CCD_CRUISES WHERE UPPER(CRUISE_NAME) = UPPER(V_CRUISE_NAME);

	CCD_DVM_PKG.EXEC_DVM_CRUISE_SP(P_PK_ID);

	IF (V_SP_RET_CODE = 1) then
		DBMS_output.put_line('The parent record ('||V_CRUISE_NAME||') was evaluated successfully');

		--commit the successful validation records
		COMMIT;
	ELSE
		DBMS_output.put_line('The parent record ('||V_CRUISE_NAME||') was not evaluated successfully');

	END IF;

	--rollback;
END;
/


--update the existing vessel overlaps to a state where overlap has been removed
DECLARE

    V_OVERLAP_CRUISE_IDS apex_application_global.vc_arr2;

    V_PROC_RETURN_CODE PLS_INTEGER;

		V_LEG_NAME CCD_CRUISE_LEGS.LEG_NAME%TYPE := 'HI-19-02 Leg 1';

		--variable to store the cruise_leg_id:
		V_CRUISE_LEG_ID CCD_CRUISE_LEGS.CRUISE_LEG_ID%TYPE;

		--variable to store the cruise_leg_id:
		V_CRUISE_ID CCD_CRUISES.CRUISE_ID%TYPE;


		--variable to store the cruise name:
		V_CRUISE_NAME CCD_CRUISES.CRUISE_NAME%TYPE;

		--variable to store the result of the CEN_UTILS.CEN_UTIL_ARRAY_PKG.ARRAY_VAL_EXISTS_FN package function
    V_FOUND_CODE PLS_INTEGER;

		--variable to store the exception message for VALIDATE_PARENT_RECORD_RC_SP procedure calls:
		V_EXC_MSG VARCHAR2(4000);

BEGIN

    dbms_output.put_line ('Update the Cruise Leg ('||V_LEG_NAME||') to one set of overlaps to another one');

		--query for the cruise and cruise leg information based on V_LEG_NAME value:
		SELECT CRUISE_ID, CRUISE_LEG_ID, CRUISE_NAME INTO V_CRUISE_ID, V_CRUISE_LEG_ID, V_CRUISE_NAME  FROM CCD_CRUISE_LEGS_V WHERE LEG_NAME = V_LEG_NAME;

    --query for any leg/vessel overlap for the specified cruise (do not revalidate the same cruise if there is an overlap with another associated cruise leg since the initial execution will identify those validation issues)
    FOR rec IN (SELECT DISTINCT CRUISE_ID FROM CEN_CRUISE.CCD_QC_LEG_OVERLAP_V WHERE CRUISE_ID2 = V_CRUISE_ID AND CRUISE_ID <> V_CRUISE_ID)

    --loop through each CRUISE_ID returned by the SELECT query so these overlapping cruise IDs can be re-evaluated by the DVM after the cruise leg is updated:
    LOOP
        V_OVERLAP_CRUISE_IDS(V_OVERLAP_CRUISE_IDS.COUNT + 1) :=  rec.CRUISE_ID;

    END LOOP;

    dbms_output.put_line ('The current value of V_OVERLAP_CRUISE_IDS is: '||APEX_UTIL.table_to_string(V_OVERLAP_CRUISE_IDS, ','));






		--update the leg dates for the current cruise leg from one set of overlaps to another one:
		UPDATE CCD_CRUISE_LEGS SET LEG_START_DATE = TO_DATE('01-DEC-18', 'DD-MON-YY'), LEG_END_DATE = TO_DATE('09-DEC-18', 'DD-MON-YY') WHERE CRUISE_LEG_ID = V_CRUISE_LEG_ID;




    --query for any leg/vessel overlap for the specified cruise (do not revalidate the same cruise if there is an overlap with another associated cruise leg since the initial execution will identify those validation issues)
    FOR rec IN (SELECT DISTINCT CRUISE_ID FROM CEN_CRUISE.CCD_QC_LEG_OVERLAP_V WHERE CRUISE_ID2 = V_CRUISE_ID AND CRUISE_ID <> V_CRUISE_ID)

    --loop through each CRUISE_ID returned by the SELECT query so these overlapping cruise IDs can be re-evaluated by the DVM after the cruise leg is updated:
    LOOP

        dbms_output.put_line ('The current value of rec.CRUISE_ID is: '||rec.CRUISE_ID);


        --determine if the current cruise ID has already been identified as overlapping before the update, if so then do not add it to the array:
        V_FOUND_CODE := CEN_UTILS.CEN_UTIL_ARRAY_PKG.ARRAY_VAL_EXISTS_FN (V_OVERLAP_CRUISE_IDS, TO_CHAR(rec.CRUISE_ID));

        --check if the array element was found
        IF (V_FOUND_CODE = 0) THEN
            --the current CRUISE_ID value was not found in the array, add it to the array:

            V_OVERLAP_CRUISE_IDS(V_OVERLAP_CRUISE_IDS.COUNT + 1) :=  rec.CRUISE_ID;

        ELSIF (V_FOUND_CODE IS NULL) THEN
            --there was a processing error for the array:
            dbms_output.put_line ('The array could not be searched successfully for the current cruise ID value');

            --raise a custom exception:
            RAISE_APPLICATION_ERROR (-20402, 'The array could not be searched successfully for the current cruise ID value');

        END IF;


    END LOOP;



    --loop through the overlapping cruise IDs and re-evaluate them:
    for i in 1..V_OVERLAP_CRUISE_IDS.count
    loop
        dbms_output.put_line ('Run the DVM on the CRUISE_ID: '||V_OVERLAP_CRUISE_IDS(i));

        --execute the DVM on the current cruise:
        CEN_CRUISE.CCD_DVM_PKG.EXEC_DVM_CRUISE_RC_SP (TO_NUMBER(V_OVERLAP_CRUISE_IDS(i)), V_PROC_RETURN_CODE, V_EXC_MSG);

        IF (V_PROC_RETURN_CODE = 1) THEN
            dbms_output.put_line ('The DVM was successfully executed');

        ELSE
            dbms_output.put_line ('The DVM was NOT successfully executed');

            --raise a custom exception:
            RAISE_APPLICATION_ERROR (-20502, 'The Cruise (CRUISE_ID: '||V_OVERLAP_CRUISE_IDS(i)||') was not processed by the DVM successfully:'||chr(10)||V_EXC_MSG);
        END IF;

    end loop;


    --execute the DVM on the specified cruise:
    CEN_CRUISE.CCD_DVM_PKG.EXEC_DVM_CRUISE_RC_SP (V_CRUISE_ID, V_PROC_RETURN_CODE, V_EXC_MSG);

    IF (V_PROC_RETURN_CODE = 1) THEN
        dbms_output.put_line ('The DVM was successfully executed');

    ELSE
        dbms_output.put_line ('The DVM was NOT successfully executed');

        --raise a custom exception:
        RAISE_APPLICATION_ERROR (-20502, 'The Cruise (CRUISE_ID: '||V_CRUISE_ID||', CRUISE_NAME: '||V_CRUISE_NAME||') was not processed by the DVM successfully:'||chr(10)||V_EXC_MSG);
    END IF;


END;
/














--update the cruise leg date(s):

--Update Cruise Leg Case 4 (overlap to same overlap) Update the cruise to maintain the vessel overlap error, run the PL/SQL to update the cruise leg and re-evaluate the existing overlapping records.  Update SE-22-02 Leg 1 to maintain same overlap with SE-22-01 Leg 2:



--execute for test data stream (SE-22-01):
DECLARE
	P_PK_ID NUMBER;
	V_SP_RET_CODE PLS_INTEGER;
	V_CRUISE_NAME VARCHAR2(2000) := 'SE-22-01';
BEGIN

	--retrieve the PK ID of the specified cruise:
	SELECT CRUISE_ID INTO P_PK_ID FROM CCD_CRUISES WHERE UPPER(CRUISE_NAME) = UPPER(V_CRUISE_NAME);

	CCD_DVM_PKG.EXEC_DVM_CRUISE_SP(P_PK_ID);

	DBMS_output.put_line('The parent record ('||V_CRUISE_NAME||') was evaluated successfully');

	--commit the successful validation records
	COMMIT;

	EXCEPTION
		WHEN OTHERS THEN
			DBMS_output.put_line('The parent record ('||V_CRUISE_NAME||') was not evaluated successfully');

	--rollback;
END;
/





--execute for test data stream (SE-22-02):
DECLARE
	P_PK_ID NUMBER;
	V_SP_RET_CODE PLS_INTEGER;
	V_CRUISE_NAME VARCHAR2(2000) := 'SE-22-02';
BEGIN

	--retrieve the PK ID of the specified cruise:
	SELECT CRUISE_ID INTO P_PK_ID FROM CCD_CRUISES WHERE UPPER(CRUISE_NAME) = UPPER(V_CRUISE_NAME);

	CCD_DVM_PKG.EXEC_DVM_CRUISE_SP(P_PK_ID);

	DBMS_output.put_line('The parent record ('||V_CRUISE_NAME||') was evaluated successfully');

	--commit the successful validation records
	COMMIT;

	EXCEPTION
		WHEN OTHERS THEN
			DBMS_output.put_line('The parent record ('||V_CRUISE_NAME||') was not evaluated successfully');

	--rollback;
END;
/


--update the non vessel overlap to a vessel overlap with two cruise legs
DECLARE

    V_OVERLAP_CRUISE_IDS apex_application_global.vc_arr2;

    V_PROC_RETURN_CODE PLS_INTEGER;

		V_LEG_NAME CCD_CRUISE_LEGS.LEG_NAME%TYPE := 'SE-22-02 Leg 1';

		--variable to store the cruise_leg_id:
		V_CRUISE_LEG_ID CCD_CRUISE_LEGS.CRUISE_LEG_ID%TYPE;

		--variable to store the cruise_leg_id:
		V_CRUISE_ID CCD_CRUISES.CRUISE_ID%TYPE;


		--variable to store the cruise name:
		V_CRUISE_NAME CCD_CRUISES.CRUISE_NAME%TYPE;

		--variable to store the result of the CEN_UTILS.CEN_UTIL_ARRAY_PKG.ARRAY_VAL_EXISTS_FN package function
    V_FOUND_CODE PLS_INTEGER;

		--variable to store the exception message for VALIDATE_PARENT_RECORD_RC_SP procedure calls:
		V_EXC_MSG VARCHAR2(4000);

BEGIN

    dbms_output.put_line ('Update the Cruise Leg ('||V_LEG_NAME||') to one set of overlaps to another one');

		--query for the cruise and cruise leg information based on V_LEG_NAME value:
		SELECT CRUISE_ID, CRUISE_LEG_ID, CRUISE_NAME INTO V_CRUISE_ID, V_CRUISE_LEG_ID, V_CRUISE_NAME  FROM CCD_CRUISE_LEGS_V WHERE LEG_NAME = V_LEG_NAME;

    --query for any leg/vessel overlap for the specified cruise (do not revalidate the same cruise if there is an overlap with another associated cruise leg since the initial execution will identify those validation issues)
    FOR rec IN (SELECT DISTINCT CRUISE_ID FROM CEN_CRUISE.CCD_QC_LEG_OVERLAP_V WHERE CRUISE_ID2 = V_CRUISE_ID AND CRUISE_ID <> V_CRUISE_ID)

    --loop through each CRUISE_ID returned by the SELECT query so these overlapping cruise IDs can be re-evaluated by the DVM after the cruise leg is updated:
    LOOP
        V_OVERLAP_CRUISE_IDS(V_OVERLAP_CRUISE_IDS.COUNT + 1) :=  rec.CRUISE_ID;

    END LOOP;

    dbms_output.put_line ('The current value of V_OVERLAP_CRUISE_IDS is: '||APEX_UTIL.table_to_string(V_OVERLAP_CRUISE_IDS, ','));






		--update the leg dates for the current cruise leg to maintain the overlap with the same cruise leg:
		UPDATE CCD_CRUISE_LEGS SET LEG_START_DATE = TO_DATE('01-DEC-21', 'DD-MON-YY'), LEG_END_DATE = TO_DATE('14-DEC-21', 'DD-MON-YY') WHERE CRUISE_LEG_ID = V_CRUISE_LEG_ID;




    --query for any leg/vessel overlap for the specified cruise (do not revalidate the same cruise if there is an overlap with another associated cruise leg since the initial execution will identify those validation issues)
    FOR rec IN (SELECT DISTINCT CRUISE_ID FROM CEN_CRUISE.CCD_QC_LEG_OVERLAP_V WHERE CRUISE_ID2 = V_CRUISE_ID AND CRUISE_ID <> V_CRUISE_ID)

    --loop through each CRUISE_ID returned by the SELECT query so these overlapping cruise IDs can be re-evaluated by the DVM after the cruise leg is updated:
    LOOP

        dbms_output.put_line ('The current value of rec.CRUISE_ID is: '||rec.CRUISE_ID);


        --determine if the current cruise ID has already been identified as overlapping before the update, if so then do not add it to the array:
        V_FOUND_CODE := CEN_UTILS.CEN_UTIL_ARRAY_PKG.ARRAY_VAL_EXISTS_FN (V_OVERLAP_CRUISE_IDS, TO_CHAR(rec.CRUISE_ID));

        --check if the array element was found
        IF (V_FOUND_CODE = 0) THEN
            --the current CRUISE_ID value was not found in the array, add it to the array:

            V_OVERLAP_CRUISE_IDS(V_OVERLAP_CRUISE_IDS.COUNT + 1) :=  rec.CRUISE_ID;

        ELSIF (V_FOUND_CODE IS NULL) THEN
            --there was a processing error for the array:
            dbms_output.put_line ('The array could not be searched successfully for the current cruise ID value');

            --raise a custom exception:
            RAISE_APPLICATION_ERROR (-20402, 'The array could not be searched successfully for the current cruise ID value');

        END IF;


    END LOOP;



    --loop through the overlapping cruise IDs and re-evaluate them:
    for i in 1..V_OVERLAP_CRUISE_IDS.count
    loop
        dbms_output.put_line ('Run the DVM on the CRUISE_ID: '||V_OVERLAP_CRUISE_IDS(i));

        --execute the DVM on the current cruise:
        CEN_CRUISE.CCD_DVM_PKG.EXEC_DVM_CRUISE_RC_SP (TO_NUMBER(V_OVERLAP_CRUISE_IDS(i)), V_PROC_RETURN_CODE, V_EXC_MSG);

        IF (V_PROC_RETURN_CODE = 1) THEN
            dbms_output.put_line ('The DVM was successfully executed');

        ELSE
            dbms_output.put_line ('The DVM was NOT successfully executed');

            --raise a custom exception:
            RAISE_APPLICATION_ERROR (-20502, 'The Cruise (CRUISE_ID: '||V_OVERLAP_CRUISE_IDS(i)||') was not processed by the DVM successfully:'||chr(10)||V_EXC_MSG);
        END IF;

    end loop;


    --execute the DVM on the specified cruise:
    CEN_CRUISE.CCD_DVM_PKG.EXEC_DVM_CRUISE_RC_SP (V_CRUISE_ID, V_PROC_RETURN_CODE, V_EXC_MSG);

    IF (V_PROC_RETURN_CODE = 1) THEN
        dbms_output.put_line ('The DVM was successfully executed');

    ELSE
        dbms_output.put_line ('The DVM was NOT successfully executed');

        --raise a custom exception:
        RAISE_APPLICATION_ERROR (-20502, 'The Cruise (CRUISE_ID: '||V_CRUISE_ID||', CRUISE_NAME: '||V_CRUISE_NAME||') was not processed by the DVM successfully:'||chr(10)||V_EXC_MSG);
    END IF;


END;
/
