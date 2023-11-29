
set serveroutput on;

--Insert Cruise Leg Case 1 (evaluate one record  - HA1007 (copy) - that has an overlap with another cruise), the overlapping cruise is automatically evaluated using the CCD_DVM_PKG.EXEC_DVM_CRUISE_OVERLAP_SP procedure:


--execute for test data stream (HA1007 (copy)):
DECLARE
	V_CRUISE_NAME VARCHAR2(2000) := 'HA1007 (copy)';
BEGIN

	CCD_DVM_PKG.EXEC_DVM_CRUISE_OVERLAP_SP(V_CRUISE_NAME);

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
	V_CRUISE_NAME VARCHAR2(2000) := 'HI1101';
BEGIN

	--retrieve the PK ID of the specified cruise:
	CCD_DVM_PKG.EXEC_DVM_CRUISE_OVERLAP_SP(V_CRUISE_NAME);

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
	V_CRUISE_NAME VARCHAR2(2000) := 'SE-15-01';
BEGIN


	CCD_DVM_PKG.EXEC_DVM_CRUISE_OVERLAP_SP(V_CRUISE_NAME);

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

--Delete Cruise Leg Case 1 (Overlap to no overlap) Vessel Leg Overlaps DVM records removed after using CCD_CRUISE_PKG.DEL_LEG_OVERLAP_SP procedure is executed on SE-20-05 Leg 1 to remove the overlap errors on SE-20-04:


--execute for test data stream (SE-20-04):
DECLARE
	V_CRUISE_NAME VARCHAR2(2000) := 'SE-20-04';
BEGIN

	CCD_DVM_PKG.EXEC_DVM_CRUISE_SP(V_CRUISE_NAME);

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
	V_CRUISE_NAME VARCHAR2(2000) := 'SE-20-05';
BEGIN

	CCD_DVM_PKG.EXEC_DVM_CRUISE_SP(V_CRUISE_NAME);

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
	V_LEG_NAME VARCHAR2(2000) := 'SE-20-05 Leg 1';
BEGIN

  CEN_CRUISE.CCD_DVM_PKG.DEL_LEG_OVERLAP_SP (V_LEG_NAME);

 	DBMS_output.put_line('The Cruise Leg was deleted successfully');

	--commit the successful validation records
	COMMIT;

	EXCEPTION
		WHEN OTHERS THEN

       DBMS_output.put_line('The Cruise Leg was NOT deleted successfully');


	--rollback;
END;
/





--Delete Cruise Leg Case 2 (Overlap with two cruises to no overlap) Vessel Leg Overlaps DVM records removed after using CCD_CRUISE_PKG.DEL_LEG_OVERLAP_SP procedure is executed on SE-21-03 to remove the overlap errors on SE-21-01 and SE-21-04:

--execute for test data stream (SE-21-01):
DECLARE
	V_CRUISE_NAME VARCHAR2(2000) := 'SE-21-01';
BEGIN

	CCD_DVM_PKG.EXEC_DVM_CRUISE_SP(V_CRUISE_NAME);

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
	V_CRUISE_NAME VARCHAR2(2000) := 'SE-21-03';
BEGIN

	CCD_DVM_PKG.EXEC_DVM_CRUISE_SP(V_CRUISE_NAME);

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
	V_CRUISE_NAME VARCHAR2(2000) := 'SE-21-04';
BEGIN

	CCD_DVM_PKG.EXEC_DVM_CRUISE_SP(V_CRUISE_NAME);

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
	V_LEG_NAME VARCHAR2(2000) := 'SE-21-03';
BEGIN


  CEN_CRUISE.CCD_DVM_PKG.DEL_LEG_OVERLAP_SP (V_LEG_NAME);

  DBMS_output.put_line('The Cruise Leg was deleted successfully');

	--commit the successful validation records
	COMMIT;

	EXCEPTION
		WHEN OTHERS THEN
			DBMS_output.put_line('The Cruise Leg was NOT deleted successfully');


	--rollback;
END;
/





--Delete Cruise Leg Case 3 (One cruise overlaps with two cruises, one overlap is resolved when removing an overlapping cruise leg) Run the CCD_CRUISE_PKG.DEL_LEG_OVERLAP_SP procedure.  Delete HI-21-08 Leg 1 removing the HI-21-08 Leg 1 overlap errors from HI-21-07 Leg 2:



--execute for test data stream (HI-21-06):
DECLARE
	V_CRUISE_NAME VARCHAR2(2000) := 'HI-21-06';
BEGIN

	CCD_DVM_PKG.EXEC_DVM_CRUISE_SP(V_CRUISE_NAME);

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
	V_CRUISE_NAME VARCHAR2(2000) := 'HI-21-07';
BEGIN

	CCD_DVM_PKG.EXEC_DVM_CRUISE_SP(V_CRUISE_NAME);

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
	V_CRUISE_NAME VARCHAR2(2000) := 'HI-21-08';
BEGIN

	CCD_DVM_PKG.EXEC_DVM_CRUISE_SP(V_CRUISE_NAME);

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
	V_LEG_NAME VARCHAR2(2000) := 'HI-21-08 Leg 1';
BEGIN


  CEN_CRUISE.CCD_DVM_PKG.DEL_LEG_OVERLAP_SP (V_LEG_NAME);

	DBMS_output.put_line('The Cruise Leg was deleted successfully');

	--commit the successful validation records
	COMMIT;

	EXCEPTION
		WHEN OTHERS THEN
			DBMS_output.put_line('The Cruise Leg was NOT deleted successfully');

	--rollback;
END;
/







--Delete Cruise Leg Case 4 (Three cruises overlap, remove one overlapping cruise leg) Run the CCD_CRUISE_PKG.DEL_LEG_OVERLAP_SP.  Delete HI-20-10 Leg 1 resolves overlapping errors with HI-20-10 Leg 1 for HI-20-08 Leg 1, HI-20-08 Leg 2, HI-20-09 Leg 1:



--execute for test data stream (HI-20-08):
DECLARE
	V_CRUISE_NAME VARCHAR2(2000) := 'HI-20-08';
BEGIN

	CCD_DVM_PKG.EXEC_DVM_CRUISE_SP(V_CRUISE_NAME);

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
	V_CRUISE_NAME VARCHAR2(2000) := 'HI-20-09';
BEGIN

	CCD_DVM_PKG.EXEC_DVM_CRUISE_SP(V_CRUISE_NAME);

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
	V_CRUISE_NAME VARCHAR2(2000) := 'HI-20-10';
BEGIN

	CCD_DVM_PKG.EXEC_DVM_CRUISE_SP(V_CRUISE_NAME);

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
	V_LEG_NAME VARCHAR2(2000) := 'HI-20-10 Leg 1';
BEGIN



  CEN_CRUISE.CCD_DVM_PKG.DEL_LEG_OVERLAP_SP (V_LEG_NAME);

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
	V_CRUISE_NAME VARCHAR2(2000) := 'SE-21-06';
BEGIN

	CCD_DVM_PKG.EXEC_DVM_CRUISE_SP(V_CRUISE_NAME);

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
	V_CRUISE_NAME VARCHAR2(2000) := 'SE-21-07';
BEGIN

	CCD_DVM_PKG.EXEC_DVM_CRUISE_SP(V_CRUISE_NAME);

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
	V_CRUISE_NAME VARCHAR2(2000) := 'SE-21-08';
BEGIN

	CCD_DVM_PKG.EXEC_DVM_CRUISE_SP(V_CRUISE_NAME);

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
	V_CRUISE_NAME VARCHAR2(2000) := 'SE-21-09';
BEGIN

	CCD_DVM_PKG.EXEC_DVM_CRUISE_SP(V_CRUISE_NAME);

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
		V_LEG_NAME CCD_CRUISE_LEGS.LEG_NAME%TYPE := 'SE-21-07';

		--variable to store the cruise_leg_id:
		V_CRUISE_LEG_ID CCD_CRUISE_LEGS.CRUISE_LEG_ID%TYPE;


		--variable to store the cruise name:
		V_CRUISE_NAME CCD_CRUISES.CRUISE_NAME%TYPE;


BEGIN

    dbms_output.put_line ('Update the Cruise Leg ('||V_LEG_NAME||') from one set of overlaps to another one');

		--query for the cruise and cruise leg information based on V_LEG_NAME value:
		SELECT CRUISE_LEG_ID, CRUISE_NAME INTO V_CRUISE_LEG_ID, V_CRUISE_NAME  FROM CCD_CRUISE_LEG_V WHERE LEG_NAME = V_LEG_NAME;


		--run the pre leg update procedure to identify any existing overlapping cruises:
		CCD_DVM_PKG.PRE_UPDATE_LEG_SP (V_CRUISE_NAME);



		--update the leg dates for the current cruise leg from one set of overlaps to another one:
		UPDATE CCD_CRUISE_LEGS SET LEG_START_DATE = TO_DATE('20-MAY-21', 'DD-MON-YY'), LEG_END_DATE = TO_DATE('16-JUN-21', 'DD-MON-YY') WHERE CRUISE_LEG_ID = V_CRUISE_LEG_ID;


		--run the post leg update procedure to identify any new overlapping cruises and execute the DVM on the updated cruise leg's cruise and any previous/new overlapping cruises:
		CCD_DVM_PKG.POST_UPDATE_LEG_SP (V_CRUISE_NAME);

 		dbms_output.put_line ('The Update Leg procedure was successful');

		EXCEPTION
			WHEN OTHERS THEN
    		dbms_output.put_line ('The Update Leg procedure was NOT successful');
				dbms_output.put_line (SQLERRM);

END;
/





--update the cruise leg date(s):

--Update Cruise Leg Case 2 (non-overlap to overlap) Update the cruise to resolve the vessel overlap error, run the PL/SQL to update the cruise leg and re-evaluate the new overlapping cruise.  Update SE-19-05 Leg 1 to change overlap from none to SE-19-04 Leg 1 and SE-19-04 Leg 2:




--execute for test data stream (SE-19-04):
DECLARE
	V_CRUISE_NAME VARCHAR2(2000) := 'SE-19-04';
BEGIN

	CCD_DVM_PKG.EXEC_DVM_CRUISE_SP(V_CRUISE_NAME);

	DBMS_output.put_line('The parent record ('||V_CRUISE_NAME||') was evaluated successfully');

	--commit the successful validation records
	COMMIT;

	EXCEPTION
		WHEN OTHERS THEN
			DBMS_output.put_line('The parent record ('||V_CRUISE_NAME||') was not evaluated successfully');


	--rollback;
END;
/





--execute for test data stream (SE-19-05):
DECLARE
	V_CRUISE_NAME VARCHAR2(2000) := 'SE-19-05';
BEGIN

	CCD_DVM_PKG.EXEC_DVM_CRUISE_SP(V_CRUISE_NAME);

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

		V_LEG_NAME CCD_CRUISE_LEGS.LEG_NAME%TYPE := 'SE-19-05 Leg 1';

		--variable to store the cruise_leg_id:
		V_CRUISE_LEG_ID CCD_CRUISE_LEGS.CRUISE_LEG_ID%TYPE;



		--variable to store the cruise name:
		V_CRUISE_NAME CCD_CRUISES.CRUISE_NAME%TYPE;


BEGIN

    dbms_output.put_line ('Update the Cruise Leg ('||V_LEG_NAME||') non vessel overlap to a vessel overlap with two cruise legs');

		--query for the cruise and cruise leg information based on V_LEG_NAME value:
		SELECT CRUISE_LEG_ID, CRUISE_NAME INTO V_CRUISE_LEG_ID, V_CRUISE_NAME  FROM CCD_CRUISE_LEG_V WHERE LEG_NAME = V_LEG_NAME;



		--run the pre leg update procedure to identify any existing overlapping cruises:
		CCD_DVM_PKG.PRE_UPDATE_LEG_SP (V_CRUISE_NAME);



		--update the leg dates from a non vessel overlap to a vessel overlap with two cruise legs:
		UPDATE CCD_CRUISE_LEGS SET LEG_START_DATE = TO_DATE('14-JUN-19', 'DD-MON-YY'), LEG_END_DATE = TO_DATE('20-JUL-19', 'DD-MON-YY') WHERE CRUISE_LEG_ID = V_CRUISE_LEG_ID;


		--run the post leg update procedure to identify any new overlapping cruises and execute the DVM on the updated cruise leg's cruise and any previous/new overlapping cruises:
		CCD_DVM_PKG.POST_UPDATE_LEG_SP (V_CRUISE_NAME);

 		dbms_output.put_line ('The Update Leg procedure was successful');

		EXCEPTION
			WHEN OTHERS THEN
    		dbms_output.put_line ('The Update Leg procedure was NOT successful');
				dbms_output.put_line (SQLERRM);

END;
/







--update the cruise leg date(s):

--Update Cruise Leg Case 3 (overlap to no overlap) Update the cruise to resolve the vessel overlap error, run the PL/SQL to update the cruise leg and re-evaluate the previous overlapping cruise.  Update HI-19-02 Leg 1 to change overlap from HI-19-01 Leg 2 to none:



--execute for test data stream (HI-19-01):
DECLARE
	V_CRUISE_NAME VARCHAR2(2000) := 'HI-19-01';
BEGIN

	CCD_DVM_PKG.EXEC_DVM_CRUISE_SP(V_CRUISE_NAME);

	DBMS_output.put_line('The parent record ('||V_CRUISE_NAME||') was evaluated successfully');

	--commit the successful validation records
	COMMIT;

	EXCEPTION
		WHEN OTHERS THEN
			DBMS_output.put_line('The parent record ('||V_CRUISE_NAME||') was not evaluated successfully');



	--rollback;
END;
/





--execute for test data stream (HI-19-02):
DECLARE
	V_CRUISE_NAME VARCHAR2(2000) := 'HI-19-02';
BEGIN


	CCD_DVM_PKG.EXEC_DVM_CRUISE_SP(V_CRUISE_NAME);

	DBMS_output.put_line('The parent record ('||V_CRUISE_NAME||') was evaluated successfully');

	--commit the successful validation records
	COMMIT;

	EXCEPTION
		WHEN OTHERS THEN
			DBMS_output.put_line('The parent record ('||V_CRUISE_NAME||') was not evaluated successfully');


END;
/






--update the existing vessel overlaps to a state where overlap has been removed
DECLARE

		V_LEG_NAME CCD_CRUISE_LEGS.LEG_NAME%TYPE := 'HI-19-02 Leg 1';

		--variable to store the cruise_leg_id:
		V_CRUISE_LEG_ID CCD_CRUISE_LEGS.CRUISE_LEG_ID%TYPE;


		--variable to store the cruise name:
		V_CRUISE_NAME CCD_CRUISES.CRUISE_NAME%TYPE;


BEGIN

    dbms_output.put_line ('Update the Cruise Leg ('||V_LEG_NAME||') existing vessel overlaps to a state where overlap has been removed');

		--query for the cruise and cruise leg information based on V_LEG_NAME value:
		SELECT CRUISE_LEG_ID, CRUISE_NAME INTO V_CRUISE_LEG_ID, V_CRUISE_NAME  FROM CCD_CRUISE_LEG_V WHERE LEG_NAME = V_LEG_NAME;



		--run the pre leg update procedure to identify any existing overlapping cruises:
		CCD_DVM_PKG.PRE_UPDATE_LEG_SP (V_CRUISE_NAME);



		--update the leg dates existing vessel overlaps to a state where overlap has been removed:
		UPDATE CCD_CRUISE_LEGS SET LEG_START_DATE = TO_DATE('01-DEC-18', 'DD-MON-YY'), LEG_END_DATE = TO_DATE('09-DEC-18', 'DD-MON-YY') WHERE CRUISE_LEG_ID = V_CRUISE_LEG_ID;


		--run the post leg update procedure to identify any new overlapping cruises and execute the DVM on the updated cruise leg's cruise and any previous/new overlapping cruises:
		CCD_DVM_PKG.POST_UPDATE_LEG_SP (V_CRUISE_NAME);

 		dbms_output.put_line ('The Update Leg procedure was successful');

		EXCEPTION
			WHEN OTHERS THEN
    		dbms_output.put_line ('The Update Leg procedure was NOT successful');
				dbms_output.put_line (SQLERRM);

END;
/














--update the cruise leg date(s):

--Update Cruise Leg Case 4 (overlap to same overlap) Update the cruise to maintain the vessel overlap error, run the PL/SQL to update the cruise leg and re-evaluate the existing overlapping records.  Update SE-22-02 Leg 1 to maintain same overlap with SE-22-01 Leg 2:



--execute for test data stream (SE-22-01):
DECLARE
	V_CRUISE_NAME VARCHAR2(2000) := 'SE-22-01';
BEGIN


	CCD_DVM_PKG.EXEC_DVM_CRUISE_SP(V_CRUISE_NAME);

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
	V_CRUISE_NAME VARCHAR2(2000) := 'SE-22-02';
BEGIN

	CCD_DVM_PKG.EXEC_DVM_CRUISE_SP(V_CRUISE_NAME);

	DBMS_output.put_line('The parent record ('||V_CRUISE_NAME||') was evaluated successfully');

	--commit the successful validation records
	COMMIT;

	EXCEPTION
		WHEN OTHERS THEN
			DBMS_output.put_line('The parent record ('||V_CRUISE_NAME||') was not evaluated successfully');

	--rollback;
END;
/


--Update the cruise to maintain the vessel overlap error, run the PL/SQL to update the cruise leg and re-evaluate the existing overlapping records
DECLARE

		V_LEG_NAME CCD_CRUISE_LEGS.LEG_NAME%TYPE := 'SE-22-02 Leg 1';

		--variable to store the cruise_leg_id:
		V_CRUISE_LEG_ID CCD_CRUISE_LEGS.CRUISE_LEG_ID%TYPE;


		--variable to store the cruise name:
		V_CRUISE_NAME CCD_CRUISES.CRUISE_NAME%TYPE;


BEGIN

    dbms_output.put_line ('Update the Cruise Leg ('||V_LEG_NAME||') existing vessel overlaps to a state where overlap has been removed');

		--query for the cruise and cruise leg information based on V_LEG_NAME value:
		SELECT CRUISE_LEG_ID, CRUISE_NAME INTO V_CRUISE_LEG_ID, V_CRUISE_NAME  FROM CCD_CRUISE_LEG_V WHERE LEG_NAME = V_LEG_NAME;



		--run the pre leg update procedure to identify any existing overlapping cruises:
		CCD_DVM_PKG.PRE_UPDATE_LEG_SP (V_CRUISE_NAME);



		--update the leg dates for the current cruise leg to maintain the overlap with the same cruise leg:
		UPDATE CCD_CRUISE_LEGS SET LEG_START_DATE = TO_DATE('01-DEC-21', 'DD-MON-YY'), LEG_END_DATE = TO_DATE('14-DEC-21', 'DD-MON-YY') WHERE CRUISE_LEG_ID = V_CRUISE_LEG_ID;


		--run the post leg update procedure to identify any new overlapping cruises and execute the DVM on the updated cruise leg's cruise and any previous/new overlapping cruises:
		CCD_DVM_PKG.POST_UPDATE_LEG_SP (V_CRUISE_NAME);

 		dbms_output.put_line ('The Update Leg procedure was successful');

		EXCEPTION
			WHEN OTHERS THEN
    		dbms_output.put_line ('The Update Leg procedure was NOT successful');
				dbms_output.put_line (SQLERRM);

END;
/


--Delete Cruise Case 1 (DVM issues and records exist) Delete the Cruise and all associated DVM records.


--Run DVM on OES0509

--execute for test data stream (OES0509):
DECLARE
	V_CRUISE_NAME VARCHAR2(2000) := 'OES0509';
BEGIN


	CCD_DVM_PKG.EXEC_DVM_CRUISE_SP(V_CRUISE_NAME);

	DBMS_output.put_line('The parent record ('||V_CRUISE_NAME||') was evaluated successfully');

	--commit the successful validation records
	COMMIT;

	EXCEPTION
		WHEN OTHERS THEN
			DBMS_output.put_line('The parent record ('||V_CRUISE_NAME||') was not evaluated successfully');

	--rollback;
END;
/


--Exceute Delete Cruise SP on OES0509 and confirm there are no DVM records associated with it afterwards:
DECLARE

		V_CRUISE_NAME CCD_CRUISES.CRUISE_NAME%TYPE := 'OES0509';

BEGIN

    dbms_output.put_line ('Delete the Cruise ('||V_CRUISE_NAME||') and all associated DVM records');


		--run the pre leg update procedure to identify any existing overlapping cruises:
		CCD_DVM_PKG.DEL_CRUISE_SP (V_CRUISE_NAME);


 		dbms_output.put_line ('The Delete Cruise procedure was successful');

		EXCEPTION
			WHEN OTHERS THEN
    		dbms_output.put_line ('The Delete Cruise procedure was NOT successful');
				dbms_output.put_line (SQLERRM);

END;
/



--Delete Cruise Case 2 (no DVM records exist) Delete the Cruise with no associated DVM records.

--Exceute Delete Cruise SP on TC0009 (copy) and confirm there are no DVM records associated with it afterwards:

DECLARE

		V_CRUISE_NAME CCD_CRUISES.CRUISE_NAME%TYPE := 'TC0009 (copy)';

BEGIN

    dbms_output.put_line ('Delete the Cruise ('||V_CRUISE_NAME||') and all associated DVM records');


		--run the pre leg update procedure to identify any existing overlapping cruises:
		CCD_DVM_PKG.DEL_CRUISE_SP (V_CRUISE_NAME);


 		dbms_output.put_line ('The Delete Cruise procedure was successful');

		EXCEPTION
			WHEN OTHERS THEN
    		dbms_output.put_line ('The Delete Cruise procedure was NOT successful');
				dbms_output.put_line (SQLERRM);

END;
/
